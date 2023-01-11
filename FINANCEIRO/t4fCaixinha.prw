#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define _EOL chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณt4fCaixinha?Autor ณLuiz Eduardo           ?Data ? 25/10/18   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ?Relatorio do caixinha.                    				   บฑฑ
ฑฑ?         ?                                                              บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ?T4F / Financeiro                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function t4fCaixinha()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ?
	//?Declaracao de Variaveis                                             ?
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ?
	Local lContinua := .t.
	Local lExit:= .f.
	Local cPerg   := "CAIXINHA"

	If Select("CAIXINHA") > 0
		DbSelectArea("CAIXINHA")
		DbCloseArea()
	Endif


	dbSelectArea("SET")
	dbSetOrder(1)                                                                                                                      

	If  !Pergunte(cPerg,.t.)
		lContinua:= .f.
	EndIf

	If Empty(mv_par01) .or. At(".",mv_par01)>0 .or. Len(Alltrim(mv_par01)) > 20
		ApMsgInfo("Problema com o nome do arquivo."+chr(13)+"Aten็ใo: "+chr(13)+"- Nใo pode ficar em branco;"+chr(13)+"- Nใo pode ter extensใo"+chr(13)+"- Nใo deve ter mais de 8 CARACTERES.","INFO")
		lContinua:= .f.
	Endif

	If  lContinua 
		Processa({|| RunProcesso() },"Processsando arquivo...")
	EndIf    

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑ?
ฑฑบFuno    ณRUNPROCESS?Autor ?Gilberto           ?Data ? 16/08/10   บฑ?
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑ?
ฑฑบDescrio ?Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑ?
ฑฑ?         ?monta a janela com a regua de processamento.               บฑ?
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑ?
ฑฑบUso       ?Programa principal                                         บฑ?
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑ?
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ?
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿?
/*/

Static Function RunProcesso()

	Local _cArquivo, _cPNome, _cAlias
	Local cQuery:= ''
	Local oTMPTable

	cQuery +=  " SELECT ET_NOME AS NOME,ET_FORNECE AS FORNECE,ET_GESTOR AS GESTOR,ET_CC,CTT_DESC01	AS DESCRI,"
	cQuery +=  " ET_LOCAL AS LOCAL,ET_CARTAO	AS CARTAO,ET_VCTOLIM AS VENCIMENTO,	ET_VALOR AS VALOR 
	cQuery +=  " FROM "+retSqlName("SET")+ " XET "
	cQuery += "  LEFT JOIN "+retSqlName("CTT")+ " CTT ON CTT_CUSTO = ET_CC AND CTT.D_E_L_E_T_ <> '*' "
	cQuery += "  WHERE ET_SITUAC='0' AND XET.D_E_L_E_T_ = ' '  "

	cQuery+=  " ORDER BY ET_NOME "

	cQuery:= ChangeQuery(cQuery)

	Memowrite("C:\temp\CAIXINHA.SQL",cquery)   

	MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"CAIXINHA",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

	
	DbSelectArea("CAIXINHA")
	DbCommitAll()         
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	_cArqTrb:= CriaTrab(nil,.f.)
	Copy To &(_cArqTrb)
	*/

	If Select("trb") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif
	
	
	/*
	dbUseArea( .T.,,_cArqTrb, "TRB", Nil, .F. )
	*/

	oTMPTable:= FWTemporaryTable():New("TRB")
	oTMPTable:Create()	
	//oTMPTable:APPEND FROM ("CAIXINHA")
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	DBGOTOP()

	Trb->( DbGotop() )

	If Trb->( !Eof() )
		//C:\CAIXINHA.SQL
		//	_cArquivo:= "C:\Temp\Caixinha"+substr( dtos(dDatabase),1,6)
		_cArquivo:= "C:"+Iif( !empty( mv_par01), lower(alltrim(mv_par01)),"Caixinha"+substr( dtos(dDatabase),1,6) )
		_cPNome:= "Caixinha"
		_cAlias:= "Trb"

		If File( _cArquivo+".xml" )
			Ferase( _cArquivo+".xml")
		EndIf 

		MsAguarde( { || u_DB2XML(_cArquivo, _cPNome, _cAlias,,,,"2018","DTOC(dDataBase)")},"Aguarde .. Gerando arquivo...")

		ApMsgInfo("Arquivo :"+_cArquivo+".xml gerado. Verifique o disco local de sua mแquina"+chr(13)+"Aperte OK para continuar gerando o relat๓rio...","Informa็ใo","INFO")

	EndIF             

	Trb->( DbCloseArea() )

Return(Nil)
