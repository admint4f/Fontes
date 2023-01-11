#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TOTVS.CH"

/*/{Protheus.doc} MFACOMH0 

Rotina para preencher corretamente as posições 012 e 013 do Header do Lote Segmento A do arquivo cnab BRADFOR.2PE

@type function
@author Vinicius Franceschi
@since 28/10/2021
@version P12
@database MSSQL,Oracle
@return cModel (CODIGO PARA A POSICAO CNAB)


@see RFINE001
/*/

User Function RFINE002()

	Local cModel        := ""
	Local aAreaSA2		:= SA2->(getarea())
	Local aAreaSEA		:= SEA->(getarea())
	Local cBancFor      := ""
	Local cBordero      := SEA->EA_MODELO

	Dbselectarea("SA2")
	SA2->(dbsetorder(1))
	If Dbseek (FwxFilial("SA2")+SEA->EA_FORNECE+SEA->EA_LOJA)
		cBancFor := SA2->A2_BANCO

		If cBancFor =="237"
			IF cBordero == "41"
				cModel := "01"
			else
				cModel := cBordero
			ENDIF
		else
			cModel := cBordero
		ENDIF
	ENDIF

	Restarea(aAreaSEA)
	Restarea(aAreaSA2)

Return(cModel)
