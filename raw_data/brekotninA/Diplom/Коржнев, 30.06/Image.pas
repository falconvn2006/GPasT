unit Image;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sGroupBox, Buttons, sBitBtn, MPlayer, ShellAPI;

type
  TImageForm = class(TForm)
    sGroupBox3: TsGroupBox;
    sBitBtn5: TsBitBtn;
    sBitBtn12: TsBitBtn;
    sBitBtn13: TsBitBtn;
    sBitBtn1: TsBitBtn;
    procedure sBitBtn5Click(Sender: TObject);
    procedure sBitBtn12Click(Sender: TObject);
    procedure sBitBtn13Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImageForm: TImageForm;

implementation

uses MyDB, ShowVideo, ShowPicture, ShowAudio, MainMenu;

{$R *.dfm}

procedure TImageForm.FormShow(Sender: TObject);
var
  ResStream:TResourceStream;
begin
  if fdb.ADOInsertQuestion.FieldByName('SolveVideo_Id').IsNull then
    begin
      sBitBtn5.Visible:=false;
      sBitBtn5.Enabled:=false;
    end
  else
    begin
      if fMainMenu.userOld<10 then
        begin
          //if FileExists(ExtractFilePath(Application.ExeName)+'img\Video.bmp') then
            begin
              sBitBtn5.Caption:='';
              ResStream:=TResourceStream.Create(HInstance, 'Image4', RT_RCDATA);
              sBitBtn5.Glyph.LoadFromStream(ResStream);
              ResStream.Free;
              //sBitBtn5.Glyph.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\Video.bmp');
            end;
        end;
    end;
  if fdb.ADOInsertQuestion.FieldByName('SolvePhoto_Id').IsNull then
    begin
      sBitBtn12.Visible:=false;
      sBitBtn12.Enabled:=false;
    end
  else
    begin
      if fMainMenu.userOld<10 then
        begin
          //if FileExists(ExtractFilePath(Application.ExeName)+'img\PhotoApp.bmp') then
            begin
              sBitBtn12.Caption:='';
              ResStream:=TResourceStream.Create(HInstance, 'Image5', RT_RCDATA);
              sBitBtn12.Glyph.LoadFromStream(ResStream);
              ResStream.Free;
              //sBitBtn12.Glyph.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\PhotoApp.bmp');
            end;
        end;
    end;
  if fdb.ADOInsertQuestion.FieldByName('SolveAudio_Id').IsNull then
    begin
      sBitBtn13.Visible:=false;
      sBitBtn13.Enabled:=false;
    end
  else
    begin
      if fMainMenu.userOld<10 then
        begin
          //if FileExists(ExtractFilePath(Application.ExeName)+'img\Audio.bmp') then
            begin
              sBitBtn13.Caption:='';
              ResStream:=TResourceStream.Create(HInstance, 'Image3', RT_RCDATA);
              sBitBtn13.Glyph.LoadFromStream(ResStream);
              ResStream.Free;
              //sBitBtn13.Glyph.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\Audio.bmp');
            end;
        end;
    end;
  if fdb.ADOInsertQuestion.FieldByName('TheoryHelp_Id').IsNull then
    begin
      sBitBtn1.Visible:=false;
      sBitBtn1.Enabled:=false;
    end
  else
    begin
      if fMainMenu.userOld<10 then
        begin
          //if FileExists(ExtractFilePath(Application.ExeName)+'img\book.jpg') then
            begin
              sBitBtn1.Caption:='';
              ResStream:=TResourceStream.Create(HInstance, 'Image6', RT_RCDATA);
              sBitBtn1.Glyph.LoadFromStream(ResStream);
              ResStream.Free;
              //sBitBtn1.Glyph.LoadFromFile(ExtractFilePath(Application.ExeName)+'img\book.jpg');
            end;
        end;
    end;
end;

procedure TImageForm.sBitBtn12Click(Sender: TObject);
Var
  s:String;
  Photo_ID: integer;
begin
  try
    Screen.Cursor:=crAppStart;
    Photo_ID:=fdb.ADOInsertQuestion.FieldByName('SolvePhoto_Id').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=3');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Photo_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowPictureForm := TShowPictureForm.Create(nil);
    try
      ShowPictureForm.Mode:=1;
      ShowPictureForm.FileName:=s;
      try
        ShowPictureForm.Image1.Picture.LoadFromFile(ShowPictureForm.FileName);
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        hide;
        ShowPictureForm.ShowModal;
      finally
        FreeAndNil(ShowAudioForm);
      end;
        show;
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;

procedure TImageForm.sBitBtn13Click(Sender: TObject);
Var
  s:String;
  Audio_ID: integer;
begin
  try
    Screen.Cursor:=crAppStart;
    Audio_ID:=fdb.ADOInsertQuestion.FieldByName('SolveAudio_Id').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=1');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Audio_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowAudioForm := TShowAudioForm.Create(nil);
    try
      ShowAudioForm.Mode:=1;
      ShowAudioForm.FileName:=s;
      try
        ShowAudioForm.MediaPlayer1.FileName:=ShowAudioForm.FileName;
        ShowAudioForm.MediaPlayer1.Open;
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        hide;
        ShowAudioForm.ShowModal;
        if ShowAudioForm.MediaPlayer1.Mode=mpPlaying then
          ShowAudioForm.MediaPlayer1.Stop;
      finally
        FreeAndNil(ShowAudioForm);
      end;
        show;
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;

procedure TImageForm.sBitBtn1Click(Sender: TObject);
var
  s:String;
  TheoryHelp_ID:integer;
begin
  try
    Screen.Cursor:=crAppStart;
    TheoryHelp_ID:=fdb.ADOInsertQuestion.FieldByName('TheoryHelp_ID').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=4');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=TheoryHelp_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    if s<>'' then
      ShellExecute(ImageForm.Handle, 'open', PWideChar(s), nil, nil, SW_RESTORE)
    else
      ShowMessage('Файл с теорией не найден!');
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;

procedure TImageForm.sBitBtn5Click(Sender: TObject);
Var
  s:String;
  Video_ID:integer;
begin
  try
    Screen.Cursor:=crAppStart;
    Video_ID := fdb.ADOInsertQuestion.FieldByName('SolveVideo_Id').AsInteger;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    fDB.ADOAudioUsl.SQL.Clear;
    fDB.ADOAudioUsl.SQL.ADD('SELECT Soderjanie FROM Multim WHERE ID=:1 AND Type=2');
    fDB.ADOAudioUsl.Parameters.ParamByName('1').Value:=Video_ID;
    fDB.ADOAudioUsl.Open;
    fDB.ADOAudioUsl.First;
    s:=ExtractFilePath(Application.ExeName)+fdb.ADOAudioUsl.Fields[0].AsString;
    if fDB.ADOAudioUsl.Active then
      fDB.ADOAudioUsl.Close;
    ShowVideoForm := TShowVideoForm.Create(nil);
    try
      ShowVideoForm.Mode:=1;
      ShowVideoForm.FileName:=s;
      try
        ShowVideoForm.MediaPlayer1.FileName:=ShowVideoForm.FileName;
        ShowVideoForm.MediaPlayer1.Open;
      except
        ShowMessage('Нераспознанный формат файла!');
        exit;
      end;
        hide;
        ShowVideoForm.ShowModal;;
        if ShowVideoForm.MediaPlayer1.Mode=mpPlaying then
          ShowVideoForm.MediaPlayer1.Stop;
      finally
        FreeAndNil(ShowVideoForm);
      end;
        show;
    except
      on E:Exception do
        begin
          ShowMessage(E.Message);
          Screen.Cursor:=crDefault;
        end;
    end;
    Screen.Cursor:=crDefault;
end;

end.
