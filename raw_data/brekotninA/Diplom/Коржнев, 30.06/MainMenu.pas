unit MainMenu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sGroupBox, ExtCtrls, Buttons, sBitBtn, ComCtrls,
  sStatusBar, IniFiles, sDialogs, sMemo, Menus, sCalculator, acPNG, Math;

type
  TfMainMenu = class(TForm)
    sBitBtn2: TsBitBtn;
    sBitBtn3: TsBitBtn;
    sBitBtn4: TsBitBtn;
    sBitBtn5: TsBitBtn;
    sStatusBar1: TsStatusBar;
    sOpenDialog1: TsOpenDialog;
    sBitBtn6: TsBitBtn;
    sBitBtn1: TsBitBtn;
    sBitBtn7: TsBitBtn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    N2: TMenuItem;
    sBitBtn8: TsBitBtn;
    Image1: TImage;
    sBitBtn9: TsBitBtn;
    Label1: TLabel;
    J1: TMenuItem;
    procedure sBitBtn5Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure sBitBtn7Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sBitBtn8Click(Sender: TObject);
    procedure sBitBtn9Click(Sender: TObject);
    procedure PopupMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
      Height: Integer);
    procedure PopupDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure J1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    userId:Integer;
    userOld:Integer;
    userName:String;
    userPassword:String;
    userClass:String;
    userFirstName:String;
    work:String;
    flag:Boolean;
    DevReport:Boolean;
    BgColor, FontColor, FontSize, CountQuest, Mode : Integer;
    FontStyle, Theme : String;
  end;

var
  fMainMenu: TfMainMenu;
  fFromWhere: Integer;
implementation

uses IndependentWork, Choose, OptionUser, Entry,SelectLesson,
  QuestionType,MyDB, ClassReports, Traject_level, Misc, Dictionary, Theory,
  Unit1;

{$R *.dfm}



procedure TfMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fEntry.Visible := True;
  fMainMenu.userId:=0;
end;

procedure TfMainMenu.FormShow(Sender: TObject);
begin
  fEntry.Visible := False;
  fOptionUser.LoadSettings;
  
end;

procedure TfMainMenu.sBitBtn1Click(Sender: TObject);
begin
  Work:='Class';
  if Traject_levelForm=nil then
    Traject_levelForm := TTraject_levelForm.Create(nil);
  try
    Traject_levelForm.ShowModal;
  finally
    FreeAndNil(Traject_levelForm);
  end;
end;

procedure TfMainMenu.sBitBtn2Click(Sender: TObject);
begin
  Work:='Ind';
  QuestionTypeForm.ShowModal;
end;

procedure TfMainMenu.sBitBtn3Click(Sender: TObject);
var
  cp,sp:tpoint;
begin
  cp.X:=sBitBtn3.Left;
  cp.Y:=sBitBtn3.Top;//+sBitBtn3.Height;
  sp:=clienttoscreen(cp);
  PopupMenu1.Popup(sp.X,sp.Y);
end;

procedure TfMainMenu.sBitBtn4Click(Sender: TObject);
begin
  fOptionUser.ShowModal;
end;

procedure TfMainMenu.sBitBtn5Click(Sender: TObject);
begin
  Close;
end;

procedure TfMainMenu.sBitBtn7Click(Sender: TObject);
begin
  Work:='Diag';
  if Traject_levelForm=nil then
    Traject_levelForm := TTraject_levelForm.Create(nil);
  try
    Traject_levelForm.ShowModal;
  finally
    FreeAndNil(Traject_levelForm);
  end;
end;

procedure TfMainMenu.N1Click(Sender: TObject);
begin
  DevReport:=false;
  ClassReportsForm := TClassReportsForm.Create(nil);
  try
    ClassReportsForm.ShowModal();
  finally
    FreeAndNil(ClassReportsForm);
  end;
  Work:='ClassReport';

  {
  fSelectLesson := TfSelectLesson.Create(nil);
  try
    fSelectLesson.Traject;
    fSelectLesson.sBitBtn1.Caption:='Выбрать';
    fSelectLesson.ShowModal();
  finally
    FreeAndNil(fSelectLesson);
  end;  }
end;

procedure TfMainMenu.J1Click(Sender: TObject);
begin
  DevReport:=true;
   ClassReportsForm := TClassReportsForm.Create(nil);
  try
    ClassReportsForm.ShowModal();
  finally
    FreeAndNil(ClassReportsForm);
  end;
   Work:='DevReport';

end;

procedure TfMainMenu.N4Click(Sender: TObject);
begin
  Work:='IndReport';
  QuestionTypeForm.ShowModal;
end;

procedure TfMainMenu.N2Click(Sender: TObject);
begin
  Work:='DiagReport';
  QuestionTypeForm.ShowModal;
end;

procedure TfMainMenu.FormCreate(Sender: TObject);
begin
  Caption:=GetBaseCaption;
end;

procedure TfMainMenu.sBitBtn8Click(Sender: TObject);
begin
  MentalAbilitiesDevelopment.ShowModal;
 //fDictionary.ShowModal;

             //Work:='Ind';
  //fFromWhere:=1;
             //QuestionTypeForm.ShowModal;
  {
  Work:='Class';
  if Traject_levelForm=nil then
    Traject_levelForm := TTraject_levelForm.Create(nil);
  try
    Traject_levelForm.ShowModal;
  finally
    FreeAndNil(Traject_levelForm);
  end;       }
end;

procedure TfMainMenu.sBitBtn9Click(Sender: TObject);
begin
  fDictionary.ShowModal;
end;

procedure TfMainMenu.PopupMeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin
   ACanvas.Font.Size := 14;
   ACanvas.Font.Style := [fsbold];
   Height := ACanvas.TextHeight('.') + 10;
   Width := sBitBtn3.Width * 4 div 3;
end;

procedure TfMainMenu.PopupDrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
   item : TMenuItem;
begin
   item := Sender as TMenuItem;
   ACanvas.Font.Size := 14;
   ACanvas.Font.Style := [fsbold];
 
   ACanvas.Font.Color := IfThen(Selected, clHighlightText, clMenuText);
   ACanvas.Brush.Color := IfThen(Selected, clHighlight, clMenu);
   ACanvas.FillRect(ARect);
 
   DrawText(ACanvas.Handle, PChar(item.Caption), Length(item.Caption),
      ARect, DT_LEFT);
end;



end.
