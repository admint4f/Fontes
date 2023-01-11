#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"


//-------------------------------------------------------------------
/*/{Protheus.doc} T4FCLINETPDC
@Description Função para realizar a inclusão de cadastro de Clientes.
@type User Function
@author  Joalisson Laurentino  
@version    1.00
@since      24/03/2022
/*/
//-------------------------------------------------------------------
User Function CLINETPDV(cIDPDV)

Local cCLiente  := "      "
Local cLoja 	:= "  "
Local cEvento := ""

Default aParams := {"20","01"}
Default cIDPDV	:= ""
Private lLogado  := Type('cEmpAnt') == 'C'


IF !lLogado
	cEmp := aParams[1] 
	cFil := aParams[2]


	RPCSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "LOJA"
ENDIF

	CliPad := SuperGetMV("MV_CLIPAD")      // Cliente Padrao
	LojPad:= SuperGetMV("MV_LOJAPAD")     // Loja Padrao
	cEvento	 := SuperGetMv("ES_EVTNETP",.F.,"11254") 
	
    cQuery := " SELECT * "
	cQuery += " FROM "
	cQuery += "		"+RetSQLName( "ZZX" )+" ZZX "
	cQuery += " WHERE "
	cQuery += "		ZZX.D_E_L_E_T_ <> '*' "
	cQuery += "		AND ZZX.ZZX_FILIAL =  '"+xFilial("ZZX")+"' "
	cQuery += "		AND ZZX.ZZX_STATUS = '0' "
	cQuery += "		AND ZZX.ZZX_CODCLI = '      ' "
	IF !EMPTY(cIDPDV)
		cQuery += "		AND ZZX.ZZX_IDPDV = '"+cIDPDV+"' "
	ENDIF
	cQuery += "		AND ZZX.ZZX_IDEVEN = '"+cEvento+"' "
	//cQuery += "		AND ROWNUM <= 300 "
	
	cQuery += " ORDER BY "
	cQuery += "		ZZX.ZZX_DATA, ZZX.ZZX_HORA, ZZX.ZZX_IDPDV, ZZX.ZZX_ITEM"
	TCQuery cQuery New Alias "ZZXCLI"

	ZZXCLI->(DbGoTop())
	If ZZXCLI->(!Eof())
		While ZZXCLI->( !Eof() )
			IF !EMPTY(ZZXCLI->(ZZX_CODCLI))
				ZZXCLI->(DBSKIP())
				Loop
			ENDIF

			IF EMPTY(ZZXCLI->(ZZX_CPF))
				cCliente	:= CliPad
				cLoja		:= LojPad
			ELSE
				//Realiza o cadastro do cliente caso no exista no Protheus
				DBSelectArea("SA1")
				SA1->(dbSetOrder(3))
				If SA1->(!MsSeek(xFilial("SA1") + ZZXCLI->(ZZX_CPF)))
					Begin Transaction
					aParam := U_T4FCLINETPDC(UPPER(Alltrim("CLIENTE "+ZZXCLI->(ZZX_CPF))),;
							ZZXCLI->(ZZX_CPF),;
							UPPER("R..."),;
							UPPER(""/*Bairro*/),;
							UPPER(Alltrim("SAO PAULO")),;
							UPPER("SP"),;
							ZZXCLI->(ZZX_EMAIL),;
							STRTRAN(Alltrim("04757000"),'-',''))
						End Transaction
						SA1->(MsSeek(xFilial("SA1") + ZZXCLI->(ZZX_CPF)))
				EndIf
				IF SA1->A1_EST = 'EX'
					cCliente	:= CliPad
					cLoja		:= LojPad
				ELSE
					cCliente := SA1->A1_COD
					cLoja	 := SA1->A1_LOJA
				ENDIF
				SA1->(dbCloseArea())
			ENDIF

			DbSelectArea("ZZX")
			dbgoto(ZZXCLI->(R_E_C_N_O_))
			RecLock("ZZX", .F.)
				ZZX->ZZX_CODCLI	:= cCliente
				ZZX->ZZX_LOJCLI	:= cLoja
				ZZX->ZZX_STATUS := "1"	
				ZZX->ZZX_HISTOR	:= U_HISNETPDV("CLIENTE GRAVADO",ZZX->ZZX_HISTOR)
			MsUnlock()
			ZZX->(dbCloseArea())
			ZZXCLI->(dbSkip())
			
		END
		ZZXCLI->(dbCloseArea())
	ENDIF

IF !lLogado
	RESET ENVIRONMENT
ENDIF


Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} T4FCLINETPDC
@Description Função para realizar a inclusão de cadastro de Clientes.
@type User Function
@author  Joalisson Laurentino  
@version    1.00
@since      24/03/2022
/*/
//-------------------------------------------------------------------
User Function T4FCLINETPDC(cNome,cCPF,cEND,cBAIRRO,cCIDADE,cEST,cEmail,cCEP)
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

	cCodCli	:=	GetSx8Num("SA1","A1_COD")

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
	SA1->A1_OBS     :=  "Cadastrado automaticamente pela rotina de integracao NETPDV."
	SA1->A1_EMAIL	:=  cEmail
	SA1->(MsUnlock())

	ConfirmSX8()

	U_T4F01LOG("Cliente "+cCodCli+ " incluído com sucesso!")

	AADD(aParam,{lRet,SA1->A1_COD,SA1->A1_LOJA})
	
	RestArea(aAreaSA1)

Return(aParam)

