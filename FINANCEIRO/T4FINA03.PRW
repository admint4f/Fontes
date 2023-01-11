#include "rwmake.ch"
#include "topconn.ch"
#include "prtopdef.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FINA03  ºAutor  ³Microsiga           º Data ³    /  /13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para gravação dos arquivos de pagamentos antecipados º±±
±±º          ³ via planilha .CSV                             			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function T4FINA03()

	cFile := cGetFile('Arquivo CSV|*.Csv','Selecione arquivo',0,'',.T.,,.F.)
	
	If !Empty(cFile)
		If !File(cFile)
			MsgAlert("Arquivo não localizado","Geração de Pagto Antecipado")
			Return
		Endif
	
		Processa({|| fPrcZZE() },"Geração de título de Folha Build-Up...")
	EndIf
	
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fPrcZZE  ºAutor  ³Microsiga           º Data ³    /  /13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para processar o arquivo de Integração Build-up.     º±±
±±º          ³                                               			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fPrcZZE()

	Local aAreaAnt := GetArea()
	Local aArray	:= {}
	Local aCabec	:= {}
	Local _aCC		:= {}
	Local aStrut	:= ZZE->(DbStruct())
	Local _lReturn	:= .f.
	Local cBuffer   := ""
	Local _cNumero	:= ""
	Local cCount	:= 0
	Local _nLinha	:= 0
	Local _nOk		:= 0
	Local _nFornec	:= 0
	Local _nValor	:= 0
	Local _nData	:= 0
	Local _nNature	:= 0
	Local _nFilial	:= 0
	Local _nIDBDUP	:= 0
	Local _nCC		:= 0
	Local _nItem	:= 0
	Local _nPos		:= 0
	Local _nValTot	:= 0
	Local _lOk		:= .F.
	
	Private _aUser	:= {}
	
	FT_FUSE(cFile)
	
	ProcRegua(FT_FLASTREC())
	
	FT_FGOTOP()
	
	cBuffer	:= FT_FREADLN()
	If Len(cBuffer) > 1022
		FT_FSKIP()
		cBuffer	+= FT_FREADLN()
	Endif
	
	aCabec		:= Separa(cBuffer, ";")
	_nFornec	:= aScan(aCabec,{|x| x == "ZZE_FORNEC" })
	_nValor		:= aScan(aCabec,{|x| x == "ZZE_VALOR" })
	_nData		:= aScan(aCabec,{|x| x == "ZZE_DATA" })
	_nNature	:= aScan(aCabec,{|x| x == "ZZE_NATURE" })
	_nFilial	:= aScan(aCabec,{|x| x == "ZZE_FILIAL" })
	_nCC		:= aScan(aCabec,{|x| x == "ZZE_CCUSTO" })
	_nCCApr		:= aScan(aCabec,{|x| x == "ZZE_CCAPRO" })
	_nUser		:= aScan(aCabec,{|x| x == "ZZE_USER" })
	
	FT_FSKIP()
	
	If _nFornec > 0 .And. _nValor > 0 .And. _nData > 0 .And. _nNature > 0 .And. _nFilial > 0 .And. _nCC > 0 .And. _nCCApr > 0  .And. _nUse > 0

		dbSelectArea("ZZE")
		ZZE->(dbSetOrder(1))
		
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		
		_cNumero	:= ZZE->(GetSXENum("ZZE","ZZE_NUMERO"))
		ZZE->(ConfirmSX8())
				
		_lOk	:= .T.
		
		While !FT_FEOF()
			IncProc("Processando arquivo de pagto antecipados... " )
	
			cBuffer 	:= FT_FREADLN()
			If Len(cBuffer) > 1022
				FT_FSKIP()
				cBuffer	+= FT_FREADLN()
			Endif
	
			aArray			:= Separa(cBuffer, ";")
			_cFornecedor	:= _aArray[_nFornec]
						
			_nLinha++
			If fVldUsr()
				SA2->(dbGoTop())
				If SA2->(dbSeek(xFilial("SA2") + _aArray[_nFornec]))
					If _aArray[_nFornec] == _cFornecedor
						_nItem++
					Else
						fIncAlc(ZZE->ZZE_CCUSTO , ZZE->ZZE_NUMERO,_nValTot)
						_cNumero	:= ZZE->(GetSXENum("ZZE","ZZE_NUMERO"))
						ZZE->(ConfirmSX8())
						_nItem := 1
					EndIf
	
					If RecLock("ZZE", .T.)
						For i := 1 to Len(aCabec)
							nPos := aScan(aStrut,{|x| x[1] == aCabec[i]})
							If aStrut[nPos][2] == "N"
								ZZE->&(aStrut[nPos][1]) := Val(aArray[i])
							ElseIf aStrut[nPos][2] == "D"
								ZZE->&(aStrut[nPos][1]) := StoD(aArray[i])
							Else
								ZZE->&(aStrut[nPos][1]) := aArray[i]
							EndIf
						Next
						ZZE->ZZE_FILIAL	:= xFilial("ZZE")
						ZZE->ZZE_NUMERO	:= _cNumero
						ZZE->ZZE_NOME	:= SA2->A2_NOME
						ZZE->ZZE_LOJA	:= SA2->A2_LOJA
						_nValTot		+= ZZE->ZZE_VALOR
						ZZE->ZZE_ITEM	:= PadL(AllTrim(Str(_nItem)),TamSx3("ZZE_ITEM")[1],"0")
		
						ZZE->(MsUnlock())
						_nOk++
					EndIf
				EndIf
			EndIf
			FT_FSKIP()
		EndDo
	Else
		Aviso("Atencao!", 	"Arquivo não pode ser processado, pois não contém a estrutura desejada para solicitações de pagamentos adiantados! " + CRLF + ;
							'Arquivo : "' + cFile + '".' ,{"Ok"},1)
	EndIf
	
	FT_FUSE()
	// Restaura area
	RestArea(aAreaAnt)
	
	If _lOk
		Aviso("Atencao!", 	"Foram processados os registros contidos no arquivo " + CRLF + '"' + cFile + '".' + CRLF +;
							"Importações realizadas: " + AllTrim(Str(_nOk)) +  " ." + CRLF ,{"Ok"},2)
	EndIf
	
	If _nOk == 0
		ZZE->(RollBackSX8())
	Else

		For _nI := 1 To Len(_aCC)
			
		Next _nI
	EndIf

Return( .t. )

Static Function fVldUsr(_cUsuario)

	Local _lOk		:= .F.
	PswOrder(2)
	
	If PswSeek( _cUsuario, .T. )
		_aUser	:= PSWRET()
		_lOk	:= .T.
	EndIf 

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fIncAlc  ºAutor  ³Bruna Zechetti      º Data ³  29/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para inclusão do workflow de alçadas para os títulos º±±
±±º          ³BuildUp.                                      			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fIncAlc(cCentroCusto, cNum, nValTot)

	Local cPrimNiv	:= "1"

	DbSelectArea("ZZ5")
	Dbsetorder(3)  // CC + Nivel
	If Dbseek(xfilial("ZZ5") + cCentroCusto)
		
		While ZZ5->(!Eof()) .and. (ZZ5->ZZ5_FILIAL == xFilial("ZZ5")) .And. (AllTrim(ZZ5->ZZ5_CC) == AllTrim(cCentroCusto))
			
			DbSelectArea("SAK")
			SAK->(DbSetOrder(1))
			If SAK->(DbSeek(xFilial("SAK") + ZZ5->ZZ5_APROV))
				
				// Verifica valor da alçada
				If (nValTot >= SAK->AK_LIMMIN .AND. nValTot <= SAK->AK_LIMMAX)
					DbSelectArea("ZZ6")
					ZZ6->(RecLock("ZZ6",.T.))
					ZZ6->ZZ6_FILIAL	:= xFilial("ZZ6")
					ZZ6->ZZ6_SC		:= GetSX8Num("ZZ6","ZZ6_SC")
					ZZ6->ZZ6_PA		:= cNum
					ZZ6->ZZ6_APROV	:= ZZ5->ZZ5_APROV
					ZZ6->ZZ6_NIVEL	:= ZZ5->ZZ5_NIVEL
					ZZ6->ZZ6_STATUS	:= Iif(ZZ5->ZZ5_NIVEL > cPrimNiv,"4","1")
					ZZ6->ZZ6_HRENT	:= Time()
					ZZ6->ZZ6_DTENT	:= dDataBase
					ZZ6->ZZ6_CC		:= ZZ5->ZZ5_CC
					If ZZ6->ZZ6_STATUS == "1"
						cPrimNiv	:= ZZ5->ZZ5_NIVEL
					EndIf
					ZZ6->(MsUnlock())
				Endif
			EndIf
			ZZ5->(dbSkip())
		EndDo
	Endif

Return()