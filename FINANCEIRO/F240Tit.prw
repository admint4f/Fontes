/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240TIT   �Autor  �Microsiga           � Data �  03/16/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F240Tit

Local aArea:= GetArea()
Local _lRet := .F.
Local _cQuery
Static  _ContV 

// Verifica��o se o t�tulo de adiantamento consta no border� - fun��o verbord() - caso n�o conste renomeia no SE2 e ZZE - Luiz Eduardo - 19/03/2018
 
Select SE2
nRegSE2 := recno()
select SA2
dbSetOrder(1)
seek xFilial()+se2tmp->E2_FORNECE+se2tmp->E2_LOJA
Select SE2TMP
RecLock("SE2TMP",.f.)
//se2TMP->E2_BCOPAG := sa2->a2_banco     
MsUnLock()   

VerBord() // Fun��o que verifica se existem PA�s no border� que n�o apareceram na posi��o

Select SE2
goto nRegSe2
RestArea( aArea )

Return(.t.)  // O programa foi interrompido aqui para n�o gerar uma nova query (eliminando a query do F240fil) - Luiz Eduardo - 08-12-2017


//��������������������������Ŀ
//�MONTA QUERY DE VERIFICACAO�
//����������������������������

_cQuery := "SELECT COUNT(*) as REGS FROM " + RETSQLNAME('SE2') + " "
_cQuery += "WHERE E2_FILIAL = '"  + xFILIAL('SA2')  + "' "
_cQuery += "  AND E2_FORNECE = '" + SE2->E2_FORNECE + "' "
_cQuery += "  AND E2_LOJA    = '" + SE2->E2_LOJA    + "' "        
_cQuery += "  AND E2_TIPO    = 'PA' "
_cQuery += "  AND E2_SALDO   > 0 "
_cQuery += "  AND E2_VENCREA >='20180301'"
_cQuery += "  AND D_E_L_E_T_ = ' '"


//��������������������������Ŀ
//�EXECUTAR QUERY            �
//����������������������������

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBT4F",.f.,.t.)


If _ContV <> 2 .AND. ( TRBT4F->REGS != 0 )
   _ContV := 2
   MsgAlert("No Periodo Selecionado Existem Titulos com Pagamentos j� Adiantados. Verifique!")
   dbCloseArea("TRBT4F")
   Return(.T.)
ELSE    
   IF ( TRBT4F->REGS == 0 )
      dbCloseArea("TRBT4F")
      Return(.T.)
   ENDIF   
END

If ( TRBT4F->REGS != 0 ) .AND. _ContV == 2
	_lRet := .T. // O Retorno True n�o negativa o valor do c�lculo 
	Alert("Aten��o: Existem Pagamentos Antecipados em aberto para este fornecedor. Verifique as compensa��es.")
EndIf

dbCloseArea("TRBT4F")

// Restaura area anterior
RestArea(aArea)
Return(_lRet)

Static Function VerBord()

//��������������������������Ŀ
//�MONTA QUERY DE VERIFICACAO�
//����������������������������

_cQuery := "SELECT E2_PREFIXO,E2_NUM,E2_PARCELA,E2_FORNECE,E2_LOJA,E2_NUMBOR FROM " + RETSQLNAME('SE2') + " "
_cQuery += "WHERE E2_FILIAL = '"  + xFILIAL('SE2')  + "' "
_cQuery += "  AND E2_TIPO    = 'PA ' "
_cQuery += "  AND E2_PREFIXO = 'AUT' "
_cQuery += "  AND E2_VENCREA >= '"+DTOS(dVenIni240)+"' "
_cQuery += "  AND E2_VENCREA <= '"+DTOS(dVenFim240)+"' "
_cQuery += "  AND E2_SALDO   > 0 "
//_cQuery += "  AND E2_NUMBOR = '      ' "
_cQuery += "  AND D_E_L_E_T_ = ' '"


//��������������������������Ŀ
//�EXECUTAR QUERY            �
//����������������������������
If Select("TRBT4F") > 0
	DbSelectArea("TRBT4F")
	DbCloseArea()
Endif

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.t.,"TOPCONN",TCGENQRY(,,_cQuery),"TRBT4F",.f.,.t.)
dbgotop()
if eof()
	Return
endif

Select TRBT4F
dbGoTop()
Do while !eof()
	Select SE5
	dbSetOrder(7)
	seek xFilial()+trbt4f->(E2_PREFIXO+E2_NUM+E2_PARCELA+"PA "+E2_FORNECE+E2_LOJA)
	if !eof() .and. e5_tipo="PA" .and. e5_recpag="P" .and. e5_prefixo="AUT" .and. left(e5_histor,30)="ADIANTAMENTO AUTOMATICO GERADO" 
		recLock("SE5",.f.)                                                                                                             
		replace E5_TIPODOC with 'PA'
		MsUnLock()
	endif
	Select TRBT4F
	skip
Enddo
Select TRBT4F
use

Return

