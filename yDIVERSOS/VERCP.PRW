USER FUNCTION VERCP()

Local aArea    := GetArea()  
nome := Posicione("SA2",1,xFilial("SA2")+ca120Forn,"A2_CP")
IF ALLTRIM(nome) == "X"
   Msgalert("ATENÇÃO !! - JÁ EXISTE CONTRATO DE PARCERIA PARA ESTE FORNECEDOR - VERIFICAR!")
     M->C7_OBSCP := "EXISTE CONTRATO DE PARCERIA"
ENDIF

RestArea(aArea)
return(M->C7_PRODUTO) 