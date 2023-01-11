#include 'protheus.ch'
#define _EOL chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCCXAPR ºAutor  ³Gilberto            º Data ³  02/12/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Aprovadores por Centro de Custo.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RelCCxApr()

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "APROVADORES POR CENTRO DE CUSTO"
	Local cPict          := ""
	Local titulo			:= "APROVADORES POR CENTRO DE CUSTO"
	Local nLin				:= 80
	Local Cabec1			:= "Centro de Custo"
	Local Cabec2			:= "     Nivel Aprovador                                  A partir de"
	Local imprime			:= .T.
	Local aOrd				:= {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 080
	Private tamanho      := "P"
	Private nomeprog     := "RelCCxApr"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt			:= Space(10)
	Private cbcont			:= 00
	Private CONTFL			:= 01
	Private m_pag			:= 01
	Private wnrel			:= "RelCCxApr"
	Private cPerg           := "CCXAPR"
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSx1("CCXAPR",	"01",	"Centro de Custo de ?",	"Centro de Custo de ?",	"Centro de Custo de ?",	"mv_ch1",	"C",20,	0,	0,	"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1("CCXAPR",	"02",	"Centro de Custo ate ?","Centro de Custo ate ?","Centro de Custo ate ?",	"mv_ch2",	"C",20,	0,	0,	"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1("CCXAPR",	"03",	"Saida Relatorio em ?","Saida Relatorio em ?","Saida Relatorio em ?",	"mv_ch3",	"N",1,0,1,"C","","","","","mv_par03","Excel","Excel","Excel","","Relatorio","Relatorio","Relatorio","","","","","","","","","")
	//PutSx1("CTRCTB",    "01","Tipo Relatorio","Tipo Relatorio","Tipo Relatorio","mv_ch1","N",1,0,2,"C","","","","","mv_par01","Carta Acordo","Carta Acordo","Carta Acordo","","Briefing","Briefing","Briefing","","","","","","","","","",{},{},{})
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	If Pergunte(cPerg,.T.)

		wnrel := SetPrint("SAK",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

		SetDefault(aReturn,"SAK")

		If nLastKey == 27
			Return
		Endif

		nTipo := If(aReturn[4]==1,15,18)

		RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

	EndIf

Return(Nil)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/09/09   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
//±±º          ³ monta a janela com a regua de processamento.               º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ Programa principal                                         º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local cCaminho     := __RELDIR
	Local cArquivo     := "result_"+dtos(ddatabase)+"_"+StrTran(Time(),":","_")+".xml"
	Local cNomeArq     := Alltrim(cCaminho+cArquivo)
	Local cPathDestino
	Local lCopyOk      := .f.
	Private _TabSql:= GetNextAlias()

	//         10        20        30        40        50        60        70        80        90       100       110       120       130       140
	//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//Centro de Custo
	//012345678901234567890 - 1234567890123456789012345678901234567890
	//     Nivel Aprovador                                  A partir de   Limite Final
	//     ----- --------------------------------------- -------------- --------------
	//       123 123456 - 123456789012345678901234567890 999,999,999.99 999,999,999.99

	FQuery(mv_par01,mv_par02,_TabSql)

	If MV_PAR03 == 1

		cPathDestino := cGetFile("\", "Diretorio Destino",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)

		//Obriga a ser informado o diretorio de Destino
		If Empty(cPathDestino)

			MsgAlert("Atenção, é obrigatório a seleção do diretório de destino da planilha a ser gerada.")

		Else

			//Fecha o arquivo e copia para a estacao do usuario
			(_TabSql)->(dbGoTop())

			If File( (cNomeArq ) )
				FERASE( (cNomeArq ) )
			EndIf

			MsAguarde( { || u_DB2XML(cNomeArq,"RESULT", _TabSql )},"Aguarde .. Gerando arquivo XML...")
			lCopyOk:= .t.

			//		MsAguarde( { || ( lCopyOk:= CpyS2T( Lower(cNomeArq) , cPathDestino,.T.) )	},"Aguarde .. Copiando para o destino...")

			If ( lCopyOk ) .And. File( cPathDestino+Upper(cArquivo) )
				FErase( (cNomeArq ) )
				ApMsgInfo("Arquivo salvo com sucesso."+_EOL+"Caminho: "+cPathDestino+_EOL+"Arquivo: "+cArquivo,"Informação","INFO")

				//Cria o link com o Excel
				oExcel := MsExcel():New()
				oExcel:WorkBooks:Open( cPathDestino+Upper(cArquivo) )
				oExcel:SetVisible(.T.)
			Else
				ApMsgInfo("Atenção:"+_EOL+"Não foi possivel copiar o arquivo:"+_EOL+cNomeArq+_EOL+"Para: "+_EOL+cArquivo+_EOL+"Tente novamente.","Informação","INFO")
			EndIf
		EndIf
	Else


		Do While (_TabSql)->( !Eof() )

			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif

			If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
			Endif

			@nLin,00 PSAY Alltrim( (_TabSql)->ZZ5_CC )+" - "+(_TabSql)->CTT_DESC01

			nLin++

			_cCC:= (_TabSql)->ZZ5_CC

			Do While (_TabSql)->( !Eof() ) .And. (_TabSql)->ZZ5_CC == _cCC

				If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...

					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

					nLin := 8

					@nLin,00 PSAY Alltrim( (_TabSql)->ZZ5_CC )+" - "+(_TabSql)->CTT_DESC01

					nLin++

				Endif

				@nLin,07 PSAY (_TabSql)->ZZ5_NIVEL
				@nLin,11 PSAY (_TabSql)->ZZ5_APROV
				@nLin,18 PSAY "-"
				@nLin,20 PSAY (_TabSql)->AK_NOME
				@nLin,51 PSAY (_TabSql)->AK_LIMMIN Picture "@E 999,999,999.99"
				//@nLin,66 PSAY (_TabSql)->AK_LIMMAX Picture "@E 999,999,999.99"

				nLin ++ // Avanca a linha de impressao

				(_TabSql)->( DbSkip() )

			EndDo

			//(_TabSql)->( DbSkip() )

		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza a execucao do relatorio...                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		SET DEVICE TO SCREEN

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se impressao em disco, chama o gerenciador de impressao...          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If aReturn[5]==1
			dbCommitAll()
			SET PRINTER TO
			OurSpool(wnrel)
		Endif

		MS_FLUSH()

	Endif


Return( Nil )

Static Function FQuery(_cCCIni, _cCCFim,_TabSql)

	Local _cQuery:= ''

	If Select(_TabSql) > 0
		(_TabSql)->(dbCloseArea())
	EndIf

	_cQuery+="SELECT ZZ5.ZZ5_CC,CTT.CTT_DESC01,ZZ5.ZZ5_NIVEL, ZZ5.ZZ5_APROV, SAK.AK_NOME, SAK.AK_LIMMIN, SAK.AK_LIMMAX "
	_cQuery+= "FROM "+RetSqlName("ZZ5")+" ZZ5 INNER JOIN "+RetSqlName("SAK")+" SAK "+_EOL
	_cQuery+= "ON ZZ5.ZZ5_CC BETWEEN '"+_cCCIni+"' AND '"+_cCCFim+"' AND "+_EOL
	_cQuery+= "ZZ5.ZZ5_APROV = SAK.AK_COD AND "+_EOL
	_cQuery+= "ZZ5.ZZ5_FILIAL = '"+XFILIAL("ZZ5")+"' AND "+_EOL
	_cQuery+= "ZZ5.D_E_L_E_T_ = '' "+_EOL
	_cQuery+= "INNER JOIN "+RetSqlName("CTT")+" CTT "+_EOL
	_cQuery+= "ON ZZ5.ZZ5_FILIAL='"+XFILIAL("ZZ5")+"' AND "+_EOL
	_cQuery+= "ZZ5.ZZ5_CC = CTT.CTT_CUSTO "+_EOL                
	_cQuery+= "WHERE SAK.D_E_L_E_T_ = '' AND "
	_cQuery+= "CTT.D_E_L_E_T_ = '' AND "+_EOL                           
	_cQuery+= "CTT.CTT_BLOQ <> '1' "+_EOL
	_cQuery+= "ORDER BY ZZ5.ZZ5_FILIAL, ZZ5.ZZ5_CC, ZZ5.ZZ5_NIVEL "

	_cQuery := ChangeQuery(_cQuery)

	MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),_TabSql,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

	(_TabSql)->( DbGotop() )

Return



