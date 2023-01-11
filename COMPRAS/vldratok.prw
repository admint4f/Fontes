#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldRatok  ºAutor  ³Sergio Celestino    º Data ³  01/13/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na Validacao do rateio                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VldRatok

Local nPPerc    := AScan(aHeader        ,{|x| AllTrim(x[2]) == "Z2_PERC"      })
Local nPosItem  := 0
Local nPosISc   := AScan(oGetDad:aHeader,{|x| AllTrim(x[2]) == "Z2_ITEMSC"    })
Local lRetorno  := .T.       
Local nX        := 0 
Local nPosEpep	:= AScan(aHeader        ,{|x| AllTrim(x[2]) == "Z2_ITEMCTA"   })
Local cMsgEpep	:= ""

If Alltrim(Upper(FunName(0))) == 'MATA110'		
  nPosItem  := AScan(aOrigHeader    ,{|x| AllTrim(x[2]) == "C1_ITEM"      })
Else
  nPosItem  := AScan(aOrigHeader    ,{|x| AllTrim(x[2]) == "C3_ITEM"      })
Endif    

If !aCols[N][Len(aCols[N])]
	If aCols[N][nPPerc] == 0
		Help(" ",1,"A103PERC")
		lRetorno := .F.
	EndIf
EndIf

If lRetorno
	nPercRat := 0
	nPercARat:= 0
	
	CTD->( dbSetOrder(1) )//CTD_FILIAL+CTD_ITEM
	
	For nX	:= 1 To Len(aCols)
		If !aCols[nX][Len(aCols[nX])] .And. aCols[nX][nPosISc] == aOrigAcols[nOrigN,nPosItem]
			nPercRat += aCols[nX][nPPerc]
		EndIf
		
		//trecho adicionado por alt ideas - fazan para validar se o epep nao esta bloqueado.
		if !aCols[nX][Len(aCols[nX])] .and. CTD->( dbSeek(xFilial("CTD")+aCols[nx, nPosEpep]) ) .and. CTD->CTD_BLOQ == "1" .and. !(aCols[nx, nPosEpep] $ cMsgEpep)
			cMsgEpep += aCols[nx, nPosEpep] + chr(13)+chr(10)
		endif
	Next
    
    //msg adicionada para validar os elementos peps do rateio
    if !empty(cMsgEpep)
		lRetorno := .F.
		msgAlert("Os Elementos PEP listados abaixo estão bloqueados e não podem ser usados." + chr(13)+chr(10) + cMsgEpep)    	
    endif
    
	nPercARat := 100 - nPercRat

	If Type("oPercRat")=="O"
		oPercRat:Refresh()
		oPercARat:Refresh()
	Endif

EndIf  

If lRetorno
	Do Case
	Case cTipo == "B"
		lRetorno :=	PcoVldLan("000054","11","MATA103",/*lUsaLote*/,/*lDeleta*/, .T./*lVldLinGrade*/)
	Case cTipo == "D"
		lRetorno :=	PcoVldLan("000054","10","MATA103",/*lUsaLote*/,/*lDeleta*/, .T./*lVldLinGrade*/)
	OtherWise
		lRetorno :=	PcoVldLan("000054","09","MATA103",/*lUsaLote*/,/*lDeleta*/, .T./*lVldLinGrade*/)
	EndCase
Endif

Return lRetorno