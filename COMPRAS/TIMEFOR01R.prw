#include 'Protheus.ch'
#include 'TopConn.ch'
#DEFINE ENTER Chr(13)+Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTIMEFOR01Rบ Autor ณ Sergio Celestino   ณ Data ณ 27/01/11    ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relacoes de Solicitacoes de Compras                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TIMEFOR01R()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1     := "Este programa emitira' uma relacao"
Local cDesc2     := "de Solicita็๕es de Compras"
Local cDesc3     := ''
Local cString    := 'SC1'
Local Titulo	  := 'Rela็ใo de Solicita็๕es de Compras'
Local Tamanho    := 'G'
Local wnRel      := 'TIMEFOR01R'

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis tipo Private padrao de todos os relatorios         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private aOrd       := {"Categoria","Sub-Categoria","Solicita็ใo","Produto"}
Private aReturn    := {"Zebrado",1,"Administracao", 1, 2, 1, '',1 }
Private cPerg      := "TIMEFOR01R"
Private nLastKey   := 0
Private nTipo      := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
VALPERG(cPerg)
Pergunte(cPerg,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Envia controle para a funcao SETPRINT                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnRel := SetPrint(cString,wnRel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)
nTipo := If(aReturn[4]==1,GetMv('MV_COMP'),GetMv('MV_NORM'))

If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif

RptStatus({|lEnd| TimeExec(@lEnd,wnRel,Tamanho,Titulo)},Titulo)

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTimeExec    Autor ณ Sergio Celestino      ณ Data ณ 27/01/11 ณฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do Relatorio                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TimeExec(lEnd, wnRel, Tamanho, Titulo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis especificas do Relatorio                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nHdl		 := 0
Local i			 := 0
Local cFile		 := ""
Local cLinhaCSV	 := ""
Local aCabec	 := {} 
Local oExcel	 := Nil  
Local __cEmp     := ""

Private cFamilia   := ""
Private cProduto   := ""
Private cNomFor    := ""
Private sAprov     := ""
Private nTotalSc   := 0



//Cria o arquivo CSV
cFile 	+= "C:\TEMP\"+"REL"+DtoS(dDataBase)+StrTran(Time(),":","_")+".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Aten็ใo, nใo foi possํvel criar o arquivo no diret๓rio especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
AAdd(aCabec,{"Empresa"					,"C",'C1_EMP'	     })
//AAdd(aCabec,{"Filial"					,"C",'C1_FILIAL'	 })
AAdd(aCabec,{"Filial de Entrega"	    ,"C",'cNomeFil'	     })
AAdd(aCabec,{"Emergencial"				,"C",'C1_EMERGEN'	 })
AAdd(aCabec,{"Familia"				    ,"C",'cFamilia'      })
AAdd(aCabec,{"Nr Solicitacao"			,"C",'C1_NUM'	     })
AAdd(aCabec,{"Item da Solicitacao"	    ,"C",'C1_ITEM'	     })
AAdd(aCabec,{"Produto"	                ,"C",'C1_PRODUTO'	 })
AAdd(aCabec,{"Descricao"                ,"C",'cProduto'     })
AAdd(aCabec,{"Unidade Medida"           ,"C",'C1_UM'	     })
AAdd(aCabec,{"Quantidade"               ,"N",'C1_QUANT'	     })
AAdd(aCabec,{"Vlr. Unitario"            ,"N",'C1_VUNIT'	     })
AAdd(aCabec,{"Vlr. Total"               ,"N",'nTotalSc'	     })
AAdd(aCabec,{"Necessidade"              ,"D",'C1_DATPRF'	 })
AAdd(aCabec,{"Observacao"               ,"C",'C1_OBS'	     })
AAdd(aCabec,{"Segunda Unidade"          ,"C",'C1_SEGUM'	     })
AAdd(aCabec,{"Qtd. Segunda Unidade"     ,"C",'C1_QTSEGUM'	 })
AAdd(aCabec,{"Loja do Fornecedor"       ,"C",'C1_LOJA'	     })
AAdd(aCabec,{"Fornecedor"               ,"C",'C1_FORNECE'	 })
AAdd(aCabec,{"Nome Fornecedor"          ,"C",'cNomFor'	     })
AAdd(aCabec,{"Dt. Emissao"              ,"D",'C1_EMISSAO'	 })
AAdd(aCabec,{"Solicitante"              ,"C",'C1_SOLICIT'	 })
AAdd(aCabec,{"Dt. Aprovacao"            ,"C",'sAprov'	     })


For i := 1 To Len(aCabec)
	cLinhaCSV += aCabec[i,1] + ";"
Next i                            
FWrite(nHdl,cLinhaCSV+ENTER)

nRecno := MontaQuery()


For nI := 1 To 5

	__cAlias := 'TR'+Alltrim(Str(nI))
	dbSelectArea(__cAlias)
	dbGoTop()
	SetRegua(nRecno)
	
	While !Eof()
	  
	  cLinhaCSV := ""
	  
	  If lEnd
		@ PRow()+1, 001 PSay "CANCELADO PELO OPERADOR"	
		Exit
	  EndIf
	
	  IncRegua("Gerando Relatorio.Aguarde!!!")
	  
	  aAreaSM0 := SM0->(GetArea())
	  Do Case
	     Case &(__cAlias+"->C1_EMP" ) == 'T4F'            ;__cEmp:='08'
	     Case &(__cAlias+"->C1_EMP" ) == 'METROPOLITAN'   ;__cEmp:='09'
	     Case &(__cAlias+"->C1_EMP" ) == 'VICAR'          ;__cEmp:='16'
	     Case &(__cAlias+"->C1_EMP" ) == 'T4F A&B'        ;__cEmp:='20'
	     Case &(__cAlias+"->C1_EMP" ) == 'AREA MARKITING' ;__cEmp:='25'
	  EndCase 
      DbSelectArea("SM0")
      DbSetOrder(1)
      If DbSeek(__cEmp + &(__cAlias+"->C1_FILENT" ) )
        cNomeFil := SM0->M0_FILIAL
      Endif  
      RestArea(aAreaSM0)	   
	  
	  DbSelectArea("SB1")
	  DbSetOrder(1)
	  DbSeek( xFilial("SB1") + &(__cAlias+"->C1_PRODUTO" ) )
	  
	  DbSelectArea("SBM")
	  DbSetOrder(1)
	  DbSeek( xFilial("SBM") + SB1->B1_GRUPO )  
	  
	  DbSelectArea("SA2")
	  DbSetOrder(1)
	  DbSeek( xFilial("SA2") + &(__cAlias+"->C1_FORNECE") + &(__cAlias+"->C1_LOJA" )  )
	  
	  cFamilia := SBM->BM_DESC
	  cProduto := SB1->B1_DESC
	  cNomFor  := SA2->A2_NOME
	  nTotalSc := ( &(__cAlias+"->C1_QUANT") * &(__cAlias+"->C1_VUNIT ") )
	  
	  If &(__cAlias+"->C1_APROV") == 'L'
	    sAprov   := VerAprov(&(__cAlias+"->C1_NUM"),__cEmp)
	  Endif  
	  
	  For nY := 1 To Len(aCabec)
	    If Substr(aCabec[nY][3],1,2)=="C1"
	       cCpoVar := "TR"+Alltrim(Str(nI))+"->"+aCabec[nY][3]
	    Else   
           cCpoVar := aCabec[nY][3]	    
        Endif   
	    
	    If aCabec[nY][2]=="C"
	      cLinhaCSV += Alltrim(&cCpoVar)+";"
	    Elseif aCabec[nY][2]=="D"
	      dData := STOD(&cCpoVar)
	      cLinhaCSV += DTOC(dData)+";"
	    Elseif aCabec[nY][2]=="N"    
	      cLinhaCSV += Transform(&cCpoVar,"@E 999,999,999.99")+";"
	    Endif
	  Next
	  FWrite(nHdl,cLinhaCSV+ENTER)
	  
	  DbSelectArea(__cAlias)
	  DbSkip()
	End
Next

FClose(nHdl)
oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cFile)
oExcel:SetVisible(.T.)   

//If aReturn[5] == 1
//	Set Printer To
//	dbCommitAll()
//	OurSpool(wnRel)
//Endif

//MS_Flush()

Return Nil 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณ VALPERG  ณ Autor ณ Sergio Celestino        ณ Data ณ 27/01/11 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao ณ Verifica perguntas, incluindo-as caso nao existam.           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function VALPERG(cPerg)

	ssAlias	:= Alias()
	cPerg 	:= PADR(cPerg,10)
	aRegs 	:= {}
	dbSelectArea("SX1")
	dbSetOrder(1)
 
   aAdd(aRegs,{cPerg,"01","C๓digo do Produto de ?","จC๓digo do Produto de ?","From                      ?","mv_ch1","C",15,0,0,"G","","MV_PAR01","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","SB1",""})
   aAdd(aRegs,{cPerg,"02","C๓digo do Produto Ate?","จC๓digo do Produto Ate?","To                        ?","mv_ch2","C",15,0,0,"G","","MV_PAR02","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","SB1",""})   
   aAdd(aRegs,{cPerg,"03","Local de             ?","จLocal de             ?","From                      ?","mv_ch3","C",02,0,0,"G","","MV_PAR03","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","",""})
   aAdd(aRegs,{cPerg,"04","Local Ate            ?","จLocal Ate            ?","Ate                       ?","mv_ch4","C",02,0,0,"G","","MV_PAR04","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","",""})   
   aAdd(aRegs,{cPerg,"05","Categoria de ?"        ,"Categoria de ?"         ,"Categoria de ?"             ,"mv_ch5","C",06,0,0,"G","","MV_PAR05","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","SAJ",""})
   aAdd(aRegs,{cPerg,"06","Categoria Ate?"        ,"Categoria de ?"         ,"Categoria de ?"             ,"mv_ch6","C",06,0,0,"G","","MV_PAR06","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","SAJ",""})   
   aAdd(aRegs,{cPerg,"07","Sub-Categoria de ?"    ,"Sub-Categoria de ?"     ,"Sub-Categoria de ?"         ,"mv_ch7","C",04,0,0,"G","","MV_PAR07","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","SBM",""})
   aAdd(aRegs,{cPerg,"08","Sub-Categoria Ate?"    ,"Sub-Categoria de ?"     ,"Sub-Categoria de ?"         ,"mv_ch8","C",04,0,0,"G","","MV_PAR08","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","SBM",""})   
   aAdd(aRegs,{cPerg,"09","Tipo de Solicita็๕es ?","Tipo de Solicita็๕es ?" ,"Tipo de Solicita็๕es ?"     ,"mv_ch9","N",01,0,0,"C","","MV_PAR09","Atendidas"   ,"Atendidas"      ,"Atendidas"      ,"","","Nao Atendidas"  ,"Nao Atendidas"  ,"Nao Atendidas"  ,"","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","",""})   
   aAdd(aRegs,{cPerg,"10","Emergenciais         ?","Emergenciais         ?" ,"Emergenciais         ?"     ,"mv_cha","N",01,0,0,"C","","MV_PAR10","Sim"         ,"Sim"            ,"Sim"            ,"","","Nao"            ,"Nao"            ,"Nao"            ,"","","Todas"        ,"Todas"       ,"Todas"          ,"","","         ","         ","           ","","","        ","         ","          ","","",""})   
   aAdd(aRegs,{cPerg,"11","Emissao de             ?","จEmissao de        ?" ,"From                      ?","mv_chb","D",08,0,0,"G","","MV_PAR11","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","",""})
   aAdd(aRegs,{cPerg,"12","Emissao Ate            ?","จEmissao Ate        ?","Ate                       ?","mv_chc","D",08,0,0,"G","","MV_PAR12","            ","               ","               ","","","               ","               ","               ","","","             ","            ","               ","","","         ","         ","           ","","","        ","         ","          ","","",""})   
   aAdd(aRegs,{cPerg,"13","Aprovadas              ?","Aprovadas           ?" ,"Aprovadas                ?","mv_chd","N",01,0,0,"C","","MV_PAR13","Sim"         ,"Sim"            ,"Sim"            ,"","","Nao"            ,"Nao"            ,"Nao"            ,"","","Todas"        ,"Todas"       ,"Todas"          ,"","","         ","         ","           ","","","        ","         ","          ","","",""})   
            
   For i := 1 to Len(aRegs)
      If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
   dbSelectArea(ssAlias)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQueryบAutor  ณSergio Celestino    บ Data ณ  01/27/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerar Volume de Dados para Impressao                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaQuery()

Local cQueryA := ""
Local cQueryB := ""


For nM := 1 To 5
  cQueryA := ""
  Do Case
     Case nM == 1;cQueryA += " SELECT 'T4F'            AS C1_EMP,SC1.* FROM SC1080 SC1 "
     Case nM == 2;cQueryA += " SELECT 'METROPOLITAN'   AS C1_EMP,SC1.* FROM SC1090 SC1 "
     Case nM == 3;cQueryA += " SELECT 'VICAR'          AS C1_EMP,SC1.* FROM SC1160 SC1 "
     Case nM == 4;cQueryA += " SELECT 'T4F A&B'        AS C1_EMP,SC1.* FROM SC1200 SC1 "
     Case nM == 5;cQueryA += " SELECT 'AREA MARKITING' AS C1_EMP,SC1.* FROM SC1250 SC1 "
  EndCase   

	cQueryA += " INNER JOIN "+RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC1.C1_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
	cQueryA += " WHERE "
	cQueryA += " C1_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQueryA += " C1_LOCAL   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND "
	cQueryA += " B1_GRUPCOM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	cQueryA += " B1_GRUPO   BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND "
	cQueryA += " SC1.C1_EMISSAO  BETWEEN '"+DtoS(mv_par11)+"' AND '"+DtoS(mv_par12)+"'  AND "
	cQueryA += " SC1.D_E_L_E_T_ = ' ' AND "
	
	If mv_par13==1
	   cQueryA += "  C1_APROV = 'L'  AND "	
	Elseif mv_par13 ==2
	   cQueryA += "  C1_APROV = 'B'  AND "	
	Endif   
	
	If mv_par10 == 1
	  cQueryA += " C1_EMERGEN = 'S' AND "
	Elseif mv_par10 == 2
	  cQueryA += " C1_EMERGEN = 'N' AND "
	Endif
	
	If mv_par09 == 1
	  cQueryA += " C1_QUANT = C1_QUJE "
	Else
	  cQueryA += " C1_QUJE < C1_QUANT   "
	Endif
	
	If aReturn[8] == 1
	  cQueryA += " ORDER BY B1_GRUPCOM,C1_NUM "
	Elseif aReturn[8] == 2
	  cQueryA += " ORDER BY B1_GRUPO,C1_NUM   "
	Elseif aReturn[8] == 3
	  cQueryA += " ORDER BY C1_NUM,C1_ITEM    "
	Elseif aReturn[8] == 4
	  cQueryA += " ORDER BY C1_PRODUTO,C1_NUM "
	Endif

    cQueryA := ChangeQuery(cQueryA)

	If Select("TR"+Alltrim(Str(nM))) > 0
	   DbSelectArea("TR"+Alltrim(Str(nM)))
	   DbCloseArea()
	Endif   

    TcQuery cQueryA New Alias "TR"+Alltrim(Str(nM))

Next



//----------------------------------------------------------------------------------------------------------
// TOTALIZAR REGISTROS --------
//----------------------------------------------------------------------------------------------------------

cQueryB += " SELECT COUNT(*) AS TOTAL FROM "+RetSqlName("SC1")+ " SC1"
cQueryB += " INNER JOIN "+RetSqlName("SB1")+ " SB1 ON SB1.B1_COD = SC1.C1_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
cQueryB += " WHERE "
cQueryB += " C1_PRODUTO BETWEEN '"+mv_par01+"' AND '"+mv_par02+"'  AND "
cQueryB += " C1_LOCAL   BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'  AND "
cQueryB += " B1_GRUPCOM BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'  AND "
cQueryB += " B1_GRUPO   BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'  AND "
cQueryB += " SC1.C1_EMISSAO  BETWEEN '"+DtoS(mv_par11)+"' AND '"+DtoS(mv_par12)+"'  AND "
cQueryB += " SC1.D_E_L_E_T_ = ' ' AND "

If mv_par13==1
   cQueryB += "  C1_APROV = 'L'  AND "	
Elseif mv_par13 ==2
   cQueryB += "  C1_APROV = 'B'  AND "	
Endif   

If mv_par10 == 1
  cQueryB += " C1_EMERGEN = 'S' AND "
Elseif mv_par10 == 2
  cQueryB += " C1_EMERGEN = 'N' AND "
Endif

If mv_par09 == 1
  cQueryB += " C1_QUANT = C1_QUJE "
Else
  cQueryB += " C1_QUJE < C1_QUANT "
Endif

cQueryB := ChangeQuery(cQueryB)

If Select("TRA") > 0
   DbSelectArea("TRA")
   DbCloseArea()
Endif   

TcQuery cQueryB New Alias "TRA"

Return TRA->TOTAL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTIMEFOR01RบAutor  ณMicrosiga           บ Data ณ  02/17/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerAprov(cNum,__cEmp)

Local cQry     := ""
Local cDataRet := ""
                                          
cQry := "SELECT * FROM ZZ6"+Alltrim(__cEmp)+"0 WHERE ZZ6_SC = '"+cNum+"' AND D_E_L_E_T_ = ' ' AND ZZ6_DTSAI <> ' ' ORDER BY ZZ6_DTSAI"

If Select("TRA")>0
   DbSelectArea("TRA")
   DbCloseArea()
Endif   
     
TcQuery cQry New Alias "TRA"

DbSelectArea("TRA")
DbGotop()
While !Eof()
    cDataRet := Substr(TRA->ZZ6_DTSAI,7,2)+"/"+Substr(TRA->ZZ6_DTSAI,5,2)+"/"+Substr(TRA->ZZ6_DTSAI,1,4)
  DbSelectArea("TRA")
  DbSkip()
End

Return cDataRet