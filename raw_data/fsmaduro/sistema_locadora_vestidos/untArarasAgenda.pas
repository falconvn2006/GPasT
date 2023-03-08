unit untArarasAgenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, cxLookAndFeelPainters, cxStyles, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, IBCustomDataSet,
  IBQuery, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxClasses, cxControls, cxGridCustomView, cxGrid, StdCtrls,
  cxButtons, DBCtrls, ExtCtrls, cxLookAndFeels, dxSkinBlack, dxSkinBlue,
   dxSkinCaramel, dxSkinCoffee,  dxSkinDarkSide,
  dxSkinGlassOceans,  dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver,
   dxSkinPumpkin,
   dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinValentine,  dxSkinXmas2008Blue;

type
  TfrmArarasAgenda = class(TForm)
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    DBText1: TDBText;
    cxButton6: TcxButton;
    grdPainel: TcxGrid;
    grdPainelDBTableView1: TcxGridDBTableView;
    grdPainelLevel1: TcxGridLevel;
    qryPainel: TIBQuery;
    dtsPainel: TDataSource;
    qryPainelCODIGO: TIntegerField;
    qryPainelPERFIL: TIBStringField;
    qryPainelPRODUTOS: TIntegerField;
    grdPainelDBTableView1CODIGO: TcxGridDBColumn;
    grdPainelDBTableView1PERFIL: TcxGridDBColumn;
    grdPainelDBTableView1PRODUTOS: TcxGridDBColumn;
    Panel2: TPanel;
    cxButton5: TcxButton;
    cxButton1: TcxButton;
    chbSemFoto: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure qryPainelBeforeOpen(DataSet: TDataSet);
    procedure cxButton6Click(Sender: TObject);
    procedure cxButton5Click(Sender: TObject);
    procedure cxButton1Click(Sender: TObject);

    //BOTÃO HELP
    procedure wmNCLButtonDown(var Msg: TWMNCLButtonDown); message WM_NCLBUTTONDOWN; // adicione esta procedure
    procedure wmNCLButtonUp(var Msg: TWMNCLButtonUp); message WM_NCLBUTTONUP;
    procedure FormCreate(Sender: TObject); // e esta tb
    //FIM BOTÃO HELP
  private
    { Private declarations }
  public
    vCodigo: integer;
    { Public declarations }
  end;

var
  frmArarasAgenda: TfrmArarasAgenda;

implementation

uses untARARA, untDtmRelatorios, funcao, versao;

Const
  cCaption = 'ARARAS DA AGENDA';

{$R *.dfm}

//BOTÃO HELP
procedure TfrmArarasAgenda.wmNCLButtonDown(var Msg: TWMNCLButtonDown);
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0; // swallow mouse down on biHelp border icon
  end
  else
    inherited;
end;

procedure TfrmArarasAgenda.wmNCLButtonUp(var Msg: TWMNCLButtonUp);
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

procedure TfrmArarasAgenda.cxButton1Click(Sender: TObject);
begin
  frmDtmRelatorios.ImprimirArara(qryPainelCODIGO.AsInteger, chbSemFoto.Checked);
end;

procedure TfrmArarasAgenda.cxButton5Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmArarasAgenda.cxButton6Click(Sender: TObject);
begin
  If Application.FindComponent('frmARARA') = Nil then
    FreeAndNil(frmARARA);
  Application.CreateForm(TfrmARARA, frmARARA);

  frmARARA.vCodigo := qryPainelCODIGO.AsInteger;

  frmARARA.ShowModal;

  try
    qryPainel.Close;
    qryPainel.Open;
  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmArarasAgenda.FormCreate(Sender: TObject);
begin
   Caption := CaptionTela(cCaption);
end;

procedure TfrmArarasAgenda.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  try

    qryPainel.Close;
    qryPainel.Open;

  except
    on E:Exception do
      application.MessageBox(Pchar('Erro ao abrir consulta com banco de dados'+E.message),'ERRO',mb_OK+MB_ICONERROR);
  end;
end;

procedure TfrmArarasAgenda.qryPainelBeforeOpen(DataSet: TDataSet);
begin
  qryPainel.Params[0].AsInteger := vCodigo;
end;

end.
