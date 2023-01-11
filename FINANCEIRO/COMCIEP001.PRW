#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CIEP001     º Autor ³ Claudio Barros   º Data ³  15/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ajuste do Cadastro dos Fornecedores e Atualizacao          º±±
±±º          ³ do contas a pagar                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function COMCIEP001()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


// MsAguarde({ || CIEPSA2() },"Aguarde","Processando Fornecedores...",.F.)

MsAguarde({ || CIEPSE2() },"Aguarde","Processando Titulos...",.F.)


Static Function CIEPSA2

Private cString := "SA2"

dbSelectArea("SA2")
dbSetOrder(1)
SA2->(DbGotop())

While !SA2->(Eof())
      MsProcTxt("Atualizando Cadastro de Fornecedores "+SA2->A2_COD) 
//      IF EMPTY(SA2->A2_NREDUZ)
//         nPOS := AT(" ",SA2->A2_NOME) 
//         cReduz := SUBS(SA2->A2_NOME,1,nPOS-1)
//         IF EMPTY(A2_NREDUZ)
            RecLock("SA2",.F.)
//          SA2->A2_NREDUZ := cReduz 
            SA2->A2_NREDUZ := SUBS(SA2->A2_NOME,1,20)
            SA2->(MsUnlock())
//         ENDIF   
//      ENDIF             
      SA2->(DBSKIP())
End      


Return


Static Function CIEPSE2()

dbSelectArea("SE2")
dbSetOrder(1)
SE2->(DbGotop())


While !	SE2->(EOF())
      MsProcTxt("Atualizando Titulos  "+SE2->E2_PREFIXO+"  "+SE2->E2_NUM) 

//      IF !EMPTY(E2->E2_NOMFOR)
//         SE2->(DBSKIP())
//         LOOP
//      ENDIF   
      DBSELECTAREA("SA2")
      SA2->(DBSETORDER(1))
      SA2->(DBGOTOP())
      IF SA2->(DBSEEK(xFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA))
         RecLock("SE2",.F.)
         SE2->E2_NOMFOR := SA2->A2_NREDUZ
         SE2->(MsUnLock())
      ENDIF   
      SE2->(DBSKIP())
END

Return


Static Function CIEPCTT()


Local cQuery := ""
Local CFOL   := Chr(13)+Chr(10)



cQuery := " SELECT C7_NUM,C7_CC, C7_PRODUTO,C7_ITEM FROM "+RetSqlName("SC7")+"  " + cFOL
cQuery += " WHERE D_E_L_E_T_ == ' ' AND C7_FILIAL = '"+xFilial("SD2")+"'  " + cFOL
cQuery += " AND C7_CC <> ' ' AND C7_QUJE < C7_QUANT " + cFOL
cQuery += " AND C7_ENCER == ' '  " + cFOL
cQuery += " ORDER C7_CC " + cFOL
//TCQUERY cQuery NEW ALIAS "TRB"

dbSelectArea("TRB")
dbGoTop()

While !TRB->(EOF())

      DBSELECTAREA("SC7")
      SC7->(DBSETORDER(1))
      IF SC7->(DBSEEK(xFILIAL("SC7")+TRB->C7_NUM+TRB->C7_ITEM))
         RecLock("SC7",.F.)
         SC7->C7_CC := VerCtt(TRB->C7_CC)
//         SC7->C7_
         SC7->(MsUnlock())

      EndIf

      TRB->(DBSKIP())
End


Dbselectarea("TRB")
TRB->(DbCloseArea())


Return


Static Function VerCtt(pCUSTO)

Local cQuery := ""
Local CFOL   := Chr(13)+Chr(10)


cQuery := " SELECT CTT_CCANT,C7_CUSTO  FROM "+RetSqlName("SC7")+"  " + cFOL
cQuery += " WHERE D_E_L_E_T_ == ' ' AND C7_FILIAL = '"+xFilial("SD2")+"'  " + cFOL
cQuery += " AND C7_CCANT = '"+pCUSTO+"' " + cFOL  
cQuery += " AND C7_ENCER == ' '  " + cFOL
cQuery += " ORDER C7_CC " + cFOL
//TCQUERY cQuery NEW ALIAS "TRB"

Return






