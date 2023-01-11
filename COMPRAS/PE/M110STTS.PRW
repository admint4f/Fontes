#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M110STTS  ºAutor  ³Microsiga           º Data ³  09/16/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Geração de PC automatica para SC Emergencial e Descentral.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M110STTS()
	Local cNumSC	:= ParamIXB[1]
	Local _nOpcSC	:= ParamIXB[2]

// INICIO CUSTOM T4F
//Local cNumSC	 := ParamIXB[1]
//	Local aAreaBKP	 := GetArea()
//	Local i			 := 0
	Local cDestEmail := Space(50)

	Local lBlqPCO := .F.

	Private lAlcadaNew := GetMv("MV_T4FANEW",,.F.)
	Private aItemPC := {}
	Private aCabcPC := {}

//Busca Centro de Custo do usuario que fez a inclusao
	SC1->(dbSetOrder(1))
	SC1->(dbGoTop())
	SC1->(dbSeek(xFilial("SC1")+cNumSC))

	If INCLUI //--Sergio Celestino ( Gravar Campo de Identificação de anexo )
		aAreaSC1 := SC1->(GetArea())
		While !Eof() .And. SC1->C1_NUM == cNumSC
			Reclock("SC1",.F.)
			SC1->C1_ANEXO := IIF(U_VERANEXO(cNumSC),"S","N")
			MsUnlock()
			DbSelectArea("SC1")
			DbSkip()
		End
		RestArea(aAreaSC1)
	Endif

	If !INCLUI .And. !ALTERA
		cQuery  := "SELECT * FROM "+RetSqlName("SC1")+" WHERE C1_NUM = '"+cNumSC+"' "

		If Select("TRB") > 0
			DbSelectArea("TRB")
			DbCloseArea()
		Endif

		dbusearea( .T. ,"TOPCONN",TCGenQry(,,CQUERY),"TRB", .F. , .T. )
		__cSolicit := TRB->C1_USER

		_cSUBJECT:="[T4F-Suprimentos] Exclusão de Solicitação de compras "+cNumSC

		PswOrder(1)
		IF PswSeek(__cSolicit, .T. )
			If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
				cDestEmail := GetMv("MV_XMAILRE",,Space(200))
			Else
				cDestEmail := PSWRET(1)[1][14]
			Endif
		Endif
		//Comentado por Solic.Marcio Frade - 07/11/13
		//U_CRIAEMAIL(cDestEmail,_cSUBJECT)		// Envia email informando ao solicitante que a solicitacao de compras foi cancelada.

		//Exluir o rateio caso exista
		aAreax := GetArea()
		DbSelectArea("SZ2")
		SZ2->( DbSetOrder(2) )
		SZ2->( DbGotop() )
		If SZ2->( DbSeek( xFilial("SZ2") + cNumSC ) )
			While SZ2->( !Eof() ) .And. xFilial("SZ2")+SZ2->Z2__SC1 == SZ2->Z2_FILIAL + cNumSC
				If Alltrim(SZ2->Z2_TIPO) == "S"
					Reclock("SZ2",.F.)
					DbDelete()
					MsUnlock()
				Endif
				DbSelectARea("SZ2")
				SZ2->( DbSkip() )
			End-While
		Endif
		RestArea(aAreax)
	Endif

	dbSelectArea("ZZ4")
	ZZ4->(dbSetOrder(2))
	If ZZ4->(dbSeek(xFilial("ZZ4")+Padr(__cUserID,20)+AllTrim(SC1->C1_CC)))

		//Gera Alcada
		If INCLUI .Or. ALTERA
			//Apaga a alcada geraada
			dbSelectArea("ZZ6")
			ZZ6->(dbSetOrder(1))
			ZZ6->(dbSeek(xFilial("ZZ6")+cNumSC ))
			While ZZ6->(!Eof()) .And. ZZ6->ZZ6_FILIAL + ZZ6->ZZ6_SC == xFilial("ZZ6")+cNumSC
				ZZ6->(RecLock("ZZ6",.F.))
				ZZ6->(dbDelete())
				ZZ6->(MsUnlock())

				ZZ6->(dbSkip())
			EndDo
			LJMsgRun("Gerando Alçada de Aprovação","Aguarde",{|| U_Gera_Alcada_SC(cNumSC,SC1->C1_CC,lBlqPCO) })
		Else
			LJMsgRun("Estornando Alçada de Aprovação","Aguarde",{|| U_Estorna_Alcada_SC(cNumSC) })
		EndIf

	EndIf

	LJMsgRun("Gravando Rateio...","Aguarde",{||U_GeraRat(cNumSC)})
// FIM CUSTOM T4F

//INICIO - TOTVS
	If _nOpcSC == 1 .OR. _nOpcSC == 2
		LJMsgRun("Gravando PC...","Aguarde",{||U_GerPC110(cNumSC)})
	EndIf
	U_T4COMW01(cNumSC)

	SC1->(dbSetOrder(1))
	SC1->(dbGoTop())
	If( SC1->( dbSeek(xFilial("SC1")+cNumSC ) ) )
		Reclock("SC1",.F.)
		SC1->C1_APROV := "L"
		SC1->( MsUnlock() )
	EndIf

Return

//Funcao GeraPC - TOTVS
User Function GerPC110(cNumSC)
	Local nRecSC1	:= SC1->( Recno() )
	Local aCabecPC	:= {}
	Local aItemPC	:= {}
	Local cItemPc	:= PADL("",TamSX3("C7_ITEM")[1],"0")
	//Local cCompT4F	:= SuperGetMV("T4_COMEME",,"999")
	Local _cNumPC	:= Space(TamSX3("C1_PEDIDO")[1])
	Local _nRecSM0	:= SM0->( Recno() )
	Local _cEmpBkp	:= cEmpAnt
	Local _cFilBkp	:= cFilAnt
	Local _nRecC1Tmp:= SC1->( Recno() )
	Local _cC1Num	:= SC1->C1_NUM
	Local nTaxa := 0
	Local cCmoeda
	public cC7_NUM


	If Empty(_cMoeda)
		Alert('Informa a moeda da operação','Moeda da Operação')
		lRet:=.F.
	Else
		Do Case
		Case (cValToChar(_cMoeda) = "1-Real") .or. (cValToChar(_cMoeda) = "1")
			cCmoeda := 1 
		Case (cValToChar(_cMoeda) = "2-Dolar") .or. (cValToChar(_cMoeda) = "2")
			cCmoeda := 2
		Case (cValToChar(_cMoeda) = "6-Euro") .or. (cValToChar(_cMoeda) = "6")
			cCmoeda := 6
		EndCase
	EndIf

	DbSelectArea("SC1")
	DbSetOrder(1)
	If SC1->( DbSeek(xFilial("SC1")+cNumSC ) )
		If ( SC1->C1_XTPCPR $ "E,D" .OR. alltrim(_cTpCpr) $ "E,D" )

			SB1->(DbSetOrder(1))
			SB1->( DbSeek(xFilial("SB1")+SC1->C1_PRODUTO) )

			IF SC1->( DbSeek(xFilial("SC1")+SC1->(cNumSC) ) )
				SC1->(Reclock("SC1",.F.))
				SC1->C1_MOEDA := cCmoeda
				SC1->(MSUnlock())

				Do case
				Case SC1->C1_MOEDA == 2
					SM2->(DbSetOrder(1))
					SM2->( DbSeek(SM2->(dTos(dDatabase))) )
					nTaxa := SM2->M2_MOEDA2
				Case SC1->C1_MOEDA == 3
					SM2->(DbSetOrder(1))
					SM2->( DbSeek(SM2->(dTos(dDatabase))) )
					nTaxa := SM2->M2_MOEDA3
				Case SC1->C1_MOEDA == 6
					SM2->(DbSetOrder(1))
					SM2->( DbSeek(SM2->(dTos(dDatabase))) )
					nTaxa := SM2->M2_MOEDA6
				EndCase
			EndIf

			cC7_NUM := U_SC7COD(dDatabase) //Getsx8num("SC7","C7_NUM")
			//ConfirmSX8()
			aCabecPC	:={}
			aItemPC		:={}
			aRatPC		:= {}

			aCabecPC:=  {;
				{"C7_NUM"     ,cC7_NUM  	  		,Nil},; // Numero do Pedido
			{"C7_EMISSAO" ,dDataBase  		 	,Nil},; // Data de Emissao
			{"C7_FORNECE" ,SC1->C1_FORNECE 		,Nil},; // Fornecedor
			{"C7_LOJA"    ,SC1->C1_LOJA         ,Nil},; // Loja do Fornecedor
			{"C7_COND"    ,SC1->C1_CONDPAG		,Nil},; // Condicao de pagamento
			{"C7_CONTATO" ,""					,Nil},; // Contato
			{"C7_FILENT"  ,Iif(Empty(SC1->C1_FILENT),cFilAnt,SC1->C1_FILENT)	  	,Nil},; // Filial Entrega //Celso - alterei 29-08-17
			{"C7_XTPCPR"  ,SC1->C1_XTPCPR		,Nil},; // Tipo Compra
			{"C7_XSOLPA"  ,SC1->C1_XSOLPA		,Nil},; // Solic.PA
			{"C7_XVALPA"  ,SC1->C1_XVALPA		,Nil},; // Val.SOl.PA
			{"C7_XVENPA"  ,SC1->C1_XVENPA		,Nil},; // Ven.SOl.PA
			{"C7_XOBSAPR" ,SC1->C1_XOBSAPR		,Nil},; // Obs.Aprov.
			{"C7_XOBSFO"  ,SC1->C1_XOBSFO		,Nil},; // Obs.Fornc.
			{"C7_XMAILF"  ,SC1->C1_XMAILF		,Nil},; // e-MAIL FORNEC. //ANDRE
			{"C7_MOEDA"   ,SC1->C1_MOEDA        ,Nil},; // Moeda
			{"C7_TXMOEDA" ,nTaxa   			    ,Nil},; // Moeda
			{"C7_TES"	  ,SB1->B1_TE	 	   	,Nil}; //Codigo da TES
			}

			While !SC1->(EOF()) .AND. fwFilial("SC1")+cNumSC == SC1->(C1_FILIAL+C1_NUM)

				SB1->(DbSetOrder(1))
				SB1->( DbSeek(FwFilial("SB1")+SC1->C1_PRODUTO) )

				cItemPc := Soma1(cItemPc)

				Aadd(aItemPC,	{												  ;
					{"C7_ITEM"    ,cItemPc		          		,Nil},; //Numero do Item
				{"C7_PRODUTO" ,SC1->C1_PRODUTO 	   			,Nil},; //Codigo do Produto
				{"C7_DESC1"   ,SB1->B1_DESC       			,Nil},; //Descricao
				{"C7_UM"	  ,SC1->C1_UM 	   	   			,Nil},; //Unid.Medida
				{"C7_QUANT"   ,SC1->C1_QUANT	   			,Nil},; //Quantidade
				{"C7_PRECO"   ,SC1->C1_VUNIT	   			,Nil},; //Preco
				{"C7_OBS"     ,SC1->C1_OBS         			,NIL},; //Obs
				{"C7_DATPRF"  ,SC1->C1_DATPRF   			,Nil},; //Data De Entrega
				{"C7_OPER_F"  ,"01"						    ,Nil},; // Tp. Operacao
				{"C7_CC"      ,SC1->C1_CC   				,Nil},; //C.Custo
				{"C7_TES"     ,SB1->B1_TE   				,Nil},; //Tes - dava erro na filial 04
				{"C7_ITEMCTA" ,SC1->C1_ITEMCTA   			,Nil},; //Item Contabil
				{"C7_CLVL"    ,SC1->C1_CLVL   				,Nil},; //Classe Valor
				{"C7_T4FLROU" ,SC1->C1_T4FLROU   			,Nil},; //Lei Rouanet //	{"C7_XMAILF"  ,SC1->C1_XMAILF   			,Nil},; //Mail Fornecedor
				{"C7_NUMSC"   ,SC1->C1_NUM   				,Nil},; //NumSC
				{"C7_XMAILF"  ,SC1->C1_XMAILF       		,Nil},; // e-MAIL FORNEC.  ANDRE
				{"C7_ITEMSC"  ,SC1->C1_ITEM   				,Nil},; //Item SC
				{"C7_QTDSOL"  ,SC1->C1_QUANT   				,Nil},;  //Qtd SC
				{"C7_XCCAPR"  ,SC1->C1_CC   				,Nil},; //C.Custo p/aprovacao
				{"C7_USER"	  ,SC1->C1_USER   				,Nil},; //Usuário Solicitacao de compra	// inclusão MARCIO FRADE
				{"C7_SOLICIT" ,SC1->C1_SOLICIT   			,Nil}; 	//SOLICITANTE // inclusão MARCIO FRADE
				})
				//{"C7_SOLICIT" ,UsrFullName(SC1->C1_USER)    ,Nil}; 	//SOLICITANTE // inclusão MARCIO FRADE


				//if SM0->M0_CODIGO+SM0->M0_CODFIL='0804'
					//GravaPc()
				//endif
				_cFilEntrg	:= Iif(Empty(SC1->C1_FILENT),cFilAnt,SC1->C1_FILENT) // Celso 29-08-17
				_cC1Num		:= SC1->C1_NUM
				Select SC1
				RecLock("SC1",.f.)
				sc1->C1_ITEMPED := cItemPc
				sc1->C1_TES		:= sb1->b1_TE
				MsUnLock()
				SC1->(DbSkip())
			EndDo

			//Posicionamento Filial de Entrega
			_nRecSM0	:= SM0->( Recno() )
			_cEmpBkp	:= cEmpAnt
			_cFilBkp	:= cFilAnt
			_nRecC1Tmp	:= SC1->( Recno() )

			DbSelectArea("SM0")
			SM0->(DbSetOrder(1))
			SM0->( DbSeek(_cEmpBkp+_cFilEntrg) )
			cEmpAnt	:= SM0->M0_CODIGO
			cFilAnt	:= SM0->M0_CODFIL

			lMsErroAuto := .F.
//		if SM0->M0_CODIGO+SM0->M0_CODFIL<>'0804'
			MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCabecPC,aItemPC,3,,)
//		endif

			If lMsErroAuto
				Aviso("Problema gravando PEDIDO DE COMPRA ","Problema",{"Ok"})
				MostraErro()
				DisarmTransaction()
				Return
			Else

				SC1->( DbGoTo(_nRecC1Tmp) )
				_cNumPC := Posicione("SC1",1, xFilial("SC1")+_cC1Num, "C1_PEDIDO")

				If !Empty(_cNumPC)
					SC7->( DbSetOrder(1) )
					If SC7->(DbSeek(xFilial("SC7")+_cNumPC ) )
						While !SC7->( EOF()) .AND. xFilial("SC7")+_cNumPC == SC7->(C7_FILIAL+C7_NUM)
							RecLock("SC7",.F.)
							SC7->C7_USER := SC1->C1_USER //INCLUSÃO MARCIO FRADE
							//SC7->C7_USER := Posicione("SY1",1, xFilial("SY1")+cCompT4F, "Y1_USER")
							MsUnLock()
							SC7->(DbSkip())
						EndDo
						MsgInfo("Pedido de compra gerado com sucesso: " + _cNumPC)
					EndIf
				EndIf
			EndIf

			SM0->( DbGoTo(_nRecSM0) )
			cEmpAnt	:= _cEmpBkp
			cFilAnt	:= _cFilBkp

		EndIf
	EndIf

	SC1->(DbGoTo(nRecSC1))
Return

/*Static Function GravaPC()  // Grava quando filial for 04 - km de Vantagens (Luiz Eduardo - 22/05/2018)

	Select SC7
	RecLock("SC7",.t.)
	SC7->C7_FILIAL	:= xFilial()
	SC7->C7_NUM		:= cC7_NUM
	SC7->C7_EMISSAO	:= dDataBase
	SC7->C7_FORNECE	:= sc1->c1_fornece
	SC7->C7_LOJA	:= sc1->c1_loja
	SC7->C7_COND	:= sc1->c1_condpag
	SC7->C7_CONTATO	:= ""
	SC7->C7_FILENT	:= Iif(Empty(SC1->C1_FILENT),cFilAnt,SC1->C1_FILENT)
	SC7->C7_XTPCPR	:= SC1->C1_XTPCPR
	SC7->C7_XSOLPA	:= SC1->C1_XSOLPA
	SC7->C7_XVALPA	:= SC1->C1_XVALPA
	SC7->C7_XVENPA 	:= SC1->C1_XVENPA
	SC7->C7_XOBSAPR	:= SC1->C1_XOBSAPR
	SC7->C7_XOBSFO	:= SC1->C1_XOBSFO
	SC7->C7_XMAILF	:= SC1->C1_XMAILF
	SC7->C7_MOEDA	:= 1
	SC7->C7_TXMOEDA	:= 1

	SC7->C7_ITEM	:= SC1->C1_ITEM
	SC7->C7_PRODUTO	:= SC1->C1_PRODUTO
	SC7->C7_TES		:= SB1->B1_TE
	SC7->C7_DESCRI	:= SB1->B1_DESC
	SC7->C7_UM		:= SC1->C1_UM
	SC7->C7_QUANT	:= SC1->C1_QUANT
	SC7->C7_PRECO	:= SC1->C1_VUNIT
	SC7->C7_TOTAL	:= SC1->C1_T4FTOT
	sc7->C7_OBS		:= SC1->C1_OBS
	sc7->C7_DATPRF	:= SC1->C1_DATPRF

	SC7->C7_CONTA	:= SB1->B1_CONTA
	SC7->C7_ITEMCTA	:= SB1->B1_ITEMCTA
	SC7->C7_PREOPER	:= "R"
	SC7->C7_LOCAL	:= "01"
	SC7->C7_IPIBRUT	:= "B"


	sc7->C7_OPER_F	:= "01"
	sc7->C7_CC		:= SC1->C1_CC
	sc7->C7_ITEMCTA	:= SC1->C1_ITEMCTA
	sc7->C7_CLVL	:= SC1->C1_CLVL
	sc7->C7_T4FLROU	:= SC1->C1_T4FLROU
	sc7->C7_NUMSC	:= SC1->C1_NUM
	sc7->C7_XMAILF	:= SC1->C1_XMAILF
	sc7->C7_ITEMSC	:= SC1->C1_ITEM
	sc7->C7_QTDSOL	:= SC1->C1_QUANT
	sc7->C7_XCCAPR	:= SC1->C1_CC
	sc7->C7_USER	:= SC1->C1_USER
	sc7->C7_SOLICIT	:= UsrFullName(SC1->C1_USER)
	MsUnLock()

return*/

User Function VerAnexo(cNumSC1)
Local cPathZIPs	:= Lower(AllTrim(GetMv("MV_XPATHZIP",,"\anexos_scs\")))
Local lRet := .F.
                
	If (File(Lower(cPathZIPs)+Lower(cNumSC1)+".zip"))
  lRet := .T.
	EndIf
Return lRet
