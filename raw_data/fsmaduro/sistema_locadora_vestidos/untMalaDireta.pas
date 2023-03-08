unit untMalaDireta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RxLookup, DB, IBCustomDataSet, IBQuery, Menus,
  cxLookAndFeelPainters, cxButtons, untClasseLembrete, ACBrBase, ACBrSMS;

type
  TfrmMalaDireta = class(TForm)
    Panel1: TPanel;
    qryTipoPerfil: TIBQuery;
    IntegerField1: TIntegerField;
    qryTipoPerfilDESCRICAO: TIBStringField;
    qryTipoPerfilTIPO: TIntegerField;
    dtsTipoPerfil: TDataSource;
    Label15: TLabel;
    cbTipoPerfil: TRxDBLookupCombo;
    qrySituacao: TIBQuery;
    qrySituacaoCODIGO: TIntegerField;
    qrySituacaoDESCRICAO: TIBStringField;
    qrySituacaoAPLICACAO: TIntegerField;
    qrySituacaoOPERACAO: TIntegerField;
    qrySituacaoDIASREAVALIACAO: TIntegerField;
    dtsSituacao: TDataSource;
    Label45: TLabel;
    cbStatus: TRxDBLookupCombo;
    chbSMS: TCheckBox;
    chbEmail: TCheckBox;
    Label1: TLabel;
    mmMensagem: TMemo;
    btnIniciar: TcxButton;
    ACBrSMS1: TACBrSMS;
    IBQuery1: TIBQuery;
    cxButton1: TcxButton;
    procedure FormShow(Sender: TObject);
    procedure btnIniciarClick(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP; // e esta tb
    //FIM BOTÃO HELP
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMalaDireta: TfrmMalaDireta;

implementation

uses untdados, funcao, versao;

{$R *.dfm}

//BOTÃO HELP
procedure TfrmMalaDireta.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmMalaDireta.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmMalaDireta.btnIniciarClick(Sender: TObject);
var
  lFiltro: String;
begin

  lFiltro := ' 1=1';

  if cbTipoPerfil.KeyValue > 0 then
     lFiltro := lFiltro + ' and CODIGOTIPOPERFIL = '+IntToStr(cbTipoPerfil.KeyValue);

  if cbStatus.KeyValue > 0 then
     lFiltro := lFiltro + ' and CODIGOSITUACAO = '+IntToStr(cbStatus.KeyValue);

   Dados.regMalaDireta.EnviarEmail := chbEmail.Checked;
   Dados.regMalaDireta.EnviarSMS := chbSMS.Checked;
   Dados.regMalaDireta.Filtro := lFiltro;
   Dados.regMalaDireta.Mensagem := mmMensagem.Text;
   Dados.regMalaDireta.Iniciar := True;

end;

procedure TfrmMalaDireta.cxButton1Click(Sender: TObject);
begin
   Dados.regMalaDireta.EnviarEmail := False;
   Dados.regMalaDireta.EnviarSMS := False;
   Dados.regMalaDireta.Filtro := '';
   Dados.regMalaDireta.Mensagem := '';
   Dados.regMalaDireta.Iniciar := False;
end;

procedure TfrmMalaDireta.FormShow(Sender: TObject);
begin
   qryTipoPerfil.Open;
   qrySituacao.Open;
end;

end.
