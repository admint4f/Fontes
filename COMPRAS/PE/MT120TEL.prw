#INCLUDE "PROTHEUS.CH"                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120TEL  ºAutor  ³Microsiga           º Data ³  09/13/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adiciona campos na tela de Pedido.Compra                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120TEL()      

Local _oDlg     := PARAMIXB[1]
Local _aPosGet  := PARAMIXB[2]
Local _nOpcx    := PARAMIXB[4]
Local _nReg     := PARAMIXB[5]
Local aSizeAut  := MsAdvSize(,.F.)    

Public _cTpCpr	 := IIf(_nOpcx == 3,CriaVar("C7_XTPCPR"),SC7->C7_XTPCPR  )  
Public _oTpCpr       
Public _cGeraPA	 := IIf(_nOpcx == 3,CriaVar("C7_XSOLPA"),SC7->C7_XSOLPA  )     
Public _oGeraPA     
Public _nValPA	 := IIf(_nOpcx == 3,CriaVar("C7_XVALPA"),SC7->C7_XVALPA  )      
Public _oValPA
Public _dVencPA  := IIf(_nOpcx == 3,CriaVar("C7_XVENPA"),SC7->C7_XVENPA  ) 
Public _oVencPA
Public _cObsAprov:= IIf(_nOpcx == 3,CriaVar("C7_XOBSAPR"),SC7->C7_XOBSAPR  ) 
Public _oObsAprov
Public _cObsForn := IIf(_nOpcx == 3,CriaVar("C7_XOBSFO"),SC7->C7_XOBSFO  ) 
Public _oObsForn  
//==========================
Public _eMailForn := IIf(_nOpcx == 3,CriaVar("C7_XMAILF"),SC7->C7_XMAILF  )  
Public _oMailForn

//_aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,105,145,225,265,210,255},{10,45}})
_aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,;
					{{10,40,105,140,200,234,275,200,225,260,285,265},;
					If(cPaisLoc<>"PTG",{10,40,105,140,200,234,255,265,63},{10,40,101,120,175,205,63,250,270}),;
					{10,40,105,140,200,234,275,200,225,260,285,265}} )


@ 74,_aPosGet[2,1]  SAY OemToAnsi("Tipo Compra") OF _oDlg PIXEL SIZE 038,006  
//@ 73,_aPosGet[2,2] MSCOMBOBOX _oTpCpr VAR _cTpCpr ITEMS {"C=Centralizado","D=Descentralizado","E=Emergencial"} VALID ValTPCpr(_nOpcx) WHEN  /*_nOpcx ==3 .OR. _nOpcx==4*/ .F. PIXEL SIZE 060, 010 OF _oDlg 
@ 73,_aPosGet[2,2] MSCOMBOBOX _oTpCpr VAR _cTpCpr ITEMS {"D=Descentralizado"} VALID ValTPCpr(_nOpcx) WHEN  /*_nOpcx ==3 .OR. _nOpcx==4*/ .F. PIXEL SIZE 060, 010 OF _oDlg 

@ 74,_aPosGet[2,3]  SAY OemToAnsi("Gera Sol.PA?") OF _oDlg PIXEL SIZE 038,006  
@ 73,_aPosGet[2,4] MSCOMBOBOX _oGeraPA VAR _cGeraPA ITEMS {"1=Nao","2=Sim"} VALID ValGeraPA(_nOpcx) WHEN _nOpcx ==3 .OR. _nOpcx==4 .OR. _nOpcx==6 PIXEL SIZE 040, 010 OF _oDlg 

@ 74,_aPosGet[2,5]-12  SAY OemToAnsi("Valor Sol.PA") OF _oDlg PIXEL SIZE 038,006  
@ 73,_aPosGet[2,6]-24 MSGET _oValPA VAR _nValPA PICTURE PesqPict("SC1","C1_XVALPA") WHEN ValGeraPA(_nOpcx) PIXEL SIZE 060, 010 OF _oDlg 

@ 74,_aPosGet[2,7]  SAY OemToAnsi("Vencto") OF _oDlg PIXEL SIZE 038,006  
@ 73,_aPosGet[2,8] MSGET _oVencPA VAR _dVencPA VALID ValVenPA(_nOpcx) WHEN ValGeraPA(_nOpcx) PIXEL SIZE 050, 010 OF _oDlg 

@ 87,_aPosGet[2,1]  SAY OemToAnsi("Obs.p/aprov.") OF _oDlg PIXEL SIZE 038,006  
@ 86,_aPosGet[2,2] MSGET _oObsAprov VAR _cObsAprov WHEN _nOpcx ==3 .OR. _nOpcx==4 .OR. _nOpcx==6 PIXEL SIZE 350, 010 OF _oDlg 
                                                                                                   
@ 100,_aPosGet[2,1]  SAY OemToAnsi("Obs.p/forn.") OF _oDlg PIXEL SIZE 038,006  
@ 099,_aPosGet[2,2] MSGET _oObsForn VAR _cObsForn WHEN _nOpcx ==3 .OR. _nOpcx==4 .OR. _nOpcx==6 PIXEL SIZE 350, 010 OF _oDlg   
//======
@ 113,_aPosGet[1,1]  SAY OemToAnsi("E-mail/forn.") OF _oDlg PIXEL SIZE 038,006  
@ 112,_aPosGet[1,2] MSGET _oMailForn VAR _eMailForn WHEN _nOpcx ==3 .OR. _nOpcx==4 .OR. _nOpcx==6 PIXEL SIZE 350, 010 OF _oDlg 


RETURN               
                            

Static Function ValTpCpr(nOpcX)
Local nPosProd	:= aScan(aHeader,{|x| Alltrim(x[2])=="C7_PRODUTO"})
Local _lRet := .T.
                            
If nOpcX == 3 .OR.  nOpcX == 4
	If !Empty(aCols[1][nPosProd]) 
		MsgAlert("Não pode alterar o Tipo de compra após já ter inserido item")
		_lRet := .F.
	EndIf
EndIf

Return _lRet
                             

Static Function ValGeraPA(nOpcX)  
If nOpcX == 3 .OR.  nOpcX == 4 .or. nOpcX == 6
	If _cGeraPA == "2"
		_oValPA:Enable()
		_oValPA:Refresh()    
		
		_oVencPA:Enable()
		_oVencPA:Refresh()
	Else          
		_nValPA := 0
		_oValPA:Disable()
		_oValPA:Refresh() 
		
		_dVencPA  := CTOD("")
		_oVencPA:Disable()
		_oVencPA:Refresh()
	EndIf
Else 
	Return .F.	
EndIf
	
Return .T.

Static Function ValVenPA(nOpcx)
Local lret := .T.
                              
If nOpcx == 3 .OR. nOpcx == 4 .or. nOpcX == 6
	If dDatabase >= _dVencPA .AND. !Empty(_dVencPA)
		MSgAlert("Data de vencimento de Sol.PA deve ser maior que Data Atual.")
		lRet := .F.
	EndIF
EndIf

Return lret