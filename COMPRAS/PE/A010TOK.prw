#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TopConn.Ch"
#INCLUDE "RwMake.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Bruna Zechetti      º Data ³  18/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na confirmação do cadastro de Produtos.     ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A010TOK()

	If AllTrim(M->B1_TIPO) == "SR"
		Do Case
			Case Empty(M->B1_CODISS)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Cod. Serv. ISS]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_IRRF)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Impos. Renda]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_INSS)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Calcula INSS]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_PIS)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Retem PIS]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_RETOPER)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Ret. Operação]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_COFINS)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Retem COF]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_CSLL)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Retem CSLL]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
			Case Empty(M->B1_MEPLES)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Exe. Serviço]. Por favor preenche-lo!"),{"Ok"},2)
				Return(.F.)
		EndCase
	Else
		If Empty(M->B1_ORIGEM)
			Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Origem]. Por favor preenche-lo!"),{"Ok"},2)
			Return(.F.)
		EndIf
		If Empty(M->B1_POSIPI)
			Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Existe campo obrigatório em branco [Pos. IPI/NCM]. Por favor preenche-lo!"),{"Ok"},2)
			Return(.F.)
		EndIf
	EndIf

dbSelectArea("SF4")
dbSetOrder(1)
Seek xFilial()+m->B1_TE
if F4_MSBLQL='1'
	Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Favor corrigir o campo Tes de Entrada (bloqueado)"),{"Ok"},2)
	Return(.F.)
endif
Seek xFilial()+m->B1_TS
if F4_MSBLQL='1'
	Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Favor corrigir o campo Tes de Saída (bloqueado)"),{"Ok"},2)
	Return(.F.)
endif


Return(.T.)