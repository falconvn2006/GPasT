unit Traject_level;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, ComCtrls, sListView;

type
  TTraject_levelForm = class(TForm)
    sBitBtn2: TsBitBtn;
    sBitBtn1: TsBitBtn;
    sListView1: TsListView;
    sBitBtn5: TsBitBtn;
    procedure FormShow(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sListView1DblClick(Sender: TObject);
    procedure sBitBtn5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Traject_levelForm: TTraject_levelForm;

implementation

uses MyDB, SelectLesson,IndependentWork, MainMenu, QuestionType;

{$R *.dfm}

procedure TTraject_levelForm.FormShow(Sender: TObject);
begin
  if sListView1.Items.Count>0 then
    sListView1.SelectItem(0);
  if fMainMenu.work='Diag' then
    begin
      sBitBtn5.Visible:=false;
      sBitBtn5.Enabled:=false;
    end;
end;

procedure TTraject_levelForm.sBitBtn2Click(Sender: TObject);
begin
  if sListView1.Selected<>nil then
    begin
      hide;
      if fMainMenu.work='Class' then
        begin
          fdb.Zoya_level:=sListView1.Selected.Index;
          fSelectLesson := TfSelectLesson.Create(nil);
          try
            fSelectLesson.Traject;
            fSelectLesson.ShowModal;
          finally
            //FreeAndNil(fSelectLesson);
          end;
        end;
      if fMainMenu.work='Diag' then
        begin
          fdb.Zoya_level:=sListView1.Selected.Index;
          QuestionTypeForm.ShowModal;
        end;
      show;
    end
  else
    ShowMessage('Выберите уровень!');
end;

procedure TTraject_levelForm.sBitBtn5Click(Sender: TObject);
begin
if sListView1.Selected<>nil then
    begin
      fMainMenu.Work:='Class';
      fdb.Zoya_level:=sListView1.Selected.Index;
      fSelectLesson := TfSelectLesson.Create(nil);
      try
        fSelectLesson.Traject;
        fSelectLesson.sBitBtn5Click(Sender);      
      finally
        //FreeAndNil(fSelectLesson);
      end;
    end
  else
    ShowMessage('Выберите уровень!');
end;

procedure TTraject_levelForm.sListView1DblClick(Sender: TObject);
begin
  sBitBtn2Click(Sender);
end;

end.
