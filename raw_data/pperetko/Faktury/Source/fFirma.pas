unit fFirma;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FModalBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TFirmaForm = class(TModalBase)
    lblNazwa: TLabel;
    edtNazwa: TDBEdit;
    Label1: TLabel;
    edtNip: TDBEdit;
    Label2: TLabel;
    edtRegon: TDBEdit;
    gbAdres: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblGmina: TLabel;
    lblPowiat: TLabel;
    edtKodPocztowy: TDBEdit;
    edtNrDomu: TDBEdit;
    edtnrLokalu: TDBEdit;
    edtGmina: TDBEdit;
    edtPowiat: TDBEdit;
    lblMiejscowosc: TLabel;
    edtMiejscowosc: TDBEdit;
    lblUlica: TLabel;
    edtUlica: TDBEdit;
    Label3: TLabel;
    edtWojewodztwo: TDBEdit;
    BaseQueryID: TIntegerField;
    BaseQueryNIP: TStringField;
    BaseQueryREGON: TStringField;
    BaseQueryAdresId: TIntegerField;
    BaseQueryNazwa: TStringField;
    qAdres: TADOQuery;
    dsAdres: TDataSource;
    qAdresID: TIntegerField;
    qAdresKOD: TStringField;
    qAdresMiejscowosc: TStringField;
    qAdresUlica: TStringField;
    qAdresNrBudynku: TStringField;
    qAdresNrLokalu: TStringField;
    qAdresPoczta: TStringField;
    qAdresGmina: TStringField;
    qAdresPowiat: TStringField;
    qAdresWojewodztwo: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure btn_zapiszClick(Sender: TObject);
  private
    { Private declarations }
  public
    class procedure Show;
  end;



implementation
uses uDB;
{$R *.dfm}

{ TFirmaForm }

procedure TFirmaForm.btn_zapiszClick(Sender: TObject);
begin
  try
     if qAdres.State in [dsInsert] then begin
       qAdres.Post;
       BaseQuery.FieldByName('AdresId').Value := GetLastID(BaseQuery.Connection);
     end else if qAdres.State in [dsEdit] then
       qAdres.Post;
     if BaseQuery.state in [dsInsert, dsEdit] then begin
        BaseQuery.Post;
     end;
  finally

  end;
end;

procedure TFirmaForm.FormCreate(Sender: TObject);
begin
  inherited;
  BaseQuery.Open;
  qAdres.Parameters.ParamByName('cid').Value := BaseQuery.FieldByName('AdresId').AsInteger;
  qAdres.Open;
  if BaseQuery.IsEmpty then begin
    BaseQuery.Insert;
    qAdres.Insert;
  end
end;

class procedure TFirmaForm.Show;
var
  FirmaForm: TFirmaForm;
begin
  Application.CreateForm(TFirmaForm, FirmaForm);
  With FirmaForm do begin
    ShowModal;
    free;
  end;
end;

end.
