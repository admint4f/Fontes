#include "totvs.ch"
#include "rwmake.ch"
#include "Topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"


/*/{Protheus.doc} MTALCALT
Ponto de Entrada utilizado para alteração da tabela SCR (Documentos com alçada) após operação de inclusão.
@type function
@version  2.0
@author roger
@since 06/01/2021
/*/

User Function MTALCALT()

	Local nNivel,nNivel1,nNivSup,nNivInf
	Local cAlias := GetNextAlias()

	If SCR->CR_TIPO == "CT"  .OR. SCR->CR_TIPO == "MD" .OR. SCR->CR_TIPO == "RV"
		RecLock("SCR", .F.)
		SCR->CR_XCONTRA := CN9->CN9_NUMERO
		SCR->CR_XREVISA := CN9->CN9_REVISA
		If SCR->CR_NIVEL == '01'
			SCR->CR_STATUS := '02'
		EndIf
		MsUnLock()
	EndIf

	// Criada condição para que altere para o nível superior quando o usuário aprovador for igual ao fornecedor
	// Verifica se no cadastro do fornecedor esta preenchido o campo A2_XCODUSR
	If !Empty(ALLTRIM(SA2->A2_XCODUSR))

		BeginSql Alias cAlias
	SELECT AL_COD, AL_DESC, AL_ITEM, AL_USER, AL_NIVEL
	FROM  %table:SAL% SAL
	WHERE 
	SAL.AL_COD = %exp:SAL->AL_COD% AND
	SAL.AL_USER =  %exp:SA2->A2_XCODUSR% AND
	SAL.%notDel% 
		EndSql

		DbselectArea(cAlias)
		Do Case
		Case SAL->AL_NIVEL==(cAlias)->AL_NIVEL

			nNivel  := Val((cAlias)->AL_NIVEL)+1
			nNivSup := If(nNivel<=9,'0'+cValTochar(nNivel),cValtoChar(nNivel))
			nNivel1 := If((Val((cAlias)->AL_NIVEL)-1)=0,1,Val((cAlias)->AL_NIVEL)-1)
			nNivInf := If(nNivel1<=9,'0'+cValTochar(nNivel1),cValtoChar(nNivel1))

			DbSelectArea('SAL')
			DbSetOrder(2)
			If MsSeeK(xFilial('SAL')+SCR->CR_GRUPO+nNivSup)
				RecLock("SCR", .F.)
				SCR->CR_USER    := SAL->AL_USER
				SCR->CR_APROV   := SAL->AL_APROV
				SCR->CR_NIVEL   := SAL->AL_NIVEL
				SCR->CR_USERORI := SAL->AL_USER
				SCR->CR_APRORI  := SAL->AL_APROV
				SCR->CR_STATUS  := '02'
				MsUnLock()
			Else
				MsSeeK(xFilial('SAL')+SCR->CR_GRUPO+nNivInf)
				RecLock("SCR", .F.)
				SCR->CR_USER    := SAL->AL_USER
				SCR->CR_APROV   := SAL->AL_APROV
				SCR->CR_NIVEL   := SAL->AL_NIVEL
				SCR->CR_USERORI := SAL->AL_USER
				SCR->CR_APRORI  := SAL->AL_APROV
				SCR->CR_STATUS  := '02'
				MsUnLock()
			EndIf
		Case SAL->AL_NIVEL<(cAlias)->AL_NIVEL

			nNivel  := Val((cAlias)->AL_NIVEL)+1
			nNivSup := If(nNivel<=9,'0'+cValTochar(nNivel),cValtoChar(nNivel))
			nNivel1 := If((Val((cAlias)->AL_NIVEL)-1)=0,1,Val((cAlias)->AL_NIVEL)-1)
			nNivInf := If(nNivel1<=9,'0'+cValTochar(nNivel1),cValtoChar(nNivel1))

			DbSelectArea('SAL')
			DbSetOrder(2)
			If MsSeeK(xFilial('SAL')+SCR->CR_GRUPO+nNivSup)
				RecLock("SCR", .F.)
				SCR->CR_USER    := SAL->AL_USER
				SCR->CR_APROV   := SAL->AL_APROV
				SCR->CR_NIVEL   := SAL->AL_NIVEL
				SCR->CR_USERORI := SAL->AL_USER
				SCR->CR_APRORI  := SAL->AL_APROV
				SCR->CR_STATUS  := '02'
				MsUnLock()
			EndIf
		EndCase
		(cAlias)->(DbCloseArea())
	EndIf

Return
