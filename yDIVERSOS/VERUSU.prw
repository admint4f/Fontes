#INCLUDE "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerifica  บ Autor ณ Marcos Justo       บ Data ณ  18/03/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/


User Function VERUSU()
Local _CCHAVE := " "

IF alltrim(SUBSTR(CUSUARIO,7,15)) == "Administrador" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Giane" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Flavio" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Tuca" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Robert".or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Giane" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Robert" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Tuca" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "S_Flavio" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Alessandra" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Gabriela" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Carol" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Patricia"  .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Renata" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Ricardo" .or. alltrim(SUBSTR(CUSUARIO,7,15)) == "Andrea"
// MSGalert(SUBSTR(CUSUARIO,7,15))
_CCHAVE := " "
ELSE
_CCHAVE := "999"
ENDIF
           
Return(_CCHAVE)
