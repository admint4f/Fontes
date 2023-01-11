#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TOTVS.CH"

/*/{Protheus.doc} MFACOMH0 

Rotina para preencher corretamente as posições 018 e 020 do Segmento A do arquivo cnab BRADFOR.2PE

@type function
@author Vinicius Franceschi
@since 27/10/2021
@version P12
@database MSSQL,Oracle
@return cCentral (CODIGO PARA A POSICAO CNAB)


@see RFINE001
/*/

User Function RFINE001()

	Local cCentral    := ""
	Local aAreaSA2		:= SA2->(getarea())
	Local aAreaSEA		:= SEA->(getarea())

	IF SEA->EA_MODELO == "41" .OR. SEA->EA_MODELO == "43"

		IF SA2->A2_BANCO == "237"
			cCentral := "000"

		else
			cCentral := "018"
		ENDIF

	elseif SEA->EA_MODELO == "03"

		IF SA2->A2_BANCO == "237"
			cCentral := "000"
		else
			cCentral := "700"
		ENDIF

	ENDIF

	Restarea(aAreaSEA)
	Restarea(aAreaSA2)

Return(cCentral)
