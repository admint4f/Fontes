#include 'protheus.ch'

/*-----------------------------------------------------------------------------------------------------
{Protheus.doc} _fRetCpos
Retorna um array com os campos de determinada Tabela
@author 	Carlos Eduardo Saturnino
@since 		21/08/2019
@version 	1.0
@return 	${return}, ${return_description}
@param 		cTabela, characters	, Alias da tabela com nome dos campos a serem retornados pela função
@param 		lUsado, logical		, Só Campos Usados
@type 		User Function														
------------------------------------------------------------------------------------------------------*/
User Function _fRetCpos(cTabela)

	Local aVetCpos	:= {}
	Local nX      	:= 0              
	Local aCampos 	:= FWSX3Util():GetAllFields( cTabela, .f. ) 

	If !Empty(aCampos)
		For nX := 1 To Len(aCampos)
			If x3usado(aCampos[nX]) 
				Aadd(aVetCpos,aCampos[nX])
			EndIf  
		Next nX
	EndIf   

Return aVetCpos