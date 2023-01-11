#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณT4COMA10  บAutor  ณ Totvs              บ Data ณ  23/09/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa JOB para elimina็ใo de residuos dos PCดs           บฑฑ
ฑฑบ          ณ PL: PLCOM10                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ T4F                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION T4COMA10(aParam1) 
	Local lJob	:= IIF(VALTYPE(aParam1) == "U", .F., .T.)

	DEFAULT   aParam1:={}

	AADD(aParam1,{CEMPANT}) 
	AADD(aParam1,{CFILANT})

	If lJob
		cEmp := aParam1[1]
		cFil := aParam1[2] 
		RpcSetType( 3 )
		RpcSetEnv( cEmp, cFil,,,'COM')	
	Else
		cEmp := cEmpAnt
		cFil := cFilAnt
	EndIf

	//cEmp := CEMPANT
	//cFil := CFILANT



	PRIVATE lMT235G1 := existblock("MT235G1")

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	// CONOUT("T4COMA10 - Inicio - Empresa/Filial: "+cEmp+"/"+cFil)
	FWLogMsg("INFO", "", "", "T4COMA10", "", "", "T4COMA10 - Inicio - Empresa/Filial: " + cEmp + "/" + cFil, 0, 0)

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	Pergunte("MTA235",.F.)

	mv_par01 := 100                         // Percentual maximo
	mv_par02 := CTOD(SPACE(8))              // Data de Emissao de
	mv_par03 := dDataBase                   // Data ate
	mv_par04 := SPACE(TamSX3('C7_NUM')[1])  // Pedido de
	mv_par05 := SPACE(TamSX3('C7_NUM')[1])  // Pedido ate
	mv_par06 := SPACE(TamSX3('B1_COD')[1])  // Produto de
	mv_par07 := REPLICATE("Z",TamSX3('B1_COD')[1]) // Produto ate
	mv_par08 := 1 // Elimina residuo por: 1-Pedido 2-Aut.Entr 3-Pedido e Autor. 4-Solicitacao
	mv_par09 := SPACE(TamSX3('A2_COD')[1]) // Fornecedor de
	mv_par10 := REPLICATE("Z",TamSX3('A2_COD')[1]) // Fornecedor ate
	mv_par11 := CTOD("01/01/1990") // Data Entrega de
	mv_par12 := dDataBase // Data Entrega ate
	mv_par13 := 2 // - Elimina SC com OP? 1-Sim  2-Nao

	nDiasProc := GETNEWPAR("T4_QTDRES",60)

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	// CONOUT("T4COMA10 - Seleciona pedidos a eliminar.")

	FWLogMsg("INFO", "", "", "T4COMA10", "", "", "T4COMA10 - Seleciona pedidos a eliminar.", 0, 0)

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	// Seleciona os pedidos reprovados 
	cQ := "SELECT DISTINCT(CR_NUM) FROM "+RetSqlName("SCR")
	cQ += " WHERE CR_FILIAL = '"+XFILIAL("SCR")+"'"
	cQ += " AND CR_TIPO = 'PC' "
	cQ += " AND CR_STATUS = '04' "
	cQ += " AND CR_DATALIB <= '"+DTOS(dDataBase - nDiasProc)+"'"
	cQ +="  AND D_E_L_E_T_ <> '*'" 
	TcQuery ChangeQuery(cQ) ALIAS "QrySCR" NEW    

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 19/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	IF QrySCR->(EOF())
		CONOUT("T4COMA10 - Nใo existem pedidos a eliminar.")
	ELSE
		WHILE QrySCR->(!EOF())	                            
			CONOUT("T4COMA10 - ELimina resํduo do pedido: "+QrySCR->CR_NUM)	
			mv_par04 := QrySCR->CR_NUM
			mv_par05 := QrySCR->CR_NUM		
			Processa({|lEnd| MA235PC(mv_par01,mv_par08,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par09,mv_par10,mv_par11,mv_par12,mv_par14,mv_par15)})		
			QrySCR->(DBSKIP())
		END
	ENDIF	
	QrySCR->(DBCLOSEAREA())
	CONOUT("T4COMA10 - Fim - Empresa/Filial: "+cEmp+"/"+cFil)	
	*/

	IF QrySCR->(EOF())
		FWLogMsg("INFO", "", "", "T4COMA10", "", "","T4COMA10 - Nใo existem pedidos a eliminar.", 0, 0)
	ELSE
		WHILE QrySCR->(!EOF())	                            
			FWLogMsg("INFO", "", "", "T4COMA10", "", "","T4COMA10 - ELimina resํduo do pedido: " + QrySCR->CR_NUM , 0, 0)			
			mv_par04 := QrySCR->CR_NUM
			mv_par05 := QrySCR->CR_NUM		
			Processa({|lEnd| MA235PC(mv_par01,mv_par08,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par09,mv_par10,mv_par11,mv_par12,mv_par14,mv_par15)})		
			QrySCR->(DBSKIP())
		END
	ENDIF	
	QrySCR->(DBCLOSEAREA())
	FWLogMsg("INFO", "", "", "T4COMA10", "", "","T4COMA10 - Fim - Empresa/Filial: "+cEmp+"/"+cFil , 0, 0)	

	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------	

	//RpcClearEnv()                         

RETURN