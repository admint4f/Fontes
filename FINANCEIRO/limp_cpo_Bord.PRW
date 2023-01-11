#include "rwmake.ch"        
#include "colors.ch"
#INCLUDE "TOPCONN.CH"
#Include "Protheus.ch"

#DEFINE CRLF (chr(13)+chr(10))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Limp_cpo_bord ºAutor ³Luiz Eduardo     º Data ³  15/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Limpa campo E2_XPLACA para permitir que insira novamente   º±±
±±º          ³ no borderô de pagamentos									  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Limp_cpo_bord()
	Local   _aAr   :=  getarea()
	Private _nTitCon:=0 // 0=Nao identificado;1=Titulo;2=Concessionaria

		cPref := space(3)
		cNum  := space(9)
		cParc := space(1)
		cForn := space(6)
		cLoja := space(2)

		@ 010,010 TO 230,350 DIALOG oDlg1 TITLE "Informe número do Titulo"

		@ 005,010 SAY "Titulo:" pixel
	 	@ 005,025 GET cPref  Size 020,030 F3 "SE2PFS" Valid ValidTit() picture "@!"
	 	@ 005,060 GET cNum   Size 040,030 F3 "SE2PFS" Valid ValidTit() picture "@!" 
	 	@ 005,110 GET cParc  Size 010,030 F3 "SE2PFS" Valid ValidTit() picture "@!" 
		@ 35,005 SAY "Fornecedor" pixel
		@ 035,045 GET cForn Size 040,030 F3 "SA2" Valid ValidForn() picture "@!"
		@ 035,090 GET cLoja Size 010,030 F3 "SA2" Valid ValidForn() picture "@!"

		@ 085,100 BMPBUTTON TYPE 01 ACTION (if(Limpcpo(),Close(oDlg1),nil))
		@ 085,145 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
		ACTIVATE DIALOG oDlg1 CENTER

/*
DEFINE DIALOG oDlg1 TITLE "Informe número do Titulo"  FROM 20, 20 TO 225,310 PIXEL 

	@ 05,05 SAY "Título" PIXEL
	 	@ 005,025 MSGET cPref  Size 020,030 F3 "SE2PFS" Valid ValidTit() 
	 	@ 005,060 MSGET cNum   Size 020,030 F3 "SE2PFS" Valid ValidTit() 
	 	@ 005,110 MSGET cParc  Size 020,030 F3 "SE2PFS" Valid ValidTit() 
	@ 35,005 SAY "Fornecedor" PIXEL
		@ 035,045 GET cForn Size 020,030 F3 "SA2" Valid ValidForn()
		@ 035,090 GET cLoja Size 020,030 F3 "SA2" Valid ValidForn()

		@ 085,100 BMPBUTTON TYPE 01 ACTION (if(Limpcpo(),Close(oDlg1),nil))
		@ 085,145 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
		ACTIVATE DIALOG oDlg1 CENTER
*/
//	DEFINE SBUTTON FROM 85,75  TYPE 1 ACTION (if(Limpcpo(),Close(oDlg1),nil)) ENABLE OF oDlg1
//	DEFINE SBUTTON FROM 85,105 TYPE 2 ACTION { || lRet := .F., oDlg1:End() } ENABLE OF oDlg1

//ACTIVATE MSDIALOG oDlg1 CENTERED //ON INIT ( IIf( Type( "lUsaLeitor" ) == "L" .AND. lUsaLeitor, LeitorFoco( nHdlLeitor, .T. ), NIL ) )


/*		@ 090,042 TO 360,500 DIALOG oDlg1 TITLE "Informe número do Titulo"	

		@ 005,010 SAY "Titulo:"
	 	@ 005,045 GET cPref  Size 020,030 F3 "SE2" Valid ValidTit()
	 	@ 005,090 GET cNum   Size 020,030 F3 "SE2" Valid ValidTit()
	 	@ 005,140 GET cParc  Size 020,030 F3 "SE2" Valid ValidTit()
		@ 025,010 SAY "Fornecedor:"
		@ 035,045 GET cForn Size 020,030 F3 "SA2" Valid ValidForn()
		@ 035,090 GET cLoja Size 020,030 F3 "SA2" Valid ValidForn()
		@ 085,100 BMPBUTTON TYPE 01 ACTION (if(Limpcpo(),Close(oDlg1),nil))
		@ 085,145 BMPBUTTON TYPE 02 ACTION Close(oDlg1)
		ACTIVATE DIALOG oDlg1 CENTER
*/	    
	    Restarea(_aAr)
		Return(.t.)        

Return 

*****************************************************************************
Static Function Limpcpo() 

Select SE2
dbSetOrder(6)
Seek xFilial()+cForn+cLoja+cPref+cNum+cParc
if SE2->E2_XPLACA = " "  .and. !eof()
//	Aviso("Título pronto para ser incluído no borderô",{"Ok"},2,,,,,,2)
	AVISO("Título pronto para ser incluído no borderô", "", { "", "Fechar" }, 1)
	Close(oDlg1)
	Return
endif
if !eof() .AND. MsgYesNo("Título "+SE2->E2_NUM+" Vencimento "+dtoc(se2->e2_vencrea)+CHR(13)+" Fornecedor "+se2->(e2_FORNECE+" "+E2_NOMFOR)+CHR(13)+CHR(13)+"Deseja prosseguir com a operação ?"+CHR(13)+CHR(13)+"Será gravado um log da operação para auditoria"+CHR(13))
	_lReturn:=.t.
	RecLock("SE2",.f.)
	SE2->E2_XPLACA := " "
	SE2->E2_NOMERET := trim(SE2->E2_NOMERET)+alltrim(SUBSTR(CUSUARIO,7,15))+" "+dtoc(dDataBase)+";"
	MsUnLock()
	fkcommit()
	Aviso("Alteração efetuada com sucesso !!! Título"+se2->e2_num+" Usuário : "+alltrim(SUBSTR(CUSUARIO,7,15)),(chr(13)+chr(10))+"Processamento efetuado em: Data: "+(Dtoc(dDataBase)+" | Hora: "+substr(time(),1,5)),{"Ok"},2,,,,,,2)
	EnviaEMail()
Else
	Aviso("Operação não realizada, título não encontrado para o fornecedor", "", { "", "Fechar" }, 1)
Endif
Close(oDlg1)

Return _lReturn

Static Function ValidTit()

Select SE1
dbSetOrder(6)
Seek xFilial()+cForn+cLoja+cPref+cNum+cParc
if eof()
//	Aviso("Título não encontrado "+se2->e2_num,,{"Ok"},2,,,,,,2)
Endif

Return

Static Function ValidForn()

Select SA2
dbSetOrder(1)
Seek xFilial()+cForn+cLoja
if eof()
//	Aviso("Fornecedor não encontrado "+sa2->a2_nome+" Usuário : "+alltrim(SUBSTR(CUSUARIO,7,15)),(chr(13)+chr(10))+"Processamento efetuado em: Data: "+(Dtoc(dDataBase)+" | Hora: "+substr(time(),1,5)),{"Ok"},2,,,,,,2)
endif

Return


Static Function EnviaEmail


Local _cSUBJECT:="-Financeiro] Alteração Libera Título do Borderô"
Local cTxtEmail:=""
Local _aFiles:=array(1)
Local oDlg
Local cDestEmail := ""
Local lRes := .F.
Local xAlias := "SE2" 
Local cCrLf    	:= Chr(13) + Chr(10)

Local aArray := {}

_NomeUser := trim(substr(cUsuario,7,15))

auser := pswret(1)
cemail := alltrim(auser[1,14])
cUser  := alltrim(auser[1,1])
cDestEmail := PSWRET(1)[1][14]

DbSelectArea(xAlias)
dVENCREA := SE1->E1_VENCREA

cDestEmail := "tmoraes@t4f.com.br"
                                                   
cTxtEmail := "Fornecedor : " +se2->e2_nomfor + cCrLf  // Pula linha
cTxtEmail += "Título : " + se2->(E2_PREFIXO+" "+E2_NUM+" "+E2_PARCELA) + cCRLF
cTxtEmail += "Usuário : "+alltrim(SUBSTR(CUSUARIO,7,15))+" data "+dtoc(dDataBase) + cCRLF
cTxtEmail += "Alterado pelo usuário : "+_NomeUser

do case
	case SM0->M0_CODIGO == '08'
		cEmp := '[T4F'
	case SM0->M0_CODIGO == '09'
		cEmp := '[Metropolitan'
	case SM0->M0_CODIGO == '16'
		cEmp := '[Vicar'
	case SM0->M0_CODIGO == '20'
		cEmp := '[A&B'
	case SM0->M0_CODIGO == '25'
		cEmp := '[Mkt'
endcase
U_EnvEmail(cDestEmail+";",cEmp+_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao superior que houve alteração no vencimento.

Return()

