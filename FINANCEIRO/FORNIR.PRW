USER FUNCTION FORNIR

dbselectarea("SE2")

Set filter to ALLTRIM(SE2->E2_TIPO) == "TX"

dbGotop()

While !eof()
     
     
IF !EMPTY(E2_BAIXA)
   dbSkip()
   loop
ENDIF

//IF ALLTRIM(E2_NATUREZ) <> "PIS"
//   dbSkip()
//   loop
//ENDIF

//IF ALLTRIM(E2_NATUREZ) <> "COFINS"
//   dbSkip()
//   loop
//ENDIF

//IF ALLTRIM(E2_NATUREZ) <> "CSLL"
//   dbSkip()
//   loop
//ENDIF

IF ALLTRIM(E2_CODRET) == "5952"
Reclock('SE2',.f.)
SE2->E2_LOJA   := "01"
SE2->E2_NOMFOR := "PIS/COFINS/CSLL RET"
SE2->( MsUnlock() )
ENDIF                      

IF ALLTRIM(E2_CODRET) == "5979"
Reclock('SE2',.f.)
SE2->E2_LOJA   := "02"
SE2->E2_NOMFOR := "PIS RETENCAO S/ 3ºS" 
SE2->( MsUnlock() )
ENDIF                      

IF ALLTRIM(E2_CODRET) == "5960"
Reclock('SE2',.f.)
SE2->E2_LOJA   := "03"
SE2->E2_NOMFOR := "COFINS RETENCAO S/ 3" 
SE2->( MsUnlock() )
ENDIF                      

IF ALLTRIM(E2_CODRET) == "5987"
Reclock('SE2',.f.)
SE2->E2_LOJA   := "04"
SE2->E2_NOMFOR := "CSLL RETENCAO S/ 3ºS" 
SE2->( MsUnlock() )
ENDIF                      
          
DBSKIP()

ENDDO

RETURN