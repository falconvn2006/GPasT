unit DictionaryEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sDialogs, MPlayer, ExtCtrls, sPanel, StdCtrls, sComboBox, sMemo,
  sButton, sEdit, sLabel, jpeg, ADODB, DB;

type
  TfDictionaryEdit = class(TForm)
    sLabelWord: TsLabel;
    sLabelValue: TsLabel;
    sImageWord: TImage;
    sEditWord: TsEdit;
    sButtonExit: TsButton;
    sButtonAddWord: TsButton;
    sMemoValue: TsMemo;
    sButtonImage: TsButton;
    sOpenDialogImage: TsOpenDialog;
    sLabel1: TsLabel;
    procedure sButtonExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sButtonImageClick(Sender: TObject);
    procedure sButtonAddWordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fDictionaryEdit: TfDictionaryEdit;
  ImageTrue : Integer;
  pics:Integer;

implementation

uses MyDB;

{$R *.dfm}

procedure TfDictionaryEdit.sButtonExitClick(Sender: TObject);
begin
Close;
end;

procedure TfDictionaryEdit.FormShow(Sender: TObject);
begin
 ImageTrue := 0;
end;

 
procedure TfDictionaryEdit.sButtonImageClick(Sender: TObject);
var
  JPG : TJPEGImage;
begin
   sImageWord.Visible := True;
 if (sOpenDialogImage.Execute)  then
   begin
    JPG := TJPEGImage.Create;
    JPG.LoadFromFile(sOpenDialogImage.FileName);
    sImageWord.Picture.Assign(JPG);
    JPG.Free;
    ImageTrue := 1;
   end;

  
end;


procedure TfDictionaryEdit.sButtonAddWordClick(Sender: TObject);
var
   PWord : string;
   PChangeWord : string;
   PNumberWord : string;
   PKind : string;
   Ptest : String;
   Blob:TMemoryStream;
begin
   PWord := '';
   PChangeWord := '';
   Ptest := '';

 try
 if (sEditWord.Text <> '') and (sMemoValue.Text <> '')then
   begin
       PWord := sEditWord.Text;
       PChangeWord := sMemoValue.Text;
       if sOpenDialogImage.FileName <> '' then
          begin
           Ptest := 's' ;
          end;

      with fDB.ADOCommandWord do
        begin
          Parameters.ParamByName('Word').Value := PWord;
          Parameters.ParamByName('ChangeWord').Value := PChangeWord;
          if Ptest <> '' then
          begin
          Parameters.ParamByName('test').LoadFromFile(sOpenDialogImage.FileName,ftBlob);
          end;
          Execute;
        end;

     ShowMessage('Определение успешно добавлено!');
     sEditWord.Clear;
     sMemoValue.Clear;
     end;
  Except
      ShowMessage('Ошибка! Определение не добавлено.');
 end;
end;

end.
