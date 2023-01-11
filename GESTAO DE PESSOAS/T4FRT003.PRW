#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"  

User Function T4FRT003()

	Local _cXML
	Local _cArquivo	:= GetTempPath()+CriaTrab(,.F.)+'_func_experiencia.xml'
	Local _cPerg	:= "T4FRT03"
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	ajustaSx1(_cPerg)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	
	If Pergunte(_cPerg)		
		_cXML := FWMsExcel():New()
		_cXML:AddWorkSheet( "Experiencia" )
		_cXML:AddTable( "Experiencia", "Resumo de Funcionarios" )
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Empresa",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Filial",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Matricula",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Nome",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Admissao",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Centro de Custo",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Descrição CC",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Cargo",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Gestor",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Salario",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Tp. MAO-DE-OBRA",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Ven. Experiencia 1",1,1)
		_cXML:AddColumn("Experiencia","Resumo de Funcionarios","Ven. Experiencia 2",1,1)
		
		
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
	Local _cAliasFE
	Local _aSM0			:= GetArea()
	Local _cTEmpresa	:= ""
	Local _cTFilial		:= ""
	Local _cEmpAtu		:= ""
	
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	While SM0->(!EOF())
//		If SM0->M0_CODIGO <> _cEmpAtu
			_cAliasFE	:= GetNextAlias()
			_cTEmpresa	:= AllTrim(SM0->M0_NOME)
			_cTFilial	:= AllTrim(SM0->M0_FILIAL)
	
			_cQuery	:= "SELECT SRA.RA_MAT,	SRA.RA_NOME,	SRA.RA_CC, CTT.CTT_DESC01,	SRJ.RJ_DESC, SRA.RA_NOMSUP,	"
    		_cQuery	+= " SRA.RA_ADMISSA, SRA.RA_SALARIO, SRA.RA_CATFUNC, SRA.RA_VCTOEXP, SRA.RA_VCTEXP2 "
      
			_cQuery	+= " FROM SRA" + SM0->M0_CODIGO + "0 SRA "
			
			_cQuery	+= " LEFT JOIN SRJ080 srj "
			_cQuery	+= " ON RJ_FUNCAO = RA_CODFUNC "
			_cQuery	+= " AND SRJ.D_E_L_E_T_ <> '*' "
			
			_cQuery	+= " LEFT JOIN CTT080 CTT "
			_cQuery	+= " ON CTT_CUSTO = RA_CC "
			_cQuery	+= " AND CTT.D_E_L_E_T_ <> '*' "
			     
			_cQuery	+= " WHERE SRA.D_E_L_E_T_ <> '*' "
			If MV_PAR07 == 1
				_cQuery += " AND SRA.RA_SITFOLH <> 'D'  "
				_cQuery	+= " AND   SRA.RA_DEMISSA = ' ' "
			ElseIf MV_PAR07 == 2
				_cQuery += " AND SRA.RA_SITFOLH = 'D'  "
				_cQuery	+= " AND   SRA.RA_DEMISSA <> ' ' "
			EndIf
			_cQuery	+= " AND SRA.RA_FILIAL = '" + SM0->M0_CODFIL + "' "
			
			If !Empty(MV_PAR01) 
				_cQuery	+= " AND SRA.RA_VCTOEXP >= '" + DtoS(MV_PAR01) + "' "
			EndIf
			If !Empty(MV_PAR02) 
				_cQuery	+= " AND SRA.RA_VCTOEXP <= '" + DtoS(MV_PAR02) + "' "
			EndIf
						
			If !Empty(MV_PAR03) 
				_cQuery	+= " AND SRA.RA_MAT >= '" + AllTrim(MV_PAR03) + "' "
			EndIf
			If !Empty(MV_PAR04) 
				_cQuery	+= " AND SRA.RA_MAT <= '" + AllTrim(MV_PAR04) + "' "
			EndIf
			
			If !Empty(MV_PAR05) 
				_cQuery	+= " AND SRA.RA_CC >= '" + AllTrim(MV_PAR05) + "' "
			EndIf
			If !Empty(MV_PAR06) 
				_cQuery	+= " AND SRA.RA_CC <= '" + AllTrim(MV_PAR06) + "' "
			EndIf
			
			TcQuery _cQuery New Alias &(_cAliasFE)
			
			While (_cAliasFE)->(!EOF())
					_cXML:AddRow("Experiencia","Resumo de Funcionarios",{	_cTEmpresa,;
																			_cTFilial,;
																			(_cAliasFE)->RA_MAT,;
																			(_cAliasFE)->RA_NOME,;
																			StoD((_cAliasFE)->RA_ADMISSA),;
																			(_cAliasFE)->RA_CC,;
																			(_cAliasFE)->CTT_DESC01,;
																			(_cAliasFE)->RJ_DESC,;
																			(_cAliasFE)->RA_NOMSUP,;
																			Transform((_cAliasFE)->RA_SALARIO,PesqPict("SRA","RA_SALARIO")),;
																			Tabela("28",(_cAliasFE)->RA_CATFUNC),;
																			StoD((_cAliasFE)->RA_VCTOEXP),;
																			StoD((_cAliasFE)->RA_VCTEXP2)})
	
				(_cAliasFE)->(dbSkip())
			EndDo	
			
			(_cAliasFE)->(dbCloseArea())
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
	putSx1( cPerg, "01", "Data inicial"  ,".",".","mv_ch1","D",08,0,2,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "02", "Data final"    ,".",".","mv_ch2","D",08,0,2,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "03", "Matricula de"  ,".",".","mv_ch3","C",06,0,2,"G","","SRA","","","mv_par03","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "04", "Matricula ate" ,".",".","mv_ch4","C",06,0,2,"G","","SRA","","","mv_par04","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "05", "C Custo de"    ,".",".","mv_ch5","C",20,0,2,"G","","CTT","","","mv_par05","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "06", "C Custo ate"   ,".",".","mv_ch6","C",20,0,2,"G","","CTT","","","mv_par06","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "07", "Situacao"   	 ,".",".","mv_ch7","N",01,0,2,"C","","","","","mv_par07","Ativo(s)","","","","Demitido(s)","","","Ambos","","","","","","","","",,,,"")	
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
return