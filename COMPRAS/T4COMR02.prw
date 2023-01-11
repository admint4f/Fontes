#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  T4COMR02     บAutor  ณGiovani Zago    บ Data ณ  01/10/13     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Relatorio de Cadastro de Al็ada                           บฑฑ
ฑฑบ          ณ  Plcom08                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------*
User Function T4COMR02()
*--------------------------*

	Local   oReport

	Private cPerg 			:= "T4RCO2"
	Private cTime         	:= Time()
	Private cHora         	:= SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSx1( cPerg, "01","Aprovador  de:"    ,"","","mv_ch1","C",6,0,0,"G","","SAK","","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Aprovador At้:"    ,"","","mv_ch2","C",6,0,0,"G","","SAK","","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","C/C  de:"          ,"","","mv_ch3","C",9,0,0,"G","","CTT","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "04","C/C At้:"          ,"","","mv_ch4","C",9,0,0,"G","","CTT","","","mv_par04","","","","","","","","","","","","","","","","")
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	oReport		:= ReportDef()
	oReport:PrintDialog()

	Return


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ReportDef    บAutor  ณGiovani Zago    บ Data ณ  01/10/13     บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ  Relatorio de Cadastro de Al็ada                           บฑฑ
	ฑฑบ          ณ  Plcom08                                                   บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*--------------------------*
Static Function ReportDef()
	*--------------------------*

	Local oReport
	Local oSection

	oReport := TReport():New(cPerg,"RELATำRIO Cadastro de Al็ada",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irแ imprimir um relat๓rio de Cadastro de Al็ada .")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Cadastro de Al็ada",{"SC5"})

	TRCell():New(oSection,'CCusto'		,,'CCusto' 		,,09,.F.,)
	TRCell():New(oSection,"Desc_CCusto"	,,"Desc_CCusto"	,,40,.F.,)
	TRCell():New(oSection,"Grupo"   	,,"Grupo"		,,06,.F.,)
	TRCell():New(oSection,"Desc_Grupo"	,,"Desc_Grupo"	,,15,.F.,)
	TRCell():New(oSection,"Aprovador"	,,"Aprovador"	,,06,.F.,)
	TRCell():New(oSection,"Nome"		,,"Nome"		,,25,.F.,)
	TRCell():New(oSection,"Nivel"		,,"Nivel"		,,03,.F.,)
	TRCell():New(oSection,"Tipo_Apr"	,,"Tipo_Apr"	,,09,.F.,)
	TRCell():New(oSection,"Auto_Limite"	,,"Auto_Limite"	,,02,.F.,)
	TRCell():New(oSection,"Tipo"		,,"Tipo"		,,07,.F.,)
	TRCell():New(oSection,"Val_Minimo" 	,,"Val_Minimo"	,"@E 999,999,999.99",15)
	TRCell():New(oSection,"Val_Maximo" 	,,"Val_Maximo"	,"@E 999,999,999.99",15)
	TRCell():New(oSection,"Limite"		,,"Limite"	    ,"@E 999,999,999.99",15)
	TRCell():New(oSection,"Tipo_Limite"	,,"Tipo_Limite"	,,07,.F.,)

	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("DA1")

	Return oReport


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  ReportPrint  บAutor  ณGiovani Zago    บ Data ณ  01/10/13     บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ  Relatorio de Cadastro de Al็ada                           บฑฑ
	ฑฑบ          ณ  Plcom08                                                   บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------------*
Static Function ReportPrint(oReport)
	*-----------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local aDados[2]
	Local aDados1[14]



	oSection1:Cell('CCusto')    	:SetBlock( { || aDados1[01] } )
	oSection1:Cell("Desc_CCusto")	:SetBlock( { || aDados1[02] } )
	oSection1:Cell("Grupo")			:SetBlock( { || aDados1[03] } )
	oSection1:Cell("Desc_Grupo")	:SetBlock( { || aDados1[04] } )
	oSection1:Cell("Aprovador")		:SetBlock( { || aDados1[05] } )
	oSection1:Cell("Nome")			:SetBlock( { || aDados1[06] } )
	oSection1:Cell("Nivel")			:SetBlock( { || aDados1[07] } )
	oSection1:Cell("Tipo_Apr")		:SetBlock( { || aDados1[08] } )
	oSection1:Cell("Auto_Limite")	:SetBlock( { || aDados1[09] } )
	oSection1:Cell("Tipo")   		:SetBlock( { || aDados1[10] } )
	oSection1:Cell("Val_Minimo")	:SetBlock( { || aDados1[11] } )
	oSection1:Cell("Val_Maximo")	:SetBlock( { || aDados1[12] } )
	oSection1:Cell("Limite")		:SetBlock( { || aDados1[13] } )
	oSection1:Cell("Tipo_Limite")	:SetBlock( { || aDados1[14] } )



	oReport:SetTitle("Cadastro de Al็ada")// Titulo do relat๓rio

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	rptstatus({|| strelquer( ) },"Compondo Relatorio")


	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->CTT_CUSTO
			aDados1[02]	:=	(cAliasLif)->CTT_DESC01
			aDados1[03]	:=	(cAliasLif)->AL_COD
			aDados1[04]	:=	(cAliasLif)->AL_DESC
			aDados1[05]	:=	(cAliasLif)->AL_APROV
			aDados1[06]	:= 	(cAliasLif)->AL_NOME
			aDados1[07]	:=	(cAliasLif)->AL_NIVEL
			aDados1[08]	:=	IIF((cAliasLif)->AL_LIBAPR  = 'A','Aprovador','Visto')                                                                                                             
			aDados1[09]	:=	IIF((cAliasLif)->AL_AUTOLIM = 'S','SIM','NรO')    
			aDados1[10]	:=  IIF((cAliasLif)->AL_TPLIBER = 'U','Usuario', IIF((cAliasLif)->AL_TPLIBER = 'N','Nivel','Pedido'))                                                                                                       
			aDados1[11]	:=	(cAliasLif)->AK_LIMMIN
			aDados1[12]	:= 	(cAliasLif)->AK_LIMMAX
			aDados1[13]	:=	(cAliasLif)->AK_LIMITE
			aDados1[14]	:= 	IIF((cAliasLif)->AK_TIPO = 'D','Diario', IIF((cAliasLif)->AK_TIPO = 'S','Semanal','Mensal'))                                                                                                     

			oSection1:PrintLine()
			aFill(aDados1,nil)


			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()




	Return oReport

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
	ฑฑบPrograma  STRELQUER    บAutor  ณGiovani Zago    บ Data ณ  01/10/13     บฑฑ
	ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
	ฑฑบDesc.     ณ  Relatorio de Cadastro de Al็ada                           บฑฑ
	ฑฑบ          ณ  Plcom08                                                   บฑฑ
	ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
	ฑฑบUso       ณ AP                                                         บฑฑ
	ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
	ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
	฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
	*/
	*-----------------------------------*
Static Function STRELQUER()
	*-----------------------------------*
	Local cQuery     := ' '

	/*
	cQuery := " SELECT
	cQuery += " CTT_CUSTO  ,CTT_DESC01 ,AL_COD,AL_DESC,AL_APROV,AL_NOME,AL_NIVEL ,AL_LIBAPR ,AL_AUTOLIM , AL_TPLIBER, AK_LIMMIN  ,AK_LIMMAX ,AK_LIMITE , AK_TIPO
	cQuery += " FROM
	cQuery += " "+RetSqlName("SAK")+"  SAK "
	cQuery += "  INNER JOIN ( SELECT * FROM "+RetSqlName("SAL")+"  )SAL "
	cQuery += " ON    SAL.AL_APROV   = SAK.AK_COD
	cQuery += " AND   SAL.AL_FILIAL  = '"+xFilial("SAL")+"'"
	cQuery += " AND   SAL.D_E_L_E_T_ = ' '

	cQuery += " INNER JOIN ( SELECT * FROM "+RetSqlName("CTT")+"  )CTT "
	cQuery += " ON    CTT.D_E_L_E_T_ = ' '
	cQuery += " AND   CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"
	cQuery += " AND   CTT.CTT_XGRAPR = SAL.AL_COD
	cQuery += " AND   CTT.CTT_CUSTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'
	cQuery += " AND   CTT.CTT_BLOQ <> '1' 

	cQuery += " WHERE SAK.D_E_L_E_T_ = ' '
	cQuery += " AND   SAK.AK_FILIAL  = '"+xFilial("SAK")+"'"
	cQuery += " AND   SAK.AK_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' 

	//cQuery += " ORDER BY SAK.AK_COD 
	cQuery += " ORDER BY CTT.CTT_CUSTO, SAL.AL_COD, SAL.AL_NIVEL 
	*/  
	cQuery := " SELECT
	cQuery += " CTT_CUSTO  ,CTT_DESC01 ,AL_COD,AL_DESC,AL_APROV,AL_NOME,AL_NIVEL ,AL_LIBAPR ,AL_AUTOLIM , AL_TPLIBER, AK_LIMMIN  ,AK_LIMMAX ,AK_LIMITE , AK_TIPO
	cQuery += " FROM          
	cQuery += " "+RetSqlName("CTT")+"  CTT "   

	cQuery += " LEFT JOIN ( SELECT * FROM "+RetSqlName("SAL")+"  )SAL "
	cQuery += " ON    SAL.AL_FILIAL  = '"+xFilial("SAL")+"'"  
	cQuery += " AND   SAL.AL_COD = CTT.CTT_XGRAPR 
	cQuery += " AND   SAL.D_E_L_E_T_ = ' '

	cQuery += " LEFT JOIN ( SELECT * FROM "+ RetSqlName("SAK")+" )SAK "  
	cQuery += " ON   SAK.AK_FILIAL  = '"+xFilial("SAK")+"'"
	cQuery += " AND  SAK.AK_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' 
	cQuery += " AND  SAL.AL_APROV   = SAK.AK_COD
	cQuery += " AND  SAK.D_E_L_E_T_ = ' '

	cQuery += " WHERE CTT.CTT_FILIAL = '"+xFilial("CTT")+"'"
	cQuery += " AND   CTT.CTT_CUSTO BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'
	cQuery += " AND   CTT.CTT_BLOQ <> '1' AND CTT.CTT_CLASSE <> '1' AND CTT.D_E_L_E_T_ = ' '

	cQuery += " ORDER BY CTT.CTT_CUSTO, SAL.AL_COD, SAL.AL_NIVEL 

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


