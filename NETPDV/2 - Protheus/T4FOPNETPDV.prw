#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

#DEFINE ENTER Chr(13)+Chr(10)

//-------------------------------------------------------------------
/*/{Protheus.doc} T4FOPNETPDV
@Description Fun√ß√£o para realizar a inclus√£o e apontamento de OPs
@type User Function
@author  Alessandra Costa
@version    1.00
@since      23/06/2022
/*/
//-------------------------------------------------------------------


User Function T4FOPNETPDV()

Local lEnd		:= .F.
Local oGrid	 	:= Nil
Local cTitulo	 := "IntegraÁ„o NetPDV x Protheus"
Local cDescricao := "Gera as Ordens de ProduÁ„o dos registros com venda confirmada."
cDescricao += "Considerando as NFCEs autorizadas de produtos que possuem estrutura cadastrada."

Private lRet      := .F.

	oGrid := FWGridProcess():New("T4FOPNETPDV",cTitulo,cDescricao,{|lEnd| geraOPZZX(oGrid)},/*cPergunta*/,/*cGrid*/,/*lSaveLog*/)
	oGrid:SetMeters(1)
	oGrid:Activate()
	If oGrid:IsFinished()
		FWAlertSuccess("Processamento finalizado com sucesso!", "Sucesso!")
	Else
		FWAlertError("Erro ao realizar Processamento!","Error!")
	EndIf
	oGrid:DeActivate()
	FwFreeObj(oGrid)

RETURN


Static Function geraOPZZX(oGrid)

Local cNumOP		:= ""
Local cObsOP		:= ""
Local lApont    :=.F.
Local lCriaOp   := .F.
Local cNSIOP		:= ""
Local dDataOP		:= CToD("  /  /    ")
Local cRecnos:= "'"


    cLocMov   := ALLTRIM(SuperGetMV("ES_LOCNETP"))
	cEvento	 := SuperGetMv("ES_EVTNETP",.F.,"11254") 

	cQuery := " SELECT ZZX_DTINTE DATAINT,ZZX_PRODUT PRODUT, sum(ZZX_QUANT) QUANT,"
	cQuery += " LISTAGG(R_E_C_N_O_ , ',') WITHIN GROUP (ORDER BY R_E_C_N_O_) RECNO "
	cQuery += " FROM "+retsqlname("ZZX")+" ZZX "
	cQuery += " WHERE ZZX.D_E_L_E_T_ <> '*' "
	cQuery += "	AND ZZX.ZZX_IDEVEN = '"+cEvento+"' "
	cQuery += " AND ZZX_STATUS = '6' "
	cQuery += " AND ZZX_GERAOP = 'S' AND ZZX_INTEGR = 'S'"
	cQuery += " AND ZZX_OP = ' ' "
	cQuery += " GROUP BY ZZX_DTINTE,ZZX_PRODUT "
	TCQuery cQuery New Alias "ZZXOP"

	ZZXOP->(DbGoTop())
	If ZZXOP->(!Eof())
		While ZZXOP->( !Eof() )
			IF EMPTY(ZZXOP->DATAINT)
				ZZXOP->(DBSKIP())
				Loop
			ENDIF
			
			dDataOP := STOD(ZZXOP->DATAINT)

			oGrid:SetIncMeter(1,"Gerando OP DIA: "+DTOC(dDataOP) + " | PRODUTO: "+ ALLTRIM(ZZXOP->PRODUT) )
            
			lApont:=.F.
            lCriaOp:= .F.
			cNumOP		:= ""
			cObsOP		:= ""
			cNSIOP		:= ""
            cRecnos:= "'"

			begin transaction
			If CriaOP(AllTrim(ZZXOP->PRODUT),ZZXOP->QUANT,cLocMov,@cNumOP,@cObsOP,@cNSIOP,dDataOP)
				IF AlteraEmp(cNSIOP,cLocMov)  
					If ApontaOP(cNSIOP,cLocMov,dDataOP)
						lApont:= .T.   

					ENDIF
				ENDIF
				
				IF !lApont
					DisarmTransaction()
					FWAlertError("Erro no apontamento da OP.","ERRO!")
				ELSE
					cRecnos += ALLTRIM(ZZXOP->RECNO) + ","
            
					//monta historico
					cHistor:= U_HISNETPDV("ROTINA GERA«√O OP")
					
					//arruma recnos
					cRecnos:= REPLACE(cRecnos,",","','")
					cRecnos:= LEFT(cRecnos,len(cRecnos)-2)
					
					//atualiza zzx com nro da OP
					cQryStat:= " UPDATE "+retsqlname("ZZX")+" SET ZZX_OP='"+cNumOP+"' "
					cQryStat+= " , ZZX_HISTOR = RAWTOHEX('"+cHistor + ENTER + " ' || LTRIM(RTRIM(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZZX_HISTOR, 2000, 1)) ))) "
					cQryStat+= " WHERE R_E_C_N_O_ IN ( "
					cQryStat+= cRecnos + " )"
				
					If (TcSqlExec(cQryStat) < 0) //se erro na atualizaÁ„o da query
						DisarmTransaction()
					EndIf
				ENDIF
				
	   		ELSE
				DisarmTransaction()
				FWAlertError("Erro na geraÁ„o da OP.","ERRO!")
		
            ENDIF
			end transaction
			ZZXOP->(dbSkip())
		END
		
	else
		FWAlertError("N„o h· registros a serem gerados.","ERRO!")
		lRet:= .F.
	ENDIF
	ZZXOP->(DBCLOSEAREA())

//RESET ENVIRONMENT
Return lRet

Static Function CriaOP(cProd,nQtd,cLocMov,cNumOP,cObsOP,cNSIOP,dDataOP)

	Local nOpc    := 3 			//  3 - Inclusao || 4 - Alteracao || 5 - Exclusao
	Local aCabc   := {}
	Local lRet		:= .F.
	Private lMsErroAuto := .F.

	aCabc  := { ;
		{'C2_FILIAL'    , xFilial("SC2")  ,NIL},;
		{'C2_ITEM'      , "01"                      ,".T."},;
		{'C2_SEQUEN'    , "001"                     ,".T."},;
		{'C2_PRODUTO'   , cProd                     ,NIL},;
		{"C2_QUANT"     , nQtd                      ,NIL},;
		{"C2_STATUS"    , 'N'                       ,NIL},;
		{"C2_LOCAL"     , cLocMov					,NIL},;
		{"C2_CC"        , ''                        ,NIL},;
		{"C2_PRIOR"     , '500'                     ,NIL},;
		{"C2_DATPRI"    , dDataOP	                ,NIL},;
		{"C2_DATPRF"    , ddatabase	                ,NIL},;
		{"C2_EMISSAO"   , dDataOP	                ,NIL},;
		{'AUTEXPLODE'   , "S"                       ,NIL};
	}

	msExecAuto({|x,Y| Mata650(x,Y)},aCabc,nOpc)

	If !lMsErroAuto
		lRet	:= .T.
	EndIf

	cNumOP  := SC2->C2_NUM
	cObsOP  := ""
	cNSIOP	:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN

Return lRet

Static Function AlteraEmp(cNumOp,cLocMov)

	Local nX         := 0
	Local aCab       := {}
	Local aLine      := {}
	Local aItens     := {}
	Local lRet			:= .F.
	
	PRIVATE lMsErroAuto := .F.
	
	aCab := {{"D4_OP",cNumOp,NIL},;
				{"INDEX",2,Nil}}

	//Busca os empenhos da SD4 para alterar/excluir.
	SD4->(dbSetOrder(2))
	SD4->(dbSeek(xFilial("SD4")+PadR(cNumOp,Len(SD4->D4_OP))))

	While SD4->(!Eof()) .And. SD4->(D4_FILIAL+D4_OP) == xFilial("SD4")+PadR(cNumOp,Len(SD4->D4_OP))

		aLine := {}

		For nX := 1 To SD4->(FCount())
			IF SD4->(Field(nX)) == "D4_LOCAL"
				aAdd(aLine,{SD4->(Field(nX)),cLocMov,Nil})
			ELSE
            	aAdd(aLine,{SD4->(Field(nX)),SD4->(FieldGet(nX)),Nil})
			ENDIF
        Next nX
		
		//Adiciona o identificador LINPOS para identificar que o registro j· existe na SD4
        //aAdd(aLine,{"LINPOS","D4_COD+D4_TRT+D4_LOTECTL+D4_NUMLOTE+D4_LOCAL+D4_OPORIG+D4_SEQ",;
		aAdd(aLine,{"LINPOS","D4_COD+D4_TRT+D4_LOTECTL+D4_NUMLOTE+D4_LOCAL+D4_OPORIG+D4_SEQ",;
                            SD4->D4_COD,;
                            SD4->D4_TRT,;
                            SD4->D4_LOTECTL,;
                            SD4->D4_NUMLOTE,;
                            SD4->D4_LOCAL,;
                            SD4->D4_OPORIG,;
                            SD4->D4_SEQ})
		/*
		aAdd(aLine,{"D4_OP",SD4->D4_OP,Nil})
		aAdd(aLine,{"D4_COD",SD4->D4_COD,Nil})
		aAdd(aLine,{"D4_LOCAL",cLocMov,Nil})
		aAdd(aLine,{"D4_QTDEORI",SD4->D4_QTDEORI,Nil})
		aAdd(aLine,{"D4_QUANT",SD4->D4_QUANT,Nil})
		aAdd(aLine,{"D4_TRT",SD4->D4_TRT,Nil})
		*/

		aAdd(aItens,aLine)
		SD4->(dbSkip())
		
	END
	
	MSExecAuto({|x,y,z| mata381(x,y,z)},aCab,aItens,4)
	If !lMsErroAuto
		//Se ocorrer erro.
		lRet:= .T.
	EndIf

RETURN lRet

Static Function ApontaOP(cNumOp,cLocMov,dDataOP)

	Local aVetor  := {}
	Local nOpc    := 3 //-Op√ß√£o de execu√ß√£o da rotina, informado nos parametros quais as op√ß√µes possiveisl
	Local lRet	:= .F.

	Private lMsErroAuto := .F.

	aVetor :=	{;
		{"D3_OP" 		,cNumOp			,NIL},;
		{"D3_FILIAL"	,xFilial("SD3") ,NIL},;
		;//{"D3_QUANT"     ,cQuant   			,NIL},;
		{"D3_LOCAL"		,cLocMov 		,NIL},;
		{"D3_EMISSAO"	,dDataOP 		,NIL},;
		{"D3_TM"    	,"001"    		,NIL}}

	MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

	If !lMsErroAuto
		lRet	:= .T.
	EndIf

Return lRet
