#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CRLF (chr(13)+chr(10))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT235G2   �Autor  �Sergio Celestino    � Data �  19/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Enviar e-mail ao solicitante quando ocorrer cancelamento   ���
���          �via elemina��o por residuo (Ponto de Entrada)               ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AlteraVenc

// Buscar RA_SUP (gestor - para receber e-mail)
// Tabela ZZS - Gestores - buscar e-mail  ZZS_EMAIL
// GATILHO - iif(!empty(m->e1_vencrea),u_AlteraVenc(),m->e1_vencrea) 

Local _cSUBJECT:="-Financeiro] Altera��o de Vencimento de T�tulo "
Local cTxtEmail:=""
Local _aFiles:=array(1)
Local oDlg
Local cDestEmail := ""
Local lRes := .F.
Local xAlias := "SE1" 
Local cCrLf    	:= Chr(13) + Chr(10)

Local aArray := {}

If inclui
	Return(M->E1_VENCREA)
endif

_NomeUser := trim(substr(cUsuario,7,15))

auser := pswret(1)
cemail := alltrim(auser[1,14])
cUser  := alltrim(auser[1,1])
cDestEmail := PSWRET(1)[1][14]

DbSelectArea(xAlias)
//dVenc    := SE1->E1_VENCTO
dVENCREA := SE1->E1_VENCREA

//IF dVenc = m->E1_VENCTO .and. dVENCREA = SE1->E1_VENCREA
IF m->e1_VENCREA = SE1->E1_VENCREA
	Return(M->E1_VENCREA)
Endif

If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
	cDestEmail := GetMv("MV_XMAILRE",,"teste@teste.com.br")
Else
	Select SAL
	dbsetorder(2)
	seek xFilial()+ "000074"
	if !eof()
		PswOrder(1) // Ordem de numero
		If PswSeek(SAL->AL_USER,.T.)
			cDestEmail := PSWRET(1)[1][14]
		endif
	endif
Endif
                                                   
if empty(m->E1_OBS)
	cObs := "Motivo n�o informado"
else
	cObs := m->E1_OBS
endif
cTxtEmail := "Cliente : " +se1->e1_nomcli + cCrLf  // Pula linha
cTxtEmail += "T�tulo : " + se1->(E1_PREFIXO+" "+E1_NUM+" "+E1_PARCELA) + cCRLF
cTxtEmail += "Vencimento alterado de : "+dtoc(SE1->E1_VENCREA)+" para " + dtoc(M->E1_VENCREA) + cCRLF
cTxtEmail += "Motivo : "+cObs + cCRLF
cTxtEmail += "Alterado pelo usu�rio : "+_NomeUser

do case
	case SM0->M0_CODIGO == '08'
		cEmp := '[T4F'
	case SM0->M0_CODIGO == '09'
		cEmp := '[Metropolitan'
	case SM0->M0_CODIGO == '16'
		cEmp := '[Vicar'
	case SM0->M0_CODIGO == '20'
		cEmp := '[A&B'
	case SM0->M0_CODIGO == '25'
		cEmp := '[Mkt'
endcase
U_EnvEmail(cDestEmail+";contasareceber@t4f.com.br",cEmp+_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao superior que houve altera��o no vencimento.
//U_EnvEmail("luiz.totalit@t4f.com.br",cEmp+_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao superior que houve altera��o no vencimento.

Return(M->E1_VENCREA)
