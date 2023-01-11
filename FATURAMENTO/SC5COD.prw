#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SC5COD    ºAutor  ³Gilberto Oliveira   º Data ³  31/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUTILIZANDO COMO BASE O PROGRAMA:                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPrograma  ³SC7COD    ºAutor  ³Sergio Celestino    º Data ³  23/02/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Formacao dos codigos dos Pedidos de VENDAS.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ T4F                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SC5COD(dDataPed)
Local aBkpArea:= GetArea()
Local lCodInt := GetMv("T4F_CODPV",,.T.)                       
//Local cAno    := ""
//Local cMes    := ""
Local cSeq    := "000000"
 
If lCodInt
//    cAno:= Substr(Alltrim(Str(Ano(dDataPed))),4,1)
//    cMes:= VerMes(dDataPed)
    cSeq:= GetMv("T4F_SEQPV",,"000000")
    cSeq:= Soma1(cSeq,6)
    //cRet:= Alltrim(cAno)+Alltrim(cMes)+Alltrim(cSeq)
    cRet:= Alltrim(cSeq)
 Else    
    cRet:= CriaVar("C5_NUM",.T.)
    Return cRet
Endif    

DbSelectArea("SC5")
SC5->(dbOrderNickName("6"))
DbGotop()

Set Deleted off //( Trazer deletados )//Sergio Celestino

While ( MsSeek( cRet ) .OR. !MayIUseCode("SC5"+cRet) ) //Alterado em 7/4/10 (adicionado empresa e filial para reserva de numero)
        cSeq := Soma1(cSeq,4)
        //cRet:= Alltrim(cAno)+Alltrim(cMes)+Alltrim(cSeq)
        cRet:= Alltrim(cSeq)
End-While

Set Deleted On //( Ocultar deletados )//Sergio Celestino

//cRet:= Alltrim(cAno)+Alltrim(cMes)+Alltrim(cSeq)
cRet:= Alltrim(cSeq)
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