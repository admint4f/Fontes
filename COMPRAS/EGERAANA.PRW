#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EGERAANA  º Autor ³ AP6 IDE            º Data ³  18/05/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EGERAANA()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "ANALISE DE RENTABILIDADE"
Local cPict          := ""
Local titulo       := "ANALISE DE RENTABILIDADE"
Local nLin         := 80

Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
//Local _cortesi     := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "M"
Private nomeprog         := "ANALISE" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg      := "SZL"
Private cbtxt      := Space(10)
Private cbcont     := 00   
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ANALISE" // Coloque aqui o nome do arquivo usado para impressao em disco
Private _opmedio   := 0
Private cString    := "SZL"

Private _cortesi   := ""
Private _oPagant   := ""
Private _PMEDIOR   := 0
Private _quanrea   := 0
Private _vendascc  := 0
Private _PARTCOD   := ""
Private _PORCCC    := 0
Private _parttip   := ""        
Private _TOTIMPO   := 0                  
Private _BILEST    := 0         
Private _OBILEST   := 0       
Private _OECAD     := 0
Private _VENDASR   := 0                    
Private _CISS      := 0
Private _CECAD     := 0
Private _CPIS      := 0
Private _ONEGOCI   := 0
Private _BILLIQU   := 0
Private _OBILLIQ   := 0          
Private _partart   := 0
Private _OPARTAR   := 0                
Private _CPARTAR   := 0                                                                                            
Private  _CHOSP    := 0                   
Private _CAMARIM   := 0
Private _NUMAPRE   := 0
Private _CCAMARI   := 0
Private _CTOTG     := _CSOM := _CLUZ := _CTAEREO := _CTTERRE := _CALIMENTA := _CTEQUIP := _CBACLIN := 0
Private _CODESP    := _totaere := _CPCARTI := reacus := _HOSP := _TOTCPRO := _TOTTERR := _ctterre := 0
Private _alimenta  := _trequip := _cBackLin := _cBACLIN := _totODESP := _ODESP := _CPCARTI := _CODESP := 0


dbSelectArea("SZL")
dbSetOrder(2)


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
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/05/04   º±±
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
dbSetOrder(2)

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

DbSeek(xFilial("SZL")+mv_par01,.T.)
While !EOF() .And. SZL->ZL_FILIAL = xFilial("SZL") .And. SZL->ZL_CHAVE1 <= mv_par02

// IF SZL->ZL_MESANT == "S"
//    DBSKIP()
//    LOOP
// ENDIF   

_CHAVE1  := SZL->ZL_CHAVE1 
_DESCRI  := SZL->ZL_DESCRI
_ARTISTA    := SZL->ZL_ARTISTA
_DATAINI    := SZL->ZL_DATAINI
_DATAFIM    := SZL->ZL_DATAFIM
_NUMAPRE    := SZL->ZL_NUMAPRE
_TXOCUPA    := SZL->ZL_TXOCUPA
_PRMEDIO    := SZL->ZL_PRMEDIO
_TXESTUD    := SZL->ZL_TXESTUD
_PUBEST     := SZL->ZL_PUBEST
_PORCART    := SZL->ZL_PORCART

_BILEST     := SZL->ZL_BILEST
_OBILEST    := SZL->ZL_OBILEST
_VENDASR    := SZL->ZL_VENDASR

_CPARTAR    := SZL->ZL_CPARTAR
_TOTAIMO    := SZL->ZL_TOTAIMO
_OALUGIM    := SZL->ZL_OALUGIM
_CALUIMO    := SZL->ZL_CALUIMO
_TOTMIDI    := SZL->ZL_TOTMIDI
_PORCMID    := SZL->ZL_PORCMID
_MIDIA      := SZL->ZL_MIDIA
_OMIDIA     := SZL->ZL_OMIDIA
_CMIDIA     := SZL->ZL_CMIDIA
_TOTCPRO    := SZL->ZL_TOTCPRO
_ODESP      := SZL->ZL_ODESP
_CODESP     := SZL->ZL_CODESP
_SOM        := SZL->ZL_SOM
_CSOM       := SZL->ZL_CSOM
_LUZ        := SZL->ZL_LUZ
_CLUZ        := SZL->ZL_CLUZ



_CTTERRE    :=SZL->ZL_CTTERRE
_ALIMENTA    :=SZL->ZL_NPESSDI*SZL->ZL_NDIAALI*SZL->ZL_VALDALI
_CALIMENTA  := SZL->ZL_CALIMEN
_TREQUIP    := SZL->ZL_TREQUIP
_CTEQUIP   := SZL->ZL_CTEQUIP
_BACKLIN    := SZL->ZL_BACKLIN
_CBACLIN    := SZL->ZL_CBACLIN
_CPCARTI    := SZL->ZL_CPCARTI
_RESSHOW    := SZL->ZL_RESSHOW
_ORESULT    := SZL->ZL_ORESULT
_PORCCC     := SZL->ZL_PORCCC
_DPERFIL    := SZL->ZL_DPERFIL
_DESCTIP    := SZL->ZL_DESCTIP
//_PROMO      := SZL->ZL_PROMO
 

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

   If nLin > 44 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 7
   Endif

   // Coloque aqui a logica da impressao do seu programa...
   // Utilize PSAY para saida na impressora. Por exemplo:
   // @nLin,00 PSAY SA1->A1_COD

   nLin := nLin + 1 // Avanca a linha de impressao

@ nlin,1 PSAY "|" + trim(_DESCRI) + " " + " " + trim(_ARTISTA)
@ nlin,68 PSAY "Data Emissão :"
@ nlin,83 PSAY date()
@ nlin,92 PSAY "|"

  nLin := nLin + 1

@ nLin,1 PSAY "|"
@ nLin,2 PSAY _DATAINI
@ nLin,12 PSAY "A"
@ nLin,14 PSAY _DATAFIM
@ nLin,28 PSAY "Nº Apresentações ="
@ nLin,47 PSAY _numapRE 
@ nLin,68 PSAY "Analise Nº."
@ nLin,83 PSAY _chave1 
@ nLin,92 PSAY "|"

   nLin := nLin + 1        
@ nLin,1 PSAY "|__________________________________________________________________________________________|"
nLin := nLin + 1

@ nLin,1 PSAY "|"
@ nLin,2 PSAY "Tx.Ocupação"
@ nLin,14 PSAY _txocupa 
@ nLin,17 PSAY "%"
@ nLin,20 PSAY "Preço Médio Analise"
@ nLin,40 PSAY _prmedio picture "999.99"
@ nLin,47 PSAY "Tx.Estudante"
@ nLin,60 PSAY _txestud 
@ nLin,63 PSAY "%"
@ nLin,65 PSAY "Pub.Est."
@ nLin,73 PSAY _pubest 
@ nLin,92 PSAY "|"
@ nLin,93 PSAY "Elem.Pep : " + SZL->ZL_ELEMPEP


  nLin := nLin + 1

@ nLin,1 PSAY "|"
@ nLin,2 PSAY "Part.Art."
@ nLin,14 PSAY _porcart 
@ nLin,17 PSAY "%"
@ nLin,20 PSAY "Preço Médio Orçado"
@ nLin,40 PSAY _opmedio picture "999.99"
@ nLin,47 PSAY "Cortesias"
@ nLin,57 PSAY _cortesi 
@ nLin,65 PSAY "NºPag.Orç."
@ nLin,76 PSAY _opagant 
@ nLin,92 PSAY "|"
//@ nLin,93 PSAY "Tipo       : " + _desctip  

  nLin := nLin + 1

@ nLin,1 PSAY "|"
@ nLin,20 PSAY "Preço Médio Realiz"
@ nLin,40 PSAY _PMEDIOR picture "999.99"
@ nLin,47 PSAY "Pub.Rel."
@ nLin,57 PSAY _quanrea 
 
// @ 7,2 PSAY "Base Orçamento="
// @ 7,17 PSAY trim(descorca)
// @ 7,59 PSAY diaorca pict "99"
// @ 7,61 PSAY "/"
// @ 7,62 PSAY mesorca
@ nLin,65 PSAY "Vendas C/C"
@ nLin,76 PSAY _vendascc picture "9,999,999.99"
@ nLin,92 PSAY "|"
//@ nLin,93 PSAY "Promocão ? : " + _promo

 nLin := nLin + 1

@ nLin,1 PSAY "|"
@ nLin,2 PSAY "Negociação Art."
@ nLin,17 PSAY _PARTCOD
@ nLin,20 PSAY alltrim(_parttip)
@ nLin,61 PSAY "Prev. % Vendas C/C"
@ nLin,85 PSAY _PORCCC 
@ nLin,87 PSAY "%"

// @ 8,47 PSAY "Base Orçamento="
// @ 8,64 PSAY diaorca pict "99"
// @ 8,66 PSAY "/"
// @ 8,67 PSAY mesorca PICT "99"

// IF DIAORCA <> 31 .AND. MESORCA <> 12
// @ 8,71 PSAY trim(descorca)
// ELSE
// @ 8,71 PSAY "ORÇAMENTO PADRÃO"
// ENDIF
   nLin := nLin + 1
   @ nLin,1 PSAY "|__________________________________________________________________________________________|"
   nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,29 PSAY "|"
          @nLin,30 PSAY "  PREVISÃO" 
          @nLin,42 PSAY "|"
          @nLin,45 PSAY "%"
          @nLin,50 PSAY "|"
          @nLin,52 PSAY "%"
          @nLin,58 PSAY "|"
          // if diaorca = 31 .and. mesorca = 12
          // nLin,59 PSAY "ORÇA/PADRÃO" font 'arial',8 style 'b'
          // ELSE
          @ nLin,59 PSAY "  ORÇADO" 
          // ENDIF
          @nLin,71 PSAY "|"
          @nLin,72 PSAY "%DESVIO"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY "  REALIZADO" 
          @nLin,92 PSAY "|"
          @nlin,93 PSAY "Formas de Pagamento"
           
          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,2 PSAY "BILHETERIA ESTIMADA" 
          @nLin,29 PSAY "|"
          @ nLin,30 PSAY ((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100)) Picture "99999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY "100.00" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY _OBILEST Picture "99999,999.99"
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_OBILEST/_BILEST)*100-100 PICTURE "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _vendasr Picture "99999,999.99" 
          @nLin,92 PSAY "|"
          @ nlin,93 psay "CASH  : "
          @ nlin,102 psay SZL->ZL_qcash picture "9,999,999.99"
          @ nlin,115 psay SZL->ZL_vcash picture "9,999,999.99"
          
          
          
nLin := nLin + 1
	      @nLin,1 PSAY "|"
          @nLin,29 PSAY "|"
          @nLin,42 PSAY "|"
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,92 PSAY "|"
          @ nlin,93 psay "MC    : "
          @ nlin,102 psay SZL->ZL_qmc picture "9,999,999.99"
	      @ nlin,115 psay SZL->ZL_vmc picture "9,999,999.99"

          
          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,3 PSAY "IMPOSTOS BILHETERIA" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _totimpo Picture "99999,999.99" 
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_totimpo/_BILEST)*100 picture "999.99"  
          @nLin,49 PSAY "%"
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY _OECAD Picture "99999,999.99" 
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_OECAD/_TOTIMPO)*100-100 picture "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
IF SZL->ZL_CISS == 0
   _CISS = (_VENDASR * SZL->ZL_TXISS)/100
ELSE
   _CISS = SZL->ZL_CISS
ENDIF
IF SZL->ZL_CECAD == 0
   _CECAD = (_VENDASR * SZL->ZL_TXECAD)/100
ELSE
   _CECAD = SZL->ZL_CECAD
ENDIF
IF SZL->ZL_CPIS == 0
//((vendastotrel-(VENDASTOTREL*(txpartart/100)))*TXPISCOFINS)

   _CPIS = ((_VENDASR -(_VENDASR*(SZL->ZL_PORCART/100)))*(SZL->ZL_TXPIS/100)) 
ELSE
   _CPIS = SZL->ZL_CPIS   
ENDIF   
      // VER IMPOSTOS
          @nLin,80 PSAY (_CISS+_CECAD+_CPIS) picture "99999,999.99"
          @nLin,92 PSAY "|"
		  @ nlin,93 psay "VISA  : "
		  @ nlin,102 psay SZL->ZL_qvisa picture "9,999,999.99"
		  @ nlin,115 psay SZL->ZL_vvisa picture "9,999,999.99"
          
    IF SZL->ZL_ECAD == 0      
          _ecad := (_bilest*(SZL->ZL_TXECAD/100))
    ELSE
          _ECAD := SZL->ZL_ECAD
    ENDIF
          
    IF SZL->ZL_ISS == 0
          _iss  := (_bilest*(SZL->ZL_TXISS/100))
    ELSE
          _ISS  := SZL->ZL_ISS
    ENDIF
    
    IF SZL->ZL_PIS == 0
          _pis  := (_BILEST*(1-(_PORCART/100))*(SZL->ZL_TXPIS/100))
    ELSE
          _PIS  := SZL->ZL_PIS
    ENDIF
         
         nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "ECAD" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY (_ecad) Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY _ecad/_BILEST*100 picture "999.99"  
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY (_oecad) Picture "9,999,999.99" 
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_OECAD/_totimpo)*100-100 picture "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY (_CECAD) Picture "9,999,999.99" 
          @nLin,92 PSAY "|"        
		  @ nlin,93 psay "DC    : "
		  @ nlin,102 psay SZL->ZL_qDC picture "9,999,999.99"
		  @ nlin,115 psay SZL->ZL_vDC picture "9,999,999.99"
          
          
          nLin := nLin + 1          
          @nLin,1 PSAY "|"          
          @nLin,5 PSAY "ISS" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _iss Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY _ISS/_BILEST*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _CISS Picture "9,999,999.99" 
          @nLin,92 PSAY "|"
		  @ nlin,93 psay "AMX   : "
		  @ nlin,102 psay SZL->ZL_qAMX picture "9,999,999.99"
		  @ nlin,115 psay SZL->ZL_vAMX picture "9,999,999.99"
          
          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "PIS/COFINS" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _PIS Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY _PIS/_BILEST*100 picture "999.99"
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _CPIS Picture "9,999,999.99"
          @nLin,92 PSAY "|"
@ nlin,93 psay "CORTES: "
@ nlin,102 psay SZL->ZL_qCORTES picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vCORTES picture "9,999,999.99"



          nLin := nLin + 1
	      @nLin,1 PSAY "|"
          @nLin,29 PSAY "|"
          @nLin,42 PSAY "|"
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,92 PSAY "|"
	      @ nlin,93 psay "MCDB  : "
  	      @ nlin,102 psay SZL->ZL_qmcDB picture "9,999,999.99"
		  @ nlin,115 psay SZL->ZL_vmcDB picture "9,999,999.99"
          
          
          
          
          
          nLin := nLin + 1   

          @nLin,1 PSAY "|"
          @nLin,3 PSAY "OUTROS/NEGOCIAÇÃO"
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _ONEGOCI Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY " "
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY " "
          @nLin,92 PSAY "|"
		  @ nlin,93 psay "MC    : "
		  @ nlin,102 psay SZL->ZL_qmc picture "9,999,999.99"
		  @ nlin,115 psay SZL->ZL_vmc picture "9,999,999.99"
          
          
nLin := nLin + 1

TOTCCRE := (((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100))*(SZL->ZL_PORCCC/100)*(SZL->ZL_TXCC/100))                     

          @nLin,1 PSAY "|"
          @nLin,3 PSAY "TAXA CARTÃO CRÉDITO" 
       
          @nLin,29 PSAY "|"
         // @nLin,30 PSAY SZL->ZL_totcc picture "9,999,999.99"  
          @nLin,30 PSAY TOTCCRE picture "9,999,999.99" 
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (TOTCCRE/_BILeST)*100 PICTURE "999.99"
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          _TOTCAR =(_VENDASCC*SZL->ZL_txcc)/100
          @nLin,80 PSAY (_VENDASCC*SZL->ZL_txcc)/100 PICTURE "9,999,999.99"
          @nLin,92 PSAY "|"
		  @ nlin,93 psay "VDB   : "
		  @ nlin,102 psay SZL->ZL_qVDB picture "9,999,999.99"
		  @ nlin,115 psay SZL->ZL_vVDB picture "9,999,999.99"

          nLin := nLin + 1


// ************* BILHETERIA LIQUIDA *******************


          @nLin,1 PSAY "|"
          @nLin,29 PSAY "|"
          @nLin,42 PSAY "|"
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,92 PSAY "|"
@ nlin,93 psay "TXMCDB: "
@ nlin,102 psay SZL->ZL_qTXMCDB picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vTXMCDB picture "9,999,999.99"



          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,2 PSAY "BILHETERIA LIQUIDA" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _BILLIQU Picture "99999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_BILLIQU/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY _OBILLIQ Picture "99999,999.99" 
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_OBILLIQ/_BILLIQU)*100-100 PICTURE "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _VENDASR-_CISS-_CECAD-_CPIS-_TOTCAR picture "99999,999.99"
          @nLin,92 PSAY "|"
@ nlin,93 psay "TXMC  : "
@ nlin,102 psay SZL->ZL_qTXmc picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vTXmc picture "9,999,999.99"
          


// ********************* FINAL BILHETERIA LIQUIDA *****************
	      nLin := nLin + 1
	      @nLin,1 PSAY "|"
          @nLin,29 PSAY "|"
          @nLin,42 PSAY "|"        
          
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,92 PSAY "|"
@ nlin,93 psay "TXVISA: "
@ nlin,102 psay SZL->ZL_qTXVISA picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vTXVISA picture "9,999,999.99"
          
              
nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "PART.ARTISTA/CACHE" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _partart Picture "99999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_partart/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY _OPARTAR Picture "9,999,999.99"
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_OPARTAR/_PARTART)*100-100 picture "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _CPARTAR Picture "9,999,999.99" 
          @nLin,92 PSAY "|"
@ nlin,93 psay "TXDC  : "
@ nlin,102 psay SZL->ZL_qTXDC picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vTXDC picture "9,999,999.99"

nLin := nLin + 1          

//          RELBILLIQ=VENDASTOTREL-CNEGOCIACAO-(VENDASTOTREL*MISS/100)-(VENDASTOTREL*MECAD/100)-((VENDASTOTREL-(VENDASTOTREL*TXPARTART/100))*TXPISCOFINS/100)-((VENDASCCrel*txcc)/100)

MVALIMO := SZL->ZL_VALIMO
MTOTBIL := SZL->ZL_TOTBIL
MPORCART := SZL->ZL_PORCART
MPARTCOD := SZL->ZL_PARTCOD

MTXECAD := SZL->ZL_TXECAD
MTXISS  := SZL->ZL_TXISS
MTXPIS  := SZL->ZL_TXPIS
MTXCC   := SZL->ZL_TXCC
MPORCCC := SZL->ZL_PORCCC
MSOM    := SZL->ZL_SOM
MLUZ    := SZL->ZL_LUZ
MNUMAPRE:= SZL->ZL_NUMAPRE
MTXOCUPA:= SZL->ZL_TXOCUPA

MBILESTI := (MTOTBIL*_NUMAPRE)*(MTXOCUPA/100)
MTOTECAD := (MBILESTI*(MTXECAD/100))
MTOTISS  := (MBILESTI*(MTXISS/100))
MTOTPIS  := (MBILESTI*(1-(MPORCART/100))*(MTXPIS/100)) 
MTOTCC   := ((MBILESTI*(MPORCCC/100))*(MTXCC/100))

MTOTBI := (MBILESTI-MTOTECAD-MTOTISS-MTOTPIS-MTOTCC-SZL->ZL_ONEGOCI)
//_TOTBI := (_BILESTI-_TOTECAD-_TOTISS-_TOTPIS-M->ZL_ONEGOCI)
              
MTOTIMO := (MTOTBI*(SZL->ZL_TXALIMO/100))

IF MVALIMO > 0
   MTOTIMO := MVALIMO
ENDIF   

_TOTAIMO := MTOTIMO

          @nLin,1 PSAY "|"          
          @nLin,5 PSAY "ALUG.IMÓVEIS" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _TOTAIMO Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_TOTAIMO/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY _OALUGIM Picture "9,999,999.99" 
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_OALUGIM/_TOTAIMO)*100-100 picture "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
          IF _CALUIMO == 0
             _CALUIMO := ((_VENDASR-_CISS-_CECAD-_CPIS-_TOTCAR)*(SZL->ZL_TXALIMO/100)) 
          ENDIF
          
          @nLin,80 PSAY _CALUIMO Picture "9,999,999.99"
          @nLin,92 PSAY "|"

@ nlin,93 psay "CC    : "
@ nlin,102 psay SZL->ZL_qCC picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vCC picture "9,999,999.99"

          
          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "MIDIA/PROPAGANDA"
          @nLin,23 PSAY _PORCMID picture "999"
          @nLin,27 PSAY "%" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY (_TOTMIDI) Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_TOTmidi/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
     //     @nLin,51 PSAY _TOTMIDI/_BILEST*100 PICT "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY _omidia Picture "9,999,999.99"
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_OMIDIA/_TOTMIDI)*100-100 picture "999.99" 
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY (_CMIDIA*(_PORCMID/100)) Picture "9,999,999.99" 
          @nLin,92 PSAY "|"

@ nlin,93 psay "CHEQUE: "
@ nlin,102 psay SZL->ZL_qCHEQUE picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vCHEQUE picture "9,999,999.99"
          
          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,29 PSAY "|"
          @nLin,42 PSAY "|"
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,92 PSAY "|"

@ nlin,93 psay "PPRT  : "
@ nlin,102 psay SZL->ZL_qPPRT picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vPPRT picture "9,999,999.99"


aAreaAnt := GetArea()
outcus := 0
reacus := 0
dbSelectarea("SZS")
dbGotop()
While !eof()
	IF SZS->ZS_CHAVE1 <> _CHAVE1
	   dbSkip()
	   Loop
	ENDIF

outcus := outcus + SZS->ZS_PREVIST
reacus := reacus + SZS->ZS_REALIZA

dbSkip()
Enddo
RestArea(aAreaAnt)                               

          
          
          nLin := nLin + 1
      
          @nLin,1 PSAY "|"                
          @nLin,3 PSAY "CUSTO DE PRODUÇÃO" 
          @nLin,29 PSAY "|" 
          @nLin,30 PSAY _totcpro  picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_totcpro/_bilEst)*100 picture "999.99"
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY "100.00"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY (_ODESP) picture "9,999,999.99" 
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_ODESP/_TOTCPRO)*100-100 picture "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
          _CTOTG = _CSOM+_CLUZ+_CHOSP+_CCAMARI+_CTAEREO+_CTTERRE+_CALIMENTA+_CTEQUIP+_CBACLIN+_CODESP+_CPCARTI + reacus
          @nLin,80 PSAY _CTOTG picture "9,999,999.99" 
           @nLin,92 PSAY "|"
@ nlin,93 psay "HIPERC: "
@ nlin,102 psay SZL->ZL_qhiperc picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vhiperc picture "9,999,999.99"

          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "SOM" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY (_SOM*_NUMAPRE) Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY ((_som*_NUMAPRE)/_BILEST)*100 PICTURE "999.99"
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY (_SOM*_NUMAPRE)/_TOTCPRO*100 PICTURE "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _Csom Picture "9,999,999.99"
          @nLin,92 PSAY "|"
@ nlin,93 psay "TXVDB : "
@ nlin,102 psay SZL->ZL_qTXVDB picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vTXVDB picture "9,999,999.99"

          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "LUZ" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY (_LUZ*_NUMAPRE) Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_luz*_NUMAPRE/_BILEST)*100 picture "999.99"
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY _LUZ*_NUMAPRE/_TOTCPRO*100 PICTURE "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _Cluz Picture "9,999,999.99"
          @nLin,92 PSAY "|"
@ nlin,93 psay "TXCC  : "
@ nlin,102 psay SZL->ZL_qTXCC  picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vTXCC  picture "9,999,999.99"


          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "HOSPEDAGEM" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _hosp Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_hosp/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY _HOSP/_TOTCPRO*100 PICTURE "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _Chosp Picture "9,999,999.99"
          @nLin,92 PSAY "|"
@ nlin,93 psay "TXAMX : "
@ nlin,102 psay SZL->ZL_qTXAMX picture "9,999,999.99"
@ nlin,115 psay SZL->ZL_vTXAMX picture "9,999,999.99"


          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "CAMARIM" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY (_CAMARIM*_NUMAPRE) Picture "9,999,999.99" 
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_camarim*_NUMAPRE/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY _CAMARIM*_NUMAPRE/_TOTCPRO*100 PICTURE "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _ccamari Picture "9,999,999.99" 
          @nLin,92 PSAY "|"

          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "TRANSP.AEREO ART." 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _totaere Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_totaere/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY _TOTAERE/_TOTCPRO*100 PICTURE "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _ctaereo Picture "9,999,999.99"
          @nLin,92 PSAY "|"
@ nlin,93 psay "TOTAIS: "
totq := SZL->ZL_qcash+SZL->ZL_qpprt+SZL->ZL_qcortes+SZL->ZL_qcheque+SZL->ZL_qmc+SZL->ZL_qvdb+SZL->ZL_qvisa+SZL->ZL_qcc+SZL->ZL_qamx+SZL->ZL_qmcdb+SZL->ZL_qdc+SZL->ZL_qhiperc+SZL->ZL_qtxmc+SZL->ZL_qtxvdb+SZL->ZL_qtxvisa+SZL->ZL_qtxcc+SZL->ZL_qtxamx+SZL->ZL_qtxmcdb+SZL->ZL_qtxcc
@ nlin,102 psay totq picture "9,999,999.99"
totv := SZL->ZL_vcash+SZL->ZL_vpprt+SZL->ZL_vcortes+SZL->ZL_vcheque+SZL->ZL_vmc+SZL->ZL_vvdb+SZL->ZL_vvisa+SZL->ZL_vcc+SZL->ZL_vamx+SZL->ZL_vmcdb+SZL->ZL_vdc+SZL->ZL_vhiperc+SZL->ZL_vtxmc+SZL->ZL_vtxvdb+SZL->ZL_vtxvisa+SZL->ZL_vtxcc+SZL->ZL_vtxamx+SZL->ZL_vtxmcdb+SZL->ZL_vtxcc
@ nlin,115 psay totv picture "9,999,999.99"

          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "TRANSP.TERRESTRE" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _totterr Picture "9,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_totterr/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY _TOTTERR/_TOTCPRO*100 PICTURE "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _ctterre Picture "9,999,999.99" 
          @nLin,92 PSAY "|"
@ nlin,93 psay "Total tx.Entrega   : "
@ nlin,115 psay SZL->ZL_entrega picture "9,999,999.99"


          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "ALIMENTAÇÃO/AJUDA" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _alimenta Picture "9,999,999.99" 
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_alimenta/_BILEST)*100 picture "999.99"
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY _ALIMENTA/_TOTCPRO*100 PICTURE "999.99"
          @nLin,57 PSAY "%" 
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _calimenta Picture "9,999,999.99"
          @nLin,92 PSAY "|"
@ nlin,93 psay "Total tx.Convenien.: "
@ nlin,115 psay SZL->ZL_conveni picture "9,999,999.99"

          
          nLin := nLin + 1
          @nLIn,1 PSAY "|"
          @nLIn,5 PSAY "TRANSP.EQUIPAMENTO" 
          @nLIn,29 PSAY "|"
          @nLIn,30 PSAY _trequip Picture "9,999,999.99"
          @nLIn,42 PSAY "|"
          @nLIn,43 PSAY (_trequip/_BILEST)*100  picture "999.99"
          @nLIn,49 PSAY "%"                   
          @nLIn,50 PSAY "|"
          @nLIn,51 PSAY _TREQUIP/_TOTCPRO*100 PICTURE "999.99"
          @nLIn,57 PSAY "%"
          @nLIn,58 PSAY "|"
          @nLIn,59 PSAY " "
          @nLIn,71 PSAY "|"
          @nLIn,79 PSAY "|"
          @nLIn,80 PSAY _ctequip Picture "9,999,999.99" 
          @nLIn,92 PSAY "|"
nLin := nLin + 1
          @nLIn,1 PSAY "|"
//          @nLIn,5 PSAY "CUSTOS OPERACIONAIS"  
@nLIn,5 PSAY " " 
          @nLIn,29 PSAY "|"
        //  @nLIn,30 PSAY custopimov pict "9,999,999.99" font 'arial',8 style "B"
          @nLIn,42 PSAY "|"
        //  @nLIn,43 PSAY (custopimov/bilhetiestI)*100 font 'arial',8 style "B" PICT "999.99"
        //  @nLIn,49 PSAY "%" font 'arial',8 style "B"
          @nLIn,50 PSAY "|"
         // @nLIn,51 PSAY CUSTOPIMOV/TOTCGERAL*100 PICT "999.99"
//          @nLIn,57 PSAY "%"
          @nLIn,58 PSAY "|"
          @nLIn,59 PSAY " "
          @nLIn,71 PSAY "|"
          @nLIn,79 PSAY "|"
        //  @nLIn,80 PSAY ctotri font 'arial',8 style "B"  pict "9,999,999.99"
          @nLIn,92 PSAY "|"
          nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,5 PSAY "BACKLINE" 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _backlin Picture "9,999,999.99" 
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_backlin/_BILEST)*100 picture "999.99" 
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLIn,51 PSAY _BACKLIN/_TOTCPRO*100 PICTURE "999.99"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY " "
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _cBACLIN Picture "9,999,999.99"
          @nLin,92 PSAY "|"                            
          

_SINDICA   := SZL->ZL_SINDICA
_VRCONTR   := SZL->ZL_VRCONTR
_TOTSINDICA := (SZL->ZL_SINDICA*(SZL->ZL_VRCONTR/100))

_VISTOENT  := SZL->ZL_VISTOEN
_NUMPENT   := SZL->ZL_NUMPENT
_TOTVISTO  := (SZL->ZL_VISTOEN*SZL->ZL_NUMPENT)

_EQUIPPR   := SZL->ZL_EQUIPPR
_NUMPPRO   := SZL->ZL_NUMPPRO    
_TOTPROD   := (SZL->ZL_EQUIPPR*SZL->ZL_NUMPPRO)
           
_TOTODESP  := _TOTSINDICA + _TOTVISTO + _TOTPROD + OUTCUS         
          nLin := nLin + 1
          @nLin,1 PSAY "|"                
          // ANTIGA LINHA DE OUTRAS DESPESAS
          @nLin,5 PSAY "CUSTOS DE PRODUÇÃO" 
          @nLin,29 PSAY "|"
          // @nLin,30 PSAY _totcpro-(_som*_NUMAPRE)-(_luz*_NUMAPRE)-_hosp-(_camarim*_NUMAPRE)-_totaere-_totterr-_alimenta-_trequip-_backlin picture "9,999,999.99" 
		  @nLin,30 PSAY _totODESP picture "9,999,999.99" 
          @nLin,42 PSAY "|"
          // @nLin,43 PSAY ((_totcpro-(_som*_NUMAPRE)-(_luz*_NUMAPRE)-_hosp-(_camarim*_NUMAPRE)-_totaere-_totterr-_alimenta-_trequip-_backlin)/_bilest)*100  PICTURE "999.99"
          @nLin,43 PSAY ((_totODESP)/_bilest)*100  PICTURE "999.99"
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,51 PSAY ((_totODESP)/_TOTCPRO)*100 PICTURE "999.99"
          @nLin,57 PSAY "%"
          @nLin,58 PSAY "|"
          @nLin,59 PSAY _ODESP picture "9,999,999.99"
          @nLin,71 PSAY "|"
        //  @nLin,72 PSAY ORCOUTRASDESP*NUMAP/(SOM+LUZ+HOSPEDAGEM+CAMARIM+TRANSPAERE+TRANSPTERR+ALIMENTA+TRANSEQUIP+CUSTOPIMOV+OUTRASDESP)*100-100 pict "999.99"
          @nLin,79 PSAY "|"
          @nLin,80 PSAY _codesp + reacus picture "9,999,999.99"
          @nLin,92 PSAY "|"
       
         
          
nLin := nLin + 1
		  @nLin,1 PSAY "|"
          @nLin,5 PSAY "DESP.POR CONTA ARTISTA" 
          @nLin,29 PSAY "|"
          @nLin,42 PSAY "|"
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"

          @nLin,80 PSAY _CPCARTI Picture "9,999,999.99"
          @nLin,92 PSAY "|"

	      nLin := nLin + 1
	      @nLin,1 PSAY "|"
          @nLin,29 PSAY "|"
          @nLin,42 PSAY "|"
          @nLin,50 PSAY "|"
          @nLin,58 PSAY "|"
          @nLin,71 PSAY "|"
          @nLin,79 PSAY "|"
          @nLin,92 PSAY "|"

nLin := nLin + 1
          @nLin,1 PSAY "|"
          @nLin,2 PSAY "RESULTADO SHOW " 
          @nLin,29 PSAY "|"
          @nLin,30 PSAY _RESSHOW Picture "99,999,999.99"
          @nLin,42 PSAY "|"
          @nLin,43 PSAY (_RESSHOW/_BILEST)*100 picture "999.99"  
          @nLin,49 PSAY "%" 
          @nLin,50 PSAY "|"
          @nLin,57 PSAY " "
          @nLin,58 PSAY "|"
          @nLin,59 PSAY (_ORESULT) Picture "9999,999.99" 
          @nLin,71 PSAY "|"
          @nLin,72 PSAY (_ORESULT/_RESSHOW)*100-100 picture "999.99"
          @nLin,78 PSAY "%"
          @nLin,79 PSAY "|"
//          @nLin,80 PSAY _VENDASR-_CISS-_CECAD-_CPIS-_TOTCAR-_ctotg-_cpartar-_caluimo-_cmidia picture "9,999,999.99"
          @nLin,80 PSAY _VENDASR-_CISS-_CECAD-_CPIS-_TOTCAR-_ctotg-_cpartar-_caluimo-(_CMIDIA*(_PORCMID/100)) picture "99999,999.99"                  
        
          @nLin,92 PSAY "|"
   
       
          nLin := nLin + 1      
         
            
@ nLin,1 PSAY "********************************************************************************************"
nLin := nLin + 1      
//          if xcodart = 1
//            partiarti=((XVENDASTOTREL-XCNEGOCIACAO)*(xpartart/100))
//          @ 43,60 PSAY "Calculo Part.Art.="
//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
//          endif
          
//          if xcodart = 2
//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100))*(xpartart/100)
//          @ 43,60 PSAY "Calculo Part.Art.="
//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
//          endif
          
//          if xcodart = 3
//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASCCREL*3/100)*(xpartart/100))
//          @ 43,60 PSAY "Calculo Part.Art.="
//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
//          endif
          
//          if xcodart = 4
//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100)-(XVENDASCCREL*3/100))*(xpartart/100)
//          @ 43,60 PSAY "Calculo Part.Art.="
//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
//          endif
          
//          if xcodart = 5
//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100)-XCsom-XCluz)
//          partiarti=(partiarti*(xpartart/100))
//          @ 43,60 PSAY "Calculo Part.Art.="
//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
//          endif
          
//          if xcodart = 6
//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100)-(XVENDASCCREL*3/100)-XCsom-XCluz)
//          partiarti=(partiarti*(xpartart/100))
//          @ 43,60 PSAY "Calculo Part.Art.="
//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
//          endif
          
//XCACHE=PARTART          
 //         if xcodart = 7
  //        @ 43,60 PSAY "Calculo Cache="
   //       @ 43,80 PSAY XCACHE-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
    //      endif 



@ nlin,1 Psay "|"
@ nlin,21 Psay "|"
@ nlin,26 Psay "|"
@ nlin,32 Psay "CORTESIA"
@ nlin,46 PSAY "|"
@ nlin,53 Psay "|"
@ nlin,61 Psay "|"
@ nlin,73 Psay "|"

nlin := nlin+1

@ nlin,1 Psay "|"
@ nlin,2 PSAY "Configuração"
@ nlin,21 Psay "|"
@ nlin,22 Psay "Lot."
@ nlin,26 Psay "|"
@ nlin,27 Psay "Patr."
@ nlin,32 Psay "Art."
@ nlin,37 Psay "Casa"
@ nlin,42 Psay "Rad."
@ nlin,46 Psay "|"
@ nlin,47 Psay "Disp."
@ nlin,53 Psay "|"
@ nlin,54 Psay "Preço"
@ nlin,61 Psay "|"
@ nlin,62 Psay "Total Bil."
@ nlin,73 Psay "|"
              
nlin := nlin+1

@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor1
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant1 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat1 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art1 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa1 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio1 picture "9999"
_xq1=SZL->ZL_quant1-SZL->ZL_pat1-SZL->ZL_art1-SZL->ZL_casa1-SZL->ZL_radio1
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq1 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR1 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ1*SZL->ZL_VALOR1)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT1=(_xQ1*SZL->ZL_VALOR1)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1

@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor2
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant2 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat2 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art2 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa2 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio2 picture "9999"
_xq2=SZL->ZL_quant2-SZL->ZL_pat2-SZL->ZL_art2-SZL->ZL_casa2-SZL->ZL_radio2
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq2 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR2 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ2*SZL->ZL_VALOR2)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT2=(_xQ2*SZL->ZL_VALOR2)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor3
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant3 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat3 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art3 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa3 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio3 picture "9999"
_xq3=SZL->ZL_quant3-SZL->ZL_pat3-SZL->ZL_art3-SZL->ZL_casa3-SZL->ZL_radio3
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq3 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR3 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ3*SZL->ZL_VALOR3)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT3=(_xQ3*SZL->ZL_VALOR3)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor4
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant4 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat4 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art4 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa4 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio4 picture "9999"
_xq4=SZL->ZL_quant4-SZL->ZL_pat4-SZL->ZL_art4-SZL->ZL_casa4-SZL->ZL_radio4
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq4 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR4 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ4*SZL->ZL_VALOR4)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT4=(_xQ4*SZL->ZL_VALOR4)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor5
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant5 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat5 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art5 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa5 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio5 picture "9999"
_xq5=SZL->ZL_quant5-SZL->ZL_pat5-SZL->ZL_art5-SZL->ZL_casa5-SZL->ZL_radio5
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq5 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR5 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ5*SZL->ZL_VALOR5)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT5=(_xQ5*SZL->ZL_VALOR5)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor6
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant6 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat6 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art6 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa6 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio6 picture "9999"
_xq6=SZL->ZL_quant6-SZL->ZL_pat6-SZL->ZL_art6-SZL->ZL_casa6-SZL->ZL_radio6
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq6 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR6 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ6*SZL->ZL_VALOR6)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT6=(_xQ6*SZL->ZL_VALOR6)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor7
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant7 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat7 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art7 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa7 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio7 picture "9999"
_xq7=SZL->ZL_quant7-SZL->ZL_pat7-SZL->ZL_art7-SZL->ZL_casa7-SZL->ZL_radio7
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq7 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR7 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ7*SZL->ZL_VALOR7)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT7=(_xQ7*SZL->ZL_VALOR7)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor8
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant8 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat8 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art8 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa8 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio8 picture "9999"
_xq8=SZL->ZL_quant8-SZL->ZL_pat8-SZL->ZL_art8-SZL->ZL_casa8-SZL->ZL_radio8
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq8 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR8 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ8*SZL->ZL_VALOR8)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT8=(_xQ8*SZL->ZL_VALOR8)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor9
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant9 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat9 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art9 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa9 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio9 picture "9999"
_xq9=SZL->ZL_quant9-SZL->ZL_pat9-SZL->ZL_art9-SZL->ZL_casa9-SZL->ZL_radio9
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq9 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR9 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ9*SZL->ZL_VALOR9)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT9=(_xQ9*SZL->ZL_VALOR9)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor10
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant10 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat10 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art10 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa10 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio10 picture "9999"
_xq10=SZL->ZL_quant10-SZL->ZL_pat10-SZL->ZL_art10-SZL->ZL_casa10-SZL->ZL_radio10
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq10 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR10 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ10*SZL->ZL_VALOR10)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT10=(_xQ10*SZL->ZL_VALOR10)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor11
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant11 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat11 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art11 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa11 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio11 picture "9999"
_xq11=SZL->ZL_quant11-SZL->ZL_pat11-SZL->ZL_art11-SZL->ZL_casa11-SZL->ZL_radio11
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq11 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR11 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ11*SZL->ZL_VALOR11)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT11=(_xQ11*SZL->ZL_VALOR11)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin+1
@ nlin,1 Psay "|"
@ nlin,2 Psay SZL->ZL_setor12
@ nlin,21 Psay "|"
@ nlin,22 Psay SZL->ZL_quant12 picture "9999"
@ nlin,26 Psay "|"
@ nlin,27 Psay SZL->ZL_pat12 picture "9999"
@ nlin,31 Psay "|"
@ nlin,32 Psay SZL->ZL_art12 picture "9999"
@ nlin,36 Psay "|"
@ nlin,37 Psay SZL->ZL_casa12 picture "9999"
@ nlin,41 Psay "|"
@ nlin,42 Psay SZL->ZL_radio12 picture "9999"
_xq12=SZL->ZL_quant12-SZL->ZL_pat12-SZL->ZL_art12-SZL->ZL_casa12-SZL->ZL_radio12
@ nlin,46 Psay "|"
@ nlin,47 Psay _xq12 picture "99999"
@ nlin,53 Psay "|"
@ nlin,54 Psay SZL->ZL_VALOR12 PICTure "9999.99"
@ nlin,61 Psay "|"
@ nlin,62 PSAY (_xQ12*SZL->ZL_VALOR12)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
_XTOT12=(_xQ12*SZL->ZL_VALOR12)*(1-((_TXESTUD/100)*.5))
@ nlin,73 Psay "|"
  
nlin := nlin +1
@ nlin,1 psay "|"
@ nlin,2 pSAY "TOTAIS"
@ nlin,21 psay "|"
@ nlin,22 pSAY (SZL->ZL_QUANT1+SZL->ZL_QUANT2+SZL->ZL_QUANT3+SZL->ZL_QUANT4+SZL->ZL_QUANT5+SZL->ZL_QUANT6+SZL->ZL_QUANT7+SZL->ZL_QUANT8+SZL->ZL_QUANT9+SZL->ZL_QUANT10+SZL->ZL_QUANT11+SZL->ZL_QUANT12) PICTURE "9999"
@ nlin,26 psay "|"
@ nlin,27 pSAY (SZL->ZL_PAT1+ SZL->ZL_PAT2+ SZL->ZL_PAT3+ SZL->ZL_PAT4+ SZL->ZL_PAT5+ SZL->ZL_PAT6+ SZL->ZL_PAT7+ SZL->ZL_PAT8+ SZL->ZL_PAT9+ SZL->ZL_PAT10+ SZL->ZL_PAT11+ SZL->ZL_PAT12) PICTURE "9999"
@ nlin,31 psay "|"
@ nlin,32 pSAY (SZL->ZL_ART1 + SZL->ZL_ART2 + SZL->ZL_ART3 + SZL->ZL_ART4 + SZL->ZL_ART5 + SZL->ZL_ART6 + SZL->ZL_ART7 + SZL->ZL_ART8 + SZL->ZL_ART9 + SZL->ZL_ART10+ SZL->ZL_ART11+ SZL->ZL_ART12) PICTURE "9999"
@ nlin,36 psay "|"
@ nlin,37 pSAY (SZL->ZL_CASA1 + SZL->ZL_CASA2 + SZL->ZL_CASA3 + SZL->ZL_CASA4 + SZL->ZL_CASA5 + SZL->ZL_CASA6 + SZL->ZL_CASA7 + SZL->ZL_CASA8 + SZL->ZL_CASA9 + SZL->ZL_CASA10+ SZL->ZL_CASA11+ SZL->ZL_CASA12) PICTURE "9999"
@ nlin,41 psay "|"
@ nlin,42 pSAY (SZL->ZL_RADIO1 + SZL->ZL_RADIO2 + SZL->ZL_RADIO3 + SZL->ZL_RADIO4 + SZL->ZL_RADIO5 + SZL->ZL_RADIO6 + SZL->ZL_RADIO7 + SZL->ZL_RADIO8 + SZL->ZL_RADIO9 + SZL->ZL_RADIO10+ SZL->ZL_RADIO11 + SZL->ZL_RADIO12) PICTure "9999"
@ nlin,46 psay "|"
@ nlin,47 pSAY (_XQ1+_XQ2+_XQ3+_XQ4+_XQ5+_XQ6+_XQ7+_XQ8+_XQ9+_XQ10+_XQ11+_XQ12) PICTURE "99999"
@ nlin,53 psay "|"
@ nlin,61 psay "|"
@ nlin,62 pSAY (_XTOT1+_XTOT2+_XTOT3+_XTOT4+_XTOT5+_XTOT6+_XTOT7+_XTOT8+_XTOT9+_XTOT10+_XTOT11+_XTOT12) PICTURE "9999,999.99"
@ nlin,73 psay "|"
nlin := nlin+1
@ nlin,1 psay "xx**********************************************************************"

nlin := nlin +1
  
@ nlin,1 psay "Mensagem : "
@ nlin,12 psay SZL->ZL_mensage
nlin := nlin +1
@ nlin,1 psay "Mensagem : "
@ nlin,12 psay SZL->ZL_mensa1
nlin := nlin +1
@ nlin,1 psay "Mensagem : "
@ nlin,12 psay SZL->ZL_mensa2



   dbSkip() // Avanca o ponteiro do registro no arquivo
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
