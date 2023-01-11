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

User Function IMAtuPrice()
	Private cJumpLin	:= Chr(13) + Chr(10)
	Private cNumLocal	:= space(6)
	Private cDescGeral	:= space(30)
	Private cDescProd	:= space(30)
	Private nValorNovo	:= 0
	Private cCodProd	:= space(15)

	DEFINE MSDIALOG oFiltro FROM 000,000 TO 220,265 TITLE Alltrim(OemToAnsi("Integração Meep")) Pixel

	oSayLn		:= tSay():New(0010,0012,{||"Num Local:"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
	oGet 		:= tGet():New(0008,0050,{|u| if(PCount()>0,cNumLocal:=u,cNumLocal)}, oFiltro,60,9,,{ || BuscaLocal() },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"ZZB0","cNumLocal")
	oGet 		:= tGet():New(999,999,{|u| if(PCount()>0,cDescGeral,cDescGeral)}, oFiltro,100,9  ,    ,{ ||  }, ,,,   ,,.T.,,   , {|| .T. } ,   ,   ,,.T.   ,,"","")
	@ 0023,0020 SAY oSayP PROMPT cDescGeral SIZE 100,50 OF oFiltro PIXEL

	oSayLn		:= tSay():New(0035,0012,{||"Cód Prod:"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
	oGet2 		:= TGet():New(0035,0050, { | u | If( PCount() == 0, cCodProd, cCodProd := u ) },oFiltro, 075, 010,,{ || BuscaProd() }, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,"SB1","cCodProd",,,,.T.  )
	@ 0048,0020 SAY oSayP PROMPT cDescProd SIZE 100,50 OF oFiltro PIXEL

	oSayLn		:= tSay():New(0060,0012,{||"Novo Preço:"},oFiltro,,,,,,.T.,CLR_BLACK,CLR_RED,60,20)
	oGet2 		:= TGet():New(0060,0060, { | u | If( PCount() == 0, nValorNovo, nValorNovo := u ) },oFiltro, 060, 010, "@E 99,999.99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nValorNovo",,,,.T.  )

	@ 90, 0012 Button "Integrar Meep" Size 070, 15 PIXEL OF oFiltro Action Processa( {|| IMEEPPRICE() }, "Aguarde","Carregando..." ) 
	@ 90, 0085 Button "Cancelar" Size 045, 015 PIXEL OF oFiltro Action Close(oFiltro)

	Activate Dialog oFiltro Centered

Return(.T.)

Static Function BuscaLocal()
	Local lRet	:= .F.

	if !empty(alltrim(cNumLocal))
		dbSelectArea("ZB0")
		dbSetOrder(2)
		IF dbSeek(xFilial("ZB0")+padr(cNumLocal,TAMSX3("ZB0_NUM")[1] ," ")) 
			cDescGeral	:= ZB0->ZB0_DESC
			lRet := .T.
		else
			MsgAlert("Numero invalido","[Integração Meep]")
		endif
	Else
		lRet := .T.
	EndIf	
return(lRet)


Static Function BuscaProd()
	Local lRet	:= .F.

	if !empty(alltrim(cCodProd))
		dbSelectArea("SB1")
		dbSetOrder(1)
		IF dbSeek(xFilial("SB1")+padr(AllTrim(cCodProd),TAMSX3("B1_COD")[1] ," ")) 
			cDescProd	:= SB1->B1_DESC
			lRet		:= .T.
		else
			MsgAlert("Codigo invalido","[Integração Meep]")
		endif
	Else
		lRet := .T.
	EndIf	
return(lRet)


Static Function IMEEPPRICE()
	Local aHeadProd 	:= {}
    Local cUrlMeep      := SuperGetMV("MV_MPURL",.T.,"https://server.meep.cloud")
	Local oRestClient 	:= FWRest():New(cUrlMeep)
	Local oJsonPostItens
	Local cPostRet		:= ""
	Local oJsonPostCategory
	Local cPosta		:= ''
	// Local cImgCod64		:= ""
	// Local cCFOP			:= ""

	If nValorNovo == 0
		MsgAlert("Valor invalido","[Integração Meep]")
		return
	EndIf

	dbSelectArea("ZB0")
	dbSetOrder(2)
	dbSeek(xFilial("ZB0")+padr(AllTrim(cNumLocal),TAMSX3("ZB0_NUM")[1] ," ")) 

	dbSelectArea("ZB2")
	dbSetOrder(1)
	If dbSeek(xFilial("ZB2")+padr(ZB0->ZB0_MEEP,TAMSX3("ZB2_STORE")[1] ," ")+PadR(AllTrim(cCodProd),15," "))

		cToken	:= U_MeepAuth()

		Aadd(aHeadProd, 'Authorization: Bearer '+cToken)
		AAdd(aHeadProd, "Content-Type: application/json")

		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+padr(AllTrim(cCodProd),TAMSX3("B1_COD")[1] ," "))

		dbSelectArea("SBM")
		dbSetOrder(1)
		dbSeek(xFilial("SBM")+padr(SB1->B1_GRUPO,TAMSX3("BM_DESC")[1] ," "))

		////Atualização da imagem do produto
		// if !empty(SB1->B1_BITMAP)
		// 	aSizes := {}
		// 	if RepExtract(SB1->B1_BITMAP, "IntMeep.bmp",.T.,.T.)
		// 		ADir("IntMeep.bmp", aFiles, aSizes)
		// 		nHandle := fopen("IntMeep.bmp" , FO_READWRITE + FO_SHARED )
		// 		cString := ""
		// 		FRead( nHandle, cString, aSizes[1] )
		// 		cImgCod64	:= Encode64(cString)
		// 		fclose(nHandle)
		// 		FErase("IntMeep.bmp")
		// 	endif
		// else
		// 	cImgCod64 := ""
		// endif

		////Atualização do CFOP
		// dbSelectArea("SF4")
		// dbSetOrder(1)
		// If dbSeek(xFilial("SF4")+ZB0->ZB0_TES)
		// 	cCFOP		:= SF4->F4_CF
		// EndIf

		oJsonPostItens := JsonObject():New()
		oJsonPostItens["storeID"]   		:= AllTrim(ZB0->ZB0_MEEP)
		oJsonPostItens["id"]   				:= AllTrim(ZB2->ZB2_IDMEEP)
		oJsonPostItens["name"]  			:= alltrim(SB1->B1_DESC)
		// oJsonPostItens["inventoryControl"] 	:= .T.
		oJsonPostItens["value"] 			:= nValorNovo
		// oJsonPostItens["integrationCode"] 	:= alltrim(SB1->B1_COD)
		// oJsonPostItens["category"]			:= {}
		// oJsonPostItens["cfop"] 				:= cCFOP
		// oJsonPostItens["ncm"] 				:= alltrim(SB1->B1_POSIPI)
		// oJsonPostItens["description"] 		:= alltrim(SB1->B1_ESPECIF)
		// oJsonPostItens["barcode"] 			:= Alltrim(SB1->B1_CODBAR)
		// oJsonPostItens["cest"] 				:= Alltrim(SB1->B1_CEST)
		// oJsonPostItens["Image"] 			:= cImgCod64
		// oJsonPostItens["minimumStock"] 	:= 0
		// oJsonPostItens["maximumStock"] 	:= 0

		oJsonPostCategory := JsonObject():New()
		// oJsonPostCategory["name"]  			:= alltrim(SBM->BM_DESC)

		oJsonPostItens["category"]			:= oJsonPostCategory

		cPosta := oJsonPostItens:ToJson()

		oRestClient:setPath("/api/third/product")
		oRestClient:SetPostParams(cPosta)
		if oRestClient:Post(aHeadProd)
			cPostRet := (oRestClient:GetResult())
			oJsonRet := JsonObject():New()
			oJsonRet:FromJson(cPostRet)
			RecLock('ZB2', .F.)
				ZB2->ZB2_PRECO		:=	nValorNovo
			ZB2->(MsUnlock())

			MsgInfo("Preço do produto "+AllTrim(cDescProd)+" atualizado com sucesso.","[Integracao Meep]")

			dbSelectArea("DA1")
			dbSetOrder(1)
			If dbSeek(xFilial("DA1")+padr(ZB0->ZB0_TABPC,TAMSX3("DA1_CODTAB")[1] ," ")+PadR(AllTrim(cCodProd),15," "))
				RecLock('DA1', .F.)
					DA1->DA1_PRCVEN		:=	nValorNovo
				DA1->(MsUnlock())
			EndIf

			// cNumLocal	:= space(6)
			// cDescGeral	:= space(30)
			cCodProd	:= space(15)
			cDescProd	:= space(30)
			nValorNovo	:= 0

		else
			MsgAlert("Ocorreu um erro desconhecido.","[Integracao Meep]")
			cPostRet := (oRestClient:GetLastError())
		Endif
	Else
		MsgAlert("Produto não está integrado com o Meep","[Integracao Meep]")
		
		cCodProd	:= space(15)
		cDescProd	:= space(30)
	EndIf

Return
