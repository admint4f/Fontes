#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} T4FR001
Relatrio de entregas  - em excel abre no broffice

@author 
@since 21/12/2018
@version 1.0
/*/
//-------------------------------------------------------------------

User Function T4FR001()
	Local oReport := nil
	Local cPerg   := "T4FRINTI"

	Pergunte(cPerg,.T.)

	oReport := RptDef(cPerg)
	oReport:PrintDialog()
Return

Static Function RptDef(cNome)
	Local oReport   := Nil
	Local oSection1 := Nil

	Local cNomRel   := 'Integração Vendas INTI_' + dToS(dDataBase) + StrTran(Time(), ":", "-")

/* MV_PAR03
	1=Ingresso
	2=Taxas,Conveniencia","Servicos","Entrega","impressao",Assinaturas
	3=doações
	4=todos
*/

	/*Sintaxe: TReport():New(cNome,cTitulo,cPerguntas,bBlocoCodigo,cDescricao)*/
	oReport:= TReport():New(cNomRel,"Relatorio de Integração INTI",cNome,{|oReport| ReportPrint(oReport)},"Relação de integração vendas INTI")
	oReport:ShowParamPage()
	oReport:lParamPage := .F.
	oReport:nFontBody := 8
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)
	oReport:SetDevice(4)

	oSection1:= TRSection():New(oReport, "END", {"ZAD"}, NIL, .F., .T.)
	oSection1:SetLineHeight(70)

	/*
		'Ingresso'			:=		'1' 		
		'Conveniencia'		:=		'2' 		
		'Servicos'			:=		'3' 		
		'Entrega'			:=		'4' 		
		'Cortesia'			:=		'5' 		
		'Socios'			:=		'6' 		
		'Assinaturas'		:=		'7' 		
		'Doação'			:=		'8' 		
	*/

	TRCell():New(oSection1,"EPEP               "  ,"","Elemento PEP" 			,"@!",30)
	TRCell():New(oSection1,"EVENTO             "  ,"","Desc.Evento" 			,"@!",30)
	TRCell():New(oSection1,"TP_MOVTO           "  ,"","Tp.Movto" 				,"@!",30)
	TRCell():New(oSection1,"TP_ITEM            "  ,"","Tp.Item" 				,"@!",30)
	TRCell():New(oSection1,"STATUS             "  ,"","Status" 					,"@!",30)
	TRCell():New(oSection1,"DESCRICAO          "  ,"","Descrição" 				,"@!",30)
	TRCell():New(oSection1,"OBS                "  ,"","Observação" 			    ,"@!",100)
	TRCell():New(oSection1,"LOCALIZADOR        "  ,"","Localizador" 			,"@!",30)
	TRCell():New(oSection1,"ID_ITEM_VENDA      "  ,"","Id.Item Venda" 			,"@!",30)
	TRCell():New(oSection1,"CPF" 			      ,"","CPF" 					,"@!",30)
	TRCell():New(oSection1,"DTVENDA            "  ,"","Data Venda" 				,"@!",30)
	TRCell():New(oSection1,"SERIE"			      ,"","Serie RPS" 				,"@!",09)
	TRCell():New(oSection1,"RPS"  			      ,"","RPS" 	     			,"@!",03)
	TRCell():New(oSection1,"STATUS"  			  ,"","Status" 	     			,"@!",09)
	TRCell():New(oSection1,"VALOR"         		  ,"","Valor Movimento"   		,"@!",12)

	/*
	TRCell():New(oSection1,"VLR_INGRESSO"         ,"","Vlr. Ingresso" 			,"@!",12)
	TRCell():New(oSection1,"VLR_CONVENIENCIA"     ,"","Vlr. Conveniencia" 		,"@!",12)
	TRCell():New(oSection1,"VLR_ENTREGA"          ,"","Vlr. Entrega" 			,"@!",12)
	TRCell():New(oSection1,"VLR_SERVICOS"         ,"","Vlr. Serviços" 			,"@!",12)
	TRCell():New(oSection1,"VLR_TX_IMPRESSAO"     ,"","Vlr. Taxa de Impressão" 	,"@!",12)
	*/

	oReport:SetTotalInLine(.F.)

	//Aqui, farei uma quebra  por seo
	//oSection1:SetPageBreak(.F.)
	//oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cQuery2   := ""
	Local cAlias	:= GetNextAlias()
	Local cAlias2	:= ""
	Local cTpItem	:= ''

	cQuery += "	SELECT ZAD_ITEMID,ZAD_EPEP EPEP ,  "+CRLF
	cQuery += "	ZAD_EVENTO EVENTO ,  "+CRLF
	cQuery += "	CASE ZAD_TPTRAN  "+CRLF
	cQuery += "	WHEN '1' THEN 'Venda'  "+CRLF
	cQuery += "	WHEN '2' THEN 'Cancelado'  "+CRLF
	cQuery += "	END AS TP_MOVTO ,  "+CRLF
	cQuery += "	CASE ZAD_TPITEM  "+CRLF
	cQuery += "	WHEN '1' THEN 'Ingresso'  "+CRLF
	cQuery += "	WHEN '2' THEN 'Conveniencia'  "+CRLF
	cQuery += "	WHEN '3' THEN 'Servicos'  "+CRLF
	cQuery += "	WHEN '4' THEN 'Entrega'  "+CRLF
	cQuery += "	WHEN '5' THEN 'Cortesia'  "+CRLF
	cQuery += "	WHEN '6' THEN 'Socios'  "+CRLF
	cQuery += "	WHEN '7' THEN 'Assinaturas'  "+CRLF
	cQuery += "	WHEN '8' THEN 'Doação'  "+CRLF
	cQuery += "	END AS TP_ITEM ,  "+CRLF
	cQuery += "	CASE ZAD_STATUS  "+CRLF
	cQuery += "	WHEN '1' THEN 'Pendente'  "+CRLF
	cQuery += "	WHEN '2' THEN 'Pedido Gerado'  "+CRLF
	cQuery += "	WHEN '3' THEN 'Nota Gerada'  "+CRLF
	cQuery += "	WHEN '4' THEN 'Falha Integracao'  "+CRLF
	cQuery += "	WHEN '5' THEN 'Cancelamento Processado'  "+CRLF
	cQuery += "	WHEN 'E' THEN 'ERRO no Cancelamento '  "+CRLF
	cQuery += "	END AS STATUS ,  "+CRLF
	cQuery += "	ZAD_ITNAME DESCRICAO ,  "+CRLF
	cQuery += "	ZAD_OBS OBS ,  "+CRLF
	cQuery += "	ZAD_SEARCH LOCALIZADOR ,  "+CRLF
	cQuery += "	ZAD_SLUID ID_ITEM_VENDA ,  "+CRLF
	cQuery += "	ZAD_CPF CPF ,  "+CRLF
	cQuery += "	ZAD_DTVEND DTVENDA ,  "+CRLF
	cQuery += "	ZAD_SETOTV SERIE ,  "+CRLF
	cQuery += "	ZAD_NFTOTV RPS ,  "+CRLF
	cQuery += "	SUM(ZAD_VLRTXC) VLR_CONVENIENCIA ,  "+CRLF
	cQuery += "	SUM(ZAD_VLENTR) VLR_ENTREGA ,  "+CRLF
	cQuery += "	SUM(ZAD_VLRTKT) VLR_INGRESSO ,  "+CRLF
	cQuery += "	SUM(ZAD_VLRTXS) VLR_SERVICOS ,  "+CRLF
	cQuery += "	SUM(ZAD_VLRTXI) VLR_TX_IMPRESSAO,  "+CRLF
	cQuery += "	SUM(ZAD_VLRSOC) VLR_SOCIO  "+CRLF
	cQuery += "	FROM "+RETSQLNAME("ZAD") + " ZAD " +CRLF
	cQuery += "	WHERE ZAD_DTVEND BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02)+"' " +CRLF
	//cQuery += "	AND ZAD_SEARCH = 'Y3F3F70             ' " +CRLF
	cQuery += "	AND ZAD_EPEP BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 +"' " +CRLF


	If MV_PAR05 == 1
		cTpItem := "'1'" 	//Ingresso
	EndIf

	If MV_PAR06 == 1
		cTpItem += ",'2'" 	//Conveniencia
	EndIf

	If MV_PAR07 == 1
		cTpItem += ",'3'" 	//Servicos
	EndIf

	If MV_PAR08 == 1
		cTpItem += ",'4'"	//Entrega
	EndIf

	If MV_PAR09 == 1
		cTpItem += ",'5'" 	//Cortesia
	EndIf

	If MV_PAR10 == 1
		cTpItem += ",'6'" 	//Socios
	EndIf

	If MV_PAR11 == 1
		cTpItem += ",'7'" 	//Assinaturas
	EndIf

	If MV_PAR12 == 1
		cTpItem += ",'8'" 	//Doação
	EndIf

	If AT(',',cTpItem) == 1
		cTpItem	:= substr(cTpItem,2,len(cTpItem)-1)
	EndIf

	If !Empty(cTpItem)
		cQuery += "	AND ZAD_TPITEM IN (" + cTpItem + ")" +CRLF
	EndIf

	cQuery += "	AND D_E_L_E_T_ = ' '   "+CRLF
	cQuery += "	GROUP BY ZAD_ITEMID, ZAD_EPEP 	,  "+CRLF
	cQuery += "	ZAD_OBS	   ,  "+CRLF
	cQuery += "	ZAD_EVENTO ,  "+CRLF
	cQuery += "	ZAD_SETOTV ,  "+CRLF
	cQuery += "	ZAD_TPITEM ,  "+CRLF
	cQuery += "	ZAD_ITNAME ,  "+CRLF
	cQuery += "	ZAD_STATUS ,  "+CRLF
	cQuery += "	ZAD_NFINTI ,  "+CRLF
	cQuery += "	ZAD_NFTOTV ,  "+CRLF
	cQuery += "	ZAD_DTVEND ,  "+CRLF
	cQuery += "	ZAD_CPF ,  "+CRLF
	cQuery += "	ZAD_SEARCH ,  "+CRLF
	cQuery += "	ZAD_SLUID ,  "+CRLF
	cQuery += "	ZAD_TPTRAN  "+CRLF
	cQuery += "	ORDER BY ZAD_CPF ,  "+CRLF
	cQuery += "	ZAD_SLUID 		,  "+CRLF
	cQuery += "	ZAD_SEARCH		,   "+CRLF
	cQuery += "	ZAD_NFTOTV		, "+CRLF
	cQuery += "	ZAD_OBS   "			+CRLF

	DbUseArea( .T. , "TOPCONN" , TcGenQry(,,cQuery) , cAlias,.T.,.T.)

	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	oReport:SetMeter((cAlias)->(LastRec()))

	//Irei percorrer todos os meus registros
	While !(cAlias)->(Eof())

		If oReport:Cancel()
			Exit
		EndIf

		//inicializo a primeira seo
		oSection1:Init()

		oReport:IncMeter()

		IncProc("Gerando Relatorio ")

		//imprimo a primeira seção
		oSection1:init()

		oReport:IncMeter()

		IncProc("Imprimindo lista...")

		If MV_PAR06 == 2 .And. Alltrim((cAlias)->TP_ITEM)	== 'Cortesia'

			(cAlias)->(dbSkip())

			Loop

		EndIf

		oSection1:Cell("EPEP               ")  :SetValue((cAlias)->EPEP				)
		oSection1:Cell("EVENTO             ")  :SetValue((cAlias)->EVENTO			)
		oSection1:Cell("TP_MOVTO           ")  :SetValue((cAlias)->TP_MOVTO			)
		oSection1:Cell("TP_ITEM            ")  :SetValue((cAlias)->TP_ITEM			)
		oSection1:Cell("STATUS             ")  :SetValue((cAlias)->STATUS			)
		oSection1:Cell("DESCRICAO          ")  :SetValue((cAlias)->DESCRICAO		)
		oSection1:Cell("OBS                ")  :SetValue((cAlias)->OBS      		)
		oSection1:Cell("LOCALIZADOR        ")  :SetValue((cAlias)->LOCALIZADOR		)
		oSection1:Cell("ID_ITEM_VENDA      ")  :SetValue((cAlias)->ID_ITEM_VENDA	)
		oSection1:Cell("CPF"                )  :SetValue((cAlias)->CPF				)
		oSection1:Cell("DTVENDA            ")  :SetValue(stod((cAlias)->DTVENDA)	)

		cSerie	:= (cAlias)->SERIE
		cRPS	:= (cAlias)->RPS

		oSection1:Cell("SERIE"				)  :SetValue(cSerie         	)
		oSection1:Cell("RPS"				)  :SetValue(cRPS           	)

//		EndIf

		dbSelectArea("SF3")
		SF3->(DbSetOrder(5))
		SF3->(dbSetFilter({||SF3->F3_CFO > '4999'}," SF3->F3_CFO > '4999' "))

		If SF3->(MsSeek(xFilial("SF3")+cSerie+cRPS))

			If !Empty(SF3->F3_NFELETR) .And. Empty(SF3->F3_DTCANC)

				oSection1:Cell("STATUS")  :SetValue("RPS TRANSMITIDO")
			
			ElseIf !Empty(SF3->F3_DTCANC)

				oSection1:Cell("STATUS")  :SetValue("DOCUMENTO CANCELADO")

			EndIf

		EndIf
		
		DO CASE

		CASE Alltrim((cAlias)->TP_ITEM) == 'Ingresso'
			oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->VLR_INGRESSO, "@E 999,999.99")           			)
		CASE Alltrim((cAlias)->TP_ITEM) == 'Conveniencia'
			oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->VLR_CONVENIENCIA, "@E 999,999.99")         		)
		CASE Alltrim((cAlias)->TP_ITEM) $ 'Servicos.Socios'
			oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->(VLR_SERVICOS+VLR_TX_IMPRESSAO), "@E 999,999.99")	)
		CASE Alltrim((cAlias)->TP_ITEM) $ 'Socios'
			oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->(VLR_SOCIO), "@E 999,999.99")	)
		CASE Alltrim((cAlias)->TP_ITEM) == 'Doação'
			oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->(VLR_SERVICOS+VLR_TX_IMPRESSAO+VLR_INGRESSO), "@E 999,999.99")	)
		CASE Alltrim((cAlias)->TP_ITEM) == 'Entrega'
			If Alltrim((cAlias)->TP_MOVTO) == "Cancelado"
				oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->VLR_ENTREGA * -1, "@E 999,999.99"))
			Else
				oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->VLR_ENTREGA , "@E 999,999.99")          			)
			EndIf

		CASE Alltrim((cAlias)->TP_ITEM) == 'Assinaturas'
			oSection1:Cell("VALOR"			)  :SetValue(Transform((cAlias)->VLR_SERVICOS , "@E 999,999.99")          			)
		ENDCASE


		/*
		oSection1:Cell("VLR_INGRESSO"		)  :SetValue((cAlias)->VLR_INGRESSO    	)
		oSection1:Cell("VLR_CONVENIENCIA"	)  :SetValue((cAlias)->VLR_CONVENIENCIA	)
		oSection1:Cell("VLR_ENTREGA"		)  :SetValue((cAlias)->VLR_ENTREGA     	)
		oSection1:Cell("VLR_SERVICOS"		)  :SetValue((cAlias)->VLR_SERVICOS    	)
		oSection1:Cell("VLR_TX_IMPRESSAO"	)  :SetValue((cAlias)->VLR_TX_IMPRESSAO	)
		*/
		oSection1:Printline()

		(cAlias)->(dbSkip())

	EndDo
	
	//finalizo a primeira secao para que seja reiniciada para o proximo registro
	oSection1:Finish()

	(cAlias)->(dbCloseArea())
Return
