/*/{Protheus.doc} CN100ADI
Localizado no adiantamento do contrato, este ponto de entrada tem por objetivo 
permitir a gravação dos campos customizados referentes ao adiantamento.
Uso para alterar o numero do titulo na ZZE, pois no PE anterior não contem essa numeração
@type function
@version 
@author Rogerio
@since 26/08/2020
@return return_type, return_description

/*/
User Function CN100ADI()

    Local cTpCtr    := CN9->CN9_ESPCTR
    Local cNumTitulo:=""
    Local _cNumero  := GetSX8Num("ZZE","ZZE_NUMERO")
    Local aAreaZZE  := ZZE->(GetArea())
    Local aAreaCNX  := CNX->(GetArea())

    If(cTpCtr == "1")

        cNumTitulo:=SE2->E2_NUM
/*
        DbSelectArea('ZZE')
        ZZE->(DbSetOrder(4))
        If (ZZE->(DbSeek(xFilial('ZZE')+SE2->E2_FORNECE+SE2->E2_LOJA+"   "+"CTR"+RIGHT(SE2->E2_MDCONTR,6)+SE2->E2_PARCELA)))

            RecLock("ZZE",.F.)

            ZZE_TITULO  := cNumTitulo
            ZZE_NATURE  := SE2->E2_NATUREZ

            ZZE->(MsUnlock())

        EndIf
*/
    Else

        Begin Transaction
            DbSelectArea('ZZE')
            ZZE->(DbSetOrder(4))
            If !(ZZE->(DbSeek(xFilial('ZZE')+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)))

                RecLock("ZZE",.T.)

                ZZE_FILIAL	:=	xFilial('ZZE')
                ZZE_ITEM	:=  '001'
                ZZE_TIPO	:= 	5
                ZZE_NUMERO  :=	_cNumero
                ZZE_FORNEC	:=  SE1->E1_CLIENTE
                ZZE_LOJA	:=	SE1->E1_LOJA
                ZZE_NOMFOR	:=	SA1->A1_NOME
                ZZE_VALOR	:=	SE1->E1_VALOR//SC7->C7_XVALPA
                ZZE_HISTOR	:=	'ADIANTAMENTO AUTOMATICO GERADO PELO CONTRATO '+SE1->E1_MDCONTR
                ZZE_STATUS	:=	'L'
                ZZE_BANCO	:=	cBco
                ZZE_AGENC	:=	cAgc
                ZZE_CONTA	:=	cCta
                ZZE_DATA	:=  SE1->E1_VENCTO// CRIAR CAMPO NA CNX PARA INCLUIR A DATA DO DEBITO
                ZZE_CCUSTO	:=	''// CRIAR CAMPO NA CNX PARA INCLUIR O CENTRO CE CUSTO
                ZZE_PEP	    :=	''// CRIAR CAMPO NA CNX PARA INCLUIR A CLASSE VALOR
                ZZE_PEDIDO	:=	""
                ZZE_MOEDA	:=	1
                ZZE_USERID  := retcodusr()
                ZZE_PREF    := ""
                ZZE_TITULO  := SE1->E1_NUM  //VERIFICAR NUMERAÇÃO DO TITULO DE RA
                ZZE_NATURE  := SE1->E1_NATUREZ
                ZZE_CCAPRO  := SE1->E1_NUM

                SE1->(Confirmsx8())
                ZZE->(Confirmsx8())
                ZZE->(MsUnlock())

            EndIf

            If lMsErroAuto
                MostraErro()
                DisarmTransaction()
                Return
            Endif

        End Transaction

    EndIf
    RestArea(aAreaZZE)
    RestArea(aAreaCNX)

Return
