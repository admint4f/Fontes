#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*/{Protheus.doc} GPEA040
Ponto de entrada MVC na rotina de atualização de contratos
@type User function
@version 
@author Rogerio
@since 11/11/2020
@return Lógico, Retorna se deve prosseguir com o processo
/*/
User Function GPEA040()
	Local aParam     := PARAMIXB
	Local aParamPonto:={}
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local chtm       := ''
	Local aCampo	 := {}
	Local cTexto	 :="Alteração"

	If aParam <> NIL

		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

	EndIf

	If cIdPonto == 'FORMCOMMITTTSPRE'

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
			aAdd(aCampo,{FWX3Titulo("RV_LCTOP"),M->RV_LCTOP,SRV->RV_LCTOP})
		EndIf

		If !(M->RV_LANCPCO==SRV->RV_LANCPCO)
			aAdd(aCampo,{FWX3Titulo("RV_LANCPCO"),M->RV_LANCPCO,SRV->RV_LANCPCO})
		EndIf

		If Len(aCampo) > 0

			aParamPonto := PARAMIXB

			If aParamPonto[4] == .T.
				cTexto:="Inclusão"
			Else
				cTexto:="Alteração ou Exclusão"
			EndIf

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

			cTO	:= "oprocopio@t4f.com.br,lsanto@t4f.com.br"
			cCC := "masilva@t4f.com.br,emaimone@t4f.com.br"
			cBcc:= ""

			cTxtemail := "Atualização Cadastro de verbas "

			U_SENDMAIL(cTO,cCc,cBcc,cTxtemail+ dtoc(MsDate()),cHtm)

		EndIf
	EndIf

Return xRet
