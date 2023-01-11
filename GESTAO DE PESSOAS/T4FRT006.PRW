#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"  

User Function T4FRT006()

	Local _cPerg	:= "T4FRT02"
	Local _cXML
	Local _cArquivo	:= GetTempPath()+CriaTrab(,.F.)+'_func_atv_dem.xml'

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	ajustaSx1(_cPerg)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	If Pergunte(_cPerg,.T.)
		
		_cXML := FWMsExcel():New()
		_cXML:AddWorkSheet( "Por Periodo" )
		_cXML:AddTable( "Por Periodo", "Resumo de Funcionarios" )
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Status",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Empresa",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Filial",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Matricula",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Nome",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Centro de Custo",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Descrição CC",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Cargo",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Gestor",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Admissão",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Demissão",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Salario",1,1)
		_cXML:AddColumn("Por Periodo","Resumo de Funcionarios","Tp. MAO-DE-OBRA",1,1)
		
		_fGetDFT(_cXML)
		
		//Criando o XML
		_cXML:Activate()
		_cXML:GetXMLFile(_cArquivo)
		
		//Abrindo o excel e abrindo o arquivo xml
		_cXML := MsExcel():New() 			//Abre uma nova conexão com Excel
		_cXML:WorkBooks:Open(_cArquivo) 	//Abre uma planilha
		_cXML:SetVisible(.T.) 				//Visualiza a planilha
		_cXML:Destroy()
		
	EndIf
	    
Return(Nil)

Static Function _fGetDFT(_cXML)

	Local _cQuery		:= ""
	Local _cAliasFP
	Local _aSM0			:= GetArea()
	Local _cTEmpresa	:= ""
	Local _cTFilial		:= ""
	Local _dDataI		:= StoD(MV_PAR01+"01")
	Local _dDataF		:= LastDay(StoD(MV_PAR01+"01"))
	Local _cEmpAtu		:= ""
	
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	While SM0->(!EOF())
//		If SM0->M0_CODIGO <> _cEmpAtu
			_cAliasFP	:= GetNextAlias()
			_cTEmpresa	:= AllTrim(SM0->M0_NOME)
			_cTFilial	:= AllTrim(SM0->M0_FILIAL)
	
			_cQuery	:= "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CC, CTT_DESC01, RJ_DESC, RA_NOMSUP, RA_ADMISSA, RA_DEMISSA, RA_SALARIO, RA_CATFUNC "
			_cQuery	+= " FROM SRA" + SM0->M0_CODIGO + "0 SRA "
			
			_cQuery	+= " LEFT JOIN CTT080 CTT "
			_cQuery	+= " ON CTT_CUSTO = RA_CC "
			_cQuery	+= " AND CTT.D_E_L_E_T_ = ' ' "
			
			_cQuery	+= " LEFT JOIN SRJ080 SRJ "
			_cQuery	+= " ON RJ_FUNCAO = RA_CODFUNC "
			_cQuery	+= " AND SRJ.D_E_L_E_T_ = ' ' "
			
			_cQuery	+= " WHERE SRA.D_E_L_E_T_ = ' ' "
			_cQuery	+= " AND RA_FILIAL = '" + SM0->M0_CODFIL + "' "
			_cQuery	+= " AND (( RA_DEMISSA BETWEEN '" + DtoS(_dDataI) + "' AND '" + DtoS(_dDataF) + "' ) "
			_cQuery	+= " OR (RA_ADMISSA BETWEEN '" + DtoS(_dDataI) + "' AND '" + DtoS(_dDataF) + "'))"

			If !Empty(MV_PAR02) 
				_cQuery	+= " AND SRA.RA_MAT >= '" + AllTrim(MV_PAR02) + "' "
			EndIf
			If !Empty(MV_PAR03) 
				_cQuery	+= " AND SRA.RA_MAT <= '" + AllTrim(MV_PAR03) + "' "
			EndIf
			
			If !Empty(MV_PAR04) 
				_cQuery	+= " AND SRA.RA_CC >= '" + AllTrim(MV_PAR04) + "' "
			EndIf
			If !Empty(MV_PAR05) 
				_cQuery	+= " AND SRA.RA_CC <= '" + AllTrim(MV_PAR05) + "' "
			EndIf
 
			TcQuery _cQuery New Alias &(_cAliasFP)
			
			While (_cAliasFP)->(!EOF())
					_cXML:AddRow("Por Periodo","Resumo de Funcionarios",{	IIf(Month(StoD((_cAliasFP)->RA_DEMISSA)) == Val(SubStr(Mv_PAR01,5,2)), "Demitido no mes","Ativo"),;
																			_cTEmpresa,;
																			_cTFilial,;
																			(_cAliasFP)->RA_MAT,;
																			(_cAliasFP)->RA_NOME,;
																			(_cAliasFP)->RA_CC,;
																			(_cAliasFP)->CTT_DESC01,;
																			(_cAliasFP)->RJ_DESC,;
																			(_cAliasFP)->RA_NOMSUP,;
																			StoD((_cAliasFP)->RA_ADMISSA),;
																			StoD((_cAliasFP)->RA_DEMISSA),;
																			Transform((_cAliasFP)->RA_SALARIO,PesqPict("SRA","RA_SALARIO")),;
																			Tabela("28",(_cAliasFP)->RA_CATFUNC)})
	
				(_cAliasFP)->(dbSkip())
			EndDo	
			
			(_cAliasFP)->(dbCloseArea())
//		EndIf
//		_cEmpAtu := SM0->M0_CODIGO
		SM0->(dbSkip())
	EndDo
	RestArea(_aSM0)

Return()

Static Function ajustaSx1(cPerg)

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	putSx1( cPerg, "01", "Periodo (AAAAMM)?",".",".","mv_ch1","C",06,0,2,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "02", "Matricula de"  	,".",".","mv_ch2","C",06,0,2,"G","","SRA","","","mv_par02","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "03", "Matricula ate" 	,".",".","mv_ch3","C",06,0,2,"G","","SRA","","","mv_par03","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "04", "C Custo de"    	,".",".","mv_ch4","C",20,0,2,"G","","CTT","","","mv_par04","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "05", "C Custo ate"  	,".",".","mv_ch5","C",20,0,2,"G","","CTT","","","mv_par05","","","","","","","","","","","","","","","","",,,,"")
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

return