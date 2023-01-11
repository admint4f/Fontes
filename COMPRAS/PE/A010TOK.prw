#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TopConn.Ch"
#INCLUDE "RwMake.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A010TOK   �Autor  �Bruna Zechetti      � Data �  18/09/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na confirma��o do cadastro de Produtos.     ��
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function A010TOK()

	If AllTrim(M->B1_TIPO) == "SR"
		Do Case
			Case Empty(M->B1_CODISS)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Cod. Serv. ISS]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_IRRF)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Impos. Renda]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_INSS)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Calcula INSS]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_PIS)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Retem PIS]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_RETOPER)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Ret. Opera��o]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_COFINS)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Retem COF]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_CSLL)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Retem CSLL]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_MEPLES)
				Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Exe. Servi�o]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
		EndCase
	Else
		If Empty(M->B1_ORIGEM)
			Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Origem]. Por favor preenche-lo!"),{"Ok"},2)
			Return(.F.)
		EndIf
		If Empty(M->B1_POSIPI)
			Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Existe campo obrigat�rio em branco [Pos. IPI/NCM]. Por favor preenche-lo!"),{"Ok"},2)
			Return(.F.)
		EndIf
	EndIf

dbSelectArea("SF4")
dbSetOrder(1)
Seek xFilial()+m->B1_TE
if F4_MSBLQL='1'
	Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Favor corrigir o campo Tes de Entrada (bloqueado)"),{"Ok"},2)
	Return(.F.)
endif
Seek xFilial()+m->B1_TS
if F4_MSBLQL='1'
	Aviso(OEMTOANSI("Aten��o"),OEMTOANSI("Favor corrigir o campo Tes de Sa�da (bloqueado)"),{"Ok"},2)
	Return(.F.)
endif


Return(.T.)