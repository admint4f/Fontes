#INCLUDE "Protheus.ch"
#include "Fileio.ch"
#include "rwmake.ch"
#INCLUDE "TBICONN.CH"
/*
==============================================================================================================================================================


==============================================================================================================================================================
*/
/*
==============================================================================================================================================================
Função    : BwVLOen
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau para retornar o valor das outras entidades
Parâmetro :
==============================================================================================================================================================
*/
User Function BwVlOen()

Local lC_Retorno := ""

//========= MODELO 17 - GPS
If SEA->EA_MODELO == "17"
	lC_Retorno := STRZERO(SE2->E2_XOUTENT*100,14)
Else
	lC_Retorno := STRZERO(0,14)
EndIf
SEA->(DbSkip())

Return lC_Retorno
/*
==============================================================================================================================================================
Função    : BwVLGps
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau para retornar o valor líquido do GPS
Parâmetro :
==============================================================================================================================================================
*/
User Function BwVlGps()

Local lC_Retorno := ""

SEA->(DbSkip(-1))
//========= MODELO 17 - GPS
If SEA->EA_MODELO == "17"
	lC_Retorno := STRZERO((SE2->E2_VALOR-SE2->E2_XOUTENT)*100,14)
Else
	lC_Retorno := STRZERO(SOMAVALOR(),14)
EndIf

Return lC_Retorno
/*
==============================================================================================================================================================
Função    : Bw341a
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau - registro detalhes do segmento A - ITAUENV.PAG - Posição 024 a 043
Parâmetro :
==============================================================================================================================================================
*/
User Function BW341A

Local lC_Bloco := ""

//If SA2->A2_BANCO $ "341/409"
//If SE2->E2_BCOPAG $ "341/409" .Or. SA2->A2_BANCO $ "341/409" .and. se2->e2_tipo <>"PA"
// ATENDENDO A SOLICITAÇÃO DO DEPARTAMENTO FINANCEIRO, ESTOU DESABILITANDO A CHAMADO DO CAMPO E2_BCOPAG
// O CNAB PASSA A BUSCAR O BANCO,AGENCIA E CONTA DO CADASTRO DO FORNECEDOR              
// inclui a condição  .or. 1=1 para forçar o sistema a buscar SEMPRE no cadastro de fornecedor
// LUIZ EDUARDO - 23-03-2017
If SA2->A2_BANCO $ "341/409" //.and. se2->e2_tipo <>"PA"
	
	//---- Número da banco creditada
	If Empty(SE2->E2_BCOPAG) 
		lC_Bloco := Strzero(Val(SA2->A2_BANCO),3)
	Else
		If Alltrim(SE2->E2_TIPO) $ "PA" .or. 1=1
			lC_Bloco := Strzero(Val(SA2->A2_BANCO),3)
		Else
			lC_Bloco := Strzero(Val(SE2->E2_BCOPAG),3)
		EndIf
	EndIf
	
	//---- Complemento de registro
	lC_Bloco += "0"
	//---- Número da agência creditada
	If Empty(SE2->E2_AGPAG)
		lC_Bloco += Strzero(Val(SubStr(SA2->A2_AGENCIA,1,4)),4)
	Else
		If Alltrim(SE2->E2_TIPO) $ "PA" .or. 1=1
			lC_Bloco += Strzero(Val(SubStr(SA2->A2_AGENCIA,1,4)),4)
		Else
			lC_Bloco += Strzero(Val(SubStr(SE2->E2_AGPAG,1,4)),4)
		EndIf
	EndIf
	//---- Complemento de registro
	lC_Bloco += " "
	//---- Complemento de registro
	lC_Bloco += "000000"
	//---- Número de CC créditada
	If Empty(SE2->E2_CTAPAG)
		lC_Bloco += Strzero(Val(SubStr(SA2->A2_NUMCON,1,6)),6)
	Else
		If Alltrim(SE2->E2_TIPO) $ "PA" .or. 1=1
			lC_Bloco += Strzero(Val(SubStr(SA2->A2_NUMCON,1,6)),6)
		Else
			lC_Bloco += Strzero(Val(SubStr(SE2->E2_CTAPAG,1,6)),6)
		EndIf
	EndIf
	
	//---- Complemento de registro
	lC_Bloco += " "
	//---- Dígito verificador da agência
	If !Empty(SA2->A2_DVCONTA)
		lC_Bloco += SA2->A2_DVCONTA
		//	Else
		//		lC_Bloco += SE2->E2_DVCONTA
	EndIf
	
Else

	//---- Número da banco creditada
	If Empty(SE2->E2_BCOPAG) .or. 1=1
		lC_Bloco += Strzero(Val(SA2->A2_BANCO),3)
	Else
		lC_Bloco += Strzero(Val(SE2->E2_BCOPAG),3)
	EndIf
	
	//---- Número da agência creditada
	If SA2->A2_BANCO $ "001" .and. !empty(SA2->A2_DVAGENC)
		lC_Bloco += Strzero(Val(SA2->A2_AGENCIA),5)
	Else
	If Empty(SE2->E2_AGPAG) .or. 1=1
		lC_Bloco += Strzero(Val(SA2->A2_AGENCIA),5)
	Else
		lC_Bloco += Strzero(Val(SE2->E2_AGPAG),5)
	EndIf
	Endif
	
	//---- Complemento de registro
	lC_Bloco += " "
	
	//---- Número de CC créditada
	If SA2->A2_BANCO $ "001" .and. !empty(SA2->A2_DVAGENC)
		lC_Bloco += SA2->A2_DVAGENC+Strzero(Val(SA2->A2_NUMCON),11)
	else
	If Empty(SE2->E2_CTAPAG) .or. 1=1
		lC_Bloco += Strzero(Val(SA2->A2_NUMCON),12)
	Else
		lC_Bloco += Strzero(Val(SE2->E2_CTAPAG),12)
	EndIf
	Endif
	
	//---- Complemento de registro
	lC_Bloco += " "
	
	//---- Dígito verificador da agência
	If !Empty(SA2->A2_DVCONTA)
		lC_Bloco += SA2->A2_DVCONTA
		//	Else
		//		lC_Bloco += SE2->E2_DVCONTA
	EndIf
	
EndIf

Return lC_Bloco
/*
==============================================================================================================================================================
Função    : Bw341DV
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau - registro detalhes do segmento J para buscar o dígito verificador.
Parâmetro :
==============================================================================================================================================================
*/
User Function BW341DV()
Return If(Len(Alltrim(SE2->E2_CODBAR))==47,SubStr(SE2->E2_CODBAR,33,1),SubStr(SE2->E2_CODBAR,5,1))
/*
==============================================================================================================================================================
Função    : Bw341VL
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau - registro detalhes do segmento J para buscar o valor do título
Parâmetro :
==============================================================================================================================================================
*/
User Function BW341VL()
Return If(Len(Alltrim(SE2->E2_CODBAR))==47,Substr(SE2->E2_CODBAR,34,4)+Strzero(Val(SubStr(SE2->E2_CODBAR,38,10)),10),Substr(SE2->E2_CODBAR,6,4)+Strzero(Val(SubStr(SE2->E2_CODBAR,10,10)),10))
/*
==============================================================================================================================================================
Função    : Bw341CL
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau - registro detalhes do segmento J para buscar o campo livre
Parâmetro :
==============================================================================================================================================================
*/
User Function BW341CL()
Return If(Len(Alltrim(SE2->E2_CODBAR))==47,SubStr(SE2->E2_CODBAR,5,25),SubStr(SE2->E2_CODBAR,20,25))
/*
==============================================================================================================================================================
Função    : Bw341VP
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau - registro detalhes do segmento J para buscar o valor do pagamento
Parâmetro :
==============================================================================================================================================================
*/
User Function BW341VP()
Return STRZERO((SE2->E2_SALDO-SE2->E2_DECRESC+SE2->E2_ACRESC)*100,15)
/*
==============================================================================================================================================================
Função    : Bw341PT
Autor     : José Carlos - Totalit
Data      : 06/10/2015
Descrição : Programa chamado no SISPAG do banco Itau - registro detalhes do segmento J para buscar o valor do pagamento
Parâmetro :
==============================================================================================================================================================
*/
User Function BW341PT()

Local lC_Retorno := ""
//Space(178)

//========= MODELO 17 - GPS
If SEA->EA_MODELO == "17"
	lC_Retorno += "01"           //--- posição 18 e 19 - identificação do tributo 01-GPS
	lC_Retorno += SE2->E2_CODRET //--- posição 20 a 23 - código de pagamento
	lC_Retorno += SE2->E2_XCOMPET //--- posição 24 a 29 - mês e ano de competência MMAAAA
	lC_Retorno += Posicione("SA2",1,xFilial("SA2")+SE2->E2_BWFOCON+SE2->E2_BWLJCON,"SA2->A2_CGC") //--- posição 30 a 43 - CNPJ contribuinte
	lC_Retorno += STRZERO((SE2->E2_VALOR-SE2->E2_XOUTENT)*100,14) //--- posição 44 a 57 - valor previsto
	lC_Retorno += STRZERO((SE2->E2_XOUTENT)*100,14) //--- posição 58 a 71 - valor outras entidades
	lC_Retorno += STRZERO(0,14) //--- posição 72 a 85 - atualização monetária
	lC_Retorno += STRZERO((SE2->E2_VALOR)*100,14) //--- posição 86 a 99 - valor arrecadado
	lC_Retorno += SubStr(Dtos(SE2->E2_VENCREA),7,2)+SubStr(Dtos(SE2->E2_VENCREA),5,2)+SubStr(Dtos(SE2->E2_VENCREA),1,4)  //--- posição 100 a 107 - data de pagamento DDMMAAAA
	lC_Retorno += Space(8)	//--- posição 108 a 115 - brancos
	lC_Retorno += Space(50) //--- posição 116 a 165 - brancos
	lC_Retorno += SubStr(Posicione("SA2",1,xFilial("SA2")+SE2->E2_BWFOCON+SE2->E2_BWLJCON,"SA2->A2_NOME"),1,30) //--- posição 166 a 195 - Nome
Else
	lC_Retorno := Space(178)
EndIf

Return lC_Retorno


