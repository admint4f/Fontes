#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_IMCadZBM()                                           	    |
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Rotina responsável por consultar a API do Meep de Vendas e 	|
 |        gerar as tabelas ZBM, ZBN e ZBP para início da integração. 	|
 | Parm:  dDataInt: Dia da emissão dos cupons, se vazio, utilizará o 	|
 |                  dia atual.                                       	|
 |        cHrInt:   Horário atual, quando passado será considerado duas |
 |                  horas atrás do informado. Quando não informado será |
 |                  integrado o dia inteiro.                            |
 *----------------------------------------------------------------------*/

User Function IMAtuZBM(dDataInt,cHrInt)
    Local cUrl := {}
    Local cUrl1,cUrl2,cUrl3,cUrl4,cUrl5,cUrl6,cUrl7,cUrl8
    Local cPage         := 0
    Local bLoop         := .T.
    Local i             := 0
    Local cToken        := ""

    Local oMeep
    Local nTotal        := 0

    Local aHeadProd     := {}
	Local cPostRet		:= ""
    Local cUrlMeep      := ""
    Local oRestClient

    Local cDiaInt           := date()
    Local cMesInt           := date()
    Local cAnoInt           := date()

    Local aASD2:={},aASFT:={},aASF3:={},k,m

    Default cHrInt          := ""
    Default dDataInt        := date()

    PREPARE ENVIRONMENT EMPRESA "20" FILIAL "01" MODULO "LOJA"

    oMeep         := JsonObject():New()
    nTotal        := 0

    aHeadProd     := {}
	cPostRet		:= ""
    cUrlMeep      := SuperGetMV("MV_MPURL",.F.,"https://server.meep.cloud")
    oRestClient   := FWRest():New(cUrlMeep)

    cDiaInt           := Day2Str(dDataInt)
    cMesInt           := Month2Str(dDataInt)
    cAnoInt           := Year2Str(dDataInt)

    cToken	:= U_MeepAuth()

    cDiaInt       := Day2Str(dDataInt)
    cMesInt       := Month2Str(dDataInt)
    cAnoInt       := Year2Str(dDataInt)

    Aadd(aHeadProd, 'Authorization: Bearer '+cToken)

    cPage := 1

        //cUrl1 := "/api/third/sales?Start=2021-"+cMesInt+"-01T03%3A00%3A00.000&End=2021-"+cMesInt+"-04T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        //cUrl2 := "/api/third/sales?Start=2021-"+cMesInt+"-05T03%3A00%3A00.000&End=2021-"+cMesInt+"-08T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        //cUrl3 := "/api/third/sales?Start=2021-"+cMesInt+"-09T03%3A00%3A00.000&End=2021-"+cMesInt+"-12T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        //cUrl4 := "/api/third/sales?Start=2021-"+cMesInt+"-13T03%3A00%3A00.000&End=2021-"+cMesInt+"-16T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        //cUrl5 := "/api/third/sales?Start=2021-"+cMesInt+"-17T03%3A00%3A00.000&End=2021-"+cMesInt+"-20T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        cUrl6 := "/api/third/sales?Start=2021-"+cMesInt+"-21T03%3A00%3A00.000&End=2021-"+cMesInt+"-24T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        cUrl7 := "/api/third/sales?Start=2021-"+cMesInt+"-25T03%3A00%3A00.000&End=2021-"+cMesInt+"-28T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        cUrl8 := "/api/third/sales?Start=2021-"+cMesInt+"-29T03%3A00%3A00.000&End=2021-"+cMesInt+"-31T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
        
        //Aadd(cUrl,{cUrl1})
        //Aadd(cUrl,{cUrl2})
        //Aadd(cUrl,{cUrl3})
        //Aadd(cUrl,{cUrl4})
        //Aadd(cUrl,{cUrl5})
        Aadd(cUrl,{cUrl6})
        Aadd(cUrl,{cUrl7})
        Aadd(cUrl,{cUrl8})


    While bLoop
       /* If empty(cHrInt)
            cUrl    := "/api/third/sales?Start="+cAnoInt+"-"+cMesInt+"-"+cDiaInt+"T00:00:00.000Z"+;
                                         "&End="+cAnoInt+"-"+cMesInt+"-"+cDiaInt+"T23:59:59.999Z"+;
                                        "&Page="+cvaltochar(cPage)+"&Count=500"
        Else
            If val(cHrInt) == 23
                cHrMeep := "00"
                cDiaInt     := Day2Str(dDataInt+1)
                cMesInt     := Month2Str(dDataInt+1)
                cAnoInt     := Year2Str(dDataInt+1)
            Else
                cHrMeep     := Padl(cValToChar(cvaltochar(val(cHrInt)+1)),2,"0")
                cDiaInt     := Day2Str(dDataInt)
                cMesInt     := Month2Str(dDataInt)
                cAnoInt     := Year2Str(dDataInt)
            EndIf
            cUrl    :=  "/api/third/sales?Start="+cAnoInt+"-"+cMesInt+"-"+cDiaInt+"T"+cHrMeep+":00:00.000Z&"+;
                                           "End="+cAnoInt+"-"+cMesInt+"-"+cDiaInt+"T"+cHrMeep+":59:59.999Z&"+;
                                          "Page="+cvaltochar(cPage)+"&Count=500"
        EndIf
        */
// cUrl    := "/api/third/sales?Start=2021-08-25T00%3A00%3A00.000Z&End=2021-08-28T23%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"
// cUrl    := "/api/third/sales?Start=2021-09-16T18%3A00%3A00.000&End=2021-09-17T04%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"

for m := 1 to len(cUrl)

	oRestClient:setPath(cUrl[m][1])
	If oRestClient:Get(aHeadProd)
		cPostRet := (oRestClient:GetResult())
	Else
		cPostRet := (oRestClient:GetLastError())
		// conout(cPostRet)
		Return
	EndIf

	oMeep:FromJSON(FwNoAccent(DecodeUTF8(cPostRet, "cp1252")))

	nTotal  := zConta(cPostRet, "OrderId", .F.)

	If nTotal = 0
		bLoop := .F.
	Else
		For i := 1 to nTotal
			If oMeep[i]:GetJsonText("Sefaz")<>"null"
				cProtocolNumber     := oMeep[i]["Sefaz"]["ProtocolNumber"]
				cNFCeAccessKey      := oMeep[i]["Sefaz"]["NFCeAccessKey"]
				cUrlSefaz           := oMeep[i]["Sefaz"]["UrlSefaz"]
				cStatusSefaz        := oMeep[i]["Sefaz"]["Status"]
				cNumeroSefaz        := cvaltochar(oMeep[i]["Sefaz"]["Number"])
				cSerieSefaz         := oMeep[i]["Sefaz"]["Serie"]
				dDataEmis           := CToD(SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],9,2)+"/"+SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],6,2)+"/"+LEFT(oMeep[i]["Sefaz"]["EmitAt"],4))
				cHoraEmis           := SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],12,8)
				cCodSEFAZ           := oMeep[i]["Sefaz"]["StatusCode"]
			EndIf

			//If dDataEmis<>ctod('  /  /    ') .OR. dDataEmis$'null' .OR. dDataEmis
				//PESQUISA SE JÁ INTEGROU A VENDA
				dbSelectArea("ZBM")
				dbSetOrder(2)
				If dbSeek(xFilial("ZBM")+padr(oMeep[i]["OrderId"],TAMSX3("ZBM_ORDID")[1] ," "))
					If dDataEmis<>ZBM_DTEMIS .or. ZBM->ZBM_KEYNFC$"Sem chave"
						If Empty(ZBM_NUMB)
							RecLock('ZBM', .F.)
							ZBM->ZBM_NUMB:=	cNumeroSefaz
							ZBM->ZBM_SERIE:=cSerieSefaz
							ZBM->ZBM_KEYNFC:=cNFCeAccessKey
							ZBM->ZBM_DTEMIS:=dDataEmis
							ZBM->(MsUnlock())
						EndIF
						//EndIf

						BeginSql alias 'TEMPD2'
						SELECT D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_COD,D2_ITEM,D2_EMISSAO,R_E_C_N_O_ FROM  SD2200
						WHERE
						D2_DOC = %exp:cNumeroSefaz% AND
						D_E_L_E_T_<>'*'
						EndSql
						While !(EOF())
							Aadd(aASD2,{TEMPD2->D2_DOC,TEMPD2->D2_SERIE,TEMPD2->D2_CLIENTE,TEMPD2->D2_LOJA,TEMPD2->D2_COD,TEMPD2->D2_ITEM})
							DbSkip()
						EndDo

						For k := 1 To Len(aASD2)
							dbSelectArea("SD2")
							dbSetOrder(3)
							If dbSeek(xFilial("SD2")+aASD2[k][1]+aASD2[k][2]+aASD2[k][3]+aASD2[k][4]+aASD2[k][5]+aASD2[k][6])
								If dDataEmis<>D2_EMISSAO
									RecLock('SD2', .F.)
									SD2->D2_EMISSAO:= dDataEmis
									SD2->(MsUnlock())
								EndIf
							EndIf
						Next k

						TEMPD2->(DbCloseArea())

						BeginSql alias 'TEMPFT'
						SELECT FT_FILIAL,FT_TIPOMOV,FT_SERIE,FT_NFISCAL,FT_CLIEFOR,FT_LOJA,FT_ITEM,FT_PRODUTO,R_E_C_N_O_ FROM  SFT200
						WHERE
						FT_NFISCAL = %exp:cNumeroSefaz% AND
						D_E_L_E_T_<>'*'
						EndSql
						While !(EOF())
							Aadd(aASFT,{TEMPFT->FT_TIPOMOV,TEMPFT->FT_SERIE,TEMPFT->FT_NFISCAL,TEMPFT->FT_CLIEFOR,TEMPFT->FT_LOJA,TEMPFT->FT_ITEM,TEMPFT->FT_PRODUTO})
							DbSkip()
						EndDo

						For k := 1 To Len(aASFT)
							dbSelectArea("SFT")
							dbSetOrder(1)
							If dbSeek(xFilial("SFT")+aASFT[k][1]+aASFT[k][2]+aASFT[k][3]+aASFT[k][4]+aASFT[k][5]+aASFT[k][6]+aASFT[k][7])
								If dDataEmis<>FT_EMISSAO
									RecLock('SFT', .F.)
									SFT->FT_EMISSAO:= dDataEmis
									SFT->FT_ENTRADA:= dDataEmis
									SFT->(MsUnlock())
								EndIf
							EndIf
						Next k

						TEMPFT->(DbCloseArea())

						dbSelectArea("SF2")
						dbSetOrder(1)
						If dbSeek(xFilial("SF2")+cNumeroSefaz)
							If dDataEmis<>F2_EMISSAO
								RecLock('SF2', .F.)
								SF2->F2_EMISSAO:=	dDataEmis
								SF2->(MsUnlock())
							EndIF
						EndIf

						BeginSql alias 'TEMPF3'
						SELECT F3_ENTRADA,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_CFO,R_E_C_N_O_ FROM  SF3200
						WHERE
						F3_NFISCAL = %exp:cNumeroSefaz% AND
						D_E_L_E_T_<>'*'
						EndSql
						While !(EOF())
							Aadd(aASF3,{TEMPF3->F3_ENTRADA,TEMPF3->F3_NFISCAL,TEMPF3->F3_SERIE,TEMPF3->F3_CLIEFOR,TEMPF3->F3_LOJA,TEMPF3->F3_CFO})
							DbSkip()
						EndDo

						For k := 1 To Len(aASF3)
							dbSelectArea("SF3")
							dbSetOrder(1)
							If dbSeek(xFilial("SF3")+aASF3[k][1]+aASF3[k][2]+aASF3[k][3]+aASF3[k][4]+aASF3[k][5]+aASF3[k][6])
								If dDataEmis<>F3_EMISSAO
									RecLock('SF3', .F.)
									SF3->F3_EMISSAO:= dDataEmis
									SF3->F3_ENTRADA:= dDataEmis
									SF3->(MsUnlock())
								EndIF
							EndIf
						Next k

						TEMPF3->(DbCloseArea())

						ASIZE(aASD2,0)
						ASIZE(aASFT,0)
						ASIZE(aASF3,0)
					EndIF
				EndIf
			//EndIf
		Next i
	EndIF
	cPage++
Next m
EndDo

RESET ENVIRONMENT

Return .T.


Static Function zConta(cPalavra, cCaracter, lMaiusculo)
	Local aArea       := GetArea()
	Local nTotal      := 0
	Local nAtual      := 0
	Default cPalavra  := ""
	Default cCaracter := ""

	//Se transForma tudo em maiusculo
	If lMaiusculo
		cPalavra  := Upper(cPalavra)
		cCaracter := Upper(cCaracter)
	EndIf

	//Percorre todas as letras da palavra
	For nAtual := 1 To Len(cPalavra)
		//Se a posição atual For igual ao caracter procurado, incrementa o valor
		If SubStr(cPalavra, nAtual, len(cCaracter)) == cCaracter
			nTotal++
		EndIf
	Next

	RestArea(aArea)
Return nTotal
