USER FUNCTION VERCP3()

Local aArea    := GetArea()  

IF ALLTRIM(M->C7_PRODUTO) == "DA011"
//   Msgalert("ATENÇÃO !! - JÁ EXISTE CONTRATO DE PARCERIA PARA ESTE FORNECEDOR - VERIFICAR!")
     M->C7_OBSCP := "=>DESPESAS POR CONTA DO ARTISTA<="
ELSE
     M->C7_OBSCP := " "

ENDIF                

RestArea(aArea)
return(M->C7_OBSCP) 