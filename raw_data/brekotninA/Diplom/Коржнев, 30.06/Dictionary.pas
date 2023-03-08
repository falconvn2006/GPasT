unit Dictionary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, sPanel, StdCtrls, sEdit, sListBox, ComCtrls,
  sTreeView, sButton, sMemo, sLabel, jpeg, ADODB, DB;

type
  TfDictionary = class(TForm)
    sLabel_word: TsLabel;
    sLabel_change: TsLabel;
    sMemo_drscription: TsMemo;
    sButton_exit: TsButton;
    sTreeViewA: TsTreeView;
    sListBoxA: TsListBox;
    sEditWord: TsEdit;
    sImage_Word: TImage;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    procedure sButton_exitClick(Sender: TObject);
    procedure sTreeViewAClick(Sender: TObject);
    procedure sListBoxAClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDictionary: TfDictionary;

implementation

uses MyDB;

{$R *.dfm}

procedure TfDictionary.sButton_exitClick(Sender: TObject);
begin
Close;
end;

procedure TfDictionary.sTreeViewAClick(Sender: TObject);
var
  w : string;

begin
   With fDB.ADOQueryW do
    begin
     SQL.Clear;
     SQL.Text := 'SELECT Word FROM Words WHERE Word LIKE '+#39+sTreeViewA.Selected.Text+'%'+#39 + 'ORDER BY Word';
     ExecSQL;
    end;
   With fDB.ADOQueryW do
    begin
     sListBoxA.Items.Clear;
     Active := True;
     First;
     while not Eof do
       begin
        sListBoxA.Items.Add(Fields[0].AsString);
        Next;
       end;
     Active := False;  
    end;

end;

procedure TfDictionary.sListBoxAClick(Sender: TObject);
var
   Blob:TMemoryStream;
   jpg : TjpegImage;
begin
    sEditWord.Text := sListBoxA.Items.Strings[sListBoxA.itemIndex];
    jpg:=TJPEGImage.Create;
    with fDB.ADOQueryW do
      begin
       SQL.Clear;
       SQL.Text := 'SELECT ChangeWords FROM Words WHERE Word = '+#39+sListBoxA.Items.Strings[sListBoxA.itemIndex]+#39;
       ExecSQL;
       Active := True;
       First;
       sMemo_drscription.Text := Fields[0].AsString;
       Active := False;

       SQL.Clear;
       SQL.Text := 'SELECT PictureWord FROM Words WHERE Word = '+#39+sListBoxA.Items.Strings[sListBoxA.itemIndex]+#39;
       ExecSQL;
       Active := True;
       First;
       Blob:=TADOBlobStream.Create(TBlobField(FieldByName('PictureWord')),bmRead);
       jpg.LoadFromStream(Blob);
       sImage_word.Picture.Assign(jpg);
       Active := False;
       jpg.Free;
       Blob.Free;
      end;


end;



end.
