//Bibliotecas
#Include "Protheus.ch"
 
/*/{Protheus.doc} Menu Cadastro EPEP x Local de Evento ZB1

@type function
@author Felipe Sakaguti - CRM Services
@since 09/09/2021
@version 1.0
/*/
 
User Function T4FZB1MP()
    Local aArea     := GetArea()
    Local aAreaZB1  := ZB1->(GetArea())
    Local cDelOk    := ".T."
    Local cFunTOk   := ".T." //Pode ser colocado como "u_zVldTst()"
 
    //Chamando a tela de cadastros
    AxCadastro('ZB1', 'Local Meep x EPEP', cDelOk, cFunTOk)
    
    // AxCadastro(cAlias, cTitle, cDel, cOk, aRotAdic, bPre, bOK, bTTS, bNoTTS, aAuto, nOpcAuto, aButtons, aACS, cTela, lMenuDef)
 
    RestArea(aAreaZB1)
    RestArea(aArea)
Return
