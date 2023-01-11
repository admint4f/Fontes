#INCLUDE "Protheus.ch"
/*/{Protheus.doc} MT110FIL
Função responsável por filtrar a solicitação de compras apenas do usuário que a criou
exceto os usuários cadastrados como compradores.
@type function
@version 1.0
@author lucas Valins
@since 24/02/2021
/*/
User Function MT110FIL()
	Local aAreaBKP 	:= GetArea()
	Local cFiltro	:= ""
//	Local cCCs		:= "" //	Comentado por Lucas Valins 24/02/2021 através de solicitação do Helton e Thiago T4F
//	Local cFSCResid	:= GetMv("MV_T4FSCSR",,"") indicar neste parametro os codigos de usuarios que nao verao as SCs eliminadas por residuo
//	Comentado por Lucas Valins 24/02/2021 através de solicitação do Helton e Thiago T4F
	Local cTipoFilt	:= SuperGetMv("MV_XTPFILT")//GetMv("MV_XTPFILT",,"1")
	Local SY1Area	:= SY1->(Getarea())
	Local SC1Area	:= SC1->(Getarea())
//	Local ZZ4Area	:= ZZ4->(Getarea()) Comentado por Lucas Valins 24/02/2021 através de solicitação do Helton e Thiago T4F
//Ignora o filtro para usuarios que sao compradores
	dbSelectArea("SY1")
	SY1->(dbSetOrder(3))
	If SY1->(dbSeek(xFilial("SY1")+__cUserId))
		//cFiltro := "1 == 1" // Alterado Luis Dantas 28/06/2012
		cFiltro := ""
	Else
		If cTipoFilt == "1" //Se for igual a 1 efetua o bloqueio por usuários se igual a 2 então libera o bloqueio por usuário.
		cFiltro := "AllTrim(C1_USER) == '"+AllTrim(__cUserId)+"'"
	/*----------------------------------------------------------------------------------------------------------------------------------------*/
	//Busca os C.C. do usuario
			/*dbSelectArea("ZZ4")
			ZZ4->(dbSetOrder(2))
			ZZ4->(dbSeek(xFilial("ZZ4")+__cUserId))
			While ZZ4->(!Eof()) .And. ZZ4->ZZ4_FILIAL + AllTrim(ZZ4->ZZ4_USER) == xFilial("ZZ4")+__cUserId
				cCCs += AllTrim(ZZ4->ZZ4_CC)+"|"
				ZZ4->(dbSkip())
			EndDo*/
			//Se o usuario nao estiver relacionado com nenhum C.C. nao permite visualizar nenhuma S.C.
			/*If Empty(cCCs)
				cFiltro := "C1_NUM == '******'"
				//Amarra os C.C.s com as S.C.s do usuario
			Else
				cFiltro := "AllTrim(C1_CC) $ '" + cCCs + "' "
			EndIf*/
		/*ElseIf cTipoFilt == "2" // Filtra apenas SCs incluidas pelo usuario
			cFiltro := "AllTrim(C1_USER) == '" + AllTrim(__cUserId) + "' "*/
			//Bloco anterior comentado por Lucas Valins de acordo com solicitação Heltão e Thiago 24/02/2021
		Else
			cFiltro := ""
		EndIf
	EndIf
	/*----------------------------------------------------------------------------------------------------------------------------------------*/
	//Bloco anterior comentado por Lucas Valins de acordo com solicitação Heltão e Thiago 24/02/2021
	/* Comentado por Lucas Valins através da solicitação do Thiago Moraes.
	If !Empty(cFSCResid)
		If __cUserId $ cFSCResid
			IIf (Empty(cFiltro), cFiltro += " Empty(C1_RESIDUO)" , cFiltro += " .AND. Empty(C1_RESIDUO)") // Alterado Luis Dantas 28/06/2012
			//cFiltro += 	" .AND. Empty(C1_RESIDUO)" //Nao mostra SCs eliminadas por residuo no Browse // Alterado Luis Dantas 28/06/2012
		EndIf
	EndIf
	*/
	RestArea(aAreaBKP)
	RestArea(SY1Area)
	RestArea(SC1Area)
	//RestArea(ZZ4Area)
Return(cFiltro)
