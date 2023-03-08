//$Log:
// 7    Utilitaires1.6         24/02/2014 16:07:24    Thierry Fleisch
//      Modification du logiciel pour g?rer les PATH et autre via fichier INI
// 6    Utilitaires1.5         14/10/2010 17:05:44    ginkodev        ne pas
//      traiter la base Test.ib et envoyer email ? adminginkoia.gmail.com
// 5    Utilitaires1.4         09/10/2006 10:24:52    pascal          modif
//      pour l'envois des mails
// 4    Utilitaires1.3         02/10/2006 16:19:09    Sandrine MEDEIROS Modif
//      du ftp + envoie d'email
// 3    Utilitaires1.2         24/10/2005 15:25:00    pascal          Ajout
//      d'un log
// 2    Utilitaires1.1         07/07/2005 11:10:27    pascal          Ajout
//      d'un enchainement sur l'executable pour NPD
// 1    Utilitaires1.0         27/04/2005 16:08:56    pascal          
//$
//$NoKeywords$
//

unit URecalcAgrPrin_Frm;

interface

uses
  XMLCursor,
  inifiles,
  StdXML_TLB,
  UTraiteTrigBase,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Psock, NMsmtp,URecalcAgrPrin_Types;
const
  MaxThread = 8;
type
  TForm1 = class(TForm)
    Button1: TButton;
    LB: TListBox;
    mmLogs: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
    tsl: tstringlist;
    tslnom: string;
  public
    { Déclarations publiques }
    BaseaTraiter: Tstringlist;
    Th: array[1..MaxThread] of TraiteTrigBase;
    mail: TstringList;
    procedure listedesbases;
    procedure terminate(sender: TObject);
    procedure Agit(sender: TObject);

    PROCEDURE AddToMemo( ALogs : String);
  end;

var
  Form1: TForm1;

implementation

uses UPost;

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  BaseaTraiter := Tstringlist.Create;
  LoadIni;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  BaseaTraiter.free;
end;

procedure TForm1.listedesbases;

  procedure traite(Version, fichier: string);
  var
    Document: IXMLCursor;
    PassXML: IXMLCursor;
    PassXML2: IXMLCursor;
    Base: string;
  begin
    Document := TXMLCursor.Create;
    AddToMemo('    § Chargement fichier : ' + base);
    Document.Load(Fichier);
    PassXML := Document.Select('DataSource');
    while not PassXML.eof do
    begin
      PassXML2 := PassXML.Select('Params');
      PassXML2 := PassXML2.Select('Param');
      base := '';
      while not PassXML2.eof do
      begin
        if PassXML2.GetValue('Name') = 'SERVER NAME' then
        begin
          base := PassXML2.GetValue('Value');
          BREAK;
        end;
        PassXML2.next;
      end;
      if pos(':', base) > 2 then
        base := copy(base, pos(':', base) + 1, 255);
      if ((base <> '') and (Pos('TEST.IB', UpperCase(base))=0)) then
      begin
        if fileexists(base) then
        begin
          AddToMemo('    § Base à traiter : ' + base);
          BaseaTraiter.Add(base);
        END;
      END;
      PassXML.next;
    end;
    PassXML2 := nil;
    PassXML := nil;
    Document := nil;
  end;

var
  f: tsearchrec;
begin
  AddToMemo('-> Liste des bases');
  AddToMemo('  - Chemin : ' + IniStruct.Path);
  AddToMemo('  - Fichier : ' + IniStruct.Fichier);
  BaseaTraiter.clear;
  if FindFirst(IniStruct.Path + '*.*', faanyfile, f) = 0 then
  begin
    repeat
      AddToMemo('  -> Fichier trouvée/Dir : ' + f.name);
      if (Copy(f.name, 1, 1) = 'V') and ((f.attr and faDirectory) = faDirectory) then
      begin
        AddToMemo('  -> Existe ? : ' + IniStruct.Path + f.name + '\' + IniStruct.Fichier);
        if FileExists(IniStruct.Path + f.name + '\' + IniStruct.Fichier) then
        begin
          AddToMemo('   * Traite : ' + f.name);
          Traite(f.name, IniStruct.Path + f.name + '\' + IniStruct.Fichier);
        end;
      end;
    until Findnext(f) <> 0;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
  fini: boolean;
  S: string;
  LaMachine: string;
  pass: array[0..255] of char;
  size: dword;
begin
  size := 250;
  getcomputername(pass, size);
  lamachine := string(pass);
  tsl := tstringlist.create;
  tslnom := changefileext(application.exename, '.txt');
  try
    mail := TStringList.Create;
    mail.add('SERVEUR : ' + lamachine);
    mail.add('Debut du traitement : ' + DateTimeToStr(Now));
    mail.add(' ');

    lb.items.clear;
    for i := 1 to MaxThread do
    begin
      Th[i] := nil;
      lb.items.Add('');
    end;
    listedesbases;
    while BaseaTraiter.Count > 0 do
    begin
      for i := 1 to MaxThread do
      begin
        if (BaseaTraiter.Count > 0) and (th[i] = nil) then
        begin
          tsl.add(BaseaTraiter[0]);
          tsl.savetofile(tslnom);
          Th[i] := TraiteTrigBase.create(BaseaTraiter[0]);
          lb.items[i - 1] := Th[i].LaBase;
          th[i].OnTerminate := terminate;
          th[i].onagit := Agit;
          th[i].Resume;
          BaseaTraiter.delete(0);
        end;
      end;
      for i := 1 to 20 do
      begin
        Application.processmessages;
        sleep(25);
      end;
    end;
    repeat
      fini := true;
      for i := 1 to MaxThread do
      begin
        if th[i] <> nil then
        begin
          fini := false;
        end
      end;
      if not fini then
      begin
        for i := 1 to 20 do
        begin
          Application.processmessages;
          sleep(25);
        end;
      end;
    until fini;
    try
      s := IniStruct.ExportExe; // 'D:\ExportNpd\ExportNpd.exe';
      if FileExists(s) then
        Winexec(pchar(s), 0);
    except
    end;
  except
    mail.add('Erreur de traitement');
  end;
  mail.add('');
  mail.add('Fin du traitement : ' + DateTimeToStr(Now));
  sendmail(IniStruct.From, IniStruct.SendTo,
    lamachine + ' Calcul differe des triggers',
    mail.text);
  mail.free;
  Screen.cursor := CrDefault;
  tsl.free;
end;

procedure TForm1.terminate(sender: TObject);
var
  i: integer;
begin
  // gestion des erreur ;
  for i := 1 to MaxThread do
  begin
    if th[i] = sender then
    begin
      tsl.add(th[i].LaBase + ' ok');
      tsl.savetofile(tslnom);
      if th[i].erreur then
        mail.add(' - ***' + th[i].Lemessage + '***  -   ' + Inttostr(th[i].NbPacket) + ' Paquet(s)  -   ' + Datetimetostr(th[i].Debut) + ' - ' + DateTimeToStr(Now))
      else
        mail.add(th[i].LaBase + ' - OK - ' + Inttostr(th[i].NbPacket) + ' Paquet(s)  -   ' + Datetimetostr(th[i].Debut) + ' - ' + DateTimeToStr(Now));
      lb.items[i - 1] := '';
      th[i] := nil;
      BREAK;
    end
  end;
end;

procedure TForm1.Agit(sender: TObject);
var
  i: integer;
begin
  for i := 1 to MaxThread do
    if th[i] = sender then
    begin
      lb.items[i - 1] := Th[i].LaBase + '  ' + Inttostr(Th[i].PacketTraite) + '/' + Inttostr(Th[i].NbPacket);
      BREAK;
    end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if (paramcount > 0) and (uppercase(paramstr(1)) = 'GO') then
  begin
    Button1Click(nil);
    close;
  end;
end;

procedure TForm1.AddToMemo(ALogs: String);
begin
  mmLogs.Lines.Add(FormatDateTime('[DD/MM/YYYY hh:mm:ss] ',Now) + ALogs);
end;

end.

