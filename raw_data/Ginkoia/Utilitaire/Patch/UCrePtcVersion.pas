//$Log:
// 1    Utilitaires1.0         20/05/2005 11:22:25    pascal          
//$
//$NoKeywords$
//
unit UCrePtcVersion;

interface

uses
   UsaisiePtch,
   filectrl,
   Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
   Buttons, ExtCtrls, Db, dxmdaset, MemDataX;

type
   TCrePtcVersion = class(TForm)
      OKBtn: TButton;
      CancelBtn: TButton;
      Bevel1: TBevel;
      lb: TListBox;
      Label1: TLabel;
      DataX: TDataBaseX;
      Versions: TMemDataX;
      Versionsid: TIntegerField;
      Versionsversion: TStringField;
      Versionsnomversion: TStringField;
      VersionsPatch: TIntegerField;
   private
    { Private declarations }
   public
    { Public declarations }
      function execute: boolean;
   end;

var
   CrePtcVersion: TCrePtcVersion;

implementation

{$R *.DFM}

{ TOKRightDlg }

function TCrePtcVersion.execute: boolean;
var
   saisiePtch: TsaisiePtch;
   path: string;
begin
   versions.open;
   while not versions.eof do
   begin
      lb.items.AddObject(Versionsnomversion.AsString, pointer(Versionsid.AsInteger));
      Versions.next;
   end;
   lb.ItemIndex := 0;
   result := Showmodal = MrOk;
   if result then
   begin
      versions.trouve(Versionsid, inttostr(integer(lb.items.Objects[lb.ItemIndex])));
      application.CreateForm(TsaisiePtch, saisiePtch);
      try
         result := saisiePtch.Showmodal = MrOk;
         if result then
         begin
            path := IncludeTrailingBackslash(ExtractFilePath(application.exename));
            path := Path + 'patch\' + Versionsnomversion.AsString + '\';
            forcedirectories(path);
            Versions.edit ;
            VersionsPatch.AsInteger := VersionsPatch.AsInteger+1 ;
            Versions.Post ;
            saisiePtch.mem.Lines.SaveToFile(Path+'Script'+VersionsPatch.AsString+'.sql') ;
            Versions.Validation ;
         end;
      finally
         saisiePtch.release;
      end;
   end;
   versions.close ;
end;

end.

