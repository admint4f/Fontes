#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIMPATIVO ºAutor  ³Microsiga           º Data ³  08/23/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Deleta registros das tabelas SN1, SN2, SN3 e SN4.           º±±
±±º          ³Prepara a base para ser importada do afixcode.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LimpAtivo() 
//U_LimpAtivo
Local oGet1
Local dGet1 := Date()
Local oGroup1
Local oGroup2
Local oSay1
Local oSButton1
Local oSButton2
Local lNFC:= .f.
Static oDlg

If ApMsgYesNo("Deseja realizar exclusão apenas das NFC's ?")
	lNFC:= .t.
EndIF

DEFINE MSDIALOG oDlg TITLE "Limpeza Ativo Fixo" FROM 000, 000  TO 200, 385 COLORS 0, 16777215 PIXEL

@ 007, 004 GROUP oGroup2 TO 055, 181 OF oDlg COLOR 0, 16777215 PIXEL
@ 058, 004 GROUP oGroup1 TO 089, 142 PROMPT "Data Base para exclusão dos Ativos" OF oDlg COLOR 0, 16777215 PIXEL
DEFINE SBUTTON oSButton1 FROM 076, 154 TYPE 02 OF oDlg ENABLE ACTION Eval( {|| oDlg:End() } )
DEFINE SBUTTON oSButton2 FROM 061, 154 TYPE 01 OF oDlg ENABLE ACTION Eval( { || Processa( { || OkGeraTxt(dGet1,lNFC)},"Eliminando Registros..." ), oDlg:End() } ) WHEN !Empty(dGet1)
@ 013, 007 SAY oSay1 PROMPT "Este programa tem por objetivo limpar as tabelas do Ativo Fixo (SN1,SN2,SN3 e SN4) cuja data de aquisição seja menor que o parametro informado. Digite abaixo a data de referencia para exclusão dos ativos. Todos os itens com data de aquisição MENOS do que " SIZE 170, 038 OF oDlg COLORS 0, 16777215 PIXEL
@ 072, 009 MSGET oGet1 VAR dGet1 SIZE 086, 010 OF oDlg VALID !Empty(dGet1) COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return

// SN1 UNIQ -> N1_FILIAL+N1_CBASE+N1_ITEM
// SN3 UNIQ -> N3_FILIAL, N3_CBASE, N3_ITEM, N3_TIPO, N3_BAIXA, N3_SEQ
// N3_FILIAL, N3_CBASE , N3_ITEM, N3_TIPO, N3_HISTOR, N3_CCONTAB, E

Static Function OkGeraTxt(dGet1, lNFC)
Local cQuery:= ''
Local nTotalRegistros:= 0
Local lSimNao:= .f.

If lNFC
	lSimNao:= ApMsgYESNo("Você escolheu eliminar as NFC anteriores à "+dtos(dGet1)+chr(13)+chr(10)+"APENAS NFC's SERÃO EXCLUÍDAS!"+chr(13)+"Confirma essa operação ?")
Else
	lSimNao:= ApMsgYesNo( "Confirma execução da rotina ?"+chr(13)+"Data Ref.: "+dtos(dGet1) )
EndIF

If lSimNao
	
	// Apenas para contar os registros...
	cQuery:= "select count(*) totregn1 "
	cQuery+= "from "+retsqlname("sn1")+ " "
	cQuery+= "where n1_aquisic < '"+dtos(dGet1)+"' and d_e_l_e_t_ = ' '"
	If lNFC
		cQuery+= " and n1_cbase like 'NFC%' "
	EndIF
	
	
	
	MsAguarde( {|| dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"TOTREG",.F.,.T.) } , "Totalizando registros...")
	nTotalRegistros:= TOTREG->totregn1
	TOTREG->( DbCloseArea() )
	
	cQuery:= ""
	cQuery:= "select n1_filial,n1_cbase,n1_item,r_e_c_n_o_ as sn1recno "
	cQuery+= "from "+retsqlname("sn1")+ " "
	cQuery+= "where n1_aquisic < '"+dtos(dGet1)+"' and d_e_l_e_t_ = ' ' "
	If lNFC
		cQuery+= " and n1_cbase like 'NFC%' "
	EndIF
	MsAguarde( {|| dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"TRBTEMP",.F.,.T.) }, "Consultando Banco de Dados...")
	
	ProcRegua(nTotalRegistros)
	TRBTEMP->( dbGotop() )
	While TRBTEMP->( !Eof() )
		
		IncProc("Processando registros...")
		
		// Busca SN2
		// N2_FILIAL+N2_CBASE+N2_ITEM+N2_TIPO+N2_SEQUENC
		DbSelectArea("SN2")
		DbSetOrder(1)
		While SN2->( DbSeek( TRBTEMP->N1_FILIAL + TRBTEMP->N1_CBASE + TRBTEMP->N1_ITEM ) )
			RecLock("SN2",.F.)
			SN2->(DbDelete())
			MsUnLock()
		End-While
		
		// Busca SN3
		// N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ
		DbSelectArea("SN3")
		DbSetOrder(1)
		While SN3->( DbSeek( TRBTEMP->N1_FILIAL + TRBTEMP->N1_CBASE + TRBTEMP->N1_ITEM ) )
			
			RecLock("SN3",.F.)
			SN3->( DbDelete() )
			MsUnLock()
		End-While
		
		// Busca SN4
		// N4_FILIAL+N4_CBASE+N4_ITEM+N4_TIPO+DTOS(N4_DATA)+N4_OCORR+N4_SEQ
		DbSelectArea("SN4")
		DbSetOrder(1)
		While SN4->( DbSeek( TRBTEMP->N1_FILIAL + TRBTEMP->N1_CBASE + TRBTEMP->N1_ITEM ) )
			RecLock("SN4",.F.)
			SN4->( DbDelete() )
			MsUnLock()
		End-While
		
		// Por fim, elimina o proprio SN1
		DbSelectArea("SN1")
		DbGoto(TRBTEMP->sn1recno) // posiciona no registro
		RecLock("SN1",.F.)
		SN1->( DbDelete() )
		MsUnLock()
		
		DbSelectArea("TRBTEMP")
		TRBTEMP->( DbSkip() )
		
	End-While
	
	TRBTEMP->( DbCloseArea() )
	ApMsgInfo("Rotina de Limpeza Finalizada... ", "INFO")
EndIf

Return


/*
ProcRegua( 4*Len(aEmpresas) )

For x:= 1 to Len(aEmpresas)

IncProc("Eliminando SN2...")
// Elimina o SN2 abaixo de 01/08/2010
//cQuery:= "delete from sn2"+aEmpresas[x]+"0 "
cQuery:= "update sn2"+aEmpresas[x]+"0 set D_E_L_E_T_ = '*' "
cQuery+= "where n2_filial||n2_cbase||n2_item in "
cQuery+= "( select n1_filial||n1_cbase||n1_item "
cQuery+= "from sn1"+aEmpresas[x]+"0 "
cQuery+= "where n1_aquisic < '20100801' and d_e_l_e_t_ = '' ) "
cQuery+= "and d_e_l_e_t_ = ' '"
If (TcSqlExec(cQuery) < 0)
MsgStop("TCSQLError() " + TCSQLError())
EndIf
Inkey(2)


IncProc("Eliminando SN3...")
// Elimina o SN3 abaixo de 01/08/2010
cQuery:= ''

//cQuery:= "delete from sn3"+aEmpresas[x]+"0 "
cQuery:= "update sn3"+aEmpresas[x]+"0 set D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
cQuery+= " where n3_filial||n3_cbase||n3_item in "
cQuery+= "( select n1_filial||n1_cbase||n1_item "
cQuery+= "from sn1"+aEmpresas[x]+"0 "
cQuery+= "where n1_aquisic < '20100801' and d_e_l_e_t_ = '' ) "
cQuery+= "and d_e_l_e_t_ = ' '"
If (TcSqlExec(cQuery) < 0)
MsgStop("TCSQLError() " + TCSQLError())
EndIf
Inkey(2)

IncProc("Eliminando SN4...")
// Elimina o SN4 abaixo de 01/08/2010
cQuery:= ''
//cQuery:= "delete from sn4"+aEmpresas[x]+"0 "
cQuery:= "update sn4"+aEmpresas[x]+"0 set D_E_L_E_T_ = '*' "
cQuery+= "where n4_filial||n4_cbase||n4_item in "
cQuery+= "( select n1_filial||n1_cbase||n1_item "
cQuery+= "	from sn1"+aEmpresas[x]+"0 "
cQuery+= "	where n1_aquisic < '20100801' and d_e_l_e_t_ = '' ) "
cQuery+= "and d_e_l_e_t_ = ' '"
If (TcSqlExec(cQuery) < 0)
MsgStop("TCSQLError() " + TCSQLError())
EndIf
Inkey(2)

If ApMsgYesNo("Deseja Eliminar o SN1 ? ")

IncProc("Eliminando SN1")
// Elimina o SN1
cQuery:= ''
//cQuery:= "delete from sn1"+aEmpresas[x]+"0 "
cQuery:= "update sn1"+aEmpresas[x]+"0 set D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_ "
cQuery+= "where n1_aquisic < '20100801' and d_e_l_e_t_ = ''"
If (TcSqlExec(cQuery) < 0)
MsgStop("TCSQLError() " + TCSQLError())
EndIf
Inkey(2)

EndIf

Next
EndIf

Return
*/
