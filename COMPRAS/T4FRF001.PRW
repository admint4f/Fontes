#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ T4FRF001         ³Autor ³ Geraldo Sabino     ³Data³ 05.10.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera Relatorio EPEP Excel                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Manutencao Efetuada                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                            ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function T4FRF001()     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1         := "Este programa tem como objetivo gerar o arquivo Excel "
Local cDesc2         := "das despesas por SC e Rateio"
Local cDesc3         := ""
Local cPict          := " "
Local nLin           := 80
Local cDestino	     := cGetFile(, "Selecione o Destino do arquivo",0,"",.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)

Local imprime        := .T.
Local aPergunta      := {}
Private Titulo       := "Relatorio de Despesas "

Private Titulo0      := "Relatorio de Despesas "

Private aOrd		 := {}
private aCampos      := {}
private cNomArq      := ""
Private lAbortPrint  := .F.
Private limite       := 80
Private tamanho      := "G"
Private nomeprog     := "T4FRF001"
Private nTipo        := 18
Private aReturn      := { "ZebraDo", 1, "Administracao", 2, 2, 1, "", 1} //"ZebraDo"###"Administracao"
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private wnrel        := "T4FRF001"
Private cPerg        := "T4FRF001"

XT4FRF001(cDestino)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ XT4FRF001       ³Autor ³ GERALDO SABINO       ³Data³ 05.10.18³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Processamento do relatorio								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function XT4FRF001(cDestino)
Local aArqs		    := {}
Local aAreaSM0
Local lGestao       := ( FWSizeFilial() > 2 )
Local lSE2Excl      := Iif( lGestao, FWModeAccess("SE1",1) == "E", FWModeAccess("SE1",3) == "E")
Local aSM0          := {}
Local aSelFil       := {}
Private _aDados       := {}
Private aParamBox     := {}
Private aRet          := {}

aAdd(aParamBox,{1,"Periodo De:      ",DATE(),"","","","",50,.F.})
aAdd(aParamBox,{1,"Periodo Ate:     ",DATE(),"","","","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  1 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  2 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  3 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  4 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  5 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  6 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  7 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  8 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP  9 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})
aAdd(aParamBox,{1,"Elemento EPEP 10 "	 ,SPAC(LEN(SC1->C1_ITEMCTA)),"","","CTD","",50,.F.})

If !ParamBox(aParamBox, "Confirma Parametros ?", aRet)
	Return Nil
EndIf

aStruct:={}

//aAdd(aStruct,{"UNIDADE"    	,"C"	,_nLen               ,0})
aAdd(aStruct,{"COL01"      		,"D"	,08		,0})
aAdd(aStruct,{"COL02"       	,"C"	,06		,0})
aAdd(aStruct,{"COL03"       	,"C"	,10		,0}) //????????????????????
aAdd(aStruct,{"COL04"  			,"C"	,06		,0})
aAdd(aStruct,{"COL05"      		,"C"	,LEN(SC1->C1_CC)		,0})
aAdd(aStruct,{"COL06"  	  		,"C"	,10		,0}) //?????? 11 OU 9?
aAdd(aStruct,{"COL07"        	,"C"	,LEN(SC1->C1_ITEMCTA)		,0})
aAdd(aStruct,{"COL08" 			,"C"	,LEN(SC1->C1_ITEMCTA)		,0})
aAdd(aStruct,{"COL09"  	 		,"C"	,06		,0})
aAdd(aStruct,{"COL09A" 	 		,"C"	,20		,0})
aAdd(aStruct,{"COL10"       	,"C"	,09     ,0})
aAdd(aStruct,{"COL11"          	,"C"	,03     ,0})
aAdd(aStruct,{"COL12"        	,"C"	,10     ,0})
aAdd(aStruct,{"COL13"         	,"C"	,10     ,0})
aAdd(aStruct,{"COL14"          	,"N"	,13     ,2})
aAdd(aStruct,{"COL15"        	,"N"	,13     ,2})
aAdd(aStruct,{"COL16"         	,"N"	,13     ,2})
aAdd(aStruct,{"COL17"         	,"N"	,13     ,4})
aAdd(aStruct,{"COL18"         	,"N"	,13     ,4})
aAdd(aStruct,{"COL19"         	,"C"	,15     ,0})
aAdd(aStruct,{"COL20"         	,"C"	,30     ,0})
aAdd(aStruct,{"COL21"         	,"C"	,10     ,0})


If (Select("TRB") <> 0)
	dbSelectArea("TRB")
	TRB->(dbCloseArea ())
Endif

_cArq:=Criatrab(,.F.)
MsCreate(_cArq,aStruct,"DBFCDX")
dbUseArea(.T.,"DBFCDX",_cArq,"TRB",.T.,.F.)
IndRegua("TRB", _cArq, "COL02+COL04",,, "Ordenando arquivo temporário...")

Processa({|| xBuscaC1(cDestino,aRet)},"Gerando arquivo temporário...")

Return


Static Function xBuscaC1(cDestino,aRet)
Local  cQuery := ""
Local  nRegs  := 0



// Monta os Elementos para usar em Formatin da Query
_c1     := " "
For _c:=3 to 12
	If !Empty(aRet[_c])
	    If _c>3
		_c1     += "/"
	    Endif
		_c1     += aRet[_c]
	Endif
Next        

_c1:=alltrim(_c1)

// Filtra na primeira query

_cQuery :=" SELECT " 
_cQuery +=" SC1.C1_EMISSAO AS COL01,"
_cQuery +=" SC1.C1_NUM     AS COL02,"
_cQuery +=" SZ2.Z2_NUMSC   AS COL03,"
_cQuery +=" SC7.C7_NUM     AS COL04,"
_cQuery +=" SC1.C1_CC      AS COL05,"
_cQuery +=" SZ2.Z2_CC      AS COL06,"
_cQuery +=" SC1.C1_ITEMCTA AS COL07,"
_cQuery +=" SZ2.Z2_ITEMCTA AS COL08,"
_cQuery +=" SC7.C7_FORNECE AS COL09,"
_cQuery +=" SA2.A2_NREDUZ  AS COL09A,"
_cQuery +=" SD1.D1_DOC     AS COL10,"
_cQuery +=" SC1.C1_CONDPAG AS COL11,"
_cQuery +=" SZ2.Z2_ITEMSC  AS COL12,"
_cQuery +=" SZ2.Z2_ITEM    AS COL13,"
_cQuery +=" SZ2.Z2_PERC    AS COL14,"
_cQuery +=" SC7.C7_TOTAL   AS COL15,"
_cQuery +=" SZ2.Z2_VALOR   AS COL16,"
_cQuery +=" SC7.C7_QUANT   AS COL17,"
_cQuery +=" SC7.C7_QUJE    AS COL18,"
_cQuery +=" SC7.C7_PRODUTO AS COL19,"
_cQuery +=" SC7.C7_DESCRI  AS COL20,"
_cQuery +=" SC7.C7_USUARIO AS COL21  "
_cQuery +=" FROM "+RETSQLNAME("SC1")+" SC1 "

_cQuery +=" LEFT JOIN "+RETSQLNAME("SD1")+ " SD1 "
_cQuery +=" ON  SD1.D1_COD    = SC1.C1_PRODUTO "
_cQuery +=" AND SD1.D1_PEDIDO = SC1.C1_PEDIDO "
_cQuery +=" AND SD1.D1_ITEMPC = SC1.C1_ITEM "
_cQuery +=" AND SD1.D_E_L_E_T_<>'*' "

_cQuery +=" LEFT JOIN "+RETSQLNAME("SZ2")+" SZ2 "
_cQuery +=" ON  SZ2.Z2_NUMSC  = SC1.C1_NUM  "
_cQuery +=" AND SZ2.Z2_ITEMSC = SC1.C1_ITEM "
_cQuery +=" AND SZ2.D_E_L_E_T_<>'*' "


_cQuery +=" LEFT JOIN "+RETSQLNAME("SC7")+" SC7 "
_cQuery +=" ON  SC7.C7_NUM = SC1.C1_PEDIDO "
_cQuery +=" AND SC7.C7_ITEMSC = SC1.C1_ITEM "
_cQuery +=" AND SC7.D_E_L_E_T_<>'*' "


_cQuery +=" LEFT JOIN "+RETSQLNAME("SA2")+ " SA2  "
_cQuery +=" ON  SA2.A2_COD    = SC7.C7_FORNECE "
_cQuery +=" AND SA2.A2_LOJA   = SC7.C7_LOJA "
_cQuery +=" AND SA2.D_E_L_E_T_<>'*' "


_cQuery +=" WHERE SC1.C1_EMISSAO BETWEEN '"+Dtos(aRet[1])+"' AND '"+Dtos(aRet[2])+"' "
_cQuery +=" AND SZ2.Z2_ITEMCTA IN "+FormatIn(_c1,"/")+"  "
_cQuery +=" AND SC1.D_E_L_E_T_<>'*' "
_cQuery +=" AND SC7.D_E_L_E_T_<>'*' "
_cQuery +=" AND SZ2.D_E_L_E_T_<>'*' "
_cQuery +=" UNION "
_cQuery += "SELECT  "
_cQuery +=" SC1.C1_EMISSAO AS COL01,"
_cQuery +=" SC1.C1_NUM     AS COL02,"
_cQuery +=" SC1.C1_TIPCOM  AS COL03,"
_cQuery +=" SC7.C7_NUM     AS COL04,"
_cQuery +=" SC1.C1_CC      AS COL05,"
_cQuery +=" SC1.C1_TIPCOM  AS COL06,"
_cQuery +=" SC1.C1_ITEMCTA AS COL07,"
_cQuery +=" SC1.C1_TIPCOM  AS COL08,"
_cQuery +=" SC7.C7_FORNECE AS COL09,"
_cQuery +=" SA2.A2_NREDUZ  AS COL09A,"
_cQuery +=" SD1.D1_DOC     AS COL10,"
_cQuery +=" SC1.C1_CONDPAG AS COL11,"
_cQuery +=" SC1.C1_TIPCOM  AS COL12,"
_cQuery +=" SC1.C1_TIPCOM  AS COL13,"
_cQuery +=" 0              AS COL14,"
_cQuery +=" SC7.C7_TOTAL   AS COL15,"
_cQuery +=" 0              AS COL16,"
_cQuery +=" SC7.C7_QUANT   AS COL17,"
_cQuery +=" SC7.C7_QUJE    AS COL18,"
_cQuery +=" SC7.C7_PRODUTO AS COL19,"
_cQuery +=" SC7.C7_DESCRI  AS COL20,"
_cQuery +=" SC7.C7_USUARIO AS COL21 "
_cQuery +=" FROM "+RetSqlname("SC1")+" SC1  "

_cQuery +=" LEFT JOIN "+RETSQLNAME("SD1")+" SD1 "
_cQuery +=" ON SD1.D1_COD = SC1.C1_PRODUTO "
_cQuery +=" AND SD1.D1_PEDIDO = SC1.C1_PEDIDO "
_cQuery +=" AND SD1.D1_ITEMPC = SC1.C1_ITEM "
_cQuery +=" AND SD1.D_E_L_E_T_<>'*' "

_cQuery +=" LEFT JOIN "+RETSQLNAME("SC7")+ " SC7  "
_cQuery +=" ON  SC7.C7_NUM = SC1.C1_PEDIDO "
_cQuery +=" AND SC7.C7_ITEMSC = SC1.C1_ITEM "
_cQuery +=" AND SC7.D_E_L_E_T_<>'*' "

_cQuery +=" LEFT JOIN "+RETSQLNAME("SA2")+ " SA2  "
_cQuery +=" ON  SA2.A2_COD    = SC7.C7_FORNECE "
_cQuery +=" AND SA2.A2_LOJA   = SC7.C7_LOJA "
_cQuery +=" AND SA2.D_E_L_E_T_<>'*' "

_cQuery +=" WHERE SC1.C1_EMISSAO BETWEEN '"+Dtos(aRet[1])+"' AND '"+Dtos(aRet[2])+"' "
_cQuery +=" AND SC1.C1_ITEMCTA IN "+FormatIn(_c1,"/")+"  "
_cQuery +=" AND SC1.D_E_L_E_T_<>'*' "
_cQuery +=" AND SC7.D_E_L_E_T_<>'*' "

IF SELECT("QRY") <> 0
	dBSelectarea("QRY")
	dBClosearea("")
Endif     

TCQUERY _cQuery New Alias "QRY"       

TCSetField( "QRY", "COL01", "D", 8 )


dBSelectarea("QRY")
dBgotop()
COUNT TO nregs
dbgotop()
//Alert("Foram selecionados "+STR(nRegs) + " Registros !")
             
_aSC :={}
While !QRY->(Eof()) 
    //IncProc()
	 	
	RecLock("TRB",.T.)
	TRB->COL01   	    :=  QRY->COL01
	TRB->COL02         	:=  QRY->COL02
	TRB->COL03     		:=  QRY->COL03
	TRB->COL04     		:=  QRY->COL04
	TRB->COL05       	:=  QRY->COL05
	TRB->COL06      	:=  QRY->COL06
	TRB->COL07        	:=  QRY->COL07
	TRB->COL08     		:=  QRY->COL08
	TRB->COL09       	:=  QRY->COL09
	TRB->COL09A      	:=  QRY->COL09A
	TRB->COL10         	:=  QRY->COL10
	TRB->COL11         	:=  QRY->COL11
	TRB->COL12          :=  QRY->COL12
	TRB->COL13          :=  QRY->COL13
	TRB->COL14          :=  QRY->COL14
	TRB->COL15          :=  QRY->COL15
	TRB->COL16          :=  QRY->COL16
	TRB->COL17          :=  QRY->COL17
	TRB->COL18          :=  QRY->COL18
	TRB->COL19          :=  QRY->COL19
	TRB->COL20          :=  QRY->COL20
	TRB->COL21          :=  QRY->COL21
	MsUnLock()
	
	
	IF !EMPTY(QRY->COL02) .AND. !EMPTY(QRY->COL03) 
	   AADD(_aSC,QRY->COL02)                        
	ENDIF
	
	dBSelectarea("QRY")
	dBSkip()
Enddo     



	dBSelectarea("QRY")
	dBClosearea("")

FISImpExcel(cDestino)
Return

/*                X'
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FISIMPEXCEL  ºAutor  ³Microsiga        º Data ³  11/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function FISIMPEXCEL(cDestino)
Local oExcel
Local oExcelApp
Local cArq	   		:= ""
Local nI       		:= 0
Local nX       		:= 0
Local cDirTmp  		:= "C:\temp"
Local cPlan			:= ""
Local lDataCpo		:=.F.
Local lStringCpo	:=.F.
Local aDados:={}

//Cria objeto
oExcel := FWMSEXCEL():New()

//Inclui nova Planilha no Arquivo
cPlan	:= "RELACAO DE DESPESAS RATEIO/SC  "
oExcel:AddworkSheet(cPlan)

aColumns 	:= {"Emissao","Numero Solicitacao","Num Solic Rat","Numero do Pedido","CC Solic","CC Rat","EPEP Sc","EPE Rat","Codigo Fornecedor","Nome Fornecedor","Numero do Documento","Cond Pagamento","Item da SC Rateado","Parcela do Rateio","Porcentagem Item Rateado","Soma","Valor Produto Selecionado","Valor Produto Rateado","Quantidade","Quantidade Entregue","Codigo Produto","Descricao Produto","Solicitante"}
cTab	:= " LISTAGEM DE DESPESAS "

//Inclui nova Planilha no Arquivo
oExcel:AddTable(cPlan,cTab)

// Cria Cabecalho das informações
For nI := 1 To Len(aColumns)
	oExcel:AddColumn(cPlan,cTab,aColumns[nI],1,1)
Next nI

dBselectarea("TRB")
dBGotop()

While ! TRB->(Eof())

    IF EMPTY(TRB->COL03) .AND. EMPTY(TRB->COL06)
       nPos := ASCAN(_aSC,TRB->COL02)
       IF nPos > 0
          dBSelectarea("TRB")
          dBskip()
          Loop
       Endif           
    ENDIF


	_c01:= TRB->COL01
	_c02:= TRB->COL02
	_c03:= TRB->COL03
	_c04:= TRB->COL04
	_c05:= TRB->COL05
	_c06:= TRB->COL06
	_c07:= TRB->COL07
	_c08:= TRB->COL08
	_c09:= TRB->COL09
	_c09A:= TRB->COL09A
	_c10:= TRB->COL10
	_c11:= TRB->COL11
	_c12:= TRB->COL12
	_c13:= TRB->COL13
	_c14:= TRB->COL14 
	_c14A:= IIF(TRB->COL16=0,TRB->COL15,TRB->COL16)	
	_c15:= TRB->COL15
	_c16:= TRB->COL16
	_c17:= TRB->COL17
	_c18:= TRB->COL18
	_c19:= TRB->COL19
	_c20:= TRB->COL20
	_c21:= TRB->COL21
	
	
	aDados:={}
	aadd(aDados,      _c01                  ,"D", 08,0) //
	aadd(aDados,      _c02                  ,"C", 06,0) //
	aadd(adados,      _c03                  ,"C", 10,0) //
	aadd(adados,      _c04                  ,"C", 06,0) //
	aadd(adados,      _c05                  ,"C", LEN(SC1->C1_CC),0) //
	aadd(adados,      _c06                  ,"C", 10,0) //
	aadd(adados,      _c07                  ,"C", LEN(SC1->C1_ITEMCTA),0)  //
	aadd(adados,      _c08                  ,"C", LEN(SC1->C1_ITEMCTA),0) //
	aadd(adados,      _c09                  ,"C", 06,0) //
	aadd(adados,      _c09A                 ,"C", 20,0) //
	aadd(adados,      _c10                  ,"C", 09,0) //
	aadd(adados,      _c11                  ,"C", 03,0) //
	aadd(adados,      _c12                  ,"C", 10,0) //
	aadd(adados,      _c13                  ,"C", 10,0) //
	aadd(adados,      _c14                  ,"N", 13,2) //
	aadd(adados,      _c14A                 ,"N", 13,2) //
	aadd(adados,      _c15                  ,"N", 13,2) //
	aadd(adados,      _c16                  ,"N", 13,2) //
	aadd(adados,      _c17                  ,"N", 13,4) //
	aadd(adados,      _c18                  ,"N", 13,4) //
	aadd(adados,      _c19                  ,"C", 15,0) //
	aadd(adados,      _c20                  ,"C", 30,0) //
	aadd(adados,      _c21                  ,"C", 10,0) //
	
	oExcel:AddRow(cPlan,cTab,aDados)

	TRB->(dBskip())
	
Enddo


dBselectarea("TRB")
dBclosearea()

oExcel:Activate()

//Cria nome para arquivo
cArq := CriaTrab( NIL, .F. ) + ".xml"
cArq := "T4FRF001" + DtoS(Date()) + "_" + StrTran(Time(),":") + ".XML"
oExcel:GetXMLFile( cArq )

//Copia arquivo para diretório temporário do usuário
//e realiza abertura do mesmo
If __CopyFile( cArq, cDestino+"\"+ cArq )
	MsgInfo( "Relacao DESPESAS na Pasta " + cDestino )
Else
	MsgInfo( "Arquivo não copiado para temporário do usuário." )
Endif

Return
