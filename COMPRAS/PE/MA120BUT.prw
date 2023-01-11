#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

#DEFINE CRLF (chr(13)+chr(10))

Static aRateioCC  := {}
Static aColsAux   := {}

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MA120BUT �Autor  �Bruno Daniel Borges � Data �  19/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada de inclusao de botoes de usuario na tela   ���
���          �de Pedido de Compra/Autorizacao de Entrega                  ���
�������������������������������������������������������������������������͹��
���Alteracoes�Adicionado a Linha 28 para que o usuario possa anexar       ���
���          �documentos no PC - Sergio Celestino                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA120BUT()                                                                                        
Local aRetorno := {}
Local aArea    := GetArea()
Local aAreaSC3 := SC3->(GetArea())                                       
Local aAreaSZ2 := SZ2->(GetArea())
     
//Apenas via Autorizacao de Entrega
If nTipoPed == 2
	Aadd(aRetorno,{"SOLICITA"	,{|| U_RCOMA110()                  }	,"Solicita��o de Compras do Contrato"                   ,"Solicita��o"  })
    Aadd(aRetorno,{"S4WB013N"   ,{|| U_Rateio_CC() 	                }	,"Rateio entre v�rios centros de custo deste Contrato." ,"Rateio"       }) 
Else
    Aadd(aRetorno,{"CLIPS"		,{|| u_Anexa_Documento(cA120Num)	}	,"Anexar documentos ao Pedido de compras"               ,"Anexo"        })       
EndIf

//Busca o rateio do Contrato de Parceria
dbSelectArea("SZ2")
SZ2->(dbSetOrder(2))
SZ2->(dbSeek(xFilial("SZ2")+SC7->C7_NUM))
While SZ2->(!Eof()) .And. SZ2->Z2_FILIAL + SZ2->Z2__SC1 == xFilial("SZ2")+SC7->C7_NUM
	If ALLTRIM(SZ2->Z2_TIPO) == "C"
		AAdd(aRateioCC,{	SZ2->Z2_ITEM,;
		SZ2->Z2_PERC,;
		SZ2->Z2_CONTA,;
		SZ2->Z2_ITEMCTA,;
		SZ2->Z2_CLVL,;
		SZ2->Z2_CC ,;
		SZ2->Z2_VALOR,;
 	    SZ2->Z2_ITEMSC })
	Endif    
    SZ2->(dbSkip())
EndDo

RestArea( aArea )
RestArea( aAreaSC3 )
RestArea( aAreaSZ2 )

Return(aRetorno)    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120GRV  �Autor  �Sergio Celestino    � Data �  19/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada para Enviar e-mail ao responsavel da       ���
���          �solicitacao de compras na inclusao do pedido                ���
���          �Gravacao da Alcada do Contrato de Parceria.                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
User Function MT120GRV 
//Execblock("MT120GRV",.F.,.F.,{cA120Num,l120Inclui,l120Altera,l120Deleta })

Local cPedido    := CA120NUM 
Local aHeaderBkp := aHeader
Local aColsBkp   := aCols
Local _cSUBJECT  := "[T4F-Suprimentos] Inclus�o de Pedido de Compras "+cPedido
Local cDestEmail := ""
Local cTxtEmail  := ""
Local aArea	     := GetArea()
Local aVetor     := {}
Local _aFiles    := Array(1)
Local oDlg

nPos_Prod := AScan(aHeaderBkp, { |x| Upper(Alltrim(x[2])) == 'C7_PRODUTO'})
nPos_nSc  := AScan(aHeaderBkp, { |x| Upper(Alltrim(x[2])) == 'C7_NUMSC'  })
nPos_Item := AScan(aHeaderBkp, { |x| Upper(Alltrim(x[2])) == 'C7_ITEMSC' })
nPos_Quant:= AScan(aHeaderBkp, { |x| Upper(Alltrim(x[2])) == 'C7_QUANT'  })

If INCLUI

	For nY := 1 To Len(aColsBkp)
	  
	  If !aColsBkp[nY][Len(aHeaderBkp)+1]
	  
		  cProd   := aColsBkp[nY][nPos_Prod ]  // Produto
		  cNumSc  := aColsBkp[nY][nPos_nSc  ]  // Numero da SC
		  cItemSc := aColsBkp[nY][nPos_Item ]  // Item da SC
	      nQuant  := aColsBkp[nY][nPos_Quant]  // Quantidade do PC
	
		  DbSelectArea("SC1")
		  DbSetOrder(2)
		  If DbSeek(xFilial("SC1") + cProd + cNumSc + cItemSc )//Filial + Produto + SC + Item + Fornecedor + Loja
		     aAdd(aVetor, {cPedido,cNumSc,cItemSc,cProd,nQuant,SC1->C1_USER,SC1->C1_SOLICIT,SC1->C1_QUANT} )
		  Else
		     aAdd(aVetor, {cPedido,cNumSc,cItemSc,cProd,nQuant,"000000","Administrador",1} )
		  Endif   		     
	  Endif
	Next 

Endif

If Len(aVetor) > 0
	ASort(aVetor,,,{|x,y| x[6] < y[6] })//Ordenar Vetor pelo solicitante
	
	__cUser := aVetor[1][6]
	For nY := 1 To Len(aVetor)
	
	    If __cUser <> aVetor[nY][6]
	     	    PswOrder(1)
			    IF PswSeek( __cUser, .T. )
			       If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
			          cDestEmail := GetMv("MV_XMAILRE",,"microsiga01.t4f.com.br")
			       Else   
			          cDestEmail := PSWRET(1)[1][14]
			       Endif   
			    Endif
		    U_EnvEmail(cDestEmail,_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao solicitante que a solicitacao de compras foi cancelada.
		  __cUser := aVetor[nY][6]
		Else
		  cTxtEmail += "Pedido: "+cPedido+" Solicita��o: "+Alltrim(aVetor[nY][2])+" Item SC: "+Alltrim(aVetor[nY][3])+" Produto: "+Alltrim(aVetor[nY][4])+" Qtd. SC: "+Alltrim(Str(aVetor[nY][8]))+" Qtd. PC: "+Alltrim(Str(aVetor[nY][5])) + CRLF
		Endif
	    
	   If nY == Len(aVetor)
	      PswOrder(1)
		  IF PswSeek( __cUser, .T. )
		      If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
		         cDestEmail := GetMv("MV_XMAILRE",,"microsiga01.t4f.com.br")
		      Else   
		         cDestEmail := PSWRET(1)[1][14]
		      Endif   
		   Endif
	       U_EnvEmail(cDestEmail,_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao solicitante que a solicitacao de compras foi cancelada.
	   Endif   
	Next
Endif

If Inclui .Or. Altera
   If Alltrim(Upper(FunName(0))) == "MATA122"
	    aAreaSC3:=SC3->(GetArea())
	    For nY := 1 To Len(aColsBkp)
	       If !aColsBkp[nY][Len(aHeaderBkp)+1]
	           	 cNumSc  := aColsBkp[nY][nPos_nSc  ]  // Numero da SC
		         cItemSc := aColsBkp[nY][nPos_Item ]  // Item da SC
               DbSelectArea("SC3")
               DbSetOrder(1)
               If MsSeek(xFilial("SC3")+ cNumSc + cItemSc )
                  Reclock("SC3",.F.)
                  SC3->C3_T4FPEDI := CA120NUM
               Endif
            Endif
         Next         
	     RestArea(aAreaSC3)
	     /*
	     dbSelectArea("ZZ6")
	     ZZ6->(dbSetOrder(4))
	     ZZ6->(dbSeek(xFilial("ZZ6")+SC7->C7_NUM+"C" ))
	     While ZZ6->(!Eof()) .And. ZZ6->ZZ6_FILIAL + ZZ6->ZZ6_SC+ZZ6->ZZ6_TIPO == xFilial("ZZ6")+SC7->C7_NUM+"C"
		  ZZ6->(RecLock("ZZ6",.F.))
		  ZZ6->(dbDelete())
		  ZZ6->(MsUnlock())
		  ZZ6->(dbSkip())
	     EndDo
	     LJMsgRun("Gerando Al�ada de Aprova��o","Aguarde",{|| U_Gera_Alcada_SC(CA120NUM,SC7->C7_CC,.T.) })
	     
   Endif	
Endif
/*

If !Inclui .And. !Altera
  If Alltrim(Upper(FunName(0))) == "MATA122"
    LJMsgRun("Estornando Al�ada de Aprova��o","Aguarde",{|| U_Estorna_Alcada_SC(CA120NUM) })
  Endif  
Endif 
*/
//RestArea(aArea)

//Return .T.