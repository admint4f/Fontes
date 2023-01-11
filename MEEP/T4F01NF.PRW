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
** Função que realiza a alteração da conexão com o Top para conectar a outro banco de dados **
@type function
@version 1.00
@author Rogério Costa
@since 28/09/2020
@return aRRAY, ARRAY COM AS NOTAS com outro banco através do DBAccess. Deve ser executada a partir do Menu do ERP.
/*///
USER Function T4F01NF(aParamEmp,cDataIni)

	Local aArea   		:= 	GetArea()
	Local aRet	  		:= 	{}
	Local aPvlNfs 		:= 	{}
	Local aPvlNfs2 		:= 	{}
	Local aNotas  		:= 	{}
	Local cQuery  		:= 	""
	Local cArqTmp 		:= 	GetNextAlias()
	Local nX       		:= 	0
	Local nW			:= 	0
	Local nz			:=	0
	Local lProssegue	:= .T.
	Local cPrdIngresso	:=	""
	Local cPrdIngSocio	:=	""

	If aParamEmp <> Nil .OR. VALTYPE(aParamEmp) <> "U"
		cEmp:=aParamEmp[1]
		cFil:=aParamEmp[2]
	ELse
		cEmp:='33'
		cFil:='01'
	EndIf

	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "FAT" TABLES "SB1","SC5","SC6","SC9","SB1","SB2","SF4","SE4","ZAD","ZAE"

	aAreaZAD := ZAD->(GetArea())

	dbSelectArea("ZAD")
	dbSetOrder(1)

	cSerieI  :=  GetNewPar("T4_SERINT","I  ")

	cSerieS  :=  "S  "

	cQuery  := " SELECT DISTINCT C5_EMISSAO, C6_PRODUTO,C6_NUM,  C9_ITEM,C6_ITEMCC, C6_QTDVEN
	cQuery  += " FROM "+RetSqlName("SC6") +" SC6, " + RetSqlName("SC9")+" SC9, " + RetSqlName("SC5")+" SC5" + CRLF
	cQuery  += " WHERE C6_FILIAL 	= '"+xFilial("SC6")+"' "	+CRLF
	cQuery  += " 	AND C6_FILIAL	=	C9_FILIAL" 				+CRLF
	cQuery  += " 	AND C6_FILIAL	=	C5_FILIAL" 				+CRLF
	cQuery  += " 	AND C6_NUM		=	C5_NUM" 				+CRLF
	cQuery  += " 	AND C6_NUM		=	C9_PEDIDO" 				+CRLF
	cQuery  += " 	AND C6_ITEM		=	C9_ITEM" 				+CRLF
	cQuery  += " 	AND C6_PRODUTO	=	C9_PRODUTO"				+CRLF
	cQuery  += " 	AND C6_NOTA 	= 	' ' " 					+CRLF
	cQuery  += " 	AND C6_CLI		=	C5_CLIENTE"				+CRLF
	cQuery  += " 	AND C6_LOJA		=	C5_LOJACLI"				+CRLF
	cQuery  += " 	AND C5_EMISSAO	BETWEEN '"+cDataIni+"'AND '"+cDataIni+"'"				+CRLF
	cQuery  += " 	AND C5_PAGTO 	= 'BYINTI'" 				+CRLF
	//cQuery  += " 	AND C5_NUM IN ('077927')" +CRLF
	cQuery  += " 	AND SC6.D_E_L_E_T_ = ' ' "					+CRLF
	cQuery  += " 	AND SC5.D_E_L_E_T_ = ' ' "					+CRLF
	cQuery  += " 	AND SC9.D_E_L_E_T_ = ' ' "					+CRLF
	cQuery  += " ORDER BY C6_PRODUTO,C6_NUM "					+CRLF

	cQuery := ChangeQuery(cQuery)

	TCQUERY (cQuery) NEW ALIAS (cArqTmp)

	(cArqTmp)->(DbGoTop())

	Ma410PerAut()

	aPvlNfs2:={}
	nSeq:=001

	While (cArqTmp)->(!Eof())
		AAdd(aPvlNfs,{ (cArqTmp)->C6_NUM,;
			(cArqTmp)->C9_ITEM,;
			Alltrim((cArqTmp)->C6_PRODUTO),;
			Alltrim((cArqTmp)->C6_ITEMCC),;
			Alltrim((cArqTmp)->C5_EMISSAO)})

		(cArqTmp)->(DbSkip())
	EndDo

	ZAE->( dbSetOrder(1) )

	If (!Empty(aPvlNfs))

		cNumPed     :=''
		cItemAgl    :=''
		cItem       :=''

		//****************************************************************
		//faturamento por produto separados
		//****************************************************************
		For nX := 1 To Len(aPvlNfs)

			If(ZAE->( MsSeek(xFilial("ZAE")+aPvlNfs[nX][4])))
				cPrdIngresso	:=	Alltrim(ZAE->ZAE_PRDTKT)
				cPrdIngSocio	:=	Alltrim(ZAE->ZAE_PRDSOC)
			Else
				cPrdIngresso	:=	'2004034941'
			EndIf

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

		/*
		cTO:="rogerio.costa@crmservices.com.br"
		U_EnvEmail(cTO,"Erro Integração INTI "+ dtoc(MsDate()),cLog,{},.F.)
		*/
				Return(aRet)

			ElseIf (Alltrim(aPvlNfs[nX][3])	==	Alltrim(cPrdIngresso)) .OR. (Alltrim(aPvlNfs[nX][3])	==	Alltrim(cPrdIngSocio))

				cSerieS:=''
				dbSelectArea("SC9")
				//cTabela,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,nFatMin,lAtuSA7,lECF,cDocumento,nIdJob,produto
				aNotas:= u_T4FTJOBNF("SC9",cSerieI,.F.,.F.,.T.,.F.,.F.,0,0,0,.F.,.F.,aPvlNfs[nX][1],001,aPvlNfs[nX][3])

			EndIf
		Next nX

		cSerieS:='S  '

		//****************************************************************
		//faturamento por itens aglutinados
		//****************************************************************
		For nW := 1 To Len(aPvlNfs)

			If !(aPvlNfs[nW][3]	== cPrdIngresso .OR. aPvlNfs[nW][3]	==	cPrdIngSocio)

				DDATABASE	:=	STOD(aPvlNfs[nW][5])
				dDataMoe 	:=	DDATABASE

				cSerieI:=''
				//cTabela,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,nFatMin,lAtuSA7,lECF,cDocumento,nIdJob,cItemSC9
				aNotas:= u_T4FTJOBNF("SC9",cSerieS,.F.,.F.,.T.,.F.,.F.,0,0,0,.F.,.F.,aPvlNfs[nW][1],001,'')

			EndIf
		Next nW

		If Select(cArqTmp) > 0
			(cArqTmp)->(DbCloseArea())
		EndIf
	EndIf

	//U_T4F01TRNFE()

	RestArea(aArea)
	RestArea(aAreaZAD)

	RESET ENVIRONMENT
Return

