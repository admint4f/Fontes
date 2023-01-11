#include "rwmake.ch"
#include "colors.ch"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240BORD  �Autor  �Geraldo Sabino      � Data �  08/02/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE NA GRAVA��O DO BORDERO E QUE QUANDO FOR BORDERO DE IMPOS���
���          � TOS VAI GRAVAR DATA DE APURACAO E CODIGO DA RETENCAO       ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Times4Fun                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F240BORD()
Local   _aAreaAtu    := GetArea()
Local   _aAreaAtuSE2 := SE2->(GetArea())

dBSelectarea("SE2")
dBSetOrder(15)
IF dBSeek(xFilial("SE2")+cNumBor)
	IF SE2->E2_TIPO $ "TX /INS/FT "
		_dDataPur := CTOD("")
		_cCodRet  := Spac(LEN(SE2->E2_CODRET))
		@ 000,000 TO 225,450 DIALOG oDlg1 TITLE " Dados CNAB Impostos (** ser� aplicado para todos os titulos deste Bordero)  "
		@ 005,010 SAY "Titulo:"
		@ 005,045 SAY ALLTRIM(se2->e2_prefixo)+"-"+ALLTRIM(se2->e2_num)+"-"+ALLTRIM(se2->e2_parcela)+"-"+ALLTRIM(se2->e2_tipo) COLOR CLR_HBLUE
		@ 015,010 SAY "Fornecedor:"
		@ 015,045 SAY ALLTRIM(se2->e2_nomfor) COLOR CLR_HBLUE
		@ 025,010 SAY "Valor R$:"
		@ 025,045 SAY (SE2->E2_SALDO + SE2->E2_ACRESC) - (SE2->E2_DECRESC) size 115 picture "@e 9,999,999.99" COLOR CLR_HBLUE
		@ 040,010 SAY "Digite o Periodo de Apuracao:   "
		@ 050,010 GET _dDataPur  SIZE 160,50  Valid !vazio()
		@ 065,010 say "Digite o Codigo de Retencao:"
		@ 075,010 get _cCodRet  size 160,15 valid   !vazio()
		@ 095,100 BMPBUTTON TYPE 01 ACTION (if(GravaImp(_dDataPur,_cCodRet),Close(oDlg1),nil))
		@ 095,145 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
		ACTIVATE DIALOG oDlg1 CENTER
	EndIf
Endif

Restarea(_aAreaAtuSE2)
Restarea(_aAreaAtu)     
Return



*****************************************************************************
Static Function GravaImp(_dData,_cCod)
dBSelectarea("SE2")
dBSetOrder(15)
IF  dBSeek(xFilial("SE2")+cNumBor)
	While E2_FILIAL + E2_NUMBOR == xFilial("SE2")+cNumBor
		
		RecLock("SE2",.f.)
		SE2->E2_DTAPUR := _dData
		IF ALLTRIM(SE2->E2_FORNECE) = "UNIAO"
			SE2->E2_CODRET := _cCod
			SE2->E2_NROREF := "1"
		ElseIF ALLTRIM(SE2->E2_FORNECE) = "INPS"
			SE2->E2_RETINS := _cCod
		Endif
		MsUnlock()
		
		dBSelectarea("SE2")
		dBskip()
	Enddo
Endif
Return .t.


