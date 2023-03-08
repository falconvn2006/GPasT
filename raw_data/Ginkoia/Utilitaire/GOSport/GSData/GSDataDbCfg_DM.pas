unit GSDataDbCfg_DM;

interface

uses
  SysUtils, Classes, Dialogs, GSDataCFG_Frm, IB_Components, IBODataset,
  IB_Access, Forms, Controls, GSData_Types, DB, IBServices,
  DBClient, Provider;

type
  TDM_GsDataDbCfg = class(TDataModule)
    IboDbCfg: TIBODatabase;
    Ibo_TCfg: TIBOTransaction;
    Que_Dossiers: TIBOQuery;
    Que_Horaire: TIBOQuery;
    Que_Fichier: TIBOQuery;
    Que_Magasin: TIBOQuery;
    Que_GoSport_ReUsable: TIBOQuery;
    Ibo_TMAJ: TIBOTransaction;
    Que_MAJ: TIBOQuery;
    IBServerProperties: TIBServerProperties;
    cds_Dossiers: TClientDataSet;
    cds_Horaire: TClientDataSet;
    cds_Magasin: TClientDataSet;
    cds_Fichier: TClientDataSet;
    cds_HorFic: TClientDataSet;
    Que_HorFic: TIBOQuery;
    Que_SelectedFiles: TIBOQuery;
    cds_SelectedFiles: TClientDataSet;
    procedure cds_DossiersAfterScroll(DataSet: TDataSet);
    procedure cds_HoraireAfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
    // Flag permettant de savoir si les ClientDataSet ont été chargé au moins une fois...
    FLoadInMemoryFirstAttempt: Boolean;
  public
    { Déclarations publiques }
    Function ConnectToDbCfg(APath : String) : Boolean;

    function ShowModalCFG: Integer;

    function SeekNextHoraireFor(heure, last : TDateTime; MinBetween : integer) : TDateTime;
    function GetDateLastTrtMag(idmag, idhof : integer) : TDate;
    function GetLastNumFileMag(idmag, idfic : integer) : integer;

    Procedure WaitService;
  end;

  TClientDataSetHelper = class helper for TClientDataSet
    procedure ChangeFilter(const Filter: String = ''); overload;
    procedure ChangeFilter(const Format: String; const Args: array of const); overload;
    procedure LoadFromDataSet(const IBODataset: TIBODataset);
    procedure LoadFromSQL(const IBODatabase: TIBODatabase;
      const SQL: string); overload;
  end;

var
  DM_GsDataDbCfg: TDM_GsDataDbCfg;

implementation

uses
  DateUtils;

{$R *.dfm}

{ TDataModule2 }

procedure TDM_GsDataDbCfg.cds_DossiersAfterScroll(DataSet: TDataSet);
begin
  if not cds_Magasin.Active then
    exit;
  cds_Magasin.ChangeFilter( 'mag_dosid = %d', [ DataSet.FieldByName( 'dos_id' ).AsInteger ] );
end;

procedure TDM_GsDataDbCfg.cds_HoraireAfterScroll(DataSet: TDataSet);
  procedure UpdateFichier;
  begin
    cds_Fichier.DisableControls;
    cds_Fichier.ReadOnly := False;
    try
      cds_Fichier.First;
      while not cds_Fichier.Eof do
      begin 
        cds_Fichier.Edit; 
        if cds_HorFic.Locate( 'hof_ficid', cds_Fichier.FieldByName( 'fic_id' ).AsVariant, [] ) then
        begin                                                                                                  
          cds_Fichier.FieldByName( 'hof_id' ).AsVariant := cds_HorFic.FieldByName( 'hof_id' ).AsVariant;
          cds_Fichier.FieldByName( 'hof_horid' ).AsVariant := cds_HorFic.FieldByName( 'hof_horid' ).AsVariant; 
        end
        else begin
          cds_Fichier.FieldByName( 'hof_id' ).Clear;
          cds_Fichier.FieldByName( 'hof_horid' ).Clear;
        end;
        cds_Fichier.Post;
        cds_Fichier.Next;        
      end;
      cds_Fichier.First
    finally
      cds_Fichier.ReadOnly := True;
      cds_Fichier.EnableControls;
    end;
  end;
begin
  if not cds_Fichier.Active then
    exit;
  cds_HorFic.ChangeFilter( 'hof_horid = %d', [ DataSet.FieldByName( 'hor_id' ).AsInteger ] );
  UpdateFichier;
end;

function TDM_GsDataDbCfg.ConnectToDbCfg(APath: String): Boolean;
begin
  Result := False;

  WaitService;

  if Trim(APath) = '' then
  begin
    showmessage('Veuillez configurer la base de données de configuration');
    if ShowModalCFG = mrOk then
    begin
      Result := ConnectToDbCfg(IniStruct.BasePath);
    end;
    Exit;
  end;

  IboDbCfg.Disconnect;
  IboDbCfg.DatabaseName := AnsiString(APath);
  Try  
    try
      IboDbCfg.Connect;
      Result := IboDbCfg.Connected;
      
      cds_Magasin.LoadFromDataSet( Que_Magasin ); {detail}     
      cds_Dossiers.LoadFromDataSet( Que_Dossiers ); {master} 
      cds_Fichier.LoadFromDataSet( Que_Fichier ); {detail}  
      cds_HorFic.LoadFromDataSet( Que_HorFic ); {detail}  
      cds_Horaire.LoadFromDataSet( Que_Horaire ); {master}  
      FLoadInMemoryFirstAttempt := False;
    finally
      IboDbCfg.Disconnect;
    end;
  Except     
    on E:Exception do 
    begin
      if ( MessageDlg( 'Erreur de connexion à la base de données.'#$D#$A'GSData va maintenant se fermer.', mtError, [ mbOK ], 0, mbOK ) = mrOK )
      and FLoadInMemoryFirstAttempt then
        Application.Terminate;
    end;
  End;
end;

procedure TDM_GsDataDbCfg.DataModuleCreate(Sender: TObject);
begin
  FLoadInMemoryFirstAttempt := True;
end;

function TDM_GsDataDbCfg.ShowModalCFG: Integer;
begin
  With Tfrm_GSDataCfg.Create(nil) do
  try
    BorderStyle := bsSingle;
    Parent := nil;
    Result := ShowModal;
  finally
    Release;
  end;
end;

procedure TDM_GsDataDbCfg.WaitService;
var
  bConnexion : Boolean;
begin
  bConnexion := False;
  With IBServerProperties do
    while not bConnexion do
    begin
      try
        Active := True;
        bConnexion := True;
      except on E: Exception do
        begin
          Sleep(5000);
        end;
      end;
    end;
end;

function TDM_GsDataDbCfg.SeekNextHoraireFor(heure, last : TDateTime; MinBetween : integer) : TDateTime;
var
  tmp : TDateTime;
begin
  if cds_Horaire.Active then
  begin
    tmp := Frac(heure);
    Result := heure;

    if (tmp >= cds_Horaire.FieldByName('hor_hdeb').AsDateTime) and (tmp < cds_Horaire.FieldByName('hor_hfin').AsDateTime) then
    begin
      // Dans cette plage horaire !
      if IncMinute(last, MinBetween) > Result then
        Result := IncMinute(GSTARTTIME, IniStruct.Others.Timer);
      if Frac(Result) > cds_Horaire.FieldByName('hor_hfin').AsDateTime then
        cds_Horaire.Next
      else
        Exit;
    end
    else
    begin
      // recherche de la plage horaire qui vas bien !
      cds_Horaire.First;
      while not (cds_Horaire.Eof or (Frac(cds_Horaire.FieldByName('hor_hdeb').AsDateTime) > Frac(tmp))) do
      begin
        if (tmp >= cds_Horaire.FieldByName('hor_hdeb').AsDateTime) and (tmp < cds_Horaire.FieldByName('hor_hfin').AsDateTime) then
        begin
          if IncMinute(last, MinBetween) > Result then
            Result := IncMinute(last, IniStruct.Others.Timer);
          if Frac(Result) > cds_Horaire.FieldByName('hor_hfin').AsDateTime then
            cds_Horaire.Next
          else
            Exit;
        end
        else
          cds_Horaire.Next;
      end;
    end;

    // si aucune plage horaire trouver, alors demain !
    if cds_Horaire.Eof then
    begin
      cds_Horaire.First;
      Result := IncDay(Result);
    end;

    // avec les X minutes de decalage svp
    Result := Trunc(Result) + cds_Horaire.FieldByName('hor_hdeb').AsDateTime;
    if IncMinute(last, MinBetween) > Result then
      Result := IncMinute(last, IniStruct.Others.Timer);
  end
  else
    Result := 0;
end;

function TDM_GsDataDbCfg.GetDateLastTrtMag(idmag, idhof : integer) : TDate;
begin
  Result := 0;
  try
    Que_GoSport_ReUsable.SQL.Text := 'select max(mhf_datetrt) as datetrt '
                                   + 'from maghorfic '
                                   + 'where  mhf_magid= :idmag and mhf_hofid = :idhof;';
    Que_GoSport_ReUsable.ParamCheck := true;
    Que_GoSport_ReUsable.ParamByName('idmag').AsInteger := idmag;
    Que_GoSport_ReUsable.ParamByName('idhof').AsInteger := idhof;
    Que_GoSport_ReUsable.Open();
    if not Que_GoSport_ReUsable.Eof then
      Result := Que_GoSport_ReUsable.FieldByName('datetrt').AsDateTime;
  finally
    Que_GoSport_ReUsable.Close();
  end;
end;

function TDM_GsDataDbCfg.GetLastNumFileMag(idmag, idfic : integer) : integer;
begin
  Result := 0;
  try
    Que_GoSport_ReUsable.SQL.Text := 'select hmf_lastnum '
                                   + 'from histomagfic   '
                                   + 'where hmf_magid = :idmag and hmf_ficid = :idfic;';
    Que_GoSport_ReUsable.ParamCheck := true;
    Que_GoSport_ReUsable.ParamByName('idmag').AsInteger := idmag;
    Que_GoSport_ReUsable.ParamByName('idfic').AsInteger := idfic;
    Que_GoSport_ReUsable.Open();
    if not Que_GoSport_ReUsable.Eof then
      Result := Que_GoSport_ReUsable.FieldByName('hmf_lastnum').AsInteger;
  finally
    Que_GoSport_ReUsable.Close();
  end;
end;

{ TClientDataSetHelper }

procedure TClientDataSetHelper.ChangeFilter(const Filter: String);
begin
  Self.DisableControls;
  try
    Self.Filtered := False;
    Self.Filter := Filter;
    Self.Filtered := Filter <> '';
  finally
    if Self.Active then
      Self.First;
    Self.EnableControls;
  end;
end;

procedure TClientDataSetHelper.ChangeFilter(const Format: String;
  const Args: array of const);
begin
  ChangeFilter( SysUtils.Format( Format, Args ) );
end;

procedure TClientDataSetHelper.LoadFromDataSet(const IBODataset: TIBODataset);
  procedure RaiseError(const DataSet: TDataSet; const Error: String);
  begin
    if Assigned( DataSet ) and ( not SameText( '', DataSet.Name ) ) then
      raise Exception.CreateFmt( '%s: %s', [ DataSet.Name, Error ] )
    else
      raise Exception.CreateFmt( 'DataSet: %s', [ Error ] );
  end;
var
  DataSetProvider: TDataSetProvider;
  Connected: Boolean;
begin
  try
    if not Assigned( IBODataset ) then
      RaiseError( IBODataset, 'non défini' );
    Self.DisableControls;
    try
      // Récupération de l'état de la connexion
      Connected := IBODataset.IB_Connection.Connected;    
      try
        if not Connected then
          IBODataset.IB_Connection.Connect;  
        // Rafraichissement du DataSet
        IBODataset.Close;
        IBODataset.Open;
      except
        RaiseError( IBODataset, 'erreur lors de la mise à jour' );
      end;
      // Définition du provider pour chargement des données
      DataSetProvider := TDataSetProvider.Create( nil );
      try
        try
          DataSetProvider.DataSet := IBODataset;
          Self.ChangeFilter( '' );
          Self.Close;
          Self.SetProvider( DataSetProvider );
          Self.Open;
          Self.LogChanges := False;// Fix: Bug MDC
          Self.SetProvider( nil );
        except
          RaiseError( Self, 'erreur lors du chargement du dataset' );
        end;
      finally
        FreeAndNil( DataSetProvider );
      end;
    finally
      // Restauration de l'état de la connexion
      if not Connected then
        IBODataset.IB_Connection.Disconnect;        
      if Self.Active then
        Self.First;
      Self.EnableControls;
    end;
  except
    on E: Exception do
      raise Exception.CreateFmt( 'LoadFromDataSet -> %s', [ E.Message ] );
  end;
end;

procedure TClientDataSetHelper.LoadFromSQL(const IBODatabase: TIBODatabase;
  const SQL: string);
var
  IBODataset: TIBODataset;
begin
  IBODataset := TIBODataset.Create( nil );
  try
    IBODataset.IB_Connection := IBODatabase;
    IBODataset.SQL.Text := SQL;
    LoadFromDataSet( IBODataset );
  finally
    IBODataset.Free;
  end;
end;

end.
