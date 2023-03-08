unit BAR62;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Grids, DBGrids, ExtCtrls, Buttons;

type
  TfrmBuscarProveedor = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    QProveedores: TADOQuery;
    dsProveedores: TDataSource;
    Memo1: TMemo;
    QProveedoresProveedorID: TAutoIncField;
    QProveedoresNombre: TWideStringField;
    QProveedoresrnc: TWideStringField;
    QProveedorestelefono: TWideStringField;
    QProveedoresdireccion: TWideStringField;
    QProveedorescontacto: TWideStringField;
    QProveedoresemail: TWideStringField;
    Panel2: TPanel;
    edbusca: TEdit;
    lbtipo: TStaticText;
    btcodigo: TSpeedButton;
    btnombre: TSpeedButton;
    btrnc: TSpeedButton;
    btclose: TSpeedButton;
    btaceptar: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    btteclado: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    btcontacto: TSpeedButton;
    bttelefono: TSpeedButton;
    procedure btcloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bttelefonoClick(Sender: TObject);
    procedure btcontactoClick(Sender: TObject);
    procedure bttecladoClick(Sender: TObject);
    procedure btcodigoClick(Sender: TObject);
    procedure btnombreClick(Sender: TObject);
    procedure btrncClick(Sender: TObject);
    procedure btaceptarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure edbuscaChange(Sender: TObject);
  private
    procedure Buscar(vBusqueda,vConsulta:string);
  public
    Acepto : integer;
    Busqueda : string;
  end;

var
  frmBuscarProveedor: TfrmBuscarProveedor;

implementation
uses BAR04, BAR33;

{$R *.dfm}

procedure TfrmBuscarProveedor.btcloseClick(Sender: TObject);
begin
  Acepto := 0;
  Close;
end;

procedure TfrmBuscarProveedor.FormActivate(Sender: TObject);
begin
  if not QProveedores.Active then QProveedores.Open;
end;

procedure TfrmBuscarProveedor.FormCreate(Sender: TObject);
begin
  Busqueda := 'NOMBRE';
  btclose.Caption := 'F1'+#13+'SALIR';
  btaceptar.Caption := 'F10'+#13+'ACEPTAR';
  btteclado.Caption := 'F4'+#13+'TECLADO';

  btcodigo.Caption    := 'F4'+#13+'CODIGO';
  btnombre.Caption    := 'F5'+#13+'NOMBRE';
  btrnc.Caption       := 'F6'+#13+'RNC';
  bttelefono.Caption  := 'F7'+#13+'TELEFONO';
  btcontacto.Caption  := 'F8'+#13+'CONTACTO';


  Memo1.Lines := QProveedores.SQL;
  QProveedores.SQL.Add('order by nombre');

end;

procedure TfrmBuscarProveedor.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1  then btcloseClick(Self);
  if key = vk_f4  then bttecladoClick(Self);

  if key = vk_f4  then btcodigoClick(Self);
  if key = vk_f5  then btnombreClick(Self);
  if key = vk_f6  then btrncClick(Self);
  if key = vk_f7  then bttelefonoClick(Self);
  if key = vk_f8  then btcontactoClick(Self);

  if key = vk_f10 then btaceptarClick(Self);
end;

procedure TfrmBuscarProveedor.bttelefonoClick(Sender: TObject);
begin
  Busqueda := 'TELEFONO';
  lbtipo.Caption := 'Buscar por: '+Busqueda;
  Buscar(Busqueda,edbusca.Text);
  edbusca.SetFocus;
end;

procedure TfrmBuscarProveedor.btcontactoClick(Sender: TObject);
begin
  Busqueda := 'CONTACTO';
  lbtipo.Caption := 'Buscar por: '+Busqueda;
  Buscar(Busqueda,edbusca.Text);
  edbusca.SetFocus;
end;

procedure TfrmBuscarProveedor.bttecladoClick(Sender: TObject);
begin
  Application.CreateForm(tfrmTeclado, frmTeclado);
  frmTeclado.ShowModal;
  if frmTeclado.Acepto = 1 then
    edbusca.Text := frmTeclado.edteclado.Text;
  frmTeclado.Release;
end;

procedure TfrmBuscarProveedor.btcodigoClick(Sender: TObject);
begin
  Busqueda := 'CODIGO';
  lbtipo.Caption := 'Buscar por: '+Busqueda;
  Buscar(Busqueda,edbusca.Text);
  edbusca.SetFocus;
end;

procedure TfrmBuscarProveedor.btnombreClick(Sender: TObject);
begin
  Busqueda := 'NOMBRE';
  lbtipo.Caption := 'Buscar por: '+Busqueda;
  Buscar(Busqueda,edbusca.Text);
  edbusca.SetFocus;
end;

procedure TfrmBuscarProveedor.btrncClick(Sender: TObject);
begin
  Busqueda := 'RNC';
  lbtipo.Caption := 'Buscar por: '+Busqueda;
  Buscar(Busqueda,edbusca.Text);
  edbusca.SetFocus;
end;

procedure TfrmBuscarProveedor.btaceptarClick(Sender: TObject);
begin
  Acepto := 1;
  Close;
end;

procedure TfrmBuscarProveedor.SpeedButton1Click(Sender: TObject);
begin
  if not QProveedores.Bof then QProveedores.Prior;
end;

procedure TfrmBuscarProveedor.SpeedButton2Click(Sender: TObject);
begin
  if not QProveedores.Eof then QProveedores.Next;
end;


procedure TfrmBuscarProveedor.Buscar(vBusqueda,vConsulta: string);
begin
  QProveedores.DisableControls;
  QProveedores.Close;
  QProveedores.SQL.Clear;
  QProveedores.SQL := Memo1.Lines;
  QProveedores.SQL.Add('where '+vBusqueda+' like '+QuotedStr(vConsulta+'%'));
  QProveedores.SQL.Add('order by '+vBusqueda);
  QProveedores.Open;
  QProveedores.EnableControls;
end;

procedure TfrmBuscarProveedor.edbuscaChange(Sender: TObject);
begin
  Buscar(Busqueda,edbusca.Text);
end;

end.
