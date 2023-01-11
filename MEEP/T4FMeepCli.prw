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
 | Parm:  aCliPad:  Array com as informações do cód e loja do cliente  	|
 |					que será utilizado quando o mesmo não for informado |
 |                  na venda.                                       	|
 |        			[1] Cód Cliente										|
 |                  [2] Loja Cliente									|
 *----------------------------------------------------------------------*/

User Function IMCliente(aCliPad)
    Local cCPF      	:= ""
    Local cQuery
	Local cNewStatus	:= "1"
	Local aCliDados

    cQuery := " SELECT * "
	cQuery += " FROM "
	cQuery += "		"+RetSQLName( "ZBM" )+" ZBM "
	cQuery += " WHERE "
	cQuery += "		ZBM.D_E_L_E_T_ <> '*' "
	cQuery += "		AND ZBM.ZBM_FILIAL =  '"+xFilial("ZBM")+"' "
	cQuery += "		AND ZBM.ZBM_STATUS = '0' "
	cQuery += "		AND ZBM.ZBM_ETAPA = '0' "
	cQuery += "		AND ZBM.ZBM_CLICOD = '      ' "
	cQuery += "		AND ZBM.ZBM_KEYNFC <> '"+space(TAMSX3("ZBM_KEYNFC")[1])+"' "
	cQuery += " ORDER BY "
	cQuery += "		ZBM.ZBM_STATUS, "
	cQuery += "		ZBM.ZBM_ORDID "
	TCQuery cQuery New Alias "ZBMST0"

	ZBMST0->(DbGoTop())
	If ZBMST0->(!Eof())
		While ZBMST0->( !Eof() )
            cCPF    := alltrim(ZBMST0->ZBM_CPF)
			cNome	:= ZBMST0->ZBM_CLINA
			cEST	:= ""
                                                                                //Venda possui cliente?
            If !len(alltrim(cCPF)) = 0    										//----Sim,  Há Cliente -> Esta Registrado ?  
                dbSelectArea("SA1")					
                dbSetOrder(3)
                If dbSeek(xFilial("SA1")+padr(cCPF,TAMSX3("A1_CGC")[1] ," "))   //------------Sim - Pegar Dados
					aCliDados 	:= {SA1->A1_COD,SA1->A1_LOJA,.T.}
                Else                         
                    aCliDados   := T4FMEEPCLI(cNome,cCPF,cEST)
				EndIf
			Else
				aCliDados	:= aCliPad
            EndIf																//----Não, sem CPF -> Puxar registro padrão
			
			If aCliDados[3]
				IMAltZBMSt(ZBMST0->ZBM_ORDID,cNewStatus,aCliDados[1],aCliDados[2])
			EndIf
            
			ZBMST0->(DbSkip())

        EndDo
    EndIf

	ZBMST0->(dbCloseArea())

return .T.


Static Function T4FMEEPCLI(cNome,cCPF,cEST)

	Local lRet      := .T.
	Local aParam    := {}
	Local aAreaSA1  := GetArea()

	RecLock("SA1",.T.)
		SA1->A1_COD     :=  GetSx8Num("SA1", "A1_COD")
		SA1->A1_LOJA    :=  '01'
		SA1->A1_NOME    :=  cNome
		SA1->A1_NREDUZ  :=  cNome
		SA1->A1_TIPO    :=  "F"
		SA1->A1_PESSOA  :=  IIf(Len(Alltrim(cCPF)) > 11,'J','F')
		SA1->A1_CGC    	:=  cCPF
		SA1->A1_END     :=  "0"	
		SA1->A1_EST     :=  cEST											//BO	
		SA1->A1_COD_MUN	:=	"13850"											//BO
		SA1->A1_MUN		:=	"0"												//PUXA DO COD
		SA1->A1_BAIRRO  :=	"0"
		SA1->A1_PAIS	:=	"105"
		SA1->A1_INSCR	:=	"ISENTO"
		SA1->A1_INSCRM	:=	"ISENTO"
		SA1->A1_ENDCOB	:=  "0"
		// SA1->A1_CONTA	:= "0"
		// SA1->A1_ALIQIR	:=												//BO
		SA1->A1_MUNC	:= "0"
		SA1->A1_ESTC	:= "0"
		SA1->A1_RECISS	:=	"2"
		SA1->A1_RECINSS :=  "N"
		SA1->A1_RECCOFI :=	"N"
		SA1->A1_RECCSLL :=	"N"
		SA1->A1_RECPIS  :=	"N"
		SA1->A1_SIMPNAC :=  "2"
		SA1->A1_RECIRRF :=  "2"
		SA1->A1_CODPAIS	:= "01058"
		SA1->A1_DTCAD  	:=  DDATABASE
		SA1->A1_HRCAD   :=  Time()
		SA1->A1_OBS     :=  "Cliente cadastrado automaticamente pela rotina de integracao Meep x Protheus."
	SA1->(MsUnlock())

	ConfirmSX8()

	// U_T4F01LOG("Cliente incluído com sucesso!")

	aParam	:= {SA1->A1_COD,SA1->A1_LOJA,lRet}

	RestArea(aAreaSA1)

Return(aParam)


Static Function IMAltZBMSt(cOrdemId,cNewStatus,cCliCod,cCliLoja)
	
	dbSelectArea("ZBM")
	dbSetOrder(2)
	If dbSeek(xFilial("ZBM")+padr(cOrdemId,TAMSX3("ZBM_ORDID")[1] ," "))

		If ZBM->ZBM_APONT == '1'	//OP Ja criada e apontada, atualizar ZBM_STATUS
			RecLock('ZBM', .F.)
				ZBM->ZBM_CLICOD     := cCliCod
				ZBM->ZBM_CLILO      := cCliLoja
				ZBM->ZBM_STATUS     := cNewStatus
			ZBM->(MsUnlock())
		Else
			RecLock('ZBM', .F.)
				ZBM->ZBM_CLICOD     := cCliCod
				ZBM->ZBM_CLILO      := cCliLoja
			ZBM->(MsUnlock())
		EndIf

	EndIf

return .T.
