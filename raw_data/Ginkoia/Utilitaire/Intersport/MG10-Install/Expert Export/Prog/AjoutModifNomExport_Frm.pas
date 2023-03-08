unit AjoutModifNomExport_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, GinkoiaStyle_Dm, AdvGlowButton, RzLabel,
  ExtCtrls, RzPanel;

type
  TFrm_AjoutModifNomExport = class(TAlgolDialogForm)
    Label1: TLabel;
    ENom: TEdit;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
  private
    { Déclarations privées }
    sNomModif: string;
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Déclarations publiques }
    sReponseNom: string;
    procedure SetModif(ANomExport: string);
  end;

var
  Frm_AjoutModifNomExport: TFrm_AjoutModifNomExport;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_AjoutModifNomExport.CMDialogKey(var M: TCMDialogKey);
begin
  if (m.CharCode=VK_RETURN) and ENom.Focused then
  begin
    m.Result := 1;
    Nbt_PostClick(Nbt_Post);
    exit;
  end;
  inherited;
end;

procedure TFrm_AjoutModifNomExport.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_AjoutModifNomExport.Nbt_PostClick(Sender: TObject);
var
  i: integer;
  iPosition: integer;
  iRech: integer;
begin
  sReponseNom := Trim(ENom.Text);
  if (sReponseNom='') then
  begin
    MessageDlg('Nom obligatoire !',mterror,[mbok],0 );
    ENom.SetFocus;
    ENom.SelectAll;
    ModalResult := mrnone;
    exit;
  end;

  iPosition := -1;
  if (sNomModif<>'') then
  begin
    i := 1;
    while (iPosition<0) and (i<=Dm_Main.ListeNomExport.Count) do
    begin
      if UpperCase(sNomModif)=UpperCase(Dm_Main.ListeNomExport[i-1]) then
        iPosition := i-1;
      inc(i);
    end;
  end;

  iRech := -1;
  i := 1;
  while (iRech<0) and (i<=Dm_Main.ListeNomExport.Count) do
  begin
    if (UpperCase(sReponseNom)=UpperCase(Dm_Main.ListeNomExport[i-1]))
         and (iPosition<>i-1) then
      iRech := i-1;
    inc(i);
  end;

  if iRech<>-1 then
  begin
    MessageDlg('Nom déjà existant !', mterror, [mbok], 0);
    ENom.SetFocus;
    ENom.SelectAll;
    ModalResult := mrnone;
    exit;
  end;

  if iPosition=-1 then
    Dm_Main.ListeNomExport.Add(sReponseNom)
  else
  begin
    Dm_Main.ListeNomExport.Insert(iPosition, sReponseNom);
    Dm_Main.ListeNomExport.Delete(iPosition+1);
  end;
  Dm_Main.ListeNomExport.Sort;
  ModalResult := mrOk;
end;

procedure TFrm_AjoutModifNomExport.SetModif(ANomExport: string);
begin
  sNomModif := ANomExport;
  ENom.Text := ANomExport;
  Caption := 'Modifier le nom d''export';
end;

procedure TFrm_AjoutModifNomExport.AlgolDialogFormCreate(Sender: TObject);
begin
  sNomModif := '';
  ENom.Text := '';
end;

end.
