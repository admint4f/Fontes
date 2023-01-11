#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SPDPIS09 º Autor ³ Marcelo Iuspa      º Data ³  29/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para a Geracao dos Registro do Bloco F100 º±±
±±º          ³ SPED PIS COFINS.                                           º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rotina SPEDPISCOF                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function DEPCTBGRV()

Local aSavAre   := GetArea()

if ct2->ct2_lote='008810' .or. ct2->ct2_lote='008820'
	cChave := dtos(ct2->ct2_data)+ct2->(ct2_lote+ct2_sblote+ct2_doc) 
	Select CT2
	dbSetOrder(1)
	Seek xfilial()+cChave
	Do while !eof() .and.  cChave = dtos(ct2->ct2_data)+ct2->(ct2_lote+ct2_sblote+ct2_doc)
		do case
			case ct2->ct2_lote='008810'
				reclock("CT2",.F.)
				CT2->CT2_XDOC  := SF1->F1_DOC
				CT2->CT2_XUSER := SUBSTR(CUSUARIO,7,15)
				CT2->CT2_XDATA := DATE()
				CT2->CT2_XPEDCO:= SD1->D1_PEDIDO
				msunlock()
			case ct2->ct2_lote='008820'
				reclock("CT2",.F.)
				CT2->CT2_XDOC  := SF2->F2_DOC
				CT2->CT2_XUSER := SUBSTR(CUSUARIO,7,15)
				CT2->CT2_XDATA := DATE()
//				CT2->CT2_XPEDCO:= SD2->D2_PEDIDO
				msunlock()
		endcase
		skip
	enddo
Endif

Return
