#Include "PROTHEUS.CH"
//--------------------------------------------------------------
// Luiz Eduardo - 22/05/2017
// Ponto de entrada para permitir a exclus?o de border?s de contas a pagar somente para usu?rios 
// cadastrados no par?metro MV_XFINUSR
//--------------------------------------------------------------
User Function F240OK()  
Local aAreBkp:= GetArea()  // Salva area anterior.
Local cFiltro:= ""
//Local cUserFin := GetMv("MV_XFINUSR")   //#WAC20170927 - Retirado o GetMv pois n?o existe em todas as empresas
Local cUserFin := SuperGetMv( "MV_XFINUSR" ,.F.,"ND", ) //#WAC20170927 - Incluido para caso n?o exista parametro retorna ND evitando error log

If !(__cUserID $ cUserFin) .And. cUserFin <> "ND"
	Aviso("Help","Usu?rio n?o habilitado para exclus?o de border?s, favor acionar o departamento financeiro" ,{"Ok"},1)
	Return(.f.) 
endif          

Return(.t.)      
