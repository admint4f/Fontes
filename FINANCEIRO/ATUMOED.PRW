#include 'totvs.ch'
#include 'restful.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

User function ATPTAX()

    local cURL as char
    local cHeadRet as char
    local cGetRet as char
    local cParserError as char
    local nTimeOut as numeric
    local jAPIData
    local aMoeda:={}
    local aCotacao:={}
    local cData

    RpcSetType(3)
    RpcSetEnv("08","01")

    cHeadRet  := ""
    cURL      := "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)"
    nTimeOut  := 15

    //cGetRet := HTTPSGet( cURL, "", "", "", '@dataCotacao=' + Escape("'08-17-2020'") + '&$top=' + Escape('1') + '&$format=' + Escape('json') + '&$select=' + "cotacaoCompra,cotacaoVenda", nTimeOut, /*aHeadOut*/, @cHeadRet)
    /*
    MOEDA2 DOLAR
    MOEDA4 MARCO ALEMAO
    MOEDA5 PESO
    MOEDA6 EURO
    MOEDA7 AUS
    */

    dDtCotacao:= dDataBase-1

    dDtCotacao  :=  DataValida(dDtCotacao,.F.)

    cData       :=  Alltrim(Str(Month(dDtCotacao)))+"-"+Alltrim(Str(Day(dDtCotacao)))+"-"+Alltrim(Str(Year(dDtCotacao)))

    aAdd(aMoeda,'USD') //moeda2
    aAdd(aMoeda,'EUR') //moeda6
    aAdd(aMoeda,'GBP') //moeda8 LIBRA ESTERLINA

    dbSelectArea("SM2")
    SM2->(dbSetOrder(1))

    For i:=1 To Len(aMoeda)
        cGetRet := HTTPSGet( cURL, "", "", "", '@moeda=' + Escape("'"+aMoeda[i]+"'") + '&@dataCotacao=' + Escape("'"+cData+"'") + '&$format=' + Escape('json') , nTimeOut, /*aHeadOut*/, @cHeadRet)

        if !Empty(cGetRet)

            jAPIData := JsonObject():New()
            cParserError := jAPIData:fromJson(cGetRet)
            oCli  := jAPIData:GetJsonObject('value')

            if Empty(cParserError)
                For n:=1 to len(oCli)
                    If (oCli[n]:GetJsonObject('tipoBoletim')=="Fechamento PTAX")
                        cValComp:=oCli[n]:GetJsonObject('cotacaoVenda')
                        Aadd(aCotacao,{aMoeda[i],cValComp})
                    EndIf
                Next n
            else
                ConOut("Ocorreu um erro, veja o header:", cHeadRet, "", "Erro retornado pela API:", cGetRet)
            endif

            jAPIData := nil
        else
            ConOut("Ocorreu um erro, veja o header:", cHeadRet)
        endif
    Next i

    If (SM2->(DbSeek(DtoS(DataValida(dDtCotacao+1)))))
        RecLock("SM2",.F.)
        SM2->M2_MOEDA2 := aCotacao[1][2]
        SM2->M2_MOEDA6 := aCotacao[2][2]
        SM2->M2_MOEDA8 := aCotacao[3][2]
        MsUnlock()
    Else
        RecLock("SM2",.T.)
        SM2->M2_DATA   := DataValida(dDtCotacao+1)
        SM2->M2_MOEDA2 := aCotacao[1][2]
        SM2->M2_MOEDA6 := aCotacao[2][2]
        SM2->M2_MOEDA8 := aCotacao[3][2]
        MsUnlock()
    EndIf

    aCotacao:={}

    RESET ENVIRONMENT

Return

