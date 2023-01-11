/*/{Protheus.doc} MT103ISS
// Ponto de Entrada chamado no momento de gravação do título da nota fiscal, onde seu retorno atribui valores a serem alterados nas variáveis
@author Gabriel Rodrigues gabriel.rodrigues@virtual360.io
@since 18/03/2021
@version 1.0
@args Array,
  PARAMIXB[1] = Código do fornecedor de ISS atual para gravação
  PARAMIXB[2] = Loja do fornecedor de ISS atual para gravação
  PARAMIXB[3] = Indicador de gera dirf atual para gravação
  PARAMIXB[4] = Código de retenção do título de ISS atual para gravação
  PARAMIXB[5] = Data de vencimento do título de ISS atual para gravação
@return Array, 
  aRet[1] = Novo código do fornecedor de ISS
  aRet[2] = Nova loja do fornecedor de ISS
  aRet[3] = Novo indicador de gera dirf
  aRet[4] = Novo código de retenção do título de ISS
  aRet[5] = Nova data de vencimento do título de ISS

@type function
/*/
User Function MT103ISS

  Local aRet := {}
  If (Type("_lv360call") != 'U') .AND. (_lv360call == .T.)
    aRet := U_V360ISS(PARAMIXB)
  EndIf
  
Return aRet
