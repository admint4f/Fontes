#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/{Protheus.doc} INTIB2B
description gera pedido de venda INTI
@type function
@version  
@author roger
@since 26/07/2021
@return variant, return_description
/*/
User function INTIB2B()

	Local 	aParamBox	:=	{}
	Local 	aRet		:=	{}
	Local	nPvGer

	Private cB1Cod     	:= ""
	Private cF4TES     	:= ""
	Private cE4Codigo  	:= ""
	Private	cNaturez	:= ""
	Private dDtIni
	Private	dDtFim
	Private oGrid
	Private aListCli := {}

	If cEmpAnt <> '33'
		FWAlertWarning("Rotina para uso exclusivo na empresa 33 - INTI ", "EMPRESA ERRADA")
		Return Nil
	EndIf

	aAdd(aParamBox,{1,"Data Inicial Vendas "  	,FirstDate(DDATABASE),"","","","",50,.F.}) // Tipo data
	aAdd(aParamBox,{1,"Data Final Vendas"  		,LastDate(DDATABASE),"","","","",50,.F.}) // Tipo data
	aAdd(aParamBox,{1,"Produto PV"      		,"2004034941    ","","","SB1","",50,.F.}) // Tipo c 2004034941
	aAdd(aParamBox,{1,"Natureza PV"  			,"100100    ","","","SED","",50,.F.}) // Tipo c 100100
	aAdd(aParamBox,{1,"TES PV"  				,"601","","","SF4","",50,.F.}) // Tipo c 618
	aAdd(aParamBox,{1,"Cond.Pagto PV"  			,"117","","","SE4","",50,.F.}) // Tipo c 117
	aAdd(aParamBox,{3,"Visualiza Pedidos Gerados? ",1,{"Sim","Não"},50,"",.F.})

	If !ParamBox(aParamBox, "Data de Vendas", aRet)
		Return Nil
	Else

		If (aRet[5] <= '499')

			FWAlertWarning("A TES informada é usada para entrada de documentos, escolha códigos acima de 499 !!!", "TES ERRADA")

			Return
		Else
			dDtIni		:=	aRet[1]
			dDtFim		:=	aRet[2]
			cB1Cod     	:= 	aRet[3]
			cNaturez	:= 	aRet[4]
			cF4TES     	:= 	aRet[5]
			cE4Codigo  	:= 	aRet[6]
			nPvGer		:=	aRet[7]
		EndIf
	EndIf

	FwMsgRun(NIL,{ |oSay| SELITEMS(dDtIni,dDtFim,nPvGer,oSay) }, "Geração de Pedido de Venda B2B|INTI", 'SELECIONANDO REGISTROS, AGUARDE.......')



Return


/*/{Protheus.doc} SELITEMS
description
@type function
@version  
@author roger
@since 26/07/2021
@param dDtIni, date, param_description
@param dDtFim, date, param_description
@return variant, return_description
/*/
Static Function SELITEMS(dDtIni,dDtFim,nPvGer,oSay)

	Local 	_aCores		:= {}
	Local 	cCadastro	:='SELEÇÃO DE ITENS PARA GERAÇÃO DE PEDIDOS'
	Local 	oDlg
	Local 	cQueryZAF	:= ""
	Local 	aObjects	:= {}
	Local 	aInfo		:= {}
	Local 	aPosObj		:= {}
	Local 	cFontUti  	:= "Tahoma"
	Local 	oFontSubN2	:= TFont():New(cFontUti,,-15,,.T.)
	Local 	lInverte 	:= .F.
	Local 	aSize 		:= MsAdvSize(.T.)
	Local 	aButEnc		:= {}
	Local 	aCpoZAF		:= {}
	Local 	aCpoBrw		:= {}

	Private	cMarca 		:= GetMark()
	Private	cAliasZAF	:= GetNextAlias()
	Private	cAliasTMP	:= GetNextAlias()
	Private nVlrTot		:= 0
	Private oVlrTot		:= 0
	Private cOrdem      := " "
	Private aOrdem      := {"Modulo","NomeCli"}
	Private cFiltro     := SPACE(200)

	AAdd( aObjects, { 100 , 100, .T., .T. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)

	Aadd(aButEnc, {"EXTRATO", {|| INTILEG() 							}, "Legenda"})
	Aadd(aButEnc, {"EXTRATO", {|| U_ADTLIMPA()							}, "Desmarcar Itens Selecionados"})
	Aadd(aButEnc, {"EXTRATO", {|| U_RELFATB2B(Dtos(dDtIni),Dtos(dDtFim))}, "Memoria Calculo Fat.B2B"})
	Aadd(aButEnc, {"EXTRATO", {|| IMPRPS((cAliasTMP)->PEDIDO)			}, "Visualiza RPS-Prefeitura"})

	cQueryZAF +=" SELECT ' ' OK, PEDIDO,  Modulo, NomeCli, CNPJ, Produto, "   +CRLF
	cQueryZAF +="  	ZAF_PROMOT, SUM(Valor) Valor FROM ( " +CRLF
	cQueryZAF +=" SELECT  ' ' OK, ZAF_PEDIDO PEDIDO,  ZAF_MODULO Modulo, ZAF_CORPNA NomeCli, ZAF_CORPCN CNPJ, ZAF_ITNAME Produto, "  +CRLF
	cQueryZAF +="  	ZAF_PROMOT, SUM(ZAF_FINTXO+ZAF_FINTXS) Valor, '1' TIPO "   +CRLF
	cQueryZAF +="      FROM SIGA.ZAF330 ZAF  "   +CRLF
	cQueryZAF +="      WHERE ZAF_FILIAL ='01'  " +CRLF
	cQueryZAF +="      	AND ZAF_NUMERO  > ' ' "  +CRLF
	cQueryZAF +="   	  	AND ZAF_SLUID > ' ' " +CRLF
	//cQueryZAF +="   	  	AND ZAF_TPPGTO <> 'INTI Wallet' " +CRLF
	cQueryZAF +="   	  	AND (ZAF_FINTXO > 0 OR ZAF_FINTXS > 0) " +CRLF
	cQueryZAF +="   	  	AND ZAF_TIPO = 'Venda               '"   +CRLF
	cQueryZAF +="   	  	AND ZAF_DTVEND BETWEEN '"+ Dtos(dDtIni) +"' AND '"+ Dtos(dDtFim) +"' "										+CRLF
	cQueryZAF +="   		AND D_E_L_E_T_ = ' '   "   +CRLF
	cQueryZAF +="   GROUP BY ZAF_MODULO, ZAF_PEDIDO, ZAF_CORPNA, ZAF_CORPCN, ZAF_ITNAME, ZAF_PROMOT   "   +CRLF
	cQueryZAF +="   UNION ALL "   +CRLF
	cQueryZAF +="   SELECT  ' ' OK, ZAF_PEDIDO PEDIDO,  ZAF_MODULO Modulo, ZAF_CORPNA NomeCli, ZAF_CORPCN CNPJ, ZAF_ITNAME Produto, "   +CRLF
	cQueryZAF +="  	ZAF_PROMOT, SUM(ZAF_FINTXO+ZAF_FINTXS) Valor , '2' TIPO "  +CRLF
	cQueryZAF +="      FROM SIGA.ZAF330 ZAFCANC  "  +CRLF
	cQueryZAF +="      WHERE ZAF_FILIAL ='01'  " +CRLF
	cQueryZAF +="      	AND ZAF_NUMERO  > ' ' "  +CRLF
	cQueryZAF +="   	  	AND ZAF_SLUID > ' ' " +CRLF
	cQueryZAF +="   	  	AND ZAF_TPPGTO <> 'INTI Wallet' " +CRLF
	cQueryZAF +="   	  	AND (ZAF_FINTXO < 0 OR ZAF_FINTXS < 0) "   +CRLF
	cQueryZAF +="   	  	AND ZAF_TIPO <> 'Venda               '"   +CRLF
	cQueryZAF +="   	  	AND ZAF_DTCANC BETWEEN '"+ Dtos(dDtIni) +"' AND '"+ Dtos(dDtFim) +"' "										+CRLF
	cQueryZAF +="   		AND D_E_L_E_T_ = ' '   "   +CRLF
	cQueryZAF +="   GROUP BY ZAF_MODULO, ZAF_PEDIDO, ZAF_CORPNA, ZAF_CORPCN, ZAF_ITNAME, ZAF_PROMOT "  +CRLF
	cQueryZAF +="   ORDER BY CNPJ,TIPO) "  +CRLF
	cQueryZAF +="   GROUP BY PEDIDO,  Modulo, NomeCli, CNPJ, Produto,ZAF_PROMOT " +CRLF

	TCQuery cQueryZAF  New Alias (cAliasZAF)

	(cAliasZAF)->( DbGoTop() )

	aAdd(aCpoZAF,{"OK"        		,"C",02,0})
	aAdd(aCpoZAF,{"Modulo"	      	,"C",15,0})
	aAdd(aCpoZAF,{"NomeCli"  	    ,"C",40,0})
	aAdd(aCpoZAF,{"CNPJ"	 	  	,"C",15,0})
	aAdd(aCpoZAF,{"Produto"     	,"C",40,0})
	aAdd(aCpoZAF,{"Valor"			,"N",15,2})
	aAdd(aCpoZAF,{"Pedido"			,"C",06,0})

	aAdd(aCpoBrw,{"OK"			,"" ,"" 				,"@!"						 })
	aAdd(aCpoBrw,{"Modulo"     	,""	,"Modulo"        	,"@!"               ,"15","0"})
	aAdd(aCpoBrw,{"NomeCli"		,""	,"Nome Cliente"     ,"@!"       		,"40","0"})
	aAdd(aCpoBrw,{"CNPJ"		,""	,"CNPJ"		   		,"@!"               ,"15","0"})
	aAdd(aCpoBrw,{"Produto"		,""	,"Produto"   		,"@!"               ,"40","0"})
	aAdd(aCpoBrw,{"Valor"	    ,""	,"Valor"   	    	,"@E 9,999,999.99"  ,"15","2"})
	aAdd(aCpoBrw,{"Pedido"	    ,""	,"Pedido"   	    ,"@!"  				,"06","0"})

	oSay:SetText("Gerando consulta localizadores")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	CRIATAB(cAliasTMP,aCpoZAF,oSay)

	_aCores := {}

	aAdd(_aCores,{"Alltrim((cAliasTMP)->Pedido) == '' "	,"BR_VERMELHO"		})
	aAdd(_aCores,{"Alltrim((cAliasTMP)->Pedido) != '' "	,"BR_VERDE"	})

	Define MsDialog oDlg From aSize[7],0 TO aSize[6],aSize[5] Title cCadastro Pixel

	@ 035, 003 GROUP oGroup1 TO aPosObj[1][3],aPosObj[1][4] OF oDlg COLOR 0, 16777215  PIXEL

	@ 040, 006 SAY "FATURAMENTO INTI B2B - " + Dtoc(dDtIni) + " a " + Dtoc(dDtFim)  SIZE 250, 010 FONT oFontSubN2  OF oDlg COLORS RGB(031,073,125) PIXEL

	@ 040, 256 SAY "TOTAL "    SIZE 100, 010 FONT oFontSubN2  OF oDlg COLORS RGB(031,073,125) PIXEL
	@ 040, 310 GET nVlrTot Object oVlrTot When .f. SIZE 050,008 Picture "@E 9,999,999.99"

	@ 038,aPosObj[1][4]/2+030 ComboBox cOrdem ITEMS aOrdem SIZE 060,050 Object oOrdem
	@ 038,aPosObj[1][4]/2+094 Get    cFiltro  			   Size 180,150 Object oFiltro
	@ 038,aPosObj[1][4]/2+280 Button "Filtrar"       	   Size 040,013 Action FILTELA(CORDEM)

	oMark:=MsSelect():New(cAliasTMP,"OK","",aCpoBrw,@lInverte,cMarca,{aPosObj[1][1]+030,aPosObj[1][2],aPosObj[1][3],aPosObj[1][4]},,,,,_aCores)
	oMark:oBrowse:lHasMark := .T.

	oMark:oBrowse:lCanAllMark:=.T.
	lMarcar	:=	.T.

	oMark:oBrowse:bAllMark := { || SetMarkAll(cMarca,lMarcar )}

	oMark:bMark := {| | Mark(cMarca)}

	Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg, { |oSay| FwMsgRun(,{ |oSay| GPVINTI(oSay) }, "Geração PV INTI Promotor", 'Aguarde, gerando pedidos de venda......')},{ ||oDlg:End() } ,,aButEnc)

Return


/*/{Protheus.doc} CRIATAB
description cria tabela temporária para seleção dos registros
@type function
@version  
@author roger
@since 26/07/2021
@param cAliasTMP, character, param_description
@param aCpoZAF, array, param_description
@return variant, return_description
/*/
Static Function CRIATAB(cAliasTMP,aCpoZAF,oSay)

	Local oTempTable
	Local nX := 0

	oSay:SetText("Criando tabela temporária")
	ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

	//-------------------
	//Criação do objeto
	//-------------------
	oTempTable := FWTemporaryTable():New(cAliasTMP )

	oTemptable:SetFields( aCpoZAF )

	//------------------
	//Criação da tabela
	//------------------
	oTempTable:Create()

	DbSelectArea(cAliasTMP)

	cCnpj := " "
	nPos	  := 0
	lTem := .F.

	While !(cAliasZAF)->(Eof())

		RecLock(cAliasTMP,.T.)

		(cAliasTMP)->OK			:= ' '
		(cAliasTMP)->Modulo		:= (cAliasZAF)->Modulo
		(cAliasTMP)->NomeCli	:= (cAliasZAF)->NomeCli
		(cAliasTMP)->CNPJ		:= (cAliasZAF)->CNPJ
		(cAliasTMP)->Produto	:= (cAliasZAF)->Produto
		(cAliasTMP)->Valor		:= (cAliasZAF)->Valor
		(cAliasTMP)->Pedido		:= (cAliasZAF)->Pedido

		(cAliasTMP)->(MsUnlock())

		(cAliasZAF)->(dbSkip())

	EndDo

/*	
//---------------------------------
//Exclui a tabela 
//---------------------------------
oTempTable:Delete() 
*/
	(cAliasTMP)->(dbGotop())
Return

/*/{Protheus.doc} Mark
description validação na marcação dos registros
@type function
@version  
@author roger
@since 26/07/2021
@param cMarca, character, param_description
@return variant, return_description
/*/
Static Function Mark(cMarca)


	//(cAliasTMP)->(dbGotop())

	If Empty((cAliasTMP)->PEDIDO)

		If Marked("OK")
			RecLock(cAliasTMP,.F.)
			(cAliasTMP)->OK 	:= cMarca

			MsUnlock()
			nVlrTot:= nVlrTot + (cAliasTMP)->Valor
			oVlrTot:Refresh()

		Else

			nVlrTot:= nVlrTot - (cAliasTMP)->Valor
			oVlrTot:Refresh()

		EndIf
	Else
		Alert("Pedido gerado, não será possivel selecionar esse item!!")
		RecLock(cAliasTMP,.F.)
		(cAliasTMP)->OK 	:= ""

		MsUnlock()

	EndIf

	//oMark:oBrowse:Refresh()

Return()


/*/{Protheus.doc} INTILEG
description legenda da rotina
@type function
@version  
@author roger
@since 12/07/2021
@return variant, return_description
/*/
Static Function INTILEG()

	Local aCor := {}

	aAdd(aCor,{"BR_VERDE"	,"Pedido Gerado" 	  })
	aAdd(aCor,{"BR_VERMELHO","Pendente"	  })

	BrwLegenda(,"Legenda",aCor)

Return

/*/{Protheus.doc} SetMarkAll
description
@type function
@version  
@author roger
@since 27/07/2021
@param cMarca, character, param_description
@param lMarcar, logical, param_description
@return variant, return_description
/*/
Static Function SetMarkAll(cMarca,lMarcar )

	Local aAreaMark := (cAliasTMP)->( GetArea() )

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->( dbGoTop() )

	While !(cAliasTMP)->( Eof() )

		If Empty((cAliasTMP)->PEDIDO)

			If Empty((cAliasTMP)->OK )
				RecLock( (cAliasTMP), .F. )

				(cAliasTMP)->OK := cMarca
				(cAliasTMP)->(MsUnLock())

				nVlrTot:= nVlrTot + (cAliasTMP)->Valor

			Else
				RecLock( (cAliasTMP), .F. )

				(cAliasTMP)->OK := " "
				(cAliasTMP)->(MsUnLock())

				nVlrTot:= nVlrTot - (cAliasTMP)->Valor

			EndIf

		EndIf

		(cAliasTMP)->( dbSkip() )

	EndDo


	oVlrTot:Refresh()
	oMark:oBrowse:Refresh()

	RestArea( aAreaMark )

Return .T.


Static Function GPVINTI(oSay)

//	Local cNumPed    := ""		// Número do Pedido de Vendas
	Local cA1Cod     := ""  	// Código do Cliente
	Local cA1Loja    := "" 		// Loja do Cliente
	Local cAliasNPed := GetNextAlias()
	Local nOpcX      := 0
	Local aCabec     := {}
	Local aItens     := {}
	Local aLinha     := {}
	Local cItem      := ' '
	Local nI         := 0
	Local cEpep		 :='990300002           '
	Local msg		 := " "
	Local lRet		 := .F.
	Local cMenNota 	 := " "

	Private lMsErroAuto    := .F.
	Private lAutoErrNoFile := .F.
	Private lMsHelpAuto := .T.

	lRet	:=	FWAlertYesNo("Confirma geração dos pedidos de venda?", "P.Venda B2B")

	If lRet

		SA1->(dbSetOrder(3)) //cnpj
		SB1->(dbSetOrder(1))
		SE4->(dbSetOrder(1))
		SF4->(dbSetOrder(1))

/*
		cQryNumPed := " SELECT MAX(C5_NUM) NUM " + CRLF
		cQryNumPed += " FROM " +RetSqlName("SC5") + CRLF
*/
//		TCQUERY (cQryNumPed) NEW ALIAS (cAliasNPed)

//		cNumPed    :=	GetSX8Num("SC5","C5_NUM")

		If Select(cAliasNPed) > 0
			(cAliasNPed)->( DbCloseArea() )
		EndIf

		(cAliasTMP)->( dbGoTop() )

		While (cAliasTMP)->(!Eof())

			If !Empty((cAliasTMP)->OK)

				oSay:SetText("Gerando Pedido de Venda cliente: " + Substr((cAliasTMP)->NomeCli,1,10))
				ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

				//****************************************************************
				//* Inclusao - INÍCIO
				//****************************************************************
				SA1->(dbSetOrder(3))
				If SA1->(MsSeek(xFilial("SA1") + (cAliasTMP)->CNPJ))
					cA1Cod  :=  SA1->A1_COD
					cA1Loja :=  SA1->A1_LOJA
					cBlqCli :=  SA1->A1_MSBLQL
				Else

					msg := "ATENCAO!"+CHR(13)+CHR(10)
					msg += "Promotor não encontrato no cadastro de clientes, favor realizar o cadastro!!!" +CHR(13)+CHR(10)
					msg += "Nome : " + Alltrim((cAliasTMP)->NomeCli) +CHR(13)+CHR(10)
					msg += "CNPJ : " + Alltrim((cAliasTMP)->CNPJ) +CHR(13)+CHR(10)

					Alert(msg)

					(cAliasTMP)->(dbSkip())

					Loop

				End If

				If (cBlqCli=="2") .OR. (cBlqCli==" ")
				 
				 cMenNota := "Licenciamento de Software - Modulo "+ Alltrim((cAliasTMP)->Modulo) +"-" + Alltrim((cAliasTMP)->Produto) + "- NF apenas para efeito fiscal. Valor ja descontado do repasse"

					If Len(aCabec) == 0
//						aadd(aCabec, {"C5_NUM"    ,  cNumPed                , Nil})
						aadd(aCabec, {"C5_TIPO"   ,  "N"                    , Nil})
						aadd(aCabec, {"C5_CLIENTE", cA1Cod                  , Nil})
						aadd(aCabec, {"C5_LOJACLI", cA1Loja                 , Nil})
						aadd(aCabec, {"C5_LOJAENT", cA1Loja                 , Nil})
						aadd(aCabec, {"C5_CONDPAG", cE4Codigo               , Nil})
						aadd(aCabec, {"C5_NATUREZ", cNaturez                , Nil})
						aadd(aCabec, {"C5_MENNOTA", cMenNota        		, Nil})
						aadd(aCabec, {"C5_PAGTO"  , "B2BINTI" 				, Nil})
						aadd(aCabec, {"C5_DATARPS", DDATABASE			 	, Nil})

						cItem:='01'
					EndIf


					//****************************************************************
					//- Informando os dados do item do Pedido de Venda
					//****************************************************************
					If Empty((cAliasTMP)->Pedido)

						aLinha := {}
						aadd(aLinha,{"C6_ITEM"    , cItem			       	,Nil})
						aadd(aLinha,{"C6_PRODUTO" , cB1Cod                 	,Nil})
						aadd(aLinha,{"C6_QTDVEN"  , 1     			    	,Nil})
						aadd(aLinha,{"C6_PRCVEN"  , (cAliasTMP)->Valor		,Nil})
						aadd(aLinha,{"C6_PRUNIT"  , (cAliasTMP)->Valor		,Nil})
						aadd(aLinha,{"C6_VALOR"   , (cAliasTMP)->Valor		,Nil})
						aadd(aLinha,{"C6_TES"     , cF4TES                 	,Nil})
						aadd(aLinha,{"C6_ITEMCC"  , cEpep				   	,Nil})

						aadd(aItens, aLinha)

						If Len(aItens) > 0
							nOpcX := 3

							Begin Transaction

								MSExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)

							End Transaction

							If !lMsErroAuto

								For nI	:=	1 To Len(aItens)

									oSay:SetText("Atualizando status da tabela de integrações.")
									ProcessMessage() // FORÇA O DESCONGELAMENTO DO SMARTCLIENT

									cTmp	:=	"cTmp"

									cQryUPD	:= " UPDATE " +RetSqlName("ZAF") + CRLF
									cQryUPD	+= " SET ZAF_PEDIDO = '" + SC5->C5_NUM +"'" + CRLF
									cQryUPD	+= " WHERE ZAF_FILIAL='01' " + CRLF
									cQryUPD	+= " AND ZAF_MODULO = '"+(cAliasTMP)->Modulo+"'" + CRLF
									cQryUPD	+= " AND ZAF_CORPNA = '"+(cAliasTMP)->NomeCli+"'" + CRLF
									cQryUPD	+= " AND ZAF_CORPCN = '"+(cAliasTMP)->CNPJ+"'" + CRLF
									cQryUPD	+= " AND ZAF_ITNAME = '" + (cAliasTMP)->Produto+"'"+ CRLF
									cQryUPD	+= " AND ZAF_DTVEND BETWEEN '"+ Dtos(dDtIni) +"' AND '"+ Dtos(dDtFim) +"' "+CRLF
									cQryUPD	+= " AND ZAF_TIPO ='Venda' "+CRLF
									cQryUPD	+= " AND D_E_L_E_T_ = ' ' " + CRLF

									TcSqlExec(cQryUPD)

								Next nI

								RecLock(cAliasTMP,.F.)

								(cAliasTMP)->PEDIDO	:= SC5->C5_NUM
								(cAliasTMP)->OK		:= ""

								nVlrTot := nVlrTot - (cAliasTMP)->Valor

								(cAliasTMP)->(MsUnLock())

								SC5->(ConfirmSX8())

								//cNumPed    :=	GetSX8Num("SC5","C5_NUM")
								aItens	:=	{}
								aCabec  := 	{}

							Else

								msg := "ATENCAO!"+CHR(13)+CHR(10)
								msg += "Erro ao gerar o pedido!!!" +CHR(13)+CHR(10)
								msg += "Nome : " + Alltrim((cAliasTMP)->NomeCli) +CHR(13)+CHR(10)
								msg += "CNPJ : " + Alltrim((cAliasTMP)->CNPJ) +CHR(13)+CHR(10)

								Alert(msg)

								MostraErro()

							EndIf


						End If
					EndIf

				Else
					msg := "ATENCAO!"+CHR(13)+CHR(10)
					msg += "Cliente bloqueado para uso, favor verificar cadastro!!!" +CHR(13)+CHR(10)
					msg += "Nome : " + Alltrim((cAliasTMP)->NomeCli) +CHR(13)+CHR(10)
					msg += "CNPJ : " + Alltrim((cAliasTMP)->CNPJ) +CHR(13)+CHR(10)

					Alert(msg)

					(cAliasTMP)->(dbSkip())

					Loop

				EndIf
			EndIf

			(cAliasTMP)->(dbSkip())

		EndDo


		//****************************************************************
		//* Inclusao - FIM
		//****************************************************************

		(cAliasTMP)->(DBClearFilter())
		(cAliasTMP)->(dbGoTop())

		oVlrTot:Refresh()
		oMark:oBrowse:Refresh()

	EndIf

Return


/*/{Protheus.doc} FILTELA
description filtra informações no browse
@type function
@version  
@author roger
@since 12/07/2021
@param cOrdem, character, param_description
@param ntela, numeric, param_description
@return variant, return_description
/*/
Static Function FILTELA(cOrdem)

	Local _nReg	:=	Recno()

	DbSelectArea(cAliasTMP)
	DbGoTop()

	If !Empty(cFiltro)
		(cAliasTMP)->(DbSetFilter( { || UPPER(Alltrim(FwCutOff(cFiltro, .F.))) $ UPPER(FwCutOff((cAliasTMP)->&cOrdem, .F.))  }, 'UPPER(Alltrim(FwCutOff(cFiltro, .F.))) $ UPPER(FwCutOff((cAliasTMP)->&cOrdem, .F.))' ) )
	Else
		DbSelectArea(cAliasTMP)
		(cAliasTMP)->(DBClearFilter())
		DbGoTo(_nReg)
	EndIf

	oMark:oBrowse:Refresh(.T.)
Return


Static Function IMPRPS(cNumPv)

	Local aCcm 		:= {}
	Local aArea		:= Lj7GetArea({"SC5","SF3"})
	Local cQry		:= ''
	Local cNumDoc 	:= ''
	Local cSerie 	:= ''

	aCcm := FWSM0Util():GetSM0Data(FWCodEmp(),cFilAnt,{"M0_INSCM"})// Caso tenha que buscar a incrição municipal pela SM0
	cCcm := Alltrim(aCcm[1][2])
	//cNumPv := '326508'

	//ShellExecute( "open", 'https://nfe.prefeitura.sp.gov.br/contribuinte/notaprint.aspx?ccm='+cCcm+'&nf='+Alltrim('746604              ')+'&cod='+Alltrim('YKGMKWI7'), "", "", 3 )


	DbselectArea('SC5')
	SC5->(DbsetOrder(1))

	If SC5->(MsSeek(xFilial("SC5")+cNumPv))
		cNumDoc := SC5->C5_NOTA
		cSerie	:= SC5->C5_SERIE
	EndIf

	cQry:= " SELECT F3_NFISCAL, F3_CODNFE, F3_NFELETR"		 + CRLF
	cQry+= " FROM "+ RetSqlName('SF3') + ' SF3 ' + CRLF
	cQry+= " WHERE F3_NFISCAL 	='"+cNumDoc+"'"	 + CRLF
	cQry+= " AND F3_SERIE 		='"+cSerie+"'"	 + CRLF
	cQry+= " AND F3_CFO 		> '499 '"		 + CRLF
	cQry+= " AND F3_CODNFE 		> ' '"			 + CRLF
	cQry+= " AND D_E_L_E_T_ 	=' '"			 + CRLF

	TcQuery cQry New Alias (cAlias:=GetNextAlias())

	dbSelectArea(cAlias)

	(cAlias)->(dbGoTop())

	If !Empty((cAlias)->F3_NFISCAL)
		ShellExecute( "open", 'https://nfe.prefeitura.sp.gov.br/contribuinte/notaprint.aspx?ccm='+cCcm+'&nf='+Alltrim((cAlias)->F3_NFELETR)+'&cod='+Alltrim((cAlias)->F3_CODNFE), "", "", 3 )
	Else
		FWAlertWarning("O pedido não foi faturado ou o RPS não foi transmitido para prefeitura ", "Visualização RPS")
	EndIf

	Lj7RestArea(aArea)

Return
