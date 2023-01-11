//Bibliotecas
#include 'totvs.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ��
//���Program   � APROMEURH � Autor � Rafael Augusto   � Data � 16.03.2021   ���
//�������������������������������������������������������������������������Ĵ��
//���Descricao � Desenvolvimento responsavel por efeutar as aprovacoes das  ���
//���          � marcacoes incluidas pelo MEU RH, quando estiverem no status���
//���          � Aguardando RH.                                             ���
//�������������������������������������������������������������������������Ĵ��
//���Uso       � T4F - CRM SERVICES LTDA.   					            ���
//��������������������������������������������������������������������������ٱ�
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

User Function APROMEURH()

	Local cEmp          := "08"  //codigo da empresa
	Local cFil          := "01"  //codigo da filial
	Local cQuery		:= ""
	Local nRet          := 0
	Local cMsg			:= ""
	Local cAviso		:= ""
	Local _cUpdate		:= ""
	Local aFilesOpen 	:=	{"SP5", "SPN", "SP8", "SPG","SPB","SPL","SPC", "SPH", "SPF"}  
	Local nLoops  


	RPCSetType(3)  //Nao consome licensas

	RpcSetEnv( cEmp , cFil ) //Abertura do ambiente

	If Select("QRY_RH3") > 0
		DbSelectArea("QRY_RH3")
		DbCloseArea()
	EndIf

	nLoops := Len( aFilesOpen )  
	For nLoop := 1 To nLoops
		IF !( lLocked := ChkFile( aFilesOpen[ nLoop ],.F.) ) 
			Conout("Erro tabela em uso"+aFilesOpen[nLoop])
			Return
		EndIF
	Next nLoop 

	cQuery := "Select * FROM " + RetSqlName("RH3")
	cQuery += " WHERE D_E_L_E_T_ = ' ' "
	cQuery += " AND RH3_STATUS = '4' "
	cQuery += " AND RH3_NVLAPR = '99' "
	cQuery += " AND RH3_DTATEN = ' ' "
	cQuery += " AND RH3_TIPO = 'Z' "

	TCQuery cQuery New Alias "QRY_RH3"

	dbSelectArea("QRY_RH3")
	dbGotop()

	//carrega itens da query
	While QRY_RH3->( !EOF() )

		//fAprovPon - Realiza a aprovacao das solicitacoes de marcacoes do Portal e do MeuRH.
		//Parametros:	cFilSRA - Filial;
		//              cMatSRA - Matricula;
		//              cCodRH3 - Codigo da solicitacao;
		//              cMsg - Mensagens de erro durante a geracao da marcacao;
		//              cAviso - Mensagens de erro durante a geracao da marcacao;
		//              lUpdRH3 - Se atualiza o status da requisicao marcando como aprovado;
		//Retorno:	Zero (0) quando a operacao foi realizada com sucesso

		nRet := fAprovPon( QRY_RH3->RH3_FILIAL, QRY_RH3->RH3_MAT, QRY_RH3->RH3_CODIGO, @cMsg, @cAviso, .F. )

		DbSelectArea("SRA")
		DbSetOrder(1)
		SRA->(DbSeek(QRY_RH3->RH3_FILIAL + QRY_RH3->RH3_MAT))

		If nRet == 1

			Conout("Erro liberacao apontamento MEU RH")
			Conout(cMsg)
			Conout(cAviso)

		ElseIf nRet == 2

			Conout("Erro liberacao apontamento MEU RH")
			Conout("Marcacao esta fora do periodo aberto, nao pode ser incluida!")
			Conout(QRY_RH3->RH3_MAT+' '+QRY_RH3->RH3_CODIGO)

		Else

			_cUpdate	:= "UPDATE " + RetSQLName("RH3")
			_cUpdate	+= " SET RH3_STATUS = '2', "
			_cUpdate	+= " RH3_DTATEN = '" + Dtos(dDataBase) + "' "
			_cUpdate	+= " WHERE R_E_C_N_O_ = '" + STR(QRY_RH3->R_E_C_N_O_) + "' " 
			_cUpdate	+= " AND D_E_L_E_T_ <> '*'  "

			TCSQLExec(_cUpdate)

		EndIf

		QRY_RH3->( dbSkip() )
	EndDo

	QRY_RH3->( dbCloseArea() )

	RpcClearEnv() //Limpa o ambiente, liberando a licenca e fechando as conexoes

Return
