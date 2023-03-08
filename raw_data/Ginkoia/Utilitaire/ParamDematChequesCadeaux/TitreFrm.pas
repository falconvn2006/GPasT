unit TitreFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, ExtCtrls, uDemat, cxCheckBox, StdCtrls, Menus, cxButtons, dxmdaset;

type
  Tfrm_Titres = class(TForm)
    dsTITRE: TDataSource;
    Panel1: TPanel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    MemTitres: TdxMemData;
    MemTitresCKECODE: TStringField;
    MemTitresTYPECODE: TStringField;
    MemTitresLIBELLE: TStringField;
    MemTitresUTILISABLE: TIntegerField;
    cxGrid1DBTableView1TYPECODE: TcxGridDBColumn;
    cxGrid1DBTableView1LIBELLE: TcxGridDBColumn;
    cxGrid1DBTableView1UTILISABLE: TcxGridDBColumn;
    BVALIDER: TcxButton;
    BFermer: TcxButton;
  private
    FArray : TTitres;
    procedure ParseMemTitres();
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function ExecuteTitres(aArray:TTitres;Const isReadOnly:Boolean=true):TTitres;

implementation

Uses MainFrm;

{$R *.dfm}

function ExecuteTitres(aArray:TTitres;Const isReadOnly:Boolean=true):TTitres;
var frm_Titres: Tfrm_Titres;
    i:Integer;
begin
  Application.CreateForm(Tfrm_Titres,frm_Titres);
  With frm_Titres do
    begin
       SetLength(FArray,Length(aArray));
       FArray := aArray;
       MemTitres.Open;
       for I := Low(FArray) to High(FArray) do
        begin
          MemTitres.Append;
          MemTitres.FieldByName('CKECODE').AsString      := FArray[i].CKI_CKECODE;
          MemTitres.FieldByName('TYPECODE').AsString     := FArray[i].CKI_TYPECODE;
          MemTitres.FieldByName('LIBELLE').AsString      := FArray[i].CKI_LIBELLE;
          MemTitres.FieldByName('UTILISABLE').Asinteger  := FArray[i].UTILISABLE;
          MemTitres.Post();
        end;
      if MemTitres.RecordCount>0 then
        MemTitres.First;
      if isReadOnly then
        begin
          BVALIDER.Enabled := false;
          BVALIDER.Visible := false;

          BFERMER.Enabled  := true;
          BVALIDER.Visible := true;

          dsTITRE.AutoEdit   := false;
          cxGrid1DBTableView1UTILISABLE.Options.Focusing := false;
          cxGrid1DBTableView1UTILISABLE.Options.Editing  := false;
        end
      else
        begin
          BVALIDER.Enabled := true;
          BVALIDER.Visible := true;

          BFERMER.Enabled  := false;
          BFERMER.Visible  := false;
        end;
      if ShowModal = mrOk then
        begin
          ParseMemTitres();
          result := FArray;
        end;
    end;

end;

procedure Tfrm_Titres.ParseMemTitres();
var i:integer;
begin
    MemTitres.DisableControls;
    MemTitres.First;
    i:=0;
    While not(MemTitres.eof) do
      begin
         FArray[i].Utilisable := MemTitres.FieldByName('UTILISABLE').asinteger;
         inc(i);
         MemTitres.Next;
      end;
    MemTitres.EnableControls;
end;





end.
