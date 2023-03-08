unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EFic1: TEdit;
    EFic2: TEdit;
    EFicResu: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Nbt_Exec: TBitBtn;
    SD_Resu: TSaveDialog;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Nbt_ExecClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  EFic1.Text := 'InitConsodiv.csv';
  EFic2.Text := 'AutreConsoDiv.csv';
  EFicResu.Text := 'CONSODIV.csv';
end;

procedure TMainForm.Nbt_ExecClick(Sender: TObject);
var
  sFile1, sFile2: string;
  sTest: string;
  sFileResu: string;
  Stream1, Stream2, StreamDest: TFileStream;
begin
  sFile1 := EFic1.Text;
  if (sFile1='') or not(FileExists(sFile1)) then
  begin
    MessageDlg('Fichier 1 invalide !', mterror, [mbok], 0);
    exit;
  end;

  sFile2 := EFic2.Text;
  if (sFile2='') or not(FileExists(sFile2)) then
  begin
    MessageDlg('Fichier 2 invalide !', mterror, [mbok], 0);
    exit;
  end;

  sfileResu := EFicResu.Text;
  sTest := ExtractfilePath(sFileResu);
  if (sTest<>'') and (sTest[Length(sTest)]<>'\') then
    sTest := sTest+'\';
  if (sTest='') or not(DirectoryExists(sTest)) then
  begin
    MessageDlg('Répertoire destination introuvable !', mterror, [mbok], 0);
    exit;
  end;

  if FileExists(sFileResu) then
    DeleteFile(sFileResu);

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Stream1 := nil;
  Stream2 := nil;
  StreamDest := nil;
  try
    Stream1 := TFileStream.Create(sFile1, fmOpenRead);
    Stream1.Seek(0, soFromBeginning);
    Stream2 := TFileStream.Create(sFile2, fmOpenRead);
    Stream2.Seek(0, soFromBeginning);
    StreamDest := TFileStream.Create(sFileResu, fmCreate);
    StreamDest.CopyFrom(Stream1, 0);
    StreamDest.CopyFrom(Stream2, 0);

    MessageDlg('Ok', mterror, [mbok], 0);
  finally
    if Assigned(StreamDest) then
    begin
      StreamDest.Free;
      StreamDest := nil;
    end;
    if Assigned(Stream1) then
    begin
      Stream1.Free;
      Stream1 := nil;
    end;
    if Assigned(Stream2) then
    begin
      Stream2.Free;
      Stream2 := nil;
    end;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
var
  odTemp : TOpenDialog;
  sFile: string;
begin
  sFile := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier csv|*.csv|*.*|tous';
    odTemp.Title := 'Fichier 1';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      sFile := odTemp.FileName;
  finally
    FreeAndNil(odTemp);
  end;
  if sFile='' then
    exit;

  EFic1.Text := sFile;
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
var
  odTemp : TOpenDialog;
  sFile: string;
begin
  sFile := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier csv|*.csv|*.*|tous';
    odTemp.Title := 'Fichier 2';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      sFile := odTemp.FileName;
  finally
    FreeAndNil(odTemp);
  end;
  if sFile='' then
    exit;

  EFic2.Text := sFile;
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  if SD_Resu.Execute then
    EFicResu.Text := SD_Resu.FileName;
end;

end.
