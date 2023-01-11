#include "protheus.ch"
#include "fileio.ch"
#include "RwMake.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³altVrGen  ºAutor  ³Rodrigo Fazan       º Data ³  11/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function altVRTk()
local cPerg := "ALTVR"
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

FormBatch( "Geração de VR", aSays, aButtons )

if nOpca == 1
	processa({|| geraArquivo() },"Gerando arquivo VR")
endif

return


static function geraArquivo()

local cRegHead	:= ""
local cRegFilial:= ""
local cRegArea	:= ""
local cRegUsu	:= ""
local cRegTra	:= ""

local aEscola	:= {"1",; //primeiro grau
					"2",; //segundo grau
					"3",; //superior
					"4"}  //pos

local aSexo		:= {"F",; //feminino
					"M"}  //masculino
					
local aTpDoc	:= {"1",; //RG
					"2",; //RNE
					"3"}  //Passaporte

local aEstCivil := {"1",; //1 - Solteiro
					"2",; //2 - Casado
					"3",; //3 - Viuvo
					"4",; //4 - Separado
					"5"}  //Outros
					
local cLinSeq	:= "000001" 

local nTotSeq5	:= 1
local nTotVal	:= 0

local cDir		:= alltrim(MV_PAR05)
local cNomeArq  := ""

local cArqDat	:= dtos( dDataBase )
local cArqSeq	:= "001"
Local _cQuery	:= ""
Local _cAlias
Local oReport := nil  // Relatório em Excel
	
private cArqNome := cArqDat + cArqSeq

cDir := if(right(cDir, 1) == "\", left(cDir, len(cDir) - 1), cDir)

if !empty(alltrim(cDir))
	cNomeArq := alltrim(cDir)+"\"+cArqNome + ".txt" 
else
	cNomeArq := "c:\temp\"+alltrim(cDir)+"\"+cArqNome + ".txt"
endif

if file( cNomeArq )
	fErase( cNomeArq )
endif

CriaArqtmp()

SR0->( dbSetOrder(1) )
SRA->( dbSetOrder(1) )
SRN->( dbSetOrder(1) )

SM0->( dbSetOrder(1) )
SM0->( dbSeek(cEmpAnt+MV_PAR01) )

//Header Tipo = LSUP5
cRegHead := "LSUP5"						  							//001 005 N S Tipo de registro. Fixo 0 = HEADER 
cRegHead += padR(upper(substr(cUsuario,7,5)),8)						//006 013 C S Usuário
cRegHead += padR(replicate(" ",11), 11) 							//014 024 C S Reservado
cRegHead += gravaData(dDataBase, .F., 8) 							//025 032 N S Data do pedido (DDMMAAAA) 
cRegHead += padR(time(), 08)			 							//033 040 N S Hora do pedido (HH.MM.SS) 
cRegHead += padR("LAYOUT-16/06/2014",017)							//041 057 N S Fixo 
cRegHead += padR(space(107), 107)		 							//058 165 C S Reservado

/*
cRegHead += padR(upper(SM0->M0_NOME), 35) 							//014 035 C S Nome da Razão Social da Empresa Cliente ou Nome do cliente Autônomo 
cRegHead += padR(SM0->M0_CGC, 14)		   							//049 014 N S(*1) Número do CNPJ do Emitente do Pedido 
cRegHead += padL("", 11, "0")		  								//063 011 N S(*2) Número do CPF do Cliente Autônomo 
cRegHead += padL(alltrim(MV_PAR06), 11, "0")						//074 011 N S Número do Contrato. 
//cRegHead += substr(dtos(dDataBase), 5,2)+left(dtos(dDataBase), 4)	//085 006 N N Número do Pedido do Cliente 
cRegHead += mv_par07 	//085 006 N N Número do Pedido do Cliente 
cRegHead += gravaData(dDataBase, .F., 5)   							//091 008 N S(*3) Data de Efetivação do Benefício (DDMMAAAA) 
cRegHead += "2"							 							//099 001 N S 1 = AVV 2= RVV 3= CVV 4= NVV 5= FVV 
cRegHead += "1"														//100 001 N S 1 = Pedido Normal 2 = Pedido Complementar
//cRegHead += substr(dtos(dDataBase), 5,2)+left(dtos(dDataBase), 4)	//101 006 N S Mês de Competência do Benefício (MMAAAA) 
cRegHead += mv_par07	//101 006 N S Mês de Competência do Benefício (MMAAAA) 
cRegHead += padR(" ", 18)											//107 018 C S Reservado para uso livre dos Clientes 
cRegHead += "7  "													//125 003 N S Versão do layout. Fixo: 7 para este layout 
cRegHead += padR(" ", 267)											//128 267 C S Espaços em Branco. 
cRegHead += cLinSeq													//395 006 N S Número seqüencial do registro. Numeração seqüencial e contínua do registro de arquivo. 
//cRegHead += //401 050 C N Códigos de Retorno (de zero a 10 códigos, separados por ”;”). Não deve ser preenchido pelo cliente.							
*/

GrvCsv( cNomeArq, cRegHead )

clinSeq := soma1(cLinSeq)

//mv_par06 := "096130261" // Informar nos parâmetros o número do contrato
cRegHead :=  "T"													// Tipo de Produto / Seqüência	001	001	001	X	Fixo “T”
cRegHead +=  "R"													// Produto	002	002	001	X	A = Alimentação R = Restaurante
cRegHead +=  "02"													// Fixo	003	004	002	X	Fixo “02”
cRegHead +=  "0"													// Tipo de Registro	005	005	001	X	“0”
cRegHead +=  "R0"													// Produto	006	006	001	X	A = Alimentação R = Restaurante
cRegHead += padL(alltrim(MV_PAR06), 9, "0")							// Código do Cliente	007	016	010	9	Código de contrato do cliente
cRegHead += padR(upper(SM0->M0_NOMECOM), 24) 						// Nome da Empresa	017	040	024	X
cRegHead += padR(space(6), 6)		 								// Reservado	041	046	006	X	Preencher com espaços
cRegHead += gravaData(dDataBase, .F., 8) 							// Data do Pedido	047	054	008	9	Formato AAAAMMDD
cRegHead += gravaData(MV_PAR09, .F., 8)   							// Data da Liberação do Beneficio	055	062	008	9	Formato AAAAMMDD
cRegHead += padR(space(17), 17) 									// Reservado	063	079	017	X	Preencher com espaços
cRegHead += padR(substr(mv_par07,5,2),02)							// Mês de Referência	080	081	002	9	Mês de referencia do pedido
cRegHead += padR(space(19), 19) 									// Reservado		082	100	019	X	Preencher com espaços
cRegHead +=  "04"													// Tipo de Layout	101	102	002	X	Preencher com “04”
cRegHead +=  "34"													// Tipo do Cartão	103	104	002	X	33	para TAE 34	para TRE
cRegHead += padR(space(48), 48) 									// Reservado		105	152	048	X	Preencher com espaços
cRegHead += "SUP   "	 				  							// Origem	    	153	158	006	X	Preencher com “SUP”
cRegHead += cLinSeq						  							// Seqüência		159	164	006	9	Número seqüencial para cada linha do arquivo. Formato “999999”, iniciando em ex.:

GrvCsv( cNomeArq, cRegHead )

clinSeq := soma1(cLinSeq)

nTotHead :=0

while SM0->( !eof() ) .and. SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL >= MV_PAR01 .and. SM0->M0_CODFIL <= MV_PAR02 

cEnd := left(SM0->M0_ENDENT,at(",",SM0->M0_ENDENT)-1)
cNum := strzero(val(substr(SM0->M0_ENDENT,at(",",SM0->M0_ENDENT)+1,10)),5)	
//cComp := left(SM0->M0_COMPENT,at(",",SM0->M0_COMPENT)-1)
cComp := SM0->M0_COMPENT
cRegHead :=  "T"													// Tipo de Produto / Seqüência	001	001	001	X	Fixo “T”
cRegHead +=  "R"													// Produto	002	002	001	X	A = Alimentação R = Restaurante
cRegHead +=  "02"													// Fixo	003	004	002	X	Fixo “02”
cRegHead +=  "2"													// Tipo de Registro	005	005	001	X	“0”
cRegHead += padR(upper(SM0->M0_NOMECOM), 26)						// Nome da Unidade	006	031	026	X	Nome da Unidade
cRegHead += padR("R", 04)				 							// Tipo de logradouro	032	035	004	X	Tipo de logradouro (Rua, Av, etc)
cRegHead += padR(upper(cEnd), 30)			 						// Logradouro	036	065	030	X	Logradouro
cRegHead += padR(upper(cNum), 6) 									// Número	066	071	006	X	Caso sem número, informar zero(0)
cRegHead += padR(upper(cComp), 10)			 						// Complemento	072	081	010	X	Complemento
cRegHead += padR(upper(SM0->M0_CIDENT), 25) 						// Município	082	106	025	X	Município
cRegHead += padR(upper(SM0->M0_BAIRENT), 15) 						// Bairro	107	121	015	X	Bairro
cRegHead += padR(left(SM0->M0_CEPENT,5), 5) 						// CEP	122	126	005	9	CEP – apenas os 5 primeiros numeros
cRegHead += padR(upper(SM0->M0_ESTENT), 2) 							// Estado	127	128	002	X	Estado
cRegHead += padR(upper(MV_PAR08), 20)	 							// Interlocutor	129	148	020	X	Interlocutor responsável pelo recebimento do pedido na unidade
cRegHead += padR(right(SM0->M0_CEPENT,3), 3) 						// Complemento do CEP	149	151	003	9	Complemento do CEP - 3 ultimos numeros
cRegHead += padR(SPACE(7), 7) 										// Reservado	152	158	007	X	Preencher com espaços em “	“
cRegHead += cLinSeq						  							// Seqüência	159	164	006	9	Número seqüencial para cada linha do arquivo. Formato “999999”, iniciando em ex.:

GrvCsv( cNomeArq, cRegHead )

clinSeq := soma1(cLinSeq)


	_cAlias	:= GetNextAlias()
	
	
	_cQuery	:= " SELECT * "
	_cQuery	+= " FROM " + RetSqlName("SRA") "
	_cQuery	+= " WHERE RA_FILIAL = '" + SM0->M0_CODFIL + "' "
	_cQuery	+= " AND RA_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	_cQuery	+= " AND RA_SITFOLH <> 'D' "
	TcQuery _cQuery New Alias &(_cAlias)
	

	//tabela que contem o VR por mes para pegar a qtd de dias e o valor
	SR0->( dbSetOrder(1) ) 
			
	while (_cAlias)->( !eof() )
		
		IncProc()
		
		cRegUsu	:= "TR023"																//001 001 N S Tipo de registro. Fixo 5 = Usuário 
		
		dBSelectarea("SR0")
		dBSetOrder(1)
		IF DbSeek((_cAlias)->RA_FILIAL+(_cAlias)->RA_MAT)

			do while !eof() .and. SR0->R0_ROTEIR<>'VRF' .AND. R0_FILIAL+R0_MAT+R0_PERIOD=((_cAlias)->RA_FILIAL+(_cAlias)->RA_MAT+mv_par07)
				skip
				loop
			enddo

			cMat := strzero(val((_cAlias)->RA_MAT),12)
			cRegUsu	+= PadR(alltrim(ftAcento((_cAlias)->RA_CC)), 26 )					// Departamento	006	031	026	X	Código do departamento // Centro de Custos		   	
			cRegUsu	+= PadR(alltrim(ftAcento(cMat)), 12 )								// Identificação	032	043	012	9	Identificação do funcionário na Ticket.
			cRegUsu	+= gravaData(stod((_cAlias)->RA_NASC), .F., 5)						// Data de Nascimento	044	051	008	9	Formato “ DDMMAAAA”
			cRegUsu += padR(space(18), 18)		 										// 052 069 C S Reservado
			cRegUsu	+= padR(upper(SM0->M0_NOMECOM), 26) 								// Nome da Unidade	070	095	026	X	Nome da Unidade
			cRegUsu	+= padR("00101", 5)				 									// Fixo	096	100	005	9	Preencher com “00101”

			nValVR	:= SR0->R0_VALCAL * 100
			cRegUsu	+= padL( nValVR, 09, "0")		 									// Valor	101	109	009	9	Valor do benefício com 7 inteiros e 2 casas decimais
			nTotVal += nValVR

			cRegUsu	+= "R"																// Produto	110	110	001	X	“A” para Alimentação “R” para Restaurante
			cRegUsu	+= "E"																// Fixo	111	111	001	X	“E” = Eletrônico			
			cRegUsu	+= PadR(alltrim(ftAcento((_cAlias)->RA_NOME)), 30)					// Nome do Funcionário	112	141	030	X	Nome do funcionário/ ** Vide observação
			cRegUsu	+= PadR(" ", 6)														// Reservado	142	147	006	X	Preencher com espaços
			cRegUsu	+= padL((_cAlias)->RA_CIC, 11, "0")									//CPF	148	158	011	9	Número (Ex. 12345678911)
			cRegUsu += cLinSeq						  									// Seqüência	159	164	006	9	Número seqüencial para cada linha do arquivo. Formato “999999”, iniciando em ex.:

		   	GrvCsv( cNomeArq, cRegUsu )
		   	GravaDet(_cAlias)  //Grava informações para planilha Excel
		   	
		   	nTotSeq5++
		   	
		   	clinSeq := soma1(cLinSeq)

			   																					//cRegUsu	+= //401 050 C N Códigos de Retorno (de zero a 10 códigos, separados por ; ). Não deve ser preenchido pelo cliente.
		endif
		
		(_cAlias)->( dbSkip() )
		
	end
 
 	(_cAlias)->( dbCloseArea() )
 	
	SM0->( dbSkip() )
	nTotHead ++
end

// Trailler do Pedido
cRegTra := "TR029" 					// Tipo de Produto / Seqüência	001	001	001	X	Fixo “T” 
									// Produto	002	002	001	X	A = Alimentação R = Restaurante 
									// Fixo	003	004	002	X	Fixo “02” 
									// Tipo de Registro	005	005	001	X	“9”
cRegTra += PadL(nTotSeq5-1, 8, "0")	// Total de Funcionários	006	013	008	9	Quantidade de registros tipo 3 (Funcionários)
cRegTra += PadL(nTotVal, 14, "0")	// Valor Total	014	027	014	9	Somatória do valor do pedido, com 2 casas decimais
cRegTra += PadR(" ", 131)			// Reservado	028	158	131	X	Preencher com espaços
cRegTra += cLinSeq					// Seqüência	159	164	006	9	Número seqüencial para cada linha do arquivo. Formato “999999”, iniciando em ex.:


GrvCsv( cNomeArq, cRegTra )

clinSeq := soma1(cLinSeq)

// Trailler do Arquivo
cRegTra := "LSUP9" 					
cRegTra += PadL(nTotHead, 8, "0")	// Total de Funcionários	006	013	008	9	Quantidade de registros tipo 3 (Funcionários)
cRegTra += PadL(1, 8, "0")	// Valor Total	014	027	014	9	Somatória do valor do pedido, com 2 casas decimais
cRegTra += PadR(" ", 277)			// Reservado	028	158	131	X	Preencher com espaços


GrvCsv( cNomeArq, cRegTra )

	
oReport := RptDef("ALTVR")
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
PutSx1( cPerg, "06", "Contrato?"	  , "Contrato?"		,"Contrato?"	 ,"mv_ch6","C",11,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",,,,"")

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
AADD(aCampos,{ "DIASPRO" , "N",12,2})
AADD(aCampos,{ "DPROPIN" , "N",12,2})
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

oReport := TReport():New(cNome,"Vale Refeição",cNome,{|oReport| ReportPrint(oReport)},"Vale Refeição")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"VR Alelo", {"TRB"}, , .F., .T.)

TRCell():New(oSection1,"MAT"		,"TRB","Matrícula"    ,"@!",10)
TRCell():New(oSection1,"NOME"		,"TRB","Funcionário"  ,"@!",40)
TRCell():New(oSection1,"VALOR"		,"TRB","Valor","@E 999,999,999.99",15)
TRCell():New(oSection1,"DIASPRO"	,"TRB","Dias para Calculo","@E 999,999,999.99",15)
TRCell():New(oSection1,"DPROPIN"	,"TRB","Dias Proporcionais","@E 999,999,999.99",15)
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
		oSection1:Cell("DIASPRO"):SetValue(TRB->DIASPRO)
		oSection1:Cell("DPROPIN"):SetValue(TRB->DPROPIN)
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
trb->DIASPRO := SR0->R0_DIASPRO // Nº de Dias para Calculo 
trb->DPROPIN := SR0->R0_DPROPIN //= Dias Proporcionais Inform
trb->DataNasc := right((_cAlias)->RA_NASC,2)+"/"+substr((_cAlias)->RA_NASC,5,2)+"/"+left((_cAlias)->RA_NASC,4)
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
trb->ADMISS := right((_cAlias)->RA_ADMISSA,2)+"/"+substr((_cAlias)->RA_ADMISSA,5,2)+"/"+left((_cAlias)->RA_ADMISSA,4)
MsUnLock()			
Return
