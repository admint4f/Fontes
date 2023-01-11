//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#INCLUDE "MSGRAPHI.CH"
#include 'protheus.ch'

/*/{Protheus.doc} ALTSRV
description - Funcao responsavel por alterar apenas alguns campos da Alias informada
@type function
@version 
@author Rogério Costa
@since 11/11/2020
@return return_type, return_description
/*/
User Function ALTSRV()

	Local oBrowse
	Local aArea     := GetArea()

	Private aRotina		:= MenuDef()
	Private CCADASTRO   := "Cadastro de Verbas"

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('SRV')
	oBrowse:Activate()

	RestArea(aArea)

Return

/*/{Protheus.doc} MenuDef
description - Funcao responsavel por montar o menu de acesso da rotina
@type function
@version 
@author Rogério Costa
@since 11/11/2020
@return return_type, return_description
/*/
Static Function MenuDef

	Local aRotina := {}

	Add Option aRotina Title 'Pesquisar' 			Action 'AxPesqui' 		  	Operation 1 Access 0
	Add Option aRotina Title 'Visualizar' 			Action 'AxVisual' 			Operation 2 Access 0
	Add Option aRotina Title 'Alterar' 				Action 'U_ALT001()' 		Operation 4 Access 0

Return(aRotina)

/*/{Protheus.doc} ALTSRV
description - Funcao responsavel por alterar o cadastro com os campos informados nas variaveis.
@type function
@version 
@author Rogério Costa
@since 11/11/2020
@return return_type, return_description
/*/
User Function ALT001()

	Local aAcpoVis  := { "RV_COD", "RV_DESC", "RV_TIPOCOD" , "RV_TIPO","RV_XRCUSTO","RV_DB","RV_CB","RV_DBPEP","RV_CDPEP",;
		"RV_ENCARCC","RV_CUSTO","RV_LCTOP","RV_LANCPCO"}
	Local aAcpoAlt  := { "RV_XRCUSTO","RV_DB","RV_CD","RV_DBPEP","RV_CDPEP","RV_ENCARCC","RV_CUSTO","RV_LCTOP","RV_LANCPCO"}

	// aAcpoVis - Array com o nome dos campos que serão exibidos na interface (tela).
	// aAcpoAlt - Array com o nome dos campos que poderão ser editados.

	//Funcao Padrao de alterar AXCADASTRO - detalhe no fonte pai precisa ter a variavel CCDASTRO declarada como Private.
	//No caso abaixo foi informado o codigo 3, pois no menu somente existe tres rotinas e a alteracao e o terceiro item.

	//AxAltera( <cAlias>, <nReg>, <nOpc>, <aAcho>, <aCpos>, <nColMens>, <cMensagem>, <cTudoOk>, <cTransact>, <cFunc>, <aButtons>, <aParam>, <aAuto>, <lVirtual>, <lMaximized>)

	AxAltera("SRV",,3,aAcpoVis,aAcpoAlt,,,"U_ALTTOK()")

Return

/*/{Protheus.doc} ALTTOK
description
@type function
@version 
@author roger
@since 16/11/2020
@return return_type, return_description
/*/
User Function ALTTOK()

	Local 	chtm	:=""
	Local 	cTO		:= ""
	Local	cCC 	:= ""
	Local 	cBcc	:= ""
	Local 	cTexto	:="Alteração"
	Local	aCampo	:= {}
	Local 	lRet	:=.T.

	If !(M->RV_DB == SRV->RV_DB)
		aAdd(aCampo,{FWX3Titulo("RV_DB"),M->RV_DB,SRV->RV_DB})
	End If

	If !(M->RV_CD == SRV->RV_CD)
		aAdd(aCampo,{FWX3Titulo("RV_CD"),M->RV_CD,SRV->RV_CD})
	EndIf

	If !(M->RV_DBPEP == SRV->RV_DBPEP)
		aAdd(aCampo,{FWX3Titulo("RV_DBPEP"),M->RV_DBPEP,SRV->RV_DBPEP})
	EndIf

	If !(M->RV_CDPEP == SRV->RV_CDPEP)
		aAdd(aCampo,{FWX3Titulo("RV_CDPEP"),M->RV_CDPEP,SRV->RV_CDPEP})
	EndIf

	If !(M->RV_LCTOP == SRV->RV_LCTOP)
		aAdd(aCampo,{FWX3Titulo("RV_LCTOP"),M->RV_LCTOP,SRV->RV_LCTOP})
	EndIf

	If !(M->RV_XRCUSTO==SRV->RV_XRCUSTO)
		aAdd(aCampo,{FWX3Titulo("RV_XRCUSTO"),M->RV_XRCUSTO,SRV->RV_XRCUSTO})
	EndIf

	If !(M->RV_ENCARCC==SRV->RV_ENCARCC)
		aAdd(aCampo,{FWX3Titulo("RV_ENCARCC"),M->RV_ENCARCC,SRV->RV_ENCARCC})
	EndIf
	
	If !(M->RV_CUSTO==SRV->RV_CUSTO)
		aAdd(aCampo,{FWX3Titulo("RV_CUSTO"),M->RV_CUSTO,SRV->RV_CUSTO})
	EndIf
	
	If !(M->RV_LCTOP==SRV->RV_LCTOP)
		aAdd(aCampo,{FWX3Titulo("RV_LCTOP"),M->RV_LCTOP==SRV->RV_LCTOP})
	EndIf
	
	If !(M->RV_LANCPCO==SRV->RV_LANCPCO)
		aAdd(aCampo,{FWX3Titulo("RV_LANCPCO"),M->RV_LANCPCO==SRV->RV_LANCPCO})
	EndIf

	If Len(aCampo) > 0

		chtm:='<html>'
		chtm+='<head>'
		chtm+='<title> '+cTexto+' de Verba </title>'
		chtm+='<body>'
		chtm+='<p>Atenção, </p>'
		chtm+='<br>'
		chtm+='<p>A verba de código <strong>'+SRV->RV_COD+' - '+Alltrim(SRV->RV_DESC)+' </strong> '
		chtm+='foi alterada pelo usuário <strong>'+ UsrFullName() +'</strong>'
		chtm+='<br><br>'

		chtm+='<table border="1" width=100%>'
		chtm+=' <tr>'
		chtm+=' 	<td><strong>Campo</strong></td>'
		chtm+=' 	<td><strong>Conteudo Novo</strong></td>'
		chtm+=' 	<td><strong>Conteudo Antigo</strong></td>'
		chtm+=' </tr>

		For n:=1 to Len(aCampo)
			chtm+='<tr>'
			chtm+='<td>'+Alltrim(aCampo[n][1])+'</td>'
			chtm+='<td>'+Alltrim(aCampo[n][2])+'</td>'
			chtm+='<td>'+Alltrim(aCampo[n][3])+'</td>'
			chtm+='</tr>'
		Next n

		chtm+='</table>'
		chtm+='<br><br><hr>'
		chtm+='<p><strong>E-mail automático! Não responda essa mensagem!</strong></p><hr>'
		chtm+='</body>'
		chtm+='</html>'

		cTO	:= "amarsola@t4f.com.br,dabreu@t4f.com.br"
		cCC := "dabreu@t4f.com.br"
		cBcc:= ""

		cTxtemail := "Atualização Cadastro de verbas "

		//U_EnvEmail(cTO,cTxtemail+ dtoc(MsDate()),cHtm,{},.F.)
		U_SENDMAIL(cTO,cCc,cBcc,cTxtemail+ dtoc(MsDate()),cHtm)
	EndIf

Return(lRet)
