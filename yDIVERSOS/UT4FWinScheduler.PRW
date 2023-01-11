#include "totvs.ch"
#include "tbiconn.ch"
//------------------------------------------------------------------------------------------------------------------------------------------------
	/*/
	 Funcao:T4FWinScheduler
	 Data:31/01/2017
	 Autor:Marinaldo de Jesus
	 Descricao:Executar Funcoes via Task Manager
	 Sintaxe: 
	//------------------------------------------------------------------------------------------------------------------------------------------------
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=08;01;U_T4LOJE;08,01;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=08;02;U_T4LOJE;08,02;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=08;03;U_T4LOJE;08,03;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=08;04;U_T4LOJE;08,04;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=08;05;U_T4LOJE;08,05;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=ee;ff;U_T4LOJE;ee,ff;1;FAT -c=WF -e=T4F_WF -m -l 
	//------------------------------------------------------------------------------------------------------------------------------------------------
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=09;01;U_T4LOJE;09,01;1;FAT -c=WF -e=T4F_WF -m -l 
	//------------------------------------------------------------------------------------------------------------------------------------------------
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=15;01;U_T4LOJE;15,01;1;FAT -c=WF -e=T4F_WF -m -l 
	//------------------------------------------------------------------------------------------------------------------------------------------------
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=16;01;U_T4LOJE;16,01;1;FAT -c=WF -e=T4F_WF -m -l 
	//------------------------------------------------------------------------------------------------------------------------------------------------
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=20;01;U_T4LOJE;20,01;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=20;02;U_T4LOJE;20,02;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=20;03;U_T4LOJE;20,03;1;FAT -c=WF -e=T4F_WF -m -l 
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=ee;ff;U_T4LOJE;ee,ff;1;FAT -c=WF -e=T4F_WF -m -l 
	//------------------------------------------------------------------------------------------------------------------------------------------------
		 D:\TOTVS\microsiga\protheus11\bin\smartclient\smartclient.exe -q -p=u_T4FWinScheduler -a=25;01;U_T4LOJE;25,01;1;FAT -c=WF -e=T4F_WF -m -l 
	//------------------------------------------------------------------------------------------------------------------------------------------------
        /*/
//------------------------------------------------------------------------------------------------------------------------------------------------
User Function T4FWinScheduler(cParameter)

    Local aFun
    Local aPar
    Local aParameter
    
    Local bonWInit
     
    Local cEmp
    Local cFil
    Local cFun
    Local cMsg
    Local cMod
    
    Local cProcName
    
    Local c_svEmpAnt
	Local c_svFilAnt             		   
    
    Local lWindow
    Local l_svEmpFil
    
    Local nPar
    Local nParameter
    
    Local oT4FExFArray
     
    DEFAULT cParameter:=""

	cProcName:=ProcName()
   
    begin sequence 

	    aParameter:=StrTokArr2(cParameter,";")
	    nParameter:=Len(aParameter)
    	
    	if (empty(aParameter).or.(nParameter<4))
		    cMsg:='['+cProcName+']: T4F - WINDOWS TASK Scheduler : ERROR : INVALID PARAMETERS'+DTOS(MsDate())+'-'+Time()
			OutMessage(cMsg)
    	endif
    
	    cEmp:=aParameter[1]
	    cFil:=aParameter[2]
	    cFun:=aParameter[3]
	    cPar:=aParameter[4]

	    if (nParameter>=5)
	    	lWindow:=(aParameter[5]=="1")
	    else
	    	lWindow:=.F.
	    endif

	    if (nParameter>=6)
	    	cMod:=aParameter[6]
	    else
	    	cMod:="FAT"
	    endif
	    
	    aPar:=StrTokArr2(cPar,",")
	    nPar:=Len(aPar)
	    
	    aFun:=Array(10)
	    
	    aFun[01]:=cFun
	    aFun[02]:=if(nPar>=1,aPar[1],"")
	    aFun[03]:=if(nPar>=2,aPar[2],"")
	    aFun[04]:=if(nPar>=3,aPar[3],"")
	    aFun[05]:=if(nPar>=4,aPar[4],"")
	    aFun[06]:=if(nPar>=5,aPar[5],"")
	    aFun[07]:=if(nPar>=6,aPar[6],"")
	    aFun[08]:=if(nPar>=7,aPar[7],"")
	    aFun[09]:=if(nPar>=8,aPar[8],"")
	    aFun[10]:=if(nPar>=9,aPar[9],"")
	
	    cMsg:='['+cProcName+']: T4F - WINDOWS TASK Scheduler : START : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
		OutMessage(cMsg)

		oT4FExFArray:=u_T4FExFArray()
		bonWInit:={|oMainWnd,oT4FExFArray,aFun|oT4FExFArray:ExecFromArray(aFun),if(ValType(oMainWnd)=="O",oMainWnd:End(),NIL)}

		Private oMainWnd
		
		l_svEmpFil:=((Type("cEmpAnt")=="C").and.(Type("cFilAnt")=="C"))
			
		if (l_svEmpFil)
			c_svEmpAnt:=cEmpAnt
			cEmpAnt:=cEmp
			c_svFilAnt:=cFilAnt
			cFilAnt:=cFil
		endif

	    RPCSetType(3)
	    RpcSetEnv(cEmp/*[cRpcEmp]*/,cFil/*[cRpcFil]*/,/*[cEnvUser]*/,/*[cEnvPass]*/,cMod/*[cEnvMod]*/,/*[cFunName]*/,/*[aTables]*/,/*[lShowFinal]*/,/*[lAbend]*/,/*[lOpenSX]*/,/*[lConnect]*/)
		if (lWindow)
			SetBlind(.F.)
			DEFINE WINDOW oMainWnd FROM 000,000 TO 000,000 TITLE "T4F - WINDOWS TASK Scheduler"
			ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT Eval(bonWInit,@oMainWnd,@oT4FExFArray,@aFun)
		else
			SetBlind(.T.)
			Eval(bonWInit,@oMainWnd,@oT4FExFArray,@aFun)
		endif

	    cMsg:='['+cProcName+']: T4F - WINDOWS TASK Scheduler : FINAL : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
	    OutMessage(cMsg)
		
		if (l_svEmpFil)
	 		RpcSetEnv(c_svEmpAnt/*[cRpcEmp]*/,c_svFilAnt/*[cRpcFil]*/,/*[cEnvUser]*/,/*[cEnvPass]*/,cMod/*[cEnvMod]*/,/*[cFunName]*/,/*[aTables]*/,/*[lShowFinal]*/,/*[lAbend]*/,/*[lOpenSX]*/,/*[lConnect]*/)
	    else
	    	RpcClearEnv()
	    endif
		    
	    cMsg:='['+cProcName+']: T4F - WINDOWS TASK Scheduler : END : '+DTOS(MsDate())+'-'+Time()+'/'+" Emp: "+cEmp+" Fil: "+cFil+" Fun: "+cFun
	    OutMessage(cMsg)

	end sequence
        
    Return(NIL)

Static Procedure OutMessage(cMsg)
    PTInternal(1,cMsg)
	#IFDEF TOP
		TCInternal(1,cMsg)    
	#ENDIF
    U_CONSOLE(cMsg)
	Return    