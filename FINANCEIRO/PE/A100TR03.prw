#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A100TR03  � Autor �RENATO TAKAO        � Data �  04/08/08   ���
�������������������������������������������������������������������������͹��
���Descricao � PE DA FINA100                                              ���
���          � COMPELEMENTA GRAVACAO SE5                                  ���
���          � PARA GRAVAR DADOS DA SOLICITACAO DE TROCO                  ���
�������������������������������������������������������������������������͹��
���Uso       � t4f                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
   
// PEGOU OS DADOS EM FA100DOC
// VALIDOU EM FA100TRF
// GRAVOU EM A100TR03

User Function A100TR03()
         
         // substituido por A100TR01 e A100TR02            
RETURN
/*
Private aAreaAnt:= getarea()
      
if reclock("SE5",.F.)
	SE5->E5_NUMPA := cDocTran
	msunlock()
	dbskip(-1)
endif
if reclock("SE5",.F.)
	SE5->E5_NUMPA := cDocTran
	msunlock()
endif	
if reclock("ZZE",.F.)
	ZZE->ZZE_TRANSF ++
	msunlock()
endif           

restarea(aAreaAnt)

RETURN */