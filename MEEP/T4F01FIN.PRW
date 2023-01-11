#include 'totvs.ch'
#INCLUDE "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"
//TODO DEPENDE DA DEFINIÇÃO DA CONCILIADORA E DA REGRA PARA GERAÇÃO DOS TITULOS
/*/{Protheus.doc} T4F01FIN
@description **Geração dos titulos a receber por bandeira e tipo de pagamento**
@type User function
@version 1.00
@author Rogério Costa
@since 20/10/2020
@return return_type, return_description
/*/
User Function T4F01FIN()

    Local cTipo		:= "NF "
    Local aRotAuto	:=	{}
    Local cAliasSC5 := ""
    Local cQuery2   := ""
    Private lMsErroAuto := .F.

    PREPARE ENVIRONMENT EMPRESA "08" FILIAL "01" MODULO "FIN" TABLES "SE1","SE4","SED"

    cAliasSC5:= GetNextAlias()

    cQuery2:= " SELECT C5_PAGTO, C5_XBANDEI, C5_NATUREZ, SUM(D2_TOTAL) TOTAL " + CRLF
    cQuery2+= "  FROM " +RetSqlName("SD2") +" SD2," +RetSqlName("SC6")+" SC6," +RetSqlName("SC5")+" SC5 " + CRLF
    cQuery2+= "    WHERE D2_FILIAL=C6_FILIAL " + CRLF
    cQuery2+= "     AND D2_SERIE='9' " + CRLF
    cQuery2+= "     AND D2_SERIE = C6_SERIE " + CRLF
    cQuery2+= "     AND D2_DOC = C6_NOTA " + CRLF
    cQuery2+= "     AND D2_CLIENTE = C6_CLI " + CRLF
    cQuery2+= "     AND D2_LOJA = C6_LOJA " + CRLF
    cQuery2+= "     AND D2_ITEMPV = C6_ITEM " + CRLF
    cQuery2+= "     AND C5_NUM = C6_NUM" + CRLF
    cQuery2+= "     AND C5_PAGTO <> ' '" + CRLF
    cQuery2+= "     AND C6_CLI = C5_CLIENTE " + CRLF
    cQuery2+= "     AND C6_LOJA = C5_LOJACLI " + CRLF
    cQuery2+= "     AND C6_NOTA <> ' ' " + CRLF
    cQuery2+= "     AND sd2.D_E_L_E_T_ = ' ' " + CRLF
    cQuery2+= "     AND sc6.D_E_L_E_T_ = ' ' " + CRLF
    cQuery2+= "     AND sc5.D_E_L_E_T_ = ' ' " + CRLF
    cQuery2+= " GROUP BY C5_PAGTO, C5_XBANDEI, C5_NATUREZ " + CRLF

    dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery2),cAliasSC5,.F.,.T.)

    (cAliasSC5)->(DbGoTop())

    While (cAliasSC5)->(!Eof())

        cNumSe1	:=	GetSX8Num("SE1","E1_NUM")

        AAdd( aRotAuto, { "E1_NUM"    , cNumSe1, NIL } )
        AAdd( aRotAuto, { "E1_PREFIXO", "INT", NIL } )
        AAdd( aRotAuto, { "E1_NATUREZ", (cAliasSC5)->C5_NATUREZ, NIL } )
        AAdd( aRotAuto, { "E1_TIPO"   , cTipo, NIL } )
        Do Case
        Case (cAliasSC5)->C5_XBANDEI == '1'
            cLiente :='000100'
            cLoja   :='01'
        Case (cAliasSC5)->C5_XBANDEI == '2'
            cLiente :='008   '
            cLoja   :='01'
        Case (cAliasSC5)->C5_XBANDEI == '3'
            cLiente :='002   '
            cLoja   :='01'
        EndCase

        AAdd( aRotAuto, { "E1_CLIENTE", cLiente                     , NIL } )
        AAdd( aRotAuto, { "E1_LOJA"   , cLoja                       , NIL } )
        AAdd( aRotAuto, { "E1_VALOR"  , (cAliasSC5)->TOTAL          , NIL } )
        AAdd( aRotAuto, { "E1_EMISSAO", dDataBase                   , NIL } )
        AAdd( aRotAuto, { "E1_VENCTO" , dDataBase                   , NIL } )
        AAdd( aRotAuto, { "E1_VENCREA", DataValida( dDataBase )     , NIL } )
        AADD( aRotAuto, { "E1_VENCORI", DataValida( Ddatabase,.T.)  , NIL })
        AADD( aRotAuto, { "E1_HIST"   , "TITULO AGLUTINADO INTI"    , NIL })
        AADD( aRotAuto, { "E1_MOEDA"  , 1                           , NIL})
        AADD( aRotAuto, { "E1_MDCONTR", ""                          , NIL})
        AADD( aRotAuto, { "E1_MDREVIS", ""                          , NIL})
        AADD( aRotAuto, { "E1_ORIGEM" , "INTI"                   , NIL})

        BEGIN TRANSACTION

            MSExecAuto({|x, y| FINA040(x, y)}, aRotAuto, 3)

            If lMsErroAuto
                MOSTRAERRO()
                DisarmTransaction()
            Endif
//TODO TRATAR ERROR LOG 
            aRotAuto:={}
        
        END TRANSACTION

        (cAliasSC5)->(DbSkip())

    EndDo
    RESET ENVIRONMENT

Return(Nil)
