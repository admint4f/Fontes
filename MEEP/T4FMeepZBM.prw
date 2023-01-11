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

User Function IMCadZBM(dDataInt,cHrInt)
    Local cUrl          := ""
    Local cPage         := 0
    Local bLoop         := .T.
    Local i             := 0
    Local j             := 0
    Local p             := 0
    Local nItem         := ""
    Local cToken        := ""

    Local oMeep         := JsonObject():New()
    Local nTotal        := 0

    Local aHeadProd     := {}
	Local cPostRet		:= ""
    Local cUrlMeep      := SuperGetMV("MV_MPURL",.F.,"https://server.meep.cloud")
    Local oRestClient   := FWRest():New(cUrlMeep)

    Local cMoeda        := "01"
    Local cFormaPG      := ""
    Local nSaldoVenda   := 0
    Local cFilZB0       := ""
    Local cNumZB0       := ""

    Local cEPEP             := ""
    Local cCliDoc           := ""
    Local cCliName          := ""
    Local cCodProd          := ""
    Local cProtocolNumber   := ""
    Local cNFCeAccessKey    := ""
    Local cUrlSefaz         := ""
    Local cStatusSefaz      := ""
    Local dDataMeep         := date()
    Local dDataFat          := date()
    Local dDataFtd          := date()

    Local cDiaInt           := Day2Str(dDataInt)
    Local cMesInt           := Month2Str(dDataInt)
    Local cAnoInt           := Year2Str(dDataInt)

    //Modificar
    Local cTes              := ""

    Default cHrInt          := ""
    Default dDataInt        := date()

    cToken	      := U_MeepAuth()
    
    cDiaInt       := Day2Str(dDataInt)
    cMesInt       := Month2Str(dDataInt)
    cAnoInt       := Year2Str(dDataInt)

    Aadd(aHeadProd, 'Authorization: Bearer '+cToken)

    cPage := 1

    While bLoop
        If empty(cHrInt)
            cUrl    := "/api/third/sales?Start="+cAnoInt+"-"+cMesInt+"-"+cDiaInt+"T00:00:00.000Z"+;
                                         "&End="+cAnoInt+"-"+cMesInt+"-"+cDiaInt+"T23:59:59.999Z"+;
                                        "&Page="+cvaltochar(cPage)+"&Count=50"
        Else
            // If val(cHrInt) < 2
            //     cHrMeep     := cValToChar(22 + val(cHrInt))
            //     dDataInt    := dDataInt-1
            //     cDiaInt     := Day2Str(dDataInt)
            //     cMesInt     := Month2Str(dDataInt)
            //     cAnoInt     := Year2Str(dDataInt)
            // Else
            //     cHrMeep     := cValToChar(cvaltochar(val(cHrInt) -2))
            //     cDiaInt     := Day2Str(dDataInt)
            //     cMesInt     := Month2Str(dDataInt)
            //     cAnoInt     := Year2Str(dDataInt)
            // EndIf
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
                                          "Page="+cvaltochar(cPage)+"&Count=50"
        EndIf

        // cUrl    := "/api/third/sales?Start=2021-09-03T18%3A00%3A00.000&End=2021-09-04T17%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //324
        // cUrl    := "/api/third/sales?Start=2021-09-15T18%3A00%3A00.000&End=2021-09-16T17%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //378
        // cUrl    := "/api/third/sales?Start=2021-09-16T18%3A00%3A00.000&End=2021-09-17T17%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //257
        // cUrl    := "/api/third/sales?Start=2021-09-17T18%3A00%3A00.000&End=2021-09-18T17%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //334
        // cUrl    := "/api/third/sales?Start=2021-09-18T18%3A00%3A00.000&End=2021-09-19T17%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //775
        // cUrl    := "/api/third/sales?Start=2021-10-14T18%3A00%3A00.000&End=2021-10-16T17%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //478
        // cUrl    := "/api/third/sales?Start=2021-09-24T03%3A00%3A00.000&End=2021-09-25T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //300
        // cUrl    := "/api/third/sales?Start=2021-09-25T03%3A00%3A00.000&End=2021-09-26T02%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"   //750
        //cUrl       := "/api/third/sales?Start=2021-10-24T03%3A00%3A00.000&End=2021-10-27T23%3A59%3A59.999&Page="+cvaltochar(cPage)+"&Count=1000"

        oRestClient:setPath(cUrl)
        If oRestClient:Get(aHeadProd)
            cPostRet := (oRestClient:GetResult())
        Else
            cPostRet := (oRestClient:GetLastError())
            //conout(cPostRet)
            Return
        EndIf

        oMeep:FromJSON(FwNoAccent(DecodeUTF8(cPostRet, "cp1252")))
        
        nTotal  := zConta(cPostRet, "OrderId", .F.)
        
        If nTotal = 0
            bLoop := .F.
        Else
            For i := 1 to nTotal
             
             BEGIN Transaction               
                
                IF oMeep[i]:GetJsonText("NextPage")=="false"
                    bLoop := .F.
                ENDIF

                If ( oMeep[i]:GetJsonText("Customer")=="null" .Or. oMeep[i]:GetJsonText("Document")=="null" )
                    cCliDoc     := ""
                    cCliName    := ""
                Else
                    cCliDoc     := oMeep[i]:GetJsonText("Document")
                    cCliName    := oMeep[i]:GetJsonText("Name")
                EndIf

                dbSelectArea("ZB0")
                dbSetOrder(1)
                ZB0->( dbGoTop() )

                cFilZB0 := ""
                cNumZB0 := ""

                While ZB0->( !EOF() )
                    If UPPER(AllTrim(ZB0->ZB0_MEEP)) == UPPER(AllTrim(oMeep[i]["StoreId"]))
                        If ZB0->ZB0_EMP == FWCodEmp() 
                            If ZB0->ZB0_ATIVO == "1"
                                cFilZB0 := ZB0->ZB0_FIL
                                cNumZB0 := ZB0->ZB0_NUM
                            EndIf
                        EndIf
                    EndIf
                    ZB0->( dbSkip() )
                EndDo

              If Alltrim(oMeep[i]["OrderId"])$"6919c305-ee8e-4283-b46d-1f0d2ab8577e"
                 conout('passou')
              EndIf

                //PESQUISA SE JÁ INTEGROU A VENDA
                dbSelectArea("ZBM")
                dbSetOrder(2)
                If !dbSeek(xFilial("ZBM")+padr(oMeep[i]["OrderId"],TAMSX3("ZBM_ORDID")[1] ," "))

                    dDataMeep   := SUBSTR(oMeep[i]["Date"],9,2)+"/"+SUBSTR(oMeep[i]["Date"],6,2)+"/"+LEFT(oMeep[i]["Date"],4)

                    cHoraMeep   := SUBSTR(oMeep[i]["Date"],12,2)

                    dbSelectArea("ZB1")     //Sakaguti
                    dbSetOrder(1)
                    ZB1->( dbGoTop() )

                    cEPEP := ""
                    
                    Do While ZB1->( !EOF() ) .AND. ZB1->ZB1_NUM == cNumZB0 .AND. ZB1->ZB1_DTINI <= CToD(dDataMeep) .AND. ZB1->ZB1_DTFIM >= CToD(dDataMeep)
                        
                        If ZB1->ZB1_DTINI == CToD(dDataMeep) 
                            If Val(ZB1->ZB1_HRINI) > val(cHoraMeep)
                                Loop
                            EndIf
                        EndIf
                        
                        If ZB1->ZB1_DTFIM == CToD(dDataMeep)
                            If Val(ZB1->ZB1_HRFIM) < val(cHoraMeep)
                                Loop
                            EndIf
                        EndIf

                        cEPEP       := ZB1->ZB1_EPEP
                        
                        ZB1->( dbSkip() )
                    EndDo

                    dDataEmis := CToD("  /  /  ")
                    dDataCanc := CToD("  /  /  ")
                    cHoraCanc:= ""

                    If oMeep[i]:GetJsonText("Sefaz")=="null"
                        cProtocolNumber     := ""
                        cNFCeAccessKey      := ""
                        cUrlSefaz           := ""
                        cStatusSefaz        := ""
                        cNumeroSefaz        := ""
                        cSerieSefaz         := ""
                        dDataEmis           := CToD("  /  /  ")
                        cHoraEmis           := ""
                        cCodSEFAZ           := ""
                    Else    
                        cProtocolNumber     := oMeep[i]["Sefaz"]["ProtocolNumber"]
                        cNFCeAccessKey      := oMeep[i]["Sefaz"]["NFCeAccessKey"]
                        cUrlSefaz           := oMeep[i]["Sefaz"]["UrlSefaz"]
                        cStatusSefaz        := oMeep[i]["Sefaz"]["Status"]
                        cNumeroSefaz        := oMeep[i]["Sefaz"]["Number"]
                        cSerieSefaz         := oMeep[i]["Sefaz"]["Serie"]
                        dDataEmis           := CToD(SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],9,2)+"/"+SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],6,2)+"/"+LEFT(oMeep[i]["Sefaz"]["EmitAt"],4))
                        cHoraEmis           := SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],12,8)
                        cCodSEFAZ           := oMeep[i]["Sefaz"]["StatusCode"]
                        IF !(oMeep[i]["Sefaz"]:GetJsonText("CancelAt") == "null" )
                            dDataCanc           := CToD(SUBSTR(oMeep[i]["Sefaz"]["CancelAt"],9,2)+"/"+SUBSTR(oMeep[i]["Sefaz"]["CancelAt"],6,2)+"/"+LEFT(oMeep[i]["Sefaz"]["CancelAt"],4))
                            cHoraCanc           := SUBSTR(oMeep[i]["Sefaz"]["CancelAt"],12,8)

                            nHrcanc:= val(LEFT(cHoraCanc,2)) - 3

                            IF nHrcanc < 0
                                nHrcanc+= 24
                                dDataCanc:= dDataCanc-1
                            ENDIF

                            cHoraCanc:= PADL(nHrcanc,2,"0")+RIGHT(cHoraCanc,6)
                            
                        ENDIF
                    EndIf 

                    If Empty(dDataEmis)
                        cStatusZBM          := ""
                        cEtapaZBM           := "X"
                    Else
                        cStatusZBM          := "0"
                        cEtapaZBM           := "0"
                    EndIf                    

                    If val(cHoraMeep) < 3
                        dDataFtd := DaySub(CToD(dDataMeep),1)
                    Else
                        dDataFtd := CToD(dDataMeep)
                    EndIf

                    dbSelectArea("ZBM")
                    dbSetOrder(2)
                    
                    RecLock('ZBM', .T.)
                        ZBM->ZBM_EPEP		:=	cEPEP
                        ZBM->ZBM_STORE		:=	oMeep[i]["StoreId"]
                        ZBM->ZBM_ORDID		:=	oMeep[i]["OrderId"]
                        ZBM->ZBM_DTINT		:=	Date()
                        ZBM->ZBM_CPF		:=	cCliDoc
                        ZBM->ZBM_CLINA		:=	cCliName
                        ZBM->ZBM_ORDTP		:=	cValToChar(oMeep[i]["OrderType"])

                        ZBM->ZBM_NUMB		:=	cNumeroSefaz
                        ZBM->ZBM_SERIE		:=	cSerieSefaz

                        ZBM->ZBM_DTMP		:=	oMeep[i]["Date"]
                        ZBM->ZBM_VALUE		:=	oMeep[i]["Value"]
                        ZBM->ZBM_STATUS     :=  cStatusZBM
                        ZBM->ZBM_ETAPA      :=  cEtapaZBM
                        ZBM->ZBM_DTMPFT		:=	dDataFtd
                        ZBM->ZBM_FILORC 	:=	cFilZB0
                        ZBM->ZBM_KEYNFC		:=	cNFCeAccessKey
                        ZBM->ZBM_SEPROT 	:=	cProtocolNumber
                        ZBM->ZBM_URLSEF 	:=	cUrlSefaz
                        ZBM->ZBM_STSEFA 	:=	cStatusSefaz
                        ZBM->ZBM_CANC 	    :=  oMeep[i]:GetJsonText("Status")
                        ZBM->ZBM_DTEMIS     :=  dDataEmis
                        ZBM->ZBM_HREMIS     :=  cHoraEmis
                        ZBM->ZBM_SEFCD      :=  cCodSEFAZ
                        ZBM->ZBM_DTCANC     :=  dDataCanc
                    ZBM->(MsUnlock())

                    // Else
                    //     dDataEmis           := CToD("  /  /  ")
                    //     If oMeep[i]:GetJsonText("Sefaz")=="null"
                    //         dDataEmis           := CToD("  /  /  ")
                    //         cHoraEmis           := ""
                    //         cCodSEFAZ           := ""
                    //     Else 
                    //         if ValType(oMeep[i]["Sefaz"]["EmitAt"]) <> "U"
                    //             dDataEmis           := CToD(SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],9,2)+"/"+SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],6,2)+"/"+LEFT(oMeep[i]["Sefaz"]["EmitAt"],4))
                    //             cHoraEmis           := SUBSTR(oMeep[i]["Sefaz"]["EmitAt"],12,8)
                    //         Else
                    //             dDataEmis           := CToD("  /  /  ")
                    //             cHoraEmis           := ""
                    //         EndIf
                    //         if ValType(oMeep[i]["Sefaz"]["StatusCode"]) <> "U"
                    //             cCodSEFAZ           := oMeep[i]["Sefaz"]["StatusCode"]
                    //         Else
                    //             cCodSEFAZ           := ""
                    //         EndIf
                    //     EndIf

                    //     RecLock('ZBM', .F.)
                    //         ZBM->ZBM_CANC       :=  oMeep[i]:GetJsonText("Status")
                    //         ZBM->ZBM_DTEMIS     :=  dDataEmis
                    //         ZBM->ZBM_HREMIS     :=  cHoraEmis
                    //         ZBM->ZBM_SEFCD      :=  cCodSEFAZ
                    //     ZBM->(MsUnlock())

                EndIf

                For j := 1 to (len(oMeep[i]["Itens"]))
                    dbSelectArea("ZB2")
                    dbSetOrder(2)
                    ZB2->( dbGoTop() )
                    If dbSeek(xFilial("ZB2")+padr((oMeep[i]["StoreId"]),TAMSX3("ZB2_STORE")[1] ," ")+padr(oMeep[i]["Itens"][j]["ProductId"],TAMSX3("ZB2_IDMEEP")[1] ," "))
                        cCodProd    := ZB2->ZB2_COD
                    Else
                        cCodProd    := "00010006" // PRODUTO SEM CÓDIGO NO MEEP
                    EndIf
                    dbSelectArea("SB1")
                    dbSetOrder(1)
                    SB1->( dbGoTop() )
                    If dbSeek(xFilial("SB1")+padr(ZB2->ZB2_COD,TAMSX3("ZB2_STORE")[1] ," ")+padr(oMeep[i]["Itens"][j]["ProductId"],TAMSX3("ZB2_IDMEEP")[1] ," "))
                        cCodProd    := ZB2->ZB2_COD
                    Else
                        cCodProd    := "00010006" // PRODUTO SEM CÓDIGO NO MEEP
                    EndIf

                    cTes        := SB1->B1_TS

                    dbSelectArea("ZBN")
                    dbSetOrder(3)
                    If !dbSeek(xFilial("ZBN")+padr(oMeep[i]["OrderId"],TAMSX3("ZBN_ORDID")[1] ," ")+padl(cvaltochar(j),TAMSX3("ZBN_ITEMMP")[1] ,"0"))
                        RecLock('ZBN', .T.)
                            ZBN->ZBN_ORDID		:=	oMeep[i]["OrderId"]
                            ZBN->ZBN_ITEMMP		:=	padl(cvaltochar(j),TAMSX3("ZBN_ITEMMP")[1] ,"0")
                            ZBN->ZBN_IDPD		:=	oMeep[i]["Itens"][j]["ProductId"]
                            ZBN->ZBN_COD		:=	cCodProd
                            ZBN->ZBN_QTD		:=	oMeep[i]["Itens"][j]["Quantity"]
                            ZBN->ZBN_VLUN		:=	oMeep[i]["Itens"][j]["UnitValue"]
                            ZBN->ZBN_DESCO		:=	oMeep[i]["Itens"][j]["Discount"]
                            ZBN->ZBN_TES		:=	cTes
                            ZBN->ZBN_CFOP		:=	StrTran(oMeep[i]["Itens"][j]["Cfop"], ".", "")
                            ZBN->ZBN_NCM		:=	oMeep[i]["Itens"][j]["NCM"]
                            ZBN->ZBN_PRDTP		:=	oMeep[i]["Itens"][j]["ProductType"]
                            ZBN->ZBN_STATUS		:=	"0"
                        ZBN->(MsUnlock())
                    EndIf
                Next j

                nSaldoVenda := oMeep[i]["Value"]
                nItem       := "000"
                lPgtos      := .F. //Controla a gravação de dados na ZBP, se não tiver nenhum pagamento aborta transacao

                For p:= 1 to (len(oMeep[i]["Payments"]))

                    dDataFat := dDataFtd
                    lPgtos  := .T.

                    If oMeep[i]["Payments"][p]["Type"] == 1
                        cFormaPG    := "CC"
                    Else
                        cFormaPG    := "CD"
                    EndIf

                    nItem   :=  padl(p,3,"0")
                    nSaldoVenda := nSaldoVenda - oMeep[i]["Payments"][p]["Value"]
                    dbSelectArea("ZBP")
                    dbSetOrder(1)
                    If !dbSeek(xFilial("ZBP")+padr(oMeep[i]["OrderId"],TAMSX3("ZBP_ORDID")[1] ," ")+nItem)
                        dDataFat   := CToD(SUBSTR(oMeep[i]["Payments"][p]["ReceiptDate"],9,2)+"/"+SUBSTR(oMeep[i]["Payments"][p]["ReceiptDate"],6,2)+"/"+LEFT(oMeep[i]["Payments"][p]["ReceiptDate"],4))

                        RecLock('ZBP', .T.)
                            ZBP->ZBP_ORDID		:=	oMeep[i]["OrderId"]
                            ZBP->ZBP_ITEM       :=  nItem
                            ZBP->ZBP_DATA       :=  oMeep[i]["Payments"][p]["ReceiptDate"]
                            ZBP->ZBP_VALOR      :=  oMeep[i]["Payments"][p]["Value"]
                            ZBP->ZBP_FORMA      :=  cFormaPG
                            ZBP->ZBP_FEE        :=  oMeep[i]["Payments"][p]["Fee"]
                            ZBP->ZBP_MOEDA      :=  cMoeda
                            ZBP->ZBP_PAYTP      :=  oMeep[i]["Payments"][p]["Type"]
                            ZBP->ZBP_DATAFT     :=  dDataFat
                            ZBP->ZBP_STATUS     :=  "0"
                        ZBP->(MsUnlock())
                    EndIf
                Next p

                if nSaldoVenda > 0 .and. ( oMeep[i]["PaymentType"] = 3 .or. oMeep[i]["PaymentType"] = 6 .or. oMeep[i]["PaymentType"] = 4 .or. oMeep[i]["PaymentType"] = 0 .or. oMeep[i]["PaymentType"] = 1 )
                    
                    dDataFat := dDataFtd
                    lPgtos  := .T.

                    if oMeep[i]["PaymentType"] = 4
                        cFormaPg    := "CL"
                    else
                        cFormaPG    := "R$"
                    endif

                    nItem   := padl(val(nItem)+1,3,"0")
                    dbSelectArea("ZBP")
                    dbSetOrder(2)
                    If !dbSeek(xFilial("ZBP")+padr(oMeep[i]["OrderId"],TAMSX3("ZBP_ORDID")[1] ," ")+cFormaPG)
                        RecLock('ZBP', .T.)
                            ZBP->ZBP_ORDID		:=	oMeep[i]["OrderId"]
                            ZBP->ZBP_ITEM       :=  nItem
                            ZBP->ZBP_DATA       :=  oMeep[i]["Date"]
                            ZBP->ZBP_VALOR      :=  nSaldoVenda
                            ZBP->ZBP_FORMA      :=  cFormaPg
                            ZBP->ZBP_FEE        :=  0
                            ZBP->ZBP_MOEDA      :=  cMoeda
                            ZBP->ZBP_PAYTP      :=  oMeep[i]["PaymentType"]
                            ZBP->ZBP_DATAFT     :=  dDataFat
                            ZBP->ZBP_STATUS     :=  "0"
                        ZBP->(MsUnlock())
                    EndIf
                    nSaldoVenda := 0
                endif

                IF !lPgtos
                    DisarmTransaction()
                ENDIF

                End Transaction
            Next i
        EndIf
        cPage++
    EndDo
    
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
