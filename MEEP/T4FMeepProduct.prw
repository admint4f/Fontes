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

User Function IMPROD(ZB0Num)

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
	Local cToken		:= ""

	Local cImgCod64	:= ""
	Local lAtivo	:=.F.

	Local aFiles := {} // O array receberá os nomes dos arquivos e do diretório
	Local aSizes := {} // O array receberá os tamanhos dos arquivos e do diretorio

	Private cJumpLin	:= Chr(13) + Chr(10)
	Private cEPEP		:= space(15)
	Private cDescEPEP	:= space(30)
	Private cLojaMeep	:= space(100) // Alessandra 03/03/22 '5A93CA2C-1FB3-BE3C-0551-C1F77E57A547'
	Private cLocal		:= space(2) //Alessandra 03/03/22  '05'
	Private cLocaliz	:= space(20)
	Private cTipoSaida	:= space(3)
	Private cGrpEmp		:= space(20)
	Private cFiliAtu	:= space(20) //Alessandra 03/03/22  '01'
	Private cTabPrec	:= space(3) // Alessandra 03/03/22 '002'
	Private lCtrlEst	:= .T.
	Private cState		:= "SP"

	cToken	:= U_MeepAuth()

	dbSelectArea("ZB0")
	dbSetOrder(2)
	IF dbSeek(xFilial("ZB0")+padr(ZB0Num,TAMSX3("ZB0_NUM")[1] ," ")) 
		cRet		:= .T.
		cDescEPEP	:= alltrim(ZB0_DESC)
		cLojaMeep	:= alltrim(ZB0_MEEP)
		cLocal		:= ZB0_LOCAL //ALESSANDRA 03/03/2022 cLocal		:= '05'
		// cLocaliz	:= ZB0_LOCALI
		cTabPrec	:= ZB0_TABPC //ALESSANDRA 03/03/2022 cTabPrec	:= '002'
		lCtrlEst	:= ZB0_CTEST
		cFiliAtu	:= ZB0_FIL // ALESSANDRA 03/03/2022  '01'
		cTipoSaida	:= ZB0_TES
		cGrpEmp		:= FwCodEmp() 
		lAtivo		:= IIF(ZB0_ATIVO == '1',.T.,.F.)
		lCtrlEst	:= .T. //ZB0_CTEST

	EndIf
	
	If lAtivo .and. lCtrlEst

		cQuery := " SELECT "
		cQuery += "		SB2.B2_COD, "
		cQuery += "		SB1.B1_DESC, "
		cQuery += "		SB1.B1_PRV1, "
		cQuery += "		SB1.B1_ESPECIF, "
		cQuery += "		SB1.B1_POSIPI, "
		cQuery += "		SB1.B1_CEST, "
		cQuery += "		SB1.B1_CODBAR, "
		cQuery += "		SB1.B1_BITMAP, "
		cQuery += "		SBM.BM_DESC, "
		cQuery += "		SUM(SB2.B2_QATU) AS B2_QATU "
		cQuery += " FROM "
		cQuery += "		"+RetSQLName( "SB2" )+" SB2 "
		cQuery += "     LEFT JOIN "+RetSQLName( "SB1" )+" SB1 ON ( "
		cQuery += "         SB2.B2_COD = SB1.B1_COD "
		// cQuery += "         AND SB1.B1_TIPO = 'MP' "
		cQuery += "         AND SB1.D_E_L_E_T_ <> '*' "
		cQuery += "     ) "
		cQuery += "     LEFT JOIN "+RetSQLName( "SBM" )+" SBM ON ( "
		cQuery += "         SBM.BM_GRUPO = SB1.B1_GRUPO "
		cQuery += "         AND SBM.D_E_L_E_T_ <> '*' "
		cQuery += "     ) "
		cQuery += " WHERE "
		cQuery += "		SB2.D_E_L_E_T_ <> '*' "
		cQuery += "		AND SB2.B2_FILIAL =  '"+cFiliAtu+"' "
		cQuery += "		AND SB2.B2_LOCAL = '"+cLocal+"' "
		// cQuery += "		AND SB2.B2_LOCALIZ = '"+cLocaliz+"' "
		// cQuery += "		AND SB2.B2_QATU <> 0 "
		cQuery += " GROUP BY "
		cQuery += "		SB2.B2_COD, "
		cQuery += "		SB1.B1_DESC, "
		cQuery += "		SB1.B1_PRV1, "
		cQuery += "		SB1.B1_ESPECIF, "
		cQuery += "		SB1.B1_POSIPI, "
		cQuery += "		SB1.B1_BITMAP, "
		cQuery += "		SB1.B1_CEST, "
		cQuery += "		SB1.B1_CODBAR, "
		cQuery += "		SBM.BM_DESC "
		TCQuery cQuery New Alias "ProdInAd"

		ProdInAd->(DbGoTop())
			Count To nTotProd
		ProdInAd->(DbGoTop())
			
		If ProdInAd->(!Eof())
			Aadd(aHeadProd, 'Authorization: Bearer '+cToken)
			AAdd(aHeadProd, "Content-Type: application/json")
			While ProdInAd->( !Eof() )
				IncProc("Integrando produto: "+alltrim(ProdInAd->B1_DESC))
				lRegZB2		:= .F.

				//Procura Código como Componente na SG1, se não acha cadastra como MP
				dbSelectArea("SG1")
				dbSetOrder(2)

				cFilSG1 := xFilial("SG1")
				
				If dbSeek(cFilSG1+ProdInAd->B2_COD)

					//Cadastro como estrutura, verifica se é Componente Principal
					If SG1->G1_ZPRINC == '1'

						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial("SB1")+padr(SG1->G1_COD,TAMSX3("B1_COD")[1] ," "))
							cAliqIpi	:= B1_IPI //LV
							cOrigem		:= B1_ORIGEM

							If	SB1->B1_PICMRET = 0
								cAliqICMS := SUPERGETMV('MV_ICMPAD ', .F.,0)
								cAliqMva  := 0
							Else 
								cAliqICMS := 0
								cAliqMva  := SB1->B1_PICMRET
							EndIF

						dbSelectArea("SB2")
						dbSetOrder(1)		//B2_LOCAL + B2_COD + B2_LOCAL
						dbSeek(xFilial("SB1")+padr(SG1->G1_COD,TAMSX3("B1_COD")[1] ," ")+cLocal)
						
						dbSelectArea("SF4")
						dbSetOrder(1)
						If dbSeek(xFilial("SF4")+SB1->B1_TS)
							cCFOP		:= SF4->F4_CF
							cIpiCST		:= SF4->F4_CTIPI
							cPisCST		:= SF4->F4_CSTPIS
							cCofCST		:= SF4->F4_CSTCOF
							cIcmCst		:= SF4->F4_SITTRIB
							cCstICM		:= cOrigem+cIcmCst
							If SF4->F4_PISCOF$'3' .AND. SF4->F4_PISCRED$'2'
								 cAliqPis := SUPERGETMV('MV_TXPIS', .F.,0)
								 cAliqCof := SUPERGETMV('MV_TXCOFIN', .F.,0)
							Else
								cAliqPis := 0
								cAliqCof := 0
							EndIf
						EndIf

						dbSelectArea("SBM")
						dbSetOrder(1)
						dbSeek(xFilial("SBM")+padr(SB1->B1_GRUPO,TAMSX3("BM_DESC")[1] ," "))

						dbSelectArea("DA1")
						dbSetOrder(1)
						If !dbSeek(xFilial("DA1")+padr(cTabPrec,TAMSX3("DA1_CODTAB")[1] ," ")+SB1->B1_COD)
							cText += +"Os seguintes produtos não foram encontrados na tabela de preço:"+_cEnter+_cEnter
							cText += +SB1->B1_COD+"	"+SB1->B1_DESC+_cEnter

							ProdInAd->(DbSkip())
							Loop
						Else
							nPrcVen		:= DA1->DA1_PRCVEN
						EndIf

						//Cadastro como PA
						dbSelectArea("ZB2")
						dbSetOrder(1)
						If !dbSeek(xFilial("ZB2")+padr(cLojaMeep,TAMSX3("ZB2_STORE")[1] ," ")+SB1->B1_COD)

							if !empty(SB1->B1_BITMAP)
								aSizes := {}
								if RepExtract(SB1->B1_BITMAP, "IntMeep.bmp",.T.,.T.)
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

							oJsonPostItens := JsonObject():New()
							oJsonPostItens["storeID"]   		:= cLojaMeep
							oJsonPostItens["name"]  			:= alltrim(SB1->B1_DESC)
							oJsonPostItens["inventoryControl"]  := .T.
							oJsonPostItens["value"] 			:= nPrcVen
							oJsonPostItens["integrationCode"] 	:= alltrim(SB1->B1_COD)
							oJsonPostItens["category"]			:= {}
							oJsonPostItens["cfop"] 				:= cCFOP
							oJsonPostItens["ncm"] 				:= alltrim(SB1->B1_POSIPI)
							oJsonPostItens["description"] 		:= alltrim(SB1->B1_ESPECIF)
							oJsonPostItens["barcode"] 			:= Alltrim(SB1->B1_CODBAR)
							oJsonPostItens["cest"] 				:= Alltrim(SB1->B1_CEST)
							oJsonPostItens["Image"] 			:= cImgCod64
							oJsonPostItens["taxSettings"] 		:= {}
							
							oJsonPostaxHead := JsonObject():New()
							oJsonPostaxHead["cfop"]				:= cCFOP
							oJsonPostaxHead["settings"]	:= JsonObject():New()
							oJsonPostaxHead["settings"]["ipi"] := JsonObject():New()
							oJsonPostaxHead["settings"]["ipi"]["cst"] := cIpiCST
							oJsonPostaxHead["settings"]["ipi"]["aliquot"] := cAliqIpi

							oJsonPostaxHead["settings"]["pis"] := JsonObject():New()
							oJsonPostaxHead["settings"]["pis"]["cst"] := cPisCST
							oJsonPostaxHead["settings"]["pis"]["aliquot"] := cAliqPis

							oJsonPostaxHead["settings"]["cofins"] := JsonObject():New()
							oJsonPostaxHead["settings"]["cofins"]["cst"] := cCofCST
							oJsonPostaxHead["settings"]["cofins"]["aliquot"] := cAliqCof
							
							oJsonPostaxHead["settings"]["icms"] := JsonObject():New()
							oJsonPostaxHead["settings"]["icms"]["states"] := {}
							Aadd(oJsonPostaxHead["settings"]["icms"]["states"], JsonObject():New())
							oJsonPostaxHead["settings"]["icms"]["states"][1]["state"] := cState
							oJsonPostaxHead["settings"]["icms"]["states"][1]["cst"] := cCstICM
							oJsonPostaxHead["settings"]["icms"]["states"][1]["isException"] := .T.
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquot"] := cAliqICMS
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotSt"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotMva"] := cAliqMva
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotIcmsNonContributors"] :=  0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotInternalUfDestination"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["percentageDeferral"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["percentageReductionBc"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["percentageReductionBcSt"] := 0
							
							oJsonPostItens["taxSettings"] := oJsonPostaxHead
														
							// oJsonPostItens["minimumStock"] 	:= 0
							// oJsonPostItens["maximumStock"] 	:= 0

							oJsonPostCategory := JsonObject():New()
							oJsonPostCategory["name"]  := alltrim(SBM->BM_DESC)
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
								ZB2->ZB2_COD		:=	alltrim(SB1->B1_COD)
								ZB2->ZB2_IDMEEP		:=	cIdMeep
								ZB2->ZB2_QTINT		:=	0
								ZB2->ZB2_STATUS		:=	cStatusInt
								ZB2->ZB2_TABPC		:=	cTabPrec
								ZB2->ZB2_PRECO		:=	nPrcVen
							ZB2->(MsUnlock())
						endif

						dbSelectArea("ZB2")
						dbSetOrder(1)
						If dbSeek(xFilial("ZB2")+padr(cLojaMeep,TAMSX3("ZB2_STORE")[1] ," ")+SB1->B1_COD)
							If ZB2_STATUS == "1" .OR. ZB2_STATUS == "2" .OR. ZB2_STATUS == "B"
								cQtdEstrut	:= ProdInAd->B2_QATU / SG1->G1_QUANT * SB1->B1_QB+SB2->B2_QATU
								If ZB2_QTINT <> cQtdEstrut
									nQtEnviar	:= cQtdEstrut - ZB2_QTINT
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
											ZB2->ZB2_QTINT		:=	cQtdEstrut
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

					Else
						//Se não for componente principal não faz nada
					EndIf
				Else
						//Cadastro como MP

						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial("SB1")+padr(ProdInAd->B2_COD,TAMSX3("B1_COD")[1] ," "))
							cAliqIpi	:= B1_IPI //LV
							cOrigem		:= B1_ORIGEM

							If	SB1->B1_PICMRET = 0
								cAliqICMS := SUPERGETMV('MV_ICMPAD ', .F.,0)
								cAliqMva  := 0
							Else 
								cAliqICMS := 0
								cAliqMva  := SB1->B1_PICMRET
							EndIF
						
						dbSelectArea("SF4")
						dbSetOrder(1)
						If dbSeek(xFilial("SF4")+SB1->B1_TS)
							cCFOP		:= SF4->F4_CF
							cIpiCST		:= SF4->F4_CTIPI
							cPisCST		:= SF4->F4_CSTPIS
							cCofCST		:= SF4->F4_CSTCOF
							cIcmCst		:= SF4->F4_SITTRIB
							cCstICM		:= cOrigem+cIcmCst
							If SF4->F4_PISCOF$'3' .AND. SF4->F4_PISCRED$'2'
								 cAliqPis := SUPERGETMV('MV_TXPIS', .F.,0)
								 cAliqCof := SUPERGETMV('MV_TXCOFIN', .F.,0)
							Else
								cAliqPis := 0
								cAliqCof := 0
							EndIf
						EndIf

					dbSelectArea("SBM")
					dbSetOrder(1)
					dbSeek(xFilial("SBM")+padr(SB1->B1_GRUPO,TAMSX3("BM_DESC")[1] ," "))

					dbSelectArea("DA1")
					dbSetOrder(1)
					If !dbSeek(xFilial("DA1")+padr(cTabPrec,TAMSX3("DA1_CODTAB")[1] ," ")+ProdInAd->B2_COD)
						cText += +"Os seguintes produtos não foram encontrados na tabela de preço:"+_cEnter+_cEnter
						cText += +ProdInAd->B2_COD+"	"+ProdInAd->B1_DESC+_cEnter
						ProdInAd->(DbSkip())
						Loop
					Else
						nPrcVen		:= DA1->DA1_PRCVEN
					EndIf

					dbSelectArea("ZB2")
					dbSetOrder(1)
					If !dbSeek(xFilial("ZB2")+padr(cLojaMeep,TAMSX3("ZB2_STORE")[1] ," ")+ProdInAd->B2_COD)
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

						oJsonPostItens := JsonObject():New()
						oJsonPostItens["storeID"]   		:= cLojaMeep
						oJsonPostItens["name"]  			:= alltrim(ProdInAd->B1_DESC)
						oJsonPostItens["inventoryControl"] := .T.
						oJsonPostItens["value"] 			:= nPrcVen
						oJsonPostItens["integrationCode"] 	:= alltrim(ProdInAd->B2_COD)
						oJsonPostItens["category"]			:= {}
						oJsonPostItens["cfop"] 				:= cCFOP
						oJsonPostItens["ncm"] 				:= alltrim(ProdInAd->B1_POSIPI)
						oJsonPostItens["description"] 		:= alltrim(ProdInAd->B1_ESPECIF)
						oJsonPostItens["barcode"] 			:= Alltrim(ProdInAd->B1_CODBAR)
						oJsonPostItens["cest"] 				:= Alltrim(ProdInAd->B1_CEST)
						oJsonPostItens["Image"] 			:= cImgCod64
							oJsonPostItens["taxSettings"] 		:= {}
							
							oJsonPostaxHead := JsonObject():New()
							oJsonPostaxHead["cfop"]				:= cCFOP
							oJsonPostaxHead["settings"]	:= JsonObject():New()
							oJsonPostaxHead["settings"]["ipi"] := JsonObject():New()
							oJsonPostaxHead["settings"]["ipi"]["cst"] := cIpiCST
							oJsonPostaxHead["settings"]["ipi"]["aliquot"] := cAliqIpi

							oJsonPostaxHead["settings"]["pis"] := JsonObject():New()
							oJsonPostaxHead["settings"]["pis"]["cst"] := cPisCST
							oJsonPostaxHead["settings"]["pis"]["aliquot"] := cAliqPis

							oJsonPostaxHead["settings"]["cofins"] := JsonObject():New()
							oJsonPostaxHead["settings"]["cofins"]["cst"] := cCofCST
							oJsonPostaxHead["settings"]["cofins"]["aliquot"] := cAliqCof
							
							oJsonPostaxHead["settings"]["icms"] := JsonObject():New()
							oJsonPostaxHead["settings"]["icms"]["states"] := {}
							Aadd(oJsonPostaxHead["settings"]["icms"]["states"], JsonObject():New())
							oJsonPostaxHead["settings"]["icms"]["states"][1]["state"] := cState
							oJsonPostaxHead["settings"]["icms"]["states"][1]["cst"] := cCstICM
							oJsonPostaxHead["settings"]["icms"]["states"][1]["isException"] := .T.
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquot"] := cAliqICMS
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotSt"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotMva"] := cAliqMva
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotIcmsNonContributors"] :=  0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["aliquotInternalUfDestination"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["percentageDeferral"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["percentageReductionBc"] := 0
							oJsonPostaxHead["settings"]["icms"]["states"][1]["percentageReductionBcSt"] := 0
							
							oJsonPostItens["taxSettings"] := oJsonPostaxHead

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
							ZB2->ZB2_COD		:=	alltrim(ProdInAd->B2_COD)
							ZB2->ZB2_IDMEEP		:=	cIdMeep
							ZB2->ZB2_QTINT		:=	0
							ZB2->ZB2_STATUS		:=	cStatusInt
							ZB2->ZB2_TABPC		:=	cTabPrec
							ZB2->ZB2_PRECO		:=	nPrcVen
						ZB2->(MsUnlock())
					endif

					dbSelectArea("ZB2")
					dbSetOrder(1)
					If dbSeek(xFilial("ZB2")+padr(cLojaMeep,TAMSX3("ZB2_STORE")[1] ," ")+ProdInAd->B2_COD)
						If ZB2_STATUS == "1" .OR. ZB2_STATUS == "2" .OR. ZB2_STATUS == "B"
							If ZB2_QTINT <> ProdInAd->B2_QATU
								nQtEnviar	:= ProdInAd->B2_QATU - ZB2_QTINT
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
										ZB2->ZB2_QTINT		:=	ProdInAd->B2_QATU
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

				EndIf	

				ProdInAd->(DbSkip())
			EndDo
/*
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

				// Aviso("Erros de transferências",cText,{'Ok'})
				MemoWrit("C:\temp\Meep-ErroIntEstoque"+cEPEP+"-"+DTOS(DATE())+"-"+SUBSTR(TIME(), 1, 2)+"h"+SUBSTR(TIME(), 4, 2)+".txt",cText)
			EndIf
			ErIntMeep->(dbCloseArea())
		// Else*/
			// MsgInfo("Não foram encontrados produtos no local especificado.")
		EndIf

		ProdInAd->(dbCloseArea())
		// If empty(cText)
		// 	MsgInfo("Integração concluida com sucesso!")
		// EndIf
	EndIf

Return
