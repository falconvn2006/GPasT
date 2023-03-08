unit Main_Dm;

interface

uses
  SysUtils, Classes, Windows, DB, IBCustomDataSet, IBTable, IBDatabase, Forms, IniFiles, SqlTimSt,
  DBClient, UThreadCalculStock, UThreadEnvoiCourriel,DateUtils,types,
  IB_Components, IB_Access;

type
  TDm_Main = class(TDataModule)
    IBDB_Maintenance: TIBDatabase;
    IBT_Maintenance: TIBTransaction;
    IBTbl_Dossier: TIBTable;
    IBTbl_DossierDOSS_ID: TIntegerField;
    IBTbl_DossierDOSS_DATABASE: TIBStringField;
    IBTbl_DossierDOSS_CHEMIN: TIBStringField;
    IBTbl_DossierDOSS_RECALTEMPS: TIntegerField;
    IBTbl_DossierDOSS_RECALLASTDATE: TDateTimeField;
    CDS_Dossier: TClientDataSet;
    IbQ_UpdateDossier: TIB_Query;
    procedure DataModuleCreate(Sender: TObject);
    // Connexion à la base de données Maintenance
    function Connexion(): Boolean;
    // Charge la liste des bases à gérer
    procedure ChargerListeBases();
    // Enregistrement des modifications sur un dossier
    function EnregistrerDossier(ADossId: Integer) : Boolean;
    function EnregistrerTousLesDossier : Boolean;
    // Envoi le rapport par courriel
    procedure EnvoiCourriel();
    // Procédure exécuté à la fin de l'envoi du courriel
    procedure FinCourriel(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  strict private
    { Déclarations privées }
  public
    { Déclarations publiques }
    EnvoyerSMTP       : Boolean;
    HoteSMTP          : String;
    UtilisateurSMTP   : String;
    MotPasseSMTP      : String;
    PortSMTP          : Word;
    TLSSMTP           : Boolean;
    ExpediteurSMTP    : String;
    DestinatairesSMTP : String;
    ObjetSMTP         : String;
    ContenuSMTP       : String;
  end;

  TBaseClient = record
    Id            : Integer;
    Nom           : String;
    Chemin        : String;
    TempsMoyen    : Integer;
    DerniereDate  : TDateTime;
    Utilisable    : Boolean;
    // Identifiant du thread dans le tableau. -1 si inactif.
    ThreadId      : Integer;
  end;

var
  Dm_Main                 : TDm_Main;
  slListeExclus           : TStringList;
  BasesClient             : array of TBaseClient;
  tHeureDebut, tHeureFin  : TTime;
  inbThread               : Integer;
  ThsCalculStock          : array of TThreadCalculStock;

implementation

uses ResStr, Main_Frm;

{$R *.dfm}

// Connexion à la base de données Maintenance
function TDm_Main.Connexion(): Boolean;
var
  IniParametres : TIniFile;
  sHeure        : String;
  sChemin       : String;
  tsListeBase   : TStringList;
  i             : Integer;
begin
  Result := False;

  if FindCmdLineSwitch('BASE') then
  begin
    {$REGION 'Fonctionnement avec une seule base de données client'}
    FindCmdLineSwitch('BASE', sChemin);

    // Ajout du dossier à la liste
    CDS_Dossier.EmptyDataSet();
    CDS_Dossier.Append();
    CDS_Dossier.FieldByName('DOSS_ID').AsInteger              := 1;
    CDS_Dossier.FieldByName('DOSS_DATABASE').AsString         := ExtractFileName(sChemin);
    CDS_Dossier.FieldByName('DOSS_CHEMIN').AsString           := sChemin;
    CDS_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger      := 0;
    CDS_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime  := 0;
    CDS_Dossier.Post();

    {$REGION 'Récupération des paramétres'}
    IniParametres := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
      if IniParametres.SectionExists('Parametres') then
      begin
        if not(FindCmdLineSwitch('HD')) then
          tHeureDebut                               := IniParametres.ReadTime('Parametres', 'HeureDebut', StrToTime('14:00'))
        else begin
          FindCmdLineSwitch('HD', sHeure);
          tHeureDebut                               := StrToTime(sHeure);
        end;

        if not(FindCmdLineSwitch('HF')) then
          tHeureFin                                 := IniParametres.ReadTime('Parametres', 'HeureFin', StrToTime('16:00'))
        else begin
          FindCmdLineSwitch('HF', sHeure);
          tHeureFin                                 := StrToTime(sHeure);
        end;

        inbThread                                   := IniParametres.ReadInteger('Parametres', 'NbThreads', 1);
        SetLength(ThsCalculStock, inbThread);
        IniParametres.ReadSectionValues('DossiersExclus', slListeExclus);
      end;
    finally
      IniParametres.Free();
    end;
    {$ENDREGION 'Récupération des paramétres'}

    Result := True;
    {$ENDREGION 'Fonctionnement avec une seule base de données client'}
  end
  else if FindCmdLineSwitch('LISTE') then
  begin
    {$REGION 'Fonctionnement avec un fichier de liste de bases de données client'}
    FindCmdLineSwitch('LISTE', sChemin);

    // Si le fichier de liste existe : on le charge
    if FileExists(sChemin) then
    begin
      tsListeBase   := TStringList.Create();

      try
        tsListeBase.LoadFromFile(sChemin);
        CDS_Dossier.EmptyDataSet();

        // Ajout des dossiers à la liste
        for i := 0 to tsListeBase.Count - 1 do
        begin
          CDS_Dossier.Append();
          CDS_Dossier.FieldByName('DOSS_ID').AsInteger              := Succ(i);
          CDS_Dossier.FieldByName('DOSS_DATABASE').AsString         := ExtractFileName(tsListeBase[i]);
          CDS_Dossier.FieldByName('DOSS_CHEMIN').AsString           := tsListeBase[i];
          CDS_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger      := 0;
          CDS_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime  := 0;
          CDS_Dossier.Post();
        end;

        {$REGION 'Récupération des paramétres'}
        IniParametres := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
        try
          if IniParametres.SectionExists('Parametres') then
          begin
            if not(FindCmdLineSwitch('HD')) then
              tHeureDebut                               := IniParametres.ReadTime('Parametres', 'HeureDebut', StrToTime('14:00'))
            else begin
              FindCmdLineSwitch('HD', sHeure);
              tHeureDebut                               := StrToTime(sHeure);
            end;

            if not(FindCmdLineSwitch('HF')) then
              tHeureFin                                 := IniParametres.ReadTime('Parametres', 'HeureFin', StrToTime('16:00'))
            else begin
              FindCmdLineSwitch('HF', sHeure);
              tHeureFin                                 := StrToTime(sHeure);
            end;

            inbThread                                   := IniParametres.ReadInteger('Parametres', 'NbThreads', 1);
            SetLength(ThsCalculStock, inbThread);
            IniParametres.ReadSectionValues('DossiersExclus', slListeExclus);
          end;
        finally
          IniParametres.Free();
        end;
        {$ENDREGION 'Récupération des paramétres'}

        Result := True;
      finally
        tsListeBase.Free();
      end;
    end;
    {$ENDREGION 'Fonctionnement avec un fichier de liste de bases de données client'}
  end
  else
  begin
    {$REGION 'Connexion à la base de données de maintenance'}
    IniParametres := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    try
      if IniParametres.SectionExists('Parametres') then
      begin
        if IBDB_Maintenance.Connected then
          IBDB_Maintenance.Close();
        IBDB_Maintenance.DatabaseName               := IniParametres.ReadString('Parametres', 'Chemin', 'D:\Eai\Maintenance.ib');
        IBDB_Maintenance.Params.Values['user_name'] := IniParametres.ReadString('Parametres', 'Utilisateur', 'ginkoia');
        IBDB_Maintenance.Params.Values['password']  := IniParametres.ReadString('Parametres', 'MotPasse', 'ginkoia');

        if not(FindCmdLineSwitch('HD')) then
          tHeureDebut                               := IniParametres.ReadTime('Parametres', 'HeureDebut', StrToTime('14:00'))
        else begin
          FindCmdLineSwitch('HD', sHeure);
          tHeureDebut                               := StrToTime(sHeure);
        end;

        if not(FindCmdLineSwitch('HF')) then
          tHeureFin                                 := IniParametres.ReadTime('Parametres', 'HeureFin', StrToTime('16:00'))
        else begin
          FindCmdLineSwitch('HF', sHeure);
          tHeureFin                                 := StrToTime(sHeure);
        end;

        inbThread                                   := IniParametres.ReadInteger('Parametres', 'NbThreads', 1);
        SetLength(ThsCalculStock, inbThread);
        IniParametres.ReadSectionValues('DossiersExclus', slListeExclus);
        IBDB_Maintenance.Open();
        if IBDB_Maintenance.Connected then
        begin
          IBTbl_Dossier.Open();
          {$REGION 'Récupération de la liste des dossiers'}
          if IBTbl_Dossier.Active then
          begin
            try
              CDS_Dossier.EmptyDataSet();

              IBTbl_Dossier.First();
              while not(IBTbl_Dossier.Eof) do
              begin
                CDS_Dossier.Append();
                CDS_Dossier.FieldByName('DOSS_ID').AsInteger              := IBTbl_Dossier.FieldByName('DOSS_ID').AsInteger;
                CDS_Dossier.FieldByName('DOSS_DATABASE').AsString         := IBTbl_Dossier.FieldByName('DOSS_DATABASE').AsString;
                CDS_Dossier.FieldByName('DOSS_CHEMIN').AsString           := IBTbl_Dossier.FieldByName('DOSS_CHEMIN').AsString;
                CDS_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger      := IBTbl_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger;
                CDS_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime  := IBTbl_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime;
                CDS_Dossier.Post();
                IBTbl_Dossier.Next();
              end;
            finally
              Result := IBTbl_Dossier.Active;
              IBTbl_Dossier.Close();
              IBDB_Maintenance.Close();
            end;
          end;
          {$ENDREGION 'Récupération de la liste des dossiers'}

        end;
      end;
    finally
      IniParametres.Free();
    end;
    {$ENDREGION 'Connexion à la base de données de maintenance'}
  end;

  {$REGION 'Récupération des paramétres pour les courriels'}
  IniParametres := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    EnvoyerSMTP         := IniParametres.ReadBool('SMTP', 'Envoyer', CONST_SMTP_ENVOYER);
    HoteSMTP            := IniParametres.ReadString('SMTP', 'Serveur', CONST_SMTP_SERVEUR);
    UtilisateurSMTP     := IniParametres.ReadString('SMTP', 'Utilisateur', CONST_SMTP_UTILISATEUR);
    MotPasseSMTP        := IniParametres.ReadString('SMTP', 'MotPasse', CONST_SMTP_MOTPASSE);
    PortSMTP            := IniParametres.ReadInteger('SMTP', 'Port', CONST_SMTP_PORT);
    TLSSMTP             := IniParametres.ReadBool('SMTP', 'TLS', CONST_SMTP_TLS);
    ExpediteurSMTP      := IniParametres.ReadString('SMTP', 'Expediteur', CONST_SMTP_EXPEDITEUR);
    DestinatairesSMTP   := IniParametres.ReadString('SMTP', 'Destinataire', CONST_SMTP_DESTINATAIRE);
  finally
    IniParametres.Free();
  end;
  {$ENDREGION 'Récupération des paramétres pour les courriels'}
end;

procedure TDm_Main.ChargerListeBases();
var
  i, j: Integer;
begin
  // Parcours la liste des dossiers
  CDS_Dossier.First();

  SetLength(BasesClient, 0);
  i := 0;

  while not(CDS_Dossier.Eof) do
  begin
    SetLength(BasesClient, Succ(i));
    BasesClient[i].Id             := CDS_Dossier.FieldByName('DOSS_ID').AsInteger;
    BasesClient[i].Nom            := CDS_Dossier.FieldByName('DOSS_DATABASE').AsString;
    BasesClient[i].Chemin         := CDS_Dossier.FieldByName('DOSS_CHEMIN').AsString;
    BasesClient[i].TempsMoyen     := CDS_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger;
    BasesClient[i].DerniereDate   := CDS_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime;
    BasesClient[i].Utilisable     := True;
    BasesClient[i].ThreadId       := -1;

    for j := 0 to slListeExclus.Count - 1 do
    begin
      if SameText(slListeExclus.ValueFromIndex[j], BasesClient[i].Nom) then
      begin
        BasesClient[i].Utilisable   := False;
        Break;
      end;
    end;

    CDS_Dossier.Next();
    Inc(i);
  end;
end;

// Enregistrement des modifications sur un dossier
function TDm_Main.EnregistrerDossier(ADossId: Integer): Boolean;
begin
  Result := False;

  if not(FindCmdLineSwitch('BASE') or FindCmdLineSwitch('LISTE')) then
  begin
    try
      if IBTbl_Dossier.Active then
        IBTbl_Dossier.Close();
      IBTbl_Dossier.Open();

      // Localise le dossier dans le ClientDataSet
      if CDS_Dossier.Locate('DOSS_ID', ADossId, []) then
      begin
        // Localise le dossier dans la base maintenance
        if IBTbl_Dossier.Locate('DOSS_ID', ADossId, []) then
        begin
          IBTbl_Dossier.Edit();
          IBTbl_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger      := CDS_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger;
          IBTbl_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime  := CDS_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime;
          IBTbl_Dossier.Post();
          Result := True;
        end;
        Result := True;
      end;
    finally
      IBTbl_Dossier.Close();
      IBDB_Maintenance.Close();
    end;
  end
  else
    Result := True;
end;

function TDm_Main.EnregistrerTousLesDossier: Boolean;
begin
  Result := False;

  if not(FindCmdLineSwitch('BASE') or FindCmdLineSwitch('LISTE')) then
  begin
    try
      CDS_Dossier.First();
      while not CDS_Dossier.eof do
      begin
        IbQ_UpdateDossier.Close;
        IbQ_UpdateDossier.ParamByName('DOSS_RECALTEMPS').AsInteger := CDS_Dossier.FieldByName('DOSS_RECALTEMPS').AsInteger;
        IbQ_UpdateDossier.ParamByName('DOSS_RECALLASTDATE').AsDateTime := CDS_Dossier.FieldByName('DOSS_RECALLASTDATE').AsDateTime;
        IbQ_UpdateDossier.ParamByName('ID').AsInteger := CDS_Dossier.FieldByName('DOSS_ID').AsInteger;
        IbQ_UpdateDossier.ExecSQL;
        CDS_Dossier.Next();
      end;
      Result := True;
    finally
      IBTbl_Dossier.Close();
      IBDB_Maintenance.Close();
    end;
  end
  else
    Result := True;
end;

// Envoi le rapport par courriel
procedure TDm_Main.EnvoiCourriel();
var
  ThsEnvoiCourriel: TThreadEnvoiCourriel;
begin
  {$REGION 'Exécution du thread d’envoi du courriel'}
  ThsEnvoiCourriel                := TThreadEnvoiCourriel.Create(True);
  ThsEnvoiCourriel.Hote           := HoteSMTP;
  ThsEnvoiCourriel.Utilisateur    := UtilisateurSMTP;
  ThsEnvoiCourriel.MotPasse       := MotPasseSMTP;
  ThsEnvoiCourriel.Port           := PortSMTP;
  ThsEnvoiCourriel.TLS            := TLSSMTP;
  ThsEnvoiCourriel.Expediteur     := ExpediteurSMTP;
  ThsEnvoiCourriel.Destinataires  := DestinatairesSMTP;
  ThsEnvoiCourriel.Objet          := ObjetSMTP;
  ThsEnvoiCourriel.Contenu        := ContenuSMTP;
  ThsEnvoiCourriel.OnTerminate    := FinCourriel;
  ThsEnvoiCourriel.Start();
  {$ENDREGION 'Exécution du thread d’envoi du courriel'}
end;

// Procédure exécuté à la fin de l'envoi du courriel
procedure TDm_Main.FinCourriel(Sender: TObject);
begin
  // Enregistre la fin de l'envoi du courriel dans le Logs
  if not(TThreadEnvoiCourriel(Sender).Erreur) then
    Frm_Main.MessLog(Format(RS_INFO_COURRIEL, [TThreadEnvoiCourriel(Sender).Destinataires]))
  else
    Frm_Main.MessLog(Format(RS_ERR_COURRIEL, [TThreadEnvoiCourriel(Sender).Destinataires]));
end;

procedure TDm_Main.DataModuleCreate(Sender: TObject);
begin
  slListeExclus := TStringList.Create();
end;

procedure TDm_Main.DataModuleDestroy(Sender: TObject);
begin
  slListeExclus.Free();
end;

end.
