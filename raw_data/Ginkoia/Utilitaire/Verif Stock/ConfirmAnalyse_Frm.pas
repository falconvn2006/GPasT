unit ConfirmAnalyse_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LMDCustomButton, LMDButton, ExtCtrls, RzLabel;

type
  TFrm_ConfirmAnalyse = class(TForm)
    Lab_InfoAction: TRzLabel;
    Chk_Minimize: TCheckBox;
    Bevel1: TBevel;
    Nbt_Ok: TLMDButton;
    Nbt_Cancel: TLMDButton;
    Rad_Analyse: TRadioButton;
    Rad_Ouvre: TRadioButton;
    Lbx_Fichier: TListBox;
    procedure Rad_AnalyseClick(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
    procedure Lbx_FichierDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
  private
    { Déclarations privées }
    Cas: integer;
  public
    { Déclarations publiques }
    RetFic: string;
    procedure InitEcr(ANom: string);
  end;

var
  Frm_ConfirmAnalyse: TFrm_ConfirmAnalyse;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_ConfirmAnalyse.InitEcr(ANom: string);
var
  sReper: string;
  i: integer;
  resu: integer;
  sFic: string;
  SearchRec: TSearchRec;
  TPListe: TStringList;
  dtFic: TDateTime;
begin
  sReper := ReperRapport + ANom + '\';  
  Chk_Minimize.Enabled := (Rad_Analyse.Checked);
  Lbx_Fichier.Enabled := (Rad_Ouvre.Checked);
  Rad_Analyse.Checked := true;

  Lbx_Fichier.Clear;
  TPListe := TStringList.Create;
  try
    resu := FindFirst(sReper+'Analyse_Art_*.*', faAnyFile, SearchRec);
    while resu=0 do
    begin
      sFic := ExtractFileName(SearchRec.Name);
      dtFic := FileDateToDateTime(SearchRec.Time);
      if (sFic<>'.') and (sFic<>'..') then
        TPListe.Add(FormatDateTime('yyyymmddhhnnsszzz',dtFic)+'|'+sFic);

      resu := FindNext(SearchRec);
    end;
    FindClose(SearchRec);

    TPListe.Sort;
    for i:=TPListe.Count downto 1 do
    begin
      sFic := TPListe[i-1];
      sFic := Copy(sFic,Pos('|',sFic)+1, length(sFic));
      dtFic :=  FileDateToDateTime(FileAge(sReper+sFic));
      Lbx_Fichier.Items.Add(sFic+'|Fichier du '+FormatDateTime('dd/mm/yyyy hh:nn:ss',dtFic));
    end;
  finally
    TPListe.Free;
    TPListe := nil;
  end;

  Rad_Ouvre.Enabled := (Lbx_Fichier.Count>0);
end;

procedure TFrm_ConfirmAnalyse.Lbx_FichierDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
  State: TOwnerDrawState);
var
  sTmp: string;
begin
  with TListBox(Control).Canvas do
  begin
    FillRect(Rect);
    if not(TListBox(Control).Enabled) then
      Font.Color := clgray;
    sTmp := TListBox(Control).Items[Index];
    sTmp := Copy(sTmp,Pos('|',sTmp)+1,Length(sTmp));
    TextOut(Rect.Left+2, Rect.Top, sTmp);
  end;
end;

procedure TFrm_ConfirmAnalyse.Nbt_OkClick(Sender: TObject);
begin
  RetFic := '';
  if Rad_Ouvre.Checked then
  begin
    if Lbx_Fichier.ItemIndex<0 then
    begin
      MessageDlg('Pas de sélection de fichier !',mterror,[mbok],0);
      ModalResult:= mrnone;
      exit;
    end;

    RetFic := Lbx_Fichier.Items[Lbx_Fichier.ItemIndex];
    RetFic := Copy(RetFic,1,pos('|',RetFic)-1);
  end;
end;

procedure TFrm_ConfirmAnalyse.Rad_AnalyseClick(Sender: TObject);
begin
  Chk_Minimize.Enabled := (Rad_Analyse.Checked);
  Lbx_Fichier.Enabled := (Rad_Ouvre.Checked);
end;

end.
