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
user function altVtGen()
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

FormBatch( "Geração de VT - Alelo", aSays, aButtons )

if nOpca == 1
	processa({|| geraArquivo() },"Gerando arquivo ALELO")
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

CriaArqtmp()

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

//Registro de Cabeçalho
cRegCab := "0"									//001-001 N OBR IDENTIFICADOR DO REGISTRO = "0"
cRegCab += gravaData(dDataBase, .F., 5)			//002-009 N OBR DATA DO ARQUIVO (DDMMAAAA)
cRegCab += SM0->M0_CGC							//010-023 N OBR CNPJ DA EMPRESA PRINCIPAL
cRegCab += padR(SM0->M0_NOME, 50)				//024-073 C OBR RAZÃO SOCIAL
cRegCab += space(157)                           //074-230 C 174 BRANCOS
cRegCab += "04"									//231-232 N 002 VERSÃO - "04"
cRegCab += "00"									//233-234 N 002 RELEASE - "00"
cRegCab += cLinSeq								//235-240 N 006 SEQUÊNCIA DO REGISTRO - "000001"

GrvCsv( cNomeArq, cRegCab )

SR0->( dbSetOrder(1) )
SRA->( dbSetOrder(1) )
SRN->( dbSetOrder(1) )

SM0->( dbSetOrder(1) )
SM0->( dbSeek(cEmpAnt) )
while SM0->( !eof() ) .and. SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL >= MV_PAR01 .and. SM0->M0_CODFIL <= MV_PAR02 
    
	if SM0->M0_CODIGO = "08" .AND. SM0->M0_CODFIL $ "03*04*05"
		SM0->( dbSkip() )
		loop
	endif
	
    cLinSeq := soma1(cLinSeq)
    cSeqEnd := soma1(cSeqEnd)
    
    aEnd := trataEndereco(SM0->M0_ENDCOB)
    
	cRegEnd	:= "1"							//001-001 001 N IDENTIFICADOR DO REGISTRO = "1"
	cRegEnd += SM0->M0_CGC					//002-015 014 N CNPJ
	cRegEnd += cSeqEnd						//016-018 003 N ENDERECO TRABALHO/ENTREGA (SEQÜÊNCIA) - ASK
	cRegEnd += padR(aEnd[1], 50)			//019-068 050 A LOGRADOURO
	cRegEnd += padL(aEnd[2], 15, "0")		//069-083 015 A NÚMERO
	cRegEnd += padR(SM0->M0_COMPCOB, 20)	//084-103 020 A COMPLEMENTO
	cRegEnd += padR(SM0->M0_BAIRCOB, 35)	//104-138 035 ALFANUMERICO BAIRRO
	cRegEnd += padL(SM0->M0_CEPCOB, 8) 		//139-146 008 NUMÉRICO CEP
	cRegEnd += padR(SM0->M0_CIDCOB, 30)		//147-176 030 ALFANUMERICO CIDADE
	cRegEnd += SM0->M0_ESTCOB				//177-178 002 ALFANUMERICO ESTADO
	cRegEnd += padR("SORAIA ABRAO", 45)		//179-223 045 ALFANUMERICO RESPONSÁVEL PELO RECEBIMENTO
	cRegEnd += Space(11)					//224-234 011 ALFANUMERICO BRANCOS
	cRegEnd += cLinSeq						//235-240 006 NUMERICO SEQUÊNCIA DO REGISTRO  
    
	GrvCsv( cNomeArq, cRegEnd )

	nTotEnd++    

	dbSelectArea("SR0")
	dbSetOrder(1)
	dbSeek(AllTrim(SM0->M0_CODFIL)) 
//	SR0->( dbSeek(xFilial("SR0")+AllTrim(SM0->M0_CODFIL)) ) //SR0->( dbSeek(SM0->M0_CODFIL) )
	while !eof() //SR0->( !eof() ) .and. AllTrim(SR0->R0_FILIAL) = AllTrim(SM0->M0_CODFIL)
	    
	    IncProc("Filial: " + SM0->M0_CODFIL + " Func.: " + SR0->R0_MAT)
	    
		dbSelectArea("SRA")
		dbSetOrder(1)
	    dbSeek(trim(SM0->M0_CODFIL)+SR0->R0_MAT)
		dbSelectArea("SR0")
	    
	    //if SR0->R0_QDIACAL > 0 .and. SRA->( dbSeek(SM0->M0_CODFIL+SR0->R0_MAT) ) .and. SRA->RA_SITFOLH != "D" .and. SR0->R0_TPVALE == "0"
	    if SR0->R0_QDIACAL > 0  .and. SRA->RA_SITFOLH != "D" .and. SR0->R0_TPVALE == "0" .and. trim(SM0->M0_CODFIL)+SR0->R0_MAT = SRA->(RA_FILIAL+RA_MAT)
	        
	    	if cMatAnt != SR0->R0_MAT
	    	    
	    		if !empty(aArq)
	    			
	    			aArq := aSort(aArq,,,{|x,y| x[1] < y[1]})
	    			
	    			for i := 1 to len(aArq)
	    		   		GrvCsv( cNomeArq, aArq[i,2] )		
	    			next i
	    			
	    			aArq := {}
	    			
	    		endif
	    	
	    	
				cLinSeq := soma1(cLinSeq)
			    
				//Registro de Usuários
				cRegUsu := "2"																		  							//001-001 001 NUMERICO IDENTIFICADOR DO REGISTRO = "2"
				cRegUsu += padL(SM0->M0_CGC, 14, "0")																			//002-015 014 NUMERICO CNPJ
				cRegUsu += cSeqEnd			   										 											//016-018 003 NUMERICO ENDERECO DE TRABALHO/ENTREGA (REGISTRO ENDERECOS)
				cRegUsu += padR(SRA->RA_MAT, 15)												 								//019-033 015 ALFANUMERICO MATRICULA
				cRegUsu += padR(alltrim(SRA->RA_NOME), 50)															 			//034-083 050 ALFANUMERICO NOME COMPLETO
				cRegUsu += padL(SRA->RA_CIC, 11, "0")																   			//084-094 011 NUMERICO CPF
				cRegUsu += padR(left(strTran(strTran(alltrim(SRA->RA_RG), "-", ""),".",""), len(alltrim(SRA->RA_RG)) - 1 ), 9)//095-103 009 ALFANUMERICO NÚMERO DO RG
				cRegUsu += padR(right(strTran(strTran(alltrim(SRA->RA_RG), "-", ""),".",""), 1 ), 2)	   	 					//104-105 002 ALFANUMERICO DÍGITO DO RG
				cRegUsu += padR(SRA->RA_NATURAL, 2)															  					//106-107 002 ALFANUMERICO ESTADO EMISS. RG							ask ver na sra
				cRegUsu += gravaData(SRA->RA_NASC, .F., 5)												   						//108-115 008 NUMERICO DATA NASCIMENTO (DDMMAAAA)
				cRegUsu += padR(" ", 45)																			   			//SRA->RA_CODDEP//116-160 045 ALFANUMERICO DEPARTAMENTO
				cRegUsu += padR(posicione("SQ3", 1, xFilial("SQ3")+SRA->RA_CARGO, "Q3_DESCSUM"), 45) 				   			//161-205 045 ALFANUMERICO CARGO
				cRegUsu += padL((SR0->R0_QDIACAL/SR0->R0_QDIAINF), 3, "0")			  								 			//206-208 003 NUMERICO QUANTIDADE DE DIAS TRABALHADOS
				cRegUsu += PadR(" ", 26)			   																   			//209-234 026 ALFANUMERICO BRANCOS
				cRegUsu += cLinSeq																   					   			//235-240 006 NUMERICO SEQUÊNCIA DO REGISTRO        
			    
			    //GrvCsv( cNomeArq, cRegUsu )
				Gravadet("SRA")
				dbSelectArea("SR0")
			    aAdd(aArq, {"2"+SR0->R0_FILIAL+SRA->RA_MAT, cRegUsu})  
				nTotUsu++
			
			endif				
			
			//Registro de Beneficios
			SRN->( dbSeek(xFilial("SRN")+SR0->R0_CODIGO) )
			cLinSeq := soma1(cLinSeq)
			
			cRegBen	:= "3"																		//001-001 001 NUMERICO SIM IDENTIFICADOR DO REGISTRO = "3"
			cRegBen	+= padL(SM0->M0_CGC, 14, "0")  												//002-015 014 NUMERICO SIM CNPJ 
			cRegBen	+= padR(SRA->RA_MAT, 15)													//016-030 015 ALFANUMERICO SIM MATRICULA
			cRegBen	+= padL(SRN->RN_ITEMPED, 6, "0")											//031-036 006 NUMERICO SIM CÓDIGO BENEFÍCIO
			cRegBen	+= padR(SRN->RN_DESC, 50)													//037-086 050 ALFANUMERICO SIM DESCRIÇÃO DO BENEFÍCIO
			cRegBen	+= padL(alltrim(str(SRN->RN_VUNIATU*100)), 12, "0")							//087-098 012 NUMERICO NÃO VALOR DO ITEM
			cRegBen	+= padL(alltrim(str(SR0->R0_QDIAINF)), 3, "0")								//099-101 003 NUMERICO SIM QUANTIDADE (POR DIA)
			cRegBen	+= padR(" ", 25)															//102-126 025 ALFANUMERICO NÃO NÚMERO CARTÃO
			cRegBen	+= padR(" ", 108)															//127-234 108 ALFANUMERICO SIM BRANCOS
			cRegBen	+= cLinSeq																	//235-240 006 NUMERICO SIM SEQUÊNCIA DO REGISTRO
	        
			//GrvCsv( cNomeArq, cRegBen )
			aAdd(aArq, {"3"+SR0->R0_FILIAL+SRA->RA_MAT, cRegBen})  
			nTotBen++	
	        
			if cMatAnt != SR0->R0_MAT
			
				cLinSeq := soma1(cLinSeq)
				
				//Registro Residencia
				cRegRes := "4"																		//001-001 001 NUMERICO SIM IDENTIFICADOR DO REGISTRO = "4"
				cRegRes += padL(SM0->M0_CGC, 14, "0")												//002-015 014 NUMERICO SIM CNPJ 
				cRegRes += padR(SRA->RA_MAT, 15)													//016-030 015 ALFANUMERICO SIM MATRICULA
				cRegRes += padR(upper(SRA->RA_ENDEREC), 50)												//031-080 050 ALFANUMERICO SIM LOGRADOURO
				cRegRes += padR(" ", 15)															//081-095 015 ALFANUMERICO SIM NÚMERO
				cRegRes += padR(" ", 20)															//096-115 020 ALFANUMERICO NÃO COMPLEMENTO
				cRegRes += padR(upper(SRA->RA_BAIRRO), 35)													//116-150 035 ALFANUMERICO NÃO BAIRRO
				cRegRes += padL(alltrim(SRA->RA_CEP), 8, "0")		  								//151-158 008 NUMÉRICO SIM CEP
				cRegRes += padR(SRA->RA_MUNICIP, 30)												//159-188 030 ALFANUMERICO NÃO CIDADE
				cRegRes += padR(SRA->RA_ESTADO, 2)													//189-190 002 ALFANUMERICO SIM ESTADO
				cRegRes += "N"																		//191-191 001 ALFANUMERICO SIM SOLICITAR SUGESTÃO DE ROTA – CONTEÚDO “N” ou “S”
				cRegRes += padL("0", 12)															//192-203 012 NUMÉRICO NÃO VALOR TOTAL DE VALES-TRANSPORTE (P/ CALC. REDUÇÃO)
				cRegRes += padR(" ", 31)															//204-234 031 ALFANUMERICO SIM BRANCOS
				cRegRes += cLinSeq																	//235-240 006 NUMERICO SIM SEQUÊNCIA DO REGISTRO
			        
				//GrvCsv( cNomeArq, cRegRes )
				aAdd(aArq, {"4"+SR0->R0_FILIAL+SRA->RA_MAT, cRegRes}) 

				nTotRes++
			
				cLinSeq := soma1(cLinSeq)
				
				//Registro de Dados Adicionais
				cRegDAd	:= "5"																		//001-001 001 NUMERICO SIM IDENTIFICADOR DO REGISTRO = "5"
				cRegDAd	+= padL(SM0->M0_CGC, 14, "0")												//002-015 014 NUMERICO SIM CNPJ 
				cRegDAd	+= padR(SRA->RA_MAT, 15)													//016-030 015 ALFANUMERICO SIM MATRICULA
				cRegDAd	+= padR(SRA->RA_MAE, 50)													//031-080 050 ALFANUMERICO SIM NOME DA MÃE
				cRegDAd	+= padR(" ", 154)															//081-234 154 ALFANUMERICO SIM BRANCOS 
				cRegDAd	+= cLinSeq																	//235-240 006 NUMERICO SIM SEQUÊNCIA DO REGISTRO
			
				//GrvCsv( cNomeArq, cRegDAd )
				
				aAdd(aArq, {"5"+SR0->R0_FILIAL+SRA->RA_MAT, cRegDAd}) 
				
				nTotDAd++
	            
            endif
			
			cMatAnt := SR0->R0_MAT

		endif
			    
		SR0->( dbSkip() )
		
	end

	SM0->( dbSkip() )
end

if !empty(aArq)
	aArq := aSort(aArq,,,{|x,y| x[1] < y[1]})
    
    for i := 1 to len(aArq)
    	GrvCsv( cNomeArq, aArq[i,2] )		
    next i
    		
    aArq := {}
endif

cLinSeq := soma1(cLinSeq)

//Registro de Rodape
cRegRod := "9"																		//001-001 001 NUMERICO SIM IDENTIFICADOR DO REGISTRO = "9"
cRegRod += padL(alltrim(str(nTotEnd)), 6, "0")										//002-007 006 NUMERICO SIM QTDE REGISTROS - TIPO 1
cRegRod += padL(alltrim(str(nTotUsu)), 6, "0")										//008-013 006 NUMERICO SIM QTDE REGISTROS - TIPO 2
cRegRod += padL(alltrim(str(nTotBen)), 6, "0")										//014-019 006 NUMERICO SIM QTDE REGISTROS - TIPO 3
cRegRod += padL(alltrim(str(nTotRes)), 6, "0")										//020-025 006 NUMERICO SIM QTDE REGISTROS - TIPO 4
cRegRod += padL(alltrim(str(nTotDAd)), 6, "0")										//026-031 006 NUMERICO SIM QTDE REGISTROS - TIPO 5
cRegRod += padR(" ", 203)															//032-234 203 ALFANUMERICO SIM BRANCOS 
cRegRod += cLinSeq																	//235-240 006 NUMERICO SIM SEQUÊNCIA DO REGISTRO

GrvCsv( cNomeArq, cRegRod )
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

oReport := TReport():New(cNome,"Faturamento com Margem",cNome,{|oReport| ReportPrint(oReport)},"FaturamentoXmargem")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)
														
						  
	  

oSection1 := TRSection():New(oReport,"VT Alelo", {"TRB"}, , .F., .T.)
					  
	 

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

