#INCLUDE "TopConn.ch"
#INCLUDE "PROTHEUS.CH"

#DEFINE oNApvdo    LoadBitmap( GetResources(), "BR_VERMELHO" )//Aguardando Aprovacao
#DEFINE oNApvdoX   LoadBitmap( GetResources(), "BR_AZUL"     )//Parado Nivel superior
#DEFINE oApvdo     LoadBitmap( GetResources(), "BR_VERDE"    )//Aprovado
#DEFINE oApvdoX    LoadBitmap( GetResources(), "BR_LARANJA"  )//Aprovado no Nivel
#DEFINE oRejeit    LoadBitmap( GetResources(), "BR_PRETO"    )//Rejeitado

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³T4FRATGER ºAutor  ³Sergio Celestino    º Data ³  02/04/11   º±±                           
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gerenciamento das Alcadas de Aprovacao por Rateio         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Time For Fun                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function T4FRATGER()        

Local oFont   
Local aCoorden	:= MsAdvSize(.T.)
Local lFirst    := .T.
Local lTelaAnt  := .f.//GetMv("MV_T4FAPVX",,.T.)//Caso parametro seja verdadeiro e nao exista rateio ira abrir a tela de aprovacao antiga
Local aArea     := GetArea()
Local aAreaSC1  := SC1->(GetArea())
Local aRotBkp   := aClone(aRotina)
Local cNumPesq  := ""
Local oTelaRat  
Local oMainX

Private _aCustos   := {}  
Private _aAprov    := {}
Private _oCustos   := Nil
Private _oAprov    := Nil
Private lSolicita  := IIf(Alltrim(Upper(FunName(0)))=="MATA110",.T.,.F.)
Private cTipo      := IIf(Alltrim(Upper(FunName(0)))=="MATA110","S","C")

If Alltrim(Upper(FunName(0)))=="MATA110"
   If  INCLUI
       cNumPesq := cA110Num
   Else
       cNumPesq := SC1->C1_NUM
   Endif
Else
   cNumPesq := SC3->C3_NUM
Endif

aAreaSZ2 := SZ2->(GetArea())
DbSelectArea("SZ2")
DbSetOrder(4)//FILIAL+NUM+TIPO
DbGotop()
If lTelaAnt
//If !MsSeek(xFilial("SZ2") + cNumPesq + cTipo) .And. lTelaAnt
   U_RCOMA070() // Tela de controle de aprovação antiga
Else

	MsgRun("Analisando Alçada - Aguarde...",,{|| MontaQuery(cNumPesq,1) })  
	
	If Len(_aCustos)==0
      aAdd(_aCustos ,{" "," "," "," "} )
     Endif
	 aAdd(_aAprov ,{" "," "," "," "," "," "," "," "," " } )
	
       
       oTelaRat := TDialog():New(aCoorden[7],000,aCoorden[6],aCoorden[5],OemToAnsi("Controle de Alçadas"),,,,,,,,oMainX,.T.)
	                                                                                  
	    TSay():New(015,001,{|| OemToAnsi("Solicitação")},oTelaRat,,,,,,.T.,,,oTelaRat:nWidth/2-5,10) 
	    @ 025,001 MsGet SC1->C1_NUM Picture "@!" Size 030,8 When .F. Of oTelaRat Pixel
	
	    TSay():New(015,040,{|| OemToAnsi("Solicitante")},oTelaRat,,,,,,.T.,,,oTelaRat:nWidth/2-5,10)                
	    @ 025,040 MsGet SC1->C1_SOLICIT Picture "@!" Size 113,8 When .F. Of oTelaRat Pixel
		
		@ 015,oTelaRat:nClientWidth/4-10 BITMAP RESOURCE "BR_VERMELHO_OCEAN" NO BORDER SIZE 08,08 ADJUST OF oTelaRat PIXEL
		@ 015,oTelaRat:nClientWidth/4+05 SAY "Aguardando Aprovação"          OF oTelaRat PIXEL

		@ 015,oTelaRat:nClientWidth/4+75 BITMAP RESOURCE "BR_AZUL_OCEAN"    NO BORDER SIZE 08,08 ADJUST OF oTelaRat PIXEL
		@ 015,oTelaRat:nClientWidth/4+85 SAY "Parado Nivel Superior"         OF oTelaRat PIXEL		

		@ 030,oTelaRat:nClientWidth/4-10 BITMAP RESOURCE "BR_VERDE_OCEAN"    NO BORDER SIZE 08,08 ADJUST OF oTelaRat PIXEL
		@ 030,oTelaRat:nClientWidth/4+05 SAY "Aprovado"                      OF oTelaRat PIXEL

		@ 030,oTelaRat:nClientWidth/4+75 BITMAP RESOURCE "BR_LARANJA_OCEAN"    NO BORDER SIZE 08,08 ADJUST OF oTelaRat PIXEL
		@ 030,oTelaRat:nClientWidth/4+85 SAY "Aprovado no Nivel"             OF oTelaRat PIXEL

		@ 030,oTelaRat:nClientWidth/4+145 BITMAP RESOURCE "BR_PRETO_OCEAN"    NO BORDER SIZE 08,08 ADJUST OF oTelaRat PIXEL
		@ 030,oTelaRat:nClientWidth/4+155 SAY "Rejeitado"                    OF oTelaRat PIXEL

		oFldRat1 := TFolder():New(040,001,{"Informacoes da Alçada"},,oTelaRat,,,,.T.,.T.,oTelaRat:nClientWidth/4-20,oTelaRat:nClientHeight/2.5)   
			@ 001,001 ListBox _oCustos VAR cOpcao Fields Header "Centro de Custo","Descrição","Status","Valor" Size oFldRat1:aDialogs[1]:nClientWidth/2-3,oFldRat1:aDialogs[1]:nClientHeight/2-5 PIXEL OF oFldRat1:aDialogs[1] //;

				_oCustos:bChange := {|| MsgRun("Analisando Aprovadores - Aguarde...",,{|| AtuFolder2(cNumPesq,_aCustos[_oCustos:nAt][1]) }) } 
				_oCustos:lHScroll 	  := .F.  
				_oCustos:lNoHScroll	  := .T.
				_oCustos:SetArray(_aCustos)
				_oCustos:bLine        := {||{ _aCustos[_oCustos:nAt][1]  ,;
											   _aCustos[_oCustos:nAt][2]  ,;
											   _aCustos[_oCustos:nAt][3]  ,;
											   _aCustos[_oCustos:nAt][4]  }}
			
		oFldRat2 := TFolder():New(040,oTelaRat:nClientWidth/4-10,{"Informações dos Aprovadores"},,oTelaRat,,,,.T.,.T.,oTelaRat:nClientWidth/4+5,oTelaRat:nClientHeight/2.5)   
			@ 001,001 ListBox _oAprov VAR cOpcao Fields ;
			          Header " ","Nível","Nome Aprovador","Hr. Entrada","Data Entrada","Hr.Saída","Data Saída","Justificativa" Size oFldRat2:aDialogs[1]:nClientWidth/2-3,oFldRat2:aDialogs[1]:nClientHeight/2-5 PIXEL OF oFldRat2:aDialogs[1] ;
	          On dblClick( Iif(!Empty(AllTrim(_aAprov[_oAprov:nAt][9])),MsgAlert("JUSTIFICATIVA:"+Chr(13)+Chr(10)+Chr(13)+Chr(10)+Msmm(_aAprov[_oAprov:nAt][8])),Nil) ) 
				
			    _oAprov:bChange := {||  MontaQuery(cNumPesq,2),_oCustos:Refresh(),AtuFolder2(cNumPesq,_aCustos[_oCustos:nAt][1]), _oAprov:Refresh()} 
				_oAprov:lHScroll 	:= .T.  
				_oAprov:lNoHScroll	:= .T.
				_oAprov:SetArray(_aAprov)
				_oAprov:bLine := {||{ IIF(_aAprov[_oAprov:nAt][1]=="1",oNApvdo, ;
				                        IIF(_aAprov[_oAprov:nAt][1]=="2",oApvdo,  ;
                                        IIF(_aAprov[_oAprov:nAt][1]=="5",oApvdoX, ;
                                        IIF(_aAprov[_oAprov:nAt][1]=="3",oRejeit,oNApvdoX ))) ),; //Semaforo
										   _aAprov[_oAprov:nAt][2],; 
										   _aAprov[_oAprov:nAt][3],; ////				                  Alltrim( _aAprov[_oAprov:nAt][4]),; 
										   _aAprov[_oAprov:nAt][5],; 
										   _aAprov[_oAprov:nAt][6],; 
										   _aAprov[_oAprov:nAt][7],; 
										   _aAprov[_oAprov:nAt][8],;
	                                       Iif(!Empty(AllTrim(_aAprov[_oAprov:nAt][9])),"Sim","Não") } }
		If Len(_aCustos)> 0 .And. lFirst
		   If !Empty(_aCustos[1][2])
		       AtuFolder2(cNumPesq,_aCustos[1][1])      
		       lFirst := .F.
		   Endif
		Endif       
	
	Activate MsDialog oTelaRat CENTERED On Init EnchoiceBar(oTelaRat,{||oTelaRat:End()},{||oTelaRat:End()},,) 
Endif

aRotina := aClone(aRotBkp)

If Select("XXX")>0
   DbSelectArea("XXX")
   DbCloseArea()
Endif   

RestArea(aAreaSZ2)
RestArea(aArea)
RestArea(aAreaSC1)

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AtuFolder2ºAutor  ³Sergio Celestino    º Data ³  15/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza o de acordo com bem selecinado                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Grupo Icatel                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtuFolder2(cNumSC1,cCCusto)

Local aAuxExp  := {}
Local aRpv     := {}
Local aApv     := {}

_aAprov :={}
DbSelectArea("ZZ6")
DbSetOrder(3)//FILIAL+NUMSC+CENTRO DE CUSTO + NIVEL 
DbGotop()
If MsSeek(xFilial("ZZ6") + cNumSC1 + cCCusto)
   While ZZ6->(!Eof()) .And. xFilial("ZZ6")+cNumSC1+Alltrim(cCCusto) == xFilial("ZZ6")+ZZ6->ZZ6_SC+Alltrim(ZZ6->ZZ6_CC)
      If lSolicita .And. ZZ6->ZZ6_TIPO == "C"
         ZZ6->(DbSkip())
         Loop
      Endif   
      DbSelectArea("ZZ5")
      DbSetOrder(4)//Aprovador + Centro de Custo
        If MsSeek(xFilial("ZZ5") + ZZ6->ZZ6_APROV + Alltrim(cCCusto) )
           If ZZ6->ZZ6_STATUS $ "1/3" //Aguardando Aprovação ou Rejeitado
              aAdd(aRpv,{Alltrim(ZZ6->ZZ6_NIVEL),Alltrim(cCCusto),Alltrim(ZZ6->ZZ6_STATUS),ZZ6->(Recno()),"1" })
           Else
              aAdd(aApv,{Alltrim(ZZ6->ZZ6_NIVEL),Alltrim(cCCusto),Alltrim(ZZ6->ZZ6_STATUS),ZZ6->(Recno()),"2" })
           Endif 
        Endif
      DbSelectArea("ZZ6")
      DbSkip()
   End
Endif
	   
If Len(aRpv) > 0
	nPosX := 0
	For nU := 1 To Len(aRpv)
	    nPosX := aScan(aApv,{|x| Alltrim(x[1])+Alltrim(x[2]) == ;
	                              Alltrim(aRpv[nU][1])+Alltrim(aRpv[nU][2]) } ) //Caso Encontre ja foi aprovado no mesmo nivel
        DbSelectArea("ZZ6")
        DbGoto(aRpv[nU][4])
        aAdd(aAuxExp,{   IIF(nPosX==0,aRpv[nU][3],"5") ,;//Ja aprovado no mesmo Nivel
                          ZZ6->ZZ6_NIVEL        ,;
                          Posicione("SAK",1,xFilial("SAK") + ZZ6->ZZ6_APROV ,"AK_NOME" ),;
                          ZZ6->ZZ6_STATUS       ,;
                          ZZ6->ZZ6_HRENT        ,;
                          ZZ6->ZZ6_DTENT        ,;
                          ZZ6->ZZ6_HRSAI        ,;
                          ZZ6->ZZ6_DTSAI        ,;
                          ZZ6->ZZ6_MEMO1        })
    Next                         
Endif                             

If Len(aApv)>0
   For nCnt := 1 To Len(aApv)
   DbSelectArea("ZZ6")
   DbGoto(aApv[nCnt][4])
   aAdd(aAuxExp,{    Alltrim(aApv[nCnt][3]) ,;
                     ZZ6->ZZ6_NIVEL          ,;
                     Posicione("SAK",1,xFilial("SAK") + ZZ6->ZZ6_APROV ,"AK_NOME" ),;
                     ZZ6->ZZ6_STATUS         ,;
                     ZZ6->ZZ6_HRENT          ,;
                     ZZ6->ZZ6_DTENT          ,;
                     ZZ6->ZZ6_HRSAI          ,;
                     ZZ6->ZZ6_DTSAI          ,;
                     ZZ6->ZZ6_MEMO1          })
   Next
Endif

If Len(aAuxExp)==0
 aAdd(aAuxExp ,{" "," "," "," "," "," "," "," "," " } )
Else
  aAuxExp :=  aSort(aAuxExp,,,{|x,y| x[2] < y[2] })
Endif 

_aAprov:= aAuxExp
_oAprov:aArray:=_aAprov
_oAprov:Refresh()

Return(Nil)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaQueryºAutor  ³Sergio Celestino    º Data ³  04/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gerar volume de dados da Alcada de Aprovacao das SCs        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Time For Fun                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MontaQuery(cNumSC1,nTipo)

Local cQuery := ""

_aCustos := {}

cQuery += " SELECT Z2_NUMSC AS C1_NUM,Z2_CC AS C1_CC,CTT_DESC01,SUM(Z2_VALOR) AS VALOR "
cQuery += " FROM "+RetSqlName("SZ2")+" SZ2 "
cQuery += " INNER JOIN CTT080 CTT ON CTT_CUSTO = Z2_CC AND CTT.D_E_L_E_T_ = ' ' "
cQuery += " WHERE Z2_NUMSC = '"+cNumSC1+"' AND SZ2.D_E_L_E_T_ = ' ' AND SZ2.Z2_FILIAL = '"+xFilial("SZ2")+"' "
If lSolicita
  cQuery += " AND SZ2.Z2_TIPO = 'S' "
Else
  cQuery += " AND SZ2.Z2_TIPO = 'C' "
Endif  
cQuery += " GROUP BY Z2_NUMSC,Z2_CC,CTT_DESC01 "

cQuery := ChangeQuery(cQuery)

If Select("XXX") > 0
   DbSelectArea("XXX")
   DbCloseArea()
Endif

TcQuery cQuery New Alias "XXX"

DbSelectArea("XXX")
DbGotop()

If XXX->(Eof())
   
   DbSelectArea("XXX")
   DbCloseArea()
   
   If lSolicita
	   cQuery := ""
	   cQuery += " SELECT C1_NUM,C1_CC,CTT_DESC01,SUM(C1_QUANT*C1_VUNIT) AS VALOR "
	   cQuery += " FROM "+RetSqlName("SC1")+" SC1 "
	   cQuery += " INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_CUSTO = C1_CC AND CTT.D_E_L_E_T_ = ' ' "
	   cQuery += " WHERE C1_NUM = '"+cNumSC1+"' "
	   cQuery += " GROUP BY C1_NUM,C1_CC,CTT_DESC01 "
   Else
	   cQuery := ""
	   cQuery += " SELECT C3_NUM AS C1_NUM,C3_CC AS C1_CC,CTT_DESC01,SUM(C3_QUANT*C3_PRECO) AS VALOR "
	   cQuery += " FROM "+RetSqlName("SC3")+" SC3 "
	   cQuery += " INNER JOIN "+RetSqlName("CTT")+" CTT ON CTT_CUSTO = C3_CC AND CTT.D_E_L_E_T_ = ' ' "
	   cQuery += " WHERE C3_NUM = '"+cNumSC1+"' "
	   cQuery += " GROUP BY C3_NUM,C3_CC,CTT_DESC01 "   
   Endif
   
   If Select("XXX") > 0
      DbSelectArea("XXX")
      DbCloseArea()
   Endif

   TcQuery cQuery New Alias "XXX"
  
Endif   

DbSelectArea("XXX")
DbGotop()
While XXX->(!Eof())

  aAdd(_aCustos,{Alltrim(XXX->C1_CC),Alltrim(XXX->CTT_DESC01),IIF(VerApv(cNumSC1,XXX->C1_CC),"Pendente","Aprovado") , Alltrim(Transform(XXX->VALOR,"@E 999,999,999.99")) })

  DbSelectArea("XXX")
  DbSkip()
End  

If Len(_aCustos)==0
  aAdd(_aCustos ,{" "," "," "," "} )
Endif

XXX->(dBCloseArea())

If nTipo == 2
_oCustos:aArray:=_aCustos
_oCustos:Refresh()
Endif

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VerApv    ºAutor  ³Sergio Celestino    º Data ³  04/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verificar Status do Centro de Custo na Alcada               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Intermed                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VerApv(cNumSC1,cCusto)

Local lPend    := .F.
Local aApv     := {}
Local aRpv     := {}
Local aArea    := GetArea()
Local aAreaZZ6 := ZZ6->(GetArea())
Local nCntX    := 0
Local nCntY    := 0

DbSelectArea("ZZ6")
DbSetOrder(3)//FILIAL+NUMSC+CENTRO DE CUSTO + NIVEL 
DbGotop()
If MsSeek(xFilial("ZZ6") + cNumSC1 + cCusto + cTipo )
   While ZZ6->(!Eof()) .And. xFilial("ZZ6")+cNumSC1+cCusto == xFilial("ZZ6")+ZZ6->ZZ6_SC+ZZ6->ZZ6_CC
      DbSelectArea("ZZ5")
      DbSetOrder(4)//Aprovador + Centro de Custo
        If MsSeek(xFilial("ZZ5") + ZZ6->ZZ6_APROV + cCusto )
           If ZZ6->ZZ6_STATUS == "1"
              aAdd(aRpv,{Alltrim(ZZ6->ZZ6_NIVEL),Alltrim(cCusto),ZZ6->(Recno()),.T. })
           Else
              aAdd(aApv,{Alltrim(ZZ6->ZZ6_NIVEL),Alltrim(cCusto),ZZ6->(Recno()),.T. })
           Endif   
      Endif
      DbSelectArea("ZZ6")
      DbSkip()
   End
Endif      

If Len(aRpv) > 0
	nCntX := 0
	For nU := 1 To Len(aRpv)
	    nCntX := aScan(aApv,{|x| x[1]+x[2] == aRpv[nU][1]+aRpv[nU][2] } ) //Caso Encontre ja foi aprovado no mesmo nivel
	    If nCntX > 0
	       aRpv[nU][4] := .F.
	    Endif
	Next    
	
	nCntY := aScan(aRpv,{|x| x[4] == .T. } ) //Caso Encontre existem pendencia no centro de custo
	If nCntY > 0
	   lPend := .T.
	Endif   
Endif

RestArea(aAreaZZ6)
RestArea(aArea)

Return lPend