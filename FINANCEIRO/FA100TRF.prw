#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA100TRF  � Autor � AP6 IDE            � Data �  07/07/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA100TRF
// PE da FINA100 - desativado por Takao 04/08/08
Return .t.
/*
// Rotina chamadora deve ser a fA100Tran - transferencias
Local cNumero := space(06) 
@ 20,20 TO 250,450 DIALOG oDlg TITLE "FA100TRF"
@ 30,30 Say "Nr documento:"
@ 29,70 GET cNumero PICTURE "@!" VALID !empty(cNumero)
@ 070,010 BUTTON "Ok" SIZE 50,15 ACTION close(oDlg)
@ 070,090 BUTTON "Cancelar" SIZE 50,15 ACTION close(oDlg)
 
ACTIVATE DIALOG oDlg CENTER
*/