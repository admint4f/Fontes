#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"

#DEFINE CRLF (chr(13)+chr(10))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT235G2   �Autor  �Sergio Celestino    � Data �  19/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Enviar e-mail ao solicitante quando ocorrer cancelamento   ���
���          �via elemina��o por residuo (Ponto de Entrada)               ���
�������������������������������������������������������������������������͹��
���Uso       � T4F                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT235G2


_cUsuario 	:= PswRet()[1][2]
_NomeUsr	:= Substr(cUsuario,7,15)
cTUsuar := sc7->c7_usuario 
if trim(_NomeUsr)<>trim(cTUsuar)
Aviso('Aten��o','O Pedido de compras '+sc7->c7_num+" Item "+sc7->c7_item+' foi criado pelo usu�rio'+ CRLF + cTUsuar + CRLF +;
 'Somente o respons�vel pelo pedido de compras pode efetuar a limpeza do res�duo.'+ CRLF +;
 'Em caso de aus�ncia ou por n�o fazer mais parte do quadro de funcion�rios, procure o suporte protheus.',{'Ok'})
Return .f.
Endif
RecLock("SC7")
sc7->C7_XUSRRES := Substr(cUsuario,7,15) //PswRet()[1][2]//_NomeUsr
sc7->C7_XDTRESI := date()
MsUnLock()

RETURN

User Function MA235PC

Local ExpL1 := .T.
If !MsgBox(OEMTOANSI('Somente o respons�vel pelo pedido de compras pode efetuar a limpeza do res�duo.'+ CRLF +;
'Em caso de aus�ncia ou por n�o fazer mais parte do quadro de funcion�rios, procure o suporte protheus.'+ CRLF +;
'Deseja continuar ?'),"Atencao","YESNO")
 ExpL1 := .f.
Endif
//Aviso('Aten��o', 'Somente o criador do pedido de compras pode efetuar a limpeza do res�duo.'+ CRLF +;
 //'Em caso do criador n�o fazer mais parte do quadro de funcion�rios, procure o suporte protheus.',{'Ok'})

Return(ExpL1)


/*
Local _cSUBJECT:="[T4F-Suprimentos] Cancelamento de Solicita��o de compras (Residuo) "
Local cTxtEmail:=""
Local _aFiles:=array(1)
Local oDlg
Local cDestEmail := ""
Local lRes := .F.
Local xAlias := "SC1" // Paramixb[1] Alterado Luis Dantas 06/08/12
Static cNumScBkp := ""

DbSelectArea(xAlias)
cNumSC := (xAlias)->C1_NUM

If cNumScBkp <> cNumSC
	cQuery := "SELECT * FROM "+RetSqlName("SC1")+" WHERE C1_NUM = '"+cNumSC+"' AND D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)
	
	If Select("TEMP") > 0
	   DbSelectArea("TEMP")
	   DbCloseArea()
	Endif
	   
	dbusearea( .T. ,"TOPCONN",TCGenQry(,,cQuery),"TEMP", .F. , .T. )
	
	DbSelectArea("TEMP")
	DbGotop()
	
	__cSolicit := TEMP->C1_USER
	
	While !Eof() .And. TEMP->C1_NUM == cNumSC
	   
	  //��������������������������������������������������������������Ŀ
	  //� Calcular o Residuo maximo da Compra.                         �
	  //����������������������������������������������������������������	
	  nRes := (TEMP->C1_QUANT * mv_par01)/100
	
	  //��������������������������������������������������������������Ŀ
	  //� Verifica se a Autorizacao deve ser Encerrada                 �
	  //����������������������������������������������������������������			
	  If (TEMP->C1_QUANT - TEMP->C1_QUJE <= nRes .And. TEMP->C1_QUANT > TEMP->C1_QUJE)
	     cTxtEmail+="Nr. Solicita��o: "+TEMP->C1_NUM+" Item: "+TEMP->C1_ITEM+" Usuario Canc.: "+Alltrim(Substr(cUsuario,7,15)) + CRLF
	     lRes := .T.
	  Endif  
	   
	   DbSelectArea("TEMP") 
	   DbSkip()
	End  
	
	If lRes
		PswOrder(1)
		IF PswSeek(__cSolicit, .T. )
		   If PSWRET(1)[1][17]  //Caso o Usuario esteja bloqueado
		      cDestEmail := GetMv("MV_XMAILRE",,"teste@teste.com.br")
		   Else   
		      cDestEmail := PSWRET(1)[1][14]
		   Endif   
		Endif
	    U_EnvEmail(cDestEmail,_cSUBJECT,cTxtEmail,_aFiles,.F.,oDlg)		// Envia email informando ao solicitante que a solicitacao de compras foi cancelada.
	Endif
Endif

cNumSCBkp := cNumSC

Return .T.

user function MA235PC()

Local ExpL1 := .T.//Valida��es do usu�rio.

_cUsuario 	:= PswRet()[1][2]
_NomeUsr	:= Substr(cUsuario,7,15)
cTUsuar := sc7->c7_usuario 
Aviso('Aten��o','MA235PC'+ CRLF + _NomeUsr + CRLF + cTUsuar + CRLF + sc7->c7_num,{'Ok'})

Return ExpL1


