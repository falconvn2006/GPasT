unit UInstall;

interface

uses
   registry, UBase, UUtilMachine,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls;

type
  TInstall = class(TBaseGinkoia)
  protected
    FDisk: Char;
    FMachine: TUtilMachine;
    FMagasinSurServeur: string;
    FServeur: string;
    FDirGinkoia, FDirBase : String;
    procedure create_Machine;
    procedure free_Machine;
    function GetMachine: TUtilMachine;
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure CreerIconPoste;
    procedure CreerINIPoste(magasin, Poste: string);
    procedure CreerINIServeur(magasin, Poste: string);
    function GetMagasinSurServeur: Boolean;
    function GetNomPoste: string;
    procedure OuvreServeur;
    procedure Referencement(base: string);
    procedure SetPathBPL;
    property Disk: Char read FDisk write FDisk;
    property Machine: TUtilMachine read GetMachine;
    property MagasinSurServeur: string read FMagasinSurServeur write
        FMagasinSurServeur;
    property Serveur: string read FServeur write FServeur;

    property DirGinkoia : String read FDirGinkoia write FDirGinkoia;
    property DirBase  : String read FDirBase write FDirBase;
  end;


implementation

constructor TInstall.Create(Owner: TComponent);
begin
  inherited;
  fMachine := nil;
  fMagasinSurServeur := '';
  FServeur := 'SERVEUR';
  FDisk := 'C';
  FDirGinkoia := 'c:\ginkoia\';
  FDirBase := 'c:\ginkoia\data\';
end;

destructor TInstall.Destroy;
begin
  free_Machine;
  inherited;
end;

procedure TInstall.create_Machine;
begin
  if fmachine = nil then
     fMachine := TUtilMachine.create;
end;

procedure TInstall.CreerIconPoste;
begin
  machine.CreerRaccourcie('Ginkoia', '\\' + Serveur + '\' + FDirGinkoia + 'BATCH\GINKOIA.BAT', 'Programme Ginkoia', FDirGinkoia, FDirGinkoia + 'GINKOIA.EXE');
  machine.CreerRaccourcie('Caisse', '\\' + Serveur + '\' + FDirGinkoia + 'BATCH\CAISSEGINKOIA.BAT', 'Programme caisse de Ginkoia', FDirGinkoia, FDirGinkoia + 'CAISSEGINKOIA.EXE');
end;

procedure TInstall.CreerINIPoste(magasin, Poste: string);
var
  Tsl: TstringList;
  S: string;
  Base: string;
begin
  ForceDirectories('C:\GINKOIA');
  Tsl := TstringList.create;
  // transformation du chemin de la base
  s := serveur + ':' + FDirBase + 'TEST.IB'; //  disk + ':\GINKOIA\DATA\
  Base := serveur + ':' + FDirBase + 'GINKOIA.IB'; // disk + ':\GINKOIA\DATA\GINKOIA.IB'

  Tsl.add('[GENERAL]');
  Tsl.add('Tip_Main_ShowAtStartup=False');
  Tsl.add('[DATABASE]');
  Tsl.add('PATH0=' + Base);
  Tsl.add('PATH1=' + s);
  TSl.Add('[NOMMAGS]');
  TSl.Add('MAG0=' + magasin);
  TSl.Add('MAG1=MAGASIN1');
  TSl.Add('[NOMPOSTE]');
  Connexion(base);
  qry.sql.clear;
  qry.sql.Add('Select POS_NOM, MAG_ENSEIGNE ');
  qry.sql.Add('from genmagasin join k on (k_id=mag_id and k_enabled=1)');
  qry.sql.Add('     join GenPoste join k on (k_id=POS_id and k_enabled=1)');
  qry.sql.Add('     on (POS_MAGID=MAG_ID)');
  qry.sql.Add('where POS_ID<>0');
  qry.sql.Add('And   MAG_NOM=' + QuotedStr(magasin));
  qry.sql.Add('  and POS_NOM=' + QuotedStr(Poste));
  qry.Open;
  TSl.Add('POSTE0=' + qry.fields[0].AsString);
  TSl.Add('POSTE1=' + qry.fields[0].AsString);
  TSl.Add('[NOMBASES]');
  TSl.Add('ITEM0=' + qry.fields[1].AsString);
  qry.close;
  Ferme;
  TSl.Add('ITEM1=Base TEST');
  TSl.SaveToFile(FDirGinkoia +  'GINKOIA.INI');
  TSl.SaveToFile(FDirGinkoia + 'Caisseginkoia.ini');
  tsl.free;
end;

procedure TInstall.CreerINIServeur(magasin, Poste: string);
var
  Tsl: TstringList;
  S: string;
  base: string;
  ou: string;
begin
  Base := FDirBase + 'Ginkoia.Ib'; // disk + ':\GINKOIA\DATA\GINKOIA.IB';
  ou := FDirGinkoia; // disk + ':\GINKOIA\';
  ForceDirectories(ou);
  Tsl := TstringList.create;
  Tsl.add('[GENERAL]');
  Tsl.add('Tip_Main_ShowAtStartup=False');
  Tsl.add('[DATABASE]');
  Tsl.add('PATH0=' + Base);
  s := IncludeTrailingBackslash(ExtractFilePath(base)) + 'TEST.IB';
  Tsl.add('PATH1=' + s);
  TSl.Add('[NOMMAGS]');
  TSl.Add('MAG0=' + magasin);
  TSl.Add('MAG1=MAGASIN1');
  TSl.Add('[NOMPOSTE]');
  Connexion(base);
  qry.sql.clear;
  qry.sql.Add('Select POS_NOM, MAG_ENSEIGNE ');
  qry.sql.Add('from genmagasin join k on (k_id=mag_id and k_enabled=1)');
  qry.sql.Add('     join GenPoste join k on (k_id=POS_id and k_enabled=1)');
  qry.sql.Add('     on (POS_MAGID=MAG_ID)');
  qry.sql.Add('where POS_ID<>0');
  qry.sql.Add('And   MAG_NOM=' + QuotedStr(magasin));
  qry.sql.Add('  and POS_NOM='+ QuotedStr(poste));
  qry.Open;
  TSl.Add('POSTE0=' + poste);
  TSl.Add('POSTE1=' + poste);
  TSl.Add('[NOMBASES]');
  TSl.Add('ITEM0=' + qry.fields[1].AsString);
  qry.close;
  Ferme;
  TSl.Add('ITEM1=Base TEST');
  TSl.SaveToFile(ou + 'GINKOIA.INI');
  TSl.SaveToFile(ou + 'Caisseginkoia.ini');
  Tsl.Clear;
  Tsl.add('magasin=' + magasin);
  TSl.SaveToFile(ou + 'magasin.txt');
  tsl.free;
end;

procedure TInstall.free_Machine;
begin
  if fmachine <> nil then
  begin
     fmachine.free;
     fmachine := nil;
  end;
end;

function TInstall.GetMachine: TUtilMachine;
begin
  create_Machine;
  result := FMachine;
end;

function TInstall.GetMagasinSurServeur: Boolean;
var
  Tsl: TstringList;
begin
  result := False;
  if not FileExists('\\' + Serveur + '\' + FDirGinkoia + 'magasin.txt') then  // Disk + '\GINKOIA\magasin.txt'
     EXIT;
  Tsl := TstringList.create;
  tsl.LoadFromFile('\\' + Serveur + '\' + FDirGinkoia + 'magasin.txt');
  MagasinSurServeur := trim(Tsl.Values['magasin']);
  Result := MagasinSurServeur <> '';
  tsl.free;
end;

function TInstall.GetNomPoste: string;
begin
  result := Machine.NomPoste;
end;

procedure TInstall.OuvreServeur;
begin
  Connexion(Serveur + ':' +  FDirBase + 'Ginkoia.IB'); // Disk + ':\Ginkoia\Data\
end;

procedure TInstall.Referencement(base: string);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create(KEY_WRITE);
  Reg.Access := KEY_WOW64_32KEY or KEY_QUERY_VALUE;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('SOFTWARE\Algol\Ginkoia', True);
  reg.WriteString('Base0', base);
  reg.CloseKey;
  reg.free;
end;

procedure TInstall.SetPathBPL;
var
  P: array[0..4096] of char;
  S: string;
  Path: string;
  reg: TRegistry;
  lParam: PChar;
  dwResult: Cardinal;
begin
  GetEnvironmentVariable('PATH', P, 4096);
  S := P;
  Path := Uppercase(FDirGinkoia + 'BPL'); // Disk + ':\GINKOIA\BPL');
  if Pos(Path, Uppercase(S)) < 1 then
  begin
     reg := TRegistry.create(KEY_ALL_ACCESS);
     reg.RootKey := HKEY_LOCAL_MACHINE;
     reg.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', false);
     s := reg.ReadString('Path');

     if POS(Path, Uppercase(s)) = 0 then
     begin
       S := Path + ';'+S ;
       reg.WriteString('Path', s);
       reg.CloseKey;
       reg.free;
       if not SetEnvironmentVariable('PATH', Pchar(S)) then
          application.MessageBox('prob', 'prob', mb_ok);
       lParam := 'Environment';
       SendMessageTimeOut(HWND_BROADCAST, WM_SETTINGCHANGE, 0, Integer(lParam), SMTO_NORMAL, 2000, dwResult);
     end;
  end;
end;

end.

