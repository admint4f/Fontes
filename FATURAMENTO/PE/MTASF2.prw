#Include "Protheus.Ch"
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³MTASF2   ºAutor  ³Ronald Piscioneri   º Data ³  07/08/09   º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³Grava Nro da NF da Prefeitura SP em campo de usuario        º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³Especifico T4F                                              º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
User Function MTASF2()
Local lTrt01	:= ( SuperGetMV("T4F_MTASF2",,"S") == "S" )
Local lGo		:= .F.
Local cGet		:= Space(9)
Local oDlg1
Local oGet

If lTrt01
	If cEmpAnt == "08"
		If cFilAnt == "01"
			If Alltrim(SF2->F2_SERIE) == "B"
				If FieldPos("F2_DOCISS") > 0
					Define MsDialog oDlg1 Title "NF de Servico" Of oMainWnd Pixel From 0,0 To 080,400
						@ 020,005 Say "NF Prefeitura SP" Size 050,008 COLOR CLR_BLUE PIXEL OF oDlg1 
						@ 020,060 MsGet oGet Var cGet Valid !Empty(cGet) Size 050,008 PIXEL OF oDlg1
					Activate MsDialog oDlg1 Center On Init EnchoiceBar( oDlg1 , {|| lGo:=.T.,oDlg1:End()} , {|| lGo:=.F.,oDlg1:End()} )

					If lGo
						If !Empty(cGet)
							RecLock("SF2",.F.)
							SF2->F2_DOCISS := cGet
							SF2->(msUnLock())
							TcSqlExec("Commit")
						EndIf		
					EndIf

				EndIf
			EndIf
		EndIf
	EndIf
EndIf         

Return .T.