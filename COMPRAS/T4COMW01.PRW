#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE CRLF (chr(13)+chr(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    T4COMW01   º Autor ³ Giovani.Zago       º Data ³  17/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descri‡„o ³ Notificação  cancelamento de S.C.						  º±±
±±º           ³ 														  º±±
±±º           ³  Plw02                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*----------------------------------------*
User Function T4COMW01()
*----------------------------------------*
Local _areaAll    := getarea()
Private _cUserSis  := __cuserid
Private _cNumSc1    := ParamIXB[1]
Private cTime           := Time()
Private cHora           := SUBSTR(cTime, 1, 2)
Private cMinutos    	:= SUBSTR(cTime, 4, 2)
Private cSegundos   	:= SUBSTR(cTime, 7, 2)
Private cAliasLif   	:= 'T4COMW01'+cHora+ cMinutos+cSegundos
Private cDestEmail     := ' '


If (!INCLUI .and. !ALTERA) // exclui
	StQuery()
	dbSelectArea(cAliasLif)
	(cAliasLif)->(dbgotop())
	If  Select(cAliasLif) > 0
		
		If (cAliasLif)->C1_USER  <> _cUserSis
			PswOrder(1)
			If PswSeek((cAliasLif)->C1_USER, .T. )
				
				cDestEmail := PSWRET(1)[1][14]
			Endif
			
			DbSelectArea("SY1")
			SY1->( Dbsetorder(1) )
			If SY1->( dbSeek(xFilial("SY1")+(cAliasLif)->C1_CODCOMP) )
				If (cAliasLif)->C1_USER  <> _cUserSis .And. SY1->Y1_USER  <> _cUserSis
					PswOrder(1)
					If PswSeek(SY1->Y1_USER, .T. )
						cDestEmail += ' ; '+PSWRET(1)[1][14]
				    Endif
				Endif
				
			Endif
		Else
			DbSelectArea("SY1")
			SY1->( Dbsetorder(1) )
			If SY1->( dbSeek(xFilial("SY1")+(cAliasLif)->C1_CODCOMP) )
				PswOrder(1)
				If PswSeek(SY1->Y1_USER, .T. )
					
					cDestEmail := PSWRET(1)[1][14]
					
				Endif
			Endif
			
		EndIf
	EndIf


	If !Empty(Alltrim(cDestEmail))
		
		TelaExcl(cDestEmail)
		
	EndIf
EndIf
RestArea(_areaAll)
Return()



Static Function StQuery()

Local cQuery     := ' '

cQuery  := "SELECT * FROM "+RetSqlName("SC1")+" WHERE C1_FILIAL = '" + xFilial("SC1")+"' AND C1_NUM = '"+_cNumSc1+"' "

cQuery := ChangeQuery(cQuery)

If Select(cAliasLif) > 0
	(cAliasLif)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasLif)

Return()



/*====================================================================================\
|Programa  | TelaExcl         | Autor | GIOVANI.ZAGO             | Data | 17/10/2013  |
|=====================================================================================|
|Descrição | TelaExcl                                                                 |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | TelaExcl                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
Static Function TelaExcl(cDestEmail)
*-----------------------------*

Local cInd        := "1"
Local cGetMotivo  := Space(100)
Local nOpcao      := 0
Local lRetorno    := .T.
Local lSaida      := .f.
Local _cAssunto  := 'Exclusão de Solicitação de Compras '
Local cMsg := ' '
Do While !lSaida
	nOpcao := 0
	
	Define msDialog oDxlg Title "Exclusão de Solicitação de Compra" From 10,10 TO 260,600 Pixel
	
	@ 050,010 say "Motivo da Exclusao:" COLOR CLR_HBLUE  Of oDxlg Pixel
	@ 060,010 get cGetMotivo valid !empty(cGetMotivo) size 165,08  Of oDxlg Pixel
	
	DEFINE SBUTTON FROM 102,130 TYPE 1 ACTION IF(!empty(cGetMotivo),(lSaida:=.T.,nOpcao:=1,oDxlg:End()),msgInfo("Motivo da Exclusao não preenchido","Atenção")) ENABLE OF oDxlg
	
	Activate dialog oDxlg centered
	
EndDo

If nOpcao == 1
	cMsg:='A solicitação de compra: '+_cNumSc1+', emitida em '+dtoc(ddatabase)+', Pelo Usuario: '+cUsername+CRLF+CRLF+;
	'Observação Digitada: '+cGetMotivo   
	
	 _cAssunto += _cNumSc1
	u_T4COMMAIL(cDestEmail,'' , _cAssunto, cMsg,,'')
EndIf

Return()

