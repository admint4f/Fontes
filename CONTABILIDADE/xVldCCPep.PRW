#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vldEpep   ºAutor  ³Rodrigo Fazan       º Data ³  15/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³programa a ser inserido nos valids dos campos elemento pep  º±±
±±º          ³para verificar se é compativel com o Centro de Custo        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F - Alt Ideias                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function vldEpep(cCpoEped, cCpoCC)
                           
local lRet 		:= .T.
local cMsg      := ""
local cEpep		:= ""
local cCusto	:= ""

//tratamento para quando o campo for numa getDados
cEpep := &("M->"+cCpoEped)
   
if type("aHeader") == "A" .and. len(aHeader) > 0
	cCusto := gdFieldGet(cCpoCC, n)	
else
	cCusto := &("M->"+cCpoCC)	
endif

if !empty(alltrim(cEpep)) .and. !empty(alltrim(cCusto))
    
	/*
		posiciona na CTD para verificar se o EPEP aceita centro de custo 1=Ambos;2=Nacional;3=Internacional;
	*/
	CTD->( dbSetOrder(1) )
	CTT->( dbSetOrder(1) )
	if CTD->( dbSeek( xFilial("CTD")+cEpep ) ) .and. CTT->( dbSeek( xFilial("CTT")+cCusto ) )
		
		if alltrim(CTT->CTT_XTPEPE) == "2"
			//Validacao para CC Nacional
			if alltrim(CTD->CTD_XTPEPE) == "3"
				cMsg := "O centro de custo: " + chr(10)+chr(13)
				cMsg += alltrim(CTT->CTT_CUSTO) + " - " + alltrim(CTT->CTT_DESC01) + chr(10)+chr(13) 
				cMsg += "configurado como NACIONAL e não aceita Elemento Pep INTERNACIONAL"	
			endif
		elseif alltrim(CTT->CTT_XTPEPE) == "3"
			//Validacao para CC Internacional
			if alltrim(CTD->CTD_XTPEPE) == "2"
				cMsg := "O centro de custo: " + chr(10)+chr(13)
				cMsg += alltrim(CTT->CTT_CUSTO) + " - " + alltrim(CTT->CTT_DESC01) + chr(10)+chr(13) 
				cMsg += "configurado como INTERNACIONAL e não aceita Elemento Pep NACIONAL"	
			endif	 
		endif
		
	endif
	
	if !empty(alltrim(cMsg))
		aviso("Elemento PEP inválido!", cMsg, {"OK"})
		lRet := .F.	
	endif

endif

return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vldEpep   ºAutor  ³Rodrigo Fazan       º Data ³  15/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³programa a ser inserido nos valids dos campos elemento pep  º±±
±±º          ³para verificar se é compativel com o Centro de Custo        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F - Alt Ideias                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function vldCC(cCpoCC, cCpoEped)
                           
local lRet 		:= .T.
local cMsg      := ""

//tratamento para quando o campo for numa getDados
cCusto := &("M->"+cCpoCC)
   
if type("aHeader") == "A" .and. len(aHeader) > 0
	cEpep := gdFieldGet(cCpoEped, n)	
else
	cEpep := &("M->"+cCpoEped)
endif

if !empty(alltrim(cCusto)) .and. !empty(alltrim(cEpep))
	/*
		posiciona na CTD para verificar se o EPEP aceita centro de custo 1=Ambos;2=Nacional;3=Internacional;
	*/
	CTD->( dbSetOrder(1) )
	CTT->( dbSetOrder(1) )
	if CTD->( dbSeek( xFilial("CTD")+cEpep ) ) .and. CTT->( dbSeek( xFilial("CTT")+cCusto ) )
		if alltrim(CTD->CTD_XTPEPE) == "2"
			//Validacao para CC Nacional
			if alltrim(CTT->CTT_XTPEPE) == "3"
				cMsg := "O Elemento Pep: " + chr(10)+chr(13)
				cMsg += alltrim(CTD->CTD_ITEM) + " - " + alltrim(CTD->CTD_DESC01) + chr(10)+chr(13) 
				cMsg += "configurado como NACIONAL e não aceita Centro de Custo INTERNACIONAL"	
			endif
		elseif alltrim(CTD->CTD_XTPEPE) == "3"
			//Validacao para CC Internacional
			if alltrim(CTT->CTT_XTPEPE) == "2"
				cMsg := "O Elemento Pep: " + chr(10)+chr(13)
				cMsg += alltrim(CTD->CTD_ITEM) + " - " + alltrim(CTD->CTD_DESC01) + chr(10)+chr(13) 
				cMsg += "configurado como INTERNACIONAL e não aceita Centro de Custo NACIONAL"	
			endif	 
		endif
	endif
	
	if !empty(alltrim(cMsg))
		aviso("Centro de Custo inválido!", cMsg, {"OK"})
		lRet := .F.	
	endif

endif

return lRet