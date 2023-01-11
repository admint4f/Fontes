#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'   
#INCLUDE 'TBICONN.CH' 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FR001   ºAutor  ³TOTALIT             º Data ³  05/02/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍJÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina desenvolvida para gerar um arquivo EXCEL XML       -º±±
±±º          ³ Balancete Consolidado Complexos e Grupo                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS12                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function T4FR001()       	//U_T4FR001()   
	
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

Local cCampo 		:= "" 
Local cFilqry		:= "" 

Local aHolding		:= {}
Local cCodHolds		:= ""     
Local cFilqry		:= "" 

Local dDatade
Local dDataate  
Local cContade  	:= ""
Local cContaate 	:= ""

Local aContas		:= {}
Local cTitulo		:= "" 


aAdd( aPara ,{2,"Opção de geração?","1 - Por Empresas",{"1 - Por Empresas", "2 - Por Filiais"},60,"",.T.})

If ParamBox(aPara ,"Empresa ou Filial",aRet) 

 
	if substr(aRet[1],1,1) == "1" //Por empresa
		cOpcao := "E" 
		cCampo := "EMP"   
		cPerg  := "T4FR1E"
	Else	
		cCampo := "FIL"
		cOpcao := "F"  
		cPerg  := "T4FR1F"
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
	
	If MV_PAR08 == 1 .and. Empty(MV_PAR09)
		Alert("A Data Lucro/Perdas deve ser informada!")   
		Return
	Endif

	If cOpcao == "E" 
		cCodHolds			:= AllTrim(mv_par05)
		aHolding := GetEmpresa(cCodHolds,cOpcao)
    Else
    	If !Empty(aFil)
    		For _y := 1 to len(aFil)
    			aAdd(aHolding,{cEmpant,aFil[_y]})
    			If Empty(cFilqry)
    				cFilqry := aFil[_y]
    			Else
    				cFilqry += "/" + aFil[_y]
    			Endif	
    		Next
    	Endif
    Endif   

    dDatade   := mv_par01
    dDataate  := mv_par02 
    
    cContade  := mv_par03
    cContaate := mv_par04

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Array com as contas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



    dBSelectarea("CT1")
	dBSetOrder(1)
	dbgotop()
	aContas:={}

	While CT1->(!Eof())
//		IF CT1->CT1_CONTA >= Aret[3] .and. CT1->CT1_CONTA <= Aret[4]
		IF CT1->CT1_CONTA >= mv_par03 .and. CT1->CT1_CONTA <= mv_par04
			If MV_PAR06 == 1
				IF CT1->CT1_CLASSE = "1" // essa linha soh considera contas sinteticas. 
					AADD(aContas,{cFilAnt,CT1->CT1_CONTA,CT1->CT1_DESC01}) 
				Endif
			ElseIf MV_PAR06 == 2
				IF CT1->CT1_CLASSE = "2" // essa linha soh considera contas analiticas.
					AADD(aContas,{cFilAnt,CT1->CT1_CONTA,CT1->CT1_DESC01}) 
				Endif
            Else
            	AADD(aContas,{cFilAnt,CT1->CT1_CONTA,CT1->CT1_DESC01}) 
			ENDIF
		ENDIF
		CT1->(dBSkip())
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ UI¿
	//³Montagem do relatorio TReport³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ UIÙ
	    If MV_PAR10 == 1 
			cTitulo := "Balancete Comparativo Acumulado"
		Else
			cTitulo := "Balancete Comparativo Mensal"
		Endif 
		oReport := TReport():New("T4FR001",cTitulo,,{|oReport| ReportPrint(oReport,cCampo,aHolding,cOpcao,dDatade,dDataate,aContas,cFilqry,cContade,cContaate)},"Balancete Comparativo")
		oReport:SetPortrait()    
		oReport:SetTotalInLine(.F.)
	
		
		//Seção Contas
		oSection1:= TRSection():New(oReport, "BALANCETE",, NIL, .F., .T.)  
		TRCell():New(oSection1,"CONTA"	,,"CONTA"        ,PesqPict("CT1","CT1_CONTA"	),TamSx3("CT1_CONTA") [1])
		TRCell():New(oSection1,"DESC"	,,"DESCRICAO"    ,PesqPict("CT1","CT1_DESC01"	),TamSx3("CT1_DESC01")[1])
	    
	        
	    If cCampo == "EMP"
			For _x := 1 to len(aHolding) 
		
				TRCell():New(oSection1,cCampo+aHolding[_x,1]	,,cCampo+aHolding[_x,1] ,PesqPict("CT7","CT7_CREDIT"),TamSx3("CT7_CREDIT")[1]+TamSx3("CT7_CREDIT")[2])
				oSection1:Cell(cCampo+aHolding[_x,1]):SetHeaderAlign("RIGHT") 	// Alinhamento a direita das colunas de valor
		
			Next 
		Else
			For _x := 1 to len(aHolding) 
		
				TRCell():New(oSection1,cCampo+aHolding[_x,2]	,,cCampo+aHolding[_x,2] ,PesqPict("CT7","CT7_CREDIT"),TamSx3("CT7_CREDIT")[1]+TamSx3("CT7_CREDIT")[2])
				oSection1:Cell(cCampo+aHolding[_x,2]):SetHeaderAlign("RIGHT") 	// Alinhamento a direita das colunas de valor
		
			Next 
		Endif

		TRCell():New(oSection1,"TOTAL"	,,"TOTAL"    ,PesqPict("CT7","CT7_CREDIT"),TamSx3("CT7_CREDIT")[1]+TamSx3("CT7_CREDIT")[2])
		
	//	TRFunction():New(oSection1:Cell("PRODUTO"),"Produtos com Diferença:" ,"COUNT",,,"@E 999999",,.F.,.T.)	
		
		oReport:nfontbody := 8	
		oReport:SetTotalInLine(.F.)
	       
	    oSection1:SetTotalText(" ")	 
	
Endif	
	

Return(oReport)
	           
	
Static function ReportPrint(oReport,cCampo,aHolding,cOpcao,dDatade,dDataate,aContas,cFilqry,cContade,cContaate)     

Local aFields 	:= {}
Local oTempTable
Local cAlias 	:= "TMPBALAN"
Local cQuery    := ""
Local nTotal	:= 0   
Local nSldCta	:= 0

Local oSection1 := oReport:Section(1) 	
                                                 	
	//-------------------
	//Criação do objeto
	//-------------------    
	oTempTable := FWTemporaryTable():New( cAlias )
	
	//--------------------------
	//Monta os campos da tabela
	//--------------------------
	
	
	aadd(aFields,{"CONTA","C",20,0})
	aadd(aFields,{"DESCR","C",40,0})

    If cCampo == "EMP"
		For x := 1 to len(aHolding)
			aadd(aFields,{cCampo+aHolding[x,1],"N",14,2})	
		Next
	Else	
		For x := 1 to len(aHolding)
			aadd(aFields,{cCampo+aHolding[x,2],"N",14,2})	
		Next
	Endif
		
	oTemptable:SetFields( aFields )
	oTempTable:AddIndex("indice1", {"CONTA"} )

	//------------------
	//Criação da tabela
	//------------------
	oTempTable:Create() 

	//LER O FOR 
	For nI := 1 to len(aContas)
		For x := 1 to len(aHolding)  
		    
			If cCampo == "EMP"
				nSldCta := MONTASLD(aContas[nI,2],aHolding[x,1],cOpcao,dDatade,dDataate,cFilqry,cContade,cContaate)
		    Else
				nSldCta := MONTASLD(aContas[nI,2],aHolding[x,2],cOpcao,dDatade,dDataate,cFilqry,cContade,cContaate)		    
		    Endif                                            
		    
			cValor := Strtran(cValtochar(nSldCta), ",",".")
			If cCampo == "EMP"
				cStmt := "INSERT INTO " + oTempTable:GetRealName() + "(CONTA,DESCR,"+cCampo+aHolding[x,1]+") VALUES ('"+aContas[nI,2]+"','"+aContas[nI,3]+"',"+cValor+")"
			Else
				cStmt := "INSERT INTO " + oTempTable:GetRealName() + "(CONTA,DESCR,"+cCampo+aHolding[x,2]+") VALUES ('"+aContas[nI,2]+"','"+aContas[nI,3]+"',"+cValor+")"			
			Endif
			TCSqlExec(cStmt)
		
		Next
	Next
	//------------------------------------
	//Executa query para leitura da tabela
	//------------------------------------
	cQuery := "SELECT CONTA, DESCR," 
	For _y := 1 to len(aHolding)
        If cCampo == "EMP"
			cQuery += " SUM("+cCampo+aHolding[_y,1]+") AS " + cCampo+aHolding[_y,1]
	    Else
			cQuery += " SUM("+cCampo+aHolding[_y,2]+") AS " + cCampo+aHolding[_y,2]	    
	    Endif                                     
	    
		If _y <> len(aHolding) 
			cQuery += ","
		Endif
	Next
	cQuery += " FROM "+ oTempTable:GetRealName() 
	cQuery += " GROUP BY CONTA, DESCR"
	cQuery += " ORDER BY CONTA, DESCR"
	MPSysOpenQuery( cQuery, 'QRYTMP' )
	oReport:SetMeter(QRYTMP->(LastRec()))	  
	
	//inicializo a seção
	oSection1:init()
	oSection1:SetHeaderSection(.T.)

	//Irei percorrer todos os meus registros
	While QRYTMP->(!Eof())	
	
		If oReport:Cancel()
			Exit
		EndIf
			
		oReport:IncMeter()	 
	
		IncProc("Imprimindo balancete ") 
		nTotal := 0

		For _y := 1 to len(aHolding)
		    If cCampo == "EMP"
				cCmpTab := "QRYTMP->"+cCampo+aHolding[_y,1]
				nTotal += &(cCmpTab)
			Else
				cCmpTab := "QRYTMP->"+cCampo+aHolding[_y,2]
				nTotal += &(cCmpTab)
			Endif	
		Next   
		
		If MV_PAR07 == 1 //imprimi saldo zerados
			 
		//	nTotal:= 0
			oSection1:Cell("CONTA"):SetValue(QRYTMP->CONTA)
			oSection1:Cell("DESC"):SetValue(QRYTMP->DESCR)
			For _y := 1 to len(aHolding)
			    If cCampo == "EMP"
					cCmpTab := "QRYTMP->"+cCampo+aHolding[_y,1]
					oSection1:Cell(cCampo+aHolding[_y,1]):SetValue(&(cCmpTab)) 
		  //		nTotal += &(cCmpTab)
				Else
					cCmpTab := "QRYTMP->"+cCampo+aHolding[_y,2]
					oSection1:Cell(cCampo+aHolding[_y,2]):SetValue(&(cCmpTab)) 
		//			nTotal += &(cCmpTab)
				Endif	
			Next                                                  
			oSection1:Cell("TOTAL"):SetValue(nTotal)
			
			oSection1:PrintLine()
			
			QRYTMP->(dbSkip())
		Else
            
			If nTotal <> 0
			//	nTotal:= 0
				oSection1:Cell("CONTA"):SetValue(QRYTMP->CONTA)
				oSection1:Cell("DESC"):SetValue(QRYTMP->DESCR)
				For _y := 1 to len(aHolding)
				    If cCampo == "EMP"
						cCmpTab := "QRYTMP->"+cCampo+aHolding[_y,1]
						oSection1:Cell(cCampo+aHolding[_y,1]):SetValue(&(cCmpTab))
				 //		nTotal += &(cCmpTab)
					Else
						cCmpTab := "QRYTMP->"+cCampo+aHolding[_y,2]
						oSection1:Cell(cCampo+aHolding[_y,2]):SetValue(&(cCmpTab))
				 //		nTotal += &(cCmpTab)
					Endif	
				Next                                                  
				oSection1:Cell("TOTAL"):SetValue(nTotal)
				
				oSection1:PrintLine()
				
				
			Endif
			QRYTMP->(dbSkip())
		Endif 	 		
	Enddo       
	
	//finalizo a seção
	oSection1:Finish()  
	
	//oReport:SkipLine(2)


	//---------------------------------
	//Exclui a tabela 
	//---------------------------------
	oTempTable:Delete() 
	    
	
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Funcao para buscar saldo.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function MONTASLD(cConta,cEmpFil,cOpcao,dDatade,dDataate,cFilqry,cContade,cContaate)
Local nSaldo	:= 0   
Local cQuery	:= ""

IF cOpcao == "E" //Empresa  
/*

	cQuery := " SELECT (SUM(CQ1_CREDIT)) - (SUM(CQ1_DEBITO)) AS SALDO" + CRLF
	cQuery += " FROM CQ1080" + CRLF   
	cQuery += " WHERE D_E_L_E_T_ <> '*'" + CRLF
	cQuery += " AND CQ1_TPSALD = '1'" + CRLF
	cQuery += " AND CQ1_CONTA = '" + ALLTRIM(cConta) + "'" + CRLF
	cQuery += " AND CQ1_DATA <= '20190110'" + CRLF  

*/

	cQuery := "SELECT SUM(CQ1_CREDIT)-SUM(CQ1_DEBITO) AS SALDO"
	cQuery += " FROM CQ1"+ cEmpFil + "0"
	cQuery += " WHERE D_E_L_E_T_ <> '*'"
	cQuery += " AND CQ1_CONTA LIKE '" + ALLTRIM(cConta) + "%'"
	cQuery += " AND CQ1_CONTA BETWEEN '" + ALLTRIM(cContade) + "' AND '" + ALLTRIM(cContaate) + "'" 
	cQuery += " AND CQ1_TPSALD = '1' 
	If MV_PAR10 == 1
		cQuery += " AND CQ1_DATA<='" + dtos(dDataate) + "'" 
	Else                                                    
		cQuery += " AND CQ1_DATA BETWEEN '" + dtos(dDatade) + "' AND '" + dtos(dDataate) + "'" 
	Endif

Else //Filial

	cQuery := "SELECT SUM(CASE WHEN CT2_CREDIT LIKE '" + ALLTRIM(cConta) + "%' THEN CT2_VALOR ELSE CT2_VALOR*-1 END) AS SALDO"
	cQuery += " FROM " + RetSqlName("CT2") + " CT2"
	cQuery += " WHERE D_E_L_E_T_ <> '*'"
	cQuery += " AND (CT2_DEBITO LIKE '" + ALLTRIM(cConta) + "%' OR CT2_CREDIT LIKE '" + ALLTRIM(cConta) + "%')"
	cQuery += " AND (CT2_DEBITO BETWEEN '" + ALLTRIM(cContade) + "' AND '" + ALLTRIM(cContaate) + "'"
	cQuery += " OR CT2_CREDIT BETWEEN '" + ALLTRIM(cContade) + "' AND '" + ALLTRIM(cContaate) + "')"  
	If MV_PAR10 == 1
		cQuery += " AND CT2_DATA<='" + dtos(dDataate) + "'" 
	Else 
		cQuery += " AND CT2_DATA BETWEEN '" + dtos(dDatade) + "' AND '" + dtos(dDataate) + "'" 
	Endif
	cQuery += " AND CT2_FILORI IN " + FormatIn(cFilqry,'/')

Endif 

If Select("TMPCTB")>0
	DbSelectArea("TMPCTB")
	TMPCTB->(DbCloseArea())
EndIf

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPCTB",.F.,.T.)

DbSelectArea("TMPCTB")
TMPCTB->(dbGoTop())

If TMPCTB->(!Eof())
	nSaldo := TMPCTB->SALDO     
	
	If MV_PAR08 == 1 //desconsidera apuração de resultado 
	
		IF cOpcao == "E" //Empresa  
	
			cQuery := "SELECT SUM(CASE WHEN CT2_CREDIT LIKE '" + ALLTRIM(cConta) + "%' THEN CT2_VALOR ELSE CT2_VALOR*-1 END) AS APURACAO" + CRLF
			cQuery += " FROM CT2"+ cEmpFil + "0" + CRLF
			cQuery += " WHERE D_E_L_E_T_ <> '*'" + CRLF
			cQuery += " AND (CT2_DEBITO LIKE '" + ALLTRIM(cConta) + "%' OR CT2_CREDIT LIKE '" + ALLTRIM(cConta) + "%')"
			cQuery += " AND (CT2_DEBITO BETWEEN '" + ALLTRIM(cContade) + "' AND '" + ALLTRIM(cContaate) + "'"
			cQuery += " OR CT2_CREDIT BETWEEN '" + ALLTRIM(cContade) + "' AND '" + ALLTRIM(cContaate) + "')"  
			cQuery += " AND CT2_DTLP = '" + dtos(MV_PAR09) + "'" + CRLF  
		Else   
			cQuery := "SELECT SUM(CASE WHEN CT2_CREDIT LIKE '" + ALLTRIM(cConta) + "%' THEN CT2_VALOR ELSE CT2_VALOR*-1 END) AS APURACAO" + CRLF
			cQuery += " FROM " + RetSqlName("CT2") + " CT2" + CRLF
			cQuery += " WHERE D_E_L_E_T_ <> '*'" + CRLF
			cQuery += " AND (CT2_DEBITO LIKE '" + ALLTRIM(cConta) + "%' OR CT2_CREDIT LIKE '" + ALLTRIM(cConta) + "%')"
   			cQuery += " AND (CT2_DEBITO BETWEEN '" + ALLTRIM(cContade) + "' AND '" + ALLTRIM(cContaate) + "'"
   			cQuery += " OR CT2_CREDIT BETWEEN '" + ALLTRIM(cContade) + "' AND '" + ALLTRIM(cContaate) + "')"  
			cQuery += " AND CT2_DTLP = '" + dtos(MV_PAR09) + "'" + CRLF  
		Endif  

		If Select("TMPAPUR")>0
			DbSelectArea("TMPAPUR")
			TMPAPUR->(DbCloseArea())
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMPAPUR",.F.,.T.)
		
		DbSelectArea("TMPAPUR")
		TMPAPUR->(dbGoTop())
		
		
        If TMPAPUR->(!Eof())
			nSaldo -= TMPAPUR->APURACAO
		Endif
		
	Endif
	
Endif  


Return(nSaldo)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Funcao para criar array com empresas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

Static Function GetEmpresa(cCodHolds,cOpcao)
	Local aHolding		:= {}
	Local aCodHold		:= StrTokArr(cCodHolds,';')
	Local cCodHold		:= ''
	Local cDescHold		:= ''
	Local nI			:= 0

	SM0->(DbSetOrder(1))
	If cOpcao == "E"
		For nI	:= 1 To Len(aCodHold)
			If SM0->(DbSeek(aCodHold[nI]))
				cCodHold	:= SM0->M0_CODIGO
				cDescHold	:= SM0->M0_NOME
				aAdd(aHolding,{cCodHold,cDescHold})
			EndIf
		Next nI
	Else
		For nI	:= 1 To Len(aCodHold)
			If SM0->(DbSeek(cEmpant))
				
				While SM0->(!EOF()) .AND. SM0->(M0_CODIGO) == cEmpant
					If SM0->(M0_CODFIL) == aCodHold[nI] 
						cCodHold	:= SM0->M0_CODFIL
						cDescHold	:= SM0->M0_FILIAL
			   			aAdd(aHolding,{cCodHold,cDescHold})
						SM0->(DbSkip())
				    Endif
				EndDo

			EndIf
		Next nI
	
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
    Else
 		aAdd(aRegs,{cPerg,"05","Empresa"	,"","","mv_ch5","C",20,0,0,"G","Vazio()","mv_par05",""   				,"","","",""   				,"","","","","","","","","","","","","","","","","","","",""	,"","",""})
	Endif

	aAdd(aRegs,{cPerg,"06","Imprimir Contas:"   ,"Imprimir Contas:"   ,"Imprimir Contas:"   ,"mv_ch6" ,"C",1,0,0,"C","","mv_par06","Sintetica","Sintetica","Sintetica","","","Analitica","Analitica","Analitica","","","Ambas","Ambas","Ambas","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Saldos Zerados?"    ,"Saldos Zerados?"    ,"Saldos Zerados?"    ,"mv_ch7" ,"C",1,0,0,"C","","mv_par07","Sim"      ,"Sim"      ,"Sim"      ,"","","Não"      ,"Não"      ,"Não"      ,"","",""     ,""     ,""     ,"","","","","",""})
	aAdd(aRegs,{cPerg,"08","Posição Ant. L/P?"  ,"Posição Ant. L/P?"  ,"Posição Ant. L/P?"  ,"mv_ch8" ,"C",1,0,0,"C","","mv_par08","Sim"      ,"Sim"      ,"Sim"      ,"","","Não"      ,"Não"      ,"Não"      ,"","",""     ,""     ,""     ,"","","","","",""})
	aAdd(aRegs,{cPerg,"09","Data Lucros/Perdas?","Data Lucros/Perdas?","Data Lucros/Perdas?","mv_ch9" ,"D",8,0,0,"G","","mv_par09",""         ,""         ,""         ,"","",""         ,""         ,""         ,"","",""     ,""     ,""     ,"","","","","",""})
	aAdd(aRegs,{cPerg,"10","Resultado?"         ,"Resultado?"         ,"Resultado?"         ,"mv_cha" ,"C",1,0,0,"C","","mv_par10","Acumulado","Acumulado","Acumulado","","","Mensal"   ,"Mensal"   ,"Mensal"   ,"","",""     ,""     ,""     ,"","","","","",""})	

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