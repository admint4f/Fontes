#INCLUDE "rwmake.ch"

#DEFINE CR chr(13)+chr(10)

/*/

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA020TOK  บ Autor ณ Fabiano            บ Data ณ  01/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada para envio de email no momento do cadastroบฑฑ
ฑฑบ          ณ de fornecedores.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

/*/

User Function MA020TDOK


// Ajuste para eliminar Tab nos campos
cNome := iif(at(chr(9),a2_NOME)<>0,left(a2_NOME,at(chr(9),A2_NOME)-1),a2_NOME)
cEnd  := iif(at(chr(9),a2_END)<>0,left(a2_END,at(chr(9),A2_END)-1),a2_END)
cNum  := iif(at(chr(9),a2_nr_end)<>0,left(a2_nr_end,at(chr(9),A2_nr_end)-1),a2_nr_end)
cBairro := iif(at(chr(9),a2_bairro)<>0,left(a2_bairro,at(chr(9),A2_BAIRRO)-1),a2_bairro)

//Reclock("SA2",.F.)
if cNome<>A2_NOME
	M->A2_NOME := cNome
	M->a2_apolice := "1"
endif
if cEnd<>A2_END
	M->A2_END   := cEnd
	M->a2_apolice := trim(a2_apolice)+"2"
endif
if cNum<>A2_nr_end
	M->A2_NR_END   := cNum
	M->a2_apolice := trim(a2_apolice)+"3"
endif
if cBairro<>A2_Bairro
	M->A2_BAIRRO := cBairro
	M->a2_apolice := trim(a2_apolice)+"4"
endif
Msunlock()


if M->A2_XTPPGTO = "S" .and. empty(alltrim(M->A2_NUMCON))
	msgstop("Dados bancแrios obrigat๓rios","MA020TdOK",)   
	Return(.f.)
Endif

if TRIM(M->A2_EST) = "EX" .and. empty(alltrim(M->A2_NIFEX ))
	msgstop("C๓digo NIF obrigat๓rio por se tratar de fornecedor estrangeiro","MA020TdOK",)   
	Return(.f.)
Endif

Return(.t.)

//User Function MA020TOK

//

//If ALLTRIM(M->A2_EST) <> "EX"
//
//                If Empty(M->A2_CGC)
//
//                               MsgBox(" CNPJ Nao informado no Cadastro do Fornecedor: " + M->A2_COD + "/" + M->A2_LOJA)
//
//                               Return(.f.)
//
//                Endif
//
//Endif
//
//
//
//Return(.t.)

