#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGDIRF    บ Autor ณ MARCOS JUSTO       บ Data ณ  18/10/04    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP5 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function GDIRF()              

IF alltrim(SUBSTR(CUSUARIO,7,15)) <> "Administrador" 
  MSGalert(SUBSTR(CUSUARIO,7,15)+" Nใo autorizado")
  return()
ENDIF
 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString := "SE2"
dbSelectArea("SE2")
dbSetOrder(3)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Posicionamento do primeiro registro e loop principal. Pode-se criar ณ
//ณ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ณ
//ณ cessa enquanto a filial do registro for a filial corrente. Por exem ณ
//ณ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial())                                                   ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ O tratamento dos parametros deve ser feito dentro da logica do seu  ณ
//ณ relatorio. Geralmente a chave principal e a filial (isto vale prin- ณ
//ณ cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- ณ
//ณ meiro registro pela filial + pela chave secundaria (codigo por exem ณ
//ณ plo), e processa enquanto estes valores estiverem dentro dos parame ณ
//ณ tros definidos. Suponha por exemplo o uso de dois parametros:       ณ
//ณ mv_par01 -> Indica o codigo inicial a processar                     ณ
//ณ mv_par02 -> Indica o codigo final a processar                       ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ณ
//ณ                                                                     ณ
//ณ Assim o processamento ocorrera enquanto o codigo do registro posicioณ
//ณ nado for menor ou igual ao parametro mv_par02, que indica o codigo  ณ
//ณ limite para o processamento. Caso existam outros parametros a serem ณ
//ณ checados, isto deve ser feito dentro da estrutura de la็o (WHILE):  ณ
//ณ                                                                     ณ
//ณ mv_par01 -> Indica o codigo inicial a processar                     ณ
//ณ mv_par02 -> Indica o codigo final a processar                       ณ
//ณ mv_par03 -> Considera qual estado?                                  ณ
//ณ                                                                     ณ
//ณ dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio ณ
//ณ While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  ณ
//ณ                                                                     ณ
//ณ     If A1_EST <> mv_par03                                           ณ
//ณ         dbSkip()                                                    ณ
//ณ         Loop                                                        ณ
//ณ     Endif                                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

dbGoTop()

While !EOF()
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	// @nLin,00 PSAY SA1->A1_COD
	_prefixo := alltrim(SE2->E2_PREFIXO)
	_num     := alltrim(SE2->E2_NUM)
	_fornece := alltrim(SE2->E2_FORNECE)
	_loja    := alltrim(SE2->E2_LOJA)
	_nomfor  := alltrim(SE2->E2_NOMFOR)
	_vencrea := SE2->E2_VENCREA
	_emissao := SE2->E2_EMISSAO
	_baixa   := SE2->E2_BAIXA
	_valor   := SE2->E2_VALLIQ
	_ir      := SE2->E2_IRRF
	_pis     := SE2->E2_PIS
	_cofins  := SE2->E2_COFINS
	_csll    := SE2->E2_CSLL
	_totimpo := _ir + _pis + _cofins + _csll
	_parcela := ALLTRIM(SE2->E2_PARCELA)
	_tipo    := ALLTRIM(SE2->E2_TIPO)
	_portado := SE2->E2_PORTADO
	_numcheq := SE2->E2_NUMBCO
	_contae2 := substr(SE2->E2_CONTA,1,10)
	_iteme2  := SE2->E2_ITEM
	_clvle2  := SE2->E2_CLVL
	_ccusto2 := SE2->E2_CCUSTO
	
	
	dbSelectArea(cString)
	dbSetOrder(3)
	
	aArea      := GetArea()
	IF ALLTRIM(SE2->E2_FATURA) == "NOTFAT"
		//EMPRESA 99
		_NUM := Posicione("SE2",18,xFilial("SE2")+_NUM,"E2_NUM")
		// EMPRESA 01
	//	_NUM := Posicione("SE2",15,xFilial("SE2")+_NUM,"E2_NUM")
	ENDIF
	RestArea(aArea)
	
	dbSelectArea("SD1")
	dbSetOrder(11)
	IF	DbSeek(xFilial("SD1")+_loja+_fornece+_num,.T.)
		While !EOF() .And. SD1->D1_LOJA = _loja .And. SD1->D1_FORNECE = _fornece .And. SD1->D1_DOC = _num 
			_d1loja1  := SD1->D1_LOJA
			_d1forne1 := SD1->D1_FORNECE
			_d1doc1   := SD1->D1_DOC
			_totdoc1  := alltrim(_d1loja1)+alltrim(_d1forne1)+alltrim(_d1doc1)
			_coddirf  := alltrim(SD1->D1_CODDIRF)     
			
		IF _IR > 0	
			if _coddirf = "1708" .or. _coddirf = "0588"	
			dbSelectArea(cString)
			dbSetOrder(3)
	        Reclock("SE2",.F.)
			  SE2->E2_CODRET := _coddirf
			  SE2->E2_DIRF   := "1"
			Msunlock()  
		    dbSelectArea("SD1")
			dbSetOrder(11)
			endif
		ENDIF	
			dbSkip() // Avanca o ponteiro do registro no arquivo
			_d1loja2  := SD1->D1_LOJA
			_d1forne2 := SD1->D1_FORNECE
			_d1doc2   := SD1->D1_DOC
			_totdoc2  := alltrim(_d1loja2)+alltrim(_d1forne2)+alltrim(_d1doc2)
			
			
		Enddo
	Endif
	dbSelectArea("SE2")
	dbSetOrder(3)
	
	dbSkip()
	
	
EndDo

Return
