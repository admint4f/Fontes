#Include "Rwmake.Ch"

User Function CONSE2AB()
	MSAGUARDE( {||PROCCONSE2AB()})
Return

STATIC FUNCTION PROCCONSE2AB()                          
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
//Local aButtons   := {{"S4WB059N",{|| Total(aTotal) },"Pesquisa Total"},{"S4WB061N",{|| U_CONSD1() },"Pesquisa Itens"}}
Private cAliasTRB := AllTrim("SE2SE2" + xFilial("SE2"))

//Pergunte(cPerg,.T.)

//dbSelectArea("SF1")
//dbSetOrder(2)
//dbGotop()

//DbSeek(xFilial("SD1")+dtos(mv_par01),.T.)

cQuery := "Select E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCREA,E2_VALOR,E2_BAIXA,E2_CLVL,E2_NUMBOR,E2_BCOPAG,E2_FATURA,E2_NUMPC "
cQuery += "From " + RetSqlName("SE2") + " "
cQuery += "Where E2_FILIAL     = '" + xFilial("SE2") + "' " 
cQuery += " And E2_EMISSAO >= '20070101' "
cQuery += "  And D_E_L_E_T_     = ' '"
cQuery += "Order By E2_NOMFOR"

cQuery := ChangeQuery(cQuery)
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasTRB,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

//CTD->(dbSetOrder(1))
//CTT->(dbSetOrder(1))

dbSelectArea(cAliasTRB)
dbGoTop()


While !EOF()  //.And. F1_FILIAL = xFilial("SF1") //.And. dtos(SD1->D1_EMISSAO) <= dtos(mv_par02)

IF E2_CLVL <> "BAYB"
	dbSkip()
	Loop
ENDIF                    

//aAdd(aNota, { E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,E2_VENCREA,E2_VALOR,E2_BAIXA,E2_CLVL,E2_NUMBOR,E2_BCOPAG,E2_FATURA,E2_NUMPC })
aAdd(aNota, { E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,substr(E2_EMISSAO,7,2)+ "/" + substr(E2_EMISSAO,5,2) + "/" + substr(E2_EMISSAO,3,2),substr(E2_VENCREA,7,2)+"/"+substr(E2_VENCREA,5,2)+"/"+substr(E2_VENCREA,3,2),E2_VALOR,substr(E2_BAIXA,7,2)+"/"+substr(E2_BAIXA,5,2)+"/"+substr(E2_BAIXA,3,2),E2_CLVL,E2_NUMBOR,E2_BCOPAG,E2_FATURA,E2_NUMPC })

	dbSkip()

EndDo     

If Len(aNota) > 0


//	Define MsDialog oDlg Title "Consulta da Analise: " + mv_par01 + c7_artista From 0,0 To 516,791 Of oMainWnd Pixel
    Define MsDialog oDlg Title "Consulta Titulos : "  From 0,0 To 516,791 Of oMainWnd Pixel

// "PREFIXO","NUM","PARCELA","TIPO","FORNECE","LOJA","NOMFOR","EMISSAO","VENCREA","VALOR","BAIXA","CLVL","NUMBOR","BCOPAG","FATURA","NUMPC"



	@ 13,0 ListBox oLbx Fields Header "PREFIXO","NUM","PARCELA","TIPO","FORNECE","LOJA","NOMFOR","EMISSAO","VENCREA","VALOR","BAIXA","CLVL","NUMBOR","BCOPAG","FATURA","NUMPC";		
							Size 382,220 Of oDlg Pixel
	oLbx:SetArray(aNota)
	oLbx:bLine := { || { aNota[oLbx:nAt,1],aNota[oLbx:nAt,2],aNota[oLbx:nAt,3],aNota[oLbx:nAt,4],aNota[oLbx:nAt,5],aNota[oLbx:nAt,6],aNota[oLbx:nAt,7],aNota[oLbx:nAt,8],aNota[oLbx:nAt,9],transform(aNota[oLbx:nAt,10],"@E 9,999,999.99"),aNota[oLbx:nAt,11],aNota[oLbx:nAt,12],aNota[oLbx:nAt,13],aNota[oLbx:nAt,14],aNota[oLbx:nAt,15],aNota[oLbx:nAt,16] } }

    Activate MsDialog oDlg Center On Init EnchoiceBar(oDlg,{||oDlg:End()},{||oDlg:End()},,)
Else
	Aviso("ATENÇÃO !!!","Não Há Notas " + AllTrim(aNota) + " !",{ " << Voltar " },2," " )
EndIf   

(cAliasTRB)->(dbCloseArea())

//RestArea(aAreaAnt)
Return()


