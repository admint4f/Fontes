#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAJ002    º Autor ³ AP6 IDE            º Data ³  17/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RELSZI


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Vendas Diarias"
Local cPict          := ""
Local titulo       := "VENDAS DIARIAS SHOWS - ESPECIFICO CIE BRASIL"
Local nLin         := 80        
                   //           1         2         3         4         5         6         7         8         9         0         1         2
                   //  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       := " EVENTO            DESCRIÇÃO              QUANT. %REAL. VALOR VENDA %REAL. VAL.PREV. VAL.PREV.   DATA        HORA         CORTE- PREÇO"
Local Cabec2       := "                                                 QUANT.              VALOR ANALISE    ANALISE    VENDA             IMOVEL SIAS   MÉDIO"                                    
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RELSZI-CIE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RSZI"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "VENDAS DIARIAS" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZI"
	xtotq := 0
	xtotv := 0
	xtotp := 0
	xtotr := 0
	xtotc := 0
	XTOTANQ := 0
	XTOTANV := 0
	xtotanp := 0
	xtotanr := 0
	xtotanc := 0
dbSelectArea("SZI")
dbSetOrder(5)


pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  17/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O tratamento dos parametros deve ser feito dentro da logica do seu  ³
//³ relatorio. Geralmente a chave principal e a filial (isto vale prin- ³
//³ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ³
//³ meiro registro pela filial + pela chave secundaria (codigo por exem ³
//³ plo), e processa enquanto estes valores estiverem dentro dos parame ³
//³ tros definidos. Suponha por exemplo o uso de dois parametros:       ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³ Assim o processamento ocorrera enquanto o codigo do registro posicio³
//³ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ³
//³ limite para o processamento. Caso existam outros parametros a serem ³
//³ checados, isto deve ser feito dentro da estrutura de laço (WHILE):  ³
//³                                                                     ³
//³ mv_par01 -> Indica o codigo inicial a processar                     ³
//³ mv_par02 -> Indica o codigo final a processar                       ³
//³ mv_par03 -> Considera qual estado?                                  ³
//³                                                                     ³
//³ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ³
//³ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ³
//³                                                                     ³
//³     If A1_EST <> mv_par03                                           ³
//³         dbSkip()                                                    ³
//³         Loop                                                        ³
//³     Endif                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbGoTop() 
DbSeek(xFilial("SZI")+dtos(mv_par01),.T.)
While !EOF() .And. SZI->ZI_FILIAL = xFilial("SZI") .And. SZI->ZI_DATA <= mv_par02
//While !EOF()
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

   nLin := nLin + 1 // Avanca a linha de impressa
XEV  := SZI->ZI_CLAVE   
XANA := SZI->ZI_ANALISE
   @ nLin,1  PSAY SZI->ZI_EVENTO
   @ nLin,10 PSAY SZI->ZI_DESC
   @ nLin,41 PSAY SZI->ZI_QUANT  PICTURE "999,999"
   @ nLin,49 PSAY (SZI->ZI_QUANT/SZI->ZI_QPREV)*100 PICTURE "999"
   @ nLin,52 PSAY "%"
   @ nLin,54 PSAY SZI->ZI_VALOR  PICTURE "9,999,999.99"
   @ nLin,70 PSAY (SZI->ZI_VALOR/SZI->ZI_VPREV)*100 PICTURE "999"
   @ nLin,73 PSAY "%"
   @ nLin,75 PSAY SZI->ZI_QPREV PICTURE "999,999"
   @ nLin,83 PSAY SZI->ZI_VPREV PICTURE "9,999,999.99"
   @ nLin,96 PSAY SZI->ZI_DATA   
   @ nLin,107 PSAY SZI->ZI_HORA
   @ nLin,118 PSAY SZI->ZI_IMOVEL
   @ nLin,122 PSAY SZI->ZI_CORTES PICTURE "9999"
   @ nLin,127 PSAY (SZI->ZI_VALOR/SZI->ZI_QUANT) PICTURE "999.99"
   
   xtotq := xtotq + SZI->ZI_QUANT
   xtotv := xtotv + SZI->ZI_VALOR
   xtotp := xtotp + SZI->ZI_QPREV
   xtotr := xtotr + SZI->ZI_VPREV
   xtotc := xtotc + SZI->ZI_CORTES
   XTOTANQ := XTOTANQ + SZI->ZI_QUANT
   XTOTANV := XTOTANV + SZI->ZI_VALOR
   XTOTANP := XTOTANP + SZI->ZI_QPREV
   XTOTANR := XTOTANR + SZI->ZI_VPREV
   XTOTANC := XTOTANC + SZI->ZI_CORTES
   
   dbSkip() // Avanca o ponteiro do registro no arquivo

XEV2 = SZI->ZI_CLAVE
XANA2 = SZI->ZI_ANALISE

IF XEV2 <> XEV
nLin := nLin + 1
    @ nlin,1  psay "Total Evento"
    @ nlin,41 PSAY xtotq Picture "999,999"
    @ nlin,49 PSAY (xtotq/xtotp)*100 Picture "999"
    @ nLin,52 PSAY "%"
	@ nlin,54 PSAY xtotv Picture "9,999,999.99"
	@ nlin,70 PSAY (xtotv/xtotr)*100 Picture "999"
    @ nLin,73 PSAY "%"
    @ nlin,75 PSAY xtotp Picture "999,999"
	@ nlin,83 PSAY xtotr Picture "9,999,999.99"
	@ nLin,122 PSAY xtotc PICTURE "9999"
	@ nlin,127 psay (xtotv/xtotq) picture "999.99"
	
	nLin := nLin + 1

        @ nLin,1 PSAY "------------------------------------------------------------------------------------------------------------------------------------"
	xtotq := 0
	xtotv := 0
	xtotp := 0
	xtotr := 0
	xtotc := 0
 ENDIF
      
IF XANA <> XANA2
nLin := nLin + 1
    @ nlin,1  psay "Total Analise"
    @ nLin,15 psay xana
	@ nlin,41 PSAY xtotanq Picture "999,999"
	@ nlin,49 PSAY (xtotanq/xtotanp)*100 Picture "999"
    @ nLin,52 PSAY "%"
	@ nlin,54 PSAY xtotanv Picture "9,999,999.99"
	@ nlin,70 PSAY (xtotanv/xtotanr)*100 Picture "999"
    @ nLin,73 PSAY "%"
    @ nlin,75 PSAY xtotanp Picture "999,999"
	@ nlin,83 PSAY xtotanr Picture "9,999,999.99"
	@ nLin,122 PSAY xtotanc PICTURE "9999"
	@ nlin,127 psay (xtotanv/xtotanq) picture "999.99"
    nLin := nLin + 1	
	@ nlin,1 psay "===================================================================================================================================="
	nLin := nLin + 1
	

dbSelectArea("SZL")
dbSetOrder(2)
dbGoTop() 
IF DbSeek(xFilial("SZL")+XANA,.T.)
	Reclock("SZL",.F.)
  	SZL->ZL_QUANREA := xtotanq
	SZL->ZL_VENDASR := xtotanv
	SZL->ZL_PMEDIOR := (xtotanv/xtotanq)
	SZL->ZL_CORTESI := xtotanc     
	SZL->(Msunlock())
ENDIF

    xtotanq := 0
	xtotanv := 0
	xtotanp := 0
	xtotanr := 0
	xtotanc := 0 
 
dbSelectArea("SZI")
dbSetOrder(5)
 
 ENDIF

EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
