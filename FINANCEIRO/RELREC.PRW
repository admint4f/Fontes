#INCLUDE "rwmake.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?Rpaga     ? Autor ? Marcos Justo       ? Data ?  16/09/04   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descricao ? Codigo gerado pelo AP5 IDE.                                ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP5 IDE                                                    ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function RELREC()


//?????????????????????????????????????????????????????????????????????Ŀ
//? Declaracao de Variaveis                                             ?
//???????????????????????????????????????????????????????????????????????

Local aOrd := {}
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio Contas a Receber"
Local cPict          := ""
Local titulo       := "Relatorio Contas a Receber - Liquido de Impostos"
Local nLin         := 80
             //        12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
Local Cabec1       := "NOME DO CLIENTE      TIP PRF DOCUME. EMISSAO   VENCIMENTO  BANCO       VALOR           ATRASO        HISTORICO"                                                                                                  

Local Cabec2       := ""
Local imprime      := .T.

Private cString
Private CbTxt        := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RELREC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "RSE2"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01

Private wnrel      := "RELREC" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SE1"
Private total := 0
Private SUBtotal := 0
dbSelectArea("SE1")
dbSetOrder(7)


ValidPerg()

pergunte(cPerg,.F.)

//?????????????????????????????????????????????????????????????????????Ŀ
//? Monta a interface padrao com o usuario...                           ?
//???????????????????????????????????????????????????????????????????????

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.F.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//?????????????????????????????????????????????????????????????????????Ŀ
//? Processamento. RPTSTATUS monta janela com a regua de processamento. ?
//???????????????????????????????????????????????????????????????????????

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?RUNREPORT ? Autor ? AP5 IDE            ? Data ?  23/09/03   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ???
???          ? monta a janela com a regua de processamento.               ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(7)    


//?????????????????????????????????????????????????????????????????????Ŀ
//? SETREGUA -> Indica quantos registros serao processados para a regua ?
//???????????????????????????????????????????????????????????????????????

SetRegua(RecCount())

//?????????????????????????????????????????????????????????????????????Ŀ
//? Posicionamento do primeiro registro e loop principal. Pode-se criar ?
//? a logica da seguinte maneira: Posiciona-se na filial corrente e pro ?
//? cessa enquanto a filial do registro for a filial corrente. Por exem ?
//? plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ?
//?                                                                     ?
//? dbSeek(xFilial())                                                   ?
//? While !EOF() .And. xFilial() == A1_FILIAL                           ?
//???????????????????????????????????????????????????????????????????????

//?????????????????????????????????????????????????????????????????????Ŀ
//? O tratamento dos parametros deve ser feito dentro da logica do seu  ?
//? relatorio. Geralmente a chave principal e a filial (isto vale prin- ?
//? cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ?
//? meiro registro pela filial + pela chave secundaria (codigo por exem ?
//? plo), e processa enquanto estes valores estiverem dentro dos parame ?
//? tros definidos. Suponha por exemplo o uso de dois parametros:       ?
//? mv_par01 -> Indica o codigo inicial a processar                     ?
//? mv_par02 -> Indica o codigo final a processar                       ?
//?                                                                     ?
//? dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ?
//? While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ?
//?                                                                     ?
//? Assim o processamento ocorrera enquanto o codigo do registro posicio?
//? nado for menor ou igual ao parametro mv_par02, que indica o codigo  ?
//? limite para o processamento. Caso existam outros parametros a serem ?
//? checados, isto deve ser feito dentro da estrutura de la?o (WHILE):  ?
//?                                                                     ?
//? mv_par01 -> Indica o codigo inicial a processar                     ?
//? mv_par02 -> Indica o codigo final a processar                       ?
//? mv_par03 -> Considera qual estado?                                  ?
//?                                                                     ?
//? dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ?
//? While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ?
//?                                                                     ?
//?     If A1_EST <> mv_par03                                           ?
//?         dbSkip()                                                    ?
//?         Loop                                                        ?
//?     Endif                                                           ?
//???????????????????????????????????????????????????????????????????????

dbGoTop()

DbSeek(xFilial("SE1")+dtos(mv_par01),.T.)
While !EOF() .And. SE1->E1_FILIAL = xFilial("SE1") .And. dtos(SE1->E1_VENCREA) <= dtos(mv_par02)


   //?????????????????????????????????????????????????????????????????????Ŀ
   //? Verifica o cancelamento pelo usuario...                             ?
   //???????????????????????????????????????????????????????????????????????

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //?????????????????????????????????????????????????????????????????????Ŀ
   //? Impressao do cabecalho do relatorio. . .                            ?
   //???????????????????????????????????????????????????????????????????????

   If nLin > 75 // Salto de P?gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
   
    _DATA1 := SE1->E1_VENCREA    
    IF alltrim(SE1->E1_STATUS) == "A" 
    	IF alltrim(SE1->E1_OCORREN) <> "04"
    @ nLin,01 PSAY SE1->E1_NOMCLI
    @ nLin,22 PSAY SE1->E1_TIPO
    @ nLin,26 PSAY SE1->E1_PREFIXO
    @ nLin,30 PSAY SE1->E1_NUM  
    @ nlin,37 PSAY SE1->E1_EMISSAO
    @ nlin,48 PSAY SE1->E1_VENCREA
    _DATA1 := SE1->E1_VENCREA
    @ nlin,60 PSAY SE1->E1_PORTADO
    _VALOR := (SE1->E1_VALOR - SE1->E1_IRRF - SE1->E1_CSLL - SE1->E1_COFINS - SE1->E1_PIS)
    @ nlin,66 PSAY  _VALOR PICTURE "9,999,999,999.99"
    if (ddatabase-SE1->E1_vencrea) > 0
    @ nlin,87 PSAY (ddatabase-SE1->E1_vencrea)
    endif
    @ nlin,98 PSAY SE1->E1_HIST
    SUBtotal := SUBtotal + _VALOR
    total := total + _VALOR
    nLin := nLin + 1 // Avanca a linha de impressao
    	ENDIF
    ENDIF
    
    
    dbSkip() // Avanca o ponteiro do registro no arquivo

    _DATA2 := SE1->E1_VENCREA
     
    IF _DATA2 <> _DATA1 .and. SUBTOTAL > 0
      @ nLin,35 PSAY "SUB-TOTAL =>"
      @ nLin,66 PSAY SUBTOTAL picture "9,999,999,999.99"
      SUBtotal := 0
      nLin := nLin + 2
    Endif
    
    
EndDo 

      @ nLin,35 PSAY "TOTAL =>"
      @ nLin,66 PSAY TOTAL picture "9,999,999,999.99"
      

//?????????????????????????????????????????????????????????????????????Ŀ
//? Finaliza a execucao do relatorio...                                 ?
//???????????????????????????????????????????????????????????????????????

SET DEVICE TO SCREEN

//?????????????????????????????????????????????????????????????????????Ŀ
//? Se impressao em disco, chama o gerenciador de impressao...          ?
//???????????????????????????????????????????????????????????????????????

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Fun??o    ?VALIDPERG ? Autor ? AP5 IDE            ? Data ?  23/09/03   ???
?????????????????????????????????????????????????????????????????????????͹??
???Descri??o ? Verifica a existencia das perguntas criando-as caso seja   ???
???          ? necessario (caso nao existam).                             ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? Programa principal                                         ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := padr(cPerg,len(X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//aAdd(aRegs,{cPerg,"","","mv_ch1","",00,00,0,"","","mv_par","","","","","","","","","","","","","",""})

aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"01",; 				//Ordem
	"De",;				//Pergunta em Portugues
	"De",;				//Pergunta em Espanhol
	"De",;				//Pergunta em Ingles
	"mv_ch1",;			//Variavel
	"C",;	   			//Tipo
	6,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				// 
	"",;				//Validacao
	"mv_par01","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"02",; 				//Ordem
	"Ate",;				//Pergunta em Portugues
	"Ate",;				//Pergunta em Espanhol
	"Ate",;				//Pergunta em Ingles
	"mv_ch2",;			//Variavel
	"C",;	   			//Tipo
	6,0,0,;			//Tamanho, Decimal, Pre-Selecionada
	"G",;				// 
	"",;				//Validacao
	"mv_par02","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05


For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next

dbSelectArea(_sAlias)

Return
