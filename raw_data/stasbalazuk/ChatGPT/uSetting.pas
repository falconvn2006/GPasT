unit uSetting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, IniFiles, ComCtrls, Buttons;

type
  TfSetting = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    grpT: TGroupBox;
    mmoToken: TMemo;
    edtTemp: TEdit;
    ud1: TUpDown;
    ltemp: TLabel;
    btnSave: TBitBtn;
    grpGoogleLanguageApiKey: TGroupBox;
    mmoGoogleLanguageApiKey: TMemo;
    procedure edtTempKeyPress(Sender: TObject; var Key: Char);
    procedure btnSaveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure WriteIniFile(uFile: string; Section_Name: string; Key_Name: string; StrValue: string);
    function ReadIniFile(uFile: string; Section_Name: string; Key_Name: string) : string;
    procedure ReadAllSecIniFile(uFile: string);
    procedure EraseSecIniFile(uFile: string; Section_Name: string);
    procedure ReadValueSecIniFile(uFile: string; Section_Name: string);
    procedure ReadSecIniFile(uFile: string; Section_Name: string);
  public
    { Public declarations }
    temper : Integer;
    uToken,uGoogleLanguageApiKey : string;
  end;

var
  fSetting: TfSetting;

implementation

{$R *.dfm}


// Write values to a INI file
procedure TfSetting.WriteIniFile(uFile: string; Section_Name: string; Key_Name: string; StrValue: string); //'c:\MyIni.ini'
 var
   ini: TIniFile;
begin
try
   // Create INI Object and open or create file test.ini
    ini := TIniFile.Create(uFile);
   try
     // Write a string value to the INI file.
    ini.WriteString(Section_Name, Key_Name, StrValue);
     // Write a integer value to the INI file.
     //ini.WriteInteger(Section_Name, Key_Name, IntValue);
     // Write a boolean value to the INI file.
     //ini.WriteBool(Section_Name, Key_Name, BoolValue);
   finally
     ini.Free;
   end;
except
  Exit;
end;
end;


 // Read values from an INI file
function TfSetting.ReadIniFile(uFile: string; Section_Name: string; Key_Name: string) : string;
 var
   ini: TIniFile;
   res: string;
begin
try
     Result := '';
     // Create INI Object and open or create file test.ini
     ini := TIniFile.Create(uFile);
   try
     res := ini.ReadString(Section_Name, Key_Name, ''); //MessageDlg('Value of Section:  ' + res, mtInformation, [mbOK], 0);
     Result := res;
   finally
     ini.Free;
   end;
except
  Exit;
end;
end;

 // Read all sections
procedure TfSetting.ReadAllSecIniFile(uFile: string);
 var
    ini: TIniFile;
    uList: TStringList;
begin
try
  try
     uList := TStringList.Create;
     ini := TIniFile.Create('MyIni.ini');
   try
     ini.ReadSections(uList);
     if uList.Count > 0 then MessageDlg('All Section:  ' + uList.Text, mtInformation, [mbOK], 0);
   finally
     ini.Free;
   end;
  finally
    uList.Free;
  end;
except
  Exit;
end;
end;

 // Read a section
procedure TfSetting.ReadSecIniFile(uFile: string; Section_Name: string);
var
    ini: TIniFile;
    uList: TStringList;
begin
try
  try
    uList := TStringList.Create;
    ini := TIniFile.Create(uFile);
   try
    ini.ReadSection(Section_Name, uList);
    if uList.Count > 0 then MessageDlg('Read of Section:  ' + uList.Text, mtInformation, [mbOK], 0);
   finally
    ini.Free;
   end;
  finally
    uList.Free;
  end;
except
   Exit;
end;
end;

 // Read section values
procedure TfSetting.ReadValueSecIniFile(uFile: string; Section_Name: string);
var
    ini: TIniFile;
    uList: TStringList;
begin
try
  try
    uList := TStringList.Create;
    ini := TIniFile.Create(uFile);
   try
    ini.ReadSectionValues(Section_Name, uList);
    if uList.Count > 0 then MessageDlg('Value of Section:  ' + uList.Text, mtInformation, [mbOK], 0);
   finally
    ini.Free;
   end;
  finally
    uList.Free;
  end;
except
   Exit;
end;
end;

 // Erase a section
procedure TfSetting.EraseSecIniFile(uFile: string; Section_Name: string);
var
    ini: TIniFile;
begin
try
    ini := TIniFile.Create(uFile);
   try
    ini.EraseSection(Section_Name);
    MessageDlg('Erase of Section:  ' + Section_Name + ' successfully', mtInformation, [mbOK], 0);
   finally
    ini.Free;
   end;
except
   Exit;
end;
end;

procedure TfSetting.edtTempKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'2', #8])then Key:=#0;
end;

function ExtractOnlyFileName(const FileName: string): string;
begin
  result:=StringReplace(ExtractFileName(FileName),ExtractFileExt(FileName),'',[]);
end;

procedure TfSetting.btnSaveClick(Sender: TObject);
var uTok,uGoogleKey : string;
begin
try
     uTok := Trim(mmoToken.Text);
     uGoogleKey := Trim(mmoGoogleLanguageApiKey.Text);
  if Length(uTok) > 0 then begin
     WriteIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Bearer','Token',uTok);
     WriteIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Bearer','GoogleLanguageApiKey',uGoogleKey);
     WriteIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Setting','Temperature',Trim(edtTemp.Text));
     temper := StrToInt(edtTemp.Text);
     uToken := uTok;
     uGoogleLanguageApiKey := uGoogleKey;
  end else MessageBox(Handle,PChar('No token, please enter a token!'), PChar('Attention'), 64);
     mmoToken.SetFocus;
except
  Exit;
end;
end;

procedure TfSetting.FormActivate(Sender: TObject);
begin
try
  mmoToken.SetFocus;
except
  Exit;
end;
end;

procedure TfSetting.FormCreate(Sender: TObject);
begin
try
if FileExists(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini') then begin
   mmoToken.Text := ReadIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Bearer','Token');
   mmoGoogleLanguageApiKey.Text := ReadIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Bearer','GoogleLanguageApiKey');
   edtTemp.Text := ReadIniFile(ExtractFileDir(ParamStr(0))+'\ChatGPT.ini','Setting','Temperature');
end;
except
  Exit;
end;
end;

end.
