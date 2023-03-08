unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ImgList, ComCtrls,
  iniFiles, Buttons, CheckLst, ADODB, DB;

Const
  cConnectionString = 'Provider=SQLNCLI10.1;Persist Security Info=True;User ID=%s;password=%s;Initial Catalog=%s;Data Source=%s;';

type
  TFormUpdateBaseFromFile = class(TForm)
    Pgc_FileControl: TPageControl;
    Tab_Logs: TTabSheet;
    MemoData: TMemo;
    Btn_RunUpdate: TButton;
    ComboBoxFilePathAndName: TComboBox;
    FileOpenDialogDefaultPath: TFileOpenDialog;
    ADOConnection: TADOConnection;
    ADOQueryUpdateDB: TADOQuery;
    RadioGroupExt: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure ComboBoxFilePathAndNameDropDown(Sender: TObject);
    procedure Btn_RunUpdateClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure LoadIniParams;
  public
    { Déclarations publiques }
    ABoolean : Boolean;
  end;

var
  FormUpdateBaseFromFile: TFormUpdateBaseFromFile;

implementation

{$R *.dfm}

procedure TFormUpdateBaseFromFile.FormActivate(Sender: TObject);
begin
  RadioGroupExt.ItemIndex := 0;
  LoadIniParams;
end;


procedure TFormUpdateBaseFromFile.LoadIniParams;
var
  vIniFile : TIniFile;
  aString, aLoginAdresse, aLoginBaseName, aLoginUserName, aLoginPwd: String;
begin
  try
    aString := ExtractFilePath(Application.ExeName) + 'UpdateBaseFromFile.ini';
    vIniFile:= TIniFile.Create(aString);
    aLoginAdresse := vIniFile.ReadString('SQLSERVEUR','LoginAdresse','');
    aLoginBaseName := vIniFile.ReadString('SQLSERVEUR','LoginBaseName','');
    aLoginUserName := vIniFile.ReadString('SQLSERVEUR','LoginUserName','');
    aLoginPwd := vIniFile.ReadString('SQLSERVEUR','LoginPwd','');
    aString := Format(cConnectionString, [aLoginUserName,aLoginPwd,aLoginBaseName,aLoginAdresse]);
    ADOConnection.ConnectionString := aString;
    ADOConnection.DefaultDatabase:= aLoginBaseName;
    ADOConnection.Open;
  finally
    vIniFile.Free;
  end;
end;



procedure TFormUpdateBaseFromFile.Btn_RunUpdateClick(Sender: TObject);
var
  AString : string;

  I,J : Integer;
  ADateTime : TDateTime;
begin
  if (ABoolean = False) and (FileExists(ComboBoxFilePathAndName.Text)) then
  begin
    MemoData.Lines.LoadFromFile(ComboBoxFilePathAndName.Text);
    ABoolean := True;
  end;
  if (ABoolean = True) and (RadioGroupExt.ItemIndex >= 0) and (MemoData.Lines.Count > 0) then
  begin
    ABoolean := False;
    ADOQueryUpdateDB.SQL.Clear;
    ADOQueryUpdateDB.SQL.Append('UPDATE CLIENTS SET');
    case RadioGroupExt.ItemIndex of
      0 : ADOQueryUpdateDB.SQL.Append('CLI_CREATION = 1');
      1 : ADOQueryUpdateDB.SQL.Append('CLI_MODIF = 1');
      2 : ADOQueryUpdateDB.SQL.Append('CLI_CREATION = 0, CLI_MODIF = 1');
    end;
    ADOQueryUpdateDB.SQL.Append('WHERE CLI_NUMCARTE = :PCLI_NUMCARTE');
    case RadioGroupExt.ItemIndex of
      0 : ADOQueryUpdateDB.SQL.Append('AND CLI_ENSID = 2');
      1 : ADOQueryUpdateDB.SQL.Append('AND CLI_ENSID = 1');
      2 : ADOQueryUpdateDB.SQL.Append('AND CLI_ENSID = 2');
    end;

    try
      ADOConnection.BeginTrans;
      J := 0;
      ADateTime := now;
      for I := 0 to MemoData.Lines.Count-1 do
      begin
        AString := Trim(MemoData.Lines[I]);
        if AString <> '' then
        begin
          ADOQueryUpdateDB.Parameters.ParamByName('PCLI_NUMCARTE').Value := AString;
          ADOQueryUpdateDB.ExecSQL;
          Inc(J);
          RadioGroupExt.Caption := 'Nbr=' + IntToStr(J);
          Application.ProcessMessages;
        end;
      end;
      ADOConnection.CommitTrans;
      RadioGroupExt.Caption := '';
      MemoData.Lines.Clear;
      MemoData.Lines.Append('Début traitement.........: ' + FormatDateTime('dd/mm/yyyy a hh:nn:ss',now));
      MemoData.Lines.Append('Type extention...........: ' + RadioGroupExt.Items[RadioGroupExt.ItemIndex]);
      MemoData.Lines.Append('Nbr de données traitées : ' + IntToStr(J));
      MemoData.Lines.Append('Fin traitement.............: ' + FormatDateTime('dd/mm/yyyy a hh:nn:ss',now));
      MemoData.Lines.Append('Temps de traitement.....: ' + FormatDateTime('hh:nn:ss:zzz', now - ADateTime));

    except
      on E: Exception do
      begin
        if ADOConnection.InTransaction then
        begin
          ADOConnection.RollbackTrans;
          Raise Exception.Create('Erreur NumCarte = ' + AString + ' : ' + E.Message);
        end;
      end;
    end;
  end;
end;

procedure TFormUpdateBaseFromFile.ComboBoxFilePathAndNameDropDown(Sender: TObject);
begin
  FileOpenDialogDefaultPath.Options := [];
  if FileOpenDialogDefaultPath.Execute then
  begin
    ComboBoxFilePathAndName.Text := FileOpenDialogDefaultPath.FileName;
    if FileExists(ComboBoxFilePathAndName.Text) then
    begin
      MemoData.Lines.LoadFromFile(ComboBoxFilePathAndName.Text);
      Btn_RunUpdate.Enabled := True;
      ABoolean := True;
    end
    else MessageDlg('Fichier inexistant',mtError,[mbOk],0);
  end;
end;




end.
