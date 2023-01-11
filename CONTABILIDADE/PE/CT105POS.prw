#include "RwMake.ch"
User Function CT105POS()
// Marca o lan�amento como pr�-lan�amento para valida��o posterior

// Criada condi��o para obrigar o usu�rio a informar a conta cont�bil pr�-operativa da atividade (quando a conta d�bito ou cr�dito for pr-e operativa)
// Luiz Eduardo - 22/10/2018

Local lRetorno := ParamIXB[1]
If lRetorno
	Select TMP
	dbgotop()
	do while !eof()
		Reclock("TMP",.f.)
		IF (trim(FunName())="CTBA102" .or. trim(FunName())="CTBA500"  .or. trim(FunName())="CTBA101")
			tmp->CT2_TPSALD := "9"
		ENDIF
		IF trim(FunName())="FINA750" .or. (trim(FunName())="CTBA102" .or. trim(FunName())="CTBA500"  .or. trim(FunName())="CTBA101")
			if inclui
				if trim(tmp->CT2_DEBITO)='1109010003' .and. empty(tmp->CT2_ATIVDE)
					ApMsgStop("Aten��o: "+chr(13)+"Favor informar a conta da Atividade Debito"+chr(13)+"Linha : "+tmp->Ct2_linha )
					lRetorno := .f.
				endif
				if trim(tmp->CT2_CREDIT)='1109010003' .and. empty(tmp->CT2_ATIVCR)
					ApMsgStop("Aten��o: "+chr(13)+"Favor informar a conta da Atividade Credito"+chr(13)+"Linha : "+tmp->Ct2_linha )
					lRetorno := .f.
				endif
			Endif
		endif
		MsUnLock()
		skip
	enddo
EndIf

Return( lRetorno )

