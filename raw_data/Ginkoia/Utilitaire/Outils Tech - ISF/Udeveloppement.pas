unit Udeveloppement;

interface

uses
   UInternet,
   SevenZip,
   UZip,
   UBase,
   UUtilMachine,
   UInstall,
   StrUtils,

   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls, VCLUnZip, VCLZip;

type
   TForm1 = class(TForm)
      PB: TProgressBar;
      LAB_ETAT: TLabel;
      Button1: TButton;
      Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    VCLZip1: TVCLZip;
    Btn_7Zip: TButton;
    OD_7Zip: TOpenDialog;
    Btn_Unzip: TButton;
    Btn_MultiFile: TButton;
      procedure Button1Click(Sender: TObject);
      procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Btn_7ZipClick(Sender: TObject);
    procedure Btn_UnzipClick(Sender: TObject);
    procedure Btn_MultiFileClick(Sender: TObject);
   private
    { Déclarations privées }
   public
    { Déclarations publiques }
      procedure OnInternetProgress(Sender: TObject; Actuel: Integer; Maximum: Integer);
      procedure OnZipProgress(Sender: TObject; Percent: Integer);
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Btn_7ZipClick(Sender: TObject);
Var
  FileSource    : String;   //Chemin du fichier à compressé
  FileDest      : String;   //Chemin du fichier compressé
begin
  //Choix du fichier à compressé
  If OD_7Zip.Execute then
    Begin
      //Création de l'archive
      FileSource  := OD_7Zip.FileName;
      FileDest    := IncludeTrailingPathDelimiter(ExtractFilePath(FileSource))+LeftStr(ExtractFileName(FileSource),Pos('.',ExtractFileName(FileSource)))+'zip';
      LoadSevenZipDLL;
      SevenZipCreateArchive(application.Handle,
                            ExtractFileName(FileDest),
                            ExtractFilePath(FileSource),
                            ExtractFileName(FileSource),
                            true,
                            9,
                            True,
                            False,
                            '',
                            True);
      UnloadSevenZipDLL;
    End
  else
    Exit;
end;

procedure TForm1.Btn_MultiFileClick(Sender: TObject);
Var
  FileList,rep  : String;           //Chemin du fichier à compressé
  FileDest      : String;           //Chemin du fichier compressé
  Tab_File      : Array of string;  //Tableau de la liste des fichiers
  I             : Integer;          //Variable de boucle
begin
  //Choix des fichiers
  SetLength(Tab_File,0);
  OD_7Zip.Title := 'Ajouter un fichier à l''archive.';
  Repeat
    If OD_7Zip.Execute then
      Begin
        Setlength(Tab_File,Length(Tab_File)+1);
        Tab_File[length(Tab_File)-1]  := OD_7Zip.FileName;
      End;
  Until MessageDlg('Voulez vous ajouter d''autres fichiers ?',mtConfirmation,[mbYes,mbNo],0)= mrNo;
  
  //Contrôle qu'il y a des fichiers à archiver
  if length(Tab_File)<=0 then exit;

  //Choix de l'archive
  OD_7Zip.Title := 'Nom de l''archive.';
  If OD_7Zip.Execute then
    Begin
      //Création de l'archive
      FileDest    := OD_7Zip.FileName;
      FileList    := '"'+Tab_File[0]+'"';
      for I := 1 to length(Tab_File) - 1 do
        Begin
          FileList  := FileList + ',"' + Tab_File[I]+'"';
        End;
      LoadSevenZipDLL;
      SevenZipCreateArchive(application.Handle,
                            ExtractFileName(FileDest),
                            ExtractFilePath(FileDest),
                            FileList,
                            true,
                            9,
                            True,
                            False,
                            '',
                            False);
      UnloadSevenZipDLL;
    End
  else
    Exit;
end;

procedure TForm1.Btn_UnzipClick(Sender: TObject);
Var
  FileSource    : String;   //Chemin du fichier à compressé
  FileDest      : String;   //Chemin du fichier compressé
begin
  //Choix du fichier à compressé
  If OD_7Zip.Execute then
    Begin
      //Création de l'archive
      FileSource  := OD_7Zip.FileName;
      FileDest    := IncludeTrailingPathDelimiter(ExtractFilePath(FileSource));
      FileDest    := 'C:\Ginkoia\';
      LoadSevenZipDLL;
      SevenZipExtractArchive(application.Handle,
                            FileSource,
                            '"*.*"',
                            True,
                            '',
                            true,
                            'C:\Ginkoia\',//FileDest,
                            true);
      UnloadSevenZipDLL;
    End
  else
    Exit;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   Internet: TInternet;
   s : String;
   Login,Password : String;   //Accès internet
begin
   Internet := TInternet.Create(self);
   Login      := InputBox('Accès base','Veuillez entrer le nom de la base :','');
   Password   := InputBox('Accès base','Veuillez entrer votre mot de passe :','');
   s := Internet.Connexion(Login,Password);
   if s<>'' then
   begin
      Enabled := false;
      try
         Internet.OnProgress := OnInternetProgress;
         Internet.Download(S);
      finally
         Enabled := true;
      end;
   end;
   Internet.Free;
end;

procedure TForm1.OnInternetProgress(Sender: TObject; Actuel,
   Maximum: Integer);
begin
   PB.Max := Maximum;
   Pb.Position := Actuel;
   Application.ProcessMessages;
end;

procedure TForm1.OnZipProgress(Sender: TObject; Percent: Integer);
begin
   Pb.Position := Percent;
   Application.ProcessMessages;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   Zip: TZip;
begin
   Zip := TZip.Create(self);
   Zip.OnProgress := OnZipProgress;
   Enabled := false;
   try
      Zip.Unzip('c:\tmp\SERVEUR_VANCIA-HG.zip', 'C:\Ginkoia\');
   finally
      Enabled := true;
   end;
   Zip.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
Var
  UtilMachine : TUtilMachine ;
begin
  UtilMachine := TUtilMachine.Create ;
//  UtilMachine.CreerRaccourcie ;
  UtilMachine.free ;
end;

procedure TForm1.Button4Click(Sender: TObject);
Var
  Install : TInstall ;
begin
  Install := TInstall.Create(Self) ;
  Install.free ;
end;

end.

