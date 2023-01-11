#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} T4FRELSE5
Relatório financeiro substituindo os genéricos SE5
@type function
@version 1.00
@author Lucas Valins
@since 22/11/2021
/*/

User Function T4FRELSE5()
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := "T4FRELSE5"
	Pergunte(cPerg,.T.)
	ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	oReport := TReport():New("SE5","Relatorio - SE5",cPerg,{|oReport| PrintReport(oReport)},"Relatorio - SE5")
	oReport:SetLandscape(.T.)
	oReport:SetTotalInLine(.F.)
	oSecCab := TRSection():New( oReport , "SE5", {"SQL"} )
        TRCell():New( oSecCab,'E5_FILIAL ' ,'SE5', 'Filial      ')
        TRCell():New( oSecCab,'E5_DATA   ' ,'SE5', 'DT Movimen  ')
        TRCell():New( oSecCab,'E5_TIPO   ' ,'SE5', 'Tipo Titulo ')
        TRCell():New( oSecCab,'E5_MOEDA  ' ,'SE5', 'Numerario   ')
        TRCell():New( oSecCab,'E5_VALOR  ' ,'SE5', 'Vlr.Movim.  ')
        TRCell():New( oSecCab,'E5_NATUREZ' ,'SE5', 'Natureza    ')
        TRCell():New( oSecCab,'E5_DESCNAT' ,'SE5', 'Desc Naturez')
        TRCell():New( oSecCab,'E5_BANCO  ' ,'SE5', 'Banco       ')
        TRCell():New( oSecCab,'E5_AGENCIA' ,'SE5', 'Agencia     ')
        TRCell():New( oSecCab,'E5_CONTA  ' ,'SE5', 'Conta Banco ')
        TRCell():New( oSecCab,'E5_NUMCHEQ' ,'SE5', 'Num Cheque  ')
        TRCell():New( oSecCab,'E5_DOCUMEN' ,'SE5', 'Documento   ')
        TRCell():New( oSecCab,'E5_VENCTO ' ,'SE5', 'Vencimento  ')
        TRCell():New( oSecCab,'E5_RECPAG ' ,'SE5', 'Rec/Pag     ')
        TRCell():New( oSecCab,'E5_BENEF  ' ,'SE5', 'Beneficiario')
        TRCell():New( oSecCab,'E5_HIST   ' ,'SE5', 'Cod Historic')
        TRCell():New( oSecCab,'E5_HISTOR ' ,'SE5', 'Historico   ')
        TRCell():New( oSecCab,'E5_TIPODOC' ,'SE5', 'Tipo do Doc.')
        TRCell():New( oSecCab,'E5_VLMOED2' ,'SE5', 'Vlr.Moeda 2 ')
        TRCell():New( oSecCab,'E5_LA     ' ,'SE5', 'Ident.L.A.  ')
        TRCell():New( oSecCab,'E5_SITUACA' ,'SE5', 'Situacao    ')
        TRCell():New( oSecCab,'E5_LOTE   ' ,'SE5', 'Lote        ')
        TRCell():New( oSecCab,'E5_PREFIXO' ,'SE5', 'Prefixo     ')
        TRCell():New( oSecCab,'E5_NUMERO ' ,'SE5', 'Titulo      ')
        TRCell():New( oSecCab,'E5_PARCELA' ,'SE5', 'Parcela     ')
        TRCell():New( oSecCab,'E5_CLIFOR ' ,'SE5', 'Cli/For     ')
        TRCell():New( oSecCab,'E5_LOJA   ' ,'SE5', 'Loja        ')
        TRCell():New( oSecCab,'E5_DTDIGIT' ,'SE5', 'Data Digit. ')
        TRCell():New( oSecCab,'E5_TIPOLAN' ,'SE5', 'Tipo Lanc.  ')
        TRCell():New( oSecCab,'E5_DEBITO ' ,'SE5', 'Cta Cont Fis')
        TRCell():New( oSecCab,'E5_DESCFIS' ,'SE5', 'Desc Cta Fis')
        TRCell():New( oSecCab,'E5_CREDITO' ,'SE5', 'Cta Cont Ger')
        TRCell():New( oSecCab,'E5_DESCCTA' ,'SE5', 'Desc Cta Ger')
        TRCell():New( oSecCab,'E5_MOTBX  ' ,'SE5', 'MOT BAIXA   ')
        TRCell():New( oSecCab,'E5_RATEIO ' ,'SE5', 'Rateio      ')
        TRCell():New( oSecCab,'E5_RECONC ' ,'SE5', 'Reconciliado')
        TRCell():New( oSecCab,'E5_SEQ    ' ,'SE5', 'Sequencia   ')
        TRCell():New( oSecCab,'E5_ARQRAT ' ,'SE5', 'Arq Rateio  ')
        TRCell():New( oSecCab,'E5_DTDISPO' ,'SE5', 'Data Dispon ')
        TRCell():New( oSecCab,'E5_CCD    ' ,'SE5', 'C.Custo     ')
        TRCell():New( oSecCab,'E5_CCC    ' ,'SE5', 'C.Custo Crd.')
        TRCell():New( oSecCab,'E5_OK     ' ,'SE5', 'Iden.Selecao')
        TRCell():New( oSecCab,'E5_IDENTEE' ,'SE5', 'Ident Comp  ')
        TRCell():New( oSecCab,'E5_ORDREC ' ,'SE5', 'Rec/Ordem   ')
        TRCell():New( oSecCab,'E5_FILORIG' ,'SE5', 'Filial Orig ')
        TRCell():New( oSecCab,'E5_ARQCNAB' ,'SE5', 'Arq CNAB    ')
        TRCell():New( oSecCab,'E5_VLJUROS' ,'SE5', 'Valor juros ')
        TRCell():New( oSecCab,'E5_SITUA  ' ,'SE5', 'Situacao Frt')
        TRCell():New( oSecCab,'E5_VLMULTA' ,'SE5', 'Valor Multa ')
        TRCell():New( oSecCab,'E5_VLCORRE' ,'SE5', 'Valor Correc')
        TRCell():New( oSecCab,'E5_VLDESCO' ,'SE5', 'Valor Descto')
        TRCell():New( oSecCab,'E5_CNABOC ' ,'SE5', 'Ocorr CNAB  ')
        TRCell():New( oSecCab,'E5_ITEMD  ' ,'SE5', 'Elemento PEP')
        TRCell():New( oSecCab,'E5_ITEMC  ' ,'SE5', 'Item Credito')
        TRCell():New( oSecCab,'E5_CLVLDB ' ,'SE5', 'Cl Valor    ')
        TRCell():New( oSecCab,'E5_CLVLCR ' ,'SE5', 'Cl Valor Crd')
        TRCell():New( oSecCab,'E5_PROJPMS' ,'SE5', 'Projeto     ')
        TRCell():New( oSecCab,'E5_EDTPMS ' ,'SE5', 'EDT         ')
        TRCell():New( oSecCab,'E5_TASKPMS' ,'SE5', 'Tarefa      ')
        TRCell():New( oSecCab,'E5_VRETPIS' ,'SE5', 'Val. Ret.PIS')
        TRCell():New( oSecCab,'E5_VRETCOF' ,'SE5', 'Val. Ret.COF')
        TRCell():New( oSecCab,'E5_VRETCSL' ,'SE5', 'Val. Ret.CSL')
        TRCell():New( oSecCab,'E5_PRETPIS' ,'SE5', 'Pend.Ret.Pis')
        TRCell():New( oSecCab,'E5_PRETCOF' ,'SE5', 'Pend.Ret.Cof')
        TRCell():New( oSecCab,'E5_PRETCSL' ,'SE5', 'Pend.Ret.Csl')
        TRCell():New( oSecCab,'E5_MODSPB ' ,'SE5', 'Modalid. SPB')
        TRCell():New( oSecCab,'E5_TXMOEDA' ,'SE5', 'Tx moeda tit')
        TRCell():New( oSecCab,'E5_SITCOB ' ,'SE5', 'Sit.Cobranca')
        TRCell():New( oSecCab,'E5_CODORCA' ,'SE5', 'Cod. Orcam. ')
        TRCell():New( oSecCab,'E5_BANCOG ' ,'SE5', 'Ct.Gerencial')
        TRCell():New( oSecCab,'E5_FATURA ' ,'SE5', 'Fatura      ')
        TRCell():New( oSecCab,'E5_FATPREF' ,'SE5', 'Pref. Fatura')
        TRCell():New( oSecCab,'E5_FORNADT' ,'SE5', 'Forn. Adto. ')
        TRCell():New( oSecCab,'E5_LOJAADT' ,'SE5', 'Loja Adto.  ')
        TRCell():New( oSecCab,'E5_MOVCX  ' ,'SE5', 'Mov.Caixinha')
        TRCell():New( oSecCab,'E5_CLIENTE' ,'SE5', 'Cliente     ')
        TRCell():New( oSecCab,'E5_FORNECE' ,'SE5', 'Fornecedor  ')
        TRCell():New( oSecCab,'E5_SERREC ' ,'SE5', 'Serie Recibo')
        TRCell():New( oSecCab,'E5_OPERAD ' ,'SE5', 'Operador    ')
        TRCell():New( oSecCab,'E5_KEY    ' ,'SE5', 'Chave Titulo')
        TRCell():New( oSecCab,'E5_MULTNAT' ,'SE5', 'Mult.Naturez')
        TRCell():New( oSecCab,'E5_AGLIMP ' ,'SE5', 'Agl.Impostos')
        TRCell():New( oSecCab,'E5_VLACRES' ,'SE5', 'Valor Acresc')
        TRCell():New( oSecCab,'E5_VLDECRE' ,'SE5', 'Valor Decres')
        TRCell():New( oSecCab,'E5_AUTBCO ' ,'SE5', 'Aut.Bancaria')
        TRCell():New( oSecCab,'E5_PRETIRF' ,'SE5', 'Pend.Rt. IR ')
        TRCell():New( oSecCab,'E5_VRETIRF' ,'SE5', 'Valor Rt IR ')
        TRCell():New( oSecCab,'E5_VRETISS' ,'SE5', 'Valor Rt ISS')
        TRCell():New( oSecCab,'E5_CTADEST' ,'SE5', 'Cta Destino ')
        TRCell():New( oSecCab,'E5_NUMPA  ' ,'SE5', 'Nr.Solic.PA ')
        TRCell():New( oSecCab,'E5_PROCTRA' ,'SE5', 'Proc. Transf')
        TRCell():New( oSecCab,'E5_NUMMOV ' ,'SE5', 'Movimento   ')
        TRCell():New( oSecCab,'E5_DIACTB ' ,'SE5', 'Cod. Diario ')
        TRCell():New( oSecCab,'E5_BASEIRF' ,'SE5', 'Base IRPF   ')
        TRCell():New( oSecCab,'E5_NODIA  ' ,'SE5', 'Seq. Diario ')
        TRCell():New( oSecCab,'E5_FORMAPG' ,'SE5', 'Forma Pagto ')
        TRCell():New( oSecCab,'E5_PRINSS ' ,'SE5', 'Prov INSS   ')
        TRCell():New( oSecCab,'E5_PRISS  ' ,'SE5', 'Prov ISS    ')
        TRCell():New( oSecCab,'E5_IDMOVI ' ,'SE5', 'Id.Movimento')
        TRCell():New( oSecCab,'E5_TPDESC ' ,'SE5', 'Desc. F100  ')
        TRCell():New( oSecCab,'E5_ORIGEM ' ,'SE5', 'Origem      ')
        TRCell():New( oSecCab,'E5_FLDMED ' ,'SE5', 'St. DMED    ')
        TRCell():New( oSecCab,'E5_CGC    ' ,'SE5', 'ID contrib. ')
        TRCell():New( oSecCab,'E5_CCUSTO ' ,'SE5', 'C. de Custo ')
        TRCell():New( oSecCab,'E5_SEQCON ' ,'SE5', 'Seq Conc    ')
        TRCell():New( oSecCab,'E5_MOVFKS ' ,'SE5', 'Reg. Mig.   ')
        TRCell():New( oSecCab,'E5_IDORIG ' ,'SE5', 'Id. Origem  ')
        TRCell():New( oSecCab,'E5_TABORI ' ,'SE5', 'Tab. Orig.  ')
        TRCell():New( oSecCab,'E5_DTCANBX' ,'SE5', 'Dt cancel bx')
        TRCell():New( oSecCab,'E5_PRETINS' ,'SE5', 'Pend.Rt.INSS')
        TRCell():New( oSecCab,'E5_VRETINS' ,'SE5', 'Vlr Ret INSS')
        TRCell():New( oSecCab,'E5_SDOCREC' ,'SE5', 'Série Recibo')
	oSecCab:PrintLine()
Return

Static Function PrintReport(oReport)
	Local cAlias := GetNextAlias()
        //Local cTipo := "%E5_TIPO LIKE"+MV_PAR03+"%"
	oSecCab:BeginQuery()
	BeginSql Alias cAlias
		SELECT  E5_FILIAL 	,
E5_DATA   	,
E5_TIPO   	,
E5_MOEDA  	,
E5_VALOR  	,
E5_NATUREZ	,
E5_DESCNAT	,
E5_BANCO  	,
E5_AGENCIA	,
E5_CONTA  	,
E5_NUMCHEQ	,
E5_DOCUMEN	,
E5_VENCTO 	,
E5_RECPAG 	,
E5_BENEF  	,
E5_HIST   	,
E5_HISTOR 	,
E5_TIPODOC	,
E5_VLMOED2	,
E5_LA     	,
E5_SITUACA	,
E5_LOTE   	,
E5_PREFIXO	,
E5_NUMERO 	,
E5_PARCELA	,
E5_CLIFOR 	,
E5_LOJA   	,
E5_DTDIGIT	,
E5_TIPOLAN	,
E5_DEBITO 	,
E5_DESCFIS	,
E5_CREDITO	,
E5_DESCCTA	,
E5_MOTBX  	,
E5_RATEIO 	,
E5_RECONC 	,
E5_SEQ    	,
E5_ARQRAT 	,
E5_DTDISPO	,
E5_CCD    	,
E5_CCC    	,
E5_OK     	,
E5_IDENTEE	,
E5_ORDREC 	,
E5_FILORIG	,
E5_ARQCNAB	,
E5_VLJUROS	,
E5_SITUA  	,
E5_VLMULTA	,
E5_VLCORRE	,
E5_VLDESCO	,
E5_CNABOC 	,
E5_ITEMD  	,
E5_ITEMC  	,
E5_CLVLDB 	,
E5_CLVLCR 	,
E5_PROJPMS	,
E5_EDTPMS 	,
E5_TASKPMS	,
E5_VRETPIS	,
E5_VRETCOF	,
E5_VRETCSL	,
E5_PRETPIS	,
E5_PRETCOF	,
E5_PRETCSL	,
E5_MODSPB 	,
E5_TXMOEDA	,
E5_SITCOB 	,
E5_CODORCA	,
E5_BANCOG 	,
E5_FATURA 	,
E5_FATPREF	,
E5_FORNADT	,
E5_LOJAADT	,
E5_MOVCX  	,
E5_CLIENTE	,
E5_FORNECE	,
E5_SERREC 	,
E5_OPERAD 	,
E5_KEY    	,
E5_MULTNAT	,
E5_AGLIMP 	,
E5_VLACRES	,
E5_VLDECRE	,
E5_AUTBCO 	,
E5_PRETIRF	,
E5_VRETIRF	,
E5_VRETISS	,
E5_CTADEST	,
E5_NUMPA  	,
E5_PROCTRA	,
E5_NUMMOV 	,
E5_DIACTB 	,
E5_BASEIRF	,
E5_NODIA  	,
E5_FORMAPG	,
E5_PRINSS 	,
E5_PRISS  	,
E5_IDMOVI 	,
E5_TPDESC 	,
E5_ORIGEM 	,
E5_FLDMED 	,
E5_CGC    	,
E5_CCUSTO 	,
E5_SEQCON 	,
E5_MOVFKS 	,
E5_IDORIG 	,
E5_TABORI 	,
E5_DTCANBX	,
E5_PRETINS	,
E5_VRETINS	,
E5_SDOCREC	
FROM %table:SE5% SE5
		WHERE 
			SE5.%notDel% AND
			SE5.E5_DATA BETWEEN %exp:(dtos(MV_PAR01))% AND %exp:(dtos(MV_PAR02))% AND
                        SE5.E5_MOTBX = %exp:MV_PAR03%
	EndSql
	oSecCab:EndQuery()
	oSecCab:Print()
	(cAlias)->(DbCloseArea())
Return
