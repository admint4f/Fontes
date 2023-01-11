#INCLUDE "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	   � MS520VLD	� Autor �Alessandro Afonso      � Data � 07/07/08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada chamado do fonte MATA521.                 ���
���          � Exclusao da nota fiscal consolidada, valida�ao             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � SF2520E(void)											                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso		   � SIGALOJA 												                          ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MS520VLD()
Local aArea := GetArea()
Local aSF2Area:= SF2->(GetArea())
Local aSE1Area:= SE1->(GetArea())
Local lRet  := .T.                

If ExistBlock("CIEA097")
	//Funcao esta no fonte CIEA097 Nota Fiscal Consolidada
	//Usada para Limpara o campo F2_NFCUPOM disponibilizando para outra nota.
	//Somente ser� apricado caso a Nota fiscal estiver com os campos abaixo retornando verdadeiro
	//SF2->F2_NFCUPOM <> '' .AND. SF2->F2_VALBRUT = 0 .AND. SF2->F2_VALFAT = 0 .AND. SF2->F2_CODOBS <> ''
	lRet := U_CIEA097()
Endif
                  
RestArea(aSE1Area)
RestArea(aSF2Area)
RestArea(aArea)                  

Return(lRet)
