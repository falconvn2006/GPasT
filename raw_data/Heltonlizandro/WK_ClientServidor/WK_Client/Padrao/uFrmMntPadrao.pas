unit uFrmMntPadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uFrmPadrao, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, F_Funcao, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Menus;

type
  TFrmMntPadrao = class(TFrmPadrao)
    PanelBotoes: TPanel;
    PanelSave: TPanel;
    ImgAdd: TImage;
    PanelSair: TPanel;
    ImgSair: TImage;
    dsDados: TDataSource;
    procedure ImgSairClick(Sender: TObject);
    procedure ImgAddClick(Sender: TObject);
    procedure ImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgMouseLeave(Sender: TObject);
    procedure ImgMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CriarAtalhoClick(Sender: TObject);
    procedure ExcluirAtalho1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    sRetorno : TStrings;
    function  ValidaCadastro: Boolean; Virtual; Abstract;
    procedure SalvaCadastro; Virtual; Abstract;
  public
    { Public declarations }
//    procedure ChamaManutencao(sDataSet: TDataSet; sBotao : TBotao); Virtual;
    procedure PreencheDados; Virtual;
  end;

var
  FrmMntPadrao: TFrmMntPadrao;

implementation

{$R *.dfm}

procedure TFrmMntPadrao.CriarAtalhoClick(Sender: TObject);
begin
{ Comentado para não efetuar o evento referente ao Padrao
  inherited;}
end;

procedure TFrmMntPadrao.ExcluirAtalho1Click(Sender: TObject);
begin
{ Comentado para não efetuar o evento referente ao Padrao
  inherited;}
end;

procedure TFrmMntPadrao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
{ Comentado para não efetuar o evento referente ao Padrao
  inherited;}
end;

procedure TFrmMntPadrao.FormCreate(Sender: TObject);
begin
  inherited;
  sRetorno := TStringList.Create;
end;

procedure TFrmMntPadrao.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(sRetorno);
end;

procedure TFrmMntPadrao.ImgAddClick(Sender: TObject);
begin
  inherited;
  if ValidaCadastro then
  begin
    SalvaCadastro;
    inherited;
    case Botao of
      btInserir, btAlterar: Close;
    end;
  end;
end;

procedure TFrmMntPadrao.ImgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if TPanel(TImage(Sender).Parent).Enabled then
    TPanel(TImage(Sender).Parent).Color := $009F9F9F; //clAqua;
end;

procedure TFrmMntPadrao.ImgMouseLeave(Sender: TObject);
begin
  if TPanel(TImage(Sender).Parent).Enabled then
    TPanel(TImage(Sender).Parent).Color := clBtnFace    //clLime;
  else
    TPanel(TImage(Sender).Parent).Color := clBtnShadow;
end;

procedure TFrmMntPadrao.ImgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if TPanel(TImage(Sender).Parent).Enabled then
    TPanel(TImage(Sender).Parent).Color := $00CDCDCD; //clGreen;
end;

procedure TFrmMntPadrao.ImgSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmMntPadrao.PreencheDados;
begin

end;

end.
