unit POS14;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, Buttons, ToolWin, ComCtrls, DB, ADODB, StdCtrls;

type
  TfrmClientes = class(TForm)
    ToolBar1: TToolBar;
    btsalir: TSpeedButton;
    DBGrid1: TDBGrid;
    QClientes: TADOQuery;
    QClientesemp_codigo: TIntegerField;
    QClientescli_codigo: TIntegerField;
    QClientescli_nombre: TStringField;
    dsClientes: TDataSource;
    Edit1: TEdit;
    QClientescli_rnc: TStringField;
    QClientescli_cedula: TStringField;
    QClientescli_limite: TBCDField;
    QClientescli_balance: TBCDField;
    QClientesemp_numero: TIntegerField;
    QClientescli_direccion: TStringField;
    QClientescli_localidad: TStringField;
    QClientestfa_codigo: TIntegerField;
    QClientescli_facturarbce: TStringField;
    QClientescli_facturarvencida: TStringField;
    QClientesAumento: TBCDField;
    procedure btsalirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    seleccion : integer;
    total : double;
  end;

var
  frmClientes: TfrmClientes;

implementation

uses POS01, POS03, POS00;

{$R *.dfm}

procedure TfrmClientes.btsalirClick(Sender: TObject);
begin
  seleccion := 0;
  Close;
end;

procedure TfrmClientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then btsalirClick(Self);
end;

procedure TfrmClientes.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    QClientes.Close;
    QClientes.SQL.Clear;
    QClientes.SQL.Add('select');
    QClientes.SQL.Add('distinct emp_codigo, cli_codigo, cli_nombre, cli_rnc, cli_cedula, cli_direccion,cli_localidad,');
    QClientes.SQL.Add('isnull(cli_limite,0) as cli_limite, cli_balance, emp_numero, cli_telefono, tfa_codigo,');
    QClientes.SQL.Add('cli_facturarbce, cli_facturarvencida, Aumento');
    QClientes.SQL.Add('from clientes');
    QClientes.SQL.Add('where cli_nombre+isnull(cli_referencia,'+QuotedStr('')+')+isnull(cli_telefono,'+QuotedStr('')+') like '+QuotedStr('%'+Edit1.Text+'%'));
    QClientes.SQL.Add('and cli_status = '+QuotedStr('ACT'));
    QClientes.SQL.Add('order by cli_nombre');
    QClientes.Open;
    DBGrid1.SetFocus;

    key := #0;
  end;
end;

procedure TfrmClientes.DBGrid1KeyPress(Sender: TObject; var Key: Char);
var
  autorizar : boolean;
begin
  if key = #13 then
  begin
    if QClientes.RecordCount > 0 then
    begin
      autorizar := false;
      if total > (QClientescli_limite.Value - QClientescli_balance.Value) then
        autorizar := true
      else if StrToFloat(format('%10.2F',[QClientescli_balance.Value])) > 0  then
      begin
        if QClientescli_facturarbce.AsString <> 'S' then
          autorizar := true
        else
        begin
          dm.Query1.Close;
          dm.Query1.SQL.Clear;
          dm.Query1.SQL.Add('select * from PR_BUSCA_VENCIDO (:emp, :cli, :fec)');
          dm.Query1.Parameters.ParamByName('emp').Value := QClientesemp_codigo.Value;
          dm.Query1.Parameters.ParamByName('cli').Value := QClientescli_codigo.Value;
          dm.Query1.Parameters.ParamByName('fec').Value := Date;
          dm.Query1.Open;

          if (QClientescli_facturarvencida.AsString <> 'S') and (dm.Query1.FieldByName('vencido').asstring = 'S') then
            autorizar := true
        end;
      end;

      if autorizar then
      begin
        MessageDlg('FAVOR COMUNICARSE CON EL DEPARTAMENTO DE CREDITO',mtError,[mbok],0);
        Application.CreateForm(tfrmAcceso, frmAcceso);
        frmAcceso.lbtitulo.Caption := 'Digite la clave del Supervisor';
        frmAcceso.ShowModal;

        dm.Query1.Close;
        dm.Query1.SQL.Clear;
        dm.Query1.SQL.Add('select c.clave, u.usu_autoriza_credito');
        dm.Query1.SQL.Add('from clave_supervisor_caja c, usuarios u');
        dm.Query1.SQL.Add('where c.clave = :cla');
        dm.Query1.SQL.Add('and c.usu_codigo = u.usu_codigo');
        dm.Query1.Parameters.ParamByName('cla').Value := frmAcceso.edclave.Text;
        dm.Query1.Open;
        if dm.Query1.RecordCount = 0 then
        begin
          MessageDlg('ESTA CLAVE NO ES VALIDA, PRESIONE [ENTER] PARA SALIR',mtError,[mbok],0);
          DBGrid1.SetFocus;
        end
        else if dm.Query1.FieldByName('usu_autoriza_credito').AsString <> 'True' then
        begin
          MessageDlg('ESTE SUPERVISOR NO TIENE ACCESO A AUTORIZAR CREDITO',mtError,[mbok],0);
          DBGrid1.SetFocus;
        end
        else
        begin
          seleccion := 1;
          close;
        end;
        frmAcceso.Release;
      end
      else
      begin
        seleccion := 1;
        close;
      end;
    end;
  end;
end;

procedure TfrmClientes.FormCreate(Sender: TObject);
begin
  seleccion := 0;
end;

procedure TfrmClientes.FormActivate(Sender: TObject);
begin
  Edit1.Enabled := frmMain.SeleccionCliente = 0;
end;

end.
