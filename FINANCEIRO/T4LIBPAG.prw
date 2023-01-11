#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4LIBPAG  ºAutor  ³Microsiga           º Data ³  26/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function T4LIBPAG(aParam) 
Local _cEmpresa	:= "08,09,15,16,20,25"  //Setando a empresa no Fonte, o processamento do serviço do Job é menor. Configurar apenas empresa 08, Fil 01 no Schedule 
Local _aEmprFil := {}
Private _lJob	:= .T.   

If aParam == Nil .OR. VALTYPE(aParam) == "U"
	_lJob	:= .F.
EndIf    
                                           
If _lJob
	RpcSetType(3)
	RpcSetEnv(aParam[1],aParam[2])
	DbSelectArea("SM0")
    SM0->(DbSetOrder(1))
	WHILE !SM0->(EOF()) 
	
		If !(SM0->M0_CODIGO $ _cEmpresa)
			SM0->(DbSkip())
			Loop
		EndIf
		
		aAdd(_aEmprFil,{SM0->M0_CODIGO,SM0->M0_CODFIL})

		SM0->(DbSkip())	 
	EndDo
	RpcClearEnv()		
	For _nx := 1 to Len(_aEmprFil)
		RpcSetType(3)
		RpcSetEnv(_aEmprFil[_nx][1],_aEmprFil[_nx][2])	
		
	    DbSelectArea("SM0")
    	SM0->(DbSetOrder(1))
    	SM0->( DbSeek(_aEmprFil[_nx][1]+_aEmprFil[_nx][2]) )
                
		cEmpAnt	:= _aEmprFil[_nx][1]
		cFilAnt	:= _aEmprFil[_nx][2]
		Conout("LIBPAG INICIO - Empresa/Filial: " + cEmpAnt + "/"+cFilAnt+". Inicio Processamento")
        LibPag()
        
        RpcClearEnv()
	Next

Else	
	LibPag()
EndIf



Return  
                 
/*******************************************
Realiza Liberacao de Pagamentos
*******************************************/
Static Function LibPag()
Local cQry := ""

cQry := " UPDATE " + RetSqlName("SE2") 
cQry += " SET E2_DATALIB='" +DTOS(Date())+ "', E2_USUALIB='Administrador' "
cQry += " WHERE E2_FILIAL ='" + xFilial("SE2")+ "' "
cQry += " AND E2_TIPO NOT IN ('NF ') AND E2_DATALIB=' ' "
cQry += " AND D_E_L_E_T_ = ' ' "         

nErro	:= 0
nErro	:= TcSqlExec(cQry)      

If nErro <> 0                      
	If _lJob                                                       
		Conout("LIBPAG FIM - Empresa/Filial: " + cEmpAnt + "/"+cFilAnt+". Erro ao liberar titulos!")
	Else
		Alert("Empresa/Filial: " + cEmpAnt + "/"+cFilAnt+". Erro ao liberar titulos!")
	EndIf  
Else
	If _lJob                                                       
		Conout("LIBPAG FIM - Empresa/Filial: " + cEmpAnt + "/"+cFilAnt+". Titulos Liberados!")
	Else
		MsgInfo("Empresa/Filial: " + cEmpAnt + "/"+cFilAnt+". Titulos Liberados!")
	EndIf 
EndIf

Return