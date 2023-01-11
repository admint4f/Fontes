#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOTVS.CH'

#DEFINE CRLF Chr(13)+Chr(10)

USER FUNCTION AltHist()

	Local n
	Local aTexto  := {}
	Local nHandle := FCreate('C:\TOTVS T4F\testelucal.txt')
	Local aArea   := GetArea()
	Local ctxIncl := 'ALLTRIM(SF1->F1_ESPECIE)+" "+ALLTRIM(SF1->F1_DOC)+" "+ALLTRIM(SA2->A2_COD)+" "+TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+ALLTRIM(SD1->D1_PEDIDO)+" "+TRIM(SD1->D1_XDESC)'
//	Local cTxPis  := 'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-PIS"'
//	Local cTxCof  := 'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-COF"'
//	Local cTxiss  := 'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-ISS"'
//	Local cTxins  := 'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-INS"'

	Local cTeEst  := '"EST."+" "+ALLTRIM(SF1->F1_ESPECIE)+" "+ALLTRIM(SF1->F1_DOC)+" "+ALLTRIM(SA2->A2_COD)+" "+TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+ALLTRIM(SD1->D1_PEDIDO)+" "+TRIM(SD1->D1_XDESC)' 
//	Local cTePis  := '"EST.+" "+'+'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-PIS"' 
//	Local cTeCof  := '"EST.+" "+'+'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-COF"'
//	Local cTeiss  := '"EST.+" "+'+'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-ISS"'
//	Local cTeins  := '"EST.+" "+'+'ALLTRIM(SF1->F1_ESPECIE)+" "+'+'ALLTRIM(SF1->F1_DOC)+" "+'+'TRIM(SUBSTR(SA2->A2_NOME,1,13))+" "+'+'ALLTRIM(SD1->D1_PEDIDO)+" "+'+'TRIM(SD1->D1_XDESC)+" "+'+'"-INS"'

	DBSelectArea('CT5')
	CT5->(DBSetOrder(1))
	CT5->(DBGoTop())

	//MsgInfo('Iniciando alteração dos registros 650')
	CT5->(DBSeek(FWxfilial('CT5')+'650'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='650'
		Reclock('CT5',.F.)
		CT5_HIST := ctxIncl
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'651'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='651'
		Reclock('CT5',.F.)
		CT5_HIST := ctxIncl
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo	

	CT5->(DBSeek(FWxfilial('CT5')+'655'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='655'
		Reclock('CT5',.F.)
		CT5_HIST := cTeEst
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'656'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='656'
		Reclock('CT5',.F.)
		CT5_HIST := cTeEst
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'660'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='660'
		Reclock('CT5',.F.)
		CT5_HIST := ctxIncl
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'666'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='666'
		Reclock('CT5',.F.)
		CT5_HIST := cTeEst
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'500'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD>='500' .AND. CT5_LANPAD<='507'
		Reclock('CT5',.F.)
		CT5_HIST:= RTRIM(STRTRAN(CT5_HIST,'SE1->E1_NOMCLI','SA1->A1_NOME'))+('+" "+"E1_HIST"')
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo
		
	CT5->(DBSeek(FWxfilial('CT5')+'510'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='510' .AND. (CT5_SEQUEN$'001/002/003/004/005/006')
		Reclock('CT5',.F.)
		CT5_HIST := 'SE2->E2_TIPO+" "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" "+TRIM(SUBSTR(SE2->E2_NOMFOR  , 1 , 7))+" "+SE2->E2_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'510'+'007'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='510' .AND. (CT5_SEQUEN$'007/008/009')
		Reclock('CT5',.F.)
		CT5_HIST := '"DV "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" "+TRIM(SUBSTR(SA2->A2_NOME  , 1 , 7))+" "+SE2->E2_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'511'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD=='511'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE2->E2_TIPO+" "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" "+TRIM(SUBSTR(SA2->A2_NOME , 1 , 7))+" "+SE2->E2_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'512'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'512/513/514/515'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE2->E2_TIPO+" "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" "+TRIM(SUBSTR(SA2->A2_NOME  , 1 , 7))+" "+SE2->E2_HIST+"-EST."'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'520'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'520'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE1->E1_TIPO+" "+SE1->E1_NUM+" "+SUBSTR(SA1->A1_NOME,1,9) +" BX.CR: "+SE5->E5_MOTBX+" "+SE1->E1_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo
	
	CT5->(DBSeek(FWxfilial('CT5')+'521'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'521' .AND. (CT5_SEQUEN$'001/002')
		Reclock('CT5',.F.)
		CT5_HIST := 'SE1->E1_TIPO+" "+SE1->E1_NUM+" "+SUBSTR(SA1->A1_NOME,1,9) +" BX.CR: "+SE5->E5_MOTBX+" "+SE1->E1_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'521'+'003'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'521'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE1->E1_TIPO+" "+SE1->E1_NUM+" "+SUBSTR(SA1->A1_NOME,1,9) +" BX.CR: "+SE5->E5_MOTBX+" "+SE1->E1_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'527'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'527'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE1->E1_TIPO+" "+SE1->E1_NUM+" "+SUBSTR(SA1->A1_NOME,1,9) +" BX.CR: "+SE5->E5_MOTBX+"-EST"+" "+SE1->E1_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'530'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'530'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE2->E2_TIPO+" "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" BCP "+SE5->E5_MOTBX+IIF(EMPTY(SE2->E2_NUMBOR),"",SE2->E2_NUMBOR)+" "+SE2->E2_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'531'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'531'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE2->E2_TIPO+" "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" BCP "+SE5->E5_MOTBX+IIF(EMPTY(SE2->E2_NUMBOR),"",SE2->E2_NUMBOR)+"-EST"+" "+SE2->E2_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo

	CT5->(DBSeek(FWxfilial('CT5')+'532'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'532'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE2->E2_TIPO+" "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" BCP "+SE5->E5_MOTBX+IIF(EMPTY(SE2->E2_NUMBOR),"",SE2->E2_NUMBOR)+" "+SE2->E2_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo
	
	CT5->(DBSeek(FWxfilial('CT5')+'532'))
	While CT5->(!(EOF())) .AND. CT5_LANPAD$'532'
		Reclock('CT5',.F.)
		CT5_HIST := 'SE2->E2_TIPO+" "+SE2->E2_NUM+" "+SA2->A2_NOME+SE2->E2_LOJA+" BCP "+SE5->E5_MOTBX+IIF(EMPTY(SE2->E2_NUMBOR),"",SE2->E2_NUMBOR)+" "+SE2->E2_HIST'
		CT5->(MsUnlock())
		aAdd(aTexto,(CT5->CT5_LANPAD+"|"+CT5->CT5_SEQUEN))
		CT5->(Dbskip())
	EndDo
	
	//ALTERAÇÃO DAS LPS
/*------------------------------------------------------------------------------*/

	MsgInfo("Alterações das LPs de compra realizadas com sucesso")

	DBSelectArea('SX6')
	CT5->(DBSetOrder(1))
	CT5->(DBGoTop())

	MsgInfo("Alterando MV_CT5HIST para .F.")
	SX6->(DBSeek(FWxfilial('SX6')+'MV_CT5HIST'))
	Reclock('SX6',.F.)
	X6_CONTEUD := ".F."
	SX6->(MsUnlock())

	MsgInfo("Alterando MV_AGLHIST para .T.")
	SX6->(DBSeek(FWxfilial('SX6')+'MV_AGLHIST'))
	Reclock('SX6',.F.)
	X6_CONTEUD := ".T."
	SX6->(MsUnlock())

	MsgInfo("Alterações dos Parametros realizadas com sucesso")

	If nHandle = -1
		Conout("Erro ao criar arquivo" + Str(Ferror()))
	Else
		Fwrite(nHandle, "Abaixo LPs que foram alteradas"+ CRLF)
		For n := 1 to len(aTexto)
			FWrite(nHandle, (aTexto[n]) + CRLF)
		Next n
		FClose(nHandle)
	EndIf

	RestArea(aArea)

Return
