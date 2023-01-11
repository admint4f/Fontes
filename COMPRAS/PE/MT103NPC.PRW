#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#define CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103NPC  ºAutor  ³Luiz Eduardo        º Data ³  18/07/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na Validacao da TES Pessoa Física                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//*****************
User Function MT103NPC

// Em 09/07/2020 - Incluída validação verificando se existem pedidos de compras de PA em aberto para o fornecedor
VerAdto()
/*
dbSelectArea("SC7")
dbSetOrder(1)
cNum:= sc7->c7_num
seek xFilial()+cNum
lAlterou := .f.
Do while !eof() .and. c7_Num = cNum
	
	_Regra := Posicione("SF4",1,xFilial("SF4")+SC7->C7_TES,"F4_REGRA")
	If _Regra<>"08" .and. sa2->a2_tipo="F" //Empty(cA100For) .Or. Empty(cLoja)
		//Recalculo dos Impostos
		//Caso tenha Elemento PEP será custo (TES 181) caso contrário será despesa (TES 182)
		if !empty(SC7->C7_ITEMCTA)
			RecLock("SC7",.f.)
			SC7->C7_TES := "181"
			MsUnLock()
			cTes := "181"
		else
			RecLock("SC7",.f.)
			SC7->C7_TES := "182"
			MsUnLock()
			cTes := "182"
		endif
		lAlterou := .t.
	EndIf
	
	skip
Enddo
if lAlterou
	//Preenche o aCols
	For i := 1 To Len(aCols)
		N := Len(aCols)
		For j := 1 To Len(aHeader)
			If AllTrim(aHeader[j][2]) == "D1_TES"
				aCols[Len(aCols)][j] := cTES
				MaFisAlt("IT_TES",cTES,n)
				MaFisToCols(aHeader,aCols,,"MT100")
				MaFisAlt("IT_ALIQICM",0,n)		
				MaFisAlt("IT_ALIQIPI",0,n)		
				MaFisAlt("IT_ALIQISS",0,n)		
			endif
		Next j
	Next i
	Eval(bRefresh)
	Eval(bGDRefresh)

Endif
*/
Return .t.

*-----------------------------------*
Static Function VerAdto()
*-----------------------------------*

Local cQuery     := ' '
 cTime1 := time()
//SELECT C7_NUM,C7_EMISSAO,C7_XDTRESI,C7_XUSRRES,C7_CONAPRO,C7_ENCER,C7_RESIDUO,C7_QUANT,C7_QUJE,D_E_L_E_T_ FROM SC7080 WHERE C7_NUM='0E1756'

cQuery := " SELECT
cQuery += " DISTINCT SC7.C7_NUM,SC7.C7_TOTAL 
cQuery += " FROM  "+RetSqlName("SC7")+"  SC7 "

cQuery += " WHERE SC7.D_E_L_E_T_ = ' '"
cQuery += " AND SC7.C7_ENCER     = ' '"
cQuery += " AND SC7.C7_RESIDUO   = ' '"
cQuery += " AND SC7.C7_XSOLPA    = '2'"
cQuery += " AND SC7.C7_FORNECE	 = '"+cA100For+"'"
cQuery += " AND SC7.C7_LOJA		 = '"+cLoja+"'"
//cQuery += " AND SC7.C7_FILIAL    = '"+SF1->F1_FILIAL +"'"

//cQuery += " ORDER BY SC1.C1_USER
//SELECT DISTINCT SC1.C1_USER,SC1.C1_NUM FROM SD1080 SD1 INNER JOIN(SELECT * FROM SC7080 ) SC7 ON SC7.D_E_L_E_T_ = ' ' AND SC7.C7_NUM = SD1.D1_PEDIDO AND SC7.C7_ITEM = SD1.D1_ITEMPC AND SC7.C7_FILIAL = '01' INNER JOIN(SELECT * FROM SC1080 ) SC1 ON SC1.D_E_L_E_T_ = ' ' AND SC7.C7_NUMSc = SC1.C1_NUM AND SC7.C7_ITEMSC = SC1.C1_ITEM AND SC1.C1_FILIAL = '  '  WHERE  SD1.D_E_L_E_T_ = ' ' AND SD1.D1_DOC = '111111   ' AND SD1.D1_SERIE = '231' AND SD1.D1_FILIAL = '01'  ORDER BY  SC1.C1_USER
cQuery := ChangeQuery(cQuery)

cAlias := GetNextAlias()
If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)
cMsg := ''
do while !eof()
	cMsg += C7_NUM+" - R$ "+left(STR(C7_TOTAL*100,10),8)+","+right(STR(C7_TOTAL,10),2)+CRLF
	skip
enddo
cTime2 := time()
//aviso(cA100For+" Hora Inicio"+cTime1+" Hora término "+ctime2  , cMsg, {"OK"})
//if cMsg<>''
//	aviso(" Informar Pedido com adiantamento " , cMsg, {"OK"})
//	Return(.f.)
//endif
if cMsg<>''
	if !msgbox("Pedido(s) com adiantamento para esse fornecedor "+chr(13)+cMsg+chr(13)+;
	"Pressione Sim para continuar ou Não para alterar o pedido","Atencao","YESNO")	
	lRet1 := .f.
	Endif
endif
Return()
