#INCLUDE "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4GCOM020 º Autor ³Wellington Santos   º Data ³ 09/06/2009  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Tela para cadastro de CC x Elemento PEP                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GCOM020(cRetorno)
//Local cRetorno	:= space(20)
Local nPosCC	:= AScan(aHeader,{|x| AllTrim(x[2]) == "C1_CC" })
Local nPosIte := AScan(aHeader,{|x| AllTrim(x[2]) == "C1_ITEMCTA" })

aCols[N,nPosCC] := aCols[1,nPosCC]
aCols[N,nPosIte] := aCols[1,nPosIte]
//cRetorno	:= aCols[N,nPosIte]

IF ! EMPTY( aCols[N,nPosCC])	// apenas com centro de custo preenchido
	aArea:=GetArea()
	dbSelectArea("SZ3")
	dbSetOrder(2)	//Z3_FILIAL+Z3_ELEMPEP+Z3_CC
	// se achou o elemento pep na amarracao
	IF dbSeek(xFilial("SZ3")+aCols[N,nPosIte])
		// faz uma busca exata entre o elemento pep + o centro de custo
		if ! dbSeek(xFilial("SZ3")+aCols[N,nPosIte]+aCols[N,nPosCC])
			MsgAlert(" Elemento PEP não pode ser utilizado por esse Centro de Custo ")
			cRetorno := space(20)
		endif
	Endif
	if SM0->M0_CODIGO # '16'
		Select CTT
		seek xFilial()+aCols[N,nPosCC]
		if !eof() .and. trim(ctt_desc02)="VICAR"
//			MsgAlert(" Centro de Custo VICAR , não poderá ser utilizado nessa empresa ")
			ApMsgStop("Centro de Custo VICAR não poderá ser utilizado nessa empresa.")
			cRetorno := space(20)
		endif
	endif
	RestArea(aArea)
ENDIF

return( cRetorno)
