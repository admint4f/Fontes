#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TopConn.Ch"
#INCLUDE "RwMake.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Bruna Zechetti      º Data ³  18/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada na confirmação do cadastro de Produtos.     ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function T4COMA01()

	//Local cFiltro   	:= ""
	Local _aCpoBrw		:= {}

	Private cAlias   	:= "SA2"
	Private _cCpo  		:= "A2_TIPO/A2_COD/A2_LOJA/A2_CGC/A2_NOME/A2_BANCO/A2_AGENCIA/A2_DVAGENC/A2_NUMCON/A2_DVCONTA/A2_MSBLQL"
	Private cCadastro 	:= "Cadastro de Fornecedores"
	Private aRotina     := {{"Pesquisar" 	, "AxPesqui"    , 0, 1 },;
		{"Visualizar" 	, "U_fGrvFor"   , 0, 2 },;
		{"Incluir"      , "U_fGrvFor"   , 0, 3 },;
		{"Alterar"      , "U_fGrvFor"   , 0, 4 },;
		{"Excluir"      , "U_fGrvFor"   , 0, 5 }}

	AADD(_aCpoBrw,{"Tipo"			,"A2_TIPO"})
	AADD(_aCpoBrw,{"Codigo"			,"A2_COD"})
	AADD(_aCpoBrw,{"Loja"			,"A2_LOJA"})
	AADD(_aCpoBrw,{"CNPJ/CPF"		,"A2_CGC"})
	AADD(_aCpoBrw,{"Razao Social"	,"A2_NOME"})
	AADD(_aCpoBrw,{"Banco"			,"A2_BANCO"})
	AADD(_aCpoBrw,{"Agencia"		,"A2_AGENCIA"})
	AADD(_aCpoBrw,{"DV.Agencia"		,"A2_DVAGENC"})
	AADD(_aCpoBrw,{"Cta Corrente"	,"A2_NUMCON"})
	AADD(_aCpoBrw,{"DV.Conta"		,"A2_DVCONTA"})
	AADD(_aCpoBrw,{"Bloqueado"		,"A2_MSBLQL"})

	dbSelectArea("SA2")
	dbSetOrder(1)

	mBrowse( ,,,,"SA2",_aCpoBrw,,,,,/*aCores*/,,,,,,,,/*cFiltro*/)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGrvFor   ºAutor  ³Bruna Zechetti      º Data ³  27/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para criação da tela de manutenção de Fornecedores.   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/		
User Function fGrvFor(_cAlias, _nReg, _nOpc)

	Local _aBloq		:= {"1 - Sim","2 - Nao"}
	Private _oDlgFor	:= Nil
	Private _aCampos	:= {}
	Private aGets
	Private aTela
	Private _oTipo		:= Nil
	Private _cTipo		:= Space(TAMSX3("A2_TIPO")[1])
	Private _oCodFor	:= Nil
	Private _cCodFor	:= Space(TAMSX3("A2_COD")[1])
	Private _oLojFor	:= Nil
	Private _cLojFor	:= Space(TAMSX3("A2_LOJA")[1])
	Private _oNomFor	:= Nil
	Private _cNomFor 	:= Space(TAMSX3("A2_NOME")[1])
	Private _oCGCFor	:= Nil
	Private _cCGCFor	:= Space(TAMSX3("A2_CGC")[1])
	Private _oBanco 	:= Nil
	Private _cBanco		:= Space(TAMSX3("A2_BANCO")[1])
	Private _oCodAgc 	:= Nil
	Private _cCodAgc	:= Space(TAMSX3("A2_AGENCIA")[1])
	Private _oDvAgc 	:= Nil
	Private _cDvAgc		:= Space(TAMSX3("A2_DVAGENC")[1])
	Private _oConta 	:= Nil
	Private _cConta		:= Space(TAMSX3("A2_NUMCON")[1])
	Private _oDvConta 	:= Nil
	Private _cDvConta	:= Space(TAMSX3("A2_DVCONTA")[1])
	Private _oBloq	 	:= Nil
	Private _cBloq		:= Space(TAMSX3("A2_MSBLQL")[1])
	Private _oCContab 	:= Nil
	Private _cCContab	:= PadR("2101010002",TAMSX3("A2_CONTA")[1])

	dbSelectArea("SA2")
	If _nOpc == 3
		_cCodFor	:= GETSX8NUM('SA2')
	Else
		_cCodFor	:= SA2->A2_COD
		_cLojFor	:= SA2->A2_LOJA
		_cNomFor 	:= SA2->A2_NOME
		_cCGCFor	:= SA2->A2_CGC
		_cBanco		:= SA2->A2_BANCO
		_cCodAgc	:= SA2->A2_AGENCIA
		_cDvAgc		:= SA2->A2_DVAGENC
		_cConta		:= SA2->A2_NUMCON
		_cCContab	:= SA2->A2_CONTA
		_cDvConta	:= SA2->A2_DVCONTA
	EndIf

	//_oDlgFor:=MSDialog():New(10,10,215,668,cCadastro,,,,,,CLR_WHITE,,,.T.)
	_oDlgFor:=MSDialog():New(10,10,250,668,cCadastro,,,,,,CLR_WHITE,,,.T.)

	ENCHOICEBAR(_oDlgFor,{||(fGrvSa2(_nOpc),SA2->(ConfirmSx8()))},{|| SA2->(RollBackSx8()),Close(_oDlgFor)},,)

	@ 040,003 SAY "Tipo"     	                            					SIZE 040,08 PIXEL OF _oDlgFor
	_oTipo := tComboBox():New(040,035,{|u|if(PCount()>0,_cTipo:=u,_cTipo)},{"","Fisica","Juridica","Outros"},040,08,_oDlgFor,,,,,,.T.,,,,{|| !_nOpc == 5},,,,,"_cTipo")
	_oTipo:bChange	:= {|| u_fVldPic(_nOpc),_oDlgFor:Refresh()}
	If _nOpc <> 3
		_oTipo:nAt	:= Iif(UPPER(ALLTRIM(SA2->A2_TIPO))=="F",2,Iif(UPPER(ALLTRIM(SA2->A2_TIPO))=="J",3,4))
		_oTipo:Refresh()
	EndIf

	@ 040,110 SAY OEMTOANSI("Código")                       					SIZE 040,08 PIXEL OF _oDlgFor
	@ 040,140 MSGET _oCodFor   VAR _cCodFor Picture "@!" 						SIZE 060,08 PIXEL OF _oDlgFor WHEN .F.

	@ 040,210 SAY OEMTOANSI("Loja")                     						SIZE 040,08 PIXEL OF _oDlgFor
	@ 040,245 MSGET _oLojFor   VAR _cLojFor				 						SIZE 020,08 PIXEL OF _oDlgFor

	@ 055,003 SAY OEMTOANSI("Nome")                       						SIZE 040,08 PIXEL OF _oDlgFor
	@ 055,035 MSGET _oNomFor   VAR _cNomFor Picture "@!" 						SIZE 290,08 PIXEL OF _oDlgFor WHEN !_nOpc == 5

	@ 070,003 SAY OEMTOANSI("CNPJ/CPF")                     					SIZE 040,08 PIXEL OF _oDlgFor
	u_FvldPic(_nOpc)
	_oCGCFor:Refresh()

	@ 070,110 SAY OEMTOANSI("Bloqueado")		                 				SIZE 040,08 PIXEL OF _oDlgFor
	_oBloq := tComboBox():New(070,140,{|u|if(PCount()>0,_cBloq:=u,_cBloq)},_aBloq,060,08,_oDlgFor,,{|| _oDlgFor:Refresh()},,,,.T.,,,,{|| !_nOpc == 5},,,,,"_cBloq")
	If _nOpc == 3
		_oBloq:nAt	:= 2
	Else
		_oBloq:nAt	:= Val(SA2->A2_MSBLQL)
	EndIF

	@ 085,003 SAY OEMTOANSI("Banco")                       						SIZE 040,08 PIXEL OF _oDlgFor
	@ 085,035 MSGET _oBanco   VAR _cBanco  										SIZE 040,08 PIXEL OF _oDlgFor  F3 "SA6" WHEN !_nOpc == 5

	@ 085,110 SAY OEMTOANSI("Agência")		                 					SIZE 040,08 PIXEL OF _oDlgFor
	@ 085,140 MSGET _oCodAgc   VAR _cCodAgc  									SIZE 060,08 PIXEL OF _oDlgFor WHEN !_nOpc == 5

	@ 100,003 SAY OEMTOANSI("Cta Corrente")                 					SIZE 040,08 PIXEL OF _oDlgFor
	@ 100,035 MSGET _oConta   VAR _cConta  										SIZE 060,08 PIXEL OF _oDlgFor WHEN !_nOpc == 5

	@ 085,210 SAY OEMTOANSI("DV. Agência")                  					SIZE 040,08 PIXEL OF _oDlgFor
	@ 085,245 MSGET _oDvAgc   VAR _cDvAgc  										SIZE 030,08 PIXEL OF _oDlgFor WHEN !_nOpc == 5

	@ 100,110 SAY OEMTOANSI("DV. Conta")                       					SIZE 040,08 PIXEL OF _oDlgFor
	@ 100,140 MSGET _oDvConta   VAR _cDvConta  									SIZE 030,08 PIXEL OF _oDlgFor WHEN !_nOpc == 5

	@ 100,210 SAY OEMTOANSI("Cta Contabil")                    					SIZE 040,08 PIXEL OF _oDlgFor
	@ 100,245 MSGET _oCContab   VAR _cCContab  									SIZE 080,08 PIXEL OF _oDlgFor VALID Ctb105Cta() F3 "CT1" WHEN !_nOpc == 5

	_oDlgFor:Activate(,,,.T.,,,)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FvldPic   ºAutor  ³Bruna Zechetti      º Data ³  27/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para validação dos campos.                            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FvldPic(_nOpc)

	@ 070,035 MSGET _oCGCFor   VAR _cCGCFor Picture Iif(SubStr(_cTipo,1,1)=='J',"@R 99.999.999/9999-99","@R 999.999.999-99") 	SIZE 060,08 PIXEL OF _oDlgFor VALID Vazio().Or.Cgc(_cCGCFor) WHEN !_nOpc == 5

	_oDlgFor:Refresh()
	_oCGCFor:Refresh()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVldFor   ºAutor  ³Bruna Zechetti      º Data ³  27/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para validação dos campos.                            ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

Static Function fVldFor()

	Local _lOk		:= .T.

	If Empty(_cNomFor) .Or. Empty(_cCGCFor) .Or. Empty(_cBanco) .Or. Empty(_cCodAgc) .Or. Empty(_cConta) .Or. Empty(_cCContab)
		Aviso("Atencao!", "Existem campos obrigatórios em branco. Por favor preenche-los!" ,{"Ok"},1)
		_lOk	:= .F.
	EndIf

Return(_lOk)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fVldCGC   ºAutor  ³Bruna Zechetti      º Data ³  27/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para validação do CNPJ/CPF.                           ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldCGC()

	Local _cQuery		:= ""
	Local _cAliasCGC	:= GetNextAlias()
	Local _lOk			:= .T.

	_cQuery	:= "SELECT A2_CGC, A2_NOME, A2_COD"
	_cQuery	+= " FROM " + RetSqlName("SA2")
	_cQuery	+= " WHERE A2_FILIAL = '" + xFilial("SA2") + "'"
	_cQuery	+= " AND A2_CGC = '" + _cCGCFor + "'"
	_cQuery	+= " AND D_E_L_E_T_ = ' '"
	TcQuery _cQuery New Alias &(_cAliasCGC)

	If (_cAliasCGC)->(!EOF())
		Aviso("Atencao!", "Já existe CNPJ/CPF informado para outro Fonecedor [" + AllTrim((_cAliasCGC)->A2_COD) + " - " + AllTrim((_cAliasCGC)->A2_NOME) + "]. Favor verificar o CNPJ/CPF !" ,{"Ok"},1)
		_lOk	:= .F.
	EndIf

Return(_lOk)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGrvSA2   ºAutor  ³Bruna Zechetti      º Data ³  27/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para gravação dos dados na tabela.                    ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fGrvSA2(_nOpc)

	Begin Transaction
		If _nOpc == 5
			If RecLock("SA2",.F.)
				SA2->(DbDelete())
				SA2->(MsUnlock())
			EndIf
			Close(_oDlgFor)
		Else
			If _nOpc==3
				If  fVldCGC() //.AND. fVldFor()
					If RecLock("SA2",.T.)
						SA2->A2_FILIAL	:= xFilial("SA2")
						SA2->A2_TIPO	:= IIf(SubStr(_cTipo,1,1)=="O","X",SubStr(_cTipo,1,1))
						SA2->A2_COD		:= _cCodFor
						SA2->A2_LOJA	:= _cLojFor
						SA2->A2_NOME	:= _cNomFor
						SA2->A2_NREDUZ	:= _cNomFor
						SA2->A2_CGC		:= _cCGCFor
						SA2->A2_BANCO	:= _cBanco
						SA2->A2_AGENCIA	:= _cCodAgc
						SA2->A2_DVAGENC	:= _cDvAgc
						SA2->A2_NUMCON	:= _cConta
						SA2->A2_CONTA	:= _cCContab
						SA2->A2_DVCONTA	:= _cDvConta
						SA2->A2_MSBLQL	:= SubStr(_cBloq,1,1)
						SA2->(MsUnlock())
					EndIf
					Close(_oDlgFor)
				EndIf
			EndIf
			If _nOpc==4
				If RecLock("SA2",.F.)
					SA2->A2_FILIAL	:= xFilial("SA2")
					SA2->A2_TIPO	:= IIf(SubStr(_cTipo,1,1)=="O","X",SubStr(_cTipo,1,1))
					SA2->A2_COD		:= _cCodFor
					SA2->A2_LOJA	:= _cLojFor
					SA2->A2_NOME	:= _cNomFor
					SA2->A2_NREDUZ	:= _cNomFor
					SA2->A2_CGC		:= _cCGCFor
					SA2->A2_BANCO	:= _cBanco
					SA2->A2_AGENCIA	:= _cCodAgc
					SA2->A2_DVAGENC	:= _cDvAgc
					SA2->A2_NUMCON	:= _cConta
					SA2->A2_CONTA	:= _cCContab
					SA2->A2_DVCONTA	:= _cDvConta
					SA2->A2_MSBLQL	:= SubStr(_cBloq,1,1)
					SA2->(MsUnlock())
				EndIf
				Close(_oDlgFor)
			EndIF
		EndIF

	End Transaction

Return(.T.)
