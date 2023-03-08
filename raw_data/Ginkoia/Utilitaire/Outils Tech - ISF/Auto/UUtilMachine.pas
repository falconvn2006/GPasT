unit UUtilMachine;

interface

uses
   registry, ShlObj, ComObj, ActiveX,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls;

type
  TUtilMachine = class(TObject)
  public
    procedure CreerRaccourcie(Nom, Fichier, Description, Repertoire, Icon :
        String; Index:Integer=0);
    function NomPoste: string;
  end;


implementation

procedure TUtilMachine.CreerRaccourcie(Nom, Fichier, Description, Repertoire,
    Icon : String; Index:Integer=0);
var
  ShellLink: IShellLink;
  registre: Tregistry;
  chem_bureau: string;
begin
  registre:=Tregistry.create (KEY_READ) ;
  registre.RootKey:=HKEY_CURRENT_USER;
  registre.OpenKey ('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',false);
  chem_bureau := IncludeTrailingBackslash(registre.ReadString('DeskTop')) ;
  registre.free ;

  ShellLink:=CreateComObject(CLSID_ShellLink) as IShellLink;
  ShellLink.SetDescription(Pchar(Description));
  ShellLink.SetWorkingDirectory(Pchar(Repertoire));
  ShellLink.SetPath(PChar(Fichier));
  ShellLink.SetShowCmd(SW_SHOW);
  ShellLink.SetIconLocation(Pchar(Icon),Index) ;
  (ShellLink as IpersistFile).Save(StringToOleStr(chem_bureau+Nom+'.lnk'), true);
end;

function TUtilMachine.NomPoste: string;
var
  pass: array[0..255] of char;
  size: dword;
begin
  size := 250 ;
  getcomputername(pass, size);
  result := string(pass);
end;



end.
