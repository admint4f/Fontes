#include "Protheus.Ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWBROWSE.CH"
#INCLUDE "msmgadd.ch"
#INCLUDE "TOPCONN.CH"
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | T4FCONC          | AUTOR | Geraldo Sabino   | DATA | 30/09/2020 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Programa para fazer a conciliação contabil especifica da T4F.   |//
//|           | Solicitação da Erica Maimone / Maria Helena                     |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
///////////////////////////////////////////////////////////////////////////////////

User Function T4FCONC()

	Private oDlg
	Private cVar     	:= ""
	Private lMark    	:= .F.
	Private oOk      	:= LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
	Private oNo      	:= LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  /////O
	Private oChk1
	Private oChk2
	Private cSaldo
	Private cQuery 		:= ""
	Private cCodCT1 	:= SPACE(TamSX3("CT1_CONTA")[1])
	Private oCodCT1
	Private oBold

	DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD

	Set Key VK_F4 TO MTF4()
	Set Key VK_F5 TO MTF5()

	Private _nDeb:=0
	Private _nCre:=0
	Private _cFil:=SPAC(20)
	Private oDeb
	Private oCre
	Private oPesq

	Private oData
	Private dDataFim	:= dDataBase
	Private xvetor      :={}

	Private dDataIni	:= dDataBase
	Private cTitulo 	:= "CONCILIAÇÃO DE LANÇAMENTOS CONTÁBEIS"
	Private lChk1 		:= .F.
	Private oLbx
	Private aVetor 		:= {}
	Private nX			:= 1
	Private lContinua 	:= .f.
	Private _aRat       :={}

	Private aParamBox := {}
	Private aRet2     := {}
	Private _aSalvar   := {}
	Private _lSalvo   := .T.

	aAdd( aVetor, {lMark,"","","","","","","","","","",0,0,"","","","","","",0  }) //20 pos
	aAdd(aParamBox,{1,"Traz Conciliados  (S)im, (N)ao    ?","S"         ,"","","","",10,.F.})
	aAdd(aParamBox,{1,"Ordem (N)ormal, (D)oc, (V)alor    ?","N"         ,"","","","",10,.F.})

	If !ParamBox(aParamBox, "Conciliação contabil", aRet2)
		Return Nil
	EndIf

	Private lTrazCon:=aRet2[1]
	Private cOrdem  :=aRet2[2]

	XTELA()
Return

STATIC FUNCTION XTELA()

Local aSize := MsAdvSize()

//monta a tela para Get dos Campos de seleção
//	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 05,0 TO  080,200  PIXEL     // 100,800  PIXEL    // 500 1400
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 05,0 TO aSize[6],aSize[5]  PIXEL     // 100,800  PIXEL    // 500 1400

		@ 20,05 LISTBOX oLbx FIELDS HEADER ;
			" ", "Dia", "Lote", "Sub Lote","Doc", "Linha", "Tipo","Debito", "Credito", "Historico", "Debito", "Credito","C.Custo Debito", "C.Custo Crédito",;
			 "Item Debito", "Item Credito","Documento", "Origem","Conciliado", "R_E_C_N_O_" SIZE aSize[3],  aSize[4]-20 OF oDlg PIXEL ON dblClick( Marca() )

	oLbx:SetArray( aVetor )
	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		aVetor[oLbx:nAt,7],;
		aVetor[oLbx:nAt,8],;
		aVetor[oLbx:nAt,9],;
		aVetor[oLbx:nAt,10],;
		aVetor[oLbx:nAt,11],;
		aVetor[oLbx:nAt,12],;
		aVetor[oLbx:nAt,13],;
		aVetor[oLbx:nAt,14],;
		aVetor[oLbx:nAt,15],;
		aVetor[oLbx:nAt,16],;
		aVetor[oLbx:nAt,17],;
		aVetor[oLbx:nAt,18],;
		aVetor[oLbx:nAt,19],;
		aVetor[oLbx:nAt,20]}}

	oLbx:SetFocus()

	@ 07,05 SAY   "Dt Inicial: " 	SIZE 130,06 PIXEL OF oDlg
	@ 05,30 MSGET oData VAR dDataIni PICTURE "@D" SIZE 45, 09 OF oDlg PIXEL HASBUTTON valid(!empty(dDataIni))

	@ 07,80 SAY   "Dt Final: " 	SIZE 130,06 PIXEL OF oDlg
	@ 05,103 MSGET oData 	 VAR dDataFim PICTURE "@D" SIZE 45, 09 OF oDlg PIXEL HASBUTTON  valid(!empty(dDataFim).and.dDataFim>=dDataIni)

	@ 07,150 SAY   "Cta Contab: " SIZE 130,06 PIXEL OF oDlg
	@ 05,180 MSGET  oCodCT1  VAR cCodCT1  PICTURE "@!"  F3 "CT1"   valid(!empty(cCodCT1).and.ExistCpo("CT1", cCodCT1))   SIZE 050,08 PIXEL OF oDlg

		//@ 07,750 SAY   "F4-Busca TEXTO" SIZE 80,8 PIXEL OF oDlg FONT oBold COLOR CLR_RED

	@ 00,243 SAY   "Pesquisar" 	SIZE 120,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	oBtn2 := TBtnBmp2():New( 12,490,26,26,'PMSPESQ',,,,{||MsgRun("Selecionando lançamentos","",{||FGRSPesq()})},oDlg,,,.T. )

	@ 00,273 SAY   "Conc Todos" 	SIZE 120,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	oBtn2 := TBtnBmp2():New( 12,560,26,26,'BTURNSHARPLEFT',,,,{||MsgRun("Concilia Todos","",{||FGGrvCON(1)})},oDlg,,,.T. )

	@ 00,308 SAY   "Desc Todos" 	SIZE 120,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	oBtn2 := TBtnBmp2():New( 12,618,26,26,'BTURNSHARPRIGHT'	,,,,{||MsgRun("DesConcilia Todos","",{||FGGrvCON(2)})},oDlg,,,.T. )

	@ 00,345 SAY   "Excel" 	SIZE 120,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	oBtn2 := TBtnBmp2():New( 12,690,26,26,'PMSEXCEL',,,,{||MsgRun("Exporta para excel todas as linhas da conciliação atual !!!","",{||XEXPEXCEL()})},oDlg,,,.T.)

	@ 00,368 SAY   "Salvar"	SIZE 120,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	oBtn2 := TBtnBmp2():New( 12,735,26,26,'SALVAR',,,,{||MsgRun("Salva a Conciliação !!!","",{||XFGGrvCON()})},oDlg,,,.T.)

//@ 00,515 SAY   "Filtro"	SIZE 120,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
//oBtn2 := TBtnBmp2():New( 12,1040,26,26,'FILTRO'	,,,,{||    MsgRun("Salva a Conciliação !!!",""			  ,{||XFGGrvCON(2)	          	})			},oDlg,,,.T. )

	@ 01,398 SAY   "debito" 	SIZE 100,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	@ 08,398 MSGET oDeb   VAR   _nDeb PICTURE "@E 999,999,999.99" WHEN .F. SIZE 60, 08 OF oDlg PIXEL HASBUTTON
//oBtn2 := TBtnBmp2():New( 12,0600,26,26,'PMSCUSTO' 	,,,,{||    MsgRun("",""			    ,{||T4FTOT(1)  				})			},oDlg,,,.T. )

	@ 01,465 SAY   "Credito" 	SIZE 100,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	@ 08,465 MSGET oCre  VAR   _nCre PICTURE "@E 999,999,999.99"  WHEN .F. SIZE 60, 08 OF oDlg PIXEL HASBUTTON
//oBtn2 := TBtnBmp2():New( 12,0700,26,26,'PMSCUSTO' 	,,,,{||    MsgRun("",""			    ,{||T4FTOT(2)  				})			},oDlg,,,.T. )

//oBtn5 := TBtnBmp2():New( 10,1015,26,26,'PMSCUSTO'	,,,,{||    MsgRun("Total Credito",""			,{||T4FTOT()  				})			},oDlg,,,.T. )

//@ 01,715 SAY   "Filtrar" 		SIZE 100,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
//@ 00,715 MSGET oPesq  VAR   _cFil PICTURE "@!"  WHEN .t.  	VALID FGRFILTRO(_cFil) SIZE 35, 10 OF oDlg PIXEL HASBUTTON
//oBtn2 := TBtnBmp2():New( 12,1015,26,26,'PMSCUSTO'	,,,,{||    MsgRun("MsgRun","Encerrando Processamento"				,{||FGRFILTRO()})      	},oDlg,,,.T. )


	@ 00,545	 SAY   "Sair" 		SIZE 120,8 PIXEL OF oDlg //FONT oBold COLOR CLR_BLACK
	oBtn2 := TBtnBmp2():New( 12,1090,26,26,'FINAL'	,,,,{||    MsgRun("MsgRun","Encerrando Processamento",{||FGRSEnd()})},oDlg,,,.T.)


	oDlg:lMaximized := .T.
	oLbx:lHScroll   := .T. // NoScroll

	ACTIVATE MSDIALOG oDlg CENTER

	IF !_lsalvo
		alert("Retornar a Tela de Conciliação pois itens em aberto não foram salvos !!!")
	Endif

Return


//Finalizando o programa
//--------------------------
Static Function FGRSEnd()
//--------------------------
	IF _nDeb<>_nCre
		ALERT("Valores de DEBITO e CREDITO não Batem, Saindo da Rotina !!!")

	Else
		IF _nDeb+_nCre = 0
			oDlg:End()
		Endif
		IF !_lSalvo
			IF Aviso("Conciliação","Nao foi salva a Conciliação. Confirma saida sem salvar ? ",{"Sim","Nao"})=1
				oDlg:End()
			ENDIF
		Else
			oDlg:End()
		Endif
	Endif
Return

//Pesquisando as requisições.
//-----------------------------------
Static Function FGRSPesq()
//-----------------------------------
	Local nLinha := 0
	Local cAlias1 := GetNextAlias()
	Local xObscn := If(lTrazCon='S','L',' ')
	Local xordem
	
	DO CASE
		CASE cOrdem $ "Nn"  .or. cOrdem $ " "
			xordem:='1'
		CASE cOrdem $ "Dd"
			xordem:='CT2_FILIAL,CT2_XDOC'
		CASE cOrdem $ "Vv"
			xordem:='CT2_FILIAL,CT2_VALOR'
	ENDCASE

//MsFreeObj(@oLbx, .F.)

	if empty(dDataIni) .or. empty(dDataFim) .or. empty(cCodCT1)
		oLbx:Refresh()
		Aviso( "Lançamentos", "Parametros preenchidos de forma incorreta.", {"Ok"} )
		return
	endif

	BeginSql Alias cAlias1
		SELECT CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_DC  ,CT2_DEBITO,CT2_CREDIT,
		CT2_HIST,CT2_VALOR,CT2_CCD,CT2_CCC,CT2_ITEMD,CT2_ITEMC,CT2_XDOC,CT2_ORIGEM,CT2_XOBSCN,  %table:CT2%.R_E_C_N_O_ AS REG 
		FROM %table:CT2%
		WHERE
			CT2_DATA BETWEEN %exp:dDataIni% AND %exp:dDataFim% AND
			(CT2_DEBITO = %exp:alltrim(cCodCT1)% OR  CT2_CREDIT = %exp:alltrim(cCodCT1)%) AND
			CT2_FILIAL =  %xfilial:CT2% AND D_E_L_E_T_<>'*' AND
			D_E_L_E_T_<>'*' AND
			CT2_MOEDLC = '01' AND
			CT2_TPSALD = '1'AND
			CT2_XOBSCN = %exp:xObscn%
			ORDER BY %exp:&xordem%
	EndSql

	aVetor:={}
	aAdd( aVetor, {lMark,"","","","","","","","","","",0,0,"","","","","","",0  }) //20 pos

	oLbx:SetArray( aVetor )
	olbx:refresh()

	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		aVetor[oLbx:nAt,7],;
		aVetor[oLbx:nAt,8],;
		aVetor[oLbx:nAt,9],;
		aVetor[oLbx:nAt,10],;
		aVetor[oLbx:nAt,11],;
		aVetor[oLbx:nAt,12],;
		aVetor[oLbx:nAt,13],;
		aVetor[oLbx:nAt,14],;
		aVetor[oLbx:nAt,15],;
		aVetor[oLbx:nAt,16],;
		aVetor[oLbx:nAt,17],;
		aVetor[oLbx:nAt,18],;
		aVetor[oLbx:nAt,19],;
		aVetor[oLbx:nAt,20]}}

	DbSelectArea(cAlias1)
	DbGoTop()
	_aSequen :={}

	do While(cAlias1)->(!eof())
		nLinha++

		IF !Empty((cAlias1)->CT2_XOBSCN)
			lMark := .T.
		ELSE
			lMark := .F.
		ENDIF

		AADD(_aSalvar,{(cAlias1)->(REG),lMark,(cAlias1)->CT2_XOBSCN})

		if nLinha = 1
			aVetor[nLinha,01] := lMark
			aVetor[nLinha,02] := DTOC((cAlias1)->CT2_DATA)
			aVetor[nLinha,03] :=(cAlias1)->CT2_LOTE
			aVetor[nLinha,04] :=(cAlias1)->CT2_SBLOTE
			aVetor[nLinha,05] :=(cAlias1)->CT2_DOC
			aVetor[nLinha,06] :=(cAlias1)->CT2_LINHA
			aVetor[nLinha,07] :=(cAlias1)->CT2_DC
			aVetor[nLinha,08] :=(cAlias1)->CT2_DEBITO
			aVetor[nLinha,09] :=(cAlias1)->CT2_CREDIT
			aVetor[nLinha,10] := SUBSTR((cAlias1)->CT2_HIST,1,40)

			IF(cAlias1)->CT2_DC $ "1/3"
				aVetor[nLinha,11] := Transf((cAlias1)->CT2_VALOR,"@E 999,999,999.99")
			Else
				aVetor[nLinha,11] := ""
			ENDIF

			IF(cAlias1)->CT2_DC $ "2/3"
				aVetor[nLinha,12] := Transf((cAlias1)->CT2_VALOR,"@E 999,999,999.99")
			ELSE
				aVetor[nLinha,12] := ""
			ENDIF

			aVetor[nLinha,13] :=(cAlias1)->CT2_CCD
			aVetor[nLinha,14] :=(cAlias1)->CT2_CCC
			aVetor[nLinha,15] :=(cAlias1)->CT2_ITEMD
			aVetor[nLinha,16] :=(cAlias1)->CT2_ITEMC
			aVetor[nLinha,17] :=(cAlias1)->CT2_XDOC
			aVetor[nLinha,18] :=(cAlias1)->CT2_ORIGEM
			aVetor[nLinha,19] :=(cAlias1)->CT2_XOBSCN
			aVetor[nLinha,20] :=(cAlias1)->REG
		else
			aAdd( aVetor, { lMark, ;
				DTOc((cAlias1)->CT2_DATA), ;
				(cAlias1)->CT2_LOTE, ;
				(cAlias1)->CT2_SBLOTE, ;
				(cAlias1)->CT2_DOC, ;
				(cAlias1)->CT2_LINHA, ;
				(cAlias1)->CT2_DC  , ;
				(cAlias1)->CT2_DEBITO, ;
				(cAlias1)->CT2_CREDIT, ;
				SUBSTR((cAlias1)->CT2_HIST,1,40), ;
				IIF((cAlias1)->CT2_DC$"1/3",Transf((cAlias1)->CT2_VALOR,"@E 999,999,999.99"),""), ;
				IIF((cAlias1)->CT2_DC$"2/3",Transf((cAlias1)->CT2_VALOR,"@E 999,999,999.99"),""), ;
				(cAlias1)->CT2_CCD, ;
				(cAlias1)->CT2_CCC, ;
				(cAlias1)->CT2_ITEMD, ;
				(cAlias1)->CT2_ITEMC, ;
				(cAlias1)->CT2_XDOC, ;
				(cAlias1)->CT2_ORIGEM, ;
				(cAlias1)->CT2_XOBSCN, ;
				(cAlias1)->REG })
		endif
		(cAlias1)->(dbSkip())
	Enddo

	T4FTOT(1)    // Totaliza o Debito
	T4FTOT(2)    // Totaliza o Credito
	oDeb:Refresh()
	oCre:Refresh()
	oLbx:Refresh()

	xVetor:=aVetor
Return

//---------------------------------------
// rotina automatica de requisição de estoque
//movimentação simples
//---------------------------------------
Static Function T4FTot(nPar)
//---------------------------------------
	//Local nLenVet 		:= len(avetor)
	Local xII 			:= 0
	//Local aD3 			:= {}
	//Local lMsErroAuto 	:= .f.

	If nPar=1
		_nDeb:=0
	Else
		_nCre:=0
	Endif

	For xII = 1 to len(aVetor)

		if Empty(aVetor[xII,1])
			Loop
		Endif

		if aVetor[xII,1]
			If nPar=1
				IF aVetor[xII,7] $ "1/3"

					IF cCodCT1 = aVetor[xII,8]
						cVal := STRTRAN(aVetor[xII,11],".","")
						cVal := STRTRAN(cVal,",",".")
						_nDeb+=VAL(cVal)
					Endif

				ENDIF
			Else
				IF aVetor[xII,7] $ "2/3"

					IF cCodCT1 = aVetor[xII,9]
						cVal := STRTRAN(aVetor[xII,12],".","")
						cVal := STRTRAN(cVal,",",".")
						_nCre+=Val(cVal)
					Endif

				ENDIF
			Endif

		Endif

	Next
	oDeb:Refresh()
	oCre:Refresh()

Return


//Marcando os itens.
//-----------------------------
Static Function Marca()
//-----------------------------
	//Local i 		:= 0
	Local nPos 		:= 0
//Verificar se há algum item marcado
//Há item marcado?
//Não, então marque.
//	Sim, o item marcado é o mesmo que já está marcado?
//			Sim, então inverta a marca.
//			Não, então desmaque o item marcado e marque o item desejado.


	XII:= oLbx:nAt

	IF aVetor[ oLbx:nAt,  1 ]
		aVetor[ oLbx:nAt, 1 ] := .F.

		IF aVetor[xII,7] $ "1/3"
			IF cCodCT1 = aVetor[xII,8]

				cVal := STRTRAN(aVetor[xII,11],".","")
				cVal := STRTRAN(cVal,",",".")
				_nDeb-=VAL(cval)
			Endif

		ENDIF

		IF aVetor[xII,7] $ "2/3"
			IF cCodCT1 = aVetor[xII,9]

				cVal := STRTRAN(aVetor[xII,12],".","")
				cVal := STRTRAN(cVal,",",".")
				_nCre-=  VAL(cval)
			Endif

		ENDIF

		nPos:=Ascan(_aSalvar,{|x| x[1]==aVetor[xII,20]})
		_aSalvar[nPos,2] := .F.
		_aSalvar[nPos,3] := ""

	Else
		aVetor[ oLbx:nAt, 1 ] := .T.

		IF aVetor[xII,7] $ "1/3"
			IF cCodCT1 = aVetor[xII,8]

				cVal := STRTRAN(aVetor[xII,11],".","")
				cVal := STRTRAN(cVal,",",".")
				_nDeb+=VAL(cval)
			Endif
		ENDIF

		IF aVetor[xII,7] $ "2/3"
			IF cCodCT1 = aVetor[xII,9]
				cVal := STRTRAN(aVetor[xII,12],".","")
				cVal := STRTRAN(cVal,",",".")
				_nCre+=VAL(cval)
			Endif

		ENDIF

		nPos:=Ascan(_aSalvar,{|x| x[1]==aVetor[xII,20]})
		_aSalvar[nPos,2] := .T.
		_aSalvar[nPos,3] := Substr(cUsuario,7,15)+" - "+dtoc(Date())

	Endif

	_lSalvo   := .F.

	oDeb:Refresh()
	oCre:Refresh()

	oLbx:Refresh()
Return



Static Function FGGrvCON(nOpc)
	Local _nDeb		:=0
	Local _nCre     :=0
	Local xII


	IF nOpc = 1
		nConc 	:= Aviso("Conciliação","Confirma a conciliação de todos as linhas de lançamentos Contábeis ? ",{"Sim","Nao"})

	Else
		nConc 	:= Aviso("DesConciliação","Confirma a Desconciliação de todos as linhas de lançamentos Contábeis ? ",{"Sim","Nao"})

	Endif

	IF nConc = 2
		Return
	ENDIF


	IF nOpc = 1   // Concilia Todos
		For xII := 1 to len(aVetor)

			if !aVetor[xII,1]
				aVetor[ xII, 1 ] := .T.

				IF aVetor[xII,7] $ "1/3"
					IF cCodCT1 = aVetor[xII,8]

						cVal := STRTRAN(aVetor[xII,11],".","")
						cVal := STRTRAN(cVal,",",".")
						_nDeb+=VAL(STRTRAN(aVetor[xII,11],",",""))
					Endif
				ENDIF


				IF aVetor[xII,7] $ "2/3"
					IF cCodCT1 = aVetor[xII,9]

						cVal := STRTRAN(aVetor[xII,12],".","")
						cVal := STRTRAN(cVal,",",".")
						_nCre+=Val(STRTRAN(aVetor[xII,12],",",""))
					Endif
				ENDIF

				nPos:=Ascan(_aSalvar,{|x| x[1]==aVetor[xII,20]})
				_aSalvar[nPos,2] := .T.
				_aSalvar[nPos,3] := Substr(cUsuario,7,15)+" - "+dtoc(Date())
				_lSalvo   := .F.
			Endif

		Next
	Else // DesConcilia Todos


		For xII := 1 to len(aVetor)

			if aVetor[xII,1]
				aVetor[ xII, 1 ] := .F.
				IF aVetor[xII,7] $ "1/3"
					IF cCodCT1 = aVetor[xII,8]

						cVal := STRTRAN(aVetor[xII,11],".","")
						cVal := STRTRAN(cVal,",",".")
						_nDeb-=VAL(STRTRAN(aVetor[xII,11],",",""))
					Endif
				ENDIF


				IF aVetor[xII,7] $ "2/3"
					IF cCodCT1 = aVetor[xII,9]

						cVal := STRTRAN(aVetor[xII,12],".","")
						cVal := STRTRAN(cVal,",",".")
						_nCre-=Val(STRTRAN(aVetor[xII,12],",",""))
					Endif
				ENDIF

				nPos:=Ascan(_aSalvar,{|x| x[1]==aVetor[xII,20]})
				_aSalvar[nPos,2] := .F.
				_aSalvar[nPos,3] := ""
				_lSalvo   := .F.
			Endif

		Next

	Endif


	T4FTOT(1)    // Totaliza o Debito
	T4FTOT(2)    // Totaliza o Credito

	oDeb:Refresh()
	oCre:Refresh()
	oLbx:Refresh()
Return



Static Function FGGrvDES()
	//Local _nDeb		:=0
	//Local _nCre     :=0
	Local xII

	nConc 	:= Aviso("DesConciliação","Confirma a Desconciliação de todos as linhas de lançamentos Contábeis ? ",{"Sim","Nao"})
	IF nConc = 2
		Return
	ENDIF



	For xII := 1 to len(aVetor)

		aVetor[ xII, 1 ] := .F.
		dBSelectarea("CT2")
		dBgoto(aVetor[xII,20])
		CT2->(Reclock("CT2",.F.))
		CT2->CT2_XOBSCN := ""
		CT2->(MsUnlock())
	Next

	T4FTOT(1)
	T4FTOT(2)

	oDeb:Refresh()
	oCre:Refresh()
	oLbx:Refresh()
Return



Static Function XEXPEXCEL()
	Local cArquivoA		:= ''
	Local oExcelA		:= Nil
	Local cDirDocs		:= MsDocPath()
	Local oExcelApp		:= Nil
	Local cPath			:= AllTrim(GetTempPath())
	Local _aComplexo    :={}
	Local _x,_c
	AADD(_aComplexo,"CONCILIACAO")

	cArquivoA	:= CriaTrab(,.F.)+".xml"
	oExcelA		:= FWMSEXCEL():New()

	cNameSheet	:= _aComplexo[1]
	oExcelA:AddworkSheet(cNameSheet)
	oExcelA:AddTable(cNameSheet,cNameSheet)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Mark"		            ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Data"		            ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Lote"		    	    ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Sub Lote"            	,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Doc Ctb"            	,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Linha"	    	        ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Tipo"	    		    ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Debito"	            ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Credito"		        ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Historico"		       	,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"debito"                ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"credito"               ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"CC Debito"	        	,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"CC Credito"		    ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Item Debito"       	,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Item Credito"       	,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Nota Fiscal"       	,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Origem"                ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Conciliado"            ,1	,1,.F.)
	oExcelA:AddColumn(cNameSheet,cNameSheet,"Registro"           	,1	,1,.F.)


	For _c:=1 to Len(aVetor)
		aLinha 	:= {}
		For _x:=1 to 20

			If _x=1
				If aVetor[_c,_x]
					aAdd(aLinha,"Ok")
				Else
					aAdd(aLinha,"..")
				Endif
			Else
				aAdd(aLinha,aVetor[_c,_x])
			Endif

		Next
		oExcelA:AddRow(cNameSheet,cNameSheet,aLinha)
	Next

	If !Empty(oExcelA:aWorkSheet)
		oExcelA:Activate()
		oExcelA:GetXMLFile(cDirDocs+"\"+cArquivoA)

		CpyS2T(cDirDocs+"\"+cArquivoA,cPath)

		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPath+cArquivoA) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
		MsgAlert("Veja a Planilha no Excel")
	Else
		MsgAlert("Não há valores a apresentar.")
	EndIf

Return Nil



Static Function XFGGRVCON()
	
	Local _c

	IF _lSalvo
		Alert("Não houve alterações. Sem necessidade de salvar neste momento !")
		Return
	ENDIF

	IF Aviso("Conciliação","Confirma salvar a Conciliação ? ",{"Sim","Nao"})=2
		Return
	ENDIF


	IF _nDeb<>_nCre
		Alert("Nao pode salvar com diferença de debito e credito !")
		Return
	Endif

	For _c:=1 to Len(_aSalvar)
		dBSelectarea("CT2")
		dBgoto(_aSalvar[_C,1])
		CT2->(Reclock("CT2",.F.))
		CT2->CT2_XOBSCN := _aSalvar[_c,3]
		CT2->(MsUnlock())
	Next
	_lSalvo := .T.

	MsgAlert("Conciliação Salva ")

Return

STATIC function MTF5()
	aVetor:={}
	aAdd( aVetor, {lMark,"","","","","","","","","","",0,0,"","","","","","",0  }) //20 pos

	oLbx:SetArray( aVetor )
	olbx:refresh()

	oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
		aVetor[oLbx:nAt,2],;
		aVetor[oLbx:nAt,3],;
		aVetor[oLbx:nAt,4],;
		aVetor[oLbx:nAt,5],;
		aVetor[oLbx:nAt,6],;
		aVetor[oLbx:nAt,7],;
		aVetor[oLbx:nAt,8],;
		aVetor[oLbx:nAt,9],;
		aVetor[oLbx:nAt,10],;
		aVetor[oLbx:nAt,11],;
		aVetor[oLbx:nAt,12],;
		aVetor[oLbx:nAt,13],;
		aVetor[oLbx:nAt,14],;
		aVetor[oLbx:nAt,15],;
		aVetor[oLbx:nAt,16],;
		aVetor[oLbx:nAt,17],;
		aVetor[oLbx:nAt,18],;
		aVetor[oLbx:nAt,19],;
		aVetor[oLbx:nAt,20]}}
	FGRSPESQ()
RETURN


STATIC function MTF4()
	
	Private aVetor2:={}

	_cFil:=SPAC(20)
	@ 096,042 TO 200,300 DIALOG oDlg1 TITLE "Filtro para Pesquisa"
	@ 008,010 SAY "Texto "
	@ 008,065 GET _cFil PICTURE "@!"
	@ 030,030 BMPBUTTON TYPE 1 ACTION CProcura(_cFil)// Substituido pelo assistente de conversao do AP5 IDE em 01/10/01 ==>        @ 030,030 BMPBUTTON TYPE 1 ACTION Execute(C730Imp)
	@ 030,070 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1
return .T.

Static Function cProcura(_cFil)

	Local xII,_xx

	For xII := 1 to len(aVetor)
		nLinha:=XII
		IF Alltrim(_cFil) $ aVetor[XII,10]  .AND. Len(alltrim(_cFil))>0
			aaDD(aVetor2,{aVetor[nLinha,01],aVetor[nLinha,02],aVetor[nLinha,03],aVetor[nLinha,04],aVetor[nLinha,05],;
				aVetor[nLinha,06],aVetor[nLinha,07],aVetor[nLinha,08],aVetor[nLinha,09],aVetor[nLinha,10],;
				aVetor[nLinha,11],aVetor[nLinha,12],aVetor[nLinha,13],aVetor[nLinha,14],aVetor[nLinha,15],;
				aVetor[nLinha,16],aVetor[nLinha,17],aVetor[nLinha,18],aVetor[nLinha,19],aVetor[nLinha,20]})
		ENDIF
	Next

	IF Len(aVetor2)>0
		aVetor:=aVetor2
		oLbx:SetArray( aVetor )
		For _xx:=1 to Len(aVetor)
			oLbx:nAt :=_xx
			oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
				aVetor[oLbx:nAt,2],;
				aVetor[oLbx:nAt,3],;
				aVetor[oLbx:nAt,4],;
				aVetor[oLbx:nAt,5],;
				aVetor[oLbx:nAt,6],;
				aVetor[oLbx:nAt,7],;
				aVetor[oLbx:nAt,8],;
				aVetor[oLbx:nAt,9],;
				aVetor[oLbx:nAt,10],;
				aVetor[oLbx:nAt,11],;
				aVetor[oLbx:nAt,12],;
				aVetor[oLbx:nAt,13],;
				aVetor[oLbx:nAt,14],;
				aVetor[oLbx:nAt,15],;
				aVetor[oLbx:nAt,16],;
				aVetor[oLbx:nAt,17],;
				aVetor[oLbx:nAt,18],;
				aVetor[oLbx:nAt,19],;
				aVetor[oLbx:nAt,20]}}
		Next
	Endif
	Close(oDlg1)

	oDeb:Refresh()
	oCre:Refresh()
	oLbx:Refresh()
	oLbx:SetFocus()
Return .T.
