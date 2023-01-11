#Include "Protheus.ch"
  
/*/{Protheus.doc} MT103DRF
Ponto de Entrada para alterar o Campo DIRF e Código de Retenção dos Impostos
na Classificação do Documento de Entrada
@author Lucas Valins
@since 03/09/2020
@version 1.0
@type function
@example U_MT103DRF()
/*/
  
 
User Function MT103DRF()

Local nCombo := PARAMIXB[1] 
Local cCodRet := PARAMIXB[2] 
//Local oCombo := PARAMIXB[3] 
//Local oCodRet := PARAMIXB[4] 
Local aImpRet := {}

nCombo := 1
cCodRet := "1708"

aadd(aImpRet,{"IRR",nCombo,cCodRet})

nCombo  := 2
cCodRet := ""

aadd(aImpRet,{"ISS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"

aadd(aImpRet,{"PIS",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"

aadd(aImpRet,{"COF",nCombo,cCodRet})

nCombo  := 1
cCodRet := "5952"

aadd(aImpRet,{"CSL",nCombo,cCodRet})

Return aImpRet
