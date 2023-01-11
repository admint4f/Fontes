#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#define CRLF Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110LOK  ºAutor  ³Microsiga           º Data ³  03/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validações na inclusão/alteração SC                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT110LOK()
Local lRet		:= ParamIXB[1] 
Local aArea		:= GetArea()
Local nPosProd	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_PRODUTO"})
Local nPosQtd	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_QUANT"})
Local nPosVUnit	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_VUNIT"})
Local nPosVTot	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_T4FTOT"})
Local nPosCPgto	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_CONDPAG"})
Local nPosDtNec	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_DATPRF"})
Local nPosForn	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_FORNECE"})
Local nPosForLj	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_LOJA"})
Local nPosObs	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_OBS"})
Local nPosItCta	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_ITEMCTA"})
Local nPosClVl	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_CLVL"})
Local nPosCC	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_CC"})
Local nPosCta	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_CONTA"})
Local cCposNOK	:= ""                                         
Local cCompGen	:= SuperGetMV("T4_COMEME",,"999") //Comprador generico - Compras Emergencial/Descentralizada
Local nDiasDtNec:= SuperGetMV("T4_QTDNEC",,0) //Define a quantidade minima de dias para data necessidade - SCs Centralizadas
Local _nz        :=0
//Checa se é linha deletada

If aCols[n][ len(aCols[n]) ]   
	Return lRet
EndIf

cForn := (aCols[n][nPosForn])
cForLj := (aCols[n][nPosForLj])
//if m->C7_XSOLPA = '2'"
	lRet1 := .t.
	Verpedab(cForn,cForLj) // Verifica se existem PA´s em aberto para o fornecedor
	IF !lRet1
		Return lRet1
	Endif
//endif
                                                                                       
//Validações Tipo de Compra = Centralizada 
If _cTpCpr == "C"       
	If Empty(aCols[n][nPosCta])   
		cCposNOK += Alltrim(RetTitle("C1_CONTA"))+ ", "
	EndIf
	If Empty(aCols[n][nPosCC])   
		cCposNOK += Alltrim(RetTitle("C1_CC"))+ ", "
	EndIf
	If Empty(aCols[n][nPosItCta])   // Incluída validação por EPEP
		_cEPEP  := Posicione("CT1",1,xFilial("CT1")+ aCols[n][nPosCta],"CT1_ITOBRG") 
		If _cEPEP="1"
			MsgAlert("Conta contábil exige Elemento PEP " ) 
			lRet	:= .F.		
		endif
//		cCposNOK += Alltrim(RetTitle("C1_ITEMCTA"))+ ", "
	EndIf
	If Empty(aCols[n][nPosClVl])   
		cCposNOK += Alltrim(RetTitle("C1_CLVL"))+ ", "
	EndIf
	If Empty(aCols[n][nPosDtNec])   
		cCposNOK += Alltrim(RetTitle("C1_DATPRF"))+ ", "  
	ElseIf aCols[n][nPosDtNec] < (dDatabase + nDiasDtNec )
		MsgAlert("Data de Necessidade deve ser maior ou igual a " + DTOC(dDatabase + nDiasDtNec)  ) 
		lRet	:= .F.		
	EndIf                   
	
//	If Empty(aCols[n][nPosObs])   
//		cCposNOK += Alltrim(RetTitle("C1_OBS"))+ ", "
//	EndIf		                 
	
	//Carrega Cod.Comprador                    
	If !Empty(aCols[n][nPosProd])
		_cGrupoCpr  := Posicione("SB1",1,xFilial("SB1")+ aCols[n][nPosProd],"B1_GRUPCOM") 
		If !Empty(_cGrupoCpr)
			_cUserCpr	:= Posicione("SAJ",1,xFilial("SAJ")+ _cGrupoCpr,"AJ_USER") 
			If !Empty(_cUserCpr)		
				cCodCompr 	:= Posicione("SY1",3,xFilial("SY1")+ _cUserCpr,"Y1_COD") 
			EndIf
		EndIf
	EndIf
	SY1->(dBSetOrder(1))
           
//Validações Tipo de Compra = Descentralizada ou Emergencial
ElseIf _cTpCpr == "D" .OR. _cTpCpr == "E"   
	If Empty(aCols[n][nPosCta])   
		cCposNOK += Alltrim(RetTitle("C1_CONTA"))+ ", "
	EndIf
	If Empty(aCols[n][nPosCC])   
		cCposNOK += Alltrim(RetTitle("C1_CC"))+ ", "
	EndIf
	If Empty(aCols[n][nPosItCta])   // Incluída validação por EPEP
		_cEPEP  := Posicione("CT1",1,xFilial("CT1")+ aCols[n][nPosCta],"CT1_ITOBRG") 
		If _cEPEP="1" //.and. _cGeraPA = '2'
			MsgAlert("Conta contábil exige Elemento PEP " ) 
			lRet	:= .F.		
		endif
//		cCposNOK += Alltrim(RetTitle("C1_ITEMCTA"))+ ", "
	EndIf
//	If Empty(aCols[n][nPosItCta])   
//		cCposNOK += Alltrim(RetTitle("C1_ITEMCTA"))+ ", "
//	EndIf
	If Empty(aCols[n][nPosClVl])   
		cCposNOK += Alltrim(RetTitle("C1_CLVL"))+ ", "                     
	EndIf
	If Empty(aCols[n][nPosVUnit])   
		cCposNOK += Alltrim(RetTitle("C1_VUNIT"))+ ", "
	EndIf
	If Empty(aCols[n][nPosVTot])   
		cCposNOK += Alltrim(RetTitle("C1_T4FTOT"))+ ", "			
	EndIf
	If Empty(aCols[n][nPosCPgto])   
		cCposNOK += Alltrim(RetTitle("C1_CONDPAG"))+ ", "
	EndIf
	If Empty(aCols[n][nPosDtNec])   
		cCposNOK += Alltrim(RetTitle("C1_DATPRF"))+ ", "
	EndIf
	If Empty(aCols[n][nPosForn])   
		cCposNOK += Alltrim(RetTitle("C1_FORNECE"))+ ", "
	EndIf
	If Empty(aCols[n][nPosForLj])   
		cCposNOK += Alltrim(RetTitle("C1_LOJA"))+ ", "
	EndIf    
	
	cCodCompr := cCompGen
EndIf

SY1->(dBSetOrder(1))
	
If !Empty(cCposNOK)
	MsgAlert("Campo(s) obrigatório(s) em branco: " + cCposNOK ) 
	lRet	:= .F.
EndIf

          
//Validações de campos que nao podem ser diferentes nas linhas   
//Tipo de Compra, C.Custo, Cond.Pgto, Forn, Lj.Forn não podem ser diferentes    
For _nz := 1 To Len(aCols)
	If !(n == _nz) .AND. !(aCols[_nz][ len(aCols[_nz]) ]  ) //Nao é a mesma linha e nao é linha deletada
		If !( (aCols[_nz][nPosCC] + aCols[_nz][nPosCPgto] + aCols[_nz][nPosForn]  + aCols[_nz][nPosForLj]) == ;
			  (aCols[n][nPosCC] + aCols[n][nPosCPgto] + aCols[n][nPosForn]  + aCols[n][nPosForLj]) )   
			  MsgAlert("Os campos " + Alltrim(RetTitle("C1_CC"))+ ", " + Alltrim(RetTitle("C1_CONDPAG"))+ ", " + Alltrim(RetTitle("C1_FORNECE"))+ ", " + Alltrim(RetTitle("C1_LOJA")) +" não podem ser diferentes nos itens.")
			  lRet	:= .F.	
			  Exit		  
		EndIf	
	EndIf
Next   

If n == 1 
	If Len(aCols) > 1
		If !( ( aCols[1][nPosCC] + aCols[1][nPosCPgto] + aCols[1][nPosForn]  + aCols[1][nPosForLj]) == ;
			  ( aCols[2][nPosCC] + aCols[2][nPosCPgto] + aCols[2][nPosForn]  + aCols[2][nPosForLj]) )  
			  MsgAlert("Os campos " + Alltrim(RetTitle("C1_CC"))+ ", " + Alltrim(RetTitle("C1_CONDPAG"))+ ", " + Alltrim(RetTitle("C1_FORNECE"))+ ", " + Alltrim(RetTitle("C1_LOJA")) +" não podem ser diferentes nos itens.")
			  lRet	:= .F.
		EndIf
	EndIf
Else
		If !( (aCols[1][nPosCC] + aCols[1][nPosCPgto] + aCols[1][nPosForn]  + aCols[1][nPosForLj]) == ;
			  (aCols[n][nPosCC] + aCols[n][nPosCPgto] + aCols[n][nPosForn]  + aCols[n][nPosForLj]) )   
			  MsgAlert("Os campos " + Alltrim(RetTitle("C1_CC"))+ ", " + Alltrim(RetTitle("C1_CONDPAG"))+ ", " + Alltrim(RetTitle("C1_FORNECE"))+ ", " + Alltrim(RetTitle("C1_LOJA")) +" não podem ser diferentes nos itens.")
			  lRet	:= .F.			  
		EndIf
EndIf    
 */

SY1->(dBSetOrder(1))

Return lRet

*-----------------------------------*
Static Function Verpedab(cForn,cForLj)
*-----------------------------------*

Local cQuery     := ' '
 cTime1 := time()

cQuery := " SELECT
cQuery += " DISTINCT SC7.C7_NUM,SC7.C7_TOTAL
cQuery += " FROM  "+RetSqlName("SC7")+"  SC7 "

cQuery += " WHERE SC7.D_E_L_E_T_ = ' '"
cQuery += " AND SC7.C7_ENCER     = ' '"
cQuery += " AND SC7.C7_RESIDUO   = ' '"
cQuery += " AND SC7.C7_XSOLPA    = '2'"
cQuery += " AND SC7.C7_FORNECE	 = '"+cForn+"'"
cQuery += " AND SC7.C7_LOJA		 = '"+cForLj+"'"

cQuery := ChangeQuery(cQuery)

cAlias := GetNextAlias()
If Select(cAlias) > 0
	(cAlias)->(dbCloseArea())
EndIf

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias)
cMsg := ''
do while !eof()
	cMsg += C7_NUM+"-"+STR(C7_TOTAL,10)+CRLF
	skip
enddo
//cTime2 := time()
//aviso(cForn+" Hora Inicio"+cTime1+" Hora término "+ctime2  , cMsg, {"OK"})
if cMsg<>''
	if !msgbox("Pedido(s) com adiantamento para esse fornecedor "+chr(13)+cMsg+chr(13)+;
	"Pressione Sim para continuar ou Não para retornar ao pedido","Atencao","YESNO")	
//	aviso(" Existe Pedido com adiantamento para esse fornecedor" , cMsg, {"OK"})
	lRet1 := .f.
	Endif
endif

Return()
