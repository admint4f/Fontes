#INCLUDE "PRTOPDEF.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} PARAN
Permite que o usuário altere os parâmetros de travamento dos movimentos contábeis,
Fiscal, Financeiro, Folha e de Estoque através de uma interface.
@type function
@version 1.00
@author Lucas Valins
@since 27/08/2020
/*/
User Function PARAN()
	Local lOk := .F.
	Local lAch := .f.
	Local dMV_EST := GETMV("MV_DBLQMOV")
	Local dMV_dDE := GETMV("MV_DATADE")
	Local dMV_ATE := GETMV("MV_DATAATE")
	Local dMV_FIN := GETMV("MV_DATAFIN")
	Local dMV_FIS := GETMV("MV_DATAFIS")
	Local cParan := SuperGetMV('MV_USERCON')

	If cUserName$cParan
		@ 000,000 TO 395,355 DIALOG oDlg TITLE "Parametros Contabil/Financeiro"
		@ 001,011 SAY "Periodo Lancto Contabeis"
		@ 002,001 SAY "Data Inicio (MV_DATADE ):"
		@ 003,001 SAY "Data Final  (MV_DATAATE):"
		@ 005,011 SAY "Operacoes Financeiras"
		@ 006,001 SAY "Data Fechto (MV_DATAFIN):"
		@ 008,011 SAY "Operacoes Fiscais"
		@ 009,001 SAY "Data Fechto (MV_DATAFIS):"
		@ 011,011 SAY "Bloqueio Estoque"
		@ 012,001 SAY "Data Fechto (MV_DBLQMOV):"

		@ 002,011 GET dMV_dDE   SIZE 050,010
		@ 003,011 GET dMV_ATE	SIZE 50,10
		@ 006,011 GET dMV_FIN	SIZE 50,10
		@ 009,011 GET dMV_FIS 	SIZE 50,10
		@ 012,011 GET dMV_EST 	SIZE 50,10

		@ 175, 050 BMPBUTTON TYPE 1 ACTION (lOk := .t. , Close( oDlg ) )
		@ 175, 110 BMPBUTTON TYPE 2 ACTION (lOk := .f. , Close( oDlg ) )

		ACTIVATE DIALOG oDlg CENTERED

		IF lOk .AND. MSGYESNO("Confirma a alteracao dos parametros ?")

			// AJUSTANDO O PARAMETRO MV_DATADE
			DBSELECTAREA( "SX6" )
			IF !DBSEEK( cFilAnt + "MV_DATADE")
				lAch := DBSEEK( "  "+"MV_DATADE")
			ELSE
				lAch := .T.
			ENDIF
			IF lAch
				RECLOCK("SX6", .F. )
				REPLACE X6_CONTEUD WITH dTOC(dMV_dDE)
				MSUNLOCK()
			ENDIF

			// AJUSTANDO O PARAMETRO MV_DATAATE
			DBSELECTAREA( "SX6" )
			IF !DBSEEK( cFilAnt + "MV_DATAATE")
				lAch := DBSEEK( "  "+"MV_DATAATE")
			ELSE
				lAch := .T.
			ENDIF
			IF lAch
				RECLOCK("SX6", .F. )
				REPLACE X6_CONTEUD WITH dTOC(dMV_ATE)
				MSUNLOCK()
			ENDIF

			// AJUSTANDO O PARAMETRO MV_DATAFIN
			DBSELECTAREA( "SX6" )
			IF !DBSEEK( cFilAnt + "MV_DATAFIN")
				lAch := DBSEEK( "  "+"MV_DATAFIN")
			ELSE
				lAch := .T.
			ENDIF
			IF lAch
				RECLOCK("SX6", .F. )
				REPLACE X6_CONTEUD WITH dTOs(dMV_FIN)
				MSUNLOCK()
			ENDIF


			// AJUSTANDO O PARAMETRO MV_DATAFIS
			DBSELECTAREA( "SX6" )
			IF !DBSEEK( cFilAnt + "MV_DATAFIS")
				lAch := DBSEEK( "  "+"MV_DATAFIS")
			ELSE
				lAch := .T.
			ENDIF
			IF lAch
				RECLOCK("SX6", .F. )
				REPLACE X6_CONTEUD WITH dTOs(dMV_FIS)
				MSUNLOCK()
			ENDIF

			// AJUSTANDO O PARAMETRO MV_DBLQMOV
			DBSELECTAREA( "SX6" )
			IF !DBSEEK( cFilAnt + "MV_DBLQMOV")
				lAch := DBSEEK( "  "+"MV_DBLQMOV")
			ELSE
				lAch := .T.
			ENDIF
			IF lAch
				RECLOCK("SX6", .F. )
				REPLACE X6_CONTEUD WITH dTOs(dMV_EST)
				MSUNLOCK()
			ENDIF

		ENDIF

	Else
		MsgAlert('Usuário sem permissão para acessar a rotina','Usuário Sem Permissão')
   ENDIF
RETURN
