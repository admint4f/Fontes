#include "protheus.ch"
#define cr chr(13)+chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRBHORAS   บAutor  ณ Rafael Rodrigues   บ Data ณ  03/10/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Banco de Horas global                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RBHoras()
	local cPerg		:= "RBHORAS"
	local cQuery	:= ""
	local aMeses	:= {}
	local aNomes	:= {"JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"}
	local aEmps		:= {}
	local aD		:= {}
	local aB		:= {}
	local lC		:= .F.
	local d,i

	aAdd( aD, "Este programa permite exportar para excel um resumo do saldo de banco de  " )
	aAdd( aD, "horas m๊s a m๊s, considerando os funcionarios de todas as empresas do grupo." )

	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	ajustaSX1(cPerg)
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------

	pergunte(cPerg,.F.)

	aAdd( aB, {5,.T.,{|| pergunte(cPerg,.T.) }} )
	aAdd( aB, {1,.T.,{|| lC := .T., fechaBatch() }} )
	aAdd( aB, {2,.T.,{|| fechaBatch() }} )

	formBatch( "Resumo do Banco de Horas", aD, aB )

	if !lC
		return
	endif

	d := lastDay(mv_par01)

	while d <= lastDay(mv_par02)
		aAdd( aMeses, { left(dtos(d),6), aNomes[month(d)]+"_"+str(year(d),4) } )
		d := lastDay(d+1)
	end

	cQuery += "SELECT TRIM(M0_NOME) RD_EMPRESA, TRIM(M0_FILIAL) PI_FILIAL, PI_MAT, RA_NOME, RA_CC," + cr
	cQuery += "       RA_ADMISSA, RA_CODFUNC, R6_TURNO, RA_DEMISSA, RA_SUP" + cr

	for i := 1 to len( aMeses )
		cQuery += "       ,CentToMin(SUM(CASE WHEN RD_DATARQ <= '" + aMeses[i,1] + "' THEN PI_QUANTV ELSE 0 END)) " + aMeses[i,2] + cr
	next i

	cQuery += "  FROM BHSALDO A" + cr
	cQuery += "  JOIN SM0 B" + cr
	cQuery += "    ON M0_CODIGO = RD_EMPRESA" + cr
	cQuery += "   AND M0_CODFIL = PI_FILIAL" + cr
	cQuery += "   AND PI_MAT    BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'" + cr
	cQuery += "   AND RA_NOME   BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'" + cr
	cQuery += "   AND RA_CC     BETWEEN '"+mv_par07+"' AND '"+mv_par08+"'" + cr
	cQuery += "   AND B.D_E_L_E_T_ = ' '" + cr
	cQuery += " GROUP BY M0_NOME, M0_FILIAL, PI_MAT, RA_NOME, RA_CC, RA_ADMISSA, RA_CODFUNC, R6_TURNO, RA_DEMISSA, RA_SUP" + cr

	if !u_altExcel( {{ cQuery, "BancoDeHoras", "Resumo do Banco de Horas" }} )
		msgInfo("Nใo foi possํvel gerar o relat๓rio. Revise os parโmetros e tente novamente!")
	endif

return

//
//
//
static function ajustaSx1(cPerg)
	//----------------------------------------------------------------------------------------------------------------------------------------
	// Revisado CodeAnalisys por Carlos Eduardo Saturnino em 26/08/2019
	//----------------------------------------------------------------------------------------------------------------------------- { Inicio }
	/*
	putSx1( cPerg, "01", "Data inicial"  ,".",".","mv_ch1","D",08,0,2,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "02", "Data final"    ,".",".","mv_ch2","D",08,0,2,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "03", "Matricula de"  ,".",".","mv_ch3","C",06,0,2,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "04", "Matricula ate" ,".",".","mv_ch4","C",06,0,2,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "05", "Nome de"       ,".",".","mv_ch5","C",40,0,2,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "06", "Nome ate"      ,".",".","mv_ch6","C",40,0,2,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "07", "C Custo de"    ,".",".","mv_ch7","C",20,0,2,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",,,,"")
	putSx1( cPerg, "08", "C Custo ate"   ,".",".","mv_ch8","C",20,0,2,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",,,,"")
	*/
	//{ Fim } --------------------------------------------------------------------------------------------------------------------------------
return




/*
// FONTE DA VIEW NO ORACLE, CASO SEJA PERDIDA ALGUM DIA. COPIA REALIZADA EM 21/03/2015

CREATE OR REPLACE VIEW SIGA.BHSALDO
AS (

SELECT '08' RD_EMPRESA, PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01) RA_CC, RA_ADMISSA, RJ_DESC RA_CODFUNC, NVL(R6_DESC,' ') R6_TURNO, RA_DEMISSA, NVL(ZZS_NOME,' ') RA_SUP, SUBSTR(PI_DATA,1,6) RD_DATARQ, SUM(MinToCent(CASE WHEN P9_TIPOCOD IN ('1','3') THEN PI_QUANTV ELSE PI_QUANTV * -1 END)) PI_QUANTV
FROM SPI080 A
JOIN SRA080 R
ON R.RA_FILIAL  = A.PI_FILIAL
AND R.RA_MAT     = A.PI_MAT
AND R.RA_REGRA   <> '05'
AND R.D_E_L_E_T_ = ' '
JOIN CTT080 T
ON CTT_FILIAL   = ' '
AND CTT_CUSTO    = R.RA_CC
AND T.D_E_L_E_T_ = ' '
JOIN SRJ080 J
ON J.RJ_FILIAL  = ' '
AND J.RJ_FUNCAO  = R.RA_CODFUNC
AND J.D_E_L_E_T_ = ' '
JOIN SP9080 B
ON B.P9_FILIAL = ' '
AND B.P9_CODIGO = A.PI_PD
AND B.D_E_L_E_T_ = ' '
JOIN SR6080 U
ON U.R6_FILIAL  = ' '
AND U.R6_TURNO   = R.RA_TNOTRAB
AND U.D_E_L_E_T_ = ' '
LEFT
JOIN ZZS080 Z
ON Z.ZZS_FILIAL = ' '
AND Z.ZZS_COD    = R.RA_SUP
AND Z.D_E_L_E_T_ = ' '
WHERE A.D_E_L_E_T_ = ' '
AND A.PI_STATUS  = ' '
GROUP BY PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01), RA_ADMISSA, RJ_DESC, R6_DESC, RA_DEMISSA, ZZS_NOME, SUBSTR(PI_DATA,1,6)


UNION ALL


SELECT '09' RD_EMPRESA, PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01) RA_CC, RA_ADMISSA, RJ_DESC RA_CODFUNC, NVL(R6_DESC,' ') R6_TURNO, RA_DEMISSA, NVL(ZZS_NOME,' ') RA_SUP, SUBSTR(PI_DATA,1,6) RD_DATARQ, SUM(MinToCent(CASE WHEN P9_TIPOCOD IN ('1','3') THEN PI_QUANTV ELSE PI_QUANTV * -1 END)) PI_QUANTV
FROM SPI090 A
JOIN SRA090 R
ON R.RA_FILIAL  = A.PI_FILIAL
AND R.RA_MAT     = A.PI_MAT
AND R.RA_REGRA   <> '05'
AND R.D_E_L_E_T_ = ' '
JOIN CTT080 T
ON CTT_FILIAL   = ' '
AND CTT_CUSTO    = R.RA_CC
AND T.D_E_L_E_T_ = ' '
JOIN SRJ080 J
ON J.RJ_FILIAL  = ' '
AND J.RJ_FUNCAO  = R.RA_CODFUNC
AND J.D_E_L_E_T_ = ' '
JOIN SP9080 B
ON B.P9_FILIAL = ' '
AND B.P9_CODIGO = A.PI_PD
AND B.D_E_L_E_T_ = ' '
JOIN SR6080 U
ON U.R6_FILIAL  = ' '
AND U.R6_TURNO   = R.RA_TNOTRAB
AND U.D_E_L_E_T_ = ' '
LEFT
JOIN ZZS080 Z
ON Z.ZZS_FILIAL = ' '
AND Z.ZZS_COD    = R.RA_SUP
AND Z.D_E_L_E_T_ = ' '
WHERE A.D_E_L_E_T_ = ' '
AND A.PI_STATUS  = ' '
GROUP BY PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01), RA_ADMISSA, RJ_DESC, R6_DESC, RA_DEMISSA, ZZS_NOME, SUBSTR(PI_DATA,1,6)


UNION ALL


SELECT '15' RD_EMPRESA, PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01) RA_CC, RA_ADMISSA, RJ_DESC RA_CODFUNC, NVL(R6_DESC,' ') R6_TURNO, RA_DEMISSA, NVL(ZZS_NOME,' ') RA_SUP, SUBSTR(PI_DATA,1,6) RD_DATARQ, SUM(MinToCent(CASE WHEN P9_TIPOCOD IN ('1','3') THEN PI_QUANTV ELSE PI_QUANTV * -1 END)) PI_QUANTV
FROM SPI150 A
JOIN SRA150 R
ON R.RA_FILIAL  = A.PI_FILIAL
AND R.RA_MAT     = A.PI_MAT
AND R.RA_REGRA   <> '05'
AND R.D_E_L_E_T_ = ' '
JOIN CTT080 T
ON CTT_FILIAL   = ' '
AND CTT_CUSTO    = R.RA_CC
AND T.D_E_L_E_T_ = ' '
JOIN SRJ080 J
ON J.RJ_FILIAL  = ' '
AND J.RJ_FUNCAO  = R.RA_CODFUNC
AND J.D_E_L_E_T_ = ' '
JOIN SP9080 B
ON B.P9_FILIAL = ' '
AND B.P9_CODIGO = A.PI_PD
AND B.D_E_L_E_T_ = ' '
JOIN SR6080 U
ON U.R6_FILIAL  = ' '
AND U.R6_TURNO   = R.RA_TNOTRAB
AND U.D_E_L_E_T_ = ' '
LEFT
JOIN ZZS080 Z
ON Z.ZZS_FILIAL = ' '
AND Z.ZZS_COD    = R.RA_SUP
AND Z.D_E_L_E_T_ = ' '
WHERE A.D_E_L_E_T_ = ' '
AND A.PI_STATUS  = ' '
GROUP BY PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01), RA_ADMISSA, RJ_DESC, R6_DESC, RA_DEMISSA, ZZS_NOME, SUBSTR(PI_DATA,1,6)


UNION ALL


SELECT '16' RD_EMPRESA, PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01) RA_CC, RA_ADMISSA, RJ_DESC RA_CODFUNC, NVL(R6_DESC,' ') R6_TURNO, RA_DEMISSA, NVL(ZZS_NOME,' ') RA_SUP, SUBSTR(PI_DATA,1,6) RD_DATARQ, SUM(MinToCent(CASE WHEN P9_TIPOCOD IN ('1','3') THEN PI_QUANTV ELSE PI_QUANTV * -1 END)) PI_QUANTV
FROM SPI160 A
JOIN SRA160 R
ON R.RA_FILIAL  = A.PI_FILIAL
AND R.RA_MAT     = A.PI_MAT
AND R.RA_REGRA   <> '05'
AND R.D_E_L_E_T_ = ' '
JOIN CTT080 T
ON CTT_FILIAL   = ' '
AND CTT_CUSTO    = R.RA_CC
AND T.D_E_L_E_T_ = ' '
JOIN SRJ080 J
ON J.RJ_FILIAL  = ' '
AND J.RJ_FUNCAO  = R.RA_CODFUNC
AND J.D_E_L_E_T_ = ' '
JOIN SP9080 B
ON B.P9_FILIAL = ' '
AND B.P9_CODIGO = A.PI_PD
AND B.D_E_L_E_T_ = ' '
JOIN SR6080 U
ON U.R6_FILIAL  = ' '
AND U.R6_TURNO   = R.RA_TNOTRAB
AND U.D_E_L_E_T_ = ' '
LEFT
JOIN ZZS080 Z
ON Z.ZZS_FILIAL = ' '
AND Z.ZZS_COD    = R.RA_SUP
AND Z.D_E_L_E_T_ = ' '
WHERE A.D_E_L_E_T_ = ' '
AND A.PI_STATUS  = ' '
GROUP BY PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01), RA_ADMISSA, RJ_DESC, R6_DESC, RA_DEMISSA, ZZS_NOME, SUBSTR(PI_DATA,1,6)



UNION ALL


SELECT '20' RD_EMPRESA, PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01) RA_CC, RA_ADMISSA, RJ_DESC RA_CODFUNC, NVL(R6_DESC,' ') R6_TURNO, RA_DEMISSA, NVL(ZZS_NOME,' ') RA_SUP, SUBSTR(PI_DATA,1,6) RD_DATARQ, SUM(MinToCent(CASE WHEN P9_TIPOCOD IN ('1','3') THEN PI_QUANTV ELSE PI_QUANTV * -1 END)) PI_QUANTV
FROM SPI200 A
JOIN SRA200 R
ON R.RA_FILIAL  = A.PI_FILIAL
AND R.RA_MAT     = A.PI_MAT
AND R.RA_REGRA   <> '05'
AND R.D_E_L_E_T_ = ' '
JOIN CTT080 T
ON CTT_FILIAL   = ' '
AND CTT_CUSTO    = R.RA_CC
AND T.D_E_L_E_T_ = ' '
JOIN SRJ080 J
ON J.RJ_FILIAL  = ' '
AND J.RJ_FUNCAO  = R.RA_CODFUNC
AND J.D_E_L_E_T_ = ' '
JOIN SP9080 B
ON B.P9_FILIAL = ' '
AND B.P9_CODIGO = A.PI_PD
AND B.D_E_L_E_T_ = ' '
JOIN SR6080 U
ON U.R6_FILIAL  = ' '
AND U.R6_TURNO   = R.RA_TNOTRAB
AND U.D_E_L_E_T_ = ' '
LEFT
JOIN ZZS080 Z
ON Z.ZZS_FILIAL = ' '
AND Z.ZZS_COD    = R.RA_SUP
AND Z.D_E_L_E_T_ = ' '
WHERE A.D_E_L_E_T_ = ' '
AND A.PI_STATUS  = ' '
GROUP BY PI_FILIAL, PI_MAT, RA_NOME, RA_CC || ' - '||TRIM(CTT_DESC01), RA_ADMISSA, RJ_DESC, R6_DESC, RA_DEMISSA, ZZS_NOME, SUBSTR(PI_DATA,1,6)
)

*/
