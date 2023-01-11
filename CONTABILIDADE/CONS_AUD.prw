#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#define _EOL chr(13)+chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsolidadoบ Autor ณGilberto A Oliveira บ Data ณ  15/08/10   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio da Base Consolidada Contabil.                     บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F / Contabilidade                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Cons_Aud()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local lContinua := .t.
Local lExit:= .f.
Local cPerg   := "CONSOL"

dbSelectArea("CT2")
dbSetOrder(1)                                                                                                                      

PutSx1(cPerg,"01",	"Data Lancto de ?", "Data Lancto de ?" ,"Data Lancto de ?",	"mv_ch1","D",8,	0,	0,	"G","","","","","mv_par01","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"02",	"Data Lancto Ate ?","Data Lancto Ate ?","Data Lancto Ate ?","mv_ch2","D",8,	0,	0,	"G","","","","","mv_par02","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"03",	"Conta Contabil de ?",	"Conta Contabil de ?" ,	"Conta Contabil de ?",	"mv_ch3",	"C",20,	0,	0,	"G","","","","","mv_par03","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"04",	"Conta Contabil ate ?","Conta Contabil ate ?","Conta Contabil ate ?",	"mv_ch4",	"C",20,	0,	0,	"G","","","","","mv_par04","","","","","","","","","","","","","","","","")
PutSx1(cPerg,"05",	"Nome Arquivo ?","File Name ?","File Name ?","mv_ch5",	"C",20,0,0,	"G","","","","","mv_par05","","","","","","","","","","","","","","","","",{"Digite o nome do arquivo que deseja","gerar. Escolha, de preferencia, um nome","simples e NรO COLOQUE EXTENSรO."},{},{})
PutSx1(cPerg,"06",	"Tipo Saldo ?","Tipo Saldo ?","Tipo Saldo ?",	"mv_ch6",	"C",TamSX3("CT2_TPSALD")[1],	0,	0,	"G","","SLW","","","mv_par06","","","","","","","","","","","","","","","","")

While  lContinua 
    
    
       If  !Pergunte(cPerg,.t.) 
           Exit
       EndIf  

	If Empty(mv_par01) .or. Empty(mv_par02)
	   ApMsgInfo("Nใo pode haver data em branco !"+chr(13)+ "Por favor verifique os parametros...","INFO")
	   Loop
	EndIf

	If Empty(mv_par02) < Empty(mv_par01)
	   ApMsgInfo("Hแ data final deve ser maior que a data inicial !"+chr(13)+ "Por favor verifique os parametros...","INFO")
	   Loop
	EndIf

	If Empty(mv_par03) .And. Empty(mv_par04)
	   ApMsgInfo("Digite a conta contแbil inicial e final, se quiser trazer todas as contas"+chr(13)+ 'digite "Conta de" com a primeira do cadastro e "Conta at้" com a ultima',"INFO")
	   Loop
	EndIf
	
	If Empty(mv_par05) .or. At(".",mv_par05)>0 .or. Len(Alltrim(mv_par05)) > 20
	   ApMsgInfo("Problema com o nome do arquivo."+chr(13)+"Aten็ใo: "+chr(13)+"- Nใo pode ficar em branco;"+chr(13)+"- Nใo pode ter extensใo"+chr(13)+"- Nใo deve ter mais de 8 CARACTERES.","INFO")
	   Loop
	Endif
	lContinua:= .f.
	   
End-While
    
If  !lContinua 
    Processa({|| RunProcesso() },"Processsando arquivo...")
EndIf    

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNPROCESSบ Autor ณ Gilberto           บ Data ณ  16/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunProcesso()
   
Local _cArquivo, _cPNome, _cAlias
Local cQuery:= ''
Local lAuro     

//lAuro:= ApMsgYesNo("Deseja Incluir AuroLight ?"+chr(13)+'Aten็ใo: Na ocorrencia de erros responda essa pergunta como "nใo" e retire o CT2 pela op็ao "Genericos"') Retirado a mensagem uma vez que a Auro foi encerrada. Maria Helena deu ok 09-05-2019


cQuery+=           "SELECT  'T4F_MATRIZ' AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2080 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' '  " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'METRO'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2090 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'VICAR'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2160 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'AeB'        AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2200 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'AREA_MKT'   AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2250 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'PLF'   	 AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2320 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
If lAuro
   cQuery+= "UNION ALL SELECT  'AUROLIGHT'  AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO FROM CT2150 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND  D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
EndIf   
cQuery+= "UNION ALL SELECT  'T4F_MATRIZ' AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2080 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' "  + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'METRO'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2090 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'VICAR'      AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2160 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'AeB'        AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2200 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'AREA_MKT'   AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2250 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
cQuery+= "UNION ALL SELECT  'PLF'   	 AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_CREDIT AS CONTA, CT2_VALOR       AS VALOR, CT2_HIST, CT2_CCC AS CUSTO, CT2_ITEMC AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO,CT2_CODFOR,A2_NOME FROM CT2320 CT2 LEFT JOIN SA2080 SA2 ON CT2_CODFOR = A2_COD WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_CREDIT BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND CT2.D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
If lAuro
   cQuery+= "UNION ALL SELECT  'AUROLIGHT'  AS EMPRESA, SUBSTRING(CT2_DATA,5,2)||SUBSTRING(CT2_DATA,1,4) AS PERIODO, CT2_DATA, CT2_LOTE, CT2_DEBITO AS CONTA,( CT2_VALOR*-1 ) AS VALOR, CT2_HIST, CT2_CCD AS CUSTO, CT2_ITEMD AS EL_PEPE, CT2_ATIVDE, CT2_ATIVCR, CT2_XDOC ,CT2_XUSER ,CT2_XDATA ,CT2_XPEDCO FROM CT2150 WHERE CT2_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND CT2_DEBITO BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR04)+"' AND D_E_L_E_T_ = ' ' " + Iif(!Empty(MV_PAR06)," AND CT2_TPSALD = '" + AllTrim(MV_PAR06) + "' ","")
EndIf
cQuery+= "ORDER BY EMPRESA, CT2_DATA "

cQuery:= ChangeQuery(cQuery)

Memowrite("C:\CONSOLIDADO.SQL",cquery)   

MsAguarde( { || dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"CONSOLID",.F.,.T.)},"Aguarde... Consultando o Banco de Dados...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Compatibiliza os campos com a TopField ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
      
	MsAguarde( { || u_DB2XML(_cArquivo, _cPNome, _cAlias,,,,"2007","Consolid->EMPRESA+' - '+DTOC(Consolid->CT2_DATA)")},"Aguarde Gerando Arquivo...")

//	ApMsgInfo("Arquivo :"+_cArquivo+".xml gerado. Verifique o disco local de sua mแquina"+chr(13)+"Aperte OK para continuar gerando o relat๓rio...","Informa็ใo","INFO") editado a mensagem para menor.  Thiago Moraes 09-05-2019      
	ApMsgInfo("Arquivo gerado no caminho:  "+_cArquivo+".xml")

EndIF             

CONSOLID->( DbCloseArea() )

Return(Nil)