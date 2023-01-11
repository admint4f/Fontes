#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "Protheus.ch"
#DEFINE EOL 	CHR(13) + CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Consolidado?Autor ³Gilberto A Oliveira ?Data ? 15/08/10      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio da Base Consolidada Contabil.                      º±±
±±º          ³                                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³T4F / Contabilidade                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function t4fRazao()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//|?Declaracao de Variaveis                                             |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	Local lContinua := .t.
	Local lExit:= .f.
	Local cPerg   := "CONSOL"

	If Select("consolid") > 0
		DbSelectArea("consolid")
		DbCloseArea()
	Endif


	dbSelectArea("CT2")
	dbSetOrder(1)                                                                                                                      

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSx1(cPerg,"01",	"Data Lancto de ?", "Data Lancto de ?" ,"Data Lancto de ?",	"mv_ch1","D",8,	0,	0,	"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02",	"Data Lancto Ate ?","Data Lancto Ate ?","Data Lancto Ate ?","mv_ch2","D",8,	0,	0,	"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03",	"Conta Contabil de ?",	"Conta Contabil de ?" ,	"Conta Contabil de ?",	"mv_ch3",	"C",20,	0,	0,	"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04",	"Conta Contabil ate ?","Conta Contabil ate ?","Conta Contabil ate ?",	"mv_ch4",	"C",20,	0,	0,	"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"05",	"Nome Arquivo ?","File Name ?","File Name ?","mv_ch5",	"C",20,0,0,	"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{"Digite o nome do arquivo que deseja","gerar. Escolha, de preferencia, um nome","simples e NÃO COLOQUE EXTENSÃO."},{},{})
	PutSx1(cPerg,"06",	"Tipo Saldo ?","Tipo Saldo ?","Tipo Saldo ?",	"mv_ch6",	"C",TamSX3("CT2_TPSALD")[1],	0,	0,	"G","","SLW","","","mv_par06","","","","","","","","","","","","","","","","")
	*/

	If  !Pergunte(cPerg,.t.) 
		Return()
	EndIf  
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	While  lContinua 
	
		/*
		If  !Pergunte(cPerg,.t.) 
			Exit
		EndIf  
		*/

		If Empty(mv_par01) .or. Empty(mv_par02)
			ApMsgInfo("Não pode haver data em branco !"+chr(13)+ "Por favor verifique os parametros...","INFO")
			Loop
		EndIf

		If Empty(mv_par02) < Empty(mv_par01)
			ApMsgInfo("H?data final deve ser maior que a data inicial !"+chr(13)+ "Por favor verifique os parametros...","INFO")
			Loop
		EndIf

		If Empty(mv_par03) .And. Empty(mv_par04)
			ApMsgInfo("Digite a conta contábil inicial e final, se quiser trazer todas as contas"+chr(13)+ 'digite "Conta de" com a primeira do cadastro e "Conta at? com a ultima',"INFO")
			Loop
		EndIf

		If Empty(mv_par05) .or. At(".",mv_par05)>0 .or. Len(Alltrim(mv_par05)) > 20
			ApMsgInfo("Problema com o nome do arquivo."+chr(13)+"Atenção: "+chr(13)+"- Não pode ficar em branco;"+chr(13)+"- Não pode ter extensão"+chr(13)+"- Não deve ter mais de 8 CARACTERES.","INFO")
			Loop
		Endif
		
		lContinua:= .f.

	End-While

	If  !lContinua 
		Processa({|| RunProcesso() },"Processsando arquivo...")
	EndIf    

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFun‡„o    ³RUNPROCESS?Autor ?Gilberto           ?Data ? 16/08/10   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescri‡„o ?Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±?
±±?         ?monta a janela com a regua de processamento.               º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?Programa principal                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
/*/

Static Function RunProcesso()

	Local _cArquivo, _cPNome, _cAlias
	Local cQuery:= ''
	Local lAuro
	Local oTMPTable	:= Nil     

	//Cod Conta	Data Lcto	Numero Lote	Sub Lote	Numero Doc	Numero Linha	Hist Lanc	
	//XPARTIDA	C Custo	Elem Pep	DEBITO	CREDITO	Cod. Fornec.	N Fantasia

	cQuery+=  "SELECT  SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE,CT2_DOC, CT2_LINHA, CT2_CREDIT AS CONTA, CT2_VALOR AS CREDITO,0 AS DEBITO "
	cQuery+=  ",CT2_HIST, CT2_DEBITO AS XPARTIDA, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_XDOC AS CODFOR ,CT2_XUSER AS NOME "
	cQuery+=  " FROM "+retSqlName("CT2")+ " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery+=  " AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"'"
	cQuery+=  " AND D_E_L_E_T_ = ' '  " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")

	cQuery+= " UNION ALL "
	cQuery+=  "SELECT  SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE,CT2_DOC, CT2_LINHA, CT2_DEBITO AS CONTA, 0 AS CREDITO, CT2_VALOR AS DEBITO "
	cQuery+=  ",CT2_HIST, CT2_CREDIT AS XPARTIDA, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_XDOC AS CODFOR ,CT2_XUSER AS NOME "
	cQuery+=  " FROM "+retSqlName("CT2")+ " WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' "
	cQuery+=  " AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"'"
	cQuery+=  " AND D_E_L_E_T_ = ' '  " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
	cQuery+=  " ORDER BY CT2_DATA "

	cQuery:= ChangeQuery(cQuery)

	Memowrite("C:\CONSOLIDADO.SQL",cquery)   

	MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"CONSOLID",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//?Compatibiliza os campos com a TopField ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTamSX3	:= TAMSX3("CT2_DATA")   ; TcSetField("CONSOLID", "CT2_DATA",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	aTamSX3	:= TAMSX3("CT2_VALOR")  ; TcSetField("CONSOLID", "VALOR"  ,	aTamSX3[3], aTamSX3[1], aTamSX3[2])
	DbSelectArea("CONSOLID")
	DbCommitAll()         

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 20/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	_cArqTrb:= CriaTrab(nil,.f.)
	Copy To &(_cArqTrb)

	If Select("trb") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif

	dbUseArea( .T.,,_cArqTrb, "TRB", Nil, .F. )
	*/

	If Select("trb") > 0
		DbSelectArea("TRB")
		DbCloseArea()
	Endif

	oTMPTable:= FWTemporaryTable():New("TRB" )
	oTMPTable:SetFields( aTamSX3 )
	oTMPTable:Create()	

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	DBGOTOP()

	do while !eof()
		if "W"$CT2_HIST         
			cForn := substr(trb->CT2_HIST,at("W",trb->CT2_HIST),6)
			Select SA2
			dbSetOrder(1)
			Seek xFilial()+cForn
			IF !EOF()
				Select Trb
				RecLOCK("TRB",.f.)
				Trb->CODFOR := SA2->A2_COD
				Trb->NOME	:= SA2->A2_NREDUZ
				MsUnLock()       
			ELSE
				Select Trb
				RecLOCK("TRB",.f.)
				Trb->CODFOR := ""
				Trb->NOME	:= ""
				MsUnLock()       
			ENDIF
		Endif
		skip
	enddo

	Trb->( DbGotop() )

	If Trb->( !Eof() )

		_cArquivo:= "C:\"+Iif( !empty( mv_par05), lower(alltrim(mv_par05)),"consolidado_contabil_periodo_"+substr( dtos(mv_par01),1,4) )
		_cPNome:= "Consolidado_Contabil"
		_cAlias:= "Trb"

		If File( _cArquivo+".xml" )
			Ferase( _cArquivo+".xml")
		EndIf 

		MsAguarde( { || u_DB2XML(_cArquivo, _cPNome, _cAlias,,,,"2007","DTOC(Trb->CT2_DATA)")},"Aguarde .. Gerando arquivo...")

		ApMsgInfo("Arquivo :"+_cArquivo+".xml gerado. Verifique o disco local de sua máquina"+chr(13)+"Aperte OK para continuar gerando o relatório...","Informação","INFO")

	EndIF             

	Trb->( DbCloseArea() )

Return(Nil)