#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"

#DEFINE _EOL chr(13)+chr(10)


/*{Protheus.doc} T4JUR01
TODO 		Rotina para impressao do relat�rio de Pre Fluxo
@author	 	Bruna Zechetti
@since 		11/06/2013
@version 	1.0
@return 	${return}, ${return_description}

@type 		User Function
/*/

User Function T4JUR01()

	Local lEnd		:= .F.
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private _cPerg	:= "JUR001A"
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSX1(_cPerg,"01",	"Data de :", "Data de " ,"Data de " ,	"mv_ch1","D",8,	0,	0,	"G","NAOVAZIO()","","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSX1(_cPerg,"02",	"Data ate :", "Data ate" ,"Data ate",	"mv_ch2","D",8,	0,	0,	"G","NAOVAZIO()","","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSX1(_cPerg,"03",	"Produto", "Codigo do Produto" ,"Codigo do Produto","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03","","","","","","","","","","","","","","","","")
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------


	If Pergunte(_cPerg,.t.)
		Processa({|lEnd| fRunProc(@lEnd) }, "Processos", "Processando o arquivo, Aguarde...", .T. )	
	EndIf

Return(Nil)

Static Function fRunProc(lEnd)

	Local _nI			:= 0
	Local _nJ			:= 0
	Local _nPos			:= 0
	Local _cAlias		:= ""
	Local _cAliasF		:= GetNextAlias()
	Local _cAliasZZP	:= ""
	Local _cAliasZZE	:= ""
	Local _cArqTmp		:= ""
	Local _cArqTmp2		:= ""
	Local _cArq			:= ""
	Local _cPNome		:= ""
	Local _cQuery		:= ""
	Local _aStruct		:= {}
	Local _aEmpresas	:= {{"08", "T4F_MATRIZ"},;
	{"09", "METRO"},;
	{"15", "AURO"},;
	{"16", "VICAR"},;
	{"20", "AEB"},;
	{"25", "AREAMKT"}}

	_nPos := aScan(_aEmpresas,{|x| Alltrim(x[1]) == cEmpAnt })   

	If Select("TMP") > 0
		Dbselectarea("TMP")
		TMP->(DbClosearea())
	EndIf
	If Select("TMP1") > 0
		Dbselectarea("TMP1")
		TMP1->(DbClosearea())
	EndIf


	ReportDef()
	oReport:PrintDialog()

Return Nil     

Static Function ReportDef()

	oReport := TReport():New("JUR001","Processos Jurídicos",_cPerg,{|oReport| PrintReport(oReport)},"Impressão de registros do jurídico.")
	oReport:SetLandscape(.T.)

	oSecCab := TRSection():New( oReport , "Processos Jurídicos", {"TMP"} )
	TRCell():New( oSecCab, "ZZP_COD"    , "TMP")
	//TRCell():New( oSecCab, "ZZP_VRUNIT" , "TMP")
	TRCell():New( oSecCab, "ZZP_TOTAL"  , "TMP")
	TRCell():New( oSecCab, "ZZE_NUMERO" , "TMP")
	TRCell():New( oSecCab, "ZZE_FORNEC" , "TMP")
	//TRCell():New( oSecCab, "ZZE_HISTOR" , "TMP")
	//TRCell():New( oSecCab, "ZZE_STATUS" , "TMP")
	TRCell():New( oSecCab, "ZZE_DATA"   , "TMP")
	TRCell():New( oSecCab, "ZZE_CCUSTO" , "TMP")
	TRCell():New( oSecCab, "ZZE_PEP"    , "TMP")
	//TRCell():New( oSecCab, "ZZE_USERID" , "TMP")
	//TRCell():New( oSecCab, "AA1_NOMUSU" , "TMP")
	TRCell():New( oSecCab, "ZZE_TITULO" , "TMP")
	//TRCell():New( oSecCab, "REC"        , "TMP")
	TRCell():New( oSecCab, "ZZR_DESCRI" , "TMP")
	//TRCell():New( oSecCab, "AK3_DESCRI"      , "TMP")
	//TRCell():New( oSecCab, "AK5_DESCRI"      , "TMP")
	//TRCell():New( oSecCab, "AK6_DESCRI"      , "TMP")

Return Nil


Static Function PrintReport(oReport)

	Local oTMPTable
	
	//Monta Arquivo
	aCampos := {}
	AADD(aCampos,{ "ZZP_COD"    , "C",15,0}) 
	AADD(aCampos,{ "ZZP_VRUNIT" , "N",15,2}) 
	AADD(aCampos,{ "ZZP_TOTAL"  , "N",15,2}) 
	AADD(aCampos,{ "ZZE_NUMERO" , "C",12,0}) 
	AADD(aCampos,{ "ZZE_FORNEC" , "C",06,0}) 
	//AADD(aCampos,{ "ZZE_HISTOR" , "C",40,0}) 
	AADD(aCampos,{ "ZZE_STATUS" , "C",01,0}) 
	AADD(aCampos,{ "ZZE_DATA"   , "D",08,0}) 
	AADD(aCampos,{ "ZZE_CCUSTO" , "C",20,0}) 
	AADD(aCampos,{ "ZZE_PEP"    , "C",20,0}) 
	AADD(aCampos,{ "ZZE_USERID" , "C",10,2}) 
	AADD(aCampos,{ "AA1_NOMUSU" , "C",30,2}) 
	AADD(aCampos,{ "ZZE_TITULO" , "C",10,0}) 
	AADD(aCampos,{ "REC"        , "C",20,0}) 
	AADD(aCampos,{ "ZZR_DESCRI"       , "C",250,0}) 
	//AADD(aCampos,{ "AK3_DESCRI"       , "C",60,0}) 
	//AADD(aCampos,{ "AK5_DESCRI"       , "C",60,0}) 
	//AADD(aCampos,{ "AK6_DESCRI"       , "C",60,0}) 

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	cTemp1 := CriaTrab(nil,.f.)
	dbCreate(cTemp1,aCampos)
	dbUseArea( .T.,,cTemp1,"TMP", Nil, .F. )
	*/
	oTMPTable:= FWTemporaryTable():New("TMP")
	oTMPTable:SetFields( aCampos )
	oTMPTable:Create()	

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	//Query do Relatorio    

	cQuery := " "  
	cQuery += " SELECT ZP.ZZP_CODIGO,ZP.ZZP_COD,ZP.ZZP_VRUNIT,ZP.ZZP_TOTAL " //,ZE.ZZE_NUMERO,ZE.ZZE_FORNEC, "
	//cQuery += " ZE.ZZE_HISTOR,ZE.ZZE_STATUS,ZE.ZZE_DATA,ZE.ZZE_CCUSTO,ZE.ZZE_PEP,ZE.ZZE_USERID,ZE.ZZE_TITULO,ZE.R_E_C_N_O_ as REC"
	//cQuery += " '' AS ZZE_DESC "
	//cQuery += " ISNULL(CONVERT(VARCHAR(2047), CONVERT(VARBINARY(2047), ZE.ZZE_DESC)),'') AS OBS"
	cQuery += " FROM "+RetSqlName("ZZP")+" ZP INNER JOIN "+RetSqlName("ZZE")+" ZE "
	cQuery += "   ON ZE.ZZE_NUMERO = ZP.ZZP_CODIGO "
	cQuery += " WHERE ZP.D_E_L_E_T_ = ' '  "
	cQuery += "   AND ZE.D_E_L_E_T_ = ' '  "  
	cQuery += "   AND ZE.ZZE_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  "
	cQuery += "   AND ZP.ZZP_COD = '"+(MV_PAR03)+"' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
	//copy to \xx1
	dbgotop()


	Do while !eof()
		SELECT ZZE
		dbSetOrder(1)
		Seek xFilial()+tmp1->ZZP_CODIGO
		cLinha1 := cLinha2 := cLinha3 := cLinha4 := cLinha5 := cLinha6 := ""
		For i:=1 To MLCount(ZZE_DESC)
			//		cLinha6 := Memoline(ZZE_DESC,300,i)
			do case
				case I=1
				cLinha1 := Memoline(ZZE_DESC,60,i)
				case I=2
				cLinha2 := Memoline(ZZE_DESC,60,i)
				case I=3
				cLinha3 := Memoline(ZZE_DESC,60,i)
				case I=4
				cLinha4 := Memoline(ZZE_DESC,60,i)
				case I=5
				cLinha5 := Memoline(ZZE_DESC,60,i)
			Endcase
		Next

		cDesc := alltrim(MSMM(ZZE_DESC,240))
		PswOrder(1)
		PswSeek(ZZE->ZZE_USERID,.T.)
		cUser := AllTrim(Pswret(1)[1][4])
		SELECT TMP
		RecLock("TMP",.t.)
		tmp->ZZP_COD	:= tmp1->ZZP_COD
		tmp->ZZP_VRUNIT	:= tmp1->ZZP_VRUNIT
		tmp->ZZP_TOTAL	:= tmp1->ZZP_TOTAL
		tmp->ZZE_NUMERO	:= ZZE->ZZE_NUMERO
		tmp->ZZE_FORNEC	:= ZZE->ZZE_FORNEC
		//	tmp->ZZE_HISTOR	:= ZZE->ZZE_HISTOR
		tmp->ZZE_STATUS	:= ZZE->ZZE_STATUS
		tmp->ZZE_DATA	:= ZZE->ZZE_DATA
		tmp->ZZE_CCUSTO	:= ZZE->ZZE_CCUSTO
		tmp->ZZE_PEP	:= ZZE->ZZE_PEP
		tmp->ZZE_USERID	:= ZZE->ZZE_USERID
		tmp->AA1_NOMUSU	:= cUser
		tmp->ZZE_TITULO	:= ZZE->ZZE_TITULO
		tmp->ZZR_DESCRI		:= trim(cLinha1)+" "+trim(cLinha2)+" "+trim(cLinha3)+" "+trim(cLinha4)+" "+trim(cLinha5) //SUBSTR(cDesc,001,60)
		//	tmp->AK3_DESCRI		:= cLinha2 //SUBSTR(cDesc,061,60)
		//	tmp->AK5_DESCRI		:= cLinha3 //SUBSTR(cDesc,121,60)
		//	tmp->AK6_DESCRI		:= cLinha4 //SUBSTR(cDesc,181,60)
		MsUnLock()
		Select Tmp1
		skip
	Enddo

	Select Tmp
	//copy to \xx2
	dbgotop()

	//For i:=1 To MLCount(ZZE_DESC)
	//	cLinha := Memoline(ZZE_DESC,60,i)
	//Next

	oSecCab:Print()

RETURN

