#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'


/*/{Protheus.doc} GP110VLD
Ponto de entrada responsável por validar a data da competencia em que esta sendo contabilizado e
o período liberado pela contabilidade na rotina de contabilização da folha.
@type User function
@version 1.00
@author Lucas Valins
@since 01/10/2020
@return Lógico , Efetua a saída da rotina se for .T.
/*/

USER FUNCTION GP110VLD()

    Local lRet:= .F.//Somente permite a contabilizacao do mes no mes da data base.
    Local dAno:= SUBSTR(cMesAnoCtab,3,4)
    Local dMes:= SUBSTR(cMesAnoCtab,1,2)
    Local dData:= dAno+dMes+"01"

    Local dAno1 := Substr(cValToChar(SuperGetMV("MV_DATADE")),7,4)
    Local dMes1 := Substr(cValToChar(SuperGetMV("MV_DATADE")),4,2)
    Local dDia1 := Substr(cValToChar(SuperGetMV("MV_DATADE")),1,2)
    Local dData1 := dAno1+dMes1+dDia1

    Local dAno2 := Substr(cValToChar(SuperGetMV("MV_DATAATE")),7,4)
    Local dMes2 := Substr(cValToChar(SuperGetMV("MV_DATAATE")),4,2)
    Local dDia2 := Substr(cValToChar(SuperGetMV("MV_DATAATE")),1,2)
    Local dData2 := dAno2+dMes2+dDia2

    IF dData < dData1 .OR.dData > dData2
        Alert("O período esta fechado, entre em contato com a contabilidade!")
        lRet:= .T.
    Endif

Return(lRet)
