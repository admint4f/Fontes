#INCLUDE "PROTHEUS.CH
#include "fileio.ch"
#include "protheus.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "totvs.ch"


User Function MT110CON()

Local lGrava  := .T.
//Paramixb[1] = Numero da SC
//Paramixb[2] = Solicitante
//Paramixb[3] = Data da SC
//Paramixb[4] = Centro de Custo
//Paramixb[5] = Unidade Requisitante
//Paramixb[6] = Codigo do Comprador


If PARAMIXB[3] <> date() .and. (inclui .or. altera) // ValidaÃ§Ã£o do Usuario para interromper a gravaÃ§Ã£o     
	Aviso('Atenção','Pedido não gravado, não é permitida a alteração da data base do sistema',{'Ok'})
	dA110Data := date()
	lGrava := .f.
Endif

Return ( lGrava ) 
