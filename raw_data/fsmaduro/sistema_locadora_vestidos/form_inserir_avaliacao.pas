unit form_inserir_avaliacao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, CheckLst, Grids, Wwdbigrd, Wwdbgrid, RxMemDS, wwdblook, IBUpdateSQL,
  dblookup, ExtCtrls, wwdbdatetimepicker, Mask;

type TTipoFinalidadeAvaliacao = (tAvPerfil, tAvProduto);

type
  Tinserir_avaliacao = class(TForm)
    qryGeral: TIBQuery;
    grdManequim: TwwDBGrid;
    qryAvaliacao: TIBQuery;
    updAvaliacaoPerfil: TIBUpdateSQL;
    dtsAvaliacaoPerfil: TDataSource;
    qryAvaliacaoPerfil: TIBQuery;
    qryAvaliacaoDESCRIACAOAVALIACAO: TIBStringField;
    qryAvaliacaoCODIGOAVALIACAO: TIntegerField;
    qryAvaliacaoID: TIntegerField;
    qryAvaliacaoDESCRICAO: TIBStringField;
    qryAvaliacaoVALOR: TIBBCDField;
    qryAvaliacaoPerfilDESCRICAO: TStringField;
    qryAvaliacaoCombo: TIBQuery;
    IBStringField1: TIBStringField;
    IBStringField2: TIBStringField;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    IBBCDField1: TIBBCDField;
    dtsAvaliacaoCombo: TDataSource;
    wwDBLookupCombo1: TwwDBLookupCombo;
    qryAvaliacaoPerfilDESCRICAORESULTADO: TStringField;
    IBQuery1: TIBQuery;
    Panel1: TPanel;
    btn_ok: TSpeedButton;
    btn_sair: TSpeedButton;
    lblValorResultado: TLabel;
    lblDescricaoResultado: TLabel;
    Panel7: TPanel;
    Panel2: TPanel;
    edtCodigo: TDBEdit;
    lblCodigo: TLabel;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    Label1: TLabel;
    DBEdit24: TDBEdit;
    Label17: TLabel;
    DBEdit6: TDBEdit;
    Label30: TLabel;
    Panel3: TPanel;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    Label2: TLabel;
    qryAvaliacaoPerfilGeral: TIBQuery;
    dtsAvaliacaoPerfilGeral: TDataSource;
    updAvaliacaoPerfilGeral: TIBUpdateSQL;
    DBEdit1: TDBEdit;
    Label3: TLabel;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    dtsUsuario: TDataSource;
    qryAvaliacaoPerfilGeralNomeUsuario: TStringField;
    DBMemo1: TDBMemo;
    Label6: TLabel;
    lblResultadoParcial: TLabel;
    RxDBLookupCombo3: TRxDBLookupCombo;
    Label45: TLabel;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    qryAvaliacaoPerfilGeralCODIGOORIGEM: TIntegerField;
    qryAvaliacaoPerfilGeralCODIGOQUESTIONARIO: TIntegerField;
    qryAvaliacaoPerfilGeralCODIGOUSUARIO: TIntegerField;
    qryAvaliacaoPerfilGeralDATA: TDateField;
    qryAvaliacaoPerfilGeralHORA: TTimeField;
    qryAvaliacaoPerfilGeralTIPO: TIntegerField;
    qryAvaliacaoPerfilGeralCODIGOREGISTRO: TIntegerField;
    qryAvaliacaoPerfilGeralOBSERVACOES: TIBStringField;
    qryAvaliacaoPerfilGeralDATAFIM: TDateField;
    qryAvaliacaoPerfilGeralHORAFIM: TTimeField;
    qryAvaliacaoPerfilGeralRESULTADO: TIBBCDField;
    qryAvaliacaoPerfilGeralCODIGOSITUACAO: TIntegerField;
    qryAvaliacaoPerfilCODIGOREGISTRO: TIntegerField;
    qryAvaliacaoPerfilCODIGOAVALIACAO: TIntegerField;
    qryAvaliacaoPerfilVALOR: TIBBCDField;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_okClick(Sender: TObject);
    procedure qryAvaliacaoPerfilAfterScroll(DataSet: TDataSet);
    procedure qryAvaliacaoComboBeforeOpen(DataSet: TDataSet);
    procedure qryAvaliacaoPerfilCalcFields(DataSet: TDataSet);
    procedure qryAvaliacaoPerfilAfterPost(DataSet: TDataSet);
    procedure qryAvaliacaoPerfilAfterOpen(DataSet: TDataSet);
    procedure qryAvaliacaoPerfilGeralBeforeOpen(DataSet: TDataSet);
    procedure qryAvaliacaoPerfilGeralBeforePost(DataSet: TDataSet);
    procedure RxDBLookupCombo3Enter(Sender: TObject);
    procedure RxDBLookupCombo3Exit(Sender: TObject);
    procedure qrySituacaoBeforeOpen(DataSet: TDataSet);
  private
    bIniciando: Boolean;
    { Private declarations }
    procedure IniciarRegistros;
    procedure Totalizar;
    procedure VerificarAlteracaoSituacao;
    procedure AtualizarResultado;
  public
    ok: Boolean;
    FormChamado : Tform;
    _Finalidade : TTipoFinalidadeAvaliacao;
    _codigoOrigem : Integer;
    _codigoRegistro : Integer;
    cCodigoSituacaoAlterada, cOldCodigo : String;
    { Public declarations }
  end;

var
  inserir_avaliacao: Tinserir_avaliacao;

implementation

uses untDados, funcao;

{$R *.dfm}

procedure Tinserir_avaliacao.AtualizarResultado;
var
  cTotal : Double;
begin

  if qryAvaliacaoPerfilGeralCODIGOSITUACAO.Text <> '' then
  begin

    IBQuery1.Close;
    IBQuery1.SQL.Text := 'select sum(valor) as total '+
                         '  from tabavaliacaoperfilgeral g '+
                         ' inner join TABAVALIACAOPERFIL a on (g.codigoregistro = a.codigoregistro) '+
                         ' where g.codigoorigem =' +intToStr(_codigoOrigem)+
                         '   and g.tipo ='+iif(_Finalidade = tAvPerfil,'1','2');
    IBQuery1.Open;

    cTotal := IBQuery1.FieldByName('total').AsFloat;

    if cTotal < 0 then
    begin


      qryAvaliacaoPerfil.First;
      
      While not qryAvaliacaoPerfil.Eof do
      begin

        qryAvaliacaoPerfil.Edit;

        if qryAvaliacaoPerfil.Bof then
          qryAvaliacaoPerfilVALOR.AsFloat := cTotal * (-1)
        else
          qryAvaliacaoPerfilVALOR.AsFloat := 0;

        qryAvaliacaoPerfil.Post;

        qryAvaliacaoPerfil.Next;
      end;

      qryAvaliacaoPerfilGeral.Edit;
      qryAvaliacaoPerfilGeral.Post;

    end;


  end;

end;

procedure Tinserir_avaliacao.btn_okClick(Sender: TObject);
begin

  if not (qryAvaliacaoPerfilGeral.State in [dsEdit]) then
    qryAvaliacaoPerfilGeral.Edit;
    
  qryAvaliacaoPerfilGeral.Post;

  VerificarAlteracaoSituacao;

  AtualizarResultado;

  Dados.IBTransaction.CommitRetaining;

  Close;
  
end;

procedure Tinserir_avaliacao.btn_sairClick(Sender: TObject);
begin

  Dados.IBTransaction.RollBackRetaining;

  Close;
end;

procedure Tinserir_avaliacao.FormShow(Sender: TObject);
var
  i: Integer;
begin
  Top := 175;
  Left := 185;

  cCodigoSituacaoAlterada := '';

  qrySituacao.Close;
  qrySituacao.Open;

  IniciarRegistros
end;

procedure Tinserir_avaliacao.IniciarRegistros;
var
  Where : String;
  CodigoQuestionario : Integer;
begin

  qryAvaliacaoPerfilGeral.Close;
  qryAvaliacaoPerfilGeral.Open;

  qryAvaliacaoPerfil.Close;
  qryAvaliacaoPerfil.Open;

  if qryAvaliacaoPerfilGeral.IsEmpty then
  begin

    CodigoQuestionario := 0;
    grdManequim.Enabled := True;
    DBMemo1.Enabled := True;
    btn_ok.Enabled := True;
    RxDBLookupCombo3.Enabled := True;

    Dados.Geral.Close;
    Dados.Geral.SQL.Text := 'select MAX(CODIGOREGISTRO) AS CODIGOREGISTRO from TABAVALIACAOPERFILGERAL';
    Dados.Geral.Open;

    _codigoRegistro := Dados.Geral.fieldbyname('CODIGOREGISTRO').AsInteger + 1;

    if _Finalidade = tAvPerfil then
      Where := ' WHERE Q.APLICACAO IN (2,4) '
    else if _Finalidade = tAvProduto then
      Where := ' WHERE Q.APLICACAO IN (3,4) ';

    qryGeral.Close;
    qryGeral.SQL.Text := 'SELECT COUNT(1) AS QTD '+
                         '  FROM TABQUESTIONARIO Q '+
                         Where;
    qryGeral.Open;

    
    if not qryGeral.IsEmpty then
    begin

      if qryGeral.FieldByName('QTD').AsInteger > 1 then
      begin
        CodigoQuestionario := dados.DigitarValorBD('Selecione o Questionário',
                                                   'TABQUESTIONARIO Q '+Where,
                                                   1,
                                                   'DESCRICAO',
                                                   'CODIGO')

      
      end;

      qryGeral.Close;
      qryGeral.SQL.Text := 'SELECT Q.CODIGO AS CODIGOQUESTIONARIO, Q.DESCRICAO, A.* '+
                           '  FROM TABQUESTIONARIO Q '+
                           ' INNER JOIN TABQUESTIONARIOAVALIACAO QA ON (Q.CODIGO = QA.CODIGOQUESTIONARIO) '+
                           ' INNER JOIN TABAVALIACAO A ON (QA.CODIGOAVALIACAO = A.CODIGO) '+
                           Where +
                           iif(CodigoQuestionario > 0,' AND Q.CODIGO = '+intToStr(CodigoQuestionario),'');
      qryGeral.Open;
      CodigoQuestionario := qryGeral.FieldByName('CODIGOQUESTIONARIO').AsInteger;

      qryAvaliacaoPerfilGeral.Insert;
      qryAvaliacaoPerfilGeralCODIGOREGISTRO.AsInteger     := _codigoRegistro;
      qryAvaliacaoPerfilGeralCODIGOORIGEM.AsInteger       := _codigoOrigem;
      qryAvaliacaoPerfilGeralCODIGOQUESTIONARIO.AsInteger := CodigoQuestionario;
      qryAvaliacaoPerfilGeralCODIGOUSUARIO.AsInteger      := untDados.CodigoUsuarioCorrente;
      qryAvaliacaoPerfilGeralDATA.AsDateTime              := Date;
      qryAvaliacaoPerfilGeralHORA.AsDateTime              := Time;
      qryAvaliacaoPerfilGeralTIPO.AsInteger               := iif(_Finalidade = tAvPerfil,1,2);
      qryAvaliacaoPerfilGeral.Post;


      qryGeral.First;
      While not qryGeral.Eof do
      begin

        qryAvaliacaoPerfil.Insert;
        qryAvaliacaoPerfilCODIGOREGISTRO.AsInteger  := _codigoRegistro;
        qryAvaliacaoPerfilCODIGOAVALIACAO.AsInteger := qryGeral.FieldByName('CODIGO').AsInteger;
        qryAvaliacaoPerfil.Post;

        qryGeral.Next;
      end;

    end
    else
      Application.MessageBox(Pchar('Nenhum questionário definido!'),'ERRO',mb_OK+MB_ICONERROR);
  end
  else
  begin
    grdManequim.Enabled := False;
    DBMemo1.Enabled := False;
    btn_ok.Enabled := False;
    RxDBLookupCombo3.Enabled := False;
  end;

  qryAvaliacao.Close;
  qryAvaliacao.Open;

  qryAvaliacaoCombo.Close;
  qryAvaliacaoCombo.Open;

end;

procedure Tinserir_avaliacao.qryAvaliacaoComboBeforeOpen(DataSet: TDataSet);
begin
  qryAvaliacaoCombo.SQL.Strings[qryAvaliacaoCombo.SQL.IndexOf('--and')+1] := ' AND A.CODIGO =0'+qryAvaliacaoPerfilCODIGOAVALIACAO.Text;
end;

procedure Tinserir_avaliacao.qryAvaliacaoPerfilAfterOpen(DataSet: TDataSet);
begin
  Totalizar;
end;

procedure Tinserir_avaliacao.qryAvaliacaoPerfilAfterPost(DataSet: TDataSet);
begin
  Totalizar;
end;

procedure Tinserir_avaliacao.qryAvaliacaoPerfilAfterScroll(DataSet: TDataSet);
begin
  qryAvaliacaoCombo.Close;
  qryAvaliacaoCombo.Open;
end;

procedure Tinserir_avaliacao.qryAvaliacaoPerfilCalcFields(DataSet: TDataSet);
begin

  if qryAvaliacaoPerfilVALOR.Text <> '' then
  begin
  
    IBQuery1.Close;
    IBQuery1.SQL.Text := 'SELECT D.DESCRICAO '+
                         '  FROM TABAVALIACAODETALHE D '+
                         ' WHERE CODIGOAVALIACAO =0'+qryAvaliacaoPerfilCODIGOAVALIACAO.Text+
                         '   AND VALOR =0'+qryAvaliacaoPerfilVALOR.Text;
    IBQuery1.Open;

    qryAvaliacaoPerfilDESCRICAORESULTADO.Text := IBQuery1.FieldByName('DESCRICAO').Text;
    
  end;

end;

procedure Tinserir_avaliacao.qryAvaliacaoPerfilGeralBeforeOpen(
  DataSet: TDataSet);
var
  Filtro : String;
begin

  if _Finalidade = tAvPerfil then
    filtro := ' AND TIPO = 1 '
  else if _Finalidade = tAvProduto then
    filtro := ' AND TIPO = 2 ';

  qryAvaliacaoPerfilGeral.SQL.Strings[qryAvaliacaoPerfilGeral.SQL.IndexOf('--and')+1] := ' AND CODIGOREGISTRO =0'+intToStr(_codigoRegistro) + filtro;
end;

procedure Tinserir_avaliacao.qryAvaliacaoPerfilGeralBeforePost(
  DataSet: TDataSet);
begin

  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select sum(valor) as total '+
                       '  from TABAVALIACAOPERFIL '+
                       ' where CODIGOREGISTRO = '+intToStr(_codigoRegistro);
  IBQuery1.Open;

  qryAvaliacaoPerfilGeralRESULTADO.AsInteger := IBQuery1.FieldByName('total').AsInteger;
  
end;

procedure Tinserir_avaliacao.qrySituacaoBeforeOpen(DataSet: TDataSet);
var
  filtro : String;
begin
  if _Finalidade = tAvPerfil then
    filtro := ' AND APLICACAO IN (2,99) '
  else if _Finalidade = tAvProduto then
    filtro := ' AND APLICACAO IN (1,99) ';

  qrySituacao.SQL.Strings[qrySituacao.SQL.IndexOf('--and')+1] := filtro;

end;

procedure Tinserir_avaliacao.RxDBLookupCombo3Enter(Sender: TObject);
begin
  cOldCodigo := qryAvaliacaoPerfilGeralCODIGOSITUACAO.Text;
end;

procedure Tinserir_avaliacao.RxDBLookupCombo3Exit(Sender: TObject);
begin
  if (cOldCodigo <> qryAvaliacaoPerfilGeralCODIGOSITUACAO.Text) and (qryAvaliacaoPerfilGeral.State = dsEdit) then
  begin

    if Application.MessageBox('Ao definir a situação manualmente, o sistema zera a pontuação do cliente.'+#13+
                              'Deseja realmente informar a situação?','Gravar',MB_YESNO+MB_ICONQUESTION) = idNo then
    begin
       if qryAvaliacaoPerfilGeral.State in [dsInsert, dsEdit] then
         qryAvaliacaoPerfilGeralCODIGOSITUACAO.Text := '';
    end;

  end;
end;

procedure Tinserir_avaliacao.Totalizar;
begin

  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select sum(valor) as total '+
                       '  from TABAVALIACAOPERFIL '+
                       ' where CODIGOREGISTRO = '+intToStr(_codigoRegistro);
  IBQuery1.Open;

  lblResultadoParcial.Caption := 'Result. Parcial: '+IBQuery1.FieldByName('total').Text;


  IBQuery1.Close;
  IBQuery1.SQL.Text := 'select sum(a.valor) as total '+
                       '  from tabavaliacaoperfilgeral g '+
                       ' inner join TABAVALIACAOPERFIL a on (g.CODIGOREGISTRO = a.CODIGOREGISTRO) '+
                       ' where g.codigoorigem =' +intToStr(_codigoOrigem)+
                       '   and g.tipo ='+iif(_Finalidade = tAvPerfil,'1','2');
  IBQuery1.Open;

  lblValorResultado.Caption := IBQuery1.FieldByName('total').Text;

  if lblValorResultado.Caption <> '' then
  begin

    IBQuery1.Close;
    IBQuery1.SQL.Text := 'select S.DESCRICAO from TABQUESTIONARIODETALHE Q LEFT JOIN TABSITUACAOPRODUTO S ON (Q.CODIGOSITUACAO = S.CODIGO)'+
                         ' where Q.CODIGOQUESTIONARIO =0'+qryAvaliacaoPerfilGeralCODIGOQUESTIONARIO.Text +
                         ' AND '+lblValorResultado.Caption+' BETWEEN Q.VALORINICIAL AND Q.VALORFINAL';
    IBQuery1.Open;

    lblDescricaoResultado.Caption := 'Resultado: '+ lblValorResultado.Caption + '  '+IBQuery1.FieldByName('DESCRICAO').Text;
    
  end;

end;

procedure Tinserir_avaliacao.VerificarAlteracaoSituacao;
var
  cSituacao : Integer;
begin

  if lblValorResultado.Caption <> '' then
  begin

    IBQuery1.Close;
    IBQuery1.SQL.Text := 'select Q.*, S.DESCRICAO from TABQUESTIONARIODETALHE Q LEFT JOIN TABSITUACAOPRODUTO S ON (Q.CODIGOSITUACAO = S.CODIGO)'+
                         ' where Q.CODIGOQUESTIONARIO ='+qryAvaliacaoPerfilGeralCODIGOQUESTIONARIO.Text +
                         ' AND '+lblValorResultado.Caption+' BETWEEN Q.VALORINICIAL AND Q.VALORFINAL';
    IBQuery1.Open;

    if not IBQuery1.IsEmpty then
    begin

      if qryAvaliacaoPerfilGeralCODIGOSITUACAO.Text <> '' then
        cSituacao := qryAvaliacaoPerfilGeralCODIGOSITUACAO.AsInteger
      else
        cSituacao := IBQuery1.FieldByName('CODIGOSITUACAO').AsInteger;

      Dados.InserirHistorico(_codigoRegistro,
                             _codigoOrigem,
                             iif(_Finalidade = tAvPerfil,1,2),
                             cSituacao,
                             IBQuery1.FieldByName('DESCRICAO').Text,
                             qryAvaliacaoPerfilGeralDATAFIM.Text,
                             qryAvaliacaoPerfilGeralHORAFIM.Text);

      cCodigoSituacaoAlterada := intToStr(cSituacao);

    end;

  end;

end;

procedure Tinserir_avaliacao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  qryGeral.Close;
end;

end.
