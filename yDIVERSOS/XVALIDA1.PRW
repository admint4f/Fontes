#INCLUDE "PROTHEUS.CH"
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    |XVALIDA1    ? Autor ? Priscila Cesario    ? Data ?08.02.2012 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 矲uncao que valida o CNPJ/CPF do cliente    para n鉶 permitir 潮?
北?          砫uplicidade, permite apenas para o cliente    estrangeiro    潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   |XvalidA1() 		      	    		                           潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矲inanceiro                                                   潮?
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
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
		
		
		msgstop("CNPJ/CPF j? cadastrado!","XvalidA1",)
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
