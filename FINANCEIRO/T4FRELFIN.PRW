#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} T4FRELFIN
Relatório financeiro substituindo os genéricos SE1
@type function
@version 1.00
@author Lucas Valins
@since 22/11/2021
/*/

User Function T4FRELFIN()
	Private oReport  := Nil
	Private oSecCab	 := Nil
	Private cPerg 	 := "T4FRELFIN"
	Pergunte(cPerg,.T.)
	ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
	oReport := TReport():New("SE1","Relatorio - SE1",cPerg,{|oReport| PrintReport(oReport)},"Relatorio - SE1")
	oReport:SetLandscape(.T.)
	oReport:SetTotalInLine(.F.)
	oSecCab := TRSection():New( oReport , "SE1", {"SQL"} )
	TRCell():New( oSecCab,'E1_PREFIXO' ,'SE1', 'Prefixo')
	TRCell():New( oSecCab,'E1_NUM    ' ,'SE1', 'No. Titulo')
	TRCell():New( oSecCab,'E1_PARCELA' ,'SE1', 'Parcela')
	TRCell():New( oSecCab,'E1_TIPO   ' ,'SE1', 'Tipo')
	TRCell():New( oSecCab,'E1_NATUREZ' ,'SE1', 'Natureza')
	TRCell():New( oSecCab,'E1_PORTADO' ,'SE1', 'Portador')
	TRCell():New( oSecCab,'E1_AGEDEP ' ,'SE1', 'Depositaria')
	TRCell():New( oSecCab,'E1_CLIENTE' ,'SE1', 'Cliente')
	TRCell():New( oSecCab,'E1_LOJA   ' ,'SE1', 'Loja')
	TRCell():New( oSecCab,'E1_NOMCLI ' ,'SE1', 'Nome Cliente')
	TRCell():New( oSecCab,'E1_NUMBOR ' ,'SE1', 'Num. Bordero')
	TRCell():New( oSecCab,'E1_EMISSAO' ,'SE1', 'DT Emissao')
	TRCell():New( oSecCab,'E1_VENCTO ' ,'SE1', 'Vencimento')
	TRCell():New( oSecCab,'E1_VENCREA' ,'SE1', 'Vencto real')
	TRCell():New( oSecCab,'E1_BAIXA  ' ,'SE1', 'DT Baixa')
	TRCell():New( oSecCab,'E1_VALOR  ' ,'SE1', 'Vlr.Titulo')
	TRCell():New( oSecCab,'E1_IRRF   ' ,'SE1', 'IRRF')
	TRCell():New( oSecCab,'E1_ISS    ' ,'SE1', 'ISS')
	TRCell():New( oSecCab,'E1_NUMBCO ' ,'SE1', 'Nº no Banco')
	TRCell():New( oSecCab,'E1_INDICE ' ,'SE1', 'Reajuste')
	TRCell():New( oSecCab,'E1_DATABOR' ,'SE1', 'DT Bordero')
	TRCell():New( oSecCab,'E1_EMIS1  ' ,'SE1', 'DT Contab.')
	TRCell():New( oSecCab,'E1_HIST   ' ,'SE1', 'Historico')
	TRCell():New( oSecCab,'E1_LA     ' ,'SE1', 'Ident. Lanc.')
	TRCell():New( oSecCab,'E1_LOTE   ' ,'SE1', 'Lote Contabl')
	TRCell():New( oSecCab,'E1_MOTIVO ' ,'SE1', 'Motivo')
	TRCell():New( oSecCab,'E1_MOVIMEN' ,'SE1', 'Ult.Moviment')
	TRCell():New( oSecCab,'E1_OP     ' ,'SE1', 'Empresa Tit.')
	TRCell():New( oSecCab,'E1_SITUACA' ,'SE1', 'Situacao')
	TRCell():New( oSecCab,'E1_CONTRAT' ,'SE1', 'Contrato')
	TRCell():New( oSecCab,'E1_SALDO  ' ,'SE1', 'Saldo')
	TRCell():New( oSecCab,'E1_SUPERVI' ,'SE1', 'Supervisor')
	TRCell():New( oSecCab,'E1_VEND1  ' ,'SE1', 'Vendedor 1')
	TRCell():New( oSecCab,'E1_VEND2  ' ,'SE1', 'Vendedor 2')
	TRCell():New( oSecCab,'E1_VEND3  ' ,'SE1', 'Vendedor 3')
	TRCell():New( oSecCab,'E1_VEND4  ' ,'SE1', 'Vendedor 4')
	TRCell():New( oSecCab,'E1_VEND5  ' ,'SE1', 'Vendedor 5')
	TRCell():New( oSecCab,'E1_COMIS1 ' ,'SE1', '% Comissao 1')
	TRCell():New( oSecCab,'E1_COMIS2 ' ,'SE1', '% Comissao 2')
	TRCell():New( oSecCab,'E1_COMIS3 ' ,'SE1', '% Comissao 3')
	TRCell():New( oSecCab,'E1_COMIS4 ' ,'SE1', '% Comissao 4')
	TRCell():New( oSecCab,'E1_DESCONT' ,'SE1', 'Desconto')
	TRCell():New( oSecCab,'E1_COMIS5 ' ,'SE1', '% Comissao 5')
	TRCell():New( oSecCab,'E1_MULTA  ' ,'SE1', 'Multa')
	TRCell():New( oSecCab,'E1_JUROS  ' ,'SE1', 'Juros')
	TRCell():New( oSecCab,'E1_CORREC ' ,'SE1', 'Correcao')
	TRCell():New( oSecCab,'E1_VALLIQ ' ,'SE1', 'Vlr.Liq Baix')
	TRCell():New( oSecCab,'E1_VENCORI' ,'SE1', 'Vencto Orig')
	TRCell():New( oSecCab,'E1_VALJUR ' ,'SE1', 'Taxa Perman.')
	TRCell():New( oSecCab,'E1_PORCJUR' ,'SE1', 'Porc Juros')
	TRCell():New( oSecCab,'E1_MOEDA  ' ,'SE1', 'Moeda')
	TRCell():New( oSecCab,'E1_BASCOM1' ,'SE1', 'Base Comis 1')
	TRCell():New( oSecCab,'E1_BASCOM2' ,'SE1', 'Base Comis 2')
	TRCell():New( oSecCab,'E1_BASCOM3' ,'SE1', 'Base Comis 3')
	TRCell():New( oSecCab,'E1_BASCOM4' ,'SE1', 'Base Comis 4')
	TRCell():New( oSecCab,'E1_BASCOM5' ,'SE1', 'Base Comis 5')
	TRCell():New( oSecCab,'E1_FATPREF' ,'SE1', 'Pref. Fatura')
	TRCell():New( oSecCab,'E1_FATURA ' ,'SE1', 'Fatura')
	TRCell():New( oSecCab,'E1_PROJETO' ,'SE1', 'Projeto')
	TRCell():New( oSecCab,'E1_OK     ' ,'SE1', 'Iden.Selecao')
	TRCell():New( oSecCab,'E1_CLASCON' ,'SE1', 'Classific.')
	TRCell():New( oSecCab,'E1_VALCOM1' ,'SE1', 'Vlr. comis.1')
	TRCell():New( oSecCab,'E1_VALCOM2' ,'SE1', 'Vlr. comis.2')
	TRCell():New( oSecCab,'E1_VALCOM3' ,'SE1', 'Vlr. comis.3')
	TRCell():New( oSecCab,'E1_VALCOM4' ,'SE1', 'Vlr. comis.4')
	TRCell():New( oSecCab,'E1_VALCOM5' ,'SE1', 'Vlr. comis.5')
	TRCell():New( oSecCab,'E1_OCORREN' ,'SE1', 'Cod Ocorrenc')
	TRCell():New( oSecCab,'E1_INSTR1 ' ,'SE1', 'Inst.Primar.')
	TRCell():New( oSecCab,'E1_INSTR2 ' ,'SE1', 'Instr.Secund')
	TRCell():New( oSecCab,'E1_PEDIDO ' ,'SE1', 'No. Pedido')
	TRCell():New( oSecCab,'E1_DTVARIA' ,'SE1', 'Dt UIt.Var.')
	TRCell():New( oSecCab,'E1_VARURV ' ,'SE1', 'Vlr.Variacao')
	TRCell():New( oSecCab,'E1_VLCRUZ ' ,'SE1', 'Vlr R$')
	TRCell():New( oSecCab,'E1_DTFATUR' ,'SE1', 'Data Faturam')
	TRCell():New( oSecCab,'E1_STATUS ' ,'SE1', 'Status')
	TRCell():New( oSecCab,'E1_NUMNOTA' ,'SE1', 'Nota Fiscal')
	TRCell():New( oSecCab,'E1_SERIE  ' ,'SE1', 'Serie')
	TRCell():New( oSecCab,'E1_ORIGEM ' ,'SE1', 'Origem')
	TRCell():New( oSecCab,'E1_NUMCART' ,'SE1', 'Num do Carta')
	TRCell():New( oSecCab,'E1_IDENTEE' ,'SE1', 'Ident CEC')
	TRCell():New( oSecCab,'E1_FLUXO  ' ,'SE1', 'Fluxo Caixa')
	TRCell():New( oSecCab,'E1_DESCFIN' ,'SE1', 'Desc Financ.')
	TRCell():New( oSecCab,'E1_DIADESC' ,'SE1', 'Dias p/ Desc')
	TRCell():New( oSecCab,'E1_TIPODES' ,'SE1', 'Tipo Descont')
	TRCell():New( oSecCab,'E1_CARTAO ' ,'SE1', 'Nro. Cartao')
	TRCell():New( oSecCab,'E1_CARTVAL' ,'SE1', 'Validade')
	TRCell():New( oSecCab,'E1_CARTAUT' ,'SE1', 'Autorizaþão')
	TRCell():New( oSecCab,'E1_ADM    ' ,'SE1', 'Administ.')
	TRCell():New( oSecCab,'E1_TRANSF ' ,'SE1', 'Doc.Transf.')
	TRCell():New( oSecCab,'E1_VLRREAL' ,'SE1', 'Valor Real')
	TRCell():New( oSecCab,'E1_BCOCHQ ' ,'SE1', 'Bco. Cheque')
	TRCell():New( oSecCab,'E1_AGECHQ ' ,'SE1', 'Agenc.Cheque')
	TRCell():New( oSecCab,'E1_CTACHQ ' ,'SE1', 'Conta Cheque')
	TRCell():New( oSecCab,'E1_NUMLIQ ' ,'SE1', 'N.Liquidacao')
	TRCell():New( oSecCab,'E1_INSS   ' ,'SE1', 'INSS')
	TRCell():New( oSecCab,'E1_ORDPAGO' ,'SE1', 'Ordem Pagto')
	TRCell():New( oSecCab,'E1_FILORIG' ,'SE1', 'Filial Orig')
	TRCell():New( oSecCab,'E1_TIPOFAT' ,'SE1', 'Tipo Fatura')
	TRCell():New( oSecCab,'E1_TIPOLIQ' ,'SE1', 'Tipo Liquida')
	TRCell():New( oSecCab,'E1_CSLL   ' ,'SE1', 'CSLL')
	TRCell():New( oSecCab,'E1_COFINS ' ,'SE1', 'COFINS')
	TRCell():New( oSecCab,'E1_PIS    ' ,'SE1', 'PIS/PASEP')
	TRCell():New( oSecCab,'E1_MESBASE' ,'SE1', 'Mes Base')
	TRCell():New( oSecCab,'E1_FLAGFAT' ,'SE1', 'Flag Fatura')
	TRCell():New( oSecCab,'E1_ANOBASE' ,'SE1', 'Ano Base')
	TRCell():New( oSecCab,'E1_PLNUCOB' ,'SE1', 'Num.Cobranca')
	TRCell():New( oSecCab,'E1_CODINT ' ,'SE1', 'Instituicao')
	TRCell():New( oSecCab,'E1_CODEMP ' ,'SE1', 'Empresa/Grup')
	TRCell():New( oSecCab,'E1_MATRIC ' ,'SE1', 'Matricula')
	TRCell():New( oSecCab,'E1_TXMOEDA' ,'SE1', 'Taxa moeda')
	TRCell():New( oSecCab,'E1_ACRESC ' ,'SE1', 'Acrescimo')
	TRCell():New( oSecCab,'E1_SDACRES' ,'SE1', 'Sld.Acresc.')
	TRCell():New( oSecCab,'E1_DECRESC' ,'SE1', 'Decrescimo')
	TRCell():New( oSecCab,'E1_SDDECRE' ,'SE1', 'Sld.Decresc.')
	TRCell():New( oSecCab,'E1_MULTNAT' ,'SE1', 'Mult. Natur.')
	TRCell():New( oSecCab,'E1_MSFIL  ' ,'SE1', 'Filial Orig.')
	TRCell():New( oSecCab,'E1_MSEMP  ' ,'SE1', 'Empresa Orig')
	TRCell():New( oSecCab,'E1_PROJPMS' ,'SE1', 'Rateio Proj.')
	TRCell():New( oSecCab,'E1_DESDOBR' ,'SE1', 'Desdobramen.')
	TRCell():New( oSecCab,'E1_NRDOC  ' ,'SE1', 'Nr.Documento')
	TRCell():New( oSecCab,'E1_MODSPB ' ,'SE1', 'Mod. Recebto')
	TRCell():New( oSecCab,'E1_IDCNAB ' ,'SE1', 'Id. Cnab')
	TRCell():New( oSecCab,'E1_PLCOEMP' ,'SE1', 'Contr Empres')
	TRCell():New( oSecCab,'E1_PLTPCOE' ,'SE1', 'Tp Cont Empr')
	TRCell():New( oSecCab,'E1_CODCOR ' ,'SE1', 'Cod Corretor')
	TRCell():New( oSecCab,'E1_PARCCSS' ,'SE1', 'Parc.CSS')
	TRCell():New( oSecCab,'E1_CODORCA' ,'SE1', 'Cod. Orcam.')
	TRCell():New( oSecCab,'E1_CODIMOV' ,'SE1', 'Cod. Imovel')
	TRCell():New( oSecCab,'E1_CONTAG ' ,'SE1', 'Ct.Gerencial')
	TRCell():New( oSecCab,'E1_USUARIO' ,'SE1', 'USUARIO')
	TRCell():New( oSecCab,'E1_CCONTAB' ,'SE1', 'Conta Contab')
	TRCell():New( oSecCab,'E1_ITEM   ' ,'SE1', 'Elem Pep')
	TRCell():New( oSecCab,'E1_SABTCLS' ,'SE1', 'SALDO AB.CLS')
	TRCell():New( oSecCab,'E1_SABTCSL' ,'SE1', 'Saldo Ab.CSL')
	TRCell():New( oSecCab,'E1_CONTA  ' ,'SE1', 'Conta Ag.Dep')
	TRCell():New( oSecCab,'E1_RECIBO ' ,'SE1', 'No. Recibo')
	TRCell():New( oSecCab,'E1_DTACRED' ,'SE1', 'Data p/ Comp')
	TRCell():New( oSecCab,'E1_EMITCHQ' ,'SE1', 'Emitente CHQ')
	TRCell():New( oSecCab,'E1_FILDEB ' ,'SE1', 'Fil.Debito')
	TRCell():New( oSecCab,'E1_NUMSOL ' ,'SE1', 'No. Solic.')
	TRCell():New( oSecCab,'E1_NUMRA  ' ,'SE1', 'Numero RA')
	TRCell():New( oSecCab,'E1_INSCRIC' ,'SE1', 'Inscric.P.S.')
	TRCell():New( oSecCab,'E1_SERREC ' ,'SE1', 'Serie Recibo')
	TRCell():New( oSecCab,'E1_DATAEDI' ,'SE1', 'Data EDI')
	TRCell():New( oSecCab,'E1_CODBAR ' ,'SE1', 'Codig.Barras')
	TRCell():New( oSecCab,'E1_CHQDEV ' ,'SE1', 'Chq Devolvid')
	TRCell():New( oSecCab,'E1_CODDIG ' ,'SE1', 'Codig.Digita')
	TRCell():New( oSecCab,'E1_VLBOLSA' ,'SE1', 'Valor Bolsa')
	TRCell():New( oSecCab,'E1_LIDESCF' ,'SE1', 'Lim Desc Fin')
	TRCell():New( oSecCab,'E1_VLFIES ' ,'SE1', 'Bolsa Fies')
	TRCell():New( oSecCab,'E1_NUMCRD ' ,'SE1', 'Contr Financ')
	TRCell():New( oSecCab,'E1_DEBITO ' ,'SE1', 'Conta Deb.')
	TRCell():New( oSecCab,'E1_CCD    ' ,'SE1', 'C.Custo Deb.')
	TRCell():New( oSecCab,'E1_ITEMD  ' ,'SE1', 'Item Ctb.Deb')
	TRCell():New( oSecCab,'E1_CLVLDB ' ,'SE1', 'Cl.Vlr. Deb.')
	TRCell():New( oSecCab,'E1_CREDIT ' ,'SE1', 'Conta Cred.')
	TRCell():New( oSecCab,'E1_CCC    ' ,'SE1', 'C.Custo Cred')
	TRCell():New( oSecCab,'E1_ITEMC  ' ,'SE1', 'It.Ctb.Cred.')
	TRCell():New( oSecCab,'E1_CLVLCR ' ,'SE1', 'Cl.Vlr. Cred')
	TRCell():New( oSecCab,'E1_DESCONT' ,'SE1', 'Desconto')
	TRCell():New( oSecCab,'E1_DESCONT' ,'SE1', 'Desconto')
	TRCell():New( oSecCab,'E1_DTDESC3' ,'SE1', 'Dat.Desconto')
	TRCell():New( oSecCab,'E1_DTDESC3' ,'SE1', 'Dat.Desconto')
	TRCell():New( oSecCab,'E1_DTDESC3' ,'SE1', 'Dat.Desconto')
	TRCell():New( oSecCab,'E1_VLMULTA' ,'SE1', 'Valor Multa')
	TRCell():New( oSecCab,'E1_DESCONT' ,'SE1', 'Desconto')
	TRCell():New( oSecCab,'E1_MOTNEG ' ,'SE1', 'Motivo Negoc')
	TRCell():New( oSecCab,'E1_SABTPIS' ,'SE1', 'Saldo Ab.Pis')
	TRCell():New( oSecCab,'E1_SABTCOF' ,'SE1', 'Saldo Ab.COF')
	TRCell():New( oSecCab,'E1_FORNISS' ,'SE1', 'Forn.ISS')
	TRCell():New( oSecCab,'E1_PARTOT ' ,'SE1', 'Parcela atua')
	TRCell():New( oSecCab,'E1_SITFAT ' ,'SE1', 'Sit. Fatura')
	TRCell():New( oSecCab,'E1_BASEPIS' ,'SE1', 'Base Pis')
	TRCell():New( oSecCab,'E1_BASECOF' ,'SE1', 'Base Cof')
	TRCell():New( oSecCab,'E1_BASECSL' ,'SE1', 'Base Csll')
	TRCell():New( oSecCab,'E1_VRETISS' ,'SE1', 'Valor Rt.ISS')
	TRCell():New( oSecCab,'E1_PARCIRF' ,'SE1', 'Parcela IRRF')
	TRCell():New( oSecCab,'E1_SCORGP ' ,'SE1', 'PisCof OrgP.')
	TRCell():New( oSecCab,'E1_FRETISS' ,'SE1', 'Form Ret ISS')
	TRCell():New( oSecCab,'E1_TXMDCOR' ,'SE1', 'Tx Cor.Moeda')
	TRCell():New( oSecCab,'E1_SATBIRF' ,'SE1', 'Saldo Ab.irf')
	TRCell():New( oSecCab,'E1_TIPREG ' ,'SE1', 'Tp. Registro')
	TRCell():New( oSecCab,'E1_CONEMP ' ,'SE1', 'Contr. Empr.')
	TRCell():New( oSecCab,'E1_VERCON ' ,'SE1', 'Versão Contr')
	TRCell():New( oSecCab,'E1_SUBCON ' ,'SE1', 'Sub-Contrato')
	TRCell():New( oSecCab,'E1_VERSUB ' ,'SE1', 'Versao Sub')
	TRCell():New( oSecCab,'E1_PLLOTE ' ,'SE1', 'Lote PLS')
	TRCell():New( oSecCab,'E1_PLOPELT' ,'SE1', 'Operadora Lt')
	TRCell():New( oSecCab,'E1_CODRDA ' ,'SE1', 'Código RDA')
	TRCell():New( oSecCab,'E1_FORMREC' ,'SE1', 'Forma Pagto')
	TRCell():New( oSecCab,'E1_BCOCLI ' ,'SE1', 'Banco Client')
	TRCell():New( oSecCab,'E1_AGECLI ' ,'SE1', 'Agencia Cli.')
	TRCell():New( oSecCab,'E1_CTACLI ' ,'SE1', 'Conta Cli.')
	TRCell():New( oSecCab,'E1_PARCFET' ,'SE1', 'Parc.FETHAB')
	TRCell():New( oSecCab,'E1_FETHAB ' ,'SE1', 'Vlr.FETHAB')
	TRCell():New( oSecCab,'E1_NUMCON ' ,'SE1', 'Nro.Contrato')
	TRCell():New( oSecCab,'E1_OBS    ' ,'SE1', 'Observacao')
	TRCell():New( oSecCab,'E1_PREOPER' ,'SE1', 'Pre-Operat.')
	TRCell():New( oSecCab,'E1_APLVLMN' ,'SE1', 'Aplica Vlr')
	TRCell():New( oSecCab,'E1_NFELETR' ,'SE1', 'NF Eletr.')
	TRCell():New( oSecCab,'E1_VRETIRF' ,'SE1', 'Vlr.Rt.Irf')
	TRCell():New( oSecCab,'E1_MDCRON ' ,'SE1', 'Num. Cronogr')
	TRCell():New( oSecCab,'E1_MDCONTR' ,'SE1', 'Num. Contrat')
	TRCell():New( oSecCab,'E1_MEDNUME' ,'SE1', 'Num. Medição')
	TRCell():New( oSecCab,'E1_MDPLANI' ,'SE1', 'Num. Planilh')
	TRCell():New( oSecCab,'E1_MDPARCE' ,'SE1', 'Num. Parcela')
	TRCell():New( oSecCab,'E1_MDREVIS' ,'SE1', 'Revisão')
	TRCell():New( oSecCab,'E1_NUMMOV ' ,'SE1', 'Movimento')
	TRCell():New( oSecCab,'E1_NODIA  ' ,'SE1', 'Seq. Diario')
	TRCell():New( oSecCab,'E1_RETCNTR' ,'SE1', 'Retencao Ctr')
	TRCell():New( oSecCab,'E1_MDDESC ' ,'SE1', 'Desconto Ctr')
	TRCell():New( oSecCab,'E1_MDBONI ' ,'SE1', 'Bonific Ctr')
	TRCell():New( oSecCab,'E1_MDMULT ' ,'SE1', 'Multa Ctr')
	TRCell():New( oSecCab,'E1_DOCTEF ' ,'SE1', 'Num. NSU')
	TRCell():New( oSecCab,'E1_DIACTB ' ,'SE1', 'Cod Diario')
	TRCell():New( oSecCab,'E1_SABTIRF' ,'SE1', 'Sld Abt Irrf')
	TRCell():New( oSecCab,'E1_VLMINIS' ,'SE1', 'Vlr Min ISS')
	TRCell():New( oSecCab,'E1_CODISS ' ,'SE1', 'Cod.Aliq.ISS')
	TRCell():New( oSecCab,'E1_BASEINS' ,'SE1', 'Base INSS')
	TRCell():New( oSecCab,'E1_PARCFAC' ,'SE1', 'Parc.FACS')
	TRCell():New( oSecCab,'E1_BASEIRF' ,'SE1', 'Base Impost.')
	TRCell():New( oSecCab,'E1_PARCFAB' ,'SE1', 'Parc.FABOV')
	TRCell():New( oSecCab,'E1_FABOV  ' ,'SE1', 'Vlr.FABOV')
	TRCell():New( oSecCab,'E1_BASEISS' ,'SE1', 'Base ISS')
	TRCell():New( oSecCab,'E1_FACS   ' ,'SE1', 'Vlr.FACS')
	TRCell():New( oSecCab,'E1_TITPAI ' ,'SE1', 'Tit.Pai PCC')
	TRCell():New( oSecCab,'E1_SEQBX  ' ,'SE1', 'Seq.Baixa')
	TRCell():New( oSecCab,'E1_NUMPRO ' ,'SE1', 'Proc. Refer.')
	TRCell():New( oSecCab,'E1_INDPRO ' ,'SE1', 'Tp. Processo')
	TRCell():New( oSecCab,'E1_TPDP   ' ,'SE1', 'Vlr. TPDP')
	TRCell():New( oSecCab,'E1_PARTPDP' ,'SE1', 'Par. TPDP')
	TRCell():New( oSecCab,'E1_RELATO ' ,'SE1', 'Env. Relato')
	TRCell():New( oSecCab,'E1_CODIRRF' ,'SE1', 'Cod.Rec.IRRF')
	TRCell():New( oSecCab,'E1_FAMAD  ' ,'SE1', 'Vl.FAMAD')
	TRCell():New( oSecCab,'E1_PARCFAM' ,'SE1', 'Parc.FAMAD')
	TRCell():New( oSecCab,'E1_FMPEQ  ' ,'SE1', 'Vl.FUMIPEQ')
	TRCell():New( oSecCab,'E1_PARCFMP' ,'SE1', 'Parc.FUMIPEQ')
	TRCell():New( oSecCab,'E1_NSUTEF ' ,'SE1', 'NSU SITEF')
	TRCell():New( oSecCab,'E1_PRINSS ' ,'SE1', 'Prov INSS')
	TRCell():New( oSecCab,'E1_PRISS  ' ,'SE1', 'Prov ISS')
	TRCell():New( oSecCab,'E1_PRODUTO' ,'SE1', 'Produto')
	TRCell():New( oSecCab,'E1_PERLET ' ,'SE1', 'Per. Letivo')
	TRCell():New( oSecCab,'E1_CHAVENF' ,'SE1', 'Chave NF')
	TRCell():New( oSecCab,'E1_PREFORI' ,'SE1', 'Pref Origem')
	TRCell():New( oSecCab,'E1_IDMOV  ' ,'SE1', 'Id.Mov.')
	TRCell():New( oSecCab,'E1_MULTDIA' ,'SE1', 'Multa ao Dia')
	TRCell():New( oSecCab,'E1_JURFAT ' ,'SE1', 'Num Fat Jur')
	TRCell():New( oSecCab,'E1_TPDESC ' ,'SE1', 'Desc. F100')
	TRCell():New( oSecCab,'E1_IDAPLIC' ,'SE1', 'Matriz Aplic')
	TRCell():New( oSecCab,'E1_VLBOLP ' ,'SE1', 'Bolsa Pontu.')
	TRCell():New( oSecCab,'E1_SERVICO' ,'SE1', 'Cod. Servico')
	TRCell():New( oSecCab,'E1_IDBOLET' ,'SE1', 'Id.Boleto')
	TRCell():New( oSecCab,'E1_NUMINSC' ,'SE1', 'Num. Inscr.')
	TRCell():New( oSecCab,'E1_PROCEL ' ,'SE1', 'Proc. Sel.')
	TRCell():New( oSecCab,'E1_IDLAN  ' ,'SE1', 'Nr. Lancto.')
	TRCell():New( oSecCab,'E1_LTCXA  ' ,'SE1', 'Lote Cxa')
	TRCell():New( oSecCab,'E1_NOPER  ' ,'SE1', 'N. Trans')
	TRCell():New( oSecCab,'E1_TURMA  ' ,'SE1', 'Turma')
	TRCell():New( oSecCab,'E1_RATFIN ' ,'SE1', 'Rateio Fin')
	TRCell():New( oSecCab,'E1_FUNDESA' ,'SE1', 'Vlr.FUNDESA')
	TRCell():New( oSecCab,'E1_IMAMT  ' ,'SE1', 'Vlr.IMA-MT')
	TRCell():New( oSecCab,'E1_FASEMT ' ,'SE1', 'Vlr. FASE-MT')
	TRCell():New( oSecCab,'E1_PARFUND' ,'SE1', 'Parc.FUNDESA')
	TRCell():New( oSecCab,'E1_PARIMA ' ,'SE1', 'Parc. IMA-MT')
	TRCell():New( oSecCab,'E1_PARFASE' ,'SE1', 'Parc. FASE-M')
	TRCell():New( oSecCab,'E1_CCUSTO ' ,'SE1', 'C. de Custo')
	TRCell():New( oSecCab,'E1_DESCJUR' ,'SE1', 'Desc.Juros')
	TRCell():New( oSecCab,'E1_TPESOC ' ,'SE1', 'Tp serviço')
	TRCell():New( oSecCab,'E1_CNO    ' ,'SE1', 'Cod CNO')
	TRCell():New( oSecCab,'E1_CTRBCO ' ,'SE1', 'Contr MCMV')
	TRCell():New( oSecCab,'E1_CODRET ' ,'SE1', 'Cod. Ret.PCC')
	TRCell():New( oSecCab,'E1_CDRETIR' ,'SE1', 'Cod. Ret. IR')
	TRCell():New( oSecCab,'E1_CDRETCS' ,'SE1', 'Cod. Ret. CS')
	TRCell():New( oSecCab,'E1_CLVL   ' ,'SE1', 'Classe Valor')
	TRCell():New( oSecCab,'E1_ITEMCTA' ,'SE1', 'Item Contab.')
	TRCell():New( oSecCab,'E1_SDOCREC' ,'SE1', 'Série Recibo')
	TRCell():New( oSecCab,'E1_SDOC   ' ,'SE1', 'Série Doc.')
	TRCell():New( oSecCab,'E1_TCONHTL' ,'SE1', 'Tipo Conta')
	TRCell():New( oSecCab,'E1_CONHTL ' ,'SE1', 'Conta Hotel')
	TRCell():New( oSecCab,'E1_BOLETO ' ,'SE1', 'Gera boleto')
	TRCell():New( oSecCab,'E1_CODSERV' ,'SE1', 'Cod.Serv.ISS')
	TRCell():New( oSecCab,'E1_BTRISS ' ,'SE1', 'ISS Bitribut')
	TRCell():New( oSecCab,'E1_VRETBIS' ,'SE1', 'Vlr. Ret ISB')

	oSecCab:PrintLine()
Return

Static Function PrintReport(oReport)
	Local cAlias := GetNextAlias()
	oSecCab:BeginQuery()
	BeginSql Alias cAlias
		SELECT  E1_FILIAL 	,
E1_X_SITUA	,
//E1_X_DESCR	,
E1_PREFIXO	,
E1_NUM    	,
E1_PARCELA	,
E1_TIPO   	,
E1_NATUREZ	,
E1_PORTADO	,
E1_AGEDEP 	,
E1_CLIENTE	,
E1_LOJA   	,
E1_NOMCLI 	,
E1_NUMBOR 	,
E1_EMISSAO	,
E1_VENCTO 	,
E1_VENCREA	,
E1_BAIXA  	,
E1_VALOR  	,
E1_IRRF   	,
E1_ISS    	,
E1_NUMBCO 	,
E1_INDICE 	,
E1_DATABOR	,
E1_EMIS1  	,
E1_HIST   	,
E1_LA     	,
E1_LOTE   	,
E1_MOTIVO 	,
E1_MOVIMEN	,
E1_OP     	,
E1_SITUACA	,
E1_CONTRAT	,
E1_SALDO  	,
E1_SUPERVI	,
E1_VEND1  	,
E1_VEND2  	,
E1_VEND3  	,
E1_VEND4  	,
E1_VEND5  	,
E1_COMIS1 	,
E1_COMIS2 	,
E1_COMIS3 	,
E1_COMIS4 	,
E1_DESCONT	,
E1_COMIS5 	,
E1_MULTA  	,
E1_JUROS  	,
E1_CORREC 	,
E1_VALLIQ 	,
E1_VENCORI	,
E1_VALJUR 	,
E1_PORCJUR	,
E1_MOEDA  	,
E1_BASCOM1	,
E1_BASCOM2	,
E1_BASCOM3	,
E1_BASCOM4	,
E1_BASCOM5	,
E1_FATPREF	,
E1_OK     	,
E1_FATURA 	,
E1_PROJETO	,
E1_CLASCON	,
E1_VALCOM1	,
E1_VALCOM2	,
E1_VALCOM3	,
E1_VALCOM4	,
E1_VALCOM5	,
E1_OCORREN	,
E1_INSTR1 	,
E1_INSTR2 	,
E1_PEDIDO 	,
E1_DTVARIA	,
E1_VARURV 	,
E1_VLCRUZ 	,
E1_NUMNOTA	,
E1_SERIE  	,
E1_DTFATUR	,
E1_STATUS 	,
E1_IDENTEE	,
E1_ORIGEM 	,
E1_NUMCART	,
E1_FLUXO  	,
E1_DESCFIN	,
E1_DIADESC	,
E1_TIPODES	,
E1_CARTAO 	,
E1_CARTVAL	,
E1_CARTAUT	,
E1_VLRREAL	,
E1_ADM    	,
E1_TRANSF 	,
E1_BCOCHQ 	,
E1_AGECHQ 	,
E1_CTACHQ 	,
E1_ORDPAGO	,
E1_NUMLIQ 	,
E1_INSS   	,
E1_FILORIG	,
E1_TIPOFAT	,
E1_TIPOLIQ	,
E1_CSLL   	,
E1_COFINS 	,
E1_PIS    	,
E1_MESBASE	,
E1_ANOBASE	,
E1_PLNUCOB	,
E1_CODINT 	,
E1_CODEMP 	,
E1_MATRIC 	,
E1_TXMOEDA	,
E1_ACRESC 	,
E1_SDACRES	,
E1_DECRESC	,
E1_SDDECRE	,
E1_MULTNAT	,
E1_MSFIL  	,
E1_MSEMP  	,
E1_PROJPMS	,
E1_DESDOBR	,
E1_NRDOC  	,
E1_MODSPB 	,
E1_IDCNAB 	,
E1_PLCOEMP	,
E1_PLTPCOE	,
E1_CODCOR 	,
E1_PARCCSS	,
E1_CODORCA	,
E1_FLAGFAT	,
E1_CODIMOV	,
E1_CONTAG 	,
E1_USUARIO	,
E1_CCONTAB	,
E1_ITEM   	,
E1_SABTCLS	,
E1_SABTCSL	,
E1_CONTA  	,
E1_RECIBO 	,
E1_DTACRED	,
E1_EMITCHQ	,
E1_FILDEB 	,
E1_NUMSOL 	,
E1_NUMRA  	,
E1_INSCRIC	,
E1_SERREC 	,
E1_CODBAR 	,
E1_CHQDEV 	,
E1_CODDIG 	,
E1_VLBOLSA	,
E1_DATAEDI	,
E1_LIDESCF	,
E1_VLFIES 	,
E1_NUMCRD 	,
E1_DEBITO 	,
E1_CCD    	,
E1_ITEMD  	,
E1_CLVLDB 	,
E1_CREDIT 	,
E1_CCC    	,
E1_ITEMC  	,
E1_CLVLCR 	,
E1_DESCON1	,
E1_DESCON2	,
E1_DTDESC3	,
E1_DTDESC1	,
E1_DTDESC2	,
E1_VLMULTA	,
E1_DESCON3	,
E1_MOTNEG 	,
E1_SABTPIS	,
E1_SABTCOF	,
E1_FORNISS	,
E1_PARTOT 	,
E1_SITFAT 	,
E1_BASEPIS	,
E1_BASECOF	,
E1_BASECSL	,
E1_VRETISS	,
E1_PARCIRF	,
E1_SCORGP 	,
E1_FRETISS	,
E1_TXMDCOR	,
E1_SATBIRF	,
E1_TIPREG 	,
E1_CONEMP 	,
E1_VERCON 	,
E1_SUBCON 	,
E1_VERSUB 	,
E1_PLLOTE 	,
E1_PLOPELT	,
E1_CODRDA 	,
E1_FORMREC	,
E1_BCOCLI 	,
E1_AGECLI 	,
E1_CTACLI 	,
E1_PARCFET	,
E1_FETHAB 	,
E1_NUMCON 	,
E1_OBS    	,
E1_PREOPER	,
E1_APLVLMN	,
E1_NFELETR	,
E1_VRETIRF	,
E1_USERLGI	,
E1_USERLGA	,
E1_MDCRON 	,
E1_MDCONTR	,
E1_MEDNUME	,
E1_MDPLANI	,
E1_MDPARCE	,
E1_MDREVIS	,
E1_NUMMOV 	,
E1_NODIA  	,
E1_RETCNTR	,
E1_MDDESC 	,
E1_MDBONI 	,
E1_MDMULT 	,
E1_DOCTEF 	,
E1_DIACTB 	,
E1_SABTIRF	,
E1_VLMINIS	,
E1_CODISS 	,
E1_BASEINS	,
E1_PARCFAC	,
E1_BASEIRF	,
E1_PARCFAB	,
E1_FABOV  	,
E1_BASEISS	,
E1_FACS   	,
E1_TITPAI 	,
E1_SEQBX  	,
E1_NUMPRO 	,
E1_INDPRO 	,
E1_TPDP   	,
E1_PARTPDP	,
E1_RELATO 	,
E1_CODIRRF	,
E1_FAMAD  	,
E1_PARCFAM	,
E1_FMPEQ  	,
E1_PARCFMP	,
E1_NSUTEF 	,
E1_PRINSS 	,
E1_PRISS  	,
E1_PRODUTO	,
E1_PERLET 	,
E1_CHAVENF	,
E1_PREFORI	,
E1_IDMOV  	,
E1_MULTDIA	,
E1_JURFAT 	,
E1_TPDESC 	,
E1_IDAPLIC	,
E1_VLBOLP 	,
E1_SERVICO	,
E1_IDBOLET	,
E1_NUMINSC	,
E1_PROCEL 	,
E1_IDLAN  	,
E1_LTCXA  	,
E1_NOPER  	,
E1_TURMA  	,
E1_RATFIN 	,
E1_FUNDESA	,
E1_IMAMT  	,
E1_FASEMT 	,
E1_PARFUND	,
E1_PARIMA 	,
E1_PARFASE	,
E1_CCUSTO 	,
E1_DESCJUR	,
E1_TPESOC 	,
E1_CNO    	,
E1_CTRBCO 	,
E1_CODRET 	,
E1_CDRETIR	,
E1_CDRETCS	,
E1_CLVL   	,
E1_ITEMCTA	,
E1_SDOCREC	,
E1_SDOC   	,
E1_TCONHTL	,
E1_CONHTL 	,
E1_BOLETO 	,
E1_CODSERV	,
E1_BTRISS 	,
E1_VRETBIS	,
E1_PARCIMA	,
E1_IMA    	
		FROM %table:SE1% SE1
		WHERE 
			SE1.%notDel% AND
			SE1.E1_EMISSAO BETWEEN %exp:(dtos(MV_PAR01))% AND %exp:(dtos(MV_PAR02))%
	EndSql
	oSecCab:EndQuery()
	oSecCab:Print()
	(cAlias)->(DbCloseArea())
Return
