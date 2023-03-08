unit form_visualizar_historico;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, CheckLst, Grids, Wwdbigrd, Wwdbgrid, RxMemDS, wwdblook, IBUpdateSQL,
  dblookup, ExtCtrls, wwdbdatetimepicker, Mask;

type
  Tvisualizar_historico = class(TForm)
    grdManequim: TwwDBGrid;
    dtsHistorico: TDataSource;
    qryHistorico: TIBQuery;
    Panel1: TPanel;
    btn_sair: TSpeedButton;
    lblResultado: TLabel;
    qryUsuario: TIBQuery;
    qryUsuarioCODIGO: TIntegerField;
    qryUsuarioUSERNAME: TIBStringField;
    dtsUsuario: TDataSource;
    qryHistoricoCODIGOORIGEM: TIntegerField;
    qryHistoricoID: TIntegerField;
    qryHistoricoTIPO: TIntegerField;
    qryHistoricoDATA: TDateField;
    qryHistoricoHORA: TTimeField;
    qryHistoricoCODIGOSITUACAO: TIntegerField;
    qryHistoricoDESCRICAOSITUACAO: TIBStringField;
    qryHistoricoUSERNAME: TIBStringField;
    qryHistoricoNOMESITUACAO: TIBStringField;
    qryHistoricoDATAFIM: TDateField;
    qryHistoricoHORAFIM: TTimeField;
    qryHistoricoOBSERVACOES: TIBStringField;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure qryHistoricoBeforeOpen(DataSet: TDataSet);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure FormCreate(Sender: TObject); // e esta tb
    //FIM BOTÃO HELP
  private
    bIniciando: Boolean;
    { Private declarations }
  public
    ok: Boolean;
    FormChamado : Tform;
    _codigoRegistro : Integer;
    { Public declarations }
  end;

var
  visualizar_historico: Tvisualizar_historico;

implementation

uses untDados, funcao, versao;

Const
  cCaption = 'AVALIAR';

{$R *.dfm}

//BOTÃO HELP
procedure Tvisualizar_historico.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure Tvisualizar_historico.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ControleVersao.ShowAlteracoes(self.Name);
  end
  else
    inherited;
end;
//FIM BOTÃO HELP

procedure Tvisualizar_historico.btn_sairClick(Sender: TObject);
begin
  Close;
end;

procedure Tvisualizar_historico.FormCreate(Sender: TObject);
begin
   Caption := CaptionTela(cCaption);
end;

procedure Tvisualizar_historico.FormShow(Sender: TObject);
var
  i: Integer;
begin
  Top := 175;
  Left := 185;

  qryHistorico.Close;
  qryHistorico.Open;

end;

procedure Tvisualizar_historico.qryHistoricoBeforeOpen(DataSet: TDataSet);
begin
  qryHistorico.ParamByName('CODIGOREGISTRO').Value := _codigoRegistro;
end;

end.
