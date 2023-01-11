#include  "Protheus.Ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �CORCT2X  �Autor �Geraldo Sabino � Data � 17/12/2020 ���
�������������������������������������������������������������������������͹��
���Desc. � Gravacao do campo CT2_XDOC para uso na concilia��o Mari          �
���      � Deixar rodando durante a noite.                                  �
���      �                                                                  �
�������������������������������������������������������������������������͹��
���Uso � Para apoio ao Projeto AGIS - Migra��o dicionario x Banco         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CORCT2X()  


dBSelectarea("CT2")
dBgotop()
_cFiltro := " CT2_LOTE = '008850'  .AND. CT2_ROTINA <> 'FINA100' .AND. CT2_VALOR > 0"
MSfilter(_cFiltro)
dBSelectarea("CT2")
dbgotop()     
NNN:=0
While ! Eof() 

      IF EMPTY(CT2->CT2_XDOC) .and. !Empty(CT2->CT2_KEY)
         CT2->(Reclock("CT2",.F.))
         CT2->CT2_XDOC  :=  Substr(CT2->CT2_KEY,8,9) 
         CT2->(MsUnlock())
         NNN++
      Endif  



      dBSelectarea("CT2")
      dBskip()
Enddo
ALERT(nnn)

