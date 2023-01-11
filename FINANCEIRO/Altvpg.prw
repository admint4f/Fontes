#include "rwmake.ch"
#include "protheus.ch"
#include "ap5mail.ch"
#include "TopConn.ch"
#DEFINE  NUMITENS 999
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Altvpg   ³ Autor ³ Luiz Eduardo Tapajós  ³ Data ³ 23/07/20 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Tela para liberação de títulos				              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFIN                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Altvpg( cRotina )

Local aFixe := {}
Local aStruct
Local aCores
Local cFilter := " "

Local cArqTrab
Local cCond
Local cIndexKey

Private aRotina := MenuDef()
Private cCadastro := "Alteração Vencimento"
Private aCores    := { { "E2_MSBLQL<>'1' .and. STRZERO(E2_SALDO,1)<>'0'", 'BR_VERDE' },;
{ "STRZERO(E2_SALDO,1)=='0'", 'BR_VERMELHO' },;
{ "STRZERO(E2_SALDO,1)<>'0' .and. E2_SALDO<>E2_VALOR", 'BR_AZUL' } }
cAprov := GetMV("MV_USRINSS")  // Parâmetro  criado contendo os usuários aptos a utilizar a rotina
//if !RetCodUsr()$cAprov
//	ApMsgInfo("Esse Usuario nao esta cadastrado para aprovação de títulos do INSS ","Atencao")
//	Return
//Endif
//001479(Thiago)-001100(Soraia) 

//Private aCores    := { { "empty(E2_DATALIB)", 'BR_VERDE' },;
//{ "STRZERO(E2_SALDO,1)=='0'", 'BR_VERMELHO' },;
//{ "!empty(E2_DATALIB)", 'BR_AZUL' } }

If ValType( cRotina ) <> "C"
	
//	If MsgYesNo("Mostrar APENAS titulos bloqueados ? ","ATENÇÃO","YESNO")
		cFilter := "E2_SALDO <>0"//"E2_MSBLQL='1' "//.AND. E2_SALDO <>0 "
//	Else
//		cFilter := "E2_INSS<>0 OR E2_XPLACA='BLOQ' "//.AND. E2_SALDO <>0 "
//	Endif
	
	//	mBrowse( 6, 1, 22, 75, "SE2" )
	mBrowse( 6, 1, 22, 75, "SE2",,,,,, aCores,,,,,,,,cFilter)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tratamento para chamada de outra rotina                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty( nScan := AScan( aRotina, { |x| x[2] == cRotina } ) )
		cRoda := cRotina + "( 'SE2', SE2->( Recno() ), " + Str( nScan, 2 ) + ") "
		Eval( { || &( cRoda ) } )
	EndIf
EndIf

Return( nil )

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ MenuDef  ³ Autor ³ Luiz Eduardo          ³ Data ³ 06.08.19 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Definição do aRotina (Menu funcional)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MenuDef()                                                  ³±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aRotina := {	{ "Pesquisar"	,"AxPesqui"		,0	,1	,0	,.F.	}	,;
{ "Alt.Vencto"	,"u_Altera()"	,0	,3	,0	,.T.	}	,;   //						{ "Incluir"	,"At120Incl"	,0	,3	,0	,.T.	}	,;
{ "Legenda" ,"u_LEGD1()"     , 0, 5 } }
//{ "Alterar"	,"At120Alte"	,0	,4	,0	,.T.	}	,;
//{ "Excluir"	,"At120Excl"	,0	,2	,0	,.T.	}	,;

Return(aRotina)
/*

Local oSize

// Calcula as dimensoes dos objetos

oSize := FwDefSize():New( .T. ) // Com enchoicebar
oSize:lLateral     := .F.  // Calculo vertical

// adiciona Enchoice

oSize:AddObject( "ENCHOICE", 100, 60, .T., .T. ) // Adiciona enchoice

// adiciona folder

oSize:AddObject( "FOLDER",100, 100, .T., .T. ) // Adiciona Folder

// Dispara o calculo
oSize:Process()

// Desenha a dialog

DEFINE MSDIALOG oDlgEsp TITLE STR0001 FROM ;

oSize:aWindSize[1],oSize:aWindSize[2] TO ;

oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

// Monta a Enchoice

oEnChoice:=MsMGet():New( cAlias, nReg, nOpc,,,,,;

{oSize:GetDimension("ENCHOICE","LININI"),;

oSize:GetDimension("ENCHOICE","COLINI"),;

oSize:GetDimension("ENCHOICE","LINEND"),;

oSize:GetDimension("ENCHOICE","COLEND")};

, , 3, , , , , ,.T. )



// Monta o Objeto Folder

oFolder:=TFolder():New( oSize:GetDimension("FOLDER","LININI"),;

oSize:GetDimension("FOLDER","COLINI"),aTitles,aPages,oDlgEsp,,,,.T.,;

.T.,oSize:GetDimension("FOLDER","XSIZE"),;

oSize:GetDimension("FOLDER","YSIZE"))



// Cria a dimensão das getdados, diminuindo um pouco da área do folder //devido ao titulo da pasta e bordas do objeto

aPosGetD := { 3, 3, oSize:GetDimension("FOLDER","YSIZE") - 16, oSize:GetDimension("FOLDER","XSIZE") - 4 }

//desenha a getdados

o2Get:=MSGetDados():New( aPosGetD[1] ,aPosGetD[2],aPosGetD[3],;

aPosGetD[4],nOpc,"At250LinOk( 2 )",'AllWaysTrue',"+AAO_ITEM",.T.,,,,;

MAXGETDAD,,,,,oFolder:aDialogs[2])

*/
User Function LegD1()

aLegenda := { { "BR_AZUL"    , "Bx.Parcial" },;
{ "BR_VERDE"   , "Aberto"},;
{ "BR_VERMELHO", "Pago"} }

BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return .t.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Altera    º Autor ³ Luiz Eduardo       º Data ³  23/07/2020 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍmÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gravacao da alteração do vencimento		                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function Altera()

Local _cPAOpen		:= ""
Local _lReturn		:= .t.
Local _nIndice		:= 1
Private cDesc		:= Space(10)
Private aAreaAnt	:= GetArea()
Private oDlg3

DEFINE FONT _oFonte1 NAME "Arial" BOLD
DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD

If e2_saldo=0
	MsgAlert("Atenção, Título já baixado. Favor verificar!")
	_lReturn:= .f.
Endif

If _lReturn
	
	DbSelectArea("SD1")
	dbSetOrder(1)
	Dbseek(se2->(E2_FILORIG+E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA))
	DbSelectArea("SC7")
	dbSetOrder(1)
	Dbseek(se2->E2_FILORIG+sd1->D1_PEDIDO)
	DbSelectArea("SA2")
	SA2->( Dbsetorder(1) )
	SA2->( Dbseek(xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA) ) )
	dVenc:=SE2->E2_VENCREA
	
	@ 50,42 TO 510,875 DIALOG oDlg3 TITLE "Alteração Vencimento Título"
	
		@ 011,010 Say "Numero: " FONT _oFonte1 OF oDlg3 PIXEL
		@ 011,080 Say SE2->E2_NUM SIZE 40,10 PIXEL
		

		@ 028,010 Say "Fornec.:" FONT _oFonte1 OF oDlg3 PIXEL
		@ 027,080 Say SE2->E2_FORNECE SIZE 40,12 PIXEL
		@ 27,118 Say SA2->A2_LOJA PIXEL
		@ 27,135 Say SA2->A2_NOME PIXEL
		
		@ 044,010 Say "Centro de Custo: " FONT _oFonte1 OF oDlg3 PIXEL
		@ 043,080 Say SD1->D1_CC SIZE 40,10 PIXEL
		CTT->(DbSeek(xFilial("CTT")+SD1->D1_CC))
		@ 043,135 Say CTT->CTT_DESC01 SIZE 120,020 PIXEL
		
		@ 078,010 Say "Produto: " FONT _oFonte1 PIXEL
		SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
		cDesc := AllTRim(SD1->D1_COD)+" - "+AllTRim(SB1->B1_DESC)
		@ 078,080 Say cDesc SIZE 200,20 PIXEL //WHEN .F. PIXEL

		@ 090,010 Say "Descrição : " FONT _oFonte1 PIXEL
		@ 090,080 Say SC7->C7_OBS SIZE 200,008 PIXEL //WHEN .F. PIXEL

		@ 102,010 Say "Usuário : " FONT _oFonte1 PIXEL
		@ 102,080 Say SC7->C7_USUARIO + "-" + SC7->C7_CONTATO SIZE 200,008 PIXEL //WHEN .F. PIXEL
      
		@ 163,010 Say "Pedido de Compra:" FONT _oFonte1 PIXEL
		@ 163,080 Say SD1->D1_PEDIDO PIXEL
		
		@ 163,150 Say "Valor:" FONT _oFonte1 PIXEL
		@ 163,200 Say SE2->E2_VALOR PICTURE "@E 999,999,999.99" PIXEL
		
		@ 163,290 Say "Vencimento :" FONT _oFonte1 PIXEL
		@ 163,345 Get dVenc PIXEL
		
		@ 214,345 BMPBUTTON TYPE 1 ACTION Eval( {|| Altven(), oDlg3:End() } )
		@ 214,383 BMPBUTTON TYPE 2 ACTION (oDlg3:End())
	
	ACTIVATE DIALOG oDlg3 CENTERED
	
EndIF

RestArea(aAreaAnt)

Return( _lReturn )


Static Function Altven()


If MsgYesNo("Confirma alteração do vencimento","ATENÇÃO","YESNO")
	RecLock("SE2",.f.)
	SE2->E2_VENCREA := dVenc
	SE2->E2_USUALIB := cUsername
	MsUnLock()
	MsgAlert("Vencimento Alterado")
EndIf
Return

