#Include "Protheus.Ch"
#Include "TopConn.Ch"
#Include "RwMake.Ch"  
#INCLUDE "TBICONN.CH"
#INCLUDE "FINR865.CH"

#DEFINE ENTER Chr(13)+Chr(10)

User Function T4FR8652()

	Local _cPerg	:= "FIN865"
	Local _oReport	:= Nil

	Private Titulo   := STR0007 

	_oReport := fImp865(_oReport,_cPerg)
	_oReport:PrintDialog()

Return(Nil)

Static Function fImp865(_oReport,_cPerg)

	Local _clNomProg	:= "T4FR865"
	Local _clTitulo 	:= STR0007 
	Local _clDesc   	:= STR0001
	Local aCodRet		:= {}
	Local _lReport		:= .T.

	Pergunte("FIN865",.F.)
	_lReport := Iif( mv_par09 == 2 .Or. (mv_par09 == 1 .And. FR865CodRet( @aCodRet )),.T.,.F.)

	_oReport:= TReport():New(_clNomProg,_clTitulo,_cPerg,{|_oReport| Iif( _lReport ,FRunSPT(_oReport,aCodRet),.F.)},_clDesc)
	_oReport:SetLandscape()			// Formato paisagem
	_oReport:oPage:nPaperSize:=9 	// Impressão em papel A4
	_oReport:lFooterVisible := .F.	// Não imprime rodapé do protheus

Return(_oReport)

Static Function fRunSPT(_oReport,aCodRet)

	Local _oSec1		:= Nil

	Pergunte("FIN865",.F.)

	_FTabTRB(_oReport)

	_oSec1 := TRSection():New(_oReport,STR0007, {"TRB"},,.F.,.F.)

	_FGrvTRB(_oSec1,aCodRet)

	TRCell():New(_oSec1,"CODIGO" ,"TRB",STR0020,/*Picture*/, 06 ,/*lPixel*/,{ || TRB->CODIGO  } )		//"Codigo"
	TRCell():New(_oSec1,"LOJA"   ,"TRB",STR0021,/*Picture*/, 02 ,/*lPixel*/,{ || TRB->LOJA 	  } )		//"Loja"
	TRCell():New(_oSec1,"NOMEFOR","TRB",STR0022,/*Picture*/, 40 ,/*lPixel*/,{ || TRB->NOMEFOR } )		//"Fornecedor"
	TRCell():New(_oSec1,"CGC"    ,"TRB",STR0023,PesqPict("SA2","A2_CGC"), 25 ,/*lPixel*/,{ || If(!Empty(TRB->CGC), TRB->CGC, ) } )	//"CGC"
	TRCell():New(_oSec1,"PRF"    ,"TRB",STR0024,/*Picture*/, TamSX3("E2_PREFIXO")[1],/*lPixel*/,{ || TRB->PREFIXO } )	//"Prf"
	TRCell():New(_oSec1,"NUM"    ,"TRB",STR0025,/*Picture*/, TamSX3("E2_NUM")[1]    ,/*lPixel*/,{ || TRB->NUM     } )	//"Numero"
	TRCell():New(_oSec1,"PARCELA","TRB",STR0026,/*Picture*/, TamSX3("E2_PARCELA")[1],/*lPixel*/,{ || TRB->PARCELA } )	//"Pc"
	TRCell():New(_oSec1,"TIPO"   ,"TRB",STR0027,/*Picture*/, TamSX3("E2_TIPO")[1]   ,/*lPixel*/,{ || TRB->TIPO    } )	//"Tipo"
	TRCell():New(_oSec1,"TPNOT"  ,"TRB","Tipo Nota",/*Picture*/, TamSX3("F1_ESPECIE")[1]   ,/*lPixel*/,{ || TRB->TPNOT   } )	//"Tipo"
	TRCell():New(_oSec1,"MUNIC"  ,"TRB","Municipio",/*Picture*/, TamSX3("A2_COD_MUN")[1]   ,/*lPixel*/,{ || TRB->MUNIC    } )	//"Tipo"
	TRCell():New(_oSec1,"EMISSAO","TRB",STR0028,/*Picture*/, TamSX3("E2_EMISSAO")[1]+2,/*lPixel*/,/*{ || TRB->EMISSAO }*/ )	//"Emissao"
	TRCell():New(_oSec1,"VENCTO" ,"TRB",STR0029,/*Picture*/, TamSX3("E2_VENCREA")[1]+2,/*lPixel*/,/*{ || TRB->VENCTO  }*/ )	//"Vencto"
	TRCell():New(_oSec1,"VALBASE","TRB",STR0030+STR0031,TM(0,15), 15,/*lPixel*/,/*{ || TRB->VALBASE }*/ )		//"Valor "##"Original"
	TRCell():New(_oSec1,"VALSEST","TRB",STR0030+STR0032,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"SEST"
	TRCell():New(_oSec1,"VALIRRF","TRB",STR0030+STR0033,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"IRRF"
	TRCell():New(_oSec1,"VALISS" ,"TRB",STR0030+STR0034,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"ISS"
	TRCell():New(_oSec1,"VALINSS","TRB",STR0030+STR0035,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"INSS"
	TRCell():New(_oSec1,"VALPIS" ,"TRB",STR0030+STR0036,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"PIS"
	TRCell():New(_oSec1,"VALCOF" ,"TRB",STR0030+STR0037,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"COFINS"
	TRCell():New(_oSec1,"VALCSLL","TRB",STR0030+STR0038,TM(0,15), 15,/*lPixel*/,/*{ || }*/ )	//"Valor "##"CSLL"
	TRCell():New(_oSec1,"VALLIQ" ,"TRB",STR0030+STR0039,TM(0,15), 15,/*lPixel*/,/*{ || If (!lPccBaixa .or. !lContrRet, TRB->VALLIQ, TRB->(VALLIQ-VALPIS-VALCOF-VALCSLL) ) }*/ )	//"Valor "##"Liquido"
	TRCell():New(_oSec1,"TIPORET",""   ,Substr(STR0017,1,1)+Substr(STR0018,1,1)+Substr(STR0019,1,1),/*Picture*/, 01 ,/*lPixel*/,/*CodeBlock*/)

	//	_oSec1:Cell("CGC"):SetPicture(IIF(Len(Alltrim(TRB->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99"))
	_oSec1:Init()
	_oSec1:SetHeaderSection(.T.)

	DbSelectArea("TRB")
	TRB->(dbGoTop())
	_oReport:SetMeter(TRB->(RecCount()))
	While TRB->(!Eof())
		If _oReport:Cancel()
			Return()
		EndIf

		_oReport:IncMeter()

		_oSec1:Cell("CODIGO"):SetValue(TRB->CODIGO  )		//"Codigo"
		_oSec1:Cell("LOJA"):SetValue(TRB->LOJA 	  )		//"Loja"
		_oSec1:Cell("NOMEFOR"):SetValue(TRB->NOMEFOR )		//"Fornecedor"
		_oSec1:Cell("CGC"):SetValue(If(!Empty(TRB->CGC), TRB->CGC, ) )	//"CGC"
		_oSec1:Cell("PRF"):SetValue(TRB->PREFIXO  )	//"Prf"
		_oSec1:Cell("NUM"):SetValue(TRB->NUM      )	//"Numero"
		_oSec1:Cell("PARCELA"):SetValue(TRB->PARCELA  )	//"Pc"
		_oSec1:Cell("TIPO"):SetValue(TRB->TIPO     )	//"Tipo"
		_oSec1:Cell("TPNOT"):SetValue(TRB->TPNOT    )	//"Tipo"
		_oSec1:Cell("MUNIC"):SetValue(TRB->MUNIC     )	//"Tipo"
		_oSec1:Cell("EMISSAO"):SetValue(TRB->EMISSAO  )	//"Emissao"
		_oSec1:Cell("VENCTO"):SetValue(TRB->VENCTO   )	//"Vencto"
		_oSec1:Cell("VALBASE"):SetValue(TRB->VALBASE  )		//"Valor "##"Original"
		_oSec1:Cell("VALSEST"):SetValue(TRB->VALSEST )
		_oSec1:Cell("VALIRRF"):SetValue(TRB->VALIRRF)
		_oSec1:Cell("VALISS"):SetValue(TRB->VALISS)
		_oSec1:Cell("VALINSS"):SetValue(TRB->VALINSS)
		_oSec1:Cell("VALPIS"):SetValue(TRB->VALPIS)
		_oSec1:Cell("VALCOF"):SetValue(TRB->VALCOF)
		_oSec1:Cell("VALCSLL"):SetValue(TRB->VALCSLL)
		_oSec1:Cell("VALLIQ"):SetValue(TRB->VALLIQ)

		_oSec1:PrintLine()

		dbSelectArea("TRB")
		TRB->(dbSkip())
	EndDo

	_oSec1:Finish()

	TRB->(dbCloseArea())

Return()

Static Function _FTabTRB()

	Local _aCampos		:= {}
	Local _oTMPTable

	aCampos	:= {{"CODIGO"	,"C",TamSX3("A2_COD")[1]	,0 },;
	{"LOJA"	    ,"C",02						,0 },;
	{"NOMEFOR"	,"C",40						,0 },;
	{"CGC"		,"C",14						,0 },;  
	{"FILIAL"   ,"C",TamSX3("E2_FILIAL")[1]	,0 },;
	{"PREFIXO"	,"C",03						,0 },;
	{"NUM"		,"C",TAMSX3("E2_NUM")[1]	,0 },;
	{"PARCELA"	,"C",TamSx3("E2_PARCELA")[1],0 },;
	{"TIPO"		,"C",03						,0 },;
	{"EMISSAO"	,"D",08						,0 },;
	{"VENCTO"	,"D",08						,0 },;
	{"VALBASE"  ,"N",17						,2 },;
	{"VALINSS"	,"N",17						,2 },;
	{"VALPIS"	,"N",17						,2 },;
	{"VALCOF"	,"N",17						,2 },;
	{"VALCSLL"	,"N",17						,2 },;
	{"VALIRRF"	,"N",17						,2 },;
	{"VALISS"	,"N",17						,2 },;
	{"VALSEST"	,"N",17						,2 },;
	{"VALLIQ"	,"N",17						,2 },;
	{"VRETPIS"	,"N",17						,2 },;
	{"VRETCOF"	,"N",17						,2 },;
	{"VRETCSL"	,"N",17						,2 },;
	{"PRETPIS"	,"C",01						,0 },;
	{"PRETCOF"	,"C",01						,0 },;
	{"PRETCSL"	,"C",01						,0 },; 
	{"PRETIRF"	,"C",01						,0 },; 
	{"TRETISS"	,"C",01						,0 },;
	{"FATURA"	,"C",TamSx3("E2_FATURA")[1]	,0 },; 
	{"PARCISS"  ,"C",TamSX3("E2_PARCPIS")[1],0 },;
	{"PARCINS"  ,"C",TamSX3("E2_PARCINS")[1],0 },;
	{"PARCIR"   ,"C",TamSX3("E2_PARCIR")[1]	,0 },;
	{"PARCPIS"  ,"C",TamSX3("E2_PARCPIS")[1],0 },;
	{"PARCCOF"  ,"C",TamSX3("E2_PARCCOF")[1],0 },;
	{"PARCSLL"  ,"C",TamSX3("E2_PARCSLL")[1],0 },;
	{"PARCSES"  ,"C",TamSX3("E2_PARCSES")[1],0 },;
	{"NATUREZ"  ,"C",TamSX3("E2_NATUREZ")[1],0 },;
	{"FILORI"   ,"C",TamSX3("E2_FILIAL")[1]	,0 },;
	{"MUNIC"   	,"C",TamSX3("A2_COD_MUN")[1],0 },;
	{"TPNOT"   	,"C",TamSX3("F1_ESPECIE")[1],0 }}

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 13/09/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	cArqTrab := CriaTrab( aCampos )
	dbUseArea( .T.,, cArqTrab, "TRB", if(.F. .OR. .F., !.F., NIL), .F. )
	*/

	_oTMPTable:= FwTemporaryTable():New("TRB" )
	_oTMPTable:SetFields( aCampos )
	_oTMPTable:Create()	

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

Return()


Static Function _FGrvTRB(_oSec1,aCodRet)

	Local _cSql			:= ""
	Local clTmp			:= ""
	Local cQuery		:= ""
	Local _cAlias2		:= GetNextAlias()

	Local lContrRet 	:= !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
	!Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
	!Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )
	Local lContRetIRF	:= !Empty(SE2->(FieldPos("E2_VRETIRF"))) .AND. !Empty(SE2->(FieldPos("E2_PRETIRF")))
	Local lCalcIssBx 	:=	!Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. ;
	!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2" //Retencao do ISS pela emissao (1) ou baixa (2)
	Local lConsFil		:= ( mv_par11 == 1 )	// Considera Filiais
	Local cTipoForn		:= Iif( mv_par10 == 1, "F", Iif( mv_par10 == 2, "J", "" ) )	// Tipo de Fornecedor
	Local cFilterUser 	:= _oSec1:GetSqlExp("SE2")
	Local nRegSM0		:= SM0->(Recno())
	Local lSE2Comp		:= Empty(FwFilial("SE2"))
	Local nValBase		:= 0
	Local nValLiq		:= 0
	Local lDedInss		:= .T.

	cFilterSE2 := cFilterUser

	If mv_par14 == 1
		//		If AdmSelctGC() .and. lGestao
		//			aSelFil := FwSelectGC()
		//		Else
		aSelFil := AdmGetFil(.F.,.F.,"SE2")
		//		Endif
	Endif
	If Empty(aSelFil)
		aSelFil := {cFilAnt}
	Endif

	lConsFil := .T.

	SM0->(DbGoTo(nRegSM0))

	aSM0 := FR865AbreSM0(aSelFil)

	If Len(aSM0) > 1
		lMultFil := .T.
	Else
		lMultFil := .F.	
	Endif

	lFilCRet := ( Len( aCodRet ) > 0 )

	cFilDe  := aSelFil[1]
	cFilAte := aSelFil[Len(aSelFil)]

	cQuery := "SELECT A2_COD CODIGO,A2_LOJA LOJA,A2_NOME NOMEFOR,A2_CGC CGC, E2_FILIAL FILIAL, E2_PREFIXO PREFIXO, A2_COD_MUN MUNIC, "
	cQuery += "E2_NUM NUM,E2_PARCELA PARCELA,E2_TIPO TIPO,E2_EMISSAO EMISSAO,E2_VENCREA VENCTO,"
	cQuery += "E2_IRRF VALIRRF,"
	cQuery += "E2_ISS VALISS,E2_INSS VALINSS,E2_FATURA FATURA,E2_NATUREZ NATUREZ, "
	cQuery += "E2_PIS VALPIS,E2_COFINS VALCOF,E2_CSLL VALCSLL, E2_FILORIG FILORIG,"

	//Se controla Retencao
	If lContrRet
		cQuery += "E2_VRETPIS VRETPIS,E2_VRETCOF VRETCOF,E2_VRETCSL VRETCSL,"	
		cQuery += "E2_PRETPIS PRETPIS,E2_PRETCOF PRETCOF,E2_PRETCSL PRETCSL,"	
		cQuery += "(E2_VALOR) VALBASE,"
		cQuery += "E2_SEST VALSEST,"	
	Else
		cQuery += "(E2_VALOR) VALBASE,"
		cQuery += "E2_SEST VALSEST,"
	Endif		

	If lContRetIRF
		cQuery += "E2_VRETIRF VRETIRF, E2_PRETIRF PRETIRF, "
	Endif			

	IF lCalcIssBx
		cQuery += "E2_TRETISS TRETISS,"
	Endif

	cQuery += "E2_VALOR VALLIQ, E2_PARCISS PARCISS, E2_PARCINS PARCINS, E2_PARCIR PARCIR, "
	cQuery += "E2_PARCPIS PARCPIS, E2_PARCCOF PARCCOF, E2_PARCSLL PARCSLL, E2_PARCSES PARCSES, F1_ESPECIE TPNOT, ED_DEDINSS DEDINSS "

	cQuery += "FROM " + RetSqlName("SA2")+" SA2, " + RetSqlName("SE2")+" SE2, " + RetSqlName("SF1") + " SF1, " + RetSqlName("SED") + " SED "
	cQuery += " WHERE SA2.A2_FILIAL = '" + xFilial("SA2") + "' "
	cQuery += " AND SA2.A2_COD  BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += " AND SA2.A2_LOJA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"
	If !Empty( cTipoForn )
		cQuery += " AND SA2.A2_TIPO = '" + cTipoForn + "' "
	EndIf	
	If !Empty(MV_PAR15)
		cQuery += " AND SA2.A2_COD_MUN = '" + Alltrim(MV_PAR15) + "' "
	EndIf
	cQuery += " AND SA2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SE2.E2_FILIAL = '" + xFilial("SE2") + "'"
	cQuery += " AND SE2.E2_FORNECE = SA2.A2_COD"
	cQuery += " AND SE2.E2_LOJA	= SA2.A2_LOJA"
	cQuery += " AND SE2.E2_EMISSAO  <= '" + DTOS(dDataBase) + "'"
	cQuery += " AND (SE2.E2_INSS > 0 "
	cQuery += " OR SE2.E2_ISS > 0 "
	cQuery += " OR SE2.E2_PIS > 0 "
	cQuery += " OR SE2.E2_COFINS > 0 "
	cQuery += " OR SE2.E2_CSLL > 0 "
	cQuery += " OR SE2.E2_SEST > 0 "  

	If lContRetIRF
		cQuery += " OR (SE2.E2_IRRF > 0 OR (SE2.E2_VRETIRF > 0 AND SE2.E2_PRETIRF <> '1' ))) "
	Else 
		cQuery += " OR SE2.E2_IRRF = 0 ) "		
	Endif
	cQuery += " AND SE2.E2_VENCREA  between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
	cQuery += " AND SE2.E2_EMISSAO  between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
	cQuery += " AND SE2.E2_EMISSAO  <= '"      + DTOS(dDataBase) + "'"		

	// Se considera filiais e SE2 estah compartilhado, realiza filtro por filial origem
	If lConsFil .And. lSE2Comp
		cQuery += " AND SE2.E2_FILORIG BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' "
	EndIf
	If !Empty(cFilterSE2)
		cQuery += " AND " + cFilterSE2
	EndIf

	cQuery += " AND SE2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SF1.F1_FILIAL = SE2.E2_FILORIG "
	cQuery += " AND SF1.F1_DOC = SE2.E2_NUM "
	cQuery += " AND SF1.F1_SERIE = SE2.E2_PREFIXO "
	cQuery += " AND SF1.F1_FORNECE = SE2.E2_FORNECE "
	cQuery += " AND SF1.F1_LOJA = SE2.E2_LOJA "
	//Celso Rondinelli - acrescentei filtro por data de digitacao F1_DTDIGIT
	cQuery += " AND SF1.F1_DTDIGIT between '" + DTOS(mv_par16)  + "' AND '" + DTOS(mv_par17) + "'"
	//***********************************************************************
	cQuery += " AND SF1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SED.ED_FILIAL = '" + xFilial("SED") + "' "
	cQuery += " AND SED.ED_CODIGO = SE2.E2_NATUREZ "
	cQuery += " AND SED.D_E_L_E_T_ = ' ' "

	cQuery += " ORDER BY FILIAL,CODIGO,LOJA"
	cQuery := ChangeQuery(cQuery)

	TcQuery cQuery New Alias (_cAlias2)

	If (_cAlias2)->(!EOF())
		While (_cAlias2)->(!EOF())

			If	lContrRet
				nValBase := (_cAlias2)->(VALBASE+VALIRRF+VALISS)+IF(((_cAlias2)->DEDINSS=="1"),(_cAlias2)->VALINSS,0)
				nValLiq := (_cAlias2)->VALBASE	
				If (Empty((_cAlias2)->PRETPIS) .OR. Empty((_cAlias2)->PRETCOF) .OR. Empty((_cAlias2)->PRETCSL)) .AND. ((_cAlias2)->VALPIS+(_cAlias2)->VALCOF+(_cAlias2)->VALCSLL) > 0
					//PCC retido na emissao nele mesmo, somar para compor o valor original.
					nValBase += (_cAlias2)->VALPIS+(_cAlias2)->VALCOF+(_cAlias2)->VALCSLL
				Else
					//PCC retido na baixa ou na emissao nao nele mesmo, ou seja, o E2_VALOR nao sofreu abatimento, entao abater o PCC para obter o liquido
					nValLiq -= (_cAlias2)->VALPIS+(_cAlias2)->VALCOF+(_cAlias2)->VALCSLL
				Endif
			Else
				nValBase := (_cAlias2)->(VALBASE+VALIRRF+VALISS+VALPIS+VALCOF+VALCSLL)+IF(((_cAlias2)->DEDINSS=="1"),(_cAlias2)->VALINSS,0)
				nValLiq := (_cAlias2)->VALBASE
			EndIf
			nValBase += (_cAlias2)->VALSEST

			dbSelectArea("TRB")
			If RecLock("TRB",.T.)	
				TRB->CODIGO		:= (_cAlias2)->CODIGO
				TRB->LOJA		:= (_cAlias2)->LOJA
				TRB->NOMEFOR	:= (_cAlias2)->NOMEFOR
				TRB->CGC		:= (_cAlias2)->CGC
				TRB->FILIAL  	:= (_cAlias2)->FILIAL
				TRB->PREFIXO	:= (_cAlias2)->PREFIXO
				TRB->NUM		:= (_cAlias2)->NUM
				TRB->PARCELA	:= (_cAlias2)->PARCELA
				TRB->TIPO		:= (_cAlias2)->TIPO
				TRB->EMISSAO	:= StoD((_cAlias2)->EMISSAO)
				TRB->VENCTO		:= StoD((_cAlias2)->VENCTO)
				TRB->VALBASE	:= nValBase
				TRB->VALINSS	:= (_cAlias2)->VALINSS
				TRB->VALPIS		:= (_cAlias2)->VALPIS
				TRB->VALCOF		:= (_cAlias2)->VALCOF
				TRB->VALCSLL	:= (_cAlias2)->VALCSLL 
				TRB->VALIRRF	:= (_cAlias2)->VALIRRF
				TRB->VALISS		:= (_cAlias2)->VALISS       
				TRB->FATURA		:= (_cAlias2)->FATURA
				IF lCalcIssBx
					TRB->TRETISS	:= (_cAlias2)->TRETISS 			
				EndIf
				TRB->PARCISS	:= (_cAlias2)->PARCISS
				TRB->PARCINS	:= (_cAlias2)->PARCINS
				TRB->PARCIR		:= (_cAlias2)->PARCIR
				TRB->PARCPIS	:= (_cAlias2)->PARCPIS
				TRB->PARCCOF	:= (_cAlias2)->PARCCOF
				TRB->PARCSLL	:= (_cAlias2)->PARCSLL
				TRB->PARCSES	:= (_cAlias2)->PARCSES
				TRB->NATUREZ	:= (_cAlias2)->NATUREZ
				TRB->VALSEST	:= (_cAlias2)->VALSEST  
				TRB->VALLIQ		:= nValLiq
				TRB->FILORI		:= (_cAlias2)->FILORIG
				TRB->MUNIC		:= (_cAlias2)->MUNIC
				TRB->TPNOT		:= (_cAlias2)->TPNOT
				//Se controla retencao
				If lContrRet
					TRB->VRETPIS	:= (_cAlias2)->VRETPIS
					TRB->VRETCOF	:= (_cAlias2)->VRETCOF
					TRB->VRETCSL	:= (_cAlias2)->VRETCSL 
					TRB->PRETPIS	:= (_cAlias2)->PRETPIS
					TRB->PRETCOF	:= (_cAlias2)->PRETCOF
					TRB->PRETCSL	:= (_cAlias2)->PRETCSL 
				Endif			

				MSUnlock()
			Endif
			(_cAlias2)->(dbSkip())
		EndDo
	EndIf

	(_cAlias2)->(dbCloseArea())
Return()

Static Function FR865AbreSM0(aSelFil)               

	Local aArea			:= SM0->( GetArea() )
	Local aRetSM0		:= {}
	Local nLaco			:= 0

	aRetSM0	:= FWLoadSM0()

	If Len(aRetSM0) != Len(aSelFil)

		For nLaco := Len(aRetSM0) To 1 Step -1
			cFilx := aRetSm0[nLaco,SM0_CODFIL]
			nPosFil := Ascan(aSelFil,aRetSm0[nLaco,SM0_CODFIL])

			If nPosFil == 0 .Or. cEmpAnt != aRetSM0[nLaco,SM0_GRPEMP]
				ADel(aRetSM0,nLaco)
				aSize(aRetSM0, Len(aRetSM0)-1)
			Endif
		Next
	Endif

	aSort(aRetSm0,,,{ |x,y| x[SM0_CODFIL] < y[SM0_CODFIL] } )
	RestArea( aArea )

Return aClone(aRetSM0)

Static Function FR865CodRet( aCodRet )

	Local aArea		:= GetArea()
	Local cTitulo	:= ""                     
	Local lRet		:= .T.
	Local cTabela	:= "37"		// Tabela 37 - Codigos de retencao
	Local aBox		:= {}                        
	Local nTam		:= TamSX3("E2_CODRET")[1]
	Local aContent	:= FWGetSX5("00",cTabela,)
	Local _nI

	Local MvParDef	:= ""
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 13/09/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	// Posiciona na Tabela 37 para buscar a descricao da tabela do SX5
	If SX5->( MsSeek( xFilial("SX5") + "00" + cTabela ) )
		cTitulo := SX5->( Alltrim( Left( X5Descri(), 20 ) ) )
	EndIf

	// Monta opcoes para selecao de acordo com os itens da tabela do SX5
	If SX5->( MsSeek( xFilial("SX5") + cTabela ) )
		Do While SX5->( !Eof() .And. X5_TABELA == cTabela )
			AAdd( aBox, AllTrim( SX5->X5_CHAVE ) + " - " + Alltrim( SX5->( X5Descri() ) ) )
			MvParDef += AllTrim( SX5->X5_CHAVE )
			SX5->( dbSkip() )
		EndDo
	EndIf
	*/
	
	// Posiciona na Tabela 37 para buscar a descricao da tabela do SX5
	If ! Empty(aContent[01][04]) 
		cTitulo := aContent[01][04]
	Endif
	
	// Monta opcoes para selecao de acordo com os itens da tabela do SX5
	For _nI := 1 To Len(aContent)
		AAdd( aBox, AllTrim( aContent[_nI][03] ) + " - " + Alltrim( aContent[_nI][04] ))
		MvParDef += AllTrim( aContent[_nI][03] )	
	Next _nI
	
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	Do While lRet

		lRet := f_Opcoes(	@aCodRet,;		// uVarRet
		cTitulo,;		// cTitulo
		@aBox,;			// aOpcoes
		MvParDef,;		// cOpcoes
		,;				// nLin1
		,;				// nCol1
		,;				// l1Elem
		nTam,; 			// nTam
		Len( aBox ),;	// nElemRet
		,;				// lMultSelect
		,;				// lComboBox
		,;				// cCampo
		,;				// lNotOrdena
		,;				// NotPesq
		.T.,;			// ForceRetArr
		)				// F3

		If lRet .And. Len( aCodRet ) == 0
			// Quando for informado "Sim" na pergunta "Filtra Códigos de Retenção?", deve ser selecionado ao menos um código de retenção.
			MsgInfo( STR0043 ) 
		Else
			dbSkip()
		EndIf

	EndDo

	RestArea( aArea )

Return lRet
