
#INCLUDE "TOTVS.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"
#include "PRTOPDEF.CH"

#DEFINE ENTER Chr(13)+Chr(10)

User Function ORCNETPDV(cIDPDV)

	Local aItem	:= {}
	Local nVlOrc:= 0
	Local cRecnos:= "'"
	Local cLocMov   := "  "
	Local nItem:= 1
	Local cCodVend  := "  "
	Local cCPF:= " "
	Local cCodCli:= " "
	Local cLojCli:=  " "


	Default cIDPDV	:= ""
	Private lLogado  := Type('cEmpAnt') == 'C'

	IF !lLogado
		RPCSetType(3)
		PREPARE ENVIRONMENT EMPRESA "20" FILIAL "01" MODULO "LOJA"
	ENDIF

	cLocMov   := ALLTRIM(SuperGetMV("ES_LOCNETP"))
	cCodVend  := SuperGetMv("TF4_VENPDV",.F.,"000001")
	cEvento	 := SuperGetMv("ES_EVTNETP",.F.,"11254") 

	cQuery := "SELECT ZZX_DATA,ZZX_CODCLI,ZZX_LOJCLI, ZZX_CPF , ZZX_EMAIL, ZZX_PRODUT , "
	cQuery += " SUM(ZZX_QUANT) QUANT, SUM(ZZX_TOTAL)/SUM(ZZX_QUANT) VUNIT, SUM(ZZX_TOTAL) TOTAL,
	cQuery += " LISTAGG(R_E_C_N_O_ , ',') WITHIN GROUP (ORDER BY R_E_C_N_O_) RECNO "
	cQuery += " FROM "+ retsqlname("ZZX")
	cQuery += " WHERE D_E_L_E_T_ <> '*' AND ZZX_INTEGR = 'S' "
	cQuery += "	AND ZZX_IDEVEN = '"+cEvento+"' "
	IF !EMPTY(cIDPDV)
		cQuery += "		AND ZZX_IDPDV = '"+cIDPDV+"' "
		cQuery += "	AND (ZZX_STATUS = '1' or ZZX_STATUS = '3') "
	ELSE
		cQuery += "	AND ZZX_STATUS = '1' "
	ENDIF
	cQuery += "	AND ZZX_IDPDV NOT IN "
	cQuery += " (SELECT ZZX_IDPDV FROM "+RetSqlName("ZZX")+" WHERE D_E_L_E_T_ <> '*' AND ZZX_STATUS = '0') "
	cQuery += "	GROUP BY ZZX_DATA,ZZX_CPF , ZZX_EMAIL,ZZX_CODCLI,ZZX_LOJCLI, ZZX_PRODUT "
	cAliasCPF := MPSysOpenQuery(ChangeQuery(cQuery))

	IF (cAliasCPF)->(!EOF())
		cCPFOld:= (cAliasCPF)->ZZX_CPF

		While !(cAliasCPF)->(Eof())

			IF EMPTY((cAliasCPF)->ZZX_CODCLI)
				(cAliasCPF)->(DBSKIP())
				loop
			ENDIF

			IF cCPFOld != (cAliasCPF)->ZZX_CPF

				cCPFOld:=(cAliasCPF)->ZZX_CPF

				IF len(aItem) > 0

					cRecnos:= REPLACE(cRecnos,",","','")
					cRecnos:= LEFT(cRecnos,len(cRecnos)-2)
					geraOrc(cCodCli,cLojCli,cCPF,dDataVenda,nVlOrc,aItem,cRecnos,cCodVend)
		
					aItem:= {}
					nItem:= 1
					nVlOrc:= 0
					cRecnos:= "'"
				ENDIF
			ENDIF

			dDataVenda:=STOD((cAliasCPF)->ZZX_DATA)
			cCPF:= (cAliasCPF)->ZZX_CPF
			cCodCli:= (cAliasCPF)->ZZX_CODCLI
			cLojCli:=  (cAliasCPF)->ZZX_LOJCLI

			DbSelectArea("SB1")
			DBsetOrder(1)
			dbgotop()
			IF dbseek(xFilial("SB1")+(cAliasCPF)->ZZX_PRODUT)

				cClasFis := Lj7RetClasFis(SB1->B1_COD,SB1->B1_TS)
				aAdd(aItem,{{"LR_PRODUTO",(cAliasCPF)->ZZX_PRODUT,NIL},;
					{"LR_ITEM"   ,StrZero(nItem,2) 		,NIL},;
					{"LR_QUANT"  ,(cAliasCPF)->QUANT   ,NIL},;
					{"LR_VRUNIT" ,(cAliasCPF)->VUNIT   ,NIL},;
					{"LR_VLRITEM",(cAliasCPF)->TOTAL   ,NIL},;
					{"LR_UM"     ,SB1->B1_UM    		,NIL},;
					{"LR_LOCAL"  ,cLocMov				,NIL},;
					{"LR_DESCRI" ,SB1->B1_DESC  		,NIL},;
					{"LR_CLASFIS",cClasFis,				NIL},;
					{"LR_DESC"   ,0             ,NIL},;
					{"LR_EMISSAO",dDataBase     ,NIL},;
					{"LR_VALDESC",0             ,NIL},;
					{"LR_TABELA" ,"2"           ,NIL},;
					{"LR_DESCPRO",0             ,NIL},;
					{"LR_TES"    ,SB1->B1_TS    ,NIL},;
					{"LR_VEND"   ,cCodVend      ,NIL}})

				nVlOrc+=(cAliasCPF)->TOTAL
				cRecnos += ALLTRIM((cAliasCPF)->RECNO) + ","
			

				dbSelectArea("SB0")
				dbSetOrder(1)
				If dbSeek(xFilial("SB0")+SB1->B1_COD)
					RecLock("SB0",.F.)
					SB0->B0_PRV2  := (cAliasCPF)->VUNIT
					SB0->(MsUnlock())
				Else
					RecLock("SB0",.T.)
					SB0->B0_FILIAL:= xFilial("SB0")
					SB0->B0_COD   := SB1->B1_COD
					SB0->B0_PRV2  := (cAliasCPF)->VUNIT
					SB0->(MsUnlock())
				EndIf
				SB0->(dbCloseArea())
				SB1->(dbCloseArea())
			ELSE
				(cAliasCPF)->(DbSkip())
				Loop
			ENDIF
			SB1->(DBCLOSEAREA())

			nItem++
			(cAliasCPF)->(DbSkip())
		End
	
		cRecnos:= REPLACE(cRecnos,",","','")
		cRecnos:= LEFT(cRecnos,len(cRecnos)-2)
		geraOrc(cCodCli,cLojCli,cCPF,dDataVenda,nVlOrc,aItem,cRecnos,cCodVend)
	ELSEIF !EMPTY(cIDPDV)
		FWAlertError("Há outros itens do mesmo IDPDV que ainda não podem ser processados","Operação não Permitida!")
		(cAliasCPF)->(dbclosearea())
		Return .F.
	ENDIF
	(cAliasCPF)->(dbclosearea())
	
	IF !lLogado
		RESET ENVIRONMENT
	ENDIF
Return .T.


Static Function geraOrc(cCodCli,cLojaCli,cCPF,dDataVenda,nVlOrc,aItem,cRecnos,cCodVend)


Local cTipCli	:= "F"
Local cMenNota	:= "ZZX"
Local cPDV		:= ""
Local aLoja701	:= {}
Local aPayment	:= {}
Local cStatus	:= ""
Local cOrcamento := '      '
Local cNota   	:= ' '
Local cNumero 	:= '         '

Private INCLUI      := .T. //Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
Private ALTERA      := .F. //Variavel necessária para o ExecAuto identificar que se trata de uma alteração

Private lMsErroAuto 	:= .F.
Private lMsHelpAuto 	:= .T.
Private lAutoErrNoFile  := .T. //<= para nao gerar arquivo e pegar o erro com a funcao GETAUTOGRLOG()
Private cSerie          := "2"

	aAdd(aLoja701,{"LQ_VEND"   ,cCodVend    ,NIL})
	aAdd(aLoja701,{"LQ_COMIS"  ,0           ,NIL})
	aAdd(aLoja701,{"LQ_CLIENTE",cCodCli 	,NIL})
	aAdd(aLoja701,{"LQ_LOJA"   ,cLojaCli	,NIL})
	aAdd(aLoja701,{"LQ_TIPOCLI",cTipCli     ,NIL})
	aAdd(aLoja701,{"LQ_DTLIM"  ,Date()      ,NIL})
	aAdd(aLoja701,{"LQ_EMISSAO",Date()      ,NIL})
	aadd(aLoja701,{"LQ_MENNOTA",cMenNota    ,Nil})
	aAdd(aLoja701,{"LQ_OPERADO","237"       ,NIL})
	aAdd(aLoja701,{"LQ_ESTACAO","001"       ,NIL})
	aAdd(aLoja701,{"LQ_CGCCLI",cCPF     	,NIL})
	aAdd(aLoja701,{"LQ_PDV"   , cPDV        , NIL} )

	//Monta o cabeçalho do orçamento (aPagtos)
	aAdd(aPayment,{{"L4_DATA"    ,dDataVenda,NIL},;
		{"L4_VALOR"  ,nVlOrc,NIL},;
		{"L4_FORMA"  ,"R$ "  ,NIL},;
		{"L4_ADMINIS"," "    ,NIL},;
		{"L4_FORMAID"," "    ,NIL},;
		{"L4_MOEDA"  ,0      ,NIL}})

	//======================================= Executa Loja701
	lUseSAT := LjGetStation("LG_USESAT")

	lMsErroAuto := .F.

	begin transaction

		SetFunName("LOJA701")
		MsExecAuto({|a,b,c,d,e,f,g,h| LOJA701(a,b,c,d,e,f,g,h)},.F.,3,"","",{},aLoja701,aItem,aPayment)

		If !lMsErroAuto
			cStatus:= '2'
			cMsg := "Gerado Orcamento"
			cOrcamento := SL1->L1_NUM

			cNota   := NxtSX5Nota(cSerie,,"1",.T.)
			cNumero := PadR(StrZero(Val(cNota),Len(cNota)),TamSx3("F1_DOC")[1])

			If !Empty(cNumero)
				lRet := .T.
				If RecLock("SL1",.F.)
					SL1->L1_DOC	    :=	cNumero
					SL1->L1_SERIE	:=	cSerie
					SL1->L1_TIPO	:=	"V"
					SL1->L1_SITUA	:=	"RX"
					SL1->L1_ESTACAO :=  "1"
					SL1->L1_OPERADO :=  "237"
					SL1->L1_TROCO1  :=  0
					SL1->L1_ESPECIE :=  "NFCE"
					SL1->L1_CGCCLI	:=  cCPF
					SL1->(MsUnlock())
				EndIf

				DbSelectArea("SL2")
				DbSetOrder(1)
				DBGOTOP( )
				dbseek(xFilial("SL2")+cOrcamento)
				While (SL2->(!EOF()) .and. SL2->L2_NUM == cOrcamento)
					RecLock("SL2", .F.)
						SL2->L2_DOC		    := cNumero
						SL2->L2_SERIE       := cSerie
					SL1->(MsUnlock())
					SL2->(dbskip())
				END

			ENDIF
		else
			MostraErro("\log_NETPDV", cCPF+".txt")
			cStatus:= '3' //erro na geracao orcamento
			cNumero		:= '         '
			cMsg := "Erro Geração Orcamento"
			cOrcamento	:= '      '
		ENDIF

		lRet:= U_grvStZZX(cStatus,cRecnos,cOrcamento,cNumero,cMsg,"ROTINA GERACAO ORCAMENTO")
		IF !lRet
			DisarmTransaction()
		ENDIF

	end transaction

Return


User Function grvStZZX(cStatus,cRecnos,cOrcamento,cNumero,cMsg,cHist,lExc,dDataNF,cStatOld)

Local lRet:= .F.
Local cHistor:= ""
Default lExc:= .F.
Default cRecnos:=""
Default cStatOld:=""

cEvento	 := SuperGetMv("ES_EVTNETP",.F.,"11254") 
CliPad := SuperGetMV("MV_CLIPAD")      // Cliente Padrao
LojPad:= SuperGetMV("MV_LOJAPAD")     // Loja Padrao

IF !EMPTY(cStatus)
	cQryStat:= " UPDATE "+retsqlname("ZZX")+" SET ZZX_STATUS='"+cStatus+"' "
	
	IF cStatus == "6"
		//SE NFCE TRANSMITIDA, GRAVA DATA DE GERAÇÃO NF PARA CONTROLE DE FINALIZAÇÃO
		cQryStat+= " , ZZX_DTINTE = '" + dDataNF + "' "
	ENDIF

	IF !EMPTY(cRecnos)
		IF !EMPTY(cOrcamento) .or. lExc
			cQryStat+= " , ZZX_ORC = '"+cOrcamento +"' "
		ENDIF
		IF !EMPTY(cNumero) .or. lExc
			cQryStat+= " , ZZX_DOC = '"+cNumero +"' "
		ENDIF
		IF !EMPTY(cMsg)
			cMsg:= replace(cMsg,"'","")
			cQryStat+= " , ZZX_MSG = '"+cMsg +"' "
		ENDIF
		IF !EMPTY(cHist)
			cHistor:= U_HISNETPDV(cHist)
			cQryStat+= " , ZZX_HISTOR = RAWTOHEX('"+cHistor + ENTER + " ' || LTRIM(RTRIM(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZZX_HISTOR, 2000, 1)) ))) "
		ENDIF	

		cQryStat+= " WHERE R_E_C_N_O_ IN ( "
		cQryStat+= cRecnos + " )"


		If (TcSqlExec(cQryStat) >= 0)
			lRet := .T.
		EndIf
	ELSE 
		//ATUALIZA PELO NRO DOC
		IF !empty(cOrcamento) .AND. !Empty(cNumero)
			IF !EMPTY(cMsg)
				cMsg:= replace(cMsg,"'","")
				cQryStat+= " , ZZX_MSG = '"+cMsg +"' "
				
				IF !EMPTY(cHist)
					cHistor:= U_HISNETPDV(cHist)
					cQryStat+= " , ZZX_HISTOR = RAWTOHEX('"+cHistor + ENTER + " ' || LTRIM(RTRIM(UTL_RAW.CAST_TO_VARCHAR2(dbms_lob.substr(ZZX_HISTOR, 2000, 1)) ))) "
				ENDIF

				IF !EMPTY(cStatOld)
					cQryStat+= " , ZZX_CODCLI = '"+CliPad+"', ZZX_LOJCLI = '"+LojPad+"' "
				ENDIF

				cQryStat+= " WHERE D_E_L_E_T_ <> '*' "
				cQryStat+= " AND ZZX_IDEVEN = '"+cEvento+"' "
				cQryStat+= " AND ZZX_DOC = '"+cNumero+"' "
				cQryStat+= " AND ZZX_ORC = '"+cOrcamento+"' "

				If (TcSqlExec(cQryStat) >= 0)
					lRet := .T.
				EndIf	
			ENDIF
			
			
		ENDIF

	ENDIF
	
ENDIF


RETURN lRet
