#include "rwmake.ch" 
#include "protheus.ch"
#include "colors.CH"          
#include "topconn.ch"

#DEFINE _EOL chr(13) + chr(10)  // Pula a linha.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CadSX5   บ Autor ณ Felipe Raposo      บ Data ณ  05/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Monta browser do cadastro de tabelas somente com registros บฑฑ
ฑฑบ          ณ da tabela passada por parametro.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _cTabelaP - tabela que sera navegada.                      บฑฑ
ฑฑบ          ณ _cDescr1P - descricao do campo X5_CHAVE.                   บฑฑ
ฑฑบ          ณ _cDescr2P - descricao do campo X5_DESCRI.                  บฑฑ
ฑฑบ          ณ _cValidP  - validacao da inclusao ou alteracao de registro.บฑฑ
ฑฑบ          ณ _cVldExcP - validacao da exclusao de registro.             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CadSX5(_cTabelaP, _cDescr1P, _cDescr2P, _cValidP, _cVldExcP, _cPict1P, _cPict2P)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aArea    := U_GetArea({"SX5"})
Local _cArquivo := CriaTrab(nil, .F.)
Local _cIndice  := SX5->(IndexKey(1))  // Indice 1 => X5_FILIAL, X5_TABELA, X5_CHAVE.
Local _cFiltro  := "X5_FILIAL == '" + xFilial("SX5") + "' .and. X5_TABELA == '" + _cTabelaP + "'"
Local _aCampos  := {{_cDescr1P, "X5_CHAVE", _cPict1P}, {_cDescr2P, "X5_DESCRI", _cPict2P}}
Private _cTabela := _cTabelaP
Private _cDescr1 := U_ValPad(_cDescr1P, Posicione("SX3", 2, "X5_CHAVE",  "X3_TITULO"))
Private _cDescr2 := U_ValPad(_cDescr2P, Posicione("SX3", 2, "X5_DESCRI", "X3_TITULO"))
Private _cValid  := U_ValPad(_cValidP,  "AlwaysTrue()")
Private _cVldExc := U_ValPad(_cVldExcP, "AlwaysTrue()")
Private _cPict1  := U_ValPad(_cPict1P, "@!")
Private _cPict2  := U_ValPad(_cPict2P, "@!")
Private aRotina, cAlias := "SX5", cCadastro := Posicione("SX5", 1, xFilial("SX5") + "00" + _cTabela, "AllTrim(X5_DESCRI)")

// Filtra somente a tabela necessaria.
IndRegua(cAlias, _cArquivo, _cIndice,, _cFiltro, "Selecionando registros...")

// Monta menu de rotinas.
aRotina := {;
{"Pesquisar",  "U_CadSX5a", 0, 1},;
{"Visualizar", "U_CadSX5a", 0, 2},;
{"Incluir",    "U_CadSX5a", 0, 3},;
{"Alterar",    "U_CadSX5a", 0, 4},;
{"Excluir",    "U_CadSX5a", 0, 5}}

// Acerta o indice da tabela.
SX5->(dbSetOrder(1))  // X5_FILIAL, X5_TABELA, X5_CHAVE.

// Monta browser de registros.
mBrowse(06, 01, 22, 75, cAlias, _aCampos)

// Limpa o filtro.
dbSelectArea(cAlias)
Set Filter To
U_RestArea(_aArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CadSX5a  บ Autor ณ Felipe Raposo      บ Data ณ  05/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Abre o registro posicionado para edicao.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ _cAlias  - Alias que esta sendo atualizado.                บฑฑ
ฑฑบ          ณ _nReg    - Registro posicionado.                           บฑฑ
ฑฑบ          ณ _nOpcPar - 2 - visualizar                                  บฑฑ
ฑฑบ          ณ            3 - incluir                                     บฑฑ
ฑฑบ          ณ            4 - alterar                                     บฑฑ
ฑฑบ          ณ            5 - remover                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Utilizado pelo programa U_CadSX5().                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CadSX5a(_cAlias, _nReg, _nOpcPar)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _oDlg1, _oSay1, _oGet1, _oSay2, _oGet2, _oBtnOk, _oBtnCan
Local _cTitulo := IIf(_nOpcPar == 1, "Pesquisa", cCadastro), _nOpcUsr := 2
Local _aObj1, _aObj2, _aObj3, _aObj4, _aObj5
Private INCLUI := (_nOpcPar == 3), ALTERA := (_nOpcPar == 4), EXCLUI := (_nOpcPar == 5)
Private _cVldSis := "IIf(empty(m->X5_CHAVE) .or. empty(m->X5_DESCRI), (MsgAlert('Preencha os campos com valores vแlidos', 'Aten็ใo'), .F.), .T.)"
Private _cVldChv := "ExistChav('SX5', '" + _cTabela + "' + m->X5_CHAVE)"
Private _cValida := IIf(EXCLUI, _cVldExc, IIf(INCLUI .or. ALTERA, _cValid, "AlwaysTrue()"))

// Atualiza as variaveis de memoria.
If str(_nOpcPar, 1) $ "13"  // Se for visualizacao ou inclusao.
	M->X5_CHAVE  := CriaVar("X5_CHAVE",  .F.)
	M->X5_DESCRI := CriaVar("X5_DESCRI", .F.)
Else
	M->X5_CHAVE  := SX5->X5_CHAVE
	M->X5_DESCRI := SX5->X5_DESCRI
Endif

// Posicao dos objetos.
If _nOpcPar == 1  // 1 - Pesquisa.
	_aObj1 := {08, 00, 013, 30}		// _oDlg1
	_aObj2 := {10, 04}				// _oSay1
	_aObj3 := {10, 30, 030, 04}		// _oGet1
	_aObj4 := {25, 60}				// _oBtnOk
	_aObj5 := {25, 90}				// _oBtnCan
Else
	_aObj1 := {08, 00, 017, 56}		// _oDlg1
	_aObj2 := {17, 04}				// _oSay1
	_aObj3 := {27, 04, 030, 04}		// _oGet1
	_aObj4 := {41, 04}				// _oSay2
	_aObj5 := {51, 04, 160, 04}		// _oGet2
Endif

// Monta e exibe a tela.
Define msDialog _oDlg1 title _cTitulo from _aObj1[1], _aObj1[2] to _aObj1[3], _aObj1[4] of oMainWnd
_oSay1 := TSay():New(_aObj2[1], _aObj2[2], {|| _cDescr1}, _oDlg1,,,,,,.T., CLR_BLUE,,,,,,,,)
_oGet1 := TGet():New(_aObj3[1], _aObj3[2], {|u| IIf(PCount() == 0, M->X5_CHAVE, M->X5_CHAVE := u)}, _oDlg1, _aObj3[3], _aObj3[4], _cPict1, {|| &_cVldChv}, CLR_BLACK,,,,, .T., "Chave",, {|| str(_nOpcPar, 1) $ "13"},,,,,,,,,,,)

If _nOpcPar == 1  // 1 - Pesquisa.
	_oBtnOk  := sButton():New(_aObj4[1], _aObj4[2], 1, {|| _nOpcUsr := 1, _oDlg1:End()})
	_oBtnCan := sButton():New(_aObj5[1], _aObj5[2], 2, {|| _nOpcUsr := 2, _oDlg1:End()})
	Activate msDialog _oDlg1 centered
Else
	_oSay2 := TSay():New(_aObj4[1], _aObj4[2], {|| _cDescr2}, _oDlg1,,,,,, .T., CLR_BLUE,,,,,,,,)
	_oGet2 := TGet():New(_aObj5[1], _aObj5[2], {|u| IIf(PCount() == 0, M->X5_DESCRI, M->X5_DESCRI := u)}, _oDlg1, _aObj5[3], _aObj5[4], _cPict2,, CLR_BLACK,,,,, .T., "Descri็ใo",, {|| str(_nOpcPar, 1) $ "34"},,,,,,,,,,,)
	Activate msDialog _oDlg1 centered on init EnchoiceBar(_oDlg1, {|| IIf(&_cVldSis .and. &_cValida, (_nOpcUsr := 1, _oDlg1:End()), nil)}, {|| _nOpcUsr := 2, _oDlg1:End()})
Endif

// Grava os dados na tabela.
If _nOpcUsr == 1
	If _nOpcPar == 1  // 1 - Pesquisa.
		SX5->(dbSeek(xFilial("SX5") + _cTabela + m->X5_CHAVE, .T.))
	ElseIf _nOpcPar > 2
		// Grava o registro.
		RecLock("SX5", _nOpcPar == 3)
		
		// Verifica se eh para excluir.
		If _nOpcPar == 5  // 5 - Excluir.
			SX5->(dbDelete())
		Else
			SX5->X5_FILIAL := xFilial("SX5")
			SX5->X5_TABELA := _cTabela
			SX5->X5_CHAVE  := m->X5_CHAVE
			SX5->(X5_DESCRI := X5_DESCSPA := X5_DESCENG := m->X5_DESCRI)
		Endif
		SX5->(msUnLock())
	Endif
Endif
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ VerAlias บ Autor ณ Felipe Raposo      บ Data ณ  22/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Verifica se o alias passado por parametro esta aberto ou   บฑฑ
ฑฑบ          ณ nao. Se nao estiver, a funcao abre.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _cAlias - alias que sera aberto.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function VerAlias(_cAlias)

// Verifica se o alias esta aberto.
If !(_cAlias $ cArqTab)
	// Se nao estiver, abre.
	ChkFile(_cAlias, .F.)
Endif

// Seleciona o alias.
dbSelectArea(_cAlias)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Gatilho  บ Autor ณ Felipe Raposo      บ Data ณ  22/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Executa os gatilhos cadastrados referentes ao campo passa- บฑฑ
ฑฑบ          ณ do por parametro.                                          บฑฑ
ฑฑบ          ณ Essa funcao so executa gatilhos do tipo "P" (primario).    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _cCampo  - campo que tera os gatilhos disparados.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function Gatilho(_cCampo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nAux1, _aAreas := U_GetArea({"SX3", "SX7"})
Private _cCDomin, _cRegra

// Posiciona o campo que tera os gatilhos disparados.
If !empty(U_ValPad(_cCampo, ""))
	SX3->(dbSetOrder(2))  // X3_CAMPO.
	If SX3->(dbSeek(upper(AllTrim(_cCampo)), .F.))
		_cCampo := SX3->X3_CAMPO
	Endif
ElseIf !empty(SX3->X3_CAMPO)
	_cCampo := SX3->X3_CAMPO
Endif

// Testa se o campo possui gatilhos.
If SX3->(!eof() .and. X3_TRIGGER == "S") .and. !empty(_cCampo)
	// Posiciona o cadastro de gatilhos.
	SX7->(dbSetOrder(1))  // X7_CAMPO + X7_SEQUENC.
	SX7->(dbSeek(SX3->X3_CAMPO, .F.))
	
	// Processa todos os gatilhos do campo.
	Do While SX7->(!eof()) .and. SX7->X7_CAMPO == _cCampo
		
		// Analisa a condicao do gatilho antes de processa-lo.
		If SX7->X7_TIPO == "P"
			
			// Posiciona o alias, se necessario.
			If SX7->X7_SEEK == "S"
				dbSelectArea(SX7->X7_ALIAS)
				dbSetOrder(SX7->X7_ORDEM) // Atencao (UPDXFUN).
				dbSeek(&(SX7->X7_CHAVE), .F.)
			Endif
			
			// Faz a validacao do gatilho antes de atualizar o contra-dominio.
			If (empty(SX7->X7_CONDIC) .or. &(SX7->X7_CONDIC))
				// Executa a regra do gatilho.
				_cCDomin := SX7->X7_CDOMIN
				_cRegra  := SX7->X7_REGRA
				m->(&_cCDomin) := &_cRegra
				
				// Se o gatilho for executado pela aCols, atualiza a aCols tambem.
				If Type("aHeader") == "A" .and. (_nAux1 := GdFieldPos(_cCDomin)) != 0
					aCols[n, _nAux1] := m->(&_cCDomin)
				Endif
			Endif
		Endif
		
		// Processa o proximo gatilho.
		SX7->(dbSkip())
	EndDo
Endif

// Restaura as condicoes anteriores dos alias.
U_RestArea(_aAreas)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AjustaX1 บ Autor ณ Felipe Raposo      บ Data ณ  13/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ajusta a tabela de perguntas (SX1) de acordo com os para-  บฑฑ
ฑฑบ          ณ metros passados.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ _cPerg - grupo das perguntas passadas.                     บฑฑ
ฑฑบ          ณ _aAjustaX1 - matriz com as perguntas de acordo com o lay-  บฑฑ
ฑฑบ          ณ              out abaixo:                                   บฑฑ
ฑฑบ          ณ    1 - Ordem da pergunta (obrigatorio)                     บฑฑ
ฑฑบ          ณ    2 - Descricao da pergunta (obrigatorio)                 บฑฑ
ฑฑบ          ณ    3 - Objeto  =>   C=Combo / G=Get (obrigatorio)          บฑฑ
ฑฑบ          ณ    4 - Array com opcoes do parametro (obrigatorio)         บฑฑ
ฑฑบ          ณ      No caso de Get (texto):                               บฑฑ
ฑฑบ          ณ        4.1 - Tipo  =>  C=Caracter / N=Numerico / D=Data    บฑฑ
ฑฑบ          ณ        4.2 - Tamanho (obrigatorio, exceto em campo data)   บฑฑ
ฑฑบ          ณ        4.3 - Decimal (opcional)                            บฑฑ
ฑฑบ          ณ        4.4 - Consulta padrao F3 (opcional)                 บฑฑ
ฑฑบ          ณ        4.5 - Validacao do Get                              บฑฑ
ฑฑบ          ณ      No caso de Combo:                                     บฑฑ
ฑฑบ          ณ        4.1 - Selecao padrao (opcional)                     บฑฑ
ฑฑบ          ณ        4.2 - Opcao 1 em portugues (obrigatorio)            บฑฑ
ฑฑบ          ณ        4.3 - Opcao 2 em portugues (obrigatorio)            บฑฑ
ฑฑบ          ณ        4.4 - Opcao 3 em portugues (opcional)               บฑฑ
ฑฑบ          ณ        4.5 - Opcao 4 em portugues (opcional)               บฑฑ
ฑฑบ          ณ        4.6 - Opcao 5 em portugues (opcional)               บฑฑ
ฑฑบ          ณ    5 - Help do parametro em portugues (opcional)           บฑฑ
ฑฑบ          ณ    6 - Help do parametro em ingles (opcional)              บฑฑ
ฑฑบ          ณ    7 - Help do parametro em espanhol (opcional)            บฑฑ
ฑฑบ          ณ        Esses tres parametros de help deverao ser matrizes  บฑฑ
ฑฑบ          ณ        contendo as linhas do help.                         บฑฑ
ฑฑบ          ณ        Ex: {"linha 1", "linha 2", "linha 3"}               บฑฑ
ฑฑบ          ณ _lRefaz - sobrescreve as perguntas existentes (.T./.F.)?   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function AjustaX1(_cPerg, _aAjustaX1, _lRefaz)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nAux1, _lAchou
Local _cKey, _aHelpPor, _aHelpEng, _aHelpSpa

// Acerta os valores padroes dos parametros.
_cPerg  := PadR(_cPerg, 10, " ")  // Completa espacos caso _cPerg tenha menos que 6 caracteres.
_lRefaz := U_ValPad(_lRefaz, .F.)

// Acerta a tabela SX1.
SX1->(dbSetOrder(1))  // X1_GRUPO, X1_ORDEM.
For _nAux1 := 1 to len(_aAjustaX1)
	
	// Posiciona o registro da pergunta e o abre para alteracao.
	// Se nao encontrar o registro, cria um novo.
	_lAchou := SX1->(dbSeek(_cPerg + _aAjustaX1[_nAux1, 1], .F.))
	RecLock("SX1", !_lAchou)  // Abre registro para edicao ou cria novo registro.
	
	// Atualiza a descricao da pergunta.
	SX1->X1_PERGUNT := _aAjustaX1[_nAux1, 2]
	
	// Se for inclusao ou esta marcado para refazer de qualquer jeito,
	// o sistema atualiza os outros campos.
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := _aAjustaX1[_nAux1, 1]
	SX1->X1_GSC     := _aAjustaX1[_nAux1, 3]
	If _aAjustaX1[_nAux1, 3] == "G"  // Get (texto).
		SX1->X1_TIPO    := _aAjustaX1[_nAux1, 4, 1]
		SX1->X1_TAMANHO := IIf(_aAjustaX1[_nAux1, 4, 1] == "D", 8, _aAjustaX1[_nAux1, 4, 2])
		SX1->X1_DECIMAL := IIf(len(_aAjustaX1[_nAux1, 4]) >= 3 .and. _aAjustaX1[_nAux1, 4, 1] == "N", _aAjustaX1[_nAux1, 4, 3], 0)
		SX1->X1_F3      := IIf(len(_aAjustaX1[_nAux1, 4]) >= 4, _aAjustaX1[_nAux1, 4, 4], "")
		SX1->X1_VALID   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 5, _aAjustaX1[_nAux1, 4, 5], "")		
		If !_lAchou .or. _lRefaz
			SX1->X1_CNT01 := ""  // Cria com conteudo em branco.
		Endif
	ElseIf _aAjustaX1[_nAux1, 3] == "C"  // Combo.
		SX1->X1_TIPO    := "N"  // Numerico.
		SX1->X1_TAMANHO := 01
		SX1->X1_DECIMAL := 00
		If !_lAchou .or. _lRefaz
			SX1->X1_PRESEL := U_ValPad(_aAjustaX1[_nAux1, 4, 1], 1)  // Nao obrigatorio.
		Endif
		SX1->X1_DEF01   := _aAjustaX1[_nAux1, 4, 2]  // Obrigatorio.
		SX1->X1_DEF02   := _aAjustaX1[_nAux1, 4, 3]  // Obrigatorio.
		SX1->X1_DEF03   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 4, _aAjustaX1[_nAux1, 4, 4], "")  // Nao obrigatorio.
		SX1->X1_DEF04   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 5, _aAjustaX1[_nAux1, 4, 5], "")  // Nao obrigatorio.
		SX1->X1_DEF05   := IIf(len(_aAjustaX1[_nAux1, 4]) >= 6, _aAjustaX1[_nAux1, 4, 6], "")  // Nao obrigatorio.
	Endif
	
	// Monta o help para o item.
	_aHelpPor := IIf(len(_aAjustaX1[_nAux1]) >= 5, aClone(_aAjustaX1[_nAux1, 5]), {})
	_aHelpEng := IIf(len(_aAjustaX1[_nAux1]) >= 6, aClone(_aAjustaX1[_nAux1, 6]), {})
	_aHelpSpa := IIf(len(_aAjustaX1[_nAux1]) >= 7, aClone(_aAjustaX1[_nAux1, 7]), {})
	If !empty(_aHelpPor) .or. !empty(_aHelpEng) .or. !empty(_aHelpSpa)
		_cKey := "P." + AllTrim(_cPerg) + AllTrim(_aAjustaX1[_nAux1, 1]) + "."
		PutSX1Help(_cKey, _aHelpPor, _aHelpEng, _aHelpSpa)
	Endif
	
	// Salva as alteracoes na tabela.
	SX1->(msUnLock())
Next _nAux1
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaLog  บ Autor ณ Felipe Raposo      บ Data ณ  06/11/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria o arquivo de log na pasta \LOG.                       บฑฑ
ฑฑบ          ณ Caso o arquivo ja exista, apenas o abre.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ _cArquivo - nome do arquivo a ser aberto ou criado.        บฑฑ
ฑฑบ          ณ _lCabec   - indica se a mensagem de abertura ou criacao do บฑฑ
ฑฑบ          ณ             arquivo de log deve ser gravada.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Numero do arquivo aberto.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function CriaLog(_cArquivo, _lCabec)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nHd, _cArqLog
Local _nAux1, _cMsg
Local _cDir := "\" + CurDir()

// Acerta valores padroes dos parametros.
_lCabec := U_ValPad(_lCabec, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o arquivo de log.                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Separa o arquivo do diretorio.
_cArquivo := StrTran(_cArquivo, "/", "\")  // Substitui as barras normais pelas invertidas.
If (_nAux1 := rat("\", _cArquivo)) != 0  // Separa o caminho (path) do nome do arquivo.
	_cAux1    := AllTrim(left(_cArquivo, _nAux1))
	_cAux1    := IIf(left(_cAux1, 1) == "\", right(_cAux1, len(_cAux1) - 1), _cAux1)
	_cDir     += _cAux1
	_cArquivo := AllTrim(right(_cArquivo, len(_cArquivo) - _nAux1))
Endif

// Cria o arquivo log com extensao .LOG no diretorio \LOGS.
_cArqLog := _cDir + "Logs\" + IIf((_nAux1 := at(".", _cArquivo)) == 0, _cArquivo, SubStr(_cArquivo, 1, _nAux1 - 1)) + ".LOG"
If file(_cArqLog)  // Cria um arquivo de log novo se ja nao existir.
	_nHd  := fOpen(_cArqLog, 2)  // Abre o arquivo para edicao.
	_cMsg := _EOL + _EOL + "*** Arquivo de log reaberto em " + dtoc(dDataBase) + ", เs " + time() + " ***" + _EOL
Else
	_nHd  := fCreate(_cArqLog)   // Cria o arquivo novo.
	_cMsg := "*** Arquivo de log criado em " + dtoc(dDataBase) + ", เs " + time() + " ***" + _EOL
Endif
If _lCabec
	fSeek(_nHd, 0, 2)    // Vai para o fim do arquivo.
	fWrite(_nHd, _cMsg)  // Grava a mensagem no arquivo de log.
Endif
//

Return(_nHd)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValPad   บ Autor ณ Felipe Raposo      บ Data ณ  08/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna um valor padrao para a variavel, caso ela nao      บฑฑ
ฑฑบ          ณ tenha valor ainda.                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _uValor  - valor original. O que sera comparado.           บฑฑ
ฑฑบ          ณ _uValPad - caso o valor original seja invalido, sera retor-บฑฑ
ฑฑบ          ณ            nado o valor passado nesse parametro.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Sera retornado o valor original, caso esse seja validado;  บฑฑ
ฑฑบ          ณ senao sera retornado o valor padrao (segundo parametro).   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ValPad(_uValor, _uValPad)
Return(IIf(ValType(_uValor) == ValType(_uValPad), _uValor, _uValPad))


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TamBytes บ Autor ณ Felipe Raposo      บ Data ณ  11/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna o valor passado no 1o parametro, ja formatado em   บฑฑ
ฑฑบ          ณ caracter ou numerico, de acordo com os parametros passados บฑฑ
ฑฑบ          ณ pelo usuario.                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _nTam   - valor original, que sera formatado e retornado.  บฑฑ
ฑฑบ          ณ _cTipo  - indica a grandeza do valor passado. Pode ser:    บฑฑ
ฑฑบ          ณ           B  - bytes (padrao)                              บฑฑ
ฑฑบ          ณ           KB - kilobytes (1024 bytes)                      บฑฑ
ฑฑบ          ณ           MB - megabytes (1024 kilobytes)                  บฑฑ
ฑฑบ          ณ           GB - gigabytes (1024 megabytes)                  บฑฑ
ฑฑบ          ณ           TB - terabytes (1024 gigabytes)                  บฑฑ
ฑฑบ          ณ _nSaida - indica o tipo de retorno da funcao. Pode ser:    บฑฑ
ฑฑบ          ณ           1 - saida caracter. Ex: "7,56 MB" (padrao).      บฑฑ
ฑฑบ          ณ           2 - saida matricial. Ex: {7.56, "MB"}.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function TamBytes(_nTam, _cTipo, _nSaida)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _uRet, _nValSai, _cTpVal

// Acerta os valores padroes das variaveis, caso alguma nao tenha sido passada.
_cTipo  := U_ValPad(upper(_cTipo), "")
_nSaida := U_ValPad(_nSaida, 1)  // Saida padrao: 1 - caracter.
_nTam   := U_ValPad(_nTam, 0)
_nTam   := IIf(_nTam < 0, -_nTam, _nTam)  // Nao aceita valor negativo.

// Trata o valor passado por parametro e transforma em bytes.
Do Case
	Case empty(_cTipo) .or. _cTipo == "B" // Nao fazer nada.
	Case _cTipo == "KB"; _nTam *= 1024
	Case _cTipo == "MB"; _nTam *= (1024 ^ 2)
	Case _cTipo == "GB"; _nTam *= (1024 ^ 3)
	Case _cTipo == "TB"; _nTam *= (1024 ^ 4)
EndCase

// Calcula os valores da saida.
Do Case
	Case _nTam == 1;					_nValSai := _nTam;				_cTpVal := " byte"
	Case _nTam < 1000;	  				_nValSai := _nTam;				_cTpVal := " bytes"
	Case (_nTam / 1024) < 1000;			_nValSai := _nTam / 1024;		_cTpVal := " KB"  // Kilobytes.
	Case (_nTam / (1024 ^ 2)) < 1000;	_nValSai := _nTam / (1024 ^ 2);	_cTpVal := " MB"  // Megabytes.
	Case (_nTam / (1024 ^ 3)) < 1000;	_nValSai := _nTam / (1024 ^ 3);	_cTpVal := " GB"  // Gigabytes.
	OtherWise;							_nValSai := _nTam / (1024 ^ 4);	_cTpVal := " TB"  // Terabytes.
EndCase

// Transforma os valores da saida no formato escolhido.
If _nSaida == 1  // Saida caractere.
	If _nValSai >= (10 ^ 6)  // Se for maior ou igual a 1 milhao.
		_uRet := AllTrim(Transform(_nValSai / (10 ^ 6), "@E 999,999,999.99")) + " milhใo(๕es) de" + _cTpVal
	Else
		_uRet := AllTrim(Transform(_nValSai, IIf("byte" $ _cTpVal, "@E 9,999", "@E 999,999.99"))) + _cTpVal
	Endif
ElseIf _nSaida == 2  // Saida em matriz.
	_uRet := {_nValSai, AllTrim(_cTpVal)}  // 1 - Valor; 2 - Grandeza.
Endif

Return(_uRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Agora    บ Autor ณ Felipe Raposo      บ Data ณ  31/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna a data e a hora correntes no seguinte formato:     บฑฑ
ฑฑบ          ณ  Formato texto                                             บฑฑ
ฑฑบ          ณ  AAAAMMDD - hh:mm:ss                                       บฑฑ
ฑฑบ          ณ Onde:                                                      บฑฑ
ฑฑบ          ณ  AAAA - ano                                                บฑฑ
ฑฑบ          ณ  MM   - mes                                                บฑฑ
ฑฑบ          ณ  DD   - dia                                                บฑฑ
ฑฑบ          ณ  hh   - horas                                              บฑฑ
ฑฑบ          ณ  mm   - minutos                                            บฑฑ
ฑฑบ          ณ  ss   - segundos                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function Agora(_cFormat)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _uRet, _dData, _cHora
Local _dRef, _nDif, _nDias, _nHoras, _nMins, _nSegs

// Atribui um valor padrao ao formato de data.
_cFormat := U_ValPad(_cFormat, "S")

// Busca um valor para a data.
_dData := date()
_cHora  := AllTrim(time())
Do Case
	Case _cFormat == "S"
		_uRet := dtos(_dData) + " - " + _cHora
	Case _cFormat == "C"
		_uRet := dtoc(_dData) + " " + _cHora
	Case _cFormat == "N"
		_dRef   := ctod("01/01/2006")  // Data referencia.
		_nDias  := _dData - _dRef  // Quantidade de dias.
		_nHoras := val(SubStr(_cHora, 1, 2))
		_nMins  := val(SubStr(_cHora, 4, 2))
		_nSegs  := val(SubStr(_cHora, 7, 2))
		_uRet   := (_nDias * 86400) + (_nHoras * 3600) + (_nMins * 60) + _nSegs
EndCase

Return(_uRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TRemain  บ Autor ณ Felipe Raposo      บ Data ณ  01/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna o tempo restante de processamento, de acordo com   บฑฑ
ฑฑบ          ณ os dados passados por parametros.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ _nAtual   - Quantidade de unidades processadas.            บฑฑ
ฑฑบ          ณ _nTotal   - Quantidade de unidades total.                  บฑฑ
ฑฑบ          ณ _cTimeIni - Hora do inicio do processamento.               บฑฑ
ฑฑบ          ณ _cTimeAtu - Hora atual (opcional).                         บฑฑ
ฑฑบ          ณ _cTRemain - Tempo restante calculado na passagem anterior. บฑฑ
ฑฑบ          ณ _nFreq    - Frequencia de atualizacao do cronometro (em    บฑฑ
ฑฑบ          ณ             passagens / unidades).                         บฑฑ
ฑฑบ          ณ _nMedia   - Variavel que contara unidades por segundo.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function TRemain(_nAtual, _nTotal, _cTimeIni, _cTimeAtu, _cTRemain, _nFreq, _nMedia)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cRet, _nSegRest, _nSegIni, _nSegAtu

// Pega a hora atual, caso nao tenha sido passada por parametro.
_cTimeAtu := U_ValPad(_cTimeAtu, time())
_cTRemain := U_ValPad(_cTRemain, "")
_nFreq    := U_ValPad(_nFreq, 1)

// Atualiza o cronometro considerando a frequencia de atualizacao.
If (_nAtual % _nFreq) == 0 .or. _nAtual == 1
	// Converte os tempos iniciais e finais para segundo.
	_nSegIni := HoraToSeg(_cTimeIni)
	_nSegAtu := HoraToSeg(_cTimeAtu) + IIf(_cTimeAtu < _cTimeIni, 86400, 0)  // 24 horas = 86400 segundos.
	
	// Calcula a media de processamento (unidades por segundo).
	// Media = quantidade processada / tempo processado.
	_nMedia := _nAtual / (_nSegAtu - _nSegIni)
	
	// Calcula o tempo estimado para o processamento das unidades restantes.
	// Tempo restante = quantidade restante / media (resultado em segundos).
	_nSegRest := (_nTotal - _nAtual) / _nMedia
	
	// Converte tudo para horas (caracter).
	_cRet := IIf(_nSegRest > 0, SegToHora(_nSegRest), "--:--:--")
Else
	_cRet := _cTRemain
Endif

Return(_cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ TDecor   บ Autor ณ Felipe Raposo      บ Data ณ  01/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Calcula o tempo decorrido, de acordo com os paramentros    บฑฑ
ฑฑบ          ณ passados.                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function TDecor(_cTIni, _cTFim, _lSegs)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _uRet, _nSegIni, _nSegFim

// Desmembra as horas de caractere para numerico.
_nSegIni := HoraToSeg(_cTIni)
_nSegFim := HoraToSeg(_cTFim) + IIf(_cTFim < _cTIni, 86400, 0)  // 86400 segundos tem um dia.
_uRet    := IIf(U_ValPad(_lSegs, .F.), _nSegFim - _nSegIni, SegToHora(_nSegFim - _nSegIni))

Return(_uRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHoraToSeg บ Autor ณ Felipe Raposo      บ Data ณ  01/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Converte o tempo passado por parametro (caracter) para se- บฑฑ
ฑฑบ          ณ gundos (numerico).                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function HoraToSeg(_cTempo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nRet, _nHoras, _nMinutos, _nSegundos

// Desmembra as horas de caractere para numerico.
_nHoras    := val(SubStr(_cTempo, 1, 2))
_nMinutos  := val(SubStr(_cTempo, 4, 2))
_nSegundos := val(SubStr(_cTempo, 7, 2))

// Converte para segundos.
_nRet := (_nHoras * 3600) + (_nMinutos * 60) + _nSegundos

Return(_nRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSegToHora บ Autor ณ Felipe Raposo      บ Data ณ  01/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Converte os segundos passados por parametro (numerico) em  บฑฑ
ฑฑบ          ณ formado de hora (texto hhh:mm:ss).                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function SegToHora(_nSegs)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cRet, _nHoras, _nMinutos, _nSegundos

// Divide os segundos entre horas, minutos e segundos.
_nHoras    := int(_nSegs / 3600)							// Busca as horas.
_nMinutos  := int((_nSegs / 60) % 60)						// Busca os minutos.
_nSegundos := _nSegs - (_nMinutos * 60) - (_nHoras * 3600)	// Busca os segundos.

// Converte para caracter.
_cRet := IIf(_nHoras >= 100, AllTrim(str(_nHoras)), StrZero(_nHoras, 2))	// Horas...
_cRet += ":" + StrZero(_nMinutos, 2) + ":" + StrZero(_nSegundos, 2)		// Minutos e segundos.

Return(_cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GetArea  บ Autor ณ Felipe Raposo      บ Data ณ  26/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna informacoes correntes referentes as areas passadas บฑฑ
ฑฑบ          ณ por parametro.                                             บฑฑ
ฑฑบ          ณ A diferenca dessa funcao para o GetArea() padrao do siste- บฑฑ
ฑฑบ          ณ ma eh que essa funcao pega varios alias de uma vez so, in- บฑฑ
ฑฑบ          ณ clusive o alias selecionado no momento da chamada dessa    บฑฑ
ฑฑบ          ณ funcao.                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GetArea(_aAreas)

// Declaracao de variaveis.
Local _aRet[0]      
Local i     

// Armazena o alias corrente.
Local _aAreaAtu:= GetArea()

// Valores Padroes
_aAreas:= u_ValPad(_aAreas, {_aAreaAtu[1]})

// Adiciona a area corrente na ultima posicao.
// Apenas se nao estiver vazio e se for diferente do ultimo alias que ja veio no parametro.
If !Empty(_aAreaAtu[1]) .And. ( _aAreaAtu[1] != _aAreas[ Len(_aAreas) ] )
	aAdd(_aAreas, _aAreaAtu[1])
EndIf

//Armazena as condicoes dos alias passados por parametro.
For i:= 1 to Len(_aAreas)
    If Select(_aAreas[i]) != 0 .And. !Empty(_aAreas[i])
       DbSelectArea(_aAreas[i])
       AAdd(_aRet,GetArea())
    EndIf   
Next       

// Restaura area anterior.
RestArea(_aAreaAtu)

Return(_aRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RestArea บ Autor ณ Felipe Raposo      บ Data ณ  26/02/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Restaura as areas dos alias passados por parametro. O pa-  บฑฑ
ฑฑบ          ณ rametro passado devera ter sido formado pela funcao de     บฑฑ
ฑฑบ          ณ usuario U_GetArea().                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RestArea(_aAreas)     
Return(aEval(_aAreas, {|x| RestArea(x)}))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ProgLock บ Autor ณ Felipe Raposo      บ Data ณ  06/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Tenta alocar o sistema para a execucao de um programa, paraบฑฑ
ฑฑบ          ณ evitar que um mesmo programa seja executado duas vezes ao  บฑฑ
ฑฑบ          ณ mesmo tempo, ou que um programa nao seja executado enquantoบฑฑ
ฑฑบ          ณ uma outra instancia desse mesmo programa nao tenha termina-บฑฑ
ฑฑบ          ณ do de processar.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParamentroณ _cProg - nome do programa a ser alocado.                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Retorna o numero da alocacao conseguida. Se a funcao nao   บฑฑ
ฑฑบ          ณ conseguir fazer a alocacao, eh retornado o valor 0 (zero). บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ProgLock(_cProg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nRet := 0
Local _cArqCtrl := AllTrim(_cProg) + ".CTR"

// Controle para saber se essa rotina ja esta rodando no servidor.
// Se o arquivo de controla ja estiver no servidor e nao puder ser
// excluido, entao o programa ainda esta em execucao.

// Testa se o arquivo nao existe ou pode ser apagado.
// Se o arquivo existir e o sistema nao conseguir apagar esse arquivo,
// a funcao retorna zero, indicando que o programa ja esta em uso.
If !file(_cArqCtrl) .or. fErase(_cArqCtrl) == 0
	_nRet := fCreate(_cArqCtrl, 0)  // Aloca o programa.
Endif

Return(_nRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณProgUnLockบ Autor ณ Felipe Raposo      บ Data ณ  06/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Desaloca um programa em execucao.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParamentroณ _cProg - nome do programa a ser desalocado.                บฑฑ
ฑฑบ          ณ _nAloc - numero da alocacao                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ProgUnLock(_cProg, _nAloc)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cArqCtrl := AllTrim(_cProg) + ".CTR"

// Fecha e apaga o arquivo de controle.
fClose(_nAloc)
If file(_cArqCtrl)
	fErase(_cArqCtrl)
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvEnch  บ Autor ณ Felipe Raposo      บ Data ณ  29/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava os dados da enchoice na tabela.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ _nOpc   - 2 - visualizar                                   บฑฑ
ฑฑบ          ณ           3 - incluir                                      บฑฑ
ฑฑบ          ณ           4 - alterar                                      บฑฑ
ฑฑบ          ณ           5 - remover                                      บฑฑ
ฑฑบ          ณ _cAlias - alias da tabela que terao os dados gravados.     บฑฑ
ฑฑบ          ณ _nOrdem - indice que sera utilizado na pesquisa.           บฑฑ
ฑฑบ          ณ _cChave - chave de pesquisa para posicionar o registro que บฑฑ
ฑฑบ          ณ           vai ser atualizado.                              บฑฑ
ฑฑบ          ณ _cMsg   - parametro para armazenar qualquer eventual erro. บฑฑ
ฑฑบ          ณ _bExec  - bloco de comandos que sera executado antes da    บฑฑ
ฑฑบ          ณ           gravacao do registro, com o registro bloqueado.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Retorno logico, informando se tudo ocorreu bem.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Eh recomendavel que seja utilizado o controle de transa-   บฑฑ
ฑฑบ          ณ coes para a execucao dessa rotina, e que a transacao seja  บฑฑ
ฑฑบ          ณ desfeita (rollback) caso a rotina retorne valor falso.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GrvEnch(_nOpc, _cAlias, _nOrdem, _cChave, _cMsg, _bExec)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nAux1, _lRet := .T.

// Testa a opcao do usuario.
If U_ValPad(_nOpc, 0) > 2
	
	// Acerta os valores padroes dos parametros.
	_cAlias := U_ValPad(_cAlias, Alias())
	_nOrdem := U_ValPad(_nOrdem, 0)
	_cChave := U_ValPad(_cChave, "")
	
	// Seleciona a tabela e posiciona o registro, se nao for uma inclusao.
	dbSelectArea(_cAlias)
	If _nOpc != 3  // 3 - incluir.
		If !empty(_nOrdem) .and. !empty(_cChave)
			// Acerta os valores padroes dos parametros.
			_nOrdem := U_ValPad(_nOrdem, 1)
			_cChave := U_ValPad(_cChave, xFilial(_cAlias))
			
			// Posiciona o registro.
			dbSetOrder(_nOrdem) // Atencao (UPDXFUN).
			If !dbSeek(_cChave, .F.)
				_cMsg := "Registro nใo encontrato" + _EOL +;
				"Alias..: [" + _cAlias + "]" + _EOL +;
				"Indice.: [" + AllTrim(str(_nOrdem)) + " - " + AllTrim(IndexKey()) + "]" + _EOL +;
				"Chave..: [" + _cChave + "]"
				_lRet := .F.
			Endif
		ElseIf eof()
			_cMsg := "Tentativa de grava็ใo no final da tabela" + _EOL +;
			"Alias.: [" + _cAlias + "]" + _EOL +;
			"Opcao.: [" + IIf(_nOpc == 4, "Alterar", "Remover") + "]"
			_lRet := .F.
		Endif
	Endif
	
	// Testa se nao houve nenhum erro ate agora.
	If _lRet
		// Aloca o registro.
		RecLock(_cAlias, _nOpc == 3)
		
		// Atualiza os campos.
		If _nOpc == 5  // Excluir.
			dbDelete()
		Else
			If _nOpc == 3  // Incluir.
				// Atualiza a filial.
				Private _cFilial := _cAlias + "->" + PrefixoCpo(_cAlias) + "_FILIAL"
				&_cFilial := xFilial(_cAlias)
			Endif
			
			// Atualiza todos os campos.
			aEval(array(FCount()), {|x, y| FieldPut(y, m->&(Field(y)))})
		Endif
		
		// Executa o bloco de comandos, se for passado por parametro.
		If ValType(_bExec) == "B"
			Eval(_bExec)
		Endif
		
		// Grava as alteracoes do registro.
		msUnLock()
	Endif
Endif

Return _lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MontaGD  บ Autor ณ Felipe Raposo      บ Data ณ  06/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Monta as variaveis aCols e aHeader de acordo com os para-  บฑฑ
ฑฑบ          ณ metros passados.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ _nOpc   - 2 - visualizar                                   บฑฑ
ฑฑบ          ณ           3 - incluir                                      บฑฑ
ฑฑบ          ณ           4 - alterar                                      บฑฑ
ฑฑบ          ณ           5 - remover                                      บฑฑ
ฑฑบ          ณ _cAlias - alias referente as variaveis.                    บฑฑ
ฑฑบ          ณ _nOrder - ordem que o sistema devera utilizar para filtrar บฑฑ
ฑฑบ          ณ           os registros que irao para a aCols.              บฑฑ
ฑฑบ          ณ _cSeek  - string utilizada para buscar o primeiro registro บฑฑ
ฑฑบ          ณ           que devera aparecer na aCols.                    บฑฑ
ฑฑบ          ณ _cWhile - condicao para filtrar os registros seguintes que บฑฑ
ฑฑบ          ณ           tambem deverao aparecer na aCols. A diferenca    บฑฑ
ฑฑบ          ณ           desse parametro para o parametro _cFor, eh que o บฑฑ
ฑฑบ          ณ           sistema saira do looping assim que encontrar o   บฑฑ
ฑฑบ          ณ           primeiro registro que nao satisfaca essa condi-  บฑฑ
ฑฑบ          ณ           cao; enquanto que no _cFor, o sistema simples-   บฑฑ
ฑฑบ          ณ           mente pula para o proximo registro.              บฑฑ
ฑฑบ          ณ _cFor   - condicao para filtrar os registros que deverao   บฑฑ
ฑฑบ          ณ           aparecer na aCols. O sistema nao sai do looping  บฑฑ
ฑฑบ          ณ           caso nao satisfaca essa condicao, ao contrario   บฑฑ
ฑฑบ          ณ           do _cWhile.                                      บฑฑ
ฑฑบ          ณ _aInsCpos - campos que serao inseridos no inicio.          บฑฑ
ฑฑบ          ณ _aExcCpos - campos que nao poderao ser inseridos.          บฑฑ
ฑฑบ          ณ _aCampos  - campos que serao considerados. Se esse parame- บฑฑ
ฑฑบ          ณ             tro for passado, todos os campos que nao esti- บฑฑ
ฑฑบ          ณ             verem nesse parametro nao serao considerados.  บฑฑ
ฑฑบ          ณ _cCpoSeq  - campos caracter que sera sequencial na aCols.  บฑฑ
ฑฑบ          ณ             Ex: "C6_ITEM".                                 บฑฑ
ฑฑบ          ณ _lSLock   - indica se os registros retornados serao trava- บฑฑ
ฑฑบ          ณ             dos pelo comando SoftLock().                   บฑฑ
ฑฑบ          ณ _aSLock   - matriz que armazenara os registros travados,   บฑฑ
ฑฑบ          ณ             caso o parametro _lSLock sea passada como true.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Numerico - a quantidade de campos disponiveis na aCols.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ As variaveis aHeader, aCols, n e nUsado precisam ser cria- บฑฑ
ฑฑบ          ณ das como Private ou Public antes da chamada dessa funcao.  บฑฑ
ฑฑบ          ณ O recomendavel eh que elas sejam criadas como Private, paraบฑฑ
ฑฑบ          ณ que sejam eliminadas apos o termino da funcao principal.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function MontaGD(_nOpc, _cAlias, _nOrder, _cSeek, _cWhile, _cFor, _aInsCpos, _aExcCpos, _aCampos, _cCpoSeq, _lSLock, _aSLock)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nAux1, _aAux1, _uAux1
Local _bInsCpo, _bForS, _bForU, _bFor, _bWhile
Local _aArea := GetArea()  // Armazena as informacoes da area corrente.
Private _uCampo

// Monta o bloco que insere os campos na aHeader.
_bInsCpo := {|| SX3->(aAdd(aHeader, {AllTrim(X3Titulo()), X3_CAMPO, X3_PICTURE, X3_TAMANHO,;
X3_DECIMAL, X3_VALID, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT})), nUsado++}

// Atualiza os valores padroes dos parametros.
_cFor     := U_ValPad(_cFor,     "")
_aInsCpos := U_ValPad(_aInsCpos, {})
_aExcCpos := U_ValPad(_aExcCpos, {})
_aCampos  := U_ValPad(_aCampos,  {})
_cCpoSeq  := U_ValPad(_cCpoSeq,  "")
_lSLock   := U_ValPad(_lSLock,  .F.)
_aSLock   := U_ValPad(_aSLock,   {})

// Variavel que contem a linha posicionada na GetDados.
n := 1

// Variavel que contem a quantidade de campos visiveis existente na aCols.
nUsado := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aHeader.                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SX3->(dbSetOrder(2))  // X3_CAMPO.
aHeader := {}
If !empty(_aCampos)
	// Se o usuario definiu os campos manualmente, so serao inseridos esses.
	aEval(_aCampos, {|x| SX3->(dbSeek(x)), Eval(_bInsCpo)})
Else
	// Insere os campos que o usuario solicitou na frente.
	aEval(_aInsCpos, {|x| SX3->(dbSeek(x)), Eval(_bInsCpo)})
	
	// Insere os outros campos.
	SX3->(dbSetOrder(1))
	SX3->(dbSeek(_cAlias))  // X3_ARQUIVO + X3_ORDEM.

	_bForS  := {|| SX3->(X3Uso(X3_USADO) .and. cNivel >= X3_NIVEL)}
	_bForU  := {|| SX3->(GdFieldPos(X3_CAMPO) == 0 .and. aScan(_aExcCpos, {|x| upper(AllTrim(x)) == upper(AllTrim(X3_CAMPO))}) == 0)}
	_bFor   := {|| Eval(_bForS) .and. Eval(_bForU)}
	_bWhile := {|| SX3->(!eof() .and. X3_ARQUIVO == _cAlias)}
	
	SX3->(dbEval(_bInsCpo, _bFor, _bWhile,,, .T.))
	
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta aCols.                                         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCols := {}
If _nOpc != 3
	SX3->(dbSetOrder(2))  // X3_CAMPO.
	dbSelectArea(_cAlias); dbSetOrder(_nOrder) // Atencao (UPDXFUN).
	dbSeek(_cSeek, .F.)
	Do While !eof() .and. &_cWhile
		// Verifica se o usuario nao solicitou que alguns registros fossem filtrados.
		// O comando SoftLock() trava o registro, caso necessario (_lSLock for true).
		If (empty(_cFor) .or. &_cFor) .and. (!_lSLock .or. SoftLock(_cAlias))
			// Se travou o registro, armazena o ocorrido na matriz _aSLock.
			If _lSLock
				aAdd(_aSLock, {_cAlias, RecNo()})
			Endif
			
			// Inclui uma linha na aCols.
			_aAux1 := {}
			For _nAux1 := 1 to nUsado
				_uCampo := aHeader[_nAux1, 2]
				SX3->(dbSeek(_uCampo, .F.))
				If SX3->X3_CONTEXT == "V"
					_uAux1 := CriaVar(_uCampo, .T.)
					_uAux1 := IIf(ValType(_uAux1) == "D" .and. empty(_uAux1), dDataBase, _uAux1)
					aAdd(_aAux1, _uAux1)
				Else
					aAdd(_aAux1, &_uCampo)
				Endif
			Next _nAux1
			aAdd(_aAux1, .F.)  // Campos de apagado tem que estar como falso.
			aAdd(aCols, aClone(_aAux1))
		Endif
		
		// Vai para o proximo item da aCols.
		dbSelectArea(_cAlias); dbSkip()
	EndDo
Endif
//
// Se a aCols estiver vazia, cria uma linha em branco.
If empty(aCols)
	aCols := {Array(nUsado + 1)}
	aCols[1, nUsado + 1] := .F.
	For _nAux1 := 1 to nUsado
		_uAux1 := CriaVar(aHeader[_nAux1, 2], .T.)
		_uAux1 := IIf(ValType(_uAux1) == "D" .and. empty(_uAux1), dDataBase, _uAux1)
		aCols[1, _nAux1] := _uAux1
	Next _nAux1
	
	// Acerta o campo sequencial.
	If !empty(_cCpoSeq) .and. empty(aCols[1, _nAux1 := GdFieldPos(_cCpoSeq)])
		aCols[1, _nAux1] := StrZero(1, len(aCols[1, _nAux1]))
	Endif
Endif

// Restaura as condicoes da area anterior (alias, indice e registro).
RestArea(_aArea)
Return(nUsado)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ InsLinGD บ Autor ณ Felipe Raposo      บ Data ณ  08/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Insere uma linha em branco no final da aCols.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ _cCpoSeq - campo sequencial. Sera incrementado um ao valor บฑฑ
ฑฑบ          ณ            desse campo da linha anterior na linha inserida.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ O numero da linha criada. A sintaxe recomendavel e:        บฑฑ
ฑฑบ          ณ n := InsLinGD(_cCpoSeq)                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ As variaveis aHeader, aCols, n e nUsado devem estar cria-  บฑฑ
ฑฑบ          ณ das e acessiveis como Private (recomendavel) ou Public.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function InsLinGD(_cCpoSeq)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nRet, _psSeq
Local _nUsado := IIf(Type("nUsado") == "N", nUsado, len(aHeader))

// Verifica o valor padrao do parametro passado.
_cCpoSeq := U_ValPad(_cCpoSeq, "")

// Insere uma linha na aCols sem valor nenhum (somente nulos).
aAdd(aCols, array(_nUsado + 1))

// Pega o numero da ultima linha da aCols (recem criada).
_nRet := len(aCols)

// Atualiza os campos de nulo para os valores corretos deles.
aCols[_nRet, _nUsado + 1] := .F.
aEval(aHeader, {|x, y| aCols[_nRet, y] := CriaVar(x[2], .T.)})

// Atualiza o campo sequencial.
If !empty(_cCpoSeq) .and. (_psSeq := GdFieldPos(_cCpoSeq)) != 0
	If _nRet > 1
		aCols[_nRet, _psSeq] := Soma1(aCols[_nRet - 1, _psSeq])
	Else
		aCols[_nRet, _psSeq] := StrZero(1, len(aCols[_nRet, _psSeq]))
	Endif
Endif

// Retorna o tamanho atualizado do aCols.
Return(_nRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvGD    บ Autor ณ Felipe Raposo      บ Data ณ  03/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava os dados da aCols na tabela.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _nOpc =>  2 - visualizar (nao faz nada).                   บฑฑ
ฑฑบ          ณ           3 - incluir                                      บฑฑ
ฑฑบ          ณ           4 - alterar                                      บฑฑ
ฑฑบ          ณ           5 - remover                                      บฑฑ
ฑฑบ          ณ _cAlias   - alias a qual a getdados se refere.             บฑฑ
ฑฑบ          ณ _nIndice  - indice utilizado para pesquisa do registro.    บฑฑ
ฑฑบ          ณ _cChFixa  - chave fixa utilizada no inicio da pesquisa.    บฑฑ
ฑฑบ          ณ _cChVarP  - chave que varia a cada registro, utilizada na  บฑฑ
ฑฑบ          ณ             sequencia do _cChFixa na pesquisa.             บฑฑ
ฑฑบ          ณ _bExeCpo  - bloco de comandos a ser executado na gravacao  บฑฑ
ฑฑบ          ณ             de cada campo. Utilize esse recurso com caute- บฑฑ
ฑฑบ          ณ             la, pois pode fazer o sistema ficar lento.     บฑฑ
ฑฑบ          ณ _bExeReg  - bloco de comandos a ser executado na gravacao  บฑฑ
ฑฑบ          ณ             de cada registro.                              บฑฑ
ฑฑบ          ณ _bExeFim  - bloco de comandos a ser executado apos a gra-  บฑฑ
ฑฑบ          ณ             vacao de todos os registros.                   บฑฑ
ฑฑบ          ณ _lSLock   - indica se os registros ja estao bloqueados pe- บฑฑ
ฑฑบ          ณ             lo comando SoftLock() ou nao.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Retorno logico, informando se tudo ocorreu bem.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Eh recomendavel que seja utilizado o controle de transa-   บฑฑ
ฑฑบ          ณ coes para a execucao dessa rotina, e que a transacao seja  บฑฑ
ฑฑบ          ณ desfeita (rollback) caso a rotina retorne valor falso.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function GrvGD(_nOpc, _cAlias, _nIndice, _cChFixa, _cChVarP, _bExeCpo, _bExeReg, _bExeFim, _lSLock)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _lExc, _lAchou
Local _nAux1, _lRet := .T.
Private _cChVar, n

// Abre o registro para alteracao ou inclusao.
If _nOpc > 2
	
	// Acerta os valores padroes dos parametros.
	_bExeCpo := U_ValPad(_bExeCpo, {|_nLin, _nCol| })
	_bExeReg := U_ValPad(_bExeReg, {|_nLin| })
	_bExeFim := U_ValPad(_bExeFim, {|| })
	_cChVar  := U_ValPad(_cChVarP, "")
	_lSLock  := U_ValPad(_lSLock, .F.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava as variaveis de memoria da getdados.           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	// Seleciona o alias e acerta o indice passado por parametro.
	dbSelectArea(_cAlias); dbSetOrder(_nIndice) // Atencao (UPDXFUN).
	
	// Grava cada linha da aCols.
	For _nAux1 := 1 to len(aCols)
		
		// Cria variaveis private para que a chave de busca possa usa-las.
		aEval(aHeader, {|x, y| m->(&(x[2])) := aCols[_nAux1, y]})
		
		// Testa se eh para excluir o registro.
		_lExc := (aCols[_nAux1, nUsado + 1] .or. _nOpc == 5)
		
		// Posiciona o registro.
		_lAchou := dbSeek(_cChFixa + IIf(!empty(_cChVar), m->(&_cChVar), ""), .F.)
		
		// Grava os campos na tabela. Nao passa por esse bloco de comandos
		// somente se for exclusao e nao encontrar o registro na tabela.
		If !_lExc .or. _lAchou
			// Abre o registro para alteracao ou inclusao.
			If !_lAchou
				// Se for inclusao, ou se for alteracao e nao achou o registro; entao inclui registro novo.
				RecLock(_cAlias, .T.)
				&(_cAlias)->(&(PrefixoCpo(_cAlias) + "_FILIAL")) := xFilial(_cAlias)
			ElseIf !_lSLock
				// Senao abre o registro para alteracao.
				RecLock(_cAlias, .F.)
			Endif
			
			// Testa se eh para excluir o registro.
			If _lExc
				&(_cAlias)->(dbDelete())  // Exclui o registro.
			Else
				// Atualiza todos os campos.
				aEval(aHeader, {|x, y| &(_cAlias)->(&(x[2])) := aCols[_nAux1, y], Eval(_bExeCpo, _nAux1, y)})
			Endif
			
			// Executa rotina passada pelo parametro a cada registro antes de gravar.
			_lRet := _lRet .and. U_ValPad(Eval(_bExeReg, _nAux1), .T.)
			
			// Grava as alteracoes na tabela.
			&(_cAlias)->(msUnLock())
		Endif
	Next _nAux1
	
	// Executa rotina passada pelo parametro depois de gravar todos os registros.
	_lRet := _lRet .and. U_ValPad(Eval(_bExeFim), .T.)
Endif
Return _lRet


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rateio   บ Autor ณ Felipe Raposo      บ Data ณ  19/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Efetua o rateio de uma certa quantidade em uma matriz.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _nRateio - quantidade a ser rateada.                       บฑฑ
ฑฑบ          ณ _aMatriz - matriz base a ser considerada para o rateio.    บฑฑ
ฑฑบ          ณ            Essa matriz devera conter os fatores para rece- บฑฑ
ฑฑบ          ณ            ber o rateio.                                   บฑฑ
ฑฑบ          ณ _nPrecis - precisao do valor rateado (numero de casas de-  บฑฑ
ฑฑบ          ณ            cimais).                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ _aRet - matriz, com o mesmo tamanho que a matriz base, com บฑฑ
ฑฑบ          ณ         a quantidade rateada de cada item, respectivamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function Rateio(_nRateio, _aMatriz, _nPrecis)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aRet, _nSaldo, _nBase := 0, _nFator, _aAux1[0], _bAux1, _nAux1, _nAux2

// Acerta os valores padroes dos parametros.
_aMatriz := U_ValPad(_aMatriz, {0})
_nPrecis := U_ValPad(_nPrecis, 0)
_aRet    := array(len(_aMatriz))
_nSaldo  := _nRateio
_nFator  := 10 ^ _nPrecis
aEval(_aMatriz, {|x| _nBase += x})

// Efetua o rateio.
If _nBase == 0
	_bAux1 := {|x, y| _aRet[y] := int((_nRateio / len(_aMatriz)) * _nFator) / _nFator, _nSaldo -= _aRet[y]}
Else
	_bAux1 := {|x, y| _aRet[y] := int((_nRateio / _nBase) * x * _nFator) / _nFator, _nSaldo -= _aRet[y]}
Endif
aEval(_aMatriz, _bAux1)

// Rateia o saldo restante, se houver.
If _nSaldo != 0
	// Define a ordem dos que receberao o rateio primeiro.
	aEval(_aMatriz, {|x, y| aAdd(_aAux1, {x, y})})
	aSort(_aAux1,,, {|x, y| x[1] > y[1]})
	
	// Faz o rateio do saldo restante.
	_nAux2 := _nSaldo * _nFator
	// _nAux2 - esse numero nao pode ser maior que len(_aAux1). Se
	// isso ocorrer, eh porque alguma formula acima esta errada.
	For _nAux1 := 1 to _nAux2
		_aRet[_aAux1[_nAux1, 2]] += (1 / _nFator)
		_nSaldo--
	Next _nAux1
Endif

// Retorna os valores rateados.
Return(_aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExistX6Funบ Autor ณ Gilberto           บ Data ณ  17/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se um determinado parametro existe no SX6 ou nao. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral.                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ExistX6Fun(nomeParam)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local bkpArea := u_GetArea({"SX6"})  // Grava area anterior
Local existOuNao := .f.

// Verifica se o parametro foi passado.
If nomeParam != nil
	// verifica se o parametro existe no SX6.
	SX6->(dbSetOrder(1))
	existOuNao := SX6->(dbSeek(xFilial("SX6") + nomeParam , .F.))
EndIf

u_RestArea(bkpArea)
Return(existOuNao)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PutMV    บ Autor ณ Felipe Raposo      บ Data ณ  24/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o valor de um parametro do sistema.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral.                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PutMV(_cParam, _uValor)
Local bkpArea := u_GetArea({"SX6"})  // Grava area anterior
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cType

// Atualiza o parametro do lote.
SX6->(dbSetOrder(1))  // X6_FIL, X6_VAR.
If SX6->(dbSeek(xFilial() + _cParam, .F.))
	RecLock("SX6", .F.)
	_cType := SX6->X6_TIPO
Else
	_cType := ValType(_uValor)
	RecLock("SX6", .T.)
	SX6->X6_FIL  := xFilial("SX6")
	SX6->X6_TIPO := _cType
Endif
Do Case
	Case _cType == "C"  // Nao faz nada
	Case _cType == "N"; _uValor := AllTrim(str(_uValor))
	Case _cType == "D"; _uValor := dtoc(_uValor)
	Case _cType == "L"; _uValor := IIf(_uValor, "T", "F")
EndCase
SX6->X6_CONTEUD := _uValor
SX6->X6_CONTSPA := _uValor
SX6->X6_CONTENG := _uValor
SX6->(msUnLock())
u_RestArea(bkpArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DB2XML   บ Autor ณ Felipe Raposo      บ Data ณ  05/06/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Converte um alias aberto para um arquivo XML, no formato   บฑฑ
ฑฑบ          ณ Excel 2006.                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _cArquivo - arquivo a ser gerado.                          บฑฑ
ฑฑบ          ณ _PNome    - nome da planilha a ser criada no arquivo.      บฑฑ
ฑฑบ          ณ _cAlias   - alias que sera convertido para XML (opcional). บฑฑ
ฑฑบ          ณ _aStruct  - matriz com a estrutura da planilha. A sintaxe  บฑฑ
ฑฑบ          ณ             da matriz e' a seguinte:                       บฑฑ
ฑฑบ          ณ             1 - Cabecalho (opcional).                      บฑฑ
ฑฑบ          ณ             2 - Campo.                                     บฑฑ
ฑฑบ          ณ             3 - Largura da coluna (XML - opcional).        บฑฑ
ฑฑบ          ณ _bWhile   - converte os registros enquanto o retorno do    บฑฑ
ฑฑบ          ณ             bloco passado for verdadeiro.                  บฑฑ
ฑฑบ          ณ _bFor     - converte somente os registros cujo o bloco pas-บฑฑ
ฑฑบ          ณ             sado nesse parametro retornar verdadeiro.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Retorna o numero de registros que foram convertidos para o บฑฑ
ฑฑบ          ณ arquivo XML.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function DB2XML(_cArquivo, _cPNome, _cAlias, _aStruct, _bWhile, _bFor,_cVrs,_cCampoChave)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cMsg, _nAux1, _nAux2, _cAux1, _aAux1
Local _nLinhas := 0
Local _cCabec, _cColuna := "", _aColuna[0]
Local _cLinha, _aPlanilha[0], _aPlans[0], _cArqXML
Local _nCSVArq, _nCount := 0
Local _cDataBase := dtos(dDataBase)
Local _cDataHora := left(_cDataBase, 4) + "-" + SubStr(_cDataBase, 5, 2) + "-" + right(_cDataBase, 2) + "T" + Time() + "Z"
Local _bGrvErr := {|_cArq| MsgAlert("Ocorreu um erro na grava็ใo do arquivo " + _cArq + ". Favor avisar sistemas.", "Aten็ใo")}
Local _bGrvArq := {|_nArq, _cTxt, _cArq| IIf(fWrite(_nArq, _cTxt, len(_cTxt)) != len(_cTxt), Eval(_bGrvErr, _cArq), nil)}
Local _nSupLin

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o nome do arquivo a ser gravado.                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cArquivo := AllTrim(_cArquivo)
_cArquivo := _cArquivo + IIf(upper(right(_cArquivo, 4)) == ".XML", "", ".xml")

// Cria e testa se o arquivo foi criado com sucesso.
If (_nCSVArq := fCreate(_cArquivo)) <= 0 .or. !file(_cArquivo)
	_cMsg := "O arquivo XML nใo p๔de ser criado." + _EOL + _cArquivo + _EOL +;
	"Verifique se o disco estแ cheio ou protegido contra grava็๕es."
	MsgAlert(_cMsg, "Aten็ใo")
	Return .F.
Endif

// Analista os parametros passados para a funcao.
_cAlias  := U_ValPad(_cAlias, Alias())
_cPNome  := U_ValPad(_cPNome, _cAlias)
_aStruct := U_ValPad(_aStruct, {})
_bWhile  := U_ValPad(_bWhile,  {|| .T.})
_bFor    := U_ValPad(_bFor,    {|| .T.})
_cVrs    := U_ValPad(_cVrs, "2003")
_cCampoChave:= U_ValPad(_cCampoChave,'Space(01)')

// Versao do Excel: A versao 2007 suporta um numero maior de linhas.
// Gilberto - 16/08/2010
If _cVrs == "2007"
   _nSupLin:= 1000000
Else 
   _nSupLin:= 65536
EndIf
   
// Seleciona o alias que sera convertido para XML.
dbSelectArea(_cAlias); dbGoTop()

// Analista a estrutura passada.
If empty(_aStruct)
	SX3->(dbSetOrder(2))  // X3_CAMPO.
	_aAux1 := dbStruct()
	For _nAux1 := 1 to len(_aAux1)
		
		SX3->(dbSeek(_aAux1[_nAux1, 1], .F.))
        _cAux1:= Alltrim(X3Titulo())
        // Gilberto - 23/01/2007 - Retira os eventuais acentos ou caracteres especiais do cabecalho.
        //_cAux1:= u_TiraAct(_cAux1,.t.,"XML") thiago moraes
        If Empty(_cAux1); _cAux1:=  _aAux1[_nAux1, 1]; EndIf
		//IIf(empty(_cAux1 := AllTrim(X3Titulo())), _cAux1 := _aAux1[_nAux1, 1], nil)
		aAdd(_aStruct, {_cAux1, &("{|| " +  AllTrim(_aAux1[_nAux1, 1]) + "}")})
		
	Next _nAux1
Endif

aEval(_aStruct, {|x, y| _aStruct[y] := {IIf(ValType(x[1]) == "B", x[1], Capital(x[1])), x[2], IIf(len(x) >= 3, x[3], 0), 0, .T.}})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Converte os registros em linhas XML.                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do While Eval(_bWhile) .and. !eof()

	If Eval(_bFor)

		// Atualizacao das informacoes na tela.         
		msProcTxt("Criando linhas do XML "+&(_cCampoChave)  )	
		
		// Monta a linha corrente.
		_cLinha := '   <Row>' + _EOL
		For _nAux1 := 1 to len(_aStruct)
			_cCampo := Eval(_aStruct[_nAux1, 2])
			_cTipo  := ValType(_cCampo)
			Do Case
				Case _cTipo == "N"; _cCampo := AllTrim(str(_cCampo))
				Case _cTipo == "C"; _cCampo := AllTrim(U_TiraAct(_cCampo, .T.,"XML"))
				Case _cTipo == "D"; _cCampo := dtoc(_cCampo)
				OtherWise; _cCampo := ""
			EndCase
			_aStruct[_nAux1, 4] := max(_aStruct[_nAux1, 4], len(_cCampo))     // Armazena o maior registro desse campo.
			_aStruct[_nAux1, 5] := (_cTipo == "N" .and. _aStruct[_nAux1, 5])  // Indica se todos os registros do campo sao numericos.
			
			// Adiciona o campo a linha que sera retornada.
			If _cTipo == "N"
				_cLinha += '    <Cell ss:StyleID="s22"><Data ss:Type="Number">' + _cCampo + '</Data></Cell>' + _EOL
			Else
				_cLinha += '    <Cell><Data ss:Type="String">' + _cCampo + '</Data></Cell>' + _EOL
			Endif
		Next _nAux1                  
		
		_cLinha += '   </Row>' + _EOL
		
		// Limite de linhas por tabela no Excel.
		//If _nLinhas < 65536 - 1  // Subtrai um porque e' a linha utilizada pelo cabecalho.
		If _nLinhas < _nSupLin - 1
		
			aAdd(_aPlanilha, _cLinha)
			_nLinhas ++
			
		Else
		
			If empty(_aPlans)
				_cPNome += "_1"
			Endif
			
			aAdd(_aPlans, {_cPNome, aClone(_aPlanilha), _nLinhas})
			_cPNome := Soma1(_cPNome)
			_aPlanilha := {_cLinha}
			 _nLinhas := 1
			 
		Endif
		
	Endif
	
	// Vai para o proximo registro.
	dbSelectArea(_cAlias)
	dbSkip()
	
EndDo

aAdd(_aPlans, {_cPNome, _aPlanilha, _nLinhas})

// Configura as colunas e monta a linha de cabecalho.
_cCabec  := '   <Row ss:StyleID="s21">' + _EOL
For _nAux1 := 1 to len(_aStruct)
	_cAux1 := AllTrim(IIf(ValType(_aStruct[_nAux1, 1]) == "B", Eval(_aStruct[_nAux1, 1]), _aStruct[_nAux1, 1]))
	// Se nao houver uma largura informada no parametro, o sistema calcula.
	If (_nAux2 := _aStruct[_nAux1, 3]) == 0
		_nAux2 := IIf(_aStruct[_nAux1, 5], 72.75, _aStruct[_nAux1, 4] * 10.5)
	Endif
	IIf(!empty(_aColuna) .and. _aColuna[len(_aColuna), 1] == _nAux2, _aColuna[len(_aColuna), 2]++, aAdd(_aColuna, {_nAux2, 0}))
	_cCabec += '    <Cell><Data ss:Type="String">' + _cAux1 + '</Data></Cell>' + _EOL
Next _nAux1
_cCabec += '   </Row>' + _EOL
aEval(_aColuna, {|x| _cColuna += '   <Column ss:Width="' + AllTrim(str(x[1])) + '"' + IIf(x[2] > 0, ' ss:Span="' + AllTrim(str(x[2])) + '"', '') + '/>' + _EOL})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o arquivo XML propriamente dito.                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_cArqXML :=;
'<?xml version="1.0"?>' + _EOL +;
'<?mso-application progid="Excel.Sheet"?>' + _EOL +;
'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + _EOL +;
' xmlns:o="urn:schemas-microsoft-com:office:office"' + _EOL +;
' xmlns:x="urn:schemas-microsoft-com:office:excel"' + _EOL +;
' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + _EOL +;
' xmlns:html="http://www.w3.org/TR/REC-html40">' + _EOL +;
' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + _EOL +;
'  <LastAuthor>' + AllTrim(cUserName) + '</LastAuthor>' + _EOL +;
'  <Created>' + _cDataHora + '</Created>' + _EOL +;
'  <Version>11.5606</Version>' + _EOL +;
' </DocumentProperties>' + _EOL +;
' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + _EOL +;
'  <WindowHeight>9000</WindowHeight>' + _EOL +;
'  <WindowWidth>9000</WindowWidth>' + _EOL +;
'  <WindowTopX>100</WindowTopX>' + _EOL +;
'  <WindowTopY>100</WindowTopY>' + _EOL +;
'  <ProtectStructure>False</ProtectStructure>' + _EOL +;
'  <ProtectWindows>False</ProtectWindows>' + _EOL +;
' </ExcelWorkbook>' + _EOL +;
' <Styles>' + _EOL +;
'  <Style ss:ID="Default" ss:Name="Normal">' + _EOL +;
'   <Alignment ss:Vertical="Bottom"/>' + _EOL +;
'   <Borders/>' + _EOL +;
'   <Font/>' + _EOL +;
'   <Interior/>' + _EOL +;
'   <NumberFormat/>' + _EOL +;
'   <Protection/>' + _EOL +;
'  </Style>' + _EOL +;
'  <Style ss:ID="s21">' + _EOL +;
'   <Font x:Family="Swiss" ss:Bold="1"/>' + _EOL +;
'  </Style>' + _EOL +;
'  <Style ss:ID="s22">' + _EOL +;
'   <NumberFormat ss:Format="Standard"/>' + _EOL +;
'  </Style>' + _EOL +;
' </Styles>' + _EOL
Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.

// Monta as planilhas dentro do arquivo.
For _nAux1 := 1 to len(_aPlans)
	// Interpreta a linha.
	_cPNome    := _aPlans[_nAux1, 1]
	_aPlanilha := aClone(_aPlans[_nAux1, 2])
	_nLinhas   := _aPlans[_nAux1, 3]
	_nCount    += _nLinhas
	
	// Monta a string da planilha.
	_cArqXML :=;
	' <Worksheet ss:Name="' + _cPNome + '">' + _EOL +;
	'  <Table ss:ExpandedColumnCount="' + AllTrim(str(len(_aStruct))) + '" ss:ExpandedRowCount="' + AllTrim(str(_nLinhas + 1)) + '" x:FullColumns="1" x:FullRows="1">' + _EOL +;
	_cColuna + _cCabec
	Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
	
	// Grava cada linha de registro.
	For _nAux2 := 1 to len(_aPlanilha)
		_cArqXML := _aPlanilha[_nAux2]
		Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
	Next _nAux2
	
	// Finaliza a tabela.
	_cArqXML :=;
	'  </Table>' + _EOL +;
	'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + _EOL +;
	'   <PageSetup>' + _EOL +;
	'    <Header x:Margin="0.49"/>' + _EOL +;
	'    <Footer x:Margin="0.49"/>' + _EOL +;
	'    <PageMargins x:Left="0.8" x:Right="0.8"/>' + _EOL +;
	'   </PageSetup>' + _EOL +;
	'   <Selected/>' + _EOL +;
	'   <FreezePanes/>' + _EOL +;
	'   <FrozenNoSplit/>' + _EOL +;
	'   <SplitHorizontal>1</SplitHorizontal>' + _EOL +;
	'   <TopRowBottomPane>1</TopRowBottomPane>' + _EOL +;
	'   <ActivePane>2</ActivePane>' + _EOL +;
	'  </WorksheetOptions>' + _EOL +;
	' </Worksheet>' + _EOL
	Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
Next _nAux1

// Finaliza o arquivo.
_cArqXML := '</Workbook>' + _EOL
Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.

// Fecha os arquivos XML.
fClose(_nCSVArq)

Return _nCount

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DB2TXT   บ Autor ณ GILBERTO           บ Data ณ  02/02/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Converte um alias aberto para um arquivo XML, no formato   บฑฑ
ฑฑบ          ณ Excel 2006.                                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ _cArquivo - arquivo a ser gerado.                          บฑฑ
ฑฑบ          ณ _PNome    - nome da planilha a ser criada no arquivo.      บฑฑ
ฑฑบ          ณ _cAlias   - alias que sera convertido para XML (opcional). บฑฑ
ฑฑบ          ณ _aStruct  - matriz com a estrutura da planilha. A sintaxe  บฑฑ
ฑฑบ          ณ             da matriz e' a seguinte:                       บฑฑ
ฑฑบ          ณ             1 - Cabecalho (opcional).                      บฑฑ
ฑฑบ          ณ             2 - Campo.                                     บฑฑ
ฑฑบ          ณ             3 - Largura da coluna (XML - opcional).        บฑฑ
ฑฑบ          ณ _bWhile   - converte os registros enquanto o retorno do    บฑฑ
ฑฑบ          ณ             bloco passado for verdadeiro.                  บฑฑ
ฑฑบ          ณ _bFor     - converte somente os registros cujo o bloco pas-บฑฑ
ฑฑบ          ณ             sado nesse parametro retornar verdadeiro.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Retorna o numero de registros que foram convertidos para o บฑฑ
ฑฑบ          ณ arquivo XML.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Db2Txt(_cArquivo,_aEstruct,_cAlias,_cCampoChave,_cDelim)

Local _lRet := .T.
Local _nCSVArq
Private _cLinha := ""

//&(_cAlias)->(DbStruct())
// Analista os parametros passados para a funcao.
_cArquivo:= u_ValPad(_cArquivo, _cAlias)
_cAlias  := u_ValPad(_cAlias, Alias())
_cCampoChave:= u_ValPad(_cCampoChave," ")
_aEstruct := u_ValPad(_aEstruct, {})
_cDelim:= u_ValPad(_cDelim,";")

If File(_cArquivo)
   If ApMsgYesNo("Arquivo: "+_cArquivo+" jแ existe." + _EOL +"Deseja substituir ?")
      Ferase(_cArquivo)                                                                          	
   Else
	  _lRet:= .F.
   EndIf
EndIf

// Cria os arquivos textos.
_nCSVArq := fCreate(_cArquivo)
	
// Testa se o arquivo foi criado com sucesso.
If ( _lRet ) .And. ( _nCSVArq <= 0 ) .or. !File(_cArquivo)
	_cMsg := "O arquivo texto nใo p๔de ser criado." + _EOL + ;
	"Verifique tamb้m se o disco estแ cheio ou protegido contra grava็๕es."
	ApMsgAlert(_cMsg, "Aten็ใo")
	_lRet:= .F.
Endif

If   _lRet

	// Analista a estrutura passada.
	If Empty(_aEstruct)

		SX3->(dbSetOrder(2))  // X3_CAMPO.
		_aAux1 := dbStruct()
		
		For _nAux1 := 1 to Len(_aAux1)
			SX3->(dbSeek(_aAux1[_nAux1, 1], .F.))
	        _cAux1:= Alltrim(X3Titulo())
	        // Gilberto - 23/01/2007 - Retira os eventuais acentos ou caracteres especiais do cabecalho.
	        _cAux1:= u_TiraAct(_cAux1,.t.,"XML")
	        If Empty(_cAux1)
	           _cAux1:=  _aAux1[_nAux1, 1]
	        EndIf
			aAdd(_aEstruct, {_cAux1, &("{|| " +  AllTrim(_aAux1[_nAux1, 1]) + "}")})
		Next _nAux1
		
	Endif
	
	aEval(_aEstruct, {|x, y| _aEstruct[y] := {IIf(ValType(x[1]) == "B", x[1], Capital(x[1])), x[2], IIf(len(x) >= 3, x[3], 0), 0, .T.}})


	// Monta a linha do cabecalho.	
	aEval(_aEstruct, {|_aCabec| _cLinha += _aCabec[1] + _cDelim})
	_cLinha += _EOL
	
	// Gravacao o arquivo texto ja testando por erros.
	If fWrite(_nCSVArq, _cLinha, len(_cLinha)) != len(_cLinha)
		MsgAlert("Ocorreu um erro na grava็ใo do arquivo " + _cArquivo + ". Favor avisar sistemas.", "Aten็ใo")
		_lRet := .F.
	Endif

	// Processa todos os produtos.
	Private lEnd:= .f.
	Private _nCount:= 0
	MsAguarde({|lEnd| RunProc(@lEnd,_cAlias,_cCampoChave,_aEstruct,_nCSVArq,_lRet,_cDelim)}, "Aguarde...", "Gerando arquivo...",.t.)
	
	// Fecha o arquivo texto gerado.
	fClose(_nCSVArq)

EndIf

Return( _nCount)
//---
Static Function RunProc(lEnd,_cAlias,_cCampoChave,_aEstruct,_nCSVArq,_lRet,_cDelim)

Local _cLinha:= ""
DbSelectArea(_cAlias)
DbGotop()

While !Eof() .and. _lRet
	
	// Atualiza tela de processamento.
	If !Empty(_cCampoChave)
		msProcTxt("Exportando pre็os " + &(_cCampoChave))
	Else
		msProcTxt("Exportando pre็os ")
	EndIf
	ProcessMessages()  // Atualiza a pintura da janela.
	
	// Monta a linha que sera gravada.
	_cLinha := ""
	For _nAux1 := 1 to len(_aEstruct)
		_cCampo := Eval(_aEstruct[_nAux1, 2])
		_cTipo  := ValType(_cCampo)
		Do Case
			Case _cTipo == "C"; _cCampo := "'"+AllTrim(_cCampo)
			//Case _cTipo == "N"; _cCampo := AllTrim(Transform(_cCampo,"@e 999,9999.99"))
			Case _cTipo == "N"; _cCampo := AllTrim(Transform(_cCampo,"@e 9999999999.99"))			
			Case _cTipo == "D"; _cCampo := DtoC(_cCampo)
			OtherWise; _cCampo := ""
		EndCase
		_cLinha += _cCampo + _cDelim
	Next _nAux1
	_cLinha += _EOL
	
	// Gravacao o arquivo texto ja testando por erros.
	If fWrite(_nCSVArq, _cLinha, len(_cLinha)) == len(_cLinha)
		_nCount++
	Else
		MsgAlert("Ocorreu um erro na grava็ใo do arquivo " + _cArquivo + ". Favor avisar sistemas.", "Aten็ใo")
		_lRet := .F.
		Exit
	Endif
	
	// Vai a proxima nota.
	dbSelectArea(_cAlias)
	dbSkip()
	
End-While

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMsgMatriz บ Autor ณ Felipe Raposo      บ Data ณ  19/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe uma matriz bi-dimensional na tela, em uma grade      บฑฑ
ฑฑบ          ณ ListBox.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Geral.                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MsgMatriz(_aMatriz, _aHeader, _cTitulo, _cMens)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _SaveArea:= u_GetArea()
Local _oDlg1, _oSay1, _oListBox1, _nRetUser := 1
Local _aPosObj[0], _aObjetos[0], _aInfo[0], _aTam[0]
Local _aMatRet:={}  // Matriz de retorno

// Valores padroes.
_cTitulo := U_ValPad(_cTitulo, "Aten็ใo")
_cMens   := U_ValPad(_cMens, "Matriz de dados")
If Len(_aMatriz) == 0
   Private _aAux[ Len(_aHeader) ]
   Afill(_aAux,"")
   Aadd(_aMatriz,_aAux)
EndIf

AAdd(_aObjetos, {000, 010, .T., .F.})
AAdd(_aObjetos, {000, 000, .T., .T., .T.})
_aTam    := {000, 012, 210, 100, 420, 200, 000}
_aInfo   := {_aTam[1], _aTam[2], _aTam[3], _aTam[4], 3, 3}
_aPosObj := MsObjSize(_aInfo, _aObjetos)

// Desenha a tela.
DEFINE MSDIALOG _oDlg1 TITLE _cTitulo FROM _aTam[7], 0 TO _aTam[6], _aTam[5] PIXEL STYLE 128 STATUS
//Define msDialog _oDlg1 title _cTitulo from _aTam[7], 0 to _aTam[6], _aTam[5] pixel STYLE DS_MODALFRAME STATUS

// Desabilita o uso do ESC para cancelar a janela.
_oDlg1:lEscClose:= .f.

// Botoes ok e cancelar no topo da tela.
_bBntOk:= {|| _nRetUser:= _oListBox1:nAt ,_oDlg1:End()}
_bBntCan:= {|| _nRetUser:= 0, _oDlg1:End()}

// Label no top da tela.
_oSay1 := TSay():New(_aPosObj[1, 1], _aPosObj[1, 2], {|| _cMens}, _oDlg1,,,,,, .T.,,,, 007)

// Monta o ListBox com as datas.
_oListBox1 := TWBrowse():New(_aPosObj[2, 1], _aPosObj[2, 2], _aPosObj[2, 3], _aPosObj[2, 4], {|| nil}, _aHeader,, _oDlg1,,,,,,,,,,, _cMens,,, .T.,,,,,)
_oListBox1:SetArray(_aMatriz)
_oListBox1:bLine := {|| _aLin := {}, aEval(_aMatriz[_oListBox1:nAt], {|x| aAdd(_aLin, x)}), _aLin}

// Exibe a tela montada para o usuario.
Activate msDialog _oDlg1 center on init EnchoiceBar(_oDlg1, _bBntOk, _bBntCan)

u_RestArea(_SaveArea)

// _nRetUser retorna o valor da linha em que esta posicionado quando eh pressionado o botao verde "Ok".
// Se for pressionado vermelho "cancela", entao o valor a ser retornado eh zero (0).
Return(_nRetUser)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuSXE   บ Autor ณ Felipe Raposo      บ Data ณ  26/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para manutencao das tabelas SXE e SXF do sistema. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Italian Coffee do Brasil.                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function AtuSXE

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _oDlg1, _oSay1, _oBtn1, _oGetDXE, _oGetDXF, _nRetUser := 0
Local _cLinOk, _cTudoOk, _cFldOk, _lDelOk, _aAlter
Local _nOpc := 4  // 4 - Alterar.
Local _aPosObj[0], _aObjetos[0], _aInfo[0], _aTam[0]
Local _aHeaderXE, _aColsXE, _aRecNoXE, _aHeaderXF, _aColsXF, _aRecNoXF
Private VISUAL := (_nOpc == 2)
Private INCLUI := (_nOpc == 3)
Private ALTERA := (_nOpc == 4)
Private EXCLUI := (_nOpc == 5)
Private _cTabela := Space(3)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Solicita que o usuario seleciona a tabela que deseja visualizar. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Se o usuario cancelou, o sistema retorna aqui.
If !FilAlias(@_cTabela)
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abre a tela com os registros filtrados.                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// Abre os arquivo SXE e SXF.
IIf(empty(select("SXE")), dbUseArea(.T.,, "SXE", "SXE", .T., .F.), nil)
IIf(empty(select("SXF")), dbUseArea(.T.,, "SXF", "SXF", .T., .F.), nil)

// Calcula as dimensoes da tela.
_aObjetos := {}
aAdd(_aObjetos, {000, 010, .T., .F.})
aAdd(_aObjetos, {000, 000, .T., .T.})
aAdd(_aObjetos, {000, 000, .T., .T.})
_aTam    := MsAdvSize()  // {000, 012, 210, 100, 420, 200, 000}
_aInfo   := {_aTam[1], _aTam[2], _aTam[3], _aTam[4], 3, 3}
_aPosObj := MsObjSize(_aInfo, _aObjetos)

// Desenha a tela.
Define msDialog _oDlg1 title "Manuten็ใo do n๚mero sequencial" from _aTam[7], 0 to _aTam[6], _aTam[5] pixel

// Botoes ok e cancelar no topo da tela.
_bBntOk   := {|| _nRetUser := 1, _oDlg1:End()}
_bBntCan  := {|| _nRetUser := 0, _oDlg1:End()}

// Label no top da tela.
_oSay1 := TSay():New(_aPosObj[1, 1], _aPosObj[1, 2], {|| "Manuten็ใo do n๚mero sequencial"}, _oDlg1,,,,,, .T.,,,, 007)

// Botao de refresh.
_oBtn1 := TButton():New(_aPosObj[1, 1], _aPosObj[1, 2] + 120, "Atualizar", _oDlg1, {|| FilAlias(@_cTabela, @_oGetDXE, @_aRecNoXE, @_oGetDXF, @_aRecNoXF)}, 50, 10,,,, .T.,, "Atualiza os dados baixo")

// Configuracao comum as duas tabelas.
_cLinOk  := "AlwaysTrue()"
_cTudoOk := "AlwaysTrue()"
_cFldOk  := "AlwaysTrue()"
_lDelOk  := .F.
_nAlter  := GD_UPDATE  // + GD_INSERT + GD_DELETE

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aHeader e o aCols do SXE.                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SXE->(CriaGD(@_aHeaderXE, @_aColsXE, @_aRecNoXE))
_oGrpXE  := TGroup():New(_aPosObj[2, 1], _aPosObj[2, 2], _aPosObj[2, 3], _aPosObj[2, 4], "SXE - Pr๓ximo n๚mero",,,, .T.)
_aAlter  := {"XE_TAMANHO", "XE_NUMERO"}
_oGetDXE := MsNewGetDados():New(_aPosObj[2, 1] + 7, _aPosObj[2, 2] + 3, _aPosObj[2, 3] - 3, _aPosObj[2, 4] - 3, _nAlter, _cLinOk, _cTudoOk,, _aAlter,,, _cFldOk,, _lDelOk, _oDlg1, _aHeaderXE, _aColsXE)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aHeader e o aCols do SXF.                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SXF->(CriaGD(@_aHeaderXF, @_aColsXF, @_aRecNoXF))
_oGrpXF  := TGroup():New(_aPosObj[3, 1], _aPosObj[3, 2], _aPosObj[3, 3], _aPosObj[3, 4], "SXF - N๚mero em uso / n๚meros liberados",,,, .T.)
_aAlter  := {"XF_TAMANHO", "XF_NUMERO"}
_oGetDXF := MsNewGetDados():New(_aPosObj[3, 1] + 7, _aPosObj[3, 2] + 3, _aPosObj[3, 3] - 3, _aPosObj[3, 4] - 3, _nAlter, _cLinOk, _cTudoOk,, _aAlter,,, _cFldOk,, _lDelOk, _oDlg1, _aHeaderXF, _aColsXF)

// Exibe a tela montada para o usuario.
Activate msDialog _oDlg1 center on init EnchoiceBar(_oDlg1, _bBntOk, _bBntCan)

// Se o usuario confirmou, grava nas tabelas.
If _nRetUser == 1
	// Grava as tabelas.
	GrvXEXF("SXE", _oGetDXE:aHeader, _oGetDXE:aCols, _aRecNoXE)
	GrvXEXF("SXF", _oGetDXF:aHeader, _oGetDXF:aCols, _aRecNoXF)
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FilAlias บ Autor ณ Felipe Raposo      บ Data ณ  26/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Abre tela para o usuario digitar o alias que ele quer fil- บฑฑ
ฑฑบ          ณ trado na tela.                                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Italian Coffee do Brasil.                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function FilAlias(_cTabelaP, _oObjXE, _aRecNoXE, _oObjXF, _aRecNoXF)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _oDlg1, _oSay1, _oGet1, _oBtnOk, _oBtnCan
Local _aPosObj[0], _aObjetos[0], _aInfo[0], _aTam[0]
Private _cTabela := _cTabelaP

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Solicita que o usuario seleciona a tabela que deseja visualizar. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// Calcula as dimensoes da tela.
aAdd(_aObjetos, {000, 010, .T., .F.})
aAdd(_aObjetos, {000, 000, .T., .T.})
aAdd(_aObjetos, {000, 015, .T., .F.})
_aTam    := {000, 000, 140, 050, 280, 100, 000}
_aInfo   := {_aTam[1], _aTam[2], _aTam[3], _aTam[4], 3, 3}
_aPosObj := MsObjSize(_aInfo, _aObjetos)

// Desenha a tela.
Define msDialog _oDlg1 title "Manuten็ใo do n๚mero sequencial" from _aTam[7], 0 to _aTam[6], _aTam[5] pixel

// Label no top da tela.
_oSay1 := TSay():New(_aPosObj[1, 1], _aPosObj[1, 2], {|| "Digite o alias da tabela que se deseja dar manuten็ใo"}, _oDlg1,,,,,, .T.,,,, 007)

// Label no top da tela.
_oGet1 := TGet():New(_aPosObj[2, 1], _aPosObj[2, 2], {|u| IIf(PCount() == 0, _cTabela, _cTabela := u)}, _oDlg1,, 10, "@!", {|| !empty("SX2", 1, _cTabela, "X2_CHAVE")},,,, .T.,, .T., "Alias da tabela",,,,,, .F.)

// Botoes OK e Cancelar.
_oBtnOk  := sButton():New(_aPosObj[3, 1], _aPosObj[3, 4] - 60, 1, {|| _nRetUser := 1, _oDlg1:End()}, _oDlg1)
_oBtnCan := sButton():New(_aPosObj[3, 1], _aPosObj[3, 4] - 30, 2, {|| _nRetUser := 0, _oDlg1:End()}, _oDlg1)

// Exibe a tela montada para o usuario.
Activate msDialog _oDlg1 center

// Se o usuario cancelou, o sistema retorna falso.
If _nRetUser != 1
	Return .F.
Endif
_cTabelaP := _cTabela

// Se os objetos foram passados por parametro, os atualiza tambem.
If ValType(_oObjXE) == "O"
	SXE->(CriaGD(@_oObjXE:aHeader, @_oObjXE:aCols, @_aRecNoXE)); _oObjXE:Refresh()
	SXF->(CriaGD(@_oObjXF:aHeader, @_oObjXF:aCols, @_aRecNoXF)); _oObjXF:Refresh()
Endif

Return .T.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CriaGD   บ Autor ณ Felipe Raposo      บ Data ณ  26/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria as matrizes aHeader, aCols e aRecNo da tabela sele-   บฑฑ
ฑฑบ          ณ cionada (SXE ou SXF).                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Italian Coffee do Brasil.                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function CriaGD(_aHeader, _aCols, _aRecNo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cUsado := "€€€€€€€€€€€€€€ฑ"
Local _cAlias := Alias()
Local _cFiltro := right(_cAlias, 2) + "_ALIAS == '" + _cTabela + "'"
Local _nAux1, _aAux1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o aHeader e o aCols do SXE ou SXF.                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
_aHeader := {}; _aCols := {}; _aRecNo := {}
aEval(dbStruct(), {|x| aAdd(_aHeader, {Capital(SubStr(x[1], 4)), x[1], "@!", x[3], x[4], "", _cUsado, x[2], _cAlias, "S"})})
dbGoTop()
Do While !eof()
	If &_cFiltro
		// Inclui o registro na _aColsXE.
		_aAux1 := {}; aEval(_aHeader, {|x| aAdd(_aAux1, &(x[2]))})
		aAdd(_aAux1, .F.)  // Campos de apagado tem que estar como falso.
		aAdd(_aCols, aClone(_aAux1))
		
		// Armazena o RecNo do registro.
		aAdd(_aRecNo, {RecNo(), len(_aCols)})
	Endif
	
	// Vai para o proximo item da tabela.
	dbSkip()
EndDo

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GrvXEXF  บ Autor ณ Felipe Raposo      บ Data ณ  26/06/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cria as matrizes aHeader, aCols e aRecNo da tabela sele-   บฑฑ
ฑฑบ          ณ cionada (SXE ou SXF).                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Italian Coffee do Brasil.                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function GrvXEXF(_cAlias, _aHeader, _aCols, _aRecNo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _nAux1
Private _cCampo

dbSelectArea(_cAlias)
For _nAux1 := 1 to len(_aCols)
	dbGoTo(_aRecNo[_nAux1, 1])
	RecLock(_cAlias, .F.)
	// Atualiza todos os campos.
	aEval(_aHeader, {|x, y| &(x[2]) := _aCols[_nAux1, y]})
	msUnLock()
Next _nAux1
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณTranSqlString บAutor  ณMicrosiga           บ Data ณ  18/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInseri em uma matriz os dados de uma string delimitada por      บฑฑ
ฑฑบ          ณcaracter especial ( virgula, ponto-e-virgula, etc..)            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TranSqlString(_cString)

Local _aLista:= {}

If !Empty(u_ValPad(_cString, ""))

	_aChar:= {",",";","/",".","-"}

	If Len(_cString) > 1
	
	    // A string deve ter separacao de itens feita por um dos caracteres do array acima.
	    nPos:= 0
	    For c:= 1 to Len(_aChar)
	        nPos:= At(_aChar[c],_cString)
		    If nPos > 0
		       Exit
		    EndIf
        Next

        If nPos > 0
	        _cChar:= _aChar[c]
            _nPos2:= 99
            _cPart:= ""
            _cStringAux:= _cString
            While (_nPos2 > 0)
                 _nPos2:= At( _cChar, _cStringAux)
                 _cPart:= Substr(_cStringAux,1, iif( _nPos2>0, (_nPos2-1), Len(_cStringAux) ) )
  			     aAdd(_aLista, Alltrim(_cPart) )
                 _cStringAux:= Alltrim(Substr( _cStringAux,_nPos2+1)  )
            End-While

            If Substr(_cString, Len(Alltrim(_cString)),1) == _cChar
               aAdd( _aLista, Space(Len(_cStringAux)) )
            EndIf
    	Else
    	    // Adiciona o que provavelmente e' o unico item.
		    aAdd(_aLista,AllTrim(_cString))
     	Endif
     	
	EndIf		

Else
    aAdd(_aLista,_cString)
EndIf

Return(_aLista)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณTranSqlString บAutor  ณGilberto            บ Data ณ  18/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna uma expressao no formato necessario para ser aplicada   บฑฑ
ฑฑบ          ณna clausula IN do SQL a partir de itens de um array.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MontaInSql(_aLista)

Local _cExpress:= "'"

If Len( u_ValPad(_aLista,{}) ) > 0
	
	For x:= 1 to Len(_aLista)
		_cExpress+= _aLista[x]+"'"+iif( X<Len(_aLista),",'","")
	Next
	
EndIf

Return(_cExpress)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidNumLiq บAutor  ณGilberto            บ Data ณ  14/12/06   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPega sempre um numero valido NAO DUPLICADO para utilizar.     บฑฑ
ฑฑบ          ณVerifica antes se tem duplicidade no SE1.                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ValidNumLiq()

Local _Area:= u_GetArea({"SE1"})
Local _cNumLiq:= Soma1(GetMv("MV_NUMLIQ"),6)

While (_lLiquida:= SeekLiq(_cNumLiq) )
      _cNumLiq:= Soma1(_cNumLiq,6)
End-While

u_PutMV("MV_NUMLIQ", _cNumLiq)

u_RestArea(_Area)

Return(_cNumLiq)


/*
Verifica se existem liquidacoes ja feitas com o numero fornecido como parametro.
*/
Static Function SeekLiq(_cNumLiq)

Local _lRet:= .f.
Local _cQuery:= ""

_cQuery+= "SELECT COUNT(*) AS TOTREG FROM "+RetSqlName("SE1")+" "
_cQuery+= "WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND "+" E1_NUMLIQ = '"+_cNumLiq+"' AND D_E_L_E_T_ <> '*'"
dbUseArea(.T., "TOPCONN", TcGenQry(,, _cQuery), "CONT", .T., .T.)
_lRet:= (CONT->TOTREG>0)
CONT->(DbCloseArea())

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DeleteFiles บAutor  ณGilberto            บ Data ณ  07/11/07   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDeleta arquivos de um diretorio especifico, deixando de lado   บฑฑ
ฑฑบ          ณo que for excessao, antes fazendo um backup do q for excluido. บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                            บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// _cPasta -> Pasta a ser analisada a partir do RootPath do Protheus.
// _cPastaBackup -> Pasta Backup onde serao gravados os arquivos que serao eliminados
// _cCoringa -> Caracteres coringa (Exemplos: *.* , *.xnu) para pesquisar o arquivo na Pasta indicada por _cPasta
// _aListaExcessao -> Lista de arquivos que nao devem ser apagados.
User Function DeleteFiles( _cPasta, _cPastaBackup,_cCoringa,_aListaExcessao)

Local _aArea := u_GetArea()
Local _aTodosMenus:={}
Local _cFileName:= ""
Local _cFileBackup:= ""
Local _nQtdDeletados:= 0
Local _lBackupOK:= .t.

// Valores padrao
If ValType(_cPasta) == NIL
   ApMsgStop("Erro: Parametro 1 ้ obrigat๓rio !")
   Return(0)
EndIf

_cPastaBackup:= u_ValPad(_cPastaBackup,"|SEMBACKUP|")
_cCoringa:= u_ValPad(_cCoringa,"*.*")
_aListaExcessao:= u_ValPad(_aListaExcessao, {} )

If ( _cPastaBackup == "|SEMBACKUP|" )
   If !ApMsgYesNo( "Foi feita op็ใo pela EXCLUSAO DE ARQUIVOS sem a realizacao de Backup dos mesmos."+Chr(13)+"Confirma a Exclusao?")
      Return(0)
   EndIf
EndIf

// Se o diretorio de backup nao existir, entao cria.
If !File(_cPastaBackup)
	If MakeDir(_cPastaBackup) != 0
	   ApMsgStop("Nao foi possivel criar a pasta de backup solicitada"+chr(13)+"A dele็ใo dos arquivos nใo serแ feita.")
	   Return(0)
	EndIf
EndIf

_cCoringa:= _cPasta+"\"+_cCoringa
_aArquivos:= Directory(_cCoringa)

For Ind:= 1 to Len(_aArquivos)
	
	_cFileName:= Alltrim(_aArquivos[Ind,1])
	_cFileName:= _cPasta+"\"+_cFileName
	// Quando nao encontrar o arquivo na lista de excessoes, faz o backup
	If AScan( _aListaExcessao,_cFileName  ) == 0
	
	   If (_cPastaBackup != "|SEMBACKUP|")
	      _cFileBackup:= _cPastaBackup+"\"+_cFilename
		   COPY FILE (_cFileName) TO (_cFileBackup)  // Copia o arquivo para a pasta de "sem conexao".
	   EndIf
	   // Caso o backup esteja ok, entao confirma a exclusao do arquivo.	
	   If _lBackupOK
  	   	  Ferase(_cFileName)
	      _nQtdDeletados+= 1		
	   EndIf
	EndIf
	
Next
u_RestArea(_aArea)
Return(_nQtdDeletados)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
		nTam *= 0.8
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
		nTam *= 1
	Else	// Resolucao 1024x768 e acima
		nTam *= 1.28
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratamento para tema "Flat"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If "MP8" $ oApp:cVersion
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
			nTam *= 0.90
		EndIf
	EndIf
Return Int(nTam)

User Function NumFinAjuste(cNum)
Local cPrefixo:= Subs(cNum,1,3)
Local cTitulo:= PadR(Subs(cNum,4,6),9)
Local cParcela:= Subs(cNum,10,1)
Local cTipo:= Subs(cNum,11)                
Return(cPrefixo+cTitulo+cParcela+cTipo)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRetSx3TipoบAutor  ณGilberto            บ Data ณ  08/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o tipo do campo de acordo com o SX3.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Sx3RetTipo(cCampo)

Local aArea:= u_GetArea({"SX3"})
Local cTipo:= ""
                         
SX3->(DbSetOrder(2))
SX3->(DbSeek(cCampo))   
If SX3->(Found())
   cTipo:= SX3->X3_TIPO 
EndIf

//Restaura area anterior.
u_RestArea(aArea)
                
Return(cTipo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWinCliLojaบAutor  ณGilberto            บ Data ณ  10/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSolicita a digitacao do Codigo do Cliente e da Loja         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function WinCliLoja()

Local _lSaida:= .f.
Local _cCliente:= Space(06)
Local _cLoja:= Space(02)   
Local oTelinha

@ 144,99 TO 276,371 DIALOG oTelinha TITLE "CONFIRME Codigo e Loja do Cliente"
@ 004,07 TO 030,078 TITLE "Cliente"
@ 014,11 GET _cCliente PICTURE "@!" Size 60,10 Valid !Empty(_cCliente) F3 "SA1"
@ 036,07 To 062,078 Title "Loja"
@ 046,12 Get _cLoja Picture "@!" Size 60,10 Valid !Empty(_cLoja)
@ 007,86 BmpButton Type 1 Action Close(oTelinha)
@ 027,86 BmpButton Type 2 Action (_lSaida:= .t., Close(oTelinha) )
ACTIVATE DIALOG oTelinha CENTERED

If ( _lSaida )
	_cCliente:= Space(06)
	_cLoja:= Space(02)
EndIf	

Return( {_cCliente,_cLoja} )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณFSaida()  บAutor  ณProtheus            บ Data ณ  24/07/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                
Static Function FSaida()
_lSaida:= .T.
Close(oTelinha)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRetGrupo  บAutor  ณGilberto            บ Data ณ  24/10/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna o nome do grupo a que pertence o usuario.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RetGrupo( cUsuario )

Local aArea:= GetArea()
Local aArray := {}
Local cIdGrupo:= ''
Local cGrupo:= ''

// Ordem por nome de usuario.
PswOrder(2)

// Pesquisa por nome de usuario.
If PswSeek( cUsuario, .T. )

  // Retorna vetor com informacoes do usuario, de acordo com o segundo parametro de PswSeek
  aArray := PswRet() 

  // Pega o Id do Grupo na posicao que ele ocupa no array.
  cIdGrupo:= aArray[1,10,1]  

  If !Empty(cIdGrupo)      
	 
	 // Colocar por ordem de Id.
     PswOrder(1)               

     // Procura o grupo pelo Id. ( Segundo Parametro igual a .F. indica que buscar ser pelo iD)
	 If PswSeek( cIdGrupo, .F. )  
	    // Retorna nome do Grupo de Usuแrio  		 
	  	cGrupo := PswRet()[1][2] 
     EndIf
     
  EndIf   
  
EndIf

// Restaura area.
RestArea(aArea)

Return(cGrupo)
