#include "Rwmake.ch"
/*
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????ͻ??
???Programa  ?Fin001     ?Autor  ?Carlos Flavio      ? Data ?  31/01/02   ???
?????????????????????????????????????????????????????????????????????????͹??
???Desc.     ?                                                            ???
???          ?                                                            ???
?????????????????????????????????????????????????????????????????????????͹??
???Uso       ? AP6                                                        ???
?????????????????????????????????????????????????????????????????????????ͼ??
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
*/

User Function fin003()
Local _xRetorno

SEA->(MsSeek(xFilial("SEA")+MV_PAR01))
Alert("Bordero n?: " + SEA->EA_NUMBOR + " Modelo: "+SEA->EA_MODELO)
If SEA->EA_MODELO == "30" .or. SEA->EA_MODELO == "31"
	_xRetorno := .F.
Else
	_xRetorno := .T.
Endif

Return(_xRetorno)