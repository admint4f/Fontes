#INCLUDE "rwmake.ch"
#include 'totvs.ch
#include 'protheus.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ T4F001   º Autor ³Antonio Perinazzo Jrº Data ³  03/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gatilho para retornar a conta contabil de acordo com param.º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4f                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function T4F001(_Produto,_TES,_Rotina,_TIPO,_LINHA)
Local aArea      := GetArea()
Local _Retorno   := ""
Local _Conta     := ""  
Local _EntSai    := ""
Local _CC        := "" 
Local _PEP       := "" 
Local _Empresa   := SM0->M0_CODIGO
Local _Estoque   := "N"
Local _CtaAntes  := ""
Local _Campo     := ReadVar()
Local _Linha     := Iif(_Linha==Nil,n,_Linha)
Local cAdm       := GetMV('MV_ELEPADM')
Local cElPep     := Alltrim(_PEP)


_Produto := Iif(_Produto ==Nil,""            ,_Produto )
_TES     := Iif(_TES     ==Nil,""            ,_TES     )
_Rotina  := Iif(_Rotina  ==Nil,""            ,_Rotina  )
_Tipo    := Iif(_Tipo    ==Nil,"N"           ,_Tipo    )

/*
SB1->B1_CONTA  -> Conta Padrao do cadastro de produto ou Estoque
SB1->B1_CTAADM -> Conta Para Custo para Reembolso de Despesas
SB1->B1_CONTADP-> Conta Para Despesas (Sem elemento PEP informado)
SB1->B1_CTACUST-> Conta Para Custo    (Com Elemento PEP Informado)
SB1->B1_CONTAG -> Conta Para Receita  
*/
If !Empty(_TES)
EndIf

Do Case
Case _Rotina == "NFE"
	_TES       := Iif(TRIM(_Campo)=="M->D1_TES"  ,M->D1_TES  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES" })])
	_Produto   := Iif(TRIM(_Campo)=="M->D1_COD"  ,M->D1_COD  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD" })])
	_CtaAntes  := Iif(TRIM(_Campo)=="M->D1_CONTA",M->D1_CONTA,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"})])
	_EntSai    := iIF(SubStr(Iif(TRIM(_Campo)=="M->D1_TES"  ,M->D1_TES  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_TES"   })]),1,1)<"5","E","S")
	_CC        := Iif(TRIM(_Campo)=="M->D1_CC"   ,M->D1_CC   ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC" })])
	_PEP       := Iif(TRIM(_Campo)=="M->D1_ITEMCTA",M->D1_ITEMCTA  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEMCTA" })])
	_Empresa   := SM0->M0_CODIGO
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+_TES)
	If !Eof()
		_Estoque := SF4->F4_ESTOQUE
	EndIf
	_Estoque   := Iif(Empty(_Estoque),"N",_Estoque)
Case _Rotina == "NFS"
	_TES       := Iif(TRIM(_Campo)=="M->D2_TES"  ,M->D2_TES  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D2_TES" })])
 	_Produto   := Iif(TRIM(_Campo)=="M->D2_COD"  ,M->D2_COD  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D2_COD" })])
	_CtaAntes  := Iif(TRIM(_Campo)=="M->D2_CONTA",M->D2_CONTA,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D2_CONTA" })])
	_EntSai    := iIF(SubStr(Iif(TRIM(_Campo)=="M->D2_TES"  ,M->D1_TES  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D2_TES" })]),1,1)<"5","E","S")
	_CC        := Iif(TRIM(_Campo)=="M->D2_CC"   ,M->D2_CC   ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D2_CC" })])
	_PEP       := Iif(TRIM(_Campo)=="M->D2_ITEMCTA",M->D2_ITEMCTA  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "D2_ITEMCTA" })])
	_Empresa   := SM0->M0_CODIGO
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+_TES)
	If !Eof()
		_Estoque := SF4->F4_ESTOQUE
	EndIf
	_Estoque   := Iif(Empty(_Estoque),"N",_Estoque)
Case _Rotina == "PC"
	_TES       := Iif(TRIM(_Campo)=="M->C7_TES"    ,M->C7_TES    ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C7_TES" })])
	_Produto   := Iif(TRIM(_Campo)=="M->C7_PRODUTO",M->C7_PRODUTO,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO" })])
	_CtaAntes  := Iif(TRIM(_Campo)=="M->C7_CONTA"  ,M->C7_CONTA  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C7_CONTA" })])
	_EntSai    := iIF(SubStr(Iif(TRIM(_Campo)=="M->C7_TES"  ,M->C7_TES  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C7_TES" })]),1,1)<"5","E","S")
	_CC        := Iif(TRIM(_Campo)=="M->C7_CC"   ,M->C7_CC   ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C7_CC" })])
	_PEP       := Iif(TRIM(_Campo)=="M->C7_ITEMCTA",M->C7_ITEMCTA  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMCTA" })])
	_Empresa   := SM0->M0_CODIGO
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+_TES)
	If !Eof()
		_Estoque := SF4->F4_ESTOQUE
	EndIf
	_Estoque   := Iif(Empty(_Estoque),"N",_Estoque)
Case _Rotina == "PV"
	_TES       := Iif(TRIM(_Campo)=="M->C6_TES"    			,M->C6_TES    ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"	 })])
	_Produto   := Iif(TRIM(_Campo)=="M->C6_PRODUTO"			,M->C6_PRODUTO,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })])
	_CtaAntes  := Iif(TRIM(_Campo)=="M->C6_CONTA"  			,M->C6_CONTA  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C6_CONTA"   })])
	_EntSai    := iIF(SubStr(Iif(TRIM(_Campo)=="M->C6_TES"  ,M->C6_TES    ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES" 	 })]),1,1)<"5","E","S")
//	_CC        := Iif(TRIM(_Campo)=="M->C6_CCUSTO" 			,M->C6_CCUSTO ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C6_CCUSTO"  })])
	_PEP       := Iif(TRIM(_Campo)=="M->C6_ITEMCC" 			,M->C6_ITEMCC ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEMCC"  })])
//	_Empresa   := SM0->M0_CODIGO
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+_TES)
	If !Eof()
		_Estoque := SF4->F4_ESTOQUE
	EndIf
	_Estoque   := Iif(Empty(_Estoque),"N",_Estoque)
Case _Rotina == "SC"
	_TES       := Iif(TRIM(_Campo)=="M->C1_TES"    ,M->C1_TES    ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C1_TES" })])
	_Produto   := Iif(TRIM(_Campo)=="M->C1_PRODUTO",M->C1_PRODUTO,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C1_PRODUTO" })])
	_CtaAntes  := Iif(TRIM(_Campo)=="M->C1_CONTA"  ,M->C1_CONTA  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C1_CONTA" })])
	_EntSai    := iIF(SubStr(Iif(TRIM(_Campo)=="M->C1_TES",M->C1_TES  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C1_TES" })]),1,1)<"5","E","S")
	_CC        := Iif(TRIM(_Campo)=="M->C1_CC"     ,M->C1_CC     ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C1_CC" })])
	_PEP       := Iif(TRIM(_Campo)=="M->C1_ITEMCTA",M->C1_ITEMCTA  ,aCols[_Linha,AScan(aHeader,{|x| AllTrim(x[2]) == "C1_ITEMCTA" })])
	_Empresa   := SM0->M0_CODIGO
	DbSelectArea("SF4")
	DbSetOrder(1)
	DbSeek(xFilial("SF4")+_TES)
	If !Eof()
		_Estoque := SF4->F4_ESTOQUE
	EndIf
	_Estoque   := Iif(Empty(_Estoque),"N",_Estoque)
EndCase

cElPep := Alltrim(_PEP)

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+_Produto)
If !Eof()
	_Conta := SB1->B1_CONTA
	Do Case
	Case _EntSai == "E" 
		Do Case
		Case !(_Tipo $ "DB") .AND. _Estoque == "S" .AND. !Empty(SB1->B1_CONTA)
			_Conta := SB1->B1_CONTA
		Case !(_Tipo $ "DB") .AND.  Empty(_PEP) .AND.  _Estoque == "N" .AND. !Empty(SB1->B1_CONTADP)
			_Conta := SB1->B1_CONTADP
		Case !(_Tipo $ "DB") .AND.  cElPep$cAdm .AND.  _Estoque == "N" .AND. !Empty(SB1->B1_CONTADP)
			_Conta := SB1->B1_CONTADP
		Case !(_Tipo $ "DB") .AND. !Empty(_PEP) .AND.  _Estoque == "N" .AND. !Empty(SB1->B1_CTACUST)
			_Conta := SB1->B1_CTACUST
		Case _Tipo $ "DB" .and. !Empty(_CtaAntes)
		 	_Conta := _CtaAntes
		Case _Tipo $ "DB" .AND. Empty(SB1->B1_CTACUST) .AND. Empty(SB1->B1_CONTA) .AND. !Empty(SB1->B1_CONTADP)
			_Conta := SB1->B1_CONTADP
		OtherWise
			_Conta := SB1->B1_CONTA
		EndCase
	Case _EntSai == "S"
		Do Case
		Case !(_Tipo $ "DB") .AND. !EMPTY(SB1->B1_CONTAG)
			_Conta := SB1->B1_CONTAG
		Case _Tipo $ "DB" 
			_Conta := _CtaAntes
		Case !(_Tipo $ "DB") .AND. Empty(SB1->B1_CONTAG)
			_Conta := SB1->B1_CONTA
		OtherWise
			_Conta := SB1->B1_CONTA
		EndCase
		
	EndCase
	
EndIf

_Retorno := _Conta

RestArea(aArea)
Return(_Retorno)
