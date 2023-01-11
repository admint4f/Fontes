#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
 
//Vari�veis Est�ticas
Static cTitulo := "Artistas (Mod.X)"
 
/*/{Protheus.doc} T4FMPZBMX
Fun��o de exemplo de Modelo X (Pai, Filho e Neto), com as tabelas de Artistas, CDs e M�sicas
@author Atilio
@since 03/09/2016
@version 1.0
    @return Nil, Fun��o n�o tem retorno
    @example
    u_T4FMPZBMX()
/*/
 
User Function T4FMPZBMX()
    Local aArea   := GetArea()
    Local oBrowse
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMBrowse():New()
     
    //Setando a tabela de cadastro de Autor/Interprete
    oBrowse:SetAlias("ZBM")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)
     
    //Ativa a Browse
    oBrowse:Activate()
     
    RestArea(aArea)
Return Nil
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do menu MVC                                          |
 *---------------------------------------------------------------------*/
 
Static Function MenuDef()
    Local aRot := {}
     
    //Adicionando op��es
    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.T4FMPZBMX' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
 
Static Function ModelDef()
    Local oModel         := Nil
    Local oStPai         := FWFormStruct(1, 'ZBM')
    Local oStFilho     := FWFormStruct(1, 'ZBN')
    Local oStNeto     := FWFormStruct(1, 'ZBP')
    Local aZBNRel        := {}
    Local aZBPRel        := {}
     
    //Criando o modelo e os relacionamentos
    oModel := MPFormModel():New('T4FMPZBMXM')
    oModel:AddFields('ZBMMASTER',/*cOwner*/,oStPai)
    oModel:AddGrid('ZBNDETAIL','ZBMMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
    oModel:AddGrid('ZBPDETAIL','ZBNDETAIL',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
     
    //Fazendo o relacionamento entre o Pai e Filho
    aAdd(aZBNRel, {'ZBN_FILIAL',    'ZBM_FILIAL'} )
    aAdd(aZBNRel, {'ZBN_ORDID',    'ZBM_ORDID'})
     
    //Fazendo o relacionamento entre o Filho e Neto
    aAdd(aZBPRel, {'ZBP_FILIAL',    'ZBN_FILIAL'} )
    aAdd(aZBPRel, {'ZBP_ORDID',    'ZBN_ORDID'})
     
    oModel:SetRelation('ZBNDETAIL', aZBNRel, ZBN->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
    oModel:GetModel('ZBNDETAIL'):SetUniqueLine({"ZBN_ORDID","ZBN_ITEMMP"})    //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
     
    oModel:SetRelation('ZBPDETAIL', aZBPRel, ZBP->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
    oModel:GetModel('ZBPDETAIL'):SetUniqueLine({"ZBP_ORDID","ZBP_ITEM"})    //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
    oModel:SetPrimaryKey({})
     
    //Setando as descri��es
    oModel:SetDescription("Grupo de Produtos - Mod. X")
    oModel:GetModel('ZBMMASTER'):SetDescription('Modelo Artistas')
    oModel:GetModel('ZBNDETAIL'):SetDescription('Modelo CDs')
    oModel:GetModel('ZBPDETAIL'):SetDescription('Modelo Musicas')
     
    //Adicionando totalizadores
    oModel:AddCalc('TOTAIS', 'ZBMMASTER', 'ZBNDETAIL', 'ZBN_QTD',  'XX_VALOR', 'SUM',   , , "Valor Total:" )
    oModel:AddCalc('TOTAIS', 'ZBNDETAIL', 'ZBPDETAIL', 'ZBP_ITEM', 'XX_TOTAL', 'COUNT', , , "Total Musicas:" )
Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Autor: Daniel Atilio                                                |
 | Data:  03/09/2016                                                   |
 | Desc:  Cria��o da vis�o MVC                                         |
 | Obs.:  /                                                            |
 *---------------------------------------------------------------------*/
 
Static Function ViewDef()
    Local oView        := Nil
    Local oModel        := FWLoadModel('T4FMPZBMX')
    Local oStPai        := FWFormStruct(2, 'ZBM')
    Local oStFilho    := FWFormStruct(2, 'ZBN')
    Local oStNeto        := FWFormStruct(2, 'ZBP')
    Local oStTot        := FWCalcStruct(oModel:GetModel('TOTAIS'))
     
    //Criando a View
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Adicionando os campos do cabe�alho e o grid dos filhos
    oView:AddField('VIEW_ZBM', oStPai,   'ZBMMASTER')
    oView:AddGrid('VIEW_ZBN',  oStFilho, 'ZBNDETAIL')
    oView:AddGrid('VIEW_ZBP',  oStNeto,  'ZBPDETAIL')
    oView:AddField('VIEW_TOT', oStTot,   'TOTAIS')
     
    //Setando o dimensionamento de tamanho
    oView:CreateHorizontalBox('CABEC', 20)
    oView:CreateHorizontalBox('GRID',  40)
    oView:CreateHorizontalBox('GRID2', 27)
    oView:CreateHorizontalBox('TOTAL', 13)
     
    //Amarrando a view com as box
    oView:SetOwnerView('VIEW_ZBM', 'CABEC')
    oView:SetOwnerView('VIEW_ZBN', 'GRID')
    oView:SetOwnerView('VIEW_ZBP', 'GRID2')
    oView:SetOwnerView('VIEW_TOT', 'TOTAL')
     
    //Habilitando t�tulo
    oView:EnableTitleView('VIEW_ZBM','Artista')
    oView:EnableTitleView('VIEW_ZBN','CDs')
    oView:EnableTitleView('VIEW_ZBP','Musicas')
     
    //Removendo campos
    oStFilho:RemoveField('ZBN_CODART')
    oStNeto:RemoveField('ZBP_CODART')
    oStNeto:RemoveField('ZBP_CODCD')
Return oView

// Static cTitulo := "Integra��o Meep"
 
// User Function T4FZBMPX()
//     Local aArea   := GetArea()
//     Local oBrowse

//     DbSelectArea('ZBM')
//     DbSelectArea('ZBN')
//     DbSelectArea('ZBP')

//     //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
//     oBrowse := FWMBrowse():New()
     
//     //Setando a tabela de cadastro de Autor/Interprete
//     oBrowse:SetAlias("ZBM")
 
//     //Setando a descri��o da rotina
//     oBrowse:SetDescription(cTitulo)
     
//     //Legendas
//     oBrowse:AddLegend( "ZBM->ZBM_ETAPA == '0'",  "BLUE",         "Em Integra��o"     )
//     oBrowse:AddLegend( "ZBM->ZBM_ETAPA == '1'",  "RED",          "Erro na Integ"     )
//     oBrowse:AddLegend( "ZBM->ZBM_ETAPA == '2'",  "GREEN",        "Integ Finalizada"  )

//     oBrowse:SetMenuDef('T4FZBMPX')
     
//     //Ativa a Browse
//     oBrowse:Activate()
     
//     RestArea(aArea)
// Return

 
// /*---------------------------------------------------------------------*
//  | Func:  ModelDef                                                     |
//  | Autor: Daniel Atilio                                                |
//  | Data:  17/08/2015                                                   |
//  | Desc:  Cria��o do modelo de dados MVC                               |
//  | Obs.:  /                                                            |
//  *---------------------------------------------------------------------*/
 
// Static Function ModelDef()
//     Local oModel
//     Local oStPai         := FWFormStruct(1, 'ZBM')
//     Local oStFilho       := FWFormStruct(1, 'ZBN')
//     Local oStNeto        := FWFormStruct(1, 'ZBP')
//     Local aZBNRel        := {}
//     Local aZBPRel        := {}
     
//     //Criando o modelo e os relacionamentos
//     oModel := MPFormModel():New('T4FZBMPXM')
//     oModel:SetDescription('Integra��o Meep')
//     oModel:AddFields('ZBMMASTER',/*cOwner*/,oStPai)
//     oModel:AddGrid('ZBNDETAIL','ZBMMASTER',oStFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence
//     oModel:AddGrid('ZBPDETAIL','ZBMMASTER',oStNeto,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)  //cOwner � para quem pertence

//     oModel:SetPrimaryKey({"ZBM_FILIAL","ZBN_ORDID"})

//     //Fazendo o relacionamento entre o Pai e Filho
//     aAdd(aZBNRel, {'ZBN_FILIAL',    'ZBM_FILIAL'} )
//     aAdd(aZBNRel, {'ZBN_ORDID',     'ZBM_ORDID'})
     
//     //Fazendo o relacionamento entre o Pai e Neto
//     aAdd(aZBPRel, {'ZBP_FILIAL',    'ZBM_FILIAL'} )
//     aAdd(aZBPRel, {'ZBP_ORDID',     'ZBM_ORDID'}) 
     
//     oModel:SetRelation('ZBNDETAIL', aZBNRel, ZBN->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
//     oModel:GetModel('ZBNDETAIL'):SetUniqueLine({"ZBN_FILIAL","ZBN_ORDID"})    //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
//     // oModel:SetPrimaryKey({"ZBN_FILIAL","ZBN_ORDID","ZBN_ITEMMP"})
     
//     oModel:SetRelation('ZBPDETAIL', aZBPRel, ZBP->(IndexKey(1))) //IndexKey -> quero a ordena��o e depois filtrado
//     oModel:GetModel('ZBPDETAIL'):SetUniqueLine({"ZBP_FILIAL","ZBP_ORDID"})    //N�o repetir informa��es ou combina��es {"CAMPO1","CAMPO2","CAMPOX"}
//     // oModel:SetPrimaryKey({"ZBP_FILIAL","ZBP_ORDID","ZBP_ITEM"})
     
//     //Setando as descri��es
//     oModel:SetDescription("Integra��o Meep")
//     oModel:GetModel('ZBMMASTER'):SetDescription('Cabe�alho')
//     oModel:GetModel('ZBNDETAIL'):SetDescription('Item')
//     oModel:GetModel('ZBPDETAIL'):SetDescription('Pagamento')
     
//     //Adicionando totalizadores
//     // oModel:AddCalc('TOT_SALDO', 'ZBNDETAIL', 'ZBPDETAIL', 'B2_QATU', 'XX_TOTAL', 'SUM', , , "Saldo Total:" )
// Return oModel
 
// /*---------------------------------------------------------------------*
//  | Func:  ViewDef                                                      |
//  | Autor: Daniel Atilio                                                |
//  | Data:  17/08/2015                                                   |
//  | Desc:  Cria��o da vis�o MVC                                         |
//  | Obs.:  /                                                            |
//  *---------------------------------------------------------------------*/
 
// Static Function ViewDef()
//     Local oView        := Nil
//     Local oModel        := FWLoadModel('T4FZBMPX')
//     Local oStPai        := FWFormStruct(1, 'ZBM')
//     Local oStFilho      := FWFormStruct(1, 'ZBN')
//     Local oStNeto        := FWFormStruct(1, 'ZBP')
//     // Local oStTot        := FWCalcStruct(oModel:GetModel('TOT_SALDO'))
//     //Estruturas das tabelas e campos a serem considerados
//     // Local aStruZBM    := ZBM->(DbStruct())
//     // Local aStruZBN    := ZBN->(DbStruct())
//     // Local aStruZBP    := ZBP->(DbStruct())
//     // Local cConsZBM    := "ZBM_"
//     // Local cConsZBN    := "B1_COD;B1_DESC;B1_TIPO;B1_UM;B1_LOCPAD"
//     // Local cConsZBP    := "B2_LOCAL;B2_QATU"
//     // Local nAtual        := 0
     
//     //Criando a View
//     oView := FWFormView():New()
//     oView:SetModel(oModel)
     
//     //Adicionando os campos do cabe�alho e o grid dos filhos
//     oView:AddField('VIEW_ZBM',oStPai,'ZBMMASTER')
//     oView:AddGrid('VIEW_ZBN',oStFilho,'ZBNDETAIL')
//     oView:AddGrid('VIEW_ZBP',oStNeto,'ZBPDETAIL')
//     // oView:AddField('VIEW_TOT', oStTot,'TOT_SALDO')
     
//     //Setando o dimensionamento de tamanho
//     oView:CreateHorizontalBox('CABEC',40)
//     oView:CreateHorizontalBox('GRID',30)
//     oView:CreateHorizontalBox('GRID2',30)
//     // oView:CreateHorizontalBox('TOTAL',13)
     
//     //Amarrando a view com as box
//     oView:SetOwnerView('VIEW_ZBM','CABEC')
//     oView:SetOwnerView('VIEW_ZBN','GRID')
//     oView:SetOwnerView('VIEW_ZBP','GRID2')
//     // oView:SetOwnerView('VIEW_TOT','TOTAL')
     
//     //Habilitando t�tulo
//     oView:EnableTitleView('VIEW_ZBM','Grupo')
//     oView:EnableTitleView('VIEW_ZBN','Produtos')
//     oView:EnableTitleView('VIEW_ZBP','Saldos')
     
//     // //Percorrendo a estrutura da ZBM
//     // For nAtual := 1 To Len(aStruZBM)
//     //     //Se o campo atual n�o estiver nos que forem considerados
//     //     If ! Alltrim(aStruZBM[nAtual][01]) $ cConsZBM
//     //         oStPai:RemoveField(aStruZBM[nAtual][01])
//     //     EndIf
//     // Next
     
//     // //Percorrendo a estrutura da ZBN
//     // For nAtual := 1 To Len(aStruZBN)
//     //     //Se o campo atual n�o estiver nos que forem considerados
//     //     If ! Alltrim(aStruZBN[nAtual][01]) $ cConsZBN
//     //         oStFilho:RemoveField(aStruZBN[nAtual][01])
//     //     EndIf
//     // Next
     
//     // //Percorrendo a estrutura da ZBP
//     // For nAtual := 1 To Len(aStruZBP)
//     //     //Se o campo atual n�o estiver nos que forem considerados
//     //     If ! Alltrim(aStruZBP[nAtual][01]) $ cConsZBP
//     //         oStNeto:RemoveField(aStruZBP[nAtual][01])
//     //     EndIf
//     // Next

// Return oView


// /*---------------------------------------------------------------------*
//  | Func:  MenuDef                                                      |
//  | Autor: Daniel Atilio                                                |
//  | Data:  17/08/2015                                                   |
//  | Desc:  Cria��o do menu MVC                                          |
//  | Obs.:  /                                                            |
//  *---------------------------------------------------------------------*/
 
// Static Function MenuDef()
//     Local aRot := {}
     
//     //Adicionando op��es
//     ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.T4FZBMPX' OPERATION 1   ACCESS 0 //OPERATION 1
//     ADD OPTION aRot TITLE 'Legenda'    ACTION 'u_ZBMLegPX'       OPERATION 6 ACCESS 0 //OPERATION X
//     // ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.T4FZBMPX' OPERATION 3 ACCESS 0 //OPERATION 3
//     ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.T4FZBMPX' OPERATION 4 ACCESS 0 //OPERATION 4
//     // ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.T4FZBMPX' OPERATION 6 ACCESS 0 //OPERATION 5

// Return aRot

// User Function ZBMLegPX()
// 	Local aLegenda := {}
	
// 	//Monta as cores
// 	AADD(aLegenda,{"BR_VERDE",		"Int Finalizada"  })
// 	AADD(aLegenda,{"BR_AZUL",	"Em Integra��o"})
// 	AADD(aLegenda,{"BR_VERMELHO",	"Erro na Integ"})
	
// 	BrwLegenda("Status Integra��o", "Etapa", aLegenda)
// Return
