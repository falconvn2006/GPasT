unit fKontrahent;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FModalBase, Vcl.StdCtrls, Vcl.Mask,
  Vcl.DBCtrls, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls;

type
  TKontrahentForm = class(TModalBase)
    lblNazwa: TLabel;
    Label1: TLabel;
    edtNazwa: TDBEdit;
    edtNip: TDBEdit;
    Label2: TLabel;
    edtRegon: TDBEdit;
    gbAdres: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblGmina: TLabel;
    lblPowiat: TLabel;
    lblMiejscowosc: TLabel;
    lblUlica: TLabel;
    Label3: TLabel;
    edtKodPocztowy: TDBEdit;
    edtNrDomu: TDBEdit;
    edtnrLokalu: TDBEdit;
    edtGmina: TDBEdit;
    edtPowiat: TDBEdit;
    edtMiejscowosc: TDBEdit;
    edtUlica: TDBEdit;
    edtWojewodztwo: TDBEdit;
    qAdres: TADOQuery;
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
    dsAdres: TDataSource;
    BaseQueryNazwa: TStringField;
    BaseQueryNIP: TStringField;
    BaseQueryRegon: TStringField;
    BaseQueryId: TIntegerField;
    BaseQueryAdresID: TIntegerField;
    procedure btn_zapiszClick(Sender: TObject);
    procedure bt_anulujClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fid:integer;
  public
    class function Show(Aid:Integer):Integer;
  published
    property id:integer write fid;
  end;

var
  KontrahentForm: TKontrahentForm;

implementation
 uses uDb;
{$R *.dfm}

procedure TKontrahentForm.btn_zapiszClick(Sender: TObject);
begin
    try
     if qAdres.State in [dsInsert] then begin
       qAdres.Post;
       fid:= GetLastID(BaseQuery.Connection);
       BaseQuery.FieldByName('AdresId').Value := fid;
     end else if qAdres.State in [dsEdit] then
       qAdres.Post;
     if BaseQuery.state in [dsInsert, dsEdit] then begin
        BaseQuery.Post;
     end;
     ModalResult:=mrOk;
  finally

  end;
end;

procedure TKontrahentForm.bt_anulujClick(Sender: TObject);
begin
  inherited;
  if qAdres.State in [dsInsert,dsEdit] then
  qAdres.Cancel;
  fid:= high(integer);
end;

procedure TKontrahentForm.FormShow(Sender: TObject);
begin
  inherited;
  BaseQuery.Parameters.ParamByName('cid').Value := fid;
  BaseQuery.Open;
  qAdres.Parameters.ParamByName('cid').Value := BaseQuery.FieldByName('AdresId').AsInteger;
  qAdres.Open;
  if fid=-1 then begin
    BaseQuery.Insert;
    qAdres.Insert;
  end
end;

class function TKontrahentForm.Show(Aid: Integer): Integer;
var
  f:TKontrahentForm;
begin
  Application.CreateForm(TKontrahentForm, f);
  with f do begin
    id:= Aid;
    ShowModal;
    result:= fid;
    free;
  end;
end;

end.
