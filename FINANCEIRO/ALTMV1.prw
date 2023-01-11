#include "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ALTMV    ³ Autor ³ RENATO TAKAO          ³ Data ³ 25/04/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza parametro(SX6) de FECHAMENTO                      ³±±
±±³          ³                                                            ³±±
±±³          ³Fecha os parametros                                         ³±±
±±³          ³  MV_DATAFIN                                                ³±±
±±³          ³  MV_ULMES - Use somente se estoque nao estiver em uso      ³±±
±±³          ³  MV_ULTDEPR - somente visualiza                            ³±±
±±³          ³  MV_DATAFIS                                                ³±±
±±³          ³                                                            ³±±
±±³          ³Para evitar que outros modulos efetuem movimentos em perio- ³±±
±±³          ³dos fechados de contabilidade.                              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Contabilidade                                               ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

USER FUNCTION ALTMV1()

	_cDATAFIN:=DTOC(GetMV("MV_DATAFIN"))
	_cULMES  :=DTOC(GetMV("MV_ULMES"))
	_cULTDEPR:=DTOC(GetMV("MV_ULTDEPR"))
	_cDATAFIS:=DTOC(GetMV("MV_DATAFIS"))

	//;@ 000,000 TO 160,385 DIALOG _oDlg1 TITLE "Datas bloqueio de operação dos módulos"
	@ 000,000 TO 160,230 DIALOG _oDlg1 TITLE "Bloqueio de operação dos módulos"
	@ 005,017 Say OemToAnsi("Financeiro :")
	@ 005,061 Get _cDATAFIN PICTURE "@E 99/99/99"
	@ 020,017 Say OemToAnsi("Estoque    :")
	@ 020,061 Get _cULMES PICTURE "@E 99/99/99" WHEN .F.
	@ 035,017 Say OemToAnsi("Ativo fixo :")
	@ 035,061 Get _cULTDEPR PICTURE "@E 99/99/99" WHEN .F.
	@ 050,017 Say OemToAnsi("Fiscal     :")
	@ 050,061 Get _cDATAFIS PICTURE "@E 99/99/99" WHEN .F.
	@ 065,020 BMPBUTTON TYPE 01 ACTION (GRVPAR(),close(_odlg1))
	@ 065,080 BMPBUTTON TYPE 02 ACTION Close(_oDlg1)
	ACTIVATE DIALOG _oDlg1 CENTERED

RETURN()

/*

*/
Static Function GRVPAR()
	
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 23/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	DbSelectArea("SX6")
	SX6->( DbSetOrder(1) )
	SX6->( DbSeek(xFilial("SX6")+"MV_DATAFIN") )

	RecLock("SX6",.F.)
	Replace X6_CONTEUD with  DTOS(CTOD(_cDATAFIN))
	Replace X6_DESC1 with "Ultimo Bloqueio Efetuado por: "+Alltrim(cUsername)
	Replace X6_DESC2 with "Em : "+DtoC (dDataBase )
	MsUnLock()
	*/
	
	PUTMV("MV_DATAFIN", DTOS(CTOD(_cDATAFIN)))
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	
	
	/*
	dbSeek(xFilial("SX6")+"MV_ULMES")
	RecLock("SX6",.F.)
	Replace X6_CONTEUD with  DTOS(CTOD(_cULMES))
	MSUnLock()
	*/

Return()
