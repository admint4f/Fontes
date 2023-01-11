#Include "PROTHEUS.CH"
//--------------------------------------------------------------
/*/{Protheus.doc} MyFunction
Description

@param xParam Parameter Description                             
@return xRet Return Description
@author  - gilbertoo@gmail.com                                              
@since 16/3/2011
/*/                                                             
//--------------------------------------------------------------
User Function F240FIL()  
Local aAreBkp:= GetArea()  // Salva area anterior.
Local cFiltro:= ""
Local cGrvLRouanet:= SuperGetMv("T4F_GRVLRO",,"N")

// Alteração Luiz Eduardo para alimentar o campo E2_NODIA com E2_VALOR quando estiver em branco para organizar pelo índice 
// Retirar do programa assim que validar o índice E2_VALOR                      
/* Função retirda em 14/08/2018
cQuery := "SELECT E2_NUM,E2_PREFIXO,E2_PARCELA,E2_FORNECE,E2_LOJA,E2_TIPO FROM "+ RetSqlName("SE2")+" "
cQuery += " WHERE E2_NODIA ='"+SPACE(10)+"' AND E2_VENCREA >='20180301' " 
cQuery += " AND " + "D_E_L_E_T_ <>'*' "

cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP", .F., .T.)
dbgotop()
Do while !eof()
	Select SE2
	dbsetorder(1)
	seek xFilial()+tmp->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	if !eof() .and. tmp->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA) = SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA)
		RecLock("SE2",.f.)
		se2->E2_NODIA := str(se2->E2_VALOR,10)
		MsUnLock()
	endif
	Select Tmp
	skip
enddo
use
// Final da alteração, retirar assim que forem efetuados os testes com o campo E2_VALOR no índice
*/

VerBord() // Função que verifica se existem PA´s no borderô que não apareceram na posição
      
If ( cGrvLRouanet == "S" )
    cFiltro:= FiltroBor()
EndIf

// Restaura area de bkp.
RestArea( aAreBkp)
Return(cFiltro)

/*
E2_CONTAG = Customizado (Conta gerencial)
E2_CCONTAB = Customizado (Conta contabil)   --> Utilizado
E2_CONTAD = Padrao  (Cta Contabil)      
E2_DEBITO = Padrao  (Conta Deb.)
E2_CREDITO = Padrao (Conta Cred.)

 */

Static Function FiltroBor()

Static oDlg
Local oButton2
Local oCombo1
Local cCombo1
Local oComboBox1
Local cComboBox1
Local oGet1
Local cGet1 := Space(20)
Local oPanel1
Local oSay1
Local oSay2      
Local cFiltro:= ""

DEFINE MSDIALOG oDlg TITLE "Filtro Complementar" FROM 000, 000  TO 200, 300 COLORS 0, 16777215 PIXEL

@ 014, 007 MSCOMBOBOX oCombo1 VAR cCombo1 ITEMS {"Filtrar Lei Rouanet?","Filtrar Fundo Fixo?","Filtrar dev. Lollapalooza?"} SIZE 088, 018 OF oDlg COLORS 0, 16777215 PIXEL
//@ 014, 007 SAY oSay1 PROMPT "Deseja Filtrar Conta Lei Rouanet ?" SIZE 088, 018 OF oDlg COLORS 0, 16777215 PIXEL
@ 014, 096 MSCOMBOBOX oComboBox1 VAR cComboBox1 ITEMS {"1-Não","2-Sim"} SIZE 037, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 037, 008 SAY oSay2 PROMPT "Conta L.Rouanet?" SIZE 058, 016 OF oDlg COLORS 0, 16777215 PIXEL
@ 037, 069 MSGET oGet1 VAR cGet1 SIZE 073, 010 OF oDlg COLORS 0, 16777215 WHEN (oCombo1:nAt==1 .and. oComboBox1:nAT==2) F3 "CT1" PIXEL
@ 064, 007 BUTTON oButton2 PROMPT "OK" SIZE 036, 019 OF oDlg  ACTION ( oDlg:End() )  PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If ( cCombo1 == "Filtrar Lei Rouanet?" .and. cComboBox1 == "2-Sim" )
    cFiltro:= "E2_CTALROU == '"+cGet1+"'"
ElseIf (cCombo1 == "Filtrar Fundo Fixo?" .and. cComboBox1 == "2-Sim")
	cFiltro:= "E2_T4FFFIX == '1' "
Else
	// Filtra natureza de permuta para nao aparecer no bordero.
	cFiltro:= "E2_NATUREZ <> '500200' .AND. E2_NATUREZ <> '500201'"
EndIf
cFiltro += " .and. E2_XPLACA=' ' "  // Acrescentei o filtro para evitar que um título já em borderô retorne - Luiz Eduardo - 10/07/2018
if trim(SM0->M0_CODIGO) $ "08"
If ( cCombo1 == "Filtrar dev. Girls ?" .and. cComboBox1 == "2-Sim" )
    cFiltro:= "E2_PREFIXO == 'GLS'"
Endif
Else
If ( cCombo1 == "Filtrar dev. Lollapalooza ?" .and. cComboBox1 == "2-Sim" )
    cFiltro:= "E2_PREFIXO == 'LOL'"
Endif
Endif
// dbSetFilter({|| FG_IMPOSTO=='GAN'},"FG_IMPOSTO=='GAN'")exemplo
Return( cFiltro )

Static Function VerBord()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³MONTA QUERY DE VERIFICACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cQuery := "SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_LOJA,E2_NUMBOR FROM " + RETSQLNAME('SE2') + " "
_cQuery += "WHERE E2_FILIAL = '"  + xFILIAL('SE2')  + "' "
_cQuery += "  AND E2_TIPO    = 'PA ' "
_cQuery += "  AND E2_PREFIXO = 'AUT' "
_cQuery += "  AND E2_VENCREA >= '"+DTOS(dVenIni240)+"' "
_cQuery += "  AND E2_VENCREA <= '"+DTOS(dVenFim240)+"' "
_cQuery += "  AND E2_SALDO   > 0 "
//_cQuery += "  AND E2_NUMBOR = '      ' "
_cQuery += "  AND D_E_L_E_T_ = ' '"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXECUTAR QUERY            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TRBT4F") > 0
	DbSelectArea("TRBT4F")
	DbCloseArea()
Endif

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBT4F",.f.,.t.)
dbgotop()
if eof()
	Return
endif

Select TRBT4F
dbGoTop()
Do while !eof()
	Select SE5
	dbSetOrder(7)
	seek xFilial()+trbt4f->(E2_PREFIXO+E2_NUM+E2_PARCELA+"PA "+E2_FORNECE+E2_LOJA)
	if !eof() .and. e5_tipo="PA" .and. e5_recpag="P" .and. e5_prefixo="AUT" .and. left(e5_histor,30)="ADIANTAMENTO AUTOMATICO GERADO" .and. e5_tipodoc="PA"
		recLock("SE5",.f.)                                                                                                             
		replace E5_TIPODOC with 'BA'
		MsUnLock()
	endif
	Select TRBT4F
	skip
Enddo
Select TRBT4F
use

Return