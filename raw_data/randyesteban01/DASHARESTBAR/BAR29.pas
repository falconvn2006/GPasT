unit BAR29;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, DB, ADODB, Grids, DBGrids, StdCtrls, ExtCtrls;

type
  TfrmBuscaRNC = class(TForm)
    QRNC: TADOQuery;
    QRNCrnc_cedula: TWideStringField;
    QRNCrazon_social: TWideStringField;
    QRNCnombre_comercial: TWideStringField;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    edbusca: TEdit;
    lbtipo: TStaticText;
    btclose: TSpeedButton;
    btrnc: TSpeedButton;
    btrazon: TSpeedButton;
    btnombre: TSpeedButton;
    Memo1: TMemo;
    dsRNC: TDataSource;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btteclado: TSpeedButton;
    btaceptar: TSpeedButton;
    btbuscar: TSpeedButton;
    btadd: TSpeedButton;
    btedit: TSpeedButton;
    procedure btcloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btrncClick(Sender: TObject);
    procedure btrazonClick(Sender: TObject);
    procedure btnombreClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure btbuscarClick(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
    procedure btaddClick(Sender: TObject);
    procedure bteditClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Acepto : integer;
    Busqueda : string;
  end;

var
  frmBuscaRNC: TfrmBuscaRNC;

implementation

uses BAR04, BAR33, BAR44;

{$R *.dfm}

procedure TfrmBuscaRNC.btcloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBuscaRNC.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btrnc.Caption := 'F2'+#13+'RNC';
  btrazon.Caption := 'F3'+#13+'RAZON';
  btnombre.Caption := 'F4'+#13+'NOMBRE';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
  btteclado.Caption := 'F6'+#13+'TECLADO';
  Busqueda := 'rnc_cedula';
end;

procedure TfrmBuscaRNC.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f2  then btrncClick(Self);
  if key = vk_f3  then btrazonClick(Self);
  if key = vk_f4  then btnombreClick(Self);
  if key = vk_f8  then btbuscarClick(Self);
  if key = vk_f10 then btaceptarClick(Self);
end;

procedure TfrmBuscaRNC.btrncClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Busqueda := 'rnc_cedula';
  lbtipo.Caption := 'Buscar por: RNC';
  Application.ProcessMessages;
  QRNC.Close;
  QRNC.SQL.Clear;
  QRNC.SQL := Memo1.Lines;
  QRNC.SQL.Add('where '+Busqueda+' like '+QuotedStr(edbusca.Text+'%'));
  //QRNC.SQL.Add('order by '+Busqueda);
  QRNC.Open;
  Screen.Cursor := crDefault;
  edbusca.SetFocus;
end;

procedure TfrmBuscaRNC.btrazonClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Busqueda := 'razon_social';
  lbtipo.Caption := 'Buscar por: RAZON SOCIAL';
  Application.ProcessMessages;
  QRNC.Close;
  QRNC.SQL.Clear;
  QRNC.SQL := Memo1.Lines;
  QRNC.SQL.Add('where '+Busqueda+' like '+QuotedStr(edbusca.Text+'%'));
  //QRNC.SQL.Add('order by '+Busqueda);
  QRNC.Open;
  Screen.Cursor := crDefault;
  edbusca.SetFocus;
end;

procedure TfrmBuscaRNC.btnombreClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  Busqueda := 'nombre_comercial';
  lbtipo.Caption := 'Buscar por: NOMBRE COMERCIAL';
  Application.ProcessMessages;
  QRNC.Close;
  QRNC.SQL.Clear;
  QRNC.SQL := Memo1.Lines;
  QRNC.SQL.Add('where '+Busqueda+' like '+QuotedStr(edbusca.Text+'%'));
  //QRNC.SQL.Add('order by '+Busqueda);
  QRNC.Open;
  Screen.Cursor := crDefault;
  edbusca.SetFocus;
end;

procedure TfrmBuscaRNC.btaceptarClick(Sender: TObject);
begin
  if QRNC.Active then
  begin
    if QRNC.RecordCount > 0 then
    begin
      Acepto := 1;
      Close;
    end;
  end;
end;

procedure TfrmBuscaRNC.SpeedButton1Click(Sender: TObject);
begin
  if not QRNC.Bof then QRNC.Prior;
end;

procedure TfrmBuscaRNC.SpeedButton2Click(Sender: TObject);
begin
  if not QRNC.Eof then QRNC.Next;
end;

procedure TfrmBuscaRNC.btbuscarClick(Sender: TObject);
begin
  if Busqueda = 'rnc_cedula' then
    btrncClick(Self)
  else if Busqueda = 'razon_social' then
    btrazonClick(Self)
  else if Busqueda = 'nombre_comercial' then
    btnombreClick(Self);

  edbusca.Text := '';
end;

procedure TfrmBuscaRNC.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    edbusca.Text := frmTeclado.edteclado.Text;
  frmTeclado.Release;
end;

procedure TfrmBuscaRNC.btaddClick(Sender: TObject);
begin
  Application.CreateForm(tfrmActRNC, frmActRNC);
  frmActRNC.QRNC.Open;
  frmActRNC.QRNC.Insert;
  frmActRNC.ShowModal;
  frmActRNC.Release;
end;

procedure TfrmBuscaRNC.bteditClick(Sender: TObject);
begin
  Application.CreateForm(tfrmActRNC, frmActRNC);
  frmActRNC.DBEdit1.Enabled := false;
  frmActRNC.QRNC.Parameters.ParamByName('rnc').Value := QRNCrnc_cedula.AsString;
  frmActRNC.QRNC.Open;
  frmActRNC.QRNC.Edit;
  frmActRNC.ShowModal;
  frmActRNC.Release;
end;

end.
