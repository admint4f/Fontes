#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} T4F01ZAE
@description ** Browse cadastro para configuração das regras de integração INTI **
@type function
@version 1.00 
@author Rogério Costa
@since 13/10/2020
@return return_type, Nil
/*/

User function T4F01ZAE()

    Local oBrowse

    DbSelectArea('ZAE')

//Cria o objeto do tipo FWMBrowse
    oBrowse := FWMBrowse():New()

//Alias ta tabela a ser utilizada no browse
    oBrowse:SetAlias('ZAE')

//Descrição da rotina
    oBrowse:SetDescription("Configuração de Integração INTI")

    oBrowse:AddLegend( "ZAE->ZAE_MSBLQL==' ' .OR. ZAE->ZAE_MSBLQL=='2'", "GREEN")
    oBrowse:AddLegend( "ZAE->ZAE_MSBLQL=='1'", "RED")

    oBrowse:SetMenuDef('T4F01ZAE')

    oBrowse:Activate()

Return

/*/{Protheus.doc} ModelDef
@description ** Define o modelo de dados **
@type function
@version 1.00
@author Rogério Costa
@since 13/10/2020
@return Objeto, oModel
/*/
Static Function ModelDef()

// Cria a estrutura a ser usada no Model
    Local oStruZAE      := FWFormStruct( 1, 'ZAE', /*bAvalCampo*/, /*lViewUsado*/ )
    Local oModel
    Local bPosValidacao := {||u_VldZAE(oModel)}


//Cria o objeto do Modelo de Dados
    oModel := MPFormModel():New( 'Cadastro Regras', /*bPreValidacao*/ , bPosValidacao, /*bCommit*/, /*bCancel*/ )
    oModel:SetDescription('Cadastro Regras')
//Adiciona ao modelo uma estrutura de formulário de edição por campo (antiga enchoice)
    oModel:AddFields( 'ZAEMASTER', /*cOwner*/, oStruZAE, )

//Chave Primaria
    oModel:SetPrimaryKey({"ZAE_FILIAL,ZAE_EPEP"})

//Adiciona a descricao do Modelo de Dados
    oModel:SetDescription("Configuração de Integração INTI")

//Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZAEMASTER' ):SetDescription( 'Master' )

Return oModel

/*/{Protheus.doc} ViewDef
@description ** Define a interface com usuario **
@type function
@version 1.00
@author Rogério Costa
@since 13/10/2020
@return Objeto, oView, Objeto
/*/
Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
    Local oModel   	 :=  FWLoadModel( 'T4F01ZAE' )
    Local oView

// Cria a estrutura a ser usada na View
    Local oStruZAE 	:= FWFormStruct( 2, 'ZAE' )

// Cria o objeto de View
    oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
    oView:SetModel( oModel )

    oStruZAE:AddGroup("GrpCli", "Dados Promotor", "", 2)
    oStruZAE:AddGroup("GrpEv",  "Evento", "", 2)
    oStruZAE:AddGroup("GrpReg", "Regras INTI", "", 2)
    oStruZAE:AddGroup("GrpPed", "Dados Pedido", "", 2)

    //Dados Promotor
    oStruZAE:SetProperty("ZAE_CODIGO"	, MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZAE:SetProperty("ZAE_CDPROM" 	, MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZAE:SetProperty("ZAE_DIASTR" 	, MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZAE:SetProperty("ZAE_TPREPA" 	, MVC_VIEW_GROUP_NUMBER, "GrpCli")

    //Regras INTI
    oStruZAE:SetProperty("ZAE_TPTRAN" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAE:SetProperty("ZAE_TPRECB" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAE:SetProperty("ZAE_TPVEND"	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAE:SetProperty("ZAE_ENTIDA" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAE:SetProperty("ZAE_RECEIT" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")

    //Evento
    oStruZAE:SetProperty("ZAE_EPEP" 	, MVC_VIEW_GROUP_NUMBER, "GrpEv")
    oStruZAE:SetProperty("ZAE_EVENTO" 	, MVC_VIEW_GROUP_NUMBER, "GrpEv")
    
    //DADOS PEDIDO
    oStruZAE:SetProperty("ZAE_PRDTKT" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PRDTXO" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PRDTXS" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PRDTXC" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PRDTXI" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PDTXCA" , MVC_VIEW_GROUP_NUMBER, "GrpPed")
    oStruZAE:SetProperty("ZAE_PRDENT" , MVC_VIEW_GROUP_NUMBER, "GrpPed")

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField( 'VIEW_ZAE', oStruZAE, 'ZAEMASTER' )

    oStruZAE:RemoveField('ZAE_FILIAL' )
    oStruZAE:RemoveField('ZAE_VERSAO' )
    oStruZAE:RemoveField('ZAE_TPTRAN' )
    oStruZAE:RemoveField('ZAE_DTEVEN' )
   
// Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)

// Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZAE', 'SUPERIOR')

Return oView

/*/{Protheus.doc} MenuDef
@description ** Funcao de definição do aRotina **
@type function
@version 1.00
@author Rogério Costa
@since 13/10/2020
@return Array, aRotina
/*/
Static Function MenuDef()

    Private aRotina	:= {}

    ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
    ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4F01ZAE' 	OPERATION 2 ACCESS 0

    ADD OPTION aRotina Title "Incluir"	    			Action 'VIEWDEF.T4F01ZAE' 	OPERATION 3 ACCESS 0
    ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.T4F01ZAE' 	OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE 'Legenda'                  ACTION 'u_T4F01Leg'         OPERATION 6 ACCESS 0

Return aRotina

/*/{Protheus.doc} T4F01Leg
@description **Funcao de Legenda**
@type function
@version 1.00
@author Rogério Costa
@since 13/10/2020
@return Array, aRotina
/*/
User Function T4F01Leg()
    Local aLegenda := {}

    //Monta as cores
    AADD(aLegenda,{"BR_VERDE",        "Ativo"  })
    AADD(aLegenda,{"BR_VERMELHO",    "Inativo"})

    BrwLegenda("Cadastro Regras INTI", "Regras INTI", aLegenda)
Return

/*/{Protheus.doc} VldZAE
@Description ** Função desenvolvida para validar os dados **
@type function
@author Atilio
@since 14/01/2017
@version 1.0
/*/
User Function VldZAE                                                                                                              ()
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local oModelDad  := FWModelActive()
    Local cFilZAE    := oModelDad:GetValue('ZAEMASTER', 'ZAE_FILIAL')
    Local cCodigo    := oModelDad:GetValue('ZAEMASTER', 'ZAE_EPEP')
    Local nOpc       := oModelDad:GetOperation()
    Local nAtual     := 0

    DbSelectArea('ZAE')
    ZAE->(DbSetOrder(1))

    If nOpc == MODEL_OPERATION_INSERT

        If ZAE->(DbSeek(cFilZAE+Alltrim(cCodigo)))

            lRet:= .F.

            Aviso('Atenção', 'Já existe regra com esse EPEP !', {'OK'}, 03)

        EndIf

    EndIf

    RestArea(aArea)
Return lRet



