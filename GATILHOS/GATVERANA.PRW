user function GATVERANA()

//dbSelectArea("SM0")
//dbSetOrder(1)
//_cEmp := AllTrim(SM0->M0_CODIGO)

// IF SM0->M0_CODIGO == "01"

VALOR := acols[n][7]
PRODUTO := alltrim(acols[n][2])
NUM := alltrim(acols[n][38])
ITEM := alltrim(acols[n][10])

MSGALERT(alltrim(acols[n][43]))

if num <> "999999"
	if PRODUTO <> "000001" .OR. PRODUTO <> "999999"
		if ITEM <> "0001"
			
			
			FOR Ic:= 1 TO Len(aCols)
		 //		 MSGALERT(ITEM)
		 //	MSGALERT(PRODUTO)
				
				IF alltrim(acols[Ic][2])+alltrim(acols[Ic][38]) = PRODUTO+NUM .and. ITEM <> alltrim(acols[Ic][1])
					// MSGALERT(alltrim(acols[Ic][1])+alltrim(acols[Ic][2])+alltrim(acols[Ic][39]))
					// MSGALERT(ITEM+PRODUTO+NUM)
					MSGALERT("Já existe este produto, neste pedido para esta analise")
					NUM := " "
			//		acols[n][7] := 0
				ENDIF
				
				
				
			Next
		ENDIF
	ENDIF
ENDIF
Return(NUM)


