#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} T4F01CLI
@param cNome,caractere,nome do cliente
@param cCPF,caractere,CNPJ/CPF do cliente
@param cEND,caractere,Endereço do cliente/
@param cBAIRRO,caractere,BAIRRO do cliente
@param cCIDADE,caractere,CIDADE do cliente/
@param cEST,caractere,Estado do cliente/
@param cCEP,caractere,Cep do cliente/
@param nRec,Numerico,Recno da tabela ZAD
@return aParam, lRet,COD,LOJA
@Description Função para realizar a inclusão de cadastro de Clientes.
@type User Function
@author  Rogério Costa   
@version    1.00
@since      29/09/2020
/*/
//-------------------------------------------------------------------

User Function T4F01CLI(cNome,cCPF,cEND,cBAIRRO,cCIDADE,cEST,cCEP,nRec)

	Local lRet      := .T.
	Local aParam    := {}
	Local aAreaSA1  := GetArea()
	Local cCodMun	:= ''

	//----------------------------------
	// Dados do Cliente
	//----------------------------------
	dbSelectArea("CC2")
	dbSetOrder(4)
	If CC2->(MsSeek(xFilial("CC2")+cEST+cCIDADE))
		cCodMun:=CC2->CC2_CODMUN
	EndIf

	cCodCli	:=	GetSx8Num("SA1", "A1_COD")

	RecLock("SA1",.T.)
	SA1->A1_COD     :=  cCodCli
	SA1->A1_LOJA    :=  '01'
	SA1->A1_NOME    :=  cNome
	SA1->A1_NREDUZ  :=  cNome
	SA1->A1_TIPO    :=  "F"
	SA1->A1_PESSOA  :=  IIf(Len(Alltrim(cCPF)) > 11,'J','F')
	SA1->A1_CGC    	:=  cCPF
	SA1->A1_END     :=  cEND
	SA1->A1_EST     :=  cEST
	SA1->A1_COD_MUN	:=	cCodMun
	SA1->A1_MUN		:=	cCIDADE
	SA1->A1_BAIRRO  :=	If(Empty(cBAIRRO),"Em branco",cBAIRRO)
	SA1->A1_PAIS	:=	"105"
	SA1->A1_INSCR	:=	"ISENTO"
	SA1->A1_INSCRM	:=	"ISENTO"
	SA1->A1_ENDCOB	:=	cEND
	SA1->A1_CEP 	:=  cCEP
	SA1->A1_CEPC 	:=  cCEP	
	SA1->A1_CONTA	:=	"1104020001"
	SA1->A1_MUNC	:=	cCIDADE
	SA1->A1_ESTC	:=	cEST
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
	SA1->A1_OBS     :=  "Cliente cadastrado automaticamente pela rotina de integracao INTI."
	SA1->(MsUnlock())

	ConfirmSX8()

//------------------------------------
// Chamada para cadastrar o cliente.
//------------------------------------

	U_T4F01LOG("Cliente "+cCodCli+ " incluído com sucesso!")

	AADD(aParam,{lRet,SA1->A1_COD,SA1->A1_LOJA})
	
	RestArea(aAreaSA1)

Return(aParam)
