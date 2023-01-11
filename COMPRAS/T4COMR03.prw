#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  T4COMR03     ºAutor  ³Giovani Zago    º Data ³  03/10/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Relatorio de Solicitaçoes em aberto                       º±±
±±º          ³  PlWF01                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function T4COMR03()
*--------------------------*

	Local   oReport
	Private cPerg 			:= "T4RCO3"
	Private cTime           := Time()
	Private cHora           := SUBSTR(cTime, 1, 2)
	Private cMinutos    	:= SUBSTR(cTime, 4, 2)
	Private cSegundos   	:= SUBSTR(cTime, 7, 2)
	Private cAliasLif   	:= cPerg+cHora+ cMinutos+cSegundos

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	PutSx1( cPerg, "01","Dt.Emissão SC De :"    ,"","","mv_ch1","D",8,0,0,"G","",""      ,"","","mv_par01","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "02","Dt.Emissão SC até:"    ,"","","mv_ch2","D",8,0,0,"G","",""      ,"","","mv_par02","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "03","Solicitante De	:"      ,"","","mv_ch3","C",6,0,0,"G","","SAI_01","","","mv_par03","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "04","Solicitante Até:"      ,"","","mv_ch4","C",6,0,0,"G","","SAI_01","","","mv_par04","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "05","Comprador De	:"      ,"","","mv_ch5","C",6,0,0,"G","","SY1"   ,"","","mv_par05","","","","","","","","","","","","","","","","")
	PutSx1( cPerg, "06","Comprador Até:"        ,"","","mv_ch6","C",6,0,0,"G","","SY1"   ,"","","mv_par06","","","","","","","","","","","","","","","","")

	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	oReport		:= ReportDef()
	oReport:PrintDialog()

	Return

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ReportDef    ºAutor  ³Giovani Zago    º Data ³  01/10/13     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³  Relatorio de Solicitações em Aberto                       º±±
	±±º          ³  Plcom08                                                   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	*--------------------------*
Static Function ReportDef()
	*--------------------------*

	Local oReport
	Local oSection

	oReport := TReport():New(cPerg,"RELATÓRIO Solicitações em Aberto",cPerg,{|oReport| ReportPrint(oReport)},"Este programa irá imprimir um relatório de Solicitações em Aberto .")

	Pergunte(cPerg,.F.)

	oSection := TRSection():New(oReport,"Solicitações em Aberto",{"SC1"})

	TRCell():New(oSection,'Num_SC'		,,'Num_SC' 		,,06,.F.,)
	TRCell():New(oSection,"Comprador"	,,"Comprador"	,,3,.F.,)
	TRCell():New(oSection,"Nome_Com"	,,"Nome_Com"	,,30,.F.,)
	TRCell():New(oSection,"Solicitante" ,,"Solicitante"	,,06,.F.,)
	TRCell():New(oSection,"Nome_Sol"	,,"Nome_Sol"	,,15,.F.,)
	TRCell():New(oSection,"Emissao"		,,"Emissao"		,,11,.F.,)
	TRCell():New(oSection,"Produto"		,,"Produto"		,,15,.F.,)
	TRCell():New(oSection,"Descricao"	,,"Descricao"	,,40,.F.,)
	TRCell():New(oSection,"Quantidade"	,,"Quantidade"	,"@E 999,999,999.99",15)
	TRCell():New(oSection,"Valor"		,,"Valor"		,"@E 999,999,999.99",15)
	TRCell():New(oSection,"Necessidade"	,,"Necessidade"	,,11,.F.,)
	TRCell():New(oSection,"Divisao"		,,"Divisao"		,,20,.F.,)
	TRCell():New(oSection,"Fil.Entrega"	,,"Fil.Entrega"	,,02,.F.,)


	oSection:SetHeaderSection(.t.)
	oSection:Setnofilter("DA1")

	Return oReport


	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ReportPrint  ºAutor  ³Giovani Zago    º Data ³  01/10/13     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³  Relatorio de Solicitações em Aberto                       º±±
	±±º          ³  Plcom08                                                   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	*-----------------------------------*
Static Function ReportPrint(oReport)
	*-----------------------------------*
	Local oSection	:= oReport:Section(1)
	Local oSection1	:= oReport:Section(1)
	Local _cUser	:= ""
	Local aDados[2]
	Local aDados1[13]


	oSection1:Cell('Num_SC')    		:SetBlock( { || aDados1[01] } )
	oSection1:Cell("Comprador")			:SetBlock( { || aDados1[02] } )
	oSection1:Cell("Nome_Com")			:SetBlock( { || aDados1[03] } )
	oSection1:Cell("Solicitante")		:SetBlock( { || aDados1[04] } )
	oSection1:Cell("Nome_Sol")			:SetBlock( { || aDados1[05] } )
	oSection1:Cell("Emissao")  			:SetBlock( { || aDados1[06] } )
	oSection1:Cell("Produto")			:SetBlock( { || aDados1[07] } )
	oSection1:Cell("Descricao")			:SetBlock( { || aDados1[08] } )
	oSection1:Cell("Quantidade")		:SetBlock( { || aDados1[09] } )
	oSection1:Cell("Valor")				:SetBlock( { || aDados1[10] } )
	oSection1:Cell("Necessidade")		:SetBlock( { || aDados1[11] } )
	oSection1:Cell("Divisao")			:SetBlock( { || aDados1[12] } )
	oSection1:Cell("Fil.Entrega")		:SetBlock( { || aDados1[13] } )

	oReport:SetTitle("Solicitações em Aberto")// Titulo do relatório

	oReport:SetMeter(0)
	aFill(aDados,nil)
	aFill(aDados1,nil)
	oSection:Init()

	rptstatus({|| strelquer( ) },"Compondo Relatorio")


	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0

		While 	(cAliasLif)->(!Eof())

			aDados1[01]	:=	(cAliasLif)->C1_NUM
			aDados1[02]	:=	(cAliasLif)->C1_CODCOMP
			aDados1[03]	:=	(cAliasLif)->Y1_NOME
			aDados1[04]	:=	(cAliasLif)->C1_USER
			
			//----------------------------------------------------------------------------------------------------------------------------------------
			// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
			//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
			//aDados1[05]	:=	UsrFullName( (cAliasLif)->C1_USER ) //(cAliasLif)->C1_SOLICIT
			
			aDados1[05]	:=	Substr((cAliasLif)->C1_SOLICIT,1,14)
			
			//{ Fim } --------------------------------------------------------------------------------------------------------------------------------			
			
			aDados1[06]	:=	(cAliasLif)->C1_EMISSAO
			aDados1[07]	:=	(cAliasLif)->C1_PRODUTO
			aDados1[08]	:= 	(cAliasLif)->C1_DESCRI
			aDados1[09]	:=	(cAliasLif)->C1_QUANT
			aDados1[10]	:=  (cAliasLif)->C1_TOTAL
			aDados1[11]	:=	(cAliasLif)->C1_DATPRF
			aDados1[12]	:=	(cAliasLif)->C1_CLVL
			aDados1[13]	:=	(cAliasLif)->C1_FILENT		

			oSection1:PrintLine()
			aFill(aDados1,nil)


			(cAliasLif)->(dbskip())

		End

	EndIf

	oReport:SkipLine()




	Return oReport

	/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  STRELQUER    ºAutor  ³Giovani Zago    º Data ³  01/10/13     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³  Relatorio de Cadastro de Alçada                           º±±
	±±º          ³  Plcom08                                                   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                         º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	*/
	*-----------------------------------*
Static Function STRELQUER()
	*-----------------------------------*
	Local cQuery     := ' '
	Local aEmpQry		:= {}

	aEmpQry:=T4FEmpresa()
	If Len(aEmpQry)  > 0

		For k:= 1 To Len(aEmpQry)
			If k > 1
				cQuery += " union"
			EndIf
			cQuery += " SELECT
			cQuery += " C1_NUM ,
			cQuery += " C1_CODCOMP ,
			cQuery += " NVL((SELECT Y1_NOME
			cQuery += " FROM  SY1"+aEmpQry[K,1]+"   SY1 "
			cQuery += " WHERE SY1.D_E_L_E_T_ = ' '
			//cQuery += " AND   SY1.Y1_FILIAL  = '"+xFilial("SY1")+"'"
			cQuery += " AND   SY1.Y1_COD  = SC1.C1_CODCOMP) ,' ')
			cQuery += " Y1_NOME  ,
			cQuery += " C1_USER  ,
			cQuery += " C1_SOLICIT  ,
			cQuery += " SUBSTR(SC1.C1_EMISSAO,7,2)||'/'|| SUBSTR(SC1.C1_EMISSAO,5,2)||'/'|| SUBSTR(SC1.C1_EMISSAO,1,4)
			cQuery += " C1_EMISSAO,
			cQuery += " C1_PRODUTO ,
			cQuery += " C1_DESCRI ,
			cQuery += " C1_QUANT ,
			cQuery += " C1_TOTAL ,
			cQuery += " SUBSTR(SC1.C1_DATPRF,7,2)||'/'|| SUBSTR(SC1.C1_DATPRF,5,2)||'/'|| SUBSTR(SC1.C1_DATPRF,1,4)
			cQuery += " C1_DATPRF  ,
			cQuery += " C1_CLVL,

			//Vitor
			cQuery += " NVL((SELECT Y1_USER
			cQuery += " FROM  SY1"+aEmpQry[K,1]+"   SY1 "
			cQuery += " WHERE SY1.D_E_L_E_T_ = ' '
			//cQuery += " AND   SY1.Y1_FILIAL  = '"+xFilial("SY1")+"'"
			cQuery += " AND   SY1.Y1_COD  = SC1.C1_CODCOMP) ,' ')
			cQuery += " Y1_USER,
			cQuery += " C1_FILENT "

			cQuery += " FROM
			cQuery += "  SC1"+aEmpQry[K,1]+"  SC1 "
			cQuery += " WHERE SC1.D_E_L_E_T_ = ' '
			cQuery += " AND   SC1.C1_QUJE = 0
			cQuery += " AND   SC1.C1_COTACAO = ''
			cQuery += " AND   SC1.C1_RESIDUO = ''
			cQuery += " AND   SC1.C1_XTPCPR = 'C'		
			//cQuery += " AND   SC1.C1_FILIAL  = '"+xFilial("SC1")+"'"
			cQuery += " AND   SC1.C1_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'
			cQuery += " AND   SC1.C1_USER    BETWEEN '"+mv_par03+"'        AND '"+mv_par04+"'
			cQuery += " AND   SC1.C1_CODCOMP BETWEEN '"+mv_par05+"' 	  AND '"+mv_par06+"'


		Next k

		cQuery += " ORDER BY Y1_USER, C1_CLVL, C1_FILENT, C1_NUM
	EndIf
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasLif) > 0
		(cAliasLif)->(dbCloseArea())
	EndIf

	dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()


Static Function T4FEmpresa()

	Local aEmpresa := {}
	Local cCodEmp := ""
	Local nRecSMO := SM0->( Recno() )

	SM0->( DbGoTop() )
	Do While SM0->( !EOF() )

		aadd(aEmpresa,{SM0->M0_CODIGO + "0",SM0->M0_CODFIL })

		SM0->( Dbskip() )

	EndDo

	SM0->(DbGoTo(nRecSMO))

Return(aEmpresa)


