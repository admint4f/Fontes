#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE 'FWMVCDEF.CH'

#DEFINE CRLF (chr(13)+chr(10))
/*/{Protheus.doc} T4APRODET
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

User Function T4APRODET(cDataIni,cDataFim,cEpep)

	Local cQry  	:= ''
	Local oSay

	Private cAliasZ 	:= ''

	//LOCALIZADOR|SESSÃO(DT E HORA)|EPEP|DESCRICAO| - FILTRO POR DATA EVENTO

	//Consulta localizadores
	cQry+= "  SELECT ZAD_SEARCH, SUBSTR(ZAD_DTEVEN,1,4)||SUBSTR(ZAD_DTEVEN,6,2)||SUBSTR(ZAD_DTEVEN,9,2) DT,ZAJ_HORA, "+ CRLF
	cQry+= "  ZAD_EPEP,ZAD_EVENTO, SUM(ZAD_VLRTKT) ZAD_VLRTKT "+ CRLF
	cQry+= "  	FROM "+RetSqlName("ZAD") + ' ZAD,' + RetSqlName("ZAJ") + ' ZAJ' + CRLF
	cQry+= "  	WHERE ZAD_EPEP = '"+cEpep +"' "+ CRLF
	cQry+= "  		AND ZAJ.ZAJ_DATA BETWEEN '"+cDataIni+"'"+' AND ' +"'"+cDataFim+"'"+CRLF
	cQry+= "  		AND SUBSTR(ZAD_DTEVEN , 1 , 4)||SUBSTR(ZAD_DTEVEN , 6 , 2)||SUBSTR(ZAD_DTEVEN , 9 , 2) = ZAJ.ZAJ_DATA  "+ CRLF
	cQry+= "  		AND SUBSTR(ZAD_DTEVEN,12,5) = ZAJ_HORA  "+ CRLF
	cQry+= "  		AND ZAJ_CANC = '2' "+ CRLF
	cQry+= "  		AND ZAD_FILIAL = '01'	 "+ CRLF
	cQry+= "  		AND ZAD_ITEMID > ' ' "+ CRLF
	cQry+= "  		AND ZAD_STATUS = '3' "+ CRLF
	cQry+= "  		AND ZAD_TPTRAN = '1' "+ CRLF
	cQry+= "  		AND ZAD_SETOTV = 'I  ' "+ CRLF
	cQry+= "  		AND ZAD.D_E_L_E_T_ = ' ' "+ CRLF
	cQry+= "  		AND ZAJ.D_E_L_E_T_ = ' ' "+ CRLF
	cQry+= "  		GROUP BY ZAD_SEARCH, SUBSTR(ZAD_DTEVEN,1,4)||SUBSTR(ZAD_DTEVEN,6,2)||SUBSTR(ZAD_DTEVEN,9,2),ZAJ_HORA, "+ CRLF
	cQry+= "  		ZAD_EPEP,ZAD_EVENTO "+ CRLF

	cQry:= ChangeQuery(cQry)

	cAliasZ := MPSysOpenQuery(cQry)

	dbSelectArea(cAliasZ)

	(cAliasZ)->(dbGoTop())

	FwMsgRun(NIL,{ |oSay| GExcel(cAliasZ,oSay) }, "ITENS A APROPRIAR", 'SELECIONANDO REGISTROS, AGUARDE.......')

Return


/*/{Protheus.doc} GExcel
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
Static Function GExcel(cAliasZ,oSay)

	Local oFWMsExcel
	Local oExcel
	Local cArquivo 	:= 'C:\temp\t4aprodet.xml'

	oSay:SetText("Gerando consulta localizadores")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	oFWMsExcel := FWMSExcel():New()

	//Aba 01 - Localizadores
	oFWMsExcel:AddworkSheet("Localizadores")

	//Criando a Tabela
	oFWMsExcel:AddTable("Localizadores","Vendas")
	oFWMsExcel:AddColumn("Localizadores","Vendas","Localizador",1)
	oFWMsExcel:AddColumn("Localizadores","Vendas","Data ",1)
	oFWMsExcel:AddColumn("Localizadores","Vendas","Seção",1)
	oFWMsExcel:AddColumn("Localizadores","Vendas","EPEP",1)
	oFWMsExcel:AddColumn("Localizadores","Vendas","Descrição",1)
	oFWMsExcel:AddColumn("Localizadores","Vendas","Valor",3)

	//Criando as Linhas... Enquanto não for fim da query
	While !(cAliasZ)->(EoF())

		oFWMsExcel:AddRow("Localizadores","Vendas",{;
			(cAliasZ)->ZAD_SEARCH,;
			Stod((cAliasZ)->DT),;
			(cAliasZ)->ZAJ_HORA,;
			(cAliasZ)->ZAD_EPEP,;
			(cAliasZ)->ZAD_EVENTO,;
			(cAliasZ)->ZAD_VLRTKT;
			})

		//Pulando Registro
		(cAliasZ)->(DbSkip())
	EndDo

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

	(cAliasZ)->(DbCloseArea())

Return
