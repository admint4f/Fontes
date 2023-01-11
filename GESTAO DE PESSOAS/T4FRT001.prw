#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"  

User Function T4FRT001()

	Local _cPerg	:= "T4FT01"
	Local _cXML
	Local _cArquivo	:= GetTempPath()+'_Transferidos.xml'
	
	ajustaSx1(_cPerg)
	
//	If Pergunte(_cPerg,.T.)
		
		_cXML := FWMsExcel():New()
		_cXML:AddWorkSheet( "Transferidos" )
		_cXML:AddTable( "Transferidos", "Resumo de Transferidos" )
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Tipo",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Empresa De",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Filial De",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","CNPJ De",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Matricula",1,1)		
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Nome",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Centro de Custo De",1,1)		
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Admissao",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Demissao",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Cargo",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Superior De",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Dt. Transferência",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Empresa Para",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Filial Para",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","CNPJ Para",1,1)
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Centro de Custo Para",1,1)		
		_cXML:AddColumn("Transferidos","Resumo de Transferidos","Superior Para",1,1)
		
		_FGrvTRB(_cXML)
		
		//Criando o XML
		_cXML:Activate()
		_cXML:GetXMLFile(_cArquivo)
		
		//Abrindo o excel e abrindo o arquivo xml
		_cXML := MsExcel():New() 			//Abre uma nova conexão com Excel
		_cXML:WorkBooks:Open(_cArquivo) 	//Abre uma planilha
		_cXML:SetVisible(.T.) 				//Visualiza a planilha
		_cXML:Destroy()
		
//	EndIf
	    
Return(Nil)

Static Function _FGrvTRB(_cXML)

	Local _cQuery	:= ""
	Local _aDadosD	:= {}
	Local _aDadosP	:= {}
	
	_cQuery := "SELECT RE_FILIALD, RE_EMPD, RE_MATD, RE_FILIALP, RE_EMPP, RE_MATP, RE_DATA, RE_CCD, RE_CCP "
	_cQuery += " FROM " + RetSqlName("SRE")     
	_cQuery	+= " WHERE D_E_L_E_T_ = ' ' "
/*	If !Empty(MV_PAR01)
		_cQuery	+= " AND RE_DATA >= '" + DtoS(MV_PAR01) + "'"
	EndIf
	If !Empty(MV_PAR02)
		_cQuery	+= " AND RE_DATA <= '" + DtoS(MV_PAR02) + "'"
	EndIf
	If !Empty(MV_PAR03) .And. !Empty(MV_PAR04)
		_cQuery	+= " AND RE_MATD BETWEEN '" + AllTrim(MV_PAR03) + "' AND '" + AllTrim(MV_PAR04) + "'"
	EndIf*/
	_cQuery += " ORDER BY RE_MATD,RE_DATA"
	_cQuery := ChangeQuery(_cQuery)

	TcQuery _cQuery New Alias "TTRANSF"
	
	If TTRANSF->(!EOF())
		While TTRANSF->(!EOF())
		
			aDadosD	:= _fGetDFT(TTRANSF->RE_EMPD,TTRANSF->RE_FILIALD,TTRANSF->RE_MATD)
			aDadosP	:= _fGetDFT(TTRANSF->RE_EMPP,TTRANSF->RE_FILIALP,TTRANSF->RE_MATP)
//		Empresa De	Filial De	CNPJ De	Matricula De	Nome De	Dt. Admissao De	Dt. Demissao De	Departamento De	Superior De	Dt. Transferencia	Empresa Para	Filial Para	CNPJ Para	Matricula Para	Nome Para	Dt. Admissao Para	Dt. Demissao Para	Departamento Para	Superior Para
			
//			If AllTrim(aDadosD[1,1]) <> AllTrim(aDadosP[1,1]) .And. AllTrim(aDadosD[1,2]) <> AllTrim(aDadosP[1,2])
				_cXML:AddRow("Transferidos","Resumo de Transferidos",{	IIf(AllTrim(aDadosD[1,1])+AllTrim(aDadosD[1,2]) <> AllTrim(aDadosP[1,1])+AllTrim(aDadosP[1,2]),;
																				"Transferido(a)",IIf(TTRANSF->RE_CCD<>TTRANSF->RE_CCP,"Troca CC","Troca Matricula")),;
																		aDadosD[1,1],;
																		aDadosD[1,2],;
																		aDadosD[1,3],;
																		TTRANSF->RE_MATD,;
																		aDadosD[1,4],;
																		TTRANSF->RE_CCD,;
																		stod(aDadosD[1,5]),;
																		StoD(aDadosD[1,6]),;
																		aDadosD[1,7],;
																		aDadosD[1,8],;
																		StoD(TTRANSF->RE_DATA),;
																		aDadosP[1,1],;
																		aDadosP[1,2],;
																		aDadosP[1,3],;
																		TTRANSF->RE_CCP,;
																		aDadosP[1,8]})
//			EndIf
			TTRANSF->(dbSkip())
		EndDo
	EndIf

	TTRANSF->(dbCloseArea())
Return()

Static Function _fGetDFT(_cEmpT,_cFilT,_cMatricula)

	Local _cQuery		:= ""
	Local _cAliasDFT	:= GetNextAlias()
	Local _aDados		:= {}
	Local _aSM0			:= GetArea()
	Local _cTEmpresa	:= ""
	Local _cTFilial		:= ""
	Local _cTCNPJ		:= ""
	
	dbSelectArea("SM0")
	SM0->(dbSetOrder(1))
	If SM0->(dbSeek(_cEmpT+_cFilT))
		_cTEmpresa	:= AllTrim(SM0->M0_NOME)
		_cTFilial	:= AllTrim(SM0->M0_FILIAL)
		_cTCNPJ		:= SM0->M0_CGC
	EndIf
	
	If Empty(_cTEmpresa)
		Aadd(_aDados,{_cEmpT,_cFilT,"","","//","//","",""})
	Else
		_cQuery	:= "SELECT RA_NOME,RA_ADMISSA,RA_DEMISSA,RJ_DESC,RA_NOMSUP"
		_cQuery	+= " FROM SRA"+ _cEmpT + "0 SRA"
		
		_cQuery	+= " LEFT JOIN " + RetSqlName("SRJ") + " SRJ "
		_cQuery	+= " ON RJ_FUNCAO = RA_CODFUNC "
		_cQuery	+= " AND SRJ.D_E_L_E_T_ = ' ' "
		
		_cQuery	+= " WHERE SRA.D_E_L_E_T_ = ' ' "
		_cQuery	+= " AND RA_MAT = '" + _cMatricula + "' "
		TcQuery _cQuery New Alias &(_cAliasDFT)
		
		If (_cAliasDFT)->(!EOF())
			Aadd(_aDados,{_cTEmpresa,_cTFilial,_cTCNPJ,(_cAliasDFT)->RA_NOME,(_cAliasDFT)->RA_ADMISSA,(_cAliasDFT)->RA_DEMISSA,(_cAliasDFT)->RJ_DESC,(_cAliasDFT)->RA_NOMSUP})
		Else
			Aadd(_aDados,{_cEmpT,_cFilT,"","","//","//","",""})
		EndIf	
		
		(_cAliasDFT)->(dbCloseArea())
	EndIf
	RestArea(_aSM0)

Return(_aDados)

Static Function ajustaSx1(cPerg)

	putSx1( cPerg, "01", "Data inicial"  ,".",".","mv_ch1","D",08,0,2,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "02", "Data final"    ,".",".","mv_ch2","D",08,0,2,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "03", "Matricula de"  ,".",".","mv_ch3","C",06,0,2,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "04", "Matricula ate" ,".",".","mv_ch4","C",06,0,2,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",,,,"")
	
return