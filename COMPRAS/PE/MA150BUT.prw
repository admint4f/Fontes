#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA150BUT �Autor  �Bruno Daniel Borges � Data �  11/07/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para incluir botoes de usuario na tela de  ���
���          �atualizacao da cotacao                                      ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA150BUT()
Local aRetorno := {}

Aadd(aRetorno,{"CLIPS",{|| Anexa_Documento()	}	,"Anexar documentos na cota��o de compras","Anexo" })    

Return(aRetorno)

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Programa  �Anexa_Documento�Autor  �Bruno Daniel Borges � Data �  18/03/08   ���
������������������������������������������������������������������������������͹��
���Desc.     �Funcao de Downdload e Upload de arquivos ZIPs                    ���
���          �                                                                 ���
������������������������������������������������������������������������������͹��
���Uso       � T4F                                                             ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
Static Function Anexa_Documento()
Local nTipoPrc	:= Aviso("Tipo de Opera��o","Clique no bot�o abaixo conforme o tipo de opera��o a ser efetuada.",{"Anexar","Download","Cancelar"})
Local cPathZIPs	:= Upper(AllTrim(GetMv("MV_XPATHSC8",,"ANEXOS_COT/")))
Local cFileOrig	:= ""        
Local cPathDest	:= ""
Local i
                
//Anexar documento
If nTipoPrc == 1 
	If l150Inclui 
		MsgAlert("Aten��o confirme a inclus�o dessa cota��o e depois clique em ATUALIZAR para anexar documentos.")
		Return(Nil)
	EndIf
	
	If (File(cPathZIPs+cA150Num+cA150Forn+cA150Loj+".ZIP") .And. MsgYesNo("Aten��o, j� existe um anexo a essa cota��o/fornecedor. Deseja sobrescrev�-lo ?")) .Or. !File(cPathZIPs+cA150Num+cA150Forn+cA150Loj+".ZIP") 
		MontaDir(cPathZIPs)
		cFileOrig := cGetFile( "Arquivos Compactados(*.ZIP)  |*.ZIP" , "Selecione o arquivo com o(s) anexo(s) da Cota��o de Compras." )
	EndIf
	
	If !Empty(cFileOrig)
		Cpyt2s(Upper(AllTrim(cFileOrig)),cPathZIPs,.F.)           
		For i := Len(cFileOrig) To 1 Step -1
			If SubStr(cFileOrig,i,1) == "\"
				cFileOrig := SubStr(cFileOrig,i+1)
				Exit
			EndIf
		Next i
		
		FRename(Upper(cPathZIPs+cFileOrig),Upper(cPathZIPs+cA150Num+cA150Forn+cA150Loj+Right(cFileOrig,4)))
		MsgAlert("Arquivo anexado com sucesso.")	
	EndIf
                    
//Download do documento
ElseIf nTipoPrc == 2
	If !File(Upper(cPathZIPs+cA150Num+cA150Forn+cA150Loj)+".ZIP")
		MsgAlert("Aten��o, n�o h� anexo(s) para essa cota��o de compras.")
		Return(Nil)	
	Else
		cPathDest := cGetFile("\", "Diretorio Destino",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
		If !Empty(cPathDest)
			CpyS2T(Upper(cPathZIPs+cA150Num+cA150Forn+cA150Loj)+".ZIP",cPathDest,.F.)
			MsgAlert("O arquivo " + Upper(cPathDest)+cA150Num+cA150Forn+cA150Loj+".ZIP foi copiado com o(s) anexo(s) dessa cota��o de compras.")
		EndIf		
	EndIf
EndIf

Return(Nil)
