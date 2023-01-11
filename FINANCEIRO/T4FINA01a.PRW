#include "fileio.ch"
#include "totvs.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "RwMake.Ch"
#INCLUDE "TopConn.Ch"
#DEFINE ENTER Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณT4FINA01a บAutor  ณLuiz Eduardo        บ Data ณ  02/03/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para importa็ใo da planilha (reembolso)               ฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function T4FIN01a(cArqE,cOrigemE,nLinTitE,lTela)


// SX5 - Tabela 05 - criar tipo de tํtulo LOL
// SX6 - criar parametro MV_XUSRLOL

Local bOk        := {||lOk:=.T.,oDlg:End()}
Local bCancel    := {||lOk:=.F.,oDlg:End()}
Local lOk        := .F.
Local nLin       := 20
Local nCol1      := 15
Local nCol2      := nCol1+30
Local cMsg       := ""
Local oDlg
Local oArq
Local oOrigem
Local oMacro
Local aButtons := {}
Local _aStru	:= {}
Local n
Local _w

Default lTela := .T.

Private cVar       	:= ""
Private cArq       	:= ""//If(ValType(cArqE)=="C",cArqE,"")
Private cArqMacro  	:= "XLS2DBF.XLA"
Private cTemp   	:= GetTempPath() //pega caminho do temp do client
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private aArquivos  := {}
Private aRet       := {}
Private lUsr	   := .f.
Private aParamBox   := {}
Private aPerg       := {}
Private aOpcoes     := {}
Private nOpcoes
Private _aTit       := {}
Private _nn         := 0
Private _nAlert     := 0

Static lSair := .t.
Static _nRegistro := 0

dbSelectArea("SX5")
seek "  NK"
do while !eof() .and. X5_TABELA="NK"
	if substr(x5_chave,3,1)='A'
		aAdd(aOpcoes,{left(x5_chave,2)+" - "+trim(x5_descri)})
	endif
	skip
Enddo

cOpcoes := '{'
For n:=1 to len(aOpcoes)
			cOpcoes += '"'+aOpcoes[n][1]+iif(n<len(aOpcoes),'",','')
Next n
cOpcoes += '"}'


aAdd(aParamBox,{2,"Escolha o evento (SX5-NK) ",1 ,&cOpcoes    ,80,"",.F.})  //02
aAdd(aParamBox,{1,"Qtd.Erros MSexecauto      "   	  ,1,"99","","","",10,.F.}) // Tipo num้rico
aAdd(aParamBox,{1,"Data de Vencimento        "        ,ctod(""),"","","","",0,.T.})


If !ParamBox(aParamBox, "Parametros Importa็ใo CASHLESS...", aPerg)
	Return Nil
EndIf

If ValType(aPerg[1]) == "C"
	cVar := left(aPerg[1],2)
else
	cVar := left(aOpcoes[(aPerg[1])][1],2)
endif

_nAlert := aPerg[2]
IF SELECT("TMP") # 0
	TMP->(DBCLOSEAREA( ))
ENDIF

IF SELECT("ERRMSG") # 0
	ERRMSG->(DBCLOSEAREA( ))
ENDIF

IF SELECT("LOLLA") # 0
	LOLLA->(DBCLOSEAREA( ))
ENDIF

// Cria e Abre arquivo temporแrio
_aStru := {}
aadd( _aStru , {'dataerro'  , 'C' , 10 , 00 } )
aadd( _aStru , {'usuario'  	, 'C' , 30 , 00 } )
aadd( _aStru , {'mensagem'  , 'C' , 150 , 00 } )
aadd( _aStru , {'pulseira'  , 'C' , 25 , 00 } )

_cErr := CriaTrab(_aStru, .T.)
dbUseArea(.T.,__LocalDriver,_cErr,"ERRMSG",.F.)

// Formato do Arquivo deve ser : PRODUTO - SALDO

cArq       += Space(20-(Len(cArq)))
cOrigem    += Space(99-(Len(cOrigem)))

aAdd(aButtons,{"RELATORIO",{|| 	U_fXGetArq() },"Arquivos"})

If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))
	
	if !lSair
		Return
	endif
	
	Define MsDialog oDlg Title 'Integra็ใo de Excel' From 7,10 To 20,50 OF oMainWnd
	
	
	nLin -= 12
	@ nLin,nCol1  Say      'Estrutura excel deve ter colunas conforme acordado entre os departamentos'  Of oDlg Pixel
	nLin += 12
	
	@ nLin,nCol1  Say      'Arquivo :'                                Of oDlg Pixel
	@ nLin,nCol2  MsGet    oArq   Var cArq            Size 60,09 Of oDlg Pixel
	
	nLin += 15
	
	@ nLin,nCol1  Say      'Caminho do arquivo :'                     Of oDlg Pixel
	nLin += 10
	@ nLin,nCol1  MsGet    oOrigem Var cOrigem            Size 130,09 Of oDlg Pixel
	
	nLin += 15
	
	//	@ nLin,nCol1  Say      'Nome da Macro :'                          Of oDlg Pixel
	//	nLin += 10
	//	@ nLin,nCol1  MsGet    oMacro  Var cArqMacro When .F. Size 130,09 Of oDlg Pixel
	
	
	Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel,.F.,aButtons) Centered
	
Else
	lOk := .T.
EndIf

If lOk
	cMsg := validaCpos()
	aAdd(aArquivos, cArq)
	If	Empty(cMsg)
		LjMsgRun(OemToAnsi("importando Excel. Por favor aguarde!"),,{||fIntArq()} )
	Else
		MsgStop(cMSg)
		Return
	EndIf
EndIf

// Grava็ใo dos dados da Planilha
//IF SELECT("TMP") # 0
//	TMP->(DBCLOSEAREA( ))
//ENDIF
//	if file(cTemp+".dtc")
//		dbUseArea(.T.,__LocalDriver,cTemp,"TMP",.F.)  // Reabre arquivo temporแrio
//	else
//		Return
//	endif


Processa( {|| aRet:= GravaFin(aPerg[3]) } ,"Aguarde, gravando registros ... ")
ConOut("Terminou grava็ใo do arquivo SE2 -"+Time())

Return .T.

*-------------------------*
Static Function GravaFin(dvencto)
*-------------------------*
Local _w:=0

dbSelectArea("SX5")
seek "  NK"+cVar
Do while !eof() .and. cVar=left(X5_CHAVE,2)
	if substr(X5_CHAVE,3,1)='B'
		cPrf := trim(X5_DESCRI)
	endif
	if substr(X5_CHAVE,3,1)='C'
		cEmp := trim(X5_DESCRI)
	endif
	if substr(X5_CHAVE,3,1)='D'
		cAprov := trim(X5_DESCRI)
	endif
	if substr(X5_CHAVE,3,1)='E'
		cHist := trim(X5_DESCRI)
	endif
	if substr(X5_CHAVE,3,1)='F'
		cCC := trim(X5_DESCRI)
	endif

	if substr(X5_CHAVE,3,1)='G'
		cEPEP := trim(X5_DESCRI)
	endif

	if substr(X5_CHAVE,3,1)='H'
		_cNat := trim(X5_DESCRI)
	endif

	if substr(X5_CHAVE,3,1)='I'
		_cCtb := trim(X5_DESCRI)
	endif

	if substr(X5_CHAVE,3,1)='J'
		_cTipo := trim(X5_DESCRI)
	endif

	skip
Enddo

if file("lolla2020.dtc")
	cTempLolla := CriaTrab(nil,.f.)
	dbUseArea(.T.,__LocalDriver,"lolla2020.dtc","LOLLA",.F.)  // Reabre arquivo temporแrio
	Index on val(usid) to &cTempLolla
endiF


//
If TMP->(!EOF())
	
	TMP->(dbGoTop())
	
	While ! TMP->(Eof())
		AADD(_aTit, {TMP->nome       , TMP->sobrenome  , TMP->uid  , TMP->parc,  TMP->tel,      TMP->email, TMP->munic,  TMP->cep        , TMP->cpf  , TMP->banco, TMP->agencia,  TMP->digag, TMP->conta,  TMP->Digito     , TMP->valor})
		dBSelectarea("TMP")
		dBSkip()
	ENDDO
	

   // LEN ATST

	For  _w:=1 to Len(_aTit)
// rrCC		
		IncProc("Gravando registros "+AllTrim(str(_W,6))+" de "+AllTrim(Str(len(_aTit),6)))
		
		//		cCpf := tmp->CPF // Buscar CPF da Planilha
		cCpf := replicate("0",11-len(alltrim(_aTit[_w,9] )))+alltrim(_aTit[_w,9])
		Select SA2
		dbSetOrder(3)
		Seek xFilial()+cCpf
		// Cadastra fornecedor
		CadForn(_aTIT,_w,cCpf)
		If Empty(TRIM( _aTit[_w,1]))  .or. Empty(TRIM( _aTit[_w,9])) .or.  Empty(TRIM( _aTit[_w,13]))
			loop
		endif
		if sa2->(eof())
			loop
		Endif
		
		Select SE2
		dbSetOrder(6)
		Do case
			Case trim(SM0->M0_CODIGO) $ "20"
				//				cPrf := "LOL"
			Case trim(SM0->M0_CODIGO) $ "32"
				//				cPrf := "POP"
			Case trim(SM0->M0_CODIGO) $ "08"
				//				cPrf := "GLS"
		endCase
		Seek xFilial()+sa2->(a2_cod+a2_loja)+cPrf
		//		Seek xFilial()+sa2->(a2_cod+a2_loja)+"LOL"
		lExiste := .f.
		//		do while !eof() .and. sa2->(a2_cod+a2_loja)+"LOL" = SE2->(e2_fornece+e2_loja+e2_prefixo)
		do while !eof() .and. sa2->(a2_cod+a2_loja)+cPrf = SE2->(e2_fornece+e2_loja+e2_prefixo)
			if year(e2_emissao)=year(date())
				lExiste := .t.
				exit
			endif
			skip
		enddo
		if !eof()  .AND. val( _aTit[_w,8]) <>0 .and. lExiste  // Grava erro - tํtulo jแ existe para esse CPF ou valor menor que permitido
			RecLock("ERRMSG",.t.)
			ERRMSG->DATAERRO := dtoc(dDataBase)
			ERRMSG->USUARIO  := substr(cUsuario,7,15) + " " +time()
			ERRMSG->MENSAGEM := "Jแ existe tํtulo cadastrado para esse CPF "+alltrim(cCpf)+" ,nใo serแ importado"
			ERRMSG->PULSEIRA := alltrim(_aTit[_w,3])
			ERRMSG->(MSUNLOCK())
			loop
		endif
		
		Select SE2
		dbSetOrder(1)
		Seek xFilial()+"LOL"+alltrim(_aTit[_w,3])+alltrim( _aTit[_w,4])
		if (alltrim(SE2->E2_NUM)==alltrim(_aTit[_w,3]) .OR. empty(_aTit[_w,8]))  .AND. val(_aTit[_w,8])<>0 .and. year(e2_emissao)=year(date())// Grava erro - tํtulo jแ existe para essa pulseira
			RecLock("ERRMSG",.t.)
			ERRMSG->DATAERRO := dtoc(dDataBase)
			ERRMSG->USUARIO  := substr(cUsuario,7,15) + " " +time()
			ERRMSG->MENSAGEM := "Pulseira jแ cadastrada ou CPF em branco, nใo serแ importada"
			ERRMSG->PULSEIRA := alltrim(tmp->uid)
			ERRMSG->(MSUNLOCK())
			loop
		endif
		
		if file("lolla2020.dtc")
			Select Lolla
			seek val(_aTit[_w,3])
			if eof() .or. saldo1<_aTit[_w,13]
				RecLock("ERRMSG",.t.)
				ERRMSG->DATAERRO := dtoc(dDataBase)
				ERRMSG->USUARIO  := substr(cUsuario,7,15) + " " +time()
				ERRMSG->MENSAGEM := "Pulseira "+_aTit[_w,3]+" sem saldo suficiente para reembolso - verificar"
				ERRMSG->PULSEIRA := alltrim(_aTit[_w,3])
				ERRMSG->(MSUNLOCK())
				loop
			endif
			Select SE2
		endif
		
		if empty(cCpf)  // Grava erro - CPF nใo preenchido
			RecLock("ERRMSG",.t.)
			ERRMSG->DATAERRO := dtoc(dDataBase)
			ERRMSG->USUARIO  := substr(cUsuario,7,15) + " " +time()
			ERRMSG->MENSAGEM := "Pulseira "+_aTit[_w,3]+" sem CPF informado na planilha, nใo serแ importada"
			ERRMSG->PULSEIRA := alltrim(_aTit[_w,3])
			ERRMSG->(MSUNLOCK())
			loop
		endif
		
		dVencRea := DataValida(dVencto)
	//	Do while .T.
			//				if day(dVencRea)=5 .or. day(dVencRea)=15 .or. day(dVencRea)=25
			//					dVencRea := dVencRea + 1
			//				endif
	//		if dow(dVencRea)=5  // Mudan็a de regra em 09/07/2020 pagamentos เs 5as feiras
	//			exit
	//		endif
	//		dVencRea := DataValida(dVencRea + 1)
	//	enddo
		//		aAdd(aVetorSE2,{"E2_BCOPAG"	,tmp->Banco			  													,Nil})
		//		aAdd(aVetorSE2,{"E2_AGPAG"	,tmp->Agencia															,Nil})
		//		aAdd(aVetorSE2,{"E2_CTAPAG"	,tmp->Conta																,Nil})
		
		aVetorSE2 := {}
		aAdd(aVetorSE2,{"E2_FILIAL"		,xFilial("SE2")														,Nil})
		aAdd(aVetorSE2,{"E2_PREFIXO"	,cPrf																,Nil})
		aAdd(aVetorSE2,{"E2_NUM"		,_aTit[_W,3]           												,Nil})
		aAdd(aVetorSE2,{"E2_PARCELA"	,_aTit[_W,4] 				 										,Nil})
		aAdd(aVetorSE2,{"E2_TIPO"		,cPrf																,Nil})
	//    aAdd(aVetorSE2,{"E2_TIPO"		,_cTipo																,Nil})
		
       	aAdd(aVetorSE2,{"E2_NUMPC" 		,cPrf														    	,Nil})
		aAdd(aVetorSE2,{"E2_NUMSPA"		,trim(_aTit[_W,3]+_aTit[_W,4])												,Nil})
		aAdd(aVetorSE2,{"E2_NATUREZ"	,_cNat  															,Nil})
		// GSF aAdd(aVetorSE2,{"E2_NATUREZ"	,'ISS'															,Nil})
		aAdd(aVetorSE2,{"E2_FORNECE"	,sa2->a2_cod														,Nil})
		aAdd(aVetorSE2,{"E2_LOJA"		,sa2->a2_LOJA														,Nil})
		aAdd(aVetorSE2,{"E2_EMISSAO"	,dDataBase															,Nil})
		aAdd(aVetorSE2,{"E2_VENCTO"		,dVencto															,Nil})
		aAdd(aVetorSE2,{"E2_VENCREA"	,dVencRea															,Nil})
		aAdd(aVetorSE2,{"E2_VALOR"		,_aTit[_W,15] 															,Nil})
		aAdd(aVetorSE2,{"E2_MOEDA"		,1																	,Nil})
		aAdd(aVetorSE2,{"E2_TXMOEDA"	,1																	,Nil})
		aAdd(aVetorSE2,{"E2_CONTAD"	    ,_cCtb   	     													,Nil})
		aAdd(aVetorSE2,{"E2_CCONTAB"	,_cCtb   				    										,Nil})
		aAdd(aVetorSE2,{"E2_CCUSTO"		,cCC																,Nil})
		aAdd(aVetorSE2,{"E2_APROVA"		,cAprov															    ,Nil})
		aAdd(aVetorSE2,{"E2_ITEM"		,cEpep                                                      		,Nil})
		aAdd(aVetorSE2,{"E2_HIST"		,sa2->(A2_COD+A2_LOJA)+' '+_aTit[_W,3]+cHist						,Nil})
		aAdd(aVetorSE2,{"E2_VLCRUZ"		,_aTit[_W,15]															,Nil})
		
		if file("lolla2020.dtc")
			Select Lolla
			seek val(tmp->uid)
			if !eof()
				RecLock("LOLLA",.t.)
				LOLLA->SALDO1 := SALDO1 - _aTit[_w,15]
				MSUnlock()
			endif
		endif

		lMsErroAuto := .f.
		MsExecAuto({|x,y| Fina050(x,y)},aVetorSE2,3)
		 _lOk  := !lMsErroAuto 

		If lMsErroAuto
		    _cErro:=""

			_nn++
		    IF _nn<=_nAlert
		       _cErro:=Left(MostraErro(),150)
			ENDIF
			
			
			RecLock("ERRMSG",.t.)
			ERRMSG->DATAERRO := dtoc(dDataBase)
			ERRMSG->USUARIO  := substr(cUsuario,7,15) + " " +time()
			ERRMSG->MENSAGEM := "Pulseira "+_aTit[_w,3]+"-ERRO MSEXECAUTO "+_cErro
			ERRMSG->PULSEIRA := alltrim(_aTit[_w,3])
			SE2->(RollBackSXE())
		Else
			_lOk	:= .T.
		Endif
		
		
	NEXT
	
	If _lOk
		cObs1 :=""
		if ERRMSG->(RecCount( )) > 0
			cObs1 := "Ocorreram erros na importa็ใo, favor verificar planilha gerada"
		endif
		//		Aviso(	"Processo de importa็ใo finalizado "  + CRLF  ,{"OK"})
		//		Aviso(	"Titulos a pagar gerados com sucesso","Para a Solicita็ใo de Pagamento Antecipado/Avulso " + CRLF + ;
		//		"Titulo(s) gerado(s) : " + CRLF + "Prefixo \ Numero \ Parcela. " + CRLF  ,{"OK"})
	EndIf
EndIf

ImprimeErr()

lSair := .f.
cArq := "Sair"

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIntArq   บAutor  ณLuiz Eduardo        บ Data ณ 02/03/2017  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma das rotinas referentes a integra็ใo                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 					                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fIntArq()
Local lConv     := .F.
Local lCabcOK	:= .F.
local cCliAnt	:= ""
local aCabec	:= {}
Local aItens	:= {}
local aLinha	:= {}
Local nItem		:= 0
local lErrPrd	:= .F.
Local lPrim		:= .T.
Local cAntPedC	:= ""
Local _nR       := 0 
Private cDescErr:= ""
Private lErro	:= .F.
Private lMsErroAuto	:= .F.
Private lDescErr:= .F.
Private cBrwMsg	:= ""
Private nProc	:= 0


// Cria e Abre arquivo temporแrio
_aStru := {}
aadd( _aStru , {'Nome'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Sobrenome'  , 'C' , 20 , 00 } )
aadd( _aStru , {'UID'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Parc'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Tel'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Email'  , 'C' , 20 , 00 } )
aadd( _aStru , {'munic'  , 'C' , 20 , 00 } )
aadd( _aStru , {'cep'  , 'C' , 20 , 00 } )
aadd( _aStru , {'CPF'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Banco'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Agencia'  , 'C' , 20 , 00 } )
aadd( _aStru , {'DigAg'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Conta'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Digito'  , 'C' , 20 , 00 } )
aadd( _aStru , {'Valor'  , 'N' , 12 , 02 } )

_cTemp := CriaTrab(_aStru, .T.)
dbUseArea(.T.,__LocalDriver,_cTemp,"TMP",.F.)
//DbUseArea(.T.,"DBFCDX",_cTemp,"TMP",.F.,.F.)
//Index on Produto to _cTemp
// tst

//converte arquivos xls para csv copiando para a pasta temp
//MsAguarde( {|| ConOut("Come็ou conversใo do arquivo "+cArq+ " - "+Time()),;
//lConv := fXconvArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )
If lConv .or. 1=1
	//carrega do xls no array
	ConOut("Terminou conversใo do arquivo "+cArq+ " - "+Time())
	ConOut("Come็ou carregamento do arquivo "+cArq+ " - "+Time())
	Processa( {|| aRet:= XCargaArray(AllTrim(cArq)) } ,;
	"Aguarde, carregando planilha... Pode demorar")
	ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
	
	cNome      := ASCAN(aRet[2,1],'Nome')
	cUID       := ASCAN(aRet[2,1],'UID')
	cTel       := ASCAN(aRet[2,1],'Tel')
	cCPF       := ASCAN(aRet[2,1],'CPF')
	cBanco     := ASCAN(aRet[2,1],'Banco')
	cAgencia   := ASCAN(aRet[2,1],'Agencia')
	cDigAg     := ASCAN(aRet[2,1],'DigAg')
	cConta     := ASCAN(aRet[2,1],'Conta')
	cDigito    := ASCAN(aRet[2,1],'Digito')
	cValor     := ASCAN(aRet[2,1],'Valor')
	cEmail     := ASCAN(aRet[2,1],'Email')
	
	
	if cNome =0 .or. cUID  =0 .or. cTel  =0 .or. cEmail  =0  .or. cCPF  =0 .or. cBanco=0 .or. cAgencia=0  .or. cDigAg=0 .or. cConta=0 .or. cDigito=0 .or. cValor=0
		Aviso("Help", 	"Verifique as colunas do arquivo a ser importado, o cabe็alho deverแ obedecer ao padrใo definido entre as equipes" ,{"Ok"},1)
		return
	endif
	//	nPosPrd	:= ASCAN(aRet[2,1], "PRODUTO")
	//	nPosSld	:= ASCAN(aRet[2,1], "SALDO")
	
	//	if nPosPrd=0 .or. nPosSld=0
	//			MsgBox ("Verifique o arquivo a ser importado, deverแ ter apenas duas colunas . Na c้lula A1 deverแ constar a palavra PRODUTO e B1 com SALDO (mai๚sculas) ","Escolha","YESNO")
	//			return
	//	endif  //
	
	
	
	dbSelectArea("TMP")
	For _nR:=1 to len(aRet[1])
		TMP->(RecLock("TMP",.T.))
		tmp->Nome      := aRet[1,_nR,cNome]
		tmp->SobreNome := aRet[1,_nR,cNome]
		tmp->UID     := right(strzero(val(aRet[1,_nR,cUID]),10),9)
		tmp->Parc    := LEFT(Alltrim( aRet[1,_nR,cUID]),1)
		tmp->Tel     := aRet[1,_nR,cTel]
		tmp->Email   := aRet[1,_nR,cEmail]
		tmp->CPF     := aRet[1,_nR,cCPF]
		tmp->Banco   := aRet[1,_nR,cBanco]
		tmp->Agencia := aRet[1,_nR,cAgencia]
		tmp->Conta   := aRet[1,_nR,cConta]
		tmp->Digito  := aRet[1,_nR,cDigito]
		if at(",",aRet[1,_nR,cValor])<>0
			tmp->Valor   := val(aRet[1,_nR,cValor])+val(substr(aRet[1,_nR,cValor],at(",",aRet[1,_nR,cValor])+1,2))/100 //val(aRet[1,_nR,cValor])
		else
			tmp->Valor   := val(aRet[1,_nR,cValor])
		endif
		MsUnLock()
	Next _nR
EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfconvArqs บAutor  ณLuiz Eduardo       บ Data ณ 06/03/2017   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma que converte os arquivos .xls para .csv            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 					                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fXconvArqs(aArqs)

Local oExcelApp
Local cNomeXLS  := ""
Local cFile     := ""
Local cExtensao := ""
Local i         := 1
Local j         := 1
Local aExtensao := {}

private cPar:= "savechanges:=False"

//if MsgBox ("Processo 2","Escolha","YESNO")
//	x:=1
//endif

cOrigem := AllTrim(cOrigem)

//Verifica se o caminho termina com "\"
If !Right(cOrigem,1) $ "\"
	cOrigem := AllTrim(cOrigem)+"\"
EndIf


//loop em todos arquivos que serใo convertidos
For i := 1 To Len(aArqs)
	
	If !"." $ AllTrim(aArqs[i])
		//passa por aqui para verifica se a extensใo do arquivo ้ .xls ou .xlsx
		aExtensao := Directory(cOrigem+AllTrim(aArqs[i])+".*")
		For j := 1 To Len(aExtensao)
			If "XLS" $ Upper(aExtensao[j][1])
				cExtensao := SubStr(aExtensao[j][1],Rat(".",aExtensao[j][1]),Len(aExtensao[j][1])+1-Rat(".",aExtensao[j][1]))
				Exit
			EndIf
		Next j
	EndIf
	//recebe o nome do arquivo corrente
	cNomeXLS := AllTrim(aArqs[i])
	//	cFile    := cOrigem+cNomeXLS+cExtensao
	cFile    := cOrigem+cNomeXLS+".csv"
	If !File(cFile)
		MsgInfo("O arquivo "+cFile+" nใo foi encontrado!" ,"Arquivo")
		Return .F.
	EndIf
	
	//verifica se existe o arquivo na pasta temporaria e apaga
	If File(cTemp+cNomeXLS+cExtensao)
		fErase(cTemp+cNomeXLS+cExtensao)
	EndIf
	
	//Copia o arquivo XLS para o Temporario para ser executado
	If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.)
		MsgInfo("Problemas na copia do arquivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
		Return .F.
	EndIf
	
	//apaga macro da pasta temporแria se existir
	If File(cTemp+cArqMacro)
		fErase(cTemp+cArqMacro)
	EndIf
	
	//Copia o arquivo XLA para o Temporario para ser executado
	If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.)
		MsgInfo("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
		Return .F.
	EndIf
	
	//Exclui o arquivo antigo (se existir)
	If File(cTemp+cNomeXLS+".csv")
		fErase(cTemp+cNomeXLS+".csv")
	EndIf
	
	//Inicializa o objeto para executar a macro
	oExcelApp := MsExcel():New()
	//define qual o caminho da macro a ser executada
	oExcelApp:WorkBooks:Open(cTemp+cArqMacro)
	//executa a macro passando como parametro da macro o caminho e o nome do excel corrente
	oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cNomeXLS)
	//fecha a macro sem salvar
	//cPar:= "savechanges:=False"
	oExcelApp:WorkBooks:Close()
	//sai do arquivo e destr๓i o objeto
	oExcelApp:Quit()
	oExcelApp:Destroy()
	
	//Exclui o Arquivo excel da temp
	fErase(cTemp+cNomeXLS+cExtensao)
	fErase(cTemp+cArqMacro) //Exclui a Macro no diretorio temporario
	//
Next i
//
Return .T.

/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parโmetros  : cArq - nome do arquivo que serแ usado
Autor       : Kanaใm L. R. Rodrigues
Data/Hora   : 24/05/2012
*/
*-------------------------*
Static Function XCargaArray(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 1
Local nTotLin := 0
Local aDados  := {}
Local aDados1 := {}
//Local cFile   := cTemp + cArq + ".csv"
Local cFile   := cOrigem + cArq + ".csv"
Local nHandle := 0
Local aCabecM := {}
Local _nReg   := 0

//abre o arquivo csv gerado na temp
nHandle := Ft_Fuse(cFile)
If nHandle == -1
	Return aDados
EndIf
Ft_FGoTop()
nLinTot := FT_FLastRec()-1
ProcRegua(nLinTot)
//Pula as linhas de cabe็alho
/*
While nLinTit > 0 .AND. !Ft_FEof()
Ft_FSkip()
nLinTit--
EndDo
*/
cLinha := Ft_FReadLn()    //transforma as aspas duplas em aspas simples
cLinha := StrTran(cLinha,'"',"'")
cLinha := '{"'+cLinha+'"}'
//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
cLinha := StrTran(cLinha,';','","')
aAdd(aCabecM, &cLinha)
For _nREG:= 1 To Len(aCabecM[1])
	aCabecM[1,_nREG]:=Alltrim(aCabecM[1,_nREG])
Next _nREG
Ft_FSkip()
//percorre todas linhas do arquivo csv
Do While !Ft_FEof()
	//exibe a linha a ser lida
	IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
	nLin++
	//le a linha
	cLinha := Ft_FReadLn()
	//verifica se a linha estแ em branco, se estiver pula
	If Empty(AllTrim(StrTran(cLinha,';','')))
		Ft_FSkip()
		Loop
	EndIf
	//transforma as aspas duplas em aspas simples
	
	cLinha := StrTran(cLinha,'"',"'")
	
	If substr(cLinha,1,1)==";"
		Exit
	Endif
	cLinha := '{"'+cLinha+'"}'
	//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
	cLinha := StrTran(cLinha,';','","')
	aAdd(aDados , &cLinha)
	aAdd(aDados1, cLinha)
	
	//passa para a pr๓xima linha
	FT_FSkip()
	//
EndDo

//libera o arquivo CSV
FT_FUse()

//Exclui o arquivo csv
If File(cFile)
	//	FErase(cFile)
EndIf

Return {aDados,aCabecM}

*-------------------------*
Static Function validaCpos()
*-------------------------*
Local cMsg := ""

If Empty(cArq)
	cMsg += "Campo Arquivo deve ser preenchido!"+ENTER
EndIf

If Empty(cOrigem)
	cMsg += "Campo Caminho do arquivo deve ser preenchido!"+ENTER
EndIf

If Empty(cArqMacro)
	cMsg += "Campo Nome da Macro deve ser preenchido!"
EndIf


Return cMsg


User Function fXGetArq

Local cMask		:="*.*"
Local cArqAt   	:= cGetFile(cMask, '')
Local cFileEDI	:= RIGHT(cArqAt,  LEN(cArqAt) -RAT("\", cArqAt))
Local cCamEDI	:= left(cArqAt,RAT("\", cArqAt))
cFileEDI:=LEFT(cFileEDI,  RAT(".", cFileEDI)-1)
cArq:=cFileEDI
cOrigem:=cCamEDI
//if MsgBox ("Processo 4","Escolha","YESNO")
//	x:=1
//endif

Return cFileEDI

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "แ้ํ๓๚"+"มษอำฺ"
Local cCircu := "โ๊๎๔๛"+"ยสฮิÛ"
Local cTrema := "ไ๋๏๖ü"+"ฤหฯึÜ"
Local cCrase := "เ่์๒๙"+"ภศฬาู"
Local cTio   := "ใ๕รี"
Local cCecid := "็ว"
Local cMaior := "&lt;"
Local cMenor := "&gt;"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString
	cString := strTran( cString, cMaior, "" )
EndIf
If cMenor$ cString
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|'
		cString:=StrTran(cString,cChar,".")
	Endif
Next nX
Return cString

*************************
Static Function	CadForn(_aTit,nn,cCpf)
*************************
If 1==2    //.AND. Empty(TRIM(tmp->Nome)+" "+trim(tmp->sobrenome)) .Or. Empty(tmp->cpf) .Or. Empty(tmp->banco) .Or. Empty(tmp->conta) .Or. "."$tmp->cpf .Or. "-"$tmp->cpf
	// Aviso("Atencao!", "Existem campos obrigat๓rios em branco. Por favor preenche-los!" ,{"Ok"},1)
	if "."$tmp->cpf .Or. "-"$tmp->cpf
		cObs := "O campo CPF s๓ poderแ conter n๚meros "
	else
		cObs := "Campo(s) nใo preenchido(s)"
	endif
	if Empty(TRIM(tmp->Nome)+" "+trim(tmp->sobrenome))
		cObs += " Nome"
	endif
	if Empty(tmp->cpf)
		cObs += " CPF"
	endif
	if Empty(tmp->banco)
		cObs += " Banco"
	endif
	if Empty(tmp->conta)
	endi	f
	RecLock("ERRMSG",.t.)
	ERRMSG->DATAERRO := dtoc(dDataBase)
	ERRMSG->USUARIO  := substr(cUsuario,7,15)
	ERRMSG->MENSAGEM := cObs
	ERRMSG->PULSEIRA := alltrim(tmp->uid)
	MsUnLock()
Else
	if sa2->(eof())      // Verifica pr๓xima numera็ใo come็amdo com W
		_cIniFor	       := SOMAIT(GetMv("ES_CINIFOR"))
		_cCodFor	:= _cInIFOr
		//ALERT(_CINIFOR)
		_cLojFor    := "01"
		PUTMV("ES_CINIFOR",_cINIFOR)
	else
		_cLojFor	:= sa2->a2_loja
		_cCodFor	:= sa2->a2_cod
	endif
	_cCContab	:= PadR("2101010002",TAMSX3("A2_CONTA")[1])
	
	
	If SA2->(RecLock("SA2", eof()))
		SA2->A2_FILIAL	:= xFilial("SA2")
		SA2->A2_TIPO	:= "F"
		//GS		SA2->A2_SBTIPO	:= "1"
		SA2->A2_COD		:= _cCodFor
		SA2->A2_LOJA	:= _cLojFor
		SA2->A2_NOME	:= upper(ALLTRIM(_aTit[nn,1]))   //+" "+ALLtrim(_aTit[nn,2]))
		SA2->A2_NREDUZ	:= upper(ALLtrim(_aTit[nn,2]))
		SA2->A2_TEL		:= upper(ALLTRIM(_aTit[nn,5]))
		SA2->A2_EMAIL	:= upper(ALLTRIM(_aTit[nn,6]))

		//		SA2->A2_EST		:= ""//tmp->Estado
		//		SA2->A2_MUN		:= ""//tmp->Municipio
		SA2->A2_CEP		:= upper(_aTit[nn,8])
		SA2->A2_MUN		:= upper(_aTit[nn,7])
		SA2->A2_RECISS	:= 'S'
		SA2->A2_SIMPNAC	:= 'N'
		SA2->A2_CGC		:= cCPF   //alltrim(_aTit[nn,9])
		SA2->A2_BANCO	:= alltrim(_aTit[nn,10])
		SA2->A2_AGENCIA	:= alltrim(_aTit[nn,11])
		SA2->A2_NUMCON	:= alltrim(_aTit[nn,13])
		SA2->A2_DVCONTA := alltrim(_aTit[nn,14])
		SA2->A2_CONTA	:= _cCContab
    	SA2->A2_INSCRM  := SA2->A2_MSBLQL
		SA2->A2_MSBLQL  := ""
		//	SA2->A2_MSBLQL	:= SubStr(_cBloq,1,1)
		SA2->(MsUnlock())
		//
	EndIf
//    dBSelectarea("SA2")
//    Select SA2
//	dbSetOrder(1)
//	Seek xFilial()+cCpf
		

EndIf
//
Return

Static Function ImprimeErr()

Select ERRMSG
nTotReg := reccount()
if nTotReg =0
	return
endif
dbgotop()

//Cria o arquivo CSV
cFile 	:= AllTrim(cGetFile(,"Diret๓rio Destino",,,,GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY))
cFile 	+= "\Msg_erro" + DtoS(dDataBase) + "_" + StrTran(Time(),":") + ".CSV"
nHdl	:= FCreate(cFile)

If nHdl <= 0
	MsgAlert("Aten็ใo, nใo foi possํvel criar o arquivo no diret๓rio especificado.")
	Return(Nil)
EndIf

//Monta o cabecalho
aCabec	:= {}
cLinhaCSV	:= ""


AAdd(aCabec,{'Data Erro','C','dataerro'})
AAdd(aCabec,{'usuario','C','usuario'})
AAdd(aCabec,{'Mensagem de erro','C','mensagem'})
AAdd(aCabec,{'Pulseira','C','pulseira'})

For i := 1 To Len(aCabec)
	cLinhaCSV += aCabec[i,1] + ";"
Next i
FWrite(nHdl,cLinhaCSV+ENTER)

ProcRegua(nTotReg)

Select ERRMSG

//Geracao do arquivo CSV
While ERRMSG->(!Eof())
	IncProc()
	cLinhaCSV := ""
	
	For i := 1 To Len(aCabec)
		If aCabec[i,2] == "C"
			cLinhaCSV += ERRMSG->&(aCabec[i,3])+";"
		ElseIf aCabec[i,2] == "D"
			cLinhaCSV += DToC(SToD(ERRMSG->&(aCabec[i,3])))+";"
		ElseIf aCabec[i,2] == "N"
			cLinhaCSV += Transform(ERRMSG->&(aCabec[i,3]),"@E 999,999,999.99")+";"
		EndIf
	Next i
	
	FWrite(nHdl,cLinhaCSV+ENTER)
	ERRMSG->(dbSkip())
EndDo

FClose(nHdl)
oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cFile)
oExcel:SetVisible(.T.)

dbSelectArea("ERRMSG")
DBCLOSEAREA()

//RestArea(aAreaSM0)
// ....

Return
