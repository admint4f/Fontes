#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CRLF (chr(13)+chr(10))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณT4F_MJUROS บAutor  ณLuiz Eduardo       บ Data ณ  28/05/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Enviar e-mail ao solicitante quando houver multa/juros     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F - Ponto de Entrada                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function T4F_MJUROS

Private aCampos:= {{"E2_NUM","Numero"},;
{"E2_PREFIXO"  ,"Prefixo"},;
{"ZZE_PARC"  ,"Parcela"},;
{"E2_FORNEC","Fornecedor"},;
{"E2_VALOR" ,"Valor"},;
{"E2_EMISSAO"  ,"Data Emissao."},;
{"E2_EMIS1","Data Digita็ใo"}}

Private aCores		:= {{"E2_SALDO<>0","ENABLE"},{"!E2_SALDO=0","DISABLE"}}
Private cCadastro	:= "Gera็ใo de Multa/Juros"

Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Informar Acr้scimo","U_juros",0,2},;
{"Legenda","U_LEGSE2",0,2}}


Private aIndice		:= {}		
MBrowse(6, 1,22,75,"SE2",,,,,,aCores,,,,,,,,"E2_SALDO <> 0")

RetIndex("SE2")
dbClearFilter()
return .t.

User Function Juros

	public _oDlg1
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	Seek xFilial()+se2->(e2_fornece+e2_loja)
	dbSelectArea("SE2")
	_nValJur := SE2->E2_ACRESC
	
	
	@ 000,000 TO 160,230 DIALOG _oDlg1 TITLE "Informe Valor dos Juros para o Tํtulo"
	@ 005,010 Say OemToAnsi("Tํtulo :")+se2->e2_prefixo+" "+e2_num+" "+e2_parcela
	@ 020,010 Say OemToAnsi("Fornecedor  :")+sa2->a2_nome
	@ 035,010 Say OemToAnsi("Acr้scimo  :")
	@ 035,052 Get _nValJur PICTURE "@E 999,999.99" SIZE 60,08 WHEN .t.
//@ 250,080 MsGet oQtde	Var nQtde	Picture "@E 999,999,999.99" SIZE 60,08 PIXEL	OF _oDlgPA When .F.
	@ 065,020 BMPBUTTON TYPE 01 ACTION (GRVPAR(),close(_odlg1))
	@ 065,080 BMPBUTTON TYPE 02 ACTION Close(_oDlg1)
	ACTIVATE DIALOG _oDlg1 CENTERED
	
Return

Static Function GRVPAR()

If !MsgBox(OEMTOANSI("Confirma acr้scimo para o fornecedor "+sa2->a2_nreduz+" ?"),"Atencao","YESNO")
	Return
endif

Close(_oDlg1)

Reclock("SE2",.f.)
se2->e2_acresc := _nValJur
se2->E2_SDACRES := _nValJur
MsUnLock()

// Contabiliza Multa / Juros

dbSelectArea("CT5")
dbSeek(xFilial()+"Z04")
Contabiliza()

//Envia e-mail para aprovador

//nMulta,nJuros

// Buscar nota Fiscal 
dbSelectArea("SD1")
//1-D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA
dbSetOrder(1)
Seek xFilial()+SE2->(E2_NUM+E2_PREFIXO+E2_FORNECE+E2_LOJA)

// Busca Aprovador do pedido de compras

dbSelectArea("SCR")
dbSetOrder(1)
Seek xFilial()+"PC"+SD1->D1_PEDIDO
//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL

Do while !eof() .and. CR_NUM=SD1->D1_PEDIDO
	cEmail := UsrRetMail(CR_USER)
	if CR_VALLIB<>0
		Enviaremail(cEmail)
	endif
	dbSelectArea("SCR")
	skip
Enddo
                 
Return

Static Function Enviaremail(cEmail)

Local _cSUBJECT:="-Financeiro] Juros/Multa Tํtulo "
Local cTxtEmail:=""
Local _aFiles:=array(1)
Local oDlg
Local cDestEmail := ""
Local lRes := .F.
Local xAlias := "SE2" 
Local cCrLf    	:= Chr(13) + Chr(10)
Local aArray := {}


// Buscar RA_SUP (gestor - para receber e-mail)
// Tabela ZZS - Gestores - buscar e-mail  ZZS_EMAIL
// GATILHO - iif(!empty(m->e1_vencrea),u_AlteraVenc(),m->e1_vencrea) 



_NomeUser := trim(substr(cUsuario,7,15))
auser := pswret(1)
cemail := cEmail // alltrim(auser[1,14])
cUser  := alltrim(auser[1,1])
cDestEmail := PSWRET(1)[1][14]


If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
	cDestEmail := GetMv("MV_XMAILRE",,"teste@teste.com.br")
Else
	Select SAL
	dbsetorder(2)
	seek xFilial()+ "000025"
	if !eof()
		PswOrder(1) // Ordem de numero
		If PswSeek(SAL->AL_USER,.T.)
			cDestEmail := PSWRET(1)[1][14]
		endif
	endif
Endif                    

cDestEmail := cEmail
                                                   
cTxtEmail := "Fornecedor : " +se2->e2_nomfor + cCrLf  // Pula linha
cTxtEmail += "Tํtulo : " + se2->(E2_PREFIXO+" "+E2_NUM+" "+E2_PARCELA) + cCRLF
if m->e2_acresc <>0
	cMulta :=left(str(SE2->e2_acresc*100,10),8)+"."+right(str(SE2->e2_acresc*100,10),2)
	cTxtEmail += "Valor de acr้scimo cobrado : "+cMulta + cCRLF
endif
//cTxtEmail += "Motivo : "+cObs + cCRLF
cTxtEmail += "Alterado pelo usuแrio : "+_NomeUser
                 
cEmp := '[Teste'
do case
	case SM0->M0_CODIGO == '08'
		cEmp := '[T4F'
	case SM0->M0_CODIGO == '09'
		cEmp := '[Metropolitan'
	case SM0->M0_CODIGO == '16'
		cEmp := '[Vicar'
	case SM0->M0_CODIGO == '20'
		cEmp := '[A&B'
	case SM0->M0_CODIGO == '25'
		cEmp := '[Mkt'
	case SM0->M0_CODIGO == '32'
		cEmp := '[PLF'
	case SM0->M0_CODIGO == '33'
		cEmp := '[INTI'
endcase

U_EnvEmail(cDestEmail+";luiz.totalit@t4f.com.br",cEmp+_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao superior que houve altera็ใo no vencimento.
//U_EnvEmail("luiz.totalit@t4f.com.br",cEmp+_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao superior que houve altera็ใo no vencimento.

Return                


//Contabilizacao
Static Function Contabiliza()

	aRotina := {}
	_Rotina    := FunName()
	cArquivo := "SE2"
	nTotal    := 0
	lDigita   := .T.
	cLote     := "ACRESC"
	// Lan็amento
	cPadrao   := "Z04" // CODIGO DO LANCAMENTO PADRAO CRIADO PARA ATENDER ESTA ROTINA
	nHdlPrv:= HeadProva(cLote,_Rotina,Alltrim(cUserName),@cArquivo)

	IncProc("Gerando Lancamento Contabil...")
	nTotal += DetProva(nHdlPrv,cPadrao,_Rotina,cLote)

	RodaProva(nHdlPrv,nTotal)
	nTotal := 0

	// Envia para Lancamento Contabil
	cA100Incl(cArquivo,nHdlPrv,3,cLote,lDigita,.F.) // Essa e a funcao do quadro dos lancamentos.

Return
