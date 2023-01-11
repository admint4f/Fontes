#Include "Protheus.ch"
#Include "Topconn.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "APWEBSRV.CH"        
#Define ENTER Chr(13)+Chr(10)
Static nHdl
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTEMP01   ³ Autor ³ Michel Sales - Wikitec ³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Programa temporario para envio de notas e retorno fiscais  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±º========================================================================º±± 
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß      
*/
User Function RTEMP01
Local aPerg       := {}
Local aIndArq     := {}
Local aCores      := {}

Private cCondicao := ""
Private aRotina   := MenuDef()
Private cTmpGer	:= ALLTRIM(SuperGetMv("DS_TMPGER",,"C:\NFTS\REMESSA\")) 

aadd(aPerg,{2,"Tipo NF",PadR("",Len("2-Entrada")),{/*"1-Saída",*/"2-Entrada"},120,".T.",.T.,".T."}) //"Tipo de NFe"###"1-Saída"###"2-Entrada"
aadd(aPerg,{2,"Filtra",PadR("",Len("5-Não Transmitidas")),{"1-Autorizadas","2-Sem filtro","3-Não Autorizadas","4-Transmitidas","5-Não Transmitidas"},120,".T.",.T.,".T."}) 
aadd(aPerg,{1,"Serie",PadR("",Len(SF2->F2_SERIE)),"",".T.","",".T.",30,.F.})	

aCores    := {{"F1_FIMP==' '",'DISABLE' },;	//NF não transmitida
			{"F1_FIMP=='S'",'ENABLE'},;			//NF Autorizada
			{"F1_FIMP=='T'",'BR_AZUL'},;		//NF Transmitida
			{"F1_FIMP=='D'",'BR_CINZA'},;		//NF Uso Denegado
			{"F1_FIMP=='N'",'BR_PRETO'}}		//NF nao autorizada 
/*
cCondicao := "F2_FILIAL=='"+xFilial("SF2")+"'"
If !Empty(MV_PAR03)
	cCondicao += ".AND.F2_SERIE=='"+MV_PAR03+"'"
EndIf
If SubStr(MV_PAR02,1,1) == "2" 			//"1-NF Autorizada"
	cCondicao += ".AND. F2_FIMP$'S' "
ElseIf SubStr(MV_PAR02,1,1) == "3" 		//"3-Não Autorizadas"
	cCondicao += ".AND. F2_FIMP$'N' "
ElseIf SubStr(MV_PAR02,1,1) == "4" 		//"4-Transmitidas"
	cCondicao +=  ".AND. F2_FIMP$'T' "
ElseIf SubStr(MV_PAR02,1,1) == "5" 		//"5-Não Transmitidas"
	cCondicao += ".AND. F2_FIMP$' ' " 			
EndIf

//	cCondicao += ".AND. F2_ESPECIE$'"+AllTrim(cTipoNfd)+"'"
	
bFiltraBrw := {|| FilBrowse("SF2",@aIndArq,@cCondicao) }
Eval(bFiltraBrw)
*/
mBrowse( 6, 1,22,75,"SF1",,,,,,aCores,/*cTopFun*/,/*cBotFun*/,/*nFreeze*/,/*bParBloco*/,/*lNoTopFilter*/,.F.,.F.,)
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a integridade da rotina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
RetIndex("SF2")
dbClearFilter()
aEval(aIndArq,{|x| Ferase(x[1]+OrdBagExt())})					
Return		

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTEMP01Rem³ Autor ³ Michel Sales - Wikitec  ³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Programa temporario para envio de notas fiscais			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTEMP01Rem
Local aArea		:= GetArea()
Local aPerg		:= {}   
Local aParam	:= {}

Local cAlias	:= "SF2"
Local cParTrans	:= SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Rem"
Local cCodMun	:= SM0->M0_CODMUN
Local cNotasOk	:= ""
Local cForca	:= ""            
Local cDEST		:= Space(10)
Local cMensRet	:= "" 
Local cWhen 	:= ".T."
Local dDataIni	:= CToD('  /  /  ')
Local dDataFim  := CToD('  /  /  ')
LOCAL dData	 := Date()

Local lObrig	:= .T.

Local nForca	:= 1


cAlias	:= "SF1"                                                                                        
aParam	:= {Space(Len(SF1->F1_SERIE)),Space(Len(SF1->F1_DOC)),Space(Len(SF1->F1_DOC)),"",1,dData,dData}

MV_PAR01:=cSerie   := aParam[01] := PadR(ParamLoad(cParTrans,aPerg,1,aParam[01]),Len(SF2->F2_SERIE))
MV_PAR02:=cNotaini := aParam[02] := PadR(ParamLoad(cParTrans,aPerg,2,aParam[02]),Len(SF2->F2_DOC))
MV_PAR03:=cNotaFim := aParam[03] := PadR(ParamLoad(cParTrans,aPerg,3,aParam[03]),Len(SF2->F2_DOC))
MV_PAR05:=""
MV_PAR06:= dData
MV_PAR07:= dData
//Montagem das perguntas
aadd(aPerg,{1,"Serie da Nota Fiscal",aParam[01],"",".T.","",".T.",30,.F.})	//"Serie da Nota Fiscal"
aadd(aPerg,{1,"Nota fiscal inicial",aParam[02],"",".T.","",".T.",30,.T.})	//"Nota fiscal inicial"
aadd(aPerg,{1,"Nota fiscal final",aParam[03],"",".T.","",".T.",30,.T.}) 	//"Nota fiscal final"

//Geracao XML Arquivo Fisico
MV_PAR04:= cDEST := aParam[04] := PadR(ParamLoad(cParTrans,aPerg,4,aParam[04]),10)
  
MV_PAR05:= nForca := aParam[05] := PadR(ParamLoad(cParTrans,aPerg,5,aParam[05]),1) 
aadd(aPerg,{1,"Nome arquivo",aParam[04],"",".T.","",cWhen,40,lObrig})					//"Nome do arquivo XML Gerado"
aadd(aPerg,{2,"Força Transmissão",aParam[05],{"1-Sim","2-Não"},40,"",.T.,""})  		//"Força Transmissão"
	
MV_PAR06:=  dDataIni:= aParam[06] := ParamLoad(cParTrans,aPerg,6,aParam[06]) 
MV_PAR07:=  dDataFim:= aParam[07] := ParamLoad(cParTrans,aPerg,5,aParam[07])
aadd(aPerg,{1,"Data de",aParam[06],"",".T.","",".T.",50,.F.})			//"Data de:"
aadd(aPerg,{1,"Data ate",aParam[07],"",".T.","","",50,.F.})  		//"Data ate:"

//Verifica se o serviço foi configurado - Somente o Adm pode configurar
If ParamBox(aPerg,"Transmissão NFS-e",,,,,,,,cParTrans,.T.,.T.)    
	
	MV_PAR05 := Val(Substr(MV_PAR05,1,1))
	Processa( {|| geraArqLot(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR04,@cNotasOk,MV_PAR06,MV_PAR07,@cTmpGer)}, "Aguarde...","(1/2) Verificando dados...", .T. )
	If Empty(cNotasOk) 	
		Aviso("NFS-e","Nenhuma nota foi transmitida."+CRLF+cMensRet,{"Retornar"},3)
	Else
		Aviso("NFS-e","Arquivos Gerados na pasta:"+AllTrim(cTmpGer)+CRLF+ cNotasOk,{"Retornar"},3) //
	EndIf
Endif

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ geraArqLot| Autor ³ Michel Sales - Wikitec  ³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Gera o arquivo texto									   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function geraArqLot(cSerie,cNotaIni,cNotaFim,cNomeArq,cNotasOk,dDataIni,dDataFim,cTmpGer)
Local cHeader   := ""
Local cDadosNF  := ""
Local cFooter   := ""
Local aArea     := GetArea()  
Local aNtXml	:= {}
Local aNotas    := {}
Local aRetNotas := {}
Local aXml      := {}

Local cRetorno  := ""
Local cAliasSF3 := "SF3"
Local cWhere    := ""
Local cErro     := "" 
Local cNtXml	:= ""  
Local cNfd      := ""
Local cNfdEntRet:= ""    
Local cCodTes   := GetMv("DS_TESNFT",,"041,")
Local cHoraIni  := Time()
Local cSerieIni := cSerie
Local cSerieFim := cSerie
Local cCodMunPr := ""
Local cCodEstPr := ""                              
Local cTmpImp	:= ALLTRIM(SuperGetMv("DS_TMPIMP",,"C:\NFTS\REMESSA\"))

Local dDtxml	:= Date()

Local lForca    := .T.
Local lOk       := .F.
Local lReproc	:= .F.
Local lRemessa	:= .F. 
Local lQuery    := .F.
Local lRetorno  := .T.
Local lGeraEnt	:= .T.
Local nIt		:= 0
Local nX        := 0
Local nY        := 0
Local nNFes     := 0
Local nXmlSize  := 0
Local nTotVal   := 0
Local nTotDed   := 0
Local nW    

Private oRetorno
Private oWs

//Tratamento para chamada da rotina automatica(autonfse001)
If(type("cEntSai") == "U",cEntSai:="1","")
//If(Type("cIdEnt")=="U",cIdEnt:=GetIdEnt(),"") 
//If(Type("cUrl") =="U",cUrl:=Padr(GetNewPar("MV_SPEDURL","http://localhost:8080/nfse"),250),"") 

ProcRegua(0)

dbSelectArea("SA2")
SA2->(dbSetOrder(1)) //A2_FILIAL+A2_COD+A2_LOJA

dbSelectArea("SF1")
SF1->(dbSetOrder(1)) //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

dbSelectArea("SD1")
SD1->(dbSetOrder(1)) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

dbSelectArea("SB1")
SB1->(dbSetOrder(1)) //B1_FILIAL + B1_C0D

//Restaura a integridade da rotina caso exista filtro
//dbSelectArea(cAlias)
//dbClearFilter()
//RetIndex(cAlias)

ProcRegua(Val(cNotaIni)-Val(cNotaFim)+1)
dbSelectArea("SF3")
dbSetOrder(5)

#IFDEF TOP
	//If cEntSai == "1"
	//	cWhere := "%(SubStr(SF3.F3_CFO,1,1) >= '5')%"
		
		//tratamento para transmissao automatica
		//If lauto						
		//	cWhere:=Substr(cWhere,1,Len(cWhere)-1)
		//	cWhere+=" AND ((SELECT F2_FIMP FROM "+RetSqlName("SF2")+ " WHERE F2_DOC=F3_NFISCAL AND F2_SERIE=F3_SERIE AND F2_CLIENTE=F3_CLIEFOR AND F2_LOJA=F3_LOJA AND D_E_L_E_T_='' AND F2_FILIAL='"+xFilial("SF3")+"') NOT IN('T','S') )%"
		//EndIf	
	//ElseIF cEntSai == "0"
		cWhere := "%"
		cWhere += "(SubStr(SF3.F3_CFO,1,1) < '5') "
		cWhere += " AND ((SELECT F1_FIMP "
		cWhere += " 		FROM "+RetSqlName("SF1")+ " 
		cWhere += " 		WHERE F1_FILIAL='"+xFilial("SF3")+"' "    
		cWhere += " 		AND F1_DOC = F3_NFISCAL "
		cWhere += " 		AND F1_SERIE = F3_SERIE "
		cWhere += " 		AND F1_FORNECE = F3_CLIEFOR "
		cWhere += " 		AND F1_LOJA = F3_LOJA "
		cWhere += " 		AND F3_ESPECIE = 'NFS' "		
		cWhere += " 		AND D_E_L_E_T_=' ' "
		cWhere += " 		) NOT IN('S') )" //Autorizados!
                                                                                        

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³03/10/2013								   ³
		//³--> Adicionado filtro para excluir o municipio de Sao Paulo  		   ³					  					  		   
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Bloco de exclusao de Municipios			  					  		   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cWhere += " AND ((SELECT A2_COD_MUN "
		cWhere += " 		FROM "+RetSqlName("SA2")+ " 
		cWhere += " 		WHERE A2_COD = F3_CLIEFOR " 
		cWhere += " 		AND A2_LOJA = F3_LOJA "
		cWhere += " 		AND D_E_L_E_T_=' ' "         
		cWhere += " 		) NOT IN('50308') )"
		
/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Bloco de exclusao de tipos de TES									   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cWhere += " AND EXISTS (SELECT 1 "
		cWhere += " 		FROM "+RetSqlName("SD1")+ " 
		cWhere += " 		WHERE D1_FILIAL = '"+xFilial("SF3")+"' " 
		cWhere += " 		AND D1_DOC = F3_NFISCAL "
		cWhere += " 		AND D1_SERIE = F3_SERIE "
		cWhere += " 		AND D1_FORNECE = F3_CLIEFOR "
		cWhere += " 		AND D1_LOJA = F3_LOJA "
		cWhere += " 		AND D1_TES NOT IN('041')" 
		cWhere += " 		AND D_E_L_E_T_=' ') "
*/
		
		If ( !Empty( dDataIni ) .And. !Empty( dDataFim ) )
			cWhere += " And ( SF3.F3_ENTRADA >= '"+Dtos(dDataIni)+"' And SF3.F3_ENTRADA <= '"+Dtos(dDataFim)+"' And SF3.F3_CODISS<>' ')"
		EndIf                                        
		cWhere += "%"
		If ( Empty( cSerie ) ) 		
			cSerieIni :=  "   "
			cSerieFim :=  "ZZZ"
		EndIf
	//EndiF	
	//cWhere := "%((SubString(SF3.F3_CFO,1,1) < '5') OR (SubString(SF3.F3_CFO,1,1) >= '5'))%"
	cAliasSF3 := GetNextAlias()
	lQuery    := .T.
	BeginSql Alias cAliasSF3
		
	COLUMN F3_ENTRADA AS DATE
	COLUMN F3_DTCANC AS DATE
				
	SELECT	F3_FILIAL,F3_ENTRADA,F3_NFELETR,F3_CFO,F3_FORMUL,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_LOJA,F3_ESPECIE,F3_DTCANC,F3_CODNFE,F3_TIPO,F3_VALCONT,F3_CODISS
		
			FROM %Table:SF3% SF3
			WHERE
			SF3.F3_FILIAL = %xFilial:SF3% AND
			SF3.F3_SERIE >= %Exp:cSerieIni% AND 
			SF3.F3_SERIE <= %Exp:cSerieFim% AND 
			SF3.F3_NFISCAL >= %Exp:cNotaIni% AND 
			SF3.F3_NFISCAL <= %Exp:cNotaFim% AND 
			%Exp:cWhere% AND 
			SF3.F3_DTCANC = %Exp:Space(8)% AND 
			SF3.%notdel%
	EndSql
	cWhere := ".T."	
#ELSE
	MsSeek(xFilial("SF3")+cSerie+cNotaIni,.T.)
#ENDIF
If cEntSai == "1"
	cWhere := "(SubStr(F3_CFO,1,1) >= '5')"
ElseIF cEntSai == "0"
	cWhere := "(SubStr(F3_CFO,1,1) < '5')"
EndiF	

cHeader  := "1001"+AllTrim(SM0->M0_INSCM)+DtoS(dDataIni)+DtoS(dDataFim) + chr(13) + chr(10)

While !Eof() .And. xFilial("SF3") == (cAliasSF3)->F3_FILIAL .And.;
	(cAliasSF3)->F3_SERIE >= cSerieIni .And.;
	(cAliasSF3)->F3_SERIE <= cSerieFim .And.;
	(cAliasSF3)->F3_NFISCAL >= cNotaIni .And.;
	(cAliasSF3)->F3_NFISCAL <= cNotaFim

	If SF1->(dbSeek(xFilial("SF1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))	 //F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
		If SD1->(dbSeek(xFilial("SD1")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))	 //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
			SA2->(dbSeek(xFilial("SA2")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA)) //A2_FILIAL+A2_COD+A2_LOJA
			If SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
		
				dbSelectArea(cAliasSF3)
				If (SubStr((cAliasSF3)->F3_CFO,1,1)>="5" .Or. SubStr((cAliasSF3)->F3_CFO,1,1)<"5") .And. aScan(aNotas,{|x| x[3]+x[4]==(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL})==0
					nIt++
					IncProc("(1/2) "+"Preparando nota: "+(cAliasSF3)->F3_NFISCAL) //"Preparando nota: "
					If Empty((cAliasSF3)->F3_DTCANC)
					    cNotasOk += Pad(Alltrim((cAliasSF3)->F3_SERIE),5," ") + "/" +; //SERIE
					     	PadL(Alltrim((cAliasSF3)->F3_NFISCAL),12,"0") + CHR(13) + CHR(10) //NOTA
					    
						nTotVal += SF1->F1_VALMERC
						nTotDed += SF1->F1_VALBRUT-SF1->F1_VALMERC                            
						
						If ALLTRIM(UPPER(SUBSTR(SA2->A2_END,1,3))) $ "AV"
							cTpEnd	:=	"AV "
							cEnde	:=	ALLTRIM(UPPER(SUBSTR(SA2->A2_END,4,50)))
						ElseIf UPPER(SUBSTR(SA2->A2_END,1,3)) $ "RUA"
							cTpEnd	:=	"RUA"
							cEnde	:=	ALLTRIM(UPPER(SUBSTR(SA2->A2_END,4,50)))
						Else
							cTpEnd	:=	"RUA"
							cEnde	:=	ALLTRIM(UPPER(SA2->A2_END))
						EndIf
						
					    cDadosNF += "402"+ ; // Fixo
					    	Pad(Alltrim((cAliasSF3)->F3_SERIE),5," ") + ; //SERIE
					     	PadL(Alltrim((cAliasSF3)->F3_NFISCAL),12,"0") + ; //NOTA
					     	DtoS(SF1->F1_DTDIGIT) + ;
					     	"NT" + ; // Fixo
					     	PadL(Alltrim(StrTran(StrTran(cValToChar(Transform(SF1->F1_VALMERC,"@E 999,999,999,999.99")),",",""),".","")),15,"0")+ ; // VALOR SERVS
					     	PadL(Alltrim(StrTran(StrTran(cValToChar(Transform(SF1->F1_VALBRUT-SF1->F1_VALMERC,"@E 999,999,999,999.99")),",",""),".","")),15,"0")+ ;  // DEDUCOES
					     	Left((cAliasSF3)->F3_CODISS,5)+ ; // cod serv 
					     	Left(SB1->B1_TRIBMUN,4) + ; // sub item    
					     	Padl(StrTran(cValToChar(SB1->B1_ALIQISS)+".00",".",""),4,"0") + ; // aliq iss
					     	If(SA2->A2_CPOMSP == "2","1","2") + ; //Possui cadastro no CPOM SP?
					     	If(SA2->A2_TIPO == "J","2","1")+ ; //Iss Retido?
					     	StrTran(StrTran(Padl(SA2->A2_CGC,14,"0"),",",""),".","") + ; // CGC
					     	;//StrTran(StrTran(Padl(AllTrim(SA2->A2_INSCR),8,"0"),",","0"),".","0") + ; // INSCR
					     	Padl(AllTrim(""),8,"0")+ ; // INSCR
					     	StrTran(StrTran(PadR(SA2->A2_NOME,75," "),","," "),"."," ") + ; // Nome
					     	cTpEnd + ; //tipo do endereco
					     	PadR(StrTran(cEnde,"."," "),50," ") + ; // Nome					     	
					     	;//"Rua" + ; // Fixo
					     	;//PadR(StrTran(AllTrim(SA2->A2_END),"."," "),50," ") + ; // Nome
					     	PadR(StrTran(AllTrim(SA2->A2_NR_END),"."," "),10," ") + ; // NUMERO DE ENDERECO
					     	PadR(StrTran(AllTrim(SA2->A2_ENDCOMP),".", ""),30," ") + ; // COMPLEMENTO
					     	PadR(StrTran(AllTrim(SA2->A2_BAIRRO),"."," "),30," ") + ; // BAIRRO
					     	PadR(StrTran(AllTrim(SA2->A2_MUN),"."," "),50," ") + ; // CIDADE
					     	PadR(StrTran(AllTrim(SA2->A2_EST),"."," "),2," ") + ; // UF
					     	PadR(StrTran(AllTrim(SA2->A2_CEP),"."," "),8," ") + ; // CEP
					     	PadR(StrTran(AllTrim(SA2->A2_EMAIL),"."," "),75," ") + ; // EMAIL
					     	"10" + ; // FIXO
					     	"        " + ; // DT PAGTO FIXO
					     	Padr(Alltrim(SB1->B1_DESC),559," ") + ; // DESCRICAO
					     	chr(13) + chr(10)
					     	
				     	If SF1->F1_FIMP$"N, "
							RecLock("SF1")
						    	SF1->F1_FIMP := "T" //Transmitida
						    MsUnlock()
						Endif
					    	    
					   	dbSelectArea("SF3")
						dbSetOrder(5) //F3_FILIAL+F3_SERIE+F3_NFISCAL+F3_CLIEFOR+F3_LOJA+F3_IDENTFT				
						If SF3->(DbSeek(xFilial("SF3")+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA ))
							If SF3->(FieldPos("F3_CODRSEF")) >0
								RecLock("SF3")
									SF3->F3_CODRSEF:= "T"
								MsUnlock()						
							EndIf                           
						EndIf
					EndIf
				EndIf
			Endif
		Endif
	Endif
	dbSelectArea(cAliasSF3)
	dbSkip()	
EndDo

If !Empty(cDadosNF)
	cFooter  := "9"
	cFooter  += PadL(cValToChar(nIt),7,"0")
	cFooter  += PadL(Alltrim(StrTran(StrTran(cValToChar(transform(nTotVal,"@E 999,999,999,999.99")),",",""),".","")),15,"0")
	cFooter  += PadL(Alltrim(StrTran(StrTran(cValToChar(transform(nTotDed,"@E 999,999,999,999.99")),",",""),".","")),15,"0")
	cFooter  += CHR(13) + CHR(10)

	//01/04/2013 --> Alterado diretorio de gravacao do arquivo a ser gerado para a prefeitura.
	//MemoWrite("\\10.0.0.53\NFTS\arqger\3550308\"+Alltrim(cNomeArq)+".txt",cHeader+cDadosNF+cFooter)   
	
	//09/09/2014 --> Criado parametro para informar o local de gravacao do arquivo a ser gerado para a prefeitura.
	MemoWrite(cTmpGer+Alltrim(cNomeArq)+".txt",cHeader+cDadosNF+cFooter)  
Endif

If lQuery
	dbSelectArea(cAliasSF3)
	dbCloseArea()
	dbSelectArea("SF3")
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTEMP01Imp³ Autor ³ Michel Sales - Wikitec  ³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Programa temporario para retorno de notas fiscais		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTEMP01Imp
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chamada com tela do programa padrao									   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aPerg     := {}
Local aParam    := {Space(90)} 
Local cCodMun   := SM0->M0_CODMUN
Local cParImp   := SM0->M0_CODIGO+SM0->M0_CODFIL+"Fisa022Imp"
Local cIDThread := ""
Local cStatNfse := ""
Local lOk       := .F.
Local oWS
Local cTmpImp	:= ALLTRIM(SuperGetMv("DS_TMPIMP",,"C:\NFTS\RETORNO\"))


aParam[01] := PadR(ParamLoad(cParImp,aPerg,1,aParam[01]),Len(Space(90)))

aadd(aPerg,{1,"Arquivo de Retorno",aParam[01],"",".T.","",".T.",100,.F.})	//"Arquivo de retorno

If ParamBox(aPerg,"Transmissão NFS-e",@aParam,,,,,,,cParImp,.T.,.T.) //Monta tela de parâmetros
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o ,arquivo existe e abre 								   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//24/04/2013 --> Alterado diretorio de gravacao do arquivo de importacao da prefeitura.  
		//Hdl    := FT_FUSE(GetMV("DS_FTPIMP",,"\\10.0.0.53\NFTS\arqimp\3550308\")+AllTrim(aParam[1]),2)
		nHdl    := FT_FUSE(cTmpImp+AllTrim(aParam[1]),2)
	If nHdl != -1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processa o arquivo caso encontrado									   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Processa( {|| lOk := ProcRetorno() }, "Gerando arquivo..." )
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mensagem final padrao												   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOk
	Aviso("NFS-e","O arquivo de Retorno da Prefeitura foi importado com sucesso.",{"OK"},3)
Else
	Aviso("NFS-e","Nenhum arquivo foi importado.",{"OK"},3)
Endif
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTEMP01Leg³ Autor ³ Michel Sales - Wikitec³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Abre a legenda											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ProcRetorno()
Local lRet        := .F.
Local cBuffer     := ""
Local cNota       := ""
Local cSerie      := ""
Local cCodFornec  := ""
Local cCNPJ       := ""
Local cNFTS       := ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Certifica que esteja na primeira linha 								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_FGOTOP()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pula a primeira e a ultima linha (Header)							   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_FSKIP()
While !FT_FEOF()
	cBuffer := FT_FREADLN()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pula a primeira e a ultima linha (Header)							   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Left(cBuffer,1) != "9"
//		cNota := PadR(cValTochar(Val(Substring(cBuffer,42,1))),9," ") 
		cNota := Substring(cBuffer,34,9)
		cSerie := PadR(Substring(cBuffer,26,5),3," ")
		cCNPJ := PadR(Substring(cBuffer,497,14),14," ")
		cNFTS	:= PadR(Substring(cBuffer,2,8),8," ")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pesquisa pela nota de entrada										   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA2")
		SA2->(dbSetOrder(3)) // A2_FILIAL + A2_CNPJ
		If SA2->(dbSeek(xFilial("SA2")+cCNPJ))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Pesquisa pela nota de entrada										   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SF1")
			SF1->(dbSetOrder(1)) // F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA
			If SF1->(dbSeek(xFilial("SF1")+cNota+cSerie+SA2->(A2_COD + A2_LOJA) ))
				SF1->(RecLock("SF1",.F.))
				SF1->F1_FIMP	:= "S"
				SF1->F1_NFELETR	:= cNFTS
				SF1->(MsUnlock())
			Endif
		Endif
	Endif
		
	FT_FSKIP()
Enddo
Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTEMP01Leg³ Autor ³ Michel Sales - Wikitec³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Abre a legenda											   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTEMP01Leg

Local aLegenda := {}
aCores    := {{"F1_FIMP==' ','DISABLE'"  },;									//NF não transmitida
			  {"F1_FIMP=='S','ENABLE'"    },;						  			//NF Autorizada
			  {"F1_FIMP=='T','BR_AZUL'"  },;									//NF Transmitida
			  {"F1_FIMP=='N','BR_PRETO'"}}										//NF nao autorizada

Aadd(aLegenda, {"ENABLE"    ,"NF autorizada"})      //"NF autorizada"
Aadd(aLegenda, {"DISABLE"   ,"NF Arq. Não gerado"}) //"NF não transmitida"
Aadd(aLegenda, {"BR_AZUL"   ,"NF Arq. Gerado"}) 	 //"NF Transmitida"
Aadd(aLegenda, {"BR_PRETO"  ,"NF não autorizada" }) //"NF nao autorizada" 

BrwLegenda("NFTS","Legenda",aLegenda) //"Legenda"              
              
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTEMP01Vis³ Autor ³ Michel Sales - Wikitec³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Programa temporario para envio de notas fiscais			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RTEMP01Vis()

//If cAlias == "SF2"  
//	Mc090Visual("SF2",SF2->(RecNo()),1)
//ElseIf cAlias == "SF1"
	A103NFiscal("SF1",SF1->(RecNo()),2)  
//EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ RTEMP01   ³ Autor ³ Michel Sales - Wikitec  ³ Data ³ 22.03.13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³  Programa temporario para envio de notas fiscais			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ T4F                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef() 
Local aRotTemp := {}
aadd(aRotTemp,{"Pesquisar","AxPesqui"      ,0,1,0,.F.})	//"Pesquisar"
aadd(aRotTemp,{"Visualiza Doc.","U_RTEMP01Vis"    ,0,2,0 ,NIL})	//"Visualiza Doc."
//aadd(aRotina,{STR0005,"U_RTEMP01CFG"    ,0,2,0 ,NIL})	//"Wiz.Config."
aadd(aRotTemp,{"Gera Arq.","U_RTEMP01Rem"    ,0,2,0 ,NIL}) //"Transmissão."
aadd(aRotTemp,{"Imp.Retorno","U_RTEMP01Imp"     ,0,2,0 ,NIL})//"Imp.Retorno"		
//aadd(aRotina,{STR0009,"Fis022Mnt1"    ,0,2,0 ,NIL}) //"Monitor."
aadd(aRotTemp,{"Legenda","U_RTEMP01Leg"    ,0,2,0 ,NIL}) //"Legenda"
Return aRotTemp
