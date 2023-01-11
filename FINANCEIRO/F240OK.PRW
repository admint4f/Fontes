#Include "PROTHEUS.CH"
//--------------------------------------------------------------
// Luiz Eduardo - 22/05/2017
// Ponto de entrada para permitir a exclusão de borderôs de contas a pagar somente para usuários 
// cadastrados no parâmetro MV_XFINUSR
//--------------------------------------------------------------
User Function F240OK()  
Local aAreBkp:= GetArea()  // Salva area anterior.
Local cFiltro:= ""
//Local cUserFin := GetMv("MV_XFINUSR")   //#WAC20170927 - Retirado o GetMv pois não existe em todas as empresas
Local cUserFin := SuperGetMv( "MV_XFINUSR" ,.F.,"ND", ) //#WAC20170927 - Incluido para caso não exista parametro retorna ND evitando error log

If !(__cUserID $ cUserFin) .And. cUserFin <> "ND"
	Aviso("Help","Usuário não habilitado para exclusão de borderôs, favor acionar o departamento financeiro" ,{"Ok"},1)
	Return(.f.) 
endif          

Return(.t.)      
