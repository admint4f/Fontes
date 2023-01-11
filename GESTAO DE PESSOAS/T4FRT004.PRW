#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"  

User Function T4FRT004()

	Local _cXML
	Local _cArquivo	:= GetTempPath()+CriaTrab(,.F.)+'_func_verba.xml'
	Local _cPerg	:= "T4FRT04"
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	ajustaSx1(_cPerg)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	If Pergunte(_cPerg)		
		_cXML := FWMsExcel():New()
		_cXML:AddWorkSheet( "Verba Folha" )
		_cXML:AddTable( "Verba Folha", "Resumo Headcount" )
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Empresa",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Filial",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Matricula",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Nome",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Centro de Custo",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Descrição CC",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Admissao",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Demissao",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Gestor",1,1)
		_cXML:AddColumn("Verba Folha","Resumo Headcount","Cargo",1,1)		
		_cXML:AddColumn("Verba Folha","Resumo Headcount","TOTAL ATIVOS CLT (943)",1,1)		
		_cXML:AddColumn("Verba Folha","Resumo Headcount","TOTAL ESTAGIARIOS (944)",1,1)		
		_cXML:AddColumn("Verba Folha","Resumo Headcount","TOTAL PRO LABORE (945)",1,1)		
		_cXML:AddColumn("Verba Folha","Resumo Headcount","TOTAL AFASTADOS (946)",1,1)		
		_cXML:AddColumn("Verba Folha","Resumo Headcount","TOTAL DESLIGADOS (947)",1,1)		
		
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
	
			_cQuery	:= "SELECT SRA.RA_MAT,	SRA.RA_NOME,	SRA.RA_CC, CTT.CTT_DESC01,	SRJ.RJ_DESC, SRA.RA_NOMSUP, SRA.RA_ADMISSA, SRA.RA_DEMISSA"
      
			_cQuery	+= " FROM SRA" + SM0->M0_CODIGO + "0 SRA "
			
			_cQuery	+= " LEFT JOIN SRJ080 srj "
			_cQuery	+= " ON RJ_FUNCAO = RA_CODFUNC "
			_cQuery	+= " AND SRJ.D_E_L_E_T_ <> '*' "
			
			_cQuery	+= " LEFT JOIN CTT080 CTT "
			_cQuery	+= " ON CTT_CUSTO = RA_CC "
			_cQuery	+= " AND CTT.D_E_L_E_T_ <> '*' "
			     
			_cQuery	+= " WHERE SRA.D_E_L_E_T_ <> '*' "
			_cQuery	+= " AND SRA.RA_FILIAL = '" + SM0->M0_CODFIL + "' "
			
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
					_cXML:AddRow("Verba Folha","Resumo Headcount",{	_cTEmpresa,;
																			_cTFilial,;
																			(_cAliasFE)->RA_MAT,;
																			(_cAliasFE)->RA_NOME,;
																			(_cAliasFE)->RA_CC,;
																			(_cAliasFE)->CTT_DESC01,;
																			StoD((_cAliasFE)->RA_ADMISSA),;
																			StoD((_cAliasFE)->RA_DEMISSA),;
																			(_cAliasFE)->RA_NOMSUP,;
																			(_cAliasFE)->RJ_DESC,;
																			_fGVHCount((_cAliasFE)->RA_MAT,SM0->M0_CODIGO,'943'),;
																			_fGVHCount((_cAliasFE)->RA_MAT,SM0->M0_CODIGO,'944'),;
																			_fGVHCount((_cAliasFE)->RA_MAT,SM0->M0_CODIGO,'945'),;
																			_fGVHCount((_cAliasFE)->RA_MAT,SM0->M0_CODIGO,'946'),;
																			_fGVHCount((_cAliasFE)->RA_MAT,SM0->M0_CODIGO,'947')})
	
				(_cAliasFE)->(dbSkip())
			EndDo	
			
			(_cAliasFE)->(dbCloseArea())
//		EndIf
//		_cEmpAtu := SM0->M0_CODIGO
		SM0->(dbSkip())
	EndDo
	RestArea(_aSM0)

Return()

Static Function _fGVHCount(_cMat, _cEmpMAT, _cVerba)

	Local _cQuery		:= ""
	Local _cAliasGVV	:= GetNextAlias()
	Local _cRet			:= ""
	Local _cPer1		:= SubStr(DtoS(Mv_PAR01),1,4)+SubStr(DtoS(Mv_PAR01),5,2)
	Local _cPer2		:= SubStr(DtoS(Mv_PAR02),1,4)+SubStr(DtoS(Mv_PAR02),5,2)
	
	_cQuery	:= "SELECT RD_VALOR "
	_cQuery	+= " FROM SRD" + _cEmpMAT + "0 "
	_cQuery	+= " WHERE RD_MAT = '" + _cMat + "' "
	If _cPer1 <> _cPer2
		_cQuery	+= " AND ( RD_DATARQ = '" + _cPer1 + "' OR RD_DATARQ = '" + _cPer2 + "' )"
	Else
		_cQuery	+= " AND RD_DATARQ = '" + _cPer1 + "' "
	Endif
	_cQuery	+= " AND RD_PD = '" + _cVerba + "' "
	_cQuery	+= " AND D_E_L_E_T_ = ' ' "
	TcQuery _cQuery New Alias &(_cAliasGVV)
	
	If (_cAliasGVV)->(!EOF())
		_cRet	:= "Sim"
	EndIf
	
	(_cAliasGVV)->(dbCloseArea())

Return(_cRet)

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
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

return