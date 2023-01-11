#INCLUDE "TOTVS.ch"


User function MeepMnt()

	Local oLayer    := FWLayer():new()
	Local oMainColl := Nil
	Local oModal	:= Nil
	Local dDataIni  := Date()
	//Local dDataFim  := Date()
	//Local cTimeIni	:= Substr(Time(),1,5)
	//Local cTimeFim	:= Substr(Time(),1,5)
	Local oDataIni  := Nil
	//Local oDataFim  := Nil
	//Local oTimeIni  := Nil
	//Local oTimeFim  := Nil
	Local bVldData  := {|| IIf(Empty(oDataIni:GetValue()) ,.F.,.T.)}


	oModal := FWDialogModal():New()
	oModal:SetFreeArea(160,100)
	oModal:SetEscClose(.F.)    // Não permite fechar a tela com o ESC
	oModal:SetCloseButton(.F.) // Não permite fechar a tela com o "X"
	oModal:SetBackground(.T.)  // Escurece o fundo da janela
	oModal:SetTitle("Meep")
	oModal:setSubTitle("Processamento ")
	oModal:CreateDialog() //IMCadZBM(oDataIni:GetValue(),"")
	oModal:AddOkButton({|| FWMsgRun(,{|| U_IMCadZBM(oDataIni:GetValue(),"") },"Aguarde...","Realizando Importação..."),oModal:oOwner:End() })
	oModal:AddCloseButton({|| oModal:oOwner:End()})

	oLayer:Init(oModal:GetPanelMain(),.F.)
	oLayer:AddCollumn("MainColl",100,.F.)
	oMainColl := oLayer:GetColPanel("MainColl")

	oDataIni  := TJurPnlCampo():New(010,010,060,022,oMainColl,"Data ",("NYX_DATAIM"),{|| },{|| },dDataIni,,,)
	oDataIni:SetValid(bVldData)

	
	oModal:Activate()


Return
