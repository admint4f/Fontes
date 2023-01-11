#INCLUDE "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Verifica  º Autor ³ Marcos Justo       º Data ³  18/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function VERIFICA()
Local aAmb  := GetArea()
NUM := M->C7_CHAVE1

VALOR := acols[n][7]
PRODUTO := alltrim(acols[n][2])
GRUPO := Posicione("SB1",1,xFilial("SB1")+PRODUTO,"B1_GRUPO")


IF alltrim(SUBSTR(CUSUARIO,7,15)) == "Administrador" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Giane" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Flavio" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Tuca" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Robert" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Gabriela" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Carol" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Patricia" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Renata" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Ricardo" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Andrea"
	// MSGalert(SUBSTR(CUSUARIO,7,15))
	
	
	IF ALLTRIM(GRUPO) == "ART"
		dBSelectarea("SZL")
		dBsetorder(2)
		DbSeek(XFILIAL("SZL")+NUM)
		_artista := ZL_ARTISTA
		_casa    := ZL_DESCRI
		
		acols[n][39] := _ARTISTA
		acols[n][40] := _CASA
		
		IF FOUND()
			// SOM
			IF PRODUTO == "DA001"
				VALANT := SZL->ZL_CSOM
				VALLIB := SZL->ZL_ESOM
				VALSOM := (SZL->ZL_SOM*SZL->ZL_NUMAPRE)
				V10SOM := ((SZL->ZL_SOM*SZL->ZL_NUMAPRE)*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALSOM+V10SOM+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				acols[n][43] = "Previsto +10% = " + str((valsom+v10som),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			// LUZ
			IF PRODUTO == "DA002"
				VALANT := SZL->ZL_CLUZ
				VALLIB := SZL->ZL_ELUZ
				VALLUZ := (SZL->ZL_LUZ*SZL->ZL_NUMAPRE)
				V10LUZ := ((SZL->ZL_LUZ*SZL->ZL_NUMAPRE)*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALLUZ+V10LUZ+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				acols[n][43] = "Previsto +10% = " + str((valluz+v10luz),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			// HOSPEDAGEM
			IF PRODUTO == "DA003"
				VALANT := SZL->ZL_CHOSP
				VALLIB := SZL->ZL_EHOSP
				_TOTSUITE  := (SZL->ZL_QSUITE*SZL->ZL_NDSUITE*SZL->ZL_VALSUIT)
				_TOTSINGL  := (SZL->ZL_QUANSIN*SZL->ZL_NUMDSIN*SZL->ZL_VALSING)
				_TOTDOUBL  := (SZL->ZL_QUANDOU*SZL->ZL_NUMDDOU*SZL->ZL_VALDOUB)
				_TOTTRIPL  := (SZL->ZL_QUANTRI*SZL->ZL_NUMTRIP*SZL->ZL_VALTRIP)
				_HOSP := _TOTSUITE+_TOTSINGL+_TOTDOUBL+_TOTTRIPL
				
				VALHOSP := _HOSP
				V10HOSP := (VALHOSP*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALHOSP+V10HOSP+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				
				acols[n][43] = "Previsto +10% = " + str((valHOSP+v10HOSP),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			// CAMARIM
			IF PRODUTO == "DA004"
				VALANT := SZL->ZL_CCAMARI
				VALLIB := SZL->ZL_ECAMARI
				VALCAMA := SZL->ZL_CAMARIM*SZL->ZL_NUMAPRE
				V10CAM := ((SZL->ZL_CAMARIM*SZL->ZL_NUMAPRE)*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALCAMA+V10CAM+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				acols[n][43] = "Previsto +10% = " + str((valCAMA+v10CAM),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			
			// TRANSP. AEREO
			IF PRODUTO == "DA005"
				VALANT := SZL->ZL_CTAEREO
				VALLIB := SZL->ZL_ETAEREO
				_QAEREO1   := SZL->ZL_QAEREO1
				_VAEREO1   := SZL->ZL_VAEREO1
				_QAEREO2   := SZL->ZL_QAEREO2
				_VAEREO2   := SZL->ZL_VAEREO2
				_QAEREO3   := SZL->ZL_QAEREO3
				_VAEREO3   := SZL->ZL_VAEREO3
				_QAEREO4   := SZL->ZL_QAEREO4
				_VAEREO4   := SZL->ZL_VAEREO4
				_TOTAERE   := (_QAEREO1*_VAEREO1)+(_QAEREO2*_VAEREO2)+(_QAEREO3*_VAEREO3)+(_QAEREO4*_VAEREO4)
				
				VALAEREO := _TOTAERE
				V10AERE  := (VALAEREO*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALAEREO+V10AERE+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				
				acols[n][43] = "Previsto +10% = " + str((valAEREO+v10AERE),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			
			// TRANSP. TERRESTRE
			IF PRODUTO == "DA006"
				VALANT := SZL->ZL_CTTERRE
				VALLIB := SZL->ZL_ETTERRE
				_QCARRO    := SZL->ZL_QCARRO
				_NUMCARR   := SZL->ZL_NUMCARR
				_VALCARR   := SZL->ZL_VALCARR
				_TOTCARRO  := (SZL->ZL_QCARRO*SZL->ZL_NUMCARR*SZL->ZL_VALCARR)
				_QVAN      := SZL->ZL_QVAN
				_NUMVAN    := SZL->ZL_NUMVAN
				_VALVAN    := SZL->ZL_VALVAN
				_TOTVAN    := (SZL->ZL_QVAN*SZL->ZL_NUMVAN*SZL->ZL_VALVAN)
				_QOUTROS   := SZL->ZL_QOUTROS
				_NUMOUT    := SZL->ZL_NUMOUT
				_VALOUTR   := SZL->ZL_VALOUTR
				_TOTOUT    := (SZL->ZL_QOUTROS*SZL->ZL_NUMOUT*SZL->ZL_VALOUTR)
				_TOTTERR   := _TOTCARRO+_TOTVAN+_TOTOUT
				
				VALTERRE := _TOTTERR
				V10TERR := (VALTERRE*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALTERRE+V10TERR+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				
				acols[n][43] = "Previsto +10% = " + str((valTERRE+v10TERR),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			// ALIMENTACAO
			IF PRODUTO == "DA007"
				VALANT := SZL->ZL_CALIMEN
				VALLIB := SZL->ZL_EALIMEN
				_NPESSDI   := SZL->ZL_NPESSDI
				_NDIALI    := SZL->ZL_NDIAALI
				_VALDALI   := SZL->ZL_VALDALI
				_TOTALIM   := (_NPESSDI*_NDIALI*_VALDALI)
				
				VALALIMEN := _TOTALIM
				V10ALIM   := (VALALIMEN*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALALIMEN+V10ALIM+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				acols[n][43] = "Previsto +10% = " + str((valALIMEN+v10ALIM),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			
			// TRANSP. EQUIPAMENTO
			IF PRODUTO == "DA008"
				VALANT := SZL->ZL_CTEQUIP
				VALLIB := SZL->ZL_ETEQUIP
				VALTEQUIP := SZL->ZL_TREQUIP
				V10EQUI := (SZL->ZL_TREQUIP*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALTEQUIP+V10EQUI+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				acols[n][43] = "Previsto +10% = " + str((valTEQUIP+v10EQUI),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			// BACKLINE
			IF PRODUTO == "DA009"
				VALANT := SZL->ZL_CBACLIN
				VALLIB := SZL->ZL_EBACLIN
				VALBACLIN := SZL->ZL_BACKLINE
				V10BACK := (SZL->ZL_BACKLINE*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALBACLIN+V10BACK+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				acols[n][43] = "Previsto +10% = " + str((valBACLIN+v10BACK),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			// OUTRAS DESPESAS
			IF PRODUTO == "DA010"
				_SINDICA   := SZL->ZL_SINDICA
				_VRCONTR   := SZL->ZL_VRCONTR
				_TOTSINDICA := (SZL->ZL_SINDICA*(SZL->ZL_VRCONTR/100))
				
				_VISTOENT  := SZL->ZL_VISTOEN
				_NUMPENT   := SZL->ZL_NUMPENT
				_TOTVISTO  := (SZL->ZL_VISTOEN*SZL->ZL_NUMPENT)
				
				_EQUIPPR   := SZL->ZL_EQUIPPR
				_NUMPPRO   := SZL->ZL_NUMPPRO
				_TOTPROD   := (SZL->ZL_EQUIPPR*SZL->ZL_NUMPPRO)
				
				
				VALANT := SZL->ZL_CODESP
				VALLIB := SZL->ZL_EODESP
				VALODESP := _TOTSINDICA+_TOTVISTO+_TOTPROD
				V10DESP := (VALODESP*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALODESP+V10DESP+VALLIB)
					MSGalert("Valor maior que orçado")
					acols[n][7] = 0
				ENDIF
				acols[n][43] = "Previsto +10% = " + str((valODESP+v10DESP),14,2)
				acols[n][44] = "Liberado  = " + str(vallib,14,2)
				acols[n][45] = "Realizado = " + str(valtot,14,2)
				
			ENDIF
			
			// DESP. POR CONTA DO ARTISTA
			IF PRODUTO == "DA011"
				//    VALANT := SZL->ZL_CPCARTI
				//    VALPCARTI := SZL->ZL_PCARTI
				//    VALTOT := VALANT + VALOR
				//    	IF VALTOT > VALPCARTI
				//		MSGalert("Valor maior que orçado")
				//		acols[n][7] = 0
				//		ENDIF
				acols[n][43] = "==>VERIFIQUE O DESCONTO<=="
				
			ENDIF
			
			// ECAD
			IF PRODUTO == "DA013"
				TXECAD := SZL->ZL_TXECAD
				VENDASR := SZL->ZL_VENDASR
				acols[n][43] = "Previsto = " + str(vendasr*(txecad/100),14,2)
			ENDIF
			
			
			// ALUGUEL DE IMOVEIS
			IF PRODUTO == "DA017"
				acols[n][43] = "Previsto = " + STR(SZL->ZL_VALIMO,14,2)
			ENDIF
			
			// MIDIA
			IF PRODUTO == "DA016"
				VALANT := SZL->ZL_CMIDIA
				VALLIB := SZL->ZL_EMIDIA
				VALMIDIA := SZL->ZL_MIDIA
				V10MIDIA := (SZL->ZL_MIDIA*.1)
				VALTOT := VALANT + VALOR
				IF VALTOT > (VALMIDIA+V10MIDIA+VALLIB)
					MSGalert("Valor maior que orçado")
					//		acols[n][7] = 0
				ENDIF
			ENDIF
			
			// PART. ARTISTA
			IF PRODUTO == "DA012"
				_TOTA := 0
				_TOTREAL := ZL_VENDASR
				_PORCART := ZL_PORCART
				_PARTCOD := ZL_PARTCOD
				
				_TXECAD := ZL_TXECAD
				_TXISS  := ZL_TXISS
				_TXPIS  := ZL_TXPIS
				_TXCC   := ZL_TXCC
				_PORCCC := ZL_PORCCC
				_SOM    := ZL_CSOM
				_LUZ    := ZL_CLUZ
				_NUMAPRE:= ZL_NUMAPRE
				_TXOCUPA:= ZL_TXOCUPA
				_CPCARTI := ZL_CPCARTI
				_VENDASCC := ZL_VENDACC
				
				_BILREAL := (_TOTREAL*_NUMAPRE)
				
				IF ZL_CECAD == 0
					_TOTECAD := (_BILREAL*(_TXECAD/100))
				ELSE
					_TOTECAD := ZL_CECAD
				ENDIF
				
				IF ZL_CISS == 0
					_TOTISS  := (_BILREAL*(_TXISS/100))
				ELSE
					_TOTISS  := ZL_CISS
				ENDIF
				
				_TOTPIS  := (_BILREAL*(1-(_PORCART/100))*(_TXPIS/100))
				// _TOTCC   := ((_BILREAL*(_PORCCC/100))*(_TXCC/100))
				_TOTCAR =(_VENDASCC*SZL->ZL_txcc)/100
				
				IF _PARTCOD == "01"
					_TOTA := ((_BILREAL*(_PORCART/100)))-_CPCARTI
				ENDIF
				
				IF _PARTCOD == "02"
					_TOTA := ((_BILREAL-_TOTECAD-_TOTISS)*(_PORCART/100))-_CPCARTI
				ENDIF
				
				IF _PARTCOD == "03"
					_TOTA := ((_BILREAL-_TOTCAR)*(_PORCART/100))-_CPCARTI
				ENDIF
				
				IF _PARTCOD == "04"
					_TOTA := ((_BILREAL-_TOTCAR-_TOTECAD-_TOTISS)*(_PORCART/100))-_CPCARTI
				ENDIF
				
				IF _PARTCOD == "05"
					_TOTA := ((_BILREAL-_TOTECAD-_TOTISS-(_SOM*_NUMAPRE)-(_LUZ*_NUMAPRE))*(_PORCART/100))-_CPCARTI
				ENDIF
				
				IF _PARTCOD == "06"
					_TOTA := ((_BILREAL-_TOTECAD-_TOTISS-_TOTCAR-(_SOM*_NUMAPRE)-(_LUZ*_NUMAPRE))*(_PORCART/100))-_CPCARTI
				ENDIF
				
				IF _PARTCOD == "07"
					_TOTA := ZL_PARTART - _CPCARTI
				ENDIF
				acols[n][43] = "Previsto = " + STR(_TOTA,14,2)
			ENDIF
			
			
			IF SZL->ZL_MESANT = "S"
				MSGalert("Analise Ref. mes anterior - Fechada")
				acols[n][7] = 0
			ENDIF
			
			IF SZL->ZL_FLAAPRO <> "S"
				MSGalert("Analise não esta aprovada.")
				acols[n][7] = 0
			ENDIF
			
		ENDIF
		
	ELSE
		
		dBSelectarea("SZL")
		dBsetorder(2)
		DbSeek(XFILIAL("SZL")+NUM)
		_artista := ZL_ARTISTA
		_casa    := ZL_DESCRI
		_apro    := ZL_FLAAPRO
		
		
		
		acols[n][39] := _ARTISTA
		acols[n][40] := _CASA
		
		IF _apro == "S"
			//	IF SZL->ZL_FLAAPRO <> "S"
			//		MSGalert("Analise não esta aprovada.")
			//		acols[n][7] = 0
			//	ENDIF
			
			
			// IF NUM <> "999"
			IF ALLTRIM(GRUPO) == "COA"
				dBSelectarea("SZS")
				dBsetorder(3)
				DbSeek(XFILIAL("SZS")+NUM+PRODUTO)
				IF FOUND()
					
					VALANT := SZS->ZS_REALIZA
					VALLIB := SZS->ZS_LIBERA
					VALPREV := SZS->ZS_PREVIST
					V10PREV := (SZS->ZS_PREVIST*.1)
					VALTOT := VALANT + VALOR
					IF VALTOT > (VALprev+V10prev+VALLIB)
						MSGalert("Valor maior que orçado")
						acols[n][7] = 0
					ENDIF
					acols[n][43] = "Previsto +10% = " + str((valPREV+v10PREV),14,2)
					acols[n][44] = "Liberado  = " + str(vallib,14,2)
					acols[n][45] = "Realizado = " + str(valtot,14,2)
				ELSE
					
					MSGALERT("Produto ou Analise não encontrados!")
					acols[n][7] = 0
					
				ENDIF
				
			ENDIF
		ELSE
			
			MSGALERT("Analise não esta aprovada!")
			acols[n][7] = 0
			
		ENDIF
		
	ENDIF
ELSE
	
	MSGalert("Ok")
	
	IF alltrim(SUBSTR(CUSUARIO,7,15)) == "Super" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Giane" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Tuca" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Robert" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Flavio"
		NUM := M->C7_CHAVE1
	ENDIF
	
	// IF INCLUI
	// NUM := 999999
	// ENDIF
	
	// IF ALTERA
	// NUM := 888888
	// ENDIF
ENDIF


RestArea(aAmb)


Return(NUM)
