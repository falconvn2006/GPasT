unit AjoutModifParam_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, StdCtrls, GinkoiaStyle_Dm, AdvGlowButton, RzLabel,
  ExtCtrls, RzPanel, DB;

type
  TFrm_AjoutModifParam = class(TAlgolDialogForm)
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ENum: TEdit;
    ENom: TEdit;
    Cb_Tipe: TComboBox;
    procedure Nbt_CancelClick(Sender: TObject);
    procedure Nbt_PostClick(Sender: TObject);
    procedure ENumKeyPress(Sender: TObject; var Key: Char);
    procedure AlgolDialogFormCreate(Sender: TObject);
  private
    { Déclarations privées }
    AncienNum: integer;
  public
    { Déclarations publiques }
    procedure SetAjout;
    procedure SetModif;
  end;

var
  Frm_AjoutModifParam: TFrm_AjoutModifParam;

implementation

uses
  Main_Dm;

{$R *.dfm}

procedure TFrm_AjoutModifParam.SetAjout;
var
  Book: TBookMark;
  iNo: integer;
begin
  AncienNum := -1;
  iNo := 0;
  with Dm_Main do
  begin
    if cds_Param.RecordCount>0 then
    begin
      Book := cds_Param.GetBookmark;
      cds_Param.DisableControls;
      try
        cds_Param.First;
        while not(cds_Param.Eof) do
        begin
          if cds_Param.fieldbyname('Num').AsInteger>iNo then
            iNo := cds_Param.fieldbyname('Num').AsInteger;

          cds_Param.Next;
        end;
      finally
        cds_Param.GotoBookmark(Book);
        cds_Param.FreeBookmark(Book);
        cds_Param.EnableControls;
      end;
    end;
  end;
  ENum.Text := inttostr(iNo+1);
  ActiveControl := ENom;
end;

procedure TFrm_AjoutModifParam.SetModif;
begin
  Caption := 'Modifier un paramètre';
  AncienNum := Dm_Main.cds_Param.fieldbyname('Num').AsInteger;
  ENum.Text := inttostr(Dm_Main.cds_Param.fieldbyname('Num').AsInteger);
  ENom.Text := Dm_Main.cds_Param.fieldbyname('Nom').AsString;
  case Dm_Main.cds_Param.fieldbyname('Tipe').AsInteger of
    1: Cb_Tipe.ItemIndex := 0;
    2: Cb_Tipe.ItemIndex := 1;
    3: Cb_Tipe.ItemIndex := 2;
    4: Cb_Tipe.ItemIndex := 3;
  end;
  ActiveControl := ENom;
end;

procedure TFrm_AjoutModifParam.AlgolDialogFormCreate(Sender: TObject);
begin
  ENum.Text := '';
  ENom.Text := '';
  AncienNum := -1;
end;

procedure TFrm_AjoutModifParam.ENumKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key)>=32) and (CharInSet(Key, ['0'..'9'])) then
    Key := chr(7);
end;

procedure TFrm_AjoutModifParam.Nbt_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_AjoutModifParam.Nbt_PostClick(Sender: TObject);
var
  iNum: integer;
  bExist: boolean;
  sNom: string;
  iTipe: integer;
  Book: TBookMark;
begin
  iNum := StrToIntDef(ENum.Text, 0);
  if (iNum<=0) then
  begin
    MessageDlg('N° invalide !', mterror, [mbok],0);
    ENum.SetFocus;
    ENum.SelectAll;
    exit;
  end;

  bExist := false;
  with Dm_Main do
  begin
    if cds_Param.RecordCount>0 then
    begin
      Book := cds_Param.GetBookmark;
      cds_Param.DisableControls;
      try
        cds_Param.First;
        while not(bExist) and not(cds_Param.Eof) do
        begin
          if (cds_Param.fieldbyname('Num').AsInteger=iNum)
             and (cds_Param.fieldbyname('Num').AsInteger<>AncienNum) then
            bExist := true;

          cds_Param.Next;
        end;
      finally
        cds_Param.GotoBookmark(Book);
        cds_Param.FreeBookmark(Book);
        cds_Param.EnableControls;
      end;
    end;
  end;
  if (bExist) then
  begin
    MessageDlg('Ce N° existe déjà !', mterror, [mbok],0);
    ENum.SetFocus;
    ENum.SelectAll;
    exit;
  end;

  sNom := Trim(ENom.Text);
  if sNom='' then
  begin
    MessageDlg('Nom obligatoire !', mterror, [mbok],0);
    ENom.SetFocus;
    ENom.SelectAll;
    exit;
  end;

  iTipe := Cb_Tipe.ItemIndex+1;

  with Dm_Main do
  begin
    if AncienNum=-1 then
    begin
      cds_Param.Append;
      cds_Param.FieldByName('Num').AsInteger := iNum;
    end
    else
    begin
      cds_Param.Edit;
      cds_Param.FieldByName('ValString').AsString := '';
      cds_Param.FieldByName('ValInteger').Value := null;
      cds_Param.FieldByName('ValFloat').Value := null;
      cds_Param.FieldByName('ValDateTime').Value := null;
    end;
    cds_Param.FieldByName('Nom').AsString := ENom.Text;
    cds_Param.FieldByName('Tipe').AsInteger := iTipe;
    cds_Param.FieldByName('Saisi').AsInteger := 0;
    case iTipe of
      1:
      begin
        cds_Param.FieldByName('ValInteger').Value := null;
        cds_Param.FieldByName('ValFloat').Value := null;
        cds_Param.FieldByName('ValDateTime').Value := null;
      end;
      2:
      begin
        cds_Param.FieldByName('ValString').AsString := '';
        cds_Param.FieldByName('ValFloat').Value := null;
        cds_Param.FieldByName('ValDateTime').Value := null;
      end;
      3:
      begin
        cds_Param.FieldByName('ValString').AsString := '';
        cds_Param.FieldByName('ValInteger').Value := null;
        cds_Param.FieldByName('ValDateTime').Value := null;
      end;
      4:
      begin
        cds_Param.FieldByName('ValString').AsString := '';
        cds_Param.FieldByName('ValInteger').Value := null;
        cds_Param.FieldByName('ValFloat').Value := null;
      end;
    end;
    cds_Param.Post;
  end;

  ModalResult := mrOk;
end;

end.
