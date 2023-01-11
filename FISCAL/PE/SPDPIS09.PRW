#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SPDPIS09 บ Autor ณ Marcelo Iuspa      บ Data ณ  29/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada para a Geracao dos Registro do Bloco F100 บฑฑ
ฑฑบ          ณ SPED PIS COFINS.                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rotina SPEDPISCOF                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function SPDPIS09()
	Local aSavAre   := GetArea()
	Local cQuery    := Nil
	Local cFil      := PARAMIXB[1]
	Local dDataDe   := PARAMIXB[2]
	Local dDataAte  := PARAMIXB[3]
	Local aRetF100  := {}

	/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
	//Busca o ๚ltimo n๚mero do ๚ltimo registro da tabela CF8
	nUltCod := 0
	cQuery := "SELECT MAX(CF8_CODIGO) AS ULTCOD "
	cQuery += " FROM "       + RetSqlName("CF8") + " "
	cQuery += "WHERE " + RetSqlName("CF8")+".D_E_L_E_T_ <>'*' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
	nUltCod := ULTCOD
	use
	nSeq := val(nUltCod)+ 1
	//Consulta os contratos do m๓dulo de contratos customizado, verifica se
	//Existem contratos apropriados e considera, exceto cancelados e menor que 0.
	cQuery := " SELECT ZZ1.ZZ1_FILIAL, ZZ1.ZZ1_ITEM, " + ;
		" ZZ1.ZZ1_COFINS, ZZ1.ZZ1_CONTRA, ZZ1.ZZ1_CSLL, ZZ1.ZZ1_DATA, ZZ1.ZZ1_ICMS  , ZZ1.ZZ1_INSS, " + ;
		" ZZ1.ZZ1_IPI   , ZZ1.ZZ1_IR    , ZZ1.ZZ1_ISS , ZZ1.ZZ1_PIS , ZZ1.ZZ1_TPCONT, ZZ1.ZZ1_VALOR " + ;
		" FROM "       + RetSqlName("ZZ1") + " ZZ1 " + ;
		" WHERE " + ;
		" ZZ1.ZZ1_DATA >= '" + Dtos(dDataDe) + "' AND ZZ1.ZZ1_DATA <= '" + Dtos(dDataAte) + "' AND " + ;
		" ZZ1.ZZ1_VALOR >= 0 AND " + ;
		" ZZ1.D_E_L_E_T_ = ' ' AND "+ ;
		" ZZ1.ZZ1_LA = 'S' "
	If Select("TRB_F100") > 0
		TRB_F100->(dbCloseArea())
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB_F100", .F., .T.)
	dbgotop()
	cData  := dtos(FIRSTDAY(stod(TRB_F100->ZZ1_DATA)))
	do while !eof()
		Select ZZ0
		dbsetorder(1)
		seek TRB_F100->(ZZ1_FILIAL+ZZ1_CONTRA+ZZ1_ITEM)
		if ZZ0->ZZ0_STATUS = '5'
			Select TRB_F100
			skip
			loop
		endif
		cConta := Alltrim(ZZ0->ZZ0_CONTA)
		Select SA1
		seek xFilial()+ZZ0->(ZZ0_CLIENT+ZZ0_LOJA)
		Select SB1
		seek xFilial()+ZZ0->ZZ0_PRODUT
		Select CF8
		dbSetOrder(3)  //CF8_FILIAL+CF8_DOC+CF8_SERIE+CF8_CLIFOR+CF8_LOJA
		//Chave ๚nica = CF8_FILIAL+CF8_CODIGO
		//cChave := TRB_F100->ZZ0_FILIAL+TRB_F100->(ZZ0_CONTRA+ZZ1_ITEM)+"Ctr"+TRB_F100->(ZZ0_CLIENT+ZZ0_LOJA)
		if TRB_F100->ZZ1_VALOR > 0
			cDataZZ1 := TRB_F100->ZZ1_DATA
			cIDZZ0   := ZZ0->(ZZ0_CLIENT+ZZ0_LOJA)+TRB_F100->(ZZ1_CONTRA+ZZ1_ITEM)
			//		cSeq 	 := strzero(nSeq,6)
			cFil	 := TRB_F100->ZZ1_FILIAL
			Select SB1
			seek xfilial()+ZZ0->ZZ0_PRODUT
			Select CL2
			//CHAVE ฺNICA : CL2_FILIAL+DTOS(CL2_PER)+CL2_REG+CL2_ID
			dbSetOrder(1)
			cChave := left(TRB_F100->ZZ1_DATA,6)+"01"+"F100"+ZZ0->(ZZ0_CLIENT+ZZ0_LOJA)+TRB_F100->(ZZ1_CONTRA+ZZ1_ITEM)+RIGHT(TRB_F100->ZZ1_DATA,2)
			seek cFil+cChave
			if eof()
				RecLock("CL2",.T.)
				CL2->CL2_FILIAL	:=TRB_F100->ZZ1_FILIAL //XfILIAL()
				CL2->CL2_FILAPU	:=TRB_F100->ZZ1_FILIAL //XfILIAL()
				CL2->CL2_ID		:= ZZ0->(ZZ0_CLIENT+ZZ0_LOJA)+TRB_F100->(ZZ1_CONTRA+ZZ1_ITEM)+RIGHT(TRB_F100->ZZ1_DATA,2)
				CL2->CL2_PER	:= FIRSTDAY(stod(TRB_F100->ZZ1_DATA))
				CL2->CL2_REG	:= "F100"
				CL2->CL2_INDOP	:= "1"
				CL2->CL2_DTOPER := stod(TRB_F100->ZZ1_DATA)
				CL2->CL2_DESCR	:= SubStr(DTOC(STOD(TRB_F100->ZZ1_DATA)),4)+" "+SubStr(ZZ0->ZZ0_PRODUT,1,3)+" Ct. " + TRB_F100->ZZ1_CONTRA + ;
					"-" + TRB_F100->ZZ1_ITEM +"-" + left(SA1->A1_NREDUZ,25)
				CL2->CL2_ITEM 	:= Alltrim(ZZ0->ZZ0_PRODUT)
				CL2->CL2_VLOPER := Round(TRB_F100->ZZ1_VALOR, 2)
				CL2->CL2_CLIFOR	:= ZZ0->(ZZ0_CLIENT)
				CL2->CL2_LOJA	:= ZZ0->(ZZ0_LOJA)
				CL2->CL2_IDCF8	:=strzero(nSeq,6)
				CL2->CL2_CSTPIS	:="01"
				CL2->CL2_BCPIS 	:= Round(TRB_F100->ZZ1_VALOR, 2)
				CL2->CL2_ALQPIS := ZZ0->ZZ0_ALQPIS
				CL2->CL2_VLPIS 	:= Round(TRB_F100->(ZZ1_VALOR / 100) * ZZ0->ZZ0_ALQPIS ,2)
				CL2->CL2_CSTCOF	:="01"
				CL2->CL2_BCCOF 	:= Round(TRB_F100->ZZ1_VALOR, 2)
				CL2->CL2_ALQCOF := ZZ0->ZZ0_ALQCOF
				CL2->CL2_VLCOF 	:= Round(TRB_F100->(ZZ1_VALOR / 100) * ZZ0->ZZ0_ALQCOF ,2)
				//	CL2->CL2_INDORI	:="0"
				CL2->CL2_CTA 	:= SB1->B1_CONTAG //cConta //Alltrim(ZZ0->ZZ0_CONTA)
				CL2->CL2_CCUS 	:= Alltrim(ZZ0->ZZ0_CC) // Retirei em 02/04/2018 - Luiz Eduardo
				CL2->CL2_PARTI	:= ZZ0->(ZZ0_CLIENT)
				CL2->CL2_PART	:="1"  // Cliente
				CL2->CL2_REGIME	:="1"
				CL2->CL2_CODBCC	:= "17"
				CL2->CL2_INDCRD	:= "0"

				MsUnLock()
			Endif
		Endif
		Select Trb_F100
		nSeq ++
		dbSkip()
	Enddo
	TRB_F100->(dbCloseArea())

	/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
	// Inicio da gera็ใo dos registros do tipo ND (RL) - Tes 602 - conforme e-mail Francielly dia 10-07-2019
	_cFilial := PARAMIXB[1]

	cQuery := ""
	cQuery += "SELECT SD2.D2_FILIAL, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_EMISSAO, SD2.D2_COD,SD2.D2_TES,SD2.D2_TOTAL,"
	cQuery += " SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_CONTA, SD2.D2_CCUSTO,SD2.D2_PEDIDO, SD2.D2_ITEMPV, "
	cQuery += " SD2.D2_VALIMP6 , SD2.D2_VALIMP5 , SD2.D2_ALIQISS,SD2.D2_ALQIMP6 , SD2.D2_ALQIMP5 , "
	cQuery += " SD2.D2_ITEM "
	cQuery += " FROM "       + RetSqlName("SD2") + " SD2 "
	cQuery += " INNER JOIN "  + RetSqlName("SA1") + " SA1 ON SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA"
	cQuery += " WHERE SD2.D2_FILIAL= '" + _cFilial + "' AND SD2.D2_TES = '602' AND "
	cQuery += "  SD2.D2_EMISSAO >= '" + Dtos(dDataDe) + "' AND SD2.D2_EMISSAO <= '" + Dtos(dDataAte) + "' AND "
	cQuery += "  SA1.A1_PESSOA <> 'F' AND "
	cQuery += " SD2.D_E_L_E_T_ = ' ' AND "
	cQuery += " SA1.D_E_L_E_T_ = ' ' "

	If Select("TRB_F100") > 0
		TRB_F100->(dbCloseArea())
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB_F100", .F., .T.)
	dbgotop()
	cConta := Alltrim(TRB_F100->D2_CONTA)
	cData  := dtos(FIRSTDAY(stod(TRB_F100->D2_EMISSAO)))
	do while !eof()
		if TRB_F100->D2_TOTAL > 0
			cFil	 := TRB_F100->D2_FILIAL
			Select SB1
			seek xfilial()+TRB_F100->D2_COD
			Select SF4
			seek xfilial()+TRB_F100->D2_TES
			Select CL2
			//CHAVE ฺNICA : CL2_FILIAL+DTOS(CL2_PER)+CL2_REG+CL2_ID
			dbSetOrder(1)
			cChave := left(TRB_F100->D2_EMISSAO,6)+"01"+"F100"+TRB_F100->(D2_CLIENTE+D2_LOJA+D2_DOC+D2_SERIE+D2_ITEM)
			seek "01"+cChave //cFil+cChave
			if eof()
				RecLock("CL2",.T.)
				CL2->CL2_FILIAL	:="01"//TRB_F100->D2_FILIAL //XfILIAL()
				CL2->CL2_FILAPU	:= TRB_F100->D2_FILIAL //XfILIAL()
				CL2->CL2_ID		:= TRB_F100->(D2_CLIENTE+D2_LOJA+D2_DOC+D2_SERIE+D2_ITEM)
				CL2->CL2_PER	:= FIRSTDAY(stod(TRB_F100->D2_EMISSAO))
				CL2->CL2_REG	:= "F100"
				CL2->CL2_INDOP	:= "1"
				CL2->CL2_DTOPER := stod(TRB_F100->D2_EMISSAO)
				CL2->CL2_DESCR	:= SubStr(DTOC(STOD(TRB_F100->D2_EMISSAO)),4)+" "+SubStr(TRB_F100->D2_COD,1,3)+" Locacao " + ;
					"- Produto : " + TRB_F100->D2_COD +"-" + left(SA1->A1_NREDUZ,25)+" "+TRB_F100->(D2_SERIE+D2_DOC)
				CL2->CL2_ITEM 	:= Alltrim(TRB_F100->D2_COD)
				CL2->CL2_VLOPER := Round(TRB_F100->D2_TOTAL, 2)
				CL2->CL2_CLIFOR	:= TRB_F100->D2_CLIENTE
				CL2->CL2_LOJA	:= TRB_F100->D2_LOJA
				CL2->CL2_IDCF8	:=strzero(nSeq,6)
				CL2->CL2_CSTPIS	:="01"
				CL2->CL2_BCPIS 	:= Round(TRB_F100->D2_TOTAL, 2)
				CL2->CL2_ALQPIS := TRB_F100->D2_ALQIMP6
				CL2->CL2_VLPIS 	:= Round(TRB_F100->D2_VALIMP6,2)
				CL2->CL2_CSTCOF	:="01"
				CL2->CL2_BCCOF 	:= Round(TRB_F100->D2_TOTAL, 2)
				CL2->CL2_ALQCOF := TRB_F100->D2_ALQIMP5
				CL2->CL2_VLCOF 	:= Round(TRB_F100->D2_VALIMP5,2)
				CL2->CL2_CTA 	:= iif(!empty(SB1->B1_CONTA),SB1->B1_CONTA,cConta)
				CL2->CL2_CCUS 	:= Alltrim(TRB_F100->D2_CCUSTO)
				CL2->CL2_PARTI	:= TRB_F100->(D2_CLIENTE+D2_LOJA)
				CL2->CL2_PART	:="1"  // Cliente
				CL2->CL2_REGIME	:="1"
				CL2->CL2_CODBCC	:= SF4->F4_CODBCC
				CL2->CL2_INDCRD	:= "0"

				MsUnLock()
			Endif
		Endif
		Select Trb_F100
		nSeq ++
		dbSkip()
	enddo
	TRB_F100->(dbCloseArea())

	//Final gera็ใo notas tipo RL

	/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
	// Inicio da consulta para grava็ใo das notas fiscais de loca็ใo.

	nUltCod := 0
	cQuery := "SELECT MAX(CF8_CODIGO) AS ULTCOD "
	cQuery += " FROM "       + RetSqlName("CF8") + " "
	cQuery += "WHERE " + RetSqlName("CF8")+".D_E_L_E_T_ <>'*' "
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMP1", .F., .T.)
	nUltCod := ULTCOD
	use
	nSeq := val(nUltCod)+ 1

	_cFilial := PARAMIXB[1]

	cQuery := ""
	cQuery += "SELECT SD1.D1_FILIAL, SD1.D1_FORNECE, SD1.D1_LOJA, SD1.D1_DTDIGIT, SD1.D1_COD,"
	cQuery += " SD1.D1_DOC, SD1.D1_SERIE, SD1.D1_CONTA, SD1.D1_CC,SD1.D1_PEDIDO, SD1.D1_ITEMPC, "
	cQuery += " SD1.D1_ALQPIS , SD1.D1_ALQCOF , SD1.D1_ALIQISS, "
	cQuery += " SD1.D1_ITEM, "
	cQuery += " SD1.D1_VALCOF , SD1.D1_DOC, SD1.D1_VALCSL , SD1.D1_DTDIGIT, SD1.D1_VALICM  , SD1.D1_VALINS ,"
	cQuery += " SD1.D1_VALIPI   , SD1.D1_VALIRR  , SD1.D1_VALISS , SD1.D1_VALPIS , SD1.D1_TP, SD1.D1_TOTAL , SF1.F1_ESPECIE, SA2.A2_TIPO "
	cQuery += " FROM "       + RetSqlName("SD1") + " SD1 "
	cQuery += " INNER JOIN "  + RetSqlName("SA2") + " SA2 ON SA2.A2_COD = SD1.D1_FORNECE AND SA2.A2_LOJA = SD1.D1_LOJA"
	cQuery += " INNER JOIN "  + RetSqlName("SF1") + " SF1 ON SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE = SD1.D1_SERIE "
	cQuery += " WHERE SD1.D1_FILIAL= '"+_cFilial+"' AND "//cQuery += " (SD1.D1_TES = '181' OR SD1.D1_TES = '182' OR SD1.D1_TES = '133') AND "
	cQuery += " (SD1.D1_TES = '133') AND "
	cQuery += "  SD1.D1_DTDIGIT >= '" + left(Dtos(dDataDe),6)+'01' + "' AND SD1.D1_DTDIGIT <= '" + Dtos(lastday(dDataAte)) + "' AND "
	cQuery += "  SA2.A2_TIPO <> 'F' AND "
	cQuery += " SD1.D_E_L_E_T_ = ' '"

	If Select("TRB_F100") > 0
		TRB_F100->(dbCloseArea())
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TRB_F100", .F., .T.)
	dbgotop()
	cConta := Alltrim(TRB_F100->D1_CONTA)
	cData  := dtos(FIRSTDAY(stod(TRB_F100->D1_DTDIGIT)))
	do while !eof()
		IF TRB_F100->(D1_DOC+D1_FORNECE+D1_LOJA)='000000350W2588701'
			Aviso('Aten็ใo','Parada 1',{'Ok'})
		ENDIF

		Select SA2
		seek xFilial()+TRB_F100->(D1_FORNECE+D1_LOJA)
		IF SA2->A2_TIPO="F" .or. trb_f100->D1_DTDIGIT > Dtos(dDataAte)  // Pessoa Fํsica nใo entra no Bloco F100 - Informa็ใo da Francielly - Fiscal
			Select TRB_F100
			skip
			loop
		Endif
		Select CF8
		cQuery := "SELECT * "
		cQuery += "FROM " + RetSqlName("CF8") + " CF8 WHERE  "
		cQuery += "CF8_FILIAL = '"+TRB_F100->D1_FILIAL +"' AND "
		cQuery += "CF8_DOC = '"+TRB_F100->(D1_DOC) +"' AND "
		cQuery += "CF8_CLIFOR = '"+TRB_F100->(D1_FORNECE) +"' AND "
		cQuery += "CF8_LOJA = '"+TRB_F100->(D1_LOJA) +"' AND "
		cQuery += "CF8_SERIE = 'Nf' AND "
		cQuery += "CF8.D_E_L_E_T_ = ' ' "
		cQuery := ChangeQuery(cQuery)
		If Select("TMPCF8") > 0
			TMPCF8->(dbCloseArea())
		Endif
		dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQuery), "TMPCF8", .F., .T.)
		Select CF8
		if TRB_F100->D1_TOTAL > 0 .AND. TRB_F100->D1_ALQPIS = 1.65
			cDataZZ1 := TRB_F100->D1_DTDIGIT
			cIDZZ0   := TRB_F100->(D1_FORNECE+D1_LOJA+D1_DOC+D1_ITEM)
			//		cSeq 	 := strzero(nSeq,6)
			cFil	 := TRB_F100->D1_FILIAL
			Select SF1
			dbSetOrder(2)
			seek cFil+TRB_F100->(D1_FORNECE+D1_LOJA+D1_DOC)
			if !eof() .and. TRB_F100->D1_DTDIGIT=dtos(F1_DTDIGIT) .and. F1_ESPECIE="NFSC"
				select TRB_F100
				dbSkip()
				loop
			endif
			Select SB1
			seek xFilial()+TRB_F100->(D1_COD)
			cConta := iif(!empty(SB1->B1_CTACUST),SB1->B1_CTACUST,SB1->B1_CONTA)
			Select SA2
			dbSetOrder(1)
			Seek xFilial()+TRB_F100->(D1_FORNECE+D1_LOJA)
			Select SF1
			dbSetOrder(1)
			Seek xFilial()+TRB_F100->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
			Select SC7
			dbSetOrder(1)
			Seek xFilial()+TRB_F100->(D1_PEDIDO+D1_ITEMPC)
			if !empty(sc7->C7_CONTA)
				cConta := sc7->C7_CONTA
			endif

			Select CL2
			//CHAVE ฺNICA : CL2_FILIAL+DTOS(CL2_PER)+CL2_REG+CL2_ID
			dbSetOrder(1)
			cChave := left(TRB_F100->D1_DTDIGIT,6)+"01"+"F100"+TRB_F100->(D1_FORNECE+D1_LOJA+D1_DOC+D1_ITEM)
			seek "01"+cChave // cFil+cChave
			// Hist๓rico solicitado pelo departamento fisca
			// A esp้cie do documento
			// N๚mero o do documento
			// C๓digo e loja do fornecedor
			// Nome do fornecedor
			if eof()
				RecLock("CL2",.T.)
				CL2->CL2_FILIAL	:="01"//TRB_F100->D1_FILIAL //XfILIAL()
				CL2->CL2_FILAPU	:= TRB_F100->D1_FILIAL //XfILIAL()
				CL2->CL2_ID		:= TRB_F100->(D1_FORNECE+D1_LOJA+D1_DOC+D1_ITEM)
				CL2->CL2_PER	:= FIRSTDAY(stod(TRB_F100->D1_DTDIGIT))
				CL2->CL2_REG	:= "F100"
				CL2->CL2_INDOP	:= "0" // Alterado para gerar entradas no Sped EFD
				CL2->CL2_DTOPER := stod(TRB_F100->D1_DTDIGIT)
				CL2->CL2_DESCR	:= SubStr(DTOC(STOD(TRB_F100->D1_DTDIGIT)),4)+" "+SubStr(TRB_F100->D1_COD,1,3)+" " + SF1->F1_ESPECIE +" "+;
					TRB_F100->D1_DOC + "-" + TRB_F100->(D1_FORNECE+D1_LOJA) +"-" + left(SA2->A2_NREDUZ,25)//+" CL2"
				CL2->CL2_ITEM 	:= Alltrim(TRB_F100->D1_COD)
				CL2->CL2_VLOPER := Round(TRB_F100->D1_TOTAL, 2)
				CL2->CL2_CLIFOR	:= TRB_F100->(D1_FORNECE)
				CL2->CL2_LOJA	:= TRB_F100->(D1_LOJA)
				CL2->CL2_IDCF8	:=strzero(nSeq,6)
				CL2->CL2_CODBCC	:="03"
				CL2->CL2_INDCRD	:="0"
				CL2->CL2_CSTPIS	:= IIF(SA2->A2_TIPO <> "F","50","70")
				CL2->CL2_BCPIS 	:= Round(TRB_F100->D1_TOTAL, 2)
				CL2->CL2_ALQPIS := TRB_F100->D1_ALQPIS
				CL2->CL2_VLPIS 	:= Round(TRB_F100->(D1_TOTAL / 100 * D1_ALQPIS) ,2)
				CL2->CL2_CSTCOF	:= IIF(SA2->A2_TIPO <> "F","50","70")
				CL2->CL2_BCCOF 	:= Round(TRB_F100->D1_TOTAL, 2)
				CL2->CL2_ALQCOF := TRB_F100->D1_ALQCOF
				CL2->CL2_VLCOF 	:= Round(TRB_F100->(D1_TOTAL / 100 * D1_ALQCOF) ,2)
				//	CL2->CL2_INDORI	:="0"
				CL2->CL2_CTA 	:= cConta // Alltrim(TRB_F100->D1_CONTA)
				CL2->CL2_CCUS 	:= Alltrim(TRB_F100->D1_CC) // Retirei em 02/04/2018 - Luiz Eduardo
				CL2->CL2_PARTI	:= TRB_F100->(D1_FORNECE)
				CL2->CL2_PART	:="2"  // Fornecedor
				CL2->CL2_REGIME	:="1"
				CL2->CL2_NUMTIT :=""
				MsUnLock()
			Endif
		Endif
		Select Trb_F100
		nSeq ++
		dbSkip()
	Enddo

/*-------------------------------------------------------------------------------------------------------------------------------------------------*/
//Efetua a verifica็ใo do cr้dito, caso seja passํvel de cr้dito serแ alterado dos campos
//CL2->CL2_CODBCC	:="03" / CL2->CL2_INDCRD	:="0" / CL2->CL2_CTA	:= iif(!empty(SB1->B1_CTACUST),SB1->B1_CTACUST,SB1->B1_CONTA)

	Select CL2
	//CL2_FILIAL+DTOS(CL2_PER)+CL2_REG+CL2_ID
	dbSetOrder(1)
	Seek xFilial()+cData+"F100"
	aDescr := {}
	do while !eof() .and. CL2_PER >= dDataDe .and. CL2_PER <= dDataAte
		nLinha := Ascan(aDescr, {|x|x[1] == trim(CL2_DESCR)})
		If nLinha != 0 .or. (CL2_NUMTIT<>"  " .and. empty(CL2_DESCR))
			Reclock("CL2",.F.)
			delete
			MsUnLock()
		Endif
		Select SB1
		seek xFilial()+CL2->CL2_ITEM
		Select CL2
		RecLock("CL2",.f.)
		//	CL2->CL2_CTA 	:= SB1->B1_CONTA
		IF CL2->CL2_INDOP = "0"
			CL2->CL2_CODBCC	:="03"
			CL2->CL2_INDCRD	:="0"
			CL2->CL2_CTA	:= iif(!empty(SB1->B1_CTACUST),SB1->B1_CTACUST,SB1->B1_CONTA)
		endif
		MsUnlock()
		skip
	enddo
	RestArea(aSavAre)
Return(aRetF100)
