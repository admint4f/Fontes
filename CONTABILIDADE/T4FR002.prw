#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'   
#INCLUDE 'TBICONN.CH' 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณT4FR001   บAutor  ณTOTALIT             บ Data ณ  05/02/19   บฑฑ
ฑฑฬออออออออออุออออJอออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina desenvolvida para gerar um arquivo EXCEL XML       -บฑฑ
ฑฑบ          ณ Balancete Consolidado Complexos e Grupo                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS12                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

//User Function T4FR003()       	//U_T4FR003()   
User Function T4FR002()       	//U_T4FR003()   
	
Local oReport := nil	

oReport := RptDef()
If oReport = Nil
	Return
Endif
oReport:PrintDialog()

Return

Static Function RptDef()
Local aPara		    := {}  
Local aRet 		    := {}
Local cOpcao		:= "" 
Local aFil			:= {}
	
Local oReport 		:= Nil
Local oSection1		:= Nil     
Local oSection2		:= Nil  

 
//Ajustar os parโmetros

aAdd( aPara ,{2,"Op็ใo de gera็ใo?","1 - Por Empresas",{"1 - Por Empresas", "2 - Por Filiais"},60,"",.T.})

If ParamBox(aPara ,"Empresa ou Filial",aRet) 

 
	if substr(aRet[1],1,1) == "1" //Por empresa
		cOpcao := "E"    
		cPerg := "T4FR001E"
	Else	
		
		cOpcao := "F"  
		cPerg := "T4FR001F"
    Endif

	
	AjustSx1(cPerg,cOpcao)
	
	if cOpcao == "F"	
   		aFil := AdmGetFil() 
   		If len(aFil) <= 0   
   			Return
   		Endif
 	Endif
 	
	If !Pergunte(cPerg,.T.)    
		Return
	Endif
	
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ UIฟ
	//ณMontagem do relatorio TReportณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ UIู
	
	oReport := TReport():New("T4FR001","Razใo Comparativo",cPerg,{|oReport| ReportPrint(oReport,cOpcao,aFil)},"Balancete Comparativo")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)

		
	//Se็ใo Contas
	oSection1:= TRSection():New(oReport, "CCONTA",, NIL, .F., .T.)  
	
	If cOpcao == "E"
		cEmpfil := "EMPRESA"
    Else
		cEmpfil := "FILIAL"	
    Endif                                        
    
	TRCell():New(oSection1,"CONTA"	,,"CONTA"             	,PesqPict("CT1","CT1_CONTA"	),TamSx3("CT1_CONTA") [1])  
	TRCell():New(oSection1,"DESCR"	,,"DESCRICAO"         	,PesqPict("CT1","CT1_DESC01"),TamSx3("CT1_DESC01")[1]) 
	
	oSection2 := TRSection():New(oSection1,"DETALHES",,/*{Array com as ordens do relat๓rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
	oSection2:SetTotalInLine(.F.)
	oSection2:SetHeaderBreak(.T.)  
	
	TRCell():New(oSection2,"EMPFIL"	,,cEmpfil		        ,							,6)	
	TRCell():New(oSection2,"DTMOV"	,,"DATA"		        ,							,15)	
	TRCell():New(oSection2,"LSDL"	,,"LOTE/SUB/DOC/LINHA"	,                           ,20)
	TRCell():New(oSection2,"HIST"	,,"HISTORICO"         	,PesqPict("CT2","CT2_HIST")	,TamSx3("CT2_HIST")[1])
	TRCell():New(oSection2,"DEBITO"	,,"DEBITO"            	,PesqPict("CT2","CT2_VALOR"),TamSx3("CT2_VALOR")[1]+TamSx3("CT2_VALOR")[2])
	TRCell():New(oSection2,"CREDITO",,"CREDITO"           	,PesqPict("CT2","CT2_VALOR"),TamSx3("CT2_VALOR")[1]+TamSx3("CT2_VALOR")[2])
	TRCell():New(oSection2,"SLDMOV"	,,"SALDO MOVIMENTAวรO" 	,PesqPict("CT2","CT2_VALOR"),TamSx3("CT2_VALOR")[1]+TamSx3("CT2_VALOR")[2])    
	TRCell():New(oSection2,"SLDATU"	,,"SALDO ATUAL" 		,PesqPict("CT2","CT2_VALOR"),TamSx3("CT2_VALOR")[1]+TamSx3("CT2_VALOR")[2])    
	
	
	TRFunction():New(oSection2:Cell("DEBITO")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
	TRFunction():New(oSection2:Cell("CREDITO")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/) 
	TRFunction():New(oSection2:Cell("SLDMOV")	,/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/) 
	
	oReport:Section(1):SetHeaderPage()
	oReport:Section(1):Setedit(.T.)
	oReport:Section(1):Section(1):Setedit(.T.)
		
	oReport:nfontbody := 8	
	oReport:SetTotalInLine(.F.)
       

Endif	
	

Return(oReport)
	           
	
Static function ReportPrint(oReport,cOpcao,aFil)     

Local aFields 	:= {}
Local oTempTable
Local cAlias 	:= "TMPRAZAO"
Local cQuery    := ""
Local nSldCta	:= 0  
Local nCredito	:= 0
Local nDebito	:= 0
Local cSldCta	:= ""  
Local cCredito	:= ""
Local cDebito	:= ""
Local nSaldo	:= 0
Local cSaldo	:= ""  

Local aHolding		:= {}
Local cCodHolds		:= ""       
Local aContas		:= {}
Local cDtmov   	:= ""


Local oSection1 := oReport:Section(1)
Local oSection2 := oReport:Section(1):Section(1) 	

Local cStmt     := ""   


If cOpcao == "E" 
	cCodHolds			:= AllTrim(MV_PAR05)
	aHolding := GetEmpresa(cCodHolds,cOpcao)
 Else
   	If !Empty(aFil)
   		For _y := 1 to len(aFil)
   			aAdd(aHolding,{aFil[_y],cEmpant})
   		Next
   	Endif
 Endif
         
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	//ณArray com as contas inseridas no perguntas - aRet[3] e aRet[4]//
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                                                                       
	cQryCT1 := "SELECT CT1_CONTA, CT1_DESC01 
	cQryCT1 += " FROM " + RetSqlName("CT1") + CRLF  
	cQryCT1 += " WHERE D_E_L_E_T_<> '*'" + CRLF  
	cQryCT1 += " AND CT1_CONTA BETWEEN '" +ALLTRIM(MV_PAR03)+ "' AND '" +ALLTRIM(MV_PAR04)+ "'" + CRLF   
		
	IF SELECT("TMPCT1") <> 0
		dBSelectarea("TMPCT1")
		TMPCT1->(dBClosearea())
	ENDIF
		
	TCQUERY(cQryCT1) NEW ALIAS "TMPCT1"
		
	dBSelectarea("TMPCT1")
	dBGotop()

	While TMPCT1->(!Eof())
		aAdd(aContas,{TMPCT1->CT1_CONTA,TMPCT1->CT1_DESC01})
		TMPCT1->(dBSkip())
	Enddo
    //----------------------------------------------------------------------
	//ณ Fim Array com as contas inseridas no perguntas - aRet[3] e aRet[4]//
    //----------------------------------------------------------------------


	//-------------------
	//Cria็ใo do objeto
	//-------------------    
	oTempTable := FWTemporaryTable():New( cAlias )
	
	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	
    //Campos do Razใo	
	aadd(aFields,{"CONTA"   ,"C",TamSx3("CT1_CONTA")[1]  ,0})
	aadd(aFields,{"DESCR"   ,"C",TamSx3("CT1_DESC01")[1] ,0}) 
	aadd(aFields,{"TIPO"    ,"C",01                      ,0})
	aadd(aFields,{"DTMOV"   ,"D",8                       ,0})
	aadd(aFields,{"EMPFIL"  ,"C",06                      ,0})
	aadd(aFields,{"LSDL"	,"C",50                      ,0})
	aadd(aFields,{"HIST"	,"C",TamSx3("CT2_HIST")[1]   ,0})
	aadd(aFields,{"DEBITO"	,"N",TamSx3("CT2_VALOR")[1]  ,TamSx3("CT2_VALOR")[2]})
	aadd(aFields,{"CREDITO" ,"N",TamSx3("CT2_VALOR")[1]  ,TamSx3("CT2_VALOR")[2]})
	aadd(aFields,{"SLDMOV"	,"N",TamSx3("CT2_VALOR")[1]	 ,TamSx3("CT2_VALOR")[2]})
	aadd(aFields,{"SLDATU"	,"N",TamSx3("CT2_VALOR")[1]	 ,TamSx3("CT2_VALOR")[2]})


    	
	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("indice1", {"CONTA"} )

	//------------------
	//Cria็ใo da tabela
	//------------------
	oTempTable:Create() 

	//LER O FOR 
	For nI := 1 to len(aContas)  
		//Montar saldo anterior e jogar na tabela temporaria  (Tipo 1)
		//Para todas as empresas ou filiais
		nSldCta := 0
		For nX := 1 to len(aHolding)
			If cOpcao == "E"
				cQryCQ1 := "SELECT (SUM(CQ1_CREDIT)) - (SUM(CQ1_DEBITO)) AS TOTAL " + CRLF
				cQryCQ1 += " FROM CQ1" + aHolding[nX,1] + "0" + CRLF    
				cQryCQ1 += " WHERE D_E_L_E_T_ <> '*' " + CRLF  
				cQryCQ1 += " AND CQ1_TPSALD = '1' " + CRLF 
				cQryCQ1 += " AND CQ1_CONTA = '" + aContas[nI,1] + "' " + CRLF
				cQryCQ1 += " AND CQ1_DATA < '" + DTOS(MV_PAR01) + "' " + CRLF
			Else
				
				cQryCQ1 := " SELECT SUM(CASE WHEN CT2_CREDIT = '" + aContas[nI,1] + "' THEN CT2_VALOR ELSE CT2_VALOR*-1 END) AS TOTAL" + CRLF
				cQryCQ1 += " FROM " + RetSqlName("CT2") + CRLF
				cQryCQ1 += " WHERE D_E_L_E_T_ = ''" + CRLF
				cQryCQ1 += " AND (CT2_DEBITO = '" + aContas[nI,1] + "' OR CT2_CREDIT = '" + aContas[nI,1] + "')" + CRLF
				cQryCQ1 += " AND CT2_DATA<'" + DTOS(MV_PAR01) + "'" + CRLF
				cQryCQ1 += " AND CT2_FILORI = '" + aHolding[nX,1] + "'" + CRLF
	
			Endif	       
			
			IF SELECT("TMPCQ1") <> 0
				dBSelectarea("TMPCQ1")
				TMPCQ1->(dBClosearea())
			ENDIF
			
			TCQUERY(cQryCQ1) NEW ALIAS "TMPCQ1"
				          
			If TMPCQ1->(!EOF())
				nSldCta += TMPCQ1->TOTAL	
			Endif
			                                       
		Next nX

		cValor := Strtran(cValtochar(nSldCta), ",",".")
	       	 
		cStmt := "INSERT INTO " + oTempTable:GetRealName() + "(CONTA,DESCR,TIPO,HIST,DEBITO,CREDITO,SLDMOV) VALUES ('"+aContas[nI,1]+"','"+aContas[nI,2]+"','1','SALDO ANTERIOR',0,0,"+cValor+")"
		TCSqlExec(cStmt)
					
	//Montar movimenta็ใo e jogar na tabela temporแria (Tipo 2) - Fazer somat๓ria para totalizador das movimenta็ใoes de d้bito e cr้dito   

	
		For nY := 1 to len(aHolding)
			If cOpcao == "E"
				cQryCt2 := "SELECT *" + CRLF 
				cQryCt2 += " FROM CT2"+ aHolding[nY,1] + "0" + CRLF   
				cQryCt2 += " WHERE D_E_L_E_T_<>'*'  
				cQryCt2 += " AND CT2_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'" + CRLF 
				cQryCt2 += " AND CT2_FILIAL = '" + xFilial("CT2") + "'" + CRLF   
				cQryCt2 += " AND CT2_MOEDLC = '01'" + CRLF 
				cQryCt2 += " AND (CT2_DEBITO = '" + ALLTRIM(aContas[nI,1]) + "' OR CT2_CREDIT = '" + ALLTRIM(aContas[nI,1]) + "')" + CRLF   
				cQryCt2 += " AND CT2_TPSALD = '1'" + CRLF 
				cQryCt2 += " ORDER BY CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA" + CRLF 
			Else
			
				cQryCt2 := "SELECT *" + CRLF 
				cQryCt2 += " FROM " + RetSqlName("CT2") + CRLF   
				cQryCt2 += " WHERE D_E_L_E_T_<>'*'  
				cQryCt2 += " AND CT2_DATA BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'" + CRLF 
				cQryCt2 += " AND CT2_FILIAL = '" + xFilial("CT2") + "'" + CRLF   
				cQryCt2 += " AND CT2_MOEDLC = '01'" + CRLF 
				cQryCt2 += " AND (CT2_DEBITO = '" + ALLTRIM(aContas[nI,1]) + "' OR CT2_CREDIT = '" + ALLTRIM(aContas[nI,1]) + "')" + CRLF   
				cQryCt2 += " AND CT2_TPSALD = '1'" + CRLF 
				cQryCt2 += " AND CT2_FILORI = '" + aHolding[nY,1] + "'" + CRLF 
				cQryCt2 += " ORDER BY CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA" + CRLF 
	
			Endif
		
	
			IF SELECT("TMPCT2") <> 0
				dBSelectarea("TMPCT2")
				TMPCT2->(dBClosearea())
			ENDIF
					
			TCQUERY(cQryCt2) NEW ALIAS "TMPCT2"
		

            If TMPCT2->(EOF())
				cStmt := "INSERT INTO " + oTempTable:GetRealName() + "(CONTA,DESCR,TIPO,HIST,DEBITO,CREDITO,SLDMOV) VALUES ('"+aContas[nI,1]+"','"+aContas[nI,2]+"','2','CONTA SEM MOVIMENTO NO PERIODO',0,0,0)" 
				TCSqlExec(cStmt)
			Else 
			
				while TMPCT2->(!EOF())
					nCredito := 0 
					nDebito	:= 0
					nSaldo :=0 
						
					cLsdc := Alltrim(TMPCT2->CT2_LOTE+TMPCT2->CT2_SBLOTE+TMPCT2->CT2_DOC+TMPCT2->CT2_LINHA)
					
					
					If Alltrim(TMPCT2->CT2_CREDIT) == alltrim(aContas[nI,1])   						
						nCredito := TMPCT2->CT2_VALOR 
					Else  
					    nDebito := TMPCT2->CT2_VALOR 
					Endif  
					nSaldo :=  nCredito -  nDebito 
					nSldCta += nSaldo
					
					cSldCta := Strtran(cValtochar(nSldCta), ",",".")
					cCredito := Strtran(cValtochar(nCredito), ",",".")
					cDebito := Strtran(cValtochar(nDebito), ",",".")
					cSaldo := Strtran(cValtochar(nSaldo), ",",".")     
					cDtmov := SUBSTRING(TMPCT2->CT2_DATA,1,4)+SUBSTRING(TMPCT2->CT2_DATA,5,2)+SUBSTRING(TMPCT2->CT2_DATA,7,2) 
					
	
			 		cStmt := "INSERT INTO " + oTempTable:GetRealName() + "(CONTA,DESCR,TIPO,EMPFIL,DTMOV,LSDL,HIST,DEBITO,CREDITO,SLDMOV,SLDATU) VALUES ('"+aContas[nI,1]+"','"+aContas[nI,2]+"','2','"+aHolding[nY,1]+"','"+cDtmov+"','"+cLsdc+"','"+TMPCT2->CT2_HIST+"',"+cDebito+","+cCredito+","+cSaldo+","+cSldCta+")"
					TCSqlExec(cStmt)   
					
					TMPCT2->(Dbskip())
				Enddo

        	Endif
		Next nY
	Next nI	
	
		
	//------------------------------------
	//Executa query para leitura da tabela
	//------------------------------------
	cQuery := "SELECT *" 
	cQuery += " FROM "+ oTempTable:GetRealName() 
	cQuery += " ORDER BY CONTA,TIPO,EMPFIL,DTMOV,LSDL"

	MPSysOpenQuery( cQuery, 'QRYTMP' )
	oReport:SetMeter(QRYTMP->(LastRec()))  
	
	
	
	//Irei percorrer todos os meus registros
	While QRYTMP->(!Eof())
		
		If oReport:Cancel()
			Exit
		EndIf
	
		//inicializo a primeira se็ใo
		oSection1:Init()
					
		cConta 	:= QRYTMP->CONTA
		IncProc("Imprimindo Conta "+alltrim(QRYTMP->CONTA))
		
		//imprimo a primeira se็ใo				
		oSection1:Cell("CONTA"):SetValue(QRYTMP->CONTA)
		oSection1:Cell("DESCR"):SetValue(QRYTMP->DESCR)
		
		oSection1:Printline()
		
		//inicializo a segunda se็ใo
		oSection2:init()
		
		While QRYTMP->CONTA == cConta .and. QRYTMP->(!Eof())
			oReport:IncMeter()		
		
			IncProc("Imprimindo movimenta็ใo... ")  
			
			//oSection2:Cell("PEDIDO"):SetValue(TRBVEND->C5_NUM)
			
				oSection2:Cell("EMPFIL"):SetValue(QRYTMP->EMPFIL)		
				oSection2:Cell("DTMOV"):SetValue(STOD(QRYTMP->DTMOV))		
				oSection2:Cell("LSDL"):SetValue(QRYTMP->LSDL)
				oSection2:Cell("HIST"):SetValue(QRYTMP->HIST)
				oSection2:Cell("DEBITO"):SetValue(QRYTMP->DEBITO)
				oSection2:Cell("CREDITO"):SetValue(QRYTMP->CREDITO)
				oSection2:Cell("SLDMOV"):SetValue(QRYTMP->SLDMOV)
				oSection2:Cell("SLDATU"):SetValue(QRYTMP->SLDATU)
			
			oSection2:Printline()
	
 			QRYTMP->(dbSkip())
 		EndDo  
 				
     	oSection2:Finish()    
        oReport:SkipLine(2)
        oReport:ThinLine()
        

 		
 		//finalizo a primeira se็ใo
		oSection1:Finish()  
		
		oReport:SkipLine(2)
	Enddo	
		  

	//---------------------------------
	//Exclui a tabela 
	//---------------------------------
	oTempTable:Delete() 
	    
	
Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณFuncao para criar array com empresasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู

Static Function GetEmpresa(cCodHolds,cOpcao)
	Local aHolding		:= {}
	Local aCodHold		:= StrTokArr(cCodHolds,';')
	Local cCodHold		:= ''
	Local cDescHold		:= ''
	Local n2			:= 0

	SM0->(DbSetOrder(1))
	If cOpcao == "E"
		For n2	:= 1 To Len(aCodHold)
			If SM0->(DbSeek(aCodHold[n2]))
				cCodHold	:= SM0->M0_CODIGO
				cDescHold	:= SM0->M0_NOME
				aAdd(aHolding,{cCodHold,cDescHold})
			EndIf
		Next n2
	Else
		For n2	:= 1 To Len(aCodHold)
			If SM0->(DbSeek(cEmpant))
				
				While SM0->(!EOF()) .AND. SM0->(M0_CODIGO) == cEmpant
					If SM0->(M0_CODFIL) == aCodHold[n2] 
						cCodHold	:= SM0->M0_CODFIL
						cDescHold	:= SM0->M0_FILIAL
			   			aAdd(aHolding,{cCodHold,cDescHold})
						SM0->(DbSkip())
				    Endif
				EndDo

			EndIf
		Next n2
	

	EndIf
Return(aHolding)     


Static Function AjustSx1(cPerg,cOpcao)
Local aRegs   :={}    
Local x	:= 0
Local y := 0  

//   1    2       3        4      5         6     7     8       9      10     11   12    13    14    15       16      17    18    19      20      21       22
// Grupo/Ordem/Pergunta/PergEsp/PergIng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Defesp01/Defeng01/Cnt01/Var02/Def02/Defesp02/Defeng02/Cnt02/
//  23     24      25      26      27    28    29     30       31      32   33    34      35       36      37  38  39    40    41
// Var03/Def03/Defesp03/Defeng03/Cnt03/Var04/Def04/Defesp04/Defeng04/Cnt04/Var05/Def05/Defesp05/Defeng05/Cnt05/F3/Pyme/GRPSXG/Help
//            1    2          3               4  5    6       7  8  9 0  1  2      13     4  5  6  7  8  9  0  1  2  3  4  5  6  7  8  9

	aAdd(aRegs,{cPerg,"01","Data de"	,"","","mv_ch1","D",08,0,0,"G","","mv_par01",""   				,"","","",""   				,"","","","","","","","","","","","","","","","","","","",""   	,"","",""})
	aAdd(aRegs,{cPerg,"02","Data Ate"	,"","","mv_ch2","D",08,0,0,"G","","mv_par02",""   				,"","","",""   				,"","","","","","","","","","","","","","","","","","","",""   	,"","",""})  
	aAdd(aRegs,{cPerg,"03","Conta de"	,"","","mv_ch3","C",20,0,0,"G","","mv_par03",""   				,"","","",""   				,"","","","","","","","","","","","","","","","","","","","CT1"	,"","",""})
	aAdd(aRegs,{cPerg,"04","Conta Ate"	,"","","mv_ch4","C",20,0,0,"G","","mv_par04",""   				,"","","",""   				,"","","","","","","","","","","","","","","","","","","","CT1"	,"","",""})
    
    If cOpcao == "E" 
		aAdd(aRegs,{cPerg,"05","Empresa"	,"","","mv_ch5","C",20,0,0,"G","","mv_par05",""   				,"","","",""   				,"","","","","","","","","","","","","","","","","","","",""	,"","",""})
	Endif
	
	
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For x := 1 to Len(aRegs)
		if !SX1->( dbSeek(PADR(cPerg,10)+PADL( x,2,"0")) )
			RecLock("SX1",.T.)
			For y:=1 to FCount()
				If y <= Len(aRegs[x])
					FieldPut(y,aRegs[x,y])
				Endif
			Next
			MsUnlock()
		Endif
	Next


	

Return  