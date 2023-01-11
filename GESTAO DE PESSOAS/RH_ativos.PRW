#INCLUDE "RWMAKE.Ch"
#include "TOPCONN.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RH_BCOHR01�Autor  �Luiz Eduardo        � Data �  09/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rela��o de Ativos e Demitidos                              ���
�������������������������������������������������������������������������͹��
���Uso       � RH                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION RH_ATIVOS()

Private nHdl		:= 0
Private i			:= 0
Private cFile		:= ""
Private oExcel	:= Nil  
Private aAreaSM0	:= SM0->(GetArea())
Private aCabec	:= {} 
Private cLinhaCSV	:= ""

//�������������������������������������������������Ŀ
//� Define variaveis                                                                                        �
//���������������������������������������������������
cDesc1  := "Este relatorio tem o objetivo de imprimir "
cDesc2  := "o relat�rio com os funcion�rios ativos "
cDesc3  := "e demitidos "
cString := 'SRA'
cTamanho := 'P'
Titulo  := 'Rela��o de Ativos e Demitidos'
wnRel   := 'RH_ATIVDEM'
limite    :=80
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para montar Get.                        �
//����������������������������������������������������������������

Private aReturn         := { "Zebrado", 1,"Administracao", 2, 2, 1,"",1 }
Private cPerg           := "RELATV1"

//��������������������������������������������������������������Ŀ
//� Janela Principal                                             �
//����������������������������������������������������������������
cTitulo:="Relat�rio de Ativos "
cText1:="Neste relatorio sera impresso a etiqueta de contrato de trabalho"

Pergunte(cPerg,.t.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
//wnRel := SetPrint(cString, wnRel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,, .F.,cTamanho)

nView    := 1

//If nLastKey == 27
//	Set Filter To
//	Return Nil
//Endif

//SetDefault(aReturn, cString)

//If nLastKey == 27
//	Set Filter To
//	Return Nil
//Endif

RptStatus({|lEnd| BHImp(@lEnd, wnRel,cTamanho, Titulo)}, Titulo)

Set Filter To

Return(Nil)

/*
������������������������������������������������������������
������������������������������������������������������������
������������������������������������������������������������
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
Private nEspLarg := GetMv("MV_ETCEL") // espa�amento entre etiquetas na largura (em pixels)
Private nEspAlt  := GetMv("MV_ETCEA") // espa�amento entre etiquetas na altura  (em pixels)
Private nVertMax := GetMv("MV_ETCQL") // Qtde vertical de etiquetas por p�gina
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

cQuery := "SELECT 'T4F' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, CTT.CTT_DESC01,	SRA.RA_SUP, SRA.RA_NOMSUP, SRA.RA_CIC, SRA.RA_PIS, SRA.RA_RG, SRA.RA_RGORG, SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,"
cQuery += "      SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_UFCP, SRA.RA_ZONASEC, SRA.RA_ENDEREC, SRA.RA_NUMENDE, SRA.RA_COMPLEM,	SRA.RA_BAIRRO, SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP,"
cQuery += "      SRA.RA_TELEFON, SRA.RA_PAI, SRA.RA_MAE, SRA.RA_SEXO, SRA.RA_ESTCIVI, SRA.RA_NATURAL, SRA.RA_NACIONA, SRA.RA_DEPIR, SRA.RA_DEPSF, SRA.RA_NASC, SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_BCDEPSA, SRA.RA_CTDEPSA, SRA.RA_CTDPFGT, SRA.RA_SITFOLH, SRA.RA_HRSMES, SRA.RA_HRSEMAN, SRA.RA_TNOTRAB, SRA.RA_CATFUNC, SRA.RA_SALARIO,"
cQuery += "      SRA.RA_AFASFGT, SRA.RA_CRACHA, SRA.RA_EMAIL, SRA.RA_RACACOR,  SRA.RA_VCTOEXP, SRA.RA_VCTEXP2, SRA.RA_DTCPEXP, SRA.RA_DTRGEXP, SRA.RA_ITEM, ZZB.ZZB_DESCRI, SRJ.RJ_DESC"
cQuery += " FROM SRA080 SRA "
          
cQuery += " LEFT JOIN ZZB080 ZZB "
cQuery += " ON ZZB_LOCAL = RA_LOCAL "
cQuery += " AND   ZZB.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN SRJ080 SRJ "
cQuery += " ON RJ_FUNCAO = RA_CODFUNC "
cQuery += " AND SRJ.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN CTT080 CTT "
cQuery += " ON CTT_CUSTO = RA_CC "
cQuery += " AND CTT.D_E_L_E_T_ <> '*' "

cQuery += " WHERE SRA.RA_SITFOLH <> 'D' "
//cQuery += " AND   SRA.RA_CC   >= '"+MV_PAR01+"' AND SRA.RA_CC   <= '"+MV_PAR02+"' "
//cQuery += " AND   SRA.RA_MAT  >= '"+MV_PAR03+"' AND SRA.RA_MAT  <= '"+MV_PAR04+"' "
//cQuery += " AND   SRA.RA_NOME >= '"+MV_PAR05+"' AND SRA.RA_NOME <= '"+MV_PAR06+"' "
cQuery += " AND   SRA.D_E_L_E_T_ <> '*' "
     
If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
nTotReg := reccount()
DBGOTOP()
_cArqTrb1:= CriaTrab(nil,.f.)
Copy To &(_cArqTrb1+OrdBagExt())
DbCloseArea()
If Select("trb1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
Endif

DbUseArea( .T.,__LocalDriver,_cArqTrb1+OrdBagExt(), "TRB1",.T., .T. )

cQuery := "SELECT 'METRO' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, CTT.CTT_DESC01,	SRA.RA_SUP, SRA.RA_NOMSUP, SRA.RA_CIC, SRA.RA_PIS, SRA.RA_RG, SRA.RA_RGORG, SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,"
cQuery += "      SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_UFCP, SRA.RA_ZONASEC, SRA.RA_ENDEREC, SRA.RA_NUMENDE, SRA.RA_COMPLEM,	SRA.RA_BAIRRO, SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP,"
cQuery += "      SRA.RA_TELEFON, SRA.RA_PAI, SRA.RA_MAE, SRA.RA_SEXO, SRA.RA_ESTCIVI, SRA.RA_NATURAL, SRA.RA_NACIONA, SRA.RA_DEPIR, SRA.RA_DEPSF, SRA.RA_NASC, SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_BCDEPSA, SRA.RA_CTDEPSA, SRA.RA_CTDPFGT, SRA.RA_SITFOLH, SRA.RA_HRSMES, SRA.RA_HRSEMAN, SRA.RA_TNOTRAB, SRA.RA_CATFUNC, SRA.RA_SALARIO,"
cQuery += "      SRA.RA_AFASFGT, SRA.RA_CRACHA, SRA.RA_EMAIL, SRA.RA_RACACOR,  SRA.RA_VCTOEXP, SRA.RA_VCTEXP2, SRA.RA_DTCPEXP, SRA.RA_DTRGEXP, SRA.RA_ITEM, ZZB.ZZB_DESCRI, SRJ.RJ_DESC"
cQuery += " FROM SRA090 SRA "

cQuery += " LEFT JOIN ZZB080 ZZB "
cQuery += " ON ZZB_LOCAL = RA_LOCAL "
cQuery += " AND   ZZB.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN SRJ080 SRJ "
cQuery += " ON RJ_FUNCAO = RA_CODFUNC "
cQuery += " AND SRJ.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN CTT080 CTT "
cQuery += " ON CTT_CUSTO = RA_CC "
cQuery += " AND CTT.D_E_L_E_T_ <> '*' "
     
cQuery += " WHERE SRA.RA_SITFOLH <> 'D' "
//cQuery += " AND   SRA.RA_CC   >= '"+MV_PAR01+"' AND SRA.RA_CC   <= '"+MV_PAR02+"' "
//cQuery += " AND   SRA.RA_MAT  >= '"+MV_PAR03+"' AND SRA.RA_MAT  <= '"+MV_PAR04+"' "
//cQuery += " AND   SRA.RA_NOME >= '"+MV_PAR05+"' AND SRA.RA_NOME <= '"+MV_PAR06+"' "
cQuery += " AND   SRA.D_E_L_E_T_ <> '*' "

If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
nTotReg := reccount()
DBGOTOP()
_cArqTrb:= CriaTrab(nil,.f.)
Copy To &(_cArqTrb+OrdBagExt())
DbCloseArea()
Select Trb1
append from &(_cArqTrb+OrdBagExt())


cQuery := "SELECT 'VICAR' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, CTT.CTT_DESC01,	SRA.RA_SUP, SRA.RA_NOMSUP, SRA.RA_CIC, SRA.RA_PIS, SRA.RA_RG, SRA.RA_RGORG, SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,"
cQuery += "      SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_UFCP, SRA.RA_ZONASEC, SRA.RA_ENDEREC, SRA.RA_NUMENDE, SRA.RA_COMPLEM,	SRA.RA_BAIRRO, SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP,"
cQuery += "      SRA.RA_TELEFON, SRA.RA_PAI, SRA.RA_MAE, SRA.RA_SEXO, SRA.RA_ESTCIVI, SRA.RA_NATURAL, SRA.RA_NACIONA, SRA.RA_DEPIR, SRA.RA_DEPSF, SRA.RA_NASC, SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_BCDEPSA, SRA.RA_CTDEPSA, SRA.RA_CTDPFGT, SRA.RA_SITFOLH, SRA.RA_HRSMES, SRA.RA_HRSEMAN, SRA.RA_TNOTRAB, SRA.RA_CATFUNC, SRA.RA_SALARIO,"
cQuery += "      SRA.RA_AFASFGT, SRA.RA_CRACHA, SRA.RA_EMAIL, SRA.RA_RACACOR,  SRA.RA_VCTOEXP, SRA.RA_VCTEXP2, SRA.RA_DTCPEXP, SRA.RA_DTRGEXP, SRA.RA_ITEM, ZZB.ZZB_DESCRI, SRJ.RJ_DESC"
cQuery += " FROM SRA160 SRA "

cQuery += " LEFT JOIN ZZB080 ZZB "
cQuery += " ON ZZB_LOCAL = RA_LOCAL "
cQuery += " AND   ZZB.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN SRJ080 SRJ "
cQuery += " ON RJ_FUNCAO = RA_CODFUNC "
cQuery += " AND SRJ.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN CTT080 CTT "
cQuery += " ON CTT_CUSTO = RA_CC "
cQuery += " AND CTT.D_E_L_E_T_ <> '*' "
     
cQuery += " WHERE SRA.RA_SITFOLH <> 'D' "
//cQuery += " AND   SRA.RA_CC   >= '"+MV_PAR01+"' AND SRA.RA_CC   <= '"+MV_PAR02+"' "
//cQuery += " AND   SRA.RA_MAT  >= '"+MV_PAR03+"' AND SRA.RA_MAT  <= '"+MV_PAR04+"' "
//cQuery += " AND   SRA.RA_NOME >= '"+MV_PAR05+"' AND SRA.RA_NOME <= '"+MV_PAR06+"' "
cQuery += " AND   SRA.D_E_L_E_T_ <> '*' "

If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
nTotReg := reccount()
DBGOTOP()
_cArqTrb:= CriaTrab(nil,.f.)
Copy To &(_cArqTrb+OrdBagExt())
DbCloseArea()
Select Trb1
append from &(_cArqTrb+OrdBagExt())

cQuery := "SELECT 'AEB' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, CTT.CTT_DESC01,	SRA.RA_SUP, SRA.RA_NOMSUP, SRA.RA_CIC, SRA.RA_PIS, SRA.RA_RG, SRA.RA_RGORG, SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,"
cQuery += "      SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_UFCP, SRA.RA_ZONASEC, SRA.RA_ENDEREC, SRA.RA_NUMENDE, SRA.RA_COMPLEM,	SRA.RA_BAIRRO, SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP,"
cQuery += "      SRA.RA_TELEFON, SRA.RA_PAI, SRA.RA_MAE, SRA.RA_SEXO, SRA.RA_ESTCIVI, SRA.RA_NATURAL, SRA.RA_NACIONA, SRA.RA_DEPIR, SRA.RA_DEPSF, SRA.RA_NASC, SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_BCDEPSA, SRA.RA_CTDEPSA, SRA.RA_CTDPFGT, SRA.RA_SITFOLH, SRA.RA_HRSMES, SRA.RA_HRSEMAN, SRA.RA_TNOTRAB, SRA.RA_CATFUNC, SRA.RA_SALARIO,"
cQuery += "      SRA.RA_AFASFGT, SRA.RA_CRACHA, SRA.RA_EMAIL, SRA.RA_RACACOR,  SRA.RA_VCTOEXP, SRA.RA_VCTEXP2, SRA.RA_DTCPEXP, SRA.RA_DTRGEXP, SRA.RA_ITEM, ZZB.ZZB_DESCRI, SRJ.RJ_DESC"
cQuery += " FROM SRA200 SRA "

cQuery += " LEFT JOIN ZZB080 ZZB "
cQuery += " ON ZZB_LOCAL = RA_LOCAL "
cQuery += " AND   ZZB.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN SRJ080 SRJ "
cQuery += " ON RJ_FUNCAO = RA_CODFUNC "
cQuery += " AND SRJ.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN CTT080 CTT "
cQuery += " ON CTT_CUSTO = RA_CC "
cQuery += " AND CTT.D_E_L_E_T_ <> '*' "
     
cQuery += " WHERE SRA.RA_SITFOLH <> 'D' "
//cQuery += " AND   SRA.RA_CC   >= '"+MV_PAR01+"' AND SRA.RA_CC   <= '"+MV_PAR02+"' "
//cQuery += " AND   SRA.RA_MAT  >= '"+MV_PAR03+"' AND SRA.RA_MAT  <= '"+MV_PAR04+"' "
//cQuery += " AND   SRA.RA_NOME >= '"+MV_PAR05+"' AND SRA.RA_NOME <= '"+MV_PAR06+"' "
cQuery += " AND   SRA.D_E_L_E_T_ <> '*' "

If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
nTotReg := reccount()
DBGOTOP()
_cArqTrb:= CriaTrab(nil,.f.)
Copy To &(_cArqTrb+OrdBagExt())
DbCloseArea()
Select Trb1
append from &(_cArqTrb+OrdBagExt())

cQuery := "SELECT 'AREA MKT' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT, SRA.RA_NOME, SRA.RA_CC, CTT.CTT_DESC01,	SRA.RA_SUP, SRA.RA_NOMSUP, SRA.RA_CIC, SRA.RA_PIS, SRA.RA_RG, SRA.RA_RGORG, SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,"
cQuery += "      SRA.RA_NUMCP, SRA.RA_SERCP, SRA.RA_UFCP, SRA.RA_ZONASEC, SRA.RA_ENDEREC, SRA.RA_NUMENDE, SRA.RA_COMPLEM,	SRA.RA_BAIRRO, SRA.RA_MUNICIP, SRA.RA_ESTADO, SRA.RA_CEP,"
cQuery += "      SRA.RA_TELEFON, SRA.RA_PAI, SRA.RA_MAE, SRA.RA_SEXO, SRA.RA_ESTCIVI, SRA.RA_NATURAL, SRA.RA_NACIONA, SRA.RA_DEPIR, SRA.RA_DEPSF, SRA.RA_NASC, SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_BCDEPSA, SRA.RA_CTDEPSA, SRA.RA_CTDPFGT, SRA.RA_SITFOLH, SRA.RA_HRSMES, SRA.RA_HRSEMAN, SRA.RA_TNOTRAB, SRA.RA_CATFUNC, SRA.RA_SALARIO,"
cQuery += "      SRA.RA_AFASFGT, SRA.RA_CRACHA, SRA.RA_EMAIL, SRA.RA_RACACOR,  SRA.RA_VCTOEXP, SRA.RA_VCTEXP2, SRA.RA_DTCPEXP, SRA.RA_DTRGEXP, SRA.RA_ITEM, ZZB.ZZB_DESCRI, SRJ.RJ_DESC"
cQuery += " FROM SRA250 SRA "

cQuery += " LEFT JOIN ZZB080 ZZB "
cQuery += " ON ZZB_LOCAL = RA_LOCAL "
cQuery += " AND   ZZB.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN SRJ080 SRJ "
cQuery += " ON RJ_FUNCAO = RA_CODFUNC "
cQuery += " AND SRJ.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN CTT080 CTT "
cQuery += " ON CTT_CUSTO = RA_CC "
cQuery += " AND CTT.D_E_L_E_T_ <> '*' "
     
cQuery += " WHERE SRA.RA_SITFOLH <> 'D' "
//cQuery += " AND   SRA.RA_CC   >= '"+MV_PAR01+"' AND SRA.RA_CC   <= '"+MV_PAR02+"' "
//cQuery += " AND   SRA.RA_MAT  >= '"+MV_PAR03+"' AND SRA.RA_MAT  <= '"+MV_PAR04+"' "
//cQuery += " AND   SRA.RA_NOME >= '"+MV_PAR05+"' AND SRA.RA_NOME <= '"+MV_PAR06+"' "
cQuery += " AND   SRA.D_E_L_E_T_ <> '*' "

If Select("trb") > 0
	DbSelectArea("TRB")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TRB"
DbSelectArea("TRB")
nTotReg := reccount()
DBGOTOP()
_cArqTrb:= CriaTrab(nil,.f.)
Copy To &(_cArqTrb+OrdBagExt())

DbCloseArea()
Select Trb1
append from &(_cArqTrb+OrdBagExt())
DbCloseArea()
DbUseArea( .T.,__LocalDriver,_cArqTrb1+OrdBagExt(), "TRB",.T., .T. )

dbGotop()

GeraExcel()  

// Novo Excel
Static Function GeraExcel()

Local oReport := nil
oReport := RptDef(cPerg)
oReport:PrintDialog()

Return

Static Function RptDef(cNome)
Local oReport := Nil
Local oSection1:= Nil
Local oBreak
Local oFunction

oReport := TReport():New(cNome,"Rela��o de Funcion�rios Ativos",cNome,{|oReport| ReportPrint(oReport)},"PedidosXmargem")
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

oSection1 := TRSection():New(oReport,"Funcion�rios Ativos", {"TRB"}, , .F., .T.)

TRCell():New(oSection1,'EMPRESA','TRB','EMPRESA'  ,'@!',20)
TRCell():New(oSection1,'RA_FILIAL','TRB','RA_FILIAL'  ,'@!',20)
TRCell():New(oSection1,'RA_MAT','TRB','RA_MAT'  ,'@!',20)
TRCell():New(oSection1,'RA_NOME','TRB','RA_NOME'  ,'@!',20)
TRCell():New(oSection1,'RA_CC','TRB','RA_CC'  ,'@!',20)
TRCell():New(oSection1,'CTT_DESC01','TRB','CTT_DESC01'  ,'@!',20)
TRCell():New(oSection1,'RA_NOMSUP','TRB','RA_NOMSUP'  ,'@!',20)
TRCell():New(oSection1,'RA_CIC','TRB','RA_CIC'  ,'@!',20)
TRCell():New(oSection1,'RA_PIS','TRB','RA_PIS'  ,'@!',20)
TRCell():New(oSection1,'RA_RG','TRB','RA_RG'  ,'@!',20)
TRCell():New(oSection1,'RA_DTRGEXP','TRB','RA_DTRGEXP'  ,'@!',20)
TRCell():New(oSection1,'RA_RGORG','TRB','RA_RGORG'  ,'@!',20)
TRCell():New(oSection1,'RA_HABILIT','TRB','RA_HABILIT'  ,'@!',20)
TRCell():New(oSection1,'RA_RESERVI','TRB','RA_RESERVI'  ,'@!',20)
TRCell():New(oSection1,'RA_TITULOE','TRB','RA_TITULOE'  ,'@!',20)
TRCell():New(oSection1,'RA_ZONASEC','TRB','RA_ZONASEC'  ,'@!',20)
TRCell():New(oSection1,'RA_NUMCP','TRB','RA_NUMCP'  ,'@!',20)
TRCell():New(oSection1,'RA_SERCP','TRB','RA_SERCP'  ,'@!',20)
TRCell():New(oSection1,'RA_UFCP','TRB','RA_UFCP'  ,'@!',20)
TRCell():New(oSection1,'RA_DTCPEXP','TRB','RA_DTCPEXP'  ,'@!',20)
TRCell():New(oSection1,'RA_ENDEREC','TRB','RA_ENDEREC'  ,'@!',20)
TRCell():New(oSection1,'RA_NUMENDE','TRB','RA_NUMENDE'  ,'@!',20)
TRCell():New(oSection1,'RA_COMPLEM','TRB','RA_COMPLEM'  ,'@!',20)
TRCell():New(oSection1,'RA_BAIRRO','TRB','RA_BAIRRO'  ,'@!',20)
TRCell():New(oSection1,'RA_MUNICIP','TRB','RA_MUNICIP'  ,'@!',20)
TRCell():New(oSection1,'RA_ESTADO','TRB','RA_ESTADO'  ,'@!',20)
TRCell():New(oSection1,'RA_CEP','TRB','RA_CEP'  ,'@!',20)
TRCell():New(oSection1,'RA_TELEFON','TRB','RA_TELEFON'  ,'@!',20)
TRCell():New(oSection1,'RA_PAI','TRB','RA_PAI'  ,'@!',20)
TRCell():New(oSection1,'RA_MAE','TRB','RA_MAE'  ,'@!',20)
TRCell():New(oSection1,'RA_SEXO','TRB','RA_SEXO'  ,'@!',20)
TRCell():New(oSection1,'RA_ESTCIVI','TRB','RA_ESTCIVI'  ,'@!',20)
TRCell():New(oSection1,'RA_NATURAL','TRB','RA_NATURAL'  ,'@!',20)
TRCell():New(oSection1,'RA_NACIONA','TRB','RA_NACIONA'  ,'@!',20)
TRCell():New(oSection1,'RA_DEPIR','TRB','RA_DEPIR'  ,'@!',20)
TRCell():New(oSection1,'RA_DEPSF','TRB','RA_DEPSF'  ,'@!',20)
TRCell():New(oSection1,'RA_NASC','TRB','RA_NASC'  ,'@!',20)
TRCell():New(oSection1,'RA_ADMISSA','TRB','RA_ADMISSA'  ,'@!',20)
TRCell():New(oSection1,'RA_BCDEPSA','TRB','RA_BCDEPSA'  ,'@!',20)
TRCell():New(oSection1,'RA_CTDEPSA','TRB','RA_CTDEPSA'  ,'@!',20)
TRCell():New(oSection1,'RA_CTDPFGT','TRB','RA_CTDPFGT'  ,'@!',20)
TRCell():New(oSection1,'RA_SITFOLH','TRB','RA_SITFOLH'  ,'@!',20)
TRCell():New(oSection1,'RA_HRSMES','TRB','RA_HRSMES'  ,'@!',20)
TRCell():New(oSection1,'RA_HRSEMAN','TRB','RA_HRSEMAN'  ,'@!',20)
TRCell():New(oSection1,'RA_TNOTRAB','TRB','RA_TNOTRAB'  ,'@!',20)
TRCell():New(oSection1,'RA_CATFUNC','TRB','RA_CATFUNC'  ,'@!',20)
TRCell():New(oSection1,'RA_SALARIO','TRB','RA_SALARIO'  ,'@!',20)
TRCell():New(oSection1,'RA_AFASFGT','TRB','RA_AFASFGT'  ,'@!',20)
TRCell():New(oSection1,'RA_CRACHA','TRB','RA_CRACHA'  ,'@!',20)
TRCell():New(oSection1,'RA_EMAIL','TRB','RA_EMAIL'  ,'@!',20)
TRCell():New(oSection1,'RA_RACACOR','TRB','RA_RACACOR'  ,'@!',20)
TRCell():New(oSection1,'RA_VCTOEXP','TRB','RA_VCTOEXP'  ,'@!',20)
TRCell():New(oSection1,'RA_VCTEXP2','TRB','RA_VCTEXP2'  ,'@!',20)
TRCell():New(oSection1,'RA_ITEM','TRB','RA_ITEM'  ,'@!',20)
TRCell():New(oSection1,'ZZB_DESCRI','TRB','ZZB_DESCRI'  ,'@!',20)
TRCell():New(oSection1,'RJ_DESC','TRB','RJ_DESC'  ,'@!',20)

TRFunction():New(oSection1:Cell("RA_NOME"),NIL,"COUNT",,,,,.F.,.T.)

oReport:SetTotalInLine(.F.)

//quebra  por se��o
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
	
	//inicializo a primeira se��o
	oSection1:Init()
	
	oReport:IncMeter()
	
	dbSelectArea("TRB")
	
	IncProc("Imprimindo ")
	
	Do while !eof()
		oReport:IncMeter()
		
		//imprimo a primeira se��o

oSection1:Cell('EMPRESA'):SetValue(TRB->EMPRESA)
oSection1:Cell('RA_FILIAL'):SetValue(TRB->RA_FILIAL)
oSection1:Cell('RA_MAT'):SetValue(TRB->RA_MAT)
oSection1:Cell('RA_NOME'):SetValue(TRB->RA_NOME)
oSection1:Cell('RA_CC'):SetValue(TRB->RA_CC)
oSection1:Cell('CTT_DESC01'):SetValue(TRB->CTT_DESC01)
oSection1:Cell('RA_NOMSUP'):SetValue(TRB->RA_NOMSUP)
oSection1:Cell('RA_CIC'):SetValue(TRB->RA_CIC)
oSection1:Cell('RA_PIS'):SetValue(TRB->RA_PIS)
oSection1:Cell('RA_RG'):SetValue(TRB->RA_RG)
oSection1:Cell('RA_DTRGEXP'):SetValue(TRB->RA_DTRGEXP)
oSection1:Cell('RA_RGORG'):SetValue(TRB->RA_RGORG)
oSection1:Cell('RA_HABILIT'):SetValue(TRB->RA_HABILIT)
oSection1:Cell('RA_RESERVI'):SetValue(TRB->RA_RESERVI)
oSection1:Cell('RA_TITULOE'):SetValue(TRB->RA_TITULOE)
oSection1:Cell('RA_ZONASEC'):SetValue(TRB->RA_ZONASEC)
oSection1:Cell('RA_NUMCP'):SetValue(TRB->RA_NUMCP)
oSection1:Cell('RA_SERCP'):SetValue(TRB->RA_SERCP)
oSection1:Cell('RA_UFCP'):SetValue(TRB->RA_UFCP)
oSection1:Cell('RA_DTCPEXP'):SetValue(TRB->RA_DTCPEXP)
oSection1:Cell('RA_ENDEREC'):SetValue(TRB->RA_ENDEREC)
oSection1:Cell('RA_NUMENDE'):SetValue(TRB->RA_NUMENDE)
oSection1:Cell('RA_COMPLEM'):SetValue(TRB->RA_COMPLEM)
oSection1:Cell('RA_BAIRRO'):SetValue(TRB->RA_BAIRRO)
oSection1:Cell('RA_MUNICIP'):SetValue(TRB->RA_MUNICIP)
oSection1:Cell('RA_ESTADO'):SetValue(TRB->RA_ESTADO)
oSection1:Cell('RA_CEP'):SetValue(TRB->RA_CEP)
oSection1:Cell('RA_TELEFON'):SetValue(TRB->RA_TELEFON)
oSection1:Cell('RA_PAI'):SetValue(TRB->RA_PAI)
oSection1:Cell('RA_MAE'):SetValue(TRB->RA_MAE)
oSection1:Cell('RA_SEXO'):SetValue(TRB->RA_SEXO)
oSection1:Cell('RA_ESTCIVI'):SetValue(TRB->RA_ESTCIVI)
oSection1:Cell('RA_NATURAL'):SetValue(TRB->RA_NATURAL)
oSection1:Cell('RA_NACIONA'):SetValue(TRB->RA_NACIONA)
oSection1:Cell('RA_DEPIR'):SetValue(TRB->RA_DEPIR)
oSection1:Cell('RA_DEPSF'):SetValue(TRB->RA_DEPSF)
oSection1:Cell('RA_NASC'):SetValue(TRB->RA_NASC)
oSection1:Cell('RA_ADMISSA'):SetValue(TRB->RA_ADMISSA)
oSection1:Cell('RA_BCDEPSA'):SetValue(TRB->RA_BCDEPSA)
oSection1:Cell('RA_CTDEPSA'):SetValue(TRB->RA_CTDEPSA)
oSection1:Cell('RA_CTDPFGT'):SetValue(TRB->RA_CTDPFGT)
oSection1:Cell('RA_SITFOLH'):SetValue(TRB->RA_SITFOLH)
oSection1:Cell('RA_HRSMES'):SetValue(TRB->RA_HRSMES)
oSection1:Cell('RA_HRSEMAN'):SetValue(TRB->RA_HRSEMAN)
oSection1:Cell('RA_TNOTRAB'):SetValue(TRB->RA_TNOTRAB)
oSection1:Cell('RA_CATFUNC'):SetValue(TRB->RA_CATFUNC)
oSection1:Cell('RA_SALARIO'):SetValue(TRB->RA_SALARIO)
oSection1:Cell('RA_AFASFGT'):SetValue(TRB->RA_AFASFGT)
oSection1:Cell('RA_CRACHA'):SetValue(TRB->RA_CRACHA)
oSection1:Cell('RA_EMAIL'):SetValue(TRB->RA_EMAIL)
oSection1:Cell('RA_RACACOR'):SetValue(TRB->RA_RACACOR)
oSection1:Cell('RA_VCTOEXP'):SetValue(TRB->RA_VCTOEXP)
oSection1:Cell('RA_VCTEXP2'):SetValue(TRB->RA_VCTEXP2)
oSection1:Cell('RA_ITEM'):SetValue(TRB->RA_ITEM)
oSection1:Cell('ZZB_DESCRI'):SetValue(TRB->ZZB_DESCRI)
oSection1:Cell('RJ_DESC'):SetValue(TRB->RJ_DESC)

		
		oSection1:Printline()
		TRB->(dbSkip())
	Enddo
	
	//finalizo a primeira se��o
Enddo
//oSection1:Finish()

oSection1:Finish()

Return
