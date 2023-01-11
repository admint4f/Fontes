//#INCLUDE "ATFA200.CH"
#Include "Protheus.ch"
#Include "topconn.ch"
#define _EOL chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o      ³ T4FBLQATF ³ Autor ³ Gilberto A Oliveira   ³ Data ³ 29/01/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄeÄÄÄ´±±
±±³Adaptado de ³ ATFA200   ³ Autor ³ alice Y Yamamoto      ³ Data ³ 13/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o   ³ Programa de para efetuar o Bloqueio de depreciacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe     ³ ATFA200()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso        ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function T4FBLQATF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aSays:={}, aButtons:={}
Local nOpca := 0
Local cPerg:= PADR("T4FAF2",10)
Private cCadastro := OemtoAnsi("Bloqueio de Deprecia‡„o") 

dbSelectArea("SN1")
dbSetOrder(1 )
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas:                            ³
//³ mv_par01 - Do codigo                                          ³
//³ mv_par02 - Ate o codigo                                       ³
//³ mv_par03 - Grupo de                                           ³
//³ mv_par04 - Grupo ate                                          ³
//³ mv_par05 - Data Limite                                        ³
//³ mv_par06 - Bloqueia/Desbloqueia                               ³
//³ mv_par07 - Do Item                                        	  ³
//³ mv_par08 - At‚ o Item                                    	  ³
//³ mv_par09 - Do Centro Custo                                	  ³
//³ mv_par10 - At‚ Centro Custo                               	  ³
//³ mv_par11 - Filial de                                      	  ³
//³ mv_par12 - Filial ate                                     	  ³
//³ mv_par13 - Capacidade de                                  	  ³
//³ mv_par14 - Capacidade ate                                 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PutSx1(cPerg,"01",	"Do código ?"          ,"Do código ?"                 ,"Do código ?"          ,"mv_ch1",	"C",10,	0,	0,	"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02",	"Ate o código ?"       ,"Ate o código ?"              ,"Ate o código ?"       ,"mv_ch2",	"C",10,	0,	0,	"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03",	"Grupo de ?"           ,"Grupo de ?"                  ,"Grupo de ?"           ,"mv_ch3",	"C",4,	0,	0,	"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04",	"Grupo até ?"          ,"Grupo até ?"                 ,"Grupo até?"           ,"mv_ch4",	"C",4,	0,	0,	"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05",	"Data Limite ?"        ,"Data Limite ?"               ,"Data Limite ?"        ,"mv_ch5",	"D",8,	0,	0,	"G","","","","","mv_par05","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"06",	"Bloqueia/Desbloqueia" ,"Bloqueia/Desbloqueia"        ,"Bloqueia/Desbloqueia" ,"mv_ch6",	"C",02, 0,  0,	"C","","","","","mv_par06","Bloqueia"         ,"","","","Desbloqueia" ,"","","","","","","","","","","",{"Escolha se deseja Bloquear ou Desbloquear",'o Bem.'},{},{})
PutSx1(cPerg,"07",	"Do Item ?"            ,"Do Item ?"                   ,"Do Item ?"            ,"mv_ch7",	"C",4,	0,	0,	"G","","","","","mv_par07","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"08",	"Até o Item ?"         ,"Até o Item ?"                ,"Até o Item ?"         ,"mv_ch8",	"C",4,	0,	0,	"G","","","","","mv_par08","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"09",	"Do Centro de Custo ?" ,"Do Centro de Custo ?"        ,"Do Centro de Custo ?" ,"mv_ch9",	"C",20,	0,	0,	"G","","","","","mv_par09","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"10",	"Até Centro de Custo ?","Até Centro de Custo ?"       ,"Até Centro de Custo ?","mv_chA",	"C",20,	0,	0,	"G","","","","","mv_par10","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"11",	"Filial de ?"          ,"Filial de ?"                 ,"Filial de ?"          ,"mv_chB",	"C",02,	0,	0,	"G","","","","","mv_par11","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"12",	"Filial até ?"         ,"Filial até ?"                ,"Filial até ?"         ,"mv_chC",	"C",02,	0,	0,	"G","","","","","mv_par12","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"13",	"Capacidade de ?"      ,"Capacidade de ?"             ,"Capacidade de ?"      ,"mv_chD",	"C",20,	0,	0,	"G","","","","","mv_par13","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"14",	"Capacidade até ?"     ,"Capacidade até ?"            ,"Capacidade até ?"     ,"mv_chE",	"C",20,	0,	0,	"G","","","","","mv_par14","","","","","","","","","","","","","","","","")
*/
//---------------------------------------------------------------------------
// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
//----------------------------------------------------------------- { Inicio }

//_criaPerg(cPerg)

// { Fim } -------------------------------------------------------------------

Pergunte(cPerg,.F.)

AADD(aSays,OemToAnsi( "Este programa tem o objetivo de bloquear ou desbloquear " ) )
AADD(aSays,OemToAnsi( "o c lculo da deprecia‡„o de alguns bens de acordo com   ") ) 
AADD(aSays,OemToAnsi( " os parƒmetros escolhidos." ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o log de processamento                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( aButtons )

AADD(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T. ) } } )
AADD(aButtons, { 1,.T.,{|| nOpca := 1,	IF( AtfOK(),FechaBatch(),nOpca := 0 ) }} )
AADD(aButtons, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSays, aButtons,,,365 )

If nOpca == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("INICIO")

	Processa({ |lEnd| T4FBlqProc() })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("FIM")

Endif	

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AFA200Proc³ Autor ³ Alice Yamamoto	    ³ Data ³13/08/98  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca os bens que ter„o bloqueio de deprecia‡„o            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ AFA200Proc            				   				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ 															  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function T4FBlqProc()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as perguntas selecionadas:                            ³
//³ mv_par01 - Do codigo                                          ³
//³ mv_par02 - Ate o codigo                                       ³
//³ mv_par03 - Grupo de                                           ³
//³ mv_par04 - Grupo ate                                          ³
//³ mv_par05 - Data Limite                                        ³
//³ mv_par06 - Bloqueia/Desbloqueia                               ³
//³ mv_par07 - Do Item                                        	  ³
//³ mv_par08 - At‚ o Item                                    	  ³
//³ mv_par09 - Do Centro Custo                                	  ³
//³ mv_par10 - At‚ Centro Custo                               	  ³
//³ mv_par11 - Filial de                                      	  ³
//³ mv_par12 - Filial ate                                     	  ³
//³ mv_par13 - Capacidade de                                  	  ³
//³ mv_par14 - Capacidade ate                                 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nTotReg:= 0
Local cQuery:= ''

cQuery:= "SELECT COUNT(*) AS TOTREG "+_EOL
cQuery+= "FROM "+RetSqlName("SN1")+" SN1 "+_EOL
cQuery+= "WHERE N1_FILIAL >= '"+MV_PAR11+"' AND N1_FILIAL <= '"+MV_PAR12+"' AND "+_EOL
cQuery+= "N1_CBASE >= '"+MV_PAR01+"' AND N1_CBASE <= '"+MV_PAR02+"' AND "+_EOL
cQuery+= "N1_ITEM >= '"+MV_PAR07+"' AND N1_ITEM <= '"+MV_PAR08+"' AND "+_EOL
cQuery+= "N1_GRUPO >= '"+MV_PAR03+"' AND N1_ITEM <= '"+MV_PAR04+"' AND "+_EOL
cQuery+= "N1_X_CAPAC >= '"+MV_PAR13+"' AND N1_X_CAPAC <= '"+MV_PAR14+"' AND "+_EOL
cQuery+= "D_E_L_E_T_ = ''"+_EOL
cQuery+= "ORDER BY N1_FILIAL, N1_CBASE, N1_ITEM"+_EOL
cQuery:= ChangeQuery(cQuery)

If SELECT("TOTREG") > 0 
	TOTREG->( DbCloseArea() )   
EndIf	
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"TOTREG",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")
TOTREG->( DbGotop() )

nTotReg:= TOTREG->TOTREG
TOTREG->( DbCloseArea() )

cQuery:= ''
cQuery:= "SELECT SN1.R_E_C_N_O_ AS N1RECNO "+_EOL
cQuery+= "FROM "+RetSqlName("SN1")+" SN1 "+_EOL
cQuery+= "WHERE N1_FILIAL >= '"+MV_PAR11+"' AND N1_FILIAL <= '"+MV_PAR12+"' AND "+_EOL
cQuery+= "N1_CBASE >= '"+MV_PAR01+"' AND N1_CBASE <= '"+MV_PAR02+"' AND "+_EOL
cQuery+= "N1_ITEM >= '"+MV_PAR07+"' AND N1_ITEM <= '"+MV_PAR08+"' AND "+_EOL
cQuery+= "N1_GRUPO >= '"+MV_PAR03+"' AND N1_ITEM <= '"+MV_PAR04+"' AND "+_EOL
cQuery+= "N1_X_CAPAC >= '"+MV_PAR13+"' AND N1_X_CAPAC <= '"+MV_PAR14+"' AND "+_EOL
cQuery+= "D_E_L_E_T_ = ''"+_EOL
cQuery+= "ORDER BY N1_FILIAL, N1_CBASE, N1_ITEM"+_EOL
cQuery:= ChangeQuery(cQuery)
If Select("SN1BLQ") > 0 
	SN1BLQ->( DbCloseArea() )   
EndIf     
MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"SN1BLQ",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")
SN1BLQ->( DbGotop() )

ProcRegua( nTotReg )
While SN1BLQ->( !Eof()  )

	dbSelectArea("SN1")
	dbSetOrder(1)
	dbGoto( SN1BLQ->N1RECNO )

	// dbSeek(xFilial("SN1")+mv_par01+mv_par07,.T.)


	/*While !Eof() .And. xFilial("SN1") == SN1->N1_FILIAL .And. SN1->N1_CBASE <= mv_par02*/

	INCPROC()
	
	/*
	If SN1->N1_ITEM < MV_PAR07 .Or. SN1->N1_ITEM > mv_par08
		dbSkip()
		Loop
	Endif
	
	If SN1->N1_GRUPO < mv_par03 .or. SN1->N1_GRUPO > mv_par04 .OR. !Empty(SN1->N1_BAIXA)
		dbSkip()
		loop
	EndIf
    */
	If SN3->(!MsSeek(xFilial("SN3")+SN1->(N1_CBASE+N1_ITEM)+"01"))
		SN3->(MsSeek(xFilial("SN3")+SN1->(N1_CBASE+N1_ITEM)+"03"))
	Endif	
	
	If SN3->(!Found()) .Or. (SN3->N3_CCUSTO >= mv_par09 .And. SN3->N3_CCUSTO <= mv_par10)


		
		If mv_par06 == 1   //Bloqueia a deprecia‡„o
//			ProcLogAtu("DETALHE","Bem "+SN1->N1_CBASE+"/"+SN1->N1_ITEM+" Bloqueado.")		
			Reclock("SN1",.F.)
			SN1->N1_DTBLOQ := mv_par05
			msUnlock()
		EndIf                                      
		
		If mv_par06 == 2   //Bloqueia a deprecia‡„o
//			ProcLogAtu("DETALHE","Bem "+SN1->N1_CBASE+"/"+SN1->N1_ITEM+" Desbloqueado.")				
			Reclock("SN1",.F.)
			SN1->N1_DTBLOQ := CTOD("  \  \  ")
			MsUnlock()
		EndIf	                                                                    
//	Else	
//		ProcLogAtu("ERRO","Bem não possui itens (SN3) ou C.Custo fora dos parametros.")				
	EndIf
	
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para tratamento de registro que altera bloqueios e desbloqueios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//If ExistBlock("AT200AN1")
	//  ExecBlock("AT200AN1",.F.,.F.)
	//Endif

	dbSelectArea("SN1BLQ")
	dbSkip()

EndDo
ApMsgStop("Fim")
SN1BLQ->( DbCloseArea() )   

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AtfOk    ³ Autor ³ Alice Y. Yamamoto     ³ Data ³ 19.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Mensagem e confirmacao do processamento                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AtfOk(void)                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function AtfOk()
Return(.T.)         



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ _criaPerg³ Autor ³ Willian Ap. Carvalho  ³ Data ³ 29.09.17 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Perguntas da rotina.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ _criaPerg(cPerg)                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _criaPerg(cPerg)

//---------------------------------------------------------------------------
// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
//----------------------------------------------------------------- { Inicio }
/*
DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek(cPerg + "01",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Do Codigo          ?"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 10
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par01"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "02",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Até o Codigo       ?"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 10
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par02"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "03",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Grupo de           ?"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4 
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par03"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "04",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Grupo Até          ?"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par04"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "05",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Data Limite        ?"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par05"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "06",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Bloqueia/Desbloq.  ?"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_GSC     := "C"
	SX1->X1_VAR01   := "Mv_Par06"  
	SX1->X1_DEF01   := "Bloqueia"
	SX1->X1_DEF02   := "Desbloqueia"
	MsUnLock()
EndIf 

If !DbSeek(cPerg + "07",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Do Item            ?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4 
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par07"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "08",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Até o Item         ?"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 4 
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par08"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "09",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Do Centro de custo ?"
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 20
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par09"    
	SX1->X1_F3		:= "CTT"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "10",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Até Centro de custo?"
	SX1->X1_VARIAVL := "mv_chA"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 20
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par10"
	SX1->X1_F3		:= "CTT"
	MsUnLock()
EndIf
              
If !DbSeek(cPerg + "11",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "11"
	SX1->X1_PERGUNT := "Filial de          ?"
	SX1->X1_VARIAVL := "mv_chB"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par11"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "12",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "12"
	SX1->X1_PERGUNT := "Filial Ate         ?"
	SX1->X1_VARIAVL := "mv_chC"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par12"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "13",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "13"
	SX1->X1_PERGUNT := "Capacidade de      ?"
	SX1->X1_VARIAVL := "mv_chD"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 20
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par13"
	MsUnLock()
EndIf

If !DbSeek(cPerg + "14",.f.)
	RecLock("SX1",.t.)
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "14"
	SX1->X1_PERGUNT := "Capacidade Ate     ?"
	SX1->X1_VARIAVL := "mv_chE"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 20
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "Mv_Par14"
	MsUnLock()
EndIf
*/
//{ Fim } -------------------------------------------------------------------

Return

