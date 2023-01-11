#INCLUDE "rwmake.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥NANRET    ∫ Autor ≥ Fabiano/Renato      ∫ Data ≥  09/05/08  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ ANALISE DE RENTABILIDADE.                                  ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP6 IDE                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
O relatÛrio ter· as seguintes colunas:
OrÁado (a)  Previsto (b)   Real ProduÁ„o (c)   Real Cont·bil (d)              Desvios
Previsto x orÁado     Real ProduÁ„o x Previsto    Cont·bil x Previsto
( b ñ a ) / A         ( c ñ b ) / B               (d ñ b ) / B
R$ e %                R$ e %                      R$ e %



/*/

User Function NANRET()


	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Declaracao de Variaveis                                             ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2         := "de acordo com os parametros informados pelo usuario."
	Local cDesc3         := "ANALISE DE RENTABILIDADE"
	Local cPict          := ""
	Local titulo       := "ANALISE DE RENTABILIDADE"

	Local Cabec1       := ""
	Local Cabec2       := ""
	Local imprime      := .T.
	Local aOrd := {}
	Local nLin         := 80

	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite           := 150 //80
	Private tamanho          := "G"  //M
	Private nomeprog         := "ANALISE" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo            := 18
	Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey        := 0
	Private cPerg       := "NANRET"
	Private cbtxt      := Space(10)
	Private cbcont     := 00
	Private CONTFL     := 01
	Private m_pag      := 01
	Private wnrel      := "ANALISE" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString := "SZL"
	Private cCT4 := ""

	dbSelectArea("SZL")
	dbSetOrder(2)

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	
	//ValidPerg()
	
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
	
	pergunte(cPerg,.F.)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Monta a interface padrao com o usuario...                           ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Processamento. RPTSTATUS monta janela com a regua de processamento. ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ AP6 IDE            ∫ Data ≥  18/05/04   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ∫±±
±±∫          ≥ monta a janela com a regua de processamento.               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem

	dbSelectArea(cString)
	dbSetOrder(2)

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ SETREGUA -> Indica quantos registros serao processados para a regua ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	SetRegua(RecCount())


	dbGoTop()

	//DbSeek(xFilial("SZL")+mv_par01,.T.)
	//While !EOF() .And. SZL->ZL_FILIAL = xFilial("SZL") .And. SZL->ZL_CHAVE1 <= mv_par02
	While !EOF() .And. SZL->ZL_FILIAL = xFilial("SZL")

		// Alterado por Adriano em 19.06.2008
		IF !EMPTY(MV_PAR01)
			IF SZL->ZL_ELEMPEP <> mv_par01
				DBSKIP()
				LOOP
			ENDIF
		ELSE
			IF SZL->ZL_CHAVE1 <> mv_par04
				DBSKIP()
				LOOP
			ENDIF
		ENDIF
		// IF SZL->ZL_MESANT == "S"
		//    DBSKIP()
		//    LOOP
		// ENDIF

		_CHAVE1  := SZL->ZL_CHAVE1
		_DESCRI  := SZL->ZL_DESCRI
		_ARTISTA    := SZL->ZL_ARTISTA
		_DATAINI    := SZL->ZL_DATAINI
		_DATAFIM    := SZL->ZL_DATAFIM
		_NUMAPRE    := SZL->ZL_NUMAPRE
		_TXOCUPA    := SZL->ZL_TXOCUPA
		_PRMEDIO    := SZL->ZL_PRMEDIO
		_OPMEDIO   := SZL->ZL_OPMEDIO
		_CORTESI    := SZL->ZL_CORTESI
		_TXESTUD    := SZL->ZL_TXESTUD
		_PUBEST     := SZL->ZL_PUBEST
		_PORCART    := SZL->ZL_PORCART
		_PMEDIOR    := SZL->ZL_PMEDIOR
		_BILEST     := SZL->ZL_BILEST
		_OBILEST    := SZL->ZL_OBILEST
		_VENDASR    := SZL->ZL_VENDASR
		_QUANREA   := SZL->ZL_QUANREA
		_CPARTAR    := SZL->ZL_CPARTAR
		_TOTAIMO    := SZL->ZL_TOTAIMO
		_OALUGIM    := SZL->ZL_OALUGIM
		_CALUIMO    := SZL->ZL_CALUIMO
		_TOTMIDI    := SZL->ZL_TOTMIDI
		_PORCMID    := SZL->ZL_PORCMID
		_MIDIA      := SZL->ZL_MIDIA
		_OMIDIA     := SZL->ZL_OMIDIA
		_CMIDIA     := SZL->ZL_CMIDIA
		_TOTCPRO    := SZL->ZL_TOTCPRO
		_ODESP      := SZL->ZL_ODESP
		_CODESP     := SZL->ZL_CODESP
		_SOM        := SZL->ZL_SOM
		_CSOM       := SZL->ZL_CSOM
		_LUZ        := SZL->ZL_LUZ
		_CLUZ        := SZL->ZL_CLUZ
		_vendascc := SZL->ZL_VENDACC
		_PARTCOD := SZL->ZL_PARTCOD
		_PORCCC   := SZL->ZL_PORCCC
		_CTTERRE    :=SZL->ZL_CTTERRE
		_ALIMENTA    :=SZL->ZL_NPESSDI*SZL->ZL_NDIAALI*SZL->ZL_VALDALI
		_CALIMENTA  := SZL->ZL_CALIMEN
		_TREQUIP    := SZL->ZL_TREQUIP
		_CTEQUIP   := SZL->ZL_CTEQUIP
		_BACKLIN    := SZL->ZL_BACKLIN
		_CBACLIN    := SZL->ZL_CBACLIN
		_CPCARTI    := SZL->ZL_CPCARTI
		_RESSHOW    := SZL->ZL_RESSHOW
		_ORESULT    := SZL->ZL_ORESULT
		_PORCCC     := SZL->ZL_PORCCC
		_DPERFIL    := SZL->ZL_DPERFIL
		_DESCTIP    := SZL->ZL_DESCTIP
		_parttip       := SZL->ZL_PARTTIP
		_TOTIMPO := SZL->ZL_TOTIMPO
		_OECAD    := SZL->ZL_OECAD
		_ONEGOCI := SZL->ZL_ONEGOCI
		_BILLIQU := SZL->ZL_BILLIQU
		_OBILLIQ := SZL->ZL_OBILLIQ
		_partart := SZL->ZL_CPARTAR 
		_ppartart:= SZL->ZL_TOTPART
		_opartart:= SZL->ZL_OPARTAR
		_CHOSP := SZL->ZL_CHOSP
		_CCAMARI := SZL->ZL_CCAMARI
		_CTAEREO := SZL->ZL_CTAEREO
		_HOSP := (SZL->ZL_QUANSIN * SZL->ZL_NUMDSIN * SZL->ZL_VALSING) + (SZL->ZL_QSUITE * SZL->ZL_NDSUITE * SZL->ZL_VALSUIT) + (SZL->ZL_QUANDOU * SZL->ZL_NUMDDOU * SZL->ZL_VALDOUB) +(SZL->ZL_QUANTRI * SZL->ZL_NUMTRIP * SZL->ZL_VALTRIP)
		_CAMARIM := SZL->ZL_CAMARIM
		_TOTAERE := SZL->ZL_TOTAERE
		_TOTTERR := SZL->ZL_TOTTERR
		//_PROMO      := SZL->ZL_PROMO

		XX_ELEMPEP := SZL->ZL_ELEMPEP	
		// Busca os Dados Cont·beis
		//	_SOMCTB := SALDOITEM("","",SZL->ZL_ELEMPEP,"01","1",1)

		// SOMA CUSTOS BILHETERIA
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '411011001','411011003','412011001','412011003'"	//,'413011003','413101002','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,2) = '04' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '411011001','411011003','412011001','412011003'"	//,'413011003','413101002','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,2) = '04' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '411011001','411011003','412011001','412011003'"	//,'413011003','413101002','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,2) = '04' "      

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '411011001','411011003','412011001','412011003'"	//,'413011003','413101002','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,2) = '04' " 
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_BILHCTB := cCT4->DEBITO - cCT4->CREDIT
		_BILHCTB := _BILHCTB * -1


		// SOMA ISS CONSUMIDORES
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413191001','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,2) = '04' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413191001','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413191001','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413191001','413191003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X "                                                                                

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_CUS_ISS := cCT4->DEBITO - cCT4->CREDIT

		// SOMA PIS CONSUMIDORES
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413011001', '413101001' ,'413011003','413101003'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413011001', '413101001' ,'413011003','413101003'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "     

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413011001', '413101001' ,'413011003','413101003'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '413011001', '413101001' ,'413011003','413101003'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              
		cQry += " ) X "


		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_CUS_PIS := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CUSTOS DE PRODU«√O
		//'313011003',
		cQry := ""                                                                                                        
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ('311011001','311011002','311011003','311011004','311011005','311011006','311011007','311011008','311011009','311011010','311011011','311011012','311011013', "
		cQry += " '311011014','311011015','311011016','311011017','311011018','311011019','311011020','311011021','311021001','311021002','311021003','311021004','311021005','311021006','311031001','311031002', "
		cQry += " '311041001','311041002','311041003','311041004','311041005','311051001','311051002','311051003','311051004','311051005','311051006','311061001','311071001','311071002','312041001','312041002','312041003','312041004', "
		cQry += " '312041005','312041006','312041007','312041009','312041012','312041013','312041014','312041016','312041017','312041018','312041019','312041020','312041023','312041024','312041027','312049999', "
		cQry += " '312051001','312051002','312051004','312051005','312051006','312051007','312051008','312051009','312051010','312051011','312059999','312071001','312071002','312071003','312071004','312071005','312071006', "
		cQry += " '312071008','312071009','312071010','312071011','312071012','312071013','312071014','312071015','312071016','312071017','312071018','312071019','312071020','312071021','312071022','312071023', "
		cQry += " '312071024','312071025','312071026','312071027','312071028','312071029','312071030','312071031','312071032','312071033','312071034','312079999','312081001','312081002','312081003','312081004','312081005','312081006','312081007', "
		cQry += " '312081008','312081009','312089999','312091001','312091002','312091003','312091004','312091005','312091006','312091007','312091008','312091009','312091010','312099999','312101001','312101002','313011001','313011002', "
		cQry += " '313011004','313011005','313011006','313011007','313011008','313011011','313011012','313011013','313011014','313011015','313019999','313021003','313031001','313031002','313031003','313031004','313031005','313031006','313031007','313031008','313039999', "
		cQry += " '313041002','313041003','313041004','313049999','313051001','313051004','313051005','313051006','313051007','313051008','313061001') "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ('311011001','311011002','311011003','311011004','311011005','311011006','311011007','311011008','311011009','311011010','311011011','311011012','311011013', "
		cQry += " '311011014','311011015','311011016','311011017','311011018','311011019','311011020','311011021','311021001','311021002','311021003','311021004','311021005','311021006','311031001','311031002', "
		cQry += " '311041001','311041002','311041003','311041004','311041005','311051001','311051002','311051003','311051004','311051005','311051006','311061001','311071001','311071002','312041001','312041002','312041003','312041004', "
		cQry += " '312041005','312041006','312041007','312041009','312041012','312041013','312041014','312041016','312041017','312041018','312041019','312041020','312041023','312041024','312041027','312049999', "
		cQry += " '312051001','312051002','312051004','312051005','312051006','312051007','312051008','312051009','312051010','312051011','312059999','312071001','312071002','312071003','312071004','312071005','312071006', "
		cQry += " '312071008','312071009','312071010','312071011','312071012','312071013','312071014','312071015','312071016','312071017','312071018','312071019','312071020','312071021','312071022','312071023', "
		cQry += " '312071024','312071025','312071026','312071027','312071028','312071029','312071030','312071031','312071032','312071033','312071034','312079999','312081001','312081002','312081003','312081004','312081005','312081006','312081007', "
		cQry += " '312081008','312081009','312089999','312091001','312091002','312091003','312091004','312091005','312091006','312091007','312091008','312091009','312091010','312099999','312101001','312101002','313011001','313011002', "
		cQry += " '313011004','313011005','313011006','313011007','313011008','313011011','313011012','313011013','313011014','313011015','313019999','313021003','313031001','313031002','313031003','313031004','313031005','313031006','313031007','313031008','313039999', "
		cQry += " '313041002','313041003','313041004','313049999','313051001','313051004','313051005','313051006','313051007','313051008','313061001') "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ('311011001','311011002','311011003','311011004','311011005','311011006','311011007','311011008','311011009','311011010','311011011','311011012','311011013', "
		cQry += " '311011014','311011015','311011016','311011017','311011018','311011019','311011020','311011021','311021001','311021002','311021003','311021004','311021005','311021006','311031001','311031002', "
		cQry += " '311041001','311041002','311041003','311041004','311041005','311051001','311051002','311051003','311051004','311051005','311051006','311061001','311071001','311071002','312041001','312041002','312041003','312041004', "
		cQry += " '312041005','312041006','312041007','312041009','312041012','312041013','312041014','312041016','312041017','312041018','312041019','312041020','312041023','312041024','312041027','312049999', "
		cQry += " '312051001','312051002','312051004','312051005','312051006','312051007','312051008','312051009','312051010','312051011','312059999','312071001','312071002','312071003','312071004','312071005','312071006', "
		cQry += " '312071008','312071009','312071010','312071011','312071012','312071013','312071014','312071015','312071016','312071017','312071018','312071019','312071020','312071021','312071022','312071023', "
		cQry += " '312071024','312071025','312071026','312071027','312071028','312071029','312071030','312071031','312071032','312071033','312071034','312079999','312081001','312081002','312081003','312081004','312081005','312081006','312081007', "
		cQry += " '312081008','312081009','312089999','312091001','312091002','312091003','312091004','312091005','312091006','312091007','312091008','312091009','312091010','312099999','312101001','312101002','313011001','313011002', "
		cQry += " '313011004','313011005','313011006','313011007','313011008','313011011','313011012','313011013','313011014','313011015','313019999','313021003','313031001','313031002','313031003','313031004','313031005','313031006','313031007','313031008','313039999', "
		cQry += " '313041002','313041003','313041004','313049999','313051001','313051004','313051005','313051006','313051007','313051008','313061001') "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "    

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ('311011001','311011002','311011003','311011004','311011005','311011006','311011007','311011008','311011009','311011010','311011011','311011012','311011013', "
		cQry += " '311011014','311011015','311011016','311011017','311011018','311011019','311011020','311011021','311021001','311021002','311021003','311021004','311021005','311021006','311031001','311031002', "
		cQry += " '311041001','311041002','311041003','311041004','311041005','311051001','311051002','311051003','311051004','311051005','311051006','311061001','311071001','311071002','312041001','312041002','312041003','312041004', "
		cQry += " '312041005','312041006','312041007','312041009','312041012','312041013','312041014','312041016','312041017','312041018','312041019','312041020','312041023','312041024','312041027','312049999', "
		cQry += " '312051001','312051002','312051004','312051005','312051006','312051007','312051008','312051009','312051010','312051011','312059999','312071001','312071002','312071003','312071004','312071005','312071006', "
		cQry += " '312071008','312071009','312071010','312071011','312071012','312071013','312071014','312071015','312071016','312071017','312071018','312071019','312071020','312071021','312071022','312071023', "
		cQry += " '312071024','312071025','312071026','312071027','312071028','312071029','312071030','312071031','312071032','312071033','312071034','312079999','312081001','312081002','312081003','312081004','312081005','312081006','312081007', "
		cQry += " '312081008','312081009','312089999','312091001','312091002','312091003','312091004','312091005','312091006','312091007','312091008','312091009','312091010','312099999','312101001','312101002','313011001','313011002', "
		cQry += " '313011004','313011005','313011006','313011007','313011008','313011011','313011012','313011013','313011014','313011015','313019999','313021003','313031001','313031002','313031003','313031004','313031005','313031006','313031007','313031008','313039999', "
		cQry += " '313041002','313041003','313041004','313049999','313051001','313051004','313051005','313051006','313051007','313051008','313061001') "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_PRODCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CUSTOS DE AJUDA DE CUSTOS
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011010'"		//,'313021005' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011010'"		//,'313021005' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011010'"		//,'313021005' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011010'"		//,'313021005' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_ALIMCTB := cCT4->DEBITO - cCT4->CREDIT

		//ALUGUEIS E IM”VEIS
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001','312049998' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001','312049998' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001','312049998' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001','312049998' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_IMOCTB := cCT4->DEBITO - cCT4->CREDIT
		/*/ Removido por Renato em 9/5/2008
		// SOMA CUSTOS BACKLINE
		cQry := ""
		cQry := " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM " + RetSqlName("CT4")+ " WHERE CT4_ITEM = '" + SZL->ZL_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041025' "
		cQry += " ) "

		If ( Select ( "cCT4" ) <> 0 )
		dbSelectArea ( "cCT4" )
		dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_BACKCTB := cCT4->DEBITO - cCT4->CREDIT
		/*/
		_BACKCTB := 0

		//INSERIDOS EM 5/2008	

		// SOMA CUSTO COM TAXAS DE CART.DE CREDITO
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry +=" ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_CARTCRED := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CUSTOS CAMARIM
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " ( "
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011009','313051002','313051003' "
		cQry += " ) "      
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011009','313051002','313051003' "
		cQry += " ) "      
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011009','313051002','313051003' "
		cQry += " ) "      
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313011009','313051002','313051003' "
		cQry += " ) "      
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                               

		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_CAMACTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CUSTOS ECAD
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312051003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312051003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312051003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312051003' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              
		cQry += " ) X " 

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_ECADCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CUSTOS HOSPEDAGEM
		cQry := ""
		cQry := " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM " + RetSqlName("CT4")+ " WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313021001','313021002' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_HOSPCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CUSTOS LUZ
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041008' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION " 

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041008' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION " 

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041008' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION " 

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041008' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X "                                                                                 

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_LUZCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CUSTOS MIDIA
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999'"
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_MIDCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA CACHE
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312011001','312011002','312021001','312021002' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312011001','312011002','312021001','312021002' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312011001','312011002','312021001','312021002' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "           

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312011001','312011002','312021001','312021002' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              
		cQry += " ) X " 

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_CACHCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA SOM
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041010' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041010' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041010' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041010' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_SOMCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA TRANSP. AERO
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313021004' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313021004' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313021004' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '313021004' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_AREOCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA TRANSP EQUIPAMENTO
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'" //,'312041021','312041026','312071007' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'" //,'312041021','312041026','312071007' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'" //,'312041021','312041026','312071007' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'" //,'312041021','312041026','312071007' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X " 

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_EQUIPCTB := cCT4->DEBITO - cCT4->CREDIT

		// SOMA VALE TRANSPORTE
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                              

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND CT4_CONTA IN ("
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_VALCTB := cCT4->DEBITO - cCT4->CREDIT


		// SOMA OUTROS CUSTOS DE PRODU«√O
		cQry := ""
		cQry := " SELECT SUM(DEBITO) DEBITO, SUM(CREDIT) CREDIT FROM "
		cQry += " (	
		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4080 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND SUBSTR(CT4_CONTA,1,2) = '31'  AND CT4_CONTA NOT IN ("
		cQry += " '313011010',"
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001' ,"
		cQry += " '313011003', "
		cQry += " '313011009','313051002','313051003', "
		cQry += " '312051003', "
		cQry += " '313021001','313021002', "
		cQry += " '312041008', "
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999',"
		cQry += " '312011001','312011002','312021001','312021002', "
		cQry += " '312041010', "
		cQry += " '313021004', "
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'," 
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4090 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND SUBSTR(CT4_CONTA,1,2) = '31'  AND CT4_CONTA NOT IN ("
		cQry += " '313011010',"
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001' ,"
		cQry += " '313011003', "
		cQry += " '313011009','313051002','313051003', "
		cQry += " '312051003', "
		cQry += " '313021001','313021002', "
		cQry += " '312041008', "
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999',"
		cQry += " '312011001','312011002','312021001','312021002', "
		cQry += " '312041010', "
		cQry += " '313021004', "
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'," 
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4200 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND SUBSTR(CT4_CONTA,1,2) = '31'  AND CT4_CONTA NOT IN ("
		cQry += " '313011010',"
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001' ,"
		cQry += " '313011003', "
		cQry += " '313011009','313051002','313051003', "
		cQry += " '312051003', "
		cQry += " '313021001','313021002', "
		cQry += " '312041008', "
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999',"
		cQry += " '312011001','312011002','312021001','312021002', "
		cQry += " '312041010', "
		cQry += " '313021004', "
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'," 
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' "                                           

		cQry += " UNION "

		cQry += " SELECT SUM(CT4_DEBITO) DEBITO, SUM(CT4_CREDIT) CREDIT FROM CT4250 WHERE CT4_ITEM = '" + XX_ELEMPEP +"' "
		cQry += " AND SUBSTR(CT4_CONTA,1,2) = '31'  AND CT4_CONTA NOT IN ("
		cQry += " '313011010',"
		cQry += " '312041011','312041015','312061001','312061002','312061003','312061004','312069999','313031009','313031010','313041001' ,"
		cQry += " '313011003', "
		cQry += " '313011009','313051002','313051003', "
		cQry += " '312051003', "
		cQry += " '313021001','313021002', "
		cQry += " '312041008', "
		cQry += " '313071001','313071002','313071003','313071004','313071005','313071006','313071007','313071008','313071009','313071010','313071011','313071012','313079999',"
		cQry += " '312011001','312011002','312021001','312021002', "
		cQry += " '312041010', "
		cQry += " '313021004', "
		cQry += " '312031001','312031002','312031003','312031004','312031005','312031006','312039999'," 
		cQry += " '312041022','313021006' "
		cQry += " ) "
		cQry += " AND CT4_DATA BETWEEN '"+DTOS(MV_PAR02)+"' AND '"+DTOS(MV_PAR03)+"' "
		cQry += " AND SUBSTR(CT4_CUSTO,1,4) = '0402' " 
		cQry += " ) X "

		If ( Select ( "cCT4" ) <> 0 )
			dbSelectArea ( "cCT4" )
			dbCloseArea ()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"cCT4",.T.,.F.)
		_OCUSPRO := cCT4->DEBITO - cCT4->CREDIT

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Verifica o cancelamento pelo usuario...                             ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		dbSelectArea("SZL")

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Impressao do cabecalho do relatorio. . .                            ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

		If nLin > 44 // Salto de P·gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 7
		Endif

		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		// @nLin,00 PSAY SA1->A1_COD

		nLin := nLin + 1 // Avanca a linha de impressao

		@ nlin,1 PSAY "|" + trim(_DESCRI) + " " + " " + trim(_ARTISTA)
		@ nlin,68 PSAY "Data Emiss„o :"
		@ nlin,83 PSAY date()
		@ nlin,92 PSAY "|"

		nLin := nLin + 1

		@ nLin,1 PSAY "|"
		@ nLin,2 PSAY _DATAINI
		@ nLin,12 PSAY "A"
		@ nLin,14 PSAY _DATAFIM
		@ nLin,28 PSAY "N∫ ApresentaÁıes ="
		@ nLin,47 PSAY _numapRE
		@ nLin,68 PSAY "Analise N∫."
		@ nLin,83 PSAY _chave1
		@ nLin,92 PSAY "|"

		nLin := nLin + 1
		@ nLin,1 PSAY "|__________________________________________________________________________________________|"
		nLin := nLin + 1

		@ nLin,1 PSAY "|"
		@ nLin,2 PSAY "Tx.OcupaÁ„o"
		@ nLin,14 PSAY _txocupa
		@ nLin,17 PSAY "%"
		@ nLin,20 PSAY "PreÁo MÈdio Analise"
		@ nLin,40 PSAY _prmedio picture "999.99"
		@ nLin,47 PSAY "Tx.Estudante"
		@ nLin,60 PSAY _txestud
		@ nLin,63 PSAY "%"
		@ nLin,65 PSAY "Pub.Est."
		@ nLin,73 PSAY _pubest
		@ nLin,92 PSAY "|"
		@ nLin,93 PSAY "Elem.Pep : " + XX_ELEMPEP	//SZL->ZL_ELEMPEP


		nLin := nLin + 1

		@ nLin,1 PSAY "|"
		@ nLin,2 PSAY "Part.Art."
		@ nLin,14 PSAY _porcart
		@ nLin,17 PSAY "%"
		@ nLin,20 PSAY "PreÁo MÈdio OrÁado"
		@ nLin,40 PSAY _opmedio picture "999.99"
		@ nLin,47 PSAY "Cortesias"
		@ nLin,57 PSAY _cortesi

		@ nLin,65 PSAY "N∫Pag.OrÁ."
		//@ nLin,76 PSAY _opagant
		@ nLin,92 PSAY "|"
		//@ nLin,93 PSAY "Tipo       : " + _desctip

		nLin := nLin + 1

		@ nLin,1 PSAY "|"
		@ nLin,20 PSAY "PreÁo MÈdio Realiz"
		@ nLin,40 PSAY _PMEDIOR picture "999.99"
		@ nLin,47 PSAY "Pub.Rel."
		@ nLin,57 PSAY _quanrea

		// @ 7,2 PSAY "Base OrÁamento="
		// @ 7,17 PSAY trim(descorca)
		// @ 7,59 PSAY diaorca pict "99"
		// @ 7,61 PSAY "/"
		// @ 7,62 PSAY mesorca
		@ nLin,65 PSAY "Vendas C/C"
		@ nLin,76 PSAY _vendascc picture "9,999,999.99"
		@ nLin,92 PSAY "|"
		//@ nLin,93 PSAY "Promoc„o ? : " + _promo

		nLin := nLin + 1

		@ nLin,1 PSAY "|"
		@ nLin,2 PSAY "NegociaÁ„o Art."
		@ nLin,17 PSAY _PARTCOD
		@ nLin,20 PSAY alltrim(_parttip)
		@ nLin,61 PSAY "Prev. % Vendas C/C"
		@ nLin,85 PSAY _PORCCC
		@ nLin,87 PSAY "%"

		// @ 8,47 PSAY "Base OrÁamento="
		// @ 8,64 PSAY diaorca pict "99"
		// @ 8,66 PSAY "/"
		// @ 8,67 PSAY mesorca PICT "99"

		// IF DIAORCA <> 31 .AND. MESORCA <> 12
		// @ 8,71 PSAY trim(descorca)
		// ELSE
		// @ 8,71 PSAY "OR«AMENTO PADR√O"
		// ENDIF

		nLin := nLin + 1
		@ nLin,1 PSAY "|___________________________________________________________________________________________________________________________________________________________________________________________________________________________|"
		nLin := nLin + 1
		@nLin,001 PSAY "|"
		@nLin,(nCol:=029) PSAY "|"
		@nLin,nCol+1 PSAY "OR«ADO"
		@nLin,(nCol+=16) PSAY "|"
		@nLin,nCol+2 PSAY "% LIQ."
		@nLin,(nCol+=08) PSAY "|"
		@nLin,nCol+2 PSAY "PREVISTO"
		@nLin,(nCol+=16) PSAY "|"
		@nLin,nCol+2 PSAY "% LIQ."
		@nLin,(nCol+=08) PSAY "|"
		@nLin,nCol+1 PSAY "REAL PRODU«√O"
		@nLin,(nCol+=16) PSAY "|"
		@nLin,nCol+2 PSAY "% LIQ."
		@nLin,(nCol+=08) PSAY "|"
		@nLin,nCol+1 PSAY "REAL CONTABIL"
		@nLin,(nCol+=16) PSAY "|"
		@nLin,nCol+2 PSAY "% LIQ."
		@nLin,(nCol+=08) PSAY "|"
		@nLin,nCol+1 PSAY "PREVISTO x OR«ADO"
		@nLin,(nCol+=32) PSAY "|"
		@nLin,nCol+1 PSAY "REAL PRODU«√O x PREVISTO" //VISTO"
		@nLin,(nCol+=32) PSAY "|"
		@nLin,nCol+1 PSAY "CONTABIL x PREVISTO" //ISTO"
		@nLin,(nCol+=32) PSAY "|"


		nLin := nLin + 1                                  
		_recprv := 0
		_recprv := ((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100))
		ImpDetDados(nLin, 2,"RECEITAS BRUTAS BILHETERIA", _recprv, _OBILEST, _vendasr, _BILHCTB)


		_issdir := _pisdir := 0

		_issdir := _OBILEST * 5 / 100
		_pisdir := _OBILEST * 9.25 / 100

		If SUBSTR(XX_ELEMPEP,5,1) $ "ABCD"
			_alug := 0
			_alug := ( _BILHCTB - (_BILHCTB * 19.25/100) ) * 22/100
			_IMOCTB := _alug
		Endif
		IF SZL->ZL_CISS == 0
			_CISS = (_VENDASR * SZL->ZL_TXISS)/100
		ELSE
			_CISS = SZL->ZL_CISS
		ENDIF
		IF SZL->ZL_CECAD == 0
			_CECAD = (_VENDASR * SZL->ZL_TXECAD)/100
		ELSE
			_CECAD = SZL->ZL_CECAD
		ENDIF
		IF SZL->ZL_CPIS == 0
			//((vendastotrel-(VENDASTOTREL*(txpartart/100)))*TXPISCOFINS)

			_CPIS = ((_VENDASR -(_VENDASR*(SZL->ZL_PORCART/100)))*(SZL->ZL_TXPIS/100))
		ELSE
			_CPIS = SZL->ZL_CPIS
		ENDIF
		// VER IMPOSTOS
		//@nLin,80 PSAY (_CISS+_CECAD+_CPIS) picture "99999,999.99"

		nLin := nLin + 1
		ImpDetBranco( nLin)
		nLin := nLin + 1

		IF SZL->ZL_ECAD == 0
			_ecad := (_bilest*(SZL->ZL_TXECAD/100))
		ELSE
			_ECAD := SZL->ZL_ECAD
		ENDIF

		IF SZL->ZL_ISS == 0
			_iss  := (_bilest*(SZL->ZL_TXISS/100))
		ELSE
			_ISS  := SZL->ZL_ISS
		ENDIF

		IF SZL->ZL_PIS == 0
			_pis  := (_BILEST*(1-(_PORCART/100))*(SZL->ZL_TXPIS/100))
		ELSE
			_PIS  := SZL->ZL_PIS
		ENDIF


		//	ImpDetDados(nLin, 3,"IMPOSTOS DIRETOS", _totimpo, _OECAD, (_CISS+_CPIS), (_CUS_ISS+_CUS_PIS))
		//_CECAD+                         

		ImpDetDados(nLin, 3,"IMPOSTOS DIRETOS", (_iss+_PIS), _issdir+_pisdir, (_CISS+_CPIS), (_CUS_ISS+_CUS_PIS))

		//	_issdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_ISS")
		//	_pisdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_ISS")

		nLin := nLin + 1
		ImpDetDados(nLin, 4,"ISS", _iss, _issdir, _CISS, _CUS_ISS)

		nLin := nLin + 1
		ImpDetDados(nLin, 4,"PIS/COFINS", _PIS, _pisdir, _CPIS, _CUS_PIS)

		nLin := nLin + 1
		ImpDetBranco( nLin)
		nLin := nLin + 1
		_TOTCAR =(_VENDASCC*SZL->ZL_txcc)/100

		//	ImpDetDados(nLin, 2,"RECEITAS LIQUIDAS", _BILLIQU, _OBILLIQ, _VENDASR-_CISS-_CECAD-_CPIS-_TOTCAR, _BILHCTB - (_CUS_ISS+_CUS_PIS))
		ImpDetDados(nLin, 2,"RECEITAS LIQUIDAS", ( ((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100)) - (_iss+_PIS) )  , _OBILLIQ, _VENDASR - (_CISS+_CPIS), _BILHCTB - (_CUS_ISS+_CUS_PIS))
		nLin := nLin + 1
		ImpDetBranco( nLin)
		nLin := nLin + 1

		TOTCCRE := (((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100))*(SZL->ZL_PORCCC/100)*(SZL->ZL_TXCC/100))

		MVALIMO := SZL->ZL_VALIMO
		MTOTBIL := SZL->ZL_TOTBIL
		MPORCART := SZL->ZL_PORCART
		MPARTCOD := SZL->ZL_PARTCOD

		MTXECAD := SZL->ZL_TXECAD
		MTXISS  := SZL->ZL_TXISS
		MTXPIS  := SZL->ZL_TXPIS
		MTXCC   := SZL->ZL_TXCC
		MPORCCC := SZL->ZL_PORCCC
		MSOM    := SZL->ZL_SOM
		MLUZ    := SZL->ZL_LUZ
		MNUMAPRE:= SZL->ZL_NUMAPRE
		MTXOCUPA:= SZL->ZL_TXOCUPA

		MBILESTI := (MTOTBIL*_NUMAPRE)*(MTXOCUPA/100)
		MTOTECAD := (MBILESTI*(MTXECAD/100))
		MTOTISS  := (MBILESTI*(MTXISS/100))
		MTOTPIS  := (MBILESTI*(1-(MPORCART/100))*(MTXPIS/100))
		MTOTCC   := ((MBILESTI*(MPORCCC/100))*(MTXCC/100))

		MTOTBI := (MBILESTI-MTOTECAD-MTOTISS-MTOTPIS-MTOTCC-SZL->ZL_ONEGOCI)
		//_TOTBI := (_BILESTI-_TOTECAD-_TOTISS-_TOTPIS-M->ZL_ONEGOCI)

		MTOTIMO := (MTOTBI*(SZL->ZL_TXALIMO/100))

		IF MVALIMO > 0
			MTOTIMO := MVALIMO
		ENDIF

		_TOTAIMO := MTOTIMO

		IF _CALUIMO == 0
			_CALUIMO := ((_VENDASR-_CISS-_CECAD-_CPIS-_TOTCAR)*(SZL->ZL_TXALIMO/100))
		ENDIF

		_liqprev := ((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100)) - (_iss+_PIS) 
		_liqprod := _VENDASR - (_CISS+_CPIS)
		_liqctb  := _BILHCTB - (_CUS_ISS+_CUS_PIS)                                                                             
		_liqorc  := _OBILLIQ

		_ccvprv := (_ecad + TOTCCRE + _TOTAIMO)
		ImpDetDados(nLin, 2,"CUSTOS VARIAVEIS", _ccvprv, (_oecad +_OALUGIM ), (_CECAD+((_VENDASCC*SZL->ZL_txcc)/100) +_CALUIMO) , (_ECADCTB + _CARTCRED + _IMOCTB),; 
		(_oecad +_OALUGIM ) / _liqorc * 100,  (_ecad + TOTCCRE + _TOTAIMO) / _liqprev * 100 ,;
		( _CECAD+((_VENDASCC*SZL->ZL_txcc)/100) +_CALUIMO ) / _liqprod * 100, (_ECADCTB + _CARTCRED + _IMOCTB) / _liqctb * 100 )

		nLin := nLin + 1                                                                                         
		_tt:=0
		_tt:= ((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100)) - (_iss+_PIS)

		ImpDetDados(nLin, 4,"ECAD", _ecad , _oecad , _CECAD , _ECADCTB,   _oecad / _OBILLIQ * 100, (( _ecad /  _tt ) * 100)  , (_CECAD / ( _VENDASR - (_CISS+_CPIS) ) * 100 ), ( _ECADCTB / ( _BILHCTB - (_CUS_ISS+_CUS_PIS) ) * 100 )  )


		nLin := nLin + 1
		/*
		ImpDetDados(nLin, 4,"TAXA CART√O CR…DITO", TOTCCRE, 0, (_VENDASCC*SZL->ZL_txcc)/100, _CARTCRED, 0, ((_VENDASCC*SZL->ZL_txcc)/100 ) / _liqprev * 100 ,;
		_CARTCRED / _liqprod * 100, 0 )
		*/                                                                                                             
		_pper := 0       

		_pper := ((_VENDASCC*SZL->ZL_txcc)/100 ) / _liqprev * 100            

		ImpDetDados(nLin, 4,"TAXA CART√O CR…DITO", TOTCCRE, 0, (_VENDASCC*SZL->ZL_txcc)/100, _CARTCRED, 0,  TOTCCRE / _liqprev * 100, _CARTCRED / _liqprod * 100, 0 ) //TOTCCRE / _liqprev * 100

		//		((_VENDASCC*SZL->ZL_txcc)/100) / _liqprev * 100, 0 )                                         
		//

		nLin := nLin + 1
		ImpDetDados(nLin, 4,"ALUG.IM”VEIS", _TOTAIMO, _OALUGIM, _CALUIMO, _IMOCTB, _OALUGIM / _liqorc * 100, _TOTAIMO / _liqprev * 100, _CALUIMO / _liqprod * 100, _IMOCTB / _liqctb * 100 )

		nLin := nLin + 1
		ImpDetBranco( nLin)
		nLin := nLin + 1
		//   	ImpDetDados(nLin, 2,"CACHE ARTISTICO",_ppartart,_opartart,_partart,_CACHCTB,0,0,0, _opartart / _liqprev * 100, _ppartart / _liqprod * 100, _CACHCTB / _liqctb * 100)
		ImpDetDados(nLin, 2,"CACHE ARTISTICO",_ppartart,_opartart,_partart,_CACHCTB, _opartart / _liqprev * 100,_opartart / _liqprev * 100,_ppartart / _liqprod * 100,  _CACHCTB / _liqctb * 100)

		outcus := reacus := 0
		// Quando executado na empresa Teste, ignora o SZS - Incluido por Renato temporariamente 
		// ALTERAR CONSIDERANDO O ELEMENTO PEP NO FILTRO
		aAreaAnt := GetArea()
		If cEmpAnt <> "99"
			dbSelectarea("SZS")
			dbGotop()
			While !eof()
				IF SZS->ZS_CHAVE1 <> _CHAVE1
					dbSkip()
					Loop
				ENDIF

				outcus := outcus + SZS->ZS_PREVIST
				reacus := reacus + SZS->ZS_REALIZA

				dbSkip()
			Enddo
			RestArea(aAreaAnt)
		Endif

		_CTOTG = _CSOM+_CLUZ+_CHOSP+_CCAMARI+_CTAEREO+_CTTERRE+_CALIMENTA+_CTEQUIP+_CODESP+ reacus + _CECAD

		nLin := nLin + 1
		ImpDetBranco( nLin)
		nLin := nLin + 1

		ImpDetDados(nLin, 2,"CUSTO DE PRODU«√O", _totcpro, _ODESP, _CTOTG, _SOMCTB+_LUZCTB+_HOSPCTB+_AREOCTB+_VALCTB+_ALIMCTB+_EQUIPCTB+_CAMACTB+_OCUSPRO ,;
		_ODESP / _liqorc * 100, _totcpro / _liqprev * 100, _CTOTG / _liqprod * 100,;
		( (_SOMCTB+_LUZCTB+_HOSPCTB+_AREOCTB+_VALCTB+_ALIMCTB+_EQUIPCTB+_CAMACTB+_OCUSPRO ) / _liqctb ) * 100 )

		nLin := nLin + 1

		_somdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_SOM")
		//((_som*_NUMAPRE)/_BILEST)*100
		ImpDetDados(nLin, 4,"SOM", (_SOM*_NUMAPRE), _somdir, _Csom, _SOMCTB, (((_som*_NUMAPRE)/_BILEST)*100)  / _liqorc * 100 , (_SOM*_NUMAPRE) /_liqprev * 100, _Csom /_liqprod * 100, _SOMCTB / _liqctb * 100 )
		//	ImpDetDados(nLin, 4,"SOM", (_SOM*_NUMAPRE), _somdir, (((_som*_NUMAPRE)/_BILEST)*100)  / _liqorc * 100 , (_SOM*_NUMAPRE) /_liqprev * 100, _Csom /_liqprod * 100, _SOMCTB / _liqctb * 100 )

		nLin := nLin + 1                                   

		_luzdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_LUZ")
		//	ImpDetDados(nLin, 4,"LUZ",  (_LUZ*_NUMAPRE), (_luz*_NUMAPRE/_BILEST)*100, _Cluz, _LUZCTB, (_luz*_NUMAPRE/_BILEST*100) / _liqprev * 100,;
		//						(_LUZ*_NUMAPRE) / _liqorc * 100, _Cluz / _liqprod * 100, _LUZCTB / _liqctb * 100 )
		ImpDetDados(nLin, 4,"LUZ",  (_LUZ*_NUMAPRE), _luzdir, _Cluz, _LUZCTB, (_luz*_NUMAPRE/_BILEST*100) / _liqprev * 100,;
		(_LUZ*_NUMAPRE) / _liqorc * 100, _Cluz / _liqprod * 100, _LUZCTB / _liqctb * 100 )


		nLin := nLin + 1
		_hosdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_HOSPEDA")
		//(_hosp/_BILEST)*100
		ImpDetDados(nLin, 4,"HOSPEDAGEM", _hosp, _hosdir , _Chosp , _HOSPCTB, (_hosp/_BILEST)*100 / _liqprev * 100, _hosp / _liqorc * 100,;
		_Chosp / _liqprod * 100, _HOSPCTB / _liqctb * 100)

		nLin := nLin + 1                                
		_camdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_CAMARIM")
		//(_camarim*_NUMAPRE/_BILEST)*100
		ImpDetDados(nLin, 4,"CAMARIM", (_CAMARIM*_NUMAPRE), _camdir , _ccamari , _CAMACTB, (_camarim*_NUMAPRE/_BILEST)*100/_liqprev*100,;
		(_CAMARIM*_NUMAPRE)/_liqorc * 100, _ccamari / _liqprod * 100, _CAMACTB /_liqctb * 100 )

		nLin := nLin + 1                                           
		_tradir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_TRANSAE")
		//(_totaere/_BILEST)*100
		ImpDetDados(nLin, 4,"TRANSP.AEREO ART.", _totaere, _tradir, _ctaereo , _AREOCTB, (_totaere/_BILEST*100) / _liqprev * 100,;
		_totaere / _liqorc * 100, _ctaereo / _liqprod * 100, _AREOCTB /_liqctb * 100)

		nLin := nLin + 1
		_tterdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_TRANSPT")
		//(_totterr/_BILEST)*100
		ImpDetDados(nLin, 4,"TRANSP.TERRESTRE", _totterr, _tterdir, _ctterre , _VALCTB, (_totterr/_BILEST*100) / _liqprev * 100,;
		_totterr / _liqorc * 100, _ctterre / _liqprod * 100, _VALCTB / _liqorc * 100)

		nLin := nLin + 1                                          
		_ajuddir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_ALIMENT")
		//(_alimenta/_BILEST)*100
		ImpDetDados(nLin, 4,"ALIMENTA«√O/AJUDA", _alimenta, _ajuddir, _calimenta , _ALIMCTB, (_alimenta/_BILEST)*100 / _liqorc * 100,;
		_alimenta / _liqprev * 100, _calimenta / _liqprod * 100, _ALIMCTB / _liqctb * 100)

		nLin := nLin + 1
		_equipdir := POSICIONE("SZN",1,xFilial("SZN")+SZL->ZL_OIMOVEL,"ZN_TRANEQU")
		//(_trequip/_BILEST)*100
		ImpDetDados(nLin, 4,"TRANSP.EQUIPAMENTO", _trequip, _equipdir, _ctequip , _EQUIPCTB, (_trequip/_BILEST)*100/_liqorc,;
		_trequip / _liqprev * 100, _ctequip / _liqprod * 100, _EQUIPCTB / _liqctb * 100)

		_SINDICA   := SZL->ZL_SINDICA
		_VRCONTR   := SZL->ZL_VRCONTR
		_TOTSINDICA := (SZL->ZL_SINDICA*(SZL->ZL_VRCONTR/100))

		_VISTOENT  := SZL->ZL_VISTOEN
		_NUMPENT   := SZL->ZL_NUMPENT
		_TOTVISTO  := (SZL->ZL_VISTOEN*SZL->ZL_NUMPENT)

		_EQUIPPR   := SZL->ZL_EQUIPPR
		_NUMPPRO   := SZL->ZL_NUMPPRO
		_TOTPROD   := (SZL->ZL_EQUIPPR*SZL->ZL_NUMPPRO)

		_TOTODESP  := _TOTSINDICA + _TOTVISTO + _TOTPROD + OUTCUS

		nLin := nLin + 1
		ImpDetDados(nLin, 4,"OUTROS CUSTOS DE PRODU«√O", _totODESP , _ODESP , _codesp + reacus , _OCUSPRO, _ODESP / _liqorc * 100, _totODESP / _liqprev * 100,;
		( _codesp + reacus) /_liqprod * 100, _OCUSPRO / _liqctb * 100 )

		nLin := nLin + 1	
		ImpDetBranco( nLin)
		nLin := nLin + 1 
		ImpDetDados(nLin, 2,"MIDIA E PUBLICIDADE",  (_TOTMIDI), _omidia,  (_CMIDIA*(_PORCMID/100)), _MIDCTB, _omidia / _liqorc * 100, _TOTMIDI / _liqprev * 100,;
		(_CMIDIA*(_PORCMID/100)) / _liqprod * 100, _MIDCTB / _liqctb * 100)

		nLin := nLin + 1

		//	_CTOTG = _CSOM+_CLUZ+_CHOSP+_CCAMARI+_CTAEREO+_CTTERRE+_CALIMENTA+_CTEQUIP+_CBACLIN+_CODESP+_CPCARTI + reacus + _CECAD

		/*/ removido por Renato em 9/5/08
		nLin := nLin + 1
		@nLin,1 PSAY "|"
		@nLin,5 PSAY "BACKLINE"
		@nLin,29 PSAY "|"
		@nLin,30 PSAY _backlin Picture "9,999,999.99"
		@nLin,42 PSAY "|"
		@nLin,43 PSAY (_backlin/_BILEST)*100 picture "999.99"
		@nLin,49 PSAY "%"
		@nLin,50 PSAY "|"
		@nLIn,51 PSAY _BACKLIN/_TOTCPRO*100 PICTURE "999.99"
		@nLin,58 PSAY "|"
		@nLin,59 PSAY " "
		@nLin,71 PSAY "|"
		@nLin,79 PSAY "|"
		@nLin,80 PSAY _cBACLIN Picture "9,999,999.99"
		@nLin,92 PSAY "|"
		/*/

		//@nLin,95 PSAY "Backline "
		//@nLin,110 PSAY _backCTB PICTURE "@RE 999,999,999.99"

		//nLin := nLin + 1
		//ImpDetDados(nLin, 4,"DESP.POR CONTA ARTISTA", 0 , 0 , _CPCARTI , 0)

		//======= RESULTADO SHOW
		ImpDetBranco( nLin)
		nLin := nLin + 1


		_rshorc := 0
		_rshpre := 0
		_rshrea := 0
		_rshctb := 0
		//
		_rshorc := _recprv - (_iss+_pis)-_ppartart-_totcpro-_totmidi-_ccvprv
		///( (( ((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100)) - (_iss+_PIS) )) - (_ecad + TOTCCRE + _TOTAIMO) - _partart - _totcpro - (_TOTMIDI) )
		//
		_rshpre := _obilest-(_issdir+_pisdir)-_odesp-_opartart-_omidia-(_oecad+_oalugim)
		///( _OBILLIQ - (_oecad +_OALUGIM ) - _ODESP - _omidia )

		_rshrea := ( (_VENDASR - (_CISS+_CPIS) ) - _CPARTAR - _CTOTG - (_CMIDIA*(_PORCMID/100)) - (_CECAD+((_VENDASCC*SZL->ZL_txcc)/100) +_CALUIMO) ) 
		_rshctb := ( _BILHCTB - (_CUS_ISS+_CUS_PIS) - (_ECADCTB + _CARTCRED + _IMOCTB) - _CACHCTB - (_SOMCTB+_LUZCTB+_HOSPCTB+_AREOCTB+_VALCTB+_ALIMCTB+_EQUIPCTB+_CAMACTB+_OCUSPRO  ) - _MIDCTB )

		ImpDetDados(nLin, 2,"RESULTADO DO SHOW", _rshorc , _rshpre , _rshrea , _rshctb )
		nLin := nLin + 1

		ImpDetBranco( nLin)
		nLin := nLin + 1

		@nLin,02 PSAY "MARGEM S/ RECEITA LIQUIDA"
		@nLin,29 PSAY "|"

		@nLin,33 PSAY (_rshpre / _OBILLIQ * 100 )  Picture "@( 99999.99 %"

		@nLin,45 PSAY "|"

		@nLin,53 PSAY "|"

		@nLin,57 PSAY (_rshorc / (((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100)) - (_iss+_PIS) ) ) * 100  Picture "@( 99999.99 %"
		@nLin,69 PSAY "|"

		@nLin,77 PSAY "|"

		@nLin,80 PSAY (_rshrea / (_VENDASR - (_CISS+_CPIS)) * 100)  Picture "@( 99999.99 %"
		@nLin,93 PSAY "|"

		@nLin,101 PSAY "|"

		@nLin,104 PSAY (_rshctb / (_BILHCTB - (_CUS_ISS+_CUS_PIS)) * 100)   Picture "@( 99999.99 %"

		@nLin,117 PSAY "|"
		@nLin,125 PSAY "|"

		_pp1 := ( _rshpre / _OBILLIQ ) * 100 
		_pp2 := ( _rshorc / (SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100) - (_iss+_PIS) ) * 100

		@nLin,127 PSAY _pp1 - _pp2 PICTURE "@( 9999.99 %"
		@nLin,135 PSAY "p.p."
		@nLin,141 PSAY "|"

		@nLin,157 PSAY "|"
		@nLin,160 PSAY  (_rshrea / (_VENDASR - (_CISS+_CPIS)) * 100) - (_rshpre / _OBILLIQ * 100 ) PICTURE "@E 9999.99"
		@nLin,168 PSAY "p.p."
		@nLin,173 PSAY "|"
		@nLin,189 PSAY "|"

		@nLin,192 PSAY ( ( _rshctb / (_BILHCTB - (_CUS_ISS+_CUS_PIS)) )* 100) - (_rshpre / _OBILLIQ * 100 ) PICTURE "@E 9999.99"
		@nLin,198 PSAY "p.p."
		@nLin,201 PSAY "|"
		@nLin,216 PSAY "|"

		nLin := nLin + 1                                                                                                                                                                                                                                                                            

		@ nLin,1 PSAY "****************************************************************************************************************************************************************************************************************************"
		nLin := nLin + 1
		//          if xcodart = 1
		//            partiarti=((XVENDASTOTREL-XCNEGOCIACAO)*(xpartart/100))
		//          @ 43,60 PSAY "Calculo Part.Art.="
		//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
		//          endif

		//          if xcodart = 2
		//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100))*(xpartart/100)
		//          @ 43,60 PSAY "Calculo Part.Art.="
		//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
		//          endif

		//          if xcodart = 3
		//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASCCREL*3/100)*(xpartart/100))
		//          @ 43,60 PSAY "Calculo Part.Art.="
		//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
		//          endif

		//          if xcodart = 4
		//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100)-(XVENDASCCREL*3/100))*(xpartart/100)
		//          @ 43,60 PSAY "Calculo Part.Art.="
		//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
		//          endif

		//          if xcodart = 5
		//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100)-XCsom-XCluz)
		//          partiarti=(partiarti*(xpartart/100))
		//          @ 43,60 PSAY "Calculo Part.Art.="
		//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
		//          endif

		//          if xcodart = 6
		//          partiarti=(XVENDASTOTREL-XCNEGOCIACAO-(XVENDASTOTREL*10/100)-(XVENDASCCREL*3/100)-XCsom-XCluz)
		//          partiarti=(partiarti*(xpartart/100))
		//          @ 43,60 PSAY "Calculo Part.Art.="
		//          @ 43,80 PSAY partiarti-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
		//          endif

		//XCACHE=PARTART
		//         if xcodart = 7
		//        @ 43,60 PSAY "Calculo Cache="
		//       @ 43,80 PSAY XCACHE-XCPCARTISTA pict "9,999,999.99" font 'arial',8 style "B"
		//      endif



		@ nlin,1 Psay "|"
		@ nlin,21 Psay "|"
		@ nlin,26 Psay "|"
		@ nlin,32 Psay "CORTESIA"
		@ nlin,46 PSAY "|"
		@ nlin,53 Psay "|"
		@ nlin,61 Psay "|"
		@ nlin,73 Psay "|"

		//@nlin,93 PSAY "Formas de Pagamento"
		nlin := nlin+1

		@ nlin,1 Psay "|"
		@ nlin,2 PSAY "ConfiguraÁ„o"
		@ nlin,21 Psay "|"
		@ nlin,22 Psay "Lot."
		@ nlin,26 Psay "|"
		@ nlin,27 Psay "Patr."
		@ nlin,32 Psay "Art."
		@ nlin,37 Psay "Casa"
		@ nlin,42 Psay "Rad."
		@ nlin,46 Psay "|"
		@ nlin,47 Psay "Disp."
		@ nlin,53 Psay "|"
		@ nlin,54 Psay "PreÁo"
		@ nlin,61 Psay "|"
		@ nlin,62 Psay "Total Bil."
		@ nlin,73 Psay "|"
		/*/
		@ nlin,93 psay "CASH  : "
		@ nlin,102 psay SZL->ZL_qcash picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vcash picture "9,999,999.99"
		/*/
		nlin := nlin+1

		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor1
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant1 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat1 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art1 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa1 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio1 picture "9999"
		_xq1=SZL->ZL_quant1-SZL->ZL_pat1-SZL->ZL_art1-SZL->ZL_casa1-SZL->ZL_radio1
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq1 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR1 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ1*SZL->ZL_VALOR1)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT1=(_xQ1*SZL->ZL_VALOR1)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "MC    : "
		@ nlin,102 psay SZL->ZL_qmc picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vmc picture "9,999,999.99"
		/*/

		nlin := nlin+1

		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor2
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant2 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat2 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art2 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa2 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio2 picture "9999"
		_xq2=SZL->ZL_quant2-SZL->ZL_pat2-SZL->ZL_art2-SZL->ZL_casa2-SZL->ZL_radio2
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq2 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR2 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ2*SZL->ZL_VALOR2)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT2=(_xQ2*SZL->ZL_VALOR2)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "VISA  : "
		@ nlin,102 psay SZL->ZL_qvisa picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vvisa picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor3
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant3 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat3 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art3 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa3 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio3 picture "9999"
		_xq3=SZL->ZL_quant3-SZL->ZL_pat3-SZL->ZL_art3-SZL->ZL_casa3-SZL->ZL_radio3
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq3 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR3 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ3*SZL->ZL_VALOR3)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT3=(_xQ3*SZL->ZL_VALOR3)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "DC    : "
		@ nlin,102 psay SZL->ZL_qDC picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vDC picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor4
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant4 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat4 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art4 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa4 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio4 picture "9999"
		_xq4=SZL->ZL_quant4-SZL->ZL_pat4-SZL->ZL_art4-SZL->ZL_casa4-SZL->ZL_radio4
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq4 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR4 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ4*SZL->ZL_VALOR4)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT4=(_xQ4*SZL->ZL_VALOR4)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "AMX   : "
		@ nlin,102 psay SZL->ZL_qAMX picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vAMX picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor5
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant5 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat5 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art5 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa5 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio5 picture "9999"
		_xq5=SZL->ZL_quant5-SZL->ZL_pat5-SZL->ZL_art5-SZL->ZL_casa5-SZL->ZL_radio5
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq5 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR5 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ5*SZL->ZL_VALOR5)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT5=(_xQ5*SZL->ZL_VALOR5)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "CORTES: "
		@ nlin,102 psay SZL->ZL_qCORTES picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vCORTES picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor6
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant6 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat6 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art6 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa6 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio6 picture "9999"
		_xq6=SZL->ZL_quant6-SZL->ZL_pat6-SZL->ZL_art6-SZL->ZL_casa6-SZL->ZL_radio6
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq6 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR6 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ6*SZL->ZL_VALOR6)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT6=(_xQ6*SZL->ZL_VALOR6)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "MCDB  : "
		@ nlin,102 psay SZL->ZL_qmcDB picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vmcDB picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor7
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant7 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat7 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art7 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa7 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio7 picture "9999"
		_xq7=SZL->ZL_quant7-SZL->ZL_pat7-SZL->ZL_art7-SZL->ZL_casa7-SZL->ZL_radio7
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq7 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR7 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ7*SZL->ZL_VALOR7)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT7=(_xQ7*SZL->ZL_VALOR7)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "MC    : "
		@ nlin,102 psay SZL->ZL_qmc picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vmc picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor8
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant8 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat8 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art8 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa8 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio8 picture "9999"
		_xq8=SZL->ZL_quant8-SZL->ZL_pat8-SZL->ZL_art8-SZL->ZL_casa8-SZL->ZL_radio8
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq8 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR8 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ8*SZL->ZL_VALOR8)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT8=(_xQ8*SZL->ZL_VALOR8)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "VDB   : "
		@ nlin,102 psay SZL->ZL_qVDB picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vVDB picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor9
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant9 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat9 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art9 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa9 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio9 picture "9999"
		_xq9=SZL->ZL_quant9-SZL->ZL_pat9-SZL->ZL_art9-SZL->ZL_casa9-SZL->ZL_radio9
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq9 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR9 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ9*SZL->ZL_VALOR9)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT9=(_xQ9*SZL->ZL_VALOR9)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "TXMCDB: "
		@ nlin,102 psay SZL->ZL_qTXMCDB picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vTXMCDB picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor10
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant10 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat10 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art10 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa10 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio10 picture "9999"
		_xq10=SZL->ZL_quant10-SZL->ZL_pat10-SZL->ZL_art10-SZL->ZL_casa10-SZL->ZL_radio10
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq10 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR10 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ10*SZL->ZL_VALOR10)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT10=(_xQ10*SZL->ZL_VALOR10)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "TXMC  : "
		@ nlin,102 psay SZL->ZL_qTXmc picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vTXmc picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor11
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant11 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat11 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art11 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa11 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio11 picture "9999"
		_xq11=SZL->ZL_quant11-SZL->ZL_pat11-SZL->ZL_art11-SZL->ZL_casa11-SZL->ZL_radio11
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq11 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR11 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ11*SZL->ZL_VALOR11)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT11=(_xQ11*SZL->ZL_VALOR11)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "TXVISA: "
		@ nlin,102 psay SZL->ZL_qTXVISA picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vTXVISA picture "9,999,999.99"
		/*/

		nlin := nlin+1
		@ nlin,1 Psay "|"
		@ nlin,2 Psay SZL->ZL_setor12
		@ nlin,21 Psay "|"
		@ nlin,22 Psay SZL->ZL_quant12 picture "9999"
		@ nlin,26 Psay "|"
		@ nlin,27 Psay SZL->ZL_pat12 picture "9999"
		@ nlin,31 Psay "|"
		@ nlin,32 Psay SZL->ZL_art12 picture "9999"
		@ nlin,36 Psay "|"
		@ nlin,37 Psay SZL->ZL_casa12 picture "9999"
		@ nlin,41 Psay "|"
		@ nlin,42 Psay SZL->ZL_radio12 picture "9999"
		_xq12=SZL->ZL_quant12-SZL->ZL_pat12-SZL->ZL_art12-SZL->ZL_casa12-SZL->ZL_radio12
		@ nlin,46 Psay "|"
		@ nlin,47 Psay _xq12 picture "99999"
		@ nlin,53 Psay "|"
		@ nlin,54 Psay SZL->ZL_VALOR12 PICTure "9999.99"
		@ nlin,61 Psay "|"
		@ nlin,62 PSAY (_xQ12*SZL->ZL_VALOR12)*(1-((_TXESTUD/100)*.5))  PICTure "999,999.99"
		_XTOT12=(_xQ12*SZL->ZL_VALOR12)*(1-((_TXESTUD/100)*.5))
		@ nlin,73 Psay "|"

		/*/
		@ nlin,93 psay "TXDC  : "
		@ nlin,102 psay SZL->ZL_qTXDC picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vTXDC picture "9,999,999.99"
		/*/

		nlin := nlin +1
		@ nlin,1 psay "|"
		@ nlin,2 pSAY "TOTAIS"
		@ nlin,21 psay "|"
		@ nlin,22 pSAY (SZL->ZL_QUANT1+SZL->ZL_QUANT2+SZL->ZL_QUANT3+SZL->ZL_QUANT4+SZL->ZL_QUANT5+SZL->ZL_QUANT6+SZL->ZL_QUANT7+SZL->ZL_QUANT8+SZL->ZL_QUANT9+SZL->ZL_QUANT10+SZL->ZL_QUANT11+SZL->ZL_QUANT12) PICTURE "9999"
		@ nlin,26 psay "|"
		@ nlin,27 pSAY (SZL->ZL_PAT1+ SZL->ZL_PAT2+ SZL->ZL_PAT3+ SZL->ZL_PAT4+ SZL->ZL_PAT5+ SZL->ZL_PAT6+ SZL->ZL_PAT7+ SZL->ZL_PAT8+ SZL->ZL_PAT9+ SZL->ZL_PAT10+ SZL->ZL_PAT11+ SZL->ZL_PAT12) PICTURE "9999"
		@ nlin,31 psay "|"
		@ nlin,32 pSAY (SZL->ZL_ART1 + SZL->ZL_ART2 + SZL->ZL_ART3 + SZL->ZL_ART4 + SZL->ZL_ART5 + SZL->ZL_ART6 + SZL->ZL_ART7 + SZL->ZL_ART8 + SZL->ZL_ART9 + SZL->ZL_ART10+ SZL->ZL_ART11+ SZL->ZL_ART12) PICTURE "9999"
		@ nlin,36 psay "|"
		@ nlin,37 pSAY (SZL->ZL_CASA1 + SZL->ZL_CASA2 + SZL->ZL_CASA3 + SZL->ZL_CASA4 + SZL->ZL_CASA5 + SZL->ZL_CASA6 + SZL->ZL_CASA7 + SZL->ZL_CASA8 + SZL->ZL_CASA9 + SZL->ZL_CASA10+ SZL->ZL_CASA11+ SZL->ZL_CASA12) PICTURE "9999"
		@ nlin,41 psay "|"
		@ nlin,42 pSAY (SZL->ZL_RADIO1 + SZL->ZL_RADIO2 + SZL->ZL_RADIO3 + SZL->ZL_RADIO4 + SZL->ZL_RADIO5 + SZL->ZL_RADIO6 + SZL->ZL_RADIO7 + SZL->ZL_RADIO8 + SZL->ZL_RADIO9 + SZL->ZL_RADIO10+ SZL->ZL_RADIO11 + SZL->ZL_RADIO12) PICTure "9999"
		@ nlin,46 psay "|"
		@ nlin,47 pSAY (_XQ1+_XQ2+_XQ3+_XQ4+_XQ5+_XQ6+_XQ7+_XQ8+_XQ9+_XQ10+_XQ11+_XQ12) PICTURE "99999"
		@ nlin,53 psay "|"
		@ nlin,61 psay "|"
		@ nlin,62 pSAY (_XTOT1+_XTOT2+_XTOT3+_XTOT4+_XTOT5+_XTOT6+_XTOT7+_XTOT8+_XTOT9+_XTOT10+_XTOT11+_XTOT12) PICTURE "9999,999.99"
		@ nlin,73 psay "|"
		nlin := nlin+1
		@ nlin,1 psay "xx**********************************************************************"

		/*/
		@ nlin,93 psay "CC    : "
		@ nlin,102 psay SZL->ZL_qCC picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vCC picture "9,999,999.99"

		nlin := nlin +1

		@ nlin,93 psay "CHEQUE: "
		@ nlin,102 psay SZL->ZL_qCHEQUE picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vCHEQUE picture "9,999,999.99"
		nlin := nlin +1

		@ nlin,93 psay "PPRT  : "
		@ nlin,102 psay SZL->ZL_qPPRT picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vPPRT picture "9,999,999.99"
		nlin := nlin +1

		@ nlin,93 psay "HIPERC: "
		@ nlin,102 psay SZL->ZL_qhiperc picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vhiperc picture "9,999,999.99"
		nlin := nlin +1

		@ nlin,93 psay "TXVDB : "
		@ nlin,102 psay SZL->ZL_qTXVDB picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vTXVDB picture "9,999,999.99"
		nlin := nlin +1

		@ nlin,93 psay "TXCC  : "
		@ nlin,102 psay SZL->ZL_qTXCC  picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vTXCC  picture "9,999,999.99"
		nlin := nlin +1

		@ nlin,93 psay "TXAMX : "
		@ nlin,102 psay SZL->ZL_qTXAMX picture "9,999,999.99"
		@ nlin,115 psay SZL->ZL_vTXAMX picture "9,999,999.99"
		nlin := nlin +1

		@ nlin,93 psay "TOTAIS: "
		totq := SZL->ZL_qcash+SZL->ZL_qpprt+SZL->ZL_qcortes+SZL->ZL_qcheque+SZL->ZL_qmc+SZL->ZL_qvdb+SZL->ZL_qvisa+SZL->ZL_qcc+SZL->ZL_qamx+SZL->ZL_qmcdb+SZL->ZL_qdc+SZL->ZL_qhiperc+SZL->ZL_qtxmc+SZL->ZL_qtxvdb+SZL->ZL_qtxvisa+SZL->ZL_qtxcc+SZL->ZL_qtxamx+SZL->ZL_qtxmcdb+SZL->ZL_qtxcc
		@ nlin,102 psay totq picture "9,999,999.99"
		totv := SZL->ZL_vcash+SZL->ZL_vpprt+SZL->ZL_vcortes+SZL->ZL_vcheque+SZL->ZL_vmc+SZL->ZL_vvdb+SZL->ZL_vvisa+SZL->ZL_vcc+SZL->ZL_vamx+SZL->ZL_vmcdb+SZL->ZL_vdc+SZL->ZL_vhiperc+SZL->ZL_vtxmc+SZL->ZL_vtxvdb+SZL->ZL_vtxvisa+SZL->ZL_vtxcc+SZL->ZL_vtxamx+SZL->ZL_vtxmcdb+SZL->ZL_vtxcc
		@ nlin,115 psay totv picture "9,999,999.99"

		nlin:= nlin +1

		@ nlin,93 psay "Total tx.Entrega   : "
		@ nlin,115 psay SZL->ZL_entrega picture "9,999,999.99"

		nlin:= nlin+1

		@ nlin,93 psay "Total tx.Convenien.: "
		@ nlin,115 psay SZL->ZL_conveni picture "9,999,999.99"
		/*/


		nlin := nlin +1

		@ nlin,1 psay "Mensagem : "
		@ nlin,12 psay SZL->ZL_mensage
		nlin := nlin +1
		@ nlin,1 psay "Mensagem : "
		@ nlin,12 psay SZL->ZL_mensa1
		nlin := nlin +1
		@ nlin,1 psay "Mensagem : "
		@ nlin,12 psay SZL->ZL_mensa2



		dbSkip() // Avanca o ponteiro do registro no arquivo
	EndDo

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Finaliza a execucao do relatorio...                                 ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	SET DEVICE TO SCREEN

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Se impressao em disco, chama o gerenciador de impressao...          ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ

	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

Return


/*/  FunÁ„o para imprimir o detalhe com os dados
exemplo da chamada da funÁ„o
ImpDetDados( 2,"RECEITAS BRUTAS", ((SZL->ZL_TOTBIL*SZL->ZL_NUMAPRE)*(SZL->ZL_TXOCUPA/100)), _OBILEST, _vendasr)
/*/
Static Function ImpDetDados(XnLin, XnColuna, XcDescri, XnColB, XnColA,XnColC,XnColD, XnColE, XnColF, XnColG, XnColH)

	@XnLin,1 PSAY "|"
	@XnLin,XnColuna PSAY XcDescri
	@XnLin,(nCol:=29) PSAY "|"
	@XnLin,nCol+2 PSAY XnColA  Picture "@e 99,999,999.99"
	@XnLin,(nCol+=16) PSAY "|"                                                                 
	@XnLin,nCol+1 PSAY XnColE Picture "@e 999.99"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,nCol+2 PSAY XnColB  Picture "@e 99,999,999.99"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+1 PSAY XnColF Picture "@e 999.99"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,nCol+2 PSAY XnColC  Picture "@e 99,999,999.99"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+1 PSAY XnColG Picture "@e 999.99"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,nCol+2 PSAY XnColD  Picture "@e 99,999,999.99"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+1 PSAY XnColH Picture "@e 999.99"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,nCol+1 PSAY (XnColB-XnColA)  Picture "@e( 999,999,999.99"	//(b-a)/a
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+2 PSAY (XnColB-XnColA)/XnColA*100  Picture "@( 99999.99 %"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+1 PSAY (XnColC-XnColB)  Picture "@e( 999,999,999.99"	//(c-b)/b
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+2 PSAY (XnColC-XnColB)/XnColB*100  Picture "@( 99999.99 %"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+1 PSAY (XnColD-XnColB)  Picture "@e( 999,999,999.99"	//(d-b)/b
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,nCol+2 PSAY (XnColD-XnColB)/XnColB*100  Picture "@( 99999.99 %"
	@XnLin,(nCol+=16) PSAY "|"

Return Nil

// FunÁ„o para imprimir o detalhe em branco
Static Function ImpDetBranco( XnLin)

	@XnLin,001 PSAY "|"
	@XnLin,(nCol:=29) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=08) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"
	@XnLin,(nCol+=16) PSAY "|"

Return Nil


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥VALIDPERG ∫ Autor ≥ AP5 IDE            ∫ Data ≥  23/09/03   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Verifica a existencia das perguntas criando-as caso seja   ∫±±
±±∫          ≥ necessario (caso nao existam).                             ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function ValidPerg

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 15/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,len(X1_GRUPO))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	//aAdd(aRegs,{cPerg,"","","mv_ch1","",00,00,0,"","","mv_par","","","","","","","","","","","","","",""})

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"01",; 				//Ordem
	"Elemento PEP",;				//Pergunta em Portugues
	"Elemento PEP",;				//Pergunta em Espanhol
	"Elemento PEP",;				//Pergunta em Ingles
	"mv_ch1",;			//Variavel
	"C",;	   			//Tipo
	15,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				// 
	"",;				//Validacao
	"mv_par01","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"02",; 				//Ordem
	"Data de",;				//Pergunta em Portugues
	"Data de",;				//Pergunta em Espanhol
	"Data de",;				//Pergunta em Ingles
	"mv_ch2",;			//Variavel
	"D",;	   			//Tipo
	08,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				// 
	"",;				//Validacao
	"mv_par02","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"03",; 				//Ordem
	"Data Ate",;				//Pergunta em Portugues
	"Data Ate",;				//Pergunta em Espanhol
	"Data Ate",;				//Pergunta em Ingles
	"mv_ch3",;			//Variavel
	"D",;	   			//Tipo
	08,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				// 
	"",;				//Validacao
	"mv_par03","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","",""}) 			//Variavel 05,Default 05,Conteudo05

	aAdd(aRegs,;
	{cPerg,; 			//Grupo
	"04",; 				//Ordem
	"An·lise",;				//Pergunta em Portugues
	"An·lise",;				//Pergunta em Espanhol
	"An·lise",;				//Pergunta em Ingles
	"mv_ch4",;			//Variavel
	"C",;	   			//Tipo
	06,0,0,;				//Tamanho, Decimal, Pre-Selecionada
	"G",;				// 
	"",;				//Validacao
	"mv_par04","","",; 	//Variavel 01,Default 01,Conteudo01
	"","","",; 			//Variavel 02,Default 02,Conteudo02
	"","","",; 			//Variavel 03,Default 03,Conteudo03
	"","","",; 			//Variavel 04,Default 04,Conteudo04
	"","","",;
	"","","","","","","","","","","SZL","",""}) 			//Variavel 05,Default 05,Conteudo05

	For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
	RecLock("SX1",.T.)
	For j:=1 to FCount()
	If j <= Len(aRegs[i])
	FieldPut(j,aRegs[i,j])
	Endif
	Next
	MsUnlock()
	Endif
	Next

	dbSelectArea(_sAlias)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

Return              



// FunÁ„o para mandar o par‚metro no Elemento PEP
usER Function PESELEMP

	dbSelectArea("SZL")
	dbSetOrder(2)
	dbSeek(xFilial("SZL")+ALLTRIM(MV_PAR04))

	MV_PAR01 := SZL->ZL_ELEMPEP

Return(MV_PAR01)
