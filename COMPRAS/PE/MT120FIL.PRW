#INCLUDE 'protheus.ch'

/*/{Protheus.doc} MT120FIL
Função responsável por filtrar somente os pedidos criados pelo próprio usuário
Exceto os usuários cadastrados como compradores
@type function
@version  1.0
@author lucas
@since 24/02/2021
/*/
USER FUNCTION MT120FIL
	Local cRet :=""
	Local cTipoFilt	:= SuperGetMv("MV_XTPFILT")//GetMv("MV_XTPFILT",,"1")
	Local SY1Area	:= SY1->(Getarea())
	Local SC7Area	:= SC7->(Getarea())
	dbSelectArea("SY1")
	SY1->(dbSetOrder(3))
	If SY1->(dbSeek(xFilial("SY1")+__cUserId))
		cFiltro := ""
	Else
		If cTipoFilt == "1" //Se for igual a 1 efetua o bloqueio por usuários se igual a 2 então libera o bloqueio por usuário.
			cRet := "AllTrim(C7_USER) == '"+AllTrim(__cUserId)+"'"
		Else
			cRet := ""
		EndIf
	EndIf
    RestArea(SY1Area)
    RestArea(SC7Area)
Return cRet
