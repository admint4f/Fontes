#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CODRET    � Autor � AP6 IDE            � Data �  29/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/




User Function CODRET()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


dbSelectArea("SE2")
dbSetOrder(1)
dbGotop()

While !EOF() 

IF EMPTY(SE2->E2_PARCIR)
   dbSkip()
   Loop
ENDIF             

//IF ALLTRIM(SE2->E2_FORNECE) <> "A00783"
//   dbSkip()
//   Loop
//ENDIF             


_PREFIXO  := SE2->E2_PREFIXO
_DOC      := SE2->E2_NUM
_PARCELA  := SE2->E2_PARCELA
_PARCIR   := SE2->E2_PARCIR 
_CODRET   := SE2->E2_CODRET

aAmb  := GetArea()

DbSeek(XFILIAL("SE2")+_PREFIXO+_DOC+_PARCIR)

if found()
Reclock("SE2",.F.)
  SE2->E2_CODRET := _CODRET
  Msunlock()  
endif

RestArea(aAmb)

dbskip()

Enddo

Return
