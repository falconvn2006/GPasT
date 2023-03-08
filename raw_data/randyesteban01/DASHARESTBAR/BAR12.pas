unit BAR12;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, DB, ADODB, StdCtrls, Mask, DBCtrls;

type
  TfrmActCategoria = class(TForm)
    Panel1: TPanel;
    btclose: TSpeedButton;
    btpost: TSpeedButton;
    Panel2: TPanel;
    Panel3: TPanel;
    QCategorias: TADOQuery;
    QCategoriasCategoriaID: TIntegerField;
    QCategoriasNombre: TWideStringField;
    QCategoriasLinea1: TWideStringField;
    QCategoriasLinea2: TWideStringField;
    QCategoriasLinea3: TWideStringField;
    QCategoriasBgColor: TWideStringField;
    QCategoriasFgColor: TWideStringField;
    dsCategorias: TDataSource;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBLookupComboBox3: TDBLookupComboBox;
    DBLookupComboBox4: TDBLookupComboBox;
    QColor: TADOQuery;
    QColorColor: TWideStringField;
    QColorNombre: TWideStringField;
    dsColores: TDataSource;
    pncat2: TPanel;
    lbcat1: TStaticText;
    procedure btcloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btpostClick(Sender: TObject);
    procedure QCategoriasNewRecord(DataSet: TDataSet);
    procedure dsCategoriasDataChange(Sender: TObject; Field: TField);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Grabo : Integer;
  end;

var
  frmActCategoria: TfrmActCategoria;

implementation

uses BAR04;

{$R *.dfm}

procedure TfrmActCategoria.btcloseClick(Sender: TObject);
begin
  QCategorias.Cancel;
  Grabo := 0;
  Close;
end;

procedure TfrmActCategoria.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = chr(vk_return) then
  begin
    perform(wm_nextdlgctl, 0, 0);
    key := #0;
  end;
end;

procedure TfrmActCategoria.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_f1 then btcloseClick(Self);
  if key = vk_f2 then btpostClick(Self);
end;

procedure TfrmActCategoria.btpostClick(Sender: TObject);
begin
  QCategorias.Post;
  QCategorias.UpdateBatch;
  Grabo := 1;
  Close;
end;

procedure TfrmActCategoria.QCategoriasNewRecord(DataSet: TDataSet);
begin
  QCategoriasBgColor.Value := 'clBlue';
  QCategoriasFgColor.Value := 'clWhite';
end;

procedure TfrmActCategoria.dsCategoriasDataChange(Sender: TObject;
  Field: TField);
var
  BgColor, FgColor : Integer;
begin
  lbcat1.Caption := QCategoriasLinea1.AsString+#13+
                     QCategoriasLinea2.AsString+#13+
                     QCategoriasLinea3.AsString;
  
  lbcat1.Font.Color := clWhite;
  lbcat1.Color := clBlue;

  if not QCategoriasFgColor.IsNull then
  begin
    FgColor := StringToColor(QCategoriasFgColor.AsString);
    lbcat1.Font.Color := FgColor;
  end;
  if not QCategoriasBgColor.IsNull then
  begin
    BgColor := StringToColor(QCategoriasBgColor.AsString);
    lbcat1.Color := BgColor;
  end;
end;

procedure TfrmActCategoria.FormCreate(Sender: TObject);
begin
  btclose.Caption := 'F1'+#13+'SALIR';
  btpost.Caption  := 'F2'+#13+'GRABAR';

  QColor.Open;
end;

end.
