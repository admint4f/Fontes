#INCLUDE "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MA150BUT บAutor  ณBruno Daniel Borges บ Data ณ  11/07/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para incluir botoes de usuario na tela de  บฑฑ
ฑฑบ          ณatualizacao da cotacao                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MA150BUT()
Local aRetorno := {}

Aadd(aRetorno,{"CLIPS",{|| Anexa_Documento()	}	,"Anexar documentos na cota็ใo de compras","Anexo" })    

Return(aRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAnexa_DocumentoบAutor  ณBruno Daniel Borges บ Data ณ  18/03/08   บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao de Downdload e Upload de arquivos ZIPs                    บฑฑ
ฑฑบ          ณ                                                                 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                             บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Anexa_Documento()
Local nTipoPrc	:= Aviso("Tipo de Opera็ใo","Clique no botใo abaixo conforme o tipo de opera็ใo a ser efetuada.",{"Anexar","Download","Cancelar"})
Local cPathZIPs	:= Upper(AllTrim(GetMv("MV_XPATHSC8",,"ANEXOS_COT/")))
Local cFileOrig	:= ""        
Local cPathDest	:= ""
Local i
                
//Anexar documento
If nTipoPrc == 1 
	If l150Inclui 
		MsgAlert("Aten็ใo confirme a inclusใo dessa cota็ใo e depois clique em ATUALIZAR para anexar documentos.")
		Return(Nil)
	EndIf
	
	If (File(cPathZIPs+cA150Num+cA150Forn+cA150Loj+".ZIP") .And. MsgYesNo("Aten็ใo, jแ existe um anexo a essa cota็ใo/fornecedor. Deseja sobrescrev๊-lo ?")) .Or. !File(cPathZIPs+cA150Num+cA150Forn+cA150Loj+".ZIP") 
		MontaDir(cPathZIPs)
		cFileOrig := cGetFile( "Arquivos Compactados(*.ZIP)  |*.ZIP" , "Selecione o arquivo com o(s) anexo(s) da Cota็ใo de Compras." )
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
		MsgAlert("Aten็ใo, nใo hแ anexo(s) para essa cota็ใo de compras.")
		Return(Nil)	
	Else
		cPathDest := cGetFile("\", "Diretorio Destino",,,,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_LOCALFLOPPY)
		If !Empty(cPathDest)
			CpyS2T(Upper(cPathZIPs+cA150Num+cA150Forn+cA150Loj)+".ZIP",cPathDest,.F.)
			MsgAlert("O arquivo " + Upper(cPathDest)+cA150Num+cA150Forn+cA150Loj+".ZIP foi copiado com o(s) anexo(s) dessa cota็ใo de compras.")
		EndIf		
	EndIf
EndIf

Return(Nil)
