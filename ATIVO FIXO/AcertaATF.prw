#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACERTAATF บAutor  ณMicrosiga           บ Data ณ  00/00/00   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Corre็oes diversas a serem efetuadas na base importada do  บฑฑ
ฑฑบ          ณ AfixCode                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


User Function AcertaATF()

Acerta1()
Return  

If ApMsgYesNo("Confirma o ajuste na tabela SN3 ?"+chr(13)+"A data de aquisi็ใo que estiver em branco no SN3"+CHR(13)+"Serแ ajustada conforme a data aquisi็ใo que estiver no SN1.") 
	Processa( {|| UpdAtivo()},"Preenchendo data requisi็ใo")
EndIf

If ApMsgYesNo("Confirma o ajuste na tabela SN3 ?"+chr(13)+"Os valores das demais moedas (2,4,5) serใo zerados."+CHR(13)+"Executa apenas na empresa corrente.") 
	Processa( {|| AcOutMoedas()},"Preenchendo data requisi็ใo")
EndIf

If ApMsgYesNo("Confirma o ajuste na tabela SN3 ?"+chr(13)+"Os valores da moeda 3 serao recalculados."+CHR(13)+"Executa apenas na empresa corrente.") 
	Processa( {|| AcMoeda3()},"Preenchendo data requisi็ใo")
EndIf

If ApMsgYesNo("Confirma o ajuste na tabela SN3 ?"+chr(13)+"O campo DATA FIM DEPRECIAวรO SERม limpo !"+chr(13)+"Caso exista Saldo a Depreciar e a data da baixa estiver em branco."+CHR(13)+"Executa apenas na empresa corrente.") 
	Processa( {|| AcDtFimD()},"Preenchendo data requisi็ใo")
EndIf

If MsgYesNo("Confirma acerto da situa็ใo ca penhora no SN1 ?")
   If !File("C:\ativofixo2011\PENHORA_METRO.csv")
       ApMsgStop("Aten็ใo: O arquivo nใo foi encontrado")
   Else
      Processa( {|| AcPenhora(),"Corrigindo Sit.Penhora" } )   
   EndIF   
EndIf     

Return                                              
                      


Static Function AcDtFimD()

Local nTotReg:= 0 
Local cAlias:= GetNextAlias()
Local cAliasPrd:= GetNextAlias()
Local cQuery:= " "

// Log
Local _aLOG:= {}
Local _cMenLog:= ""
Local _nHdlLog

cQuery:= "select count(*) as totreg from "+retSqlName("sn3")+ " "
cQuery+= "where  (n3_vorig1 <> n3_vrdacm1) and n3_dtbaixa=' ' and n3_fimdepr<>' ' "
cQuery+= "and d_e_l_e_t_ = ' ' "

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")
(cAlias)->( DbGotop() )
nTotReg:= (cAlias)->TotReg
(cAlias)->( DbCloseArea() )

//
cQuery:= "select r_e_c_n_o_ as sn3recno from "+retSqlName("sn3")+ " "
cQuery+= "where  (n3_vorig1 <> n3_vrdacm1) and n3_dtbaixa=' ' and n3_fimdepr<>' ' "
cQuery+= "and d_e_l_e_t_ = ' ' "
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasPrd,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")


// Criacao do arquivo de Log
_nHdlLOG := FCreate("c:\temp\log_limp_dt_fim_depr_1.log")   
FWrite(_nHdlLOG,"O(s) registro(s) abaixo tiveram a data fim de depreciacao limpa.: " + Chr(13)+Chr(10))
FWrite(_nHdlLOG,"EMPRESAFILIAL|CBASE|ITEM|TIPO|DATA" + Chr(13)+Chr(10))			


DbSelectArea(cAliasPrd)
(cAliasPrd)->( DbGotop() )
ProcRegua( nTotReg )

While (cAliasPrd)->( !Eof() )

		DbSelectArea("SN3")
		DbGoto( (cAliasPrd)->(sn3recno) )

      IncProc("Lendo registros...")
         
      If !Empty(SN3->N3_FIMDEPR)

       	_cMenLog:= cNumEmp+"|"+SN3->N3_CBASE+"|"+SN3->N3_ITEM+"|"+SN3->N3_TIPO+"|Dt.Fim.Depr. que foi limpa: "+Dtoc(SN3->N3_FIMDEPR)+chr(10)+chr(13)   
			FWrite(_nHdlLOG,_cMenLOG)   

	      RecLock("SN3",.F.)
			SN3->N3_FIMDEPR:= CTOD(' ')
			MsUnLock()
			
		EndIf
		
		// proximo.
		DbSelectArea(cAliasPrd)		
  	   (cAliasPrd)->(DbSkip() )
		
End-While                     

//  Fecha tabela temporaria
DbSelectArea(cAliasPrd)		
(cAliasPrd)->(DbCloseArea())

// Gravacao do Log
FClose(_nHdlLOG)
If !Empty(_cMenLog)
	MsgAlert("Gerado o arquivo de LOG: " + Chr(13)+Chr(10)+"c:\temp\log_limp_dt_fim_depr.log")
EndIf


ApMsgStop("Fim do ajuste")


Return

Static Function AcMoeda3()
Local nTotReg:= 0 
Local cAlias:= GetNextAlias()
Local cQuery:= " "

cQuery:= "select count(*) as totreg from "+retSqlName("sn3")+ " "
cQuery+= "where d_e_l_e_t_ = ' ' "

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")
(cAlias)->( DbGotop() )
nTotReg:= (cAlias)->TotReg
(cAlias)->( DbCloseArea() )

DbSelectArea("SN3")
DbSetOrder(1)
DbGotop()

ProcRegua(nTotreg)

While !Eof()
		
		IncProc("Reprocessando Moeda 3")
      
		RecLock("SN3",.F.)               
		If SN3->N3_VORIG3 != (sn3->n3_vorig1/0.8287)
			SN3->N3_VORIG3:= (sn3->n3_vorig1/0.8287)
		EndIf	
		If SN3->N3_VRDACM3 != (sn3->n3_vrdacm1/0.8287)
			SN3->N3_VRDACM3:= (sn3->n3_vrdacm1/0.8287)
		EndIf	
		MsUnLock()

      DbSkip()
      
End-While      

Return



Static Function AcOutMoedas()

Local nTotReg:= 0 
Local cAlias:= GetNextAlias()
Local cAliasPrd:= GetNextAlias()
Local cQuery:= " "

cQuery:= "select count(*) as totreg from "+retSqlName("sn3")+ " "
cQuery+= "where  (n3_vorig2 + n3_txdepr2 + n3_vrdbal2 + n3_vrdmes2 + n3_vrdacm2 + n3_indice2) > 0 "
cQuery+= "or (n3_vorig4 + n3_txdepr4 + n3_vrdbal4 + n3_vrdmes4 + n3_vrdacm4 + n3_indice4) > 0 "
cQuery+= "or (n3_vorig5 + n3_txdepr5 + n3_vrdbal5 + n3_vrdmes5 + n3_vrdacm5 + n3_indice5) > 0 "
cQuery+= "and d_e_l_e_t_ = ' ' "

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAlias,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")
(cAlias)->( DbGotop() )
nTotReg:= (cAlias)->TotReg
(cAlias)->( DbCloseArea() )

//

cQuery:= "select r_e_c_n_o_ as sn3recno from "+retSqlName("sn3")+ " "
cQuery+= "where  (n3_vorig2 + n3_txdepr2 + n3_vrdbal2 + n3_vrdmes2 + n3_vrdacm2 + n3_indice2) > 0 "
cQuery+= "or (n3_vorig4 + n3_txdepr4 + n3_vrdbal4 + n3_vrdmes4 + n3_vrdacm4 + n3_indice4) > 0 "
cQuery+= "or (n3_vorig5 + n3_txdepr5 + n3_vrdbal5 + n3_vrdmes5 + n3_vrdacm5 + n3_indice5) > 0 "
cQuery+= "and d_e_l_e_t_ = ' ' "
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),cAliasPrd,.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

DbSelectArea(cAliasPrd)
(cAliasPrd)->( DbGotop() )

ProcRegua( nTotReg )

While (cAliasPrd)->( !Eof() )

		DbSelectArea("SN3")
		DbGoto( (cAliasPrd)->(sn3recno) )

      IncProc("Lendo registros...")
         
      RecLock("SN3",.F.)

      // moeda 2
      If sn3->n3_vorig2>0 ; sn3->n3_vorig2:=0 ; EndIf
		If sn3->n3_txdepr2>0 ; sn3->n3_txdepr2:=0 ; EndIf    
		If sn3->n3_vrdmes2>0 ; sn3->n3_vrdmes2:=0 ;	EndIf	
		If sn3->n3_vrdacm2>0 ; sn3->n3_vrdacm2:=0 ;	EndIf
		If sn3->n3_vrdbal2>0 ; sn3->n3_vrdbal2:=0 ;	EndIf		
		If sn3->n3_indice2>0 ; sn3->n3_indice2:=0 ; EndIf     

		// moeda 4
      If sn3->n3_vorig4>0 ; sn3->n3_vorig4:=0 ; EndIf
		If sn3->n3_txdepr4>0 ; sn3->n3_txdepr4:=0 ; EndIf    
		If sn3->n3_vrdmes4>0 ; sn3->n3_vrdmes4:=0 ; EndIf	
		If sn3->n3_vrdacm4>0 ; sn3->n3_vrdacm4:=0 ; EndIf   
		If sn3->n3_vrdbal4>0 ; sn3->n3_vrdbal4:=0 ;	EndIf				
		If sn3->n3_indice4>0 ; sn3->n3_indice4:=0 ; EndIf     		   

		// moeda 5
      If sn3->n3_vorig5>0  ; sn3->n3_vorig5:=0  ; EndIf
		If sn3->n3_txdepr5>0 ; sn3->n3_txdepr5:=0 ; EndIf    
		If sn3->n3_vrdmes5>0 ; sn3->n3_vrdmes5:=0 ;	EndIf	
		If sn3->n3_vrdacm5>0 ; sn3->n3_vrdacm5:=0 ;	EndIf
		If sn3->n3_vrdbal5>0 ; sn3->n3_vrdbal5:=0 ;	EndIf
		If sn3->n3_indice5>0 ; sn3->n3_indice5:=0 ;	EndIf     		   		
		
		MsUnLock()

		// proximo.
		DbSelectArea(cAliasPrd)		
  	   (cAliasPrd)->(DbSkip() )
		
End-While                     

//  Fecha tabela temporaria
DbSelectArea(cAliasPrd)		
(cAliasPrd)->(DbCloseArea())

ApMsgStop("Fim do ajuste")

Return

/*
*/

Static Function UpdAtivo()
             
Local nCont:= 0

DbSelectArea("SN1")
SN1->( DbSetOrder(1) )
SN1->( DbGotop() )

While SN1->( !Eof() )

	nCont++
	
	If nCont == 500
	   nCont := 0
	   ProcRegua(500)
	Else
	   IncProc("Lendo Registros...")   
	EndIf
	
	If !Empty( SN1->N1_AQUISIC )
	
		DbSelectArea("SN3")
		SN3->( DbSetOrder(1) )
		SN3->( DbSeek( FwFilial("SN3") + SN1->N1_CBASE + SN1->N1_ITEM )   )
		
		While SN3->( !Eof() ) .And. ( SN3->N3_CBASE == SN1->N1_CBASE  ) .And. ( SN3->N3_ITEM == SN1->N1_ITEM )
		
			If Empty(SN3->N3_AQUISIC)
				RecLock("SN3",.F.)
				SN3->N3_AQUISIC:= SN1->N1_AQUISIC
				MsUnLock()
			EndIF   
			     
			DbSelectArea("SN3")     
			SN3->( DbSkip() )
			
		End-While
		
	EndIf
	
	DbSelectArea("SN1")
	SN1->( DbSkip() )
	
End-While

ApMsgStop("Atualiza็ใo finalizada....")

Return

/**/

Static Function AcPenhora()

Private col := 0
Private tamcol := 0
Private colini := 0
Private coluna := {}            
Private _item:= 0
Private cFile:= "C:\ativofixo2011\PENHORA_METRO.csv"
Private nHdl := fOpen(cFile,68)
Private nTamFile := fSeek(nHdl,0,2)
Private xEmpresa, xFilial, xBase, xItem, xSituacao
Private aLOG:= {}
Private nHdlLog

// EMPRESA	FILIAL	N1_CBASE	N1_ITEM	Sit_Penhora

FSeek(nHdl,0,0)
Ft_FUse(cFile)
Ft_FGoTop()

ProcRegua(nTamFile*1000)

While !Ft_FEof()
	
	_Item := 0
	IncProc()
	
	cBuffer := ft_freadln()+";"
	
	Col := 0
	TamCol := 0
	ColIni := 0
	Coluna := {}
	
	// Seleciona a quantidade das coluna na linha e as posi็๕es iniciais e finais
	// Este comando foi setado para trabalhar com ";"
	For x := 0 to Len(cBuffer)
		If Substr(cBuffer,x,1) == ";"
			aAdd(coluna,{colini+1,tamcol-1})
			colini := x
			tamcol := 0
			tamcol ++
		ElSe
			tamcol ++
		EndIf
	Next
	
	// Busca os registros na linha atrav้s das posi็๕es da linha inicial e final, isto ้ controlado na variแvel "u"
	For u := 0 to Len(coluna)                                                                                                                                                                                                                                         
	
		If u == 1    ;xEmpresa := Strzero( Val(Substr(cBuffer,Coluna[u][1],Coluna[u][2])) , 2 )
		ElseIf u == 2;xFilial  := Strzero( Val(Substr(cBuffer,Coluna[u][1],Coluna[u][2])) , 2 )
		ElseIf u == 3;xBase    := PadR( Substr(cBuffer,Coluna[u][1],Coluna[u][2]), 10 )
		ElseIf u == 4;xItem    := Strzero( Val(Substr(cBuffer,Coluna[u][1],Coluna[u][2])) , 4 ) 
		ElseIf u == 5;xSituacao:= Substr(cBuffer,Coluna[u][1],Coluna[u][2]) 		
      	Endif
            
	Next
  
	// GRAVAวรO NA TABELA
	If Alltrim( xEmpresa ) == Subs( cNumEmp,1,2)

       DbSelectArea("SN1")
	   SN1->( DbSetOrder(1) )

	   If SN1->( !DbSeek( xFilial + xBase + xItem ) )	   
		   
		   xItem:= Right(xItem,3)          
		   SN1->( DbSeek( xFilial + xBase + xItem ) )	   		   
		   
	   EndIf
	   
	   If SN1->( Found() )
	   
	      If Empty(SN1->N1_PENHORA)
	      
        	 	RecLock("SN1",.F.) 
		        SN1->N1_PENHORA:= xSituacao
	   	        MsUnlock()

	    	   	Aadd(aLOG,xEmpresa+"|"+xFilial+"|"+xBase+"|"+xItem +"|Situacao Gravada: "+xSituacao+chr(10)+chr(13) )   	      
	    	   	
	       Else 	
			    
			    Aadd(aLOG,xEmpresa+"|"+xFilial+"|"+xBase+"|"+xItem +"|"+xSituacao+"| Situacao atual: "+SN1->N1_PENHORA+chr(10)+chr(13) )   	      	       	
			    
	   	   EndIf   
   	   
		Else
		
       		Aadd(aLOG,xEmpresa + "|" + xFilial + "|" + xBase + "|" + xItem +"|"+xSituacao+" ==> ATIVO NAO ENCONTRADO"+chr(10)+chr(13) )
       	
		EndIf
		
   EndIf

   // Proxima linha
   ft_fskip()

EndDo                                                                         

If Len(aLOG) > 0 
		nHdlLOG := FCreate("C:\LOG_SN1.LOG")   
		If Len(aLOG) > 0            
		     	cMenLog := ""
			FWrite(nHdlLOG,"O(s) registro(s) abaixo nao foram encontrados na tabela SN1.: " + Chr(13)+Chr(10))
			AEval(aLOG,{|x| cMenLog += " - " + x + Chr(13)+Chr(10)})
			FWrite(nHdlLOG,cMenLOG)                                  
		EndIf
		FClose(nHdlLOG)
		MsgAlert("Gerado o arquivo de LOG: " + Chr(13)+Chr(10)+"C:\LOG_SN1.LOG")
EndIf

MsgInfo("Opera็ใo Concluํda !")

Return

Static Function Acerta1()


Local aArea := GetArea()
Local cBase := "0000000000"
Local cItem := "0000"
Local cDescri := "TESTE"
Local nQtd := 1
Local cChapa := "00000"
Local cPatrim := "N"
Local cGrupo := "01"
Local dAquisic := dDataBase 
Local dIndDepr := RetDinDepr(dDataBase)
Local cDescric := "Teste 01"
Local nQtd := 2
Local cChapa := "00000"
Local cPatrim := "N"
Local cTipo := "01"
Local cHistor := "TESTE "
Local cContab := "1101010001"
Local cCusto := "TESTE"
Local nValor := 1000
Local nTaxa := 10
Local nTamBase := TamSX3("N3_CBASE")[1]
Local nTamChapa := TamSX3("N3_CBASE")[1]
Local cGrupo := "0001" 
Local aParam := {}

Local aCab := {}
Local aItens := {}

 Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

aCab := {}
AAdd(aCab,{"N1_CBASE" , cBase ,NIL})
AAdd(aCab,{"N1_ITEM" , cItem ,NIL})
AAdd(aCab,{"N1_AQUISIC", dDataBase ,NIL})
AAdd(aCab,{"N1_DESCRIC", cDescric ,NIL})
AAdd(aCab,{"N1_QUANTD" , nQtd ,NIL})
AAdd(aCab,{"N1_CHAPA" , cChapa ,NIL})
AAdd(aCab,{"N1_PATRIM" , cPatrim ,NIL})
AAdd(aCab,{"N1_GRUPO" , cGrupo ,NIL})

 

aItens := {}
//-- Preenche itens

 
AAdd(aItens,{; 
{"N3_CBASE" , cBase ,NIL},;
{"N3_ITEM" , cItem ,NIL},;
{"N3_TIPO" , cTipo ,NIL},;
{"N3_BAIXA" , "0" ,NIL},;
{"N3_HISTOR" , cHistor ,NIL},;
{"N3_CCONTAB" , cContab ,NIL},;
{"N3_CUSTBEM" , cCusto ,NIL},;
{"N3_CDEPREC" , cContab ,NIL},;
{"N3_CDESP" , cContab ,NIL},;
{"N3_CCORREC" , cContab ,NIL},;
{"N3_CCUSTO" , cCusto ,NIL},;
{"N3_DINDEPR" , dIndDepr ,NIL},;
{"N3_VORIG1" , nValor ,NIL},;
{"N3_TXDEPR1" , nTaxa ,NIL},;
{"N3_VORIG2" , nValor ,NIL},;
{"N3_TXDEPR2" , nTaxa ,NIL},;
{"N3_VORIG3" , nValor ,NIL},;
{"N3_TXDEPR3" , nTaxa ,NIL},;
{"N3_VORIG4" , nValor ,NIL},;
{"N3_TXDEPR4" , nTaxa ,NIL},;
{"N3_VORIG5" , nValor ,NIL},;
{"N3_TXDEPR5" , nTaxa ,NIL};
})

Begin Transaction

MSExecAuto({|x,y,z| Atfa012(x,y,z)},aCab,aItens,3,aParam)
 If lMsErroAuto 

MostraErro()
DisarmTransaction()
 Endif
 End Transaction

RestArea(aArea)

Return 