#INCLUDE "TOTVS.CH"

user function IMPNFS()

	Local oDlg1
	Local oButton1
	Local oButton2
	Local oSay1
	Local oGet1
	Local oSay2
	Local oGet2
	Local lHasButton := .T.
	Private cTGet1 := 'NFs-e de '
	Private cTGet2 := 'NFs-e ate'

	oDlg1   := TDialog():New(0,0,200,200,'Impressão NFS-e SãoPaulo',,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	oSay1   := TSay():New(022,008,{||'NFs de:'},oDlg1,,,,,,.T.,CLR_BLUE,CLR_WHITE,300,20)
	oGet1   := TGet():New(020,030,{ | u | If( PCount() == 0, cTGet1, cTGet1 := u ) },oDlg1,050,010,"!@",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cGet1",,,,lHasButton)
	oSay2   := TSay():New(042,008,{||'NFs ate:'},oDlg1,,,,,,.T.,CLR_BLUE,CLR_WHITE,300,20)
	oGet2   := TGet():New(040,030,{ | u | If( PCount() == 0, cTGet2, cTGet2 := u ) },oDlg1,050,010,"!@",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,"cGet1",,,,lHasButton)
	oButton1:= TButton():New(070,015,"Imprimir",oDlg1,{||SITEPREF()},30,10,,,.F.,.T.,.F.,,.F.,,,.F.)
	oButton2:= TButton():New(070,055,"Cancelar",oDlg1,{|| oDlg1:End()},30,10,,,.F.,.T.,.F.,,.F.,,,.F.)

	oDlg1:Activate(,,,.T.)

Return

Static Function SITEPREF()

	Local cNumNfde  := SubStr(cTGet1,3,7)
	Local cNumNfate := SubStr(cTGet2,3,7)
	Local nCount := (Val(cNumNfate))-(Val(cNumNfde))
	Local aCcm := {}
	Local aNfs := {}
	//Local n := 0
    Local i

	aCcm := FWSM0Util():GetSM0Data(FWCodEmp(),cFilAnt,{"M0_INSCM"})// Caso tenha que buscar a incrição municipal pela SM0
	cCcm := Alltrim(aCcm[1][2])

	DbselectArea('SF3')
	SF3->(DbsetOrder(6))
	SF3->(Dbgotop())
	SF3->(MsSeek(xFilial('SF3')+cTGet1+'E  '))

	While SF3->(!(EOF())) .AND. SF3->F3_NFISCAL >= cTGet1 .AND.  SF3->F3_NFISCAL <= cTGet2 .and. (SF3->F3_CFO=='5933 ' .OR. SF3->F3_CFO=='6933 ')
		If nCount >= 0
			//For n := 0 to Len(nCount)
            //SF3->(MsSeek(xFilial('SF3')+(strzero((val(cTGet1)+n),9)+'E  ')))
			Aadd(aNfs,{SF3->F3_NFISCAL,Alltrim(SF3->F3_CODNFE)})
            SF3->(Dbskip())
			//Next n
		EndIf
	EndDo

	//'https://nfe.prefeitura.sp.gov.br/nfe.aspx?ccm=27429733&nf=2030200&cod=SKHF34C2'

    For i := 1 to len(aNfs)
	ShellExecute( "open", 'https://nfe.prefeitura.sp.gov.br/nfe.aspx?ccm='+cCcm+'&nf='+SubStr(aNfs[i][1],3,7)+'&cod='+aNfs[i][2], "", "", 3 )
    Next i

	SF3->(DBCloseArea())

Return
