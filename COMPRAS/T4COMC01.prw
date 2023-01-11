#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    T4COMC01   º Autor ³ Giovani.Zago       º Data ³  24/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descri‡„o ³ Gera  Solicitação de PA (financeiro)					  º±±
±±º           ³ de acordo com o pedido de compra Posicionado(SC7)		  º±±
±±º           ³ Plcom05                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß           
/*/
*----------------------------------------*
User Function T4COMC01(_nValPa,_dPa)
*----------------------------------------*
	Local _areaAll		:= getarea()          
	Local _areaSCR		:= SCR->(GetArea())
	Local _areaSC7		:= SC7->(getarea())
	Local _lRet			:= .F.           
	Local _cUsrSolic	:= ""     
	Local _lAlcadas		:= IsInCallStack("U_WFPC") .OR. IsInCallStack("U_MT097END")         
	Local _nRecSCR		:= SCR->(Recno())
	Local _cSql			:= ""
	Local _cNumero		:= GetSX8Num("ZZE","ZZE_NUMERO")
	Local _lOk			:= .T.
	Local cC7NUM		:= SC7->C7_NUM
   
	Default _nValPa		:= SC7->C7_XVALPA
	Default _dPa		:= SC7->C7_XVENPA           
	
	If ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
	//Alterado 16/12/2015 - BZO - Duplicação da numeração.
		ZZE->(Confirmsx8())
		ZZE->(dbGoTop())
		_lOk	:= ZZE->(dbSeek(xFilial("ZZE") + _cNumero))
		While _lOk
			_cNumero   := GetSX8Num("ZZE","ZZE_NUMERO")
			ZZE->(Confirmsx8())
			ZZE->(dbGoTop())
			If ZZE->(!dbSeek(xFilial("ZZE") + _cNumero))
				_lOk	:= .F.
			EndIf
		EndDo
	EndIf

	DbSelectArea('SC7')
	SC7->(DbSetOrder(1)) 
	SC7->(DbSeek(xFilial('SC7')+cC7NUM))
	
	DbSelectArea('ZZE')
	ZZE->(DbSetOrder(2))  //ZZE_FILIAL+ZZE_PEDIDO
	If !(ZZE->(DbSeek(xFilial('ZZE')+SC7->C7_NUM)))
		
		DbSelectArea('SA2')
		SA2->(DbSetOrder(1))  //A2_FILIAL+A2_COD+A2_LOJA
		If SA2->(DbSeek(xFilial('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA))  
		
			If SC7->C7_XTPCPR $ "E,D"	
				_cUsrSolic	:= Posicione("SC1",1,xFilial("SC1")+SC7->C7_NUMSC, "C1_USER")
			Else          
				_cUsrSolic	:= SC7->C7_USER
			EndIf
			
			If RecLock("ZZE",.T.)
				ZZE_FILIAL	:=	xFilial('ZZE')
				ZZE_ITEM	:=  '001'
				ZZE_TIPO	:= 	1
				ZZE_NUMERO  :=	_cNumero //GetSxeNum("ZZE","ZZE_NUMERO")
				ZZE_FORNEC	:=  SC7->C7_FORNECE
				ZZE_LOJA	:=	SC7->C7_LOJA
				ZZE_NOMFOR	:=	SA2->A2_NOME
				ZZE_VALOR	:=	_nValPa//SC7->C7_XVALPA
				ZZE_HISTOR	:=	'ADIANTAMENTO AUTOMATICO GERADO PELO PC '+SC7->C7_NUM
				ZZE_STATUS	:=	'L'
				ZZE_BANCO	:=	SA2->A2_BANCO
				ZZE_AGENC	:=	SA2->A2_AGENCIA + SA2->A2_DVAGENC
				ZZE_CONTA	:=	SA2->A2_NUMCON + SA2->A2_DVCONTA
				ZZE_DATA	:=  _dPa//	SC7->C7_XVENPA
				ZZE_CCUSTO	:=	SC7->C7_CC
				ZZE_PEP	    :=	SC7->C7_ITEMCTA
				ZZE_PEDIDO	:=	SC7->C7_NUM
				ZZE_MOEDA	:=	1    
				ZZE_USERID  := _cUsrSolic
				
				ZZE->( MsUnLock() )
				ZZE->( DbCommit() )   
				ZZE->(ConfirmSX8())
				
			EndIf
			
			If _lAlcadas //Gera SCR referente ZZE para ficar compativel com customizacao existente da T4F - 10/12/2013  
				//_cSql := " SELECT * FROM " + RetSqlName("SCR") + " SCR "
				_cSql := " SELECT * FROM " + RetSqlName("SCR") + " SCR "
				_cSql += " WHERE CR_FILIAL = '" + xFilial("SCR") + " ' "
				_cSql += " AND CR_TIPO = 'PC' "
				_cSql += " AND RTRIM(CR_NUM)= '" + SC7->C7_NUM + "' "
				_cSql += " AND SCR.D_E_L_E_T_ = ' ' "
	 			_cSql := ChangeQuery(_cSql)
				
				If Select("QRY") > 0
					QRY->( DbCloseArea() )
				EndIf
				DbUseArea(.T., "TOPCONN", TcGenQry( , , _cSql), "QRY")
					
				If !QRY->( EOF() )
					While !QRY->( EOF() ) 
						RecLock("SCR",.T.)
						SCR->CR_FILIAL	:= xFilial("SCR")  
						SCR->CR_TIPO	:= "ZZ"
						SCR->CR_USER	:= QRY->CR_USER
						SCR->CR_APROV	:= QRY->CR_APROV
						SCR->CR_NIVEL	:= QRY->CR_NIVEL
						SCR->CR_STATUS	:= QRY->CR_STATUS
						SCR->CR_DATALIB	:= STOD(QRY->CR_DATALIB)
						SCR->CR_TOTAL	:= QRY->CR_TOTAL
						SCR->CR_EMISSAO	:= STOD(QRY->CR_EMISSAO)
						SCR->CR_USERLIB	:= QRY->CR_USERLIB
						SCR->CR_LIBAPRO	:= QRY->CR_LIBAPRO
						SCR->CR_VALLIB	:= QRY->CR_VALLIB
						SCR->CR_TIPOLIM	:= QRY->CR_TIPOLIM  
						SCR->CR_MOEDA	:= QRY->CR_MOEDA
						SCR->CR_TXMOEDA	:= QRY->CR_TXMOEDA
						SCR->CR_NUM		:= ZZE->ZZE_NUMERO
						SCR->CR_USERORI	:= QRY->CR_USERORI
						SCR->CR_APRORI	:= QRY->CR_APRORI
						
						SCR->( MsUnLock() )
						              
						QRY->( DbSkip() )
					EndDo 
				EndIf
	
				SCR->( DbGoTo(_nRecSCR) )
			EndIf
			
		Else
			MsgInfo('Fornecedor Não Localizado a Solicitação de PA Não Será Cadastrada !!!!!!!!')
		_lRet:= .F.	
		EndIf
	Else
	//	MsgInfo('Solicitação de PA Já Cadastrado !!!!!!!!')
		_lRet:= .F.
	EndIf
	
	DbSelectArea('ZZE')
	ZZE->(DbSetOrder(2))  //ZZE_FILIAL+ZZE_PEDIDO
	If ZZE->(DbSeek(xFilial('ZZE')+SC7->C7_NUM))
		_lRet:= .T.
	EndIf
	
	RestArea(_areaAll)
	RestArea(_areaSCR)
	RestArea(_areaSC7)
	
Return(_lRet)
