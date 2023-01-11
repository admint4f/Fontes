#include  "Protheus.Ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณCORCT2X  บAutor ณGeraldo Sabino บ Data ณ 17/12/2020 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. ณ Gravacao do campo CT2_XDOC para uso na concilia็ใo Mari          ฑ
ฑฑบ      ณ Deixar rodando durante a noite.                                  ฑ
ฑฑบ      ณ                                                                  ฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso ณ Para apoio ao Projeto AGIS - Migra็ใo dicionario x Banco         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CORCT2X()  


dBSelectarea("CT2")
dBgotop()
_cFiltro := " CT2_LOTE = '008850'  .AND. CT2_ROTINA <> 'FINA100' .AND. CT2_VALOR > 0"
MSfilter(_cFiltro)
dBSelectarea("CT2")
dbgotop()     
NNN:=0
While ! Eof() 

      IF EMPTY(CT2->CT2_XDOC) .and. !Empty(CT2->CT2_KEY)
         CT2->(Reclock("CT2",.F.))
         CT2->CT2_XDOC  :=  Substr(CT2->CT2_KEY,8,9) 
         CT2->(MsUnlock())
         NNN++
      Endif  



      dBSelectarea("CT2")
      dBskip()
Enddo
ALERT(nnn)

