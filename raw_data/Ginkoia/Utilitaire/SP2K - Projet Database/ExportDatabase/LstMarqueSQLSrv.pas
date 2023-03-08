unit LstMarqueSQLSrv;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, ExtCtrls, RzPanel, StdCtrls, AdvGroupBox, Grids,
  AdvObj, BaseGrid, AdvGrid, DBAdvGrid, ExtractDatabase_Dm, AlgolDialogForms, DB,
  DBGrids;

type
  Tfrm_LstMarque = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    AdvGlowButton1: TAdvGlowButton;
    AdvGlowButton2: TAdvGlowButton;
    AdvGroupBox1: TAdvGroupBox;
    Lab_Marque: TLabel;
    edtMarque: TEdit;
    Ds_LstMarque: TDataSource;
    DBGrid1: TDBGrid;
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure AdvGlowButton2Click(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure edtMarqueChange(Sender: TObject);
    procedure AlgolDialogFormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMRKNOM : string;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property MRK_NOM : STRING read FMRKNOM;

  end;

var
  frm_LstMarque: Tfrm_LstMarque;

implementation

{$R *.dfm}

procedure Tfrm_LstMarque.AdvGlowButton1Click(Sender: TObject);
begin
  FMRKNOM := Dm_ExtractDatabase.AdQue_GetLstMarque.FieldByName('MRK_NOM').AsString;
  Dm_ExtractDatabase.AdQue_GetLstMarque.close;
  ModalResult := mrOk;
end;

procedure Tfrm_LstMarque.AdvGlowButton2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_LstMarque.AlgolDialogFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Dm_ExtractDatabase.AdQue_GetLstMarque.Filtered := False;
end;

procedure Tfrm_LstMarque.AlgolDialogFormCreate(Sender: TObject);
begin
  Dm_ExtractDatabase.AdQue_GetLstMarque.close;
  Dm_ExtractDatabase.AdQue_GetLstMarque.Open;
end;

procedure Tfrm_LstMarque.edtMarqueChange(Sender: TObject);
begin
  Dm_ExtractDatabase.AdQue_GetLstMarque.Filtered := False;
  if Trim(edtMarque.Text) <> '' then
  begin
    Dm_ExtractDatabase.AdQue_GetLstMarque.Filter := 'MRK_NOM LIKE ' + QuotedStr(edtMarque.Text + '*');
    Dm_ExtractDatabase.AdQue_GetLstMarque.Filtered := True;
  end;
end;

end.
