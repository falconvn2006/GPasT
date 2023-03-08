unit fFaktury;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FModalBase, Data.DB, Data.Win.ADODB,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.Buttons;

type
  TfFakturyForm = class(TModalBase)
    q_pozycje: TADOQuery;
    ds_pozycje: TDataSource;
    pgc_DaneFaktury: TPageControl;
    ts_podstawowe_dane: TTabSheet;
    gb_daneFaktury: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dbe_NumerFaktury: TDBEdit;
    dt_data_wystawienia: TDateTimePicker;
    dt_data_dostawy: TDateTimePicker;
    Label4: TLabel;
    dt_termin_platnosci: TDateTimePicker;
    pl_left: TPanel;
    lbl_sprzedawca: TLabel;
    m_sprzedawca: TMemo;
    lbl_nabywca: TLabel;
    m_nabywca: TMemo;
    lbMiejsceWystawienia: TLabel;
    edtMiejsceWystawienia: TEdit;
    lblWystawilFakture: TLabel;
    edtWystawilFakture: TEdit;
    lblOdebralFakture: TLabel;
    edtOdebralFakture: TEdit;
    spDodajSprzedawca: TSpeedButton;
    spWybierzSprzedawca: TSpeedButton;
    spDodajNabywca: TSpeedButton;
    spWybierzNabywca: TSpeedButton;
    TabSheet1: TTabSheet;
    qtmp: TADOQuery;
    procedure spDodajSprzedawcaClick(Sender: TObject);
    procedure spWybierzSprzedawcaClick(Sender: TObject);
    procedure spWybierzNabywcaClick(Sender: TObject);
  private
    function UstawDaneKontrahenta(Aid:integer):string;
  public


  end;

var
  fFakturyForm: TfFakturyForm;

implementation
uses fkontrahent,fKontrahenciLista;
{$R *.dfm}


procedure TfFakturyForm.spDodajSprzedawcaClick(Sender: TObject);
begin
  inherited;
  m_sprzedawca.tag:= TKontrahentForm.show(-1);
end;

procedure TfFakturyForm.spWybierzNabywcaClick(Sender: TObject);
begin
  inherited;
  spWybierzNabywca.Tag:= TKontrahenciListaForm.Wybierz;
end;

procedure TfFakturyForm.spWybierzSprzedawcaClick(Sender: TObject);
begin
  inherited;
  spWybierzSprzedawca.Tag:= TKontrahenciListaForm.Wybierz;
end;

function TfFakturyForm.UstawDaneKontrahenta(Aid: integer): string;
begin

end;

end.
