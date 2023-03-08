unit uDefs;

interface

uses ShellApi, Windows, Forms, Dialogs, SysUtils;

type TVersion = record
  VersionComplet : String;
  VersionVirgul  : String;
  VersionSansZero : String;
  VersionDecoupe : record
    A,B,C,D : String;
    iA,iB,iC,iD : integer;
  end;
end;

var
  GAPPPATH : String;

function ExecuteAndWait (sExeName : String;Param : String = '') : Boolean;

implementation

function ExecuteAndWait (sExeName : String;Param : String) : Boolean;
Var  StartInfo   : TStartupInfo;
     ProcessInfo : TProcessInformation;
     Fin         : Boolean;

begin
  { Mise à zéro de la structure StartInfo }
  FillChar(StartInfo,SizeOf(StartInfo),#0);
  { Seule la taille est renseignée, toutes les autres options }
  { laissées à zéro prendront les valeurs par défaut }
  StartInfo.cb     := SizeOf(StartInfo);

  { Lancement de la ligne de commande }
  If CreateProcess(PChar(sExeName),PChar(Param) ,nil , Nil, False,
                0, Nil, Nil, StartInfo,ProcessInfo) Then
  Begin
    { L'application est bien lancée, on va en attendre la fin }
    { ProcessInfo.hProcess contient le handle du process principal de l'application }
    Fin:=False;
    Repeat
      { On attend la fin de l'application }
      Case WaitForSingleObject(ProcessInfo.hProcess, 200)Of
        WAIT_OBJECT_0 :Fin:=True; { L'application est terminée, on sort }
        WAIT_TIMEOUT  :;          { elle n'est pas terminée, on continue d'attendre }
      End;
      { Mise à jour de la fenêtre pour que l'application ne paraisse pas bloquée. }
      Application.ProcessMessages;
    Until Fin;
    { C'est fini }
  End
  Else RaiseLastOSError;

end;

end.
