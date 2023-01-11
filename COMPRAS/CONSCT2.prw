USER FUNCTION CONSCT2()

Local aAnalise := {}   
Local oDlg
Local oLbx
// Local aPlanos := {}
local cperg := "CCT2"     
local ntotal := 0
Local aAreaAnt  := GetArea()
Local aButtons   := {{"S4WB061N",{|| U_CONSD1() },"Pesquisa Itens"}}

Pergunte(cPerg,.T.)

dbSelectArea("CT2")
dbSetOrder(4)

DbSeek(xFilial("CT2")+mv_par03+DTOS(mv_par01),.T.)

While !Eof() .And. CT2->CT2_DATA <= mv_par02
        
        if 	CT2->CT2_TPSALD <> "3"
            dbSkip()
            Loop
        endif
        
        if SUBS(CT2->CT2_DEBITO,1,2) < "40"        
            dbSkip()
            Loop
        endif

        if CT2->CT2_CCD <> mv_par03
           dbSKip()
           Loop
        endif
        
        
 // SELECT CT2080.CT2_DATA, CT2080.CT2_CLVLCR, CT2080.CT2_CLVLDB, CT2080.CT2_CCC, CT2080.CT2_CCD, CT2080.CT2_ITEMC, CT2080.CT2_ITEMD, CT2080.CT2_VALOR, CT2080.CT2_HIST, CT2080.CT2_CREDIT, CT2080.CT2_DEBITO, CT2080.D_E_L_E_T_, CT2080.CT2_ORIGEM, CT2080.CT2_USUARI, CT2080.CT2_ATIVCR, CT2080.CT2_ATIVDE        
        nome    := Posicione("CT1",1,xFilial("CT1")+CT2->CT2_DEBITO,"CT1_DESC01")
        // produto := Posicione("SB1",1,xFilial("SB1")+Sc7->C7_PRODUTO,"B1_DESC") 
		aAdd(aAnalise, { CT2_DATA, CT2_CLVLDB, CT2_CCD , CT2_VALOR, "D", CT2_HIST , CT2_DEBITO, NOME, CT2_ORIGEM, CT2_ATIVDE, CT2_USUARI  })
        nTotal := nTotal + (CT2_VALOR*-1)
		dbSkip()
EndDo

dbGotop()
dbSetorder(5)

DbSeek(xFilial("CT2")+mv_par03+DTOS(mv_par01),.T.)

While !Eof() .And. CT2->CT2_DATA <= mv_par02

        if CT2->CT2_CCC <> mv_par03
           dbSKip()
           Loop
        endif 
        
        if SUBS(CT2->CT2_CREDIT,1,2) < "40"        
            dbSkip()
            Loop
        endif
        
        if 	CT2->CT2_TPSALD <> "3"
            dbSkip()
            Loop
        endif
 // SELECT CT2080.CT2_DATA, CT2080.CT2_CLVLCR, CT2080.CT2_CLVLDB, CT2080.CT2_CCC, CT2080.CT2_CCD, CT2080.CT2_ITEMC, CT2080.CT2_ITEMD, CT2080.CT2_VALOR, CT2080.CT2_HIST, CT2080.CT2_CREDIT, CT2080.CT2_DEBITO, CT2080.D_E_L_E_T_, CT2080.CT2_ORIGEM, CT2080.CT2_USUARI, CT2080.CT2_ATIVCR, CT2080.CT2_ATIVDE        
        nome    := Posicione("CT1",1,xFilial("CT1")+CT2->CT2_CREDIT,"CT1_DESC01")
        // produto := Posicione("SB1",1,xFilial("SB1")+Sc7->C7_PRODUTO,"B1_DESC") 
		aAdd(aAnalise, { CT2_DATA, CT2_CLVLCR, CT2_CCC , CT2_VALOR , "C", CT2_HIST , CT2_CREDIT, NOME, CT2_ORIGEM, CT2_ATIVDE, CT2_USUARI  })
        nTotal := nTotal + CT2_VALOR

		dbSkip()
EndDo        
        if nTotal < 0
            nTotal := nTotal *-1
			aAdd(aAnalise, { ,"Total -->" , , nTOTAL ,"D"  , , , , , ,})
        else
            aAdd(aAnalise, { ,"Total -->" , , nTOTAL ,"C"  , , , , , ,})
        endif
        
        desccc := Posicione("CTT",1,xFilial("CTT")+mv_par03,"CTT_DESC01")

		If Len(aAnalise) > 0
			Define MsDialog oDlg Title "Consulta : " + DESCCC  From 0,0 To 516,791 Of oMainWnd Pixel
			@ 13,0 ListBox oLbx Fields Header "Data","Divisao","Centro Custo","Valor","D/C","Historico","Conta","Descricao","Origem","Cod.Forn./Doc","Usuario","" ;
							Size 382,220 Of oDlg Pixel
			oLbx:SetArray(aAnalise)
			oLbx:bLine := { || { aAnalise[oLbx:nAt,1],aAnalise[oLbx:nAt,2], aAnalise[oLbx:nAt,3],transform(aAnalise[oLbx:nAt,4],"@E 9,999,999.99"),aAnalise[oLbx:nAt,5],aAnalise[oLbx:nAt,6],aAnalise[oLbx:nAt,7],aAnalise[oLbx:nAt,8],aAnalise[oLbx:nAt,9],aAnalise[oLbx:nAt,10],aAnalise[oLbx:nAt,11] } }

//			Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
            Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons) 
		Else
			Aviso("ATENÇÃO !!!","Não Há Dados para a Analise " + AllTrim(aAnalise) + " !",{ " << Voltar " },2," " + AllTrim(mv_par01))
		EndIf


//RestArea(aAreaAnt)

Return
