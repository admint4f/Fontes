#include "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Geraldo Sabino      º Data ³  17/08/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Gera dados para cálculo do auxílio creche          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AuxCreche()

Select SRB
DBsetorder(1)
seek sra->(RA_FILIAL+RA_MAT)
nValor := 0
Do while sra->(RA_FILIAL+RA_MAT) = srb->(RB_FILIAL+RB_MAT)
	nIdade := DateDiffYear( SRB->RB_DTNASC , ddatabase )  // DateDiffYear( dDate1 , dDate2 )
	if srb->RB_AUXCRE = "1"
		if nidade < 7 //.or. srb->RB_DTENTRA <>"S"
			nCreche := 30-(SRB->rb_dtentra-firstday(SRB->rb_dtentra))
			if left(dtos(SRB->rb_dtentra),6)=left(dtos(dDatabase),6)
				//			ApMsgInfo("4 - GeraVerba1","AVISO","INFO")
				//FGERAVERBA('264',POSICIONE("RCE",1,XFILIAL("RCE")+SRA->RA_SINDICA,"RCE_PISO")*RCE->RCE_PERCAC/100/30*nCreche)
				nValor += POSICIONE("RCE",1,XFILIAL("RCE")+SRA->RA_SINDICA,"RCE_PISO")*RCE->RCE_PERCAC/100/30*nCreche
					ApMsgInfo("A - SRB->RB_NOME "+str(nvalor,6),"AVISO","INFO")
			else
				//	ApMsgInfo("B - "+str(nvalor,6),"AVISO","INFO")
				//FGERAVERBA('264',POSICIONE("RCE",1,XFILIAL("RCE")+SRA->RA_SINDICA,"RCE_PISO")*RCE->RCE_PERCAC/100) 
				nValor += POSICIONE("RCE",1,XFILIAL("RCE")+SRA->RA_SINDICA,"RCE_PISO")*RCE->RCE_PERCAC/100
			endif
		endif
	endif
	skip
Enddo
if nValor<>0
	FGERAVERBA('264',nValor)
endif

Return


