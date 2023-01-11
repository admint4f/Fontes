#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    �TOPCONCNAB� Biblioteca de fun��es gen�ricas para utiliza��o na gera��o de���
���             �          � boleto de cobran�a em formato gr�fico, e nos arquivos de     ���
���             �          � comunica��o banc�ria (remessa e retorno) do Cnab             ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.01.07 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Os arquivos SE1, SA1 e SA6 devem estar posicionados no registro a ser   ���
���             � impresso                                                                ���
���             �                                                                         ���
���             �         ANTES DE QUALQUER PROCESSAMENTO CRIAR CAMPOS/PAR�METROS         ���
���             � ***************************** CAMPOS NOVOS **************************** ���
���             � A6_DIGBCO  - C - 01,0 - OBRIGAT�RIO - D�gito do banco perante a c�mara  ���
���             �              de compensa��o (FEBRABAN).                                 ���
���             � A6_DIGAGE  - C - 01,0 - OPCIONAL - D�gito da ag�ncia banc�ria se n�o    ���
���             �              existir ir� procurar pelo caracter "-" no campo A6_AGENCIA ���
���             �              e definir� como d�gito o caracter ap�s o "-".              ���
���             � A6_DIGCON  - C - 01,0 - OPCIONAL - D�gito da conta corrente do banco se ���
���             �              n�o existir ir� procurar pelo caracter "-" no campo        ���
���             �              A6_AGENCIA e definir� como d�gito o caracter ap�s o "-".   ���
���             � A6_ARQLOG  - C - 15,0 - OPCIONAL - Nome do arquivo com o logotipo do    ���
���             �              banco que deve obrigatoriamente estar no diret�rio \SYSTEM\���
���             �              se n�o existir, colocar� no lugar do logo o nome reduzido  ���
���             �              do cadastro de bancos.                                     ���
���             � ****************************** PAR�METROS ***************************** ���
���             � TC_TXJBOL - Taxa de juros de mora ao m�s por atraso no pagamento, se n�o���
���             �             existir n�o ir� colocar a mensagem com o valor dos juros que���
���             �             dever� ser cobrado por dia de atraso.                       ���
���             � TC_TXMBOL - Taxa de multa por atraso no pagamento, se n�o existir n�o   ���
���             �             ir� colocar a mensagem com o percentual de multa a ser que  ���
���             �             dever� ser cobrado por atraso no pagamento                  ���
���             � TC_DIABOL - N�mero de dias para envio do t�tulo ao cart�rio, se n�o     ���
���             �             existir n�o ir� colocar a mensagem com o prazo de envio do  ���
���             �             t�tulo ao cart�rio                                          ���
���             �                   CAMPOS ATUALIZADOS NA ROTINA                          ���
���             � E1_PORTADO - com o banco selecionado no par�metro da rotina             ���
���             � E1_AGENCIA - com a ag�ncia selecionada no par�metro da rotina           ���
���             � E1_CONTA   - com a conta selecionada no par�metro da rotina             ���
���             � EE_FAXATU  - com � pr�ximo n�mero dispon�vel para utiliza��o            ���
���             � ******************************* DIVERSOS ****************************** ���
���             � 1. O campo EE_FAXATU deve conter o pr�ximo n�mero do boleto SEM o d�gito���
���             �    verificador e no tamanho exato do n�mero definido no manual do banco,���
���             �    N�O deve haver caracteres separadores (.;,-etc...)                   ���
���             �    Citibank - 11 posi�oes                                               ���
���             �    Ita�     - 08 Posi��es                                               ���
���             � 2. Carteira - para defini��o do c�digo da carteira � utilizado o campo  ���
���             �    EE_SUBCTA                                                            ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TCDadBco � Retorna array com os dados do banco e da empresa             ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.01.07 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpA1 = Array vazio passado por refer�ncia para ser atualizado com os   ���
���             �         dados do cadastro de empresa (SigaMat)                          ���
���             � ExpA2 = Array Vazio passado por refer�ncia para ser atualizado com os   ���
���             �         dados so cadastro do banco (SA6)                                ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL1 = .T. montou os arrays corretamento, .F. n�o montou os arrays     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Os arquivos devem estar posicionados SM0, SA6, SEE                      ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
USER Function TCDadBco(aDadEmp, aDadBco)

Local aAreaAtu	:= GetArea()
Local lRet		:= .T.

//������������������������������������������������Ŀ
//� Verifica se passou os par�metros para a fun��o �
//��������������������������������������������������
If (aDadEmp == Nil .Or. ValType(aDadEmp) <> "A") .Or. (aDadBco == Nil .Or. ValType(aDadBco) <> "A")
	Aviso(	"Biblioteca de Fun��es",;
	"Os par�metros passados por refer�ncia est�o fora dos padr�es."+Chr(13)+Chr(10)+;
	"Verifique a chamada da fun��o no programa de origem.",;
	{"&Continua"},2,;
	"Chamada Inv�lida" )
	lRet	:= .F.
EndIf

//��������������������������������������������Ŀ
//� Verifica se os arquivos est�o posicionados �
//����������������������������������������������
If SM0->(Eof()) .Or. SM0->(Bof())
	Aviso(	"Biblioteca de Fun��es",;
	"O arquivo de Empresas n�o esta posicionado.",;
	{"&Continua"},,;
	"Registro Inv�lido" )
	lRet	:= .F.
EndIf
If SA6->(Eof()) .Or. SA6->(Bof())
	Aviso(	"Biblioteca de Fun��es",;
	"O arquivo de Bancos n�o esta posicionado.",;
	{"&Continua"},,;
	"Registro Inv�lido" )
	lRet	:= .F.
EndIf

//��������������������������������������������������������������Ŀ
//� Cria array vazio para que n�o d� erro se n�o encontrar dados �
//����������������������������������������������������������������
aDadEmp	:= {	"",;	// [1] Nome da Empresa
"",;	// [2] Endere�o
"",;	// [3] Bairro
"",;	// [4] Cidade
"",;	// [5] Estado
"",;	// [6] Cep
"",;	// [7] Telefone
"",;	// [8] Fax
"",;	// [9] CNPJ
"" ;	// [10]Inscri��o Estadual
}

aDadBco	:= {	"",;	// [1] C�digo do Banco
"",;	// [2] D�gito do Banco
"",;	// [3] C�digo da Ag�ncia
"",;	// [4] D�gito da Ag�ncia
"",;	// [5] N�mero da Conta Corrente
"",;	// [6] D�gito da Conta Corrente
"",;	// [7] Nome Completo do Banco
"",;	// [8] Nome Reduzido do Banco
"",;	// [9] Nome do Arquivo com o Logotipo do Banco
0,;		// [10]Taxa de juros a ser utilizado no c�lculo de juros de mora
0,;		// [11]Taxa de multa a ser impressa no boleto
0,;		// [12]N�mero de dias para envio do t�tulo ao cart�rio
"",;	// [13]Dado para o campo "Uso do Banco"
"",;	// [14]Dado para o campo "Esp�cie do Documento"
"" ;	// [15]C�digo do Cedente
}

If lRet
	//����������������������������������������Ŀ
	//� Alimenta array com os dados da Empresa �
	//������������������������������������������
	
	// Gilberto: Quando Area Marketing, considerar a razao social fixada.
	aDadEmp[1]	:= Iif( ALLTRIM(UPPER(SM0->M0_NOME)) == "AREA MARKETING","AREA MARKETING BRASIL LTDA" ,SM0->M0_NOMECOM)
	
	// aDadEmp[1]	:= SM0->M0_NOMECOM
	If !Empty(SM0->M0_ENDCOB)
		aDadEmp[2]	:= SM0->M0_ENDCOB
		aDadEmp[3]	:= SM0->M0_BAIRCOB
		aDadEmp[4]	:= SM0->M0_CIDCOB
		aDadEmp[5]	:= SM0->M0_ESTCOB
		aDadEmp[6]	:= SM0->M0_CEPCOB
	Else
		aDadEmp[2]	:= SM0->M0_ENDENT
		aDadEmp[3]	:= SM0->M0_BAIRENT
		aDadEmp[4]	:= SM0->M0_CIDENT
		aDadEmp[5]	:= SM0->M0_ESTENT
		aDadEmp[6]	:= SM0->M0_CEPENT
	EndIf
	aDadEmp[7]	:= SM0->M0_TEL
	aDadEmp[8]	:= SM0->M0_FAX
	aDadEmp[9]	:= SM0->M0_CGC
	aDadEmp[10]	:= SM0->M0_INSC
	
	//��������������������������������������Ŀ
	//� Alimenta array com os dados do Banco �
	//����������������������������������������
	IF SA6->A6_COD <> "341" // Para o banco Ita� o sistema dever� buscar conta espec�fica para Cobran�a - Luiz Eduardo - 29/09/2017
		
		If SA6->(FieldPos("A6_DIGBCO")) > 0
			aDadBco[1]	:= SA6->A6_COD
			aDadBco[2]	:= SA6->A6_DIGBCO
		Else
			aDadBco[1]	:= SA6->A6_COD
			aDadBco[2]	:= Space(1)
			aDadBco[2]	:= "5"     // DIGBANCO DO CITIBANK
		EndIf
		If SA6->(FieldPos("A6_DIGAGE")) > 0
			aDadBco[3]	:= RIGHT(TRIM(SA6->A6_AGENCIA),3)
			aDadBco[3]	:= "001"
			aDadBco[4]	:= SA6->A6_DIGAGE
		Else
			If At( "-", SA6->A6_AGENCIA ) > 1
				aDadBco[3]	:= SubStr( SA6->A6_AGENCIA, 1, At( "-", SA6->A6_AGENCIA ) - 1 )
				aDadBco[4]	:= SubStr( SA6->A6_AGENCIA, At( "-", SA6->A6_AGENCIA ) + 1, 1 )
			Else
				aDadBco[3]	:= RIGHT(TRIM(SA6->A6_AGENCIA),3)
				aDadBco[4]	:= ""
			EndIf
		EndIf
		If SA6->(FieldPos("A6_DIGCON")) > 0
			aDadBco[5]	:= SA6->A6_NUMCON
			aDadBco[6]	:= SA6->A6_DIGCON
		Else
			If At( "-", SA6->A6_NUMCON ) > 1
				aDadBco[5]	:= SubStr( SA6->A6_NUMCON, 1, At( "-", SA6->A6_NUMCON ) - 1)
				aDadBco[6]	:= SubStr( SA6->A6_NUMCON, At( "-", SA6->A6_NUMCON ) + 1, 1)
			Else
				aDadBco[5]	:= AllTrim( SA6->A6_NUMCON )
				aDadBco[6]	:= ""
			EndIf
		EndIf
	Else
		aDadBco[1]	:= SA6->A6_COD
		aDadBco[2]	:= Space(1)
		aDadBco[3]	:= RIGHT(TRIM(SA6->A6_AGCNAB),4)
		aDadBco[4]	:= ""
		aDadBco[5]	:= SA6->A6_CTCNAB
		aDadBco[6]	:= SA6->A6_DGCCNAB
	ENDIF
	aDadBco[7]	:= SA6->A6_NOME
	aDadBco[8]	:= SA6->A6_NREDUZ
	If SA6->(FieldPos("A6_ARQLOG")) > 0
		aDadBco[9]	:= SA6->A6_ARQLOG
	Else
		aDadBco[9]	:= ""
	EndIf
	
	//���������������������������������������������������������������Ŀ
	//� Define as taxas a serem utilizadas nos c�lculos das mensagens �
	//�����������������������������������������������������������������
	aDadBco[10]	:= SuperGetMv("TC_TXJBOL", .F., 0.00)
	aDadBco[11]	:= SuperGetMv("TC_TXMBOL", .F., 0.00)
	aDadBco[12]	:= SuperGetMv("TC_DIABOL", .F., 0)
	
	//��������������������������������������������Ŀ
	//� Define o campo Para Uso do Banco do boleto �
	//����������������������������������������������
	If SA6->A6_COD $ "745#"
		aDadBco[13]	:= "CLIENTE"
	EndIf
	
	//�����������������������������������������������Ŀ
	//� Define o campo Esp�cio do Documento do boleto �
	//�������������������������������������������������
	If SA6->A6_COD $ "745#341"
		aDadBco[14]	:= "DMI" //"DM"
	Else
		aDadBco[14]	:= "NF"
	EndIf
	
	//�������������������������������������������Ŀ
	//� Define o campo da Conta/Cedente do boleto �
	//���������������������������������������������
	If SA6->A6_COD $ "745#"
		//�����������������������������������������Ŀ
		//� Ag�ncia + Conta Cosmos (C�digo Empresa) �
		//�������������������������������������������
		aDadBco[15]	:= AllTrim(aDadBco[3])
		If !Empty(aDadBco[4])
			//		aDadBco[15]	+= "-"+Alltrim(aDadBco[4])
		EndIf
		If !Empty(SEE->EE_CODEMP)
			aDadBco[15]	+= "-"+StrZero(Val(EE_CODEMP),10)
		EndIf
	Else
		//��������������������������Ŀ
		//� Ag�ncia + Conta Corrente �
		//����������������������������
		aDadBco[15]	:= AllTrim(aDadBco[3])
		If !Empty(aDadBco[4])
			//			aDadBco[15]	+= "-"+Alltrim(aDadBco[4])
		EndIf
		If !Empty(aDadBco[5])
			aDadBco[15] += "-"+AllTrim(aDadBco[5])
			If !Empty(aDadBco[6])
				//				aDadBco[15] += "-"+AllTrim(aDadBco[6])
			EndIf
		EndIf
	EndIf
	
EndIf

RestArea(aAreaAtu)

Return(lRet)




/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TCDadTit � Retorna array com os dados do t�tulo e do cliente            ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.01.07 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpA1 = Array vazio passado por refer�ncia para ser atualizado com os   ���
���             �         dados do cadastro do t�tulo (SE1)                               ���
���             � ExpA2 = Array Vazio passado por refer�ncia para ser atualizado com os   ���
���             �         dados so cadastro do cliente (SA1)                              ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL1 = .T. montou os arrays corretamento, .F. n�o montou os arrays     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Os arquivos devem estar posicionados SE1, SA1, SEE, SA6                 ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function TCDadTit(aDadTit, aDadCli, aBarra, aDadBco)

Local aAreaAtu	:= GetArea()
Local lRet		:= .T.
Local nSaldo	:= 0
Local cNumDoc	:= ""
Local cCarteira	:= ""
Local cMensag1	:= ""
Local cMensag2	:= ""
Local cMensag3	:= ""
Local cMensag4	:= ""
Local cMensag5	:= ""
Local cMensag6	:= ""
Local lSaldo	:= SuperGetMV( "TC_VLRBOL", .F., .T. )

//������������������������������������������������Ŀ
//� Verifica se passou os par�metros para a fun��o �
//��������������������������������������������������
If (aDadTit == Nil .Or. ValType(aDadTit) <> "A") .Or.;
	(aDadCli == Nil .Or. ValType(aDadCli) <> "A") .Or.;
	(aBarra == Nil .Or. ValType(aBarra) <> "A")
	Aviso(	"Biblioteca de Fun��es",;
	"Os par�metros passados por refer�ncia est�o fora dos padr�es."+Chr(13)+Chr(10)+;
	"Verifique a chamada da fun��o no programa de origem.",;
	{"&Continua"},2,;
	"Chamada Inv�lida" )
	lRet	:= .F.
EndIf

//��������������������������������������������Ŀ
//� Verifica se os arquivos est�o posicionados �
//����������������������������������������������
If SE1->(Eof()) .Or. SE1->(Bof())
	Aviso(	"Biblioteca de Fun��es",;
	"O arquivo de T�tulos a Receber n�o esta posicionado.",;
	{"&Continua"},,;
	"Registro Inv�lido" )
	lRet	:= .F.
EndIf
If SA1->(Eof()) .Or. SA1->(Bof())
	Aviso(	"Biblioteca de Fun��es",;
	"O arquivo de Clientes n�o esta posicionado.",;
	{"&Continua"},,;
	"Registro Inv�lido" )
	lRet	:= .F.
EndIf

aDadTit	:= {	"",;					// [1] Prefixo do T�tulo
"",;					// [2] N�mero do T�tulo
"",;					// [3] Parcela do T�tulo
"",;					// [4] Tipo do t�tulo
CToD("  /  /  "),;		// [5] Data de Emiss�o do t�tulo
CToD("  /  /  "),;		// [6] Data de Vencimento do T�tulo
CToD("  /  /  "),;		// [7] Data de Vencimento Real
0,;						// [8] Valor L�quido do T�tulo
"",;					// [9] C�digo do Barras Formatado
"",;					// [10]Carteira de Cobran�a
"",;					// [11]1.a Linha de Mensagens Diversas
"",;					// [12]2.a Linha de Mensagens Diversas
"",;					// [13]3.a Linha de Mensagens Diversas
"",;					// [14]4.a Linha de Mensagens Diversas
"",;					// [15]5.a Linha de Mensagens Diversas
"",;					// [16]6.a Linha de Mensagens Diversas
"" ;                    // [17 ID CNAB
}
aDadCli	:= {	"",;					// [1] C�digo do cliente
"",;					// [2] Loja do Cliente
"",;					// [3] Nome Completo do Cliente
"",;					// [4] CNPJ do Cliente
"",;					// [5] Inscri��o Estadual do cliente
"",;					// [6] Tipo de Pessoa do Cliente
"",;					// [7] Endere�o
"",;					// [8] Bairro
"",;					// [9] Munic�pio
"",;					// [10] Estado
"" ;					// [11] Cep
}
aBarra	:= {	"",;					// [1] C�digo de barras (Banco+"9"+D�gito+Fator+Valor+Campo Livre
"",;					// [2] Linha Digit�vel
"",;					// [3] Nosso N�mero sem formata��o
"" ;					// [4] Nosso N�mero Formatado
}

If lRet
	//����������������������������������������Ŀ
	//� Alimenta array com os dados do cliente �
	//������������������������������������������
	aDadCli[1]	:= SA1->A1_COD
	aDadCli[2]	:= SA1->A1_LOJA
	aDadCli[3]	:= SA1->A1_NOME
	aDadCli[4]	:= SA1->A1_CGC
	aDadCli[5]	:= SA1->A1_INSCR
	aDadCli[6]	:= SA1->A1_PESSOA
	If !Empty(SA1->A1_ENDCOB) //.And. !( "MESMO" $ UPPER( SA1->A1_ENDCOB ) )
		aDadCli[7]	:= SA1->A1_ENDCOB
		aDadCli[8]	:= SA1->A1_BAIRROC
		aDadCli[9]	:= SA1->A1_MUNC
		aDadCli[10]	:= SA1->A1_ESTC
		aDadCli[11]	:= SA1->A1_CEPC
	Else
		aDadCli[7]	:= SA1->A1_END
		aDadCli[8]	:= SA1->A1_BAIRRO
		aDadCli[9]	:= SA1->A1_MUN
		aDadCli[10]	:= SA1->A1_EST
		aDadCli[11]	:= SA1->A1_CEP
	Endif
	
	//�������������������������Ŀ
	//� Monta o saldo do t�tulo �
	//���������������������������
	
	nSaldo:= u_T4FSaldoTit(lSaldo,SE1->(Recno()))
	
	//������������������������������Ŀ
	//� Pega ou monta o nosso n�mero �
	//��������������������������������
	If !Empty(SE1->E1_NUMBCO)
		cNumDoc	:= AllTrim(SE1->E1_NUMBCO)
	Else
		dbSelectArea("SEE")
		RecLock("SEE",.F.)
		nTamFax	:= Len(AllTrim(SEE->EE_FAXATU))
		cNumDoc	:= StrZero(Val(Alltrim(SEE->EE_FAXATU)),nTamFax)
		SEE->EE_FAXATU	:= Soma1(cNumDoc,nTamFax)
		MsUnLock()
	EndIf
	
	
	
	//�������������������������������Ŀ
	//� Define a carteira de cobran�a �
	//���������������������������������
	If Empty(SEE->EE_SUBCTA)
		if SEE->EE_CODIGO='745'
			cCarteira	:= "100"
		ELSE
			cCarteira	:= "109"
		ENDIF
	Else
		cCarteira	:= SEE->EE_SUBCTA
	EndIf
	
	If SEE->EE_SUBCTA $ "001*000"
		if SEE->EE_CODIGO='745'
			cCarteira	:= "100"
		ELSE
			cCarteira	:= "109"
		ENDIF
		//		cCarteira	:= "100"
	ENDIF
	
	//��������������������������������������������Ŀ
	//� Monta o C�digo de Barras e Linha Digit�vel �
	//����������������������������������������������
	// OBSERVACAO:
	// GetBarra alterada para calculcar o fator de vencimento com o Vencimento Real (E1_VENCREA) ao inves do Vencimento (E1_VENCTO).
	// Por Gilberto - 20/10/10
	
	aBarra	:= GetBarra(	aDadBco[1],;
	aDadBco[3],;
	aDadBco[4],;
	aDadBco[5],;
	aDadBco[6],;
	cCarteira,;
	cNumDoc,;
	nSaldo,;
	SE1->E1_VENCREA,;
	SEE->EE_CODEMP ;
	)
	
	//�����������������������������������������������������������Ŀ
	//� Taxa de juros a ser utilizado no c�lculo de juros de mora �
	//�������������������������������������������������������������
	If !Empty(aDadBco[10])
		//		cMensag1	:= "Mora Di�ria de R$ "+AllTrim(Transform( Round( ( nSaldo * (aDadBco[10]/100) ) / 30, 2), "@E 999,999,999.99"))
	Endif
	//����������������������������������������Ŀ
	//� Taxa de multa a ser impressa no boleto �
	//������������������������������������������
	If !Empty(aDadBco[11])
		cMensag2	:= "Multa por atraso no pagamento - " + AllTrim(Transform( aDadBco[11], "@E 999,999.99%"))
	EndIf
	//�������������������������������������������������Ŀ
	//� N�mero de dias para envio do t�tulo ao cart�rio �
	//���������������������������������������������������
	If !Empty(aDadBco[12])
		cMensag3	:= "Sujeito a Protesto ap�s " + StrZero(aDadBco[12], 2) + " (" + AllTrim(Extenso(aDadBco[12],.T.)) + ") dias do vencimento."
	EndIf
	
	//���������������������������������������Ŀ
	//� Alimenta array com os dados do t�tulo �
	//�����������������������������������������
	aDadTit[1]	:= SE1->E1_PREFIXO		// [1] Prefixo do T�tulo
	aDadTit[2]	:= SE1->E1_NUM			// [2] N�mero do T�tulo
	aDadTit[3]	:= SE1->E1_PARCELA		// [3] Parcela do T�tulo
	aDadTit[4]	:= SE1->E1_TIPO			// [4] Tipo do t�tulo
	aDadTit[5]	:= SE1->E1_EMISSAO		// [5] Data de Emiss�o do t�tulo
	aDadTit[6]	:= SE1->E1_VENCTO	    // [6] Data de Vencimento do T�tulo
	aDadTit[7]	:= SE1->E1_VENCREA		// [7] Data de Vencimento Real
	aDadTit[8]	:= nSaldo				// [8] Valor L�quido do T�tulo
	aDadTit[9]	:= aBarra[4]			// [9] C�digo do Barras Formatado
	aDadTit[10]	:= cCarteira			// [10]Carteira de Cobran�a
	aDadTit[11]	:= cMensag1				// [11]1a. Linha de Mensagem diversas
	aDadTit[12]	:= cMensag1				// [12]2a. Linha de Mensagem diversas
	aDadTit[13]	:= cMensag3				// [13]3a. Linha de Mensagem diversas
	aDadTit[14]	:= cMensag4				// [14]4a. Linha de Mensagem diversas
	aDadTit[15]	:= cMensag5				// [15]5a. Linha de Mensagem diversas
	aDadTit[16]	:= cMensag6				// [16]6a. Linha de Mensagem diversas
	aDadTit[17]	:= SE1->E1_IDCNAB       // [17]ID CNAB
EndIf

RestArea(aAreaAtu)

Return(lRet)




/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � GetBarra � C�lcula o c�digo de barras, linha digit�vel e d�gito do      ���
���             �          � nosso n�mero                                                 ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.01.07 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = C�digo do Banco                                                 ���
���             � ExpC2 = N�mero da Ag�ncia                                               ���
���             � ExpC3 = D�gito da Ag�ncia                                               ���
���             � ExpC4 = N�mero da Conta Corrente                                        ���
���             � ExpC5 = D�gito da Conta Corrente                                        ���
���             � ExpC6 = Carteira                                                        ���
���             � ExpC7 = Nosso N�mero sem d�gito                                         ���
���             � ExpN1 = Valor do T�tulo                                                 ���
���             � ExpD1 = Data de Vencimento                                              ���
���             � ExpC8 = N�mero do Contrato                                              ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpL1 = .T. montou os arrays corretamento, .F. n�o montou os arrays     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Os arquivos devem estar posicionados SE1, SA1, SEE, SA6                 ���
�����������������������������������������������������������������������������������������͹��
��� Alteracoes  � 16/03/09 - Renato Bandeira - Se banco 745 (Citi) LImita o tamnho do     ���
���             � campo nosso numero (E1_NUMBCO) em 11, pois existe diferenca nas empresas���
���             � Vicar e T4F                                                             ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function GetBarra(cBanco,cAgencia,cDigAgencia,cConta,cDigConta,cCarteira,cNNum,nValor,dVencto,cContrato)

Local cValorFinal	:= StrZero(Int(NoRound(nValor*100)),10)
Local cDvCB			:= 0
Local cDv			:= 0
Local cNN			:= ""
Local cNNForm		:= ""
Local cRN			:= ""
Local cCB			:= ""
Local cS			:= ""
Local cDvNN			:= ""
Local cFator		:= StrZero(dVencto - CToD("07/10/97"),4)
Local cCpoLivre		:= Space(25)

//�������������������������������������������������������������������������Ŀ
//�                 Definicao do NOSSO N�MERO E CAMPO LIVRE                 �
//���������������������������������������������������������������������������

//�������������������������������������������������������������������������Ŀ
//� BRASIL                                                                  �
//���������������������������������������������������������������������������
If cBanco $ "001"
	//���������������������������������������������������������������������Ŀ
	//�Composicao do Campo Livre (25 posi��es)                              �
	//�                                                                     �
	//�SOMENTE PARA AS CARTEIRAS 16/18 (com conv�nios de 6 posi��es)        �
	//�20 a 25 - (06) - N�mero do Conv�nio                                  �
	//�26 a 42 - (17) - Nosso N�mero                                        �
	//�43 a 44 - (02) - Carteira de cobran�a                                �
	//�                                                                     �
	//�SOMENTE PARA AS CARTEIRAS 17/18                                      �
	//�20 a 25 - (06) - Fixo 0                                              �
	//�26 a 32 - (07) - N�mero do conv�nio                                  �
	//�33 a 42 - (10) - Nosso Numero (sem o digito verificador)             �
	//�43 a 44 - (02) - Carteira de cobran�a                                �
	//�                                                                     �
	//�Composicao do Nosso N�mero                                           �
	//�01 a 06 - (06) - N�mero do Conv�nio (SEE->EE_CODEMP)                 �
	//�07 a 11 - (05) - Nosso N�mero (SEE->EE_FAXATU)                       �
	//�12 a 12 - (01) - D�gito do Nosso N�mero (Modulo 11)                  �
	//�����������������������������������������������������������������������
	//�������������������������������������������������������������������������Ŀ
	//� Carteira 16/18 - Conv�nio com 6 posi�oes                                �
	//���������������������������������������������������������������������������
	If Len(AllTrim(cContrato)) > 6
		Cs		:= AllTrim(cContrato) + cNNum + cCarteira
		//�������������������������������������������������������������������������Ŀ
		//� Carteira 17/18 - Conv�nio com mais de 6 posi�oes                        �
		//���������������������������������������������������������������������������
	Else
		Cs		:= "000000" + AllTrim(cContrato) + cNNum + cCarteira
	EndIf
	cDvNN		:= U_TCCalcDV( cBanco, cS )		//Modulo11(cS)
	cNN			:= AllTrim(cContrato) + cNNum + cDvNN
	cNNForm		:= AllTrim(cContrato) + cNNum + "-" + cDvNN
	cCpoLivre	:= ""
	//�������������������������������������������������������������������������Ŀ
	//� BRADESCO                                                                �
	//���������������������������������������������������������������������������
ElseIf 	cBanco $ "237"
	//���������������������������������������������������������������������Ŀ
	//�Composicao do Campo Livre (25 posi��es)                              �
	//�                                                                     �
	//�20 a 23 - (04) - Agencia cedente (sem o digito), completar com zeros �
	//�                 a esquerda se necessario	                        �
	//�24 a 25 - (02) - Carteira                                            �
	//�26 a 36 - (11) - Nosso Numero (sem o digito verificador)             �
	//�37 a 43 - (07) - Conta do cedente, sem o digito verificador, complete�
	//�                 com zeros a esquerda, se necessario                 �
	//�44 a 44 - (01) - Fixo "0"                                            �
	//�                                                                     �
	//�Composicao do Nosso N�mero                                           �
	//�01 a 02 - (02) - N�mero da Carteira (SEE->EE_SUBCTA)                 �
	//�                 06 para Sem Registro 19 para Com Registro           �
	//�03 a 13 - (11) - Nosso N�mero (SEE->EE_FAXATU)                       �
	//�04 a 14 - (01) - D�gito do Nosso N�mero (Modulo 11)                  �
	//�����������������������������������������������������������������������
	cS			:= AllTrim(cCarteira) + cNNum
	cDvNN		:= U_TCCalcDV( cBanco, cS )			//Mod11237(cS)
	cNN			:= AllTrim(cCarteira) + cNNum + cDvNN
	cNNForm		:= AllTrim(cCarteira) + "/"+ Substr(cNNum,1,2)+"/"+Substr(cNNum,3,9) + "-" + cDvnn
	cCpoLivre	:= StrZero(Val(AllTrim(cAgencia)),4)+StrZero(Val(AllTrim(cCarteira)),2)+substr(cNNum,3,7)+StrZero(Val(AllTrim(cConta)),7)+"0"
	//�������������������������������������������������������������������������Ŀ
	//� ITA�                                                                    �
	//���������������������������������������������������������������������������
ElseIf cBanco $ "341"
	//���������������������������������������������������������������������Ŀ
	//�Composicao do Campo Livre (25 posi��es)                              �
	//�                                                                     �
	//�20 a 22 - (03) - Carteira                                            �
	//�23 a 30 - (08) - Nosso N�mero (sem o d�gito verificador)             �
	//�31 a 31 - (01) - Digito verificador                                  �
	//�32 a 35 - (04) - Ag�ncia                                             �
	//�36 a 40 - (05) - Conta (sem o d�gito verificador                     �
	//�41 a 41 - (01) - D�gito verificador da conta                         �
	//�42 a 44 - (03) - Fixo "000"                                          �
	//�                                                                     �
	//�Composicao do Nosso N�mero                                           �
	//�Se carteira for 126/131/146/150/168                                  �
	//�01 a 03 - (03) - Carteira                                            �
	//�04 a 11 - (08) - Nosso N�mero (EE_FAXATU)                            �
	//�Demais carteiras                                                     �
	//�01 a 04 - (04) - Ag�ncia sem d�gito verificador                      �
	//�05 a 09 - (05) - Conta Corrente sem d�gito verificador               �
	//�10 a 12 - (03) - Carteira                                            �
	//�13 a 20 - (08) - Nosso N�mero (EE_FAXATU)                            �
	//�����������������������������������������������������������������������
	cNNum := substr(cNNum,3,8)
	If cCarteira $ "126/131/146/150/168"
		cS			:=  AllTrim(cCarteira) + cNNum
	Else
		cS			:=  AllTrim(cAgencia) + AllTrim(cConta) + AllTrim(cCarteira) + cNNum
	EndIf
	cDvNN		:= U_TCCalcDV( cBanco, cS )			//Modulo10(cS)
	cNN			:= AllTrim(cCarteira) + cNNum + cDvNN
	cNNForm		:= AllTrim(cCarteira) + "/"+ cNNum + "-" + cDvNN
	cCpoLivre	:= StrZero(Val(AllTrim(cCarteira)),3)+cNNum+cDvNN+StrZero(Val(Alltrim(cAgencia)),4)+StrZero(Val(AllTrim(cConta)),5)+cDigConta+"000"
	//�������������������������������������������������������������������������Ŀ
	//� CITIBANK                                                                �
	//���������������������������������������������������������������������������
ElseIf cBanco $ "745"
	//���������������������������������������������������������������������Ŀ
	//�Composicao do Campo Livre (25 posi��es)                              �
	//�                                                                     �
	//�20 a 20 - (01) - C�digo do Produto (3=Cobran�a com/sem registro      �
	//�                 4=Cobran�a de seguro sem registro)                  �
	//�21 a 23 - (03) - Portif�lio 3 �ltimos d�gitos do campo c�digo Empresa�
	//�                 Segundo Douglas (Citigroup) enviar neste campo o    �
	//�                 n�mero da carteira.                                 �
	//�                 O n�mero do contrato � chamado de Conta Cosmos e �  �
	//�                 formado por 10 posi��es com A.BBBBBB.CC.D, onde     �
	//�                 A      = N�o utilizado                              �
	//�                 BBBBBB = Base                                       �
	//�                 CC     = Sequencia                                  �
	//�                 D      = D�gito                                     �
	//�24 a 29 - (06) - Base (Contrato)                                     �
	//�30 a 31 - (02) - Sequencia (Contrato)                                �
	//�32 a 32 - (01) - D�gito da conta Cosmos (Contrato)                   �
	//�33 a 44 - (12) - Nosso N�mero com d�gito verificador                 �
	//�                                                                     �
	//�Composicao do Nosso N�mero                                           �
	//�01 a 11 - (11) - Nosso N�mero (EE_FAXATU)                            �
	//�����������������������������������������������������������������������
	// Limita em 11 o tamanho
	If Len( cNNum) > 11
		cNNum := StrZero(Val(cNNum), 11)
	Endif
	cS			:= cNNum
	cDvNN		:= U_TCCalcDV( cBanco, cS )			//modulo11(cS)
	cNN			:= cNNum + cDvNN
	cNNForm		:= cNNum + "-" + cDvNN
	cCpoLivre	:= "3" + StrZero(Val(cCarteira),3) + SubStr(AllTrim(cContrato), 2, 9) + cNN
EndIf

//�������������������������������������������������������������������������Ŀ
//�                  Definicao do D�GITO CODIGO DE BARRAS                   �
//���������������������������������������������������������������������������
cS		:= cBanco+"9"+cFator+cValorFinal+cCpoLivre
cDvCB	:= Modulo11(cS)
cCB		:= cBanco+"9"+cDVCB+cFator+cValorFinal+cCpoLivre

//�������������������������������������������������������������������������Ŀ
//�                  Definicao da LINHA DIGIT�VEL                           �
//� Campo 1       Campo 2        Campo 3        Campo 4   Campo 5           �
//� AAABC.CCCCX   CCCCC.CCCCCY   CCCCC.CCCCCZ   W	      UUUUVVVVVVVVVV    �
//�������������������������������������������������������������������������ĳ
//� AAA                       = C�digo do Banco na C�mara de Compensa��o    �
//� B                         = C�digo da Moeda, sempre 9                   �
//� CCCCCCCCCCCCCCCCCCCCCCCCC = Campo Livre                                 �
//� X                         = Digito Verificador do Campo 1               �
//� Y                         = Digito Verificador do Campo 2               �
//� Z                         = Digito Verificador do Campo 3               �
//� W                         = Digito Verificador do Codigo de Barras      �
//� UUUU                      = Fator de Vencimento                         �
//� VVVVVVVVVV                = Valor do T�tulo                             �
//���������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ
//� CALCULO DO D�GITO VERIFICADOR DO CAMPO 1                                �
//���������������������������������������������������������������������������
cS		:= cBanco + "9" +Substr(cCpoLivre,1,5)
cDv		:= modulo10(cS)
cRN1	:= SubStr(cS, 1, 5) + "." + SubStr(cS, 6, 4) + cDv

//�������������������������������������������������������������������������Ŀ
//� CALCULO DO D�GITO VERIFICADOR DO CAMPO 2                                �
//���������������������������������������������������������������������������
cS		:= Substr(cCpoLivre,6,10)
cDv		:= modulo10(cS)
cRN2	:= cS + cDv
cRN2	:= SubStr(cS, 1, 5) + "." + Substr(cS, 6, 5) + cDv

//�������������������������������������������������������������������������Ŀ
//� CALCULO DO D�GITO VERIFICADOR DO CAMPO 3                                �
//���������������������������������������������������������������������������
cS		:= Substr(cCpoLivre,16,10)
cDv		:= modulo10(cS)
cRN3	:= SubStr(cS, 1, 5) + "." + Substr(cS, 6, 5) + cDv             /////////ERRO

//�������������������������������������������������������������������������Ŀ
//� CALCULO DO CAMPO 4                                                      �
//���������������������������������������������������������������������������
cRN4	:= cDvCB

//�������������������������������������������������������������������������Ŀ
//� CALCULO DO CAMPO 5                                                      �
//���������������������������������������������������������������������������
cRN5	:= cFator + cValorFinal

cRN		:= cRN1 + " " + cRN2 + ' '+ cRN3 + ' ' + cRN4 + ' ' + cRN5

Return({cCB,cRN,cNNum,cNNForm,cDvNN})



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TCCalcDV � Efetua o c�lculo do d�gito verificador do nosso n�mero       ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 08.02.07 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = C�digo do Banco                                                 ���
���             � ExpC2 = Nosso N�mero                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpC3 = D�gito Verificador                                              ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function TCCalcDV( cBanco, cNNum )

cRetorno	:= ""

If cBanco $ "001
	cRetorno	:= Modulo11( cNNum )
ElseIf cBanco $ "745"
	//	cRetorno	:= Modulo11( cNNum )
	cRetorno	:= str( u_Mod11( cNNum),1)
ElseIf cBanco $ "237"
	cRetorno	:= Mod11237( cNNum )
ElseIf cBanco $ "341"
	cRetorno	:= Modulo10( cNNum )
EndIf

Return( cRetorno )




/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � Modulo10 � Efetua o c�lculo do d�gito veririficador com base 10         ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 23.01.07 �                                                  ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = String com o c�digo a ser calculado                             ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpC1 = String com o D�gito Verificador                                 ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function Modulo10(cData)

Local L	:= Len(cData)
Local D	:= 0
Local P := 0
Local B	:= .T.

While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		EndIf
	EndIf
	D := D + P
	L := L - 1
	B := !B
EndDo
D := 10 - (Mod(D,10))
If D = 10
	D := 0
EndIf

Return(AllTrim(Str(D,1)))



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � Modulo11 � Efetua o c�lculo do d�gito veririficador com base 11         ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 23.01.07 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = String com o c�digo a ser calculado                             ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpC1 = String com o D�gito Verificador                                 ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function Modulo11(cData)

Local L	:= Len(cData)
Local D	:= 0
Local P	:= 1

While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	EndIf
	L := L - 1
EndDo
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
EndIf

Return(AllTrim(Str(D,1)))



/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � Mod11237 � Efetua o c�lculo do d�gito veririficador com base 7 Bradesco ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 23.01.07 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = String com o c�digo a ser calculado                             ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpC1 = String com o D�gito Verificador                                 ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function Mod11237(cData)

Local nResult	:= 0
Local nSoma		:= 0
Local i			:= 0
Local nTam		:= 13
Local nDc		:= 0
Local nAlg		:= 2
Local nCalNum	:= space(13)

nCalNum:= cData

For i  := nTam To 1 Step -1
	nSoma   := Val(Substr(nCalNum,i,1))*nAlg
	nResult := nResult + nSoma
	nAlg    := nAlg + 1
	If nAlg > 7
		nAlg := 2
	Endif
Next i

nDC  := MOD(nResult,11)
cDig := 11 - nDc

IF nDC == 1
	cDig := "P"
ElseIf nDC == 0
	cDig := 0
	cDig := STR(cDig,1)
Else
	cDig := STR(cDig,1)
EndIF

Return(Alltrim(cDig))


/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TCImpBol � Efetua a impress�o do boleto banc�rio                        ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 20.01.07 �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpO1 = Objeto print                                                    ���
���             � ExpA1 = Array com os dados da Empresa                                   ���
���             � ExpA2 = Array com os dados do Banco                                     ���
���             � ExpA3 = Array com os dados do T�tulo                                    ���
���             � ExpA4 = Array com os dados do Cliente                                   ���
���             � ExpA5 = Array com os dados do C�digo de Barras                          ���
���             � ExpN1 = Tipo de configura��o a ser utilizado (1=Polegadas/2=Cent�metros)���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil                                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             � 28.06.07 - Rubens Lacerda - Inser��o das variaveis cCPF, cSacCNPJ e     ���
���             �            cCedCNPJ para s� aparecer CPF ou CNPJ se existirem os dados  ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function TCImpBol(oPrint,aDadEmp,aDadBco,aDadTit,aDadCli,aBarra,nTpImp)

Local oFont7
Local oFont8
Local oFont10
Local oFont11c
Local oFont14
Local oFont14n
Local oFont15
Local oFont15n
Local oFont16n
Local oFont20
Local oFont21
Local oFont24
Local nLin			:= 0
Local nLoop			:= 0
Local cBmp			:= ""
Local cStartPath	:= AllTrim(GetSrvProfString("StartPath",""))
Local cCPF := Iif( !Empty(aDadCli[4]), "CPF: "+Transform(aDadCli[4],"@R 999.999.999-99"),"")
Local cSacCNPJ := Iif( !Empty(aDadCli[4]), "CNPJ: "+Transform(aDadCli[4],"@R 99.999.999/9999-99"),"")
Local cCedCNPJ := Iif( !Empty(aDadEmp[9]), "CNPJ: "+Transform(aDadEmp[9],"@R 99.999.999/9999-99"),"")

Local VR  := 0
Local VRD := 0


//  Taxa de juros de mora ao m�s por atraso no pagament
VR := (SE1->E1_VALOR-SE1->E1_CSLL-SE1->E1_COFINS-SE1->E1_PIS-SE1->E1_IRRF) *0.0025

//VRD := STRZERO(INT(ROUND((VR)*100,2)),13)



//�����������������������������������������������Ŀ
//� Verifica se existe a barra final no StartPath �
//�������������������������������������������������
If Right(cStartPath,1) <> "\"
	cStartPath+= "\"
EndIf

//�������������������������������������������������Ŀ
//� Monta string com o caminho do logotipo do banco �
//� O Tamanho da figura tem que ser 381 x 68 pixel  �
//� para que a impress�i sai correta                �
//���������������������������������������������������
//cBmp	:= cStartPath+aDadBco[9]
//cBmp	:= "logociti.bmp"
if SA6->A6_COD='745'
	cBmp	:= "logociti.bmp"
else
	cBmp	:= "logoitau.bmp"
endif

//�������������������������������������Ŀ
//� Define as fontes a serem utilizadas �
//���������������������������������������
oFont7		:= TFont():New("Arial",			9,07,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8		:= TFont():New("Arial",			9,08,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10		:= TFont():New("Arial",			9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11c	:= TFont():New("Courier New",	9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14		:= TFont():New("Arial",			9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n	:= TFont():New("Arial",			9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15		:= TFont():New("Arial",			9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n	:= TFont():New("Arial",			9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16n	:= TFont():New("Arial",			9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont20		:= TFont():New("Arial",			9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21		:= TFont():New("Arial",			9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24		:= TFont():New("Arial",			9,24,.T.,.T.,5,.T.,5,.T.,.F.)

//������������������������Ŀ
//� Inicia uma nova p�gina �
//��������������������������
oPrint:StartPage()

//���������������������������������������������Ŀ
//� Define o Primeiro Bloco - Recibo de Entrega �
//�����������������������������������������������
oPrint:Line	(nLin+0150,0500,nLin+0070,0500)															// Quadro
oPrint:Line	(nLin+0150,0710,nLin+0070,0710)												   			// Quadro



//oPrint:SayBitMap(nLin+0084,0100,"logociti.bmp",350,060)											// Logotipo do Banco
oPrint:SayBitMap(nLin+0084,0100,cbmp,350,060)											// Logotipo do Banco

oPrint:Say	(nLin+0075,0513,	aDadBco[1]+"-"+aDadBco[2],								oFont21)	// N�mero do Banco + D�gito

oPrint:Say	(nLin+0084,1900,	"Comprovante de Entrega",								oFont10)	// Texto Fixo
oPrint:Line	(nLin+0150,0100,nLin+0150,2300)															// Quadro

oPrint:Say  (nLin+0150,0100,	"Cedente",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+0200,0100,	aDadEmp[1],												oFont10)	// Nome da Empresa

oPrint:Say  (nLin+0150,1060,	"Ag�ncia/C�digo Cedente",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+0200,1110,	AllTrim(aDadBco[15]),									oFont10)	// Agencia + C�d.Cedente

//oPrint:Say  (nLin+0150,1510,	"Nro.Documento",										oFont8)		// Texto fixo
//oPrint:Say  (nLin+0200,1560,	aDadTit[1]+aDadTit[2]+aDadTit[3],						oFont10)	// Prefixo + Numero + Parcela

oPrint:Say  (nLin+0150,1510,	"Nro.Documento",										oFont8)		// Texto fixo
oPrint:Say  (nLin+0200,1560,	aDadTit[17],                         					oFont10)	// ID CNAB

oPrint:Say  (nLin+0250,0100,	"Sacado",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+0300,0100,	aDadCli[3],												oFont10)	// Nome do Cliente

oPrint:Say  (nLin+0250,1060,	"Vencimento",											oFont8)		// Texto Fixo
//oPrint:Say  (nLin+0300,1110,	DToC(aDadTit[6]),										oFont10)	// Data de Vencimento
oPrint:Say  (nLin+0300,1110,	DToC(aDadTit[7]),										oFont10)	// Data de Vencimento REAL (E1_VENCREA)

oPrint:Say  (nLin+0250,1510,	"Valor do Documento",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+0300,1560,	Transform(aDadTit[8],"@E 9999,999,999.99"),				oFont10)	// Valor do T�tulo

oPrint:Say  (nLin+0400,0100,	"Recebi(emos) o bloqueto/t�tulo",						oFont10)	// Texto Fixo
oPrint:Say  (nLin+0450,0100,	"com as caracter�sticas acima.",						oFont10)	// Texto Fixo
oPrint:Say  (nLin+0350,1060,	"Data",													oFont8)		// Texto Fixo
oPrint:Say  (nLin+0350,1410,	"Assinatura",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0450,1060,	"Data",													oFont8)		// Texto Fixo
oPrint:Say  (nLin+0450,1410,	"Entregador",											oFont8)		// Texto Fixo

oPrint:Line (nLin+0250,0100,nLin+0250,1900 )														// Quadro
oPrint:Line (nLin+0350,0100,nLin+0350,1900 )														// Quadro
oPrint:Line (nLin+0450,1050,nLin+0450,1900 )														// Quadro
oPrint:Line (nLin+0550,0100,nLin+0550,2300 )														// Quadro

oPrint:Line (nLin+0550,1050,nLin+0150,1050 )														// Quadro
oPrint:Line (nLin+0550,1400,nLin+0350,1400 )														// Quadro
oPrint:Line (nLin+0350,1500,nLin+0150,1500 )														// Quadro
oPrint:Line (nLin+0550,1900,nLin+0150,1900 )														// Quadro

oPrint:Say  (nLin+0165,1910,	"(  ) Mudou-se",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+0205,1910,	"(  ) Ausente",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0245,1910,	"(  ) N�o existe n� indicado",							oFont8)		// Texto Fixo
oPrint:Say  (nLin+0285,1910,	"(  ) Recusado",			 							oFont8)		// Texto Fixo
oPrint:Say  (nLin+0325,1910,	"(  ) N�o procurado",		 							oFont8)		// Texto Fixo
oPrint:Say  (nLin+0365,1910,	"(  ) Endere�o insuficiente",							oFont8)		// Texto Fixo
oPrint:Say  (nLin+0405,1910,	"(  ) Desconhecido",		 							oFont8)		// Texto Fixo
oPrint:Say  (nLin+0445,1910,	"(  ) Falecido",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+0485,1910,	"(  ) Outros(anotar no verso)",							oFont8)		// Texto Fixo

//����������������������Ŀ
//� Pontilhado separador �
//������������������������
nLin+= 0200
For nLoop := 100 to 2300 Step 50
	oPrint:Line(nLin+0580, nLoop,nLin+0580, nLoop+30)												// Linha pontilhada
Next nI

//�������������������������������������������Ŀ
//� Define o Segundo Bloco - Recibo do Sacado �
//���������������������������������������������
oPrint:Line (nLin+0710,0100,nLin+0710,2300)														// Quadro
oPrint:Line (nLin+0710,0500,nLin+0630,0500)														// Quadro
oPrint:Line (nLin+0710,0710,nLin+0630,0710)														// Quadro


//oPrint:SayBitMap(nLin+0644,0100,"logociti.Bmp",350,060)											// Logotipo do Banco
oPrint:SayBitMap(nLin+0644,0100,cBmp,350,060)											// Logotipo do Banco


oPrint:Say  (nLin+0635,0513,	aDadBco[1]+"-"+aDadBco[2],								oFont21)	// Numero do Banco + D�gito
oPrint:Say  (nLin+0644,1900,	"Recibo do Sacado",										oFont10)	// Texto Fixo

oPrint:Line (nLin+0810,0100,nLin+0810,2300)														// Quadro
oPrint:Line (nLin+0910,0100,nLin+0910,2300)														// Quadro
oPrint:Line (nLin+0980,0100,nLin+0980,2300)														// Quadro
oPrint:Line (nLin+1050,0100,nLin+1050,2300)														// Quadro

oPrint:Line (nLin+0910,0500,nLin+1050,0500)														// Quadro
oPrint:Line (nLin+0980,0750,nLin+1050,0750)														// Quadro
oPrint:Line (nLin+0910,1000,nLin+1050,1000)														// Quadro
oPrint:Line (nLin+0910,1300,nLin+0980,1300)														// Quadro
oPrint:Line (nLin+0910,1480,nLin+1050,1480)														// Quadro

oPrint:Say  (nLin+0710,0100 ,	"Local de Pagamento",									oFont8)		// Texto Fixo
//oPrint:Say  (nLin+0725,0400 ,	"AT� O VENCIMENTO, PREFERENCIALMENTE NO "+Upper(aDadBco[8]),;
//																						oFont10)	// 1a. Linha de Local Pagamento
//oPrint:Say  (nLin+0765,0400 ,	"AP�S O VENCIMENTO, SOMENTE NO "+Upper(aDadBco[8]),;
//																			 			oFont10)	// 2a. Linha de Local Pagamento

oPrint:Say  (nLin+0725,0400 ,	"PAGAVEL NA REDE BANCARIA AT� O VENCIMENTO. ",;
oFont10)	// 1a. Linha de Local Pagamento
oPrint:Say  (nLin+0765,0400 ,	"                             ",;
oFont10)	// 2a. Linha de Local Pagamento



oPrint:Say  (nLin+0710,1810,	"Vencimento",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0750,2000,	StrZero(Day(aDadTit[7]),2) +"/"+;
StrZero(Month(aDadTit[7]),2) +"/"+;
StrZero(Year(aDadTit[7]),4),					 		oFont11c)	// Vencimento

oPrint:Say  (nLin+0810,0100,	"Cedente",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+0850,0100,	AllTrim(aDadEmp[1])+" - "+cCedCNPJ,				oFont10)	// Nome + CNPJ

oPrint:Say  (nLin+0810,1810,	"Ag�ncia/C�digo Cedente",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+0850,1900,	AllTrim(aDadBco[15]),									oFont11c)	// Agencia + C�d.Cedente + D�gito


oPrint:Say  (nLin+0910,0100,	"Data do Documento",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+0940,0150,	StrZero(Day(aDadTit[5]),2)+"/"+ ;
StrZero(Month(aDadTit[5]),2)+"/"+ ;
Right(Str(Year(aDadTit[5])),4),						oFont10)	// Data do Documento

//oPrint:Say  (nLin+0910,0505,	"Nro.Documento",										oFont8)		// Texto Fixo
//oPrint:Say  (nLin+0940,0605,	aDadTit[1]+aDadTit[2]+aDadTit[3],						oFont10)	// Prefixo + Numero + Parcela

oPrint:Say  (nLin+0910,0505,	"Nro.Documento",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+0940,0605,	aDadTit[17],                        					oFont10)	// ID CNAB

oPrint:Say  (nLin+0910,1005,	"Esp�cie Doc.",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0940,1055,	aDadBco[14],											oFont10)	// Tipo do Titulo

oPrint:Say  (nLin+0910,1305,	"Aceite",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+0940,1400,	"NAO",													oFont10)	// Texto Fixo

oPrint:Say  (nLin+0910,1485,	"Data do Processamento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+0940,1550,	StrZero(Day(dDataBase),2)+"/"+ ;
StrZero(Month(dDataBase),2)+"/"+ ;
StrZero(Year(dDataBase),4),								oFont10)	// Data impressao

oPrint:Say  (nLin+0910,1810,	"Nosso N�mero",	    									oFont8)		// Texto Fixo
oPrint:Say  (nLin+0940,1900,	aBarra[4],												oFont11c)	// Nosso N�mero

oPrint:Say  (nLin+0980,0100,	"Uso do Banco",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+1010,0150,	aDadBco[13],											oFont10)	// Texto Fixo

oPrint:Say  (nLin+0980,0505,	"Carteira",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+1010,0555,	aDadTit[10],											oFont10)	// Carteira

oPrint:Say  (nLin+0980,0755,	"Esp�cie",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+1010,0805,	"R$",													oFont10)	// Texto Fixo

oPrint:Say  (nLin+0980,1005,	"Quantidade",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+0980,1485,	"Valor",												oFont8)		// Texto Fixo

oPrint:Say  (nLin+0980,1810,	"Valor do Documento",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+1010,1900,	Transform(aDadTit[8],"@E 9999,999,999.99"),				oFont11c)	// Valor do T�tulo

oPrint:Say  (nLin+1050,0100,	"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)", oFont8)		// Texto Fixo

oPrint:Say  (nLin+1100,0100,	"TITULOS EMITIDOS EM REAIS"			, oFont7)	// 1a Linha Instru��o
oPrint:Say  (nLin+1100,0550,    aDadTit[1]+aDadTit[2]+aDadTit[3],   	oFont7)	// Prefixo + Numero + Parcela
//oPrint:Say  (nLin+1100,0100,	aDadTit[11],											oFont10)	// 1a Linha Instru��o
//oPrint:Say  (nLin+1150,0100,	aDadTit[12],											oFont7)	// 2a. Linha Instru��o

oPrint:Say  (nLin+1150,0100,	"MORA POR DIA DE ATRASO "	, oFont7)	// 2a. Linha Instru��o
oPrint:Say  (nLin+1150,0500,    transform(VR ,"@E 9999,999,999.99")	, oFont7)	// 2a. Linha Instru��o

//oPrint:Say  (nLin+1200,0100,	aDadTit[13],											oFont10)	// 3a. Linha Instru��o
if aDadBco[1]='745'
	oPrint:Say  (nLin+1200,0100,	"APOS O VENCIMENTO PAGAR NAS AGENCIAS DO CITIBANK,BANCO MERCANTIL DO BRASIL",	oFont8)	// 3a. Linha Instru��o
	//oPrint:Say  (nLin+1250,0100,	aDadTit[14],											oFont10)	// 4a. Linha Instru��o
	oPrint:Say  (nLin+1250,0100,   "BANCO RURAL,BICBANCO,BANCO CIDADE, OU CAIXA FEDERAL COM OS JUROS DEVIDOS"	,	oFont8)	// 4a. Linha Instru��o
Else
	oPrint:Say  (nLin+1200,0100,	"TITULO SUJEITO A PROTESTO - APOS O VENCIMENTO ACESSAR O SITE: WWW.ITAU.COM.BR/BOLETOS ",	oFont8)	// 3a. Linha Instru��o
	oPrint:Say  (nLin+1250,0100,   "OU ENTRAR EM CONTATO PELO E-MAIL CONTASARECEBER@T4F.COM.BR "	,	oFont8)	// 4a. Linha Instru��o
Endif

oPrint:Say  (nLin+1300,0100,	aDadTit[15],											oFont10)	// 5a. Linha Instru��o
oPrint:Say  (nLin+1350,0100,	aDadTit[16],											oFont10)	// 6a. Linha Instru��o

oPrint:Say  (nLin+1050,1810,	"(-)Desconto/Abatimento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+1120,1810,	"(-)Outras Dedu��es",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+1190,1810,	"(+)Mora/Multa",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+1260,1810,	"(+)Outros Acr�scimos",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+1330,1810,	"(=)Valor Cobrado",										oFont8)		// Texto Fixo

oPrint:Say  (nLin+1400,0100,	"Sacado",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+1430,0200,	" ("+aDaDCli[1]+"-"+aDadCli[2]+") "+aDadCli[3],		oFont10)	// C�digo + Nome do Cliente

If aDadCli[6] = "J"
	oPrint:Say  (nLin+1430,1850,cSacCNPJ,  						  		oFont10)	// CGC
Else
	oPrint:Say  (nLin+1430,1850,cCPF,										oFont10)	// CPF
EndIf

oPrint:Say  (nLin+1483,0200,	AllTrim(aDadCli[7])+" "+AllTrim(aDadCli[8]),			oFont10)	// Endere�o + Bairro
oPrint:Say  (nLin+1536,0200,	Transform(aDadCli[11],"@R 99999-999")+" - "+ ;
AllTrim(aDadCli[9])+" - "+ ;
AllTrim(aDadCli[10]),							oFont10)	// CEP + Cidade + Estado

oPrint:Say  (nLin+1589,1850,	aBarra[4],												oFont10)	// Nosso N�mero

oPrint:Say  (nLin+1605,0100,	"Sacador/Avalista",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+1645,1500,	"Autentica��o Mec�nica",								oFont8)		// Texto Fixo

oPrint:Line (nLin+0710,1800,nLin+1400,1800)														// Quadro
oPrint:Line (nLin+1120,1800,nLin+1120,2300)														// Quadro
oPrint:Line (nLin+1190,1800,nLin+1190,2300)														// Quadro
oPrint:Line (nLin+1260,1800,nLin+1260,2300)														// Quadro
oPrint:Line (nLin+1330,1800,nLin+1330,2300)														// Quadro
oPrint:Line (nLin+1400,0100,nLin+1400,2300)														// Quadro
oPrint:Line (nLin+1640,0100,nLin+1640,2300)														// Quadro

//����������������������Ŀ
//� Pontilhado separador �
//������������������������
nLin	:= 100
For nLoop := 100 To 2300 Step 50
	oPrint:Line(nLin+1880, nLoop, nLin+1880, nLoop+30)												// Linha Pontilhada
Next nI

//������������������������������������������������Ŀ
//� Define o Terceiro Bloco - Ficha de Compensa��o �
//��������������������������������������������������
oPrint:Line (nLin+2000,0100,nLin+2000,2300)														// Quadro
oPrint:Line (nLin+2000,0500,nLin+1920,0500)														// Quadro
oPrint:Line (nLin+2000,0710,nLin+1920,0710)														// Quadro


//oPrint:SayBitMap(nLin+1934,0100,"logociti.bmp",350,060)											// Logotipo do Banco
oPrint:SayBitMap(nLin+1934,0100,cbmp,350,060)											// Logotipo do Banco

oPrint:Say  (nLin+1925,0513,	aDadBco[1]+"-"+aDadBco[2],								oFont21)	// Numero do Banco + D�gito
oPrint:Say  (nLin+1934,0755,	aBarra[2],												oFont15n)	// Linha Digitavel do Codigo de Barras

oPrint:Line (nLin+2100,100,nLin+2100,2300 )														// Quadro
oPrint:Line (nLin+2200,100,nLin+2200,2300 )														// Quadro
oPrint:Line (nLin+2270,100,nLin+2270,2300 )														// Quadro
oPrint:Line (nLin+2340,100,nLin+2340,2300 )														// Quadro

oPrint:Line (nLin+2200,0500,nLin+2340,0500)														// Quadro
oPrint:Line (nLin+2270,0750,nLin+2340,0750)														// Quadro
oPrint:Line (nLin+2200,1000,nLin+2340,1000)														// Quadro
oPrint:Line (nLin+2200,1300,nLin+2270,1300)														// Quadro
oPrint:Line (nLin+2200,1480,nLin+2340,1480)														// Quadro

oPrint:Say  (nLin+2000,0100,	"Local de Pagamento",									oFont8)		// Texto Fixo
//oPrint:Say  (nLin+2015,0400,	"AT� O VENCIMENTO, PREFERENCIALMENTE NO "+aDadBco[8],	oFont10)	// Texto Fixo
//oPrint:Say  (nLin+2055,0400 ,	"AP�S O VENCIMENTO, SOMENTE NO "+aDadBco[8],			oFont10)	// Texto Fixo

oPrint:Say  (nLin+2015,0400,	"PAGAVEL NA REDE BANCARIA AT� O VENCIMENTO. ",	oFont10)	// Texto Fixo
oPrint:Say  (nLin+2055,0400 ,	"     								",			oFont10)	// Texto Fixo


oPrint:Say  (nLin+2000,1810,	"Vencimento",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+2040,1900,	StrZero(Day(aDadTit[7]),2)+"/"+;
StrZero(Month(aDadTit[7]),2)+"/"+;
StrZero(Year(aDadTit[7]),4),							oFont11c)	// Vencimento

oPrint:Say  (nLin+2100,0100,	"Cedente",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+2140,0100,	AllTrim(aDadEmp[1])+" - "+cCedCNPJ,				oFont10)	// Nome + CNPJ

oPrint:Say  (nLin+2100,1810,	"Ag�ncia/C�digo Cedente",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+2140,1900,	AllTrim(aDadBco[15]),									oFont11c)	// Agencia + C�d.Cedente + D�gito


oPrint:Say  (nLin+2200,0100,	"Data do Documento",									oFont8)		// Texto Fixo
oPrint:Say	(nLin+2230,0100, 	StrZero(Day(aDadTit[5]),2)+"/"+ ;
StrZero(Month(aDadTit[5]),2)+"/"+ ;
StrZero(Year(aDadTit[5]),4),		 					oFont10)	// Vencimento

//oPrint:Say  (nLin+2200,0505,	"Nro.Documento",										oFont8)		// Texto Fixo
//oPrint:Say  (nLin+2230,0605,	aDadTit[1]+aDadTit[2]+aDadTit[3],						oFont10)	// Prefixo + Numero + Parcela

oPrint:Say  (nLin+2200,0505,	"Nro.Documento",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+2230,0605,	aDadTit[17],					                     	oFont10)	// ID CNAB

oPrint:Say  (nLin+2200,1005,	"Esp�cie Doc.",						   					oFont8)		// Texto Fixo
oPrint:Say  (nLin+2230,1050,	aDadBco[14],											oFont10)	//Tipo do Titulo

oPrint:Say  (nLin+2200,1305,	"Aceite",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+2230,1400,	"NAO",													oFont10)	// Texto Fixo

oPrint:Say  (nLin+2200,1485,	"Data do Processamento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+2230,1550,	StrZero(Day(dDataBase),2)+"/"+ ;
StrZero(Month(dDataBase),2)+"/"+ ;
StrZero(Year(dDataBase),4),								oFont10)	// Data impressao

oPrint:Say  (nLin+2200,1810,	"Nosso N�mero",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+2230,1900,	aBarra[4],												oFont11c)	// Nosso N�mero

oPrint:Say  (nLin+2270,0100,	"Uso do Banco",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+2300,0150,	aDadBco[13],											oFont10)	// Texto Fixo

oPrint:Say  (nLin+2270,0505,	"Carteira",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+2300,0555,	aDadTit[10],											oFont10)

oPrint:Say  (nLin+2270,0755,	"Esp�cie",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+2300,0805,	"R$",													oFont10)	// Texto Fixo

oPrint:Say  (nLin+2270,1005,	"Quantidade",											oFont8)		// Texto Fixo
oPrint:Say  (nLin+2270,1485,	"Valor",												oFont8)		// Texto Fixo

oPrint:Say  (nLin+2270,1810,	"Valor do Documento",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+2300,1900,	Transform(aDadTit[8], "@E 9999,999,999.99"),			oFont11c)	// Valor do Documento

oPrint:Say  (nLin+2340,0100,	"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",;
oFont8)		// Texto Fixo


oPrint:Say  (nLin+2400,0100,	"TITULOS EMITIDOS EM REAIS"			, oFont7)	// 1a Linha Instru��o
oPrint:Say  (nLin+2400,0550,    aDadTit[1]+aDadTit[2]+aDadTit[3],   	oFont7)	// Prefixo + Numero + Parcela

oPrint:Say  (nLin+2450,0100,	"MORA POR DIA DE ATRASO "	, oFont7)	// 2a. Linha Instru��o
oPrint:Say  (nLin+2450,0500,    transform(VR ,"@E 9999,999,999.99")						, oFont7)	// 2a. Linha Instru��o

if aDadBco[1]='745'
	oPrint:Say  (nLin+2500,0100,	"APOS O VENCIMENTO PAGAR NAS AGENCIAS DO CITIBANK,BANCO MERCANTIL DO BRASIL",	oFont8)	// 3a. Linha Instru��o
	oPrint:Say  (nLin+2550,0100,   "BANCO RURAL,BICBANCO,BANCO CIDADE, OU CAIXA FEDERAL COM OS JUROS DEVIDOS"	,	oFont8)	// 4a. Linha Instru��o
Else
	oPrint:Say  (nLin+2500,0100,	"TITULO SUJEITO A PROTESTO - APOS O VENCIMENTO ACESSAR O SITE: WWW.ITAU.COM.BR/BOLETOS ",	oFont8)	// 3a. Linha Instru��o
	oPrint:Say  (nLin+2550,0100,   "OU ENTRAR EM CONTATO PELO E-MAIL CONTASARECEBER@T4F.COM.BR "	,	oFont8)	// 4a. Linha Instru��o
Endif

//oPrint:Say  (nLin+2500,0100,	"APOS O VENCIMENTO PAGAR NAS AGENCIAS DO CITIBANK,BANCO MERCANTIL DO BRASIL",	oFont8)	// 3a. Linha Instru��o
//oPrint:Say  (nLin+2550,0100,   "BANCO RURAL,BICBANCO,BANCO CIDADE, OU CAIXA FEDERAL COM OS JUROS DEVIDOS"	,	oFont8)	// 4a. Linha Instru��o

//oPrint:Say  (nLin+2400,0100,	aDadTit[11],											oFont10)	// 1a Linha Instru��o
//oPrint:Say  (nLin+2450,0100,	aDadTit[12],											oFont10)	// 2a. Linha Instru��o
//oPrint:Say  (nLin+2500,0100,	aDadTit[13],											oFont10)	// 3a. Linha Instru��o
//oPrint:Say  (nLin+2550,0100,	aDadTit[14],											oFont10)	// 4a. Linha Instru��o
oPrint:Say  (nLin+2600,0100,	aDadTit[15],											oFont10)	// 5a. Linha Instru��o
oPrint:Say  (nLin+2650,0100,	aDadTit[16],											oFont10)	// 6a. Linha Instru��o

oPrint:Say  (nLin+2340,1810,	"(-)Desconto/Abatimento",								oFont8)		// Texto Fixo
oPrint:Say  (nLin+2410,1810,	"(-)Outras Dedu��es",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+2480,1810,	"(+)Mora/Multa",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+2550,1810,	"(+)Outros Acr�scimos",									oFont8)		// Texto Fixo
oPrint:Say  (nLin+2620,1810,	"(=)Valor Cobrado",										oFont8)		// Texto Fixo

oPrint:Say  (nLin+2690,0100,	"Sacado",												oFont8)		// Texto Fixo
oPrint:Say  (nLin+2700,0200,	" ("+aDadCli[1]+"-"+aDadCli[2]+") "+aDadCli[3],		oFont10)	// Nome Cliente + C�digo

If aDadCli[6] = "J"
	oPrint:Say  (nLin+2700,1850, cSacCNPJ,														oFont10)	// CGC
Else
	oPrint:Say  (nLin+2700,1850, cCPF,															oFont10)	// CPF
EndIf

oPrint:Say  (nLin+2753,0200,	Alltrim(aDadCli[7])+" "+AllTrim(aDadCli[8]),			oFont10)	// Endere�o
oPrint:Say  (nLin+2806,0200,	Transform(aDadCli[11],"@R 99999-999")+" - "+;
AllTrim(aDadCli[9])+" - "+AllTrim(aDadCli[10]),		oFont10)	// CEP + Cidade + Estado

oPrint:Say  (nLin+2806,1850,	aBarra[4],												oFont10)	// Carteira + Nosso N�mero

oPrint:Say  (nLin+2855,0100,	"Sacador/Avalista",										oFont8)		// Texto Fixo
oPrint:Say  (nLin+2895,1500,	"Autentica��o Mec�nica - Ficha de Compensa��o",			oFont8)		// Texto Fixo

oPrint:Line (nLin+2000,1800,nLin+2690,1800)														// Quadro
oPrint:Line (nLin+2410,1800,nLin+2410,2300)														// Quadro
oPrint:Line (nLin+2480,1800,nLin+2480,2300)														// Quadro
oPrint:Line (nLin+2550,1800,nLin+2550,2300)														// Quadro
oPrint:Line (nLin+2620,1800,nLin+2620,2300)														// Quadro
oPrint:Line (nLin+2690,0100,nLin+2690,2300)														// Quadro
oPrint:Line (nLin+2890,0100,nLin+2890,2300)														// Quadro

//���������������������������Ŀ
//� Se Impress�o em polegadas �
//� 			              �
//�����������������������������
If nTpImp == 1
	MSBAR(	"INT25",;
	13.7,;
	0.8,;
	aBarra[1],;
	oPrint,;
	.F.,;
	Nil,;
	Nil,;
	0.013,;
	0.7,;
	Nil,;
	Nil,;
	"A",;
	.F.)
	//�����������������������������Ŀ
	//� Se Impress�o em cent�metros �
	//� 			                �
	//�������������������������������
Else
	MSBAR(	"INT25",;			// Tipo do c�digo (EAN13,EAN8,UPCA,SUP5,CODE128,INT25,MAT25,IND25,CODABAR,CODE3_9,EAN128)
	26.0,;				// N�mero da linha em cent�metros
	0.8,;				// N�mero da coluna em cent�metros
	aBarra[1],;			// String com o conte�do do c�digo
	oPrint,;			// Objeto printer
	.F.,;				// Se calcula o d�gito de controle
	Nil,;				// N�mero da Cor (utilizar a Common.ch)
	Nil,;				// Se imprime na horizontal
	0.025,;				// N�mero do tamanho da barra em cent�metros
	1.5,;				// N�mero da altura da barra em mil�metros
	Nil,;				// Imprime linha embaixo do c�digo
	Nil,;				// String com o tipo de fonte
	"A",;				// String com o modo do c�digo de barras
	.F.)				// ??
EndIf

oPrint:EndPage() // Finaliza a p�gina

Return(Nil)


/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � TCArqRem � Retorna conte�dos para o arquivo de remessa dos bancos       ���
���             �          �                                                              ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 08.02.07 �  			                                                  ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = nome do campo que dever� ser retornado                          ���
���             � ExpN1 = Tamanho do campo                                                ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpC1 = String para preenchimento do campo                              ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es � Os arquivos devem estar posicionados SE1, SA1, SEE, SA6                 ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function TCCobRem( cBanco, cCampo, nTamanho )

Local cRetorno	:= Space(nTamanho)
Local nAbatim	:= 0
Local nValLiq	:= 0

Do Case
	Case cCampo == "IDEMPRESA"
		If cBanco == "745"
			cRetorno	:= SubStr(SEE->EE_CODEMP,2,7)
			cRetorno	+= SubStr(SEE->EE_CODEMP,3,6)
			cRetorno	+= SubStr(SEE->EE_CODEMP,8,3)
			cRetorno	+= "0"
			cRetorno	+= SEE->EE_SUBCTA
		EndIf
	Case cCampo == "VLRLIQ"
		nAbatim		:= SomaAbat(	SE1->E1_PREFIXO,;
		SE1->E1_NUM,;
		SE1->E1_PARCELA,;
		"R",;
		SE1->E1_MOEDA,;
		dDataBase,;
		SE1->E1_CLIENTE,;
		SE1->E1_LOJA )
		nValLiq		:= SE1->E1_SALDO + SE1->E1_SDACRES - SE1->E1_SDDECRE - nAbatim
		cRetorno	:= StrZero( ( nValLiq * 100 ), nTamanho )
	Case cCampo == "NNUMERO"
		cRetorno	:= AllTrim(SE1->E1_NUMBCO)
		cRetorno	+= U_TCCalcDV( cBanco, AllTrim( SE1->E1_NUMBCO ) )
	OtherWise
		cRetorno	:= Space(nTamanho)
EndCase

Return( cRetorno )

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �T4FSaldoTit�Autor  �Gilberto Oliveira   � Data �  24/08/11   ���
��������������������������������������������������������������������������͹��
���Desc.     �Saldo do titulo para impressao do boleto.                    ���
���          �Transformado em funcao para ser tambem utilizado na geracao  ���
���          �do arquivo .REM (funcao VRCITI)                              ���
��������������������������������������������������������������������������͹��
���Uso       � AP                                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function T4FSaldoTit(lSaldo,nRecno)
Local nSaldo:= 0

SE1->(DbGoto(nRecno)) // Forca posicionamento.

If lSaldo
	nSaldo	:= SE1->E1_SALDO
Else
	nSaldo	:= SE1->E1_VALOR
EndIf
nSaldo	-= SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
nSaldo	-= SE1->E1_DECRESC
nSaldo	+= SE1->E1_ACRESC

Return(nSaldo)
