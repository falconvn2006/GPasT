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
  uMessage,
  uCreateProcess,

  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Intf,
  FireDAC.Comp.UI;

type
  TFrm_Main = class(TForm)
    tmr_Process: TTimer;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;

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
    FDateMinVte, FDateMinMvt, FDateMinCmd, FDateMinRap, FDateMinStk : TDate;
    FNbDaysReMouvement : integer;
    FListeMagToDo : TStringList;

    FTraitement : TTraitement;
    FBaseGin, FBaseTpn : string;
    FLogInterval : integer;
    FListeMag : TListMagasin;
    FWhatToDo : TSetTraitementTodo;

    // communication via std in/out/err
    FStdStream : TStdStream;
    procedure OnStdIn(Sender : TObject);
    procedure GestionOrdre(Param, Value : string);

    procedure MessageStartTrt(var msg : TMessage); message WM_START_TRT;
    procedure MessageHideWindow(var msg : TMessage); message WM_HIDE_WINDOW;
    procedure MessageAskToKill(var msg : TMessage); message WM_ASK_TO_KILL;
    procedure MessageTerminated(var msg : TMessage); message WM_TERMINATED;
  public
    { Déclarations publiques }
    procedure Initialisation(BaseGin, BaseTpn : string; DateMinVte, DateMinMvt, DateMinCmd, DateMinRap, DateMinStk : TDate; LogInterval : integer; ListeMagToDo : string; WhatToDo : TSetTraitementTodo; NbDaysReMouvement : integer = 0);
    procedure ThreadTerminate(Sender : TObject);
  end;

var
  Frm_Main: TFrm_Main;

implementation

{$R *.dfm}

uses
  System.TypInfo,
  System.StrUtils,
  System.Win.Registry,
  IdGlobal,
  uGestionBDD,
  uLog,
  UneInstance,
  VersionInfo;

const
  ListeOrdres : array[0..13] of string = ('START', 'PAUSE', 'RESUME', 'STOP', 'EXIT',                                    // standard
                                          'PASSWORD',                                                                    // sécurité
                                          'SERVEUR', 'BASE', 'PORT', 'AUTO', 'MANU', 'TRAITEMENT', 'YELLIS', 'LOGDEST'); // spécifique

{ TFrm_Main }

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  i : integer;
  tmp : string;
begin
  // Creation du Stream pour la com interprocess !
  FStdStream := TStdStream.Create();
  FStdStream.OnStdIn := OnStdIn;

  // Gestion des log
  FLogDos := '';       // Nom du dossier
  FLogMdl := 'Main';   // Module du programme
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
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Lancement du programme (v' + ReadFileVersion('ExtractBI.exe') + ')', logTrace);
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Paramètres : ', logDebug);
  for i := 1 to ParamCount() do
    Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, '    ' + ParamStr(i), logDebug);

{$IFNDEF DEBUG}
  if not RunOnlyOne(true) then
  begin
    Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, ' -> ATTENTION : Déjà lancer !!', logDebug);
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
  Log.Close();
  FreeAndNil(FListeMag);
  FreeAndNil(FListeMagToDo);
end;

// timer ...

procedure TFrm_Main.tmr_ProcessTimer(Sender: TObject);
begin
  Application.ProcessMessages();
end;

// aeurf

procedure TFrm_Main.OnStdIn(Sender : TObject);
var
  vLine : string;
  Param, Value : string;
begin
  repeat
    vLine := Trim(FStdStream.StdIn.readLine());
    if vLine <> '' then
    begin
      if Pos('=', vLine) > 0 then
      begin
        Param := UpperCase(Trim(Copy(vLine, 1, Pos('=', vLine) -1)));
        Value := Copy(vLine, Pos('=', vLine) +1, Length(vLine));
      end
      else
      begin
        Param := UpperCase(Trim(vLine));
        Value := '';
      end;
      GestionOrdre(Param, Value);
    end;
  until vLine = '' ;
end;

procedure TFrm_Main.GestionOrdre(Param, Value : string);
begin
  case IndexStr(Param, ListeOrdres) of
     0 : // START
      begin
//        // TODO -obpy : la gestion de l'ordre de démarage
//        if Self.Visible then
//        begin
//          // commande ??
//          FAuto := false;
//          FShowMsg := false;
//          MessageTrt(FTraitement);
//        end
//        else
//        begin
//          // demarage ...
//          FAuto := true;
//        end;
      end;
     1 : // PAUSE
      begin
        if Assigned(FTraitement) and not FTraitement.Suspended then
        begin
          FTraitement.Suspend();
          // signalisation
          FStdStream.StdErr.Writeln('PAUSED');
        end;
      end;
     2 : // RESUME
      begin
        if Assigned(FTraitement) and FTraitement.Suspended then
        begin
          FTraitement.Resume();
          // signalisation
          FStdStream.StdErr.Writeln('RESUMED');
        end;
      end;
     3 : // STOP
      begin
        if Assigned(FTraitement) then
        begin
          if FTraitement.WhatIsDoing in [ett_CreateBase, ett_UpdateBase, ett_ClearBase, ett_Purge,
                                         ett_GestionMagasins, ett_GestionFournisseurs,
                                         ett_CompletArticles, ett_CompletTickets, ett_CompletFactures, ett_CompletMouvements, ett_CompletCommandes, ett_CompletReceptions, ett_CompletRetours,
                                         ett_HistoStock, ett_ResetStock,
                                         ett_ForceSleep] then
          begin
            // ne peut pas s'arrèté !
            FStdStream.StdErr.Writeln('CANTSTOP (' + GetEnumName(TypeInfo(TEnumTypeTraitement), Ord(FTraitement.WhatIsDoing)) + ')');
          end
          else
          begin
            FTraitement.Terminate();
            // signalisation
            FStdStream.StdErr.Writeln('STOPPED');
          end;
        end;
      end;
     4 : // EXIT
      begin
        if Assigned(FTraitement) then
        begin
          FTraitement.Terminate();
          // signalisation
          FStdStream.StdErr.Writeln('STOPPED');
        end;
        PostQuitMessage(0);
      end;
//    // sécurité
//     5 : // PASSWORD
//      FPassword := Value;
//    // Specifique !
//     6 :
//      edt_Serveur.Text := value;
//     7 :
//      edt_BaseFile.Text := Value;
//     8 :
//      edt_Port.Text := IntToStr(StrToIntDef(Value, CST_BASE_PORT));
//     9 :
//      begin
//        FAuto := true;
//        FShowMsg := false;
//        if not (Trim(Value) = '') then
//          FTraitement := value;
//      end;
//    10 :
//      begin
//        FAuto := true;
//        FShowMsg := true;
//        if not (Trim(Value) = '') then
//          FTraitement := value;
//      end;
//    11 :
//      FTraitement := value;
//    12 :
//      chk_Yellis.State := cbChecked;
//    13 :
//      FLogDest := IncludeTrailingPathDelimiter(Value);
  end;
end;

// Messages ...

procedure TFrm_Main.MessageStartTrt(var msg : TMessage);
var
  TrtInterval, i : integer;
  RappAuto : boolean;
begin
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Message : ' + IntToStr(msg.Msg), logNone);
  if GetDatabaseInfos(FBaseGin, DATABASE_USER_GNK, DATABASE_PASSWORD_GNK, FLogDos, FLogRef, TrtInterval, RappAuto, FListeMag) then
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
    // Gestion du non rapprochement auto
    if not RappAuto then
      FWhatToDo := FWhatToDo - [ett_DelImport, ett_CompletReceptions, ett_CompletRetours, ett_DeltaReceptions, ett_DeltaRetours];
    // lancement du traitement !
    FTraitement := TTraitement.Create(ThreadTerminate, FStdStream, FBaseGin, FBaseTpn, FLogDos, FLogMdl, FLogRef, FLogKey, FDateMinVte, FDateMinMvt, FDateMinCmd, FDateMinRap, FDateMinStk, FLogInterval, FListeMag, FWhatToDo, FNbDaysReMouvement);
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
  begin
    if FTraitement.WhatIsDoing in [ett_CreateBase, ett_UpdateBase, ett_ClearBase, ett_Purge,
                                   ett_GestionMagasins, ett_GestionExercices, ett_GestionCollections, ett_GestionFournisseurs,
                                   ett_CompletArticles, ett_CompletTickets, ett_CompletFactures, ett_CompletMouvements, ett_CompletCommandes, ett_CompletReceptions, ett_CompletRetours,
                                   ett_HistoStock, ett_ResetStock,
                                   ett_ForceSleep] then
    begin
      // ne peut pas s'arrèté !
      FStdStream.StdErr.Writeln('CANTSTOP (' + GetEnumName(TypeInfo(TEnumTypeTraitement), Ord(FTraitement.WhatIsDoing)) + ')');
    end
    else
    begin
      FTraitement.Terminate();
      // signalisation
      FStdStream.StdErr.Writeln('STOPPED');
    end;
  end;
end;

procedure TFrm_Main.MessageTerminated(var msg : TMessage);
begin
  Log.Log(FLogMdl, FLogRef, FLogMag, FLogKey, 'Message : ' + IntToStr(msg.Msg), logNone);
  if Assigned(FTraitement) then
  begin
    FTraitement.WaitFor();
    FreeAndNil(FTraitement);
  end;
  Sleep(1000);
  Close();
end;

// autres fonction !

procedure TFrm_Main.Initialisation(BaseGin, BaseTpn : string; DateMinVte, DateMinMvt, DateMinCmd, DateMinRap, DateMinStk : TDate; LogInterval : integer; ListeMagToDO : string; WhatToDo : TSetTraitementTodo; NbDaysReMouvement : integer);
begin
  FBaseGin := BaseGin;
  FBaseTpn := BaseTpn;
  FDateMinVte := DateMinVte;
  FDateMinMvt := DateMinMvt;
  FDateMinCmd := DateMinCmd;
  FDateMinRap := DateMinRap;
  FDateMinStk := DateMinStk;
  FLogInterval := LogInterval;
  FListeMagToDo.DelimitedText := ListeMagToDo;
  FNbDaysReMouvement := NbDaysReMouvement;
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
var
  tmpTraitement : TTraitement;
begin
  if Assigned(FTraitement) then
  begin
    // "liberation" du thread ...
    tmpTraitement := FTraitement;
    FTraitement := nil;

    // affichage de message ?
    case tmpTraitement.ReturnValue of
      0 :  FStdStream.StdErr.Writeln('SUCCESS');
      else FStdStream.StdErr.Writeln('FAIL');
    end;

    // code de retour de l'appli !
    ExitCode := tmpTraitement.ReturnValue;
  end;
  PostMessage(Self.Handle, WM_TERMINATED, 0, 0);
end;

end.
