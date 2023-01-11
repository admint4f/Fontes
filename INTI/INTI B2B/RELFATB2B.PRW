#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE CRLF (chr(13)+chr(10))
/*/{Protheus.doc} RELFATB2B
Gerar um arquivo com os dados localizados e tamb?m com o comando SQL executado.
Sendo que ir? gerar esse arquivo no formato .XLS quando tiver o Excel instalado, OU ent?o cria um arquivo .CSV
@type function
@version 12.1.27
@author Jorge Alberto
@since 01/04/2021
@param cSql, character, Comando Sql
@param cLogErro, character, Log com o erro
@param nPosCursor, numeric, Posiçao do cursor no momento da chamada da rotina
/*/

User Function RELFATB2B(cDtIni,cDtFim)

	Local cQueryZAF := ""
	Local aCnpj 	:= {}
	Local cCnpj		:= ""
	Local n			:= 0
	Private oSay

	(cAliasTMP)->(dbGotop())

	While (cAliasTMP)->(!Eof())

		If !Empty((cAliasTMP)->OK)
			aAdd(aCnpj,(cAliasTMP)->CNPJ)
		EndIf

		(cAliasTMP)->(dbSkip())

	EndDo

	(cAliasTMP)->(dbGotop())

	cVir:= If(Len(aCnpj) > 1,","," ")

	For n:=1 To Len(aCnpj)
		cCnpj := "'"+ aCnpj[n] + "'" + cVir + cCnpj
	Next n

	cCnPj := "("+ substr(cCnpj,1,Len(cCnpj)-1) +")"


	If Len(aCnpj) > 0

		//Consulta PEDIDOS
		cQueryZAF +=" SELECT  ZAF_SLUID,  ZAF_MODULO, ZAF_EVENTO, ZAF_SEARCH, ZAF_ITNAME, ZAF_PROMOT,ZAF_CORPNA, ZAF_CORPCN, ZAF_DTVEND, ZAF_DTCANC, " +CRLF
		//cQueryZAF +="  (SELECT SUM(ZAD_VLRTKT+ZAD_VLRSOC) FROM "+RetSqlName('ZAD') +' ZAD WHERE ZAD_SEARCH = ZAF_SEARCH AND ZAD_SLUID = ZAF_SLUID ' +CRLF
		//cQueryZAF +=" AND ZAD_TPTRAN ='1' AND ZAD.D_E_L_E_T_ =' ') AS ZAF_VLRTRA," 																				+CRLF
		cQueryZAF +=" sum(ZAF_FINCRE) ZAF_FINCRE," 																				+CRLF
		cQueryZAF +=" SUM(ZAF_FINTXO) ZAF_FINTXO, SUM(ZAF_FINTXS) ZAF_FINTXS, 'VENDA' TIPO "    											+CRLF
		cQueryZAF +=" FROM "+RetSqlName('ZAF')+ ' ZAF '     																				+CRLF
		cQueryZAF +=" WHERE ZAF_FILIAL ='01' "  																							+CRLF
		cQueryZAF +=" AND ZAF_NUMERO  > ' '"    																							+CRLF
		cQueryZAF +=" AND ZAF_SLUID  > ' '" 																								+CRLF
//		cQueryZAF +=" AND ZAF_TPPGTO <> 'INTI Wallet'"  																					+CRLF
		cQueryZAF +=" AND ZAF_DTVEND BETWEEN '"+ cDtIni +"' AND '"+ cDtFim +"' "															+CRLF
//		cQueryZAF +=" AND ZAF_DTCANC = ' ' "    																							+CRLF
		cQueryZAF +=" AND ZAF_TIPO = 'Venda               '"   																			+CRLF
		cQueryZAF +=" AND (ZAF_FINTXS > 0 OR ZAF_FINTXO > 0)"   																			+CRLF

		If !Empty(cCnpj)
			cQueryZAF +=" AND ZAF_CORPCN IN "+cCnpj    																						+CRLF
		EndIf

		cQueryZAF +=" AND D_E_L_E_T_ = ' '  "   																							+CRLF
		cQueryZAF +=" GROUP BY ZAF_SLUID, ZAF_MODULO, ZAF_EVENTO, ZAF_SEARCH, ZAF_ITNAME,ZAF_CORPNA, ZAF_PROMOT, ZAF_CORPCN, ZAF_DTVEND, ZAF_DTCANC "  +CRLF
		
		cQueryZAF +=" UNION ALL "   																										+CRLF
		
		cQueryZAF +=" SELECT  ZAF_SLUID,  ZAF_MODULO, ZAF_EVENTO, ZAF_SEARCH, ZAF_ITNAME, ZAF_PROMOT,ZAF_CORPNA, ZAF_CORPCN, ZAF_DTVEND, ZAF_DTCANC, " +CRLF
		//cQueryZAF +="  (SELECT SUM(ZAD_VLRTKT+ZAD_VLRSOC) FROM "+RetSqlName('ZAD') +' ZAD WHERE ZAD_SEARCH = ZAF_SEARCH AND ZAD_SLUID = ZAF_SLUID ' +CRLF
		//cQueryZAF +=" AND ZAD_TPTRAN ='2' AND ZAD.D_E_L_E_T_ =' ') AS ZAF_VLRTRA," 																				+CRLF
		cQueryZAF +=" sum(ZAF_FINCRE) ZAF_FINCRE," 																							+CRLF
		cQueryZAF +=" SUM(ZAF_FINTXO) ZAF_FINTXO, SUM(ZAF_FINTXS) ZAF_FINTXS, 'CANCELAMENTO' TIPO " 										+CRLF
		cQueryZAF +=" FROM "+RetSqlName('ZAF')+ ' ZAF '     																				+CRLF
		cQueryZAF +=" WHERE ZAF_FILIAL ='01' "  																							+CRLF
		cQueryZAF +=" AND ZAF_NUMERO  > ' '"    																							+CRLF
		cQueryZAF +=" AND ZAF_SLUID  > ' '" 																								+CRLF
//		cQueryZAF +=" AND ZAF_TPPGTO <> 'INTI Wallet'"  																					+CRLF
		cQueryZAF +=" AND ZAF_DTVEND BETWEEN '"+ cDtIni +"' AND '"+ cDtFim +"' "															+CRLF
		cQueryZAF +=" AND ZAF_DTCANC BETWEEN '"+ cDtIni +"' AND '"+ cDtFim +"' "															+CRLF
		cQueryZAF +=" AND ZAF_TIPO <> 'Venda               '"   																			+CRLF
		cQueryZAF +=" AND (ZAF_FINTXS < 0 OR ZAF_FINTXO < 0)"   																			+CRLF

		If !Empty(cCnpj)
			cQueryZAF +=" AND ZAF_CORPCN IN "+cCnpj    																						+CRLF
		EndIf

		cQueryZAF +=" AND D_E_L_E_T_ = ' '  "   																							+CRLF
		cQueryZAF +=" GROUP BY ZAF_SLUID, ZAF_MODULO, ZAF_EVENTO, ZAF_SEARCH, ZAF_ITNAME, ZAF_PROMOT,ZAF_CORPNA, ZAF_CORPCN, ZAF_DTVEND, ZAF_DTCANC "  +CRLF
		cQueryZAF +=" ORDER BY ZAF_CORPCN,ZAF_DTVEND,ZAF_SEARCH, ZAF_SLUID, ZAF_MODULO "  												+CRLF

		FwMsgRun(NIL,{ |oSay| B2BExcel( cQueryZAF,oSay) }, "ARQUIVO EXCEL", 'SELECIONANDO REGISTROS, AGUARDE.......')

	Else
		FWAlertWarning("Nenhum registro foi selecionado, o relatório não será gerado.", "Faturamento B2B")
	EndIf

Return


/*/{Protheus.doc} B2BExcel
Gerar um arquivo com os dados localizados e tamb?m com o comando SQL executado.
Sendo que ir? gerar esse arquivo no formato .XLS quando tiver o Excel instalado, OU ent?o cria um arquivo .CSV
@type function
@version 12.1.27
@author Jorge Alberto
@since 01/04/2021
@param cSql, character, Comando Sql
@param cLogErro, character, Log com o erro
@param nPosCursor, numeric, Posiçao do cursor no momento da chamada da rotina
/*/
Static Function B2BExcel( cQueryZAF,oSay)

//	Local oFWMsExcel
//	Local oExcel
//	Local cArquivo := 'C:\temp\B2BExcel.xml'
//	Local nRegs := 0
	Local cEOL		:= Chr(13) + Chr(10)
	Local aAreaZAD := ZAD->(GetArea())
	Local cDirDoc	:= msDocPath()
	Local cArq		:= ""//CriaTrab(NIL, .F.) + ".csv"

	DbSelectArea("ZAD")
	DbsetOrder(3)

	oSay:SetText("Memória de Calculo B2B")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	TCQuery cQueryZAF  New Alias (cAlias:=GetNextAlias())

	// verifica se o Excel existe
	If !apOleClient("MsExcel")
		msgStop("Excel não instalado.", "RELFATB2B.PRW")
		Return
	EndIf

	// cria arquivo csv
	cArq	:= "RELFATB2B.CSV"
	nHdl	:= fCreate(cDirDoc + "\" + cArq)

	If nHdl < 0
		msgStop("Não foi possível criar o arquivo de saída.", "RELFATB2B.PRW")
		Return
	EndIf

// grava cabecalho
	cTxt	:= "Id Venda;"
	cTxt	+= "Status;"
	cTxt	+= "Modulo;"
	cTxt	+= "Produtor;"
	cTxt	+= "Evento;"
	cTxt	+= "Localizador;"
	cTxt	+= "Descrição;"
	cTxt	+= "Cliente;"
	cTxt	+= "CPF/CNPJ;"
	cTxt	+= "Data Faturamento;"
	cTxt	+= "Data Cancelamento;"
	cTxt	+= "Valor Total;"
	cTxt	+= "Taxas de Operação;"
	cTxt	+= "Taxas de Serviço" + cEOL

	fWrite(nHdl, cTxt, Len(cTxt))

	While !(cAlias)->(EoF())

		ZAD->(MsSeek(xFilial("ZAD") + (cAlias)->ZAF_SLUID))
		cNomCli := Alltrim(ZAD->ZAD_NOME)
		cCPFCli := Alltrim(ZAD->ZAD_CPF)

		cTxt :=Alltrim((cAlias)->ZAF_SLUID) 			+ ";"
		cTxt +="" 										+ ";"
		cTxt +=	(cAlias)->ZAF_MODULO 					+ ";"
		cTxt +=	Upper((cAlias)->ZAF_CORPNA)				+ ";"
		cTxt += (cAlias)->ZAF_EVENTO 					+ ";"
		cTxt += (cAlias)->ZAF_SEARCH					+ ";"
		cTxt += Upper((cAlias)->ZAF_ITNAME)				+ ";"
		cTxt += cNomCli									+ ";"
		cTxt += cCPFCli									+ ";"
		cTxt += Dtoc(Stod((cAlias)->ZAF_DTVEND))		+ ";"
		cTxt += Dtoc(Stod((cAlias)->ZAF_DTCANC))				+ ";"
		cTxt += Alltrim(Transform((cAlias)->ZAF_FINCRE,"@E 999,999,999,999.99")) + ";"
		cTxt += Alltrim(Transform((cAlias)->ZAF_FINTXO,"@E 999,999,999,999.99")) + ";"
		cTxt += Alltrim(Transform((cAlias)->ZAF_FINTXS,"@E 999,999,999,999.99")) + ";"
		cTxt += cEOL


		fWrite(nHdl, cTxt, Len(cTxt))

		//Pulando Registro
		(cAlias)->(DbSkip())
	EndDo

	fClose(nHdl)

	// pergunta onde gravar o arquivo no cliente
	cNomLoc	:= "C:\temp\"//MV_PAR04//cGetFile("Arquivos csv (*.csv)|*.csv", "Salvar arquivo", 1, "\", .F., nOr(GETF_LOCALHARD,GETF_RETDIRECTORY), .F., .F.)

	If !Empty(cNomLoc)
		If Right(cNomLoc, 1) <> "\"
			nPos	:= rAt("\", cNomLoc)

			If nPos > 0
				cNomLoc	:= Left(cNomLoc, nPos)
			EndIf
		EndIf

		// copia csv para o cliente
		CpyS2T(cDirDoc + "\" + cArq, cNomLoc)

		// abre Excel
		oExcApp	:= msExcel():New()
		oExcApp:WorkBooks:Open(cNomLoc + "\" + cArq)
		oExcApp:SetVisible(.T.)
	EndIf


// apaga arquivo no servidor
	If File(cDirDoc + "\" + cArq)
		fErase(cDirDoc + "\" + cArq)
	EndIf


/*
	oFWMsExcel := FWMSExcel():New()

	//Aba 01 - Memoria de Calculo
	oFWMsExcel:AddworkSheet("Memoria de Calculo")

	//Criando a Tabela
	oFWMsExcel:AddTable("Memoria de Calculo","Dados")
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Id Venda",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Status",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Modulo",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Evento",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Localizador",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Descrição",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Cliente",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","CPF/CNPJ",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Data Faturamento",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Data cANCELAMENTO",1)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Valor Total",3)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Taxas de Operação",3)
	oFWMsExcel:AddColumn("Memoria de Calculo","Dados","Taxas de Serviço",3)

	(cAlias)->(dbGotop())
	Count to nRegs
	nItem := 1

	(cAlias)->(dbGotop())
	
	oSay:SetText("Gravando dados no arquivo Excel.")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT
	
	//Criando as Linhas... Enquanto não for fim da query
	While !(cAlias)->(EoF())

		ZAD->(MsSeek(xFilial("ZAD") + (cAlias)->ZAF_SLUID))
		cNomCli := Alltrim(ZAD->ZAD_NOME)
		cCPFCli := Alltrim(ZAD->ZAD_CPF)
		
		oFWMsExcel:AddRow("Memoria de Calculo","Dados",{;
			(cAlias)->ZAF_SLUID			,;
			''							,;
			(cAlias)->ZAF_MODULO		,;
			(cAlias)->ZAF_EVENTO		,;
			(cAlias)->ZAF_SEARCH		,;
			(cAlias)->ZAF_ITNAME		,;
			cNomCli						,;
			cCPFCli						,;
			Stod((cAlias)->ZAF_DTVEND)	,;
			Stod((cAlias)->ZAF_DTCANC)	,;
			(cAlias)->ZAF_VLRTRA		,;
			(cAlias)->ZAF_FINTXO		,;
			(cAlias)->ZAF_FINTXS		;
			})
		
		nItem := nItem+1

		//Pulando Registro
		(cAlias)->(DbSkip())
	EndDo

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()       //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo) //Abre uma planilha
	oExcel:SetVisible(.T.)          //Visualiza a planilha
	oExcel:Destroy()                //Encerra o processo do gerenciador de tarefas
*/
	(cAlias)->(DbCloseArea())
	RestArea(aAreaZAD)

Return
