#Include "PROTHEUS.CH"
//--------------------------------------------------------------
// Luiz Eduardo - 22/05/2017
// Ponto de entrada para permitir a exclusão de borderôs de contas a pagar somente para usuários
// que já tenham sido enviados ao banco e limpe o campo E2_XPLACA
//--------------------------------------------------------------
User Function F240Can()

//Deleto o numero do bordero em todos os titulos de abatimentos

Select SE2
dbSetOrder(1)      
seek xFilial()+SEA->(EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA)
RecLock("SE2",.f.)
SE2->E2_XPLACA := " "
MsUnlock()
FKCOMMIT()

Return(.t.)
