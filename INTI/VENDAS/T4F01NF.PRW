#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "Fisa022.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE TAMMAXXML 400000  //- Tamanho maximo do XML em bytesS
#DEFINE CRLF (chr(13)+chr(10))

/*/{Protheus.doc} T4F01NF
** Função que realiza a geração das notas fiscais dos pedidos importados **
@type function
@version 1.00
@author Rogério Costa
@since 28/09/2020
@return aRRAY, ARRAY COM AS NOTAS.
/*///
USER Function T4F01NF(cDataIni,cNumPed,oSay,oGridPv,aDadosZAD,aItensNf)

	Local aArea   		:= 	GetArea()
	Local aRet	  		:= 	{}
	Local aPvlNfs 		:= 	{}
	Local aNotas  		:= 	{}
	Local cQuery  		:= 	""
	Local cArqTmp 		:= 	GetNextAlias()
	Local n       		:= 	0
	Local nX       		:= 	0
	Local nW			:= 	0
	Local lProssegue	:= .T.
	Local lAuto			:= .T.
	Local lRunSched	 	:= FWGetRunSchedule()

	If lRunSched

		PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilAnt MODULO "FAT" TABLES "SC5","SC6","SA1","SA2","SB1","SB2","SF4", "ZAD", "ZAF","ZAE"

		lAuto := .T.

	Else

		lAuto := .F.

	EndIf


	cSerieI  :=  GetNewPar("T4_SERINT","I  ")
	cSerieS  :=  "S  "

/* RETIRADO PARA EMISSAO DE RPS PELO PROTHEUS
	If cEmpAnt =='33'
		cSerieS  :=  "INT"
	Else
		cSerieS  :=  "S  "
	EndIf
*/

	dbSelectArea("SB2")
	SB2->(dbSetOrder(1))

	If VALTYPE(cDataIni) == 'D'
		cDataIni	:=	DTOS(cDataIni)
	EndIf

	Ma410PerAut()

	nSeq:=001

	If Len(aItensNf) == 0

		cQuery  := " SELECT DISTINCT C5_EMISSAO, C6_PRODUTO,C6_NUM,  C9_ITEM,C6_ITEMCC, C6_QTDVEN, C6_PEDCLI, C6_CHASSI
		cQuery  += " FROM "+RetSqlName("SC6") +" SC6, " + RetSqlName("SC9")+" SC9, " + RetSqlName("SC5")+" SC5" + CRLF
		cQuery  += " WHERE C6_FILIAL 	= '"+xFilial("SC6")+"' "	+CRLF
		cQuery  += " 	AND C6_FILIAL	=	C9_FILIAL" 				+CRLF
		cQuery  += " 	AND C6_FILIAL	=	C5_FILIAL" 				+CRLF
		cQuery  += " 	AND C6_NUM		=	C5_NUM" 				+CRLF
		cQuery  += " 	AND C6_NUM		=	C9_PEDIDO" 				+CRLF
		cQuery  += " 	AND C6_ITEM		=	C9_ITEM" 				+CRLF
		cQuery  += " 	AND C6_PRODUTO	=	C9_PRODUTO"				+CRLF
		cQuery  += " 	AND C6_PRODUTO	>	' '"					+CRLF
		cQuery  += " 	AND C6_NOTA 	= 	' ' " 					+CRLF
		cQuery  += " 	AND C6_CLI		=	C5_CLIENTE"				+CRLF
		cQuery  += " 	AND C6_LOJA		=	C5_LOJACLI"				+CRLF
		cQuery  += " 	AND C5_EMISSAO	BETWEEN '" + cDataIni + "'AND '" + cDataIni + "'"				+CRLF
		cQuery  += " 	AND C5_PAGTO 	= 'BYINTI'" 				+CRLF

		If !Empty(cNumPed)
			cQuery  += " 	AND C5_NUM 		= '" + cNumPed + "'"  		+CRLF
		EndIf

		cQuery  += " 	AND SC6.D_E_L_E_T_ = ' ' "					+CRLF
		cQuery  += " 	AND SC5.D_E_L_E_T_ = ' ' "					+CRLF
		cQuery  += " 	AND SC9.D_E_L_E_T_ = ' ' "					+CRLF
		cQuery  += " ORDER BY C6_NUM, C6_PRODUTO,C6_PEDCLI "					+CRLF

		TCQUERY (cQuery) NEW ALIAS (cArqTmp)

		(cArqTmp)->(DbGoTop())

		While (cArqTmp)->(!Eof())

			If SB2->(!MsSeek(xFilial("SB2")+(cArqTmp)->C6_PRODUTO))
				Reclock("SB2",.T.)
				SB2->B2_FILIAL:= xFilial("SB2")
				SB2->B2_COD	  := (cArqTmp)->C6_PRODUTO
				SB2->B2_LOCAL := '01'
				SB2->(Msunlock())
			EndIF

			AAdd(aPvlNfs,{ (cArqTmp)->C6_NUM,;
				(cArqTmp)->C9_ITEM,;
				Alltrim((cArqTmp)->C6_PRODUTO),;
				Alltrim((cArqTmp)->C6_ITEMCC),;
				Alltrim((cArqTmp)->C5_EMISSAO),;
				Alltrim((cArqTmp)->C6_PEDCLI),;
				Alltrim((cArqTmp)->C6_CHASSI)})

			(cArqTmp)->(DbSkip())
		EndDo

	Else

		For n:=1 To Len(aItensNf)

			AAdd(aPvlNfs,{ cNumPed,;
				aItensNf[n][1],;
				Alltrim(aItensNf[n][2]),;
				Alltrim(aItensNf[n][8]),;
				Alltrim(cDataIni),;
				Alltrim(aItensNf[n][11]),;
				Alltrim(aItensNf[n][12])})

		Next n

	EndIf

	If (!Empty(aPvlNfs))

		cNumPed     :=''
		cItemAgl    :=''
		cItem       :=''

		//****************************************************************
		//faturamento por produto separados
		//****************************************************************
		For nX := 1 To Len(aPvlNfs)

			DDATABASE	:=	STOD(aPvlNfs[nX][5])
			dDataMoe 	:=	DDATABASE

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o Fechamento do Fiscal                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			/* RETORNAR DEPOIS ROGERIO
				If ( MVUlmes() >= dDataBase )
					lProssegue := .F.
				EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o Fechamento do Fiscal                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( !FisChkDt(dDataBase) )
					lProssegue := .F.
				EndIf
			*/
			If !lProssegue
				cLog :=  Alltrim(DTOC(DDATABASE))+"-"+Alltrim(Time())+" - Data base menor que data de fechamento Estoque ou Financeiro - "

				u_T4F01LOG(cLog)

				Return(aRet)

			ElseIf Alltrim(aPvlNfs[nX][6]) == 'INGRESSO' .OR. Alltrim(aPvlNfs[nX][6]) == '1' .Or. Alltrim(aPvlNfs[nX][6]) == '6' .Or. Alltrim(aPvlNfs[nX][6]) == 'DOACAO'

				cSerieS:=''
				dbSelectArea("SC9")

				If FWIsInCallStack('U_T4FPEDMAN')

					cMsg := "FATURANDO PEDIDO NUMERO: "+aPvlNfs[nX][1] +" Emissao: "+DTOC(dDataMoe)
					oGridPv:SetIncMeter(1,cMsg)

				EndIf

				aNotas:= u_T4FTJOBNF("SC9",cSerieI,.F.,.F.,.T.,.F.,.F.,0,0,0,.F.,.F.,aPvlNfs[nX][1],001,aPvlNfs[nX][3],oSay,oGridPv,aDadosZAD)

			EndIf
		Next nX

/* EMISSAO DE RPS PELO PROTHEUS
		If cEmpAnt =='33'
			cSerieS:='INT'
		Else
			cSerieS:='S  '
		EndIf
*/
		cSerieS:='S  '
		//****************************************************************
		//faturamento por itens aglutinados
		//****************************************************************
		For nW := 1 To Len(aPvlNfs)

			If Alltrim(aPvlNfs[nW][6]) <> 'INGRESSO' .OR. Alltrim(aPvlNfs[nW][6]) <> '1' .OR. Alltrim(aPvlNfs[nW][6]) <> '6' .Or. Alltrim(aPvlNfs[nW][6]) <> 'DOACAO'

				DDATABASE	:=	STOD(aPvlNfs[nW][5])
				dDataMoe 	:=	DDATABASE

				If FWIsInCallStack('U_T4FPEDMAN')
					cMsg := "FATURANDO PEDIDO NUMERO: "+aPvlNfs[nW][1] +" EMISSAO:"+ DTOC(dDataMoe)
					oGridPv:SetIncMeter(1,cMsg)
				EndIf

				cSerieI:=''
				//cTabela,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,nFatMin,lAtuSA7,lECF,cDocumento,nIdJob,cItemSC9
				aNotas:= u_T4FTJOBNF("SC9",cSerieS,.F.,.F.,.T.,.F.,.F.,0,2,0,.F.,.F.,aPvlNfs[nW][1],001,'',oSay,oGridPv,aDadosZAD)

			EndIf
		Next nW

	EndIf

	If Select(cArqTmp) > 0
		(cArqTmp)->(DbCloseArea())
	EndIf

	RestArea(aArea)

	If lAuto
		RESET ENVIRONMENT
	EndIf

Return

