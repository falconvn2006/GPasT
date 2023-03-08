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
  Vcl.StdCtrls,
  Vcl.Imaging.jpeg,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  SelectList_Frm,
  UItem,
  uLogFile;

const
  WM_LAUNCH_AUTO = WM_APP + 1;

type
  Tfrm_Main = class(TForm)
    lbl_Titre: TLabel;
    img_Logo: TImage;

    pnl_Progression: TPanel;
      lbl_DosMag: TLabel;
      lbl_Etape: TLabel;
      pb_Dossiers: TProgressBar;
      pb_Magasins: TProgressBar;
      pb_Items: TProgressBar;

    pnl_Traitements: TGridPanel;
      grp_Activation: TGroupBox;
        btn_ActivationMagasins: TButton;
        btn_ActivationDossiers: TButton;
        btn_DesActivationMagasins: TButton;
        btn_DesActivationDossiers: TButton;
      grp_Initialisation: TGroupBox;
        btn_InitialisationMagasins: TButton;
        btn_InitialisationDossiers: TButton;
        btn_ListeMag: TButton;
      grp_Traitement: TGroupBox;
        btn_TraitementMagasins: TButton;
        btn_TraitementDossiers: TButton;
        btn_TraitementComplet: TButton;
        chk_TraitementRecalcul: TCheckBox;
        chk_TraitementSendFTP: TCheckBox;
      grp_Validation: TGroupBox;
        btn_ValidationMagasins: TButton;
        btn_ValidationDossiers: TButton;
        btn_CreationUDF: TButton;
        btn_TestMail: TButton;
      grp_Autres: TGroupBox;
        btn_FtpSend: TButton;
        btn_Recalculs: TButton;
        btn_CorrectionADate: TButton;
        btn_Reinsertion: TButton;

    lbl_Status: TLabel;
    chk_Jeton: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure btn_ActivationDossiersClick(Sender: TObject);
    procedure btn_DesActivationDossiersClick(Sender: TObject);
    procedure btn_ActivationMagasinsClick(Sender: TObject);
    procedure btn_DesActivationMagasinsClick(Sender: TObject);
    procedure btn_InitialisationMagasinsClick(Sender: TObject);
    procedure btn_InitialisationDossiersClick(Sender: TObject);
    procedure btn_ListeMagClick(Sender: TObject);
    procedure btn_TraitementMagasinsClick(Sender: TObject);
    procedure btn_TraitementDossiersClick(Sender: TObject);
    procedure btn_TraitementCompletClick(Sender: TObject);
    procedure btn_ValidationMagasinsClick(Sender: TObject);
    procedure btn_ValidationDossiersClick(Sender: TObject);
    procedure btn_CreationUDFClick(Sender: TObject);
    procedure btn_TestMailClick(Sender: TObject);
    procedure btn_FtpSendClick(Sender: TObject);
    procedure btn_RecalculsClick(Sender: TObject);
    procedure btn_CorrectionADateClick(Sender: TObject);
    procedure btn_ReinsertionClick(Sender: TObject);
  private
    { Déclarations privées }
    FAuto : boolean;
    FEnCours : boolean;

    // fichier de log
    FLogs : TLogFile;

    // Gestion du traitement Auto !
    procedure MessageTrtAuto(var msg : TWMDropFiles); message WM_LAUNCH_AUTO;
    // Traitement d'activation/desactivation
    function ActivationDossier(FicheDos : Tfrm_SelectList; Enabled : boolean) : boolean;
    // creation des UDF
    function CreateUDF() : boolean;
    // gestion de l'interface
    procedure GestionInterface(Enabled : Boolean);
  public
    { Déclarations publiques }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses
  UVersion,
  uGestionBDD,
  UTraitements,
  ULectureIniFile,
  DateChooser_Frm,
  System.StrUtils,
  System.DateUtils,
  System.IniFiles,
  system.UITypes,
  FireDAC.Comp.Client,
  system.Generics.Defaults,
  system.Generics.Collections,
  USendFTP,
  GestionEMail;

{$R *.dfm}


{ Tfrm_Main }

// Evenements

procedure Tfrm_Main.FormCreate(Sender: TObject);
var
  i, LogLevel : integer;
  ModeDebug : boolean;
begin
  Caption := Caption + ' (Version : ' + GetNumVersionSoft() + ')';

  FLogs := TLogFile.Create(ExtractFilePath(ParamStr(0)) + 'Logs/{%APP}_{%DATE}.log', false);
  if ReadIniLogs(LogLevel) then
    FLogs.logLevel := TLogLevel(LogLevel);
  FLogs.Log('', logNotice);
  FLogs.Log('==========================', logNotice);
  FLogs.Log('Démarage de l''application', logNotice);

  FAuto := False;
{$IFDEF DEBUG}
  ModeDebug := true;
{$ELSE}
  ModeDebug := false;
{$ENDIF}

  // Lecture des paramètres
  for i := 1 to ParamCount do
  begin
    case IndexStr(UpperCase(ParamStr(i)), ['AUTO',
                                           'STOCK', 'FTP', 'JETON',
                                           'NOSTOCK', 'NOFTP', 'NOJETON',
                                           'DEBUG']) of
      // traitement auto ?
      0 : Fauto := True;
      // check des cases
      1 : chk_TraitementRecalcul.Checked := true;
      2 : chk_TraitementSendFTP.Checked := true;
      3 : chk_Jeton.Checked := true;
      // uncheck des cases
      4 : chk_TraitementRecalcul.Checked := false;
      5 : chk_TraitementSendFTP.Checked := false;
      6 : chk_Jeton.Checked := false;
      // debug ??
      7 : ModeDebug := true;
    end;
  end;

  // mode debug ??
  if ModeDebug then
  begin
    FLogs.Log('', logNotice);
    FLogs.Log('!! MODE DEBUG !!', logNotice);
    FLogs.Log('', logNotice);

    btn_ListeMag.Visible := true;
    btn_CreationUDF.Visible := true;
    btn_TestMail.Visible := true;
  end;
end;

procedure Tfrm_Main.FormShow(Sender: TObject);
begin
  if FAuto then
    PostMessage(Handle, WM_LAUNCH_AUTO, 0, 0);
end;

procedure Tfrm_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FEnCours;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  FLogs.Log('Fermeture de l''application', logNotice);
  FLogs.Log('===========================', logNotice);
  FLogs.Log('', logNotice);
  FreeAndNil(FLogs);
end;

// lancement des traitements !

procedure Tfrm_Main.btn_ActivationDossiersClick(Sender: TObject);
var
  FiltreDos : string;
  FicheDos : Tfrm_SelectList;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';

    try
      FicheDos := Tfrm_SelectList.Create(Self);
      if DialogSelectDossiers(FLogs, FicheDos, FiltreDos + ' and dos_actifbi = 0') then
      begin
        if ActivationDossier(FicheDos, true) then
          MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0)
        else
          MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
      end
      else
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0);
    finally
      FreeAndNil(FicheDos);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_DesActivationDossiersClick(Sender: TObject);
var
  FiltreDos : string;
  FicheDos : Tfrm_SelectList;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';

    try
      FicheDos := Tfrm_SelectList.Create(Self);
      if DialogSelectDossiers(FLogs, FicheDos, FiltreDos + ' and dos_actifbi = 1') then
      begin
        if ActivationDossier(FicheDos, false) then
          MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0)
        else
          MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
      end
      else
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0);
    finally
      FreeAndNil(FicheDos);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ActivationMagasinsClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, true, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and (prm_float = 0 or prm_float is null)');
      if Liste.Count = 0 then
        MessageDlg('Pas de magasin sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        try
          thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_Activation], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_DesActivationMagasinsClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, true, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de magasin sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        try
          thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_DesActivation], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_InitialisationMagasinsClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, true, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de magasin sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        try
          thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_Recalcul, ett_Initialisation], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_InitialisationDossiersClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, false, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        try
          thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_Recalcul, ett_Initialisation], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ListeMagClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  Dossier : TDossierItem;
  Magasin : TMagasinItem;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, true, FiltreDos, FiltreMag);
      if Liste.Count = 0 then
        MessageDlg('Pas de magasin configuré', mtWarning, [mbOK], 0)
      else
      begin
        for Dossier in Liste.Keys do
        begin

          MessageDlg('Initialisation Dossier : '#13#10
                   + #13#10
                   + 'Id : ' + IntToStr(Dossier.Id) + #13#10
                   + 'Code : ' + Dossier.Code + #13#10
                   + 'Nom : ' + Dossier.Nom + #13#10
                   + 'Serveur : ' + Dossier.Serveur + #13#10
                   + 'Fichier : ' + Dossier.FileName + #13#10
                   + 'Actif ? : ' + BoolToStr(Dossier.Actif, true)
                   , mtInformation, [mbOK], 0);

          for Magasin in Liste[Dossier] do
          begin
            MessageDlg('Initialisation magasin : '#13#10
                     + #13#10
                     + 'Id : ' + IntToStr(Magasin.Id) + #13#10
                     + 'Code : ' + Magasin.Code + #13#10
                     + 'Nom : ' + Magasin.Nom + #13#10
                     + 'Actif ? : ' + BoolToStr(Magasin.Actif, true) + #13#10
                     + 'Initialisé ? : ' + BoolToStr(Magasin.IsInit, true) + #13#10
                     + 'Date d''initialisation : ' + FormatDateTime('yyyy-mm-dd', Magasin.DateInit) + #13#10
                     + 'Date de traitement : ' + FormatDateTime('yyyy-mm-dd', Magasin.DateDrnTrt) + #13#10
                     + #13#10
                     + 'Dossier : ' + Dossier.Nom + #13#10
                     , mtInformation, [mbOK], 0);
          end;
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_TraitementMagasinsClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TExportThread;
  WhatToDo : TSetTraitementTodo;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, true, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de magasin sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        WhatToDo := [ett_Exports, ett_Validation];
        if chk_TraitementRecalcul.Checked then
          Include(WhatToDo, ett_Recalcul);
        if chk_TraitementSendFTP.Checked then
          Include(WhatToDo, ett_FTPSend);
        try
          thread := TExportThread.Create(chk_Jeton.Checked, Liste, WhatToDo, pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_TraitementDossiersClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TExportThread;
  WhatToDo : TSetTraitementTodo;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, false, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        WhatToDo := [ett_Exports, ett_Validation];
        if chk_TraitementRecalcul.Checked then
          Include(WhatToDo, ett_Recalcul);
        if chk_TraitementSendFTP.Checked then
          Include(WhatToDo, ett_FTPSend);
        try
          thread := TExportThread.Create(chk_Jeton.Checked, Liste, WhatToDo, pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_TraitementCompletClick(Sender: TObject);
var
  thread : TExportThread;
  WhatToDo : TSetTraitementTodo;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    WhatToDo := [ett_Exports, ett_Validation, ett_MailSend];
    if chk_TraitementRecalcul.Checked then
      Include(WhatToDo, ett_Recalcul);
    if chk_TraitementSendFTP.Checked then
      Include(WhatToDo, ett_FTPSend);
    try
      thread := TExportThread.Create(chk_Jeton.Checked, nil, WhatToDo, pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
      while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
        Application.ProcessMessages();
      case thread.ReturnValue of
         0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
        else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
      end;
    finally
      FreeAndNil(thread);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ValidationMagasinsClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
  DateTrt : TDate;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, true, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de magasin sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        DateTrt := IncDay(Now(), 1);
        if SelectDate(DateTrt) then
        begin
          try
            thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_Validation], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs, true);
            thread.DateValide := DateTrt;
            thread.Resume();
            while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
              Application.ProcessMessages();
            case thread.ReturnValue of
               0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
              else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
            end;
          finally
            FreeAndNil(thread);
          end;
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ValidationDossiersClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
  DateTrt : TDate;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, false, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        DateTrt := IncDay(Now(), 1);
        if SelectDate(DateTrt) then
        begin
          try
            thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_Validation], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs, true);
            thread.DateValide := DateTrt;
            thread.Resume();
            while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
              Application.ProcessMessages();
            case thread.ReturnValue of
               0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
              else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
            end;
          finally
            FreeAndNil(thread);
          end;
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_CreationUDFClick(Sender: TObject);
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if CreateUDF() then
      MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0)
    else
      MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_TestMailClick(Sender: TObject);
var
  Server, Username, Password, Expediteur : string;
  Port : integer;
  Securite : SecuriteMail;
  Destinataire : TStringList;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    // Gestion du mail...
    Destinataire := nil;
    try
      if ReadIniMail(Server, Username, Password, Expediteur, Port, Securite, Destinataire) then
      begin
        if SendMail(Server, Port, Username, DecryptPasswd(Password), Securite,
                    Expediteur, Destinataire, 'Suivi BI Intersport - Test', 'Test') then
          MessageDlg('Envoi correct', mtInformation, [mbOK], 0)
        else
          MessageDlg('Erreur d''envoi', mtError, [mbOK], 0);
      end
      else
        MessageDlg('Erreur de lecture du fichier INI', mtError, [mbOK], 0);
    finally
      FreeAndNil(Destinataire);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_FtpSendClick(Sender: TObject);
var
  Open : TOpenDialog;
  i : integer;
  DateExp : TDate;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    DateExp := IncDay(Now(), 1);
    try
      Open := TOpenDialog.Create(self);
      Open.Filter := 'Fichier ZIP|*.zip';
      Open.FilterIndex := 0;
      repeat
        DateExp := IncDay(DateExp, -1);
        Open.InitialDir := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName) + 'Extract') + FormatDateTime('yyyy' + PathDelim + 'mm' + PathDelim + 'dd' + PathDelim, DateExp);
      until DirectoryExists(Open.InitialDir) or (DaysBetween(Now(), DateExp) > 7);
      Open.Options := [ofHideReadOnly,ofEnableSizing, ofAllowMultiSelect];
      if Open.Execute() then
      begin
        try
          for i := 0 to Open.Files.Count -1 do
            SendFileFTP(Open.Files[i]);
          MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
        except
          MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
        end;
      end;
    finally
      FreeAndNil(Open);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_RecalculsClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, false, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        try
          thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_Recalcul], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_CorrectionADateClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
  DateTrt : TDate;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, false, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        if SelectDate(DateTrt) then
        begin
          try
            thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_Correction], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs, true);
            thread.DateCorrection := DateTrt;
            thread.Resume();
            while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
              Application.ProcessMessages();
            case thread.ReturnValue of
               0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
              else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
            end;
          finally
            FreeAndNil(thread);
          end;
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

procedure Tfrm_Main.btn_ReinsertionClick(Sender: TObject);
var
  FiltreDos, FiltreMag : string;
  Liste : TItemDictionary<TDossierItem, TMagasinItem>;
  thread : TOtherThread;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    if not ReadIniFiltreDossier(FiltreDos) then
      FiltreDos := '';
    if not ReadIniFiltreMagasin(FiltreMag) then
      FiltreMag := '';

    try
      Liste := GetListeDossierMagasin(Self, FLogs, true, false, FiltreDos + ' and dos_actifbi = 1', FiltreMag + ' and prm_float = 1');
      if Liste.Count = 0 then
        MessageDlg('Pas de dossier sélectionné', mtWarning, [mbOK], 0)
      else
      begin
        try
          thread := TOtherThread.Create(chk_Jeton.Checked, Liste, [ett_ReInsertion], pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
          while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
            Application.ProcessMessages();
          case thread.ReturnValue of
             0 : MessageDlg('Traitement terminé correctement', mtInformation, [mbOK], 0);
            else MessageDlg('Traitement terminé avec des erreurs', mtError, [mbOK], 0);
          end;
        finally
          FreeAndNil(thread);
        end;
      end;
    finally
      FreeAndNil(Liste);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

// traitement du message

procedure Tfrm_Main.MessageTrtAuto(var msg : TWMDropFiles);
var
  thread : TExportThread;
  WhatToDo : TSetTraitementTodo;
begin
  try
    GestionInterface(false);
    FEnCours := true;

    WhatToDo := [ett_Exports, ett_Validation, ett_MailSend];
    if chk_TraitementRecalcul.Checked then
      Include(WhatToDo, ett_Recalcul);
    if chk_TraitementSendFTP.Checked then
      Include(WhatToDo, ett_FTPSend);
    try
      thread := TExportThread.Create(chk_Jeton.Checked, nil, WhatToDo, pb_Dossiers, pb_Magasins, pb_Items, lbl_DosMag, lbl_Etape, FLogs);
      while WaitForSingleObject(thread.Handle, 100) = WAIT_TIMEOUT do
        Application.ProcessMessages();
      PostQuitMessage(thread.ReturnValue);
    finally
      FreeAndNil(thread);
    end;
  finally
    FEnCours := false;
    GestionInterface(true);
  end;
end;

// Activation/Deasctivation dossier !

function Tfrm_Main.ActivationDossier(FicheDos : Tfrm_SelectList; Enabled : boolean) : boolean;
var
  DataBaseFile : string;
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  i : integer;
begin
  Result := false;

  if ReadIniBase(DataBaseFile) and not (Trim(DataBaseFile) = '') then
  begin
    try
      Connexion := GetNewConnexion(DataBaseFile, 'sysdba', 'masterkey', false);
      Connexion.FetchOptions.Unidirectional := true;
      Connexion.Open();
      Transaction := GetNewTransaction(Connexion, false);
      Query := GetNewQuery(Connexion, Transaction);

      try
        Transaction.StartTransaction();

        for i := 0 to FicheDos.SelectedCount -1 do
        begin
          if Enabled then
            Query.SQL.Text := 'update dossiers set dos_actifbi = 1 where dos_id = ' + IntToStr(FicheDos.Selected[i].Id) + ';'
          else
            Query.SQL.Text := 'update dossiers set dos_actifbi = 0 where dos_id = ' + IntToStr(FicheDos.Selected[i].Id) + ';';
          Query.ExecSQL();
        end;

        Transaction.Commit();
        Result := true;
      except
        Transaction.Rollback();
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  end;
end;

function Tfrm_Main.CreateUDF() : boolean;
var
  DataBaseFile : string;
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
begin
  Result := false;

  if ReadIniBase(DataBaseFile) and not (Trim(DataBaseFile) = '') then
  begin
    try
      Connexion := GetNewConnexion(DataBaseFile, 'sysdba', 'masterkey', false);
      Connexion.FetchOptions.Unidirectional := true;
      Connexion.Open();
      Transaction := GetNewTransaction(Connexion, false);
      Query := GetNewQuery(Connexion, Transaction);

      try
        Transaction.StartTransaction();

        Query.SQL.Clear();
        Query.SQL.Add('DECLARE EXTERNAL FUNCTION F_LEFT');
        Query.SQL.Add('    CSTRING(254),');
        Query.SQL.Add('    INTEGER');
        Query.SQL.Add('RETURNS CSTRING(254)');
        Query.SQL.Add('ENTRY_POINT ''Left'' MODULE_NAME ''FreeUDFLib.dll'';');
        Query.ExecSQL();

        Query.SQL.Clear();
        Query.SQL.Add('DECLARE EXTERNAL FUNCTION F_RIGHT');
        Query.SQL.Add('    CSTRING(254),');
        Query.SQL.Add('    INTEGER');
        Query.SQL.Add('RETURNS CSTRING(254)');
        Query.SQL.Add('ENTRY_POINT ''Right'' MODULE_NAME ''FreeUDFLib.dll'';');
        Query.ExecSQL();

        Query.SQL.Clear();
        Query.SQL.Add('DECLARE EXTERNAL FUNCTION F_SUBSTR');
        Query.SQL.Add('    CSTRING(254),');
        Query.SQL.Add('    CSTRING(254)');
        Query.SQL.Add('RETURNS INTEGER BY VALUE');
        Query.SQL.Add('ENTRY_POINT ''SubStr'' MODULE_NAME ''FreeUDFLib.dll'';');
        Query.ExecSQL();

        Query.SQL.Clear();
        Query.SQL.Add('DECLARE EXTERNAL FUNCTION F_STRINGLENGTH');
        Query.SQL.Add('    CSTRING(254)');
        Query.SQL.Add('RETURNS INTEGER BY VALUE');
        Query.SQL.Add('ENTRY_POINT ''StringLength'' MODULE_NAME ''FreeUDFLib.dll'';');
        Query.ExecSQL();

        Transaction.Commit();
        Result := true;
      except
        Transaction.Rollback();
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  end;
end;

// fonction utilitaires

procedure Tfrm_Main.GestionInterface(Enabled : Boolean);
begin
  if not Enabled then
    Screen.Cursor := crHourGlass;
  Application.ProcessMessages();

  try
    // blocage temporaire
    Self.Enabled := False;

    btn_ActivationMagasins.Enabled := Enabled;
    btn_ActivationDossiers.Enabled := Enabled;
    btn_DesActivationMagasins.Enabled := Enabled;
    btn_DesActivationDossiers.Enabled := Enabled;
    btn_InitialisationMagasins.Enabled := Enabled;
    btn_InitialisationDossiers.Enabled := Enabled;
    btn_TraitementMagasins.Enabled := Enabled;
    btn_TraitementDossiers.Enabled := Enabled;
    btn_TraitementComplet.Enabled := Enabled;
    chk_TraitementRecalcul.Enabled := Enabled;
    chk_TraitementSendFTP.Enabled := Enabled;
    btn_ValidationMagasins.Enabled := Enabled;
    btn_ValidationDossiers.Enabled := Enabled;
    btn_CreationUDF.Enabled := Enabled;
    btn_TestMail.Enabled := Enabled;
    btn_FtpSend.Enabled := Enabled;
    btn_Recalculs.Enabled := Enabled;
    btn_CorrectionADate.Enabled := Enabled;
    btn_Reinsertion.Enabled := Enabled;
    btn_ListeMag.Enabled := Enabled;

    chk_Jeton.Enabled := Enabled;
  finally
    // deblocage
    Self.Enabled := True;
  end;

  if Enabled then
    Screen.Cursor := crDefault;
  Application.ProcessMessages();
end;

end.


