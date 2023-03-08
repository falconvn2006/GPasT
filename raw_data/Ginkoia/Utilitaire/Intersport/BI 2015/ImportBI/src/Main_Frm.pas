unit Main_Frm;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs, 
  Vcl.ExtCtrls,
  UTraitements,
  UInfosDatabase,
  uMessage;

type
  TFrm_Main = class(TForm)
    tmr_Process: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);

    procedure tmr_ProcessTimer(Sender: TObject);
  private
    { Déclarations privées }
  protected
    { Déclarations protégées }
    FLogDos, FLogMdl, FLogRef, FLogMag, FLogKey : string;
    FDateminMvt, FDateMinStk : TDate;
    FListeMagToDo : TStringList;

    FTraitement : TTraitement;
    FBaseGin, FBaseTpn : string;
    FLogInterval : integer;
    FListeMag : TListMagasin;
    FWhatToDo : TSetTraitementTodo;

    procedure MessageStartTrt(var msg : TMessage); message WM_START_TRT;
    procedure MessageHideWindow(var msg : TMessage); message WM_HIDE_WINDOW;
    procedure MessageAskToKill(var msg : TMessage); message WM_ASK_TO_KILL;
    procedure MessageTerminated(var msg : TMessage); message WM_TERMINATED;
  public
    { Déclarations publiques }
    procedure Initialisation(BaseGin, BaseTpn : string; DateMinMvt, DateMinStk : TDate; LogInterval : integer; ListeMagToDo : string; WhatToDo : TSetTraitementTodo);
    procedure ThreadTerminate(Sender : TObject);
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

uses
  System.TypInfo,
  System.Win.Registry,
  IdGlobal,
  uGestionBDD,
  uLog,
  UneInstance,
  VersionInfo;

{ TFrm_Main }

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  i : integer;
  tmp : string;
begin
  FLogDos := '';       // Nom du dossier
  FLogMdl := 'RapprAuto';   // Module du programme
  FLogRef := '';       // GUID du site de replic
  FLogMag := '';       // ID magasin
  FLogKey := 'Status'; // "Status" ou "Stock" selon...

  FTraitement := nil;
  FBaseGin := '';
  FBaseTpn := '';
  FLogInterval := 0;
  FListeMagToDo := TStringList.Create();
  FListeMagToDo.Delimiter := ';';
  FListeMag := nil;
  FWhatToDo := [];

//===== Global pre-resigné
//  App = application   *
//  Inst = instance     ''
//  Host = Hôte         *
//  Srv = Serveur       Host
//  Dos = Dossier       -> bas_nompournous le plus frequent dans genbase
// ===== a l'appele
//  Mdl = Module        -> Main pour le général sinon BI, Stock, Commande, Purge, ... selon les traitement
//  Ref = Référence     -> GUID du site de replication
//  Mag = Magasin       -> Id du magasin en cours de traitement
// ===== Log effectif
//  Key = clé           -> status, version ou selon les IP
//  Val = valeur        -> mesage
//====== facultatif
//  Ovl = overload
//  Freq = fréquence de validité : le log doit retimer à date + freq (en seconde)
//    -> property Frequence de la classe
//       en fait passé en paramètre maintenant

  Log.readIni();
  Log.Srv := Log.Host;
  Log.Frequence := 3600;
  Log.LogKeepDays := 31;
  Log.FileLogFormat := [elDate, elLevel, elDos, elRef, elKey, elValue, elData];
  Log.MaxItems := 10000;
  Log.Deboublonage := false;
  log.SendOnClose := true;
  Log.Open();

  if FindCmdLineSwitch('LogLevel', tmp, true, [clstValueAppended]) then
  begin
    if IsNumeric(tmp) then
      Log.FileLogLevel := TLogLevel(StrToInt(tmp))
    else
      Log.FileLogLevel := TLogLevel(GetEnumValue(TypeInfo(TLogLevel), tmp));
  end;
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, '', logTrace);
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, '==================================================', logTrace);
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Lancement du programme (v' + ReadFileVersion('ImportBI.exe') + ')', logTrace);
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Paramètres : ', logDebug);
  for i := 1 to ParamCount() do
    Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, '    ' + ParamStr(i), logDebug);

{$IFNDEF DEBUG}
  if not RunOnlyOne(true) then
  begin
    Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, ' -> ATTENTION : Déjà lancé !!', logDebug);
    Halt(99);
  end;
{$ENDIF}

  // envoie des message !
  PostMessage(Self.Handle, WM_HIDE_WINDOW, 0, 0);
end;

procedure TFrm_Main.FormShow(Sender: TObject);
begin
  PostMessage(Self.Handle, WM_HIDE_WINDOW, 0, 0);
end;

procedure TFrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not Assigned(FTraitement);
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FListeMag);
  FreeAndNil(FListeMagToDo);
end;

// timer ...

procedure TFrm_Main.tmr_ProcessTimer(Sender: TObject);
begin
  Application.ProcessMessages();
end;

// Messages ...

procedure TFrm_Main.MessageStartTrt(var msg : TMessage);
var
  TrtInterval, i : integer;
  RappAuto : boolean;
begin
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Message : ' + IntToStr(msg.Msg), logNone);
  if GetDatabaseInfos(FBaseGin, DATABASE_USER_GNK, DATABASE_PASSWORD_GNK, FLogDos, FLogRef, TrtInterval, RappAuto, FListeMag) then
//  if GetDatabaseInfos(FBaseGin, DATABASE_USER_GNK, DATABASE_PASSWORD_GNK, FLogDos, FLogRef, TrtInterval, FListeMag) then
  begin
    // gestion de la liste des magasin a traité !
    if FListeMagToDo.Count > 0 then
    begin
      for i := 0 to FListeMag.Count -1 do
        if FListeMagToDo.IndexOf(IntToStr(FListeMag[i].MagId)) < 0 then
          FListeMag[i].Actif := false;
    end;
    // gestion de l'interval de log
    if FLogInterval = 0 then
      FLogInterval := TrtInterval * 2 * 60; // passage de minute en seconde + se donné du temps !
    // lancement du traitement !
    FTraitement := TTraitement.Create(ThreadTerminate, FBaseGin, FBaseTpn, FLogDos, FLogMdl, FLogRef, FLogKey, FDateMinMvt, FDateMinStk, FLogInterval, FListeMag, FWhatToDo);
  end
  else
  begin
    Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Erreur de recupération de info base', logDebug);
    PostMessage(Self.Handle, WM_TERMINATED, 0, 0);
    ExitCode := 4;
  end;
end;

procedure TFrm_Main.MessageHideWindow(var msg : TMessage);
begin
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Message : ' + IntToStr(msg.Msg), logNone);
  Hide();
end;

procedure TFrm_Main.MessageAskToKill(var msg : TMessage);
begin
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Message : ' + IntToStr(msg.Msg), logNone);
  if Assigned(FTraitement) then
    FTraitement.Terminate();
end;

procedure TFrm_Main.MessageTerminated(var msg : TMessage);
begin
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Message : ' + IntToStr(msg.Msg), logNone);
  if Assigned(FTraitement) then
    FTraitement.WaitFor();
  FreeAndNil(FTraitement);
  FreeAndNil(FListeMag);
  Close();
end;

// autres fonction !

procedure TFrm_Main.Initialisation(BaseGin, BaseTpn : string; DateMinMvt, DateMinStk : TDate; LogInterval : integer; ListeMagToDO : string; WhatToDo : TSetTraitementTodo);
begin
  FBaseGin := BaseGin;
  FBaseTpn := BaseTpn;
  FDateMinMvt := DateMinMvt;
  FDateMinStk := DateMinStk;
  FLogInterval := LogInterval;
  FListeMagToDo.DelimitedText := ListeMagToDo;
  FWhatToDo := WhatToDo;
  // test du possible backup/restore
  if FileExists(ChangeFileExt(FBaseTpn, '.OLD')) then
  begin
    Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, ' -> ATTENTION : backup/restore en cours !!', logDebug);
    Halt(98);
  end;
  // a partir d'ici on peut lancer le traitement !
  PostMessage(Self.Handle, WM_START_TRT, 0, 0);
end;

procedure TFrm_Main.ThreadTerminate(Sender : TObject);
begin
  ExitCode := FTraitement.ReturnValue;
  PostMessage(Self.Handle, WM_TERMINATED, 0, 0);
end;

end.
