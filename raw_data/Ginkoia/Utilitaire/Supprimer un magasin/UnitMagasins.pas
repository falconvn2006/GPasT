unit UnitMagasins;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.StdCtrls, Vcl.Buttons;

type
  TFormMagasins = class(TForm)
    Panel: TPanel;
    DBGrid: TDBGrid;
    FDQuery: TFDQuery;
    DataSource: TDataSource;
    BtnOk: TBitBtn;
    BtnAnnuler: TBitBtn;
    FDQueryMAG_ID: TIntegerField;
    FDQueryMAG_NOM: TStringField;
    FDQueryMAG_ENSEIGNE: TStringField;
    FDQueryVIL_NOM: TStringField;
    FDQueryMAG_CODEADH: TStringField;

    procedure FormShow(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);

  private

  public

  end;

var
  FormMagasins: TFormMagasins;

implementation

{$R *.dfm}

uses Unit1;

procedure TFormMagasins.FormShow(Sender: TObject);
begin
   // Recherche des magasins.
   FDQuery.Close;
   FDQuery.SQL.Clear;
   FDQuery.SQL.Add('select MAG_ID, MAG_NOM, MAG_CODEADH, MAG_ENSEIGNE, VIL_NOM');
   FDQuery.SQL.Add('from GENMAGASIN  join K on (K_ID = MAG_ID and K_ENABLED = 1)');
   FDQuery.SQL.Add('join GENADRESSE on (MAG_ADRID = ADR_ID)  join K on (K_ID = ADR_ID and K_ENABLED = 1)');
   FDQuery.SQL.Add('join GENVILLE on (ADR_VILID = VIL_ID)  join K on (K_ID = VIL_ID and K_ENABLED = 1)');
   FDQuery.SQL.Add('where MAG_ID <> 0');
   FDQuery.SQL.Add('order by MAG_ID');
   try
      FDQuery.Open;
   except
      on E: Exception do
      begin
         Application.MessageBox(PChar('Erreur :  la recherche des magasins a échoué !' + #13#10 + E.Message), PChar(Caption + ' - erreur'), MB_ICONERROR + MB_OK);
         Exit;
      end;
   end;

   BtnOk.Enabled := ((FDQuery.Active) and (not FDQuery.IsEmpty));
   DBGrid.SetFocus;
end;

procedure TFormMagasins.DBGridDblClick(Sender: TObject);
begin
   BtnOkClick(Sender);
end;

procedure TFormMagasins.BtnOkClick(Sender: TObject);
begin
   if(FDQuery.Active) and (not FDQuery.IsEmpty) then
      ModalResult := mrOk;
end;

end.
