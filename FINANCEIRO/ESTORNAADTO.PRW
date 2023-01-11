#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
static __lOKExc  // Variavel 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESTORNAADTOºAutor  ³Gilberto A. Oliveiraº Data ³  23/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fonte contendo os Pontos de Entrada:                        º±±
±±º          ³ - EXCADTO -> Faz parte do aRotina do Programa GERASE2.      º±±
±±º          ³ - FA050B01                                                  º±±
±±º          ³ - FA050DEL                                                  º±±
±±º          ³ Ambos trabalham para validar a exclusao dos titulos que     º±±
±±º          ³ estao ligados a Solicitacoes de Adiantamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExcAdto()  ºAutor  ³Gilberto A. Oliveiraº Data ³  23/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Apenas informativo. Faz parte do aRotina (menu) do programa º±±
±±º          ³ GeraSE2().                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                  
User Function ExcAdto()

ApmsgInfo("Atenção: "+chr(13)+;
		  "O titulo gerado por essa rotina somente poderá "+chr(13)+;
		  "ser excluído através da rotina de Contas à Pagar."+chr(13)+chr(13)+;
		  "Prefixo: "+ZZE->ZZE_PREF+CHR(13)+;
		  "Título.: "+ZZE->ZZE_TITULO+CHR(13)+;
		  "Parc...: "+ZZE->ZZE_PARC )


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050B01  ºAutor  ³Gilberto A Oliveira º Data ³  18/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para alertar o usuario a respeito do fato º±±
±±º          ³ do titulo estar vinculado a uma Soliciatacao de Adiant.    º±±
±±º          ³ e pedir uma confirmacao para exclusao.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA050DEL
Local aGetArea	:= GetArea()
Local lReturn	:= .f.
Local _cQuery	:= ""
Local _cAlias	:= ""
Local _lOk		:= .T.

If Empty(SE2->E2_NUMSPA)  // Se nao tiver um adiantamento amarrado, entao libera a exclusao conforme mantendo o fluxo normal.
	lReturn:= .t.
Else

	_cAlias	:= GetNextAlias()
	_cQuery	:= "SELECT ZZE_NUMERO, ZZE_FORNEC, ZZE_PREF, ZZE_TITULO "
	_cQuery	+= " FROM " + RetSqlName("ZZE")
	_cQuery	+= " WHERE ZZE_FILIAL = '" + xFilial("ZZE") + "' "
	_cQuery	+= " AND ZZE_NUMERO = '" + SE2->E2_NUMSPA + "' "
//	_cQuery	+= " AND ZZE_FORNECE = '" + SE2->E2_FORNECE + "'"
//	_cQuery	+= " AND ZZE_PREFIXO = '" + SE2->E2_PREFIXO + "'"
//	_cQuery	+= " AND ZZE_TITULO = '" + SE2->E2_NUM + "'"
	TcQuery _cQuery New Alias &(_cAlias)
	
	If (_cAlias)->(EOF())
		// Se nao encontrou o adiantamento, trata-se de uma inconsistencia pois deveria ter encontado. 
		// Mas de qualquer maneira procede com o fluxo normal de exclusao.
		lReturn:= .t.	
	Else
		While (_cAlias)->(!EOF()) .And. _lOk
			If (SE2->E2_FORNECE == (_cAlias)->ZZE_FORNEC) .And. (SE2->E2_PREFIXO==(_cAlias)->ZZE_PREF) .And. (SE2->E2_NUM==(_cAlias)->ZZE_TITULO)
				If ApMsgYesNo("Esse título foi gerado pela rotina de geração de adiantamentos."+chr(13)+;
					"Nr. do Adiantamento: "+SE2->E2_NUMSPA+"."+chr(13)+;
					"Ao excluir esse titulo o adiantamento voltará a,"+chr(13)+;
					"ficar em aberto, disponivel para gerar novo título."+chr(13)+;
					"Confirma a Operação ?" )
					lReturn:= .t.
					__lOkExc:= .t.
					_lOk	:= .F.
				EndIf
			EndIf
			
			(_cAlias)->(dbSkip())
		EndDo
	
	    If _lOk
	    	ApMsgInfo("Atenção: A solicitação de adiantamento "+SE2->E2_NUMSPA+" vinculada não corresponde ao titulo.")
	    EndIf
		
	EndIf
	
	(_cAlias)->(dbCloseArea())
	
/*	ZZE->( DbSetOrder(1) )
	If ZZE->( DbSeek(xFilial("ZZE")+SE2->E2_NUMSPA) )
		
		// Confirma que esta' no adiantamento correto
		If (SE2->E2_FORNECE == ZZE->ZZE_FORNEC) .And. (SE2->E2_PREFIXO==ZZE->ZZE_PREF) .And. (SE2->E2_NUM==ZZE->ZZE_TITULO)
			
			If ApMsgYesNo("Esse título foi gerado pela rotina de geração de adiantamentos."+chr(13)+;
				"Nr. do Adiantamento: "+SE2->E2_NUMSPA+"."+chr(13)+;
				"Ao excluir esse titulo o adiantamento voltará a,"+chr(13)+;
				"ficar em aberto, disponivel para gerar novo título."+chr(13)+;
				"Confirma a Operação ?" )
				lReturn:= .t.
				__lOkExc:= .t.
			EndIf
			
		Else
			
		   ApMsgInfo("Atenção: A solicitação de adiantamento "+SE2->E2_NUMSPA+" vinculada não corresponde ao titulo.")
		   
		   	
		EndIf
		
	Else	  
	
		// Se nao encontrou o adiantamento, trata-se de uma inconsistencia pois deveria ter encontado. 
		// Mas de qualquer maneira procede com o fluxo normal de exclusao.
		lReturn:= .t.                    
	
	EndIf
*/
	
EndIF

RestArea(aGetArea)
Return(lReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050B01  ºAutor  ³Gilberto A Oliveira º Data ³  18/02/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada antes de concretizar a exclusao do titulo  º±±
±±º          ³ para desvincular o Adiantamento (ZZE) que gerou esse titulo º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050B01
Local aGetArea:= GetArea()
If __lOkExc
	// Apenas para confirmar que esta posicionado no local correto, caso o ponto seja modificado.
	If (SE2->E2_FORNECE == ZZE->ZZE_FORNEC) .And. (SE2->E2_PREFIXO==ZZE->ZZE_PREF) .And. (SE2->E2_NUM==ZZE->ZZE_TITULO)
		ZZE->( RecLock("ZZE",.F.) )
		ZZE->ZZE_PREF:= ''
		ZZE->ZZE_TITULO:= ''
		ZZE->ZZE_PARC:= ''
		ZZE->( MsUnLock() )
	EndIf
	Select ZZE
	dbSetOrder(4)
	Seek xFilial()+SE2->(E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA)
	If !Eof()
		ZZE->( RecLock("ZZE",.F.) )
		ZZE->ZZE_PREF:= ''
		ZZE->ZZE_TITULO:= ''
		ZZE->ZZE_PARC:= ''
		ZZE->( MsUnLock() )
	Endif
EndIf
RestArea(aGetArea)
Return