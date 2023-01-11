#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_INT_MEEPINIT()                                           	|
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Menu de integração do estoque e produto para o software Meep	|
 *----------------------------------------------------------------------*/

User Function INT_MEEPINIT()
	Private cJumpLin	:= Chr(13) + Chr(10)
	Private cEPEP		:= space(15)
	Private cDescEPEP	:= space(30)
	Private cLojaMeep	:= space(100)
	Private cLocal		:= space(2)
	// Private cLocaliz	:= space(20)
	Private cTipoSaida	:= space(3)
	Private cGrpEmp		:= space(20)
	Private cFiliAtu	:= space(20)
	Private cTabPrec	:= space(3)
	Private lCtrlEst	:= .T.
	Private cDescGeral	:= 	"EPEP : "		+cEPEP+cJumpLin+;
							"Desc : "		+cDescEPEP+cJumpLin+;
							"Empresa : "	+cGrpEmp+cJumpLin+;
							"Filial : "		 +cFiliAtu+cJumpLin+; 
							"Local : "		+cLocal+cJumpLin
							// "Endereço : "	+cLocaliz

	DEFINE MSDIALOG oFiltro FROM 000,000 TO 220,265 TITLE Alltrim(OemToAnsi("Integração Meep")) Pixel

	oSayLn		:= tSay():New(0010,0012,{||"Elem PEP:"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
	oGet 		:= tGet():New(0008,0060,{|u| if(PCount()>0,cEPEP:=u,cEPEP)}, oFiltro,50,9,,{ || ValidaEPEP()  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,"cEPEP")

	@ 25,15 SAY oSayP PROMPT cDescGeral SIZE 100,50 OF oFiltro PIXEL

	@ 90, 0012 Button "Integrar Meep" Size 070, 15 PIXEL OF oFiltro Action Processa( {|| F_INT_MEEPINIT() }, "Aguarde","Carregando..." ) 
	@ 90, 0085 Button "Cancelar" Size 045, 015 PIXEL OF oFiltro Action Close(oFiltro)

	Activate Dialog oFiltro Centered

Return(.T.)

Static Function ValidaEPEP()
	Local cRet	:= .F.

	if !empty(alltrim(cEPEP))
		dbSelectArea("ZB0")
		dbSetOrder(1)
		IF dbSeek(xFilial("ZB0")+padr(cEPEP,TAMSX3("ZB0_EPEP")[1] ," ")+FwCodEmp()) 
			cRet		:= .T.
			cDescEPEP	:= alltrim(ZB0_DESC)
			cLojaMeep	:= alltrim(ZB0_MEEP)
			cLocal		:= ZB0_LOCAL
			// cLocaliz	:= ZB0_LOCALI
			cTabPrec	:= ZB0_TABPC
			lCtrlEst	:= ZB0_CTEST
			cFiliAtu	:= ZB0_FIL
			cTipoSaida	:= ZB0_TES
			cGrpEmp		:= FwCodEmp() 
			cDescGeral	:= 	"EPEP : "+cEPEP+cJumpLin+;
							"Desc : "+cDescEPEP+cJumpLin+;
							"Empresa : "+cGrpEmp+cJumpLin+;
							"Filial : "+cFiliAtu+cJumpLin+;
							"Local : "+cLocal+cJumpLin
							// "Endereço : "+cLocaliz
		else
			MsgAlert("Elem. PEP sem cadastro dos Dados Adicionais!","Integração Meep")
		endif
	Else
		cRet := .T.
	EndIf	
return(cRet)


Static Function F_INT_MEEPINIT()
	Local cQuery
	Local aHeadProd 	:= {}
    Local cUrlMeep      := SuperGetMV("MV_MPURL",.T.,"https://server.meep.cloud")
	Local oRestClient 	:= FWRest():New(cUrlMeep)
	Local oJsonPostItens
	Local oPostInvHead
	Local oPostInvItens
	Local cStatusInt	:= 0
	Local cPostRet		:= ""
	Local oJsonPostCategory
	Local cPosta		:= ''
	Local lRegZB2		:= .F.
	Local nPrcVen		:= 0
	Local nQtEnviar		:= 0
	Local cText			:= ""
	Local _cEnter   	:= CHR(13)+CHR(10)
	Local nTotProd		:= 0

	Local cImgCod64	:= ""

	Local lDA1Exist		:= .T.

	Local aFiles := {} // O array receberá os nomes dos arquivos e do diretório
	Local aSizes := {} // O array receberá os tamanhos dos arquivos e do diretorio

	Close(oFiltro)

if !empty(alltrim(cEPEP)) 
	dbSelectArea("SF4")
	dbSetOrder(1)
	If dbSeek(xFilial("SF4")+cTipoSaida)
		cCFOP		:= SF4->F4_CF
	EndIf
	If lCtrlEst
		cQuery := " SELECT "
		cQuery += "		SBF.BF_PRODUTO, "
		cQuery += "		SB1.B1_DESC, "
		cQuery += "		SB1.B1_PRV1, "
		cQuery += "		SB1.B1_ESPECIF, "
		cQuery += "		SB1.B1_POSIPI, "
		cQuery += "		SB1.B1_CEST, "
		cQuery += "		SB1.B1_CODBAR, "
		cQuery += "		SB1.B1_BITMAP, "
		cQuery += "		SBM.BM_DESC, "
		cQuery += "		SBF.BF_LOCALIZ, "
		cQuery += "		SUM(SBF.BF_QUANT) AS BF_QUANT "
		cQuery += " FROM "
		cQuery += "		"+RetSQLName( "SBF" )+" SBF "
		cQuery += "     LEFT JOIN "+RetSQLName( "SB1" )+" SB1 ON ( "
		cQuery += "         SBF.BF_PRODUTO = SB1.B1_COD "
		cQuery += "         AND SB1.D_E_L_E_T_ <> '*' "
		cQuery += "     ) "
		cQuery += "     LEFT JOIN "+RetSQLName( "SBM" )+" SBM ON ( "
		cQuery += "         SBM.BM_GRUPO = SB1.B1_GRUPO "
		cQuery += "         AND SBM.D_E_L_E_T_ <> '*' "
		cQuery += "     ) "
		cQuery += " WHERE "
		cQuery += "		SBF.D_E_L_E_T_ <> '*' "
		cQuery += "		AND SBF.BF_FILIAL =  '"+xFilial("SBF")+"' "
		cQuery += "		AND SBF.BF_LOCAL = '"+cLocal+"' "
		// cQuery += "		AND SBF.BF_LOCALIZ = '"+cLocaliz+"' "
		cQuery += "		AND SBF.BF_QUANT <> 0 "
		cQuery += " GROUP BY "
		cQuery += "		SBF.BF_PRODUTO, "
		cQuery += "		SB1.B1_DESC, "
		cQuery += "		SB1.B1_PRV1, "
		cQuery += "		SB1.B1_ESPECIF, "
		cQuery += "		SB1.B1_POSIPI, "
		cQuery += "		SB1.B1_BITMAP, "
		cQuery += "		SB1.B1_CEST, "
		cQuery += "		SB1.B1_CODBAR, "
		cQuery += "		SBM.BM_DESC, "
		cQuery += "		SBF.BF_LOCALIZ "
		TCQuery cQuery New Alias "ProdInAd"

		ProdInAd->(DbGoTop())
			Count To nTotProd
		ProdInAd->(DbGoTop())
		
		ProcRegua(nTotProd)

		// TODO Verificar se Tabela de Preço existe e se todos os produtos estão nelas
		ProdInAd->(DbGoTop())
		If ProdInAd->(!Eof())
			While ProdInAd->( !Eof() )
				dbSelectArea("DA1")
				dbSetOrder(1)
				If !dbSeek(xFilial("DA1")+padr(cTabPrec,TAMSX3("DA1_CODTAB")[1] ," ")+ProdInAd->BF_PRODUTO)
					If lDA1Exist
						cText := "Integração não foi realizada "+_cEnter
						cText += +"Os seguintes produtos não foram encontrados na tabela de preço:"+_cEnter+_cEnter
					EndIf
					cText += +ProdInAd->BF_PRODUTO+"	"+ProdInAd->B1_DESC+_cEnter
					lDA1Exist := .F.
				EndIf
				ProdInAd->(DbSkip())
			EndDo
		EndIf

		if !lDA1Exist
			cText += +_cEnter+_cEnter+"Foi salvo um arquivo com esta informação C:\temp\"
			Aviso("Produtos sem preços definidos",cText,{'Ok'})
			MemoWrit("C:\temp\Meep-ErroIntEstoque"+cEPEP+"-"+DTOS(DATE())+"-"+SUBSTR(TIME(), 1, 2)+"h"+SUBSTR(TIME(), 4, 2)+".txt",cText)
			return
		endif

		ProdInAd->(DbGoTop())
		
		If ProdInAd->(!Eof())
			cToken	:= U_MeepAuth()

			Aadd(aHeadProd, 'Authorization: Bearer '+cToken)
			AAdd(aHeadProd, "Content-Type: application/json")
			While ProdInAd->( !Eof() )
				IncProc("Integrando produto: "+alltrim(ProdInAd->B1_DESC))
				lRegZB2		:= .F.
				dbSelectArea("DA1")
				dbSetOrder(1)
				If dbSeek(xFilial("DA1")+padr(cTabPrec,TAMSX3("DA1_CODTAB")[1] ," ")+ProdInAd->BF_PRODUTO)
					nPrcVen		:= DA1->DA1_PRCVEN
				else
					nPrcVen		:= 0
				EndIf
				if !empty(ProdInAd->B1_BITMAP)
					aSizes := {}
					if RepExtract(ProdInAd->B1_BITMAP, "IntMeep.bmp",.T.,.T.)
						ADir("IntMeep.bmp", aFiles, aSizes)
						nHandle := fopen("IntMeep.bmp" , FO_READWRITE + FO_SHARED )
						cString := ""
						FRead( nHandle, cString, aSizes[1] )
						cImgCod64	:= Encode64(cString)
						fclose(nHandle)
						FErase("IntMeep.bmp")
					endif
				else
					cImgCod64 := ""
				endif
				dbSelectArea("ZB2")
				dbSetOrder(1)
				If !dbSeek(xFilial("ZB2")+padr(cLojaMeep,TAMSX3("ZB2_STORE")[1] ," ")+ProdInAd->BF_PRODUTO)
					oJsonPostItens := JsonObject():New()
					oJsonPostItens["storeID"]   		:= cLojaMeep
					oJsonPostItens["name"]  			:= alltrim(ProdInAd->B1_DESC)
					oJsonPostItens["inventoryControl"] := .T.
					oJsonPostItens["value"] 			:= nPrcVen
					oJsonPostItens["integrationCode"] 	:= alltrim(ProdInAd->BF_PRODUTO)
					oJsonPostItens["category"]			:= {}
					oJsonPostItens["cfop"] 				:= cCFOP
					oJsonPostItens["ncm"] 				:= alltrim(ProdInAd->B1_POSIPI)
					oJsonPostItens["description"] 		:= alltrim(ProdInAd->B1_ESPECIF)
					oJsonPostItens["barcode"] 			:= Alltrim(ProdInAd->B1_CODBAR)
					oJsonPostItens["cest"] 				:= Alltrim(ProdInAd->B1_CEST)
					oJsonPostItens["Image"] 			:= cImgCod64
					// oJsonPostItens["minimumStock"] 	:= 0
					// oJsonPostItens["maximumStock"] 	:= 0

					oJsonPostCategory := JsonObject():New()
					oJsonPostCategory["name"]  := alltrim(ProdInAd->BM_DESC)
					oJsonPostItens["category"]	:= oJsonPostCategory

					cPosta := oJsonPostItens:ToJson()

					oRestClient:setPath("/api/third/product")
					oRestClient:SetPostParams(cPosta)
					if oRestClient:Post(aHeadProd)
						cStatusInt := "1"
						cPostRet := (oRestClient:GetResult())
						oJsonRet := JsonObject():New()
						oJsonRet:FromJson(cPostRet)
						cIDMeep := oJsonRet:GetJSonObject('id')
					else
						cPostRet := (oRestClient:GetLastError())
						cStatusInt 	:= "A"
						cIDMeep		:= ""
					Endif

					RecLock("ZB2", .T.)
						ZB2->ZB2_STORE		:=	cLojaMeep
						ZB2->ZB2_COD		:=	alltrim(ProdInAd->BF_PRODUTO)
						ZB2->ZB2_IDMEEP		:=	cIdMeep
						ZB2->ZB2_QTINT		:=	0
						ZB2->ZB2_STATUS		:=	cStatusInt
						ZB2->ZB2_TABPC		:=	cTabPrec
						ZB2->ZB2_PRECO		:=	nPrcVen
					ZB2->(MsUnlock())

					lRegZB2		:= .T.
				else
					oJsonPostItens := JsonObject():New()
					oJsonPostItens["storeID"]   		:= cLojaMeep
					oJsonPostItens["id"]   				:= alltrim(ZB2->ZB2_IDMEEP)
					oJsonPostItens["name"]  			:= alltrim(ProdInAd->B1_DESC)
					oJsonPostItens["inventoryControl"] := .T.
					oJsonPostItens["value"] 			:= nPrcVen
					oJsonPostItens["integrationCode"] 	:= alltrim(ProdInAd->BF_PRODUTO)
					oJsonPostItens["category"]			:= {}
					oJsonPostItens["cfop"] 				:= cCFOP
					oJsonPostItens["ncm"] 				:= alltrim(ProdInAd->B1_POSIPI)
					oJsonPostItens["description"] 		:= alltrim(ProdInAd->B1_ESPECIF)
					oJsonPostItens["barcode"] 			:= Alltrim(ProdInAd->B1_CODBAR)
					oJsonPostItens["cest"] 				:= Alltrim(ProdInAd->B1_CEST)
					oJsonPostItens["Image"] 			:= cImgCod64
					// oJsonPostItens["minimumStock"] 	:= 0
					// oJsonPostItens["maximumStock"] 	:= 0

					oJsonPostCategory := JsonObject():New()
					oJsonPostCategory["name"]  := alltrim(ProdInAd->BM_DESC)
					oJsonPostItens["category"]	:= oJsonPostCategory

					cPosta := oJsonPostItens:ToJson()

					oRestClient:setPath("/api/third/product")
					oRestClient:SetPostParams(cPosta)
					if oRestClient:Post(aHeadProd)
						cStatusInt 	:= ZB2->ZB2_STATUS
						cPostRet 	:= (oRestClient:GetResult())
						oJsonRet 	:= JsonObject():New()
						oJsonRet:FromJson(cPostRet)
						cIDMeep 	:= oJsonRet:GetJSonObject('id')
					else
						cPostRet := (oRestClient:GetLastError())
						cStatusInt 	:= "A"
						cIDMeep		:= ""
					Endif

					If ZB2->ZB2_STATUS == "A"
						RecLock("ZB2", .F.)
							ZB2->ZB2_STATUS		:=	"1"
							ZB2->ZB2_IDMEEP		:=	cIDMeep
							ZB2->ZB2_TABPC		:=	cTabPrec
							ZB2->ZB2_PRECO		:=	nPrcVen
						ZB2->(MsUnlock())
					Else
						RecLock("ZB2", .F.)
							ZB2->ZB2_STATUS		:=	cStatusInt
							ZB2->ZB2_TABPC		:=	cTabPrec
							ZB2->ZB2_PRECO		:=	nPrcVen
						ZB2->(MsUnlock())
					EndIf

					lRegZB2		:= .T.
				endif

				dbSelectArea("ZB2")
				dbSetOrder(1)
				If dbSeek(xFilial("ZB2")+padr(cLojaMeep,TAMSX3("ZB2_STORE")[1] ," ")+ProdInAd->BF_PRODUTO)
					If ZB2_STATUS == "A" .and. !lRegZB2
						dbSelectArea("DA1")
						dbSetOrder(1)
						If dbSeek(xFilial("DA1")+padr(cTabPrec,TAMSX3("DA1_CODTAB")[1] ," ")+ProdInAd->BF_PRODUTO)
							nPrcVen		:= DA1->DA1_PRCVEN
						else
							nPrcVen		:= 0
						EndIf

						oJsonPostItens := JsonObject():New()
						oJsonPostItens["storeID"]   		:= cLojaMeep
						oJsonPostItens["name"]  			:= alltrim(ProdInAd->B1_DESC)
						oJsonPostItens["inventoryControl"] := .T.
						oJsonPostItens["value"] 			:= nPrcVen
						oJsonPostItens["integrationCode"] 	:= alltrim(ProdInAd->BF_PRODUTO)
						oJsonPostItens["category"]			:= {}
						oJsonPostItens["cfop"] 			:= cCFOP
						oJsonPostItens["ncm"] 				:= alltrim(ProdInAd->B1_POSIPI)
						oJsonPostItens["description"] 		:= alltrim(ProdInAd->B1_ESPECIF)
						oJsonPostItens["barcode"] 			:= Alltrim(ProdInAd->B1_CODBAR)
						oJsonPostItens["cest"] 				:= Alltrim(ProdInAd->B1_CEST)
						oJsonPostItens["Image"] 			:= cImgCod64
						// oJsonPostItens["minimumStock"] 	:= 0
						// oJsonPostItens["maximumStock"] 	:= 0

						oJsonPostCategory := JsonObject():New()
						oJsonPostCategory["name"]  			:= alltrim(ProdInAd->BM_DESC)

						oJsonPostItens["category"]			:= oJsonPostCategory

						cPosta := oJsonPostItens:ToJson()

						oRestClient:setPath("/api/third/product")
						oRestClient:SetPostParams(cPosta)
						if oRestClient:Post(aHeadProd)
							cPostRet := (oRestClient:GetResult())
							oJsonRet := JsonObject():New()
							oJsonRet:FromJson(cPostRet)
							cIDMeep := oJsonRet:GetJSonObject('id')
							RecLock('ZB2', .F.)
								ZB2->ZB2_STORE		:=	cLojaMeep
								ZB2->ZB2_COD		:=	alltrim(ProdInAd->BF_PRODUTO)
								ZB2->ZB2_IDMEEP		:=	cIdMeep
								ZB2->ZB2_QTINT		:=	0
								ZB2->ZB2_STATUS		:=	"1"
								ZB2->ZB2_PRECO		:=	nPrcVen
							ZB2->(MsUnlock())
						else
							cPostRet := (oRestClient:GetLastError())
							cIDMeep		:= ""
						Endif
					EndIf
					If ZB2_STATUS == "1" .OR. ZB2_STATUS == "2" .OR. ZB2_STATUS == "B"
						If ZB2_QTINT <> ProdInAd->BF_QUANT
							nQtEnviar	:= ProdInAd->BF_QUANT - ZB2_QTINT
							oPostInvHead := JsonObject():New()
							oPostInvHead["StoreId"]   		:= cLojaMeep
							oPostInvHead["Itens"]			:= {}
							Aadd(oPostInvHead["Itens"],JsonObject():new())

							oPostInvItens := JsonObject():New()
							oPostInvHead["Itens"][1]["productId"]  	:= ALLTRIM(ZB2_IDMEEP)
							oPostInvHead["Itens"][1]["quantity"]  		:= nQtEnviar
							// oPostInvHead["Itens"]			:= oPostInvItens
							// aadd(oPostInvItens,oPostInvHead["Itens"])

							cPosta := oPostInvHead:ToJson()

							oRestClient:setPath("/api/inventory/InOrOut")
							oRestClient:SetPostParams(cPosta)
							if oRestClient:Post(aHeadProd)
								cPostRet := (oRestClient:GetResult())
								oJsonRet := JsonObject():New()
								oJsonRet:FromJson(cPostRet)
								RecLock('ZB2', .F.)
									ZB2->ZB2_QTINT		:=	ProdInAd->BF_QUANT
									ZB2->ZB2_QTENV		:=	ZB2->ZB2_QTENV+nQtEnviar
									ZB2->ZB2_STATUS		:=	"2"
								ZB2->(MsUnlock())
							else
								RecLock('ZB2', .F.)
									cPostRet := (oRestClient:GetLastError())
									ZB2->ZB2_STATUS		:=	"B"
								ZB2->(MsUnlock())
							Endif
						EndIf
					EndIf
				EndIf
				ProdInAd->(DbSkip())
			EndDo

			cQuery := " SELECT "
			cQuery += "		ZB2.ZB2_COD, "
			cQuery += "		ZB2.ZB2_STATUS "
			cQuery += " FROM "
			cQuery += "		"+RetSQLName( "ZB2" )+" ZB2 "
			cQuery += " WHERE "
			cQuery += "		ZB2.D_E_L_E_T_ <> '*' "
			cQuery += "		AND ZB2.ZB2_FILIAL 	=  '"+xFilial("ZB2")+"' "
			cQuery += "		AND ZB2.ZB2_STATUS 	IN ('A','B') "
			cQuery += "		AND ZB2.ZB2_STORE 	= '"+cLojaMeep+"' "
			cQuery += " ORDER BY "
			cQuery += "		ZB2.ZB2_COD, "
			cQuery += "		ZB2.ZB2_STATUS "
			TCQuery cQuery New Alias "ErIntMeep"

			ErIntMeep->(DbGoTop())
			If ErIntMeep->(!Eof())
				cText := "Ocorreram problemas na integração dos produtos: "+_cEnter
				While ErIntMeep->( !Eof() )
					cText += +_cEnter+"Produto: "+alltrim(ErIntMeep->ZB2_COD)+"		Código: "+alltrim(ErIntMeep->ZB2_STATUS)
					ErIntMeep->(DbSkip())
				EndDo
				cText += +_cEnter+_cEnter+"Tipos de erros:"
				cText += +_cEnter+"A - Erro de Cadastro do Produto"
				cText += +_cEnter+"B - Erro de Integração do Estoque"
				cText += +_cEnter+_cEnter+"Foi salvo um arquivo com esta informação C:\temp\"

				Aviso("Erros de transferências",cText,{'Ok'})
				MemoWrit("C:\temp\Meep-ErroIntEstoque"+cEPEP+"-"+DTOS(DATE())+"-"+SUBSTR(TIME(), 1, 2)+"h"+SUBSTR(TIME(), 4, 2)+".txt",cText)
			EndIf
			ErIntMeep->(dbCloseArea())
		Else
			MsgInfo("Não foram encontrados produtos no local especificado.")
		EndIf
		ProdInAd->(dbCloseArea())
		If empty(cText)
			MsgInfo("Integração concluida com sucesso!")
		EndIf
	else			//================================================NAO CONTROLA ESTOQUE
		MsgInfo("EPEP configurado para não controlar estoque")
	EndIf
EndIf
Return

