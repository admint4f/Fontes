#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define _EOL chr(13)+chr(10)

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �t4fCaixinha?Autor �Luiz Eduardo           ?Data ? 25/10/18   ���
��������������������������������������������������������������������������͹��
���Descricao ?Relatorio do caixinha.                    				   ���
��?         ?                                                              ���
��������������������������������������������������������������������������͹��
���Uso       ?T4F / Financeiro                                             ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

User Function t4fCaixinha()

	//����������������������������������������������������������������������?
	//?Declaracao de Variaveis                                             ?
	//����������������������������������������������������������������������?
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
		ApMsgInfo("Problema com o nome do arquivo."+chr(13)+"Aten��o: "+chr(13)+"- N�o pode ficar em branco;"+chr(13)+"- N�o pode ter extens�o"+chr(13)+"- N�o deve ter mais de 8 CARACTERES.","INFO")
		lContinua:= .f.
	Endif

	If  lContinua 
		Processa({|| RunProcesso() },"Processsando arquivo...")
	EndIf    

Return

/*/
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
�������������������������������������������������������������������������ͻ�?
���Fun��o    �RUNPROCESS?Autor ?Gilberto           ?Data ? 16/08/10   ��?
�������������������������������������������������������������������������͹�?
���Descri��o ?Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ��?
��?         ?monta a janela com a regua de processamento.               ��?
�������������������������������������������������������������������������͹�?
���Uso       ?Programa principal                                         ��?
�������������������������������������������������������������������������ͼ�?
����������������������������������������������������������������������������?
����������������������������������������������������������������������������?
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

		ApMsgInfo("Arquivo :"+_cArquivo+".xml gerado. Verifique o disco local de sua m�quina"+chr(13)+"Aperte OK para continuar gerando o relat�rio...","Informa��o","INFO")

	EndIF             

	Trb->( DbCloseArea() )

Return(Nil)
