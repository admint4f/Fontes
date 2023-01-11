#include "rwmake.ch"
#include "protheus.ch"
#include "ap5mail.ch"
#include "TopConn.ch"
#DEFINE  NUMITENS 999
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � T4FLIBTIT� Autor � Luiz Eduardo Tapaj�s  � Data � 06/08/19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Tela para libera��o de t�tulos				              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFIN                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/

User Function T4FLIBTIT( cRotina )

Local aFixe := {}
Local aStruct
Local aCores
Local cFilter := " "

Local cArqTrab
Local cCond
Local cIndexKey

Private aRotina := MenuDef()
Private cCadastro := "Libera��o de T�tulos"
Private aCores    := { { "E2_MSBLQL<>'1' .and. STRZERO(E2_SALDO,1)<>'0'", 'BR_VERDE' },;
{ "STRZERO(E2_SALDO,1)=='0'", 'BR_VERMELHO' },;
{ "E2_MSBLQL='1'", 'BR_AZUL' } }
cAprov := GetMV("MV_USRINSS")  // Par�metro  criado contendo os usu�rios aptos a utilizar a rotina
if !RetCodUsr()$cAprov
//	ApMsgInfo("Esse Usuario nao esta cadastrado para aprova��o de t�tulos do INSS ","Atencao")
//	Return
Endif
//001479(Thiago)-001100(Soraia) 

//Private aCores    := { { "empty(E2_DATALIB)", 'BR_VERDE' },;
//{ "STRZERO(E2_SALDO,1)=='0'", 'BR_VERMELHO' },;
//{ "!empty(E2_DATALIB)", 'BR_AZUL' } }

If ValType( cRotina ) <> "C"
	
	If MsgYesNo("Mostrar APENAS titulos bloqueados ? ","ATEN��O","YESNO")
//		cFilter := "E2_INSS<>0 AND E2_MSBLQL='1' "//.AND. E2_SALDO <>0 "
		cFilter := "E2_MSBLQL='1' "//.AND. E2_SALDO <>0 "
	Else
		cFilter := "E2_INSS<>0 OR E2_XPLACA='BLOQ' "//.AND. E2_SALDO <>0 "
	Endif
	
	//	mBrowse( 6, 1, 22, 75, "SE2" )
	mBrowse( 6, 1, 22, 75, "SE2",,,,,, aCores,,,,,,,,cFilter)
Else
	//��������������������������������������������������������������Ŀ
	//� Tratamento para chamada de outra rotina                      �
	//����������������������������������������������������������������
	If !Empty( nScan := AScan( aRotina, { |x| x[2] == cRotina } ) )
		cRoda := cRotina + "( 'SE2', SE2->( Recno() ), " + Str( nScan, 2 ) + ") "
		Eval( { || &( cRoda ) } )
	EndIf
EndIf

Return( nil )

/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MenuDef  � Autor � Luiz Eduardo          � Data � 06.08.19 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Defini��o do aRotina (Menu funcional)                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MenuDef()                                                  ���
�����������������������������������������������������������������������������
/*/
Static Function MenuDef()
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
Local aRotina := {	{ "Pesquisar"	,"AxPesqui"		,0	,1	,0	,.F.	}	,;
{ "Aprovar"	,"u_Aprova()"	,0	,3	,0	,.T.	}	,;   //						{ "Incluir"	,"At120Incl"	,0	,3	,0	,.T.	}	,;
{ "Bloquear","u_bloq"	,0	,4	,0	,.T.	}	,;
{ "Legenda" ,"u_LEGD()"     , 0, 5 } }
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



// Cria a dimens�o das getdados, diminuindo um pouco da �rea do folder //devido ao titulo da pasta e bordas do objeto

aPosGetD := { 3, 3, oSize:GetDimension("FOLDER","YSIZE") - 16, oSize:GetDimension("FOLDER","XSIZE") - 4 }

//desenha a getdados

o2Get:=MSGetDados():New( aPosGetD[1] ,aPosGetD[2],aPosGetD[3],;

aPosGetD[4],nOpc,"At250LinOk( 2 )",'AllWaysTrue',"+AAO_ITEM",.T.,,,,;

MAXGETDAD,,,,,oFolder:aDialogs[2])

*/
User Function LegD()

aLegenda := { { "BR_AZUL"    , "Bloqueado" },;
{ "BR_VERDE"   , "Liberado"},;
{ "BR_VERMELHO", "Pago"} }

BRWLEGENDA( cCadastro, "Legenda", aLegenda )

Return .t.

//Aprov
//-----------------------------------------//
User Function Aprov( cAlias, nReg, nOpcx )

Local bCode
Local cTitle := "Aprova��o pelo usu�rio : "+alltrim(SUBSTR(CUSUARIO,7,15))
Local oDlg

Do case
	Case e2_saldo=0
		MsgAlert("Aten��o, T�tulo j� baixado. Favor verificar!")
	Case e2_inss=0
		MsgAlert("Aten��o, Opera��o permitida apenas para t�tulos que geraram INSS. Favor verificar!")
		//	Case !empty(e2_datalib)
	Case e2_msblql="2" .or. SE2->E2_MSBLQL=" "
		MsgAlert("Aten��o, Opera��o permitida apenas para t�tulos bloqueados!")
	Otherwise
		If MsgYesNo("Confirma Libera��o ","ATEN��O","YESNO")
			RecLock("SE2",.f.)
			SE2->E2_XPLACA := " "
			SE2->E2_MSBLQL := "2"
			SE2->E2_USUALIB := cUsername
			SE2->E2_CODAPRO := Fa006User( __cUserId, .F., 2 )
			MsUnLock()
			MsgAlert("T�tulo liberado")
		EndIf
EndCase
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Aprova    � Autor � Luiz Eduardo       � Data �  05/09/19   ���
��������������������������m����������������������������������������������͹��
���Descricao � Gravacao da aprovacao da solicitacao de PA                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Aprova()

Local _cPAOpen		:= ""
Local _lReturn		:= .t.
Local _nIndice		:= 1
Private cDesc		:= Space(10)
Private aAreaAnt	:= GetArea()
Private oDlg3

DEFINE FONT _oFonte1 NAME "Arial" BOLD
DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD

Do case
	Case SE2->e2_saldo=0
		MsgAlert("Aten��o, T�tulo j� baixado. Favor verificar!")
		_lReturn:= .f.
	Case SE2->e2_inss=0 .and. empty(se2->e2_xplaca) 
		MsgAlert("Aten��o, Opera��o permitida apenas para t�tulos bloquados. Favor verificar!")
		_lReturn:= .f.
		//	Case !empty(e2_datalib)
	Case SE2->e2_msblql="2" .or. SE2->E2_MSBLQL=" "
		MsgAlert("Aten��o, Opera��o permitida para t�tulos desbloqueados!")
		_lReturn:= .f.
Endcase
If !_lReturn
	Return
Endif

//aTipoFor := {"Fornecedor","Colaborador","Artista","Troco","Avulso","Presta��o Contas","Reembolso Avulso","Impostos"}

//If Empty(cAprov)
//	MsgBox("Somente os usuarios registrados como APROVADORES podem utilizar esta funcionalidade.","Atencao","ERROR")
//	_lReturn:= .f.
//Endif

If e2_saldo=0
	MsgAlert("Aten��o, T�tulo j� baixado. Favor verificar!")
	_lReturn:= .f.
Endif
If e2_inss=0 .and. empty(e2_xplaca)
	MsgAlert("Aten��o, Opera��o permitida apenas para t�tulos bloqueados. Favor verificar!")
	_lReturn:= .f.
Endif
If e2_msblql="2" .or. SE2->E2_MSBLQL=" "
	MsgAlert("Aten��o, Opera��o permitida apenas para t�tulos bloqueados!")
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
	
	@ 50,42 TO 510,875 DIALOG oDlg3 TITLE "APROVACAO de T�tulo bloqueado "
	
		@ 011,010 Say "Numero: " FONT _oFonte1 OF oDlg3 PIXEL
		@ 011,080 Say SE2->E2_NUM SIZE 40,10 PIXEL
		
//		@ 011,150 Say "Tipo: "   FONT _oFonte1 OF oDlg3 PIXEL
//		@ 011,200 Say RetTipo(_nIndice) PIXEL

		@ 028,010 Say "Fornec.:" FONT _oFonte1 OF oDlg3 PIXEL
		@ 027,080 Say SE2->E2_FORNECE SIZE 40,12 PIXEL
		@ 27,118 Say SA2->A2_LOJA PIXEL
		@ 27,135 Say SA2->A2_NOME PIXEL
		
		@ 044,010 Say "Centro de Custo: " FONT _oFonte1 OF oDlg3 PIXEL
		@ 043,080 Say SD1->D1_CC SIZE 40,10 PIXEL
		CTT->(DbSeek(xFilial("CTT")+SD1->D1_CC))
		@ 043,135 Say CTT->CTT_DESC01 SIZE 120,020 PIXEL
		
//		@ 060,010 Say "Elemento PEP: " FONT _oFonte1 OF oDlg3 PIXEL
//		@ 059,080 Say SD1->D1_ITEMCTA PIXEL
//		CTD->(DbSeek(xFilial("CTD")+SD1->D1_ITEMCTA))
//		@ 059,135 Say CTD->CTD_DESC01 PIXEL

//		@ 078,010 Say "Historico: " FONT _oFonte1 PIXEL
//		@ 076,080 Say SE2->E2_HIST SIZE 200,008 //WHEN .F. PIXEL
		@ 078,010 Say "Produto: " FONT _oFonte1 PIXEL
		SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
		cDesc := AllTRim(SD1->D1_COD)+" - "+AllTRim(SB1->B1_DESC)
		@ 078,080 Say cDesc SIZE 200,20 PIXEL //WHEN .F. PIXEL

		@ 090,010 Say "Descri��o : " FONT _oFonte1 PIXEL
		@ 090,080 Say SC7->C7_OBS SIZE 200,008 PIXEL //WHEN .F. PIXEL

		@ 102,010 Say "Usu�rio : " FONT _oFonte1 PIXEL
		@ 102,080 Say SC7->C7_USUARIO + "-" + SC7->C7_CONTATO SIZE 200,008 PIXEL //WHEN .F. PIXEL
      
//		@ 090,150 To 155,409 PIXEL
//		@ 093,153 Say "Produto: " FONT _oFonte1 PIXEL
//		SB1->(DbSeek(xFilial("SB1")+SD1->D1_COD))
//		cDesc := AllTRim(SD1->D1_COD)+"-"+AllTRim(SB1->B1_DESC)
//		@ 103,153 Say cDesc SIZE 200,008 //WHEN .F. PIXEL
//		@ 103,153 Get cDesc MEMO  SIZE 253,049	WHEN .F.  Pixel Of oDlg3
	
		@ 163,010 Say "Pedido de Compra:" FONT _oFonte1 PIXEL
		@ 163,080 Say SD1->D1_PEDIDO PIXEL
		
		@ 163,150 Say "Valor:" FONT _oFonte1 PIXEL
		@ 163,200 Say SE2->E2_VALOR PICTURE "@E 999,999,999.99" PIXEL
		
		@ 163,290 Say "Vencimento :" FONT _oFonte1 PIXEL
		@ 163,345 Get dVenc PIXEL
		
		@ 214,345 BMPBUTTON TYPE 1 ACTION Eval( {|| AprPA(), oDlg3:End() } )
		@ 214,383 BMPBUTTON TYPE 2 ACTION (oDlg3:End())
	
	ACTIVATE DIALOG oDlg3 CENTERED
	
EndIF

// Restaura Area Anterior
RestArea(aAreaAnt)

Return( _lReturn )

// Aprova T�tulo INSS

Static Function AprPA()


If MsgYesNo("Confirma Libera��o do pagamento","ATEN��O","YESNO")
	RecLock("SE2",.f.)
	SE2->E2_VENCREA := dVenc
	SE2->E2_XPLACA := " "
	SE2->E2_MSBLQL := "2"
	SE2->E2_USUALIB := cUsername
	SE2->E2_CODAPRO := Fa006User( __cUserId, .F., 2 )
	MsUnLock()
	MsgAlert("T�tulo liberado")
EndIf
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Bloqueia  � Autor � Luiz Eduardo       � Data �  05/09/19   ���
��������������������������m����������������������������������������������͹��
���Descricao � Bloqueio da T�tulo INSS									  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Bloq()

Local _cPAOpen		:= ""
Local _lReturn		:= .t.
Local _nIndice		:= 1
Private cDesc		:= Space(10)
Private aAreaAnt	:= GetArea()
Private oDlg3

DEFINE FONT _oFonte1 NAME "Arial" BOLD
DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD

Do case
	Case SE2->e2_saldo=0
		MsgAlert("Aten��o, T�tulo j� baixado. Favor verificar!")
		_lReturn:= .f.
	Case SE2->e2_inss=0 .AND. empty(SE2->e2_xplaca) 
		MsgAlert("Aten��o, Opera��o permitida apenas para t�tulos bloqueados. Favor verificar!")
		_lReturn:= .f.
		//	Case !empty(e2_datalib)
	Case SE2->e2_msblql="1" .or. SE2->E2_MSBLQL=" "
		MsgAlert("Aten��o, Opera��o permitida apenas para t�tulos liberados!")
		_lReturn:= .f.
Endcase
If !_lReturn
	Return
Endif

//aTipoFor := {"Fornecedor","Colaborador","Artista","Troco","Avulso","Presta��o Contas","Reembolso Avulso","Impostos"}

//If Empty(cAprov)
//	MsgBox("Somente os usuarios registrados como APROVADORES podem utilizar esta funcionalidade.","Atencao","ERROR")
//	_lReturn:= .f.
//Endif

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
	
	@ 50,42 TO 510,875 DIALOG oDlg3 TITLE "Bloqueio de T�tulo que gerou INSS "
	
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

		@ 090,010 Say "Descri��o : " FONT _oFonte1 PIXEL
		@ 090,080 Say SC7->C7_OBS SIZE 200,008 PIXEL //WHEN .F. PIXEL

		@ 102,010 Say "Usu�rio : " FONT _oFonte1 PIXEL
		@ 102,080 Say SC7->C7_USUARIO + "-" + SC7->C7_CONTATO SIZE 200,008 PIXEL //WHEN .F. PIXEL
      
		@ 163,010 Say "Pedido de Compra:" FONT _oFonte1 PIXEL
		@ 163,080 Say SD1->D1_PEDIDO PIXEL
		
		@ 163,150 Say "Valor:" FONT _oFonte1 PIXEL
		@ 163,200 Say SE2->E2_VALOR PICTURE "@E 999,999,999.99" PIXEL
		
		@ 163,290 Say "Vencimento :" FONT _oFonte1 PIXEL
		@ 163,345 Say SE2->E2_VENCREA PIXEL
		
		@ 214,345 BMPBUTTON TYPE 1 ACTION Eval( {|| BlqTit(), oDlg3:End() } )
		@ 214,383 BMPBUTTON TYPE 2 ACTION (oDlg3:End())
	
	ACTIVATE DIALOG oDlg3 CENTERED
	
EndIF

// Restaura Area Anterior
RestArea(aAreaAnt)

Return( _lReturn )

// Bloqueia T�tulo INSS

Static Function BlqTit()


If MsgYesNo("Confirma bloqueio do pagamento","ATEN��O","YESNO")
	RecLock("SE2",.f.)
	SE2->E2_XPLACA := "BLOQ"
	SE2->E2_MSBLQL := "1"
	SE2->E2_USUALIB := cUsername+"-Blq"
//	SE2->E2_CODAPRO := Fa006User( __cUserId, .F., 2 )
	MsUnLock()
	MsgAlert("T�tulo bloqueado")
EndIf
Return
