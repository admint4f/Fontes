USER FUNCTION VERCOM                                         

LOCAL COM

GRUPO := Posicione("SB1",1,xFilial("SB1")+M->ZF_PRODUTO,"B1_GRUPO")

IF ALLTRIM(GRUPO) == "ART"

IF ALLTRIM(M->ZF_PRODUTO) == "DA001"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CSOM")	
ENDIF

IF ALLTRIM(M->ZF_PRODUTO) == "DA002"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CLUZ")		
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA003"
COM := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CHOSP")		
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA004"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CCAMARI")			
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA005"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CTAEREO")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA006"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CTTERRE")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA007"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CALIMEN")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA008"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CTEQUIP")				
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA009"
COM     := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CBACLIN")					
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA010"
COM := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CODESP")	
ENDIF                     

IF ALLTRIM(M->ZF_PRODUTO) == "DA016"
COM := Posicione("SZL",2,xFilial("SZL")+ALLTRIM(M->ZF_ANALISE),"ZL_CMIDIA")	
ENDIF

ELSE

COM := Posicione("SZS",3,xFilial("SZS")+M->ZF_ANALISE+ALLTRIM(M->ZF_PRODUTO),"ZS_REALIZA")

ENDIF
RETURN(COM)
