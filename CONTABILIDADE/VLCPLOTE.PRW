#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} VLCPLOTE
Ponto de entrada respons?vel por validar a data da competencia em que esta sendo contabilizado e
o per?odo liberado pela contabilidade dentro dos lan?amentos autom?ticos.
@type User function
@version 1.00
@author Lucas Valins
@since 03/09/2020
@return L?gico , Efetua a sa?da da rotina se for .F.
/*/

User Function VLCPLOTE()

    Local lRet  := .T.
    Local dDatas:= dDataLanc

    If dDatas < (GetMV("MV_DATADE")) .OR. dDatas > (GetMV("MV_DATAATE"))
        Alert("A data esta diferente do per?odo liberado pela Contabilidade!")
    lRet := .F.
    EndIF

Return(lRet)
