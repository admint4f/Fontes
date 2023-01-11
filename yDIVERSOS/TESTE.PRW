#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

User function TESTE()


	Local cLinha  := ""
	//Local lPrimlin   := .F.
	//Local aCampos := {}
	Local aDados  := {}
	Local i

	cEmpUse := '20'
	cFilUse := '01'
	cLocal := '01'
	cObsOP := ''
	cNumOP := ''
	cNSIOP := ''

	RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA cEmpUse FILIAL cFilUse MODULO "LOJA"

	cDir := cGetFile('Arquivos de csv|*.csv','Selecione o arquivo',1)//"c:\temp\produção de pas.csv"
	
	If Empty(cDir)
		Return
	EndIf

	FT_FUSE(cDir)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()

	While !FT_FEOF()

		cLinha := FT_FREADLN()

		//If lPrimlin
		//	aCampos := Separa(cLinha,";",.T.)
		//	lPrimlin := .F.
		//Else
			AADD(aDados,Separa(cLinha,";",.T.))
		//EndIf

		FT_FSKIP()

	EndDo

	For i := 1 to len(aDados)
		CriaOP(adados[i][2],adados[i][4],cLocal,@cNumOP,@cObsOP,@cNSIOP,adados[i][1])
		ApontaOP(cNSIOP,adados[i][4],cLocal,adados[i][1])
	Next i

		RESET ENVIRONMENT

Return

Static Function CriaOP(cProd,nQtd,cLocal,cNumOP,cObsOP,cNSIOP,dDataOP)

	Local nOpc    := 3 			//  3 - Inclusao || 4 - Alteracao || 5 - Exclusao
	Local aCabc   := {}

	Private lMsErroAuto := .F.

	aCabc  := { ;
		{'C2_FILIAL'    , xFilial("SC2")  ,NIL},;
		{'C2_ITEM'      , "01"                      ,".T."},;
		{'C2_SEQUEN'    , "001"                     ,".T."},;
		{'C2_PRODUTO'   , cProd                     ,NIL},;
		{"C2_QUANT"     , Val(nQtd)                      ,NIL},;
		{"C2_STATUS"    , 'N'                       ,NIL},;
		{"C2_LOCAL"     , cLocal					,NIL},;
		{"C2_CC"        , ''                        ,NIL},;
		{"C2_PRIOR"     , '500'                     ,NIL},;
		{"C2_DATPRI"    , CTOD(dDataOP)	                ,NIL},;
		{"C2_DATPRF"    , DDATABASE	                ,NIL},;
		{"C2_EMISSAO"   , CTOD(dDataOP)	                ,NIL},;
		{'AUTEXPLODE'   , "S"                       ,NIL};
		}

	msExecAuto({|x,Y| Mata650(x,Y)},aCabc,nOpc)

	If !lMsErroAuto
		ConOut("Sucesso criação op! ")
	Else
		MostraErro()
		ConOut("Erro criação op!")
		Return .F.
	EndIf

	cNumOP  := SC2->C2_NUM
	cObsOP  := ""
	cNSIOP	:= SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN

Return .T.

Static Function ApontaOP(cNumOp,cQuant,cLocal,dDataOP)

	Local aVetor  := {}
	Local nOpc    := 3 //-Opção de execução da rotina, informado nos parametros quais as opções possiveisl

	Private lMsErroAuto := .F.

	aVetor :=	{;
		{"D3_OP" 		,cNumOp			,NIL},;
		{"D3_FILIAL"	,xFilial("SD3") ,NIL},;
		;//{"D3_QUANT"     ,vAL(cQuant)   			,NIL},;
		;//{"D3_LOCAL"		,cLocal 		,NIL},;
		{"D3_EMISSAO"		,CTOD(dDataOP) 		,NIL},;
		{"D3_TM"    	,"001"    		,NIL}}

	MSExecAuto({|x, y| mata250(x, y)},aVetor, nOpc )

	If !lMsErroAuto
		ConOut("Sucesso apontamento op! ")
	Else
		MostraErro()
		ConOut("Erro apontamento op!")
		Return .F.
	EndIf

Return .T.


