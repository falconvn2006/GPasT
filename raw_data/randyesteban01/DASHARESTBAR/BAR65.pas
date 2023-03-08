unit BAR65;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, DB, ADODB, DBCtrls, ComCtrls,
  Grids, DBGrids;

type
  TfrmConsultaEnttrada = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    btclose: TSpeedButton;
    btrefresh: TSpeedButton;
    btimprimir: TSpeedButton;
    GroupBox1: TGroupBox;
    QEntradas: TADOQuery;
    dsEntradas: TDataSource;
    DBGrid1: TDBGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    fecha1: TDateTimePicker;
    fecha2: TDateTimePicker;
    rgFiltro: TRadioGroup;
    QProveedores: TADOQuery;
    dsProveedores: TDataSource;
    QUsuarios: TADOQuery;
    dsUsuarios: TDataSource;
    cbFiltro: TDBLookupComboBox;
    procedure FormCreate(Sender: TObject);
    procedure btcloseClick(Sender: TObject);
    procedure btrefreshClick(Sender: TObject);
    procedure rgFiltroClick(Sender: TObject);
    procedure btimprimirClick(Sender: TObject);
    procedure dsEntradasDataChange(Sender: TObject; Field: TField);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConsultaEnttrada: TfrmConsultaEnttrada;

implementation
  uses BAR04, BAR66, BAR01;
{$R *.dfm}

procedure TfrmConsultaEnttrada.FormCreate(Sender: TObject);
begin
  Memo1.Lines := QEntradas.SQL;

  btclose.Caption    := 'F1'+#13+'SALIR';
  btrefresh.Caption  := 'F2'+#13+'CONSULTAR';
  btimprimir.Caption := 'F4'+#13+'IMPRIMIR';
  fecha1.Date := date;
  fecha2.Date := date;
end;

procedure TfrmConsultaEnttrada.btcloseClick(Sender: TObject);
begin
close;
end;

procedure TfrmConsultaEnttrada.btrefreshClick(Sender: TObject);
begin
  QEntradas.Close;
  QEntradas.SQL := Memo1.Lines;
  QEntradas.SQL.Add('and Entradas.fecha between '+QuotedStr(FormatDateTime('yyyy/mm/dd',fecha1.date))+' and '+QuotedStr(FormatDateTime('yyyy/mm/dd',fecha2.date)));

  case rgFiltro.ItemIndex of
    0 : begin
          QEntradas.SQL.Add('and Entradas.RealizadoID = '+QUsuarios.fieldbyname('UsuarioID').AsString);
          QEntradas.SQL.Add('');
    end;
    1 : begin
          QEntradas.SQL.Add('and Entradas.RevisadoID = '+QUsuarios.fieldbyname('UsuarioID').AsString);
          QEntradas.SQL.Add('');
    end;
    2 : begin
          QEntradas.SQL.Add('and Entradas.ProveedorID = '+QProveedores.fieldbyname('ProveedorID').AsString);
          QEntradas.SQL.Add('');
    end;
  end;
  QEntradas.Open;
end;

procedure TfrmConsultaEnttrada.rgFiltroClick(Sender: TObject);
begin
  QProveedores.Open;
  QUsuarios.Open;
  case rgFiltro.ItemIndex of
    0,1 : begin
            QProveedores.Close;
            cbFiltro.KeyField   := 'UsuarioID';
            cbFiltro.ListSource := dsUsuarios;
          end;
    2   : begin
            QUsuarios.Close;
            cbFiltro.KeyField   := 'ProveedorID';
            cbFiltro.ListSource := dsProveedores;
          end;
  end;
  cbFiltro.ListField  := 'Nombre';
end;

procedure TfrmConsultaEnttrada.btimprimirClick(Sender: TObject);
begin
  Application.CreateForm(TrEntradas, rEntradas);
  rEntradas.QrptEntradas.SQL[rEntradas.QrptEntradas.SQL.Count-2] :='and Entradas.fecha between '+QuotedStr(FormatDateTime('yyyy/mm/dd',fecha1.date))+' and '+QuotedStr(FormatDateTime('yyyy/mm/dd',fecha2.date));

  case rgFiltro.ItemIndex of
    0 : rEntradas.QrptEntradas.SQL[rEntradas.QrptEntradas.SQL.Count-1] :='and Entradas.RealizadoID = '+QUsuarios.fieldbyname('UsuarioID').AsString;
    1 : rEntradas.QrptEntradas.SQL[rEntradas.QrptEntradas.SQL.Count-1] :='and Entradas.RevisadoID = '+QUsuarios.fieldbyname('UsuarioID').AsString;
    2 : rEntradas.QrptEntradas.SQL[rEntradas.QrptEntradas.SQL.Count-1]:='and Entradas.ProveedorID = '+QProveedores.fieldbyname('ProveedorID').AsString;      
  end;

  rEntradas.lbfecha.Caption := 'De '+DateTimeToStr(fecha1.Date)+' A '+DateTimeToStr(fecha2.Date);
  rEntradas.QrptEntradas.Open;
//    rEntradas.PrinterSetup;
  rEntradas.Preview;
  rEntradas.Destroy;
end;

procedure TfrmConsultaEnttrada.dsEntradasDataChange(Sender: TObject;
  Field: TField);
begin
  btimprimir.Enabled := QEntradas.RecordCount > 0;
end;

procedure TfrmConsultaEnttrada.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  frmMain.Panel1.Enabled := true;
  Action:=  cafree;
end;

end.
