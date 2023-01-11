#INCLUDE "PROTHEUS.CH"
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    |XVALIDA1    ³ Autor ³ Priscila Cesario    ³ Data ³08.02.2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Funcao que valida o CNPJ/CPF do cliente    para não permitir ³±±
±±³          ³duplicidade, permite apenas para o cliente    estrangeiro    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   |XvalidA1() 		      	    		                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Financeiro                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XvalidA1 (cCgc, eEst)

Local lLiber  := .T.
Local cQuery  := ""
Local cLoja   :=""

If Empty(Alltrim(cCgc))
	Return(lLiber)
Endif

If Alltrim(eEst) <>'EX'
	
	
	If Select("TSA1") > 0
		DbSelectArea("TSA1")
		DbCloseArea()
	Endif
	
	cQuery := " SELECT COUNT(*)  CONTADOR  "
	cQuery += "   FROM "+RetSQLName("SA1")
	cQuery += "  WHERE A1_CGC      = '"+cCgc+"' "
	cQuery += "    AND A1_MSBLQL <> '1'  "
	cQuery += "    AND D_E_L_E_T_  <> '*'   "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSA1",.T.,.T.)
	
	//Executa a consulta
	dbSelectArea("TSA1")
	
	
	IF TSA1->CONTADOR > 0
		
		
		msgstop("CNPJ/CPF já cadastrado!","XvalidA1",)
		lLiber := .F.
		DbSelectArea("TSA1")
		
	Else
		If Select("TSCLI") > 0
			DbSelectArea("TSCLI")
			DbCloseArea()
		Endif
		
		cQuery := " SELECT MAX(A1_LOJA) Loja, A1_COD  "
		cQuery += "   FROM "+RetSQLName("SA1")
		cQuery += "  WHERE SUBSTR(A1_CGC,1,8)  = '"+SUBS(cCgc,1,8)+"' "
		cQuery += "    AND A1_MSBLQL <> '1'  "
		cQuery += "    AND D_E_L_E_T_  <> '*'   "
		cQuery += "  GROUP BY A1_COD "
		cQuery += "  ORDER BY A1_COD DESC "
		
		
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSCLI",.T.,.T.)
		
		IF TSCLI->(!EOF())
			cLoja:= SOMA1(TSCLI->Loja)
			SA1->(DBSETORDER(1))
			WHILE SA1->(DBSEEK(xfilial()+TSCLI->A1_COD+cLoja))
				cLoja:=SOMA1(cLoja)
			END
			M->A1_COD:= TSCLI->A1_COD
			M->A1_LOJA:= cLoja
			
			
		EndIF
		DbSelectArea("TSCLI")
		DbCloseArea()
		
	EndIF
	If Select("TSA1") > 0
		DbSelectArea("TSA1")
		DbCloseArea()
	Endif
Endif

Return (lLiber)
