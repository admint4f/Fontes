#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protdef.ch"
#define _EOL chr(13)+chr(10)

/*/
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Programa  ï¿½Consolidadoï¿½ Autor ï¿½Gilberto A Oliveira ï¿½ Data ï¿½  15/08/10   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Descricao ï¿½ Relatorio da Base Consolidada Contabil.                     ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½                                                             ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ T4F / Contabilidade                                         ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
/*/

User Function Consolidado()

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Declaracao de Variaveis                                             ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
Local lContinua := .t.
//Local lExit:= .f.
Local cPerg   := "CONSOL"

dbSelectArea("CT2")
dbSetOrder(1)                                                                                                                      

PutSx1(cPerg,"01",	"Data Lancto de ?", "Data Lancto de ?" ,"Data Lancto de ?",	"mv_ch1","D",8,	0,	0,	"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02",	"Data Lancto Ate ?","Data Lancto Ate ?","Data Lancto Ate ?","mv_ch2","D",8,	0,	0,	"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03",	"Conta Contabil de ?",	"Conta Contabil de ?" ,	"Conta Contabil de ?",	"mv_ch3",	"C",20,	0,	0,	"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04",	"Conta Contabil ate ?","Conta Contabil ate ?","Conta Contabil ate ?",	"mv_ch4",	"C",20,	0,	0,	"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05",	"Nome Arquivo ?","File Name ?","File Name ?","mv_ch5",	"C",20,0,0,	"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{"Digite o nome do arquivo que deseja","gerar. Escolha, de preferencia, um nome","simples e Nï¿½O COLOQUE EXTENSï¿½O."},{},{})
PutSx1(cPerg,"06",	"Tipo Saldo ?","Tipo Saldo ?","Tipo Saldo ?",	"mv_ch6",	"C",TamSX3("CT2_TPSALD")[1],	0,	0,	"G","","SLW","","","mv_par06","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"07",	"Moeda?","Moeda?","Moeda?",	"mv_ch7",	"C",TamSX3("CT2_MOEDLC")[1],	0,	0,	"G","","CTO","","","mv_par07","","","","","","","","","","","","","","","","")


While  lContinua 
        
       If  !Pergunte(cPerg,.t.) 
           Exit
       EndIf  

	If Empty(mv_par01) .or. Empty(mv_par02)
	   ApMsgInfo("Nï¿½o pode haver data em branco !"+chr(13)+ "Por favor verifique os parametros...","INFO")
	   Loop
	EndIf

	If Empty(mv_par02) < Empty(mv_par01)
	   ApMsgInfo("Hï¿½ data final deve ser maior que a data inicial !"+chr(13)+ "Por favor verifique os parametros...","INFO")
	   Loop
	EndIf

	If Empty(mv_par03) .And. Empty(mv_par04)
	   ApMsgInfo("Digite a conta contï¿½bil inicial e final, se quiser trazer todas as contas"+chr(13)+ 'digite "Conta de" com a primeira do cadastro e "Conta atï¿½" com a ultima',"INFO")
	   Loop
	EndIf
	
	If Empty(mv_par05) .or. At(".",mv_par05)>0 .or. Len(Alltrim(mv_par05)) > 20
	   ApMsgInfo("Problema com o nome do arquivo."+chr(13)+"Atenï¿½ï¿½o: "+chr(13)+"- Nï¿½o pode ficar em branco;"+chr(13)+"- Nï¿½o pode ter extensï¿½o"+chr(13)+"- Nï¿½o deve ter mais de 8 CARACTERES.","INFO")
	   Loop
	Endif
	lContinua:= .f.
	   
End-While
    
If  !lContinua 
    Processa({|| RunProcesso() },"Processsando arquivo...")
EndIf    

Return

/*/
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í»ï¿½ï¿½
ï¿½ï¿½ï¿½Funï¿½ï¿½o    ï¿½RUNPROCESSï¿½ Autor ï¿½ Gilberto           ï¿½ Data ï¿½  16/08/10   ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Descriï¿½ï¿½o ï¿½ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½          ï¿½ monta a janela com a regua de processamento.               ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¹ï¿½ï¿½
ï¿½ï¿½ï¿½Uso       ï¿½ Programa principal                                         ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Í¼ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
/*/

Static Function RunProcesso()
   
Local _cArquivo, _cPNome, _cAlias
Local cQuery:= ''
Local lAuro     

//lAuro:= ApMsgYesNo("Deseja Incluir AuroLight ?"+chr(13)+'Atencao: Na ocorrencia de erros responda essa pergunta como "nao" e retire o CT2 pela opcao "Genericos"') Retirado a mensagem uma vez que a Auro foi encerrada. Maria Helena deu ok 09-05-2019

cQuery+=           "SELECT  'T4F_MATRIZ' AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2080 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' '  " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'METRO'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2090 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' " 
cQuery+= "UNION ALL SELECT  'VICAR'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2160 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'AeB'        AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2200 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'AREA_MKT'   AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2250 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'PLF'   	 AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2320 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'INTI'   	 AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2330 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
If lAuro
   cQuery+= "UNION ALL SELECT  'AUROLIGHT'  AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_FILORI FROM CT2150 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
EndIf   
cQuery+= "UNION ALL SELECT  'T4F_MATRIZ' AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2080 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' "  + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'METRO'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2090 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'VICAR'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2160 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'AeB'        AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2200 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'AREA_MKT'   AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2250 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'PLF'   	 AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2320 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
cQuery+= "UNION ALL SELECT  'INTI'   	 AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2330 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
If lAuro
   cQuery+= "UNION ALL SELECT  'AUROLIGHT'  AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR , CT2_FILORI FROM CT2150 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","") + " AND CT2_MOEDLC = '"+ALLTRIM(MV_PAR07)+"' "
EndIf
cQuery+= "ORDER BY EMPRESA, CT2_DATA "

cQuery:= ChangeQuery(cQuery)

Memowrite("C:\temp\CONSOLIDADO.SQL",cquery)   

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"CONSOLID",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ä¿
//ï¿½ Compatibiliza os campos com a TopField ï¿½
//ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½
aTamSX3	:= TAMSX3("CT2_DATA")   ; TcSetField("CONSOLID", "CT2_DATA",	aTamSX3[3], aTamSX3[1], aTamSX3[2])
aTamSX3	:= TAMSX3("CT2_VALOR")  ; TcSetField("CONSOLID", "VALOR"  ,	aTamSX3[3], aTamSX3[1], aTamSX3[2])
DbSelectArea("CONSOLID")
DbCommitAll()         

CONSOLID->( DbGotop() )

If CONSOLID->( !Eof() )

	_cArquivo:= "C:\temp\"+Iif( !empty( mv_par05), lower(alltrim(mv_par05)),"consolidado_contabil_periodo_"+substr( dtos(mv_par01),1,4) )
	_cPNome:= "Consolidado_Contabil"
	_cAlias:= "CONSOLID"
   
   If File( _cArquivo+".xml" )
      Ferase( _cArquivo+".xml")
   EndIf 
   
	MsAguarde( { || DB2XML(_cArquivo, _cPNome, _cAlias,,,,"2007","Consolid->EMPRESA+' - '+DTOC(Consolid->CT2_DATA)")},"Aguarde Gerando Arquivo...")

//	ApMsgInfo("Arquivo :"+_cArquivo+".xml gerado. Verifique o disco local de sua maquina"+chr(13)+"Aperte OK para continuar gerando o relatï¿½rio...","Informaï¿½ï¿½o","INFO") editado a mensagem para menor.  Thiago Moraes 09-05-2019
	ApMsgInfo("Arquivo gerado no caminho:  "+_cArquivo+".xml")

EndIF             

CONSOLID->( DbCloseArea() )

Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DB2XML   º Autor ³ Felipe Raposo      º Data ³  05/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Converte um alias aberto para um arquivo XML, no formato   º±±
±±º          ³ Excel 2006.                                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ _cArquivo - arquivo a ser gerado.                          º±±
±±º          ³ _PNome    - nome da planilha a ser criada no arquivo.      º±±
±±º          ³ _cAlias   - alias que sera convertido para XML (opcional). º±±
±±º          ³ _aStruct  - matriz com a estrutura da planilha. A sintaxe  º±±
±±º          ³             da matriz e' a seguinte:                       º±±
±±º          ³             1 - Cabecalho (opcional).                      º±±
±±º          ³             2 - Campo.                                     º±±
±±º          ³             3 - Largura da coluna (XML - opcional).        º±±
±±º          ³ _bWhile   - converte os registros enquanto o retorno do    º±±
±±º          ³             bloco passado for verdadeiro.                  º±±
±±º          ³ _bFor     - converte somente os registros cujo o bloco pas-º±±
±±º          ³             sado nesse parametro retornar verdadeiro.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Retorna o numero de registros que foram convertidos para o º±±
±±º          ³ arquivo XML.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Generico.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function DB2XML(_cArquivo, _cPNome, _cAlias, _aStruct, _bWhile, _bFor,_cVrs,_cCampoChave)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cMsg, _nAux1, _nAux2, _cAux1, _aAux1
Local _nLinhas := 0
Local _cCabec, _cColuna := "", _aColuna[0]
Local _cLinha, _aPlanilha[0], _aPlans[0], _cArqXML
Local _nCSVArq, _nCount := 0
Local _cDataBase := dtos(dDataBase)
Local _cDataHora := left(_cDataBase, 4) + "-" + SubStr(_cDataBase, 5, 2) + "-" + right(_cDataBase, 2) + "T" + Time() + "Z"
Local _bGrvErr := {|_cArq| MsgAlert("Ocorreu um erro na gravação do arquivo " + _cArq + ". Favor avisar sistemas.", "Atenção")}
Local _bGrvArq := {|_nArq, _cTxt, _cArq| IIf(fWrite(_nArq, _cTxt, len(_cTxt)) != len(_cTxt), Eval(_bGrvErr, _cArq), nil)}
Local _nSupLin

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o nome do arquivo a ser gravado.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArquivo := AllTrim(_cArquivo)
_cArquivo := _cArquivo + IIf(upper(right(_cArquivo, 4)) == ".XML", "", ".xml")

// Cria e testa se o arquivo foi criado com sucesso.
If (_nCSVArq := fCreate(_cArquivo)) <= 0 .or. !file(_cArquivo)
	_cMsg := "O arquivo XML não pôde ser criado." + _EOL + _cArquivo + _EOL +;
	"Verifique se o disco está cheio ou protegido contra gravações."
	MsgAlert(_cMsg, "Atenção")
	Return .F.
Endif

// Analista os parametros passados para a funcao.
_cAlias  := ValPad(_cAlias, Alias())
_cPNome  := ValPad(_cPNome, _cAlias)
_aStruct := ValPad(_aStruct, {})
_bWhile  := ValPad(_bWhile,  {|| .T.})
_bFor    := ValPad(_bFor,    {|| .T.})
_cVrs    := ValPad(_cVrs, "2003")
_cCampoChave:= ValPad(_cCampoChave,'Space(01)')

// Versao do Excel: A versao 2007 suporta um numero maior de linhas.
// Gilberto - 16/08/2010
If _cVrs == "2007"
   _nSupLin:= 1000000
Else 
   _nSupLin:= 65536
EndIf
   
// Seleciona o alias que sera convertido para XML.
dbSelectArea(_cAlias); dbGoTop()

// Analista a estrutura passada.
If empty(_aStruct)
	SX3->(dbSetOrder(2))  // X3_CAMPO.
	_aAux1 := dbStruct()
	For _nAux1 := 1 to len(_aAux1)
		
		SX3->(dbSeek(_aAux1[_nAux1, 1], .F.))
        _cAux1:= Alltrim(X3Titulo())
        // Gilberto - 23/01/2007 - Retira os eventuais acentos ou caracteres especiais do cabecalho.
        _cAux1:= TiraAct(_cAux1,.t.,"XML")
        If Empty(_cAux1); _cAux1:=  _aAux1[_nAux1, 1]; EndIf
		//IIf(empty(_cAux1 := AllTrim(X3Titulo())), _cAux1 := _aAux1[_nAux1, 1], nil)
		aAdd(_aStruct, {_cAux1, &("{|| " +  AllTrim(_aAux1[_nAux1, 1]) + "}")})
		
	Next _nAux1
Endif

aEval(_aStruct, {|x, y| _aStruct[y] := {IIf(ValType(x[1]) == "B", x[1], Capital(x[1])), x[2], IIf(len(x) >= 3, x[3], 0), 0, .T.}})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Converte os registros em linhas XML.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do While Eval(_bWhile) .and. !eof()

	If Eval(_bFor)

		// Atualizacao das informacoes na tela.         
		msProcTxt("Criando linhas do XML "+&(_cCampoChave)  )	
		
		// Monta a linha corrente.
		_cLinha := '   <Row>' + _EOL
		For _nAux1 := 1 to len(_aStruct)
			_cCampo := Eval(_aStruct[_nAux1, 2])
			_cTipo  := ValType(_cCampo)
			Do Case
				Case _cTipo == "N"; _cCampo := AllTrim(str(_cCampo))
				Case _cTipo == "C"; _cCampo := AllTrim(TiraAct(_cCampo, .T.,"XML"))
				Case _cTipo == "D"; _cCampo := dtoc(_cCampo)
				OtherWise; _cCampo := ""
			EndCase
			_aStruct[_nAux1, 4] := max(_aStruct[_nAux1, 4], len(_cCampo))     // Armazena o maior registro desse campo.
			_aStruct[_nAux1, 5] := (_cTipo == "N" .and. _aStruct[_nAux1, 5])  // Indica se todos os registros do campo sao numericos.
			
			// Adiciona o campo a linha que sera retornada.
			If _cTipo == "N"
				_cLinha += '    <Cell ss:StyleID="s22"><Data ss:Type="Number">' + _cCampo + '</Data></Cell>' + _EOL
			Else
				_cLinha += '    <Cell><Data ss:Type="String">' + _cCampo + '</Data></Cell>' + _EOL
			Endif
		Next _nAux1                  
		
		_cLinha += '   </Row>' + _EOL
		
		// Limite de linhas por tabela no Excel.
		//If _nLinhas < 65536 - 1  // Subtrai um porque e' a linha utilizada pelo cabecalho.
		If _nLinhas < _nSupLin - 1
		
			aAdd(_aPlanilha, _cLinha)
			_nLinhas ++
			
		Else
		
			If empty(_aPlans)
				_cPNome += "_1"
			Endif
			
			aAdd(_aPlans, {_cPNome, aClone(_aPlanilha), _nLinhas})
			_cPNome := Soma1(_cPNome)
			_aPlanilha := {_cLinha}
			 _nLinhas := 1
			 
		Endif
		
	Endif
	
	// Vai para o proximo registro.
	dbSelectArea(_cAlias)
	dbSkip()
	
EndDo

aAdd(_aPlans, {_cPNome, _aPlanilha, _nLinhas})

// Configura as colunas e monta a linha de cabecalho.
_cCabec  := '   <Row ss:StyleID="s21">' + _EOL
For _nAux1 := 1 to len(_aStruct)
	_cAux1 := AllTrim(IIf(ValType(_aStruct[_nAux1, 1]) == "B", Eval(_aStruct[_nAux1, 1]), _aStruct[_nAux1, 1]))
	// Se nao houver uma largura informada no parametro, o sistema calcula.
	If (_nAux2 := _aStruct[_nAux1, 3]) == 0
		_nAux2 := IIf(_aStruct[_nAux1, 5], 72.75, _aStruct[_nAux1, 4] * 10.5)
	Endif
	IIf(!empty(_aColuna) .and. _aColuna[len(_aColuna), 1] == _nAux2, _aColuna[len(_aColuna), 2]++, aAdd(_aColuna, {_nAux2, 0}))
	_cCabec += '    <Cell><Data ss:Type="String">' + _cAux1 + '</Data></Cell>' + _EOL
Next _nAux1
_cCabec += '   </Row>' + _EOL
aEval(_aColuna, {|x| _cColuna += '   <Column ss:Width="' + AllTrim(str(x[1])) + '"' + IIf(x[2] > 0, ' ss:Span="' + AllTrim(str(x[2])) + '"', '') + '/>' + _EOL})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o arquivo XML propriamente dito.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cArqXML :=;
'<?xml version="1.0"?>' + _EOL +;
'<?mso-application progid="Excel.Sheet"?>' + _EOL +;
'<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + _EOL +;
' xmlns:o="urn:schemas-microsoft-com:office:office"' + _EOL +;
' xmlns:x="urn:schemas-microsoft-com:office:excel"' + _EOL +;
' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + _EOL +;
' xmlns:html="http://www.w3.org/TR/REC-html40">' + _EOL +;
' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + _EOL +;
'  <LastAuthor>' + AllTrim(cUserName) + '</LastAuthor>' + _EOL +;
'  <Created>' + _cDataHora + '</Created>' + _EOL +;
'  <Version>11.5606</Version>' + _EOL +;
' </DocumentProperties>' + _EOL +;
' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + _EOL +;
'  <WindowHeight>9000</WindowHeight>' + _EOL +;
'  <WindowWidth>9000</WindowWidth>' + _EOL +;
'  <WindowTopX>100</WindowTopX>' + _EOL +;
'  <WindowTopY>100</WindowTopY>' + _EOL +;
'  <ProtectStructure>False</ProtectStructure>' + _EOL +;
'  <ProtectWindows>False</ProtectWindows>' + _EOL +;
' </ExcelWorkbook>' + _EOL +;
' <Styles>' + _EOL +;
'  <Style ss:ID="Default" ss:Name="Normal">' + _EOL +;
'   <Alignment ss:Vertical="Bottom"/>' + _EOL +;
'   <Borders/>' + _EOL +;
'   <Font/>' + _EOL +;
'   <Interior/>' + _EOL +;
'   <NumberFormat/>' + _EOL +;
'   <Protection/>' + _EOL +;
'  </Style>' + _EOL +;
'  <Style ss:ID="s21">' + _EOL +;
'   <Font x:Family="Swiss" ss:Bold="1"/>' + _EOL +;
'  </Style>' + _EOL +;
'  <Style ss:ID="s22">' + _EOL +;
'   <NumberFormat ss:Format="Standard"/>' + _EOL +;
'  </Style>' + _EOL +;
' </Styles>' + _EOL
Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.

// Monta as planilhas dentro do arquivo.
For _nAux1 := 1 to len(_aPlans)
	// Interpreta a linha.
	_cPNome    := _aPlans[_nAux1, 1]
	_aPlanilha := aClone(_aPlans[_nAux1, 2])
	_nLinhas   := _aPlans[_nAux1, 3]
	_nCount    += _nLinhas
	
	// Monta a string da planilha.
	_cArqXML :=;
	' <Worksheet ss:Name="' + _cPNome + '">' + _EOL +;
	'  <Table ss:ExpandedColumnCount="' + AllTrim(str(len(_aStruct))) + '" ss:ExpandedRowCount="' + AllTrim(str(_nLinhas + 1)) + '" x:FullColumns="1" x:FullRows="1">' + _EOL +;
	_cColuna + _cCabec
	Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
	
	// Grava cada linha de registro.
	For _nAux2 := 1 to len(_aPlanilha)
		_cArqXML := _aPlanilha[_nAux2]
		Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
	Next _nAux2
	
	// Finaliza a tabela.
	_cArqXML :=;
	'  </Table>' + _EOL +;
	'  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">' + _EOL +;
	'   <PageSetup>' + _EOL +;
	'    <Header x:Margin="0.49"/>' + _EOL +;
	'    <Footer x:Margin="0.49"/>' + _EOL +;
	'    <PageMargins x:Left="0.8" x:Right="0.8"/>' + _EOL +;
	'   </PageSetup>' + _EOL +;
	'   <Selected/>' + _EOL +;
	'   <FreezePanes/>' + _EOL +;
	'   <FrozenNoSplit/>' + _EOL +;
	'   <SplitHorizontal>1</SplitHorizontal>' + _EOL +;
	'   <TopRowBottomPane>1</TopRowBottomPane>' + _EOL +;
	'   <ActivePane>2</ActivePane>' + _EOL +;
	'  </WorksheetOptions>' + _EOL +;
	' </Worksheet>' + _EOL
	Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.
Next _nAux1

// Finaliza o arquivo.
_cArqXML := '</Workbook>' + _EOL
Eval(_bGrvArq, _nCSVArq, _cArqXML, _cArquivo)  // Grava no arquivo.

// Fecha os arquivos XML.
fClose(_nCSVArq)

Return _nCount

Static Function ValPad(_uValor, _uValPad)
Return(IIf(ValType(_uValor) == ValType(_uValPad), _uValor, _uValPad))

Static Function TiraAct(_cTexto, _lChar,_cSaida)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cRet
Local _nAux1, _nAux2, _cAux1, _cAux2, _cAux3, _aAux1

// Acerta parametros.
_lChar := ValPad(_lChar, .F.)

// Acerta parametros.
_cSaida := Upper(ValPad(_cSaida, Space(01) ))

// Trata os acentos do texto que sera exibido no console.
_aAux1 := {;
{"áàãâä", "a"},;
{"‡", "c"},; 
{"ç", "c"},;
{"éèêë", "e"},;
{"íìîï", "i"},;
{"ñ", "n"},;
{"óòõôö", "o"},;
{"úùûü", "u"},;
{"ÁÀÃÂÄ", "A"},;
{"Ç", "C"},;
{"ÉÈÊË", "E"},;
{"ÍÌÎÏ", "I"},;
{"Ñ", "N"},;
{"ÓÒÕÔÖ", "O"},;
{"ÚÙÛÜ", "U"}}

// Quando a saida eh XML (para Excel ou OpenOffice), troca o "&" . 
If (_cSaida == "XML") 
   aAdd(_aAux1,{"&" ,"&amp;"})
EndIf   

// Substitui os acentos.
_cRet := _cTexto
For _nAux1 := 1 to len(_aAux1)
	_cAux1 := _aAux1[_nAux1, 1]  // Caracteres as serem substituidos.
	_cAux2 := _aAux1[_nAux1, 2]  // Caracter substituto.
	For _nAux2 := 1 to len(_cAux1)
		_cAux3 := SubStr(_cAux1, _nAux2, 1)    // Caracter a ser excluido (da vez).
		_cRet  := StrTran(_cRet, _cAux3, _cAux2)
	Next _nAux2
Next _nAux1

// Retira os caracteres especiais.
If _lChar
	_cAux1 := ""
	For _nAux1 := 1 to len(_cRet)
		_cAux2 := SubStr(_cRet, _nAux1, 1)
		_nAux2 := asc(_cAux2)
		_cAux1 += IIf(_nAux2 >= 32 .and. _nAux2 <= 125, _cAux2, "")
	Next _nAux1
	_cRet := _cAux1
Endif

Return(_cRet)
