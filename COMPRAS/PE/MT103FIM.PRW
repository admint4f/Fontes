#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | MT103FIM         | Autor | GIOVANI.ZAGO             | Data | 01/10/2013  |
|=====================================================================================|
|Descrição |  MT103FIM    Liberação de Conf.Recbto                                    |
|          |                                                                          |
|          | Plcom06                                                                  |
|=====================================================================================|
|Sintaxe   | MT103FIM                                                                 |
|=====================================================================================|
|Uso       | Especifico 		                                                      |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function MT103FIM()
*-----------------------------*
	Local aArea        := GetArea()
	Local nOpcA        := PARAMIXB[1]
	Local nConfirma    := PARAMIXB[2]
	Local cPara        := ' '

	//INICIO - Parametros T4F
	Local _oDlgCodBar	:= Nil
	Local _cCodBar 		:= Space(TamSX3("E2_CODBAR")[1])
	Local _lOk			:= .F.
	Local _nOpcao 		:= PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
	Local _nConfirma 	:= PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE
	//FIM - Parametros T4F

	Private cPerg 	   := "FM103"
	Private cTime      := Time()
	Private cHora      := SUBSTR(cTime, 1, 2)
	Private cMinutos   := SUBSTR(cTime, 4, 2)
	Private cSegundos  := SUBSTR(cTime, 7, 2)
	Private cAliasLif  := cPerg+cHora+ cMinutos+cSegundos
	Private   aDados1  := {}
	Private   aDados2  := {}
	Private   aUsuario  := {}


	If !IsBlind()
	
	If nOpcA = 3 .And. nConfirma = 1
	STRELQUER()

	DbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
	While 	(cAliasLif)->(!Eof())

	SF1->(RecLock("SF1",.F.))
	SF1->F1_XUSRSOL  :=  Alltrim(SF1->F1_XUSRSOL)+'/'+(cAliasLif)->C1_USER
	SF1->F1_XUSER	 :=  cUsuario
	SF1->F1_XCONREC  := 'N'
	SF1->(Msunlock("SF1"))
	SF1->( DbCommit() )


	Aadd( aDados1 , { 	(cAliasLif)->C1_USER,;
	(cAliasLif)->C1_NUM, (cAliasLif)->D1_PEDIDO } )


	(cAliasLif)->(dbskip())

	End

	If Len(aDados1) > 0
	For i:= 1 To Len(aDados1)

	Aadd( aDados2,{'NF.:'		,SF1->F1_DOC})
	Aadd( aDados2,{'Data:'		,Dtoc(ddatabase)})
	Aadd( aDados2,{'Solicitação' ,aDados1[i,2]})
	Aadd( aDados2,{'Pedido' ,aDados1[i,3]})


	cPara := UsrRetMail(aDados1[i,1])


	T4FHTML(aDados2, cPara )
	aDados2:={}
	aUsuario:={}
	Next i
	EndIf
	EndIf


	EndIf

	//INICIO - CUSTOM T4F - 10/12/13
	If INCLUI .And. _nConfirma == 1  

	// Verifica se não está sendo feito pelo V360
	If (Type("_lv360call") == 'U' .OR. _lv360call == .F.) .AND. MsgBox(OEMTOANSI("Deseja informar o código de barras do título ?"),"Atencao","YESNO")
		DEFINE MSDIALOG _oDlgCodBar From 200,001 to 350,410 Title "Complemento do Titulo"  STYLE DS_MODALFRAME Pixel

		@ 020, 010 SAY "Informacao complementar para pagamento:"
		@ 030, 010 SAY "Código de Barras"
		@ 040, 010 GET _cCodBar PICTURE "@R 99999.99999_99999.999999_99999.999999_9_999999999999999"  SIZE 170,10 VALID  VldCodBar(_cCodBar)

		ACTIVATE DIALOG _oDlgCodBar ON INIT EnchoiceBar( _oDlgCodBar, 	{ || Iif(!Empty(_cCodBar),(_lOk:=.T.,_oDlgCodBar:End()),Nil) },;
		{ || _lOk := .F.,_oDlgCodBar:End()},,) CENTERED

		If _lOk
			dbSelectArea("SE2")
			dbSetOrder(1)
				If dbSeek(xFilial("SE2") + cSerie + cNFiscal)
					If RecLock("SE2",.F.)
						SE2->E2_CODBAR	:= _cCodBar
						SE2->(MsUnLock())
					EndIf
				EndIf
		EndIf
	EndIf
	// Luiz Eduardo - 23/07/2019 - Alteração para bloquear títulos com retenção de INSS
	if SE2->E2_INSS<>0 //.AND. 1 = 2  // REGRA PARA O TÍTULO NASCER BLOQUEADO
		dbSelectArea("SE2")
		dbSetOrder(6)
		cChave := se2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
		If dbSeek(cChave)
			do while !eof().and. se2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == cChave
				If RecLock("SE2",.F.) .and. SE2->E2_INSS<>0
					SE2->E2_MSBLQL	:= '1'
					SE2->(MsUnLock())
				EndIf
				skip
			Enddo
		EndIf
		Retindex("SE2")
	Endif
	// Luiz Eduardo - 14/07/2020 - Alteração para bloquear títulos com adiantamento em aberto
	cQuery     := ' '

	cQuery := " SELECT
	cQuery += " DISTINCT SC7.C7_NUM,SC7.C7_TOTAL 
	cQuery += " FROM  "+RetSqlName("SC7")+"  SC7 "

	cQuery += " WHERE SC7.D_E_L_E_T_ = ' '"
	cQuery += " AND SC7.C7_XSOLPA    = '2'"
	cQuery += " AND SC7.C7_FORNECE	 = '"+SD1->D1_FORNECE+"'"
	cQuery += " AND SC7.C7_LOJA		 = '"+SD1->D1_LOJA+"'"
	cQuery += " AND (SC7.C7_ENCER    = ' '"
	cQuery += " AND SC7.C7_RESIDUO   = ' '"
	cQuery += " OR  SC7.C7_NUM   	 = '"+SD1->D1_PEDIDO+"')"
	cQuery := ChangeQuery(cQuery)

	cAlias := GetNextAlias()
	If Select(cAlias) > 0
		(cAlias)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)
	COPY TO \X
	dbgotop()
	if !empty((cAlias)->C7_NUM)
		dbSelectArea("SE2")
		dbSetOrder(6)
		cChave := se2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
		If dbSeek(cChave)
			do while !eof().and. se2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == cChave
				If RecLock("SE2",.F.) 
					SE2->E2_MSBLQL	:= '1'
					SE2->E2_XPLACA	:= 'BLOQ'
					SE2->(MsUnLock())
				EndIf
				skip
			Enddo
		EndIf
		Retindex("SE2")
		Mandaemail()
	Endif

	// Caso seja para nascer bloqueado apenas quando for o título da PA
	if 1==2
	dbSelectArea("SD1")
	dbSetOrder(1)
	Seek SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
	dbSelectArea("SC7")
	dbSetOrder(1)
	Seek SD1->(D1_FILIAL+D1_PEDIDO+D1_ITEMPC)
	if SC7->C7_XSOLPA='2' // REGRA PARA O TÍTULO NASCER BLOQUEADO
	dbSelectArea("SE2")
	dbSetOrder(6)
	cChave := se2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
	If dbSeek(cChave)
	do while !eof().and. se2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == cChave
	If RecLock("SE2",.F.) 
	SE2->E2_MSBLQL	:= '1'
	SE2->E2_XPLACA	:= 'BLOQ'
	SE2->(MsUnLock())
	EndIf
	skip
	Enddo
	EndIf
	Retindex("SE2")
	Endif
	Endif

	EndIf
	//FIM - CUSTOM T4F

EndIF
	Restarea(aArea)
	Return()


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  STRELQUER    ºAutor  ³Giovani Zago    º Data ³  01/10/13     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³   								                          º±±
	±±º          ³  Plcom06                                                   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
*-----------------------------------*
Static Function STRELQUER()
	*-----------------------------------*
	Local cQuery     := ' '


	cQuery := " SELECT
	cQuery += " DISTINCT SC1.C1_USER , SC1.C1_NUM, D1_PEDIDO
	cQuery += " FROM  "+RetSqlName("SD1")+"  SD1 "

	cQuery += " INNER JOIN(SELECT * FROM  "+RetSqlName("SC7")+"  )SC7 "
	cQuery += " ON SC7.D_E_L_E_T_ = ' '
	cQuery += " AND SC7.C7_NUM    = SD1.D1_PEDIDO
	cQuery += " AND SC7.C7_ITEM   = SD1.D1_ITEMPC
	cQuery += " AND SC7.C7_FILIAL = '"+xFilial("SC7")+"'"

	cQuery += " INNER JOIN(SELECT * FROM "+RetSqlName("SC1")+"  )SC1 "
	cQuery += " ON SC1.D_E_L_E_T_ = ' '
	cQuery += " AND SC7.C7_NUMSC = SC1.C1_NUM
	cQuery += " AND SC7.C7_ITEMSC = SC1.C1_ITEM
	cQuery += " AND SC1.C1_FILIAL = '"+xFilial("SC1")+"'"

	cQuery += " WHERE SD1.D_E_L_E_T_ = ' '
	cQuery += " AND SD1.D1_DOC       = '"+SF1->F1_DOC+"'"
	cQuery += " AND SD1.D1_SERIE     = '"+SF1->F1_SERIE +"'"
	cQuery += " AND SD1.D1_FORNECE	 = '"+SF1->F1_FORNECE +"'"
	cQuery += " AND SD1.D1_LOJA		 = '"+SF1->F1_LOJA +"'"
	cQuery += " AND SD1.D1_FILIAL    = '"+xFilial("SD1")+"'"


	cQuery += " ORDER BY SC1.C1_USER
	//SELECT DISTINCT SC1.C1_USER,SC1.C1_NUM FROM SD1080 SD1 INNER JOIN(SELECT * FROM SC7080 ) SC7 ON SC7.D_E_L_E_T_ = ' ' AND SC7.C7_NUM = SD1.D1_PEDIDO AND SC7.C7_ITEM = SD1.D1_ITEMPC AND SC7.C7_FILIAL = '01' INNER JOIN(SELECT * FROM SC1080 ) SC1 ON SC1.D_E_L_E_T_ = ' ' AND SC7.C7_NUMSc = SC1.C1_NUM AND SC7.C7_ITEMSC = SC1.C1_ITEM AND SC1.C1_FILIAL = '  '  WHERE  SD1.D_E_L_E_T_ = ' ' AND SD1.D1_DOC = '111111   ' AND SD1.D1_SERIE = '231' AND SD1.D1_FILIAL = '01'  ORDER BY  SC1.C1_USER
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()





Static Function T4FHTML(_aMsg,_cPara)

	Local _cFrom   := ''//"protheus@steck.com.br"//Lower(Alltrim(Posicione("SU7",1,xFilial("SU7")+SC5->C5_OPERADO,"U7_EMAIL")))
	Local _cAssunto:= 'NF Entrada Lançada '+ Alltrim(SM0->M0_NOME)+"/"+Alltrim(SM0->M0_FILIAL) + " - NF.Num: "+ Alltrim(SF1->F1_DOC)
	Local cFuncSent:= "MT103FIM"
	Local i        := 0
	Local cArq     := ""
	Local cMsg     := ""
	Local _nLin
	Local _cCopia  := 'protheusadmin@t4f.com.br'
	Local cAttach  := ''
	Default _cPara  := ''

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do cabecalho do email                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg := ""
	cMsg += '<html>'
	cMsg += '<head>'
	cMsg += '<title>' + _cAssunto +'</title>'
	cMsg += '</head>'
	cMsg += '<body>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP"><BR>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Black> <P>'
	cMsg += '<Table Border=1 Align=Center BorderColor=#000000 CELLPADDING=4 CELLSPACING=0 Width=60%>'
	cMsg += '<Caption> <FONT COLOR=#000000 FACE= "ARIAL" SIZE=5>' + _cAssunto + '</FONT> </Caption>'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do texto/detalhe do email                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _nLin := 1 to Len(_aMsg)
		IF (_nLin/2) == Int( _nLin/2 )
			cMsg += '<TR BgColor=#B0E2FF>'
		Else
			cMsg += '<TR BgColor=#FFFFFF>'
		EndIF
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,1] + ' </Font></TD>'
		cMsg += '<TD> <Font Color=#000000 Size="2" Face="Arial">' + _aMsg[_nLin,2] + ' </Font></TD>'
		cMsg += '</TR>'
	Next
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicao do rodape do email                                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMsg += '</Table>'
	cMsg += '<P>'
	cMsg += '<Table align="center">'
	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="black" size="4">Favor confirmar o recebimento através da rotina Conf.Recbto!</td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td></td>'
	cMsg += '</tr>'

	cMsg += '<tr>'
	cMsg += '<td colspan="10" align="center"><font color="black" size="2">Mensagem enviada automaticamente pelo sistema PROTHEUS - <font color="black" size="1">('+cFuncSent+')</td>'
	cMsg += '</tr>'
	cMsg += '</Table>'
	cMsg += '<HR Width=85% Size=3 Align=Centered Color=Black> <P>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial"> Atenciosamente </Font></B><BR>'
	//cMsg += '<B><Font Color=#000000 Size="2" Face="Arial">' + SM0->M0_NOMECOM + '</Font></B><BR>'
	//cMsg += '<Img Src="C:/AP5/SIGAADV/LGRL01.BMP">'
	cMsg += '</body>'
	cMsg += '</html>'

	u_T4COMMAIL(_cPara,_cCopia , _cAssunto, cMsg, ,'')

Return()

static function Mandaemail()

// Buscar RA_SUP (gestor - para receber e-mail)
// Tabela ZZS - Gestores - buscar e-mail  ZZS_EMAIL
// GATILHO - iif(!empty(m->e1_vencrea),u_AlteraVenc(),m->e1_vencrea) 

	Local _cSUBJECT:="-Financeiro] Título Bloqueado - ver adiantamento"
	Local cTxtEmail:=""
	Local _aFiles:=array(1)
	Local oDlg
	Local cDestEmail := ""
	Local lRes := .F.
	Local xAlias := "SE2"
	Local cCrLf    	:= Chr(13) + Chr(10)

	Local aArray := {}

	_NomeUser := trim(substr(cUsuario,7,15))

	auser := pswret(1)
	cemail := alltrim(auser[1,14])
	cUser  := alltrim(auser[1,1])
	cDestEmail := PSWRET(1)[1][14]

	DbSelectArea(xAlias)


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

	cObs := ""
	dbSelectArea("SE2")
	dbSetOrder(6)
	Seek cChave

	cTxtEmail := "Fornecedor : " +se2->e2_nomfor + cCrLf  // Pula linha
	cTxtEmail += "Título : " + se2->(E2_PREFIXO+" "+E2_NUM+" "+E2_PARCELA) + cCRLF
	cTxtEmail += "Existe PA em aberto para o fornecedor " + cCRLF
	cTxtEmail += "Usuário (entrada NF): "+_NomeUser + cCRLF + cCRLF

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
	endcase
//U_EnvEmail(cDestEmail+";contasareceber@t4f.com.br",cEmp+_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao superior que houve alteração no vencimento.

	cDestEmail := GetMv("MV_XMAILFIN",,"teste@teste.com.br")
	U_EnvEmail(cDestEmail+";luiz.totalit@t4f.com.br",cEmp+_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao superior que houve

