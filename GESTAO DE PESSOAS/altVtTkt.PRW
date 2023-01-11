#include "fileio.ch"
#include "RwMake.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO4     ºAutor  ³Microsiga           º Data ³  10/31/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function altVtTkt()
	local cPerg := "ALTVT"
	local aSays	:= {}
	local aButtons := {}     

	local nOpca := 0

	ajustaSx1(cPerg)

	pergunte(cPerg,.F.)

	AADD(aSays," Este programa ira gerar um arquivo texto, conforme os parametros ")
	AADD(aSays," definidos  pelo usuario,  com os registros do arquivo de         ")
	AADD(aSays," funcionarios e dependentes                                       ")

	AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
	AADD(aButtons, { 1,.T.,{|| nOpca:= 1, FechaBatch() }} )
	AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

	FormBatch( "Geração de VT - Tickets", aSays, aButtons )

	if nOpca == 1
	processa({|| geraArquivo() },"Gerando arquivo VT Tickets")
	endif

return

//
//
//
static function geraArquivo()

	//parametros
	local cDir		:= alltrim(MV_PAR05)
	local cNomeArq  := ""

	local cArqDat	:= dtos( dDataBase )
	local cArqSeq	:= "001"

	local cRegCab	:= ""
	local cRegEnd	:= ""
	local cRegUsu	:= ""
	local cRegBen	:= ""
	local cRegRes	:= ""
	local cRegDAd	:= ""
	local cRegRod	:= ""

	local nTotEnd	:= 0
	local nTotUsu	:= 0
	local nTotBen	:= 0
	local nTotRes	:= 0
	local nTotDAd	:= 0

	local cLinSeq	:= "000001"
	local cSeqEnd	:= "000"

	local cRegEnd	:= ""

	local aEnd		:= {}
	local cMatAnt	:= ""
	local aArq		:= {}

	private cArqNome := cArqDat + cArqSeq

	FiltraFun()
	dbgotop()
	cDataIni := trb1->R0_Period+"01"
	cDataFim := dtos(lastday(stod(cDataIni)))
	
	// Totaliza informações
	Select Trb1
	dbGoTop()
	nValVT := nFunc := nDeptos := nItem := 0
	Do while !eof()
		cDeptos	:= RA_CC
		nDeptos++
		Do while cDeptos == RA_CC .and. !eof()
			nFunc++
			cMat 	:= RA_MAT
			Do while cMat == RA_MAT .and. !eof()
				nValVT 	+= R0_VALCAL
				nItem++
				Skip
			Enddo
		Enddo
	Enddo
	
	CriaArqtmp()

	// Poiciona na empresa da entrega
	Select Trb1
	dbGoTop()
	
	if sm0->m0_codigo<>'09'
	 cCod := '0801'
	else
	 cCod := sm0->m0_codigo+'01'
	endif
	
	SM0->( dbSetOrder(1) )
	SM0->( dbSeek(cCod) )
	cCNPJ := SM0->M0_CGC

	cDir := if(right(cDir, 1) == "\", left(cDir, len(cDir) - 1), cDir)

	if !empty(alltrim(cDir))
		cNomeArq := alltrim(cDir)+"\"+cArqNome + ".txt" 
	else
		cNomeArq := "c:\temp\"+alltrim(cDir)+"\"+cArqNome + ".txt"
	endif

	if file( cNomeArq )
		fErase( cNomeArq )
	endif

	ProcRegua( contaSR0(MV_PAR01, MV_PAR02) )

	//Header Tipo = LSUP5
	cRegHead := "LSUP5"						  							//001 005 N S Tipo de registro. Fixo 0 = HEADER 
	cRegHead += padR(upper(substr(cUsuario,7,5)),8)						//006 013 C S Usuário
	cRegHead += padR(replicate(" ",11), 11) 							//014 024 C S Reservado
	cRegHead += gravaData(dDataBase, .F., 8) 							//025 032 N S Data do pedido (DDMMAAAA) 
	cRegHead += padR(time(), 08)			 							//033 040 N S Hora do pedido (HH.MM.SS) 
	cRegHead += padR("LAYOUT-26/07/2013",017)							//041 057 N S Fixo 
	cRegHead += padR(space(107), 107)		 							//058 165 C S Reservado

	GrvCsv( cNomeArq, cRegHead )

	//Registro de Cabeçalho (Header do Pedido)
	cRegHead :=  "T   "													// Tipo de Pacote 001 004 004 X Fixo “ T ”, alinhado à esquerda
	cRegHead +=  "A"													// Fixo 005 005 001 X Fixo “ A “
	cRegHead += gravaData(dDataBase, .F., 8) 							// Data da Geração 006 013 008 9 Formato AAAAMMDD
	cRegHead +=  "V4.0"													// Versão do Layout 014 017 004 X Fixo “ V4.0” versão do Layout
	cRegHead +=  space(60)												// Espaço Reservado 018 077 060 X Manter o campo em branco

	GrvCsv( cNomeArq, cRegHead )

	// Detalhes do pedido
	cData := left(dtoc(dDataBase),6)+right(dtoc(dDataBase),2)
	nQtdPed := nQtdE := 1
	//Data de e data até

	cRegHead :=  "TTPE"
	cRegHead +=  padR(Transform(cCNPJ,"@R 99.999.999/9999-99"),18)		//“99.999.999/9999-99” Com separadores e zeros à esquerda
	cRegHead +=  "K."+cData//“K.DD/MM/AA” com letra “K” e o ponto “.” fixo no início do campo seguido da data
	cRegHead +=  strzero(nQtdPed,4) //Formato 9999 - Soma das Unidades de Entrega inclusas no pedido. Zeros à esquerda
	cRegHead +=  strzero(nDeptos,4) //Formato 9999 - Soma dos Departamentos inclusos no Pedido. Zeros à esquerda
	cRegHead +=  strzero(nFunc,5) //Formato 99999 - Soma Funcionários inclusos no Pedido. Zeros à esquerda.
	cRegHead +=  strzero(nItem,6)  //Qtde. de Itens do Pedido	46	51	6	9	Formato 999999 - Soma total de Itens de Condução do pedido. Zeros à esquerda. Preenchimento é obrigatório porém pode ser zerado
	cRegHead +=  padR("0000000000000.00",016) 	//Campo fixo	52	67	16	9	Formato 0000000000000.00 **Com ponto.
	cRegHead +=  padR(Transform(strzero(nValVT*100,15),"@R 9999999999999.99"),16)	      	//Valor dos Bilhetes do Pedido	68	83	16	9	Formato 9999999999999.99 - Soma dos valores dos bilhetes no Pedido. Com ponto e zeros à esquerda.
	cRegHead +=  gravaData(dDataBase, .F., 8)	//Data da Geração dos Pedidos	84	91	8	9	Formato AAAAMMDD
	cRegHead +=  padR(" ",01)  					//Espaço Reservado	92	92	1	X	Manter o campo em branco
	cRegHead +=  padR(cDataIni,8)			//Verificar - Período de Utilização “DE”	93	100	8	9	Formato AAAAMMDD
	cRegHead +=  padR(cDataFim,8)			//Verificar - Período de Utilização “ATE”	101	108	8	9	Formato AAAAMMDD
	cRegHead +=  padR("000000000.00",012) 	// Campo fixo	109	120	12	9	FIXO “000000000.00” (zerado)
	cRegHead +=  padR("000000000.00",012) 	// Campo fixo	109	120	12	9	FIXO “000000000.00” (zerado)
	cRegHead +=  padR("N",01)			 	// Campo fixo	109	120	12	9	FIXO “000000000.00” (zerado)
	cRegHead +=  strzero(nQtdE,4)  			// Quant Unidades de Entregas	134	137	4	9	Somatório das Unidades de Entregas dentro do arquivo, formato “ 9999”, com zeros à esquerda. Pode ser preenchido “0000”
	cRegHead +=  padR("A",01)  				// Ordem de Pedido TT	138	138	1	X	“A” se por ordem de Nome ou “C” se por ordem de matrícula.
	cRegHead +=  padR("P",01)  				// Campo Fixo	139	139	1	X	FIXO “P”
	cRegHead +=  padR("%",03)  				// Campo Fixo	140	142	3	X	Fixo, “ %” alinhado à esquerda
	cRegHead +=  padR("R$",03) 				// Campo Fixo	143	145	3	X	Fixo,” R$” alinhado à esquerda

	GrvCsv( cNomeArq, cRegHead )

	// Unidade de Entrega
	cUnid := 1
	cData := left(dtoc(dDataBase),6)+right(dtoc(dDataBase),2)
	cEnd  := substr(SM0->M0_ENDENT,3,50)
	cEnd  := left(cEnd,at(",",cEnd)-1) 
	cNum  := strzero(val(substr(SM0->M0_ENDENT,at(",",SM0->M0_ENDENT)+1,10)),6)	
	cComp := left(SM0->M0_COMPENT,at(",",SM0->M0_COMPENT)-1)

	nQtdPed := nQtdE := 1
	//nDeptos := nFunc := nItem := 
	//	nValVT := 1234567.89
	//Data de e data até

	cRegHead :=  "TTUN" //Tipo de Registro	1	4	4	X	“ TTUN” Linha de identificação de Unidade de entrega
	cRegHead +=  padR(Transform(cCNPJ,"@R 99.999.999/9999-99"),18)		//“99.999.999/9999-99” Com separadores e zeros à esquerda
	cRegHead +=  "K."+cData//“K.DD/MM/AA” com letra “K” e o ponto “.” fixo no início do campo seguido da data
	cRegHead +=  strzero(cUnid,6) //Código da Unidade de Entrega	33	38	6	X	Formato 999999 Sigla para identificação da Unidade de entrega.Com zeros à esquerda.
	cRegHead +=  padR(SM0->M0_FILIAL, 26) //Código da Unidade de Entrega	33	38	6	X	Formato 999999 Sigla para identificação da Unidade de entrega.Com zeros à esquerda.
	cRegHead +=  padR("R", 04) //Tipo de Logradouro	65	68	4	X	(rua...avenida ) Vide tabela Tipo de Logradouros
	cRegHead +=  padR(cEnd, 30) //Logradouro	69	98	30	X	** vide observação
	cRegHead +=  padR(cNum, 06) //Número	99	104	6	9	Formato 999999
	cRegHead +=  padR(cComp, 10) //Complemento	105	114	10	X	Texto livre Ex: SALA, APTO...
	cRegHead +=  padR(upper(SM0->M0_BAIRENT), 15) 						// Bairro	115	129	15	X	da Unidade de Entrega
	cRegHead +=  padR(upper(SM0->M0_CIDENT), 25) 						// Município	130	154	25	X	da Unidade de Entrega
	cRegHead +=  left(SM0->M0_CEPENT,5)+"-"	// CEP	155	163	9	9	Formato 99999-999 (com traço)
	cRegHead +=  substr(SM0->M0_CEPENT,6,3)	// CEP	155	163	9	9	Formato 99999-999 (com traço)
	cRegHead +=  padR(upper(SM0->M0_ESTENT), 2) 							// Unidade Federativa	164	165	2	X	Vide tabela de UF pag ??
	cRegHead +=  gravaData(dDataBase, .F., 8)	//Data de Entrega	166	173	8	9	Formato AAAAMMDD
	cRegHead +=  gravaData(dDataBase, .F., 8)	//Data de Entrega	174	181	8	9	Formato AAAAMMDD
	cRegHead +=  padR(upper("Airton Marsola"),20) //Responsável pelo Recebimento	182	201	20	X	Responsável pelo recebimento na unidade
	cRegHead +=  padR(upper("01135761321"),11) //Telefone p/ Contato (DDD + Fone )	202	212	11	9	Formato 99999999999
	cRegHead +=  padR("1321",4)			//Ramal	213	216	4	9	Formato 9999
	cRegHead +=  padR("S",1)			//Lista de Assinaturas	217	217	1	X	“S” para Sim e “N”, para Não
	cRegHead +=  padR(space(40),40)		//Espaço Reservado	218	257	40	X	Manter campo em branco
	cRegHead +=  padR("S",1)			//Pacote separado por Depto	258	258	1	X	“S” para sim e “N” para não.

	GrvCsv( cNomeArq, cRegHead )

	SR0->( dbSetOrder(1) )
	SRA->( dbSetOrder(1) )
	SRN->( dbSetOrder(1) )

	SM0->( dbSetOrder(1) )
	SM0->( dbSeek(cEmpAnt) )
	SR0->( dbSetOrder(1) )
	
	dbSelectArea("TRB1")
	dbGotop()
	nQtdHead := 4
	nQtdReg  := 0
	while  !eof() 

	
	if SM0->M0_CODIGO = "08" .AND. SM0->M0_CODFIL $ "03*04*05"
	SM0->( dbSkip() )
	loop
	endif

	cLinSeq := soma1(cLinSeq)
	cSeqEnd := soma1(cSeqEnd)

	// Departamento /Centros de Custos (6 primeiros dígitos)
	
	Select CTT
	dbSetOrder(1)
	Seek xFilial()+left(trb1->RA_CC,6)+"00"
	if eof()
		Seek xFilial()+left(trb1->RA_CC,6)
	endif
	cDescCC := trb1->CTT_DESC01
	nQtdHead ++

	Select Trb1

	cComp := left(SM0->M0_COMPENT,at(",",SM0->M0_COMPENT)-1)

	if !empty(cDescCC)
		cRegHead :=  padR("TTDE",4) //Tipo de Produto / Registro	1	4	4	X	Fixo “ TTDE” identificação dos departamentos
		cRegHead +=  padR(Transform(cCNPJ,"@R 99.999.999/9999-99"),18)		//“99.999.999/9999-99” Com separadores e zeros à esquerda
		cRegHead +=  "K."+cData//“K.DD/MM/AA” com letra “K” e o ponto “.” fixo no início do campo seguido da data
		cRegHead +=  strzero(cUnid,6) //Código da Unidade de Entrega	33	38	6	X	Formato 999999 Sigla parae o departamento
		cRegHead +=  padR(left(trb1->RA_CC,6),6) //Código do Departamento	39	44	6	X	Formato 999999 Sigla do Departamento. Com zeros à esquerda.
		cRegHead +=  padR(cDescCC,26)  // Nome do Departamento	45	70	26	X	
		cRegHead +=  padR(Space(20),20) //Espaço Reservado	71	90	20	X	Manter o campo em Branco
		cRegHead +=  padR(Transform(cCNPJ,"@R 99.999.999/9999-99"),18)		//CNPJ de Faturamento	91	108	18	X	Formato 99.999.999/9999-99Com pontos, barra, traço com zeros à esquerda. Deve ser o mesmo número informado no campo “CNPJ Principal”

		GrvCsv( cNomeArq, cRegHead )
	Endif
	
	while !eof()// .and. left(trb1->RA_CC,6) = left(CTT->CTT_CUSTO,6)

	if empty(trb1->RA_MAT)
		trb1->(dbskip() )
		loop
	endif
	

	IncProc("Filial: " + trb1->R0_FILIAL + " Func.: " + trb1->RA_MAT)

	dbSelectArea("TRB1")

	if TRB1->R0_QDIACAL > 0  .and. TRB1->RA_SITFOLH != "D" .and. TRB1->R0_TPVALE == "0" 

	//if cMatAnt != TRB1->RA_MAT

	cRg := strzero(val(left(strTran(strTran(alltrim(TRB1->RA_RG), "-", ""),".",""), len(alltrim(SRA->RA_RG)) - 1 )), 10) //Número do RG *	87	96	10	X	Ou RGE em caso de estrangeiro. Caso o documento possua o digito, utilizar o traço. EX12121256-X

	cRegFun :=  padR("TTFU",4) 				//Tipo de Produto / Registro	1	4	4	X	Fixo “ TTDE” identificação dos departamentos
	cRegFun +=  padR(Transform(cCNPJ,"@R 99.999.999/9999-99"),18)		//“99.999.999/9999-99” Com separadores e zeros à esquerda
	cRegFun +=  "K."+cData					//“K.DD/MM/AA” com letra “K” e o ponto “.” fixo no início do campo seguido da data
	cRegFun +=  strzero(cUnid,6) 			//Código da Unidade de Entrega	33	38	6	X	Formato 999999 Sigla parae o departamento
	cRegFun +=  padR(left(TRB1->RA_CC,6),6)			 //Código do Departamento	39	44	6	X	Formato 999999 Sigla do Departamento. Com zeros à esquerda.
	cRegFun +=  strzero(val(TRB1->RA_MAT),12) //Identificação do Funcionário	45	56	12	9	Código ou Matrícula do funcionário (Funcional, Registro, etc.). Com zeros à esquerda.
	cRegFun +=  padR(alltrim(TRB1->RA_NOME), 30) //Nome do Funcionário	57	86	30	X
	cRegFun +=  cRg								 //Número do RG *	87	96	10	X	Ou RGE em caso de estrangeiro. Caso o documento possua o digito, utilizar o traço. EX12121256-X
//	cRegFun +=  cRegUsu += padL(TRB1->RA_CIC, 11, "0") //Número do CPF *	97	107	11	9	Não utilizar caracteres “.”(ponto), “,”(virgula), “- “(traço) .
	cRegFun +=  padL(TRB1->RA_CIC, 11, "0") //Número do CPF *	97	107	11	9	Não utilizar caracteres “.”(ponto), “,”(virgula), “- “(traço) .
	cRegFun +=  padR(" ", 4) //Espaço Reservado	108	111	4	X	Manter o campo em branco
	cRegFun +=  gravaData(stod(TRB1->RA_NASC), .F., 8) //Data de Nascimento *	112	119	8	9	Formato “AAAAMMDD”
	cRegFun += padR(alltrim(TRB1->RA_RGUF), 2) //UF do RG *	120	121	2	X	Estado de Emissão do RG.Vide tabela Ufs
	cRegFun += padR(alltrim(TRB1->RA_SEXO), 1) //Sexo *	122	122	1	X	“F” - Feminino e “M” - Masculino
	cRegFun += padR(alltrim(TRB1->RA_MAE), 30) //Nome da Mãe *	123	152	30	X
	cRegFun += padR(alltrim(TRB1->RA_LOGRTP), 5)
	cRegFun += padR(alltrim(TRB1->RA_LOGRDSC), 40)
	cRegFun += padR(alltrim(TRB1->RA_LOGRNUM), 06)
	cRegFun += padR(alltrim(TRB1->RA_COMPLEM), 15)
	cRegFun += padR(alltrim(TRB1->RA_MUNICIP), 40)
	cRegFun += padR(alltrim(TRB1->RA_BAIRRO), 30)
	cRegFun += padR(alltrim(TRB1->RA_CEP), 08)
	cRegFun += padR(alltrim(TRB1->RA_ESTADO), 02)
	cRegFun += padR("000201",6)

	GrvCsv( cNomeArq, cRegFun )
	nQtdReg++
	nSeq := 1
	cLinSeq := soma1(cLinSeq)

	//endif				
	
	cMat := trb1->R0_MAT
	do while !eof() .and. trb1->R0_MAT = cMat 
	//Registro de Beneficios

do case
Case trim(TRB1->R0_CODIGO)='23'
	cOperadora 	:= 'SPTRAN'
	cBilhete	:= 'METRO VTE'
Case trim(TRB1->R0_CODIGO)='24'
	cOperadora 	:= 'SPTRAN'
	cBilhete	:= 'SPTRANS VTE'
Case trim(TRB1->R0_CODIGO)='25'
	cOperadora 	:= 'SPTRAN'
	cBilhete	:= 'INTEGRA VTE'
Case trim(TRB1->R0_CODIGO)='P8'
	cOperadora 	:= 'CMT'
	cBilhete	:= 'BOM LIVRE'
Case trim(TRB1->R0_CODIGO)='Q8'
	cOperadora 	:= 'CMTO'
	cBilhete	:= 'BEM OSASCO'
Case trim(TRB1->R0_CODIGO)='Q2'
	cOperadora 	:= 'CMTO'
	cBilhete	:= 'BEM OSASCO'
Case trim(TRB1->R0_CODIGO)='N8'
	cOperadora 	:= 'CMT'
	cBilhete	:= 'BOM LIVRE'
Case trim(TRB1->R0_CODIGO)='T9'
	cOperadora 	:= 'CMT'
	cBilhete	:= 'BOM LIVRE'
Case trim(TRB1->R0_CODIGO)='U9'
	cOperadora 	:= 'CMT'
	cBilhete	:= 'BOM LIVRE'
Otherwise
	cOperadora 	:= 'Verificar '+TRB1->R0_CODIGO
	cBilhete	:= 'Verificar '+TRB1->R0_CODIGO
Endcase	

	SRN->( dbSeek(xFilial("SRN")+trb1->R0_CODIGO) )
	cLinSeq := soma1(cLinSeq)
	cValVale := strzero(trb1->R0_VLRVALE*100,8)
	cValVale := left(cValVale,6)+"."+right(cValVale,2)

	cRegBen	:= padR("TTIT",4)														//Tipo de Produto / Registro	1	4	4	X	“TTIT “Linha de Itens
	cRegBen +=  padR(Transform(cCNPJ,"@R 99.999.999/9999-99"),18)		//“99.999.999/9999-99” Com separadores e zeros à esquerda
	cRegBen +=  "K."+cData//“K.DD/MM/AA” com letra “K” e o ponto “.” fixo no início do campo seguido da data
	cRegBen +=  strzero(cUnid,6) //Código da Unidade de Entrega	33	38	6	X	Formato 999999 Sigla parae o departamento
	cRegBen +=  padR(left(trb1->ra_cc,6),6) //Código do Departamento	39	44	6	X	Formato 999999 Sigla do Departamento. Com zeros à esquerda.
	cRegBen +=  strzero(val(trb1->RA_MAT),12) //Identificação do Funcionário	45	56	12	9	Código ou Matrícula do funcionário (Funcional, Registro, etc.). Com zeros à esquerda.
	cRegBen +=  strzero(nSeq,3) //Sequência dos Itens Funcionário	57	59	3	9	Formato “999”Sequência dos Itens do funcionário. Ex: para o 1º Item 001 para o 2º Item 002 e assim por diante.
	cRegBen +=  strzero(trb1->R0_QDIACAL,8) //Qtde. de Bilhetes / Viagens	60	67	8	9	Formato “999999999” Soma da Qtde. dos Bilhetes / Viagens. Com zeros à esquerda.
	cRegBen +=  padR(cValVale,9)  //Valor da Tarifa do Item	68	76	9	X	Formato “999999.99” Valor da Tarifa Unitária do Item. Com zeros à esquerda e ponto.

	cRegBen	+= padR(cOperadora, 6) 		//Código da Operadora de Transporte	77	82	6	X	Código da Operadora conforme padrão Ticket. **Vide observação
	cRegBen	+= padR(cBilhete, 12) 	//Código do Bilhete	83	94	12	X	Código do Bilhete conforme padrão Ticket. **Vide observação
	
//	cRegBen +=  strzero(trb1->R0_VALCAL,9) //Valor da Tarifa do Item	68	76	9	X	Formato “999999.99” Valor da Tarifa Unitária do Item. Com zeros à esquerda e ponto.
	//
	//
	cRegBen	+= padR(" ", 4) //Campo fixo	95	98	4	X	Manter 4 posições em Branco
	cRegBen	+= padR("N", 1) //Flag do Tipo (para uso da Ticket)	99	99	1	X	“N” fixo

	nSeq++														//235-240 006 NUMERICO SIM SEQUÊNCIA DO REGISTRO
	*/	        
	GrvCsv( cNomeArq, cRegBen )

	nTotBen++	
	nQtdReg++

	cMatAnt := Trb1->RA_MAT
	SR0->( dbSkip() )
	trb1->(dbskip() )

	Enddo

	endif
	
	end

	end
	
	cLinSeq := soma1(cLinSeq)

	//Registro de Rodape
	nTot := 0

	cRegRod := "9999"									//Sequência do Registro 001 004 004 X “9999” FIXO	
	cRegRod += strzero(ntot,8)							//Qtde. Total de registros do produto 005 012 008 9 Formato “99999999” Soma da quantidade total de registros do produto
	cRegRod += padR(" ", 152)							//Espaço Reservado 013 164 152 X Manter o campo em Branco 

	GrvCsv( cNomeArq, cRegRod )
	nTrail := 2
	nTotal := 1

	cRegRod := "LSUP9"									//Sequência do Registro 001 004 004 X “9999” FIXO	
	cRegRod += strzero(nQtdHead,8)							//Quantidade de Header 006 013 008 9 Formato 99999999 Somatório total dos registros Header’s do arquivo
	cRegRod += strzero(nTrail,8)						//Quantidade de Trailler 014 021 008 9 Somatório total dos registros Trailler’s do arquivo
	cRegRod += strzero(nQtdReg,8)						//Quantidade de registros dentro do arquivo 022 029 008 9 Somatório total dos registros do arquivo,formato,exceto header’s e trailler’s
	cRegRod += padR(" ", 226)							//Espaço Reservado 030 255 226 X Brancos 

	GrvCsv( cNomeArq, cRegRod )

	/*
	cRegRod += padL(alltrim(str(nTotEnd)), 6, "0")										//002-007 006 NUMERICO SIM QTDE REGISTROS - TIPO 1
	cRegRod += padL(alltrim(str(nTotUsu)), 6, "0")										//008-013 006 NUMERICO SIM QTDE REGISTROS - TIPO 2
	cRegRod += padL(alltrim(str(nTotBen)), 6, "0")										//014-019 006 NUMERICO SIM QTDE REGISTROS - TIPO 3
	cRegRod += padL(alltrim(str(nTotRes)), 6, "0")										//020-025 006 NUMERICO SIM QTDE REGISTROS - TIPO 4
	cRegRod += padL(alltrim(str(nTotDAd)), 6, "0")										//026-031 006 NUMERICO SIM QTDE REGISTROS - TIPO 5
	*/

	oReport := RptDef("ALTVT")
	if MsgBox ("Deseja abrir planilha Excel ?","Escolha","YESNO")
	oReport:PrintDialog() 
	endif
	//MsgBox ("Arquivo gerado com sucesso ","Informa‡Æo","INFO")


return

static function ajustaSx1(cPerg)

	PutSx1( cPerg, "01", "Filial de   ?"  ,"Filial de ?"    ,"Filial de ?"   ,"mv_ch1","C",2,0,2,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,,"")
	PutSx1( cPerg, "02", "Filial até  ?"  ,"Filial até ?"   ,"Filial até ?"  ,"mv_ch2","C",2,0,2,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,,"")
	PutSx1( cPerg, "03", "Matricula de?"  ,"Filial de ?"    ,"Filial de ?"   ,"mv_ch3","C",6,0,2,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",,,,"")
	PutSx1( cPerg, "04", "Matricula ate?" , "Matricula ate?","Matricula ate?","mv_ch4","C",6,0,2,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",,,,"")
	PutSx1( cPerg, "05", "Diretório"      , "Diretório"     , "Diretório"    ,"mv_ch5","C",99,0,0,"G","","HSSDIR","","","mv_par05","","","","","","","","","","","","","","","","")

return

static function GrvCsv( cArquivo, cTexto )
	Local nHdl 		:= 0

	If !File(cArquivo)
	nHdl := FCreate(cArquivo)
	Else
		nHdl := FOpen(cArquivo, FO_READWRITE)
	Endif
	FSeek(nHdl,0,FS_END)
	cTexto += Chr(13)+Chr(10)
	FWrite(nHdl, cTexto, Len(cTexto))
	FClose(nHdl)

Return

//
//
//
static function trataEndereco( cEnd )
	local aRet := {"", ""}
	local nPosVig := at(",", cEnd)

	cEnd := alltrim(cEnd)

	if nPosVig > 0
	aRet[1] := alltrim(left(cEnd, nPosVig - 1 ))
	aRet[2] := alltrim(subs(cEnd, nPosVig + 1 ))
	else
		aRet[1] := cEnd
		aRet[2] := "0"
	endif

return aRet

static function contaSR0(cFilDe, cFilAte)
	local nCount := 0

	beginSQL alias "ALT1"
	SELECT count(*) CONTA
	FROM %table:SR0% S
	WHERE R0_FILIAL between %exp:cFilDe% and %exp:cFilAte%
	AND S.D_E_L_E_T_ = ' '
	endSQL

	if ALT1->( !eof() ) .and. ALT1->CONTA > 0
	nCount := ALT1->CONTA
	endif

	ALT1->( dbCloseArea() )

return nCount



Static Function CriaArqtmp()

	IF SELECT("TRB") # 0
	TRB->(DBCLOSEAREA( ))
	ENDIF

	//????????????????????????????????
	//?Cria array para gerar arquivo de trabalho                    ?
	//????????????????????????????????
	aCampos := {}
	AADD(aCampos,{ "Mat"     , "C",13,0})  //1- Matrícula
	AADD(aCampos,{ "NOME"    , "C",40,0})  //22-Nome
	AADD(aCampos,{ "Valor"   , "N",12,2})
	AADD(aCampos,{ "QDiaCal" , "N",12,2})
	AADD(aCampos,{ "QDiaInf" , "N",12,2})
	AADD(aCampos,{ "TpVale"  , "C",02,0})
	AADD(aCampos,{ "DataNasc", "C",10,0})  //2- Data Nascimento
	AADD(aCampos,{ "CPF"     , "C",15,0})  //3- CPF
	AADD(aCampos,{ "TipoDoc" , "C",02,0})  //4- tipo Doc
	AADD(aCampos,{ "RG"      , "C",13,0})  //5- RG
	AADD(aCampos,{ "EMISSOR" , "C",06,0})  //6- Orgao Emissor
	AADD(aCampos,{ "UF"      , "C",02,0})  //7- UF Emissor
	AADD(aCampos,{ "PIS"     , "C",15,0})  //8- PIS
	AADD(aCampos,{ "SEXO"    , "C",02,0})  //9- SEXO
	AADD(aCampos,{ "ESTCIVIL", "C",01,0})  //10-Est.Civil
	AADD(aCampos,{ "ENDER"   , "C",35,0})  //11-Endereço
	AADD(aCampos,{ "COMPL"   , "C",10,0})  //12-Complemento
	AADD(aCampos,{ "NUMEND"  , "C",05,0})  //13-Num.endereço
	AADD(aCampos,{ "CEP"     , "C",08,0})  //14-CEP
	AADD(aCampos,{ "MUN"     , "C",28,0})  //15-Município
	AADD(aCampos,{ "BAIR"    , "C",30,0})  //16-Bairro
	AADD(aCampos,{ "EST"     , "C",02,0})  //17-Estado Res
	AADD(aCampos,{ "MAE"     , "C",35,0})  //18-Nome da Mãe
	AADD(aCampos,{ "DDDRES"  , "C",13,0})  //5- RG
	AADD(aCampos,{ "TELRES"  , "C",13,0})  //5- RG
	AADD(aCampos,{ "ADMISS"  , "C",10,0})  //21-Admissão

	cTemp := CriaTrab(nil,.f.)
	dbCreate(cTemp,aCampos)
	dbUseArea( .T.,,cTemp,"TRB", Nil, .F. )

Return		

Static Function RptDef(cNome)

	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	Local oSection3:= Nil
	Local oSection4:= Nil
	Local oSection5:= Nil
	Local oSection6:= Nil
	Local oBreak
	Local oFunction   

	oReport := TReport():New(cNome,"VALE TRANSPORTE",cNome,{|oReport| ReportPrint(oReport)},"Vale Transporte")
	oReport:SetPortrait()
	oReport:SetTotalInLine(.F.)




	oSection1 := TRSection():New(oReport,"VT TKS", {"TRB"}, , .F., .T.)



	TRCell():New(oSection1,"MAT"		,"TRB","Matrícula"    ,"@!",10)
	TRCell():New(oSection1,"NOME"		,"TRB","Funcionário"  ,"@!",40)
	TRCell():New(oSection1,"VALOR"		,"TRB","Valor","@E 999,999,999.99",15)
	TRCell():New(oSection1,"QDIACAL"	,"TRB","Quantidade Dia Calculada ","@E 999,999,999.99",15)
	TRCell():New(oSection1,"QDIAINF"	,"TRB","Quantidade Dia Informada ","@E 999,999,999.99",15)
	TRCell():New(oSection1,"TPVALE"		,"TRB","Tipo de Vale","@!",02)
	TRCell():New(oSection1,"DATANASC"	,"TRB","Nascimento"  ,"@!",10)
	TRCell():New(oSection1,"CPF"		,"TRB","CPF"  ,"@!",15)
	//TRCell():New(oSection1,"TIPODOC"	,"TRB","Tipo Doc"  ,"@!",01)
	TRCell():New(oSection1,"RG"		    ,"TRB","RG"  ,"@!",20)
	TRCell():New(oSection1,"EMISSOR"	,"TRB","Emissor"  ,"@!",08)
	//TRCell():New(oSection1,"UF"		    ,"TRB","UF Emiss"  ,"@!",02)
	TRCell():New(oSection1,"PIS"		,"TRB","PIS"  ,"@!",20)
	TRCell():New(oSection1,"SEXO"		,"TRB","Sexo"  ,"@!",08)
	TRCell():New(oSection1,"ESTCIVIL"	,"TRB","Est.Civil"  ,"@!",20)
	TRCell():New(oSection1,"ENDER"		,"TRB","Endereço"  ,"@!",40)
	TRCell():New(oSection1,"COMPL"		,"TRB","Complemento"  ,"@!",08)
	TRCell():New(oSection1,"NUMEND"		,"TRB","Numero End"   ,"@!",05)
	TRCell():New(oSection1,"CEP"		,"TRB","CEP"  ,"@!",08)
	TRCell():New(oSection1,"MUN"		,"TRB","Município"  ,"@!",30)
	TRCell():New(oSection1,"BAIR"		,"TRB","Bairro"  ,"@!",30)
	TRCell():New(oSection1,"EST"		,"TRB","Estado"  ,"@!",02)
	TRCell():New(oSection1,"MAE"		,"TRB","Nome da Mãe"  ,"@!",40)
	//TRCell():New(oSection1,"DDDRES"		,"TRB","DDD Res"  ,"@!",04)
	//TRCell():New(oSection1,"TELRES"		,"TRB","Telefone Res"  ,"@!",20)
	TRCell():New(oSection1,"ADMISS"		,"TRB","Data Admissão"  ,"@!",10)

	oReport:SetTotalInLine(.F.)

	//quebra  por seção
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")
Return(oReport)

Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)

	Local cQuery    := ""
	Local cPedido   := ""
	Local lPrim 	:= .T.

	dbSelectArea("TRB")
	TRB->(dbGoTop())

	oReport:SetMeter(TRB->(LastRec()))

	While !Eof() // total Geral

	If oReport:Cancel()
	Exit
	EndIf

	//inicializo a primeira seção
	oSection1:Init()

	oReport:IncMeter()

	dbSelectArea("TRB")

	IncProc("Imprimindo ")

	Do while !eof()
	oReport:IncMeter()

	//imprimo a primeira seção
	oSection1:Cell("MAT"):SetValue(TRB->MAT)
	oSection1:Cell("NOME"):SetValue(TRB->NOME)
	oSection1:Cell("VALOR"):SetValue(TRB->VALOR)
	oSection1:Cell("QDIACAL"):SetValue(TRB->QDIACAL)
	oSection1:Cell("QDIAINF"):SetValue(TRB->QDIAINF)
	oSection1:Cell("TPVALE"):SetValue(TRB->TPVALE)
	oSection1:Cell("DATANASC"):SetValue(TRB->DATANASC)
	oSection1:Cell("CPF"):SetValue(TRB->CPF)
	//		oSection1:Cell("TIPODOC"):SetValue(TRB->TIPODOC)
	oSection1:Cell("RG"):SetValue(TRB->RG)
	oSection1:Cell("EMISSOR"):SetValue(TRB->EMISSOR)
	//		oSection1:Cell("UF"):SetValue(TRB->UF)
	oSection1:Cell("PIS"):SetValue(TRB->PIS)
	oSection1:Cell("SEXO"):SetValue(TRB->SEXO)
	oSection1:Cell("ESTCIVIL"):SetValue(TRB->ESTCIVIL)
	oSection1:Cell("ENDER"):SetValue(TRB->ENDER)
	oSection1:Cell("COMPL"):SetValue(TRB->COMPL)
	oSection1:Cell("NUMEND"):SetValue(TRB->NUMEND)
	oSection1:Cell("CEP"):SetValue(TRB->CEP)
	oSection1:Cell("BAIR"):SetValue(TRB->BAIR)
	oSection1:Cell("EST"):SetValue(TRB->EST)
	oSection1:Cell("MAE"):SetValue(TRB->MAE)
	//		oSection1:Cell("DDDRES"):SetValue(TRB->DDDRES)
	//		oSection1:Cell("TELRES"):SetValue(TRB->TELRES)
	oSection1:Cell("ADMISS"):SetValue(TRB->ADMISS)


	oSection1:Printline()
	TRB->(dbSkip())
	Enddo

	//finalizo a primeira seção
	Enddo
	oSection1:Finish()

Return

Static Function GravaDet(_cAlias)

	RecLock("TRB",.t.)
	trb->Mat := (_cAlias)->RA_Mat
	trb->NOME := (_cAlias)->RA_NOME
	trb->Valor := SR0->R0_VALCAL 
	trb->QDiaCal := SR0->R0_QDIACAL
	trb->QDiaInf := SR0->R0_QDIAINF
	trb->TpVale	 := SR0->R0_TPVALE
	trb->DataNasc := dtoc((_cAlias)->RA_NASC)
	trb->CPF := (_cAlias)->RA_CIC
	//trb->TipoDoc := (_cAlias)->RA_
	trb->RG := (_cAlias)->RA_RG
	trb->EMISSOR := (_cAlias)->RA_RGORG
	//trb->UF := (_cAlias)->RA_
	trb->PIS := (_cAlias)->RA_PIS
	trb->SEXO := (_cAlias)->RA_SEXO
	trb->ESTCIVIL := (_cAlias)->RA_ESTCIVI
	trb->ENDER := (_cAlias)->RA_ENDEREC
	trb->COMPL := (_cAlias)->RA_COMPLEM
	trb->NUMEND := (_cAlias)->RA_NUMENDE
	trb->CEP := (_cAlias)->RA_CEP
	trb->MUN := (_cAlias)->RA_MUNICIP
	trb->BAIR := (_cAlias)->RA_BAIRRO
	trb->EST := (_cAlias)->RA_ESTADO
	trb->MAE := (_cAlias)->RA_MAE
	//trb->DDDRES := (_cAlias)->RA_
	//trb->TELRES := (_cAlias)->RA_
	trb->ADMISS := dtoc((_cAlias)->RA_ADMISSA)
	MsUnLock()			


	*/
Static Function FiltraFun()

	cQuery := "SELECT RG2.RG2_FILIAL AS R0_FILIAL,RG2.RG2_MAT AS R0_MAT,RG2.RG2_DIACAL AS R0_QDIACAL,RG2.RG2_TPVALE AS R0_TPVALE,RG2.RG2_VALCAL AS R0_VALCAL,RG2.RG2_CODIGO AS R0_CODIGO,RG2.RG2_CUSUNI AS R0_VLRVALE,RG2.RG2_PERIOD AS R0_PERIOD, "
	cQuery += "      SRA.RA_FILIAL,SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, CTT.CTT_DESC01,	SRA.RA_SUP, SRA.RA_NOMSUP, SRA.RA_CIC, SRA.RA_PIS, SRA.RA_RG, SRA.RA_RGORG,SRA.RA_RGUF, "
	cQuery += "	 	 RA_LOGRTP,RA_LOGRDSC,RA_LOGRNUM, "
	cQuery += "      SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_UFCP, SRA.RA_ZONASEC, SRA.RA_ENDEREC, SRA.RA_NUMENDE, SRA.RA_COMPLEM,	SRA.RA_BAIRRO, SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP,"
	cQuery += "      SRA.RA_TELEFON, SRA.RA_PAI, SRA.RA_MAE, SRA.RA_SEXO, SRA.RA_ESTCIVI, SRA.RA_NATURAL, SRA.RA_NACIONA, SRA.RA_NASC, SRA.RA_ADMISSA,"
	cQuery += "      SRA.RA_BCDEPSA, SRA.RA_CTDEPSA, SRA.RA_CTDPFGT, SRA.RA_SITFOLH "
	cQuery += " FROM "+retSqlName("RG2")+ " RG2 "

	cQuery += " LEFT JOIN "+retSqlName("SRA")+ " SRA "
	cQuery += " ON RA_MAT = RG2.RG2_MAT "
	cQuery += " AND RA_SITFOLH <> 'D'"
	cQuery += " AND SRA.D_E_L_E_T_ <> '*' "

	cQuery += " LEFT JOIN "+retSqlName("CTT")+ " CTT "
	cQuery += " ON CTT_CUSTO = RA_CC "
	cQuery += " AND CTT.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE "
	cQuery += " RG2_PERIOD='"+MV_PAR06+"'"
	cQuery += " AND  RG2.RG2_DIACAL > 0  AND RG2.RG2_TPVALE = '0' "
	cQuery += " AND  RG2.RG2_FILIAL  <>' ' "
	cQuery += " AND  RG2.RG2_FILIAL  >= '"+MV_PAR01+"' AND RG2.RG2_FILIAL  <= '"+MV_PAR02+"' "
	cQuery += " AND  RG2.RG2_MAT  >= '"+MV_PAR03+"' AND RG2.RG2_MAT  <= '"+MV_PAR04+"' "
	cQuery += " AND   RG2.D_E_L_E_T_ <> '*' "

	cQuery += " ORDER BY RA_CC,RA_MAT "

	If Select("TRBX") > 0
	DbSelectArea("TRBX")
	DbCloseArea()
	Endif

	TCQUERY cQuery NEW ALIAS "TRBX"
	DbSelectArea("TRBX")
	nTotReg := reccount()
	DBGOTOP()
	_cArqTrb1:= CriaTrab(nil,.f.)
	Copy To &(_cArqTrb1+OrdBagExt())
	Copy To \data\vt
	DbCloseArea()
	If Select("trb1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
	Endif

	DbUseArea( .T.,__LocalDriver,_cArqTrb1+OrdBagExt(), "TRB1",.T., .T. )

	Return
//Static Function DePara()

do case
Case SR0->R0_CODIGO='23'
	cOperadora 	:= 'SPTRAN'
	cBilhete	:= 'METRO VTE'
Case SR0->R0_CODIGO='24'
	cOperadora 	:= 'SPTRAN'
	cBilhete	:= 'SPTRANS VTE'
Case SR0->R0_CODIGO='25'
	cOperadora 	:= 'SPTRAN'
	cBilhete	:= 'INTEGRA VTE'
Case SR0->R0_CODIGO='P8'
	cOperadora 	:= 'CMT'
	cBilhete	:= 'BOM LIVRE'
Case SR0->R0_CODIGO='Q8'
	cOperadora 	:= 'CMTO'
	cBilhete	:= 'BEM OSASCO'
Endcase	