#INCLUDE "RWMAKE.Ch"
#include "TOPCONN.ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RH_BCOHR01ºAutor  ³Luiz Eduardo        º Data ³  09/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relação de Ativos e Demitidos                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RH                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION RH_DEMITIDOS()

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
cDesc2  := "o relatório com os funcionários demitidos "
cDesc3  := " "
cString := 'SRA'
cTamanho := 'P'
Titulo  := 'Relação de Ativos e Demitidos'
wnRel   := 'RH_DEMITIDOS'
limite    :=80
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para montar Get.                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private aReturn         := { "Zebrado", 1,"Administracao", 2, 2, 1,"",1 }
Private cPerg           := "RELDEM"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Janela Principal                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo:="Relatório de Demitidos "
cText1:="Neste relatorio sera impresso a etiqueta de contrato de trabalho"

Pergunte(cPerg,.t.)

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
Private nHorizMax:= 2
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

cQuery := "SELECT 'T4F' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT,	    SRA.RA_NOME,	SRA.RA_CC,      CTT.CTT_DESC01,	SRA.RA_SUP,	    SRA.RA_NOMSUP,	SRA.RA_CIC,	    SRA.RA_PIS,	    SRA.RA_RG,	    SRA.RA_NUMCP,  "
cQuery += "      SRA.RA_SERCP,  SRA.RA_UFCP,	SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,	SRA.RA_ZONASEC,	SRA.RA_ENDEREC,	SRA.RA_COMPLEM,	SRA.RA_BAIRRO,	SRA.RA_MUNICIP,	SRA.RA_ESTADO,	SRA.RA_CEP,	   "
cQuery += "      SRA.RA_TELEFON,SRA.RA_PAI,	    SRA.RA_MAE,	    SRA.RA_SEXO,	SRA.RA_ESTCIVI,	SRA.RA_NATURAL,	SRA.RA_NACIONA,	SRA.RA_ANOCHEG,	SRA.RA_DEPIR,	SRA.RA_DEPSF,	SRA.RA_NASC,	SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_OPCAO,	SRA.RA_DEMISSA,	SRA.RA_VCTOEXP,	SRA.RA_EXAMEDI,	SRA.RA_BCDEPSA,	SRA.RA_CTDEPSA,	SRA.RA_BCDPFGT,	SRA.RA_CTDPFGT,	SRA.RA_SITFOLH ,SRA.RA_HRSMES,  SRA.RA_HRSEMAN, "
cQuery += "      SRA.RA_CHAPA,	SRA.RA_TNOTRAB,	SRA.RA_CODFUNC,	SRA.RA_CBO,	    SRA.RA_PGCTSIN,	SRA.RA_SINDICA,	SRA.RA_ASMEDIC,	SRA.RA_DPASSME,	SRA.RA_ADTPOSE,	SRA.RA_CESTAB,	SRA.RA_VALEREF,	SRA.RA_SEGUROV,"
cQuery += "      SRA.RA_PENSALI,SRA.RA_FAIXA,	SRA.RA_PERCADT,	SRA.RA_CATFUNC,	SRA.RA_TIPOPGT,	SRA.RA_SALARIO,	SRA.RA_ANTEAUM,	SRA.RA_BASEINS,	SRA.RA_INSSOUT,	SRA.RA_PERICUL,	SRA.RA_INSMIN,	SRA.RA_INSMED, "
cQuery += "      SRA.RA_INSMAX,	SRA.RA_TIPOADM,	SRA.RA_AFASFGT,	SRA.RA_VIEMRAI,	SRA.RA_GRINRAI,	SRA.RA_RESCRAI,	SRA.RA_MESTRAB,	SRA.RA_MESESAN,	SRA.RA_TIPRES,	SRA.RA_AVPREVI,	SRA.RA_HOMOLOG,	SRA.RA_MEDIASE, "
cQuery += "      SRA.RA_ALTEND,	SRA.RA_ALTCP,	SRA.RA_ALTPIS,	SRA.RA_ALTADM,	SRA.RA_ALTOPC,	SRA.RA_ALTNOME,	SRA.RA_CODRET,	SRA.RA_CRACHA,	SRA.RA_REGRA,	SRA.RA_BITMAP,	SRA.RA_AFASTA,	SRA.RA_RETORNO,	SRA.RA_PONTOSC,	"
cQuery += "      SRA.RA_SENHA,	SRA.RA_PONTOSI,	SRA.RA_SEQTURN,	SRA.RA_REGISTR,	SRA.RA_FICHA,	SRA.RA_NIVEL,	SRA.RA_APELIDO,	SRA.RA_TPCONTR,	SRA.RA_TECNICO,	SRA.RA_EMAIL,	SRA.RA_TPRCBT,	SRA.RA_TCFMSG,	                "
cQuery += "      SRA.RA_OCORREN,SRA.RA_INSSSC,	SRA.RA_CLASSEC,	SRA.RA_PERCSAT,	SRA.RA_RACACOR,	SRA.RA_ACUMBH,	SRA.RA_BHFOL,	SRA.RA_DEFIFIS,	SRA.RA_DISTSN,	SRA.RA_RECMAIL,	SRA.RA_RECPFNC,	SRA.RA_TABELA,              "
cQuery += "      SRA.RA_TABFAIX,SRA.RA_RGORG,	SRA.RA_TABNIVE,	SRA.RA_DESCVT,	SRA.RA_PERFGTS,	SRA.RA_DTVTEST,	SRA.RA_VCTEXP2,	SRA.RA_NOMECMP,	SRA.RA_CATEG,	SRA.RA_CODIGO,	SRA.RA_TPMAIL,	SRA.RA_TPDEFFI,	            "
cQuery += "      SRA.RA_CARGO,	SRA.RA_DCUSTO,	SRA.RA_CLASSE,	SRA.RA_TIPOCON,	SRA.RA_ALTNASC,	SRA.RA_ALTCBO,	SRA.RA_BRPDH,	SRA.RA_MSBLQL,	SRA.RA_OKTRANS,	SRA.RA_CODTIT,	SRA.RA_DTCPEXP,	SRA.RA_DTRGEXP,	SRA.RA_CRECHE,  "
cQuery += "      SRA.RA_USERLGI,SRA.RA_ESTACIO,	SRA.RA_USERLGA,	SRA.RA_LOCAL,	SRA.RA_EDIPCMS,	SRA.RA_DTPCMSO,	SRA.RA_EDIBRD,	SRA.RA_DTBRD,	SRA.RA_ASODONT,	SRA.RA_EDIINPA,	SRA.RA_DTINPA,	SRA.RA_BENINPA,"
cQuery += "      SRA.RA_ITEM,   ZZB.ZZB_DESCRI, SRJ.RJ_DESC "

cQuery += " FROM SRA080 SRA "

cQuery += " LEFT JOIN ZZB080 ZZB       "
cQuery += " ON ZZB_LOCAL = RA_LOCAL    "
cQuery += " AND   ZZB.D_E_L_E_T_ <> '*'"

cQuery += " LEFT JOIN SRJ080 srj       "
cQuery += " ON RJ_FUNCAO = RA_CODFUNC  "
cQuery += " AND SRJ.D_E_L_E_T_ <> '*'  "
     
cQuery += " LEFT JOIN CTT080 CTT "
cQuery += " ON CTT_CUSTO = RA_CC "
cQuery += " AND CTT.D_E_L_E_T_ <> '*' "
     
cQuery += " WHERE SRA.RA_DEMISSA >= '"+DTOS(MV_PAR01)+"' AND SRA.RA_DEMISSA <= '"+DTOS(MV_PAR02)+"' "
cQuery += " AND   SRA.RA_TIPOADM <> '9C' " // FILTRO PARA NÃO TRAZER OS COLABORADORES QUE FORAM TRANSFERIDOS DE EMPRESA
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

cQuery := "SELECT 'METRO' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT,	    SRA.RA_NOME,	SRA.RA_CC, CTT.CTT_DESC01,	SRA.RA_SUP,	    SRA.RA_NOMSUP,	SRA.RA_CIC,	    SRA.RA_PIS,	    SRA.RA_RG,	    SRA.RA_NUMCP,  "
cQuery += "      SRA.RA_SERCP,  SRA.RA_UFCP,	SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,	SRA.RA_ZONASEC,	SRA.RA_ENDEREC,	SRA.RA_COMPLEM,	SRA.RA_BAIRRO,	SRA.RA_MUNICIP,	SRA.RA_ESTADO,	SRA.RA_CEP,	   "
cQuery += "      SRA.RA_TELEFON,SRA.RA_PAI,	    SRA.RA_MAE,	    SRA.RA_SEXO,	SRA.RA_ESTCIVI,	SRA.RA_NATURAL,	SRA.RA_NACIONA,	SRA.RA_ANOCHEG,	SRA.RA_DEPIR,	SRA.RA_DEPSF,	SRA.RA_NASC,	SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_OPCAO,	SRA.RA_DEMISSA,	SRA.RA_VCTOEXP,	SRA.RA_EXAMEDI,	SRA.RA_BCDEPSA,	SRA.RA_CTDEPSA,	SRA.RA_BCDPFGT,	SRA.RA_CTDPFGT,	SRA.RA_SITFOLH ,SRA.RA_HRSMES,  SRA.RA_HRSEMAN, "
cQuery += "      SRA.RA_CHAPA,	SRA.RA_TNOTRAB,	SRA.RA_CODFUNC,	SRA.RA_CBO,	    SRA.RA_PGCTSIN,	SRA.RA_SINDICA,	SRA.RA_ASMEDIC,	SRA.RA_DPASSME,	SRA.RA_ADTPOSE,	SRA.RA_CESTAB,	SRA.RA_VALEREF,	SRA.RA_SEGUROV,"
cQuery += "      SRA.RA_PENSALI,SRA.RA_FAIXA,	SRA.RA_PERCADT,	SRA.RA_CATFUNC,	SRA.RA_TIPOPGT,	SRA.RA_SALARIO,	SRA.RA_ANTEAUM,	SRA.RA_BASEINS,	SRA.RA_INSSOUT,	SRA.RA_PERICUL,	SRA.RA_INSMIN,	SRA.RA_INSMED, "
cQuery += "      SRA.RA_INSMAX,	SRA.RA_TIPOADM,	SRA.RA_AFASFGT,	SRA.RA_VIEMRAI,	SRA.RA_GRINRAI,	SRA.RA_RESCRAI,	SRA.RA_MESTRAB,	SRA.RA_MESESAN,	SRA.RA_TIPRES,	SRA.RA_AVPREVI,	SRA.RA_HOMOLOG,	SRA.RA_MEDIASE, "
cQuery += "      SRA.RA_ALTEND,	SRA.RA_ALTCP,	SRA.RA_ALTPIS,	SRA.RA_ALTADM,	SRA.RA_ALTOPC,	SRA.RA_ALTNOME,	SRA.RA_CODRET,	SRA.RA_CRACHA,	SRA.RA_REGRA,	SRA.RA_BITMAP,	SRA.RA_AFASTA,	SRA.RA_RETORNO,	SRA.RA_PONTOSC,	"
cQuery += "      SRA.RA_SENHA,	SRA.RA_PONTOSI,	SRA.RA_SEQTURN,	SRA.RA_REGISTR,	SRA.RA_FICHA,	SRA.RA_NIVEL,	SRA.RA_APELIDO,	SRA.RA_TPCONTR,	SRA.RA_TECNICO,	SRA.RA_EMAIL,	SRA.RA_TPRCBT,	SRA.RA_TCFMSG,	                "
cQuery += "      SRA.RA_OCORREN,SRA.RA_INSSSC,	SRA.RA_CLASSEC,	SRA.RA_PERCSAT,	SRA.RA_RACACOR,	SRA.RA_ACUMBH,	SRA.RA_BHFOL,	SRA.RA_DEFIFIS,	SRA.RA_DISTSN,	SRA.RA_RECMAIL,	SRA.RA_RECPFNC,	SRA.RA_TABELA,              "
cQuery += "      SRA.RA_TABFAIX,SRA.RA_RGORG,	SRA.RA_TABNIVE,	SRA.RA_DESCVT,	SRA.RA_PERFGTS,	SRA.RA_DTVTEST,	SRA.RA_VCTEXP2,	SRA.RA_NOMECMP,	SRA.RA_CATEG,	SRA.RA_CODIGO,	SRA.RA_TPMAIL,	SRA.RA_TPDEFFI,	            "
cQuery += "      SRA.RA_CARGO,	SRA.RA_DCUSTO,	SRA.RA_CLASSE,	SRA.RA_TIPOCON,	SRA.RA_ALTNASC,	SRA.RA_ALTCBO,	SRA.RA_BRPDH,	SRA.RA_MSBLQL,	SRA.RA_OKTRANS,	SRA.RA_CODTIT,	SRA.RA_DTCPEXP,	SRA.RA_DTRGEXP,	SRA.RA_CRECHE,  "
//cQuery += "      SRA.RA_USERLGI,SRA.RA_ESTACIO,	SRA.RA_USERLGA,	SRA.RA_LOCAL,	SRA.RA_EDIPCMS,	SRA.RA_DTPCMSO,	SRA.RA_EDIBRD,	SRA.RA_DTBRD,	SRA.RA_ASODONT,	SRA.RA_EDIINPA,	SRA.RA_DTINPA,	SRA.RA_BENINPA,"
cQuery += "      SRA.RA_ITEM,   ZZB.ZZB_DESCRI, SRJ.RJ_DESC "
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
     
//cQuery += " WHERE SRA.RA_DEMISSA <> ' '"
cQuery += " WHERE SRA.RA_DEMISSA >= '"+DTOS(MV_PAR01)+"' AND SRA.RA_DEMISSA <= '"+DTOS(MV_PAR02)+"' "
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

cQuery := "SELECT 'AURO' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT,	    SRA.RA_NOME,	SRA.RA_CC,      CTT.CTT_DESC01,	SRA.RA_SUP,	    SRA.RA_NOMSUP,	SRA.RA_CIC,	    SRA.RA_PIS,	    SRA.RA_RG,	    SRA.RA_NUMCP,  "
cQuery += "      SRA.RA_SERCP,  SRA.RA_UFCP,	SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,	SRA.RA_ZONASEC,	SRA.RA_ENDEREC,	SRA.RA_COMPLEM,	SRA.RA_BAIRRO,	SRA.RA_MUNICIP,	SRA.RA_ESTADO,	SRA.RA_CEP,	   "
cQuery += "      SRA.RA_TELEFON,SRA.RA_PAI,	    SRA.RA_MAE,	    SRA.RA_SEXO,	SRA.RA_ESTCIVI,	SRA.RA_NATURAL,	SRA.RA_NACIONA,	SRA.RA_ANOCHEG,	SRA.RA_DEPIR,	SRA.RA_DEPSF,	SRA.RA_NASC,	SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_OPCAO,	SRA.RA_DEMISSA,	SRA.RA_VCTOEXP,	SRA.RA_EXAMEDI,	SRA.RA_BCDEPSA,	SRA.RA_CTDEPSA,	SRA.RA_BCDPFGT,	SRA.RA_CTDPFGT,	SRA.RA_SITFOLH ,SRA.RA_HRSMES,  SRA.RA_HRSEMAN, "
cQuery += "      SRA.RA_CHAPA,	SRA.RA_TNOTRAB,	SRA.RA_CODFUNC,	SRA.RA_CBO,	    SRA.RA_PGCTSIN,	SRA.RA_SINDICA,	SRA.RA_ASMEDIC,	SRA.RA_DPASSME,	SRA.RA_ADTPOSE,	SRA.RA_CESTAB,	SRA.RA_VALEREF,	SRA.RA_SEGUROV,"
cQuery += "      SRA.RA_PENSALI,SRA.RA_FAIXA,	SRA.RA_PERCADT,	SRA.RA_CATFUNC,	SRA.RA_TIPOPGT,	SRA.RA_SALARIO,	SRA.RA_ANTEAUM,	SRA.RA_BASEINS,	SRA.RA_INSSOUT,	SRA.RA_PERICUL,	SRA.RA_INSMIN,	SRA.RA_INSMED, "
cQuery += "      SRA.RA_INSMAX,	SRA.RA_TIPOADM,	SRA.RA_AFASFGT,	SRA.RA_VIEMRAI,	SRA.RA_GRINRAI,	SRA.RA_RESCRAI,	SRA.RA_MESTRAB,	SRA.RA_MESESAN,	SRA.RA_TIPRES,	SRA.RA_AVPREVI,	SRA.RA_HOMOLOG,	SRA.RA_MEDIASE, "
cQuery += "      SRA.RA_ALTEND,	SRA.RA_ALTCP,	SRA.RA_ALTPIS,	SRA.RA_ALTADM,	SRA.RA_ALTOPC,	SRA.RA_ALTNOME,	SRA.RA_CODRET,	SRA.RA_CRACHA,	SRA.RA_REGRA,	SRA.RA_BITMAP,	SRA.RA_AFASTA,	SRA.RA_RETORNO,	SRA.RA_PONTOSC,	"
cQuery += "      SRA.RA_SENHA,	SRA.RA_PONTOSI,	SRA.RA_SEQTURN,	SRA.RA_REGISTR,	SRA.RA_FICHA,	SRA.RA_NIVEL,	SRA.RA_APELIDO,	SRA.RA_TPCONTR,	SRA.RA_TECNICO,	SRA.RA_EMAIL,	SRA.RA_TPRCBT,	SRA.RA_TCFMSG,	                "
cQuery += "      SRA.RA_OCORREN,SRA.RA_INSSSC,	SRA.RA_CLASSEC,	SRA.RA_PERCSAT,	SRA.RA_RACACOR,	SRA.RA_ACUMBH,	SRA.RA_BHFOL,	SRA.RA_DEFIFIS,	SRA.RA_DISTSN,	SRA.RA_RECMAIL,	SRA.RA_RECPFNC,	SRA.RA_TABELA,              "
cQuery += "      SRA.RA_TABFAIX,SRA.RA_RGORG,	SRA.RA_TABNIVE,	SRA.RA_DESCVT,	SRA.RA_PERFGTS,	SRA.RA_DTVTEST,	SRA.RA_VCTEXP2,	SRA.RA_NOMECMP,	SRA.RA_CATEG,	SRA.RA_CODIGO,	SRA.RA_TPMAIL,	SRA.RA_TPDEFFI,	            "
cQuery += "      SRA.RA_CARGO,	SRA.RA_DCUSTO,	SRA.RA_CLASSE,	SRA.RA_TIPOCON,	SRA.RA_ALTNASC,	SRA.RA_ALTCBO,	SRA.RA_BRPDH,	SRA.RA_MSBLQL,	SRA.RA_OKTRANS,	SRA.RA_CODTIT,	SRA.RA_DTCPEXP,	SRA.RA_DTRGEXP,	SRA.RA_CRECHE,  "
//cQuery += "      SRA.RA_USERLGI,SRA.RA_ESTACIO,	SRA.RA_USERLGA,	SRA.RA_LOCAL,	SRA.RA_EDIPCMS,	SRA.RA_DTPCMSO,	SRA.RA_EDIBRD,	SRA.RA_DTBRD,	SRA.RA_ASODONT,	SRA.RA_EDIINPA,	SRA.RA_DTINPA,	SRA.RA_BENINPA,"
cQuery += "      SRA.RA_ITEM,   ZZB.ZZB_DESCRI, SRJ.RJ_DESC "
cQuery += " FROM SRA150 SRA "
          
cQuery += " LEFT JOIN ZZB080 ZZB "
cQuery += " ON ZZB_LOCAL = RA_LOCAL "
cQuery += " AND   ZZB.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN SRJ080 SRJ "
cQuery += " ON RJ_FUNCAO = RA_CODFUNC "
cQuery += " AND SRJ.D_E_L_E_T_ <> '*' "

cQuery += " LEFT JOIN CTT080 CTT "
cQuery += " ON CTT_CUSTO = RA_CC "
cQuery += " AND CTT.D_E_L_E_T_ <> '*' "
     
//cQuery += " WHERE SRA.RA_DEMISSA <> ' '"
cQuery += " WHERE SRA.RA_DEMISSA >= '"+DTOS(MV_PAR01)+"' AND SRA.RA_DEMISSA <= '"+DTOS(MV_PAR02)+"' "
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

cQuery := "SELECT 'VICAR' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT,	    SRA.RA_NOME,	SRA.RA_CC,      CTT.CTT_DESC01,	SRA.RA_SUP,	    SRA.RA_NOMSUP,	SRA.RA_CIC,	    SRA.RA_PIS,	    SRA.RA_RG,	    SRA.RA_NUMCP,  "
cQuery += "      SRA.RA_SERCP,  SRA.RA_UFCP,	SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,	SRA.RA_ZONASEC,	SRA.RA_ENDEREC,	SRA.RA_COMPLEM,	SRA.RA_BAIRRO,	SRA.RA_MUNICIP,	SRA.RA_ESTADO,	SRA.RA_CEP,	   "
cQuery += "      SRA.RA_TELEFON,SRA.RA_PAI,	    SRA.RA_MAE,	    SRA.RA_SEXO,	SRA.RA_ESTCIVI,	SRA.RA_NATURAL,	SRA.RA_NACIONA,	SRA.RA_ANOCHEG,	SRA.RA_DEPIR,	SRA.RA_DEPSF,	SRA.RA_NASC,	SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_OPCAO,	SRA.RA_DEMISSA,	SRA.RA_VCTOEXP,	SRA.RA_EXAMEDI,	SRA.RA_BCDEPSA,	SRA.RA_CTDEPSA,	SRA.RA_BCDPFGT,	SRA.RA_CTDPFGT,	SRA.RA_SITFOLH ,SRA.RA_HRSMES,  SRA.RA_HRSEMAN, "
cQuery += "      SRA.RA_CHAPA,	SRA.RA_TNOTRAB,	SRA.RA_CODFUNC,	SRA.RA_CBO,	    SRA.RA_PGCTSIN,	SRA.RA_SINDICA,	SRA.RA_ASMEDIC,	SRA.RA_DPASSME,	SRA.RA_ADTPOSE,	SRA.RA_CESTAB,	SRA.RA_VALEREF,	SRA.RA_SEGUROV,"
cQuery += "      SRA.RA_PENSALI,SRA.RA_FAIXA,	SRA.RA_PERCADT,	SRA.RA_CATFUNC,	SRA.RA_TIPOPGT,	SRA.RA_SALARIO,	SRA.RA_ANTEAUM,	SRA.RA_BASEINS,	SRA.RA_INSSOUT,	SRA.RA_PERICUL,	SRA.RA_INSMIN,	SRA.RA_INSMED, "
cQuery += "      SRA.RA_INSMAX,	SRA.RA_TIPOADM,	SRA.RA_AFASFGT,	SRA.RA_VIEMRAI,	SRA.RA_GRINRAI,	SRA.RA_RESCRAI,	SRA.RA_MESTRAB,	SRA.RA_MESESAN,	SRA.RA_TIPRES,	SRA.RA_AVPREVI,	SRA.RA_HOMOLOG,	SRA.RA_MEDIASE, "
cQuery += "      SRA.RA_ALTEND,	SRA.RA_ALTCP,	SRA.RA_ALTPIS,	SRA.RA_ALTADM,	SRA.RA_ALTOPC,	SRA.RA_ALTNOME,	SRA.RA_CODRET,	SRA.RA_CRACHA,	SRA.RA_REGRA,	SRA.RA_BITMAP,	SRA.RA_AFASTA,	SRA.RA_RETORNO,	SRA.RA_PONTOSC,	"
cQuery += "      SRA.RA_SENHA,	SRA.RA_PONTOSI,	SRA.RA_SEQTURN,	SRA.RA_REGISTR,	SRA.RA_FICHA,	SRA.RA_NIVEL,	SRA.RA_APELIDO,	SRA.RA_TPCONTR,	SRA.RA_TECNICO,	SRA.RA_EMAIL,	SRA.RA_TPRCBT,	SRA.RA_TCFMSG,	                "
cQuery += "      SRA.RA_OCORREN,SRA.RA_INSSSC,	SRA.RA_CLASSEC,	SRA.RA_PERCSAT,	SRA.RA_RACACOR,	SRA.RA_ACUMBH,	SRA.RA_BHFOL,	SRA.RA_DEFIFIS,	SRA.RA_DISTSN,	SRA.RA_RECMAIL,	SRA.RA_RECPFNC,	SRA.RA_TABELA,              "
cQuery += "      SRA.RA_TABFAIX,SRA.RA_RGORG,	SRA.RA_TABNIVE,	SRA.RA_DESCVT,	SRA.RA_PERFGTS,	SRA.RA_DTVTEST,	SRA.RA_VCTEXP2,	SRA.RA_NOMECMP,	SRA.RA_CATEG,	SRA.RA_CODIGO,	SRA.RA_TPMAIL,	SRA.RA_TPDEFFI,	            "
cQuery += "      SRA.RA_CARGO,	SRA.RA_DCUSTO,	SRA.RA_CLASSE,	SRA.RA_TIPOCON,	SRA.RA_ALTNASC,	SRA.RA_ALTCBO,	SRA.RA_BRPDH,	SRA.RA_MSBLQL,	SRA.RA_OKTRANS,	SRA.RA_CODTIT,	SRA.RA_DTCPEXP,	SRA.RA_DTRGEXP,	SRA.RA_CRECHE,  "
//cQuery += "      SRA.RA_USERLGI,SRA.RA_ESTACIO,	SRA.RA_USERLGA,	SRA.RA_LOCAL,	SRA.RA_EDIPCMS,	SRA.RA_DTPCMSO,	SRA.RA_EDIBRD,	SRA.RA_DTBRD,	SRA.RA_ASODONT,	SRA.RA_EDIINPA,	SRA.RA_DTINPA,	SRA.RA_BENINPA,"
cQuery += "      SRA.RA_ITEM,   ZZB.ZZB_DESCRI, SRJ.RJ_DESC "
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
     
//cQuery += " WHERE SRA.RA_DEMISSA <> ' '"
cQuery += " WHERE SRA.RA_DEMISSA >= '"+DTOS(MV_PAR01)+"' AND SRA.RA_DEMISSA <= '"+DTOS(MV_PAR02)+"' "
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

cQuery := "SELECT 'AEB' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT,	    SRA.RA_NOME,	SRA.RA_CC,      CTT.CTT_DESC01,	SRA.RA_SUP,	    SRA.RA_NOMSUP,	SRA.RA_CIC,	    SRA.RA_PIS,	    SRA.RA_RG,	    SRA.RA_NUMCP,  "
cQuery += "      SRA.RA_SERCP,  SRA.RA_UFCP,	SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,	SRA.RA_ZONASEC,	SRA.RA_ENDEREC,	SRA.RA_COMPLEM,	SRA.RA_BAIRRO,	SRA.RA_MUNICIP,	SRA.RA_ESTADO,	SRA.RA_CEP,	   "
cQuery += "      SRA.RA_TELEFON,SRA.RA_PAI,	    SRA.RA_MAE,	    SRA.RA_SEXO,	SRA.RA_ESTCIVI,	SRA.RA_NATURAL,	SRA.RA_NACIONA,	SRA.RA_ANOCHEG,	SRA.RA_DEPIR,	SRA.RA_DEPSF,	SRA.RA_NASC,	SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_OPCAO,	SRA.RA_DEMISSA,	SRA.RA_VCTOEXP,	SRA.RA_EXAMEDI,	SRA.RA_BCDEPSA,	SRA.RA_CTDEPSA,	SRA.RA_BCDPFGT,	SRA.RA_CTDPFGT,	SRA.RA_SITFOLH ,SRA.RA_HRSMES,  SRA.RA_HRSEMAN, "
cQuery += "      SRA.RA_CHAPA,	SRA.RA_TNOTRAB,	SRA.RA_CODFUNC,	SRA.RA_CBO,	    SRA.RA_PGCTSIN,	SRA.RA_SINDICA,	SRA.RA_ASMEDIC,	SRA.RA_DPASSME,	SRA.RA_ADTPOSE,	SRA.RA_CESTAB,	SRA.RA_VALEREF,	SRA.RA_SEGUROV,"
cQuery += "      SRA.RA_PENSALI,SRA.RA_FAIXA,	SRA.RA_PERCADT,	SRA.RA_CATFUNC,	SRA.RA_TIPOPGT,	SRA.RA_SALARIO,	SRA.RA_ANTEAUM,	SRA.RA_BASEINS,	SRA.RA_INSSOUT,	SRA.RA_PERICUL,	SRA.RA_INSMIN,	SRA.RA_INSMED, "
cQuery += "      SRA.RA_INSMAX,	SRA.RA_TIPOADM,	SRA.RA_AFASFGT,	SRA.RA_VIEMRAI,	SRA.RA_GRINRAI,	SRA.RA_RESCRAI,	SRA.RA_MESTRAB,	SRA.RA_MESESAN,	SRA.RA_TIPRES,	SRA.RA_AVPREVI,	SRA.RA_HOMOLOG,	SRA.RA_MEDIASE, "
cQuery += "      SRA.RA_ALTEND,	SRA.RA_ALTCP,	SRA.RA_ALTPIS,	SRA.RA_ALTADM,	SRA.RA_ALTOPC,	SRA.RA_ALTNOME,	SRA.RA_CODRET,	SRA.RA_CRACHA,	SRA.RA_REGRA,	SRA.RA_BITMAP,	SRA.RA_AFASTA,	SRA.RA_RETORNO,	SRA.RA_PONTOSC,	"
cQuery += "      SRA.RA_SENHA,	SRA.RA_PONTOSI,	SRA.RA_SEQTURN,	SRA.RA_REGISTR,	SRA.RA_FICHA,	SRA.RA_NIVEL,	SRA.RA_APELIDO,	SRA.RA_TPCONTR,	SRA.RA_TECNICO,	SRA.RA_EMAIL,	SRA.RA_TPRCBT,	SRA.RA_TCFMSG,	                "
cQuery += "      SRA.RA_OCORREN,SRA.RA_INSSSC,	SRA.RA_CLASSEC,	SRA.RA_PERCSAT,	SRA.RA_RACACOR,	SRA.RA_ACUMBH,	SRA.RA_BHFOL,	SRA.RA_DEFIFIS,	SRA.RA_DISTSN,	SRA.RA_RECMAIL,	SRA.RA_RECPFNC,	SRA.RA_TABELA,              "
cQuery += "      SRA.RA_TABFAIX,SRA.RA_RGORG,	SRA.RA_TABNIVE,	SRA.RA_DESCVT,	SRA.RA_PERFGTS,	SRA.RA_DTVTEST,	SRA.RA_VCTEXP2,	SRA.RA_NOMECMP,	SRA.RA_CATEG,	SRA.RA_CODIGO,	SRA.RA_TPMAIL,	SRA.RA_TPDEFFI,	            "
cQuery += "      SRA.RA_CARGO,	SRA.RA_DCUSTO,	SRA.RA_CLASSE,	SRA.RA_TIPOCON,	SRA.RA_ALTNASC,	SRA.RA_ALTCBO,	SRA.RA_BRPDH,	SRA.RA_MSBLQL,	SRA.RA_OKTRANS,	SRA.RA_CODTIT,	SRA.RA_DTCPEXP,	SRA.RA_DTRGEXP,	SRA.RA_CRECHE,  "
//cQuery += "      SRA.RA_USERLGI,SRA.RA_ESTACIO,	SRA.RA_USERLGA,	SRA.RA_LOCAL,	SRA.RA_EDIPCMS,	SRA.RA_DTPCMSO,	SRA.RA_EDIBRD,	SRA.RA_DTBRD,	SRA.RA_ASODONT,	SRA.RA_EDIINPA,	SRA.RA_DTINPA,	SRA.RA_BENINPA,"
cQuery += "      SRA.RA_ITEM,   ZZB.ZZB_DESCRI, SRJ.RJ_DESC "
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
     
//cQuery += " WHERE SRA.RA_DEMISSA <> ' '"
cQuery += " WHERE SRA.RA_DEMISSA >= '"+DTOS(MV_PAR01)+"' AND SRA.RA_DEMISSA <= '"+DTOS(MV_PAR02)+"' "
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

cQuery := "SELECT 'AREA MKT' EMPRESA, SRA.RA_FILIAL,	SRA.RA_MAT,	    SRA.RA_NOME,	SRA.RA_CC,      CTT.CTT_DESC01,	SRA.RA_SUP,	    SRA.RA_NOMSUP,	SRA.RA_CIC,	    SRA.RA_PIS,	    SRA.RA_RG,	    SRA.RA_NUMCP,  "
cQuery += "      SRA.RA_SERCP,  SRA.RA_UFCP,	SRA.RA_HABILIT,	SRA.RA_RESERVI,	SRA.RA_TITULOE,	SRA.RA_ZONASEC,	SRA.RA_ENDEREC,	SRA.RA_COMPLEM,	SRA.RA_BAIRRO,	SRA.RA_MUNICIP,	SRA.RA_ESTADO,	SRA.RA_CEP,	   "
cQuery += "      SRA.RA_TELEFON,SRA.RA_PAI,	    SRA.RA_MAE,	    SRA.RA_SEXO,	SRA.RA_ESTCIVI,	SRA.RA_NATURAL,	SRA.RA_NACIONA,	SRA.RA_ANOCHEG,	SRA.RA_DEPIR,	SRA.RA_DEPSF,	SRA.RA_NASC,	SRA.RA_ADMISSA,"
cQuery += "      SRA.RA_OPCAO,	SRA.RA_DEMISSA,	SRA.RA_VCTOEXP,	SRA.RA_EXAMEDI,	SRA.RA_BCDEPSA,	SRA.RA_CTDEPSA,	SRA.RA_BCDPFGT,	SRA.RA_CTDPFGT,	SRA.RA_SITFOLH ,SRA.RA_HRSMES,  SRA.RA_HRSEMAN, "
cQuery += "      SRA.RA_CHAPA,	SRA.RA_TNOTRAB,	SRA.RA_CODFUNC,	SRA.RA_CBO,	    SRA.RA_PGCTSIN,	SRA.RA_SINDICA,	SRA.RA_ASMEDIC,	SRA.RA_DPASSME,	SRA.RA_ADTPOSE,	SRA.RA_CESTAB,	SRA.RA_VALEREF,	SRA.RA_SEGUROV,"
cQuery += "      SRA.RA_PENSALI,SRA.RA_FAIXA,	SRA.RA_PERCADT,	SRA.RA_CATFUNC,	SRA.RA_TIPOPGT,	SRA.RA_SALARIO,	SRA.RA_ANTEAUM,	SRA.RA_BASEINS,	SRA.RA_INSSOUT,	SRA.RA_PERICUL,	SRA.RA_INSMIN,	SRA.RA_INSMED, "
cQuery += "      SRA.RA_INSMAX,	SRA.RA_TIPOADM,	SRA.RA_AFASFGT,	SRA.RA_VIEMRAI,	SRA.RA_GRINRAI,	SRA.RA_RESCRAI,	SRA.RA_MESTRAB,	SRA.RA_MESESAN,	SRA.RA_TIPRES,	SRA.RA_AVPREVI,	SRA.RA_HOMOLOG,	SRA.RA_MEDIASE, "
cQuery += "      SRA.RA_ALTEND,	SRA.RA_ALTCP,	SRA.RA_ALTPIS,	SRA.RA_ALTADM,	SRA.RA_ALTOPC,	SRA.RA_ALTNOME,	SRA.RA_CODRET,	SRA.RA_CRACHA,	SRA.RA_REGRA,	SRA.RA_BITMAP,	SRA.RA_AFASTA,	SRA.RA_RETORNO,	SRA.RA_PONTOSC,	"
cQuery += "      SRA.RA_SENHA,	SRA.RA_PONTOSI,	SRA.RA_SEQTURN,	SRA.RA_REGISTR,	SRA.RA_FICHA,	SRA.RA_NIVEL,	SRA.RA_APELIDO,	SRA.RA_TPCONTR,	SRA.RA_TECNICO,	SRA.RA_EMAIL,	SRA.RA_TPRCBT,	SRA.RA_TCFMSG,	                "
cQuery += "      SRA.RA_OCORREN,SRA.RA_INSSSC,	SRA.RA_CLASSEC,	SRA.RA_PERCSAT,	SRA.RA_RACACOR,	SRA.RA_ACUMBH,	SRA.RA_BHFOL,	SRA.RA_DEFIFIS,	SRA.RA_DISTSN,	SRA.RA_RECMAIL,	SRA.RA_RECPFNC,	SRA.RA_TABELA,              "
cQuery += "      SRA.RA_TABFAIX,SRA.RA_RGORG,	SRA.RA_TABNIVE,	SRA.RA_DESCVT,	SRA.RA_PERFGTS,	SRA.RA_DTVTEST,	SRA.RA_VCTEXP2,	SRA.RA_NOMECMP,	SRA.RA_CATEG,	SRA.RA_CODIGO,	SRA.RA_TPMAIL,	SRA.RA_TPDEFFI,	            "
cQuery += "      SRA.RA_CARGO,	SRA.RA_DCUSTO,	SRA.RA_CLASSE,	SRA.RA_TIPOCON,	SRA.RA_ALTNASC,	SRA.RA_ALTCBO,	SRA.RA_BRPDH,	SRA.RA_MSBLQL,	SRA.RA_OKTRANS,	SRA.RA_CODTIT,	SRA.RA_DTCPEXP,	SRA.RA_DTRGEXP,	SRA.RA_CRECHE,  "
//cQuery += "      SRA.RA_USERLGI,SRA.RA_ESTACIO,	SRA.RA_USERLGA,	SRA.RA_LOCAL,	SRA.RA_EDIPCMS,	SRA.RA_DTPCMSO,	SRA.RA_EDIBRD,	SRA.RA_DTBRD,	SRA.RA_ASODONT,	SRA.RA_EDIINPA,	SRA.RA_DTINPA,	SRA.RA_BENINPA,"
cQuery += "      SRA.RA_ITEM,   ZZB.ZZB_DESCRI, SRJ.RJ_DESC "
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
     
//cQuery += " WHERE SRA.RA_DEMISSA <> ' '"
cQuery += " WHERE SRA.RA_DEMISSA >= '"+DTOS(MV_PAR01)+"' AND SRA.RA_DEMISSA <= '"+DTOS(MV_PAR02)+"' "
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
/*Do while !eof()
	if rlock()
		trb->databas  := DTOC(stod(rf_databas))
		trb->fimper   := DTOC(stod(rf_databas)+365)
		trb->admissa  := DTOC(stod(ra_admissa))
	endif
	skip
Enddo
dbgotop()*/

  
//Cria o arquivo CSV
cFile 	:= AllTrim(cGetFile(,"Diretório Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	+= "\Demitidos_" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Atenção, não foi possível criar o arquivo no diretório especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
AAdd(aCabec,{'EMPRESA','C','EMPRESA'})
AAdd(aCabec,{'FILIAL','C','RA_FILIAL'})
AAdd(aCabec,{'MAT','C','RA_MAT'})
AAdd(aCabec,{'NOME','C','RA_NOME'})
AAdd(aCabec,{'CC','C','RA_CC'})
AAdd(aCabec,{'DESC01','C','CTT_DESC01'})
AAdd(aCabec,{'SUP','C','RA_SUP'})
AAdd(aCabec,{'NOMSUP','C','RA_NOMSUP'})
AAdd(aCabec,{'CIC','C','RA_CIC'})
AAdd(aCabec,{'PIS','C','RA_PIS'})
AAdd(aCabec,{'RG','C','RA_RG'})
AAdd(aCabec,{'NUMCP','C','RA_NUMCP'})
AAdd(aCabec,{'SERCP','C','RA_SERCP'})
AAdd(aCabec,{'UFCP','C','RA_UFCP'})
AAdd(aCabec,{'HABILIT','C','RA_HABILIT'})
AAdd(aCabec,{'RESERVI','C','RA_RESERVI'})
AAdd(aCabec,{'TITULOE','C','RA_TITULOE'})
AAdd(aCabec,{'ZONASEC','C','RA_ZONASEC'})
AAdd(aCabec,{'ENDEREC','C','RA_ENDEREC'})
AAdd(aCabec,{'COMPLEM','C','RA_COMPLEM'})
AAdd(aCabec,{'BAIRRO','C','RA_BAIRRO'})
AAdd(aCabec,{'MUNICIP','C','RA_MUNICIP'})
AAdd(aCabec,{'ESTADO','C','RA_ESTADO'})
AAdd(aCabec,{'CEP','C','RA_CEP'})
AAdd(aCabec,{'TELEFON','C','RA_TELEFON'})
AAdd(aCabec,{'PAI','C','RA_PAI'})
AAdd(aCabec,{'MAE','C','RA_MAE'})
AAdd(aCabec,{'SEXO','C','RA_SEXO'})
AAdd(aCabec,{'ESTCIVI','C','RA_ESTCIVI'})
AAdd(aCabec,{'NATURAL','C','RA_NATURAL'})
AAdd(aCabec,{'NACIONA','C','RA_NACIONA'})
AAdd(aCabec,{'ANOCHEG','C','RA_ANOCHEG'})
AAdd(aCabec,{'DEPIR','C','RA_DEPIR'})
AAdd(aCabec,{'DEPSF','C','RA_DEPSF'})
AAdd(aCabec,{'NASC','C','RA_NASC'})
AAdd(aCabec,{'ADMISSA','C','RA_ADMISSA'})
AAdd(aCabec,{'OPCAO','C','RA_OPCAO'})
AAdd(aCabec,{'DEMISSA','C','RA_DEMISSA'})
AAdd(aCabec,{'VCTOEXP','C','RA_VCTOEXP'})
AAdd(aCabec,{'EXAMEDI','C','RA_EXAMEDI'})
AAdd(aCabec,{'BCDEPSA','C','RA_BCDEPSA'})
AAdd(aCabec,{'CTDEPSA','C','RA_CTDEPSA'})
AAdd(aCabec,{'BCDPFGT','C','RA_BCDPFGT'})
AAdd(aCabec,{'CTDPFGT','C','RA_CTDPFGT'})
AAdd(aCabec,{'SITFOLH','C','RA_SITFOLH'})
AAdd(aCabec,{'HRSMES','N','RA_HRSMES'})
AAdd(aCabec,{'HRSEMAN','N','RA_HRSEMAN'})
AAdd(aCabec,{'CHAPA','C','RA_CHAPA'})
AAdd(aCabec,{'TNOTRAB','C','RA_TNOTRAB'})
AAdd(aCabec,{'CODFUNC','C','RA_CODFUNC'})
AAdd(aCabec,{'CBO','C','RA_CBO'})
AAdd(aCabec,{'PGCTSIN','C','RA_PGCTSIN'})
AAdd(aCabec,{'SINDICA','C','RA_SINDICA'})
AAdd(aCabec,{'ASMEDIC','C','RA_ASMEDIC'})
AAdd(aCabec,{'DPASSME','C','RA_DPASSME'})
AAdd(aCabec,{'ADTPOSE','C','RA_ADTPOSE'})
AAdd(aCabec,{'CESTAB','C','RA_CESTAB'})
AAdd(aCabec,{'VALEREF','C','RA_VALEREF'})
AAdd(aCabec,{'SEGUROV','C','RA_SEGUROV'})
AAdd(aCabec,{'PENSALI','N','RA_PENSALI'})
AAdd(aCabec,{'FAIXA','C','RA_FAIXA'})
AAdd(aCabec,{'PERCADT','N','RA_PERCADT'})
AAdd(aCabec,{'CATFUNC','C','RA_CATFUNC'})
AAdd(aCabec,{'TIPOPGT','C','RA_TIPOPGT'})
AAdd(aCabec,{'SALARIO','N','RA_SALARIO'})
AAdd(aCabec,{'ANTEAUM','N','RA_ANTEAUM'})
AAdd(aCabec,{'BASEINS','N','RA_BASEINS'})
AAdd(aCabec,{'INSSOUT','N','RA_INSSOUT'})
AAdd(aCabec,{'PERICUL','N','RA_PERICUL'})
AAdd(aCabec,{'INSMIN','N','RA_INSMIN'})
AAdd(aCabec,{'INSMED','N','RA_INSMED'})
AAdd(aCabec,{'INSMAX','N','RA_INSMAX'})
AAdd(aCabec,{'TIPOADM','C','RA_TIPOADM'})
AAdd(aCabec,{'AFASFGT','C','RA_AFASFGT'})
AAdd(aCabec,{'VIEMRAI','C','RA_VIEMRAI'})
AAdd(aCabec,{'GRINRAI','C','RA_GRINRAI'})
AAdd(aCabec,{'RESCRAI','C','RA_RESCRAI'})
AAdd(aCabec,{'MESTRAB','C','RA_MESTRAB'})
AAdd(aCabec,{'MESESAN','N','RA_MESESAN'})
AAdd(aCabec,{'TIPRES','C','RA_TIPRES'})
AAdd(aCabec,{'AVPREVI','C','RA_AVPREVI'})
AAdd(aCabec,{'HOMOLOG','C','RA_HOMOLOG'})
AAdd(aCabec,{'MEDIASE','C','RA_MEDIASE'})
AAdd(aCabec,{'ALTEND','C','RA_ALTEND'})
AAdd(aCabec,{'ALTCP','C','RA_ALTCP'})
AAdd(aCabec,{'ALTPIS','C','RA_ALTPIS'})
AAdd(aCabec,{'ALTADM','C','RA_ALTADM'})
AAdd(aCabec,{'ALTOPC','C','RA_ALTOPC'})
AAdd(aCabec,{'ALTNOME','C','RA_ALTNOME'})
AAdd(aCabec,{'CODRET','C','RA_CODRET'})
AAdd(aCabec,{'CRACHA','C','RA_CRACHA'})
AAdd(aCabec,{'REGRA','C','RA_REGRA'})
AAdd(aCabec,{'BITMAP','C','RA_BITMAP'})
AAdd(aCabec,{'AFASTA','C','RA_AFASTA'})
AAdd(aCabec,{'RETORNO','C','RA_RETORNO'})
AAdd(aCabec,{'PONTOSC','N','RA_PONTOSC'})
AAdd(aCabec,{'SENHA','C','RA_SENHA'})
AAdd(aCabec,{'PONTOSI','N','RA_PONTOSI'})
AAdd(aCabec,{'SEQTURN','C','RA_SEQTURN'})
AAdd(aCabec,{'REGISTR','C','RA_REGISTR'})
AAdd(aCabec,{'FICHA','C','RA_FICHA'})
AAdd(aCabec,{'NIVEL','C','RA_NIVEL'})
AAdd(aCabec,{'APELIDO','C','RA_APELIDO'})
AAdd(aCabec,{'TPCONTR','C','RA_TPCONTR'})
AAdd(aCabec,{'TECNICO','C','RA_TECNICO'})
AAdd(aCabec,{'EMAIL','C','RA_EMAIL'})
AAdd(aCabec,{'TPRCBT','C','RA_TPRCBT'})
AAdd(aCabec,{'TCFMSG','C','RA_TCFMSG'})
AAdd(aCabec,{'OCORREN','C','RA_OCORREN'})
AAdd(aCabec,{'INSSSC','C','RA_INSSSC'})
AAdd(aCabec,{'CLASSEC','C','RA_CLASSEC'})
AAdd(aCabec,{'PERCSAT','N','RA_PERCSAT'})
AAdd(aCabec,{'RACACOR','C','RA_RACACOR'})
AAdd(aCabec,{'ACUMBH','C','RA_ACUMBH'})
AAdd(aCabec,{'BHFOL','C','RA_BHFOL'})
AAdd(aCabec,{'DEFIFIS','C','RA_DEFIFIS'})
AAdd(aCabec,{'DISTSN','C','RA_DISTSN'})
AAdd(aCabec,{'RECMAIL','C','RA_RECMAIL'})
AAdd(aCabec,{'RECPFNC','C','RA_RECPFNC'})
AAdd(aCabec,{'TABELA','C','RA_TABELA'})
AAdd(aCabec,{'TABFAIX','C','RA_TABFAIX'})
AAdd(aCabec,{'RGORG','C','RA_RGORG'})
AAdd(aCabec,{'TABNIVE','C','RA_TABNIVE'})
AAdd(aCabec,{'DESCVT','C','RA_DESCVT'})
AAdd(aCabec,{'PERFGTS','N','RA_PERFGTS'})
AAdd(aCabec,{'DTVTEST','C','RA_DTVTEST'})
AAdd(aCabec,{'VCTEXP2','C','RA_VCTEXP2'})
AAdd(aCabec,{'NOMECMP','C','RA_NOMECMP'})
AAdd(aCabec,{'CATEG','C','RA_CATEG'})
AAdd(aCabec,{'CODIGO','C','RA_CODIGO'})
AAdd(aCabec,{'TPMAIL','C','RA_TPMAIL'})
AAdd(aCabec,{'TPDEFFI','C','RA_TPDEFFI'})
AAdd(aCabec,{'CARGO','C','RA_CARGO'})
AAdd(aCabec,{'DCUSTO','C','RA_DCUSTO'})
AAdd(aCabec,{'CLASSE','C','RA_CLASSE'})
AAdd(aCabec,{'TIPOCON','C','RA_TIPOCON'})
AAdd(aCabec,{'ALTNASC','C','RA_ALTNASC'})
AAdd(aCabec,{'ALTCBO','C','RA_ALTCBO'})
AAdd(aCabec,{'BRPDH','C','RA_BRPDH'})
AAdd(aCabec,{'MSBLQL','C','RA_MSBLQL'})
AAdd(aCabec,{'OKTRANS','C','RA_OKTRANS'})
AAdd(aCabec,{'CODTIT','C','RA_CODTIT'})
AAdd(aCabec,{'DTCPEXP','C','RA_DTCPEXP'})
AAdd(aCabec,{'DTRGEXP','C','RA_DTRGEXP'})
AAdd(aCabec,{'CRECHE','C','RA_CRECHE'})
AAdd(aCabec,{'USERLGI','C','RA_USERLGI'})
AAdd(aCabec,{'ESTACIO','C','RA_ESTACIO'})
AAdd(aCabec,{'USERLGA','C','RA_USERLGA'})
AAdd(aCabec,{'LOCAL','C','RA_LOCAL'})
AAdd(aCabec,{'EDIPCMS','C','RA_EDIPCMS'})
AAdd(aCabec,{'DTPCMSO','C','RA_DTPCMSO'})
AAdd(aCabec,{'EDIBRD','C','RA_EDIBRD'})
AAdd(aCabec,{'DTBRD','C','RA_DTBRD'})
AAdd(aCabec,{'ASODONT','C','RA_ASODONT'})
AAdd(aCabec,{'EDIINPA','C','RA_EDIINPA'})
AAdd(aCabec,{'DTINPA','C','RA_DTINPA'})
AAdd(aCabec,{'BENINPA','C','RA_BENINPA'})
AAdd(aCabec,{'ITEM','C','RA_ITEM'})
AAdd(aCabec,{'DESCRI','C','ZZB_DESCRI'})
AAdd(aCabec,{'DESC','C','RJ_DESC'})

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
			do Case
			Case trim(aCabec[i,3]) $ "RA_NASC*RA_ADMISSA*RA_DEMISSA*RA_OPCAO*RA_DTVTEST*RA_VCTOEXP*RA_VCTEXP2*RA_DTRGEXP*RA_DTCPEXP*RA_DTPCMSO" 
				cCpo := dtoc(stod(TRB->&(aCabec[i,3])))
				cLinhaCSV += cCpo+";"
			Otherwise
				cLinhaCSV += TRB->&(aCabec[i,3])+";"
			endcase
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
