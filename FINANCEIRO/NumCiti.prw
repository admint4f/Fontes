#include "protheus.ch"

User Function NumCiti
Local NumCiti := ""

If SM0->M0_CODIGO == "16" // VICAR
	if trim(SE1->E1_PORTADO)="745"
		If Empty(SE1->E1_NUMBCO)
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO := NossoNum()
			Msunlock()
		Endif
	else
		If Empty(SE1->E1_NUMBCO)
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO := T4FNumBco()
			Msunlock()
		EndIf
		
	endif
Else
	If Empty(SE1->E1_NUMBCO)
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO := T4FNumBco()
		Msunlock()
	EndIf
EndIf
	
//Retorna tamanho de 11 pois assim esta no layout
if trim(mv_par05)="341"
	NumCiti := StrZero(Val(Alltrim(SE1->E1_NUMBCO)),8)
else
	NumCiti := StrZero(Val(Alltrim(SE1->E1_NUMBCO)),11)
endif
//msgalert(numciti)
Return(NumCiti)

/* Para não permitir duplicidade de nosso numero */
Static Function T4FNumBco()

Local _lTemNN, _cNossoNum 

Local nTamFax:= Len(AllTrim(SEE->EE_FAXATU))

If Empty(SE1->E1_NUMBCO)

	_lTemNN := .t.
	_cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU)),nTamFax) //Alterado Luis Dantas 23/05/12 //Erro na numeração do E1_NUMBCO pois já havia registro com o mesmo valor do EE_FAXATU. A linha foi colocada fora do laço para permitir o incremento (Função Soma1()). 
	While ( _lTemNN )                                               
//		_cNossoNum := StrZero(Val(Alltrim(SEE->EE_FAXATU)),nTamFax) //Alterado Luis Dantas 23/05/12 //Erro na numeração do E1_NUMBCO pois já havia registro com o mesmo valor do EE_FAXATU. A linha foi colocada fora do laço para permitir o incremento (Função Soma1()). 
		_cNossoNum := Soma1(_cNossoNum,nTamFax)			
		_lTemNN	   := u_TemNumBCO(_cNossoNum)
	EndDo

	DbSelectArea("SEE")
	RecLock("SEE",.F.)
	SEE->EE_FAXATU:= _cNossoNum
	MsUnLock()
Else
	_cNossoNum := AllTrim(SE1->E1_NUMBCO)
Endif    

// Grava log de geração de nosso numero   
u_LogNumBco()            

Return( _cNossoNum )

user function digCit()

local cNossoN	:= AllTrim(SE1->E1_NUMBCO)
local cRet		:= ""
local cBanco	:= "745"
local cS		:= ""
local cDvNN		:= ""
local cNNum		:= ""

If Len( cNossoN ) > 11
	cNNum := StrZero(Val(cNossoN), 11)
Endif

cS			:= cNNum
cDvNN		:= U_TCCalcDV( cBanco, cS )			//modulo11(cS)
cRet		:= cNNum + cDvNN

return cRet