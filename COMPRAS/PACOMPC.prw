#DEFINE oCSaldo    LoadBitmap( GetResources(), "BR_VERDE"    )//PC nao Atendido e Liberado
#DEFINE oChecked   LoadBitmap( GetResources(), "CHECKED"     )//Item selecionado
#DEFINE oUnChecked LoadBitmap( GetResources(), "UNCHECKED"   )//Item nใo selecionado

#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "Rwmake.ch"
#INCLUDE "ap5mail.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPACOMPC   บAutor  ณSergio Celestino    บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela Informar o numero do pedido para a Inclussao do PA     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PACOMPC(cFornec,cLoja,cPedido,nValor)

Local oFolder	:= Nil  
Local oFont   
Local aCoorden	:= MsAdvSize(.T.)
Local nLin      := 0
Local cOpcao	:= ""
Local lRet      := .F.

Private aListExp := {}
Private lFirst   := .T.
Private oDlgMain := Nil
Private oListExp := Nil

If FunName(0) == "GERASE2"
   Return M->E2_VALOR
Endif
   
MsgRun("Consultando Pedidos de Compras...",,{|| CursorWait(),aListExp:=MontaQuery(cFornec,cLoja),CursorArrow()})

   If Len(aListExp) == 0
      aAdd(aListExp ,{" ",.F.," "," "  } ) 
   Endif   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a fonte da consulta.                                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE FONT oFont NAME "ARIAL" SIZE 0,-12 BOLD

nLin := 15
//Desenha a interface 
oDlgMain := TDialog():New(aCoorden[7]/2.5,000,aCoorden[6]/2.5+30,aCoorden[5]/2.5+10,OemToAnsi("Pagamento Antecipado x Pedido de Compra"),,,,,,,,oMainWnd,.T.)
                                                                                  
	
	@ 010+nLin,015 Say OemToAnsi("Pedido de Compra") Size 080,008 Of oDlgMain Pixel  COLOR CLR_HRED FONT oFont

	
	oFolder1 := TFolder():New(010,001,{"Informe o Pedido de Compra para o PA"},,oDlgMain,,,,.T.,.T.,oDlgMain:nClientWidth/2+5,oDlgMain:nClientHeight/3.5-10)   
		@ 001,001 ListBox oListExp VAR cOpcao Fields ;
		          Header " "," ","Nr. PC","Valor Total do PC" Size oFolder1:aDialogs[1]:nClientWidth/2-8,oFolder1:aDialogs[1]:nClientHeight/2 PIXEL OF oFolder1:aDialogs[1] ;
			On dblClick ( CheckFirst(.F.,@nValor) ,  oListExp:Refresh() )
			
//			oListExp:bHeaderClick	:= {|| CheckFirst(.T.)   , oListExp:Refresh() } 
			oListExp:lHScroll 	:= .T.  
			oListExp:lNoHScroll	:= .T.
			oListExp:SetArray(aListExp)                             
			oListExp:bLine := {||{    aListExp[oListExp:nAt][1],;   //Semaforo
			                           IIf(aListExp[oListExp:nAt][02], oChecked  ,oUnChecked ),;
									   aListExp[oListExp:nAt][3],;  //Nr. do PC
									   aListExp[oListExp:nAt][4]}}  //Valor total em Aberto do PC
			                                                       
                        

	//@ oDlgMain:nClientWidth/6+4,015 SAY "Nใo Atendido"       OF oDlgMain PIXEL

oDlgMain:Activate(EnchoiceBar(oDlgMain,{||MsgRun("Integrando PA com PC...",,{|| CursorWait(),lRet:=PAPC(oListExp:aArray,oDlgMain,@cPedido),CursorArrow()})},{|| lRet := .F.,oDlgMain:End() }),,,.T.)		


If FunName(0) == "T4F_003"
If !lRet
    nValor := 0
    cPedido := Space(6) 
  Endif      
  Return(nValor)
Else
  If !lRet
    M->E2_VALOR := 0
    M->E2_NUMPC := Space(6) 
  Endif    
  Return(M->E2_VALOR)
Endif
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCheckFirstบAutor  ณSergio Celestino    บ Data ณ  18/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para marcar e desmarcar itens do PC para            บฑฑ
ฑฑบ          ณAmmarar com o PA                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CheckFirst(lClicker,nValor)

Local lRet := .T.

If FunName(0) == "T4F_003"
	Do Case
	 Case aListExp[oListExp:nAt][4] < nValor
		 lRet := .F.
		 MsgInfo("O valor do pedido de compras ้ menor que o valor do pagamento antecipado.Verifique!")
		 Return lRet
	EndCase
Else
	Do Case
	 Case aListExp[oListExp:nAt][4] < M->E2_VALOR
		 lRet := .F.
		 MsgInfo("O valor do pedido de compras ้ menor que o valor do pagamento antecipado.Verifique!")
		 Return lRet
	EndCase
Endif
                    
If lRet .And. !lClicker
   AEval(aListExp,{|x| x[2] := .F. } ) ; oListExp:Refresh() 
   aListExp[oListExp:nAt][2] := !aListExp[oListExp:nAt][2]  ; oListExp:Refresh()
Elseif lRet .And. lClicker
   AEval(aListExp,{|x| x[2] := IF(!x[1]:CNAME $ "BR_PRETO" ,!x[2],x[2])  } ) ; oListExp:Refresh()
Endif


Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPACOMPC   บAutor  ณSergio Celestino    บ Data ณ  02/25/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualizar variavel com numero do pedido                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PAPC(aVetor,oDlgMain,cPedido)

Local lRet := .F.

For nY := 1 To Len(aVetor)
    If aVetor[nY][2]
       If FunName(0)=="T4F_003"
       	 cPedido      := aVetor[nY][3]  
       Else
         M->E2_NUMPC  := aVetor[nY][3]
       Endif
       lRet := .T.
    Endif
Next

If lRet
 oDlgMain:End()
Endif 

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQueryบAutor  ณSergio Celestino    บ Data ณ  02/25/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta os pedidos em aberto para o fornecedore selecionadoบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaQuery(cFornec,cLoja)

Local cQuery := ""
Local aList  := {}

cQuery := "SELECT C7_NUM,SUM(C7_TOTAL) AS TOTAL FROM "+RetSqlName("SC7")+" "
cQuery += " WHERE 
cQuery += " C7_FORNECE = '"+cFornec+"' AND "
cQuery += " C7_LOJA    = '"+ cLoja +"' AND 
cQuery += " C7_CONAPRO = 'L' AND C7_QUANT > C7_QUJE AND "
cQuery += " C7_ENCER <> 'E' AND C7_RESIDUO = ' ' AND D_E_L_E_T_ = ' ' "
cQuery += " GROUP BY C7_NUM "
cQuery += " ORDER BY C7_NUM "

cQuery := ChangeQuery(cQuery)   

If Select("TRB") > 0
   DbSelectArea("TRB")
   DbCloseArea()
Endif   
   
TcQuery cQuery New Alias "TRB"   
   
While !Eof() 
      
      DbSelectArea("ZZE")
      DbSetOrder(2)
      If !DbSeek(xFilial("ZZE") + TRB->C7_NUM)
      
	      aAdd(aList, {   oCSaldo                          ,;
	                         .F.                              ,; 
	                         TRB->C7_NUM                      ,;
	                         TRB->TOTAL                       }) 
      Endif
      DbSelectArea("TRB")                 
      DbSkip()
End    

Return aList