#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA103MNU บAutor  ณMicrosiga           บ Data ณ  17/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inclusao de opcoes no aRotina do MATA103                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 10.1 - Ocrim
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MTA103MNU()
aAdd(aRotina,{"Dados NF-e(Import.)","U__fMTA103DI()",0,4,0,nil}) // Dados de Importa็ใo
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_fMTA103DIบAutor  ณMicrosiga           บ Data ณ  17/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescri…o ณAbre tela para digitacao do Complemento de Informacoes para ณฑฑ
ฑฑณ          ณa NF de Importacao, informacoes da DI.Qdo nao tem o Sigaeic ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 10.1 - Ocrim                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function _fMTA103DI()
Local aAltD1    := {"D1_XADICAO","D1_XSEQADI","D1_XFABRIC","D1_XDSCADI"} // campos que podem ser alterados 
Local aTitles	:= {"Dados da D.I.","Produtos"}
Local aPages	:= {"HEADER 1","HEADER 2"}
Local _lOk      := .f.
Local aSimD1    := {"D1_ITEM","D1_COD","D1_XADICAO","D1_XSEQADI","D1_XFABRIC","D1_XDSCADI"}
Local aSimD5    := {"CD5_TPIMP","CD5_DOCIMP","CD5_DATADI","CD5_BSPIS","CD5_ALPIS","CD5_VLPIS","CD5_BSCOF","CD5_ALCOF","CD5_VLCOF","CD5_LOCDES","CD5_UFDES","CD5_DTDES","CD5_BCIMP","CD5_DSPAD","CD5_VLRII","CD5_VLRIOF","CD5_CODEXP"}
Private bOk     := {|| IIF(_f103TudOk(),_lOk := .t.,),IIF(_lOk,oDlg:End(),) }
private _aArea  := GetArea()
Private aHeadDI := aColsDI := aHeadADI := aColsADI := {}
Private _oGetADI ,_oGetDI

IF !(SF1->F1_EST == 'EX'  .AND. ALLTRIM(SF1->F1_ESPECIE) == "SPED")
	Return()
ENDIF

DEFINE MSDIALOG oDlg TITLE "Informacoes Complementares" From 8,8 To 30,120 OF oMainWnd

oFolder := TFolder():New(52,1,aTitles,aPages,oDlg,,,, .T., .F.,430,140,)
oFolder:Align := CONTROL_ALIGN_ALLCLIENT

cSeek  	  := XFilial("CD5")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
cWhile 	  := "CD5->(CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA)"
FillGetDados(4,"CD5",1,cSeek,{|| &cWhile },{|| .T. },,aSimD5,,,,,aHeadDI,aColsDI)

_oGetDI := MsNewGetDados():New(0,0,0,0,3,,,,,,1,,,,oFolder:aDialogs[1],aHeadDI,aColsDI)
_oGetDI:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT //:= CONTROL_ALIGN_ALLCLIENT

cSeek  	  := XFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
cWhile 	  := "SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)"
FillGetDados(4,"SD1",1,cSeek,{|| &cWhile },{|| .T. },,aSimD1,,,,,aHeadADI,aColsADI)

_oGetADI := MsNewGetDados():New(0,0,0,0,3,,,,aAltD1,,Len(aColsADI),,,,oFolder:aDialogs[2],aHeadADI,aColsADI)
_oGetADI:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT// := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,{||oDlg:End()})

IF _lOk
	CD5->(dbSetOrder(1))
	IF !CD5->(dbSeek(XFILIAL("CD5")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)))
		RecLock("CD5",.T.)
	ELSE
		RecLock("CD5",.F.)
	ENDIF
	CD5->CD5_FILIAL	:= xFilial("CD5")
	CD5->CD5_DOC	:= SF1->F1_DOC
	CD5->CD5_SERIE	:= SF1->F1_SERIE
	CD5->CD5_ESPEC	:= SF1->F1_ESPECIE
	CD5->CD5_FORNEC := SF1->F1_FORNECE
	CD5->CD5_LOJA	:= SF1->F1_LOJA
	CD5->CD5_TPIMP	:= _oGetDI:aCols[1,GdFieldPos("CD5_TPIMP",aHeadDI)]
	CD5->CD5_DOCIMP := _oGetDI:aCols[1,GdFieldPos("CD5_DOCIMP",aHeadDI)]
	CD5->CD5_DATADI := _oGetDI:aCols[1,GdFieldPos("CD5_DATADI",aHeadDI)]
	CD5->CD5_BSPIS	:= _oGetDI:aCols[1,GdFieldPos("CD5_BSPIS",aHeadDI)]
	CD5->CD5_ALPIS	:= _oGetDI:aCols[1,GdFieldPos("CD5_ALPIS",aHeadDI)]
	CD5->CD5_VLPIS	:= _oGetDI:aCols[1,GdFieldPos("CD5_VLPIS",aHeadDI)]
	CD5->CD5_BSCOF	:= _oGetDI:aCols[1,GdFieldPos("CD5_BSCOF",aHeadDI)]
	CD5->CD5_ALCOF	:= _oGetDI:aCols[1,GdFieldPos("CD5_ALCOF",aHeadDI)]
	CD5->CD5_VLCOF	:= _oGetDI:aCols[1,GdFieldPos("CD5_VLCOF",aHeadDI)]
	CD5->CD5_LOCDES	:= _oGetDI:aCols[1,GdFieldPos("CD5_LOCDES",aHeadDI)]
	CD5->CD5_UFDES	:= _oGetDI:aCols[1,GdFieldPos("CD5_UFDES",aHeadDI)]
	CD5->CD5_DTDES	:= _oGetDI:aCols[1,GdFieldPos("CD5_DTDES",aHeadDI)]   
	CD5->CD5_BCIMP 	:= _oGetDI:aCols[1,GdFieldPos("CD5_BCIMP",aHeadDI)]   
	CD5->CD5_DSPAD	:= _oGetDI:aCols[1,GdFieldPos("CD5_DSPAD",aHeadDI)]   
	CD5->CD5_VLRII  := _oGetDI:aCols[1,GdFieldPos("CD5_VLRII",aHeadDI)]   
	CD5->CD5_VLRIOF	:= _oGetDI:aCols[1,GdFieldPos("CD5_VLRIOF",aHeadDI)]   
	CD5->CD5_CODEXP := _oGetDI:aCols[1,GdFieldPos("CD5_CODEXP",aHeadDI)]   
	CD5->CD5_NDI	:= _oGetDI:aCols[1,GdFieldPos("CD5_DOCIMP",aHeadDI)]
	CD5->CD5_DTDI	:= _oGetDI:aCols[1,GdFieldPos("CD5_DATADI",aHeadDI)]
	CD5->(msunlock())
	
	For i := 1 to Len(_oGetADI:aCols)
		_cProd := _oGetADI:aCols[i,GdFieldPos("D1_COD",aHeadADI)]
		_cItem := _oGetADI:aCols[i,GdFieldPos("D1_ITEM",aHeadADI)]
		SD1->(dbSetOrder(1))
		IF SD1->(dbSeek(xFilial("SD1")+SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)+_cProd+_cItem))
			RecLock("SD1",.F.)
			SD1->D1_XADICAO := _oGetADI:aCols[i,GdFieldPos("D1_XADICAO",aHeadADI)]
			SD1->D1_XSEQADI := _oGetADI:aCols[i,GdFieldPos("D1_XSEQADI",aHeadADI)]
			SD1->D1_XFABRIC := _oGetADI:aCols[i,GdFieldPos("D1_XFABRIC",aHeadADI)]
			SD1->D1_XDSCADI := _oGetADI:aCols[i,GdFieldPos("D1_XDSCADI",aHeadADI)]
			MsUnLock()
		endif
	Next
	
ENDIF

RestArea(_aArea)
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_f103TudOkบAutor  ณMicrosiga           บ Data ณ  24/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validacao TudoOk                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 10.1 - Descarpack                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _f103TudOk()
Local _lRet  := .t.
Local _cMens := ""

IF Ascan(_oGetADI:aCols,{|x| Empty(x[GdFieldPos("D1_XADICAO",aHeadADI)])}) <> 0 // adicao
	_cMens += "D1_XADICAO - Adi็ใo"+Chr(13)+Chr(10)
ENDIF
IF Ascan(_oGetADI:aCols,{|x| Empty(x[GdFieldPos("D1_XSEQADI",aHeadADI)])}) <> 0 // sequencia de adicao
	_cMens += "D1_XSEQADI - Sequ๊ncia de Adi็ใo"+Chr(13)+Chr(10)
ENDIF
IF Ascan(_oGetADI:aCols,{|x| Empty(x[GdFieldPos("D1_XFABRIC",aHeadADI)])}) <> 0 // fabricante
	_cMens += "D1_XFABRIC - Fabricante"+Chr(13)+Chr(10)
ENDIF
IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_DOCIMP",aHeadDI)])}) <> 0 // numero DI
	_cMens += "CD5_DOCIMP - N๚mero DI"+Chr(13)+Chr(10)
ENDIF
IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_DATADI",aHeadDI)])}) <> 0 // data da DI
	_cMens += "CD5_DATADI - Data DI"+Chr(13)+Chr(10)
ENDIF
IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_LOCDES",aHeadDI)])}) <> 0 // Local DI
	_cMens += "CD5_LOCDES - Local Desembara็o"+Chr(13)+Chr(10)
ENDIF
IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_UFDES",aHeadDI)])}) <> 0 // UF Desemb.
	_cMens += "CD5_UFDES - UF Desembara็o"+Chr(13)+Chr(10)
ENDIF
IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_DTDES",aHeadDI)])}) <> 0 // Dt. Desemb.
	_cMens += "CD5_DTDES - Dt. Desembara็o"+Chr(13)+Chr(10)
ENDIF
//IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_BCIMP",aHeadDI)])}) <> 0 // Vlr. BC Importa็ใo
//	_cMens += "CD5_BCIMP - Vlr. BC Importa็ใo"+Chr(13)+Chr(10)                       
//ENDIF
//IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_DSPAD",aHeadDI)])}) <> 0 // Vlr. Desp. Aduaneira
//	_cMens += "CD5_DSPAD - Vlr. Desp. Aduaneira"+Chr(13)+Chr(10)
//ENDIF
//IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_VLRII",aHeadDI)])}) <> 0 // Vlr. Imp. Importa็ใo
//	_cMens += "CD5_VLRII - Vlr. Imp. Importa็ใo"+Chr(13)+Chr(10)
//ENDIF
//IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_VLRIOF",aHeadDI)])}) <> 0 //  Vlr. IOF
//	_cMens += "CD5_VLRIOF - Vlr. IOF"+Chr(13)+Chr(10)
//ENDIF
IF Ascan(_oGetDI:aCols,{|x| Empty(x[GdFieldPos("CD5_CODEXP",aHeadDI)])}) <> 0 //  Cod.Exportador.
	_cMens += "CD5_CODEXP - Cod. EXP"+Chr(13)+Chr(10)
ENDIF


IF !Empty(_cMens)
	Aviso("Campos Obrigat๓rios",_cMens,{"Sair"},3)
	_lRet := .f.
ENDIF

Return(_lRet)
