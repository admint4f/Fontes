#include 'protheus.ch'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} T4F01ZAD
@description **Browse Histórico de Registros integrados plataforma INTI**
@type function
@version 1.00 
@author Rogério Costa
@since 13/10/2020
@return return_type, Nil
/*/

User Function T4F01ZAD()

	Local oBrowse

    DbSelectArea('ZAD')

//Cria o objeto do tipo FWMBrowse
    oBrowse := FWMBrowse():New()

//Alias ta tabela a ser utilizada no browse
    oBrowse:SetAlias('ZAD')

//Descrição da rotina
    oBrowse:SetDescription("Histórico de Integração INTI")

    oBrowse:AddLegend( "ZAD->ZAD_STATUS=='1'", "GREEN"  ,"Pendente"             )
    oBrowse:AddLegend( "ZAD->ZAD_STATUS=='2'", "BLUE"   ,"Pedido Gerado"        )
    oBrowse:AddLegend( "ZAD->ZAD_STATUS=='3'", "RED"    ,"Nota Gerada"          )
    oBrowse:AddLegend( "ZAD->ZAD_STATUS=='4'", "BLACK"  ,"Falha Integração"     )
    oBrowse:AddLegend( "ZAD->ZAD_STATUS=='5'", "YELLOW" ,"Dev/Canc.Processado"  )

    oBrowse:SetMenuDef('T4F01ZAD')

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
    Local oStruZAD      := FWFormStruct( 1, 'ZAD', /*bAvalCampo*/, /*lViewUsado*/ )
    Local oModel
//    Local bPosValidacao := {||u_VldZAD(oModel)}


//Cria o objeto do Modelo de Dados
    oModel := MPFormModel():New( 'Histórico Integrações', /*bPreValidacao*/ ,/* bPosValidacao*/, /*bCommit*/, /*bCancel*/ )
    oModel:SetDescription('Histórico Integrações')
//Adiciona ao modelo uma estrutura de formulário de edição por campo (antiga enchoice)
    oModel:AddFields( 'ZADMASTER', /*cOwner*/, oStruZAD, )

//Chave Primaria
   oModel:SetPrimaryKey({"ZAD_FILIAL,ZAD_EPEP"})

//Adiciona a descricao do Modelo de Dados
    oModel:SetDescription("Integração INTI")

//Adiciona a descricao do Componente do Modelo de Dados
    oModel:GetModel( 'ZADMASTER' ):SetDescription( 'Master' )

Return oModel

/*/{Protheus.doc} ViewDef
@description ** Define a interface com usuario **
@type function
@version 1.00
@author Rogério Costa
@since 13/10/2020
@return Objeto, oView
/*/
Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado 
    Local oModel   	 :=  FWLoadModel( 'T4F01ZAD' )
    Local oView

// Cria a estrutura a ser usada na View
    Local oStruZAD 	:= FWFormStruct( 2, 'ZAD' )

// Cria o objeto de View
    oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
    oView:SetModel( oModel )

    oStruZAD:AddGroup("GrpCli", "Dados Cliente", "", 2)
    oStruZAD:AddGroup("GrpEv",  "Evento", "", 2)
    oStruZAD:AddGroup("GrpReg", "Dados Pedido INTI", "", 2)

    //Dados Cliente
    oStruZAD:SetProperty("ZAD_NOME"	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZAD:SetProperty("ZAD_CPF" 	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZAD:SetProperty("ZAD_CIDADE" , MVC_VIEW_GROUP_NUMBER, "GrpCli")
    oStruZAD:SetProperty("ZAD_EST" 	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")
    //oStruZAD:SetProperty("ZAD_ENVENTO" 	  , MVC_VIEW_GROUP_NUMBER, "GrpCli")

    //Regras INTI
    oStruZAD:SetProperty("ZAD_NFINTI" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAD:SetProperty("ZAD_DTVEND" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAD:SetProperty("ZAD_DTIMP" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAD:SetProperty("ZAD_VLRTKT"	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAD:SetProperty("ZAD_VLRTXO" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAD:SetProperty("ZAD_VLRTXS" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
	oStruZAD:SetProperty("ZAD_VLRTXC" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
	oStruZAD:SetProperty("ZAD_VLRTXI" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
	oStruZAD:SetProperty("ZAD_VLRXCA" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    oStruZAD:SetProperty("ZAD_VLENTR" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    //oStruZAD:SetProperty("ZAD_BANDEI" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    //oStruZAD:SetProperty("ZAD_TPAGTO" 	, MVC_VIEW_GROUP_NUMBER, "GrpReg")
    //oStruZAD:SetProperty("ZAD_NSU"   	, MVC_VIEW_GROUP_NUMBER, "GrpReg")

    //Evento
    oStruZAD:SetProperty("ZAD_EPEP" 	, MVC_VIEW_GROUP_NUMBER, "GrpEv")
    oStruZAD:SetProperty("ZAD_EVENTO" 	, MVC_VIEW_GROUP_NUMBER, "GrpEv")

    //Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
    oView:AddField( 'VIEW_ZAD', oStruZAD, 'ZADMASTER' )

    oStruZAD:RemoveField('ZAD_FILIAL' )
   // oStruZAD:RemoveField('ZAD_VERSAO' )

// Criar "box" horizontal para receber algum elemento da view
    oView:CreateHorizontalBox( 'SUPERIOR'  	, 100)

// Relaciona o ID da View com o "box" para exibicao
    oView:SetOwnerView( 'VIEW_ZAD', 'SUPERIOR')

Return oView

/*/{Protheus.doc} MenuDef
@description ** Funcao de definição do aRotina **
@type function
@version 1.00
@author Rogério Costa
@since 13/10/2020
@return Array, aRotina , Array com as opções no menu
/*/
Static Function MenuDef()

    Private aRotina	:= {}

    ADD OPTION aRotina Title "Pesquisar"  				Action 'PesqBrw'         	OPERATION 1 ACCESS 0
    ADD OPTION aRotina Title "Visualizar" 				Action 'VIEWDEF.T4F01ZAD' 	OPERATION 2 ACCESS 0
    ADD OPTION aRotina TITLE "Reprocessar"              ACTION 'u_T4F01PED()'         OPERATION 6 ACCESS 0
 
 //   ADD OPTION aRotina Title "Incluir"	    			Action 'VIEWDEF.T4F01ZAD' 	OPERATION 3 ACCESS 0
 //   ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.T4F01ZAD' 	OPERATION 4 ACCESS 0
 //   ADD OPTION aRotina TITLE 'Legenda'                  ACTION 'u_T4F01Leg'         OPERATION 6 ACCESS 0

//ADD OPTION aRotina Title "Alterar"  				Action 'VIEWDEF.FFLA0001' 	OPERATION 4 ACCESS 0
//ADD OPTION aRotina Title "Excluir"					Action 'VIEWDEF.FFLA0001'	OPERATION 5 ACCESS 0 

Return aRotina



