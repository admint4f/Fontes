#INCLUDE "TOTVS.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"
#include "PRTOPDEF.CH"



User function T4FEXCNETPDV()

Local lEnd		:= .F.
Local oGrid	 	:= Nil
Local cTitulo	 := "Integração NetPDV x Protheus"
Local cDescricao := "Realiza a exclusão das NFs e Orçamentos que tiveram erro na integração."

Private lRet      := .F.

	oGrid := FWGridProcess():New("T4FEXCNETPDV",cTitulo,cDescricao,{|lEnd| T4FEXCZZX(oGrid)},/*cPergunta*/,/*cGrid*/,/*lSaveLog*/)
	oGrid:SetMeters(1)
	oGrid:Activate()
	If oGrid:IsFinished()
		FWAlertSuccess("Processamento finalizada com sucesso!", "Sucesso!")
	Else
		FWAlertError("Erro ao realizar Processamento!","Error!")
	EndIf
	oGrid:DeActivate()
	FwFreeObj(oGrid)

RETURN



Static function T4FEXCZZX(oGrid)

Local cAliasZZX := GetNextAlias()
Local cHistor   := ""
Local  cMsg     := ""
Local cRecnos:= "'"

Default cStatus:= "5"
Default cEvento	 := SuperGetMv("ES_EVTNETP",.F.,"11254") 

//RPCSetType(3)
//PREPARE ENVIRONMENT EMPRESA "20" FILIAL "01" MODULO "LOJA"

	cQuery := " SELECT ZZX_DOC DOC,ZZX_ORC ORC, ZZX_STATUS STATUS,"
    cQuery += " LISTAGG(R_E_C_N_O_ , ',') WITHIN GROUP (ORDER BY R_E_C_N_O_) RECNO "
	cQuery += " FROM " + RetSQLName("ZZX") + " ZZX "
	cQuery += " WHERE D_E_L_E_T_ <> '*' "
	cQuery += " AND ZZX.ZZX_IDEVEN = '"+cEvento+"' "
	cQuery += " AND ZZX_INTEGR = 'S' "
	cQuery += " AND ZZX_STATUS = '"+cStatus+"' "
	cQuery += " GROUP BY ZZX_DOC,ZZX_ORC,ZZX_STATUS "
	cQuery += " ORDER BY ZZX_DOC,ZZX_ORC "
	TCQuery cQuery New Alias (cAliasZZX)

	IF (cAliasZZX)->(!EOF())
		
		While (cAliasZZX)->(!EOF())

            
			cNumero:= (cAliasZZX)->DOC
			cOrcamento:= (cAliasZZX)->ORC
			cStatus:= (cAliasZZX)->STATUS
            cRecnos += ALLTRIM((cAliasZZX)->RECNO) + ","
			oGrid:SetIncMeter(1,"Processando DOC: "+cNumero + " | ORC: "+cOrcamento)
            IF !EMPTY((cAliasZZX)->DOC)
				
				DbSelectArea("SL1")
				DbSetOrder(2)
				DBGOTOP()
				IF dbseek (xFilial("SL1")+'2  '+ (cAliasZZX)->DOC)

					IF SL1->L1_RETSFZ $ "100|Autorizado"
                        (cAliasZZX)->(dbskip())
						Loop
					ELSE
                        begin transaction
						cNumOrc :=  SL1->L1_NUM
						cRecnoSL1:= SL1->(RECNO())
						DbSelectArea("SF2")
						DbSetOrder(10)
						dbgotop()
						IF dbseek(XFilial("SF2")+'2  '+(cAliasZZX)->DOC)
                            reclock("SL1",.F.)
                            
                        ELSE
                            reclock("SL1",.F.)
                            SL1->L1_DOC := ""
                            SL1->L1_SERIE := ""
						    
						ENDIF

						SL1->L1_ESPECIE := ""
						SL1->L1_KEYNFCE := ""
						MsUnlock()
						xRet140 := Lj140Exc( "SL1", cRecnoSL1, 2, Nil, .T., SL1->L1_FILIAL, SL1->L1_NUM )
						If ValType(xRet140) == "N"
							If xRet140 <> 1
								//SE ERRO AO EXCLUIR
                                cHistor:= "ROTINA EXCLUSAO"
                                cMsg   := "ERRO AO EXCLUIR NF E ORÇAMENTO"
								//(cAliasZZX)->(dbskip())
								//Loop
							Else
                                cHistor:= "Excluído DOC:"+ALLTRIM(cNumero) + " | ORC:"+ALLTRIM(cOrcamento)
								cNumero:= "  "
								cOrcamento:= "  "
								cStatus:= "1"
							EndIf
						Else
							//ERRO DESCONHECIDO NA EXCLUSAO
                            cHistor:= "ROTINA EXCLUSAO"
                            cMsg   := "ERRO AO EXCLUIR NF E ORÇAMENTO"
							//(cAliasZZX)->(dbskip())
							//Loop
						EndIf

                        cRecnos:= REPLACE(cRecnos,",","','")
                        cRecnos:= LEFT(cRecnos,len(cRecnos)-2)
                        lRet:= U_grvStZZX(cStatus,cRecnos,cOrcamento,cNumero,cMsg,cHistor,.T.)
                        IF !lRet
                            DisarmTransaction()
                        ENDIF
                        cRecnos:= "'"
                        
                        end transaction

                        SF2->(DBCLOSEAREA())

					ENDIF
				ELSE
                    cHistor:= "ROTINA EXCLUSAO"
                    cNumero:= "  "
					cOrcamento:= "  "
					cStatus:= "1"

                    cRecnos:= REPLACE(cRecnos,",","','")
                    cRecnos:= LEFT(cRecnos,len(cRecnos)-2)
                    lRet:= U_grvStZZX(cStatus,cRecnos,cOrcamento,cNumero,cMsg,cHistor,.T.)
                    cRecnos:= "'"
				ENDIF
                SL1->(DBCLOSEAREA())
				
			ENDIF
            
			(cAliasZZX)->(dbskip())
		END
	ENDIF

//RESET ENVIRONMENT
RETURN
