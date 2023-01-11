#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4F_004   º Autor ³ Claudio            º Data ³  06/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Aprovação de despesas do caixinha                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function T4F_004

Local cArq,cInd
Local aStru			:= {}

Private aIndSEU		:= {}		// para uso do filtro da mbrowse
Private bFiltraBrw	:= {|| Nil}
Private cCadastro	:= "Aprovacao de adiantamento"   
Private aRotina		:= {{"Pesquisar","AxPesqui",0,1} ,;
						{"Visualizar","U_APROVAR(2)",0,2} ,;
						{"Aprovar","U_APROVAR(5)",0,4}}
Private cDelFunc 	:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cFiltro 	:= ""
Private cChave		:= ""
Private cIndice		:= ""
Private aAreaAnt	:= {}
Private cCondicao	:= ""

cCondicao := "(((retcodusr() = SEU->EU_APR1) .and. empty(SEU->EU_APR1OK)) .or. "
cCondicao += "((retcodusr() = SEU->EU_APR2) .and. empty(SEU->EU_APR2OK))) .and. "
cCondicao += "SEU->EU_TIPO = '01'"

bFiltraBrw := {|| FilBrowse("SEU",@aIndSEU,@cCondicao) }
Eval(bFiltraBrw)

mBrowse( 6,1,22,75,"SEU")
RetIndex("SEU")
dbClearFilter()

Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³APROVAR   º Autor ³ Claudio            º Data ³  05/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exibição de prestacao de contas para aprovacao             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function APROVAR(nOpcao)       

Local aAreaAnt	:= {}

if nOpcao = 5 .and. ((retcodusr() = SEU->EU_APR2) .and. empty(SEU->EU_APR1OK))
	msgbox("Essa prestação de contas precisa ser aprovada antes pelo gestor da área","Atencao","Error")
	return .f.
endif

// necessario fechar e reabrir o SEU devido a que pode estar usando indregua()
Private nValTot		:= 0
Private	cCodigo		:= SEU->EU_CAIXA
Private cNumero		:= SEU->EU_NUM
Private cNroAdia	:= SEU->EU_NROADIA
Private dDtEmis		:= SEU->EU_EMISSAO
Private cNome		:= space(30)
Private cAprovador	:= retcodusr()

SetPrvt("NOPCX,NUSADO,AHEADER,ACOLS,CCLIENTE,CLOJA")
SetPrvt("DDATA,NLINGETD,CTITULO,AC,AR,ACGD")
SetPrvt("CLINHAOK,CTUDOOK,LRETMOD2,nX,nY")
        
dbselectarea("SET")
dbsetorder(1)
dbgotop()

SET->(dbSeek(xFilial("SET")+SEU->EU_CAIXA))                                      
cNome := SET->ET_NOME

//exibir os registros de despesa
dbSelectArea("SEU")
RetIndex("SEU")
dbClearFilter()
nX := 0
nY := 0

//+--------------------------------------------------------------+
//¦ Opcao de acesso para o Modelo 2                              ¦
//+--------------------------------------------------------------+
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
nOpcx:=2	// Para impedir qualquer alteração no browse.

//+--------------------------------------------------------------+
//¦ Montando aHeader                                             ¦
//+--------------------------------------------------------------+
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SEU")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "SEU")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel
		if alltrim(SX3->X3_CAMPO) $ " EU_HISTOR EU_NRCOMP EU_VALOR EU_EMISSAO EU_FORNECE EU_LOJA EU_NOME EU_CGC ET_APR1"
	    	nUsado:=nUsado+1
    	    AADD(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
        	    	x3_tamanho, x3_decimal,,;
        		   	x3_usado, x3_tipo, x3_arquivo, x3_context } )
        endif
    Endif
    dbSkip()
End

//+--------------------------------------------------------------+
//¦ Montando aCols                                               ¦
//+--------------------------------------------------------------+
aCols := {}
dbSelectArea("SEU")
dbgotop()
While !eof() 
	if SEU->EU_NROADIA == cNumero
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next 
		aCols[Len(aCols),nUsado+1]:=.F.
		nValTot := nValTot + SEU->EU_VALOR
	endif
	dbSkip()
enddo                                        
if len(aCols) = 0
	msgbox("Ainda não foi registrada nenhuma despesa para esse adiantamento","Atencao","INFO")
	// restaurando o filtro para exibição da tela inicial
	bFiltraBrw := {|| FilBrowse("SEU",@aIndSEU,@cCondicao) }
	Eval(bFiltraBrw)
	return .f.
endif

//+--------------------------------------------------------------+
//¦ Variaveis do Cabecalho do Modelo 2                           ¦
//+--------------------------------------------------------------+
cCliente:=Space(6)
cLoja	:=Space(2)
dData	:= MsDate()
//+--------------------------------------------------------------+
//¦ Variaveis do Rodape do Modelo 2                              ¦
//+--------------------------------------------------------------+
nLinGetD:=0
//+--------------------------------------------------------------+
//¦ Titulo da Janela                                             ¦
//+--------------------------------------------------------------+
cTitulo:="Prestacao de contas de adiantamento"
//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Cabecalho do Modelo 2      ¦
//+--------------------------------------------------------------+

aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.
AADD(aC,{"cNumero",	{15,010} ,"Adiantamento: ",	"",,,})
AADD(aC,{"cCodigo",	{15,120} ,"Caixa: ",		"",,,})
AADD(aC,{"cNome",	{15,170} ,"Nome: ",          "",,,})
AADD(aC,{"dDtEmis",	{15,380},"Data de Emissao:","",,,})

//+--------------------------------------------------------------+
//¦ Array com descricao dos campos do Rodape do Modelo 2         ¦
//+--------------------------------------------------------------+
aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
//#IFDEF WINDOWS
	AADD(aR,{"nValTot"	,{120,10},"Total das despesas para este adiantamento:","@E 99,999.99",,,.F.})
//#ELSE
//	AADD(aR,{"nLinGetD"	,{19,05},"Linha na GetDados"	,"@E 999",,,.F.})
//#ENDIF

//+--------------------------------------------------------------+
//¦ Array com coordenadas da GetDados no modelo2                 ¦
//+--------------------------------------------------------------+
aCGD:={44,5,118,315}

//+--------------------------------------------------------------+
//¦ Validacoes na GetDados da Modelo 2                           ¦
//+--------------------------------------------------------------+

// Forçado retorno .t. porque nesse caso não interessa validação da linha ou do getdados
cLinhaOk := ".t."	 //"U_Md2LinOk()"
cTudoOk  :=	".t."		

// lRetMod2 retorna .t. se confirmou e .f. se cancelou
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

if lRetMod2
	if nOpcao = 5
		dbSelectArea("SEU")
		RetIndex("SEU")	
		dbClearFilter()

		aAreaAnt := getarea()
		dbsetorder(3)	
		dbgotop()
		dbseek(xFilial("SEU")+cNumero)
		if msgbox("As despesas referentes ao adiantamento "+cNumero+" serao aprovadas."+chr(13)+;
			"Pressione Sim para continuar ou Não para abandonar o processo","Atencao","YESNO")	
       	
			// para localizar se o aprovador eh gestor da area ou fiscal
			SET->(dbseek(xFilial("SET")+SEU->EU_CAIXA))
				
			// atualizar o registro de "cabecalho" do adiantamento
			dbsetorder(1)
			dbseek(xFilial("SEU")+cNumero)
			if reclock("SEU",.f.)
				if cAprovador = SET->ET_APR1
					SEU->EU_APR1	:= cAprovador 	
					SEU->EU_APR1OK	:= "S"
				else                         
					SEU->EU_APR2	:= cAprovador
					SEU->EU_APR2OK	:= "S"					
				endif
				msunlock()
			endif
		
			dbsetorder(3)	// EU_FILIAL+EU_NROADIA+EU_NUM
			dbseek(xFilial("SEU")+cNumero)
			do while SEU->EU_NROADIA = cNumero
				if reclock("SEU",.f.)
					if cAprovador = SET->ET_APR1
						SEU->EU_APR1	:= cAprovador 	
						SEU->EU_APR1OK	:= "S"
					else                         
						SEU->EU_APR2	:= cAprovador
						SEU->EU_APR2OK	:= "S"					
					endif
					msunlock()
				endif
				dbskip()
			enddo		
		endif
	endif
endif

// restaurando o filtro para exibição da tela inicial
bFiltraBrw := {|| FilBrowse("SEU",@aIndSEU,@cCondicao) }
Eval(bFiltraBrw)
return .t.
