USER FUNCTION VERLIB

LOCAL LIB

GRUPO := Posicione("SB1",1,xFilial("SB1")+M->ZF_PRODUTO,"B1_GRUPO")

IF ALLTRIM(GRUPO) == "ART"

IF ALLTRIM(M->ZF_PRODUTO) == "DA001"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_ESOM")	
ENDIF

IF ALLTRIM(M->ZF_PRODUTO) == "DA002"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_ELUZ")		
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA003"
LIB := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_EHOSP")		
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA004"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_ECAMARI")			
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA005"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_ETAEREO")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA006"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_ETTERRE")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA007"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_EALIMEN")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA008"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_ETEQUIP")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA009"
LIB     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_EBACLIN")					
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA010"
LIB := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_EODESP")	
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA016"
LIB := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_EMIDIA")	
ENDIF

ELSE

LIB := Posicione("SZS",3,xFilial("SZS")+M->ZF_ANALISE+ALLTRIM(M->ZF_PRODUTO),"ZS_LIBERA")	

ENDIF
RETURN(LIB)
