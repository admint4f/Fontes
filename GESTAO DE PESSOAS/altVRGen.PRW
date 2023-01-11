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
user function altVrGen()
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

//Header Tipo = 0
cRegHead := "0"							  							//001 001 N S Tipo de registro. Fixo 0 = HEADER 
cRegHead += gravaData(dDataBase, .F., 5) 							//002 008 N S Data do pedido (DDMMAAAA) 
cRegHead += "A001"						 							//010 004 C S Canal de Entrada (A001 ) 
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

GrvCsv( cNomeArq, cRegHead )

clinSeq := soma1(cLinSeq)
	
while SM0->( !eof() ) .and. SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL >= MV_PAR01 .and. SM0->M0_CODFIL <= MV_PAR02 
	
	cRegFilial := "1"													//001 001 N S Tipo de registro. Fixo 1 = Filial 
	cRegFilial += left(SM0->M0_CGC, 8)									//002 008 N S(*1) Número Raiz do CNPJ da Filial (Deve ser igual à Raiz do CNPJ informado no registro do tipo 0). 
	cRegFilial += substr(SM0->M0_CGC, 9, 4)								//010 004 N S(*1) Número da filial do CNPJ 
	cRegFilial += right(SM0->M0_CGC, 2)									//014 002 N S(*1) Dígito Verificador do CNPJ 
	cRegFilial += padL("", 10, "0")										//016 010 N S(*2) Código de Pessoa Jurídica Visa Vale da Filial 
	cRegFilial += padL(upper(SM0->M0_FILIAL), 35)						//026 035 C N Nome da Filial 
	cRegFilial += padL("11", 4, "0")									//061 004 N N DDD dos Interlocutores de Entrega (obrigatório, se o número de telefone presente). 
	cRegFilial += padR("LUCELIA VEGI", 35)								//065 035 C S Nome do Primeiro Interlocutor de Entrega 
	cRegFilial += padR("DEPTO RH", 40)									//100 040 C N Endereço de Localização Interna do Primeiro Interlocutor 
	cRegFilial += padL("45052624", 12, "0")								//140 012 N N Telefone do Primeiro Interlocutor de Entrega 
	cRegFilial += padL("",  6, "0")										//152 006 N N Ramal do Primeiro Interlocutor de Entrega 
	cRegFilial += padR(" ", 35)											//158 035 C N Nome do Segundo Interlocutor de Entrega 
	cRegFilial += padR(" ", 40)											//193 040 C N Endereço de Localização Interna do Segundo Interlocutor 
	cRegFilial += padL("",  12, "0")									//233 012 N N Telefone do Segundo Interlocutor de Entrega 
	cRegFilial += padL("",  6, "0")										//245 006 N N Ramal do Segundo Interlocutor de Entrega 
	cRegFilial += padR(" ", 35)											//251 035 C N Nome do Terceiro Interlocutor de Entrega 
	cRegFilial += padR(" ", 40)											//286 040 C N Endereço de Localização Interna do Terceiro Interlocutor 
	cRegFilial += padL("", 12, "0")										//326 012 N N Telefone do Terceiro Interlocutor de Entrega 
	cRegFilial += padL("",  6, "0")										//338 006 N N Ramal do Terceiro Interlocutor de Entrega
	cRegFilial += padR(" ", 20)											//344 020 C S(*2) Código da Filial / Posto de Trabalho usado pelo Cliente 
	cRegFilial += padR(" ", 31)											//364 031 C S Espaços em Branco.
	cRegFilial += clinSeq												//395 006 N S Número seqüencial do registro. Numeração seqüencial e contínua do registro de arquivo. 
	//cRegFilial += 													//401 050 C N Códigos de Retorno (de zero a 10 códigos, separados por ;). Não deve ser
	
	GrvCsv( cNomeArq, cRegFilial )
	
	clinSeq := soma1(cLinSeq)
	
	/*
	cRegArea := "2" //001 001 N S Tipo de registro. Fixo 2 = Área Funcional 
	cRegArea += //002 020 C N Nome da Diretoria 
	cRegArea += //022 020 C N Nome do Departamento 
	cRegArea += //042 020 C S Código da Área Funcional, atribuído pelo Cliente. 
	cRegArea += //062 020 C S Nome da Área Funcional, para entrega, atribuído pelo Cliente. 
	cRegArea += //082 040 C N Localização Interna da Área Funcional 
	cRegArea += //122 004 N N DDD dos Interlocutores de Entrega (obrigatório, se o número de telefone presente) 
	cRegArea += //126 035 C S Nome do Primeiro Interlocutor de Entrega 
	cRegArea += //161 012 N N Telefone do Primeiro Interlocutor de Entrega 
	cRegArea += //173 006 N N Ramal do Primeiro Interlocutor de Entrega 
	cRegArea += //179 035 C N Nome do Segundo Interlocutor de Entrega 
	cRegArea += //214 012 N N Telefone do Segundo Interlocutor de Entrega 
	cRegArea += //226 006 N N Ramal do Segundo Interlocutor de Entrega 
	cRegArea += //232 163 C S Espaços em Branco. 
	cRegArea += //395 006 N S Número seqüencial do registro. Numeração seqüencial e contínua do registro de arquivo.
	cRegArea += //401 050 C N Códigos de Retorno (de zero a 10 códigos, separados por ;). Não deve ser preenchido pelo cliente
	*/

	_cAlias	:= GetNextAlias()
	
	
	_cQuery	:= " SELECT * "
	_cQuery	+= " FROM " + RetSqlName("SRA") "
	_cQuery	+= " WHERE RA_FILIAL = '" + SM0->M0_CODFIL + "' "
	_cQuery	+= " AND RA_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	_cQuery	+= " AND RA_SITFOLH <> 'D' "
	TcQuery _cQuery New Alias &(_cAlias)
	
	// Thiago Moraes - retirado filtro da tabela SRX e RA_VALEREF - 22/11/2019

	/*_cQuery	:= "SELECT SUBSTR(RX_COD, 13, 3) REF, TRIM(SUBSTR(RX_TXT, 21, 12)) VALOR, RA.* "
	_cQuery	+= " FROM " + RetSqlName("SRA") + " RA "
	_cQuery	+= " JOIN " + RetSqlName("SRX") + "  RX "
	_cQuery	+= " ON TRIM(SUBSTR(RX_COD, 13, 3)) = TRIM(RA_VALEREF)"
	_cQuery	+= " AND RX.D_E_L_E_T_ = ' '"
	_cQuery	+= " WHERE RA_FILIAL = '" + SM0->M0_CODFIL + "' "
	_cQuery	+= " AND RA_MAT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	_cQuery	+= " AND RA.D_E_L_E_T_ = ' ' "
	_cQuery	+= " AND RA_SITFOLH != 'D' "
	TcQuery _cQuery New Alias &(_cAlias)
	*/
	

	//tabela que contem o VR por mes para pegar a qtd de dias e o valor
	SR0->( dbSetOrder(1) ) 
			
	while (_cAlias)->( !eof() )
		
		IncProc()
		
		cRegUsu	:= "5"																//001 001 N S Tipo de registro. Fixo 5 = Usuário 
		
		dBSelectarea("SR0")
		dBSetOrder(1)
//		IF DbSeek((_cAlias)->RA_FILIAL+(_cAlias)->RA_MAT+mv_par07+"01"+mv_par07)
		IF DbSeek((_cAlias)->RA_FILIAL+(_cAlias)->RA_MAT)

			do while !eof() .and. SR0->R0_ROTEIR<>'VRF' .AND. R0_FILIAL+R0_MAT+R0_PERIOD=((_cAlias)->RA_FILIAL+(_cAlias)->RA_MAT+mv_par07)
				skip
				loop
			enddo

			nValVR	:= SR0->R0_VALCAL * 100
			cRegUsu	+= padL( nValVR, 11, "0")						   					//002 011 N N Valor mensal do benefício (inclui 2 casas decimais), sem pontos ou virgulas 
			
			nTotVal += nValVR
			
			cRegUsu	+= " "											  					//013 001 C N Espaço Reservado 
			
			cRegUsu	+= padR((_cAlias)->RA_MAT, 13)											//014 013 C N Matrícula do Funcionário 
			cRegUsu	+= padR(" ", 54)								 					//027 054 C S Espaço reservado 
			cRegUsu	+= gravaData(stod((_cAlias)->RA_NASC), .F., 5)							//081 008 N S Data de Nascimento (DDMMAAAA) 
			cRegUsu	+= padL((_cAlias)->RA_CIC, 11, "0")										//089 011 N S Número do CPF 
			cRegUsu	+= aTpDoc[1]														//100 001 C N Tipo do Doc. ID 
			cRegUsu	+= padR(strTran(strTran(alltrim((_cAlias)->RA_RG), "-", ""),".",""), 13)	//101 013 C N Número do Doc. ID 
			cRegUsu	+= padR(upper(alltrim((_cAlias)->RA_RGORG)), 20)							//114 020 C N Órgão Emissor do Doc. ID 
			cRegUsu	+= padR(" ", 6) 													//134 006 C N Sigla do Estado Emissor do Doc.ID 
			cRegUsu	+= PadL(alltrim((_cAlias)->RA_PIS), 15, "0")								//140 015 N N Número do PIS 
			cRegUsu	+= PadR((_cAlias)->RA_SEXO, 1)											//155 001 C N Cód. Sexo 
			
			if (_cAlias)->RA_ESTCIVI == "S"			//solteiro
				cEstCiv := "1"	
			elseif (_cAlias)->RA_ESTCIVI == "C"		//casado
				cEstCiv := "2"
			elseif (_cAlias)->RA_ESTCIVI == "V"		//viuva
				cEstCiv := "3"
			elseif (_cAlias)->RA_ESTCIVI $ "D|Q"		//Divorciado/Separado
				cEstCiv := "4"
			elseif (_cAlias)->RA_ESTCIVI $ "M|O "	//Uniao Estavel, Outros
				cEstCiv := "5"
			endif
			
			cRegUsu	+= PadR(cEstCiv, 1)													//156 001 N N Cód. Estado Civil 
			cRegUsu	+= PadR(alltrim(upper(ftAcento((_cAlias)->RA_ENDEREC))), 35)		   		//157 035 C N Tipo e Nome do Logradouro da Residência 
			cRegUsu	+= PadR(alltrim(upper(ftAcento((_cAlias)->RA_COMPLEM))), 10)				//192 010 C N Complemento do Endereço da Residência 
			cRegUsu	+= PadL(alltrim((_cAlias)->RA_NUMENDE), 5, "0")							//202 005 N N Número do Logradouro da Residência 
			cRegUsu	+= PadL(alltrim((_cAlias)->RA_CEP), 8, "0")								//207 008 N N CEP Residencial 
			cRegUsu	+= PadR(alltrim(upper(ftAcento((_cAlias)->RA_MUNICIP))), 28)				//215 028 C N Município da Residência 
			cRegUsu	+= PadR(alltrim(upper(ftAcento((_cAlias)->RA_BAIRRO))), 30)				//243 030 C N Bairro da Residência 
			cRegUsu	+= PadR(alltrim((_cAlias)->RA_ESTADO), 2)								//273 002 C N Sigla do Estado da Residência 
			cRegUsu	+= PadR(alltrim(upper(ftAcento((_cAlias)->RA_MAE))), 35)					//275 035 C N Nome da Mãe 
			cRegUsu	+= "R"																//310 001 C N Cód. Opção Ender. Correspondência: R = Residencial C = Comercial 
			cRegUsu	+= PadR("", 4, "0") 												//311 004 N N Cód. DDD Comercial (obrigatório, se o número de telefone presente) 
			cRegUsu	+= PadR("", 8, "0") 												//315 008 N N Num. Telefone Comercial 323 004 N N Num . Ramal Comercial 
			cRegUsu	+= PadR("", 4, "0") 												//323 004 N N Num. Ramal Comercial                                                 
			cRegUsu	+= PadR("", 4, "0") 												//327 004 N N Cód. DDD Residencial (obrigatório, se o número de telefone presente) 
			cRegUsu	+= PadR("", 8, "0") 												//331 008 N N Num. Telefone Residencial 
			cRegUsu	+= PadR(" ", 1)														//339 001 C N Cód. Escolaridade 
			cRegUsu	+= gravaData(stod((_cAlias)->RA_ADMISSA), .F., 5) 						//340 008 N N Data de Admissão (DDMMAAAA) 
			cRegUsu	+= " "																//348 001 C N Espaço reservado 
			cRegUsu	+= PadR(alltrim(ftAcento((_cAlias)->RA_NOME)), 40)						//349 040 C S Nome do Usuário 
			cRegUsu	+= PadR(" ", 6)														//389 006 C S Espaço Reservado. 
			cRegUsu	+= clinSeq 															//395 006 N S Número seqüencial do registro. Numeração seqüencial e contínua do registro no arquivo.
		   	
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
end

cRegTra := "9" 						//001 001 N S Tipo de Registro Fixo 9 = Trailler
cRegTra += PadL(nTotSeq5-1, 6, "0")	//002 006 N S Quantidade total de registros de Usuários do Pedido (Registro 5) 
cRegTra += PadL(nTotVal, 15, "0")	//008 015 N S Valor total do Pedido (Somatória da Posição 002 do Registro 5)
cRegTra += PadR(" ", 372)			//023 372 C S Espaços em Branco 
cRegTra += clinSeq					//395 006 N S Número Seqüencial do Registro

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

oReport := TReport():New(cNome,"Faturamento com Margem",cNome,{|oReport| ReportPrint(oReport)},"FaturamentoXmargem")
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
