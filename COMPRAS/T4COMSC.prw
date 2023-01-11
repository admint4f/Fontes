#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | T4COMSC         | Autor | GIOVANI.ZAGO              | Data | 22/10/2013  |
|=====================================================================================|
|Descrição | T4COMSC    												              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | T4COMSC                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function T4COMSC()
*-----------------------------*

Local aArea         := GetArea()
Local _nPosForn     := aScan(aHeader, { |x| Alltrim(x[2]) == "C1_FORNECE" })
Local _nPosLoj      := aScan(aHeader, { |x| Alltrim(x[2]) == "C1_LOJA"    })

If Valtype(_emailforn) = "C" .AND. _cTpCpr <> 'C'
//	If Empty(_emailforn) //T4F - Carlos, pediu para que sempre atualize email do fornecedor, mesmo se ja estiver preenchido
		_emailforn:= Posicione("SA2",1,xFilial("SA2")+aCols[n,_nPosForn]+aCols[n,_nPosLoj],"A2_EMAIL")
//	EndIf
EndIf      

_oDlgDefault := GetWndDefault()
aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
Restarea(aArea)
Return(.F.)
               
#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | T4COMSC         | Autor | GIOVANI.ZAGO              | Data | 22/10/2013  |
|=====================================================================================|
|Descrição | T4COMPD    												              |
|          |                                                                          |
|          |                                                                          |
|=====================================================================================|
|Sintaxe   | T4COMPD                                                                  |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function T4COMPD()
*-----------------------------*

Local aArea         := GetArea()
Local _nPosForn     := ''
Local _nPosLoj      := '' 
Local _nPosSC      := aScan(aHeader, { |x| Alltrim(x[2]) == "C7_NUMSC"    })  

If l120Auto
	Return .F.
EndIf
    
If Valtype(CA120FORN) = "C"
 _nPosForn     := CA120FORN 
 EndIf
If Valtype(CA120LOJ) = "C" 
 _nPosLoj      := CA120LOJ
 EndIf
If Valtype(_emailforn) = "C"
  //	_emailforn:= Posicione("SA2",1,xFilial("SA2")+_nPosForn+_nPosLoj,"A2_EMAIL")  
	If Empty(_emailforn) 
		_emailforn:= Posicione("SC1",1,xFilial("SC1")+aCols[n,_nPosSC],"C1_XMAILF")  
		If Empty(Alltrim(_emailforn))
			_emailforn:= Posicione("SA2",1,xFilial("SA2")+_nPosForn+_nPosLoj,"A2_EMAIL")
		EndIf	      
	EndIf
	
EndIf      

_oDlgDefault := GetWndDefault()
aEval(_oDlgDefault:aControls,{|x| x:Refresh()})
Restarea(aArea)
Return(.F.)
