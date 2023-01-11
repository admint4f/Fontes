#include "protheus.ch"
#include "ap5mail.ch"

//
// Bibliotecas de funções da Alt Ideias para o portal RH+
//


//
// Encontra o funcionário na SRA e retorna os campos solicitados
// Procura na tabela da empresa correta do funcionario, ainda que não seja a mesma empresa da thread atual
//
User Function altRAdata( cEmp, cFil, cMat, aCpos )
	local aRet 		:= array(len(aCpos))
	local cAlias 	:= getNextAlias()
	local cFilRA 	:= if( empty(xFilial("SRA")), space(len(cFilAnt)), cFil )
	local i
	local cQuery 	:= "SELECT * FROM SRA" + cEmp + "0 WHERE RA_FILIAL = '" + cFilRA + "' AND RA_MAT = '" + cMat + "' AND D_E_L_E_T_ = ' '"

	dbUseArea(.T.,"TopConn",TCGenQry(,,cQuery),cAlias,.F.,.T.)

	if (cAlias)->( !eof() )
		for i := 1 to len( aCpos )
			aRet[i] := (cAlias)->( FieldGet( FieldPos( aCpos[i] ) ) )
		next i
	endif

	(cAlias)->( dbCloseArea() )

return aRet


//
// Encontra o fornecedor na SA2 e retorna os campos solicitados
// Procura na tabela da empresa correta do fornecedor, ainda que não seja a mesma empresa da thread atual
//
User Function altA2data( cEmp, cFil, cCod, cLoja, aCpos )
	local aRet := array(len(aCpos))
	local cAlias := getNextAlias()
	local cFilA2 := if( empty(xFilial("SA2")), space(len(cFilAnt)), cFil )
	local i
	local cQuery := "SELECT * FROM " + retSQLName("SA2") + " WHERE A2_FILIAL = '" + cFilA2 + "' AND A2_COD = '" + cCod + "' AND A2_LOJA = '" + cLoja + "' AND D_E_L_E_T_ = ' '"

	dbUseArea(.T.,"TopConn",TCGenQry(,,cQuery),cAlias,.F.,.T.)

	if (cAlias)->( !eof() )
		for i := 1 to len( aCpos )
			aRet[i] := (cAlias)->( FieldGet( FieldPos( aCpos[i] ) ) )
		next i
	endif

	(cAlias)->( dbCloseArea() )

return aRet


//
// Criptografa com chave complementar à MD5 padrão
//
User Function altMD5(cString)
	local cRet	:= ""
	local cKey	:= "@lt!d3!@$"
	local cMesh	:= mesh(upper(alltrim(cString)),cKey)

	cRet := md5(cMesh, 2)

return cRet

Static Function mesh(c1,c2)
	local cRet := ""
	local i

	while len(c2) < len(c1)
		c2 += c2
	end

	for i := 1 to len(c1)
		cRet += subs(c1,i,1) + subs(c2,i,1)
	next i

return cRet


//
// Envia e-mail
//
User Function altMail(cTo,cSubject,cMessage,cAttach,cError)
	local cEmailTo := ""
	local cEmailCc := ""
	local lResult  := .F.
	local cUser
	local nAt

	default cAttach := ""
	default cError := ""

	// Verifica se serao utilizados os valores padrao.
	cAccount	:= getMV( "MV_RELACNT" )
	cPassword	:= getMV( "MV_RELPSW"  )
	cServer		:= getMV( "MV_RELSERV" )
	cFrom		:= if( empty( getMV( "MV_RELFROM" )), getMV( "MV_RELACNT" ), getMV( "MV_RELFROM" ) )

	if At(Chr(59),cTo) > 0
		cEmailTo := subStr(cTo,1,At(Chr(59),cTo)-1)
		cEmailCc := subStr(cTo,At(Chr(59),cTo)+1,len(cTo))
	else
		cEmailTo := cTo
	endif

	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

	if lResult .and. GetMv("MV_RELAUTH")
		//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
		lResult := mailAuth(cAccount, cPassword)
		//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
		if !lResult
			nAt 	:= at("@",cAccount)
			cUser 	:= if(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
			lResult := mailAuth(cUser, cPassword)
		endif
	endif

	if lResult
		SEND MAIL FROM cFrom;
		TO			cEmailTo;
		CC			cEmailCc;
		SUBJECT		cSubject;
		BODY		cMessage;
		ATTACHMENT  cAttach;
		RESULT		lResult

		if !lResult
			GET MAIL ERROR cError
		endIf

		DISCONNECT SMTP SERVER
	else
		GET MAIL ERROR cError
	endIf

return lResult

//
// Transforma texto normal em texto HTML para, em geral, enviar por e-mail.
//
User Function altTxt2Htm( cText )

	// ::: CRASE
	// aA (acento crase)
	cText := STRTRAN(cText,CHR(224), "&agrave;")
	cText := STRTRAN(cText,CHR(192), "&Agrave;")

	// ::: ACENTO CIRCUNFLEXO
	// aA (acento circunflexo)
	cText := STRTRAN(cText,CHR(226), "&acirc;")
	cText := STRTRAN(cText,CHR(194), "&Acirc;")
	// eE (acento circunflexo)
	cText := STRTRAN(cText,CHR(234), "&ecirc;")
	cText := STRTRAN(cText,CHR(202), "&Ecirc;")
	// oO (acento circunflexo)
	cText := STRTRAN(cText,CHR(244), "&ocirc;")
	cText := STRTRAN(cText,CHR(212), "&Ocirc;")

	// ::: TIL
	// aA (til)
	cText := STRTRAN(cText,CHR(227), "&atilde;")
	cText := STRTRAN(cText,CHR(195), "&Atilde;")
	// oO (til)
	cText := STRTRAN(cText,CHR(245), "&otilde;")
	cText := STRTRAN(cText,CHR(213), "&Otilde;")

	// ::: CEDILHA
	cText := STRTRAN(cText,CHR(231), "&ccedil;")
	cText := STRTRAN(cText,CHR(199), "&Ccedil;")

	// ::: ACENTO AGUDO
	// aA (acento agudo)
	cText := STRTRAN(cText,CHR(225), "&aacute;")
	cText := STRTRAN(cText,CHR(193), "&Aacute;")
	// eE (acento agudo)
	cText := STRTRAN(cText,CHR(233), "&eacute;")
	cText := STRTRAN(cText,CHR(201), "&Eacute;")
	// iI (acento agudo)
	cText := STRTRAN(cText,CHR(237), "&iacute;")
	cText := STRTRAN(cText,CHR(205), "&Iacute;")
	// oO (acento agudo)
	cText := STRTRAN(cText,CHR(243), "&oacute;")
	cText := STRTRAN(cText,CHR(211), "&Oacute;")
	// uU (acento agudo)
	cText := STRTRAN(cText,CHR(250), "&uacute;")
	cText := STRTRAN(cText,CHR(218), "&Uacute;")

	// ::: ENTER
	cText := STRTRAN(cText,CHR(13)+CHR(10), "<br>")
	cText := STRTRAN(cText,CHR(13), "<br>")
	cText := STRTRAN(cText,CHR(10), "<br>")
	cText := STRTRAN(cText,"<br><br>", "<br>&nbsp;<br>")

return cText


//
// Executa uma query e exporta o resultado para excel em XML
//
user function altExcel( aData, cFile )
	local lRet := .F.
	processa( {|| lRet := geraExcel( aData, cFile ) }, "Processando informações" )
return lRet

static function geraExcel( aData, cFile )
	Local a 		:= getNextAlias()
	Local cPath  	:= getTempPath()
	Local aCmpX3 	:= {}
	Local i,r
	Local cSheet
	Local cTable
	Local cCol
	Local xml

	default cFile := criaTrab(,.F.)
	if !lower(right(alltrim(cFile),4)) == ".xml"
		cFile := alltrim(cFile)+".xml"
	endif

	procRegua(len(aData)*2)

	xml := FWMsExcel():New()

	for r := 1 to len( aData )
		cSheet := if( aData[r,2] = nil .or. empty( aData[r,2] ), "Pasta"+alltrim(str(r)), aData[r,2] )
		cTable := if( aData[r,3] = nil .or. empty( aData[r,3] ), "Dados", aData[r,3] )

		xml:AddWorkSheet( cSheet )
		xml:AddTable( cSheet, cTable )

		incProc("Obtendo dados...")

		dbUseArea(.T.,"TopConn",tcGenQRY(,,aData[r,1]),a,.F.,.T.)

		incProc("Exportando dados para a planilha...")

		if (a)->( eof() )
			xml:AddColumn( cSheet, cTable , "Nenhum dado disponivel", 1,1)
			loop
		endif

		/*
		Método    :	AddColumn
		Sintaxe   :	FWMsExcel():AddColumn(< cWorkSheet >, < cTable >, < cColumn >, < nAlign >, < nFormat >, < lTotal >)-> NIL
		Descrição :	Adiciona uma coluna a tabela de uma Worksheet.
		Parâmetros: cWorkSheet -> Nome da planilha
		cTable -----> Título da tabela
		cColumn ----> Titulo da tabela que será adicionada
		nAlign -----> Alinhamento da coluna ( 1-Left,2-Center,3-Right )
		nFormat ----> Codigo de formatação ( 1-General,2-Number,3-Monetário,4-DateTime )
		lTotal -----> Indica se a coluna deve ser totalizada
		*/
		//----------------------------------------------------------------------------------------------------------------------------------------
		// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 06/09/2019
		//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
		
		SX3->( dbSetOrder(2) )
		for i := 1 to (a)->( fCount() )
			cCol := (a)->( FieldName(i) )
			if SX3->( dbSeek( padR( cCol, len(SX3->X3_CAMPO) ) ) )
				cCol := alltrim(SX3->X3_TITULO)
				if SX3->X3_TIPO $ "DN"
					tcSetField( a				,;
					SX3->X3_CAMPO	,;
					SX3->X3_TIPO	,;
					SX3->X3_TAMANHO	,;
					SX3->X3_DECIMAL  )
				endif
			endif

			if valtype( (a)->( fieldGet(i) ) ) == "D"
				xml:AddColumn( cSheet, cTable , cCol, 2, 4)
			elseif valtype( (a)->( fieldGet(i) ) ) == "N"
				xml:AddColumn( cSheet, cTable , cCol, 3, 2)
			else
				xml:AddColumn( cSheet, cTable , cCol, 1, 1)
			endif
		next i
		
/*		
		for i := 1 to (a)->( fCount() )
			aAdd(aCmpX3,(a)->( FieldName(i) ))
			If Trim(GetSX3Cache(aCmpX3[01],"X3_CAMPO")) <> Nil
				cCol := alltrim(GetSX3Cache(aCmpX3[01],"X3_CAMPO"))
				if GetSX3Cache(aCmpX3[01],"X3_TIPO"	) $ "DN"
					tcSetField( a			,;
							GetSX3Cache(aCmpX3[01],"X3_CAMPO"	)	,;
							GetSX3Cache(aCmpX3[01],"X3_TIPO"	)	,;
							GetSX3Cache(aCmpX3[01],"X3_TAMANHO"	)	,;
							GetSX3Cache(aCmpX3[01],"X3_DECIMAL"	)	 )
				endif
			endif
			aCmpX3 := {}

			if valtype( (a)->( fieldGet(i) ) ) == "D"
				xml:AddColumn( cSheet, cTable , cCol, 2, 4)
			elseif valtype( (a)->( fieldGet(i) ) ) == "N"
				xml:AddColumn( cSheet, cTable , cCol, 3, 2)
			else
				xml:AddColumn( cSheet, cTable , cCol, 1, 1)
			endif
		next i
		
		//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
*/
		while (a)->( !eof() )
			l := {}

			for i := 1 to (a)->( fCount() )
				if valtype( (a)->( fieldGet(i) ) ) == "D"
					aAdd( l, dtoc( (a)->( fieldGet(i) ) ) )
				elseif valtype( (a)->( fieldGet(i) ) ) == "N"
					aAdd( l, str( (a)->( fieldGet(i) ) ) )
				else
					aAdd( l, alltrim( (a)->( fieldGet(i) ) ) )
				endif
			next i

			xml:AddRow( cSheet, cTable, aClone(l) )

			(a)->( dbSkip() )
		end

		(a)->( dbCloseArea() )

	next r

	xml:Activate()

	incProc("Abrindo...")

	xml:getXMLFile( cFile )

	if __CopyFile( cFile, cPath + cFile )
		oExcel := msExcel():New()
		oExcel:workBooks:Open( cPath + cFile )
		oExcel:setVisible(.T.)
	else
		msgInfo( "Erro ao copiar o arquivo." )
	endif

return .T.

//
// Funcao para retornar os feriados cadastrados na SP3 para o portal
//
user function altRFeri()

	local clAlias:= ""
	local aRet	 := {}
	local cQuery := ""
	local cAnoRef:= alltrim(str(year(dDataBase)))

	cQuery := " SELECT P3_DATA, P3_FIXO, P3_MESDIA "
	cQuery += "   FROM " + retSqlName("SP3")+ " SP3 "
	cQuery += "  WHERE P3_FILIAL = '"+xFilial("SP3")+"' "
	cQuery += "    AND ( P3_DATA LIKE '"+cAnoRef+"%' OR (P3_FIXO = 'S' AND P3_MESDIA != ' '))
	cQuery += "    AND D_E_L_E_T_ = ' '

	clAlias := getNextAlias()
	dbUseArea(.T.,"TopConn",TCGenQry(,,cQuery), clAlias,.F.,.T.)

	while ( clAlias )->( !eof() )

		if ( clAlias )->P3_FIXO == "S"
			aAdd(aRet, cAnoRef+alltrim( ( clAlias )->P3_MESDIA))
		else
			aAdd(aRet, ( clAlias )->P3_DATA)
		endif

		( clAlias )->( dbSkip() )
	end

	( clAlias )->( dbCloseArea() )

return aRet
