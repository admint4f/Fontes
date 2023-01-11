#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SC7COD    ºAutor  ³Sergio Celestino    º Data ³  23/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Formacao dos codigos dos Pedidos de compras.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SC7COD(dDataPed)
Local aBkpArea:= GetArea()
Local lCodInt := GetMv("MV_CODPED",,.T.)                       
Local cAno    := ""
Local cMes    := ""
Local cSeq    := "0000"

If lCodInt
    cAno:= Substr(Alltrim(Str(Ano(dDataPed))),4,1)
    cMes:= VerMes(dDataPed)
    cSeq:= Soma1(cSeq,4)
    cRet:= Alltrim(cAno)+Alltrim(cMes)+Alltrim(cSeq)
 Else    
    cRet:= CriaVar("C7_NUM",.T.)
    Return cRet
Endif    

DbSelectArea("SC7")//Sergio Celestino
//DbSetOrder(20)//Sergio Celestino          
SC7->(dbOrderNickName("20"))
DbGotop()//Sergio Celestino

Set deleted off //( Trazer deletados )//Sergio Celestino

While ( MsSeek( cRet ) .OR. !MayIUseCode("SC7"+cRet) ) //Alterado em 7/4/10 (adicionado empresa e filial para reserva de numero)
        cSeq := Soma1(cSeq,4)
        cRet:= Alltrim(cAno)+Alltrim(cMes)+Alltrim(cSeq)
End

Set deleted On //( Ocultar deletados )//Sergio Celestino

cRet:= Alltrim(cAno)+Alltrim(cMes)+Alltrim(cSeq)
RestArea(aBkpArea)
Return cRet
//----------------------------------
// Retorna Letra conforme Mes     //
//----------------------------------
Static Function VerMes(dDataPed)

Local cRet := ""

Do Case
   Case Mes(dDataPed)=="Janeiro"   ;cRet:="A"
   Case Mes(dDataPed)=="Fevereiro" ;cRet:="B"
   Case Mes(dDataPed)=="Marco"     ;cRet:="C"   
   Case Mes(dDataPed)=="Abril"     ;cRet:="D"
   Case Mes(dDataPed)=="Maio"      ;cRet:="E"
   Case Mes(dDataPed)=="Junho"     ;cRet:="F"
   Case Mes(dDataPed)=="Julho"     ;cRet:="G"            
   Case Mes(dDataPed)=="Agosto"    ;cRet:="H"   
   Case Mes(dDataPed)=="Setembro"  ;cRet:="I"   
   Case Mes(dDataPed)=="Outubro"   ;cRet:="J"   
   Case Mes(dDataPed)=="Novembro"  ;cRet:="L"
   Case Mes(dDataPed)=="Dezembro"  ;cRet:="M"
EndCase

Return cRet         