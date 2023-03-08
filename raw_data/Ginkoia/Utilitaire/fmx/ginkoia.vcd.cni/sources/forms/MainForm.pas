unit MainForm;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  uReportMemoryLeaks,
  FMX.Objects,
  FMX.Layouts,
  uApplicationVersion,
  uEntropy.TForm.Constrained,
  uEntropy.TSpeedButton.Colored,
  FMX.Edit,
  FMX.Media,
  Winapi.UxTheme,
  FMX.Controls.Presentation;

type
  TFrm_Main = class(TForm)
    Lay_Wrapper: TLayout;
    Img_Background: TImage;
    Lay_Header: TLayout;
    Rec_Header: TRectangle;
    Lay_AppBar: TLayout;
    Lab_AppCaption: TLabel;
    Img_AppIcon: TImage;
    Lay_Footer: TLayout;
    SBtn_Close: TSpeedButton;
    Img_CloseBtn: TImage;
    SBtn_Ok: TSpeedButton;
    Img_OkBtn: TImage;
    Lay_UserId: TLayout;
    Lab_UserId: TLabel;
    Edt_UserId: TEdit;
    GPLay_WebcamAreas: TGridPanelLayout;
    Lay_WebcamArea1: TLayout;
    Lay_WebcamControls1: TLayout;
    SBtn_Capture1: TSpeedButton;
    Img_CaptureBtn1: TImage;
    Img_Webcam1: TImage;
    Lay_DocumentInfo1: TLayout;
    Lab_DocumentCaption1: TLabel;
    Lay_WebcamError1: TLayout;
    Rec_WebcamError1: TRectangle;
    Lab_WebcamError1: TLabel;
    Lay_Filename1: TLayout;
    Edt_Filename1: TEdit;
    EEBtn_Filename1: TEllipsesEditButton;
    Lab_Filename1: TLabel;
    Lay_WebcamArea2: TLayout;
    Lay_WebcamControls2: TLayout;
    SBtn_Capture2: TSpeedButton;
    Img_CaptureBtn2: TImage;
    Img_Webcam2: TImage;
    Lay_DocumentInfo2: TLayout;
    Lab_DocumentCaption2: TLabel;
    Lay_WebcamError2: TLayout;
    Rec_WebcamError2: TRectangle;
    Lab_WebcamError2: TLabel;
    Lay_Filename2: TLayout;
    Edt_Filename2: TEdit;
    EEBtn_Filename2: TEllipsesEditButton;
    Lab_Filename2: TLabel;
    Tim_Webcam: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EEBtn_Filename1Click(Sender: TObject);
    procedure EEBtn_Filename2Click(Sender: TObject);
    procedure SBtn_OkClick(Sender: TObject);
    procedure SBtn_CloseClick(Sender: TObject);
    procedure Tim_WebcamTimer(Sender: TObject);
    procedure Lay_AppBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure SBtn_Capture1Click(Sender: TObject);
    procedure SBtn_Capture2Click(Sender: TObject);
    procedure Edt_UserIdKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure Edt_Filename1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure Edt_Filename2KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  private type
    TVideoCameraState = (vcsUncaptured, vcsCaptured, vcsLoaded);
  private
    { Déclarations privées }
    VideoCamera: TVideoCaptureDevice;
    Captured1  : TVideoCameraState;
    Captured2  : TVideoCameraState;
    CouldSave1 : Boolean;
    CouldSave2 : Boolean;
    Directory  : TFileName;
    { methods }
    procedure SampleBufferReady(Sender: TObject; const ATime: TMediaTime);
    procedure LoadParams();
    procedure LoadPicturesIfExists;
    procedure EditSetTextAndKeyUp(const Filename: TFileName; const AEdit: TEdit; const KeyEvent: TKeyEvent; const AKey: Word = vkReturn);
    procedure UpdateWebcam(AEdit: TEdit; AImage: TImage; ALayout: TLayout; var Captured: TVideoCameraState);
    procedure UpdateButton(AButton: TSpeedButton; AEdit: TEdit; var Captured: TVideoCameraState);
    procedure UpdateSaveButton();
    procedure UpdateVideoCamera();
    procedure SavePictureToFile(const Filename: TFileName; AImage: TImage; var Captured: TVideoCameraState);
    procedure FixLabelsAutosize();
  public
    { Déclarations publiques }
  end;

function CheckFilename(const AFilename: TFileName): Boolean;
function PromptForFilename(out AFilename: TFileName): Boolean;

const
  CFilterExtensionDelimiter = ';';

resourcestring
  SFilterDescription = 'Fichiers JPEG';
  SFilterExtension = '*.jpg;*.jpeg';
  SWebcamCapturing = 'Prendre le cliché';
  SWebcamStopped = 'Annuler le cliché';
  SFilenameFormat = '%s%s%s.jpg'; { <path><id><recto|verso>.jpg }
  SFilenameRecto = '_CNI1';
  SFilenameVerso = '_CNI2';

var
  Frm_Main: TFrm_Main;

implementation

uses
  ModalDialogForm;

{$R *.fmx}

function CheckFilename(const AFilename: TFileName): Boolean;
var
  StringList: TStringList;
  i         : Integer;
begin
  Result := FileExists(Trim(AFilename));

  if not Result then
    Exit(Result);

  StringList := TStringList.Create();
  try
    StringList.StrictDelimiter := True;
    StringList.Delimiter       := CFilterExtensionDelimiter;
    StringList.DelimitedText   := SFilterExtension;

    for i := 0 to StringList.Count - 1 do
    begin
      if SameText(ExtractFileExt(Trim(AFilename)), StringList[i]) then
        Exit(True);
    end;
  finally
    StringList.DisposeOf();
  end;
end;

function PromptForFilename(out AFilename: TFileName): Boolean;
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter  := Concat(SFilterDescription, '|', SFilterExtension);
    OpenDialog.Options := [TOpenOption.ofReadOnly, TOpenOption.ofHideReadOnly, TOpenOption.ofPathMustExist, TOpenOption.ofFileMustExist, TOpenOption.ofEnableSizing, TOpenOption.ofDontAddToRecent];
    Result             := OpenDialog.Execute;
    if Result then
      AFilename := OpenDialog.Filename;
  finally
    OpenDialog.DisposeOf();
  end;
end;

procedure TFrm_Main.EditSetTextAndKeyUp(const Filename: TFileName; const AEdit: TEdit; const KeyEvent: TKeyEvent; const AKey: Word);
var
  Key    : Word;
  KeyChar: Char;
begin
  AEdit.BeginUpdate();

  try
    if AEdit.Text.CompareTo(Filename) <> 0 then
      AEdit.Text := Filename;

    Key := AKey;
    KeyEvent(nil, Key, KeyChar, []);
  finally
    AEdit.EndUpdate();
  end;
end;

procedure TFrm_Main.Edt_Filename1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    // Si le filename est valide => Chargement
    if CheckFilename(Edt_Filename1.Text) then
    begin
      UpdateWebcam(Edt_Filename1, Img_Webcam1, Lay_WebcamError1, Captured1);
      UpdateButton(SBtn_Capture1, Edt_Filename1, Captured1);
      UpdateSaveButton();
      CouldSave1 := Captured1 <> TVideoCameraState.vcsUncaptured;
    end;
  end;
end;

procedure TFrm_Main.Edt_Filename2KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    // Si le filename est valide => Chargement
    if CheckFilename(Edt_Filename2.Text) then
    begin
      UpdateWebcam(Edt_Filename2, Img_Webcam2, Lay_WebcamError2, Captured2);
      UpdateButton(SBtn_Capture2, Edt_Filename2, Captured2);
      UpdateSaveButton();
      CouldSave2 := Captured2 <> TVideoCameraState.vcsUncaptured;
    end;
  end;
end;

procedure TFrm_Main.Edt_UserIdKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    // Chargement des images si existantes...
    LoadPicturesIfExists()
  else
    // Mise à jour des boutons...
    UpdateSaveButton();
end;

procedure TFrm_Main.EEBtn_Filename1Click(Sender: TObject);
var
  Filename: TFileName;
begin
  // Si l'utilisateur choisi un fichier => update du filename => Chargement (cf: "TFrm_Main.Edt_Filename1Change" )
  if PromptForFilename(Filename) then
    EditSetTextAndKeyUp(Filename, Edt_Filename1, Edt_Filename1KeyDown);
end;

procedure TFrm_Main.EEBtn_Filename2Click(Sender: TObject);
var
  Filename: TFileName;
begin
  // Si l'utilisateur choisi un fichier => update du filename => Chargement (cf: "TFrm_Main.Edt_Filename1Change" )
  if PromptForFilename(Filename) then
    EditSetTextAndKeyUp(Filename, Edt_Filename2, Edt_Filename2KeyDown);
end;

procedure TFrm_Main.FixLabelsAutosize();
const
  cGlitchAutoSizeWidth = 8;

  procedure Fix(ALabel: TLabel; const AWidth: Single = cGlitchAutoSizeWidth);
  begin
    ALabel.WordWrap              := False;
    ALabel.TextSettings.Trimming := TTextTrimming.None;
    ALabel.AutoSize              := True;
    ALabel.AutoSize              := False;
    ALabel.Width                 := ALabel.Width + AWidth;
  end;

begin
  Fix(Lab_AppCaption);
  Fix(Lab_UserId);
  Fix(Lab_DocumentCaption1);
  Fix(Lab_DocumentCaption2);
  Fix(Lab_WebcamError1);
  Fix(Lab_WebcamError2);
  Fix(Lab_Filename1);
  Fix(Lab_Filename2);
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  DialogForm: TFrm_ModalDialog;
begin
  if not(CouldSave1 or CouldSave2) then
    Exit;

  DialogForm := TFrm_ModalDialog.Create(nil);
  try
    DialogForm.FormStyle := FormStyle;
    CanClose             := DialogForm.ShowModal = mrOk;
  finally
    DialogForm.DisposeOf();
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  // Mise à jour de l'interface utilisateur
  Caption             := Format(' %s (%s) ', ['Utilitaire de capture', GetAppVersionStrFull]);
  Lab_AppCaption.Text := Caption;
  // Constraints (entropy)
  MinWidth  := 640;
  MinHeight := 480;

  Captured1                := TVideoCameraState.vcsUncaptured;
  Captured2                := TVideoCameraState.vcsUncaptured;
  VideoCamera              := TCaptureDeviceManager.Current.DefaultVideoCaptureDevice;
  Lay_WebcamError1.Visible := not Assigned(VideoCamera);
  Lay_WebcamError2.Visible := not Assigned(VideoCamera);
  SBtn_Capture1.Enabled    := Assigned(VideoCamera);
  SBtn_Capture2.Enabled    := Assigned(VideoCamera);

  if Assigned(VideoCamera) then
    VideoCamera.OnSampleBufferReady := SampleBufferReady;

  // Chargement des parametres (dossier|id)
  LoadParams();

  // default
  CouldSave1 := False;
  CouldSave2 := False;
  UpdateVideoCamera();

  if not IsThemeActive() then
  begin
    FormStyle := TFormStyle.StayOnTop;
    FixLabelsAutosize();
  end;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  // Arret de la capture...
  if Assigned(VideoCamera) then
    VideoCamera.StopCapture();
end;

procedure TFrm_Main.Lay_AppBarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  // Populate
  DoMouseDown(Button, Shift, X, Y);
end;

procedure TFrm_Main.LoadParams();
var
  sCmdLineValue: string;
  iCmdLineValue: Integer;
begin
  // Défault
  Directory := ExtractFilePath(ParamStr(0));

  if FindCmdLineSwitch('d', sCmdLineValue) then
    Directory := IncludeTrailingBackslash(sCmdLineValue);

  if FindCmdLineSwitch('id', sCmdLineValue) then
    Edt_UserId.Text := sCmdLineValue;

  // Le champ ID passe en lecture seule s'il est fourni en paramètre...
  Edt_UserId.ReadOnly := Edt_UserId.Text <> Edt_UserId.Text.Empty;

  // Chargement des images associés à cet ID si existantes...
  LoadPicturesIfExists();
end;

procedure TFrm_Main.LoadPicturesIfExists();
var
  Filename: TFileName;
  Key     : Word;
  KeyChar : Char;
begin
  Key := vkReturn;

  // Construction du filename du Recto...
  Filename := Format(SFilenameFormat, [Directory, Edt_UserId.Text, SFilenameRecto]);

  // Si le fichier existe => update du filename => Chargement (cf: "TFrm_Main.Edt_Filename1Change" )
  if FileExists(Filename) then
    EditSetTextAndKeyUp(Filename, Edt_Filename1, Edt_Filename1KeyDown);

  // Construction du filename du Verso...
  Filename := Format(SFilenameFormat, [Directory, Edt_UserId.Text, SFilenameVerso]);

  // Si le fichier existe => update du filename => Chargement (cf: "TFrm_Main.Edt_Filename2Change" )
  if FileExists(Filename) then
    EditSetTextAndKeyUp(Filename, Edt_Filename2, Edt_Filename2KeyDown);
end;

procedure TFrm_Main.SampleBufferReady(Sender: TObject; const ATime: TMediaTime);
begin
  if Captured1 = TVideoCameraState.vcsUncaptured then
  begin
    TThread.Synchronize(TThread.CurrentThread,
        procedure
      begin
        VideoCamera.SampleBufferToBitmap(Img_Webcam1.Bitmap, True);
      end);
  end;

  if Captured2 = TVideoCameraState.vcsUncaptured then
  begin
    TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
        VideoCamera.SampleBufferToBitmap(Img_Webcam2.Bitmap, True);
      end);
  end;

  // TThread::Synchronize(TThread::CurrentThread, Form4->SampleBufferSync);
  // TBitmap *bm = new TBitmap(0, 0);
  // VideoCamera->SampleBufferToBitmap(bm, true);
  // delete bm;

  // Si le reco n'est pas capturé => Lecture du stream
  // if Captured1 = TVideoCameraState.vcsUncaptured then
  // VideoCamera.SampleBufferToBitmap( Img_Webcam1.Bitmap, True );
  // Si le verso n'est pas capturé => Lecture du stream
  // if Captured2 = TVideoCameraState.vcsUncaptured then
  // VideoCamera.SampleBufferToBitmap( Img_Webcam2.Bitmap, True );
end;

procedure TFrm_Main.SavePictureToFile(const Filename: TFileName; AImage: TImage; var Captured: TVideoCameraState);
begin
  // Si le document n'est ni "chargé" ni "capturé" => Fin
  if Captured = TVideoCameraState.vcsUncaptured then
    Exit;

  try
    ForceDirectories(ExtractFilePath(Filename));
    AImage.Bitmap.SaveToFile(Filename);
  except
  end;
end;

procedure TFrm_Main.SBtn_Capture1Click(Sender: TObject);
begin
  SBtn_Capture1.Enabled := False;
  try
    // Si la caméra n'a pas été trouvé ET  que le recto est dans un état lié => Fin
    if not Assigned(VideoCamera) and (Captured1 <> TVideoCameraState.vcsLoaded) then
      Exit;

    case Captured1 of
      vcsUncaptured:
        Captured1 := TVideoCameraState.vcsCaptured;
      vcsCaptured:
        Captured1 := TVideoCameraState.vcsUncaptured;
      vcsLoaded:
        UpdateWebcam(nil, Img_Webcam1, Lay_WebcamError1, Captured1);
    end;

    CouldSave1 := Captured1 <> TVideoCameraState.vcsUncaptured;
    UpdateButton(SBtn_Capture1, Edt_Filename1, Captured1);
    UpdateSaveButton();
  finally
    SBtn_Capture1.Enabled := True;
  end;
end;

procedure TFrm_Main.SBtn_Capture2Click(Sender: TObject);
begin
  SBtn_Capture2.Enabled := False;
  try
    // Si la caméra n'a pas été trouvé ET  que le recto est dans un état lié => Fin
    if not Assigned(VideoCamera) and (Captured2 <> TVideoCameraState.vcsLoaded) then
      Exit;

    case Captured2 of
      vcsUncaptured:
        Captured2 := TVideoCameraState.vcsCaptured;
      vcsCaptured:
        Captured2 := TVideoCameraState.vcsUncaptured;
      vcsLoaded:
        UpdateWebcam(nil, Img_Webcam2, Lay_WebcamError2, Captured2);
    end;

    CouldSave2 := Captured2 <> TVideoCameraState.vcsUncaptured;
    UpdateButton(SBtn_Capture2, Edt_Filename2, Captured2);
    UpdateSaveButton();
  finally
    SBtn_Capture2.Enabled := True;
  end;
end;

procedure TFrm_Main.SBtn_CloseClick(Sender: TObject);
begin
  SBtn_Close.Enabled := False;
  try
    // Lors de la demande de fermeture => Recto et Verso passent deviennent non-
    // capturés pour une fermeture silencieuse (cf: "TFrm_Main.FormCloseQuery")
    // Captured1 := TVideoCameraState.vcsUncaptured;
    // Captured2 := TVideoCameraState.vcsUncaptured;
    Close();
  finally
    SBtn_Close.Enabled := True;
  end;
end;

procedure TFrm_Main.SBtn_OkClick(Sender: TObject);
begin
  SBtn_Ok.Enabled := False;
  try
    // Lors de la validation => Enregistrement des documents "capturés" et/ou "chargés"...
    SavePictureToFile(
      Format(SFilenameFormat, [Directory, Edt_UserId.Text, SFilenameRecto]),
      Img_Webcam1,
      Captured1);
    CouldSave1 := False;

    SavePictureToFile(
      Format(SFilenameFormat, [Directory, Edt_UserId.Text, SFilenameVerso]),
      Img_Webcam2,
      Captured2);
    CouldSave2 := False;

    // ..Puis fermeture du programme
    SBtn_CloseClick(nil);
  finally
    SBtn_Ok.Enabled := True;
  end;
end;

procedure TFrm_Main.Tim_WebcamTimer(Sender: TObject);
begin
  UpdateVideoCamera();
end;

procedure TFrm_Main.UpdateButton(AButton: TSpeedButton; AEdit: TEdit; var Captured: TVideoCameraState);
begin
  // Update du bouton et du champ texte associé pour le filename...
  AButton.Enabled := Assigned(VideoCamera) or (Captured = TVideoCameraState.vcsLoaded);
  case Captured of
    vcsUncaptured:
      AButton.Text := SWebcamCapturing;
    vcsCaptured, vcsLoaded:
      begin
        AButton.Text := SWebcamStopped;
        // AEdit.Text := AEdit.Text.Empty;
      end;
  end;
end;

procedure TFrm_Main.UpdateSaveButton();
begin
  SBtn_Ok.Enabled := (Edt_UserId.Text <> Edt_UserId.Text.Empty) and ((Captured1 <> TVideoCameraState.vcsUncaptured) or (Captured2 <> TVideoCameraState.vcsUncaptured));
  UpdateVideoCamera();
end;

procedure TFrm_Main.UpdateVideoCamera();
begin
  Tim_Webcam.Enabled := False;
  try
    if not Assigned(VideoCamera) then
      Exit;

    if ((Captured1 = TVideoCameraState.vcsUncaptured) or (Captured2 = TVideoCameraState.vcsUncaptured)) and (VideoCamera.State <> TCaptureDeviceState.Capturing) then
      VideoCamera.StartCapture();

    if (Captured1 <> TVideoCameraState.vcsUncaptured) and (Captured2 <> TVideoCameraState.vcsUncaptured) and (VideoCamera.State <> TCaptureDeviceState.Stopped) then
      VideoCamera.StopCapture();
  finally
    Tim_Webcam.Enabled := True;
  end;
end;

procedure TFrm_Main.UpdateWebcam(AEdit: TEdit; AImage: TImage; ALayout: TLayout; var Captured: TVideoCameraState);
begin
  if not Assigned(AEdit) then
  begin
    AImage.MultiResBitmap[0].Clear;
    Captured := TVideoCameraState.vcsUncaptured;
  end
  else
  begin
    try
      AImage.Bitmap.LoadFromFile(AEdit.Text.Trim);
      Captured := TVideoCameraState.vcsLoaded;
    except
      Captured := TVideoCameraState.vcsUncaptured;
    end;
  end;

  ALayout.Visible := not Assigned(VideoCamera) and (Captured = TVideoCameraState.vcsUncaptured);
end;

end.
