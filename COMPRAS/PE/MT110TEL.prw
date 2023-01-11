#INCLUDE "PROTHEUS.CH"                
#INCLUDE 'PRTOPDEF.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110TEL  ºAutor  ³Microsiga           º Data ³  09/13/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Adiciona campos na tela de Solic.Compra                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT110TEL()      

Local _oDlg     := PARAMIXB[1]
Local _aPosGet  := PARAMIXB[2]
Local _nOpcx    := PARAMIXB[3]
//Local _nReg     := PARAMIXB[4]
Local aSizeAut  := MsAdvSize(.F.)                                                      

Public _cTpCpr	 := IIf(_nOpcx == 3,CriaVar("C1_XTPCPR"),SC1->C1_XTPCPR  )  
Public _oTpCpr       
Public _cGeraPA	 := IIf(_nOpcx == 3,CriaVar("C1_XSOLPA"),SC1->C1_XSOLPA  )     
Public _oGeraPA     
Public _cMoeda	 := IIf(_nOpcx == 3,"1-Real",SC1->C1_MOEDA )
Public _ocMoeda    
Public _nValPA	 := IIf(_nOpcx == 3,CriaVar("C1_XVALPA"),SC1->C1_XVALPA  )      
Public _oValPA
Public _dVencPA  := IIf(_nOpcx == 3,CriaVar("C1_XVENPA"),SC1->C1_XVENPA  ) 
Public _oVencPA
Public _cObsAprov:= IIf(_nOpcx == 3,CriaVar("C1_XOBSAPR"),SC1->C1_XOBSAPR  ) 
Public _oObsAprov
Public _cObsForn := IIf(_nOpcx == 3,CriaVar("C1_XOBSFO"),SC1->C1_XOBSFO  ) 
Public _oObsForn
Public _eMailForn := IIf(_nOpcx == 3,CriaVar("C1_XMAILF"),SC1->C1_XMAILF  ) 
Public _oMailForn
Public _lAltTpCpr := .T.

_aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],305,{{10,35,100,135,205,255},{10,45,100,135,220,259,205,248},{65,73},{10,45},{10,45}})  

@ 64,_aPosGet[1,1]  SAY OemToAnsi("Tipo Compra") OF _oDlg PIXEL SIZE 038,006 
@ 63,_aPosGet[1,2] MSCOMBOBOX _oTpCpr VAR _cTpCpr ITEMS {"D=Descentralizado"} VALID ValTPCpr(_nOpcx) WHEN (_nOpcx ==3 .OR. _nOpcx==4) .AND. _lAltTpCpr  PIXEL SIZE 065, 010 OF _oDlg 

@ 64,_aPosGet[3,1]  SAY OemToAnsi("Moeda") OF _oDlg PIXEL SIZE 038,006  
@ 63,_aPosGet[3,2] MSCOMBOBOX _ocMoeda VAR _cMoeda ITEMS {"1-Real","2-Dolar","6-Euro","8-Coroa"} WHEN (_nOpcx ==3 .OR. _nOpcx==4 .OR. lCopia) PIXEL SIZE 040, 010 OF _oDlg

@ 64,_aPosGet[2,3]  SAY OemToAnsi("Gera Sol.PA?") OF _oDlg PIXEL SIZE 038,006  
@ 63,_aPosGet[2,4] MSCOMBOBOX _oGeraPA VAR _cGeraPA ITEMS {"1=Nao","2=Sim"} VALID ValGeraPA(_nOpcx) WHEN _cTpCpr $ "E;D" .AND. (_nOpcx ==3 .OR. _nOpcx==4 .OR. lCopia)  PIXEL SIZE 035, 010 OF _oDlg 

@ 64,_aPosGet[2,7]  SAY OemToAnsi("Valor Sol.PA") OF _oDlg PIXEL SIZE 038,006  
@ 63,_aPosGet[2,5] MSGET _oValPA VAR _nValPA PICTURE PesqPict("SC1","C1_XVALPA") WHEN ValGeraPA(_nOpcx) PIXEL SIZE 060, 010 OF _oDlg 

@ 64,_aPosGet[2,8]  SAY OemToAnsi("Vencto") OF _oDlg PIXEL SIZE 038,006  
@ 63,_aPosGet[2,6] MSGET _oVencPA VAR _dVencPA VALID ValVenPA(_nOpcx) WHEN ValGeraPA(_nOpcx) PIXEL SIZE 050, 010 OF _oDlg 

@ 77,_aPosGet[1,1]  SAY OemToAnsi("Obs.p/aprov.") OF _oDlg PIXEL SIZE 038,006  
@ 76,_aPosGet[1,2] MSGET _oObsAprov VAR _cObsAprov WHEN  (_nOpcx ==3 .OR. _nOpcx==4 .OR. lCopia) .and. ValObs(_nOpcx)  PIXEL SIZE 120, 010 OF _oDlg 
                                                                                                   
@ 77,_aPosGet[2,3]  SAY OemToAnsi("Obs.p/forn.") OF _oDlg PIXEL SIZE 038,006  
@ 76,_aPosGet[2,4] MSGET _oObsForn VAR _cObsForn WHEN  (_nOpcx ==3 .OR. _nOpcx==4 .OR. lCopia) .and. ValObs(_nOpcx)  PIXEL SIZE 120, 010 OF _oDlg 

@ 77,_aPosGet[2,7]  SAY OemToAnsi("E-mail/forn.") OF _oDlg PIXEL SIZE 038,006  
@ 76,_aPosGet[2,5] MSGET _oMailForn VAR _eMailForn WHEN (_nOpcx ==3 .OR. _nOpcx==4 .OR. lCopia) .and. ValObs(_nOpcx) PIXEL SIZE 100, 010 OF _oDlg 

RETURN                            

Static Function ValTpCpr(nOpcX)
Local nPosProd	:= aScan(aHeader,{|x| Alltrim(x[2])=="C1_PRODUTO"})
Local _lRet := .T.                                         
                            
If nOpcX == 3 .OR.  nOpcX == 4
	If !Empty(aCols[1][nPosProd]) .And. !lCopia
		MsgAlert("Não pode alterar o Tipo de compra após já ter inserido item")
		_lRet := .F.
	EndIf  
	If _cTpCpr =="C"   
		_cGeraPA := "1"
		_oGeraPA:Disable()
		_oGeraPA:Refresh() 
		ValObs(nOpcx) 
		ValGeraPA(nOpcX)
	Else
		_oGeraPA:Enable()
		_oGeraPA:Refresh() 
		
		ValObs(nOpcx)						
		ValGeraPA(nOpcX)
	EndIf
EndIf

Return _lRet
                             

Static Function ValGeraPA(nOpcX)  
If nOpcX == 3 .OR.  nOpcX == 4 .OR. lCopia
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
                              
If nOpcx == 3 .OR. nOpcx == 4 .OR. lCopia
	If dDatabase >= _dVencPA .AND. !Empty(_dVencPA)
		MSgAlert("Data de vencimento de Sol.PA deve ser maior que Data Atual.")
		lRet := .F.
	EndIF
EndIf

Return lret           

Static Function ValObs(nOpcx)    
Local lRet := .F.
If nOpcx == 3 .OR. nOpcx == 4 .OR. lCopia

	If _cTpCpr == "C"
		_cObsAprov:= Space(TamSX3("C1_XOBSAPR")[1])
		_oObsAprov:Disable()
		_oObsAprov:Refresh()
		
		_cObsForn:= Space(TamSX3("C1_XOBSFO")[1])
		_oObsForn:Disable()
		_oObsForn:Refresh() 
		
		_eMailForn:= Space(TamSX3("C1_XMAILF")[1])
		_oMailForn:Disable()
		_oMailForn:Refresh() 
		
	Else
		_oObsAprov:Enable()
		_oObsAprov:Refresh()

		_oObsForn:Enable()
		_oObsForn:Refresh() 
		
		_oMailForn:Enable()
		_oMailForn:Refresh()
		lRet := .T.
	EndIf
EndIf
Return lRet   
                     
User Function T4TPSC()      

If n == 1
	_oTpCpr:Disable()
	_oTpCpr:Refresh()
	_lAltTpCpr := .F.
EndIf
Return
