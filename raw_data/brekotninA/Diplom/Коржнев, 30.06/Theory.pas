unit Theory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, sTreeView, StdCtrls, sMemo, sButton, ADODB, DB;

type
  TfTheory = class(TForm)
    sButton_Exit: TsButton;
    sMemo_theory: TsMemo;
    sTreeView_Grammar: TsTreeView;
    procedure sButton_ExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sTreeView_GrammarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fTheory: TfTheory;
  function return_priz( _id:String ):boolean;
  function return_parent(_id:String):TTreeNode;
  function return_description(_id:String):STring;

implementation

uses MyDB;

{$R *.dfm}

procedure TfTheory.sButton_ExitClick(Sender: TObject);
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
    for i:=0 to fTheory.sTreeView_Grammar.Items.Count-1 do
    begin
      if(tmp_id = fTheory.sTreeView_Grammar.Items[i].Text)then
      begin
        Result := fTheory.sTreeView_Grammar.Items[i];
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

procedure TfTheory.FormShow(Sender: TObject);
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
      r:=sTreeView_Grammar.Items.Add(nil,s1);
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
        for i := 0 to sTreeView_Grammar.Items.Count-1 do
        begin
          if(sTreeView_Grammar.Items.Item[i].StateIndex = 1)then
          begin
            if(s2 = sTreeView_Grammar.Items.item[i].Text)then
            begin
              d:=sTreeView_Grammar.Items.AddChild(sTreeView_Grammar.Items.Item[i], s1);
              d.StateIndex:=2;
            end;
          end;
        end;
            if(return_priz(s2) = false)then
              sTreeView_Grammar.Items.AddChild(return_parent(s2),s1);
      Next;
    end;
    for i := 0 to sTreeView_Grammar.Items.Count-1 do
      sTreeView_Grammar.Items[i].Text:=return_description(sTreeView_Grammar.Items[i].Text);
  end;

end;

procedure TfTheory.sTreeView_GrammarClick(Sender: TObject);
var
  imp : String;
  s : string;
  nod :TTreeNode;
begin
  imp := '';
  nod := sTreeView_Grammar.Selected;
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
    sMemo_theory.Text := imp;
    end;
end;

end.
