#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"  

User Function T4FRT005()

	Private _cXML
	Private _cArquivo		:= GetTempPath()+CriaTrab(,.F.)+'_func_custo.xml'
	Private _nI			:= 0
	Private _aFunCusto	:= {}
	Private _cPerg		:= "T4FRT05"

	Processa({|| Gera()   }, "Aguarde", "Gerando Planilha ...")

	Static Function Gera()
	
	Local _aVerbas		:= _fGetVer()		

	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	ajustaSx1(_cPerg)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	If Pergunte(_cPerg,.T.)		
		_cXML := FWMsExcel():New()
		_cXML:AddWorkSheet( "Custo" )
		_cXML:AddTable( "Custo", "Custo Funcionarios" )
		_cXML:AddColumn("Custo","Custo Funcionarios","Empresa",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Filial",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Matricula",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Nome",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Admissao",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Demissao",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Cargo",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Gestor",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Centro de Custo",1,1)
		_cXML:AddColumn("Custo","Custo Funcionarios","Descrição CC",1,1)				
		_cXML:AddColumn("Custo","Custo Funcionarios","Tp. MAO-DE-OBRA",1,1)
		
		For _nI	:= 1 To Len(_aVerbas)
			_cXML:AddColumn("Custo","Custo Funcionarios",AllTrim(_aVerbas[_nI,2])+" ("+_aVerbas[_nI,1]+") ",1,1)
//			_cXML:AddColumn("Custo","Custo Funcionarios",AllTrim(_aVerbas[_nI,2]),1,1)
		Next _nI
		
		_cXML:AddColumn("Custo","Custo Funcionarios","Total Custo",1,1)
		
		_aFunCusto := _fGetCF(_cXML,_aVerbas)
		
		For _nI	:= 1 To Len(_aFunCusto)
			_cXML:AddRow("Custo","Custo Funcionarios",aClone(_aFunCusto[_nI]))
		Next _nI
		
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

Static Function _fGetVer()
	
	Local _aVerbas	:= {}
	Local _cQuery	:= ""
	Local _cAliasVB	:= GetNextAlias()
	
	_cQuery := "SELECT RV_COD, RV_DESC"
	_cQuery += " FROM " + RetSqlName("SRV")
	_cQuery	+= " WHERE RV_XRCUSTO = '1' "
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasVB)
	
	While (_cAliasVB)->(!EOF())
		Aadd(_aVerbas,{(_cAliasVB)->RV_COD, (_cAliasVB)->RV_DESC})
		(_cAliasVB)->(dbSkip())
	EndDo

Return(_aVerbas)

Static Function _fGetCF(_cXML,_aVerbas)

	Local _cQuery		:= ""
	Local _cAliasCF
	Local _aSM0			:= GetArea()
	Local _cTEmpresa	:= ""
	Local _cTFilial		:= ""
	Local _aFunCust		:= {}
	Local _aTeste		:= {}
	Local _nI			:= 0
	Local _nTCusto		:= 0
	
	dbSelectArea("SM0")
	Count to nExcel
	ProcRegua(nExcel)

	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())

	While SM0->(!EOF())
//		If SM0->M0_CODIGO <> _cEmpAtu
		IncProc("Gerando Excel...")

		If MsFile("SRD" + SM0->M0_CODIGO + "0")
			_cAliasCF	:= GetNextAlias()
			_cTEmpresa	:= AllTrim(SM0->M0_NOME)
			_cTFilial	:= AllTrim(SM0->M0_FILIAL)
	
			_cQuery	:= "SELECT DISTINCT SRA.RA_MAT,	SRA.RA_NOME, SRA.RA_ADMISSA, SRA.RA_DEMISSA, SRJ.RJ_DESC, SRA.RA_CC, CTT.CTT_DESC01, SRA.RA_CATFUNC,RA_NOMSUP "
			_cQuery	+= " FROM SRA" + SM0->M0_CODIGO + "0 SRA "

			_cQuery	+= " LEFT JOIN SRJ080 srj "
			_cQuery	+= " ON RJ_FUNCAO = RA_CODFUNC "
			_cQuery	+= " AND SRJ.D_E_L_E_T_ <> '*' "

			_cQuery	+= " LEFT JOIN CTT080 CTT "
			_cQuery	+= " ON CTT_CUSTO = RA_CC "
			_cQuery	+= " AND CTT.D_E_L_E_T_ <> '*' "

			_cQuery	+= " INNER JOIN SRD" + SM0->M0_CODIGO + "0 SRD "
			_cQuery	+= " ON RD_MAT = RA_MAT "
			_cQuery	+= " AND SRD.RD_DATPGT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
//			_cQuery	+= " AND SRD.RD_DATPGT BETWEEN '20170401' AND '20170431' "

			_cQuery	+= " WHERE SRA.D_E_L_E_T_ <> '*' "
			Do Case
				Case MV_PAR07 == 1
					_cQuery += " AND SRA.RA_SITFOLH <> 'D'  "
					_cQuery	+= " AND   SRA.RA_DEMISSA = ' ' "
				Case MV_PAR07 == 2
					_cQuery += " AND SRA.RA_SITFOLH = 'D'  "
					_cQuery	+= " AND   SRA.RA_DEMISSA <> ' ' "
			End Case
			
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

			_cQuery	+= " AND SRA.RA_FILIAL = '" + SM0->M0_CODFIL + "' "
			TcQuery _cQuery New Alias &(_cAliasCF)
			
			While (_cAliasCF)->(!EOF())
				_aTeste	:= {}
				AaDD(_aTeste,_cTEmpresa)
				AaDD(_aTeste,_cTFilial)
				AaDD(_aTeste,(_cAliasCF)->RA_MAT)
				AaDD(_aTeste,(_cAliasCF)->RA_NOME)
				AaDD(_aTeste,StoD((_cAliasCF)->RA_ADMISSA))
				AaDD(_aTeste,StoD((_cAliasCF)->RA_DEMISSA))
				AaDD(_aTeste,(_cAliasCF)->RJ_DESC)
				AaDD(_aTeste,(_cAliasCF)->RA_NOMSUP)
				AaDD(_aTeste,(_cAliasCF)->RA_CC)
				AaDD(_aTeste,(_cAliasCF)->CTT_DESC01)
				AaDD(_aTeste,Tabela("28",(_cAliasCF)->RA_CATFUNC))
				
				_nTCusto	:= 0
				For _nI := 1 To Len(_aVerbas)	
					_nCusto := _fGVlrV(_aVerbas[_nI,1],(_cAliasCF)->RA_MAT,SM0->M0_CODIGO)
					AaDD(_aTeste,Transform(_nCusto,PesqPict("SRD","RD_VALOR")))
					_nTCusto += _nCusto
				Next _nI
				AaDD(_aTeste,Transform(_nTCusto,PesqPict("SRD","RD_VALOR")))
				aadd(_aFunCust,_aTeste)
				
				(_cAliasCF)->(dbSkip())
				
			EndDo	
			
			(_cAliasCF)->(dbCloseArea())
		EndIf
//		_cEmpAtu := SM0->M0_CODIGO
		SM0->(dbSkip())
	EndDo
	RestArea(_aSM0)

Return(_aFunCust)

Static Function _fGVlrV(_cVerba,_cMat, _cEmpMAT)

	Local _cQuery		:= ""
	Local _cAliasGVV	:= GetNextAlias()
	Local _nVlrVerba	:= 0
	
	_cQuery	:= "SELECT RD_VALOR "
	_cQuery	+= " FROM SRD" + _cEmpMAT + "0 "
	_cQuery	+= " WHERE RD_MAT = '" + _cMat + "' "
	_cQuery	+= " AND RD_DATPGT BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "
	_cQuery	+= " AND RD_PD = '" + _cVerba + "' "
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasGVV)
	
	While (_cAliasGVV)->(!EOF())
		_nVlrVerba	:= (_cAliasGVV)->RD_VALOR
		(_cAliasGVV)->(dbSkip())
	EndDo
	
	(_cAliasGVV)->(dbCloseArea())

Return(_nVlrVerba)

Static Function ajustaSx1(cPerg)
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	putSx1( cPerg, "01", "Data inicial"  ,".",".","mv_ch1","D",08,0,2,"G","NaoVazio()","","","","mv_par01","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "02", "Data final"    ,".",".","mv_ch2","D",08,0,2,"G","NaoVazio()","","","","mv_par02","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "03", "Matricula de"  ,".",".","mv_ch3","C",06,0,2,"G","","SRA","","","mv_par03","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "04", "Matricula ate" ,".",".","mv_ch4","C",06,0,2,"G","","SRA","","","mv_par04","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "05", "C Custo de"    ,".",".","mv_ch5","C",20,0,2,"G","","CTT","","","mv_par05","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "06", "C Custo ate"   ,".",".","mv_ch6","C",20,0,2,"G","","CTT","","","mv_par06","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "07", "Situacao"   	 ,".",".","mv_ch7","N",01,0,2,"C","","","","","mv_par07","Ativo(s)","","","","Demitido(s)","","","Ambos","","","","","","","","",,,,"")	
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
return