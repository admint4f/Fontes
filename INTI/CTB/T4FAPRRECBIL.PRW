#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE 'FWMVCDEF.CH'

//////////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} T4FAPRRECBIL
Função que gera lançamento contábil de apropriação de bilheteria com base no 
calendário de eventos e notas geradas. **
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	28/03/2022												
	@param......:	aParamEmp, array, dados da empresa e filial para 		
					processamento			

/*/////////////////////////////////////////////////////////////////////////////

User Function T4FAPRRECBIL()

	Local cDataIni	 := ' '
	Local cDataFim 	:= ' '
	Local cEpep		:= ' '

	Private oSay
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.
	Private aParamBox	:= {}
	Private aRet		:= {}

	aAdd(aParamBox,{1,"Data Inicial Evento"	,DDATABASE           		,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"Data Final Evento"	,DDATABASE           		,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"EPEP-Evento"			,SPAC(TamSX3("CTD_ITEM")[1]),"","","CTD","",80,.F.})  //01

	If !ParamBox(aParamBox, "Apropriação Receita Eventos", aRet)
		Return Nil
	Else
		cDataIni:= DTOS(aRet[1])
		cDataFim:= DTOS(aRet[2])
		cEpep	:= aRet[3]
	End If

	FwMsgRun(NIL,{ |oSay| T4FMarkBrowse(cDataIni,cDataFim,cEpep,oSay) }, "Consultando tabelas envolvidas" ,'SELECIONANDO REGISTROS, AGUARDE.......')

Return


//////////////////////////////////////////////////////////////////////////////
/*/{Protheus.doc} SELDADOS
description
@type function
@version  
@author roger
@since 26/07/2021
@param dDtIni, date, param_description
@param dDtFim, date, param_description
@return variant, return_description
/*/////////////////////////////////////////////////////////////////////////////

Static Function T4FMarkBrowse(cDataIni,cDataFim,cEpep,oSay)

	Local 	_aCores		:= {}
	Local 	cCadastro	:='APROPRIAÇÃO RECEITA BILHETERIA'
	Local 	oDlg
	Local 	cQry		:= ""
	Local 	aObjects	:= {}
	Local 	aInfo		:= {}
	Local 	aPosObj		:= {}
	Local 	cFontUti  	:= "Tahoma"
	Local 	oFontSubN2	:= TFont():New(cFontUti,,-15,,.T.)
	Local 	lInverte 	:= .F.
	Local 	aSize 		:= MsAdvSize(.T.)
	Local 	aButEnc		:= {}
	Local 	aCpoCTB		:= {}
	Local 	aCpoBrw		:= {}

	Private	cMarca 		:= GetMark()
	Private	cAliasCTB	:= GetNextAlias()
	Private	cAliasTMP	:= GetNextAlias()
	Private nVlrTot		:= 0
	Private oVlrTot		:= 0
	Private cOrdem      := " "
//	Private aOrdem      := {"Datas"}
	Private cFiltro     := SPACE(200)

	AAdd( aObjects, { 100 , 100, .T., .T. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	Aadd(aButEnc, {"APROPRIACAO", {|| INTILEG() 		}, "Legenda"})
	Aadd(aButEnc, {"APROPRIACAO", {|| U_T4APRODET(cDataIni,cDataFim,cEpep)}, "Detalhamento Apropr."})

	
	cQry:= " SELECT SUBSTR(ZAD_DTEVEN,1,4)||SUBSTR(ZAD_DTEVEN,6,2)||SUBSTR(ZAD_DTEVEN,9,2) DT, ZAJ_HORA,ZAE_CTBREC, ZAE_CTBPIS, ZAE_CTBCOF, ZAJ_DTCTB , " + CRLF
	cQry+= " ZAE_EPEP , ZAE_EVENTO, ZAE_CC, D2_CONTA, SUM(D2_VALBRUT-D2_VALDEV) TOTAL, ZAJ_ITEM, ZAJ_CODIGO, SUM(D2_VALIMP6) VALPIS ,SUM(D2_VALIMP5) VALCOFINS, ZAJ.R_E_C_N_O_ RECNOZAJ " + CRLF
	cQry+= " FROM "+ RetSqlName('ZAE') + ' ZAE, ' + RetSqlName('SC6') + ' SC6, '  + CRLF
	cQry+= " " + RetSqlName('SD2')+ ' SD2, ' + RetSqlName('SF2') + ' SF2, ' + RetSqlName('ZAD') + ' ZAD, ' +RetSqlName('ZAJ') + ' ZAJ ' + CRLF
	cQry+= " WHERE SUBSTR(ZAD_DTEVEN,1,4)||SUBSTR(ZAD_DTEVEN,6,2)||SUBSTR(ZAD_DTEVEN,9,2) BETWEEN '"+cDataIni+"' AND '"+cDataFim+"' " + CRLF
	cQry+= " AND ZAJ_EPEP = ZAD_EPEP" 	+ CRLF
	cQry+= " AND ZAJ_ITEM > ' '" 		+ CRLF
	cQry+= " AND ZAJ_DATA = SUBSTR(ZAD_DTEVEN,1,4)||SUBSTR(ZAD_DTEVEN,6,2)||SUBSTR(ZAD_DTEVEN,9,2) " + CRLF
	cQry+= " AND ZAJ_HORA = SUBSTR(ZAD_DTEVEN,12,5)	" + CRLF
	cQry+= " AND ZAJ_CANC <> '1' "+ CRLF
	cQry+= " AND ZAJ_CODIGO > ' '"+ CRLF
	cQry+= " AND ZAE_EPEP = ZAD.ZAD_EPEP 	" + CRLF

	oSay:SetText("Obtendo dados necessrios para apropriao, aguarde.")
	ProcessMessage() // FORA O DESCONGELAMENTO DO SMARTCLIENT

	If !Empty(cEpep)
		cQry+= " AND ZAE_EPEP 		= '"+cEpep+"'" + CRLF
	EndIf

	cQry+= " AND ZAE_MSBLQL 	<> '1' 			" + CRLF
	
	cQry+= " AND ZAD_DTVEND 	> ' '			" + CRLF
	cQry+= " AND ZAD_ITEMID 	> ' '			" + CRLF
	cQry+= " AND ZAD_STATUS 	= '3'			" + CRLF
	cQry+= " AND ZAD_TPTRAN 	='1'			" + CRLF
	cQry+= " AND ZAD_SETOTV 	= 'I  '			" + CRLF
	cQry+= " AND ZAD_NFTOTV 	= C6_NOTA 		" + CRLF
	cQry+= " AND ZAD_SETOTV 	= C6_SERIE 		" + CRLF
	cQry+= " AND ZAD_TPITEM 	= C6_PEDCLI		" + CRLF
	cQry+= " AND ZAD_TKTID 		= C6_CHASSI		" + CRLF
	
	cQry+= " AND C6_NOTA 		= D2_DOC		" + CRLF
	cQry+= " AND C6_SERIE 		= D2_SERIE		" + CRLF
	cQry+= " AND C6_ITEM 		= D2_ITEMPV		" + CRLF
	cQry+= " AND D2_DOC 		= F2_DOC		" + CRLF
	cQry+= " AND D2_SERIE 		= F2_SERIE		" + CRLF
	cQry+= " AND D2_CLIENTE 	= F2_CLIENTE	" + CRLF
	cQry+= " AND F2_DTLANC 		<> ' '			" + CRLF
	cQry+= " AND ZAE.D_E_L_E_T_ = ' ' 			" + CRLF
	cQry+= " AND ZAD.D_E_L_E_T_ = ' '			" + CRLF
	cQry+= " AND SC6.D_E_L_E_T_	=' '			" + CRLF
	cQry+= " AND SD2.D_E_L_E_T_	=' '			" + CRLF
	cQry+= " AND SF2.D_E_L_E_T_	=' '			" + CRLF
	cQry+= " AND ZAJ.D_E_L_E_T_	=' '			" + CRLF
	cQry+= " GROUP BY ZAJ_CODIGO,ZAJ_ITEM,ZAE_EPEP , ZAE_EVENTO, ZAE_CC, D2_CONTA, ZAJ.R_E_C_N_O_, ZAJ_HORA, ZAJ_DTCTB,ZAE_CTBREC, ZAE_CTBPIS, ZAE_CTBCOF, SUBSTR(ZAD_DTEVEN,1,4)||SUBSTR(ZAD_DTEVEN,6,2)||SUBSTR(ZAD_DTEVEN,9,2)	" + CRLF
	cQry+= " ORDER BY ZAJ_CODIGO, ZAJ_ITEM, DT ,ZAJ_HORA, ZAE_EPEP " + CRLF


	TcQuery cQry New Alias (cAliasCTB)

	dbSelectArea(cAliasCTB)

	(cAliasCTB)->(dbGoTop())

	aAdd(aCpoCTB,{"OK"        ,"C",02,0})
	aAdd(aCpoCTB,{"Datas"	  ,"C",10,0})
	aAdd(aCpoCTB,{"Hora"  	  ,"C",05,0})
	aAdd(aCpoCTB,{"Epep"	  ,"C",20,0})
	aAdd(aCpoCTB,{"Evento"    ,"C",50,0})
	aAdd(aCpoCTB,{"CCusto"	  ,"C",20,0})
	aAdd(aCpoCTB,{"CtaCredito","C",20,0})
	aAdd(aCpoCTB,{"CtaDebito","C",20,0})
	aAdd(aCpoCTB,{"Ctapis"	  ,"C",20,0})
	aAdd(aCpoCTB,{"ValPis"	  ,"N",15,2})
	aAdd(aCpoCTB,{"CtaCofins" ,"C",20,0})
	aAdd(aCpoCTB,{"ValCofins" ,"N",15,2})
	aAdd(aCpoCTB,{"Total"	  ,"N",15,2})
	aAdd(aCpoCTB,{"Dtctb"	  ,"C",10,0})
	aAdd(aCpoCTB,{"RecnoZAJ"  ,"N",15,0})

	aAdd(aCpoBrw,{"OK"			,"" ,"" 					,"@!"								 })
	aAdd(aCpoBrw,{"Datas"   	,""	,"Data Evento"   		,"@!"               		,"10","0"})
	aAdd(aCpoBrw,{"Hora"		,""	,"Hora"     			,"@!"       				,"08","0"})
	aAdd(aCpoBrw,{"Epep"		,""	,"Elem.Pep"				,"@!"               		,"15","0"})
	aAdd(aCpoBrw,{"Evento"		,""	,"Descricao"   			,"@!"           		    ,"45","0"})
	aAdd(aCpoBrw,{"CCusto"	    ,""	,"Centro Custo" 		,"@!"  						,"20","0"})
	aAdd(aCpoBrw,{"CtaCredito"  ,""	,"Credito" 				,"@!"  						,"20","0"})
	aAdd(aCpoBrw,{"CtaDebito"   ,""	,"Debito" 				,"@!"  						,"20","0"})
	aAdd(aCpoBrw,{"Ctapis"	    ,""	,"Conta Pis" 		    ,"@!"  						,"20","0"})
	aAdd(aCpoBrw,{"ValPis"	    ,""	,"Valor Pis"  		    ,"@E 999,999,999,999.99"  	,"16","2"})
	aAdd(aCpoBrw,{"CtaCofins"   ,""	,"Conta Cofins" 		,"@!"  						,"20","0"})
	aAdd(aCpoBrw,{"ValCofins"	,""	,"Valor Cofins"  		,"@E 999,999,999,999.99","16","2"})
	aAdd(aCpoBrw,{"Total"	    ,""	,"Valor Total"  		,"@E 999,999,999,999.99"  	,"16","2"})
	aAdd(aCpoBrw,{"Dtctb"     	,""	,"Data da Apropriação"  ,"@!"               		,"10","0"})
	aAdd(aCpoBrw,{"RecnoZAJ"    ,""	,"Reg.ZAJ"  			,"@!"               		,"15","0"})

	//Função para criação da tabela temporária
	CRIATMP(cAliasTMP,aCpoCTB,oSay)

	_aCores := {}

	aAdd(_aCores,{"(cAliasTMP)->Dtctb == '  /  /    ' "	,"BR_AMARELO"	})
	aAdd(_aCores,{"(cAliasTMP)->Dtctb != '  /  /    ' "	,"BR_VERDE"	})

	Define MsDialog oDlg From aSize[7],0 TO aSize[6],aSize[5] Title cCadastro Pixel

	@ 035, 003 GROUP oGroup1 TO aPosObj[1][3],aPosObj[1][4] OF oDlg COLOR 0, 16777215  PIXEL

	@ 040, 006 SAY "APROPRIAÇÃO RECEITA BILHETERIA "  SIZE 250, 010 FONT oFontSubN2  OF oDlg COLORS RGB(031,073,125) PIXEL

	@ 040, 246 SAY "TOTAL "    SIZE 100, 010 FONT oFontSubN2  OF oDlg COLORS RGB(031,073,125) PIXEL
	@ 040, 280 GET nVlrTot Object oVlrTot When .f. SIZE 060,020 Picture "@E 999,999,999,999.99"


	oMark:=MsSelect():New(cAliasTMP,"OK","",aCpoBrw,@lInverte,cMarca,{aPosObj[1][1]+030,aPosObj[1][2],aPosObj[1][3],aPosObj[1][4]},,,,,_aCores)
	oMark:oBrowse:lHasMark := .T.

	oMark:oBrowse:lCanAllMark:=.T.
	lMarcar	:=	.T.

	oMark:oBrowse:bAllMark := { || MarkAll(cMarca,lMarcar )}

	oMark:bMark := {| | Check(cMarca)}

	Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg, { || FwMsgRun(,{ || T4FGERCT2(oMark,oSay) }, "Contabilização", 'Aguarde, Contabilizando valores apropriados......')},{ ||oDlg:End() } ,,aButEnc)

Return

////////////////////////////////////////////////////////////////
/*/{Protheus.doc} CRIATMP
description cria tabela temporária para seleção dos registros
@type function
@version  
@author roger
@since 26/07/2021
@param cAliasTMP, character, param_description
@param aCpoZAF, array, param_description
@return variant, return_description
/*///////////////////////////////////////////////////////////////

Static Function CRIATMP(cAliasTMP,aCpoCTB,oSay)

	Local oTempTable

	//-------------------
	//Criação do objeto
	//-------------------
	oSay:SetText("Gerando tabela temporária")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	oTempTable := FWTemporaryTable():New(cAliasTMP )

	//--------------------------
	//Monta os campos da tabela
	oTemptable:SetFields(aCpoCTB)
	oTempTable:AddIndex('01', {"Datas","Hora"} )

	//------------------
	//Criação da tabela
	//------------------
	oTempTable:Create()

	DbSelectArea("ZAJ")

	DbSelectArea(cAliasTMP)

	cItAnt	:=	(cAliasCTB)->ZAJ_ITEM
	cCodigo	:=	(cAliasCTB)->ZAJ_CODIGO

	While !(cAliasCTB)->(Eof())

		oSay:SetText("Alimentando tabela temporária")
		ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

		If Empty((cAliasCTB)->ZAJ_ITEM)

			BEGIN TRANSACTION

				cQry:= " SELECT MAX(ZAJ_ITEM) ITEM FROM "+RetSqlName('ZAJ') 		+ CRLF
				cQry+= " 	WHERE ZAJ_CODIGO ='"+cCodigo+"'" 				+ CRLF
				cQry+= " 	AND   ZAJ_EPEP	= '"+(cAliasCTB)->ZAE_EPEP+"'"	+ CRLF

				TcQuery cQry New Alias (cAliasZAJ := GetNextAlias())

				dbSelectArea(cAliasZAJ)

				RecLock("ZAJ",.T.)

				ZAJ->ZAJ_EPEP	:= (cAliasCTB)->ZAE_EPEP
				ZAJ->ZAJ_CODIGO	:= cCodigo
				ZAJ->ZAJ_ITEM	:= Soma1((cAliasZAJ)->ITEM)
				ZAJ->ZAJ_DATA	:= Stod((cAliasCTB)->DT)
				ZAJ->ZAJ_DIA	:= DiaSemana(Stod((cAliasCTB)->DT))
				ZAJ->ZAJ_HORA	:= (cAliasCTB)->ZAD_HORA

				cItAnt := ZAJ->ZAJ_ITEM
				nRecno := Recno()

				ZAJ->(MsUnlock())

				(cAliasZAJ)->(DbCloseArea())

			END TRANSACTION

		EndIf

		RecLock(cAliasTMP,.T.)

		(cAliasTMP)->OK			:= ' '
		(cAliasTMP)->Datas		:= DTOC(Stod((cAliasCTB)->DT))
		(cAliasTMP)->Hora		:= If(Empty((cAliasCTB)->ZAJ_HORA),(cAliasCTB)->ZAD_HORA,(cAliasCTB)->ZAJ_HORA)
		(cAliasTMP)->Epep		:= (cAliasCTB)->ZAE_EPEP
		(cAliasTMP)->Evento		:= (cAliasCTB)->ZAE_EVENTO
		(cAliasTMP)->CCusto		:= (cAliasCTB)->ZAE_CC
		(cAliasTMP)->CtaDebito	:= (cAliasCTB)->ZAE_CTBREC
		(cAliasTMP)->CtaCredito	:= (cAliasCTB)->D2_CONTA
		(cAliasTMP)->Ctapis		:= (cAliasCTB)->ZAE_CTBPIS
		(cAliasTMP)->ValPis		:= (cAliasCTB)->VALPIS
		(cAliasTMP)->CtaCofins	:= (cAliasCTB)->ZAE_CTBCOF
		(cAliasTMP)->ValCofins	:= (cAliasCTB)->VALCOFINS
		(cAliasTMP)->Total		:= (cAliasCTB)->TOTAL
		(cAliasTMP)->Dtctb		:= DTOC(Stod((cAliasCTB)->ZAJ_DTCTB))
		(cAliasTMP)->RecnoZAJ	:= If(Empty((cAliasCTB)->RECNOZAJ),nRecno,(cAliasCTB)->RECNOZAJ)

		(cAliasTMP)->(MsUnlock())

		cItAnt	:=	(cAliasCTB)->ZAJ_ITEM

		(cAliasCTB)->(dbSkip())

	EndDo

	(cAliasTMP)->(DbSetOrder(1))
	(cAliasTMP)->(dbGotop())

Return

/////////////////////////////////////////////////////////////
/*/{Protheus.doc} Check
description validação na marcação dos registros
@type function
@version  
@author roger
@since 26/07/2021
@param cMarca, character, param_description
@return variant, return_description
/*/////////////////////////////////////////////////////////

Static Function Check(cMarca)

	If (cAliasTMP)->Dtctb == '  /  /    '

		If Marked("OK")
			RecLock(cAliasTMP,.F.)
			(cAliasTMP)->OK 	:= cMarca

			MsUnlock()
			nVlrTot:= nVlrTot + (cAliasTMP)->TOTAL
			oVlrTot:Refresh()

		Else

			nVlrTot:= nVlrTot - (cAliasTMP)->TOTAL
			oVlrTot:Refresh()

		EndIf
	Else

		FWAlertWarning("Sessão apropriada anteriormente", "Apropriação")

		RecLock(cAliasTMP,.F.)
		(cAliasTMP)->OK 	:= ""

		MsUnlock()

	EndIf

Return()

//////////////////////////////////////////////////////////////
/*/{Protheus.doc} INTILEG
description legenda da rotina
@type function
@version  
@author roger
@since 12/07/2021
@return variant, return_description
/*/////////////////////////////////////////////////////////////

Static Function INTILEG()

	Local aCor := {}

	aAdd(aCor,{"BR_VERDE","Apropriado" })
	aAdd(aCor,{"BR_AMARELO"	,"Pendente"	  })

	BrwLegenda(,"Legenda",aCor)

Return

/////////////////////////////////////////////////////////////////
/*/{Protheus.doc} MarkAll
description
@type function
@version  
@author roger
@since 27/07/2021
@param cMarca, character, param_description
@param lMarcar, logical, param_description
@return variant, return_description
/*////////////////////////////////////////////////////////////////
Static Function MarkAll(cMarca,lMarcar )

	Local aAreaMark := (cAliasTMP)->( GetArea() )
	Local lMsg		:= .F.

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->( dbGoTop() )

	While !(cAliasTMP)->( Eof() )

		If (cAliasTMP)->Dtctb == '  /  /    '

			If Empty((cAliasTMP)->OK )
				RecLock( (cAliasTMP), .F. )

				(cAliasTMP)->OK := cMarca
				(cAliasTMP)->(MsUnLock())

				nVlrTot:= nVlrTot + (cAliasTMP)->TOTAL

			Else
				RecLock( (cAliasTMP), .F. )

				(cAliasTMP)->OK := " "
				(cAliasTMP)->(MsUnLock())

				nVlrTot:= nVlrTot - (cAliasTMP)->TOTAL

			EndIf
		Else

			If !lMsg
				FWAlertWarning("Existem sessões que já foram apropriadas, portanto não serão marcadas.", "Apropriação")
			EndIf

			lMsg := .T.
		EndIf

		(cAliasTMP)->( dbSkip() )

	EndDo

	(cAliasTMP)->( dbGoTop() )

	oVlrTot:Refresh()

	oMark:Refresh(.T.)

	RestArea( aAreaMark )

Return .T.


/*/{Protheus.doc} FilMarkBrow
description filtra informações no browse
@type function
@version  
@author roger
@since 12/07/2021
@param cOrdem, character, param_description
@param ntela, numeric, param_description
@return variant, return_description
/*/
Static Function FilMarkBrow(cOrdem)

	Local _nReg	:=	Recno()

	DbSelectArea(cAliasTMP)
	DbGoTop()

	If !Empty(cFiltro)
		(cAliasTMP)->(DbSetFilter( { || UPPER(Alltrim(FwCutOff(cFiltro, .F.))) $ UPPER(FwCutOff((cAliasTMP)->&cOrdem, .F.))  }, 'UPPER(Alltrim(FwCutOff(cFiltro, .F.))) $ UPPER(FwCutOff((cAliasTMP)->&cOrdem, .F.))' ) )
	Else
		DbSelectArea(cAliasTMP)
		(cAliasTMP)->(DBClearFilter())
		DbGoTo(_nReg)
	EndIf

	oMark:Refresh(.T.)
Return


/*/{Protheus.doc} T4FGERCT2
Description - Realiza a inclusão do lançamento contábil
@type function
@version  
@author roger
@since 12/07/2021
@return variant, return_description
/*/
Static Function T4FGERCT2(oMark,oSay)

	Local aCab	 := {}
	Local aItens := {}
	Local lRet	 := .F.
	Local nz	 := 0
	Local cLinha := '001'
	Local aAreaMark := (cAliasTMP)->( GetArea() )

	Private cData
	Private	cLote
	Private	cSLote
	Private	cDoc

	oSay:SetText("Incluindo lançamento contábil")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	//lRet	:=	FWAlertYesNo("Deseja apropriar PIS/COFINS", "Apropriação PIS/COFINS")
	lRet	:=	.F.

	DbSelectArea(cAliasTMP)
	(cAliasTMP)->(DbGoTop())

	cData := (cAliasTMP)->Datas

	While !(cAliasTMP)->(Eof())

		If !Empty((cAliasTMP)->OK) .And. (cAliasTMP)->Dtctb == "  /  /    "
			If Len(aCab) == 0
				aCab := { {'DDATALANC' ,Ctod((cAliasTMP)->Datas) ,NIL},;
					{'CLOTE' ,'RECBIL' ,NIL},;
					{'CSUBLOTE' ,'001' ,NIL},;
					{'CDOC' , STRZERO(seconds(),6) ,NIL},;
					{'CPADRAO' ,'' ,NIL},;
					{'NTOTINF' ,0 ,NIL},;
					{'NTOTINFLOT' ,0 ,NIL} }
			EndIf

			If dtoc(aCab[1][2]) == (cAliasTMP)->Datas

				aAdd(aItens,{ {'CT2_FILIAL' ,xFilial("CT2") , NIL},;
					{'CT2_LINHA' 	,cLinha , NIL},;
					{'CT2_MOEDLC' 	,'01' , NIL},;
					{'CT2_DC' 		,'3' , NIL},;
					{'CT2_DEBITO' 	,(cAliasTMP)->CtaDebito , NIL},;
					{'CT2_CREDIT' 	,(cAliasTMP)->CtaCredito , NIL},;
					{'CT2_CCD' 		,(cAliasTMP)->CCusto , NIL},;
					{'CT2_CCC' 		,(cAliasTMP)->CCusto , NIL},;
					{'CT2_ITEMD' 	,(cAliasTMP)->Epep , NIL},;
					{'CT2_ITEMC' 	,(cAliasTMP)->Epep , NIL},;
					{'CT2_VALOR' 	, (cAliasTMP)->Total , NIL},;
					{'CT2_ORIGEM' 	,'LCTO AUTOM.APRO.REC.BILHETERIA', NIL},;
					{'CT2_HP' 		,' ' , NIL},;
					{'CT2_CONVER'	,'1', NIL},;
					{'CT2_HIST' 	,'APROPRIACAO BILHETERIA - EVENTO: '+ Alltrim((cAliasTMP)->Evento) +' - DATA:  ' +(cAliasTMP)->Datas+' - SESSAO: ' + (cAliasTMP)->Hora , NIL},;
					{'RECNOZAJ' 	,(cAliasTMP)->RecnoZAJ, NIL} } )

				/*	
				//---------------------------------
				//Contabilização de PIS e COFINS
				//---------------------------------
				*/
				If lRet
					cLinha:=Soma1(cLinha)
					aAdd(aItens,{ {'CT2_FILIAL' ,xFilial("CT2") , NIL},;
						{'CT2_LINHA' 	,cLinha , NIL},;
						{'CT2_MOEDLC' 	,'01' , NIL},;
						{'CT2_DC' 		,'3' , NIL},;
						{'CT2_DEBITO' 	,(cAliasTMP)->CtaDebito , NIL},;
						{'CT2_CREDIT' 	,(cAliasTMP)->CtaPis , NIL},;
						{'CT2_CCD' 		,(cAliasTMP)->CCusto , NIL},;
						{'CT2_CCC' 		,(cAliasTMP)->CCusto , NIL},;
						{'CT2_ITEMD' 	,(cAliasTMP)->Epep , NIL},;
						{'CT2_ITEMC' 	,(cAliasTMP)->Epep , NIL},;
						{'CT2_VALOR' 	, (cAliasTMP)->ValPis , NIL},;
						{'CT2_ORIGEM' 	,'LCTO AUTOM.APRO.REC.BILHETERIA', NIL},;
						{'CT2_HP' 		,'' , NIL},;
						{'CT2_CONVER'	,'1', NIL},;
						{'CT2_HIST' 	,'PIS APROPRIACAO BILHETERIA: '+ DTOC(STOD((cAliasTMP)->Datas))+ ' EVENTO:' + Alltrim((cAliasTMP)->Evento) + ' SESSAO:' + (cAliasTMP)->Hora, NIL},;
						{'RECNOZAJ' 	,0, NIL} } )

					cLinha:=Soma1(cLinha)
					aAdd(aItens,{ {'CT2_FILIAL' ,xFilial("CT2") , NIL},;
						{'CT2_LINHA' 	,cLinha , NIL},;
						{'CT2_MOEDLC' 	,'01' , NIL},;
						{'CT2_DC' 		,'3' , NIL},;
						{'CT2_DEBITO' 	,(cAliasTMP)->CtaDebito , NIL},;
						{'CT2_CREDIT' 	,(cAliasTMP)->CtaCofins , NIL},;
						{'CT2_CCD' 		,(cAliasTMP)->CCusto , NIL},;
						{'CT2_CCC' 		,(cAliasTMP)->CCusto , NIL},;
						{'CT2_ITEMD' 	,(cAliasTMP)->Epep , NIL},;
						{'CT2_ITEMC' 	,(cAliasTMP)->Epep , NIL},;
						{'CT2_VALOR' 	, (cAliasTMP)->ValCofins , NIL},;
						{'CT2_ORIGEM' 	,'LCTO AUTOM.APRO.REC.BILHETERIA', NIL},;
						{'CT2_HP' 		,'' , NIL},;
						{'CT2_CONVER'	,'1', NIL},;
						{'CT2_HIST' 	,'COFINS APROPRIACAO BILHETERIA: '+ DTOC(STOD((cAliasTMP)->Datas))+ ' EVENTO:' + Alltrim((cAliasTMP)->Evento) + ' SESSAO:' + (cAliasTMP)->Hora, NIL},;
						{'RECNOZAJ' 	,0, NIL} } )
				EndIf

				If Len(aItens) > 0

					LJMsgRun("Contabilizando Apropriação data: "+DTOC(aCab[1][2]),"Aguarde",{|| MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3) })

					If lMsErroAuto <> Nil
						If !lMsErroAuto
							_lOk := .T.
							For nz:=1 To Len(aItens)
								If aItens[nz][16][2] > 0
									ATUZAJDTCTB(DTOS(aCab[1][2]),aItens[nz][16][2])
								EndIf
							Next nz

							cData 	:= DTOS(aCab[1][2])
							cLote 	:= aCab[2][2]
							cSLote	:= aCab[3][2]
							cDoc	:= aCab[4][2]

							lRet	:=	FWAlertYesNo("Apropriação realizada com sucesso-" + Alltrim(aItens[1][15][2]) +", Deseja visualizar lançamento?", "Apropriação")

							/*	
							//---------------------------------
							//Visualiza o lançamento
							//---------------------------------
							*/

							If lRet
								CTBA102()
							EndIf

						Else
							_lOk := .F.
							If !IsBlind()
								FWAlertError('Erro na inclusao!'+ Alltrim(aItens[1][15][2]), "Erro Apropriação")
								MostraErro()
							Endif
						EndIf
					EndIf

					aCab	:= ''
					aItens	:= {}
					cLinha 	:= '001'

				EndIf

			EndIf

		EndIf

		(cAliasTMP)->(dbSkip())

	EndDo

	/*	
	//---------------------------------
	//Exclui a tabela 
	//---------------------------------
	*/

	If(Type('oTable') <> 'U')

		oTempTable:Delete()

		FreeObj(oTempTable)

	EndIf

	(cAliasTMP)->(dbGoTop())

//	oMark:Refresh()

	RestArea(aAreaMark)

	(cAliasTMP)->(dbGoTop())

	oMark:oBrowse:Refresh()

	(cAliasTMP)->(dbGoTop())

Return

/////////////////////////////////////////////////////////////////////////////
/*/{Protheus.doc} ATUZAJDTCTB
description - Atualiza o status contábil da tabela de calendário do evento
@type function
@version  
@author roger
@since 22/06/2022
@param cData, character, data contabilizada
@param RECNO, variant, numero do registro na tabela
@return variant, return_description
/*///////////////////////////////////////////////////////////////////////////

Static Function ATUZAJDTCTB(cData,RECNO)

	Local cQry :=" "

	cQry += "UPDATE "+RetSqlName('ZAJ') + " SET ZAJ_DTCTB ='"+cData+ "' "
	cQry += " WHERE R_E_C_N_O_ = "+ALLTRIM(STR(RECNO))
	cQry += " AND D_E_L_E_T_ =' ' "

	nStatus := TcSqlExec(cQry)

	If (nStatus < 0)
		cErro :=  REPLICATE("*", 5)+ CRLF
		cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
	EndIf

	cQry += "UPDATE "+RetSqlName('CT2') + " SET D_E_L_E_T_ ='*' "
	cQry += " WHERE CT2_DATA = '" +cData+ "' "
	cQry += " AND CT2_LOTE ='RECBIL' "
	cQry += " AND D_E_L_E_T_ =' ' "

	nStatus := TcSqlExec(cQry)

	If (nStatus < 0)
		cErro :=  REPLICATE("*", 5)+ CRLF
		cErro +=  Alltrim(Time())+" - Erro " + "TCSQLError() " + TCSQLError()
	EndIf

	(cAliasTMP)->(dbGoTop())

	While !(cAliasTMP)->(Eof())
		If !Empty((cAliasTMP)->OK ) .And. (cAliasTMP)->RecnoZAJ == RECNO
			RecLock( (cAliasTMP), .F. )

			(cAliasTMP)->Dtctb	:= cData
			(cAliasTMP)->OK 	:= ' '

			(cAliasTMP)->(MsUnLock())
		EndIf

		(cAliasTMP)->(dbSkip())
	EndDo

	(cAliasTMP)->(dbGoTop())

	oVlrTot:Refresh()
	oMark:oBrowse:Refresh()

Return


