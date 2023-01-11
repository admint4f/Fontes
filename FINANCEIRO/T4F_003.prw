#include "rwmake.ch"
#include "protheus.ch"
#include "ap5mail.ch"
#include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณT4F_003   บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Registro de solicitacao de PA / REPASSE                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F / FINANCEIRO                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ 07/01/11 - Gilberto                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Inclusao do DV da Agencia. 					              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ 25/05/11 - Gilberto                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ * Remodelagem da interface - Campo cTipoFor remanejado p/  บฑฑ
ฑฑบ          ณ primeiro campo da interface.                               บฑฑ
ฑฑบ          ณ * Validacao de seguranca da tela (funcao: ValidTela())     บฑฑ
ฑฑบ          ณ * Criacao do tipo "9-Repasse Terceiros" e de todo suporte  บฑฑ
ฑฑบ          ณ de gravacao para o repasse. Geracao de titulo do tipo "FT" บฑฑ
ฑฑบ          ณ para essa ocorrencia.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ 17/10/12 - Luis                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ * Criacao do tipo "10-Devol.Ingressos" e de todo suporte   บฑฑ
ฑฑบ          ณ de gravacao para o repasse. Geracao de titulo do tipo "DV" บฑฑ
ฑฑบ          ณ para essa ocorrencia.                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function T4F_003() 
	//U_T4F_003()
	Static aTipoFor := {"","8-Impostos","9-Repasse Terceiros", "0-Devol.Ingressos"}
	//Static aTipoFor := {"","1-Fornecedor","2-Colaborador","3-Artista","4-Troco","5-Avulso","6-Presta็ใo Contas","7-Reembolso Avulso","8-Impostos","9-Repasse Terceiros", "0-Devol.Ingressos"}
	//Static aTipoFor := {"","1-Fornecedor","2-Colaborador","3-Artista","4-Troco","5-Avulso","8-Impostos","9-Repasse Terceiros", "0-Devol.Ingressos"} //Thiago retirei "6-Presta็ใo Contas","7-Reembolso Avulso",
	Local aCores:= {}
	Local cQuery1:= ""
	Local cTexto:= cTexto1 := ""
	Local nConta:= 1
	Local cUserAdmin:= GetMv("MV_XADMUSR",,"000000")
	Local cGrupo  := ""
	Local aGrupo := {}


	Private cAprov:= ValAprov(__cUserID)
	Private cNumero:= Space(06)
	Private cCadastro:= "Solicita็๕es de Troco/Pagto Antecipado/Impostos/Repasse"
	Private aMoedas:= {}
	Private cTipoFor:= Space(11)	// Tamanho maximo do tipo de fornecedor
	Private aRotina:={}

	// Adiciona elementos ao aRotina
	Aadd(aRotina,{"Pesquisar","AxPesqui",0,1})
	Aadd(aRotina,{"Visualizar","U_VerPA",0,2})
	Aadd(aRotina,{"Incluir","U_IncluiPA(1)",0,3})
	Aadd(aRotina,{"Aprovar","U_AprovPA",0,2})
	Aadd(aRotina,{"Cancelar","U_CancPA",0,3})
	Aadd(aRotina,{"Hist Aprovacao","U_fHistApr",0,2})
	Aadd(aRotina,{"Legenda","U_LEG",0,2})

	// Configuracao das cores da Legenda.
	Aadd(aCores,{'ZZE_STATUS = "L"','ENABLE'})		// Liberado
	Aadd(aCores,{'ZZE_STATUS = "P"','DISABLE'})	    // Aguardando analise pelos aprovadores
	Aadd(aCores,{'ZZE_STATUS = "E"','BR_AMARELO'})	// Em processo de aprovacao
	Aadd(aCores,{'ZZE_STATUS = "C"','BR_PRETO'})	// Cancelado

	/* Preenchimento do array de moedas
	Atualmente existem moedas com descri็ใo em branco, NAO deve perguntar no loop abaixo se a moeda tem
	descricao vazia porque o correto eh que todas estejam preenchidas.
	*/

	SX6->( Dbsetorder(1) )
	While .T.
		If SX6->( Dbseek(xFilial("SX6")+"MV_MOEDA"+Alltrim(Str(nConta,2))) )
			Aadd(aMoedas,SX6->X6_CONTEUD);	nConta++
		Else
			Exit
		EndIf
	EndDo

	If Select("TRBSCR") > 0
		TRBSCR->(Dbclosearea())
	Endif

	aGrupo :={}
	aGrupo:= UsrRetGrp(__cUserID)

	cGrupo:=""
	For x:=1 to len(aGrupo)
		cGrupo+= aGrupo[x]+"/"
	Next x

	If !(__cUserID $ cUserAdmin)//.or.cGrupo$'000026/000027'
		// 		cAprov := Iif(!Empty(cAprov),cAprov,"'XXXXXX'")
		If !Empty(cAprov) 
			// Rotina alterada em 31/07/2017 - Luiz Eduardo
			// Nใo mostrar solicita็๕es de outras filiais          
			// incluir a expressใo AND CR_DATALIB='        '  caso nใo queira mostrar solicita็๕es liberadas
			/*		cQuery1 := "SELECT UNIQUE(CR_NUM) "
			cQuery1 += " FROM " + RetSqlName("SCR") + " SCR "
			cQuery1 += " JOIN " + RetSqlName("ZZE") + " ZZE "
			cQuery1 += " ON ZZE_NUMERO = CR_NUM "
			cQuery1 += " WHERE CR_FILIAL = '"+xFilial("SCR")+"'"// AND CR_DATALIB='        ' "
			cQuery1 += " AND (ZZE_USERID = '"+__cUserId+"'"
			cQuery1 += " OR CR_APROV IN ("+cAprov+")) " // USER = '"+__cUserId +"' " 
			cQuery1 += " AND SCR.D_E_L_E_T_ <> '*' "
			cQuery1 += " AND ZZE.D_E_L_E_T_ <> '*' "
			cQuery1 += " ORDER BY CR_NUM "
			DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery1),'TRBSCR',.F.,.T. )
			TRBSCR->(DbGoTop())
			TRBSCR->(DbEval({ || cTexto1 += "'"+alltrim(TRBSCR->CR_NUM)+"'," }))
			cTexto1 := SubStr(cTexto1,1,Len(cTexto1)-1)
			*/

			/*		cQuery1 := "SELECT CTT_CUSTO"
			cQuery1 += " FROM " + RetSqlName("CTT") + " CTT "

			cQuery1 += " JOIN " + RetSqlName("SAL") + " SAL "
			cQuery1 += " ON AL_FILIAL = ''"
			cQuery1 += " AND AL_COD = CTT_XGRAPR"
			cQuery1 += " AND AL_APROV IN ("+cAprov+")"
			cQuery1 += " AND SAL.D_E_L_E_T_ <> '*'"

			cQuery1 += " WHERE CTT_FILIAL = ''"
			cQuery1 += " AND CTT.D_E_L_E_T_ <> '*' "
			cQuery1 := ChangeQuery(cQuery1)

			DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery1),'TRBZZE',.F.,.T. )
			TRBZZE->(DbGoTop())
			TRBZZE->(DbEval({ || cTexto += "'"+alltrim(TRBZZE->CTT_CUSTO)+"'," }))
			cTexto := SubStr(cTexto,1,Len(cTexto)-1)
			*/

			//		MBrowse(6, 1,22,75,"ZZE",,,,,,aCores,,,,,,,,"ZZE_CCUSTO IN ("+cTexto+") OR ZZE_USERID = '"+__cUserId+"'")
			nNum := 365
			if SM0->M0_CODIGO='08' .and. (__cUserId = '000505' .or. __cUserId = '001479')
				nNum := 180
			endif
			cQuery1 := "SELECT CR_NUM "
			cQuery1 += " FROM " + RetSqlName("SCR") + " SCR "
			cQuery1 += " WHERE CR_TIPO = 'ZZ' "
			cQuery1 += " AND CR_APROV IN ("+cAprov+")"
			cQuery1 += " AND (CR_DATALIB >'"+DTOS(DATE()-nNum)+"' OR CR_DATALIB ='        ')"  // Foi inserida essa condi็ใo devido ao excesso de lan็amentos para o aprovador - Luiz Eduardo - 01/12/2017
			cQuery1 += " AND SCR.D_E_L_E_T_ <> '*'"
			cQuery1 := ChangeQuery(cQuery1)

			DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery1),'TRBZZE',.F.,.T. )
			TRBZZE->(DbGoTop())
			TRBZZE->(DbEval({ || cTexto += "'"+alltrim(TRBZZE->CR_NUM)+"'," }))
			cTexto := SubStr(cTexto,1,Len(cTexto)-1)

			MBrowse(6, 1,22,75,"ZZE",,,,,,aCores,,,,,,,,"ZZE_NUMERO IN ("+cTexto+") OR ZZE_USERID = '"+__cUserId+"'")

		Else

			MBrowse(6, 1,22,75,"ZZE",,,,,,aCores,,,,,,,,"ZZE_USERID = '"+__cUserId+"'")

		Endif
	Else

		MBrowse(6, 1,22,75,"ZZE",,,,,,aCores)

	EndIf

	// Fecha a tabela temporaria (se estiver aberta).
	If Select("TRBZZE") > 0
		TRBZZE->(Dbclosearea())
	Endif
	If Select("TRBSCR") > 0
		TRBSCR->(Dbclosearea())
	Endif


Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALAPROV  บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida se o usuario eh aprovador                       	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValAprov(cCodigo)

	// Variveis.
	Local aAreaAnt:= GetArea()
	Local cAprov:= Space(06)

	// Verificar se o usuario eh aprovador
	SAK->( Dbsetorder(2) )		// AK_FILIAL+AK_USER
	SAK->( Dbseek(xFilial("SAK")+cCodigo) )

	Do While SAK->(!Eof()) .And. ( SAK->AK_FILIAL + SAK->AK_USER == xFilial("SAK")+cCodigo )
		cAprov += "'"+SAK->AK_COD + "',"
		SAK->(DbSkip())
	EndDo

	If !Empty(cAprov)
		cAprov := SubStr(Alltrim(cAprov),1,Len(Alltrim(cAprov))-1)
	EndIf

	// Restaura Area Anterior.
	RestArea(aAreaAnt)
Return (cAprov)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerPA()   บAutor  ณ Microsiga          บ Data ณ  04/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza dados do PA.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function VerPA()
	Local oDlg2
	Local _nIndice	:= 1
	DEFINE FONT oFont BOLD
	DEFINE FONT _oFonte1 NAME "Arial" BOLD
	DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD


	@ 050,042 TO 510,875 DIALOG oDlg2 TITLE "Solicitacao de Pagto Antecipado/Troco/Repasse"

	@ 011,010 Say "Numero: " FONT _oFonte1 OF oDlg2 PIXEL
	@ 011,080 Say ZZE->ZZE_NUMERO SIZE 20,08 PIXEL

	@ 011,150 Say "Tipo: "   FONT _oFonte1 OF oDlg2 PIXEL
	IIf(ZZE->ZZE_TIPO = 0, _nIndice := _nIndice + 10, _nIndice := _nIndice + 0) //ZZE->ZZE_TIPO )
	//	IIf(ZZE->ZZE_TIPO = 0, _nIndice := _nIndice + 10, _nIndice := _nIndice + ZZE->ZZE_TIPO ) Comentado por Thiago para ajustar a aprova็ใo e alterar o tipo
	//	IIf(ZZE->ZZE_TIPO = 0, _nIndice := _nIndice + 9, _nIndice := _nIndice + ZZE->ZZE_TIPO )
	@ 010,200 Say aTipoFor[_nIndice] PIXEL

	@ 011,290 Say "Moeda: "  FONT _oFonte1 OF oDlg2 PIXEL
	@ 010,345 Say aMoedas[ZZE->ZZE_MOEDA] SIZE 80,08 PIXEL

	@ 028,010 Say "Fornec./Colab./Artista:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 026,080 Say ZZE->ZZE_FORNEC+"/"+ZZE->ZZE_LOJA+" - "+Posicione("SA2", 1, XFILIAL("SA2")+ZZE->ZZE_FORNEC + ZZE->ZZE_LOJA , "A2_NOME" ) PIXEL

	@ 044,010 Say "Centro de Custo: " FONT _oFonte1 OF oDlg2 PIXEL
	@ 042,080 Say Rtrim(ZZE->ZZE_CCUSTO)+" - "+Posicione("CTT", 1, XFILIAL("CTT")+ZZE->ZZE_CCUSTO , "CTT_DESC01" ) PIXEL

	@ 060,010 Say "Elemento PEP: " FONT _oFonte1 OF oDlg2 PIXEL
	@ 058,080 Say Rtrim(ZZE->ZZE_PEP)+" - "+Posicione("CTD", 1, xFilial("CTD")+ZZE->ZZE_PEP, "CTD_DESC01" ) PIXEL

	@ 078,010 Say "Historico: " FONT _oFonte1 OF oDlg2 PIXEL
	@ 076,080 Get ZZE->ZZE_HISTOR Size 200,008      When .F. Pixel

	@ 090,010 TO 155,140 PIXEL
	@ 093,013 Say "Dados Bancแrios P/ Pagamento" FONT _oFonte1 OF oDlg2 PIXEL
	@ 113,013 Say "Banco:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 128,013 Say "Agencia:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 143,013 Say "Conta Corrente:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 113,080 Say ZZE->ZZE_BANCO  Pixel
	@ 128,080 Say ZZE->ZZE_AGENC  Pixel
	@ 143,080 Say ZZE->ZZE_CONTA  Pixel

	@ 090,150 TO 155,409 PIXEL
	@ 093,153 Say "Descricao / Motivo da Solicita็ใo de Pagto Antecipado/Troco/Repasse: " FONT _oFonte1 OF oDlg2 PIXEL
	//cDesc := AllTRim(MsMM(ZZE->ZZE_DESC)) 
	cDesc := LerMemo(ZZE->ZZE_DESC)
	//cDesc := ZZE->ZZE_DESC
	@ 103,153 Get cDesc MEMO  SIZE 253,049	WHEN .F.  Pixel Of oDlg2

	@ 163,010 Say "Pedido de Compra:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 163,080 Say ZZE->ZZE_PEDIDO Pixel

	@ 163,150 Say "Valor:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 163,200 Say ZZE->ZZE_VALOR  Picture "@E 999,999,999.99" Pixel

	@ 163,290 Say "Data Pagto:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 163,345 Say ZZE->ZZE_DATA   Pixel

	@ 180,010 Say "Data acerto de contas:" FONT _oFonte1 OF oDlg2 PIXEL
	@ 180,080 Say ZZE->ZZE_DTAC   Pixel

	@ 180,150 Say "Solicitante: " FONT _oFonte1 OF oDlg2 Pixel
	PswOrder(1)
	PswSeek(ZZE->ZZE_USERID,.T.)
	@ 180,200 Say AllTrim(Pswret(1)[1][4]) + Iif( !Empty(ZZE->ZZE_DEPTO), " / " + ZZE->ZZE_DEPTO, "") Pixel

	@ 197,010 Say "Cod. DIRF" FONT _oFonte1 OF oDlg2 PIXEL
	@ 197,080 Say ZZE->ZZE_DIRF   Pixel

	@ 197,150 Say "Natureza" FONT _oFonte1 OF oDlg2 PIXEL
	@ 197,200 Say ZZE->ZZE_NATURE Pixel	

	@ 214,383 BmpButton Type 2 Action Eval( {|| oDlg2:End() } )

	ACTIVATE DIALOG oDlg2 CENTERED

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRETTIPO() บAutor  ณGILBERTO            บ Data ณ  05/25/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRetorna o tipo correto.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RetTipo(nTipo)

	Local x
	Local cTipo

	For x:= 1 to Len(aTipoFor)
		If Str(nTipo,1) == Subs(aTipoFor[x],1,1)
			cTipo:= aTipoFor[x]
			Exit
		EndIf
	Next

Return(cTipo)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncluiPA  บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Registro de solicitacao de PA                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณA funcao IncluiPA teve a interface (tela) alterada para     บฑฑ
ฑฑบ          ณser possivel trabalhar com objetos                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ 15/07/08 - Claudio:                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ 1-Banco/Agencia/Conta devem ser trazidos do SA2.           บฑฑ
ฑฑบ          ณ 2-Criado campo de Data de Acerto de Contas.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ 25/05/11 - Gilberto                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ * Remodelagem da interface - Campo cTipoFor remanejado p/  บฑฑ
ฑฑบ          ณ primeiro campo da interface.                               บฑฑ
ฑฑบ          ณ * Validacao de seguranca da tela (funcao: ValidTela())     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function IncluiPA()
	Local   lOk         := .T.
	Local   cObrigat    := ''
	Local   lFor        := .F. //Sergio Celestino
	Local 	_lOk		:= .T.
	Local 	_aArea		:= GetArea()
	Local 	_aAreaZZE	:= ZZE->(GetArea())
	Private cNumero		:= GetSx8Num("ZZE","ZZE_NUMERO")
	Private cMoeda		:= "Reais"	// para selecionar a moeda 1 como padrao
	Private lPAPC	    := GetMv("MV_PACOMPC",,.F.)//Informar se PC ้ obrigatorio para inserir PA ( Sergio Celestino )
	Private cFornece	:= Space(06)
	Private cNome		:= Space(40)
	Private cLoja		:= Space(02)
	Private cTipofor	:= Space(10)
	Private cCusto		:= Space(20)
	Private cDescCC		:= Space(40)
	Private cPep		:= Space(20)
	Private cDescPep	:= Space(40)
	Private cBanco		:= Space(03)
	Private cAgencia	:= Space(05)
	Private cContaCorr	:= Space(10)
	Private cHistor		:= Space(60)
	Private cDesc		:= Space(10)
	Private cPedido		:= Space(06)
	Private nValor		:= 0
	Private dDataPag	:= CtoD(Space(08))
	Private dDtAcerto	:= ctoD(Space(08))
	Private cCodDIRF    := Space(4)
	Private cNatureza   := Space(15)

	Private oCBX1,oFornece,oLoja,oCBX2,oCusto,oDescCC,oPep,oDescPep,oHistor,oDesc,oPedido,oValor,oDataPag,oDtAcerto,oCodDIRF,oNatureza

	DEFINE FONT _oFonte1 NAME "Arial" BOLD
	DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD

	If ZZE->(dbSeek(xFilial("ZZE") + cNumero))
		//Alterado 16/12/2015 - BZO - Duplica็ใo da numera็ใo.
		//	ZZE->(Confirmsx8())
		ZZE->(dbGoTop())
		_lOk	:= ZZE->(dbSeek(xFilial("ZZE") + cNumero))
		While _lOk
			cNumero   := GetSX8Num("ZZE","ZZE_NUMERO")
			//		ZZE->(Confirmsx8())
			ZZE->(dbGoTop())
			If ZZE->(!dbSeek(xFilial("ZZE") + cNumero))
				_lOk	:= .F.
			EndIf
		EndDo
	EndIf

	DEFINE MSDIALOG oDlg FROM 050, 042 To 510,875 Title "Solicitacao de Pagto Antecipado/Troco/Repasse" Of oMainWnd PIXEL STYLE DS_MODALFRAME STATUS

	@ 011,010 Say "Numero: " FONT _oFonte1 OF oDlg PIXEL
	@ 011,080 Say cNumero OF oDlg PIXEL

	@ 011,150 Say "Tipo: "   FONT _oFonte1 OF oDlg PIXEL
	If lPAPC
		@ 010,200 COMBOBOX oCBX2 Var cTipoFor ITEMS aTipoFor Valid !Empty(cTipoFor) .And. AtuVar1( Subs(cTipoFor,1,1) , @lFor) SIZE 65,08 PIXEL OF oDlg FONT oDlg:oFont
	Else
		@ 010,200 COMBOBOX oCBX2 Var cTipoFor ITEMS aTipoFor Valid !Empty(cTipoFor) .and. Eval( {|| Iif( Subs(cTipoFor,1,1)=="9", cNatureza:= "400700", cNatureza:= Space(15) ), oNatureza:Refresh() } )  SIZE 65,08 PIXEL OF oDlg FONT oDlg:oFont
	EndIf

	@ 011,290 Say "Moeda: "  FONT _oFonte1 OF oDlg PIXEL
	@ 010,345 COMBOBOX oCBX1  Var cMoeda   ITEMS aMoedas  SIZE 60,08 PIXEL OF oDlg FONT oDlg:oFont

	@ 028,010 Say "Fornec./Colab./Artista:" FONT _oFonte1 OF oDlg PIXEL
	@ 026,080 MsGet oFornece  Var cFornece  Of oDlg Pixel F3 "SA2"     Valid ValFor(cFornece,"1")
	@ 026,118 MsGet oLoja     Var cLoja     Of oDlg Pixel SIZE 07,08   Valid ValLoja(cFornece,cLoja) .And. NaoVazio(cLoja)

	@ 044,010 Say "Centro de Custo: " FONT _oFonte1 OF oDlg PIXEL
	@ 042,080 MsGet oCusto    Var cCusto    Of oDlg Pixel SIZE 040,008 F3 "CTT" Valid ValCC(cCusto)
	@ 042,200 MsGet oDescCC   Var cDescCC   Of oDlg Pixel SIZE 090,008 When .F.

	@ 060,010 Say "Elemento PEP: " FONT _oFonte1 OF oDlg PIXEL
	@ 058,080 MsGet oPep      Var cPep      Of oDlg Pixel SIZE 070,008 F3 "CTD" Valid ValPep(cPep)
	@ 058,200 MsGet oDescPep  Var cDescPep  Of oDlg Pixel SIZE 130,008 When .F.

	@ 078,010 Say "Historico: " FONT _oFonte1 OF oDlg PIXEL
	@ 076,080 MsGet oHistor   Var cHistor   Of oDlg Pixel SIZE 200,008 Valid (!Empty(cHistor) .And. ValHist( Subs(cTipoFor,1,1) , cHistor))

	@ 090,010 TO 155,140 OF oDlg PIXEL
	@ 093,013 Say "Dados Bancแrios P/ Pagamento" FONT _oFonte1 OF oDlg PIXEL
	@ 113,013 Say "Banco:" FONT _oFonte1 OF oDlg PIXEL
	@ 128,013 Say "Agencia:" FONT _oFonte1 OF oDlg PIXEL
	@ 143,013 Say "Conta Corrente:" FONT _oFonte1 OF oDlg PIXEL

	@ 090,150 TO 155,409 PIXEL
	@ 093,153 Say "Descricao / Motivo da Solicita็ใo de Pagto Antecipado/Troco/Repasse: " FONT _oFonte1 OF oDlg PIXEL
	@ 103,153 Get cDesc MEMO  SIZE 253,049  Pixel Of oDlg

	@ 163,010 Say "Pedido de Compra:" FONT _oFonte1 OF oDlg PIXEL
	@ 163,080 Msget oPedido   Var cPedido   Of oDlg Pixel F3 "SC7"     When .F.

	@ 163,150 Say "Valor:" FONT _oFonte1 OF oDlg PIXEL
	If lPAPC   //--Adicionado variavel logica por Sergio Celestino para controle de gravacao do PA
		@ 163,200 Msget oValor Var nValor VALID IIF(lFor , U_PACOMPC(cFornece,cLoja,@cPedido,@nValor) , .T. ) PICTURE "@E 999,999,999.99" SIZE 050,08   Of oDlg Pixel
	Else
		@ 163,200 Msget oValor Var nValor VALID nValor > 0 PICTURE "@E 999,999,999.99" SIZE 050,08   Of oDlg Pixel
	Endif

	oPedido:Refresh()
	If nValor == 0 .And. !Empty(cFornece)
		oValor:SetFocus()
	Endif

	@ 163,290 Say "Data Pagto:" FONT _oFonte1 OF oDlg PIXEL
	@ 163,345 MsGet oDataPag  Var dDataPag  Of oDlg Pixel Valid ValDtPag(Subs(cTipoFor,1,1))

	@ 180,010 Say "Data acerto de contas:" FONT _oFonte1 OF oDlg PIXEL
	@ 180,080 MsGet oDtAcerto Var dDtAcerto Of oDlg Pixel

	@ 180,150 Say "Cod. DIRF" FONT _oFonte1 OF oDlg PIXEL
	@ 180,200 MsGet oCodDIRF  Var cCodDIRF  Of oDlg Pixel F3 "37"    Valid Iif(!Empty(cCodDIRF),ExistCpo("SX5","37"+cCodDIRF),"")

	@ 180,290 Say "Natureza" FONT _oFonte1 OF oDlg PIXEL
	@ 180,345 MsGet oNatureza Var cNatureza Of oDlg Pixel Valid ValNat(cNatureza) Size 50,8  F3 "SED"

	@ 193,353 BmpButton Type 1 Action Eval( {|| ValidTela(@lOK,@cObrigat), Iif(lOK,GravaPA(),ApMsgStop("Obrigatorio o preenchimento do campo: "+cObrigat+".") )   })
	@ 193,383 BmpButton Type 2 Action Eval( {|| RollBackSxe() , oDlg:End() })

	Activate MsDialog oDlg Centered

	Restarea(_aArea)
	Restarea(_aAreaZZE)

	Return(.T.)

	/**/
Static Function ValidTela(lOk,cObrigat)
	lOk := .t.

	If ( nValor == 0 )
		lOk:= .f.
		cObrigat:= "VALOR"
	EndIf

	If lOk

		If Empty(cNatureza) .and. Subs(cTipoFor,1,1) == "9"
			lOk:= .f.
			cObrigat:= "NATUREZA"
		EndIf

		If lOk

			If Empty(cTipoFor)

				lOk:= .f.
				cObrigat:= "TIPO"
			EndIf

		EndIf

	EndIF

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALFOR    บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo se o fornecedor informado estแ cadastrado e em   บฑฑ
ฑฑบ          ณ caso positivo exibe o nome.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManut.    ณ 17/11/2009 - Gilberto: Alteracao para validacao correta do บฑฑ
ฑฑบ          ณ codigo do fornecedor.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function Valfor(cFornece,cOrigem,cLojaFor)

	Local aAreaAnt := Getarea()
	Local lReturn  :=  .t.
	Local nContFor := 0
	DEFAULT cLojaFor := "01"

	If Empty(cFornece)
		MsgBox("Deve ser informado o codigo do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
		lReturn:= .f.
	Endif


	If lReturn

		SA2->( DbSetorder(1) )
		If ( cOrigem == "1" ) .Or. ( cOrigem == "2" )
			SA2->( DbSeek(xFilial("SA2")+cFornece) )
				If SA2->A2_MSBLQL == '1'
					MsgBox("Fornecedor bloqueado.","Atencao","ERROR") 
					lReturn:= .f.
				EndIf
		ElseIf cOrigem == "3" .or. cOrigem == "4"
			SA2->( DbSeek(xFilial("SA2")+cFornece+cLojaFor)	 )
				If SA2->A2_MSBLQL == '1'
					MsgBox("Fornecedor bloqueado.","Atencao","ERROR") 
					lReturn:= .f.
				EndIf
		EndIf


		If SA2->( !Found() )
			MsgBox("Codigo do fornecedor nใo encontrado.","O codigo do fornecedor nใo foi encontrado.","ERROR")
			lReturn:= .f.
		Else

			// Posiciona no primeiro fornecedor.
			cNome	   := SA2->A2_NOME
			cLoja	   := SA2->A2_LOJA
			cBanco	   := SA2->A2_BANCO
			cAgencia   := Alltrim(SA2->A2_AGENCIA)+"-"+Alltrim(SA2->A2_DVAGENC)  // Gilberto - inclusao do DV da agencia 07/01/11
			cContaCorr := Alltrim(SA2->A2_NUMCON)+"-"+Alltrim(SA2->A2_DVCONTA)

			If (cOrigem == "1") .Or. (cOrigem == "3")
				@ 27,200 Say cNome				SIZE 130,08 PIXEL
				@ 113,080 Say SA2->A2_BANCO 		SIZE 10,08 PIXEL
				@ 128,080 Say Alltrim(SA2->A2_AGENCIA)+"-"+Alltrim(SA2->A2_DVAGENC) SIZE 15,08 PIXEL
				@ 143,080 Say Alltrim(SA2->A2_NUMCON)+"-"+alltrim(SA2->A2_DVCONTA) SIZE 50,08 PIXEL
			Endif

		EndIf

	EndIf

	if cOrigem='2'
		lReturn:= .t.
	endif
	// Restaura area anterior.
	Restarea(aAreaAnt)
Return(lReturn)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALCC     บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida se o centro de custo informado esta correto.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValCC(cCusto)

	Local aAreaAnt:= GetArea()
	Local lRet:= .f.

	CTT->( DbSetOrder(1) )
	CTT->( DbGoTop() )

	If Posicione("CTT",1,xFilial("CTT")+cCusto,"CTT_BLOQ") == '1'
		MsgBox("Centro de Custo Bloqueado.","Atencao","ERROR")
		Return(.f.)
	Endif

	If SM0->M0_CODIGO # '16' .and. trim(Posicione("CTT",1,xFilial("CTT")+cCusto,"CTT_DESC02")) == "VICAR"
		ApMsgStop("Centro de Custo VICAR nใo poderแ ser utilizado nessa empresa.")
		Return(.f.)
	endif

	If !CTT->(DbSeek(xFilial("CTT")+cCusto))
		MsgBox("Centro de Custo nao cadastrado","Atencao","ERROR")
		lRet := .f.
	ElseIf CTT->CTT_CLASSE = "1"
		MsgBox("Nessa rotina sao aceitos somente Centros de Custo Analiticos."+chr(13)+;
		"Verifique e corrija.","Atencao","ERROR")
		lRet := .f.
	Else
		cDescCC := CTT->CTT_DESC01
		@ 57,200 Get cDescPep When .f. SIZE 80,08
		lRet := .t.
	Endif

	RestArea(aAreaAnt)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALLOJA   บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo se a loja do fornecedor informado ้ valida.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManut.    ณ 17/11/2009 - Gilberto: Alteracao para validacao correta do บฑฑ
ฑฑบ          ณ codigo do fornecedor.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValLoja(cFornece,cLoja,cOrigem)

	Local lReturn   := .t.
	Local aAreaAnt	:= GetArea()
	DEFAULT cOrigem := "3"

	If Empty(cLoja)
		MsgBox("Deve ser informada a loja do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
		lReturn:= .f.
	Else
		lReturn:= ValFor(cFornece,cOrigem,cLoja)
	EndIf

	if cOrigem='4'
		lReturn:= .t.
	endif

	// Restaura area.
	RestArea(aAreaAnt)
Return(lReturn)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALPEP    บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo se o elemento PEP estแ registrado                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValPep(cPep)

	Local cDescPep:= Space(40)
	Local aAreaAnt:= GetArea()
	Local _lReturn:= .t.

	DbSelectArea("CTD")
	CTD->( DbSetOrder(1) )	// CTD_FILIAL+CTD_ITEM

	// Como nao eh obrigatorio preencher, se estiver vazio deve retornar .t.
	If Empty(cPep)

		@ 58,200 Get cDescPep When .f. SIZE 130,08 PIXEL	// para o caso de ter conteudo antigo
		ApMsgStop("Aten็ใo: Elemento Pep ้ obrigat๓rio.")
		_lReturn:= .f.

	Else

		If !CTD->(dbSeek(xFilial("CTD")+cPep))
			Msgbox("Elemento PEP nใo cadastrado","Aten็ใo","ERROR")
			_lReturn:= .f.

		Else

			If Posicione("CTD",1,xFilial("CTD")+cPep,"CTD_BLOQ") == '1'
				MsgBox("Elemento PEP estแ bloqueado!")
				_lReturn:= .f.
			Else
				cDescPep := CTD->CTD_DESC01
				@ 58,200 Get cDescPep When .F. SIZE 130,08 PIXEL
			Endif

		Endif

	EndIf

	// Restaura area.
	RestArea(aAreaAnt)
Return(_lReturn)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALHIST   บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo se o historico esta preenchido quando o tipo de  บฑฑ
ฑฑบ          ณ fornecedor for "Troco".                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValHist(cTpForX,cHistX)

	Local _lReturn:= .t.

	//If Ascan( aTipoFor , Alltrim(cTpForX) ) == 4
	If cTpForX == "4"
		If Empty(cHistX)

			Msgbox("Obrigatorio o preenchimento do campo HISTORICO para esse tipo de fornecedor"+chr(13)+;
			"(Tipo: 4 - TROCO)","Atencao","ERROR")
			_lReturn:= .f.

		Endif
	Endif

Return( _lReturn )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALDTPAG  บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida็ใo se a data digitada estแ correta.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValDtPag(cTipoFor)
	Local _lReturn:= .t.

	//If AllTrim(Upper(cTipoFor)) != "IMPOSTOS"
	If cTipoFor <> "8"  // 8 = IMPOSTOS
		If dDataPag <= date()
			MsgBox("A data de pagamento deve ser posterior เ data de registro da solicita็ใo.","Atencao","ERROR")
			_lReturn:= .f.
		ElseIf Empty(dDataPag)
			Msgbox("DEVE ser informada a data de pagamento","Atencao","ERROR")
			_Return:= .f.
		Endif

	EndIf

Return( _lReturn )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALNAT     บ Autor ณ Cleverson         บ Data ณ  09/02/22   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida se a natureza financeira informada estแ bloqueada   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValNat(cNatureza)
	Local aAreaAnt:= GetArea()
	Local lRet:= .t.
	If SED->( DbSeek(xFilial("SED")+cNatureza)) 
		If SED->ED_MSBLQL == '1'
		MsgBox("Natureza bloqueada.","Atencao","ERROR")
		lReturn:= .f.
		EndIf
	Endif

	If SED->(Eof())
		MsgBox("Natureza Invalida.","Atencao","ERROR")
		lRet:=.f.
	Endif
	RestArea(aAreaAnt)
Return lRet 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGravaPA   บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao da solicitacao de pagamento antecipado.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function GravaPA()

	Local aAreaAnt := GetArea()
	Local _lReturn:= .f.
	Local _cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+cCusto,"CTT_XGRAPR")

	// 9 - Repasse Terceiros
	// Para evitar que se pressione ENTER repetidamente e gravar um PA "vazio". Se estแ verificando o campo cFornece por ser o primeiro a ser digitado.
	Do Case
		Case Empty(cFornece); Msgbox("Deve ser informado o codigo do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
		Case Empty(cLoja)   ; MsgBox("Deve ser informada a loja do fornecedor","Ha pelo menos um campo obrigatorio vazio","ERROR")
		Case Empty(nValor)  ; Msgbox("Deve ser informado o valor da solicitacao","Ha pelo menos um campo obrigatorio vazio","ERROR")
		Case Empty(dDataPag); Msgbox("Deve ser informada a data de pagamento","Ha pelo menos um campo obrigatorio vazio","ERROR")
		Case Empty(cHistor) ; MsgAlert("Aten็ใo, o camp HISTำRICO ้ de preenchimento obrigat๓rio. Preencha antes de cofirmar a inclusใo.")
		//Case cTipoFor == "Repasse Terceiros" .And. Empty(cNatureza) ; MsgBox("Deve ser informada a natureza de repasse (400700).")
		Case cTipoFor == "9" .And. Empty(cNatureza) ; MsgBox("Deve ser informada a natureza de repasse (400700).")
		Case cTipoFor == "5" .And. ( Empty(cNatureza) .Or. Empty(cCodDIRF) )
		//Case AScan( aTipoFor, Alltrim(cTipoFor)) == 5  .And. ( Empty(cNatureza) .Or. Empty(cCodDIRF) )
		MsgAlert("Aten็ใo, para pagamento antecipado de impostos ้ obrigat๓rio informar a natureza.")
		OtherWise
		_lReturn:= .t.
	EndCase

	If _lReturn

		// Chamada a funcao ValCC() para evitar que se digite um centro de custo analitico e se clique diretamente no botao ok.
		If !ValCC(cCusto)
			_lReturn:= .f.
		Endif

		If  _lReturn .And. !ValHist()
			_lReturn:= .f.
		Endif

		If _lReturn
			Begin Transaction 
				DbSelectArea("ZZE")			

				If RecLock("ZZE",.T.)
					ZZE->ZZE_FILIAL:= xFilial("ZZE")
					ZZE->ZZE_NUMERO:= cNumero
					ZZE->ZZE_MOEDA	:= Ascan(aMoedas,cMoeda)
					ZZE->ZZE_FORNEC	:= cFornece
					ZZE->ZZE_LOJA	:= cLoja
					ZZE->ZZE_NOMFOR	:= cNome
					//ZZE->ZZE_TIPO:= Iif( aScan(aTipoFor,Alltrim(cTipoFor))==5, 8, aScan(aTipoFor,Alltrim(cTipoFor)))
					ZZE->ZZE_TIPO	:= Iif(  Subs(cTipoFor,1,1)=="5", 8, Val(Subs(cTipoFor,1,2) ) )
					ZZE->ZZE_CCUSTO	:= Alltrim(cCusto)
					ZZE->ZZE_BANCO	:= cBanco
					ZZE->ZZE_AGENC	:= cAgencia
					ZZE->ZZE_CONTA	:= cContaCorr
					ZZE->ZZE_PEDIDO	:= cPedido
					ZZE->ZZE_VALOR	:= nValor
					ZZE->ZZE_DATA	:= dDataPag

					If !Empty(cPedido) //Sergio Celestino
						ZZE->ZZE_STATUS	:= "L"
					Else
						ZZE->ZZE_STATUS	:= "P"	// Status pendente - nenhum aprovador analisou.
					Endif

					ZZE->ZZE_HISTOR	:= cHistor
					//				ZZE->ZZE_DESC	:= cDesc
					ZZE->ZZE_USERID	:= __cUserID
					ZZE->ZZE_PEP	:= cPep
					ZZE->ZZE_DTAC	:= dDtAcerto
					ZZE->ZZE_NATURE	:= cNatureza
					ZZE->ZZE_DIRF	:= cCodDIRF
					_cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
					ZZE->ZZE_XGRPAP	:= _cGrpApv

					PswOrder(1)
					If PswSeek(__cUserID, .T. )
						ZZE->ZZE_DEPTO := Pswret(1)[1][12]
					Endif
					MSMM(,,,cDesc,1,,,"ZZE","ZZE_DESC")

					ZZE->( Msunlock() )
					ZZE->(ConfirmSx8())				
					//	Gera_Alcada_SC(cNumero,cCusto)
					//  Alterado TAKAO

					//u_GrvAlcZZE(cNumero,cCusto,.F.,.F.)

					MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",ZZE->ZZE_VALOR,,,_cGrpApv,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},ZZE->ZZE_DATA,1)
					fVdlNvlU(_cGrpApv)
				EndIf
			End Transaction 
		EndIf

	EndIf

	// Restaura area e fecha interface
	RestArea(aAreaAnt)
	Close(oDlg)

Return( .t. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVdlNvlU  บAutor  ณBruna Zechetti      บ Data ณ  04/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para valida็ใo do nํvel do usuแrio/aprovador.         ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static function fVdlNvlU(_cGrpApv)

	Local _aArea		:= GetArea()
	Local _lOk			:= .F.
	Local _cAliasSCR	:= GetNextAlias()
	Local _cAliasSAL	:= GetNextAlias()
	Local lAchou 		:= .f.

	dbSelectArea("SA2") 
	SA2->(dbSetOrder(1))
	If SA2->(dbSeek(xFilial("SA2")+ZZE->ZZE_FORNEC+ZZE->ZZE_LOJA))// .and. !(TRIM(ZZE->ZZE_CCUSTO)$"09021100*09021105" .AND. ZZE->ZZE_USERID$'001100*001635') Retirado por solicita็ใo da Flแbia em 27/09/2018
		If !Empty(SA2->A2_XCODUSR)
			Select SCR
			Seek xFilial()+'ZZ'+ZZE->ZZE_NUMERO
			lAchou := .f.
			cAprov := ''
			_cNivel	:= ""
			do while !eof() .and. CR_FILIAL+CR_TIPO+CR_NUM = xFilial("SCR")+'ZZ'+ZZE->ZZE_NUMERO
				// 07/08/2017 - Caso seja C.Custos 04022000 o sistema deverแ subir direto ao segundo nํvel - solicita็ใo J.J
				if rlock() .and. TRIM(ZZE->ZZE_CCUSTO)$"04022000" .and. SCR->CR_NIVEL = '01'
					delete
				endif
				if rlock() .and. (CR_USER = SA2->A2_XCODUSR .or. CR_APROV = SA2->A2_XCODUSR .or. ZZE->ZZE_USERID = CR_USER)
					lAchou := .t.
					_cNivel := SCR->CR_NIVEL
					// Antes de excluir, verifica se possui mais algum registro para nใo ficar sem aprovador
					nReg := Recno()
					skip
					if CR_FILIAL+CR_TIPO+CR_NUM = xFilial("SCR")+'ZZ'+ZZE->ZZE_NUMERO
						goto nReg
						if !trim(SA2->A2_XCODUSR)$"001748*001448" // Regra especํfica para diretores
							delete
						Endif
					else // Se tiver nํvel superior nใo irแ deletar , e sim alterar o aprovador para o pr๓ximo nํvel - LE 21/
						goto nReg
						_cGrpApv := Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
						Select SAL
						dbSetOrder(2)
						seek xFilial()+_cGrpApv
						lMuda := .f.
						do while !eof() .and. _cGrpApv = AL_COD
							if sal->AL_USER = SCR->CR_USER
								skip
								if _cGrpApv = AL_COD
									cUser  := sal->AL_USER
									cAprov := sal->AL_APROV
									lMuda := .t.
								endif
							endif
							skip
						enddo
						if lMuda
							RecLock("SCR",.f.)
							scr->cr_USER := cUser
							scr->cr_APROV:= cAprov
						endif
					endif
					//				delete
				else
//				Verifica se aprovador tem al็ada inferior ao usuแrio do reembolso
				//xxxxxx
						_cGrpApv := Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
						Select SAL
						dbSetOrder(2)
						seek xFilial()+_cGrpApv
						cNivel := ""
						cUser := cAprv := ""
						Do while !eof() .and. _cGrpApv = AL_COD
							if SA2->A2_XCODUSR = SAL->AL_USER
								cNivel := AL_NIVEL
							endif
							if AL_NIVEL>cNivel .and. !empty(cNivel)
								cUser := SAL->AL_USER
								cAprv := SAL->AL_APROV
								exit
							endif
							skip
						Enddo
						if !empty(cNivel)
							Select SCR
							Seek xFilial()+'ZZ'+ZZE->ZZE_NUMERO
							nReg01 := nReg02 := 0
							lAltera := .f.
							do while !eof() .and. trim(ZZE->ZZE_NUMERO) = trim(SCR->CR_NUM)
								if scr->cr_nivel < cNivel
									nReg01 := recno()
									lAltera := .t.
								endif
								if scr->cr_nivel > cNivel
									nReg02 := recno()
									lAltera := .f.
									exit
								endif
								skip
							enddo
							if lAltera
								IF !EMPTY(cUser) .and. nReg02=0
									dbgoto(nReg01)
									RecLock("SCR",.f.)
									scr->cr_USER := cUser
									scr->cr_APROV:= cAprv 
									MsUnLock()
								endif
							endif
						endif
				endif
//				endif          
				Select SCR
				cAprov += scr->cr_user+'*'
				skip
			enddo
			If AllTrim(AllTRIM(ZZE->ZZE_CCUSTO)) == "03042400"
				Select SCR
				Seek xFilial()+'ZZ'+ZZE->ZZE_NUMERO
				do while !eof() .and. CR_FILIAL+CR_TIPO+CR_NUM = xFilial("SCR")+'ZZ'+ZZE->ZZE_NUMERO
					if rlock() .and. CR_NIVEL == _cNivel
						delete
					endif
					skip
				enddo
			EndIf
			if lAchou
				If !Empty(SA2->A2_XCODUSR)
					_cQuery	:= "SELECT AL_APROV, AL_USER, AL_NIVEL "
					_cQuery	+= " FROM " + RetSqlName("SAL") + " SAL "
					_cQuery	+= " WHERE AL_COD = '" + _cGrpApv + "'"
					_cQuery	+= " AND AL_NIVEL > (SELECT AL_NIVEL FROM SAL080 WHERE AL_COD = '" + _cGrpApv + "' AND AL_USER = '" + SA2->A2_XCODUSR + "' AND D_E_L_E_T_ = ' ')"
					_cQuery	+= " AND D_E_L_E_T_ = ' '"
					_cQuery	+= " ORDER BY AL_NIVEL,AL_ITEM"
					TcQuery _cQuery New Alias &(_cAliasSAL)

					If (_cAliasSAL)->(!EOF()) .and. !trim((_cAliasSAL)->AL_USER)$cAprov  // Verific se jแ existe o aprovador
						If RecLock("SCR",.T.)
							SCR->CR_FILIAL	:= xFilial("SCR")
							SCR->CR_TIPO	:= "ZZ"
							SCR->CR_USER	:= (_cAliasSAL)->AL_USER
							SCR->CR_APROV	:= (_cAliasSAL)->AL_APROV
							SCR->CR_NIVEL	:= (_cAliasSAL)->AL_NIVEL
							SCR->CR_STATUS	:= '02'
							SCR->CR_NUM		:= ZZE->ZZE_NUMERO
							SCR->CR_TOTAL	:= ZZE->ZZE_VALOR
							SCR->CR_EMISSAO	:= ZZE->ZZE_DATA
							SCR->CR_MOEDA	:= ZZE->ZZE_MOEDA
							SCR->(MsUnLock())
						EndIf
					EndIf
					(_cAliasSAL)->(dbCloseAre())
					_lOk	:= .T.
				endif

				/*			_cQuery	:= "UPDATE " + RetSqlName("SCR")
				_cQuery	+= " SET D_E_L_E_T_ = '*'"
				_cQuery	+= " WHERE CR_FILIAL = '" + xFilial("SCR") + "'"
				_cQuery	+= " AND CR_NUM = '" + ZZE->ZZE_NUMERO + "'"
				_cQuery += " AND CR_TIPO = 'ZZ'"
				_cQuery += " AND CR_USER = '" + SA2->A2_XCODUSR + "'"
				TCSQLEXEC(_cQuery)
				DBCOMMIT()
				*/

			Else
			EndIf
		Else   // Verifica se o fornecedor nใo ้ aprovador por้m estแ sendo aprovado pelo solicitante
			Select SCR
			Seek xFilial()+'ZZ'+ZZE->ZZE_NUMERO
			cAprov := ''
			do while !eof() .and. CR_FILIAL+CR_TIPO+CR_NUM = xFilial("SCR")+'ZZ'+ZZE->ZZE_NUMERO
				if rlock() .and. ZZE->ZZE_USERID = CR_USER
					lAchou := .t.
					if !trim(SA2->A2_XCODUSR)$"001748*001448" // Regra especํfica para diretores
						delete
					Endif
				endif
				skip
			enddo
			if lAchou
				Select SAL
				dbSetOrder(2)
				seek xFilial()+_cGrpApv
				do while !eof()
					if al_user = zze->zze_userid
						skip
						exit
					endif
					skip
				enddo
				If sal->al_cod = _cGrpApv
					If RecLock("SCR",.T.)
						SCR->CR_FILIAL	:= xFilial("SCR")
						SCR->CR_TIPO	:= "ZZ"
						SCR->CR_USER	:= SAL->AL_USER
						SCR->CR_APROV	:= SAL->AL_APROV
						SCR->CR_NIVEL	:= SAL->AL_NIVEL
						SCR->CR_STATUS	:= '02'
						SCR->CR_NUM		:= ZZE->ZZE_NUMERO
						SCR->CR_TOTAL	:= ZZE->ZZE_VALOR
						SCR->CR_EMISSAO	:= ZZE->ZZE_DATA
						SCR->CR_MOEDA	:= ZZE->ZZE_MOEDA
						SCR->(MsUnLock())
					EndIf
				EndIf
				_lOk	:= .T.
			EndIf

		EndIf
	Endif

	if trim(SA2->A2_XCODUSR)$"001748*001448" // Cria็ใo de regra especํfica para diretores
		// Diretores - Regra definida em 27/02/2020 - altera็ใo efetuada por Luiz Eduardo 
		//Veloso aprova LO
		//LO aprova: Veloso
		//001748 - Andre Pinheiro Veloso                   
		//001448 - Luis Oscar Niemeyer Soares
		_cGrpApv := Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
		Select SAL
		dbSetOrder(2)
		seek xFilial()+_cGrpApv
		do while !eof() .and. _cGrpApv = AL_COD
			if _cGrpApv = AL_COD .and. sal->AL_USER=SA2->A2_XCODUSR  
				cNivel := AL_NIVEL
			endif
			skip
		Enddo
		Select SCR
		Seek xFilial()+'ZZ'+ZZE->ZZE_NUMERO
		aAprovadores := {}
		lsobrou := l01 := .f.
		do while !eof() .and. CR_FILIAL+CR_TIPO+trim(CR_NUM) = xFilial("SCR")+'ZZ'+trim(ZZE->ZZE_NUMERO)
			//			aAdd(aAprovadores,{CR_NIVEL})
			if cNivel> CR_NIVEL //.and. Len(aAprovadores)>1 
				Reclock("SCR",.f.)
				Delete
				MsunLock()
			Else
				lsobrou := .t.
				if cr_nivel='01'
					l01 := .t.
				endif
			Endif
			skip
		enddo
		if !lSobrou
				if trim(SA2->A2_XCODUSR)$"001748" 
					cUser  := "001448" 
					cAprov := "000420"
				else
					cUser  := "001748" 
					cAprov := "000496"
				endif

			RecLock("SCR",.T.) //LE 12/03/2020
			SCR->CR_FILIAL	:= xFilial("SCR")
			SCR->CR_TIPO	:= "ZZ"
			SCR->CR_USER	:= cUser
			SCR->CR_APROV	:= cAprov
			SCR->CR_NIVEL	:= '01'//cNivel
			SCR->CR_STATUS	:= '02'
			SCR->CR_NUM		:= ZZE->ZZE_NUMERO
			SCR->CR_TOTAL	:= ZZE->ZZE_VALOR
			SCR->CR_EMISSAO	:= ZZE->ZZE_DATA
			SCR->CR_MOEDA	:= ZZE->ZZE_MOEDA
			SCR->(MsUnLock())
		endif
		dbSelectArea("SCR")
		Seek xFilial()+'ZZ'+ZZE->ZZE_NUMERO
		do while !eof() .and. CR_FILIAL+CR_TIPO+trim(CR_NUM) = xFilial("SCR")+'ZZ'+trim(ZZE->ZZE_NUMERO)
			if cNivel = CR_NIVEL 
				if trim(SA2->A2_XCODUSR)$"001748" 
					cUser  := "001448" 
					cAprov := "000420"
				else
					cUser  := "001748" 
					cAprov := "000496"
				endif
				if CR_NIVEL = cNivel
					RecLock("SCR",.f.)
					scr->cr_USER := cUser
					scr->cr_APROV:= cAprov
					MsUnLock()
				endif
				if !l01
					RecLock("SCR",.f.)
					scr->cr_nivel := "01"
					MsUnLock()
					l01 := .T.
				endif
			endif
			skip
		Enddo
		Select SCR
	endif

	RestArea(_aArea)

Return(_lOk)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAprovPA   บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอmออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao da aprovacao da solicitacao de PA                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function AprovPA()

	Local _cPAOpen		:= ""
	Local _lReturn		:= .t.
	Local _nIndice		:= 1
	Private cDesc		:= Space(10)
	Private aAreaAnt	:= GetArea()
	Private oDlg3

	DEFINE FONT _oFonte1 NAME "Arial" BOLD
	DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD

	//aTipoFor := {"Fornecedor","Colaborador","Artista","Troco","Avulso","Presta็ใo Contas","Reembolso Avulso","Impostos"}

	If Empty(cAprov)
		MsgBox("Somente os usuarios registrados como APROVADORES podem utilizar esta funcionalidade.","Atencao","ERROR")
		_lReturn:= .f.
	Endif

	If  _lReturn .And. ( ZZE->ZZE_STATUS == "C" )
		MsgBox("Essa solicita็ao foi CANCELADA, portanto nao pode ser aprovada.","Atencao","ERROR")
		_lReturn:= .f.
	Endif

	If _lReturn .And. ( ZZE->ZZE_STATUS == "L" )
		MsgBox("Essa solicita็ao ja foi LIBERADA.","Atencao","ERROR")
		_lReturn:= .f.
	Endif

	If _lReturn

		// Verifica o item a ser aprovado 
		cNum := ZZE->ZZE_NUMERO 
		cQuery1 := "SELECT CR_FILIAL,CR_NUM "
		cQuery1 += " FROM " + RetSqlName("SCR") + " SCR "
		cQuery1 += " WHERE CR_TIPO = 'ZZ'"
		cQuery1 += " AND CR_NUM = '"+cNum+"'"
		cQuery1 += " AND SCR.D_E_L_E_T_ <> '*' "
		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery1),'TRBSCR1',.F.,.T. )
		cTexto1 := TRBSCR1->(CR_FILIAL+"ZZ"+CR_NUM)
		use

		lAchou:=.F.

		dbSelectArea("SCR")
		SCR->(dbSetOrder(2))
		If SCR->(dbSeek(cTexto1 + __cUserId))
			//	If SCR->(dbSeek(xFilial("SCR") + PadR("ZZ",TamSX3("CR_TIPO")[1]) + PadR(ZZE->ZZE_NUMERO,TamSX3("CR_NUM")[1]) + __cUserId))
			If Empty(SCR->CR_DATALIB)
				lAchou:=.T.
			Else
				MsgBox("A aprova็ใo jแ foi realizada pelo usuแrio.","Atencao","ERROR")
				Return(Nil)
			EndIf
		EndIf

		If !lAchou
			if left(SM0->M0_CODFIL,2)<>left(cTexto1,2)
				MsgBox("A solicita็ใo nใo pertence a essa filial (filial correta = '"+left(cTexto1,2)+"')","Atencao","ERROR")
				_lReturn:= .f.
			else
				MsgBox("A aprova็ใo nใo estแ no seu nํvel de aprova็ใo","Atencao","ERROR")
				_lReturn:= .f.
			endif
		Endif

		//	If !lAchou
		//		MsgBox("A aprova็ใo nใo estแ no seu nํvel de aprova็ใo","Atencao","ERROR")
		//		_lReturn:= .f.
		//	Endif

	EndIf

	if left(SM0->M0_CODFIL,2)<>left(cTexto1,2)  // Luiz Eduardo - condi็ใo incluํda para avisar ao aprovador qual a filial correta 17/10/2018
		MsgBox("A solicita็ใo nใo pertence a essa filial (filial correta = '"+left(cTexto1,2)+"')","Atencao","ERROR")
		_lReturn:= .f.
	endif

	If _lReturn .and. left(SM0->M0_CODFIL,2)=left(cTexto1,2)
		// Query para verificar adiantamentos do fornecedor em aberto - Takao 15/08
		cQuery := "SELECT COUNT(*) XQTD, sum(E2_SALDO) XSALDO FROM "+retsqlname("SE2")+" WHERE "
		cQuery += "E2_FORNECE = '"+ZZE->ZZE_FORNEC+"' AND E2_LOJA = '"+ZZE->ZZE_LOJA+"' AND E2_SALDO > 0 "
		cQuery += "AND D_E_L_E_T_ = ' ' AND E2_TIPO='PA'"
		cQuery := ChangeQuery(cQuery)

		DbUseArea( .T.,"TOPCONN",TCGenQry(,,cQuery),'TRB',.F.,.T. )
		DbSelectArea("TRB")

		_cPAOpen:= ""

		If (TRB->XQTD) > 0
			_cPAOpen:= "** Hแ "+Alltrim(Str(TRB->XQTD))+" adiantamentos em aberto totalizando "+Alltrim(GetMv("MV_SIMB1"))+Alltrim(Transform(TRB->XSALDO,"@E 9,999,999.99"))
		Endif

		TRB->(DbCloseArea())


		@ 50,42 TO 510,875 DIALOG oDlg3 TITLE "APROVACAO de Solicitacao de Pagto Antecipado/Troco/Repasse"

		@ 011,010 Say "Numero: " FONT _oFonte1 OF oDlg3 PIXEL
		@ 011,080 Say ZZE->ZZE_NUMERO SIZE 20,08 PIXEL

		@ 011,150 Say "Tipo: "   FONT _oFonte1 OF oDlg3 PIXEL
		IIf(ZZE->ZZE_TIPO = 0, _nIndice := _nIndice + 10, _nIndice := _nIndice + 0) //ZZE->ZZE_TIPO )
		//		IIf(ZZE->ZZE_TIPO = 0, _nIndice := _nIndice + 10, _nIndice := _nIndice + ZZE->ZZE_TIPO ) Comentato por Thiago par a ajustar a aprova็ใo e troca de tipo.
		@ 011,200 Say RetTipo(_nIndice) PIXEL

		@ 011,290 Say "Moeda: "  FONT _oFonte1 OF oDlg3 PIXEL
		@ 011,345 Say aMoedas[ZZE->ZZE_MOEDA] SIZE 80,08 PIXEL

		@ 028,010 Say "Fornec./Colab./Artista:" FONT _oFonte1 OF oDlg3 PIXEL
		@ 027,080 Say ZZE->ZZE_FORNEC SIZE 40,08 PIXEL
		SA2->(Dbseek(xFilial("SA2")+ZZE->ZZE_FORNEC))
		@ 27,118 Say SA2->A2_LOJA PIXEL
		@ 27,135 Say SA2->A2_NOME PIXEL

		@ 044,010 Say "Centro de Custo: " FONT _oFonte1 OF oDlg3 PIXEL
		@ 043,080 Say ZZE->ZZE_CCUSTO PIXEL
		CTT->(DbSeek(xFilial("CTT")+ZZE->ZZE_CCUSTO))
		@ 043,135 Say CTT->CTT_DESC01 PIXEL

		@ 060,010 Say "Elemento PEP: " FONT _oFonte1 OF oDlg3 PIXEL
		@ 059,080 Say ZZE->ZZE_PEP PIXEL
		CTD->(DbSeek(xFilial("CTD")+ZZE->ZZE_PEP))
		@ 059,135 Say CTD->CTD_DESC01 PIXEL

		@ 078,010 Say "Historico: " FONT _oFonte1 PIXEL
		@ 076,080 Get ZZE->ZZE_HISTOR SIZE 200,008 WHEN .F. PIXEL

		@ 090,010 To 155,140 PIXEL
		@ 093,013 Say "Dados Bancแrios P/ Pagamento" FONT _oFonte1 PIXEL
		@ 113,013 Say "Banco:" FONT _oFonte1 PIXEL
		@ 128,013 Say "Agencia:" FONT _oFonte1 PIXEL
		@ 143,013 Say "Conta Corrente:" FONT _oFonte1 PIXEL
		@ 113,080 Say ZZE->ZZE_BANCO PIXEL
		@ 128,080 Say ZZE->ZZE_AGENC PIXEL
		@ 143,080 Say ZZE->ZZE_CONTA PIXEL

		@ 090,150 To 155,409 PIXEL
		@ 093,153 Say "Descricao / Motivo da Solicita็ใo de Pag Antecipado/Troco/Repassse: " FONT _oFonte1 PIXEL
		//cDesc := AllTRim(ZZE->ZZE_DESC)	//
		cDesc := AllTRim(MsMM(ZZE->ZZE_DESC))//																	 alterado por Marcio Frade
		@ 103,153 Get cDesc MEMO  SIZE 253,049	WHEN .F.  Pixel Of oDlg3

		@ 163,010 Say "Pedido de Compra:" FONT _oFonte1 PIXEL
		@ 163,080 Say ZZE->ZZE_PEDIDO PIXEL

		@ 163,150 Say "Valor:" FONT _oFonte1 PIXEL
		@ 163,200 Say ZZE->ZZE_VALOR PICTURE "@E 999,999,999.99" PIXEL

		@ 163,290 Say "Data Pagto:" FONT _oFonte1 PIXEL
		@ 163,345 Say ZZE->ZZE_DATA PIXEL

		@ 180,010 Say "Data acerto de contas:" FONT _oFonte1 PIXEL
		@ 180,080 Say ZZE->ZZE_DTAC PIXEL

		@ 197,010 Say _cPAOPEN PIXEL

		@ 214,345 BMPBUTTON TYPE 1 ACTION Eval( {|| AprPA(), oDlg3:End() } )
		@ 214,383 BMPBUTTON TYPE 2 ACTION (oDlg3:End())

		ACTIVATE DIALOG oDlg3 CENTERED

	EndIF

	// Restaura Area Anterior
	RestArea(aAreaAnt)

Return( _lReturn )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAprPA     บ Autor ณ Claudio            บ Data ณ  26/06/08   บฑฑ
ฑฑฬออออออออออุอออออออออสอmออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao da aprovacao da solicitacao de PA                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManut.    ณ 17/11/09 Gilberto: Alteracao para contemplar a aprovacao deบฑฑ
ฑฑบ          ณ alcadas de mesmo nivel. Uma aprovacao no nivel aprova todo บฑฑ
ฑฑบ          ณ o nivel e prepara os seguintes.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ Alterado por Takao - tratamento de aprovadores cadastrados บฑฑ
ฑฑบ          ณ mais de 1 vez reestruturado por Takao					  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function AprPA()

	Local aAreaAnt		:= GetArea()
	Local lContinua		:= .f.
	Local lAprovou		:= .f.
	Local cCC			:= Space(20)
	Local cNivApr		:= Space(03)
	Local cUltNivel		:= Space(03)
	Local cAprovAux		:= Space(06)
	Local cQuery		:= Space(01)
	Local cUltZZ6		:= Space(03)
	Local _cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
	Local _cAliasAPV	:= GetNextAlias()
	Local _cQuery		:= ""
	Local _cNumero		:= ZZE->ZZE_NUMERO

	If MsgBox("Confirma a APROVAวรO desta Solicita็ใo ?","Atencao","YESNO")

		dbSelectArea("SCR")
		SCR->(dbSetOrder(2))
		If SCR->(dbSeek(xFilial("SCR") + PadR("ZZ",TamSX3("CR_TIPO")[1]) + PadR(ZZE->ZZE_NUMERO,TamSX3("CR_NUM")[1]) + __cUserId))
			//		MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",ZZE->ZZE_VALOR,SCR->CR_APROV,__cUserId,,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},dDataBase,4)				
			MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,ZZE->ZZE_VALOR,SCR->CR_APROV,,ZZE->ZZE_XGRPAP,,,,,    },dDataBase,4)				
		EndIf

		_cQuery	:= "SELECT CR_NUM "
		_cQuery	+= " FROM " + RetSqlName("SCR") + " SCR "
		_cQuery	+= " WHERE CR_NUM = '" + ZZE->ZZE_NUMERO + "'"
		_cQuery	+= " AND CR_DATALIB = ' '"
		_cQuery	+= " AND D_E_L_E_T_ = ' '"

		TcQuery _cQuery New Alias &(_cAliasAPV)

		If (_cAliasAPV)->(!EOF())
			ZZE->(dbSetOrder(1))
			ZZE->(dbGoTop())
			If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
				While ZZE->(!EOF()) .And. ZZE->ZZE_NUMERO == _cNumero
					If Reclock("ZZE",.F.)
						ZZE->ZZE_STATUS := "E"
						MsUnlock()
					EndIf
					ZZE->(dbSkip())
				EndDo
			EndIf

		Else
			ZZE->(dbSetOrder(1))
			ZZE->(dbGoTop())
			If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
				While ZZE->(!EOF()) .And. ZZE->ZZE_NUMERO == _cNumero
					If Reclock("ZZE",.f.)
						ZZE->ZZE_STATUS := "L"
						MsUnlock()
						If ZZE->ZZE_TIPO == 9 .And. !Empty( GetMv("T4F_MAILRP") )
							//							SendEMail()
						EndIf
					EndIf									
					ZZE->(dbSkip())
				EndDo
			EndIf
		EndIf

		(_cAliasAPV)->(dbCloseArea())
	Endif

	RestArea(aAreaAnt)
Return(Nil)

//
Static Function EnvEmail()

	Local oDlg
	Local aFiles    := Array(1)
	//Local cDestEmail := "cmissura@t4f.com.br"                             // GetMv("MV_XMAILAP",,"microsiga01@t4f.com.br")
	Local cDestEmail := SuperGetMv("T4F_MAILRP",,"cmissura@t4f.com.br")   // microsiga01@t4f.com.br"  //GetMv("MV_XMAILAP",,"microsiga01@t4f.com.br")
	Local _cSUBJECT  := "[AVISO] Libera็ใo de Repasse"

	Local cTxtEMail := "Aten็ใo : Foi liberada solicita็ใo de repasse numero : "+ZZE->ZZE_NUMERO

	U_EnvEmail(cDestEmail,_cSUBJECT,cTxtEmail,aFiles,.F.,oDlg)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCancPA      บ Autor ณ Claudio            บ Data ณ  26/06/08 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao do cancelamento da solicita็ใo de PA              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CancPA()

	Local _lReturn	:= .t.
	Local oDlg
	Local aAreaAnt 	:= GetArea()
	Local _nIndice	:= 1
	Private cDesc	:= Space(10)

	DEFINE FONT _oFonte1 NAME "Arial" BOLD
	DEFINE FONT _oFonte2 NAME "Arial" SIZE 08,17 BOLD

	If ( __cUserId <> ZZE->ZZE_USERID ) .And. ( Upper(Alltrim(cUserName)) != "ADMINISTRADOR"  )
		Msgbox("Somente o proprio solicitante pode cancelar uma solicitacao de PA.","Atencao","ERROR")
		_lReturn:= .f.
	Endif

	If  _lReturn .And. !Empty(ZZE->ZZE_TITULO)
		Msgbox("Essa Solicitacao de Pagamento Antecipado nao pode ser cancelada porque"+chr(13)+;
		"ja foi gerado o titulo de pagamento antecipado.","Atencao","INFO")
		_lReturn:= .f.
	Endif

	If _lReturn .And. ( ZZE->ZZE_STATUS == "C" )
		Msgbox("Essa solicita็ao jแ estแ cancelada.","Atencao","ERROR")
		_lReturn:= .f.
	Endif

	If _lReturn

		@ 050,042 TO 510,875 DIALOG oDlg TITLE "CANCELAMENTO de Solicitacao de Pagto Antecipado/Troco/Repasse"

		@ 011,010 Say "Numero: " FONT _oFonte1 PIXEL
		@ 011,080 Say ZZE->ZZE_NUMERO SIZE 20,08 PIXEL

		@ 011,150 Say "Tipo: " FONT _oFonte1 PIXEL
		IIf(ZZE->ZZE_TIPO = 0, _nIndice := _nIndice + 10, _nIndice := _nIndice + 0) //ZZE->ZZE_TIPO )
		//		IIf(ZZE->ZZE_TIPO = 0, _nIndice := _nIndice + 10, _nIndice := _nIndice + ZZE->ZZE_TIPO ) Comentado por Thiago para ajustar a troca de tipo na aprova็ใo.
		@ 011,200 Say aTipoFor[_nIndice] PIXEL

		@ 011,290 Say "Moeda: " FONT _oFonte1 PIXEL
		@ 011,345 Say aMoedas[ZZE->ZZE_MOEDA] SIZE 80,08 PIXEL

		@ 028,010 Say "Fornec./Colab./Artista:" FONT _oFonte1 PIXEL
		@ 027,080 Say ZZE->ZZE_FORNEC SIZE 40,08 PIXEL
		SA2->( Dbseek(xFilial("SA2")+ZZE->ZZE_FORNEC))
		@ 027,118 Say SA2->A2_LOJA PIXEL
		@ 027,135 Say SA2->A2_NOME PIXEL

		@ 044,010 Say "Centro de Custo: " FONT _oFonte1 PIXEL
		@ 043,080 Say ZZE->ZZE_CCUSTO PIXEL
		CTT->( DbSeek(xFilial("CTT")+ZZE->ZZE_CCUSTO))
		@ 043,135 Say CTT->CTT_DESC01 PIXEL

		@ 060,010 SaY "Elemento PEP: " FONT _oFonte1 PIXEL
		@ 059,080 Say ZZE->ZZE_PEP PIXEL
		CTD->( Dbseek(xFilial("CTD")+ZZE->ZZE_PEP))
		@ 059,135 Say CTD->CTD_DESC01 PIXEL

		@ 078,010 Say "Historico: " FONT _oFonte1 PIXEL
		@ 076,080 Say ALLTRIM(ZZE->ZZE_HISTOR) SIZE 200,008  PIXEL

		@ 090,010 TO 155,140 PIXEL
		@ 093,013 Say "Dados Bancแrios P/ Pagamento" FONT _oFonte1 PIXEL
		@ 113,013 Say "Banco:" FONT _oFonte1 PIXEL
		@ 128,013 Say "Agencia:" FONT _oFonte1 PIXEL
		@ 143,013 Say "Conta Corrente:" FONT _oFonte1 PIXEL
		@ 113,080 Say ZZE->ZZE_BANCO PIXEL
		@ 128,080 Say ZZE->ZZE_AGENC PIXEL
		@ 143,080 Say ZZE->ZZE_CONTA PIXEL

		@ 090,150 TO 155,409 PIXEL
		@ 093,153 Say "Descricao / Motivo da Solicita็ใo de Pagto Antecipado/Troco/Repasse: " FONT _oFonte1 PIXEL
		cDesc := AllTRim(MsMM(ZZE->ZZE_DESC))
		@ 103,153 Get cDesc MEMO  SIZE 253,049	WHEN .F.  Pixel Of oDlg

		@ 163,010 Say "Pedido de Compra:" FONT _oFonte1 PIXEL
		@ 163,080 Say ZZE->ZZE_PEDIDO PIXEL

		@ 163,150 Say "Valor:" FONT _oFonte1 PIXEL
		@ 163,200 Say ZZE->ZZE_VALOR Picture "@E 999,999,999.99" PIXEL

		@ 163,290 Say "Data Pagto:" FONT _oFonte1 PIXEL
		@ 163,345 Say ZZE->ZZE_DATA PIXEL

		@ 180,010 Say "Data acerto de contas:" FONT _oFonte1 PIXEL
		@ 180,080 Say ZZE->ZZE_DTAC PIXEL

		@ 214,345 BMPBUTTON TYPE 1 ACTION Eval( {|| ConfCancPA(), oDlg:End() } )
		@ 214,383 BMPBUTTON TYPE 2 ACTION Eval({||oDlg:End()})
		ACTIVATE DIALOG oDlg CENTERED

	EndIF

	RestArea(aAreaAnt)
Return( _lReturn )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConfCancPA   บ Autor ณ Claudio         บ Data ณ    26/06/08 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gravacao do cancelamento da solicita็ใo de PA              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ConfCancPA()

	Local aAreaAnt	:= GetArea()
	Local cCusto 	:= CRIAVAR("ZZ5_CC")
	Local cNivApr	:= CRIAVAR("ZZ5_NIVEL")
	Local _cGrpApv	:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
	Local _cNumero		:= ZZE->ZZE_NUMERO

	If MsgBox("Confirma o CANCELAMENTO dessa Solicitacao de Pagamento Antecipado ?","Atencao","YESNO")

		BEGIN TRANSACTION

			//		MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",ZZE->ZZE_VALOR,,,_cGrpApv,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},dDataBase,5)				
			MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",ZZE->ZZE_VALOR,,,_cGrpApv,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},dDataBase,3)				

			ZZE->(dbGoTop())     
			ZZE->(dbSetOrder(1))
			If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
				While ZZE->(!EOF()) .And. ZZE->ZZE_NUMERO == _cNumero
					If RecLock("ZZE",.F.)
						ZZE->ZZE_STATUS	:= "C"
						ZZE->( MsUnLock() )
					EndIf
					ZZE->(dbSkip())
				EndDo
			EndIf

		END TRANSACTION

	Endif

	// Restaura Area Anterior
	RestArea( aAreaAnt )
Return(Nil)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ HISTAPR  บAutor  ณBruno Daniel Borges บ Data ณ  21/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de consulta do historico da aprovacao da solicitacao บฑฑ
ฑฑบ          ณde compras                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function HistApr()

	Local aAreaBKP	:= GetArea()
	Local cQuery	:= ""
	Local bQuery	:= {|| Iif(Select("TRB_ZZ6") > 0, TRB_ZZ6->(dbCloseArea()), Nil), dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB_ZZ6",.F.,.T.), dbSelectArea("TRB_ZZ6"), TRB_ZZ6->(dbGoTop()) }
	Local aAlcada	:= {}
	Local aStatus	:= {}
	Local oDlgMain	:= Nil
	Local oListGrps	:= Nil
	Local aCoorden	:= MsAdvSize(.T.)
	Local cNumPA	:= ZZE->ZZE_NUMERO
	Local _lReturn  := .t.
	Local cNomeUser	:= ""
	Local _cAliasCR	:= GetNextAlias()
	Local _cGrpApv	:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")

	Aadd( aStatus, "Aguardando aprova็ใo nesse nํvel" )
	Aadd( aStatus, "Aprovada nesse Nํvel" )
	Aadd( aStatus, "Cancelada nesse nํvel" )
	Aadd( aStatus, "Parada em nํveis anteriores" )
	Aadd( aStatus, "Invalida Por Conflito de Al็ada" )


	If ( ZZE->ZZE_STATUS == "C" )

		Msgbox("Essa solicita็ใo de PA foi cancelada","Atencao","INFO")

	Else

		//Query que retorna o historico de aprovacao
		cQuery := " SELECT ZZ6_NIVEL, ZZ6_STATUS, ZZ6_HRENT, ZZ6_DTENT, ZZ6_HRSAI, ZZ6_DTSAI, AK_NOME, ZZ6_MEMO1 "
		cQuery += " FROM " + RetSQLName("ZZ6") + " A, " + RetSQLName("SAK") + " B "
		cQuery += " WHERE ZZ6_FILIAL = '" + xFilial("ZZ6") + "' AND ZZ6_PA = '" + cNumPA + "' AND A.D_E_L_E_T_ = ' ' AND "
		cQuery += "       AK_FILIAL = '" + xFilial("SAK") + "' AND AK_COD = ZZ6_APROV AND B.D_E_L_E_T_ = ' ' "
		cQuery += " ORDER BY ZZ6_NIVEL "

		cQuery := ChangeQuery(cQuery)

		// Executa Query
		LjMsgRun( "Buscando Hist๓rico de Aprova็ใo","Aguarde...",bQuery)


		If TRB_ZZ6->(Eof())
			cQuery := " SELECT AL_NIVEL AS NIVEL, CR_STATUS AS SITUA, CR_EMISSAO AS EMISSAO, CR_DATALIB AS DTLIB, CR_USERLIB AS USRLIB, AK_NOME AS NOME"
			cQuery += " FROM " + RetSQLName("SCR") + " A, " + RetSQLName("SAK") + " B, " + RetSQLName("SAL") + " C "
			//		cQuery += " WHERE CR_FILIAL = '" + xFilial("SCR") + "' AND CR_NUM = '" + cNumPA + "' AND A.D_E_L_E_T_ = ' ' AND "
			cQuery += " WHERE CR_NUM = '" + cNumPA + "' AND A.D_E_L_E_T_ = ' ' AND "
			cQuery += "       AK_FILIAL = '" + xFilial("SAK") + "' AND AK_COD = CR_APROV AND B.D_E_L_E_T_ = ' ' AND "
			cQuery += "       AL_FILIAL = '" + xFilial("SAL") + "' AND AL_APROV = CR_APROV AND AL_COD = '" +_cGrpApv + "' AND C.D_E_L_E_T_ = ' ' "
			cQuery += " ORDER BY AL_NIVEL "
			TcQuery cQuery New Alias &(_cAliasCR)

			If (_cAliasCR)->(Eof())
				MsgAlert("Aten็ใo, essa solicita็ใo de pagto. antecipado nใo possui al็ada de aprova็ใo.")
				_lReturn:= .f.
			Else

				PswOrder(1)
				PswSeek((_cAliasCR)->USRLIB,.T.)

				(_cAliasCR)->( DbEval({|| Aadd(aAlcada,{(_cAliasCR)->NIVEL,;
				(_cAliasCR)->NOME,;
				Iif((_cAliasCR)->SITUA=='01','Aguardando',Iif((_cAliasCR)->SITUA=='02','Em Aprovacao',Iif((_cAliasCR)->SITUA=='03','Aprovado','Bloqueado'))),;
				SToD((_cAliasCR)->EMISSAO),;
				AllTrim(Pswret(1)[1][4]),;
				SToD((_cAliasCR)->DTLIB)}) }))

				PswOrder(1)
				PswSeek(ZZE->ZZE_USERID,.T.)
				cNomeUser:= ZZE->ZZE_USERID+" - "+AllTrim(Pswret(1)[1][4])

				//Tela de historico da aprovacao
				oDlgMain := TDialog():New(aCoorden[7],000,aCoorden[6]/1.5,aCoorden[5]/1.5,OemToAnsi("Hist๓rico de Aprova็ใo"),,,,,,,,oMainWnd,.T.)
				TSay():New(014,001,{|| OemToAnsi("Solicita็ใo")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
				@ 024,001 MsGet ZZE->ZZE_NUMERO Picture "@!" Size 030,8 When .F. Of oDlgMain Pixel

				TSay():New(014,040,{|| OemToAnsi("Solicitante")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
				@ 024,040 MsGet cNomeUser Picture "@!" Size oDlgMain:nWidth/2-50,8 When .F. Of oDlgMain Pixel

				@ 040,001 ListBox oListGrps Var cItemSel Fields Header "Nํvel","Nome Aprovador","Status","Data Emissao","Usuario Lib.","Data Liber." Size oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-55 ;
				Pixel Of oDlgMain 

				oListGrps:SetArray(aAlcada)
				oListGrps:bLine := {||{		AllTrim(aAlcada[oListGrps:nAt][1]),;
				AllTrim(aAlcada[oListGrps:nAt][2]),;
				AllTrim(aAlcada[oListGrps:nAt][3]),;
				AllTrim(aAlcada[oListGrps:nAt][4]),;
				AllTrim(aAlcada[oListGrps:nAt][5]),;
				AllTrim(aAlcada[oListGrps:nAt][6])}}

				oDlgMain:Activate(,,,.T.,,,{||EnchoiceBar(oDlgMain,{|| oDlgMain:End()},{|| oDlgMain:End()})},,)
			EndIf
			(_cAliasCR)->(dbCloseArea())
		Else

			TRB_ZZ6->( DbEval({|| Aadd(aAlcada,{TRB_ZZ6->ZZ6_NIVEL,;
			aStatus[Val(TRB_ZZ6->ZZ6_STATUS)],;
			TRB_ZZ6->ZZ6_HRENT,;
			SToD(TRB_ZZ6->ZZ6_DTENT),;
			TRB_ZZ6->ZZ6_HRSAI,;
			SToD(TRB_ZZ6->ZZ6_DTSAI),;
			TRB_ZZ6->AK_NOME,;
			TRB_ZZ6->ZZ6_MEMO1 }) }))

			PswOrder(1)
			PswSeek(ZZE->ZZE_USERID,.T.)
			cNomeUser:= ZZE->ZZE_USERID+" - "+AllTrim(Pswret(1)[1][4])

			//Tela de historico da aprovacao
			oDlgMain := TDialog():New(aCoorden[7],000,aCoorden[6]/1.5,aCoorden[5]/1.5,OemToAnsi("Hist๓rico de Aprova็ใo"),,,,,,,,oMainWnd,.T.)
			TSay():New(014,001,{|| OemToAnsi("Solicita็ใo")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
			@ 024,001 MsGet ZZE->ZZE_NUMERO Picture "@!" Size 030,8 When .F. Of oDlgMain Pixel

			TSay():New(014,040,{|| OemToAnsi("Solicitante")},oDlgMain,,,,,,.T.,,,oDlgMain:nWidth/2-5,10)
			@ 024,040 MsGet cNomeUser Picture "@!" Size oDlgMain:nWidth/2-50,8 When .F. Of oDlgMain Pixel

			@ 040,001 ListBox oListGrps Var cItemSel Fields Header "Nํvel","Nome Aprovador","Status","Hr. Entrada","Data Entrada","Hr. Saida","Data Saida","Possui Justificativa" Size oDlgMain:nClientWidth/2-5,oDlgMain:nClientHeight/2-55 ;
			Pixel Of oDlgMain ;
			On dblClick( Iif(!Empty(AllTrim(aAlcada[oListGrps:nAt][8])),MsgAlert("JUSTIFICATIVA:"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+Msmm(aAlcada[oListGrps:nAt][8])),Nil) )
			oListGrps:SetArray(aAlcada)
			oListGrps:bLine := {||{		AllTrim(aAlcada[oListGrps:nAt][1]),;
			AllTrim(aAlcada[oListGrps:nAt][7]),;
			AllTrim(aAlcada[oListGrps:nAt][2]),;
			AllTrim(aAlcada[oListGrps:nAt][3]),;
			aAlcada[oListGrps:nAt][4],;
			AllTrim(aAlcada[oListGrps:nAt][5]),;
			aAlcada[oListGrps:nAt][6],;
			Iif(!Empty(AllTrim(aAlcada[oListGrps:nAt][8])),"Sim","Nใo") }}

			oDlgMain:Activate(,,,.T.,,,{||EnchoiceBar(oDlgMain,{|| oDlgMain:End()},{|| oDlgMain:End()})},,)

		EndIf

	EndIf

	// Restaura Area Anterior
	RestArea(aAreaBKP)
Return(Nil)

/// REVISADO ATE' AQUI   **************

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ TF4_003LEGณAutor ณAlexandre Inacio Lemes ณData  ณ11/04/2006ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Cria uma janela contendo a legenda da mBrowse              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ T4F                                                        ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function LEG()

	Local aLegenda := {{"ENABLE","Liberado"},;
	{"DISABLE","Aguardando analise pelos aprovadores"},;
	{"BR_AMARELO","Em processo de aprovacao"},;
	{"BR_PRETO","Cancelado"}}
	BrwLegenda("","Legenda", aLegenda )
return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ IncluiPC บAutor  ณBruno Daniel Borges บ Data ณ  30/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de prestacao de contas avulsa e de pagamento antecipadoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ 17/11/09 Gilberto: Acerto da validacao do campo Codigo do  บฑฑ
ฑฑบ          ณ fornecedor. Nao estava validando.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function IncluiPC()
	Local aAreaBKP    := GetArea()
	Local oWizard     := Nil
	Local oPainel     := Nil
	Local oFonte1     := TFont():New("Arial",,18,,.T.)
	Local oFonte2     := TFont():New("Arial",,14,,.T.)
	Local cFavorecido := Space(50)
	Local cCC         := Space(20)
	Local cDescCC     := Space(55)
	Local cElePep     := Space(20)
	Local cDescElePep := Space(50)
	Local cObs        := ""
	Local aHeader     := {}
	Local aCols       := {}
	Local aHeadSDE    := {}
	Local aColsSDE    := {}
	Local nLoop       := 0
	Local oDlg4 

	Private cFornecedor := Space(6)
	Private cLoja 	  	:= Space(2)
	Private cNome 		:= Space(50)
	Private cBanco      := Space(3)
	Private cAgencia    := Space(6)
	Private cContaCorr      := Space(15)
	Private oSay1     := Nil
	Private oSay2     := Nil
	Private oGetDados := Nil
	Private cPagtoAdto:= Space(6)
	Private oSay3       := Nil
	Private oCombTp     := Nil
	Private oGetDRateio := {}
	Private cPedido:= "" // Criado por Gilberto para compatilidade da funcao de geracao da alcada. 16/04/2010
	Private lPAPC	    := SuperGetMv("MV_PACOMPC",,.F.) //Informar se PC ้ obrigatorio para inserir PA ( Sergio Celestino )

	If !("T4F_003" $ AllTrim(FunName()))
		INCLUI := .T.
		Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
		{"Visualizar","AxVisual",0,2},;
		{"Incluir","U_IncluiPA(1)",0,3},;
		{"Prest. Contas","U_IncluiPC()",0,3},;
		{"Aprovar","U_AprovPA",0,2},;
		{"Estornar","U_EstPA",0,3},;
		{"Cancelar","U_CancPA",0,3},;
		{"Hist Aprovacao","U_fHistApr",0,2},;
		{"Legenda","U_LEG",0,2}}	//"Legenda"
	EndIf

	//Monta aHeader e aCols da getdados de recibos de despesa
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("ZZP"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "ZZP"
		If X3Uso(SX3->X3_USADO)
			Aadd(aHeader,{	Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,	;
			SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,,"",	;
			SX3->X3_VISUAL,SX3->X3_VLDUSER,SX3->X3_PICTVAR,SX3->X3_OBRIGAT })
		EndIf
		SX3->(dbSkip())
	EndDo

	//Monta aHeader e aCols da getdados de recibos de despesa
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SDE"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SDE"
		If AllTrim(SX3->X3_CAMPO) $ "DE_ITEM|DE_PERC|DE_CC"
			Aadd(aHeadSDE,{	Trim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,	;
			SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,,"",	;
			SX3->X3_VISUAL,SX3->X3_VLDUSER,SX3->X3_PICTVAR,SX3->X3_OBRIGAT })
		EndIf
		SX3->(dbSkip())
	EndDo

	AAdd(aCols,Array(Len(aHeader)+1))
	AEval(aHeader,{|x| nLoop++, aCols[Len(aCols)][nLoop] := Iif(AllTrim(aHeader[nLoop][2]) == "ZZP_ID","01",CriaVar(aHeader[nLoop][2]))  })
	aCols[Len(aCols)][Len(aHeader)+1] := .F.

	nLoop := 0
	AAdd(aColsSDE,Array(Len(aHeadSDE)+1))
	AEval(aHeadSDE,{|x| nLoop++, aColsSDE[Len(aColsSDE)][nLoop] := Iif(AllTrim(aHeadSDE[nLoop][2]) == "DE_ITEM","001",CriaVar(aHeadSDE[nLoop][2]))  })
	aColsSDE[Len(aColsSDE)][Len(aHeadSDE)+1] := .F.

	//Tela de inclusao da prestacao de contas
	oWizard := APWizard():New("Presta็ใo de Contas/Reembolso de Despesas","Assistente de solicita็ใo...","Presta็ใo de Contas/Reembolso de Despesas","Esse assistente irแ conduzi-lo no processo de inclusใo de Presta็๕es de Contas e/ou Reembolso de Despesas Avulsas. Clique no botใo AVANวAR para dar sequ๊ncia.",{|| .T.},{|| .T.},.T.,,,)
	//Etapa 1: Preenchimento dos dados do solicitante (funcionario = fornecedor)
	oWizard:NewPanel("Etapa 1 de 4: Identifica็ใo do Solicitante","Preencha os campos abaixo para identificar seu reembolso e os dados para pagamento...",{||.T.},{|| U_Vld_Wizard(2,{oCombTp:aItems[oCombTp:nAt],cFornecedor+"01",cCC},Nil) },{||.T.},.F.,)
	oPainel := oWizard:GetPanel(2)
	TSay():New(003,003,{||"Tipo "},oPainel,,,.F.,,,.T.,CLR_HBLUE,,040,011)

	oCombTp := TComboBox():New(001,020,,{"","6-Despesa Avulsa","7-Presta็ใo de Contas"},065,010,oPainel,,{|| },,,,.T.,,"",.T.,,.T.)

	TSay():New(003,090,{||"Fornecedor "},oPainel,,,.F.,,,.T.,CLR_HBLUE,,050,011)
	@ 001,120 MSGet cFornecedor Size 030,010  When .T. F3 'SA2' Picture '@!' Valid(valfor(cFornecedor,"2")) Pixel Of oPainel //Cleverson 160322 cFornece para cFornecedor
	@ 001,155 MSGet cLoja 		Size 015,010  When .T. Picture '@!' Valid( ValLoja(cFornecedor,cLoja,"4") ) Pixel Of oPainel //Cleverson 160322 cFornece para cFornecedor
	
	@ 026,080 MsGet oFornece  Var cFornecedor  Of oDlg4 Pixel F3 "SA2"     Valid ValFor(cFornecedor,"1")
	@ 026,118 MsGet oLoja     Var cLoja     Of oDlg4 Pixel SIZE 07,08   Valid ValLoja(cFornecedor,cLoja) .And. NaoVazio(cLoja)
	
	@ 001,175 MSGet cNome 		Size oPainel:nClientWidth/2-180,010 When .F. Picture '@!' Pixel Of oPainel

	TSay():New(023,003,{||"Bco "},oPainel,,,.F.,,,.T.,,,oPainel:nClientWidth/2-30,011)
	@ 020,020 MSGet cBanco Size 015,010 When .F. F3 'ZO' Picture '@!' Pixel Of oPainel

	TSay():New(023,065,{||"Ag๊ncia / Conta"},oPainel,,,.F.,,,.T.,,,oPainel:nClientWidth/2-30,011)
	@ 020,105 MSGet cAgencia Size 040,010 When .F. Picture '@!' Pixel Of oPainel
	@ 020,155 MSGet cContaCorr Size 080,010 When .F. Picture '@!' Pixel Of oPainel

	TSay():New(043,003,{||"Pagto. Antecipado"},oPainel,,,.F.,,,.T.,,,090,011)
	@ 040,050 MSGet cPagtoAdto Size 030,010 When oCombTp:nAt == 3 F3 'ZZE2' Valid(U_Vld_Wizard(7)) Picture '@!' Pixel Of oPainel


	TSay():New(043,090,{||"Centro Custo"},oPainel,,,.F.,,,.T.,CLR_HBLUE,,050,011)
	//	@ 040,130 MSGet cCC Size 038,010 When .T. F3 'CTT' Picture '@!' Valid( Iif( VldCCEL("CC",cCC) ,(cDescCC := Posicione("CTT",1,xFilial("CTT")+AllTrim(cCC),"CTT->CTT_DESC01" ), .T.),.F.))  Pixel Of oPainel
	@ 040,130 MSGet cCC Size 038,010 When .T. F3 'CTT' Picture '@!' Valid(Iif( VldCCEL("CC",cCC)    ,  (cDescCC    := Iif(!Empty(cCC)   , Posicione("CTT",1,xFilial("CTT")+AllTrim(cCC),"CTT->CTT_DESC01" ),' '), .T.),.F.))  Pixel Of oPainel
	@ 040,175 MSGet cDescCC Size oPainel:nClientWidth/2-180,010 When .F. Picture '@!' Pixel Of oPainel

	TSay():New(062,003,{||"Elemento PEP"},oPainel,,,.F.,,,.T.,,,090,011)
	//@ 060,040 MSGet cElePep Size 050,010 When .T. F3 'CTD' Valid( IIf(ExistCpo("CTD",AllTrim(cElePep),,,,.F.),(cDescElePep := Posicione("CTD",1,xFilial("CTD")+AllTrim(cElePep),"CTD->CTD_DESC01" ), .T.),.F.)) Picture '@!' Pixel Of oPainel
	//	@ 060,040 MSGet cElePep Size 050,010 When .T. F3 'CTD' Valid( IIf( VldCCEL("EP",cElePep) ,(cDescElePep := Posicione("CTD",1,xFilial("CTD")+AllTrim(cElePep),"CTD->CTD_DESC01" ), .T.),.F.)) Picture '@!' Pixel Of oPainel

	@ 060,040 MSGet cElePep Size 050,010 When .T. F3 'CTD' Valid( IIf( VldCCEL("EP",cElePep) , ( cDescElePep:= Iif(!Empty(cElePep),Posicione("CTD",1,xFilial("CTD")+AllTrim(cElePep),"CTD->CTD_DESC01" ),' '), .T.), .F.) ) Picture '@!' Pixel Of oPainel
	@ 060,095 MSGet cDescElePep Size oPainel:nClientWidth/2-100,010 When .F. Picture '@!' Pixel Of oPainel

	TSay():New(075,003,{||"Observa็๕es"},oPainel,,,.F.,,,.T.,,,090,011)
	@ 085,003 Get cObs SIZE oPainel:nClientWidth/2-10,040 Memo Pixel Of oPainel

	//Etapa 2: Preenchimento dos produtos/servicos da prestacao de contas
	oWizard:NewPanel("Etapa 2 de 4: Despesas/Comprovantes","Preencha as linhas conforme os recibos/comprovantes das despesas...",{||.T.},{|| U_Vld_Wizard(3,Nil,oGetDados) },{|| U_Vld_Wizard(3,Nil,oGetDados) },.F.,)
	oPainel := oWizard:GetPanel(3)
	oGetDados := MsNewGetDados():New(003,003,oPainel:nClientHeight/3,oPainel:nClientWidth/2-5,GD_INSERT+GD_DELETE+GD_UPDATE,,,"+ZZP_ID",,,9999,,,,oPainel,aHeader,aCols)
	oGetDados:bDelOk   := {|| U_Vld_Wizard(5) }
	oGetDados:bLinhaOk := {|| U_Vld_Wizard(6) }

	oSay1 := TSay():New(oPainel:nClientHeight/3+10,005,{||"TOTAL PRESTAวรO DE CONTAS: R$ 0,00"},oPainel,,oFonte1,.F.,,,.T.,CLR_HBLUE,,oPainel:nClientWidth/2-20,015)
	oSay2 := TSay():New(oPainel:nClientHeight/3+25,005,{||"TOTAL ADIANTAMENTO DE DESPESAS: R$ 0,00"},oPainel,,oFonte1,.F.,,,.T.,CLR_HRED,,oPainel:nClientWidth/2-20,015)

	//Etapa 3: Rateio do Centro de Custo x Conta Contabil
	oWizard:NewPanel("Etapa 3 de 4: Rateio entre Centros de Custo",;
	"Caso se aplique a essa solicita็ใo, informe o rateio nos centros de custo envolvidos...",;
	{||.T.},;
	{|| Iif(U_Vld_Wizard(9),Gera_Reembolso(cFornecedor,cLoja,cCC,cBanco,cAgencia,cContaCorr,cElePep,cPagtoAdto,cObs),.F.)  },{|| .T. },.F.,)
	oPainel := oWizard:GetPanel(4)
	oGetDRateio := MsNewGetDados():New(003,003,oPainel:nClientHeight/2-5,oPainel:nClientWidth/2-5,GD_INSERT+GD_DELETE+GD_UPDATE,,,"+DE_ITEM",,,9999,,,,oPainel,aHeadSDE,aColsSDE)
	oGetDRateio:bLinhaOk := {|| U_Vld_Wizard(8) }
	oGetDRateio:bTudoOk  := {|| U_Vld_Wizard(9) }

	//Etapa 4: Encerrameto do processo
	oWizard:NewPanel("Etapa 4 de 4: Processo Encerrado","Abaixo os dados da confirma็ใo da grava็ใo da presta็ใo de contas/reembolso de despesas...",{||.F.},{||.T.},{||.T.},.F.,)
	oPainel := oWizard:GetPanel(5)
	oSay3 := TSay():New(005,005,{|| ""},oPainel,,oFonte2,.F.,,,.T.,,,oPainel:nClientWidth/2-20,050)
	oWizard:Activate(.T.,,,)

	RestArea(aAreaBKP)

Return(Nil)


Static Function VldCCEL(cTpVld,cParam)

	Local lRet:= .t.



	If cTpVld == "CC" 

		IF !trim(cParam)==trim(Posicione("CTT",1,xFilial("CTT")+cParam,"CTT_CUSTO"))
			ApMsgStop("Favor preencher o campo Centro de Custo completo!!")
			lRet := .f.
		EndIf

		If !ExistCpo("CTT",AllTrim(cParam),,,,.F.)
			//ApMsgStop("Registro nใo encontrado...")
			lRet := .f.
		EndIf

		If lRet .And. Posicione("CTT",1,xFilial("CTT")+cParam,"CTT_BLOQ") == '1'
			ApMsgStop("Centro de Custo Bloqueado!!")
			lRet := .f.
		EndIf

		If SM0->M0_CODIGO # '16' .and. lRet .And. trim(Posicione("CTT",1,xFilial("CTT")+cParam,"CTT_DESC02")) == "VICAR" 
			ApMsgStop("Centro de Custo VICAR nใo poderแ ser utilizado nessa empresa.")
			lRet:= .f.
		endif

	ElseIf cTpVld == "EP"

		If 	!Empty(Alltrim(cParam))

			If  !Empty(cParam) .And. !ExistCpo("CTD",AllTrim(cParam),,,,.F.)
				//ApMsgStop("Elemento PEPE nใo encontrado...")
				lRet:= .f.
			ElseIf !Empty(cParam) .And. Posicione("CTD",1,xFilial("CTD")+cParam,"CTD_BLOQ") == '1'
				ApMsgStop("Elemento PEPE Bloqueado !!")
				lRet:= .f.
			EndIf
		EndIf

	Endif

Return( lRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVld_WizardบAutor  ณBruno Daniel Borges บ Data ณ  30/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de validacao entre mudancas de tela do Wizard de     บฑฑ
ฑฑบ          ณPrestacao de Contas                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Vld_Wizard(nWizard,aCampos)
	Local i             := 0
	Local lTemDespesa   := .F.
	Local nPosCod       := 0
	Local nPosQtde      := 0
	Local nPosValor     := 0
	Local nTotal        := 0
	Local nPosTotal     := 0
	Local aDadosZZE     := {}
	Local aAreaBKP      := GetArea()
	Local nZZERecno     := ZZE->(RecNo())
	Local nPosCC        := 0
	Local nPosPercentual:= 0
	Local lVld           := .t.

	If nWizard == 2 //Tela de identificacao e dados bancarios
		For i := 1 To Len(aCampos)
			If Empty(aCampos[i])
				MsgAlert("Aten็ใo, todos os campos em AZUL sใo de preenchimento obrigat๓rio. Preencha os campos antes de prosseguir.")
				Return(.F.)
			EndIf          
			//Verifica se o fornecedor ้ vแlido
			SA2->( DbSetorder(1) )
			SA2->( DbSeek(xFilial("SA2")+cFornecedor+cLoja) )
			If SA2->( !Found() )
				MsgBox("Codigo do fornecedor nใo encontrado.","O codigo do fornecedor nใo foi encontrado.","ERROR")
				Return(.F.)
			endif
		Next i

		//Gatilho o total do ADIANTAMENTO
		If !Empty(cPagtoAdto)
			oSay2:SetText("TOTAL ADIANTAMENTO DE DESPESAS: R$ " + AllTrim(Transform(Posicione("ZZE",1,xFilial("ZZE")+cPagtoAdto,"ZZE->ZZE_VALOR"),"@E 999,999,999.99")) )
			oSay2:Refresh()
		Else
			oSay2:SetText("TOTAL ADIANTAMENTO DE DESPESAS: R$ 0,00")
			oSay2:Refresh()
		EndIf

	ElseIf nWizard == 3 //Tela de apontamento das despesas
		nPosCod   := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_COD"    })
		nPosQtde  := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_QUANT"  })
		nPosValor := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_VRUNIT" })

		For i := 1 To Len(oGetDados:aCols)
			If !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
				If !(Empty(oGetDados:aCols[i,nPosCod]) .Or. Empty(oGetDados:aCols[i,nPosQtde]) .Or. oGetDados:aCols[i,nPosValor] <= 0)
					lTemDespesa := .T.
				EndIf
			EndIf
		Next i

		If !lTemDespesa
			MsgAlert("Aten็ใo, informe ao menos uma DESPESA. Nใo แ possํvel prosseguir sem essa informa็ใo.")
			Return(.F.)
		Else
			Return(.T.)
		EndIf
	ElseIf nWizard == 4 .Or. nWizard == 5 //Gatilho p/ atualizacao do total da prestacao de contas
		nPosCod   := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_COD"    })
		nPosQtde  := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_QUANT"  })
		nPosValor := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_VRUNIT" })
		nPosTotal := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_TOTAL"  })

		If nWizard == 4 //Gatilho
			For i := 1 To Len(oGetDados:aCols)
				If oGetDados:nAt <> i
					If !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
						nTotal += oGetDados:aCols[i,nPosTotal]
					EndIf
				Else
					If !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
						If "ZZP_QUANT" $ ReadVar()
							nTotal += oGetDados:aCols[i,nPosValor] * M->ZZP_QUANT
						ElseIf "ZZP_VRUNIT" $ ReadVar()
							nTotal += oGetDados:aCols[i,nPosQtde] * M->ZZP_VRUNIT
						EndIf
					EndIf
				EndIf
			Next i
		ElseIf nWizard == 5 //Exclusao da Linha
			For i := 1 To Len(oGetDados:aCols)
				If (!oGetDados:aCols[i,Len(oGetDados:aHeader)+1] .And. oGetDados:nAt <> i) .Or. (oGetDados:aCols[i,Len(oGetDados:aHeader)+1] .And. oGetDados:nAt == i)
					nTotal += oGetDados:aCols[i,nPosTotal]
				EndIf
			Next i
		EndIf

		oSay1:SetText("TOTAL PRESTAวรO DE CONTAS: R$ " + AllTrim(Transform(nTotal,"@E 999,999,999.99")))
		oSay1:Refresh()

	ElseIf nWizard == 6 //Linha OK da GetDados
		nPosCod   := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_COD"    })
		nPosQtde  := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_QUANT"  })
		nPosValor := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_VRUNIT" })
		nPosTotal := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_TOTAL"  })

		If !oGetDados:aCols[oGetDados:nAt,Len(oGetDados:aHeader)+1]
			If Empty(oGetDados:aCols[oGetDados:nAt,nPosCod]) .Or. oGetDados:aCols[oGetDados:nAt,nPosQtde] <= 0 .Or. oGetDados:aCols[oGetDados:nAt,nPosValor] <= 0 .Or. oGetDados:aCols[oGetDados:nAt,nPosTotal] <= 0
				MsgAlert("Aten็ใo, os campos: CำDIGO, QUANTIDADE e VALOR UNITมRIO sใo de preenchimento obrigat๓rio.")
				Return(.F.)
			EndIf
		EndIf

	ElseIf nWizard == 7 //Validacao do campo PAGAMENTO ANTECIPADO

		If !Empty(cPagtoAdto)

			DbSelectArea("ZZE")
			ZZE->(dbSetOrder(1))
			If ZZE->(!dbSeek(xFilial("ZZE")+cPagtoAdto))

				MsgAlert("Aten็ใo, essa solicita็ใo de pagamento antecipado nใo foi encontrada")
				lVld:= .f.

			Else

				If (	ZZE->ZZE_USERID <> __cUserID )
					MsgAlert("Aten็ใo: Essa Solicita็ใo de Adiantamento nแo se foi incluida por voce." )
					lVld:= .f.
				EndIF

				If !(ZZE->ZZE_FORNEC == cFornecedor .AND. ZZE->ZZE_LOJA == cLoja)
					MsgAlert("Aten็ใo: Fornecedor+Loja informado nแo confere com o fornecedor+loja informado na Solicita็ใo de Adiantamento." )
					lVld:= .f.
				EndIF

				If ( ZZE->ZZE_STATUS <> "L" )
					MsgAlert("Aten็ใo: Solicita็ใo de Adiantamento nแo se encontra aprovada pelos gestores." )
					lVld:= .f.
				EndIf

				If !( Str(ZZE->ZZE_TIPO,1) $ "23" )
					MsgAlert("Aten็ใo: Tipo do Adto Informado invalido."+chr(13)+;
					"Devem ser informados apenas Solicita็ใo de Adiantamento para FUNCIONARIOS ou ARTISTAS.")
					lVld:= .f.
				Endif

			EndIf

			ZZE->(dbGoTo(nZZERecno))
			RestArea(aAreaBKP)

			If !lVld
				Return(.F.)
			EndIf

		EndIf

	ElseIf nWizard == 8 //Valida a linha do rateio de centro de custos
		nPosCC        := AScan(oGetDRateio:aHeader,{|x| AllTrim(x[2]) == "DE_CC" 	})
		nPosPercentual:= AScan(oGetDRateio:aHeader,{|x| AllTrim(x[2]) == "DE_PERC"	})

		If !oGetDRateio:aCols[oGetDRateio:oBrowse:nAt][Len(oGetDRateio:aHeader)+1] .And. (Empty(oGetDRateio:aCols[oGetDRateio:oBrowse:nAt][nPosCC]) .Or. oGetDRateio:aCols[oGetDRateio:oBrowse:nAt][nPosPercentual] <= 0)
			MsgAlert("Aten็ใo, os campos % Rat. e C. de Custo sใo de preenchimento obrigat๓rio. Verique antes de prosseguir para a pr๓xima linha.")
			Return(.F.)
		EndIf

	ElseIf nWizard == 9 //Valida o TUDOOK do rateio de centro de custos
		nPosCC        := AScan(oGetDRateio:aHeader,{|x| AllTrim(x[2]) == "DE_CC" 	})
		nPosPercentual:= AScan(oGetDRateio:aHeader,{|x| AllTrim(x[2]) == "DE_PERC"	})

		For i := 1 To Len(oGetDRateio:aCols)
			If !oGetDRateio:aCols[i][Len(oGetDRateio:aHeader)+1]
				nTotal += oGetDRateio:aCols[i][nPosPercentual]
			EndIf
		Next i

		If nTotal <> 100 .And. nTotal <> 0
			MsgAlert("Aten็ใo, a soma dos rateios nใo totaliza 100%. Verifique as linhas do rateio antes de prosseguir.")
			Return(.F.)
		EndIf

	EndIf

Return(.T.)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGera_Alc_DespesaบAutor  ณBruno Daniel Borges บ Data ณ  31/07/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de geracao da presrtacao de contas e alcada de aprovacao   บฑฑ
ฑฑบ          ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Gera_Alc_Despesa(aDados)
	Local cNumero   := GetSX8Num("ZZE","ZZE_NUMERO")
	Local nTotal    := 0
	Local nPosTotal := AScan(oGetDados:aHeader,{|x| AllTrim(x[2]) == "ZZP_TOTAL" })
	Local i,j,k     := 0
	Local lRateio   := .F.
	Local nPosRateio:= 0
	Local _cGrpApv	:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
	Local _lOk		:= .T.
	Private ALTERA	:= .F.

	//Soma o total da prestacao de contas
	For i := 1 To Len(oGetDados:aCols)
		If !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
			nTotal  += oGetDados:aCols[i,nPosTotal]
		EndIf
	Next i

	If ZZE->(dbSeek(xFilial("ZZE") + cNumero))
		//	ZZE->(Confirmsx8())
		ZZE->(dbGoTop())
		_lOk	:= ZZE->(dbSeek(xFilial("ZZE") + cNumero))

		While _lOk
			cNumero   := GetSX8Num("ZZE","ZZE_NUMERO")
			//		ZZE->(Confirmsx8())
			ZZE->(dbGoTop())
			If ZZE->(!dbSeek(xFilial("ZZE") + cNumero))
				_lOk	:= .F.
			EndIf
		EndDo
	EndIf

	If Reclock("ZZE",.T.)
		ZZE->ZZE_FILIAL	:= xFilial("ZZE")
		ZZE->ZZE_NUMERO	:= cNumero
		ZZE->ZZE_MOEDA	:= 1
		ZZE->ZZE_FORNEC:= SubStr(aDados[1],1,6)
		ZZE->ZZE_LOJA	:= Posicione("SA2",1,xFilial("SA2")+SubStr(aDados[1],1,6),"SA2->A2_LOJA") //SubStr(aDados[1],7,2)
		ZZE->ZZE_NOMFOR:= aDados[2]
		ZZE->ZZE_TIPO	:= aDados[3]
		ZZE->ZZE_CCUSTO:= Alltrim(aDados[4])
		ZZE->ZZE_BANCO	:= aDados[5]
		ZZE->ZZE_AGENC	:= aDados[6]
		ZZE->ZZE_CONTA	:= aDados[7]
		ZZE->ZZE_VALOR	:= nTotal
		ZZE->ZZE_DATA	:= dDataBase
		ZZE->ZZE_STATUS	:= "P"
		ZZE->ZZE_HISTOR	:= Iif(aDados[3] == 6,"PRESTAวรO DE CONTAS","REEMBOLSO DE DESPESAS AVULSAS")
		ZZE->ZZE_DESC	:= aDados[10]
		ZZE->ZZE_USERID	:= __cUserID
		ZZE->ZZE_PEP	:= aDados[8]
		//ZZE->ZZE_HISTOR	:= aDados[10]
		PswOrder(1)
		if PswSeek(__cUserID, .T. )
			ZZE_DEPTO 	:= Pswret(1)[1][12]
		endif

		_cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
		ZZE->ZZE_XGRPAP	:= _cGrpApv

		ZZE->(Msunlock())
		ZZE->(Confirmsx8())	
		//	Gera_Alcada_SC(cNumero,AllTrim(aDados[4]))
		//U_GRVAlcZZE(cNumero,ZZE->ZZE_CCUSTO,.F.,.F.)
		_cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
		MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",ZZE->ZZE_VALOR,,,_cGrpApv,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},ZZE->ZZE_DATA,1)
		fVdlNvlU(_cGrpApv)

	endif

	//Se tem RATEIO gera um item para cada centro de custo
	For i := 1 To Len(oGetDRateio:aCols)
		If !oGetDRateio:aCols[i][Len(oGetDRateio:aHeader)+1] .And. oGetDRateio:aCols[i][AScan(oGetDRateio:aHeader,{|x| AllTrim(x[2]) == "DE_PERC" })] > 0
			lRateio 	:= .T.
			nPosRateio 	:= AScan(oGetDRateio:aHeader,{|x| AllTrim(x[2]) == "DE_PERC" })
			nPosCC      := AScan(oGetDRateio:aHeader,{|x| AllTrim(x[2]) == "DE_CC" })
			Exit
		EndIf
	Next i

	//Grava os itens dessa prestacao de contas/reembolso de despesas
	dbSelectArea("ZZP")
	ZZP->(dbSetOrder(1))
	For i := 1 To Len(oGetDados:aCols)
		If !oGetDados:aCols[i,Len(oGetDados:aHeader)+1]
			If lRateio
				For k := 1 To Len(oGetDRateio:aCols)
					If oGetDRateio:aCols[k][Len(oGetDRateio:aHeader)+1]
						Loop
					EndIf

					ZZP->(RecLock("ZZP",.T.))
					ZZP->ZZP_FILIAL := xFilial("ZZP")
					ZZP->ZZP_CODIGO := cNumero
					ZZP->ZZP_PGANT  := aDados[9]
					For j := 1 To Len(oGetDados:aHeader)
						If AllTrim(oGetDados:aHeader[j,10]) <> "V"
							ZZP->&(oGetDados:aHeader[j][2]) := oGetDados:aCols[i][j]
						EndIf
					Next j
					ZZP->ZZP_VRUNIT	:= oGetDRateio:aCols[k][nPosRateio] / 100 * ZZP->ZZP_VRUNIT
					ZZP->ZZP_TOTAL 	:= ZZP->ZZP_VRUNIT * ZZP->ZZP_QUANT
					ZZP->ZZP_CC 	:= oGetDRateio:aCols[k][nPosCC]
					ZZP->(MsUnlock())
				Next K
			Else
				ZZP->(RecLock("ZZP",.T.))
				ZZP->ZZP_FILIAL := xFilial("ZZP")
				ZZP->ZZP_CODIGO := cNumero
				ZZP->ZZP_PGANT  := aDados[9]
				For j := 1 To Len(oGetDados:aHeader)
					If AllTrim(oGetDados:aHeader[j,10]) <> "V"
						ZZP->&(oGetDados:aHeader[j][2]) := oGetDados:aCols[i][j]
					EndIf
				Next j
				ZZP->ZZP_CC := ZZE->ZZE_CCUSTO
				ZZP->(MsUnlock())
			EndIf
		EndIf
	Next i

Return(cNumero)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGera_Alcada_SCบAutor  ณRENATO TAKAO        บ Data ณ  12/08/08   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGeracao das tabelas de Alcadas para PA / Troco / Avulsos        บฑฑ
ฑฑบ          ณ                                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบManutencaoณ 17/11/09 Gilberto: Alteracao para tratar alcadas de mesmo nivelบฑฑ
ฑฑบ          ณ tanto na geracao quanto na liberacao. Solicitacao de Paula B.  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// ZZ6_STATUS
//1=Aguardando Aprovacao;2=Aprovada;3=Rejeitada;4=Aguardando Nivel Anterior;5=Inativa Nesse Nivel

User Function GrvAlcZZE(cNum,cCentroCusto,lBlqPCO,lPCO)

	//Local nLinha	:= 0
	Local cPrimNiv	:= "999"
	Local cUser		:= __cUSERID
	Local lOK		:=.F.
	Local lPassa	:=.F.
	Local nRegs		:=0
	Local aZZ6      := {}
	Local aArea     := {}
	Local lPAPC	    := GetMv("MV_PACOMPC",,.F.)//Informar se PC ้ obrigatorio para inserir PA ( Sergio Celestino )
	Local _cGrpApv	:= ""

	_cGrpApv		:= Posicione("CTT",1,xFilial("CTT")+ZZE->ZZE_CCUSTO,"CTT_XGRAPR")
	MaAlcDoc({ZZE->ZZE_NUMERO,"ZZ",ZZE->ZZE_VALOR,,,_cGrpApv,,ZZE->ZZE_MOEDA,,ZZE->ZZE_DATA},ZZE->ZZE_DATA,1)
	/*
	//Houve bloqueio de orcamento no PCO ou nao existe elemento PEP
	If lBlqPCO .Or. !lPCO

	//Incluido por Sergio Celestino para gravar a al็ada do PA quando houver pedido - linha 1819 ate 1853
	If !Empty(cPedido) .and. lPAPC
	aArea:=GetArea()

	DbSelectArea("SC1")
	DbSetOrder(6)//Filial + Pedido + Item do Pedido + Produto
	DbGotop()
	If DbSeek(xFilial("SC1") + cPedido )

	DbSelectArea("ZZ6")
	DbSetOrder(1)//Filial + SC
	DbGotop()
	DbSeek(xFilial("ZZ6") + SC1->C1_NUM )

	While !Eof() .And. ZZ6->ZZ6_SC == SC1->C1_NUM
	aAdd(aZZ6,{ZZ6->ZZ6_APROV,ZZ6->ZZ6_NIVEL,ZZ6->ZZ6_STATUS,ZZ6->ZZ6_HRENT,ZZ6->ZZ6_DTENT,ZZ6->ZZ6_HRSAI,ZZ6->ZZ6_DTSAI} )
	DbSelectArea("ZZ6")
	DbSkip()
	End

	// Cria nova alcada baseada na liberacao da s.c.
	For nY := 1 To Len(aZZ6)
	Reclock("ZZ6",.T.)
	ZZ6->ZZ6_APROV  := aZZ6[nY][1]
	ZZ6->ZZ6_NIVEL  := aZZ6[nY][2]
	ZZ6->ZZ6_STATUS := aZZ6[nY][3]
	ZZ6->ZZ6_HRENT  := aZZ6[nY][4]
	ZZ6->ZZ6_DTENT  := aZZ6[nY][5]
	ZZ6->ZZ6_HRSAI  := aZZ6[nY][6]
	ZZ6->ZZ6_DTSAI  := aZZ6[nY][7]
	ZZ6->ZZ6_PA     :=	 cNum
	MsUnlock()
	Next
	Else
	Alert("Nใo existe SC para o PC informado no PA.Verifique!!!")
	Endif
	RestArea(aArea)
	Else
	// Jแ estแ posicionado na ZZE
	// Le alcadas e grava registros de aprova็ใo
	DbSelectArea("ZZ5")
	Dbsetorder(3)  // CC + Nivel
	If Dbseek(xfilial("ZZ5")+cCentroCusto)

	While ZZ5->(!Eof()) .and. (ZZ5->ZZ5_FILIAL+ZZ5->ZZ5_CC=xfilial("ZZ5")+cCentroCusto)

	DbSelectArea("SAK")
	SAK->( DbSetOrder(1) )
	SAK->( DbSeek(xFilial("SAK")+ZZ5->ZZ5_APROV) )  // Pega dados do aprovador

	lPassa:= ( SAK->AK_USER == CUSER ) // Nใo pode aprovar SC dele mesmo

	// Verifica valor da al็ada e se jแ tem al็ada gravada
	If (ZZE->ZZE_VALOR >= SAK->AK_LIMMIN .AND. ZZE->ZZE_VALOR <= SAK->AK_LIMMAX) .OR. (nRegs=0)

	DbSelectArea("ZZ6")
	ZZ6->(RecLock("ZZ6",.T.))
	ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
	ZZ6->ZZ6_PA		:= cNum
	ZZ6->ZZ6_APROV	:= ZZ5->ZZ5_APROV
	ZZ6->ZZ6_NIVEL	:= ZZ5->ZZ5_NIVEL
	//ZZ6->ZZ6_STATUS	:= Iif(ZZ5->ZZ5_NIVEL >= cPrimNiv,"4","1")
	ZZ6->ZZ6_STATUS	:= Iif(ZZ5->ZZ5_NIVEL > cPrimNiv,"4","1")

	If ZZ6->ZZ6_STATUS == "1"
	ZZ6->ZZ6_HRENT		:= Time()
	ZZ6->ZZ6_DTENT		:= dDataBase
	cPrimNiv			:= ZZ5->ZZ5_NIVEL
	EndIf

	If lPassa  //Inativa no Nivel
	ZZ6->ZZ6_HRSAI		:= Time()
	ZZ6->ZZ6_DTSAI		:= dDataBase
	ZZ6->ZZ6_STATUS		:= "5"
	If nRegs>0
	//	cPrimNiv			:=""
	Else
	cPrimNiv			:="888"
	Endif
	Else
	nRegs++
	Endif
	ZZ6->(MsUnlock())
	Endif
	ZZ5->(dbSkip())
	EndDo
	Endif
	If nRegs=0
	MSGALERT("Solicita็ใo INVALIDA!! Sem aprovadores cadastrados!!")
	Endif
	Endif
	Else
	dbSelectArea("ZZ6")
	ZZ6->(RecLock("ZZ6",.T.))
	ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
	ZZ6->ZZ6_APROV	:= "PCO"
	ZZ6->ZZ6_NIVEL	:= "X"
	ZZ6->ZZ6_STATUS	:= "6"
	ZZ6->ZZ6_HRENT	:= Time()
	ZZ6->ZZ6_DTENT	:= dDataBase
	ZZ6->ZZ6_HRSAI	:= Time()
	ZZ6->ZZ6_DTSAI	:= dDataBase
	ZZ6->ZZ6_PA		:= cNum
	ZZ6->(MsUnlock())
	EndIf
	*/
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออหอออออออัออออออออออออออออออออหออออออlัออออออออออออปฑฑ
ฑฑบPrograma  ณGera_ReembolsoบAutor  ณBruno Daniel Borges บ Data ณ  03/09/08   บฑฑ
ฑฑฬออออออออออุออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de geracao do reembolso                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Gera_Reembolso(cFornecedor,cLoja,cCC,cBanco,cAgencia,cContaCorr,cElePep,cPagtoAdto,cObs)
	Local cNumReemb:= ""
	Local oDlg, oSay
	Local oFont1:= TFont():New("Courier New",,-14,.T.)
	Local oFont2:= TFont():New("Courier New",,-22,.T.)
	Local oFont3:= TFont():New("Arial",,20,.T.,.T.,,,,,.F.)
	If MsgYesNo("Aten็ใo, voc๊ confirma a gera็ใo da presta็ใo de contas/despesas avulsas ? A partir desse momento nใo serแ possivel retroceder.")

		LJMsgRun("Aguarde, gravando presta็ใo de contas/reembolso de despesas",;
		"Aguarde...",;
		{|| cNumReemb := Gera_Alc_Despesa( {cFornecedor+cloja,;
		Posicione("SA2",1,xFilial("SA2")+cFornecedor,"SA2->A2_NOME"),;
		Iif(oCombTp:nAt == 2,7,6),;
		cCC,cBanco,;
		cAgencia,;
		cContaCorr,;
		cElePep,;
		cPagtoAdto,;
		cObs} ) })
		/*	
		oSay3:SetText("Sua presta็ใo de contas/reembolso de despesas foi gravada com sucesso."+Chr(13)+Chr(10)+"Aguarde a autoriza็ใo pelos gestores do seu centro de custo para que o pagamento seja efetuado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"N๚mero da Solicita็ใo de Reembolso de Despesas/Presta็ใo de Contas: " + cNumReemb)
		oSay3:Refresh()
		*/

		DEFINE MSDIALOG oDlg FROM 0,0 TO 100,500 TITLE "Gravada com Sucesso" PIXEL

		// Apresenta o tSay com a fonte Courier New

		oSay := TSay():New( 10, 10, {|| "Solicita็ใo de Reembolso de Despesas/Presta็ใo de Contas"},oDlg,, oFont1,,,, .T.,, ) 
		//oSay := TSay():New( 30, 60, {|| "N๚mero : "},oDlg,, oFont2,,,, .T., , ) 
		oSay := TSay():New( 30, 090 , {|| "N๚mero:"+cNumReemb},oDlg,, oFont3,,,, .T., , ) 

		oSay:lTransparent:= .F.

		ACTIVATE MSDIALOG oDlg CENTERED


	Else

		Return(.F.)

	EndIf

Return(.T.)

/*
Static Function Gera_Reembolso(cFornecedor,cLoja,cCC,cBanco,cAgencia,cContaCorr,cElePep,cPagtoAdto,cObs)
Local cNumReemb:= ""

If MsgYesNo("Aten็ใo, voc๊ confirma a gera็ใo da presta็ใo de contas/despesas avulsas ? A partir desse momento nใo serแ possivel retroceder.")

LJMsgRun("Aguarde, gravando presta็ใo de contas/reembolso de despesas",;
"Aguarde...",;
{|| cNumReemb := Gera_Alc_Despesa( {cFornecedor+cloja,;
Posicione("SA2",1,xFilial("SA2")+cFornecedor,"SA2->A2_NOME"),;
Iif(oCombTp:nAt == 2,7,6),;
cCC,cBanco,;
cAgencia,;
cContaCorr,;
cElePep,;
cPagtoAdto,;
cObs} ) })

oSay3:SetText("Sua presta็ใo de contas/reembolso de despesas foi gravada com sucesso."+Chr(13)+Chr(10)+"Aguarde a autoriza็ใo pelos gestores do seu centro de custo para que o pagamento seja efetuado."+Chr(13)+Chr(10)+Chr(13)+Chr(10)+"N๚mero da Solicita็ใo de Reembolso de Despesas/Presta็ใo de Contas: " + cNumReemb)
oSay3:Refresh()

Else

Return(.F.)

EndIf

Return(.T.)
*/
//--------------------------------------------------------------------------------
//
// Desenvolvido por Sergio Celestino
///



Static Function AtuVar1(cTipoFor,lFor)

	// 1 = Fornecedor

	//If Alltrim(cTipoFor) == "Fornecedor"
	If ( Alltrim(cTipoFor) == "1" )
		lFor   := .T.
		nValor := 0
	Else
		cPedido  := ""
		lFor     := .F.
	Endif

	oCBX2:Refresh()
	oValor:Refresh()
	oPedido:Refresh()
	oMainWnd:Refresh()
	oDlg:Refresh()

Return

Static Function AtuNat(cTipofor,lfor)

	//If Alltrim(cTipoFor) == "Repasse Terceiros"
	If Alltrim(cTipoFor) == "9"
		cNatureza:="400700"
		oNatureza:Refresh()
		oDlg:Refresh()
	EndIf


Return


Static Function LerMemo(cChave)
	Local nPos    := 0
	Local nTam     := Len(Space(TamSx3("YP_TEXTO")[1]))
	Local cLine    := ""
	Local cString := ""
	DbSelectArea("SYP")
	SYP->(DbSetOrder(1))
	SYP->(DbGoTop())
	If(SYP->(DbSeek(xFilial("SYP") + cChave, .T.)))
		While SYP->(!Eof()) .And. ( cChave == SYP->YP_CHAVE ) .And. ( xFilial("SYP") == SYP->YP_FILIAL )
			nPos := At("\13\10",Subs(SYP->YP_TEXTO,1,nTam+6))
			If ( nPos == 0 )
				cLine := RTrim(Subs(SYP->YP_TEXTO,1,nTam))
				If ( nPos2 := At("\14\10", cLine) ) > 0
					cString += StrTran( cLine, "\14\10", Space(6) )
				Else
					cString += cLine
				EndIf
			Else
				cString += Subs(SYP->YP_TEXTO,1,nPos-1) + " "
			EndIf
			SYP->(DbSkip())
		End While
		SYP->(DbCloseArea())
	Endif
Return(cString)
