/*/{Protheus.doc} MT103ISS
// Ponto de Entrada chamado no momento de grava��o do t�tulo da nota fiscal, onde seu retorno atribui valores a serem alterados nas vari�veis
@author Gabriel Rodrigues gabriel.rodrigues@virtual360.io
@since 18/03/2021
@version 1.0
@args Array,
  PARAMIXB[1] = C�digo do fornecedor de ISS atual para grava��o
  PARAMIXB[2] = Loja do fornecedor de ISS atual para grava��o
  PARAMIXB[3] = Indicador de gera dirf atual para grava��o
  PARAMIXB[4] = C�digo de reten��o do t�tulo de ISS atual para grava��o
  PARAMIXB[5] = Data de vencimento do t�tulo de ISS atual para grava��o
@return Array, 
  aRet[1] = Novo c�digo do fornecedor de ISS
  aRet[2] = Nova loja do fornecedor de ISS
  aRet[3] = Novo indicador de gera dirf
  aRet[4] = Novo c�digo de reten��o do t�tulo de ISS
  aRet[5] = Nova data de vencimento do t�tulo de ISS

@type function
/*/
User Function MT103ISS

  Local aRet := {}
  If (Type("_lv360call") != 'U') .AND. (_lv360call == .T.)
    aRet := U_V360ISS(PARAMIXB)
  EndIf
  
Return aRet
