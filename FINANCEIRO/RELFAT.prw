#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RELFAT    � Autor � AP6 IDE            � Data �  05/04/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RELFAT


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       := "Faturas - Especifico CIE Brasil"
Local nLin         := 80

Local Cabec1       := "PRF NUM TI FATURA FORNEC.   NOME FORNECEDOR         VALOR          EMISSAO   VENC.   BAIXA    DT FATUR SALDO  "                
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RELFAT" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "GRVFAT"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELFAT" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cAliasTRB := AllTrim("SE2SEE" + xFilial("SE2"))

Private cString := "SE2"

pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  05/04/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local aNota := {}

dbSelectArea(cString)
//dbSetOrder(5)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

	cQuery := "Select E2_FORNECE,E2_VALOR,E2_VENCREA,E2_HIST,E2_FATURA,E2_BAIXA,E2_NOMFOR,E2_NUM,E2_SDACRES,E2_SDDECRE,E2_LOJA,E2_SALDO,E2_PREFIXO,E2_EMISSAO,E2_DTFATUR "
	cQuery += "From " + RetSqlName("SE2") + " "
	cQuery += "Where E2_FILIAL     = '" + xFilial("SE2") + "' "
	cQuery += "  And E2_VENCREA    = '" + dtos(mv_par01) + "' "
    cQuery += "  And E2_FATURA  <>   '"  +  " " +          "' " 
	cQuery += "  And D_E_L_E_T_     = ' '"
	cQuery += "Order By E2_FORNECE,E2_VALOR"
	
	cQuery := ChangeQuery(cQuery)
	MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

	dbSelectArea(cAliasTRB)
	dbGoTop()
	
	While !EOF()       
	 X:=E2_FORNECE
		aAdd(aNota, { E2_PREFIXO,E2_NUM,E2_FATURA,E2_FORNECE,E2_NOMFOR,E2_VALOR,E2_EMISSAO,E2_VENCREA,E2_BAIXA,E2_DTFATUR,E2_SALDO,E2_SDACRES,E2_SDDECRE  })
		dbSkip()  
		Y:=E2_FORNECE
		IF Y <> X
             		// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890   
		aAdd(aNota, { "----------------------------------------------------------------------------------------------------------------------------------","","","","","","","","","","","","" })
		ENDIF
		
	EndDo
	
//While !EOF()
   FOR NX := 1 TO LEN(ANOTA)
   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD
//          1         2         3         4         5         6         7         8         9         0         1         2         3
// 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890   
// PRF NUMTIT FATURA FORNEC NOMFOR11111111111111 VVVVVVVVVVVVVVVVVVVV DDDDDDDD DDDDDDDD DDDDDDDD DDDDDDDD SSSSSSSSSSSSSSSSSSSS 
IF SUBSTR(anota[nx ,1 ],1,1) <> "-"
   @ nLin,1  psay anota[nx ,1 ]
   @ nLin,5  psay anota[nx ,2 ]
   @ nLin,12 psay anota[nx, 3 ]
   @ nLin,20 psay anota[nx, 4 ]
   @ nLin,26 psay anota[nx, 5 ]
   @ nLin,47 psay str(anota[nx, 6],17,2)
   @ nLin,68 psay substr(anota[nx, 7],7,2) + "/" + substr(anota[nx, 7],5,2) + "/" + substr(anota[nx, 7],3,2)
   @ nLin,77 psay substr(anota[nx, 8],7,2) + "/" + substr(anota[nx, 8],5,2) + "/" + substr(anota[nx, 8],3,2)
   @ nLin,86 psay substr(anota[nx, 9],7,2) + "/" + substr(anota[nx, 9],5,2) + "/" + substr(anota[nx, 9],3,2)
   @ nLin,95 psay substr(anota[nx,10],7,2) + "/" + substr(anota[nx,10],5,2) + "/" + substr(anota[nx,10],3,2)
   @ nLin,104 psay str(anota[nx, 11],17,2)
ELSE
   @ nLin,1  psay anota[nx ,1 ]
ENDIF    

   nLin := nLin + 1 // Avanca a linha de impressao
   
NEXT
//   dbSkip() // Avanca o ponteiro do registro no arquivo
//EndDo
	(cAliasTRB)->(dbCloseArea())
//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
