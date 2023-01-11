#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �T4FINA07  �Autor  �Bruna Zechetti      � Data �  10/02/14    ���
��������������������������������������������������������������������������͹��
���Desc.     �Rotina para exclus�o do relacionamento entre pedido de compra ��
���          � e adiantamento (FIE).                                        ��
��������������������������������������������������������������������������͹��
���Uso       � T4F                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/      
User Function T4FINA07()
	
	Local _cFiltro		:= ""
	Local _cPerg		:= "T4FINA7"
	Private cCadastro	:= "Relacionamento Pedidos X Adian"
	Private aRotina		:= {}
	Private _aIndFIE	:= {}
	Private _bFilFIE	:= {||}
	Private _cFilFIE	:= ""
	
	AjustaSX1(_cPerg)
	
	If Pergunte(_cPerg,.T.)
		If !Empty(MV_PAR01)
			_cFilFIE	:= "FIE_PEDIDO='" + AllTrim(MV_PAR01) + "'"
		EndIf
		
		If !Empty(MV_PAR02)
			_cFilFIE += Iif(Empty(_cFilFIE),""," .AND. ") + "FIE_NUM='" + MV_PAR02 +"'"
		EndIf
		
		If !Empty(MV_PAR03) .And. !Empty(MV_PAR04)
			_cFilFIE += Iif(Empty(_cFilFIE),""," .AND. ") + "(FIE_FORNEC>='" + MV_PAR03 +"' .AND. FIE_FORNEC<='" + MV_PAR04 +"')"
		EndIf
		
		Aadd(aRotina,{"Excluir"					,"U_fExcFIE"	,0,2})
		
		_bFilFIE 	:= {|| FilBrowse("FIE",@_aIndFIE,@_cFilFIE) }
		Eval(_bFilFIE)
		
		MBrowse(6, 1,22,75,"FIE",,,,,,,,,,,,,,_cFiltro)
	EndIf

Return()

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �fExcFIE   �Autor  �Bruna Zechetti      � Data �  10/02/14    ���
��������������������������������������������������������������������������͹��
���Desc.     �Fun��o para exclus�o do relacionamento entre pedido de compra ��
���          � e adiantamento (FIE).                                        ��
��������������������������������������������������������������������������͹��
���Uso       � T4F                                                         ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/      
User Function fExcFIE()

	Local aAreaBKP	:= GetArea()
	Local _cQuery	:= ""
	
	If MsgBox(OEMTOANSI("Confirma a EXCLUS�O desse relacionamento de Pedido e de Pagamento Antecipado ?"),OEMTOANSI("Aten��o"),"YESNO")
        If RecLock("FIE",.F.)
	        FIE->(DBDelete())
	        FIE->(MsUnlock())
 		EndIf
	EndIf					
	
	RestArea(aAreaBKP)
	
Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �Bruna Zechetti      � Data �  10/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para ajuste das perguntas.                            ��
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AjustaSX1(_cPerg)

	Local _aArea := GetArea()
	Local _aHelpPor := {}
	Local _aHelpEng := {}
	Local _aHelpSpa := {}
	
	_aHelpPor := {"Informar o pedido de compra."}
	_aHelpEng := {""}
	_aHelpSpa := {""}
	PutSx1(_cPerg,"01","Pedido ?","Pedido ?","Pedido ?","mv_ch1","C",TamSX3("C7_NUM")[1],0,0,"G","","SC7","","","mv_par01","","","","","","","","","","","","","","","","",_aHelpPor,_aHelpEng,_aHelpSpa)

	_aHelpPor := {"Informar o t�tulo ."}
	_aHelpEng := {""}
	_aHelpSpa := {""}
	PutSx1(_cPerg,"02","Titulo ?","Titulo ?","Titulo ?","mv_ch2","C",TamSX3("E1_NUM")[1],0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",_aHelpPor,_aHelpEng,_aHelpSpa)
    
	_aHelpPor := {"Informar o fornecedor ."}
	_aHelpEng := {""}
	_aHelpSpa := {""}
	PutSx1(_cPerg,"03","Fornecedor De?","Fornecedor De?","Fornecedor De?","mv_ch3","C",TamSX3("A2_COD")[1],0,0,"G","","SA2","","","mv_par03","","","","","","","","","","","","","","","","",_aHelpPor,_aHelpEng,_aHelpSpa)

	_aHelpPor := {"Informar o fornecedor ."}
	_aHelpEng := {""}
	_aHelpSpa := {""}
	PutSx1(_cPerg,"04","Fornecedor Ate?","Fornecedor Ate?","Fornecedor Ate?","mv_ch4","C",TamSX3("A2_COD")[1],0,0,"G","","SA2","","","mv_par04","","","","","","","","","","","","","","","","",_aHelpPor,_aHelpEng,_aHelpSpa)

	RestArea(_aArea)
Return()