#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "Fileio.ch"
#INCLUDE "dbtree.ch"
#include "tbiconn.ch"

/*----------------------------------------------------------------------*
 | Func:  U_INT_MEEPINIT()                                           	|
 | Autor: Felipe Sakaguti                                              	|
 | Data:  19/03/2021                                                  	|
 | Desc:  Menu de integração do estoque e produto para o software Meep	|
 *----------------------------------------------------------------------*/

User Function IMPROD7(ZB0Num,cEmpMp,cFilMp)

	Default cEmpMp	:= "20"
	Default cFilMp	:= "01"

    PREPARE ENVIRONMENT EMPRESA cEmpMp FILIAL cFilMp MODULO "LOJA"

	dbSelectArea("ZBP")
	dbSetOrder(2)
    dbGoTop()

    Do While ZBP->( !EOF() )

        If ZBP->ZBP_STATUS == "0"
            If ZBP->ZBP_FORMA == "R$"
                dDataFtd := date()

                dDateMP   := SUBSTR(ZBP->ZBP_DATA,9,2)+"/"+SUBSTR(ZBP->ZBP_DATA,6,2)+"/"+LEFT(ZBP->ZBP_DATA,4)

                cHoraMeep   := SUBSTR(ZBP->ZBP_DATA,12,2)

                If val(cHoraMeep) < 3
                    dDataFtd := DaySub(CToD(dDateMP),1)
                Else
                    dDataFtd := CToD(dDateMP)
                EndIf

	            dbSelectArea("ZBP")

                RecLock("ZBP", .F.)
                    ZBP->ZBP_DATAFT		:=	dDataFtd
                ZBP->(MsUnlock())
            EndIf
        Endif

        ZBP->( dbSkip() )
    EndDo

	RESET ENVIRONMENT

Return
