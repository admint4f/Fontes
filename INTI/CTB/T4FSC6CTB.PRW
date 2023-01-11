#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"

#DEFINE CRLF (chr(13)+chr(10))
/*/{Protheus.doc} T4FSC6CTB
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

User Function T4FSC6CTB()

	Local cQuery  := ''
	Local cQuery2 := ''
	Local oSay

	Private aParamBox	:= {}
	Private aRet		:= {}
	Private cDataIni	:= ''
	Private cDataFim	:= ''

	aAdd(aParamBox,{1,"Data Inicial 	"	,CTOD('')					,"","","   ","",80,.F.})  //01
	aAdd(aParamBox,{1,"Data Final   	"	,CTOD('')					,"","","   ","",80,.F.})  //01

	If !ParamBox(aParamBox, "Relatório de Conferencia Integrações", aRet)
		Return Nil
	Else
		cDataIni	:= Alltrim(DTOS(aRet[1]))
		cDataFim	:= Alltrim(DTOS(aRet[2]))

	End If

	//Consulta PEDIDOS
	cQuery += "SELECT C6_NUM, C6_PRODUTO, C6_QTDVEN,  C6_DESCRI, C6_VALOR, C6_ITEMCC, C6_DATFAT, C6_NOTA, C6_SERIE, C6_COMPLE1 "
	cQuery += "FROM " + RetSqlName("SC6" ) + "  SC6, "+ RetSqlName("SC5") +" SC5 "
	cQuery += "WHERE C6_FILIAL 	= C5_FILIAL "
	cQuery += "AND C6_NUM 		= C5_NUM "
	cQuery += "AND C6_ITEM 		>  ' ' "
	cQuery += "AND C6_PRODUTO 	>  ' ' "
	cQuery += "AND SC5.C5_FILIAL= C6_FILIAL "
	cQuery += "AND C5_NUM 		= C6_NUM "
	cQuery += "AND C5_EMISSAO BETWEEN '"+cDataIni+"'" + " AND " + "'" + cDataFim + "' "
	cQuery += "AND SC5.C5_PAGTO = 'BYINTI' "
	cQuery += "AND SC5.D_E_L_E_T_ =' ' "
	cQuery += "AND SC6.D_E_L_E_T_ =' ' "
	cQuery += "ORDER BY C6_NUM, C6_NOTA "

	//Consulta localizadores
	cQuery2 += " SELECT ZAD_ITTYPE, SUM(ZAD_VLRTKT+ZAD_VLRTXO+ZAD_VLRTXS+ZAD_VLRTXC+ZAD_VLRTXI+ZAD_VLRXCA+ZAD_VLRSOC+ZAD_VLENTR) VALOR,"
	cQuery2 += " ZAD_DTVEND, ZAD_EPEP, ZAD_PEDIDO, ZAD_NFTOTV, ZAD_SETOTV, ZAD_SEARCH, ZAD_SLUID, ZAD_STATUS, COUNT(*) QTD"
	cQuery2 += " FROM "+RetSqlName("ZAD") + " ZAD"
	cQuery2 += " WHERE ZAD_FILIAL = '01' "
	cQuery2 += " AND ZAD_DTVEND BETWEEN '"+cDataIni+"'" + " AND " + "'" + cDataFim + "' "
	cQuery2 += "	AND ZAD_STATUS IN ('2','3','5')"
    cQuery2 += "	AND ZAD_TPTRAN = '1' "
	cQuery2 += "	AND ZAD.D_E_L_E_T_ =' '"
	cQuery2 += "GROUP BY ZAD_EPEP,ZAD_ITTYPE,ZAD_PEDIDO, ZAD_DTVEND, ZAD_NFTOTV, ZAD_SETOTV, ZAD_SEARCH, ZAD_STATUS,ZAD_SLUID"
	cQuery2 += " ORDER BY ZAD_DTVEND, ZAD_SEARCH,ZAD_SLUID,ZAD_EPEP"
	
	//Consulta localizadores

	cQuery3 := "	SELECT ZADCANC.ZAD_SEARCH, ZADCANC.ZAD_DTVEND, ZADCANC.ZAD_ITTYPE, ZADCANC.ZAD_DTCANC, ZADCANC.ZAD_EPEP EPEP , COUNT(*) TOTCANC,  "+ CRLF
	cQuery3 += "	SUM(ZADCANC.ZAD_VLRTKT+ZADCANC.ZAD_VLRSOC+ZADCANC.ZAD_VLRTXC) VLRCANC, ZAE.ZAE_CC CC, ZADVEND.ZAD_NFTOTV NFORI, ZADVEND.ZAD_SETOTV SERIORI, ZADCANC.ZAD_NFTOTV NF, ZADCANC.ZAD_SETOTV SERIE 	 "+ CRLF
	cQuery3 += "	FROM " + RetSqlName("ZAD") +" ZADCANC," + RetSqlName("ZAD") + " ZADVEND," +  RetSqlName("ZAE") + " ZAE "+ CRLF
	cQuery3 += "	WHERE ZADVEND.ZAD_FILIAL 	= ZADCANC.ZAD_FILIAL 			 "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_DTVEND 		= ZADCANC.ZAD_DTVEND	 "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_ITEMID		= ZADCANC.ZAD_ITEMID "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_EPEP		= ZADCANC.ZAD_EPEP "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_TKTID 		= ZADCANC.ZAD_TKTID "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_CPF			= ZADCANC.ZAD_CPF "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_SLUID 		= ZADCANC.ZAD_SLUID "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_ITTYPE		= ZADCANC.ZAD_ITTYPE "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_TPTRAN 		='1' "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_SEARCH 		= ZADCANC.ZAD_SEARCH			 "+ CRLF
	cQuery3 += "		AND ZADVEND.ZAD_STATUS 		='5'							 "+ CRLF
	cQuery3 += "		AND ZADCANC.ZAD_DTVEND 		BETWEEN '"+cDataIni+"'" + " AND " + "'" + cDataFim + "' "
	cQuery3 += "		AND ZADCANC.ZAD_TPTRAN 		='2'											 "+ CRLF
	cQuery3 += "		AND ZADCANC.ZAD_STATUS 		='5'											 "+ CRLF
	cQuery3 += "		AND ZADCANC.ZAD_EPEP 		= ZAE_EPEP												 "+ CRLF
	cQuery3 += "		AND ZAE_MSBLQL 				<> '1' 													 "+ CRLF
	cQuery3 += "		AND ZADCANC.ZAD_DTCANC BETWEEN '"+cDataIni+"'" + " AND " + "'" + cDataFim + "' "
	cQuery3 += "		AND ZADCANC.D_E_L_E_T_		=' '												 "+ CRLF
	cQuery3 += "		AND ZADVEND.D_E_L_E_T_		=' ' "+ CRLF
	cQuery3 += "		AND ZAE.D_E_L_E_T_			=' ' "+ CRLF
	cQuery3 += "	GROUP BY ZADCANC.ZAD_SEARCH, ZADCANC.ZAD_DTVEND, ZADCANC.ZAD_ITTYPE, ZADCANC.ZAD_DTCANC, ZADCANC.ZAD_EPEP,   "+ CRLF
	cQuery3 += "	ZAE.ZAE_CC , ZADVEND.ZAD_NFTOTV , ZADVEND.ZAD_SETOTV , ZADCANC.ZAD_NFTOTV , ZADCANC.ZAD_SETOTV  "+ CRLF
	cQuery3 += "	ORDER BY ZADVEND.ZAD_NFTOTV "+ CRLF

	FwMsgRun(NIL,{ |oSay| ProcExcel( cQuery,cQuery2,cQuery3, "",oSay ) }, "ARQUIVO EXCEL", 'SELECIONANDO REGISTROS, AGUARDE.......')

Return


/*/{Protheus.doc} ProcExcel
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
Static Function ProcExcel( cSql,cSql2,cSql3, cLogErro,oSay)

	Local oFWMsExcel
	Local oExcel
	Local cArquivo := 'C:\temp\zTstExc1.xml'
    Local nAtual := 0

    oSay:SetText("Gerando consulta Pedido de Venda")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	cSql	:= ChangeQuery(cSql)
	TcQuery cSql New Alias (cAlias:=GetNextAlias())
	
	oFWMsExcel := FWMSExcel():New()

	//Aba 01 - Pedidos
	oFWMsExcel:AddworkSheet("Pedido de Venda")

	//Criando a Tabela
	oFWMsExcel:AddTable("Pedido de Venda","Produtos")
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Numero",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Codigo",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Descricao",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Quantidade",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Valor",3)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Epep",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Data Faturamento",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Nota",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Serie",1)
	oFWMsExcel:AddColumn("Pedido de Venda","Produtos","Complemento",1)
	
    (cAlias)->(dbGotop())

	oSay:SetText("Gravando dados no Excel. Aguarde!!!")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

    //Criando as Linhas... Enquanto não for fim da query
	While !(cAlias)->(EoF())
 		
		oFWMsExcel:AddRow("Pedido de Venda","Produtos",{;
			(cAlias)->C6_NUM,;
			(cAlias)->C6_PRODUTO,;
			(cAlias)->C6_DESCRI,;
			(cAlias)->C6_QTDVEN,;
			(cAlias)->C6_VALOR,;
			(cAlias)->C6_ITEMCC,;
			Stod((cAlias)->C6_DATFAT),;
			(cAlias)->C6_NOTA,;
			(cAlias)->C6_SERIE,;
			(cAlias)->C6_COMPLE1;
			})

		//Pulando Registro
		(cAlias)->(DbSkip())
	EndDo

    oSay:SetText("Gerando consulta Localizadores")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	cSql2	:= ChangeQuery(cSql2)
	TcQuery cSql2 New Alias (cAlias2:=GetNextAlias())
	
	/*
	cAlias2	:= MPSysOpenQuery(cSql2)
	*/
		
	//Aba 02 - Localizadores
	oFWMsExcel:AddworkSheet("Localizadores Vendas")
    
    //Criando a Tabela
	oFWMsExcel:AddTable("Localizadores Vendas","Localizadores")
	oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Produtos",3)
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Valor",3)
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Data Venda",1)
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Pedido",1)
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Nota",1)
	oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Serie",1)
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Localizador",1)    
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","SluId",1)
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Epep",1)
    oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Status",1)
	oFWMsExcel:AddColumn("Localizadores Vendas","Localizadores","Quantidade",1)
        
    (cAlias2)->(dbGotop())
    //Criando as Linhas... Enquanto não for fim da query
	While !(cAlias2)->(EoF())
        
    	oFWMsExcel:AddRow("Localizadores Vendas","Localizadores",{;
			(cAlias2)->ZAD_ITTYPE,;
			(cAlias2)->VALOR,;
			Stod((cAlias2)->ZAD_DTVEND),;
			(cAlias2)->ZAD_PEDIDO,;
            (cAlias2)->ZAD_NFTOTV,;
			(cAlias2)->ZAD_SETOTV,;
			(cAlias2)->ZAD_SEARCH,;
            (cAlias2)->ZAD_SLUID,;
            (cAlias2)->ZAD_EPEP,;
            (cAlias2)->ZAD_STATUS,;
			(cAlias2)->QTD;
			})

		//Pulando Registro
		(cAlias2)->(DbSkip())
	EndDo

	oSay:SetText("Gerando consulta cancelamentos")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT
	
	cSql3	:= ChangeQuery(cSql3)
	TcQuery cSql3 New Alias (cAlias3:=GetNextAlias())
	
	/*
	cAlias3	:= MPSysOpenQuery(cSql3)
	*/
		
	//Aba 03 - Cancelados
	oFWMsExcel:AddworkSheet("Vendas Canceladas")
    
    //Criando a Tabela
	oFWMsExcel:AddTable("Vendas Canceladas","Cancelamento")
	oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Localizador",1)
    oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Data Venda",1)
	oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Data Cancelamento",1)
	oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Produto",1)
    oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Epep",1)	
	oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Quantidade",1)
	oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Valor",3)
   	oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","C.Custo",1)
   	oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Nota Original",1)
    oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Serie Original",1)
    oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Nota Dev.",1)	
    oFWMsExcel:AddColumn("Vendas Canceladas","Cancelamento","Serie Dev.",1)	

    oSay:SetText("Finalizando gravação do arquivo.")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	(cAlias3)->(dbGotop())
    //Criando as Linhas... Enquanto não for fim da query
	While !(cAlias3)->(EoF())
        
		oFWMsExcel:AddRow("Vendas Canceladas","Cancelamento",{;
			(cAlias3)->ZAD_SEARCH,;
			Stod((cAlias3)->ZAD_DTVEND),;
			Stod((cAlias3)->ZAD_DTCANC),;
			(cAlias3)->ZAD_ITTYPE,;		
			(cAlias3)->EPEP,;	
			(cAlias3)->TOTCANC,;
			(cAlias3)->VLRCANC,;
			(cAlias3)->CC,;
			(cAlias3)->NFORI,;
			(cAlias3)->SERIORI,;
			(cAlias3)->NF,;
			(cAlias3)->SERIE;
			})

		//Pulando Registro
		(cAlias3)->(DbSkip())
	EndDo

	//Ativando o arquivo e gerando o xml
	oFWMsExcel:Activate()
	oFWMsExcel:GetXMLFile(cArquivo)

	//Abrindo o excel e abrindo o arquivo xml
	oExcel := MsExcel():New()             //Abre uma nova conexão com Excel
	oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
	oExcel:SetVisible(.T.)                 //Visualiza a planilha
	oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas
	
	(cAlias)->(DbCloseArea())
	(cAlias2)->(DbCloseArea())
	(cAlias3)->(DbCloseArea())

Return
