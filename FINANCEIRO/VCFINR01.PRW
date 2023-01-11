#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"
#include "prtopdef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VCFINR01  ºAutor  ³Microsiga           º Data ³  30/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VCFINR01()
//U_VCFINR01()

AjustaSX1() 

Processa({|| PrcFIR01() }, "Gerando arquivo...", "Relatório Pagamento - Código Gerencial.")         

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PrcFINR01 ºAutor  ³Microsiga           º Data ³  30/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Processa o relatório                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PrcFIR01()

Local _nTotReg	:= 0
Local cDirDocs 	:= MsDocPath()
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath	   	:= AllTrim(GetTempPath())
Local cCrLf		:= Chr(13) + Chr(10)
Local nStart 	:= SECONDS()
Local nElapsed


nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
If nHandle == 0
	MsgAlert( "Erro na criacão do arquivo!!!" )
	Return
Endif

_cQuery	:= " "
_cQuery	:= "SELECT C1_EMISSAO DATA_SC, C1_NUM NUMERO_SC, C1_ITEM ITEM, C1_PRODUTO PRODUTO, B1_DESC DESCRICAO, B1_UM UNIDADE_MEDIDA, C1_QUANT QUANT, C1_QUJE QUANT_ENTREG, C1_VUNIT VALOR_UNIT, (C1_QUANT * C1_VUNIT) VALOR_TOTAL, C1_OBS OBS, C1_CONTA CONTA, C1_ITEMCTA EPEP, C1_CC CC, C1_PEDIDO PEDIDO, C1_FORNECE FORNECEDOR, A2_NOME NOME_FORNECEDOR, ' ' RESIDUO, ' ' NRO_TITULO, ' ' DATA_CONTAB"
_cQuery	+= " FROM " + RetSqlName("SC1") + " SC1 LEFT JOIN " + RetSqlName("SB1") + "  SB1 ON C1_PRODUTO=B1_COD AND C1_LOCAL=B1_LOCPAD"
_cQuery	+= " LEFT JOIN " + RetSqlName("SA2") + " SA2 ON (C1_FORNECE = A2_COD AND C1_LOJA = A2_LOJA)"
_cQuery	+= " WHERE SC1.D_E_L_E_T_ = ' '"
_cQuery	+= " AND SB1.D_E_L_E_T_   = ' '"
_cQuery	+= " AND SA2.D_E_L_E_T_   = ' '"
_cQuery	+= " AND C1_PEDIDO = ' '"
_cQuery	+= " AND C1_EMISSAO >= '" + DtoS(MV_PAR01) + "'"  
_cQuery	+= " AND C1_EMISSAO <= '" + DtoS(MV_PAR02) + "'"
_cQuery	+= " UNION"
_cQuery	+= " SELECT C1_EMISSAO DATA_SC, C1_NUM NUMERO_SC, C1_ITEM ITEM, C1_PRODUTO PRODUTO, B1_DESC DESCRICAO, B1_UM UNIDADE_MEDIDA, C1_QUANT QUANT, C1_QUJE QUANT_ENTREG, C1_VUNIT VALOR_UNIT, (C1_QUANT * C1_VUNIT) VALOR_TOTAL, C1_OBS OBS, C1_CONTA CONTA, C1_ITEMCTA EPEP, C1_CC CC, C1_PEDIDO PEDIDO, C1_FORNECE FORNECEDOR, A2_NOME NOME_FORNECEDOR, C7_RESIDUO RESIDUO, ' 'NRO_TITULO, ' ' DATA_CONTAB"
_cQuery	+= " FROM " + RetSqlName("SC1") + " SC1 LEFT JOIN " + RetSqlName("SB1") + " SB1 ON C1_PRODUTO=B1_COD AND C1_LOCAL=B1_LOCPAD"
_cQuery	+= " LEFT JOIN " + RetSqlName("SA2") + " SA2 ON (C1_FORNECE = A2_COD AND C1_LOJA = A2_LOJA)"
_cQuery	+= " LEFT JOIN " + RetSqlName("SC7") + " SC7 ON C1_PEDIDO = C7_NUM AND C1_ITEM = C7_ITEMSC"
_cQuery	+= " WHERE SC1.D_E_L_E_T_ = ' '"
_cQuery	+= " AND SB1.D_E_L_E_T_   = ' '"
_cQuery	+= " AND SA2.D_E_L_E_T_   = ' '"
_cQuery	+= " AND C1_PEDIDO <> ' '"
_cQuery	+= " AND C7_NUM || C7_ITEM NOT IN (SELECT D1_PEDIDO || D1_ITEMPC  FROM " + RetSqlName("SD1") + " SD1 WHERE SD1.D_E_L_E_T_ = ' '"
_cQuery	+= " AND D1_PEDIDO <> ' ')"
_cQuery	+= " AND C1_EMISSAO >= '" + DtoS(MV_PAR01) + "'"
_cQuery	+= " AND C1_EMISSAO <= '" + DtoS(MV_PAR02) + "'"
_cQuery	+= " UNION"
_cQuery	+= " SELECT C1_EMISSAO DATA_SC, C1_NUM NUMERO_SC, C1_ITEM ITEM, C1_PRODUTO PRODUTO, B1_DESC DESCRICAO, B1_UM UNIDADE_MEDIDA, C1_QUANT QUANT, C1_QUJE QUANT_ENTREG, C1_VUNIT VALOR_UNIT, (C1_QUANT * C1_VUNIT) VALOR_TOTAL, C1_OBS OBS, C1_CONTA CONTA, C1_ITEMCTA EPEP, C1_CC CC, C1_PEDIDO PEDIDO, C1_FORNECE FORNECEDOR, A2_NOME NOME_FORNECEDOR, C7_RESIDUO RESIDUO, F1_DOC NRO_TITULO, F1_DTLANC DATA_CONTAB"
_cQuery	+= " FROM " + RetSqlName("SC1") + " SC1 INNER JOIN " + RetSqlName("SB1") + " SB1 ON (C1_PRODUTO=B1_COD AND C1_LOCAL = B1_LOCPAD )"
_cQuery	+= " LEFT JOIN " + RetSqlName("SA2") + " SA2 ON (C1_FORNECE = A2_COD AND C1_LOJA = A2_LOJA)"
_cQuery	+= " LEFT JOIN " + RetSqlName("SC7") + " SC7 ON (C1_PEDIDO = C7_NUM AND C1_ITEM = C7_ITEMSC)"
_cQuery	+= " LEFT JOIN " + RetSqlName("SD1") + " SD1 ON (C7_NUM = D1_PEDIDO AND C7_ITEM = D1_ITEMPC)"
_cQuery	+= " LEFT JOIN " + RetSqlName("SF1") + " SF1 ON (D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA)"
_cQuery	+= " WHERE SC1.D_E_L_E_T_ = ' '"
_cQuery	+= " AND SB1.D_E_L_E_T_  = ' '"
_cQuery	+= " AND SA2.D_E_L_E_T_   = ' '"
_cQuery	+= " AND SD1.D_E_L_E_T_  = ' '"
_cQuery	+= " AND SF1.D_E_L_E_T_  = ' '"
_cQuery	+= " AND C1_EMISSAO >= '" + DtoS(MV_PAR01) + "'"
_cQuery	+= " AND C1_EMISSAO <= '" + DtoS(MV_PAR02) + "'"
// Alias para abrir no SQL.
_cTabAlias := GetNextAlias()

// Verifica se o Alias esta aberto.
If Select(_cTabAlias) > 0
	(_cTabAlias)->(dbCloseArea())
EndIf

// Abre a tabela.
dbUseArea(.T.,'TOPCONN',TcGenQry(,,_cQuery),_cTabAlias,.F.,.T.)
_aStruTRB := ( _cTabAlias )->(dbStruct())

ProcRegua(FCount())

fWrite(nHandle, "Relatorio Pagamento" + ";") // Título
fWrite(nHandle, cCrLf ) // Pula linha
For nX := 1 To Len(_aStruTRB)
	fWrite(nHandle, _aStruTRB[nX][1] + IIf( nX < Len(_aStruTRB), ";", "" )) // Gerar Cabe;alho
Next nX
fWrite(nHandle, cCrLf ) // Pula linha

DbSelectArea(_cTabAlias )
(_cTabAlias)->(DbGotop())
While (_cTabAlias )->(!Eof ())

	IncProc("Gerando Relatório Pagamentos - Vicar ")
	
	fWrite(nHandle, DtoC(StoD((_cTabAlias)->DATA_SC))	+ ";" )
	fWrite(nHandle, (_cTabAlias)->NUMERO_SC				+ ";" )
	fWrite(nHandle, (_cTabAlias)->ITEM					+ ";" )
	fWrite(nHandle, (_cTabAlias)->PRODUTO				+ ";" )
	fWrite(nHandle, (_cTabAlias)->DESCRICAO				+ ";" )
	fWrite(nHandle, (_cTabAlias)->UNIDADE_MEDIDA		+ ";" )
	fWrite(nHandle, Transform((_cTabAlias)->QUANT		, "@E 999,999,999,999.99")	+ ";" )
	fWrite(nHandle, Transform((_cTabAlias)->QUANT_ENTREG, "@E 999,999,999,999.99")	+ ";" )
	fWrite(nHandle, Transform((_cTabAlias)->VALOR_UNIT	, "@E 999,999,999,999.99")	+ ";" )
	fWrite(nHandle, Transform((_cTabAlias)->VALOR_TOTAL	, "@E 999,999,999,999.99")	+ ";" )
	fWrite(nHandle, (_cTabAlias)->OBS			+ ";" )
	fWrite(nHandle, (_cTabAlias)->CONTA			+ ";" )
	fWrite(nHandle, (_cTabAlias)->EPEP			+ ";" )
	fWrite(nHandle, (_cTabAlias)->CC			+ ";" )
	fWrite(nHandle, (_cTabAlias)->PEDIDO		+ ";" )
	fWrite(nHandle, (_cTabAlias)->FORNECEDOR	+ ";" )
	fWrite(nHandle, (_cTabAlias)->NOME_FORNECEDOR	+ ";" )
	fWrite(nHandle, (_cTabAlias)->RESIDUO			+ ";" )
	fWrite(nHandle, (_cTabAlias)->NRO_TITULO		+ ";" )
	fWrite(nHandle, DtoC(StoD((_cTabAlias)->DATA_CONTAB))	+ ";" )
	fWrite(nHandle, cCrLf ) // Pula linha
	
	DbSelectArea("SZ2")
	
	SZ2->(DbSetOrder(4))
	SZ2->(DbGotop())
	
	If SZ2->(DbSeek(xFilial("SZ2") + Padl((_cTabAlias)->NUMERO_SC, TamSx3("Z2__SC1")[1])))
		While SZ2->(!Eof()) .And. SZ2->Z2__SC1 == (_cTabAlias)->NUMERO_SC   
			If SZ2->Z2_ITEMSC == (_cTabAlias)->ITEM
				fWrite(nHandle, DtoC(StoD((_cTabAlias)->DATA_SC))		+ ";" )
				fWrite(nHandle, (_cTabAlias)->NUMERO_SC					+ ";" )
				fWrite(nHandle, (_cTabAlias)->ITEM						+ ";" )	
				fWrite(nHandle, "RATEIO SC " + (_cTabAlias)->NUMERO_SC 	+ ";" )
				fWrite(nHandle, "ITEM " + SZ2->Z2_ITEM					+ ";" )
				fWrite(nHandle, "PERCENTUAL " + Transform(SZ2->Z2_PERC	, "@E 999,999,999,999.99")	+ "%" + ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, Transform(SZ2->Z2_VALOR * (-1)	, "@E 999,999,999,999.99")	+ ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, SZ2->Z2_CONTA	+ ";" )
				fWrite(nHandle, SZ2->Z2_ITEMCTA	+ ";" )
				fWrite(nHandle, SZ2->Z2_CC		+ ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, ";" )
				fWrite(nHandle, cCrLf ) // Pula linha
			//MsgAlert("Escreveu "     + SZ2->Z2__SC1)
			EndIf
			SZ2->(DbSkip())
		EndDo
	EndIf
	(_cTabAlias)->(DbSkip())
EndDo

(_cTabAlias)->( dbCloseArea())

nElapsed = SECONDS() - nStart
fWrite(nHandle, "Decorridos: " + LTRIM(STR(nElapsed)) + " segundos" )
fWrite(nHandle, cCrLf ) // Pula linha

fClose(nHandle)

CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

If ! ApOleClient( 'MsExcel' )
	MsgAlert( 'MsExcel nao instalado' )
	Return
EndIf

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funçào    ³AjustaSX1 ³ Autor ³ Ricardo Tomasi        ³ Data ³ 09/12/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descriçào ³ Ajusta dicionario de perguntas.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ AGRR257                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1()
Local sAlias    := Alias()
Local cPergunta := "VCFR01"
Local aRegs     :={}
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local i
Local j

dbSelectArea('SX1')
SX1->(dbSetOrder(1))

Aadd( aRegs,{ cPergunta, '01',OemToAnsi(PadR('Data De',10)+'?')    		,'','','mv_ch1','D',08,0,0,'G','' ,'mv_par01','','','','','','','','','','','','','','','','','','','','','','','','','',''})
Aadd( aRegs,{ cPergunta, '02',OemToAnsi(PadR('Data Ate',10)+'?')   		,'','','mv_ch2','D',08,0,0,'G','' ,'mv_par02','','','','','','','','','','','','','','','','','','','','','','','','','',''})

If SX1->(dbSeek(cPergunta)) .And. FCount() # Len(aRegs)
	While alltrim(SX1->X1_GRUPO) == cPergunta
		RecLock('SX1',.F.)
		SX1->(dbDelete())
		SX1->(msUnlock())
		SX1->(dbSkip())
	EndDo
EndIf

For i:=1 to Len(aRegs)
	
	If !dbSeek(PADR(cPergunta,nTamSX1)+aRegs[i,2])
		RecLock('SX1',.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(sAlias)

Pergunte(cPergunta, .T.)

Return()
