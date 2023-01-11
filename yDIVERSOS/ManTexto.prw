#INCLUDE "rwmake.ch"
#DEFINE _EOL chr(13) + chr(10)  // Caractere de quebra de linha.
#DEFINE _nFTamLin 1024  // Tamanho do buffer de leitura do arquivo texto.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FUse     º Autor ³ Felipe Raposo      º Data ³  02/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Abre o arquivo passado por parametro.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FUse(_cArquivo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nRet
Public _nFUse

// Testa se eh para abrir ou fechar o arquivo texto.
If empty(_cArquivo) .or. (ValType(_nFUse) == "N" .and. _nFUse != 0)
	fClose(_nFUse)
	_nFUse := 0
Else
	// Abre o arquivo.
	_nFUse := fOpen(_cArquivo, 68)
	// Conta quantos caracteres o arquivo tem.
	_nRet := fSeek(_nFUse, 0, 2)
	fSeek(_nFUse, 0, 0)  // Move para o inicio do arquivo.
Endif

Return(_nRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FGoTop    º Autor ³ Felipe Raposo      º Data ³  02/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Vai para o inicio do arquivo.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FGoTop()
fSeek(_nFUse, 0, 0)  // Move para o inicio do arquivo.
Return(nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FEOF     º Autor ³ Felipe Raposo      º Data ³  02/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorna .T. se o arquivo estiver no final.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FEOF()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet
Local _nPosAnt, _nPosFim

// Pega a posicao atual e a posicao final do arquivo.
_nPosAnt := fSeek(_nFUse, 0, 1)  // Posicao atual do arquivo.
_nPosFim := fSeek(_nFUse, 0, 2)  // Posicao final do arquivo.

// Reposiciona o ponteiro do arquivo.
fSeek(_nFUse, _nPosAnt, 0)  // Posicao original do arquivo.

// Verifica se a posicao atual eh igual a posicao final.
_lRet := (_nPosAnt == _nPosFim)

Return(_lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FReadLN  º Autor ³ Felipe Raposo      º Data ³  02/10/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Efetua a leitura da linha corrente do arquivo. Dependendo  º±±
±±º          ³ do parametro, tambem posiciona na linha posterior.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _lSkip - vai para a proxima linha ao efetuar a leitura da  º±±
±±º          ³          linha corrente (padrao .T.)                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ String com o conteudo da linha corrente do arquivo texto.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FReadLN(_lSkip)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nPosAnt := fSeek(_nFUse, 0, 1)  // Armazena a posicao atual do arquivo.
Local _cRet, _cAux1 := "", _nAux1 := _nFTamLin
Local _nTamLin := _nFTamLin
Private _cBuffer := space(_nTamLin)

// Pega os valores padroes das variaveis.
_lSkip := U_ValPad(_lSkip, .T.)

// Le o arquivo ate encontrar a quebra de linha ou ate acabar o arquivo.
Do While at(_EOL, _cAux1) == 0 .and. _nAux1 == _nTamLin
	_nAux1 := fRead(_nFUse, @_cBuffer, _nTamLin)  // Leitura do arquivo.
	_cAux1 += _cBuffer
EndDo

// Testa se acabou o arquivo ou se encontrou uma quebra de linha.
If (_nAux1 := at(_EOL, _cAux1)) != 0  // Encontrou uma quebra de linha.
	// Se for para pular linha...
	If _lSkip
		fSeek(_nFUse, _nPosAnt + _nAux1 + 1, 0)  // ... vai para a proxima linha.
	Endif
	_cRet := SubStr(_cAux1, 1, _nAux1 - 1)  // Retorna somente ate o final da linha.
Else  // Encontrou o final do arquivo.
	_cRet := _cAux1  // Retorna toda a string lida.
Endif

// Se nao for para pular linha...
If !_lSkip
	// ... retorna o ponteiro para a posicao anterior do arquivo.
	fSeek(_nFUse, _nPosAnt, 0)
Endif

Return(_cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TiraAct  º Autor ³ Felipe Raposo      º Data ³  04/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tira os acentos do texto passado por parametro.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _cTexto   - Texto a ser processadp.                        º±±
±±º          ³ _lChar    - Indica se deve ser retornado somente caracter  º±±
±±º          ³             padrao, sem nenhum caracter especial.          º±±
±±º          ³ _cSaida (NOVO)- Se existir verifica pode ser usado para    º±±
±±º          ³                 validar determinadas trocas de caracteres  º±±
±±º          ³                 Texto comum nao precisa substituir o &, XMLº±±
±±º          ³                 sim.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ Gilberto - 23/01/2007: Inclusao da substituicao dos carac- º±±
±±º          ³ teres  "‡" por "c" e de "&" por "&amp;"                    º±±
±±º          ³ Inclusao da verificacao da saida, para substituir o "&"    º±± 
±±º          ³ apenas quando a saida for XML.                             º±± 
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TiraAct(_cTexto, _lChar,_cSaida)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cRet
Local _nAux1, _nAux2, _cAux1, _cAux2, _cAux3, _aAux1

// Acerta parametros.
_lChar := U_ValPad(_lChar, .F.)

// Acerta parametros.
_cSaida := Upper(U_ValPad(_cSaida, Space(01) ))

// Trata os acentos do texto que sera exibido no console.
_aAux1 := {;
{"áàãâä", "a"},;
{"‡", "c"},; 
{"ç", "c"},;
{"éèêë", "e"},;
{"íìîï", "i"},;
{"ñ", "n"},;
{"óòõôö", "o"},;
{"úùûü", "u"},;
{"ÁÀÃÂÄ", "A"},;
{"Ç", "C"},;
{"ÉÈÊË", "E"},;
{"ÍÌÎÏ", "I"},;
{"Ñ", "N"},;
{"ÓÒÕÔÖ", "O"},;
{"ÚÙÛÜ", "U"}}

// Quando a saida eh XML (para Excel ou OpenOffice), troca o "&" . 
If (_cSaida == "XML") 
   aAdd(_aAux1,{"&" ,"&amp;"})
EndIf   

// Substitui os acentos.
_cRet := _cTexto
For _nAux1 := 1 to len(_aAux1)
	_cAux1 := _aAux1[_nAux1, 1]  // Caracteres as serem substituidos.
	_cAux2 := _aAux1[_nAux1, 2]  // Caracter substituto.
	For _nAux2 := 1 to len(_cAux1)
		_cAux3 := SubStr(_cAux1, _nAux2, 1)    // Caracter a ser excluido (da vez).
		_cRet  := StrTran(_cRet, _cAux3, _cAux2)
	Next _nAux2
Next _nAux1

// Retira os caracteres especiais.
If _lChar
	_cAux1 := ""
	For _nAux1 := 1 to len(_cRet)
		_cAux2 := SubStr(_cRet, _nAux1, 1)
		_nAux2 := asc(_cAux2)
		_cAux1 += IIf(_nAux2 >= 32 .and. _nAux2 <= 125, _cAux2, "")
	Next _nAux1
	_cRet := _cAux1
Endif

Return(_cRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MsgTela  º Autor ³ Felipe Raposo      º Data ³  18/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exibe a mensagem passada por parametro na tela, no console º±±
±±º          ³ e grava no log.                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _cMsg     - Mensagem a ser exibida.                        º±±
±±º          ³ _cTitle   - Titulo da mensagem.                            º±±
±±º          ³ _cTipo    - Tipo da mensagem.                              º±±
±±º          ³ _nHdPar   - Numero do arquivo de log aberto com fOpen().   º±±
±±º          ³ _cProgPar - Nome do programa.                              º±±
±±º          ³ _lScrPar  - Exibe a mensagem na tela (padrao .T.)          º±±
±±º          ³ _lSrvPar  - Exibe a mensagem no console (padrao .T.)       º±±
±±º          ³ _lLogPar  - Grava a mensagem no arquivo log (padrao .T.)   º±±
±±º          ³ _lIncPar  - Exibe a mensagem na regua de progressao        º±±
±±º          ³             (padrao .T.)                                   º±±
±±º          ³ A mensagem e o tipo da mensagem sao os unicos parametros   º±±
±±º          ³ obrigatorios.                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObservacao³ A variavel _lTela podera ser criada como Private ou Public,º±±
±±º          ³ pela funcao chamadora, para informar `a funcao se as mensa-º±±
±±º          ³ gens devem aparecer na tela (.T.) ou somente em logs e     º±±
±±º          ³ console (.F.).                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MsgTela(_cMsg, _cTitle, _cTipo, _nHdPar, _cProgPar, _lScrPar, _lSrvPar, _lLogPar, _lIncPar, _lCharP)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _uRet, _nAux1,  _cAux1, _aAux1
Local _cMsgLog := ""  // Mensagem para o arquivo de log (fWrite).
Local _cMsgSrv := ""  // Mensagem para o servidor (ConOut).
Local _cMsgScr := ""  // Mensagem para a tela (MsgBox).
Local _cMsgInc := ""  // Mensagem para a regua de processamento (msProcTxt).
Local _lTelaL  := IIf(Type("_lTela") == "L", _lTela, .F.)
Local _cAgora  := U_Agora("C")
Local _cProg   := U_ValPad(_cProgPar, "")
Local _nHd     := U_ValPad(_nHdPar, 0)
Local _lScrImp := U_ValPad(_lScrPar, _lTelaL)
Local _lIncImp := U_ValPad(_lIncPar, _lTelaL)
Local _lSrvImp := U_ValPad(_lSrvPar, .T.)
Local _lLogImp := U_ValPad(_lLogPar, _nHd != 0)

// Tratamento de variaveis.
_cProg += IIf(empty(_cProg), "", " ")

// Tratamento do erro.
Do Case
	Case _cTipo == "INFO"
		_cMsgScr := _cMsg
		_cMsgSrv := ""
		_cMsgLog := _cMsg
		_cMsgInc := _cMsg
		
	Case _cTipo == "ALERT"
		_cMsgScr := _cMsg
		_cMsgSrv := _cProg + '[' + _cAgora + '] * ' + _cMsg
		_cMsgLog := _cProg + '[' + _cAgora + '] * ' + _cMsg
		_cMsgInc := ""
		
	Case _cTipo == "CONSOLE"
		_cMsgScr := ""
		_cMsgSrv := _cProg + '[' + _cAgora + '] ' + _cMsg
		_cMsgLog := _cProg + '[' + _cAgora + '] ' + _cMsg
		_cMsgInc := _cMsg
		
	Case _cTipo == "LOG"
		_cMsgScr := ""
		_cMsgSrv := ""
		_cMsgLog := _cProg + '[' + _cAgora + '] ' + _cMsg
		_cMsgInc := ""
		
	Case _cTipo == "WARN"
		_cMsgScr := ""
		_cMsgSrv := _cProg + '[' + _cAgora + '] * ' + _cMsg
		_cMsgLog := _cProg + '[' + _cAgora + '] * ' + _cMsg
		_cMsgInc := ""
		
	Case _cTipo == "ERRO"
		_cMsgScr := _cMsg
		_cMsgSrv := _cProg + '[' + _cAgora + '] ** ' + _cMsg
		_cMsgLog := _cProg + '[' + _cAgora + '] ** ' + _cMsg
		_cMsgInc := ""
		
	Case _cTipo == "YESNO"
		_cMsgScr := _cMsg + _EOL + "Deseja continuar?"
		_cMsgSrv := _cProg + '[' + _cAgora + '] ' + _cMsg
		_cMsgLog := _cProg + '[' + _cAgora + '] ' + _cMsg
		_cMsgInc := ""
		
	OtherWise
		_cMsgScr := _cMsg
		_cMsgSrv := _cProg + '[' + _cAgora + '] ' + _cMsg
		_cMsgLog := _cProg + '[' + _cAgora + '] ' + _cMsg
		_cMsgInc := _cMsg
EndCase

// Exibe a mensagem no console do servidor.
If _lSrvImp .and. !empty(_cMsgSrv)
	// Trata os acentos do texto antes de exibi-lo no console.
	ConOut(U_TiraAct(_cMsgSrv))
Endif

// Grava a mensagem no arquivo de log.
If _lLogImp .and. !empty(_cMsgLog) .and. _nHd != 0
	fWrite(_nHd, _cMsgLog + _EOL)
Endif

// Exibe a mensagem na tela.
If _lScrImp .and. !empty(_cMsgScr)
	_uRet := MsgBox(_cMsgScr, _cTitle, _cTipo)
Else
	If _cTipo == "YESNO"
		ConOut("Sim (automatico)")
	Endif
	_uRet := .T.
Endif

// Atualiza a tela de processamento.
If _lIncImp .and. !empty(_cMsgInc)
	msProcTxt(_cMsgInc)
	ProcessMessages()  // Atualiza a pintura da janela.
Endif

Return(_uRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtoA     º Autor ³ Felipe Raposo      º Data ³  17/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Transforma texto, formado por itens separados por algum    º±±
±±º          ³ delimitador qualquer, em uma matriz.                       º±±
±±º          ³                                                            º±±
±±º          ³ O limitador de palavras podera ser definido pelo usuario e º±±
±±º          ³ passado por parametro. O padrao eh uma virgula ou ponto e  º±±
±±º          ³ virgula.                                                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametro ³ _cTexto - texto que sera convertido em matriz.             º±±
±±º          ³ _cDelim - caracter delimitador de campos. Se nao passado,  º±±
±±º          ³           o sistema assumira virgula ou ponto-virgula.     º±±
±±º          ³ _lRetAspas - informe ao sistema se devera retirar as aspas º±±
±±º          ³              do caracter. Se nao for para retirar, o sis-  º±±
±±º          ³              tema retornara os item com as aspas juntas. O º±±
±±º          ³              padrao eh .T. (verdadeiro).                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Uma matriz contendo itens do tipo caracter, onde cada item º±±
±±º          ³ eh um trecho do texto passado, separado pelo delimitador.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CtoA(_cTexto, _cDelim, _lRetAspas)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _aRet := {}
Local _nAux1, _cAux1 := "", _cAux2 := "", _cAbreCpo := ""
Local _lDelim, _nTamTxt, _cAspas := "'" + '"'

// Verifica os parametros passados.
_cTexto    := U_ValPad(_cTexto, "")
_cDelim    := U_ValPad(_cDelim, ";,")
_lRetAspas := U_ValPad(_lRetAspas, .T.)

// Pega o tamanho do campo.
_nTamTxt := len(_cTexto)

// Varre todo o texto passado por parametro, um caracter por vez.
For _nAux1 := 1 to _nTamTxt
	
	// Pega o caracter da posicao.
	_cAux1 := SubStr(_cTexto, _nAux1, 1)
	
	// Testa se eh um caracter delimitador.
	// Nao considera delimitadores dentro do texto (entre aspas).
	_lDelim := (_cAux1 $ _cDelim) .and. (empty(_cAbreCpo) .or. _cAbreCpo == right(AllTrim(_cAux2), 1))
	
	// Se nao for um caracter delimitador, inclui no campo.
	If !_lDelim
		// Se uma aspa for o primeiro caracter do campo...
		If empty(_cAux2) .and. _cAux1 $ _cAspas
			// ... armazena essa aspa numa variavel auxiliar.
			_cAbreCpo := _cAux1
		Endif
		
		// Adiciona o caractere da posicao.
		_cAux2 += _cAux1
	Endif
	
	// Testa se eh fim do campo ou fim da linha.
	If _lDelim .or. (_nAux1 == _nTamTxt)
		// Verifica se abriu e fechou com aspas.
		If _lRetAspas .and. !empty(_cAbreCpo) .and. right(AllTrim(_cAux2), 1) == _cAbreCpo
			_cAux2 := AllTrim(_cAux2)
			_cAux2 := right(_cAux2, len(_cAux2) - 1)  // Retira a aspa do inicio...
			_cAux2 := left(_cAux2, len(_cAux2) - 1)   // ... e do final.
		Endif
		
		// Adiciona o campo corrente na matriz que sera retornada.
		aAdd(_aRet, _cAux2)
		
		// Zera as variaveis auxiliares.
		_cAux2    := ""
		_cAbreCpo := ""
	Endif
Next _nAux1
Return(_aRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TxtFrm   º Autor ³ Felipe Raposo      º Data ³  25/01/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Preenche o valor passado por parametro, com caracteres,    º±±
±±º          ³ ate que se atinja o tamanho desejado. O caracter padrao de º±±
±±º          ³ preenchimento eh espaco em branco. O alinhamento padrao do º±±
±±º          ³ valor eh a esquerda (com caracteres a direita).            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _uValor - valor a receber os caracteres de preenchimento.  º±±
±±º          ³ _nTam   - tamanho da cadeia de strings que devera ser re-  º±±
±±º          ³           tornada (valor + preenchimento).                 º±±
±±º          ³ Paramentros opcionais:                                     º±±
±±º          ³ _cRech  - caracter de preenchimento. O padrao sao caracte- º±±
±±º          ³           res em branco.                                   º±±
±±º          ³ _cPos   - alinhamento do valor (D=direito / E=esquerdo). O º±±
±±º          ³           padrao eh alinhamento a esquerda.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ A cadeia de caracteres, de acordo com os parametros passa- º±±
±±º          ³ dos.                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function TxtFrm(_uValor, _nTam, _cRech, _cPos)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _nAux1

// Transforma o primeiro parametro em texto.
Do Case
	Case ValType(_uValor) == "C"  // Nesse caso nao fazer nada.
	Case ValType(_uValor) == "N"; _uValor := AllTrim(str(_uValor))
	Case ValType(_uValor) == "D"; _uValor := AllTrim(dtos(_uValor))
	Case ValType(_uValor) == "U"; Return(_uValor)
	OtherWise; Return("")
EndCase

// Analista o caracter de preenchimento.
_cRech := left(U_ValPad(_cRech, " "), 1)
_nTam  := U_ValPad(_nTam, len(_uValor))

// Joga o recheio na variavel de retorno.
If upper(left(AllTrim(U_ValPad(_cPos, "E")), 1)) == "D"
	_uValor := IIf(((_nAux1 := len(_uValor)) < _nTam), Replicate(_cRech, _nTam - _nAux1) + _uValor, right(_uValor, _nTam))
Else
	_uValor := IIf(((_nAux1 := len(_uValor)) < _nTam), _uValor + Replicate(_cRech, _nTam - _nAux1), left(_uValor, _nTam))
Endif

Return(_uValor)