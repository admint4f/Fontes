#include 'Protheus.ch'
#include 'RwMake.ch'

/*====================================================================================\
|Programa  | T4COMA06         | Autor | GIOVANI.ZAGO             | Data | 01/10/2013  |
|=====================================================================================|
|Descrição |  T4COMA06    Liberação de Conf.Recbto                                    |
|          |                                                                          |
|          | Plcom06                                                                  |
|=====================================================================================|
|Sintaxe   | T4COMA06                                                                 |
|=====================================================================================|
|Uso       | Especifico STECK                                                         |
|=====================================================================================|
|........................................Histórico....................................|
\====================================================================================*/
*-----------------------------*
User Function T4COMA06()
*-----------------------------*
Local aArea          := GetArea()
Local aCores2        := {{" F1_XCONREC = 'N' " 	, "BR_VERMELHO"	}}	// Cancelado
Local cFiltro        := " F1_FILIAL = '"+xFilial("SF1")+"' AND F1_XCONREC = 'N' ""
Private cCadastro	 := "Conf.Recebimento"
Private aRotina      := {}
Private cUserMaster  := GetMv('T4_USRLIB',,'000000')
Private cIdUser      := __CuserId

aRotina	:= {	{"Pesquisar" 	,"AxPesqui"		,0,1 },;
{"Visualizar" 	,"A103NFiscal"		,0,2 },;
{ "Liberar"		,"U_STX15"	,0,4 }}

DbSelectArea("SF1")
SF1->(dbSetOrder(1))

If   cIdUser $ cUserMaster
	
	SF1->(dbSetFilter({||SF1->F1_XCONREC = 'N'}," SF1->F1_XCONREC = 'N' "))
Else
	SF1->(dbSetFilter({||SF1->F1_XCONREC = 'N' .And. __CuserId $ SF1->F1_XUSRSOL }," SF1->F1_XCONREC = 'N' .And. __CuserId $ SF1->F1_XUSRSOL "))
EndIf


mBrowse( 7, 4,20,74,"SF1",,,,,,aCores2)
SF1->(DbClearFilter())
Restarea(aArea)
Return()



User Function STX15()
Local aAreaSE2          := GetArea()
If MsgYesNo("Confirma o Recebimento ?")
	
	SF1->(RecLock("SF1",.F.))
	SF1->F1_XUSRREC  := __cuserid
	SF1->F1_XDTREC   := ddatabase
	SF1->F1_XCONREC  := ' '
	SF1->(Msunlock("SF1"))
	SF1->( DbCommit() )
	
	DbSelectArea("SE2")
	DbSetOrder(6)
   If SE2->(	DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC))
	Do While SE2->(!Eof()) .and. xFilial("SE2")+SE2->E2_NUM + SE2->E2_PREFIXO + SE2->E2_FORNECE == xFilial("SE2")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE
	   
		RecLock( "SE2", .F. )
		SE2->E2_STATLIB := "03" 
		SE2->E2_DATALIB := DDATABASE
		SE2->E2_USUALIB := CUSERNAME 
		SE2->(Msunlock("SE2"))
	    SE2->(DbCommit())
		
		SE2->(DbSkip())
	EndDo
	
	EndIf

EndIf
Restarea(aAreaSE2)
Return(.t.)

	