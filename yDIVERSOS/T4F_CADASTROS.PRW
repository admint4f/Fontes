#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
Â±Â±ÂºPrograma  Â³T4F_CADASTROSÂºAutor  Â³Luiz Eduardo     Âº Data Â³  04/06/20   ÂºÂ±Â±
Â±Â±ÂºDesc.     Â³ Cadastros customizados somente para visualizaÃ§Ã£o           ÂºÂ±Â±
*/

User Function T4F_PROD // Produtos

Private aCores		:= {{"B1_MSBLQL='2'","ENABLE"},{"B1_MSBLQL<>'2'","DISABLE"}}
Private cCadastro	:= "Produtos"

Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Legenda","U_LEGSE2",0,2}}


Private aIndice		:= {}		
MBrowse(6, 1,22,75,"SB1",,,,,,aCores,,,,,,,,"B1_MSBLQL<>'1'")

RetIndex("SB1")
dbClearFilter()
return 

User Function T4F_CLI // Clientes

Private aCores		:= {{"A1_MSBLQL='2'","ENABLE"},{"A1_MSBLQL='1'","DISABLE"}}
Private cCadastro	:= "Clientes"

Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Legenda","U_LEGSE2",0,2}}


Private aIndice		:= {}		
MBrowse(6, 1,22,75,"SA1",,,,,,aCores,,,,,,,,"A1_MSBLQL<>'1'")

RetIndex("SA1")
dbClearFilter()
return 

User Function T4F_FORN // Fornecedores

Private aCores		:= {{"A2_MSBLQL='2'","ENABLE"},{"A2_MSBLQL='1'","DISABLE"}}
Private cCadastro	:= "Fornecedores"

Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Legenda","U_LEGSE2",0,2}}


Private aIndice		:= {}		
MBrowse(6, 1,22,75,"SA2",,,,,,aCores,,,,,,,,"A2_MSBLQL<>'1'")

RetIndex("SA2")
dbClearFilter()
return 

User Function T4F_TES // tes

Private aCores		:= {{"F4_MSBLQL='2'","ENABLE"},{"F4_MSBLQL<>'2'","DISABLE"}}
Private cCadastro	:= "Cadastro de TES"

Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Legenda","U_LEGSE2",0,2}}


Private aIndice		:= {}		
MBrowse(6, 1,22,75,"SF4",,,,,,aCores,,,,,,,,"F4_MSBLQL<>'1'")

RetIndex("SF4")
dbClearFilter()
return 


User Function T4F_NAT //Natureza

Private aCores		:= {{"ED_MSBLQL='2'","ENABLE"},{"ED_MSBLQL<>'2'","DISABLE"}}
Private cCadastro	:= "Cadastro de naturezas"

Private aRotina		:= {{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Legenda","U_LEGSE2",0,2}}


Private aIndice		:= {}		
MBrowse(6, 1,22,75,"SED",,,,,,aCores,,,,,,,,"ED_MSBLQL<>'1'")

RetIndex("SED")
dbClearFilter()
return 


