#Include "Rwmake.Ch"

User Function CONSF1()
	MSAGUARDE( {||PROCCONSF1()})
Return

STATIC FUNCTION PROCCONSF1()                          
Local aNota := {}   
Local aTotal := {}
Local nQuant := 0
Local oDlg
Local oLbx
Local oBtn
// Local aPlanos := {}
//local cperg := "RSE2"
//Local aAreaAnt  := GetArea()
Local nTotal := 0
Local aButtons   := {{"S4WB059N",{|| Total(aTotal) },"Pesquisa Total"},{"S4WB061N",{|| U_CONSD1() },"Pesquisa Itens"}}
Private cAliasTRB := AllTrim("SF1SF1" + xFilial("SF1"))

//Pergunte(cPerg,.T.)

//dbSelectArea("SF1")
//dbSetOrder(2)
//dbGotop()

//DbSeek(xFilial("SD1")+dtos(mv_par01),.T.)

cQuery := "Select F1_DOC,F1_VALBRUT,F1_FORNECE,F1_EMISSAO "
cQuery += "From " + RetSqlName("SF1") + " "
cQuery += "Where F1_FILIAL     = '" + xFilial("SF1") + "' " 
cQuery += "  And D_E_L_E_T_     = ' '"
cQuery += "Order By F1_FORNECE"

cQuery := ChangeQuery(cQuery)
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

//CTD->(dbSetOrder(1))
//CTT->(dbSetOrder(1))

dbSelectArea(cAliasTRB)
dbGoTop()


While !EOF()  //.And. F1_FILIAL = xFilial("SF1") //.And. dtos(SD1->D1_EMISSAO) <= dtos(mv_par02)

	x:=F1_FORNECE
	nTotal := nTotal + F1_VALBRUT
	nQuant := nQuant + 1
        
	nome      := Posicione("SA2",1,xFilial("SA2")+F1_FORNECE,"A2_NOME")
    aAdd(aNota, { F1_DOC,F1_VALBRUT,F1_FORNECE, NOME, F1_EMISSAO  })
    codforne := F1_FORNECE    
//    MSPROCTXT("DOCUMENTO "+ F1_DOC)
	dbSkip()
	y:=F1_FORNECE

	IF Y <> X
       aAdd(aNota, { "T O T A L =========> ",nTotal,"","","" })
       aAdd(aTotal, { nTotal,CODFORNE,NOME,nQuant } )
       nTotal := 0
       nQuant := 0
	ENDIF

EndDo     

If Len(aNota) > 0


//	Define MsDialog oDlg Title "Consulta da Analise: " + mv_par01 + c7_artista From 0,0 To 516,791 Of oMainWnd Pixel
    Define MsDialog oDlg Title "Consulta Notas Fiscais: "  From 0,0 To 516,791 Of oMainWnd Pixel
			
	@ 13,0 ListBox oLbx Fields Header "Nr.Documento","Valor Bruto","Codigo Fornecedor","Nome Fornecedor","Emissao" ;
							Size 382,220 Of oDlg Pixel
	oLbx:SetArray(aNota)
	oLbx:bLine := { || { aNota[oLbx:nAt,1],transform(aNota[oLbx:nAt,2],"@E 9,999,999.99"),aNota[oLbx:nAt,3],aNota[oLbx:nAt,4],aNota[oLbx:nAt,5] } }

    Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,aButtons)
Else
	Aviso("ATENÇÃO !!!","Não Há Notas " + AllTrim(aNota) + " !",{ " << Voltar " },2," " )
EndIf   

(cAliasTRB)->(dbCloseArea())

//RestArea(aAreaAnt)
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONSF1    ºAutor  ³Microsiga           º Data ³  04/29/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³TOTAIS                                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

// Totais
Static Function total(aTotal)

If Len(aTotal) > 0
// For I := 1 to len(aTotal)
//   aTotal[I,1] := str(aTotal[I,1])
// Next 
 aTotal := aSort(aTotal,,,{ |x,y| x[1] > y[1] } )


//	Define MsDialog oDlg Title "Consulta da Analise: " + mv_par01 + c7_artista From 0,0 To 516,791 Of oMainWnd Pixel
    Define MsDialog oDlg Title "Consulta Notas Fiscais: "  From 0,0 To 516,791 Of oMainWnd Pixel
			
	@ 13,0 ListBox oLbx Fields Header "Total","Codigo Fornecedor","Nome Fornecedor","Docs.Emitidos" ;
							Size 382,220 Of oDlg Pixel
	oLbx:SetArray(aTotal)
	oLbx:bLine := { || { transform(aTotal[oLbx:nAt,1],"@E 9,999,999.99"),aTotal[oLbx:nAt,2],aTotal[oLbx:nAt,3],aTotal[oLbx:nAt,4] } }


    Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()})
Else
	Aviso("ATENÇÃO !!!","Não Há Notas " + AllTrim(aNota) + " !",{ " << Voltar " },2," " )
EndIf

Return()


