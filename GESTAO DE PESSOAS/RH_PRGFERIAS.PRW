#INCLUDE "RWMAKE.Ch"
#include "TOPCONN.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RH_BCOHR01ºAutor  ³Luiz Eduardp     º Data ³  02/12/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relação de programação de férias                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RH_PRGFERIAS()

Private nHdl		:= 0
Private i			:= 0
Private cFile		:= ""
Private oExcel	:= Nil  
Private aAreaSM0	:= SM0->(GetArea())
Private aCabec	:= {} 
Private cLinhaCSV	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variaveis                                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesc1  := "Este relatorio tem o objetivo de imprimir a"
cDesc2  := "o relatório com os funcionários que passaram "
cDesc3  := "na relação de férias "
cString := 'SRF'
cTamanho := 'P'
Titulo  := 'Relação de Programacao de Ferias'
wnRel   := 'RH_PRGFERIAS'
limite    :=80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para montar Get.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aReturn         := { "Zebrado", 1,"Administracao", 2, 2, 1,"",1 }
Private cPerg           := "GPR320"
//Private cPerg           := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Relatório de Programação de Férias "
cText1:="Neste relatorio sera impresso a etiqueta de contrato de trabalho"

Pergunte(cPerg,.f.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnRel := SetPrint(cString, wnRel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,, .F.,cTamanho)

nView    := 1

If nLastKey == 27
	Set Filter To
	Return Nil
Endif

SetDefault(aReturn, cString)

If nLastKey == 27
	Set Filter To
	Return Nil
Endif

RptStatus({|lEnd| BHImp(@lEnd, wnRel,cTamanho, Titulo)}, Titulo)

Set Filter To

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BHImp(lEnd, wnRel, cTamanho, Titulo)

Local lImpAug :=.T.
Local cTxtFoot := Space(10)
Local cNomAudLid
Local cNomeAud

Private nLin :=01
Private nREG := 0
Private m_pag   := 1
Private cCabec1 := ""
Private cCabec2 :=  ""
Private nPag    := 1
Private lPagPrint := .T.
Private lInicial := .F.
Private nEspLarg := GetMv("MV_ETCEL") // espaçamento entre etiquetas na largura (em pixels)
Private nEspAlt  := GetMv("MV_ETCEA") // espaçamento entre etiquetas na altura  (em pixels)
Private nVertMax := GetMv("MV_ETCQL") // Qtde vertical de etiquetas por página
Private nVertical:= 1
Private nHorizMax:= mv_par13
Private nHorizont:= 1
Private cEmpEtiq := SM0->M0_CODIGO


oFont1    := TFont():New( "Arial",,08,,.F.,,,,,.f. )   //08
oFont2    := TFont():New( "Arial",,10,,.t.,,,,,.f. )
oFont3    := TFont():New( "Arial",,12,,.t.,,,,.T.,.f. )

If !lInicial
	lInicial := .T.
	oprn:=TMSPrinter():New( Titulo )
Endif

DBSELECTAREA("SM0")
nRecM0 := recno()

cQuery := "SELECT 'T4F' EMPRESA,SRF.RF_FILIAL,SRF.RF_MAT,SRA.RA_NOME,SRA.RA_CC, CTT.CTT_DESC01,SRA.RA_SUP,SRA.RA_NOMSUP,"
cQuery += "SRA.RA_ADMISSA,SRA.RA_SITFOLH,SRA.RA_CATFUNC,SRA.RA_LOCAL,ZZB.ZZB_DESCRI,SRJ.RJ_DESC,RA_NASC,SRF.RF_DATABAS, "
cQuery += "SRF.RF_DFERANT,SRF.RF_DFERVAT,SRF.RF_DFERAAT,SRF.RF_IVENPEN "

cQuery += "FROM SRF080 SRF "

cQuery += "LEFT JOIN SRA080 SRA ON RA_MAT = RF_MAT AND RA_FILIAL = RF_FILIAL AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN ZZB080 ZZB ON ZZB_LOCAL = RA_LOCAL AND  ZZB.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN SRJ080 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN CTT080 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "

cQuery += "WHERE SRF.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA.RA_SITFOLH <> 'D' AND SRA.RA_DEMISSA = ' ' AND   SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "SRF.RF_DFERANT+SRF.RF_DFERVAT+SRF.RF_DFERAAT<>0 AND "
cQuery += "SRF.RF_STATUS <> '3' "

cQuery += "UNION "

cQuery += "SELECT 'METRO' EMPRESA,SRF.RF_FILIAL,SRF.RF_MAT,SRA.RA_NOME,SRA.RA_CC, CTT.CTT_DESC01,SRA.RA_SUP,SRA.RA_NOMSUP,"
cQuery += "SRA.RA_ADMISSA,SRA.RA_SITFOLH,SRA.RA_CATFUNC,SRA.RA_LOCAL,ZZB.ZZB_DESCRI,SRJ.RJ_DESC,RA_NASC,SRF.RF_DATABAS, "
cQuery += "SRF.RF_DFERANT,SRF.RF_DFERVAT,SRF.RF_DFERAAT,SRF.RF_IVENPEN "

cQuery += "FROM SRF090 SRF "

cQuery += "LEFT JOIN SRA090 SRA ON RA_MAT = RF_MAT AND RA_FILIAL = RF_FILIAL AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN ZZB080 ZZB ON ZZB_LOCAL = RA_LOCAL AND  ZZB.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN SRJ080 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN CTT080 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "

cQuery += "WHERE SRF.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA.RA_SITFOLH <> 'D' AND SRA.RA_DEMISSA = ' ' AND   SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "SRF.RF_DFERANT+SRF.RF_DFERVAT+SRF.RF_DFERAAT<>0 AND "
cQuery += "SRF.RF_STATUS <> '3' "
           
cQuery += "UNION "

cQuery += "SELECT 'AURO' EMPRESA,SRF.RF_FILIAL,SRF.RF_MAT,SRA.RA_NOME,SRA.RA_CC, CTT.CTT_DESC01,SRA.RA_SUP,SRA.RA_NOMSUP,"
cQuery += "SRA.RA_ADMISSA,SRA.RA_SITFOLH,SRA.RA_CATFUNC,SRA.RA_LOCAL,ZZB.ZZB_DESCRI,SRJ.RJ_DESC,RA_NASC,SRF.RF_DATABAS, "
cQuery += "SRF.RF_DFERANT,SRF.RF_DFERVAT,SRF.RF_DFERAAT,SRF.RF_IVENPEN "

cQuery += "FROM SRF150 SRF "

cQuery += "LEFT JOIN SRA150 SRA ON RA_MAT = RF_MAT AND RA_FILIAL = RF_FILIAL AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN ZZB080 ZZB ON ZZB_LOCAL = RA_LOCAL AND  ZZB.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN SRJ080 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN CTT080 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "

cQuery += "WHERE SRF.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA.RA_SITFOLH <> 'D' AND SRA.RA_DEMISSA = ' ' AND   SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "SRF.RF_DFERANT+SRF.RF_DFERVAT+SRF.RF_DFERAAT<>0 AND "
cQuery += "SRF.RF_STATUS <> '3' "

cQuery += "UNION "

cQuery += "SELECT 'VICAR' EMPRESA,SRF.RF_FILIAL,SRF.RF_MAT,SRA.RA_NOME,SRA.RA_CC, CTT.CTT_DESC01,SRA.RA_SUP,SRA.RA_NOMSUP,"
cQuery += "SRA.RA_ADMISSA,SRA.RA_SITFOLH,SRA.RA_CATFUNC,SRA.RA_LOCAL,ZZB.ZZB_DESCRI,SRJ.RJ_DESC,RA_NASC,SRF.RF_DATABAS, "
cQuery += "SRF.RF_DFERANT,SRF.RF_DFERVAT,SRF.RF_DFERAAT,SRF.RF_IVENPEN "

cQuery += "FROM SRF160 SRF "

cQuery += "LEFT JOIN SRA160 SRA ON RA_MAT = RF_MAT AND RA_FILIAL = RF_FILIAL AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN ZZB080 ZZB ON ZZB_LOCAL = RA_LOCAL AND  ZZB.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN SRJ080 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN CTT080 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "

cQuery += "WHERE SRF.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA.RA_SITFOLH <> 'D' AND SRA.RA_DEMISSA = ' ' AND   SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "SRF.RF_DFERANT+SRF.RF_DFERVAT+SRF.RF_DFERAAT<>0 AND "
cQuery += "SRF.RF_STATUS <> '3' "

cQuery += "UNION "

cQuery += "SELECT 'AEB' EMPRESA,SRF.RF_FILIAL,SRF.RF_MAT,SRA.RA_NOME,SRA.RA_CC, CTT.CTT_DESC01,SRA.RA_SUP,SRA.RA_NOMSUP,"
cQuery += "SRA.RA_ADMISSA,SRA.RA_SITFOLH,SRA.RA_CATFUNC,SRA.RA_LOCAL,ZZB.ZZB_DESCRI,SRJ.RJ_DESC,RA_NASC,SRF.RF_DATABAS, "
cQuery += "SRF.RF_DFERANT,SRF.RF_DFERVAT,SRF.RF_DFERAAT,SRF.RF_IVENPEN "

cQuery += "FROM SRF200 SRF "

cQuery += "LEFT JOIN SRA200 SRA ON RA_MAT = RF_MAT AND RA_FILIAL = RF_FILIAL AND  SRA.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN ZZB080 ZZB ON ZZB_LOCAL = RA_LOCAL AND  ZZB.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN SRJ080 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN CTT080 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "

cQuery += "WHERE SRF.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA.RA_SITFOLH <> 'D' AND SRA.RA_DEMISSA = ' ' AND   SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "SRF.RF_DFERANT+SRF.RF_DFERVAT+SRF.RF_DFERAAT<>0 AND "
cQuery += "SRF.RF_STATUS <> '3' "

cQuery += "UNION "

cQuery += "SELECT 'AREA MKT' EMPRESA,SRF.RF_FILIAL,SRF.RF_MAT,SRA.RA_NOME,SRA.RA_CC, CTT.CTT_DESC01,SRA.RA_SUP,SRA.RA_NOMSUP,"
cQuery += "SRA.RA_ADMISSA,SRA.RA_SITFOLH,SRA.RA_CATFUNC,SRA.RA_LOCAL,ZZB.ZZB_DESCRI,SRJ.RJ_DESC,RA_NASC,SRF.RF_DATABAS, "
cQuery += "SRF.RF_DFERANT,SRF.RF_DFERVAT,SRF.RF_DFERAAT,SRF.RF_IVENPEN "

cQuery += "FROM SRF250 SRF "

cQuery += "LEFT JOIN SRA250 SRA ON RA_MAT = RF_MAT AND RA_FILIAL = RF_FILIAL AND SRA.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN ZZB080 ZZB ON ZZB_LOCAL = RA_LOCAL AND  ZZB.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN SRJ080 SRJ ON RJ_FUNCAO = RA_CODFUNC AND SRJ.D_E_L_E_T_ <> '*' "
cQuery += "LEFT JOIN CTT080 CTT ON CTT_CUSTO = RA_CC AND CTT.D_E_L_E_T_ <> '*' "

cQuery += "WHERE SRF.D_E_L_E_T_ <> '*' AND "
cQuery += "SRA.RA_SITFOLH <> 'D' AND SRA.RA_DEMISSA = ' ' AND   SRA.D_E_L_E_T_ <> '*' AND "
cQuery += "SRF.RF_DFERANT+SRF.RF_DFERVAT+SRF.RF_DFERAAT<>0 AND "
cQuery += "SRF.RF_STATUS <> '3'"

If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif
TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
nTotReg := reccount()
DBGOTOP()
_cArqTrb:= CriaTrab(nil,.f.)
//Copy To &(_cArqTrb+OrdBagExt())
Copy To &(_cArqTrb)
//copy to \x

DbCloseArea()

aCampos := {}
AADD(aCampos,{ "EMPRESA"	, "C",30,0})
AADD(aCampos,{ "RF_FILIAL" 	, "C",30,0})
AADD(aCampos,{ "RF_MAT"   	, "C",06,0})
AADD(aCampos,{ "RA_NOME"   	, "C",50,0})
AADD(aCampos,{ "RA_CC"	   	, "C",09,0})
AADD(aCampos,{ "CTT_DESC01"	, "C",40,0})
AADD(aCampos,{ "RA_SUP"    	, "C",20,0})
AADD(aCampos,{ "RA_NOMSUP"	, "C",40,0})
AADD(aCampos,{ "RA_ADMISSA"	, "C",08,0})
AADD(aCampos,{ "ADMISSA"	, "C",10,0})
AADD(aCampos,{ "RA_SITFOLH"	, "C",05,0})
AADD(aCampos,{ "RA_CATFUNC"	, "C",08,0})
AADD(aCampos,{ "RA_LOCAL"	, "C",08,0})
AADD(aCampos,{ "ZZB_DESCRI"	, "C",40,0})
AADD(aCampos,{ "RJ_DESC"	, "C",40,0})
AADD(aCampos,{ "RF_DATABAS"	, "C",08,0})
AADD(aCampos,{ "DATABAS"	, "C",10,0})
AADD(aCampos,{ "FIMPER" 	, "C",10,0})
AADD(aCampos,{ "RF_IVENPEN"	, "C",10,0})
AADD(aCampos,{ "IVENPEN"	, "C",10,0})
AADD(aCampos,{ "RF_DFERANT"	, "N",10,0})
AADD(aCampos,{ "RF_DFERVAT"	, "N",10,0})
AADD(aCampos,{ "RF_DFERAAT" , "N",10,0})

cTemp2 := CriaTrab(nil,.f.)
dbCreate(cTemp2,aCampos)
dbUseArea( .T.,,cTemp2, "TRB", Nil, .F. )

//APPEND FROM &(_cArqTrb+OrdBagExt()) 
APPEND FROM &(_cArqTrb)

dbGotop()
Do while !eof()                                    
	if rlock()
		IF stod(rf_databas)-stod(ra_admissa)<365 .and. !empty(rf_ivenpen)
			trb->databas  := DTOC(stod(RF_IVENPEN))
			trb->fimper   := DTOC(stod(RF_IVENPEN)+365)
		Else
			trb->databas  := DTOC(stod(rf_databas))
			trb->fimper   := DTOC(stod(rf_databas)+365)
		Endif
		trb->admissa  := DTOC(stod(ra_admissa))
		trb->ivenpen  := DTOC(stod(rf_ivenpen))
	endif
	skip
Enddo
dbgotop()

  
//Cria o arquivo CSV
cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	+= "\Prog_ferias_" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
AAdd(aCabec,{'Empresa','C','EMPRESA'})
AAdd(aCabec,{'Filial','C','RF_FILIAL'})
AAdd(aCabec,{'Matricula','C','RF_MAT'})
AAdd(aCabec,{'Nome','C','RA_NOME'})
AAdd(aCabec,{'C.Custos','C','RA_CC'})
AAdd(aCabec,{'Desc.C.Custos','C','CTT_DESC01'})
AAdd(aCabec,{'Gestor','C','RA_SUP'})
AAdd(aCabec,{'Nome Gestor','C','RA_NOMSUP'})
AAdd(aCabec,{'Admissao','C','ADMISSA'})
AAdd(aCabec,{'Situação','C','RA_SITFOLH'})
AAdd(aCabec,{'Cargo','C','RA_CATFUNC'})
AAdd(aCabec,{'Local','C','RA_LOCAL'})
AAdd(aCabec,{'Desc.Local','C','ZZB_DESCRI'})
AAdd(aCabec,{'Desc.Cargo','C','RJ_DESC'})
AAdd(aCabec,{'V.Ini.Pend','C','IVENPEN'})
AAdd(aCabec,{'Data Base','C','DATABAS'})
AAdd(aCabec,{'Final Per','C','FIMPER'})
AAdd(aCabec,{'Dias Antecipados','N','RF_DFERANT'})
AAdd(aCabec,{'Dias Vencidos','N','RF_DFERVAT'})
AAdd(aCabec,{'Dias Proporc.','N','RF_DFERAAT'})

For i := 1 To Len(aCabec)
	cLinhaCSV += aCabec[i,1] + ";"
Next i                            
FWrite(nHdl,cLinhaCSV+ENTER)

ProcRegua(nTotReg)
                   
//Geracao do arquivo CSV
While TRB->(!Eof())  
	IncProc()
	cLinhaCSV := ""
	
	For i := 1 To Len(aCabec)
		If aCabec[i,2] == "C"
			cLinhaCSV += TRB->&(aCabec[i,3])+";"
		ElseIf aCabec[i,2] == "D"
			cLinhaCSV += DToC(SToD(TRB->&(aCabec[i,3])))+";"
		ElseIf aCabec[i,2] == "N"
			cLinhaCSV += Transform(TRB->&(aCabec[i,3]),"@E 999,999,999.99")+";"
		EndIf
	Next i
	
	FWrite(nHdl,cLinhaCSV+ENTER)
	TRB->(dbSkip())
EndDo   

FClose(nHdl)
oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cFile)
oExcel:SetVisible(.T.)   

dbSelectArea("TRB")
DBCLOSEAREA()

RestArea(aAreaSM0)

Return


/*
lPagPrint := .T.
oprn:StartPage() // Inicia uma nova pagina


do while !eof()
	IF !(RA_CATFUNC $ MV_PAR09)
		DBSKIP()
		LOOP
	ENDIF
	IF !(RA_SITFOLH $ MV_PAR16)
		DBSKIP()
		LOOP
	ENDIF
	
	nREG++
	
	*-----------\/----lógica da impressão
	SM0->(dbseek(cEmpEtiq+TRB->RA_FILIAL))
	
	nLP := ((nVertical-1)*nEspAlt ) + 100//170
	nCP := ((nHorizont-1)*nEspLarg) + 50
		
    cLinhaA := SM0->M0_NOMECOM
    cLinhaB := 'C.N.P.J. '+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99") 
    cLinhaC := SM0->M0_ENDCOB
    cLinhaD := ALLTRIM(SM0->M0_CIDCOB)+' - '+SM0->M0_ESTCOB   
    cLinhaE := 'Cargo: ' + ALLTRIM(RJ_DESC) + ', CBO ' + RJ_CODCBO               
    cLinhaF := 'Data Admissao: '+DTOC(StoD(RA_ADMISSA))+'   Reg.: '+RA_MAT  

    xSal := ALLTRIM(STR(RA_SALARIO*100))                 
    xSal := SUBS(xSal,1,len(xSal)-2)+','+right(xSal,2)
    xSalEx := '('+alltrim(extenso(RA_SALARIO))+')'       
    nQuebra := 0
    
    cLinhaG := 'Remuneração R$ '+xSal+' '+xSalEx+' por mes'
    
    if len(cLinhaG)>40
    	i := 39
    	do while i>1
    		if subs(cLinhaG,i,1)==' '
    			nQuebra := i
    			exit
    		endif
    		i--
    	enddo	
    	cLinhaH := subs(cLinhaG,nQuebra+1)
    	cLinhaG := left(cLinhaG,nQuebra-1)
    else
    	cLinhaH := ''
    endif		
    nQuebra := 0
    if len(cLinhaH)>40
    	i := 39
    	do while i>1
    		if subs(cLinhaH,i,1)==' '
    			nQuebra := i
    			exit
    		endif
    		i--
    	enddo	
    	cLinhaI := subs(cLinhaH,nQuebra+1)
    	cLinhaH := left(cLinhaH,nQuebra-1)
    else
    	cLinhaI := ''
    endif
    		

	oprn:Say(nLP+0100,nCP,cLinhaA,oFont1,100)//100
	oprn:Say(nLP+0170,nCP,cLinhaB,oFont1,100)//150
	oprn:Say(nLP+0240,nCP,cLinhaC,oFont1,100)
	oprn:Say(nLP+0310,nCP,cLinhaD,oFont1,100)
	oprn:Say(nLP+0380,nCP,cLinhaE,oFont1,100)
	oprn:Say(nLP+0450,nCP,cLinhaF,oFont1,100)
	oprn:Say(nLP+0520,nCP,cLinhaG,oFont1,100)
	oprn:Say(nLP+0590,nCP,cLinhaH,oFont1,100)
	oprn:Say(nLP+0660,nCP,cLinhaI,oFont1,100)

	//oprn:Say(nLP+0650,nCP+300,SM0->M0_NOMECOM,oFont1,100)	

	nHorizont++

	if nHorizont >  nHorizMax
		nHorizont := 1
		nVertical++
	endif
	if nVertical > 	nVertMax
		nVertical := 1
		oprn:EndPage()
		oprn:StartPage()
	endif
		
	*-----------/\----lógica da impressão
	
	
	
	dbselectarea("TRB")
	dbskip()
enddo







//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Set device to Screen
IF nREG <= 0
	Msginfo("Nao ha registro validos para Relatorio")
	dbSelectArea("TRB")
	DBCLOSEAREA()
	RETURN
ENDIF
dbSelectArea("TRB")
DBCLOSEAREA()
IF nView == 1
	oprn:Preview()  // Visualiza antes de imprimir
Else
	oprn:Print() // Imprime direto na impressora default Protheus
Endif



MS_FLUSH()

DBSELECTAREA("SM0")
dbgoto(nRecM0)

Return(nil)
