unit Admin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, sGroupBox, ExtCtrls, sPanel,
  sDBNavigator, Grids, DBGrids, acDBGrid, Menus;

type
  TAdminForm = class(TForm)
    sBitBtn4: TsBitBtn;
    sBitBtn5: TsBitBtn;
    sBitBtn7: TsBitBtn;
    sBitBtn8: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sBitBtn3: TsBitBtn;
    sBitBtn6: TsBitBtn;
    sBitBtn9: TsBitBtn;
    sBitBtn11: TsBitBtn;
    sBitBtn12: TsBitBtn;
    sBitBtn1: TsBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    sBitBtn10: TsBitBtn;
    procedure sBitBtn5Click(Sender: TObject);
    procedure sBitBtn4Click(Sender: TObject);
    procedure sBitBtn7Click(Sender: TObject);
    procedure sBitBtn8Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure sBitBtn6Click(Sender: TObject);
    procedure sBitBtn9Click(Sender: TObject);
    procedure sBitBtn11Click(Sender: TObject);
    procedure sBitBtn12Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sBitBtn10Click(Sender: TObject);
    procedure sBitBtn13Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AdminForm: TAdminForm;

implementation

uses CompleXityEditor, TrajectEditor, LessonsEditor, QuestionEditor, MyDB,
  QuestionTypesEditor, MetodistEditor, EditStudents, ResultsUser, OptionUser,
  MainMenu, SelectLesson, TrajectChoose, ExportImport, Misc, RedTheory,
  DictionaryEdit;


{$R *.dfm}

procedure TAdminForm.sBitBtn5Click(Sender: TObject);
begin
  //Hide;
  try
    CompleXityEditorForm:= TCompleXityEditorForm.Create(nil);
    CompleXityEditorForm.ShowModal;
  finally
    FreeAndNil(CompleXityEditorForm);
  end;
  //Show;
end;

procedure TAdminForm.sBitBtn6Click(Sender: TObject);
begin
  //Hide;
  try
    fEditStudents := TfEditStudents.Create(nil);
    fEditStudents.ShowModal();
  finally
    FreeAndNil(fEditStudents);
  end;
  //Show;
end;

procedure TAdminForm.sBitBtn3Click(Sender: TObject);
begin
  //Hide;
  try
    TrajectChooseForm:= TTrajectChooseForm.Create(nil);
    TrajectChooseForm.ShowModal;
  finally
    FreeAndNil(TrajectChooseForm);
  end;
  //Show;
end;

procedure TAdminForm.sBitBtn4Click(Sender: TObject);
begin
  //Hide;
  try
    TrajectEditorForm:= TTrajectEditorForm.Create(nil);
    TrajectEditorForm.ShowModal;
  finally
    FreeAndNil(TrajectEditorForm);
  end;
  //Show;
end;

procedure TAdminForm.sBitBtn7Click(Sender: TObject);
begin
  //Hide;
  try
    LessonsEditorForm:= TLessonsEditorForm.Create(nil);
    LessonsEditorForm.ShowModal();
  finally
    FreeAndNil(LessonsEditorForm);
    end;
  //Show;   
end;

procedure TAdminForm.sBitBtn8Click(Sender: TObject);
begin
  //Hide;
  try
    QuestionEditorForm:= TQuestionEditorForm.Create(nil);
    QuestionEditorForm.ShowModal;
  finally
    FreeAndNil(QuestionEditorForm);
  end;
  //Show;
end;

procedure TAdminForm.sBitBtn9Click(Sender: TObject);
begin
  //Hide;
  try
    Form6 := TForm6.Create(nil);
    Form6.ShowModal;
  finally
    FreeAndNil(Form6);
  end;
  //Show;
end;

procedure TAdminForm.sBitBtn11Click(Sender: TObject);
var
  cp,sp:tpoint;
begin         
  cp.X:=sBitBtn11.Left;
  cp.Y:=sBitBtn11.Top+sBitBtn11.Height;
  sp:=clienttoscreen(cp);
  fmainmenu.PopupMenu1.Popup(sp.X,sp.Y);
end;

procedure TAdminForm.sBitBtn12Click(Sender: TObject);
begin
  //Hide;
  try
    ExportImportForm:=TExportImportForm.Create(nil);
    ExportImportForm.ShowModal;
  finally
    FreeAndNil(ExportImportForm);
  end;
  //Show;
end;

procedure TAdminForm.sBitBtn2Click(Sender: TObject);
begin
  //Hide;
  try
    QuestionTypesEditorForm:= TQuestionTypesEditorForm.Create(nil);
    QuestionTypesEditorForm.ShowModal;
  finally
    FreeAndNil(QuestionTypesEditorForm);
  end;
  //Show;
end;

procedure TAdminForm.FormCreate(Sender: TObject);
begin
  Caption:=GetBaseCaption + ' (Администрирование)';
end;

procedure TAdminForm.sBitBtn10Click(Sender: TObject);
begin
  fDictionaryEdit.ShowModal;
end;

procedure TAdminForm.sBitBtn13Click(Sender: TObject);
begin
  fDictionaryEdit.ShowModal;
end;

end.
