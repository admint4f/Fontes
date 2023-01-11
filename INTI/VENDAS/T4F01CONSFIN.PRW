#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13) )
#ENDIF

/*////////////////////////////////////////////////////////////////////////////
//                                                                          //
// 	Programa ...: T4F01CONSFIN                            Modulo : SIGAFAT  //
//                                                                          //
//  Fonte desenvolvido para apresentar tela com dados do pedido 			// 
//  gerado e da contabilização realizada 									// 
//                                                                          //
//	@type.......:	function												//
//                                                                          //
//	@version....:	1.00													//
//                                                                          //
//	@author.....:	Rogério Costa											//
//                                                                          //
//	@since......: 	05/02/2022												//	
//                                                                          //
//	@param......:	nReg, Numerico, Numero do registro da tabela ZAD		//
/*////////////////////////////////////////////////////////////////////////////

/*/{Protheus.doc} T4F01CONSFIN
Fonte desenvolvido para apresentar tela com dados do pedido gerado e da contabilização realizada 									
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	05/02/2022	
	@param......:	nReg, Numerico, Numero do registro da tabela ZAD	
/*/

User Function T4F01CONSFIN(nReg)

	Local aArea 		:= GetArea()
	Local cCadastro		:='Consulta Financeiro INTI'
	Local cQuery    	:=" "
	Local cAlias    	:= GetNextAlias()
	Local cAliaSC6  	:= GetNextAlias()
	Local cAliaCT2  	:= GetNextAlias()
	Local nTotQtd 		:= 0
	Local nTotSC6 		:= 0
	Local nTotCtb		:= 0
	Local nTotZaf		:= 0
	Local aNewButton	:={}
	Local cSerie 		:= ' '
	Local cNota  		:= ' '

	Private oDlg2
	Private oGetDados
	Private aRotina 	:= {}
	Private aColsZAF	:= {}
	Private aColsSC6	:= {}
	Private aColsCT2	:= {}

	//-------------------------------------------------
	// Consulta localizador/SLUID na tabela financeira.
	//-------------------------------------------------
	cQuery:=" "
	cQuery+=" SELECT DISTINCT ZAF_MODULO,ZAF_NUMERO,ZAF_TIPO,ZAF_TPRECB,ZAF_SLUID, 
	cQuery+=" ZAF_SEARCH,ZAF_DTVEND,ZAF_DTCANC,ZAF_EVENTO,ZAF_EPEP,ZAF_TPPGTO,ZAF_VLRTRA,ZAF_FINCRE,ZAF_NSU,ZAF_FINID "+ CRLF
	cQuery+=" FROM "+RetSqlName("ZAF") + " ZAF "        	+ CRLF
	cQuery+=" LEFT JOIN "+RetSqlName("ZAD") + " ZAD " 		+ CRLF
	cQuery+=" ON ZAF.ZAF_SEARCH = ZAD.ZAD_SEARCH "        	+ CRLF
	cQuery+=" AND ZAF.ZAF_SLUID = ZAD.ZAD_SLUID"        	+ CRLF
	cQuery+=" AND ZAD.ZAD_DTCANC <> ' '"        			+ CRLF
	cQuery+=" AND ZAF.D_E_L_E_T_ =' '"        				+ CRLF
	cQuery+=" WHERE ZAF_FILIAL <> ' ' "        				+ CRLF
	cQuery+=" AND ZAF_NUMERO <> ' ' "       				+ CRLF
	cQuery+=" AND ZAF_SLUID ='"+ ZAD->ZAD_SLUID + "'" 		+ CRLF
	cQuery+=" AND ZAF_SEARCH ='" + ZAD->ZAD_SEARCH + "'"	+ CRLF
	cQuery+=" AND ZAF.D_E_L_E_T_ = ' ' "						+ CRLF

	TCQUERY (cQuery) NEW ALIAS (cAlias)

	(cAlias)->(DbGotop())

	If !Empty((cAlias)->ZAF_MODULO )
		cNumZAF	:=	' '
		While (cAlias)->(!Eof())

			aAdd(aColsZAF,{(cAlias)->ZAF_MODULO 	 ,;
				(cAlias)->ZAF_TIPO   ,;
				(cAlias)->ZAF_TPRECB ,;
				(cAlias)->ZAF_SLUID  ,;
				(cAlias)->ZAF_SEARCH ,;
				Stod((cAlias)->ZAF_DTVEND) ,;
				Stod((cAlias)->ZAF_DTCANC) ,;
				(cAlias)->ZAF_EVENTO ,;
				(cAlias)->ZAF_EPEP   ,;
				(cAlias)->ZAF_TPPGTO ,;
				(cAlias)->ZAF_VLRTRA ,;
				(cAlias)->ZAF_FINCRE,;
				(cAlias)->ZAF_NSU    ,;
				(cAlias)->ZAF_FINID })

			If cNumZAF	<>	(cAlias)->ZAF_NUMERO
				nTotZaf	+= (cAlias)->ZAF_VLRTRA
			EndIf

			cNumZAF	:=	(cAlias)->ZAF_NUMERO

			(cAlias)->(dbSkip())

		EndDo

	//-------------------------------------------------
	// Consulta localizador/SLUID na tabela financeira.
	//-------------------------------------------------
		cQuery:=" "
		cQuery+=" SELECT C6_NUM, C6_ITEM, C6_PRODUTO, C6_QTDVEN, C6_VALOR, C6_SERIE, C6_NOTA "+ CRLF
		cQuery+=" FROM "+RetSqlName("SC6") + " SC6 "        + CRLF
		cQuery+=" WHERE C6_NUM ='"+ ZAD->ZAD_PEDIDO + "'" + CRLF
		cQuery+=" AND D_E_L_E_T_ = ' ' "+ CRLF

		TCQUERY (cQuery) NEW ALIAS (cAliaSC6)

		(cAliaSC6)->(DbGotop())

		If !Empty((cAliaSC6)->C6_NUM )

			While (cAliaSC6)->(!Eof())

				If !Empty((cAliaSC6)->C6_SERIE)
					cSerie := (cAliaSC6)->C6_SERIE
					cNota  := (cAliaSC6)->C6_NOTA
				Else
					cSerie := '000'
					cNota  := '00000000'
				EndIf

				aAdd(aColsSC6,{(cAliaSC6)->C6_NUM,;
					(cAliaSC6)->C6_ITEM,;
					(cAliaSC6)->C6_PRODUTO,;
					(cAliaSC6)->C6_QTDVEN,;
					(cAliaSC6)->C6_VALOR,;
					(cAliaSC6)->C6_SERIE,;
					(cAliaSC6)->C6_NOTA})

				nTotQtd += (cAliaSC6)->C6_QTDVEN
				nTotSC6 += (cAliaSC6)->C6_VALOR

				(cAliaSC6)->(dbSkip())

			EndDo
			aAdd(aColsSC6,{' ',;
				' ',;
				'TOTAL PEDIDO',;
				nTotQtd,;
				nTotSC6,;
				' ',;
				' '})

		EndIf

		cQryCT2:=" "
		cQryCT2+=" SELECT CT2_DATA, CT2_LOTE, CT2_DEBITO, CT2_CREDIT, 	"		+ CRLF
		cQryCT2+=" CT2_VALOR, CT2_HIST , CT2_CCD, CT2_ITEMD, CT2_ORIGEM "		+ CRLF
		cQryCT2+=" FROM "+RetSqlName("CT2") + " CT2 "        			 		+ CRLF

		If Empty(ZAD->ZAD_SEARCH)
			cQryCT2+=" WHERE CT2_HIST LIKE '%"+ZAD->ZAD_SLUID+"%'"				+ CRLF
		Else
			cQryCT2+=" WHERE CT2_HIST LIKE '%"+ZAD->ZAD_SEARCH+"%'"				+ CRLF
		EndIf

		cQryCT2+=" AND CT2_DATA = '"+DTOS(ZAD->ZAD_DTVEND)+"'" 						+ CRLF
		cQryCT2+=" AND (CT2_DEBITO = '1104010009' OR CT2_CREDIT = '1104010009')"+ CRLF
		cQryCT2+=" AND D_E_L_E_T_ =' '

		TCQUERY (cQryCT2) NEW ALIAS (cAliaCT2)

		(cAliaCT2)->(DbGotop())

		If Select(cAliaCT2) > 0

			While (cAliaCT2)->(!Eof())

				aAdd(aColsCT2,{Stod((cAliaCT2)->CT2_DATA),;
					(cAliaCT2)->CT2_LOTE,;
					(cAliaCT2)->CT2_DEBITO,;
					(cAliaCT2)->CT2_CREDIT,;
					(cAliaCT2)->CT2_VALOR,;
					(cAliaCT2)->CT2_HIST,;
					(cAliaCT2)->CT2_CCD,;
					(cAliaCT2)->CT2_ITEMD,;
					(cAliaCT2)->CT2_ORIGEM})

				nTotCtb	+=	(cAliaCT2)->CT2_VALOR

				(cAliaCT2)->(dbSkip())

			EndDo
		EndIf

		lMotivo:=.T.

		oSize := FWDefSize():New(.T.)
		oSize:AddObject( "ENCHOICE", 100, 60, .T., .T. ) // Adiciona enchoice
		oSize:SetWindowSize({000, 000, 520,900})
		oSize:lLateral     := .F.  // Calculo vertical
		oSize:Process() //executa os calculos

		//Array com as posições dinamicas se quiser alterar o tamnho da tela é so alterar o tamanho do SetWindowSize
		aPos := {oSize:GetDimension("ENCHOICE","LININI"),;
			oSize:GetDimension("ENCHOICE","COLINI"),;
			oSize:GetDimension("ENCHOICE","XSIZE"),;
			oSize:GetDimension("ENCHOICE","YSIZE")}

		//"Aprovação de Documento de Frete"
		DEFINE MSDIALOG oDlg2 TITLE cCadastro ;
			FROM oSize:aWindSize[1],oSize:aWindSize[2] ;
			TO oSize:aWindSize[3],oSize:aWindSize[4] ;
			Of oMainWnd COLORS 0, 16777215 PIXEL
		oDlg2:lEscClose := .F.

		oPnlCnt := tPanel():New(aPos[1],aPos[2],,oDlg2,,,,,,aPos[3],aPos[4],.F.,.F.)

		oPnlA := tPanel():New(00,00,,oPnlCnt,,,,,,10,20,.F.,.F.)
		oPnlA:Align := CONTROL_ALIGN_TOP

		/* Folders */
		oFolder := TFolder():New(0,0,{'Mov.Financeira', "Pedido de Venda", "Lcts.Contábeis", "Resumo" },{"HEADER 1", "HEADER 2", "HEADER 3","HEADER 4" },oPnlCnt,,,,.T.,,10,10,) //"Mov.Financeiros"###"Observações"

		oFolder:bSetOption := {|nFolSel| IIF(nFolSel==2, Nil, Nil ) }

		oFolder:Align := CONTROL_ALIGN_ALLCLIENT

		oPanelB := TPanel():New(01,01,,oFolder:ADialogs[1],,,,,,0,0,.F.,.T.)
		oPanelB:Align := CONTROL_ALIGN_ALLCLIENT

		oPanelC := TPanel():New(01,01,,oFolder:ADialogs[2],,,,,,0,0,.F.,.T.)
		oPanelC:Align := CONTROL_ALIGN_ALLCLIENT

		oPanelD := TPanel():New(01,01,,oFolder:ADialogs[3],,,,,,0,0,.F.,.T.)
		oPanelD:Align := CONTROL_ALIGN_ALLCLIENT

		oPanelE := TPanel():New(01,01,,oFolder:ADialogs[4],,,,,,0,0,.F.,.T.)
		oPanelE:Align := CONTROL_ALIGN_ALLCLIENT


		// ----- Criacao dos fields referente ao romaneio no painel superior da tela principal -----//
		cNomCli := ZAD->ZAD_NOME

		If !Empty(ZAD->ZAD_SEARCH)
			@ 07,05  Say 'Localizador' Of oPnlA COLOR CLR_BLACK Pixel //"Filial: "
			@ 05,35  MSGET ZAD->ZAD_SEARCH Picture "@!" Of oPnlA When .F. SIZE 40,10  Pixel
		Else
			@ 07,05  Say 'Id.Venda' Of oPnlA COLOR CLR_BLACK Pixel //"Filial: "
			@ 05,35  MSGET ZAD->ZAD_SLUID Picture "@!" Of oPnlA When .F. SIZE 40,10  Pixel
		EndIF

		@ 07,80  Say 'Evento' Of oPnlA COLOR CLR_BLACK Pixel
		@ 05,110 MSGET ZAD->ZAD_EVENTO Picture "@!" Of oPnlA When .F.  SIZE 55,10  Pixel

		@ 07,180 Say 'Consumidor'            Of oPnlA COLOR CLR_BLACK Pixel //"Emissor: "
		@ 05,230 MSGET cNomCli  Picture "@!" Of oPnlA When .F.   SIZE 100,10 Pixel

		//----------------------------------------------------------------------------------------------------
		//Aba Movimentações Financeiras
		cMovFin := TCBrowse():New( 25 , 1, 010, 350,,{'Modulo','Tipo','Tp.Recbto','SluId','Localizador','Dt.Venda','Dt.Canc.','Evento','Epep',;
			'Tp.Pagto','Vlr.Trans.','Fin.Cred','NSU','FinId'},{40,40,50,50,50,40,40,50,50,50,40,40,50,50},oPanelB,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
		If Len(aColsZAF) > 0

			cMovFin:SetArray(aColsZAF)

			cMovFin:AddColumn( TCColumn():New('Modulo',		{ || aColsZAF[cMovFin:nAt,1] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Tipo',		{ || aColsZAF[cMovFin:nAt,2] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Tp.Recbto',	{ || aColsZAF[cMovFin:nAt,3] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('SluId',		{ || aColsZAF[cMovFin:nAt,4] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Localizador',{ || aColsZAF[cMovFin:nAt,5] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Dt.Venda',	{ || aColsZAF[cMovFin:nAt,6] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Dt.Canc.',	{ || aColsZAF[cMovFin:nAt,7] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Evento',		{ || aColsZAF[cMovFin:nAt,8] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Epep',		{ || aColsZAF[cMovFin:nAt,9] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Tp.Pagto',	{ || aColsZAF[cMovFin:nAt,10] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Vlr.Trans.',	{ || aColsZAF[cMovFin:nAt,11] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('Fin.Cred',	{ || aColsZAF[cMovFin:nAt,12] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('NSU',		{ || aColsZAF[cMovFin:nAt,13] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cMovFin:AddColumn( TCColumn():New('FinId',		{ || aColsZAF[cMovFin:nAt,14] },,,,"LEFT",,.F.,.T.,,,,.F.,) )

			// Evento de clique no cabeçalho do browse
			//cMovFin:bHeaderClick := {|o,x| Alert('bHeaderClick'+Chr(13)+;'Coluna:'+StrZero(x,3)) }

			// Evento de clicar duas vezes na célula
			//cMovFin:bLDblClick := {|z,x| Alert('bLDblClick'+Chr(13)+;'Linha:'+StrZero(cGrdPV:nAt,3)+Chr(13)+;

			cMovFin:lUseDefaultColors := .T.
			//cMovFin:SetBlkBackColor({||IIf(aColsZAF[cGrdPV:nAt,3] == 'TOTAL PEDIDO',CLR_LIGHTGRAY, )})
			cMovFin:Align := CONTROL_ALIGN_ALLCLIENT
			cMovFin:lVisibleControl := .T.
			cMovFin:lVisible := .T.
			//cGrdOcor:oBrowse:nHeight  := 251
			cMovFin:nRight   := 80
			cMovFin:nWidth   := 80

		EndIf

		//----------------------------------------------------------------------------------------------------
		// Aba Pedidos de Venda
		cGrdPV := TCBrowse():New( 25 , 1, 010, 350,,{'Numero','Item','Produto','Qtd.Vendida','Valor','Serie','Nota'},{40,40,50,50,50,40,40},oPanelC,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		If Len(aColsSC6) > 0
			cGrdPV:SetArray(aColsSC6)

			cGrdPV:AddColumn( TCColumn():New('Numero'	,{ || aColsSC6[cGrdPV:nAt,1] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdPV:AddColumn( TCColumn():New('Item' 	,{ || aColsSC6[cGrdPV:nAt,2] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdPV:AddColumn( TCColumn():New('Produto'  ,{ || aColsSC6[cGrdPV:nAt,3] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdPV:AddColumn( TCColumn():New('Qtd.Venda',{ || aColsSC6[cGrdPV:nAt,4] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdPV:AddColumn( TCColumn():New('Valor' 	,{ || aColsSC6[cGrdPV:nAt,5] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdPV:AddColumn( TCColumn():New('Serie' 	,{ || aColsSC6[cGrdPV:nAt,6] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdPV:AddColumn( TCColumn():New('Nota' 	,{ || aColsSC6[cGrdPV:nAt,7] },,,,"LEFT",,.F.,.T.,,,,.F.,) )

			// Evento de clique no cabeçalho do browse
			//cGrdPV:bHeaderClick := {|o,x| Alert('bHeaderClick'+Chr(13)+;'Coluna:'+StrZero(x,3)) }

			// Evento de clicar duas vezes na célula
			//cGrdPV:bLDblClick := {|z,x| Alert('bLDblClick'+Chr(13)+;'Linha:'+StrZero(cGrdPV:nAt,3)+Chr(13)+;

			cGrdPV:lUseDefaultColors := .F.

			cGrdPV:SetBlkBackColor({||IIf(aColsSC6[cGrdPV:nAt,3] == 'TOTAL PEDIDO',CLR_LIGHTGRAY, )})

			cGrdPV:Align := CONTROL_ALIGN_ALLCLIENT

			cGrdPV:lVisibleControl := .T.
			cGrdPV:lVisible := .T.
			//cGrdOcor:oBrowse:nHeight  := 251
			cGrdPV:nRight   := 80
			cGrdPV:nWidth   := 80
		EndIf

		//----------------------------------------------------------------------------------------------------
		//Aba Contabil
		cGrdCtb := TCBrowse():New( 25 , 1, 010, 350,,{'Data','Lote', 'Debito', 'Credito','Valor', 'Historico', 'Cta.Contabil', 'It.Debito', 'Origem'},{40,40,50,50,50,50,40,40,40},oPanelD,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

		If Len(aColsCT2) > 0
			cGrdCtb:SetArray(aColsCT2)

			cGrdCtb:AddColumn( TCColumn():New('Data'		,{ || aColsCT2[cGrdCtb:nAt,1] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('Lote' 		,{ || aColsCT2[cGrdCtb:nAt,2] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('Debito'  	,{ || aColsCT2[cGrdCtb:nAt,3] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('Credito'		,{ || aColsCT2[cGrdCtb:nAt,4] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('Valor' 		,{ || aColsCT2[cGrdCtb:nAt,5] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('Historico' 	,{ || aColsCT2[cGrdCtb:nAt,6] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('Cta.Contabil',{ || aColsCT2[cGrdCtb:nAt,7] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('It.Debito' 	,{ || aColsCT2[cGrdCtb:nAt,8] },,,,"LEFT",,.F.,.T.,,,,.F.,) )
			cGrdCtb:AddColumn( TCColumn():New('Origem' 		,{ || aColsCT2[cGrdCtb:nAt,9] },,,,"LEFT",,.F.,.T.,,,,.F.,) )

			// Evento de clique no cabeçalho do browse
			//cGrdCtb:bHeaderClick := {|o,x| Alert('bHeaderClick'+Chr(13)+;'Coluna:'+StrZero(x,3)) }

			// Evento de clicar duas vezes na célula
			//cGrdCtb:bLDblClick := {|z,x| Alert('bLDblClick'+Chr(13)+;'Linha:'+StrZero(cGrdPV:nAt,3)+Chr(13)+;

			cGrdCtb:lUseDefaultColors := .F.

			//cGrdCtb:SetBlkBackColor({||IIf(aColsSC6[cGrdCtb:nAt,3] == 'TOTAL PEDIDO',CLR_LIGHTGRAY, )})

			cGrdCtb:Align := CONTROL_ALIGN_ALLCLIENT

			cGrdCtb:lVisibleControl := .T.
			cGrdCtb:lVisible := .T.
			//cGrdOcor:oBrowse:nHeight  := 251
			cGrdCtb:nRight   := 80
			cGrdCtb:nWidth   := 80
		EndIf

		//----------------------------------------------------------------------------------------------------
		//Aba Resumo
		//----------------------------------------------------------------------------------------------------

		// Cria fonte para ser usada no TSay
		oFont := TFont():New('Arial',,-18,.T.)

		// Monta o Texto no formato HTML
		cTextHtml := '<hr size="1">'
		cTextHtml += '<font size="5" color="black">Totalizadores</font><br/>'
		cTextHtml += '<table border="1" cellpadding="1" cellspacing="0">'
		cTextHtml += '<tr>'
		cTextHtml += '<td width="100" bgcolor="#D3D3D3">Vlr.Financeiro</td>'
		cTextHtml += '<td width="200" bgcolor="#D3D3D3">Vlr.Pedido</td>'
		cTextHtml += '<td width="100" bgcolor="#D3D3D3">Vlr.Contabilizado</td>'
		cTextHtml += '</tr>'
		cTextHtml += '<tr>'
		cTextHtml += '<td>' + PadL(AllTrim(Transform(nTotZaf, "@E 9,999,999.99")), 15) +'</td>'
		cTextHtml += '<td>' + PadL(AllTrim(Transform(nTotSC6, "@E 9,999,999.99")), 15) +'</td>'
		cTextHtml += '<td>' + PadL(AllTrim(Transform(nTotCTb, "@E 9,999,999.99")), 15) +'</td>'
		cTextHtml += '</tr>'
		cTextHtml += '</table>'

		// Cria o TSay permitindo texto no formato HMTL
		lHtml := .T.
		oSay := TSay():New(01,01,{||cTextHtml},oPanelE,,oFont,,,,.T.,,,500,400,,,,,,lHtml)

		dbSelectArea(cAlias)
		dbGoTOp()

		ACTIVATE MSDIALOG oDlg2 ON INIT (EnchoiceBar(oDlg2,{||Iif(lMotivo,(lExecFilt := .T.,oDlg2:End()),NIL)},{||oDlg2:End()},,aNewButton)) CENTERED


	Else

		msg := "ATENCAO!"+CHR(13)+CHR(10)
		msg +=  CHR(13)+CHR(10)
		msg += "Não foram encontradas movimentações financeiras para esse registro."
		msg +=  CHR(13)+CHR(10)

		Alert(msg)

	EndIf

	If Select(cAlias) > 0
		(cAlias)->( DbCloseArea() )
	EndIf

	RestArea(aArea)

Return(Nil)


