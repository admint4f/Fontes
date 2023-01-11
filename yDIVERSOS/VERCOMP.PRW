USER FUNCTION VERCOMP()
        
dbSelectarea("SZW")   
dbGotop()

WHILE !EOF()

//msgalert(zw_c1 + " " + zw_c7)
	
	IF SUBSTR(ZW_C1,2,12)=="TICKETMASTER"
		X :=  SUBSTR(ZW_C1,33,8)
	ENDIF
                  
//    IF ALLTRIM(ZW_C1) == "TOTAL  SALES"
//		dbSkip(4)
//        Reclock("SZW",.F.)
//		Szw->zw_c7 := X
//		Msunlock()		
//		ELSE
//		dbSkip()
//    ENDIF 		


	IF SUBSTR(ZW_C1,1,2)="%S"
		dbSkip(-4)
		Reclock("SZW",.F.)
		Szw->zw_c7 := X
		SZW->ZW_C8 := DATE()
		SZW->ZW_C9 := SUBSTR(TIME(),1,5)
		Msunlock()		
        
		dbSkip(5)
	else
		dbSkip()
	ENDIF

Enddo

Return

