#INCLUDE "PROTHEUS.CH"
/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    |FA580LIB    � Autor � Priscila Cesario    � Data �02.02.2012 ���
��������������������������������������������������������������������������Ĵ��
���Descricao �Funcao que valida o CNPJ/CPF do fornecedor para n�o permitir ���
���          �duplicidade, permite apenas para o fornecedor estrangeiro    ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   |XvalidA2() 		      	    		                       ���
��������������������������������������������������������������������������Ĵ��
���Uso       �Financeiro                                                   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function XvalidA2(cCgc, eEst)

Local lLiber  := .T.
Local cQuery  := ""
Local cLoja	  := ""

If alltrim( eEst ) == 'EX' .or. Empty( alltrim(cCgc) )
	ILiber := .T.
Else

	If Select("TSA2") > 0
		DbSelectArea("TSA2")
		DbCloseArea()
	Endif
	
	cQuery := " SELECT COUNT(*)  CONTADOR  "
	cQuery += "   FROM "+RetSQLName("SA2")
	cQuery += "  WHERE A2_CGC      = '"+cCgc+"' "
	cQuery += "    AND D_E_L_E_T_  <> '*'   "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSA2",.T.,.T.)
	
	IF TSA2->CONTADOR > 0
	  
		msgstop("CNPJ/CPF j� cadastrado!","XvalidA2",)
		lLiber := .F.
	
	Else

		cQuery := " SELECT MAX(A2_LOJA) Loja, A2_COD  "
		cQuery += "   FROM "+RetSQLName("SA2")
		cQuery += "  WHERE SUBSTR(A2_CGC,1,8)  = '"+SUBS(cCgc,1,8)+"' "
		cQuery += "    AND A2_MSBLQL <> '1'  "
		cQuery += "    AND D_E_L_E_T_  <> '*'   "
		cQuery += "  GROUP BY A2_COD "
		cQuery += "  ORDER BY A2_COD DESC "
		
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TSFOR",.T.,.T.)
        
		IF TSFOR->(!EOF())

			cLoja:= SOMA1(TSFOR->Loja)
			SA2->( dbSetOrder(1) )

			while SA1->( dbSeek( xFilial()+TSFOR->A2_COD+cLoja ) )
				cLoja:=SOMA1(cLoja)
			end

			M->A2_COD	:= TSFOR->A2_COD
			M->A2_LOJA	:= cLoja
			
		EndIF
		
		TSFOR->( dbCloseArea() )

	EndIF
	
	If Select("TSA2") > 0
		TSA2->( dbCloseArea() )
	Endif

Endif

Return (lLiber)