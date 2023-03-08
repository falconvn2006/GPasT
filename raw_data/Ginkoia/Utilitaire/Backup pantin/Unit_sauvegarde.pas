unit Unit_sauvegarde;

interface

uses
   MapFiles,
   rxFileutil,
   Xml_Unit,
   IcXMLParser,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
   TFrm_Sauvegarde = class(TForm)
    Timer: TTimer;
    Pan_Top: TPanel;
    Lab_etat1: TLabel;
    Lab_etat2: TLabel;
    BitBtn1: TBitBtn;
    pb: TProgressBar;
    Memo1: TMemo;
    pbCopy: TProgressBar;
      procedure BitBtn1Click(Sender: TObject);
      procedure FormCreate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
   private
     FFILELOG : String;
      FileMap: TTextMap;
      first: boolean;
      procedure recup(machine: string);
      procedure AddToMemo(sText : String);

    { Déclarations privées }
   public
    { Déclarations publiques }
   end;

var
   Frm_Sauvegarde: TFrm_Sauvegarde;

implementation

{$R *.DFM}

function CopyCallBack(
  TotalFileSize: LARGE_INTEGER;          // Taille totale du fichier en octets
  TotalBytesTransferred: LARGE_INTEGER;  // Nombre d'octets déjàs transférés
  StreamSize: LARGE_INTEGER;             // Taille totale du flux en cours
  StreamBytesTransferred: LARGE_INTEGER; // Nombre d'octets déjà tranférés dans ce flus
  dwStreamNumber: DWord;                 // Numéro de flux actuel
  dwCallbackReason: DWord;               // Raison de l'appel de cette fonction
  hSourceFile: THandle;                  // handle du fichier source
  hDestinationFile: THandle;             // handle du fichier destination
  progressBar : TProgressBar
  ): DWord; far; stdcall;

begin
  // Calcul de la position en % :
  ProgressBar.position := TotalBytesTransferred.QuadPart * 100 Div TotalFileSize.QuadPart;
  // La fonction doit définir si la copie peut être continuée.
  Result := PROGRESS_CONTINUE;
  Application.ProcessMessages;
end;


procedure TFrm_Sauvegarde.recup(machine: string);
var
   f: tsearchrec;
   rep: string;
   Xml: TmonXML;
   passXML: TIcXMLElement;
   passXML2: TIcXMLElement;
   LaBase: string;
   NomClient: string;
   LaCentrale: string;
   nomfich: string;
   pass : integer;

   lpCancel: pointer;
   flag : integer;
begin
   AddToMemo('---------------------------------');
   AddToMemo('Machine : ' + machine);
   AddToMemo('---------------------------------');

   pass := 0;
   lab_etat1.caption := 'Importation pour la machine ' + machine;
   lab_etat1.Update;
   Xml := TmonXML.Create;
   rep := '\\' + machine + '\d$\EAI\';
   if findfirst(rep + '*.*', faanyfile, f) = 0 then
   begin
      repeat
         if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
         begin
            if FileExists(rep + f.name + '\DelosQPMAgent.Databases.xml') then
            begin
               AddToMemo('Traitement : ' + f.name);
               xml.LoadFromFile(rep + f.name + '\DelosQPMAgent.Databases.xml');
               passXML := Xml.find('/DataSources');
               pb.max := PassXML.GetNodeList.Length;
               pb.position := 0;
               passXML := Xml.find('/DataSources/DataSource');
               while (PassXML <> nil) do
               begin
                  pb.position := pb.position + 1;

                  NomClient := Xml.ValueTag(passXml, 'Name');
                  passXML2 := xml.FindTag(passxml, 'Params');
                  passXML2 := xml.FindTag(passxml2, 'Param');
                  while (passXML2 <> nil) and (Xml.ValueTag(passXML2, 'Name') <> 'SERVER NAME') do
                     passXML2 := passXML2.NextSibling;
                  if Xml.ValueTag(passXML2, 'Name') = 'SERVER NAME' then
                  begin
                     LaBase := Xml.ValueTag(passXML2, 'Value');
                     if (labase <> '') then
                     begin
                        LaCentrale := labase;
                        Delete(LaCentrale, 1, pos('\', LaCentrale));
                        Delete(LaCentrale, 1, pos('\', LaCentrale));
                        LaCentrale := Copy(LaCentrale, 1, pos('\', LaCentrale) - 1);
                        forcedirectories('d:\sauve\' + Machine + '\' + LaCentrale + '\' + NomClient + '\');
                        delete(labase, 1, pos('\', labase));
                        delete(labase, 1, pos('\', labase));
                        labase := rep + labase;
                        lab_etat2.caption := 'Copie de ' + f.name + ' - ' + NomClient;
                        lab_etat2.Update;
                        Application.processmessages;
                        nomfich := 'd:\sauve\' + Machine + '\' + LaCentrale + '\' + NomClient + '\GINKOIA.IB';
                        AddToMemo('Copie de : ' + labase);
                        AddToMemo('Vers : ' + nomfich);

                        lpCancel := nil;
                        Flag := 0;
                        if CopyfileEx(pchar(labase), pchar(nomfich),@CopyCallBack,pbCopy,lpCancel,flag) then
                        begin
                           AddToMemo('Copie Ok');
                           FileMap.WriteLine(nomfich);
                           if ((pass=1) and first) then
                           begin
                              AddToMemo('Lance Zipping');
                              first := false;
                              Winexec(Pchar(IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) + 'zipping.exe'), 0);
                           end;
                           inc(pass);
                        end
                        else
                          AddToMemo('Echec de la copie !!!');
                        Application.processmessages;
                        update;
                     end;
                  end;
                  PassXML := PassXML.NextSibling;
               end;
            end;
         end;
      until findnext(f) <> 0;
   end;
   findclose(f);
   xml.free;
end;

procedure TFrm_Sauvegarde.AddToMemo(sText: String);
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

procedure TFrm_Sauvegarde.BitBtn1Click(Sender: TObject);
begin
   first := true;
   FileMap := TTextMap.create('');
   FileMap.MapName := 'LIST_ZIP';
   FileMap.AutoGrow := true;
   FileMap.Active := true ;
   recup('GSA-LAME1');
   recup('GSA-LAME2');
   recup('GSA-LAME3');
   recup('GSA-LAME4');
   FileMap.WriteLine('FINI');
   FileMap.Free;
end;

procedure TFrm_Sauvegarde.FormCreate(Sender: TObject);
begin
  // gestion du fichier de log
  FFILELOG := ChangeFileExt(Application.ExeName,'.log');

  if FileExists(FFILELOG) then
    DeleteFile(FFILELOG);


  // Initialisation
   lab_etat1.caption := '';
   lab_etat2.caption := '';
   IF (paramcount>0) and (uppercase(paramstr(1))='AUTO') then
     timer.enabled := true ; 
end;

procedure TFrm_Sauvegarde.TimerTimer(Sender: TObject);
begin
  timer.enabled := false ;
  BitBtn1Click(nil) ;
  close ;
end;

end.

