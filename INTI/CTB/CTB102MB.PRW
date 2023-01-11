#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} CTB102MB
Filtro na tela de lançamentos contábeis (CT2) **
	@type.......:	function												
	@version....:	1.00													
	@author.....:	Rogério Costa											
	@since......: 	22/06/2022												
	@param......:	
/*/

User Function CTB102MB()

	Local cFiltro := ""

	If FWIsInCallStack('U_T4FAPRRECBIL')

		cDoc := CT2->CT2_DOC

		cFiltro := " CT2_DATA = '"+cData+"' .AND. CT2_LOTE = 'RECBIL' " 

	EndIf


Return(cFiltro)
