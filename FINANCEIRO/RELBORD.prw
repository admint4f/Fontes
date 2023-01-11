#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELBORD   º Autor ³ AP6 IDE            º Data ³  16/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

/*/

User Function RELBORD()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "BORDERO DE PAGAMENTOS " +  " - ESPECIFICO CIE"
Local cPict          := ""
Local titulo       := "BORDERO DE PAGAMENTOS " +  " - ESPECIFICO CIE"
Local nLin         := 80

                 //    1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       := "DOCUMENTO  BANCO       VALOR   CODIGO    NOME FORNECEDOR   VENCIMENTO    CNPJ/CPF  BANCO AGENCIA CONTA DV     "
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "BORD-CIE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "CSE2"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "BORD-CIE" // Coloque aqui o nome do arquivo usado para impressao em disco


Private cString := "SE2"

//dbSelectArea("")
//dbSetOrder(1)


pergunte(cPerg,.T.)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//titulo = titulo + " " + desccc
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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  16/06/05   º±±
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
Local aAnalise1 := {}   
Local aAnalise2 := {}   
Local aAnalise3 := {}

Local ntotal := 0
Local ndoc   := 0
Local nted   := 0
Local nbol   := 0
titulo       := "BORDERO DE PAGAMENTOS " + mv_par01 + " Agencia " + mv_par02 + " Conta Corrente " + mv_par03

//aAdd(aAnalise, { ,DESCCC,"" ,"   " , "" ,"","" ,"" ,"" ,"" ,"" ,"",})
dbSelectArea("SE2")
dbSetOrder(15)
dbGotop()

DbSeek(xFilial("SE2")+ mv_par01,.T.)

While !Eof() .And. SE2->E2_NUMBOR = mv_par01 
// DOC
TIPOB:= Posicione("SEA",1,xFilial("SEA")+mv_par01+SE2->E2_PREFIXO+SE2->E2_NUM,"SEA->EA_MODELO")

        IF  TIPOB == "31"
           dbSkip()
           Loop
        ENDIF
        
        IF E2_VALOR > 5000
           dbSkip()
           loop
        ENDIF
           
        CNPJ    := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_CGC")
        BANCO   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_BANCO")
        AGENCIA := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_AGENCIA")
        CONTA   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_NUMCON")
        DIGITO  := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_DVCONTA")
        
        
        CNPJ := STRZERO(VAL(CNPJ),14)                                
        
//        OBS  := SUBS(Posicione("SC7",1,xFilial("SC7")+SE2->E2_NUMPC,"C7_OBS"),1,60)                                                                       

//		aAdd(aAnalise1, { E2_PREFIXO, E2_NUM, E2_PORTADO , STR(E2_VALOR,14,2), E2_FORNECE , E2_NOMFOR, DTOS(E2_VENCREA), CNPJ, BANCO, AGENCIA, CONTA, DIGITO  })
        aAdd(aAnalise1, { E2_PREFIXO, E2_NUM, E2_PORTADO , E2_VALOR , E2_FORNECE , E2_NOMFOR, DTOS(E2_VENCREA), CNPJ, BANCO, AGENCIA, CONTA, DIGITO  })
        nTotal := nTotal + (E2_VALOR)
        nDoc   := nDoc + (E2_VALOR)
		dbSkip()
EndDo


dbGotop()

DbSeek(xFilial("SE2")+ mv_par01,.T.)

While !Eof() .And. SE2->E2_NUMBOR = mv_par01 
// TED
TIPOB:= Posicione("SEA",1,xFilial("SEA")+mv_par01+SE2->E2_PREFIXO+SE2->E2_NUM,"SEA->EA_MODELO")

        IF TIPOB == "31"
           dbSkip()
           Loop
        ENDIF

         IF E2_VALOR < 5001
            dbSkip()
            loop
         ENDIF
        
        CNPJ := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_CGC")
        BANCO   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_BANCO")
        AGENCIA := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_AGENCIA")
        CONTA   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_NUMCON")
        DIGITO  := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_DVCONTA")
        
        CNPJ := STRZERO(VAL(CNPJ),14)                                
        

	aAdd(aAnalise2, { E2_PREFIXO, E2_NUM, E2_PORTADO , E2_VALOR, E2_FORNECE , E2_NOMFOR, DTOS(E2_VENCREA), CNPJ, BANCO , AGENCIA, CONTA , DIGITO })
        nTotal := nTotal + (E2_VALOR)
        nTed   := nTEd + (E2_VALOR)
		dbSkip()

EndDo


 dbGotop()

DbSeek(xFilial("SE2")+ mv_par01,.T.)

While !Eof() .And. SE2->E2_NUMBOR = mv_par01 
// BOLETO

TIPOB:= Posicione("SEA",1,xFilial("SEA")+mv_par01+SE2->E2_PREFIXO+SE2->E2_NUM,"SEA->EA_MODELO")

        IF TIPOB <> "31"
           dbSkip()
           Loop
        ENDIF

        
        CNPJ := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_CGC")
        BANCO   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_BANCO")
        AGENCIA := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_AGENCIA")
        CONTA   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_NUMCON")
        DIGITO  := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE,"SA2->A2_DVCONTA")
        
        CNPJ := STRZERO(VAL(CNPJ),14)                                

        aAdd(aAnalise2, { E2_PREFIXO, E2_NUM, E2_PORTADO , E2_VALOR, E2_FORNECE , E2_NOMFOR, DTOS(E2_VENCREA), CNPJ, BANCO , AGENCIA, CONTA , DIGITO })
        nTotal := nTotal + (E2_VALOR)
        nBol   := nBol + (E2_VALOR)
		dbSkip()

EndDo
   
IF NTED > 0
X:= "TED"
ELSE
X:= "BOLETO"
ENDIF


aAnalise1 := asort(aAnalise1,,,{ |x,y| x[8] < y[8] } )
aAnalise2 := asort(aAnalise2,,,{ |x,y| x[8] < y[8] } ) 


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
// aAnalise := aSort(aAnalise[8],,,{ |x,y| x[1] > y[1] } )

// While 
IF NDOC > 0     


  FOR NX := 1 TO LEN(AANALISE1)
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


//    @ nLin,1 psay aanalise1[nx ,1 ] + " " + aanalise1[nx ,2 ] + " " + aanalise1[nx ,3 ] + " " + aANALISE1[nX,4] + " " + aanalise1[nx ,5] + " " + aanalise1[nx ,6] + " " + SUBSTR(aanalise1[nx ,7 ],7,2) + "/" + SUBSTR(aanalise1[nx ,7 ],5,2)+ "/" + SUBSTR(aanalise1[nx ,7 ],1,4) + " " + aanalise1[nx ,8 ]  + " " + aanalise1[nx ,9 ]  + " " + aanalise1[nx ,10 ]  + " " + aanalise1[nx ,11 ]  + " " + aanalise1[nx ,12 ]  
@ nLin,1 psay aanalise1[nx ,1 ] + " " + aanalise1[nx ,2 ] + " " + aanalise1[nx ,3 ]
@ nlin,14 psay transform(aANALISE1[nX,4],"@E 999,999,999.99")  
@ nlin,32 psay aanalise1[nx ,5] + " " + aanalise1[nx ,6] + " " + SUBSTR(aanalise1[nx ,7 ],7,2) + "/" + SUBSTR(aanalise1[nx ,7 ],5,2)+ "/" + SUBSTR(aanalise1[nx ,7 ],1,4) + " " + aanalise1[nx ,8 ]  + " " + aanalise1[nx ,9 ]  + " " + aanalise1[nx ,10 ]  + " " + aanalise1[nx ,11 ]  + " " + aanalise1[nx ,12 ]  

   nLin := nLin + 1 // Avanca a linha de impressao

   // dbSkip() // Avanca o ponteiro do registro no arquivo
// EndDo
NEXT


  @ nlin,1 psay "Sub-Total DOC"
  @ nlin,15 psay ndoc picture "999,999,999.99"
  @ nlin,30 psay "Nr.Titulos "
  @ nlin,42 psay len(aanalise1) picture "999"
  
  nLin := nLin + 1
  
  @ nlin,1 psay "============================================================================================================="

   nLin := nLin + 1
ENDIF

  FOR NX := 1 TO LEN(AANALISE2)
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

//   @ nLin,1 psay aanalise2[nx ,1 ] + " " + aanalise2[nx ,2 ] + " " + aanalise2[nx ,3 ] + " " + aANALISE2[nX,4] + " " + aanalise2[nx ,5] + " " + aanalise2[nx ,6] + " " + SUBSTR(aanalise2[nx ,7 ],7,2) + "/" + SUBSTR(aanalise2[nx ,7 ],5,2)+ "/" + SUBSTR(aanalise2[nx ,7 ],1,4)+  " " + aanalise2[nx ,8 ] + " " + aanalise2[nx ,9 ]  + " " + aanalise2[nx ,10 ]  + " " + aanalise2[nx ,11 ]  + " " + aanalise2[nx ,12 ]  
@ nLin,1 psay aanalise2[nx ,1 ] + " " + aanalise2[nx ,2 ] + " " + aanalise2[nx ,3 ]
@ nlin,14 psay transform(aANALISE2[nX,4],"@E 999,999,999.99")  
@ nlin,32 psay aanalise2[nx ,5] + " " + aanalise2[nx ,6] + " " + SUBSTR(aanalise2[nx ,7 ],7,2) + "/" + SUBSTR(aanalise2[nx ,7 ],5,2)+ "/" + SUBSTR(aanalise2[nx ,7 ],1,4) + " " + aanalise2[nx ,8 ]  + " " + aanalise2[nx ,9 ]  + " " + aanalise2[nx ,10 ]  + " " + aanalise2[nx ,11 ]  + " " + aanalise2[nx ,12 ]  


   nLin := nLin + 1 // Avanca a linha de impressao

NEXT


  @ nlin,1 psay "Sub-Total " + X
  if nted > 0
  @ nlin,17 psay nted picture "9,999,999.99"
  else
  @ nlin,17 psay nbol picture "9,999,999.99"
  endif
  @ nlin,30 psay "Nr.Titulos "
  @ nlin,42 psay len(aanalise2) picture "999"

  
  nLin := nLin + 1
  
  @ nlin,1 psay "============================================================================================================="
 

 nLin := nLin + 1


  @ nlin,1 psay "Total Bordero"
  @ nlin,15 psay ntOTAL picture "999,999,999.99"


 nLin := nLin + 6
 
  @ nLin,1 psay "----------------------------------------"
nLin := nLin + 1  
  @ nLin,1 psay AllTrim(SM0->M0_NOMECOM)
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
