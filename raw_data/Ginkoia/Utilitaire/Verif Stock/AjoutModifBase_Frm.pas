unit AjoutModifBase_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, RzLabel, LMDControl, LMDBaseControl, LMDBaseGraphicButton,
  LMDCustomSpeedButton, LMDSpeedButton, DB;

type
  TFrm_AjoutModifBase = class(TForm)
    RzLabel1: TRzLabel;
    RzLabel2: TRzLabel;
    Bevel1: TBevel;
    Nbt_Ok: TLMDButton;
    Nbt_Cancel: TLMDButton;
    ENom: TEdit;
    EBase: TEdit;
    Lab_info: TRzLabel;
    Nbt_ChercheBase: TLMDSpeedButton;
    OD_Base: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure ENomKeyPress(Sender: TObject; var Key: Char);
    procedure Nbt_ChercheBaseClick(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
  private
    { Déclarations privées }
    OldInd:integer;
    OldBase: string;
    procedure OuvrirFichier;
    procedure CMDialogKey(var M: TCMDialogKey); message CM_DIALOGKEY;
  public
    { Déclarations publiques }
    procedure SetModif(AInd: integer;ANom, ABase: string);
  end;

var
  Frm_AjoutModifBase: TFrm_AjoutModifBase;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_AjoutModifBase.SetModif(AInd: integer;ANom, ABase: string);
begin
  OldInd := AInd;
  ENom.Text := ANom;
  EBase.Text := ABase;
  OldBase := ABase;
  Caption := 'Modifier une base';
end;

procedure TFrm_AjoutModifBase.OuvrirFichier;
begin
  if OD_Base.Execute then
  begin
    EBase.Text := OD_Base.FileName;
    EBase.SelectAll;
  end;
end;

procedure TFrm_AjoutModifBase.CMDialogKey(var M: TCMDialogKey);
begin
  if (m.CharCode=VK_RETURN) and (ActiveControl=ENom) then
    m.CharCode:=VK_TAB;   
  if (m.CharCode=VK_RETURN) and (ActiveControl=EBase) then
  begin
    if (EBase.Text='') or not(FileExists(EBase.Text)) then
    begin
      M.Result:=1;
      OuvrirFichier;
      exit;
    end;
    m.CharCode:=VK_TAB;
  end;
  inherited;
end;

procedure TFrm_AjoutModifBase.ENomKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key)>=32) and (Pos(Key,' =/\:*?"<>|')>0) then
    Key:=chr(7);
end;

procedure TFrm_AjoutModifBase.FormCreate(Sender: TObject);
begin
  OldInd := -1;
  ENom.Text := '';
  EBase.Text := '';
  OldBase := '';
  OD_Base.InitialDir := ReperBase+'Data\';
end;

procedure TFrm_AjoutModifBase.Nbt_ChercheBaseClick(Sender: TObject);
begin
  OuvrirFichier;
end;

procedure TFrm_AjoutModifBase.Nbt_OkClick(Sender: TObject);
var
  Book: TBookmark;
  bOk: boolean;
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    if ENom.Text='' then
    begin
      MessageDlg('Nom obligatoire !',mterror,[mbok],0);
      ModalResult:=mrnone;
      ENom.SetFocus;
      Exit;
    end;
    if EBase.Text='' then
    begin
      MessageDlg('chemin base obligatoire !',mterror,[mbok],0);
      ModalResult:=mrnone;
      EBase.SetFocus;
      Exit;
    end;

    // test si le nom existe déjà
    with Dm_Main do
    begin
      bOk := true;
      Book := Cds_Base.GetBookmark;
      Cds_Base.DisableControls;
      try
        Cds_Base.First;
        while bOk and not(Cds_Base.Eof) do
        begin
          if (Cds_Base.FieldByName('Ind').AsInteger<>OldInd)
              and (Cds_Base.FieldByName('Nom').AsString=ENom.Text) then
            bOk := false;
          Cds_Base.Next;
        end;
      finally
        Cds_Base.GotoBookmark(Book);
        Cds_Base.FreeBookmark(Book);
        Cds_Base.EnableControls;
      end;
      if not(bOk) then
      begin 
        MessageDlg('Ce nom existe déjà !',mterror,[mbok],0);
        ModalResult:=mrnone;
        ENom.SetFocus;
        ENom.SelectAll;
        Exit;
      end;
    end;

    // si le chemin de la base à changer
    if OldBase<>EBase.Text then
    begin
      if not(fileExists(EBase.Text)) then
      begin
        MessageDlg('Chemin de la base non trouvé !',mterror,[mbok],0);
        ModalResult := mrnone;
        EBase.SetFocus;
        EBase.SelectAll;
        exit;
      end;

      // test connexion à la base
      if not(Dm_Main.TestConnexion(EBase.Text)) then
      begin
        MessageDlg('Impossible de se connecter à la base de données !',mterror,[mbok],0);
        ModalResult := mrnone;
        EBase.SetFocus;
        EBase.SelectAll;
        exit;
      end;
    end;
  finally
    Application.ProcessMessages; 
    Screen.Cursor := crDefault;
  end;
end;

end.
