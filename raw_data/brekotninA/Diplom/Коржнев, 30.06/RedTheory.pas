unit RedTheory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, sMemo, ComCtrls, sTreeView, sLabel, ADODB, DB;

type
  TfTheoryEdit = class(TForm)
    sLabel_theme: TsLabel;
    sLabel_theory: TsLabel;
    sTreeView_Theme: TsTreeView;
    sMemo_Theory: TsMemo;
    sButton_exit: TsButton;
    sButton_add_theory: TsButton;
    procedure sButton_exitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sTreeView_ThemeClick(Sender: TObject);
    procedure sButton_add_theoryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fTheoryEdit: TfTheoryEdit;
  function return_priz( _id:String ):boolean;
  function return_parent(_id:String):TTreeNode;
  function return_description(_id:String):STring;

implementation

uses MyDB;

{$R *.dfm}

procedure TfTheoryEdit.sButton_exitClick(Sender: TObject);
begin
  Close;
end;

function return_priz( _id:String ):boolean;
begin
  with fDB.ADOQueryGrammar2 do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT parent FROM theme WHERE id=:idd';
    Parameters.ParamByName('idd').Value:=_id;
    Open;
    if(Fields[0].AsString = '0')then
      Result:=true else Result:=False;
  end;
end;

function return_parent(_id:String):TTreeNode;
var
  i:Integer;
  tmp_id:String;
begin

  Result:=nil;
  with fDB.ADOQueryGrammar2 do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT id FROM theme WHERE id=:idd';
    Parameters.ParamByName('idd').Value:=_id;
    Open;
    tmp_id:=Fields[0].AsString;
    for i:=0 to fTheoryEdit.sTreeView_Theme.Items.Count-1 do
    begin
      if(tmp_id = fTheoryEdit.sTreeView_Theme.Items[i].Text)then
      begin
        Result := fTheoryEdit.sTreeView_Theme.Items[i];
        Break;
      end;
    end;

  end;
end;

function return_description(_id:String):STring;
begin
  with fDB.ADOQueryGrammar do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT * FROM theme WHERE id=:idd';
    Parameters.ParamByName('idd').Value:=_id;
    Open;
    Result:=Fields[1].AsString;
  end;
end;

procedure TfTheoryEdit.FormShow(Sender: TObject);
var
  r,d:TTreeNode;
  s1,s2:String;
  i:Integer;
begin
  i := 0;
  with fDB.ADOQueryGrammar do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT id FROM Theme WHERE parent=0';
    Open;
    First;
    While not(eof)do
    begin
      s1:=Fields[0].AsString;
      r:=sTreeView_Theme.Items.Add(nil,s1);
      r.StateIndex:=1;
      Next;
    end;
    Close;
    SQL.Clear;
    SQL.Text:='SELECT id, parent FROM theme WHERE parent in (SELECT id FROM theme);';
    Open;
    First;
    While not(eof)do
    begin
        s1:=Fields[0].AsString; s2:=Fields[1].AsString;
        for i := 0 to sTreeView_Theme.Items.Count-1 do
        begin
          if(sTreeView_Theme.Items.Item[i].StateIndex = 1)then
          begin
            if(s2 = sTreeView_Theme.Items.item[i].Text)then
            begin
              d:=sTreeView_Theme.Items.AddChild(sTreeView_Theme.Items.Item[i], s1);
              d.StateIndex:=2;
            end;
          end;
        end;
            if(return_priz(s2) = false)then
              sTreeView_Theme.Items.AddChild(return_parent(s2),s1);
      Next;
    end;
    for i := 0 to sTreeView_Theme.Items.Count-1 do
      sTreeView_Theme.Items[i].Text:=return_description(sTreeView_Theme.Items[i].Text);
  end;

end;

procedure TfTheoryEdit.sTreeView_ThemeClick(Sender: TObject);
var
  imp : String;
  s : string;
  nod :TTreeNode;
begin
  imp := '';
  nod := sTreeView_Theme.Selected;
  s := nod.Text  ;
  with fDB.ADOQueryGrammar2 do
    begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT theory FROM Theme WHERE name=:1';
    Parameters.ParamByName('1').Value := s;
    Open;
    First;
    imp := Fields[0].AsString;
    sMemo_Theory.Text := imp;
    end;
end;

procedure TfTheoryEdit.sButton_add_theoryClick(Sender: TObject);
var
  T,L : string;
  nod :TTreeNode;
begin
  nod := sTreeView_Theme.Selected;
  l := nod.Text  ;
  try
     If sMemo_Theory.Text <> '' then
       begin
        t := sMemo_Theory.Text;

        with   fDB.ADOCommandTheory do
          begin
            CommandText := 'UPDATE Theme SET Theory =:Theory WHERE Name = :Name  ';
            Parameters.ParamByName('Theory').Value := t;
            Parameters.ParamByName('Name').Value := l;
            Execute;
          end;
       ShowMessage('Изменения были сохранены');
       end;
   Except
      ShowMessage('Во время сохранения изменений произошла ошибка');
 end;
end;

end.
