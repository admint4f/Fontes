#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"

#DEFINE _EOL chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FINR01  ºAutor  ³Bruna Zechetti      º Data ³  11/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para impressão do relatório PRE FLUXO.                ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function T4FINR01()

	Local lEnd		:= .F.
	Local _cPerg	:= "PREFLUX"

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSX1(_cPerg,"01",	"Data de Referencia", "Data de Referencia" ,"Data de Referencia",	"mv_ch1","D",8,	0,	0,	"G","NAOVAZIO()","","","","mv_par01","","","","","","","","","","","","","","","","")
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	If Pergunte(_cPerg,.t.)
		Processa({|lEnd| fRunProc(@lEnd) }, "PRE - FLUXO", "Processando o arquivo, Aguarde...", .T. )	
	EndIf

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRunProc  ºAutor  ³Bruna Zechetti      º Data ³  11/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para geração do relatório de PRE FLUXO.               ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fRunProc(lEnd)

	Local _nI			:= 0
	Local _nJ			:= 0
	Local _nPos			:= 0
	Local _cAlias		:= ""
	Local _cAliasF		:= GetNextAlias()
	Local _cAliasSE1	:= ""
	Local _cAliasSE2	:= ""
	Local _cAliasSE5	:= ""
	Local _cArqTmp		:= ""
	Local _cArqTmp2		:= ""
	Local _cArq			:= ""
	Local _cPNome		:= ""
	Local _cQuery		:= ""
	Local _aStruct		:= {}
	Local _aEmpresas	:= {{"08", "T4F_MATRIZ"}	,;
							{"09", "METRO"}			,;
							{"15", "AURO"}			,;
							{"16", "VICAR"}			,;
							{"20", "AEB"}			,;
							{"25", "AREAMKT"		}}
	Local oTMPTable

	_nPos := aScan(_aEmpresas,{|x| Alltrim(x[1]) == cEmpAnt })
	
	If _nPos > 0 
		_cQuery	:= " WITH SE5EST AS ( 	SELECT  SUM(E5_VALOR) AS EST_VALOR, E5_FILIAL, E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E5_LOJA, E5_TIPO, E5_NATUREZ, E5_RECPAG, E5_FILORIG "
		_cQuery	+= "        			FROM " + RetSqlName("SE5") + " SE5 "
		_cQuery	+= "        			WHERE E5_FILIAL = ''"
		_cQuery	+= "        			AND E5_MOTBX IN ('DEB','FAT','NOR')"
		_cQuery	+= "        			AND E5_TIPODOC = 'ES'"
		_cQuery	+= "        			AND E5_DATA >= '" + DtoS(mv_par01) + "'"
		_cQuery	+= "        			GROUP BY E5_FILIAL,E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E5_LOJA, E5_TIPO, E5_NATUREZ, E5_RECPAG, E5_FILORIG)"
					
		_cQuery	+= "	SELECT	SE2.E2_NUM AS TITULO,"
		_cQuery	+= "			SE2.E2_PARCELA AS PAR,"
		_cQuery	+= "			SE2.E2_TIPO AS TIPO,"
		_cQuery	+= "			SE2.E2_NATUREZ AS NATORIG,"
		_cQuery	+= "			SE2.E2_NOMFOR AS NOME,"
		_cQuery	+= "			SE2.E2_CCONTAB AS CONTAB,"
		_cQuery	+= "			SE2.E2_CCUSTO AS CCUSTO, 		"
		_cQuery	+= "			SE2.E2_ITEM AS ITEM,      		"
		_cQuery	+= "			CASE"
		_cQuery	+= "				WHEN SE2.E2_NATUREZ='302318'  THEN '302302'"
		_cQuery	+= "				WHEN SE2.E2_NATUREZ='301801'  THEN '301800'"
		_cQuery	+= "				WHEN SE2.E2_NATUREZ='201301'  THEN '201300'"
		_cQuery	+= "				ELSE SE2.E2_NATUREZ"
		_cQuery	+= "			END AS NATUREZA,"
		_cQuery	+= "			SED.ED_DESCRIC AS DESCNAT,"
		_cQuery	+= "			SE2.E2_EMISSAO AS EMISSAO,"
		_cQuery	+= "			SE2.E2_VENCTO AS VENCTO,"
		_cQuery	+= "			SE2.E2_VENCREA AS VENCREA,"
		_cQuery	+= "			MAX(SE5.E5_DATA) AS DT_BAIXA,"
		_cQuery	+= "			SE2.E2_VALOR AS VALOR,"
		_cQuery	+= "			SE2.E2_IRRF AS IRRF,"
		_cQuery	+= "			SE2.E2_HIST AS HIST,"
		_cQuery	+= "			SE2.E2_SALDO AS SALDO,"
		_cQuery	+= "			CASE"
		_cQuery	+= "				WHEN EST_VALOR <> NULL THEN SUM(SE5.E5_VALOR) - EST_VALOR "
		_cQuery	+= "				ELSE SUM(SE5.E5_VALOR) "
		_cQuery	+= "			END AS VAL_REC,"
		_cQuery	+= "			SE2.E2_MOEDA AS MOEDA,"
		_cQuery	+= "			SE2.E2_VALOR AS VAL_LIQ,"
		_cQuery	+= "'" + _aEmpresas[_nPos,2] +  "' AS EMPRESA,"
		_cQuery	+= "			'CPG' AS CART,"
		_cQuery	+= "			SE2.E2_FILORIG AS FILORIG"
		_cQuery	+= "	FROM " + RetSqlName("SE2") + " SE2 "
		
		_cQuery	+= "			LEFT JOIN SE5EST EST " 
		_cQuery	+= "			ON EST.E5_FILIAL = SE2.E2_FILIAL"
		_cQuery	+= "			AND EST.E5_FILORIG = SE2.E2_FILORIG"
		_cQuery	+= "			AND EST.E5_NUMERO = SE2.E2_NUM"
		_cQuery	+= "			AND EST.E5_PREFIXO = SE2.E2_PREFIXO"
		_cQuery	+= "			AND EST.E5_PARCELA = SE2.E2_PARCELA"
		_cQuery	+= "			AND EST.E5_TIPO = SE2.E2_TIPO"
		_cQuery	+= "			AND EST.E5_NATUREZ = SE2.E2_NATUREZ"
		_cQuery	+= "			AND EST.E5_CLIFOR = SE2.E2_FORNECE"
		_cQuery	+= "			AND EST.E5_LOJA = SE2.E2_LOJA"
		_cQuery	+= "			AND EST.E5_RECPAG = 'R'"

		_cQuery	+= "			LEFT JOIN " + RetSqlName("SE5") + " SE5 " 
		_cQuery	+= "			ON SE5.E5_FILIAL = SE2.E2_FILIAL"
		_cQuery	+= "			AND SE5.E5_FILORIG = SE2.E2_FILORIG"
		_cQuery	+= "			AND SE5.E5_NUMERO = SE2.E2_NUM"
		_cQuery	+= "			AND SE5.E5_PREFIXO = SE2.E2_PREFIXO"
		_cQuery	+= "			AND SE5.E5_PARCELA = SE2.E2_PARCELA"
		_cQuery	+= "			AND SE5.E5_TIPO = SE2.E2_TIPO"
		_cQuery	+= "			AND SE5.E5_NATUREZ = SE2.E2_NATUREZ"
		_cQuery	+= "			AND SE5.E5_CLIFOR = SE2.E2_FORNECE"
		_cQuery	+= "			AND SE5.E5_LOJA = SE2.E2_LOJA"
		_cQuery	+= "        	AND SE5.E5_DATA >= '" + DtoS(mv_par01) + "'"
		_cQuery	+= "			AND SE5.E5_RECPAG = 'P'"
		_cQuery	+= "			AND SE5.E5_MOTBX IN ('DEB','FAT','NOR')"
		_cQuery	+= "			AND SE5.E5_TIPODOC NOT IN ('EP','TR','DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','TE','ES')"
		_cQuery	+= "			AND SE5.D_E_L_E_T_ <> '*'"
					
		_cQuery	+= "			INNER JOIN SED080 SED "
		_cQuery	+= "			ON SE2.E2_FILIAL=SED.ED_FILIAL "
		_cQuery	+= "			AND SE2.E2_NATUREZ=SED.ED_CODIGO"
					
		_cQuery	+= "			WHERE SE2.E2_VENCREA >= '" + DtoS(mv_par01) + "'"
		_cQuery	+= "			AND SE2.E2_TIPO <> 'FT'"
		_cQuery	+= "			AND SE2.E2_NATUREZ NOT IN ('400701','400702','500100','500200','500300','500301')"
		_cQuery	+= "			AND SE2.D_E_L_E_T_ <> '*'"
		_cQuery	+= "			AND SED.D_E_L_E_T_ <> '*'"
		_cQuery	+= "			GROUP BY SE2.E2_NUM ,SE2.E2_PARCELA,SE2.E2_TIPO ,SE2.E2_NATUREZ ,SE2.E2_NOMFOR, SE2.E2_CCONTAB ,SE2.E2_CCUSTO ,SE2.E2_ITEM ,SE2.E2_NATUREZ, SED.ED_DESCRIC,SE2.E2_EMISSAO,SE2.E2_VENCTO,SE2.E2_VENCREA,SE2.E2_BAIXA,SE2.E2_VALOR, SE2.E2_IRRF ,SE2.E2_HIST ,SE2.E2_SALDO , SE2.E2_MOEDA,SE2.E2_VALOR, SE2.E2_FILORIG, EST_VALOR"
			
		TcQuery _cQuery New Alias "TMPPF2"
		
//		TCSetField ( "TMPPF1", < cCampo>, < cTipo>, [ nTamanho], [ nDecimais] ) 
		TCSetField ( "TMPPF2", "EMISSAO", 	"D", 8, 0 ) 
		TCSetField ( "TMPPF2", "VENCTO", 	"D", 8, 0 ) 
		TCSetField ( "TMPPF2", "VENCREA", 	"D", 8, 0 ) 
		TCSetField ( "TMPPF2", "DT_BAIXA", 	"D", 8, 0 ) 
		TCSetField ( "TMPPF2", "VALOR", 	"N", TamSx3("E2_VALOR")[1], TamSx3("E2_VALOR")[2] ) 
		TCSetField ( "TMPPF2", "IRRF", 		"N", TamSx3("E2_IRRF")[1], TamSx3("E2_IRRF")[2] ) 
		TCSetField ( "TMPPF2", "SALDO", 	"N", TamSx3("E2_SALDO")[1], TamSx3("E2_SALDO")[2] ) 
		TCSetField ( "TMPPF2", "VAL_REC", 	"N", TamSx3("E2_VALOR")[1], TamSx3("E2_VALOR")[2] )
		TCSetField ( "TMPPF2", "VAL_LIQ", 	"N", TamSx3("E2_VALOR")[1], TamSx3("E2_VALOR")[2] )
		
		ProcRegua(TMPPF2->(RecCount()))
		
		If Select("TMPPF2") > 0 

			//----------------------------------------------------------------------------------------------------------------------------------------
			// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
			//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
			/*
			_aStruct := TMPPF2->(dbStruct())
			_cArqTmp := CriaTrab(_aStruct,.T.)
			dbUseArea(.T.,__LocalDrive,_cArqTmp,"TMPPF1",.F.,.F.)
			*/
			oTMPTable:= FWTemporaryTable():New("TMPPF1")
			oTMPTable:SetFields( _aStruct )
			oTMPTable:Create()	

			//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
						
			TMPPF2->(dbGoTop())				
			
			If TMPPF2->(!EOF())
				While TMPPF2->(!EOF())
					If RecLock("TMPPF1",.T.)
						For _nJ	:= 1 To Len(_aStruct)
							TMPPF1->(&(_aStruct[_nJ][1])) := TMPPF2->(FieldGet(FieldPos(_aStruct[_nJ][1])))
						Next _nJ
						MsUnLock()
					EndIf
					TMPPF2->(dbSkip())
				EndDo
			EndIf
			
			TMPPF2->(DbCloseArea())
			
			For _nI	:= 1 To Len(_aEmpresas)
			
				IncProc("Empresa - " + _aEmpresas[_nI,1] + "/" + _aEmpresas[_nI,2] )
				
				_cAliasSE1	:= 'SE1' + _aEmpresas[_nI,1] + '0'
				_cAliasSE2	:= 'SE2' + _aEmpresas[_nI,1] + '0'
				_cAliasSE5	:= 'SE5' + _aEmpresas[_nI,1] + '0'
					
				_cQuery	:= " WITH SE5EST AS ( 	SELECT  SUM(E5_VALOR) AS EST_VALOR, E5_FILIAL, E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E5_LOJA, E5_TIPO, E5_NATUREZ, E5_RECPAG, E5_FILORIG "
				_cQuery	+= "        			FROM " + _cAliasSE5 + " SE5 "
				_cQuery	+= "        			WHERE E5_FILIAL = ''"
				_cQuery	+= "        			AND E5_MOTBX IN ('DEB','FAT','NOR')"
				_cQuery	+= "        			AND E5_TIPODOC = 'ES'"
				_cQuery	+= "        			AND E5_DATA >= '" + DtoS(mv_par01) + "'"
				_cQuery	+= "        			GROUP BY E5_FILIAL,E5_NUMERO, E5_PREFIXO, E5_PARCELA, E5_CLIFOR, E5_LOJA, E5_TIPO, E5_NATUREZ, E5_RECPAG, E5_FILORIG)"
					
				_cQuery	+= "	SELECT	SE2.E2_NUM AS TITULO,"
				_cQuery	+= "			SE2.E2_PARCELA AS PAR,"
				_cQuery	+= "			SE2.E2_TIPO AS TIPO,"
				_cQuery	+= "			SE2.E2_NATUREZ AS NATORIG,"
				_cQuery	+= "			SE2.E2_NOMFOR AS NOME,"
				_cQuery	+= "			SE2.E2_CCONTAB AS CONTAB,"
				_cQuery	+= "			SE2.E2_CCUSTO AS CCUSTO, 		"
				_cQuery	+= "			SE2.E2_ITEM AS ITEM,      		"
				_cQuery	+= "			CASE"
				_cQuery	+= "				WHEN SE2.E2_NATUREZ='302318' THEN '302302'"
				_cQuery	+= "				WHEN SE2.E2_NATUREZ='301801' THEN '301800'"
				_cQuery	+= "				WHEN SE2.E2_NATUREZ='201301' THEN '201300'"
				_cQuery	+= "				ELSE SE2.E2_NATUREZ"
				_cQuery	+= "			END AS NATUREZA,"
				_cQuery	+= "			SED.ED_DESCRIC AS DESCNAT,"
				_cQuery	+= "			SE2.E2_EMISSAO AS EMISSAO,"
				_cQuery	+= "			SE2.E2_VENCTO AS VENCTO,"
				_cQuery	+= "			SE2.E2_VENCREA AS VENCREA,"
				_cQuery	+= "			MAX(SE5.E5_DATA) AS DT_BAIXA,"
				_cQuery	+= "			SE2.E2_VALOR AS VALOR,"
				_cQuery	+= "			SE2.E2_IRRF AS IRRF,"
				_cQuery	+= "			SE2.E2_HIST AS HIST,"
				_cQuery	+= "			SE2.E2_SALDO AS SALDO,"
				_cQuery	+= "			CASE"
				_cQuery	+= "				WHEN EST_VALOR <> NULL THEN SUM(SE5.E5_VALOR) - EST_VALOR "
				_cQuery	+= "				ELSE SUM(SE5.E5_VALOR) "
				_cQuery	+= "			END AS VAL_REC,"
				_cQuery	+= "			SE2.E2_MOEDA AS MOEDA,"
				_cQuery	+= "			SE2.E2_VALOR AS VAL_LIQ,"
				_cQuery	+= "'" + _aEmpresas[_nI,2] + "' AS EMPRESA,"
				_cQuery	+= "			'CPG' AS CART,"
				_cQuery	+= "			SE2.E2_FILORIG AS FILORIG"
				_cQuery	+= "	FROM " + _cAliasSE2 + " SE2 "
				
				_cQuery	+= "	LEFT JOIN SE5EST EST " 
				_cQuery	+= "	ON EST.E5_FILIAL = SE2.E2_FILIAL"
				_cQuery	+= "	AND EST.E5_FILORIG = SE2.E2_FILORIG"				
				_cQuery	+= "	AND EST.E5_NUMERO = SE2.E2_NUM"
				_cQuery	+= "	AND EST.E5_PREFIXO = SE2.E2_PREFIXO"
				_cQuery	+= "	AND EST.E5_PARCELA = SE2.E2_PARCELA"
				_cQuery	+= "	AND EST.E5_TIPO = SE2.E2_TIPO"
				_cQuery	+= "	AND EST.E5_NATUREZ = SE2.E2_NATUREZ"
				_cQuery	+= "	AND EST.E5_CLIFOR = SE2.E2_FORNECE"
				_cQuery	+= "	AND EST.E5_LOJA = SE2.E2_LOJA"
				_cQuery	+= "	AND EST.E5_RECPAG = 'R'"
							
				_cQuery	+= "	LEFT JOIN " + _cAliasSE5 + " SE5 "
				_cQuery	+= "	ON SE5.E5_FILIAL = SE2.E2_FILIAL"
				_cQuery	+= "	AND SE5.E5_FILORIG = SE2.E2_FILORIG"
				_cQuery	+= "	AND SE5.E5_NUMERO = SE2.E2_NUM"
				_cQuery	+= "	AND SE5.E5_PREFIXO = SE2.E2_PREFIXO"
				_cQuery	+= "	AND SE5.E5_PARCELA = SE2.E2_PARCELA"
				_cQuery	+= "	AND SE5.E5_TIPO = SE2.E2_TIPO"
				_cQuery	+= "	AND SE5.E5_NATUREZ = SE2.E2_NATUREZ"
				_cQuery	+= "	AND SE5.E5_CLIFOR = SE2.E2_FORNECE"
				_cQuery	+= "	AND SE5.E5_LOJA = SE2.E2_LOJA"
				_cQuery	+= "	AND SE5.E5_DATA >= '" + DtoS(mv_par01) + "'"
				_cQuery	+= "	AND SE5.E5_RECPAG = 'P'"
				_cQuery	+= "	AND SE5.E5_MOTBX IN ('DEB','FAT','NOR')"
				_cQuery	+= "	AND SE5.E5_TIPODOC NOT IN ('EP','TR','DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','TE','ES')"
				_cQuery	+= "	AND SE5.D_E_L_E_T_ <> '*'"
							 
				_cQuery	+= "	INNER JOIN SED080 SED "
				_cQuery	+= "	ON SE2.E2_FILIAL=SED.ED_FILIAL "
				_cQuery	+= "	AND SE2.E2_NATUREZ=SED.ED_CODIGO"
							 
				_cQuery	+= "	WHERE SE2.E2_VENCREA >= '" + Dtos(mv_par01) + "'"
				_cQuery	+= "	AND SE2.E2_TIPO='FT' AND SE2.E2_NATUREZ='400700'"
				_cQuery	+= "	AND SE2.D_E_L_E_T_ <> '*'"
				_cQuery	+= "	AND SED.D_E_L_E_T_ <> '*'"
				_cQuery	+= "	GROUP BY SE2.E2_NUM ,SE2.E2_PARCELA,SE2.E2_TIPO ,SE2.E2_NATUREZ ,SE2.E2_NOMFOR, SE2.E2_CCONTAB ,SE2.E2_CCUSTO ,SE2.E2_ITEM ,SE2.E2_NATUREZ, SED.ED_DESCRIC,SE2.E2_EMISSAO,SE2.E2_VENCTO,SE2.E2_VENCREA,SE2.E2_BAIXA,SE2.E2_VALOR, SE2.E2_IRRF ,SE2.E2_HIST ,SE2.E2_SALDO , SE2.E2_MOEDA,SE2.E2_VALOR, SE2.E2_FILORIG, EST_VALOR"
							
				If _nPos <> _nI
					
					_cQuery	+= "	UNION ALL"
								
					_cQuery	+= "	SELECT	SE2.E2_NUM AS TITULO,"
					_cQuery	+= "			SE2.E2_PARCELA AS PAR,"
					_cQuery	+= "			SE2.E2_TIPO AS TIPO,"
					_cQuery	+= "			SE2.E2_NATUREZ AS NATORIG,"
					_cQuery	+= "			SE2.E2_NOMFOR AS NOME,"
					_cQuery	+= "			SE2.E2_CCONTAB AS CONTAB,"
					_cQuery	+= "			SE2.E2_CCUSTO AS CCUSTO,"
					_cQuery	+= "			SE2.E2_ITEM AS ITEM,"
					_cQuery	+= "			CASE"
					_cQuery	+= "				WHEN SE2.E2_NATUREZ='302318' THEN '302302'"
					_cQuery	+= "				WHEN SE2.E2_NATUREZ='301801' THEN '301800'"
					_cQuery	+= "				WHEN SE2.E2_NATUREZ='201301' THEN '201300'"
					_cQuery	+= "	   			ELSE SE2.E2_NATUREZ"
					_cQuery	+= "			END AS NATUREZA,"
					_cQuery	+= "			SED.ED_DESCRIC AS DESCNAT,"
					_cQuery	+= "			SE2.E2_EMISSAO AS EMISSAO,"
					_cQuery	+= "			SE2.E2_VENCTO AS VENCTO,"
					_cQuery	+= "			SE2.E2_VENCREA AS VENCREA,"
					_cQuery	+= "			MAX(SE5.E5_DATA)AS DT_BAIXA,"
					_cQuery	+= "			SE2.E2_VALOR AS VALOR,"
					_cQuery	+= "			SE2.E2_IRRF AS IRRF,"
					_cQuery	+= "			SE2.E2_HIST AS HIST,"
					_cQuery	+= "			SE2.E2_SALDO AS SALDO,"
					_cQuery	+= "			CASE"
					_cQuery	+= "				WHEN EST_VALOR <> NULL THEN SUM(SE5.E5_VALOR) - EST_VALOR "
					_cQuery	+= "				ELSE SUM(SE5.E5_VALOR) "
					_cQuery	+= "			END AS VAL_REC,"
					_cQuery	+= "			SE2.E2_MOEDA AS MOEDA,"
					_cQuery	+= "			SE2.E2_VALOR AS VAL_LIQ,"
					_cQuery	+= "'" + _aEmpresas[_nI,2] + "' AS EMPRESA,"
					_cQuery	+= "			'CPG' AS CART,"
					_cQuery	+= "			SE2.E2_FILORIG AS FILORIG"
					_cQuery	+= "	FROM " + _cAliasSE2 + " SE2 "
					
					_cQuery	+= "	LEFT JOIN SE5EST EST " 
					_cQuery	+= "	ON EST.E5_FILIAL = SE2.E2_FILIAL"
					_cQuery	+= "	AND EST.E5_FILORIG = SE2.E2_FILORIG"
					_cQuery	+= "	AND EST.E5_NUMERO = SE2.E2_NUM"
					_cQuery	+= "	AND EST.E5_PREFIXO = SE2.E2_PREFIXO"
					_cQuery	+= "	AND EST.E5_PARCELA = SE2.E2_PARCELA"
					_cQuery	+= "	AND EST.E5_TIPO = SE2.E2_TIPO"
					_cQuery	+= "	AND EST.E5_NATUREZ = SE2.E2_NATUREZ"
					_cQuery	+= "	AND EST.E5_CLIFOR = SE2.E2_FORNECE"
					_cQuery	+= "	AND EST.E5_LOJA = SE2.E2_LOJA"
					_cQuery	+= "	AND EST.E5_RECPAG = 'R'"
									
					_cQuery	+= "	LEFT JOIN " + _cAliasSE5 + " SE5 "
					_cQuery	+= "	ON SE5.E5_FILIAL = SE2.E2_FILIAL"
					_cQuery	+= "	AND SE5.E5_FILORIG = SE2.E2_FILORIG"
					_cQuery	+= "	AND SE5.E5_NUMERO = SE2.E2_NUM"
					_cQuery	+= "	AND SE5.E5_PREFIXO = SE2.E2_PREFIXO"
					_cQuery	+= "	AND SE5.E5_PARCELA = SE2.E2_PARCELA"
					_cQuery	+= "	AND SE5.E5_TIPO = SE2.E2_TIPO"
					_cQuery	+= "	AND SE5.E5_NATUREZ = SE2.E2_NATUREZ"
					_cQuery	+= "	AND SE5.E5_CLIFOR = SE2.E2_FORNECE"
					_cQuery	+= "	AND SE5.E5_LOJA = SE2.E2_LOJA"
					_cQuery	+= "	AND SE5.E5_DATA >= '" + DtoS(mv_par01) + "'"
					_cQuery	+= "	AND SE5.E5_RECPAG = 'P'"
					_cQuery	+= "	AND SE5.E5_MOTBX IN ('DEB','FAT','NOR')"
					_cQuery	+= "	AND SE5.E5_TIPODOC NOT IN ('EP','TR','DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','TE','ES')"
					_cQuery	+= "	AND SE5.D_E_L_E_T_ <> '*'"
									
					_cQuery	+= "	INNER JOIN SED080 SED "
					_cQuery	+= "	ON SE2.E2_FILIAL=SED.ED_FILIAL "
					_cQuery	+= "	AND SE2.E2_NATUREZ=SED.ED_CODIGO"
									
					_cQuery	+= "	WHERE SE2.E2_VENCREA >= '" + DtoS(mv_par01) + "'"
					_cQuery	+= "	AND SE2.E2_TIPO <> 'FT'"
					_cQuery	+= "	AND SE2.E2_NATUREZ NOT IN ('400701','400702','500100','500200','500300','500301')"
					_cQuery	+= "	AND SE2.D_E_L_E_T_ <> '*'"
					_cQuery	+= "	AND SED.D_E_L_E_T_ <> '*'"
					_cQuery	+= "	GROUP BY SE2.E2_NUM ,SE2.E2_PARCELA,SE2.E2_TIPO ,SE2.E2_NATUREZ ,SE2.E2_NOMFOR, SE2.E2_CCONTAB ,SE2.E2_CCUSTO ,SE2.E2_ITEM ,SE2.E2_NATUREZ, SED.ED_DESCRIC,SE2.E2_EMISSAO,SE2.E2_VENCTO,SE2.E2_VENCREA,SE2.E2_BAIXA,SE2.E2_VALOR, SE2.E2_IRRF ,SE2.E2_HIST ,SE2.E2_SALDO , SE2.E2_MOEDA,SE2.E2_VALOR, SE2.E2_FILORIG, EST_VALOR"
					
				EndIf
							
				_cQuery	+= "	UNION ALL"
		                    
				_cQuery	+= "	SELECT	SE1.E1_NUM AS TITULO,"
				_cQuery	+= "			SE1.E1_PARCELA AS PAR,"
				_cQuery	+= "			SE1.E1_TIPO AS TIPO,"
				_cQuery	+= "			SE1.E1_NATUREZ AS NATORIG,"
				_cQuery	+= "			SE1.E1_NOMCLI AS NOME,"
				_cQuery	+= "			SE1.E1_CCONTAB AS CONTAB,"
				_cQuery	+= "			SE1.E1_CCUSTO AS CCUSTO, 		"
				_cQuery	+= "			SE1.E1_ITEM AS ITEM,      		"
				_cQuery	+= "			SE1.E1_NATUREZ AS NATUREZA,"
				_cQuery	+= "			SED.ED_DESCRIC AS DESCNAT,"
				_cQuery	+= "			SE1.E1_EMISSAO AS EMISSAO,"
				_cQuery	+= "			SE1.E1_VENCTO AS VENCTO,"
				_cQuery	+= "			SE1.E1_VENCREA AS VENCREA,"
				_cQuery	+= "			MAX(SE5.E5_DATA) AS DT_BAIXA,"
				_cQuery	+= "			SE1.E1_VALOR AS VALOR,"
				_cQuery	+= "			SE1.E1_IRRF AS IRRF,"
				_cQuery	+= "			SE1.E1_HIST AS HIST,"
				_cQuery	+= "			SE1.E1_SALDO AS SALDO,"
				_cQuery	+= "			CASE"
				_cQuery	+= "				WHEN EST_VALOR <> NULL THEN SUM(SE5.E5_VALOR) - EST_VALOR "
				_cQuery	+= "				ELSE SUM(SE5.E5_VALOR) "
				_cQuery	+= "			END AS VAL_REC,"
				_cQuery	+= "			SE1.E1_MOEDA AS MOEDA,"
				_cQuery	+= "			SE1.E1_VALOR AS VAL_LIQ,"
				_cQuery	+= "'" + _aEmpresas[_nI,2] + "' AS EMPRESA,"
				_cQuery	+= "			'CRC' AS CART,"
				_cQuery	+= "			SE1.E1_FILORIG AS FILORIG"
				_cQuery	+= "	FROM " + _cAliasSE1 + " SE1 "
				
				_cQuery	+= "	LEFT JOIN SE5EST EST " 
				_cQuery	+= "	ON EST.E5_FILIAL = SE1.E1_FILIAL"
				_cQuery	+= "	AND EST.E5_FILORIG = SE1.E1_FILORIG"
				_cQuery	+= "	AND EST.E5_NUMERO = SE1.E1_NUM"
				_cQuery	+= "	AND EST.E5_PREFIXO = SE1.E1_PREFIXO"
				_cQuery	+= "	AND EST.E5_PARCELA = SE1.E1_PARCELA"
				_cQuery	+= "	AND EST.E5_TIPO = SE1.E1_TIPO"
				_cQuery	+= "	AND EST.E5_NATUREZ = SE1.E1_NATUREZ"
				_cQuery	+= "	AND EST.E5_CLIFOR = SE1.E1_CLIENTE"
				_cQuery	+= "	AND EST.E5_LOJA = SE1.E1_LOJA"
				_cQuery	+= "	AND EST.E5_RECPAG = 'P'"
							
				_cQuery	+= "	LEFT JOIN " + _cAliasSE5 + " SE5 "
				_cQuery	+= "	ON SE5.E5_FILIAL = SE1.E1_FILIAL"
				_cQuery	+= "	AND SE5.E5_FILORIG = SE1.E1_FILORIG"
				_cQuery	+= "	AND SE5.E5_NUMERO = SE1.E1_NUM"
				_cQuery	+= "	AND SE5.E5_PREFIXO = SE1.E1_PREFIXO"
				_cQuery	+= "	AND SE5.E5_PARCELA = SE1.E1_PARCELA"
				_cQuery	+= "	AND SE5.E5_TIPO = SE1.E1_TIPO"
				_cQuery	+= "	AND SE5.E5_NATUREZ = SE1.E1_NATUREZ"
				_cQuery	+= "	AND SE5.E5_CLIFOR = SE1.E1_CLIENTE"
				_cQuery	+= "	AND SE5.E5_LOJA = SE1.E1_LOJA"
				_cQuery	+= "	AND SE5.E5_DATA >= '" + DtoS(mv_par01) + "'"
				_cQuery	+= "	AND SE5.E5_RECPAG = 'R'"
				_cQuery	+= "	AND SE5.E5_MOTBX IN ('DEB','FAT','NOR')"
				_cQuery	+= "	AND SE5.E5_TIPODOC NOT IN ('EP','TR','DC','JR','MT','CM','D2','J2','M2','C2','V2','CP','TL','TE','ES')"
				_cQuery	+= "	AND SE5.D_E_L_E_T_ <> '*'"
							
				_cQuery	+= "	INNER JOIN SED080 SED "
				_cQuery	+= "	ON SE1.E1_FILIAL=SED.ED_FILIAL "
				_cQuery	+= "	AND SE1.E1_NATUREZ=SED.ED_CODIGO"
							
				_cQuery	+= "	WHERE SE1.E1_VENCREA >= '" + DtoS(mv_par01) + "'"
				_cQuery	+= "	AND SE1.E1_TIPO <> 'FT'"
				_cQuery	+= "	AND SE1.E1_NATUREZ NOT IN ('400700','400701','400702','500100','500200','500300','500301')"
				_cQuery	+= "	AND SE1.D_E_L_E_T_ <> '*'"
				_cQuery	+= "	AND SED.D_E_L_E_T_ <> '*'"
				_cQuery	+= "	GROUP BY SE1.E1_NUM ,SE1.E1_PARCELA,SE1.E1_TIPO ,SE1.E1_NATUREZ ,SE1.E1_NOMCLI, SE1.E1_CCONTAB ,SE1.E1_CCUSTO ,SE1.E1_ITEM ,SE1.E1_NATUREZ, SED.ED_DESCRIC,SE1.E1_EMISSAO,SE1.E1_VENCTO,SE1.E1_VENCREA,SE1.E1_BAIXA,SE1.E1_VALOR, SE1.E1_IRRF ,SE1.E1_HIST ,SE1.E1_SALDO , SE1.E1_MOEDA,SE1.E1_VALOR, SE1.E1_FILORIG, EST_VALOR"
						
				_cQuery	+= "	UNION ALL"
						
				_cQuery	+= "	SELECT	SE5.E5_NUMERO AS TITULO,"
				_cQuery	+= "			SE5.E5_PARCELA AS PAR,"
				_cQuery	+= "			SE5.E5_TIPO AS TIPO,"
				_cQuery	+= "			SE5.E5_NATUREZ AS NATORIG,"
				_cQuery	+= "			'                    ' AS NOME,"
				_cQuery	+= "			'                    ' AS CONTAB,"
				_cQuery	+= "			'                    ' AS CCUSTO,"
				_cQuery	+= "			'                    ' AS ITEM,"
				_cQuery	+= "			CASE"
				_cQuery	+= "				WHEN SE5.E5_NATUREZ='101301' THEN '301709'"
				_cQuery	+= "				ELSE SE5.E5_NATUREZ"
				_cQuery	+= "			END AS NATUREZA,"
				_cQuery	+= "			SED.ED_DESCRIC AS DESCNAT,"
				_cQuery	+= "			'          '  AS EMISSAO,"
				_cQuery	+= "			'          '  AS VENCTO,"
				_cQuery	+= "			SE5.E5_DATA AS VENCREA,"
				_cQuery	+= "			SE5.E5_DATA AS DT_BAIXA,"
				_cQuery	+= "			SE5.E5_VALOR AS VALOR,"
				_cQuery	+= "			0 AS IRRF,"
				_cQuery	+= "			SE5.E5_HISTOR AS HIST,"
				_cQuery	+= "			0 AS SALDO,"
				_cQuery	+= "			SE5.E5_VALOR AS VAL_REC,"
				_cQuery	+= "			1 AS MOEDA,"
				_cQuery	+= "			SE5.E5_VALOR AS VAL_LIQ,"
				_cQuery	+= "'" + _aEmpresas[_nI,2] + "' AS EMPRESA,"
				_cQuery	+= "			'MOV' AS CART,"
				_cQuery	+= "			SE5.E5_FILORIG AS FILORIG"
				_cQuery	+= "	FROM " + _cAliasSE5 + " SE5 "
							
				_cQuery	+= "	INNER JOIN SED080 SED "
				_cQuery	+= "	ON SE5.E5_FILIAL=SED.ED_FILIAL "
				_cQuery	+= "	AND SE5.E5_NATUREZ=SED.ED_CODIGO"
							
				_cQuery	+= "	WHERE SE5.E5_DATA>= '" + Dtos(mv_par01) + "'"
				_cQuery	+= "	AND SE5.E5_NATUREZ IN ('301700','301704', '101301', '301709')"
				_cQuery	+= "	AND SED.D_E_L_E_T_ <> '*'"
				_cQuery	+= "	AND SE5.D_E_L_E_T_ <> '*'"
				
				TcQuery _cQuery New Alias "TMPPF3"
		
		//		TCSetField ( "TMPPF1", < cCampo>, < cTipo>, [ nTamanho], [ nDecimais] ) 
				TCSetField ( "TMPPF3", "EMISSAO", 	"D", 8, 0 ) 
				TCSetField ( "TMPPF3", "VENCTO", 	"D", 8, 0 ) 
				TCSetField ( "TMPPF3", "VENCREA", 	"D", 8, 0 ) 
				TCSetField ( "TMPPF3", "DT_BAIXA", 	"D", 8, 0 ) 
				TCSetField ( "TMPPF3", "VALOR", 	"N", TamSx3("E2_VALOR")[1], TamSx3("E2_VALOR")[2] ) 
				TCSetField ( "TMPPF3", "IRRF", 		"N", TamSx3("E2_IRRF")[1], TamSx3("E2_IRRF")[2] ) 
				TCSetField ( "TMPPF3", "SALDO", 	"N", TamSx3("E2_SALDO")[1], TamSx3("E2_SALDO")[2] ) 
				TCSetField ( "TMPPF3", "VAL_REC", 	"N", TamSx3("E2_VALOR")[1], TamSx3("E2_VALOR")[2] )
				TCSetField ( "TMPPF3", "VAL_LIQ", 	"N", TamSx3("E2_VALOR")[1], TamSx3("E2_VALOR")[2] )

				TMPPF3->(dbGoTop())				
				
				If TMPPF3->(!EOF())
					While TMPPF3->(!EOF())
						If RecLock("TMPPF1",.T.)
							For _nJ	:= 1 To Len(_aStruct)
								TMPPF1->(&(_aStruct[_nJ][1])) := TMPPF3->(FieldGet(FieldPos(_aStruct[_nJ][1])))
							Next _nJ
							MsUnLock()
						EndIf
						TMPPF3->(dbSkip())
					EndDo
				EndIf
				
				TMPPF3->(DbCloseArea())
		
			Next _nI
			
			DbSelectArea("TMPPF1")
			TMPPF1->(DbGotop())
			
			If TMPPF1->(!Eof())
			
				_cArq	:= "C:\temp\pre_fluxo_ver2013_" + DtoS(ddatabase) + "_" + StrTran(time(),":","_") + ".xml"
				_cPNome	:= "pre_fluxo"
				_cAlias	:= "TMPPF1"
			   
			   If File(_cArq)
			      Ferase(_cArq)
			   EndIf 
			   
				MsAguarde({ || u_DB2XML(_cArq, _cPNome, _cAlias,,,,"2013","TMPPF1->TITULO+' - '+DTOC(TMPPF1->EMISSAO)")},"Aguarde .. Gerando arquivo...")
			
			    If File(_cArq)
			
			   		ApMsgInfo("Arquivo "+_cArq+" salvo com sucesso.","Informação","INFO")
						
					//Cria o link com o Excel
					oExcel := MsExcel():New()
					oExcel:WorkBooks:Open( Upper(_cArq) )
					oExcel:SetVisible(.T.)
				Else
					ApMsgInfo("Atenção:"+_EOL+"Não foi possivel criar o arquivo:"+_EOL+_cArq+_EOL+"Tente novamente.","Informação","INFO")
				EndIf		
			                                      
			EndIF             
			
			DbSelectArea("TMPPF1")
			TMPPF1->( DbCloseArea() )
			Ferase(_cArqTmp+OrdBagExt())  // Apaga arquivo de trabalho 1. 
		EndIf 
	EndIf

Return(Nil)