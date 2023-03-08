unit Unit_zip;

interface

uses
   MapFiles,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   ExtCtrls, ZipMstr, ComCtrls, StdCtrls;

type
   TForm1 = class(TForm)
      Zip: TZipMaster;
      Timer: TTimer;
    Pan_Top: TPanel;
    Lab_Etat: TLabel;
    PB: TProgressBar;
    Memo1: TMemo;
      procedure TimerTimer(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure ZipTotalProgress(Sender: TObject; TotalSize: Int64;
         PerCent: Integer);
      procedure AddToMemo(sText : String);
   private
     FFILELOG : String;
    { Déclarations privées }
   public
    { Déclarations publiques }
      FileMap: TTextMap;
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.TimerTimer(Sender: TObject);
var
   S: string;
begin
   timer.Enabled := false;
   FileMap := TTextMap.create('');
   FileMap.MapName := 'LIST_ZIP';
   FileMap.Active := true;
   FileMap.Seek(soFromBeginning, 0);
   repeat
      if FileMap.Position = FileMap.Size then
         BREAK;
      try
         S := FileMap.ReadLine;
      except
         S := '';
      end;
      if (S <> 'FINI') and (S <> '') then
      begin
         if FileExists(S) then
         begin
           while FileIsReadOnly(S) do
           begin
             Lab_Etat.Caption := '';
             Sleep(1000);
             Lab_Etat.Caption := 'Fichier occupé : ' + S;
             Application.ProcessMessages;
           end;
          Try
            Lab_Etat.Caption := S; Lab_Etat.Update;
            deletefile(ChangeFileExt(S, '.Zip'));
            Zip.ZipFileName := ChangeFileExt(S, '.Zip');
            Zip.FSpecArgs.Clear;
            Zip.FSpecArgs.Add(S);
            Zip.add;
            if not DeleteFile(S) then
              AddToMemo('Echec de la suppression de la base : ' + S);
          Except on E:Exception do
            AddToMemo(E.Message);
          End;
         end;
      end
   until S = '';
   FileMap.free;
   Close;
end;

procedure TForm1.AddToMemo(sText: String);
var
  FFile : TextFile;
  sLigne : String;
begin
  sLigne := FormatDateTime('[DD/MM/YYYY hh:mm:ss] -> ',Now) + sText;

  while Memo1.Lines.Count > 500 do
    Memo1.Lines.Delete(0);
  Memo1.Lines.Add(sLigne);

  Try
    AssignFile(FFile, FFILELOG);
    try
      if FileExists(FFILELOG) then
       Append(FFile)
      else
        Rewrite(FFile);
      Writeln(FFile,sLigne);
    finally
      CloseFile(FFile);
    end;
  Except
  End;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // gestion du fichier de log
  FFILELOG := ChangeFileExt(Application.ExeName,'.log');

  timer.Enabled := true;
end;

procedure TForm1.ZipTotalProgress(Sender: TObject; TotalSize: Int64;
   PerCent: Integer);
begin
   pb.Position := PerCent;
   Application.processMessages;
end;

end.

