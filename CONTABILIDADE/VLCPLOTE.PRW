#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} VLCPLOTE
Ponto de entrada responsável por validar a data da competencia em que esta sendo contabilizado e
o período liberado pela contabilidade dentro dos lançamentos automáticos.
@type User function
@version 1.00
@author Lucas Valins
@since 03/09/2020
@return Lógico , Efetua a saída da rotina se for .F.
/*/

User Function VLCPLOTE()

    Local lRet  := .T.
    Local dDatas:= dDataLanc

    If dDatas < (GetMV("MV_DATADE")) .OR. dDatas > (GetMV("MV_DATAATE"))
        Alert("A data esta diferente do período liberado pela Contabilidade!")
    lRet := .F.
    EndIF

Return(lRet)
