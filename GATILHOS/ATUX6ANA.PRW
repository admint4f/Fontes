USER FUNCTION ATUX6ANA()
Local numana := M->ZL_CHAVE1
Local aAreaAnt := GetArea()
					
					//----------------------------------------------------------------------------------------------------------------------------------------
					// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 30/08/2019
					// Trecho comentado para descobrirmos onde é a chamada dessa U.Function - Combinado com Thiago
					//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
					/*
					GetMv("MV_NUMANA")
		  			RecLock( "SX6",.F. )
					SX6->X6_CONTEUD := numana
					MsUnlock()
					*/
					//{ Fim } --------------------------------------------------------------------------------------------------------------------------------					 
msgalert(numana)
RestArea(aAreaAnt)                               
                                                  
RETURN(M->ZL_ARTISTA)