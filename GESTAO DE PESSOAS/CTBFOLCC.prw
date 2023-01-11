//Bibliotecas
#include 'totvs.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "topconn.ch"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Program   ³ APROMEURH ³ Autor ³ Rafael Augusto   ³ Data ³ 16.03.2021   ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descricao ³ Desenvolvimento responsavel por efeutar as aprovacoes das  ³±±
//±±³          ³ marcacoes incluidas pelo MEU RH, quando estiverem no status³±±
//±±³          ³ Aguardando RH.                                             ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ T4F - CRM SERVICES LTDA.   					            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÝÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

User Function CTBFOLCC()

_cEPEP := ""

IF ALLTRIM(SRZ->RZ_CC) $ "03025402/03025412/04044100/03025300" 

    _cEPEP := "990200001"

ElSEIF ALLTRIM(SRZ->RZ_CC) $ "03031103"

    _cEPEP := "080200001"

ElSEIF ALLTRIM(SRZ->RZ_CC) $ "03043300/03042200/03043100"

    _cEPEP := "OGGGG209997"

ElSEIF ALLTRIM(SRZ->RZ_CC) $ "03071000"

    _cEPEP := "PGGGG209999"

ElSEIF ALLTRIM(SRZ->RZ_CC) $ "04022102/04022101"

    _cEPEP := "PGIGG209999"

ElSEIF ALLTRIM(SRZ->RZ_CC) $ "15011001/15011002/15011004"

    _cEPEP := "990300001"

ElSEIF ALLTRIM(SRZ->RZ_CC) $ "15011003/15011006/15011007/15011008"

    _cEPEP := "990300002"

ENDIF

Return _cEPEP
