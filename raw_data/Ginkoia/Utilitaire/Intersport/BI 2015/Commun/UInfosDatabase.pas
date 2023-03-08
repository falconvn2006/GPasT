unit UInfosDatabase;

interface

uses
  System.Classes,
  System.Generics.Collections;

type
  TMagasin = class(Tobject)
  protected
    FMagId : integer;
    FCodeAdh : string;
    FGUID : string;
    FBaseSender : string;
    FActif : boolean;
    FDateInit : TDateTime;
  public
    constructor Create(MagId : integer; CodeAdh, GUID, BaseSender : string; Actif : boolean; DateInit : TDateTime);
    property MagId : integer read FMagId;
    property CodeAdh : string read FCodeAdh;
    property GUID : string read FGUID;
    property BaseSender : string read FBaseSender;
    property Actif : boolean read FActif write FActif;
    property DateInit : TDateTime read FDateInit;
  end;
  TListMagasin = TObjectList<TMagasin>;

function GetBaseGinkoia() : string;
function GetBaseTampon(DataFile, Login, Password : string) : string;
function GetDatabaseInfos(DataFile, Login, Password : string; out Dossier, GUID : string; out TrtInterval : integer; out RappAuto : boolean; var ListMag : TListMagasin) : boolean;

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  System.Win.Registry,
  FireDAC.Comp.Client,
  uGestionBDD;

function GetBaseGinkoia() : string;
var
  Reg : TRegistry;
begin
  Result := '';

  try
    Reg := TRegistry.Create(KEY_READ);
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('\Software\Algol\Ginkoia\') then
    begin
      if FileExists(Reg.ReadString('Base0')) then
        Result := Reg.ReadString('Base0');
    end;
  finally
    FreeAndNil(Reg);
  end;
end;

function GetBaseTampon(DataFile, Login, Password : string) : string;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
begin
  Result := '';

  if not (Trim(DataFile) = '') and FileExists(DataFile) then
  begin
    try
      Connexion := GetNewConnexion(DataFile, Login, Password, false);
      Transaction := GetNewTransaction(Connexion, false);
      Query := GetNewQuery(Connexion, Transaction);
      try
        Transaction.StartTransaction();
        try
          Query.SQL.Text := 'select prm_string, count(*) '
                          + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                          + 'where prm_type = 25 and prm_code = 5 '
                          + '  and prm_string != '''' '
                          + '  and prm_magid in ('
                          + '    select prm_magid '
                          + '    from genparam join k on k_id = prm_id and k_enabled = 1 '
                          + '    where prm_type = 25 and prm_code = 2 and prm_integer in ( '
                          + '      select bas_id from genbases where bas_ident in ( '
                          + '        select par_string from genparambase where par_nom = ''IDGENERATEUR'' '
                          + '                   ))) '
                          + 'group by prm_string '
                          + 'order by 2;';
          try
            Query.Open();
            if Query.RecordCount > 1 then
              Raise Exception.Create('Plusieur chemin de base tampon !!')
            else if Query.Eof then
              Raise Exception.Create('Pas de base tampon !')
            else
              Result := Query.FieldByName('prm_string').AsString;
          finally
            Query.Close();
          end;
        except
          on e : Exception do
            Result := '';
        end;
      finally
        Transaction.Rollback();
      end;
    finally
      FreeAndNil(Query);
      FreeAndNil(Transaction);
      FreeAndNil(Connexion);
    end;
  end;
end;

function GetDatabaseInfos(DataFile, Login, Password : string; out Dossier, GUID : string; out TrtInterval : integer; out RappAuto : boolean; var ListMag : TListMagasin) : boolean;
var
  Connexion : TFDConnection;
  Transaction : TFDTransaction;
  Query : TFDQuery;
  basid : integer;
  Sender : string;
begin
  Result := false;
  Dossier := '';
  GUID := '';
  Sender := '';
  TrtInterval := 15; // en minutes
  if Assigned(ListMag) then
    ListMag.Clear()
  else
    ListMag := TListMagasin.Create(true);

  try
    Connexion := GetNewConnexion(DataFile, Login, Password, false);
    Transaction := GetNewTransaction(Connexion, false);
    Query := GetNewQuery(Connexion, Transaction);
    try
      Transaction.StartTransaction();
      try
        // recup du nom de dossier
        Query.SQL.Text := 'select bas_nompournous, count(*) '
                        + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                        + 'where bas_nompournous != '''' '
                        + 'group by bas_nompournous '
                        + 'order by 2 desc '
                        + 'rows 1;';
        try
          Query.Open();
          if not Query.Eof then
            Dossier := Query.FieldByName('bas_nompournous').AsString
          else
            Exit;
        finally
          Query.Close();
        end;

        // recup du bas_sender
        Query.SQL.Text := 'select bas_id, bas_sender, bas_guid '
                        + 'from genbases join k on k_id = bas_id and k_enabled = 1 '
                        + 'join genparambase on par_nom = ''IDGENERATEUR'' and par_string = bas_ident';
        try
          Query.Open();
          if not Query.Eof then
          begin
            basid := Query.FieldByName('bas_id').AsInteger;
            Sender := Query.FieldByName('bas_sender').AsString;
            GUID := Query.FieldByName('bas_guid').AsString;
          end
          else
            Exit;
        finally
          Query.Close();
        end;

        // recup du Timer
        Query.SQL.Text := 'select prm_integer '
                        + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                        + 'where prm_type = 25 and prm_code = 3;';
        try
          Query.Open();
          if not Query.Eof then
            TrtInterval := Query.FieldByName('prm_integer').AsInteger
          else
            Exit;
        finally
          Query.Close();
        end;

        // recup du Rapprochement
        Query.SQL.Text := 'select prm_integer '
                        + 'from genparam join k on k_id = prm_id and k_enabled = 1 '
                        + 'where prm_type = 25 and prm_code = 8;';
        try
          Query.Open();
          if not Query.Eof then
            RappAuto := (Query.FieldByName('prm_integer').AsInteger = basid)
          else
            RappAuto := false;
        finally
          Query.Close();
        end;

        // recup des magasins
        Query.SQL.Text := 'select mag_id, mag_codeadh, prmactif.prm_integer as actif, prmactif.prm_float as dateinit '
                        + 'from genmagasin join k on k_id = mag_id and k_enabled = 1 '
                        + 'join genparam prmafect join k on k_id = prmafect.prm_id and k_enabled = 1 on prmafect.prm_type = 25 and prmafect.prm_code = 2 and prmafect.prm_magid = mag_id '
                        + 'join genparam prmactif join k on k_id = prmactif.prm_id and k_enabled = 1 on prmactif.prm_type = 25 and prmactif.prm_code = 1 and prmactif.prm_magid = mag_id '
                        + 'where prmafect.prm_integer = ' + IntToStr(basid) + ';';
        try
          Query.Open();
          if not Query.Eof then
          begin
            while not Query.Eof do
            begin
              ListMag.Add(TMagasin.Create(Query.FieldByName('mag_id').AsInteger,
                                          Query.FieldByName('mag_codeadh').AsString,
                                          guid,
                                          Sender,
                                          (Query.FieldByName('actif').AsInteger = 1),
                                          TDateTime(Query.FieldByName('dateinit').AsFloat)));
              Query.Next;
            end;
          end
          else
            Exit;
        finally
          Query.Close();
        end;

        // ici ??
        Result := ListMag.Count > 0;
      except
        on e : Exception do
        begin
          Result := false;
        end;
      end;
    finally
      Transaction.Rollback();
    end;
  finally
    FreeAndNil(Query);
    FreeAndNil(Transaction);
    FreeAndNil(Connexion);
  end;
end;

{ TMagasin }

constructor TMagasin.Create(MagId : integer; CodeAdh, GUID, BaseSender : string; Actif : boolean; DateInit : TDateTime);
begin
  Inherited Create();
  FMagId := MagId;
  FCodeAdh := CodeAdh;
  FGUID := GUID;
  FBaseSender := BaseSender;
  FActif := Actif;
  FDateInit := DateInit;
end;

end.
