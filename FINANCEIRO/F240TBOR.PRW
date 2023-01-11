#include "rwmake.ch"        
#include "colors.ch"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F240TBOR  ºAutor  ³Wagner Farias       º Data ³  28/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE NA GRAVAÇÃO DO BORDERO QUE TRATA O CODIGO DE BARRAS SE  º±±
±±º          ³ DIGITADO OU LEITORA OTICA NO MODELO DE PAGAMENTO TIPO 30   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F240TBOR()
	Local   _aAr   :=  getarea()
	Private _nTitCon:=0 // 0=Nao identificado;1=Titulo;2=Concessionaria

//	VerPa()	
	RecLock("SE2",.f.)                  
    SE2->E2_XPLACA := cNumBor
	MsUnLock()      
	fkcommit()
	
	_cLinhaDig:=space(54)
	DbSelectArea("SE2")
	If( M->CMODPGTO $ "13;19;35;91;31;30" .and. M->CPORT240 $ "001;033;041;104;237;341;399;745" )                          	
		_cCodBar := se2->e2_codbar
	
		@ 000,000 TO 225,350 DIALOG oDlg1 TITLE "Entrada de Codigo de Barras do Titulo"	
		@ 005,010 SAY "Titulo:"
	 	@ 005,045 SAY ALLTRIM(se2->e2_prefixo)+"-"+ALLTRIM(se2->e2_num)+"-"+ALLTRIM(se2->e2_parcela)+"-"+ALLTRIM(se2->e2_tipo) COLOR CLR_HBLUE	
		@ 015,010 SAY "Fornecedor:"
		@ 015,045 SAY ALLTRIM(se2->e2_nomfor) COLOR CLR_HBLUE	
		@ 025,010 SAY "Valor R$:"
		@ 025,045 SAY (SE2->E2_SALDO + SE2->E2_ACRESC) - (SE2->E2_DECRESC) size 115 picture "@e 9,999,999.99" COLOR CLR_HBLUE		
		@ 040,010 SAY "Passe o documento pela leitora: "
		@ 050,010 GET _cCodBar SIZE 160,50  Valid vazio().or.ECODBAR(_cCodBar,SE2->E2_SALDO) WHEN .F.		
		@ 065,010 say "Ou informe abaixo a linha digitavel:"            
		@ 075,010 get _cLinhaDig size 160,15 valid _fLinhaDig()		
		@ 095,100 BMPBUTTON TYPE 01 ACTION (if(GravaBar(),Close(oDlg1),nil))
		@ 095,145 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
		ACTIVATE DIALOG oDlg1 CENTER
	    
	    Restarea(_aAr)
		Return(.t.)        
	Else
	    Restarea(_aAr)
	    Return(.t.)
	EndIf          
	Restarea(_aAr)
Return 

*****************************************************************************
Static Function GravaBar() 
	_cCodBar := ConvLD(_cLinhaDig)
	_lReturn:=.f.
	if ECODBAR(_cCodBar,SE2->E2_SALDO)
	   RecLock("SE2",.f.)
	       SE2->E2_CODBAR := _cCodBar
	   MsUnlock()
	   _lReturn:=.t.
	endif   
Return _lReturn
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ECODBAR  ³ Autor ³ ROBERTO R.MEZZALIRA   ³ Data ³ 19.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ EXECBLOCK PARA GATILHO PARA VALICAO DE VALOR DO TITULO     ³±± 
±±³          ³ DO CONTAS A PAGAR x CODIGO DE BARRAS                       ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                                                              
Static Function ECODBAR(CodBar,nVLRTIT)
	Local _aArea   := GetArea()
	Local _cBco    := Substr(CODBAR,1,3) //IDENTIFICA O BANCO DO CODIGO DE BARRA
	Local _nVlr    := 0  // RETORNA O VALOR DO CODIGO DE BARRA
	Local _cVlr    := "" 
	Local _cVlrtit := ""
	Local __msg	   := ""	                      
	//////////////////////////////////////////////////////////////////////
	//| Conforme padrão FeBraBan para Títulos normais - Linha Digitavel
	//////////////////////////////////////////////////////////////////////
	Local mv_ini   := GetNewPar("MV_XBOLINI",10) 
	Local mv_fim   := GetNewPar("MV_XBOLFIM",10)
	lOCAL mv_valid := GetNewPar("MV_XBOLVAL",.t.)
	
	Private _Lok   	 := .F. 
	
	_nTitCon:=0 // 0=Nao identificado;1=Titulo;2=Concessionaria	
	If left(codbar,1)=="8"
	   _nTitCon:=2
	   _nVlr := ( Val( Substr(CODBAR,6,10) )/100 )
	Else
	   _nTitCon:=1
	   /////////////////////////////////////////////////////////////////// 
	   //| Alteração efetuada no dia 01/09/2015 conforme solicitação 
	   //| da Priscila  
	   //| Autor  | Denis Dias
	   //| Empresa| Altideias
	   //| Seguindo o padrão FeBraBan
	   //| Posição do valor para Boletos Normais - 38 a 47
	   ///////////////////////////////////////////////////////////////////
	   _nVlr := ( Val( Substr(CODBAR,mv_ini,mv_fim) )/100 )	
	Endif         		                                                                    	
    _cVlr    := Padr(alltrim(Transform((_nVlr),"@E 999,999,999.99")),18)  		 
	_cVlrtit := Padr(alltrim(Transform(SE2->E2_SALDO,"@E 99,999,999.99")),18)        		
		
   	If( _cVlrtit <> _cVlr  .And. CODBAR <> " " )
    	If MsgYesNo("Valor do Boleto R$ "+_cVlr+CHR(13)+" difere do Titulo R$ "+_cVlrtit+CHR(13)+CHR(13)+"Deseja prosseguir com a operação ?"+CHR(13))    	
    		_Lok   := .T.
    	Else
    		_Lok   := .F.
    	EndIf
	Else                                                                                                                                                                         				
		__msg := "Leitura dinâmica - Código de Barras"+chr(13)+chr(10)+"Valor do Título R$ "+_cVlr+chr(13)+chr(10)+"Valor do Boleto R$ "+_cVlrtit
		If( mv_valid )
			Aviso("Código de Barras - (Status - Válido)"+" "+RetField('SM0',1,cEmpAnt+cFilAnt,'M0_FILIAL'),__msg+(chr(13)+chr(10))+"Processamento efetuado em: Data: "+(Dtoc(dDataBase)+" | Hora: "+substr(time(),1,5)),{"Ok"},2,,,,,,2)
		EndIf
    	_Lok   := .T. 
	EndIf       	
	
	Restarea(_aArea)
Return(_Lok)

*----------------------------------------------------------
* Ricardo Luiz da Rocha - 24/04/2006
* Monta o codigo de barras a partir da linha digitavel
*----------------------------------------------------------
Static Function _fLinhaDig()
	_cCodBar := ConvLD(_cLinhaDig)	
Return( .t. )


//////////////////////////////////////////////////////////////////////////
//Conversao para Codigo de Barras - todos os Bancos
//Denis Dias de Almeida
//15/09/2015
//////////////////////////////////////////////////////////////////////////
Static Function ConvLD(_cLinhaDig)
	SetPrvt("cStr")
	cStr := ltrim(rtrim(_cLinhaDig))
	
	if valtype(_cLinhaDig) == nil .OR. empty(_cLinhaDig)
		cStr := ""
	else
		cStr := IF(len(cStr)<44,cStr+REPL("0",47-len(cStr)),cStr)
	endIf
	
	do case
		case len(cStr) == 47
			cStr := substr(cStr,1,4)+substr(cStr,33,15)+substr(cStr,5,5)+substr(cStr,11,10)+substr(cStr,22,10)
		case LEN(cStr) == 48
			cStr := substr(cStr,1,11)+substr(cStr,13,11)+substr(cStr,25,11)+substr(cStr,37,11)
		otherwise
			cStr := cStr+space(48-len(cStr))
	endcase
Return(cStr)

***********************
Static Function VerPA()
***********************

Select SE5
Do while .t.
	seek 'x'  
	if eof()
		exit
	endif
	RecLock("SE5",.f.)
	replace e5_filial with xFilial("SE5")
	MsUnLock()
Enddo

