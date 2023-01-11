#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_MeepAuth                                                  	|
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Programa que consome rota de autentificação da API do 		|
 |		  software MEEP e retorna o Token gerado						|
 *----------------------------------------------------------------------*/

User Function MeepAuth()

	Local aHeadAuth     := {}
    Local cPassMeep     := ""
    Local cLoginMeep    := ""
    Local cUrlMeep      := ""
    Local oRestClient
    Local cPOSTParms    := ""
    Local cPostRet      := ""
    Local cToken        := ""

    cLoginMeep    := SuperGetMV("MV_MPLOG",.F.) //felipe.sakaguti@crmservices.com.br
    cPassMeep     := SuperGetMV("MV_MPPASS",.F.)            // crm@2021
    cUrlMeep      := SuperGetMV("MV_MPURL",.F.,"https://server.meep.cloud") //https://meepserver-dev.azurewebsites.net

    oRestClient   := FWRest():New(cUrlMeep)
    cPOSTParms    := "grant_type=password&username="+cLoginMeep+"&password="+cPassMeep

	Aadd( aHeadAuth, 'Content-Type: application/x-www-form-urlencoded')

    oRestClient:setPath("/token")
    oRestClient:SetPostParams(cPOSTParms)
    if oRestClient:Post(aHeadAuth)
        cPostRet := (oRestClient:GetResult())
        cToken  := substr(cPostRet,18,4600)
        cToken  := left(cToken,at('"',cToken,1)-1)
    else 
        cPostRet := (oRestClient:GetLastError())
        cToken   := "500"
    Endif

Return(cToken)
