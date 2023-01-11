#include "rwmake.ch"
#include "TOPCONN.ch"
#define _EOL chr(13)+chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºNova Versao?TIXBOR   ?Autor ³Gilberto A Oliveira ?Data ? 19/04/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºOriginal   ?RFINR010 ?Autor ³Fabiano Migoto 	    ?Data ? 23/03/09   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao  ?Relatorio de Titulos em Bordero, com rastreabilidade de    º±?
±±?          ?pedidos e solicitacao de compras                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso        ?T4F                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function TITXBOR()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	 := "Relação de Títulos x Borderôs de Pagamentos"
Local nLin         	 := 80
Local imprime      	 := .T.
Local aOrd 			 := {}
Local aPerguntas	 := {}

//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180     190       200       210       220
//Pagamento Emissao   Forma de Pagamaneto  Pref Numero Tp. Fornecedor                                                Bco Agen. Conta       Valor Original           Saldo  Pedido  Solic.  Aprovador
//____________________________________________________________________________________________________________________________________________________________________________________________________________________________
//99/99/99  99/99/99  XXXXXXXXXXXXXXXXXXXX XXX  999999 XXX 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999 99999 9999999999  999,999,999.99  999,999,999.99  XXXXXX  XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX






Local Cabec1       	 := "Dt. Pagto.   Emissao      For. Pagto.  Pref   Numero     Tp.   Fornecedor                                        Banco    Agencia     Conta       Vlr. Orig.           Saldo    Pedido    Solic.    Aprovador"
Local Cabec2          := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFINR011"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "RFIR11"
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFINR011"

dbSelectArea("SE2")
SE2->(dbSetOrder(1))

Aadd(aPerguntas,{"RFIR11","01","Bordero(s)"		,"mv_ch1"	,"C",60,00,"G","","mv_par01","","","","","","",""})
Aadd(aPerguntas,{"RFIR11","02","Quebra DOC/TED"	,"mv_ch2"	,"N",01,00,"C","","mv_par02","Sim","Nao","","","","",""})
ValidSX1(aPerguntas)

pergunte(cPerg,.F.)

wnrel := SetPrint("SE2",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,"SE2")

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFun‡„o    ³RUNREPORT ?Autor ³Bruno Daniel Borges ?Data ? 04/03/08   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescri‡„o ?Funcao de processamento do relatorio                       º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?T4F                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cBorderos	:= ""
Local cQuebra	:= ""
Local cNivel	:= ""
Local cNomeAprv:= ""
Local nTotReg	:= 0
Local nTotal	:= 0
Local nTotGer	:= 0
Local nTotBrt	:= 0
Local nTotGBrt	:= 0
Local cNumZZE  := 0
Local cForma
Local cNumSC  := ''
Local bQuerySC7 := {|| Iif(Select("TRB_SC7") > 0, TRB_SC7->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC7),"TRB_SC7",.F.,.T.), dbSelectArea("TRB_SC7"), TRB_SC7->(dbGotop()) }
Local bQueryZZE := {|| Iif(Select("TRB_ZZE") > 0, TRB_ZZE->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryZZE),"TRB_ZZE",.F.,.T.), dbSelectArea("TRB_ZZE"), TRB_ZZE->(dbGotop()) }
Local cQueryZZE	:= ""
Local cQuerySC7	:= ""

//*** Formata String para uso em "In" Sql. ***//
RetStrForm( @cBorderos )
                                    
If Empty(cBorderos)
	MsgAlert("Atenção, informe um ou mais número de borderôs nos parâmetros do relatório. Os números devem ser separados por vírgula.")
	Return(Nil)
EndIf

//**** Query do Relatorio ***//
QueryTwo(@nTotReg, cBorderos)

SetRegua(nTotReg)

TITULOS->(dbGoTop())

While TITULOS->(!Eof())
	
	cQuebra := TITULOS->EA_MODELO
	nTotal  := 0
	nTotBrt := 0
	
	While TITULOS->(!Eof()) .And. ( TITULOS->EA_MODELO == cQuebra  )
		
		// Regua de processamento.
		IncRegua()
		
		If lAbortPrint
			@ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 60
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		cNumZZe := 	RetNumSA( TITULOS->E2_PREFIXO,TITULOS->E2_NUM,TITULOS->E2_PARCELA,TITULOS->E2_FORNECE,TITULOS->E2_LOJA )
		cForma  := Iif( Empty(cNumZZE) .or. Alltrim(TITULOS->E2_TIPO)=="FT", SubStr(Posicione("SX5",1,xFilial("SX5")+"58"+TITULOS->EA_MODELO,"SX5->X5_DESCRI"),1,20), "PAGAMENTO ANTECIPADO")
		//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//0         10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180     190       200       210       220
		//Pagamento Emissao   Forma de Pagamaneto  Prf Numero Tp. Fornecedor                                                Bco Agen. Conta      Valor Original           Saldo  Pedido  Solic.  Aprovador
		//____________________________________________________________________________________________________________________________________________________________________________________________________________________________
		//99/99/99  99/99/99  XXXXXXXXXXXXXXXXXXXX XXX 999999 XXX 999999-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 999 99999 9999999999 999,999,999.99  999,999,999.99  XXXXXX  XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
		
		@ nLin,000 PSay TITULOS->E2_VENCTO
		@ nLin,013 PSay TITULOS->E2_EMISSAO
		@ nLin,026 PSay SubStr(cForma,1,12)
		@ nLin,040 PSay TITULOS->E2_PREFIXO
		@ nLin,047 PSay AllTrim(TITULOS->E2_NUM)
		@ nLin,058 PSay TITULOS->E2_TIPO
		@ nLin,064 PSay AllTrim(TITULOS->E2_FORNECE)
		@ nLin,071 PSay "-"
		@ nLin,073 PSay SubStr(TITULOS->A2_NOME,1,40)
		@ nLin,114 PSay TITULOS->A2_BANCO
		@ nLin,123 PSay SubStr(TITULOS->A2_AGENCIA,1,5)
		@ nLin,135 PSay SubStr(TITULOS->A2_NUMCON,1,10)
		@ nLin,143 PSay TITULOS->E2_VALOR Picture "@E 999,999,999.99"
		@ nLin,159 PSay TITULOS->E2_SALDO Picture "@E 999,999,999.99"
		@ nLin,177 PSay TITULOS->E2_NUMPC
		
		cNumSC:= IIf( Empty(TITULOS->C7_NUMSC) , RetNumSC(TITULOS->E2_NUMPC) , TITULOS->C7_NUMSC )
		
		If  !Empty(cNumSC)
			
			@ nLin,187 PSay cNumSC

			IF !EMPTY(Upper(Ret_Aprovador("01",cNumSC,,TITULOS->E2_NUMPC)))
				@ nLin,196 PSay Upper(Ret_Aprovador("01",cNumSC,,TITULOS->E2_NUMPC))
			ELSE
				@ nLin,196 PSay Upper( Ret_Aprovador("01",,cNumZZE,TITULOS->E2_NUMPC) )
			ENDIF
		Else
			
			//If !Empty(TITULOS->ZZE_NUMERO)
			If !Empty(cNumZZE)
				@ nLin,196 PSay Upper( Ret_Aprovador("01",,cNumZZE,TITULOS->E2_NUMPC) )
			ElseIf Empty(cNumZZE) .And. Empty(cNumSC)
				@ nLin,196 PSay Upper( Ret_Aprovador("01",,,TITULOS->E2_NUMPC) )
			Endif
			
		EndIf
		
		nLin++
		@ nLin,056 PSay "Historico.: "+TITULOS->E2_HIST
		nLin++
		
		// Impressao dos titulos vinculados a
		// No caso de Faturas lista em niveis abaixo os titulos que compoe
		// Titulos iniciados com o prefixo "SR" são das chamadas transacoe de "REPASSE" e nao possuem aprovador.
		// Verificar com o financeiro maiores detalhes.
		
		If Upper(AllTrim(TITULOS->E2_TIPO)) == "FT"
			DadosFatura(@nLin,Titulo,Cabec1,Cabec2)
		Else
			nLin--
			@ nLin,007 PSay TITULOS->E2_ORIGEM
			If !Empty(TITULOS->E2_NUMSPA)
				cQueryZZE	:= "SELECT ZZE_USERID FROM " + RetSqlName("ZZE")
				cQueryZZE	+= " WHERE ZZE_FILIAL = '" + xFilial("ZZE") + "' "
				cQueryZZE	+= " AND ZZE_NUMERO = '" + TITULOS->E2_NUMSPA + "' "
				Eval(bQueryZZE)
				
				If TRB_ZZE->(!EOF())
					@ nLin,021 PSay SubStr(UsrFullName(TRB_ZZE->ZZE_USERID),1,15)
				EndIf
				TRB_ZZE->( DbCloseArea() )
				
			EndIf
			
			If !Empty(TITULOS->E2_NUMPC)
				
				// Clausula Top Nao funciona em Oracle.
				cQuerySC7:= "select c7_numsc,c7_tipo, c7_solicit from ("
				cQuerySC7+= 		"select sc7.* "
				cQuerySC7+=				"from "+RetSqlName("sc7")+" sc7 "
				cQuerySC7+= 			"where sc7.c7_num='"+TITULOS->E2_NUMPC+"' and sc7.d_e_l_e_t_ = ' ' "
				cQuerySC7+=				"order by sc7.c7_numsc desc ) "
				cQuerySC7+=		"where rownum =1 "
				
				Eval(bQuerySC7)
				
				If TRB_SC7->(!EOF()) .And. !Empty(TRB_SC7->C7_SOLICIT)
					@ nLin,021 PSay SubStr(TRB_SC7->C7_SOLICIT,1,15)
				EndIf		
				TRB_SC7->( DbCloseArea() )
			EndIf
			nLin++
		EndIf
		
		@ nLin,000 PSay Replicate("-",limite)
		nLin++
		
		// Totalizadores.
		nTotBrt	+= TITULOS->E2_VALOR
		nTotal 	+= TITULOS->E2_SALDO
		//  Titulos
		DbSelectArea("TITULOS")
		TITULOS->(DbSkip())
		
	EndDo
	
	//Sub-Total por Modelo
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin,000 PSay "Sub-Total " + SubStr(Posicione("SX5",1,xFilial("SX5")+"58"+cQuebra,"SX5->X5_DESCRI"),1,20)
	@ nLin,143 PSay nTotBrt Picture "@E 999,999,999.99"
	@ nLin,159 PSay nTotal Picture "@E 999,999,999.99"
	nTotGBrt	+= nTotBrt
	nTotGer 	+= nTotal
	
	
	nLin += 2
	
EndDo

//Total Geral
If nTotGer > 0
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin,000 PSay "Total Geral"
	@ nLin,143 PSay nTotGBrt Picture "@E 999,999,999.99"
	@ nLin,159 PSay nTotGer  Picture "@E 999,999,999.99"
	
EndIf

Set Device To Screen

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

Ms_Flush()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DadosFatura  ºAutor  ³Gilberto            ?Data ? ??/04/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressao dos dados de fatura.                                 º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ?T4F                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DadosFatura(nLin, titulo, Cabec1, Cabec2 )
Local i
Local aDadosFat:= {}

aDadosFat := Ret_Fatura(TITULOS->E2_NUM,TITULOS->E2_FORNECE)
aDadosFat:= aSort(aDadosFat,,,{ |x,y| x[5] < y[5]} )

For i := 1 To Len(aDadosFat)
	
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin,007 PSay aDadosFat[i,13]	
	@ nLin,021 PSay SubStr(aDadosFat[i,14],1,15)
	@ nLin,039 PSay "("+aDadosFat[i,1] + " " + aDadosFat[i,2] + " " + aDadosFat[i,4] +" )"
	@ nLin,065 PSay "("+aDadosFat[i,12]+")"
	@ nLin,143 PSay "("+Transform(aDadosFat[i,5],"@E 99,999,999.99")+")"
	@ nLin,159 PSay "("+Transform(aDadosFat[i,6],"@E 99,999,999.99")+")"
	@ nLin,177 PSay aDadosFat[i,7]
	
	//Ignora autorizacoes de entrega
	If aDadosFat[i,9] <> 2 .And. !Empty(aDadosFat[i,8])
		@ nLin,187 PSay aDadosFat[i,8]
		@ nLin,196 PSay aDadosFat[i,11]
	ElseIf "REPASSE" $ aDadosFat[i,11]
		@ nLin,187 PSay aDadosFat[i,8]
		@ nLin,196 PSay aDadosFat[i,11]
	EndIf
	nLin++
Next i


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetNumSC()   ºAutor  ³Gilberto            ?Data ? ??/04/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o numero da Solicitacao de Compras                     º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ?T4F                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetNumSC(cNumPC)

Local aArea  := GetArea()
Local cAlias := GetNextAlias()
Local cQuery := ""
Local cNumSC

cQuery += "SELECT MAX(C7_NUMSC) NUMSC "
cQuery += "FROM "+RetSqlName("SC7")+" "
cQuery += "WHERE C7_FILIAL = '"+XFILIAL("SC7")+"' "
cQuery += "AND C7_NUM = '"+cNumPC+"' "
cQuery += "AND D_E_L_E_T_ = ' ' "
dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)
(cAlias)->(dbGoTop())
cNumSC:=(cAlias)->NUMSC
(cAlias)->(dbCloseArea())


RestArea(aArea)
Return( cNumSC )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetNumSA()   ºAutor  ³Gilberto            ?Data ? ??/04/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o numero da Solicitacao de Adiantamento.               º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ?T4F                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RetNumSA(cPrefixo,cNum,cParcela,cFornece,cLoja)

Local aGetArea:= GetArea()
Local cQuery,cNumZZE
Local cAlias:= GetNextAlias()

cQuery:= "SELECT ZZE_NUMERO AS ZZENUM "
cQuery+= "FROM "+RetSqlName("ZZE")+" WHERE ZZE_FILIAL = '"+XFILIAL("ZZE")+"' AND "
cQuery+= "ZZE_PREF = '"+cPrefixo+"' AND "
//cQuery+= "ZZE_TITULO = '"+SUBSTR(cNum,1,6)+"' AND "
cQuery+= "ZZE_TITULO = '"+cNum+"' AND "
cQuery+= "ZZE_PARC = '"+cParcela+"' AND "
cQuery+= "ZZE_FORNEC = '"+cFornece+"' AND "
cQuery+= "ZZE_LOJA = '"+cLoja+"' AND "
cQuery+= "D_E_L_E_T_ = ' ' "

dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAlias,.F.,.T.)

(cAlias)->(dbGoTop())
cNumZZE:= (cAlias)->ZZENUM
(cAlias)->(dbCloseArea())

//Restaura base anterior
RestArea(aGetArea)
Return( cNumZZE )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ret_AprovadorºAutor  ³Microsiga           ?Data ? 04/08/08   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao que retorna o nome do ultimo aprovador de uma solicita- º±?
±±?         ³cao de compras                                                 º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ?T4F                                                           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_Aprovador(cFilSeek,cNumSC, cNumPA, cNumPc)

Local aArea			:= GetArea()
Local cNivel 		:= ""
Local cNomeAprv		:= ""
Local _cQuery		:= ""
Local _cAliasSCR	:= GetNextAlias()
/////////////////////////////////////////////////////////////////////////////
// Autor | Denis D De Almeida | Data | 13/10/2015 | Hora | 16:40
// Motivo| Verifica alçadas de Aprovação na SCR dispensando validações
//       | na ZZ6 - customizada para a T4F 
//       | As validações customizadas não foram excluídas pois se necessário
//       | pode-se retomar a validação customizada ZZ6/ZZ5 
/////////////////////////////////////////////////////////////////////////////
Local _mv_SCR       := GetNewPar("MV_XAPRSCR", .T.)

If !Empty(cNumSC)
	
	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(1))
	dbSelectArea("SCR")
	SCR->(dbSetOrder(1))
	
	If ZZ6->(dbSeek(xFilial("ZZ6")+cNumSC))
		
		While ZZ6->(!Eof()) .And. (ZZ6->ZZ6_FILIAL + ZZ6->ZZ6_SC == xFilial("ZZ6")+cNumSC)
			If ZZ6->ZZ6_STATUS == "1"
				ZZ6->(dbSkip())
				Loop
			Endif
			
			If cNivel < ZZ6->ZZ6_NIVEL
				cNivel 		:= ZZ6->ZZ6_NIVEL
				If AllTrim(ZZ6->ZZ6_APROV) == "PCO"
					cNomeAprv	:= "APROVADO VIA PCO"
				Else
					cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+ZZ6->ZZ6_APROV,"SAK->AK_NOME"))
				EndIf
			EndIf
			ZZ6->(dbSkip())
		EndDo
	ElseIf SCR->(dbSeek(xFilial("SCR")+SubStr(TITULOS->E2_TIPO,1,TamSX3("CR_TIPO")[1])+cNumSC))
		While SCR->(!Eof()) .And. SCR->CR_FILIAL == xFilial("SCR") .And. AllTrim(SCR->CR_NUM) == AllTRim(cNumSC)
			If SCR->CR_STATUS != "03"
				SCR->(dbSkip())
				Loop
			Endif
			cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"SAK->AK_NOME"))
			SCR->(dbSkip())
		EndDo
	ElseIf SCR->(dbSeek(xFilial("SCR")+SubStr("ZZ",1,TamSX3("CR_TIPO")[1])+cNumSC))
		While SCR->(!Eof()) .And. SCR->CR_FILIAL == xFilial("SCR") .And. AllTrim(SCR->CR_NUM) == AllTRim(cNumSC)
			If SCR->CR_STATUS != "03"
				SCR->(dbSkip())
				Loop
			Endif
			cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"SAK->AK_NOME"))
			SCR->(dbSkip())
		EndDo
	Else
		_cQuery	:= " SELECT CR_APROV"
		_cQuery	+= " FROM " + RetSqlName("SCR")
		_cQuery	+= " WHERE CR_NUM = '" + AllTRim(cNumSC) + "'"
		_cQuery	+= " AND CR_TIPO <> 'ZZ'"
		_cQuery	+= " AND CR_STATUS = '03'"
		_cQuery	+= " AND D_E_L_E_T_ = ' '"
		_cQuery	:= ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cAliasSCR)
		If (_cAliasSCR)->(!EOF())
			cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+(_cAliasSCR)->CR_APROV,"SAK->AK_NOME"))
		EndIf
		(_cAliasSCR)->(dbCloseArea())

	EndIf

ElseIf !Empty(cNumPA)
	
	dbSelectArea("ZZ6")
	ZZ6->(dbSetOrder(2))
	If ZZ6->(dbSeek(xFilial("ZZ6")+cNumPA))
	
		While ZZ6->(!Eof()) .And. ZZ6->ZZ6_FILIAL + ZZ6->ZZ6_PA == xFilial("ZZ6")+cNumPA
			If ZZ6->ZZ6_STATUS == "1"
				ZZ6->(dbSkip())
				Loop
			Endif
			
			If cNivel < ZZ6->ZZ6_NIVEL
				cNivel 		:= ZZ6->ZZ6_NIVEL
				
				If AllTrim(ZZ6->ZZ6_APROV) == "PCO"
					cNomeAprv	:= "APROVADO VIA PCO"
				Else
					cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+ZZ6->ZZ6_APROV,"SAK->AK_NOME"))
				EndIf
			EndIf
			ZZ6->(dbSkip())
		EndDo
	ElseIf SCR->(dbSeek(xFilial("SCR")+SubStr(TITULOS->E2_TIPO,1,TamSX3("CR_TIPO")[1])+cNumPA))
		While SCR->(!Eof()) .And. SCR->CR_FILIAL == xFilial("SCR") .And. AllTrim(SCR->CR_NUM) == AllTrim(cNumPA)
			If SCR->CR_STATUS != "03"
				SCR->(dbSkip())
				Loop
			Endif
			cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"SAK->AK_NOME"))
			SCR->(dbSkip())
		EndDo
	ElseIf SCR->(dbSeek(xFilial("SCR")+SubStr("ZZ",1,TamSX3("CR_TIPO")[1])+cNumPA))
		While SCR->(!Eof()) .And. SCR->CR_FILIAL == xFilial("SCR") .And. AllTrim(SCR->CR_NUM) == AllTRim(cNumPA)
			If SCR->CR_STATUS != "03"
				SCR->(dbSkip())
				Loop
			Endif
			cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"SAK->AK_NOME"))
			SCR->(dbSkip())
		EndDo
	Else
		_cQuery	:= " SELECT CR_APROV"
		_cQuery	+= " FROM " + RetSqlName("SCR")
		_cQuery	+= " WHERE CR_NUM = '" + AllTRim(cNumPA) + "'"
		_cQuery	+= " AND CR_TIPO = 'ZZ'"
		_cQuery	+= " AND CR_STATUS = '03'"
		_cQuery	+= " AND D_E_L_E_T_ = ' '"
		_cQuery	:= ChangeQuery(_cQuery)
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cAliasSCR)
		If (_cAliasSCR)->(!EOF())
			cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+(_cAliasSCR)->CR_APROV,"SAK->AK_NOME"))
		EndIf
		(_cAliasSCR)->(dbCloseArea())
	EndIf
//MsgAlert("Laço 2 " + cNomeAprv)	
Endif
/////////////////////////////////////////////////////////////////////////////
// Autor | Denis D De Almeida | Data | 13/10/2015 | Hora | 16:40
// Motivo| Verifica alçadas de Aprovação na SCR dispensando validações
//       | na ZZ6 - customizada para a T4F 
//       | As validações customizadas não foram excluídas pois se necessário
//       | pode-se retomar a validação customizada ZZ6/ZZ5 
/////////////////////////////////////////////////////////////////////////////
If( _mv_SCR ) .and. !empty(cNumPc)
	_cQuery	:= " SELECT DISTINCT CR_APROV "
	_cQuery	+= "   FROM "+RetSqlName("SCR")+" "
	_cQuery	+= " WHERE CR_NUM = '"+AllTrim(cNumPc)+"' "
	_cQuery	+= "      AND CR_TIPO <> 'ZZ' " 
	_cQuery	+= "      AND CR_STATUS = '03' " 
	_cQuery	+= "      AND D_E_L_E_T_ = '  ' "
	_cQuery	+= "      AND R_E_C_N_O_ IN " 
	_cQuery	+= "     ( SELECT MAX(R_E_C_N_O_) " 
	_cQuery	+= "          FROM "+RetSqlName("SCR")+" " 
	_cQuery	+= "        WHERE CR_NUM = '"+AllTrim(cNumPc)+"' " 
	_cQuery	+= "             AND CR_TIPO <> 'ZZ' " 
	_cQuery	+= "             AND CR_STATUS = '03' " 
	_cQuery	+= "             AND D_E_L_E_T_ = '  ' ) "
	_cQuery	:= ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cAliasSCR)
	If (_cAliasSCR)->(!EOF())
		cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+(_cAliasSCR)->CR_APROV,"SAK->AK_NOME"))
	EndIf
	(_cAliasSCR)->(dbCloseArea())	
EndIf
If( _mv_SCR ) .and. empty(cNumPc)
	cNumPc := AllTrim(TITULOS->E2_NUM)

	_cQuery	:= " SELECT DISTINCT CR_APROV "
	_cQuery	+= "   FROM "+RetSqlName("SCR")+" "
	_cQuery	+= " WHERE CR_NUM = '"+AllTrim(cNumPc)+"' "
	_cQuery	+= "      AND CR_TIPO = 'ZZ' " 
	_cQuery	+= "      AND CR_STATUS = '03' " 
	_cQuery	+= "      AND D_E_L_E_T_ = '  ' "
	_cQuery	+= "      AND R_E_C_N_O_ IN " 
	_cQuery	+= "     ( SELECT MAX(R_E_C_N_O_) " 
	_cQuery	+= "          FROM "+RetSqlName("SCR")+" " 
	_cQuery	+= "        WHERE CR_NUM = '"+AllTrim(cNumPc)+"' " 
	_cQuery	+= "             AND CR_TIPO = 'ZZ' " 
	_cQuery	+= "             AND CR_STATUS = '03' " 
	_cQuery	+= "             AND D_E_L_E_T_ = '  ' ) "
	_cQuery	:= ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),_cAliasSCR)
	If (_cAliasSCR)->(!EOF())
		cNomeAprv	:= AllTrim(Posicione("SAK",1,xFilial("SAK")+(_cAliasSCR)->CR_APROV,"SAK->AK_NOME"))
	EndIf
	(_cAliasSCR)->(dbCloseArea())	
EndIf

RestArea(aArea)

if TITULOS->E2_PREFIXO='LOL' .or. TITULOS->E2_TIPO='LOL' .or. TITULOS->E2_TIPO='GLS' 
	cNomeAprv :=  TITULOS->E2_APROVA
endif
if TITULOS->E2_PREFIXO='POP' .or. TITULOS->E2_TIPO='POP'
	cNomeAprv :=  TITULOS->E2_APROVA
endif

Return(cNomeAprv)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³Ret_FaturaºAutor  ³Bruno Daniel Borges ?Data ? 08/04/08   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao que retorna um array com os dados dos titulos que    º±?
±±?         ³compoe uma fatura                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?T4F                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function Ret_Fatura(cFatura,_cFornece)
Local aRetorno	:= {}
Local cQuery	:= ""
Local cAprov	:= ""
Local cQuery,cQuerySC7
Local bQuery 	 := {|| Iif(Select("TRB_FAT") > 0, TRB_FAT->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_FAT",.F.,.T.), dbSelectArea("TRB_FAT"), TRB_FAT->(dbGotop())}
Local bQuerySC7 := {|| Iif(Select("TRB_SC7") > 0, TRB_SC7->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuerySC7),"TRB_SC7",.F.,.T.), dbSelectArea("TRB_SC7"), TRB_SC7->(dbGotop()) }
Local bQueryZZE := {|| Iif(Select("TRB_ZZE") > 0, TRB_ZZE->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQueryZZE),"TRB_ZZE",.F.,.T.), dbSelectArea("TRB_ZZE"), TRB_ZZE->(dbGotop()) }
Local cNumSA    := ''
Local cTipo     := 0
Local cNumSC    := ''
Local _cSolicit	:= ""
Local cQueryZZE	:= ""

/*
Nova Query
*/

cQuery:= ' '
cQuery +="SELECT "
cQuery +=	"SE2.E2_FORNECE, "
cQuery +=	"SE2.E2_LOJA, "
cQuery +=	"SE2.E2_HIST, "
cQuery +=	"SE2.E2_PREFIXO, "
cQuery += 	"SE2.E2_NUM, "
cQuery += 	"SE2.E2_PARCELA, "
cQuery += 	"SE2.E2_VALOR, "
cQuery += 	"SE2.E2_TIPO, "
cQuery += 	"SE2.E2_SALDO, "
cQuery += 	"SE2.E2_NUMPC, "
cQuery += 	"SE2.E2_USERLGI, "
cQuery += 	"SE2.E2_NUMSPA, "
cQuery += " CASE WHEN E2_ORIGEM = 'GPEM670' THEN 'Folha' "+_EOL
cQuery += "             WHEN E2_ORIGEM = 'MATA100' THEN 'NF Entrada' "+_EOL
cQuery += "             WHEN E2_ORIGEM = 'MATA460' THEN 'NF Saída' "+_EOL
cQuery += "             WHEN E2_ORIGEM = 'MATA953' OR E2_ORIGEM = 'MATA954' OR E2_ORIGEM = 'MATA565' THEN 'Imposto' "+_EOL
cQuery += "             ELSE 'Financeiro' "+_EOL
cQuery += "        END AS E2_ORIGEM "+_EOL
cQuery +="FROM "+RetSqlName("SE2")+" SE2 "
cQuery +="WHERE SE2.D_E_L_E_T_ = ' ' AND "
cQuery +=		 "SE2.E2_FATURA = '" + cFatura + "' "
cQuery +=		 "AND E2_FORNECE = '" + _cFornece + "' "

MemoWrite("c:\query_2.txt",cQuery)

Eval(bQuery)

While TRB_FAT->(!Eof())
	_cSolicit	:= ""
	
	If !Empty(TRB_FAT->E2_NUMSPA)
		cQueryZZE	:= "SELECT ZZE_USERID FROM " + RetSqlName("ZZE")
		cQueryZZE	+= " WHERE ZZE_FILIAL = '" + xFilial("ZZE") + "' "
		cQueryZZE	+= " AND ZZE_NUMERO = '" + TRB_FAT->E2_NUMSPA + "' "
		Eval(bQueryZZE)
		
		If TRB_ZZE->(!EOF())
			_cSolicit	:= UsrFullName(TRB_ZZE->ZZE_USERID)
		EndIf
		TRB_ZZE->( DbCloseArea() )
		
	EndIf
	
	If !Empty(TRB_FAT->E2_NUMPC)
		
		// Clausula Top Nao funciona em Oracle.
		cQuerySC7:= "select c7_numsc,c7_tipo, c7_solicit from ("
		cQuerySC7+= 		"select sc7.* "
		cQuerySC7+=				"from "+RetSqlName("sc7")+" sc7 "
		cQuerySC7+= 			"where sc7.c7_num='"+TRB_FAT->E2_NUMPC+"' and sc7.d_e_l_e_t_ = ' ' "
		cQuerySC7+=				"order by sc7.c7_numsc desc ) "
		cQuerySC7+=		"where rownum =1 "
		
		Eval(bQuerySC7)
		
		If TRB_SC7->(!EOF())
			cTipo  		:= TRB_SC7->C7_TIPO
			cNumSC 		:= TRB_SC7->C7_NUMSC
			If Empty(_cSolicit)
				_cSolicit	:= TRB_SC7->C7_SOLICIT
			EndIf
			TRB_SC7->( DbCloseArea() )
		EndIf
		
	EndIf
	
	cAprov := ""
	//If TRB_FAT->C7_TIPO <> 2 .And. !Empty(TRB_FAT->C7_NUMSC) // Desconsidera contratos de Parcerias/Autorizacoes de Entrega
	If cTipo <> 2 .And. !Empty(cNumSC) // Desconsidera contratos de Parcerias/Autorizacoes de Entrega
		cAprov := Upper(Ret_Aprovador("01",cNumSC,,TRB_FAT->E2_NUMPC))
	EndIf
	// Procura pelo aprovador atraves da solicitacao de adiantamento.
	If Empty(cAprov) .And. Empty(TRB_FAT->E2_NUMPC)
		cNumSA:= RetNumSA(TRB_FAT->E2_PREFIXO,TRB_FAT->E2_NUM,TRB_FAT->E2_PARCELA,TRB_FAT->E2_FORNECE,TRB_FAT->E2_LOJA)
		cAprov := Upper(Ret_Aprovador("01",,cNumSA,TRB_FAT->E2_NUMPC))
	EndIf
	
	// Repasse nao possui aprovadores
	If Empty(cAprov) .And. Subs(TRB_FAT->E2_NUM,1,2) == "SR"
		cAprov:= "** REPASSE"
	EndIf
	
	AAdd(aRetorno,{	TRB_FAT->E2_PREFIXO,;
	TRB_FAT->E2_NUM,;
	TRB_FAT->E2_PARCELA,;
	TRB_FAT->E2_TIPO,;
	TRB_FAT->E2_VALOR,;
	TRB_FAT->E2_SALDO,;
	TRB_FAT->E2_NUMPC,;
	Iif( Empty(TRB_FAT->E2_NUMPC),cNumSA,cNumSC),;
	cTipo,;
	"01",;
	cAprov,;
	TRB_FAT->E2_HIST,;
	TRB_FAT->E2_ORIGEM,;
	_cSolicit })
	
	// Zera variaveis
	cNumSA := ''
	cTipo  := 0
	cNumSC := ''
	cAprov := ""
	
	// Proximo Registro.
	TRB_FAT->(dbSkip())
	
EndDo

Return(aRetorno)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³RetStrFormºAutor  ³Gilberto            ?Data ? 19/04/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Retorna a string formadata para uso em SQL IN.             º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/

Static Function QueryTwo(nTotReg,cBorderos)

Local bQuery:= {|| Iif(Select("TITULOS") > 0, TITULOS->(dbCloseArea()),Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TITULOS",.F.,.T.), dbSelectArea("TITULOS"),FormatField() , TITULOS->(dbEval({|| nTotReg++})), TITULOS->(dbGoTop()) }
Local cQuery:= ''
Local _cArqTrb,_cIndex,_cKey

if mv_par02 == 1 //Quebra DOC e TED
	cQuery += " SELECT CASE WHEN EA_MODELO = '03' AND E2_VALOR <= 5000 THEN '03' "+_EOL
	cQuery += "             WHEN EA_MODELO = '03' AND E2_VALOR > 5000 THEN '41' "+_EOL
	cQuery += "             ELSE EA_MODELO "+_EOL
	cQuery += "        END AS EA_MODELO, "+_EOL
Else
	cQuery += " SELECT EA_MODELO, "+_EOL
EndIf
cQuery+= 	"A.E2_EMISSAO, "+_EOL
cQuery+= 	"A.E2_VENCTO, "+_EOL
cQuery+= 	"B.EA_DATABOR, "+_EOL
cQuery+= 	"A.E2_PREFIXO, "+_EOL
cQuery+= 	"A.E2_NUM, "+_EOL
cQuery+= 	"A.E2_TIPO, "+_EOL
cQuery+= 	"A.E2_PARCELA, "+_EOL
cQuery+= 	"A.E2_FORNECE, "+_EOL
cQuery+= 	"A.E2_LOJA, "+_EOL
cQuery+= 	"A.E2_APROVA, "+_EOL
cQuery+= 	"C.A2_NOME, "+_EOL
cQuery+= 	"C.A2_BANCO, "+_EOL
cQuery+= 	"C.A2_AGENCIA, "+_EOL
cQuery+= 	"C.A2_NUMCON, "+_EOL
cQuery+= 	"A.E2_HIST, "+_EOL
cQuery+= 	"A.E2_VALOR, "+_EOL
cQuery+= 	"A.E2_SALDO, "+_EOL
cQuery+= 	"A.E2_NUMPC, "+_EOL
/*cQuery+= "( SELECT ZZE_NUMERO AS ZZENUM "+_EOL
cQuery+= 	"FROM ZZE080 WHERE ZZE_FILIAL = '"+XFILIAL("ZZE")+"' AND "+_EOL
cQuery+=		"ZZE_PREF = A.E2_PREFIXO AND "+_EOL
cQuery+=		"ZZE_TITULO = A.E2_NUM AND "+_EOL
cQuery+=		"ZZE_PARC = A.E2_PARCELA AND "+_EOL
cQuery+=		"ZZE_FORNEC = A.E2_FORNECE AND "+_EOL
cQuery+=		"ZZE_LOJA = A.E2_LOJA AND "+_EOL
cQuery+=		"D_E_L_E_T_ = ' ' ) ZZE_NUMERO, "+_EOL*/
cQuery+= 	"MAX(G.C7_NUMSC) AS C7_NUMSC, "+_EOL
cQuery+= 	"MAX(G.C7_TIPO) AS C7_TIPO,  "+_EOL
cQuery += " A.E2_NUMSPA, "
cQuery += " CASE WHEN A.E2_ORIGEM = 'GPEM670' THEN 'Folha' "+_EOL
cQuery += "             WHEN A.E2_ORIGEM = 'MATA100' THEN 'NF Entrada' "+_EOL
//cQuery += "             WHEN A.E2_ORIGEM = 'MATA460' THEN 'NF Saída' "+_EOL
//cQuery += "             WHEN A.E2_ORIGEM = 'MATA953' OR E2_ORIGEM = 'MATA954' OR E2_ORIGEM = 'MATA565' THEN 'Imposto' "+_EOL
cQuery += "             ELSE 'Financeiro' "+_EOL
cQuery += "        END AS E2_ORIGEM "+_EOL
cQuery+= "FROM "+RetSqlName("SE2")+" A INNER JOIN "+RetSqlName("SEA")+" B ON "+_EOL
cQuery+= 	"B.EA_FILIAL  = '"+XFILIAL("SEA")+"' AND "+_EOL
cQuery+= 	"B.EA_NUMBOR  = A.E2_NUMBOR AND "+_EOL
cQuery+= 	"B.EA_PREFIXO = A.E2_PREFIXO AND "+_EOL
cQuery+= 	"B.EA_NUM     = A.E2_NUM AND "+_EOL
cQuery+= 	"B.EA_PARCELA = A.E2_PARCELA AND "+_EOL
cQuery+= 	"B.EA_TIPO    = A.E2_TIPO AND "+_EOL
cQuery+=		"B.EA_CART    = 'P' AND "+_EOL
cQuery+= 	"B.D_E_L_E_T_ = ' ' "+_EOL
cQuery+= "INNER JOIN "+RetSqlName("SA2")+" C ON "+_EOL
cQuery+= 	"C.A2_FILIAL  = '"+XFILIAL("SA2")+"' AND "+_EOL
cQuery+= 	"C.A2_COD     = A.E2_FORNECE AND "+_EOL
cQuery+= 	"C.A2_LOJA    = A.E2_LOJA AND "+_EOL
cQuery+= 	"C.D_E_L_E_T_ = ' ' " +_EOL
cQuery+= "LEFT OUTER JOIN "+RetSqlName("SF1")+" E ON "+_EOL
cQuery+= 	"E.F1_DOC     = A.E2_NUM AND "+_EOL
cQuery+= 	"E.F1_SERIE   = A.E2_PREFIXO AND "+_EOL
cQuery+= 	"E.F1_FORNECE = A.E2_FORNECE AND "+_EOL
cQuery+= 	"E.F1_LOJA    = A.E2_LOJA AND "+_EOL
cQuery+= 	"E.D_E_L_E_T_ = ' ' "+_EOL
cQuery+= "LEFT OUTER JOIN "+RetSqlName("SD1")+" F ON "+_EOL
cQuery+= 	"F.D1_DOC     = A.E2_NUM AND "+_EOL
cQuery+= 	"F.D1_SERIE   = A.E2_PREFIXO AND "+_EOL
cQuery+= 	"F.D1_FORNECE = A.E2_FORNECE AND "+_EOL
cQuery+= 	"F.D1_LOJA    = A.E2_LOJA AND "+_EOL
cQuery+= 	"F.D_E_L_E_T_ = ' ' "+_EOL
cQuery+= "LEFT OUTER JOIN "+RetSqlName("SC7")+" G ON "+_EOL
cQuery+= 	"G.C7_FILIAL  = '"+XFILIAL("SC7")+"' AND "+_EOL
cQuery+= 	"G.C7_NUM     = F.D1_PEDIDO AND "+_EOL
cQuery+= 	"G.D_E_L_E_T_ = ' ' "+_EOL
cQuery+= "WHERE A.E2_FILIAL = '"+XFILIAL("SE2")+"' AND "+_EOL
cQuery+= 	"A.E2_NUMBOR IN ("+cBorderos+") AND "+_EOL
cQuery+= 	"A.D_E_L_E_T_ = ' ' "+_EOL

// Quebra DOC e TED
If mv_par02 == 1
	cQuery += " GROUP BY CASE WHEN EA_MODELO = '03' AND E2_VALOR <= 5000 THEN '03' "+_EOL
	cQuery += "               WHEN EA_MODELO = '03' AND E2_VALOR >  5000 THEN '41' "+_EOL
	cQuery += "          ELSE EA_MODELO "+_EOL
	cQuery += "          END,	  "+_EOL
Else
	cQuery += " GROUP BY EA_MODELO, " +_EOL
EndIf
cQuery+=  "	E2_EMISSAO, EA_DATABOR, E2_VENCTO, E2_PREFIXO, "+_EOL
cQuery+= 	"E2_NUM, E2_TIPO, E2_PARCELA, E2_FORNECE, E2_LOJA, E2_APROVA, A2_NOME, "+_EOL
cQuery+= 	"A2_BANCO, A2_AGENCIA, A2_NUMCON, E2_HIST, E2_VALOR, E2_SALDO, "+_EOL
cQuery+= 	"E2_NUMPC,E2_NUMSPA,E2_ORIGEM "+_EOL
cQuery+= 	"ORDER BY EA_MODELO, E2_VALOR DESC "
//cQuery+= 	"ORDER BY EA_MODELO, ZZE_NUMERO, E2_VALOR DESC "

cQuery:= ChangeQuery(cQuery)

MemoWrite("c:\query_t4frelfin2.txt",cQuery)
LjMsgRun("Executando Pesquisa...","Aguarde...",bQuery)

// Joga para arquivo padrao para usar no browse
/*
_cArqTrb:= CriaTrab(nil,.f.)
_cIndex := CriaTrab(nil,.f.)
_cKey   := "EA_MODELO + ZZE_NUMERO + STR(E2_VALOR,15,2)"

Copy To &(_cArqTrb+OrdBagExt())
DbCloseArea()
IF Select("TITULOS") > 0
DbSelectArea("TITULOS")
DbCloseArea()
EndIF

DbUseArea( .T.,__LocalDriver,_cArqTrb+OrdBagExt(), "TITULOS",.T., .T. )
IndRegua("TITULOS",_cIndex,_cKey,,,OemToAnsi("Indexando Registros..."))
*/

DbSelectArea("TITULOS")
//DbSetOrder(1)
DbGotop()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³FormatFielºAutor  ³Gilberto            ?Data ? 19/04/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Formata dos campos data e valores da query.                º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function FormatField()

Local aTamSxe:= {}

// Compatibiliza os campos com a TopField
aTamSX3	:= TamSX3("E2_EMISSAO")
TcSetField("TITULOS", "E2_EMISSAO",aTamSX3[3],aTamSX3[1],aTamSX3[2])

aTamSX3	:= TamSX3("E2_VENCTO")
TcSetField("TITULOS", "E2_VENCTO",aTamSX3[3],aTamSX3[1],aTamSX3[2])

aTamSX3	:= TamSX3("E2_VALOR")
TcSetField("TITULOS", "E2_VALOR",aTamSX3[3],aTamSX3[1],aTamSX3[2])

aTamSX3	:= TamSX3("E2_SALDO")
TcSetField("TITULOS", "E1_SALDO",aTamSX3[3],aTamSX3[1], aTamSX3[2])

aTamSX3	:= TamSX3("EA_DATABOR")
TcSetField("TITULOS", "EA_DATABOR",aTamSX3[3], aTamSX3[1], aTamSX3[2])

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³RetStrFormºAutor  ³Gilberto            ?Data ? 19/04/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Retorna a string formadata para uso em SQL IN.             º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/
Static Function RetStrForm( cBorderos )

Local i  // Recorta os numeros de borderos
Local nUltPos:= 1

// Recorta os numeros de borderos
If !("," $ AllTrim(mv_par01))
	cBorderos := "'" + AllTrim(mv_par01) + "'"
Else
	For i := 1 To Len(AllTrim(mv_par01))
		If SubStr(mv_par01,i,1) $ ";|,|." .Or. Len(AllTrim(mv_par01)) == i
			If nUltPos == 0
				cBorderos += "'"+SubStr(mv_par01,nUltPos,i-nUltPos)+"',"
			Else
				cBorderos += "'"+StrTran(SubStr(mv_par01,nUltPos,i-(nUltPos-1)),",","")+"',"
			EndIf
			nUltPos := i + 1
		EndIf
	Next i
	cBorderos := SubStr(cBorderos,1,Len(cBorderos)-1)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ?ValidSX1 ºAutor  ³Bruno Daniel Borges ?Data ? 22/06/05   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao que valida as perguntas do SX1 e cria os novos regis-º±?
±±?         ³tros                                                        º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?T4F                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function ValidSX1(aPergunt)
Local aAreaBKP := GetArea()
Local cGrpPerg := ""
Local lTipLocl := .T.
Local i

dbSelectArea("SX1")
SX1->(dbSetOrder(1))
SX1->(dbGoTop())

If Len(aPergunt) <= 0
	Return(Nil)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ??
//³Valida as perguntas do usuario?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ??
cGrpPerg := padr(aPergunt[1,1],len(X1_GRUPO))
For i := 1 To Len(aPergunt)
	lTipLocl := !SX1->(dbSeek(cGrpPerg+aPergunt[i,2]))
	SX1->(RecLock("SX1",lTipLocl))
	SX1->X1_GRUPO		:= cGrpPerg
	SX1->X1_ORDEM		:= aPergunt[i,2]
	SX1->X1_PERGUNT		:= aPergunt[i,3]
	SX1->X1_PERSPA		:= aPergunt[i,3]
	SX1->X1_PERENG		:= aPergunt[i,3]
	SX1->X1_VARIAVL		:= aPergunt[i,4]
	SX1->X1_TIPO		:= aPergunt[i,5]
	SX1->X1_TAMANHO		:= aPergunt[i,6]
	SX1->X1_DECIMAL		:= aPergunt[i,7]
	SX1->X1_GSC			:= aPergunt[i,8]
	SX1->X1_VALID		:= aPergunt[i,09]
	SX1->X1_VAR01		:= aPergunt[i,10]
	SX1->X1_DEF01		:= aPergunt[i,11]
	SX1->X1_DEF02		:= aPergunt[i,12]
	SX1->X1_DEF03		:= aPergunt[i,13]
	SX1->X1_DEF04		:= aPergunt[i,14]
	SX1->X1_DEF05		:= aPergunt[i,15]
	SX1->X1_F3			:= aPergunt[i,16]
	SX1->X1_PICTURE		:= aPergunt[i,17]
	SX1->(MsUnlock())
Next i

RestArea(aAreaBKP)

Return(Nil)
