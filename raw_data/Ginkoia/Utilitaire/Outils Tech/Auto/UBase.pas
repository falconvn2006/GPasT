unit UBase;

interface

uses
   Upost, Uinternet, filectrl,
   Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ComCtrls, Db, IBCustomDataSet, IBQuery, IBSQL, IBDatabase, uLogfile;

type
  TOnNotifyPoste = procedure (Sender: TObject; Poste: string) of object;
  TOnNotifyMagasin = procedure (Sender: TObject; Magasin: string) of object;
  TOnNotifyBase = procedure (Sender: TObject; bas_id: integer; base_nom:
      string) of object;
  TActionProgress = procedure (Sender: TObject; Action: string; actu, max:
      Integer) of object;
  TBase = class(TObject)
  protected
    Data: TIBDatabase;
    fOwner: TComponent;
    Qry: TIBQuery;
    SQL: TIBSQL;
    Tran: TIBTransaction;
  public
    constructor Create(Owner: TComponent); virtual;
    destructor Destroy; override;
    procedure Commit;
    procedure Connexion(AQuoi: string; Master: Boolean = False);
    procedure Ferme;
    function NewQry(_tran:TIBTransaction = Nil): TIBQuery;
    function NewTran: TIBTransaction;
    procedure RollBack;
  end;

  TBaseGinkoia = class(TBase)
  protected
    FOnNotifyBase: TOnNotifyBase;
    FOnNotifyMagasin: TOnNotifyMagasin;
    FOnNotifyPoste: TOnNotifyPoste;
  public
    function BaseEnCours: string;
    function GuID: string;
    procedure ListeBases;
    procedure ListeMagasin;
    procedure ListePoste(Magasin: string);
    function VersionEnCours: string;
    property OnNotifyBase: TOnNotifyBase read FOnNotifyBase write FOnNotifyBase;
    property OnNotifyMagasin: TOnNotifyMagasin read FOnNotifyMagasin write
        FOnNotifyMagasin;
    property OnNotifyPoste: TOnNotifyPoste read FOnNotifyPoste write
        FOnNotifyPoste;
  end;

  TBaseTest = class(TBaseGinkoia)
  protected
    procedure CopieBase(disk: char);
    procedure Creation_SM_BASE_TEST;
  public
    procedure Creation(disk: char = 'C');
  end;

  TPatchScript = class(TBaseGinkoia)
  private
    FDirGinkoia: String;
    FDirBase: String;
    FLame: String;
  protected
    FActionProgress: TActionProgress;
    _Message: string;
    procedure DoActionProgress(Quoi: string; Min, max: Integer);
    procedure DoProgress(Sender: TObject; Actuel: Integer; Maximum: Integer);
    procedure DoScript(s: string);
  published
  public
    procedure Patch;
    procedure Script;
    property ActionProgress: TActionProgress read FActionProgress write
        FActionProgress;

    property DirGinkoia : String read FDirGinkoia write FDirGinkoia;
    property DirBase : String read FDirBase write FDirBase;
    property Lame : String read FLame write FLame;
  end;


implementation

constructor TBase.Create(Owner: TComponent);
begin
  inherited Create;
  fOwner := Owner;
  Data := TIBDatabase.Create(Owner);
  Tran := TIBTransaction.Create(Owner);
  Tran.DefaultDatabase := Data;
  Data.SQLDialect := 3;
  Data.LoginPrompt := false;
  data.DefaultTransaction := Tran;
  SQL := TIBSQL.Create(Owner);
  Sql.Database := data;
  Sql.Transaction := tran;
  Qry := TIBQuery.Create(Owner);
  Qry.Database := data;
  Qry.Transaction := tran;
end;

destructor TBase.Destroy;
begin
  Qry.free;
  SQL.free;
  Tran.free;
  Data.free;
  inherited;
end;

procedure TBase.Commit;
begin
  if tran.Active and tran.InTransaction then
  begin
     tran.commit;
     tran.active := true;
  end;
end;

procedure TBase.Connexion(AQuoi: string; Master: Boolean = False);
begin
  data.Close ;
(*
    if data.Connected then
    begin
       if Uppercase(data.DatabaseName) = UpperCase(Aquoi) then
       begin
          if Master and (data.Params.Values['user_name'] = 'sysdba') then
             exit
          else if not Master and (data.Params.Values['user_name'] = 'ginkoia') then
             EXIT;
       end;
       ferme;
    end;  
*)
  Tlogfile.Addline(Datetimetostr(Now)+' connexion à la base '+Aquoi);  
  if master then
  begin
     data.Params.Values['user_name'] := 'sysdba';
     data.Params.Values['password'] := 'masterkey';
  end
  else
  begin
     data.Params.Values['user_name'] := 'ginkoia';
     data.Params.Values['password'] := 'ginkoia';
  end;
  data.Close ;
  data.DatabaseName := AQuoi;
  Data.Open;
  tran.Active := true;
end;

procedure TBase.Ferme;
begin
  Data.Connected := false;
end;

function TBase.NewQry(_tran:TIBTransaction = Nil): TIBQuery;
begin
  result := TIBQuery.Create(fOwner);
  result.Database := data;
  IF _tran=nil then
    result.Transaction := tran
  else
    result.Transaction := _tran;
end;

function TBase.NewTran: TIBTransaction;
begin
  result := TIBTransaction.Create(fOwner);
  result.DefaultDatabase := Data;
end;

procedure TBase.RollBack;
begin
  if tran.Active and tran.InTransaction then
  begin
     tran.Rollback;
     tran.active := true;
  end;
end;

function TBaseGinkoia.BaseEnCours: string;
begin
  qry.sql.clear;
  qry.sql.add('select BAS_ID From GENBASES join k on(k_id=bas_id and k_enabled=1)');
  qry.sql.add('    Join genparambase on ( PAR_STRING= BAS_IDENT) ');
  qry.sql.add(' WHERE PAR_NOM = ''IDGENERATEUR''');
  qry.Open;
  result := qry.Fields[0].AsString;
  qry.close;
end;

function TBaseGinkoia.GuID: string;
var
  LaBase: string;
  Nb: Integer;
begin
  LaBase := BaseEnCours;
  qry.sql.clear;
  qry.sql.Add('select count(*) from kfld where kfld_name=''BAS_GUID''');
  qry.Open;
  nb := qry.fields[0].asInteger;
  qry.close;
  if nb > 0 then
  begin
     qry.sql.clear;
     qry.sql.Add('select BAS_GUID');
     qry.sql.Add('from GENBASES Join k on (k_id=bas_id and k_enabled=1)');
     qry.sql.Add('Where bas_id = ' + LaBase);
     qry.Open;
     result := qry.fields[0].AsString;
     qry.close;
  end
  else
  begin
     qry.sql.clear;
     qry.sql.Add('select GENPARAM.PRM_STRING ');
     qry.sql.Add('from GENPARAM join k on (k_id=prm_id and k_enabled=1)');
     qry.sql.Add('where PRM_type=9999');
     qry.sql.Add('  and prm_code=9999');
     qry.sql.Add('  and prm_magid=' + LaBase);
     qry.Open;
     result := qry.fields[0].AsString;
     qry.close;
  end;
end;

procedure TBaseGinkoia.ListeBases;
begin
  if not assigned(fOnNotifyBase) then EXIT;
  if not data.Connected then EXIT;
  qry.sql.clear;
  qry.sql.add('select BAS_ID, BAS_NOM') ;
  qry.sql.add('from GENBASES JOIN K ON (K_ID=BAS_ID AND K_ENABLED=1)') ;
  qry.sql.add('WHERE BAS_ID<>0') ;
  qry.Open;
  qry.First;
  while not qry.eof do
  begin
     OnNotifyBase(Self, qry.fields[0].AsInteger, qry.fields[1].AsString );
     qry.next;
  end;
  qry.close;
end;

procedure TBaseGinkoia.ListeMagasin;
begin
  if not assigned(FOnNotifyMagasin) then EXIT;
  if not data.Connected then EXIT;
  qry.sql.clear;
  qry.sql.add('Select MAG_NOM');
  qry.sql.add('from genmagasin join k on (k_id=mag_id and k_enabled=1)');
  qry.sql.add('where MAG_ID<>0');
  qry.Open;
  qry.First;
  while not qry.eof do
  begin
     OnNotifyMagasin(Self, qry.fields[0].AsString);
     qry.next;
  end;
  qry.close;
end;

procedure TBaseGinkoia.ListePoste(Magasin: string);
begin
  if not assigned(FOnNotifyPoste) then EXIT;
  if not data.Connected then EXIT;
  qry.sql.clear;
  qry.sql.add('Select POS_NOM');
  qry.sql.add('from genmagasin join k on (k_id=mag_id and k_enabled=1)');
  qry.sql.add('     join GenPoste join k on (k_id=POS_id and k_enabled=1)');
  qry.sql.add('     on (POS_MAGID=MAG_ID)');
  qry.sql.add('where POS_ID<>0');
  qry.sql.add('  and upper(MAG_NOM)=' + quotedStr(Magasin));
  qry.Open;
  qry.first;
  while not qry.Eof do
  begin
     OnNotifyPoste(self, qry.fields[0].AsString);
     qry.next;
  end;
  qry.close;
end;

function TBaseGinkoia.VersionEnCours: string;
begin
  Qry.sql.clear;
  Qry.sql.Add('select ver_version from genversion where Ver_date = ( select Max(Ver_date) from genversion )');
  Qry.Open;
  result := Qry.fields[0].AsString;
  Qry.close;
end;

procedure TBaseTest.CopieBase(disk: char);
begin
  CopyFile(Pchar(disk + ':\ginkoia\data\Ginkoia.IB'), Pchar(disk + ':\ginkoia\data\test.IB'), False);
end;

procedure TBaseTest.Creation(disk: char = 'C');
begin
  copieBase(disk);
  Connexion(disk + ':\ginkoia\data\test.IB', TRUE);
  // vérification de la présence de SM_BASE_TEST
  qry.sql.clear;
  qry.sql.Add('Select count(*)');
  qry.sql.Add('from rdb$procedures');
  qry.sql.Add('where rdb$procedure_name=''SM_BASE_TEST''');
  qry.open;
  if qry.fields[0].asInteger = 0 then
  begin
     qry.close;
     Creation_SM_BASE_TEST;
  end;
  qry.close;

  sql.SQL.Text := 'EXECUTE PROCEDURE SM_BASE_TEST';
  sql.ExecQuery;
  commit;
  Ferme;
end;

procedure TBaseTest.Creation_SM_BASE_TEST;
begin
  sql.sql.clear;
  sql.sql.add('CREATE PROCEDURE SM_BASE_TEST');
  sql.sql.add('AS');
  sql.sql.add('declare variable SOCID INTEGER;');
  sql.sql.add('declare variable MAGID INTEGER;');
  sql.sql.add('declare variable ADRID INTEGER;');
  sql.sql.add('declare variable UGGNOM varchar(128);');
  sql.sql.add('declare variable PERID INTEGER;');
  sql.sql.add('declare variable PERMISSION VARCHAR(64);');
  sql.sql.add('declare variable USRID INTEGER;');
  sql.sql.add('declare variable i INTEGER;');
  sql.sql.add('BEGIN');
  sql.sql.add('  UPDATE GenDossier SET Dos_String=''NON'' where dos_nom=''REPLICATION'';');
  sql.sql.add('  i=0;');
  sql.sql.add('  FOR select SOC_ID');
  sql.sql.add('  from gensociete');
  sql.sql.add('  where soc_id<>0');
  sql.sql.add('  INTO :SOCID');
  sql.sql.add('  DO');
  sql.sql.add('  BEGIN');
  sql.sql.add('    i=i+1;');
  sql.sql.add('    update gensociete set soc_nom=''SOCIETE''||:i,');
  sql.sql.add('    soc_forme='''',');
  sql.sql.add('    soc_ape=:i||''24W'',');
  sql.sql.add('    soc_rcs=''TEST ''||:i||''49 893 429 0005B11'',');
  sql.sql.add('    SOC_DIRIGEANT='''',');
  sql.sql.add('    SOC_PIEDFACTURE=''''');
  sql.sql.add('    where soc_id=:SOCID;');
  sql.sql.add('  END');
  sql.sql.add('  i=0;');
  sql.sql.add('  FOR select MAG_ID, MAG_ADRID');
  sql.sql.add('  from genmagasin');
  sql.sql.add('  where mag_id<>0');
  sql.sql.add('  INTO :MAGID, :ADRID');
  sql.sql.add('  DO');
  sql.sql.add('  BEGIN');
  sql.sql.add('    i=i+1;');
  sql.sql.add('    update genmagasin set mag_nom=''MAGASIN''||:i,');
  sql.sql.add('    mag_ident=''MAG''||:i,');
  sql.sql.add('    mag_identcourt=''MAG''||:i,');
  sql.sql.add('    mag_enseigne=''MAGASIN''||:i,');
  sql.sql.add('    mag_siret='''',');
  sql.sql.add('    mag_codeadh=''0000''||:i');
  sql.sql.add('    where mag_id=:MAGID;');
  sql.sql.add('    update genadresse set adr_vilid=0, adr_email='''' where adr_id=:ADRID;');
  sql.sql.add('    FOR SELECT UGG_NOM');
  sql.sql.add('    FROM uilgrpginkoia');
  sql.sql.add('    join k on (k_id=UGG_ID and k_enabled=1)');
  sql.sql.add('    Where UGG_ID<>0');
  sql.sql.add('    into :UGGNOM');
  sql.sql.add('    DO');
  sql.sql.add('    BEGIN');
  sql.sql.add('         execute procedure PR_GRPASSOCIEMAG(:MAGID,:UGGNOM,Null);');
  sql.sql.add('    END');
  sql.sql.add('  END');
  sql.sql.add('  delete from genlaunch where lau_id <>0;');
  sql.sql.add('  delete from genreplication where rep_id<>0;');
  sql.sql.add('  FOR select USR_ID');
  sql.sql.add('  FROM uilusers');
  sql.sql.add('  join k on (k_id=USR_id and k_enabled=1)');
  sql.sql.add('  where USR_ID<>0 and USR_ENABLED=1 and UPPER(USR_USERNAME)=''UTIL''');
  sql.sql.add('  into :USRID');
  sql.sql.add('  do');
  sql.sql.add('  begin');
  sql.sql.add('    update uilusers SET USR_PASSWORD=''util'' where USR_ID=:USRID;');
  sql.sql.add('    FOR select PER_ID, PER_PERMISSION');
  sql.sql.add('    FROM UILPERMISSIONS');
  sql.sql.add('    join k on (k_id=per_id and k_enabled=1)');
  sql.sql.add('    Where per_id<>0 and per_visible=0 and per_magasin=0 and');
  sql.sql.add('    not exists(select USA_ID FROM UILUSERACCESS');
  sql.sql.add('           join K K1 on (K1.K_ID=USA_ID and K1.K_ENABLED=1)');
  sql.sql.add('           WHERE USA_PERID=UILPERMISSIONS.PER_ID and USA_USRID=:USRID)');
  sql.sql.add('    into :PERID, :PERMISSION');
  sql.sql.add('    do');
  sql.sql.add('    begin');
  sql.sql.add('         insert into UILUSERACCESS (USA_ID,USA_USERNAME, USA_PERMISSION, USA_PERID, USA_USRID)');
  sql.sql.add('         select ID,''util'',:PERMISSION,:PERID,:USRID');
  sql.sql.add('         from PR_NEWK (''UILUSERACCESS'');');
  sql.sql.add('    end');
  sql.sql.add('  END');
  sql.sql.add('END');
  sql.ParamCheck := false;
  sql.ExecQuery;
  commit;
end;


{ TPatchScript }

procedure TPatchScript.DoActionProgress(Quoi: string; Min, max: Integer);
begin
  if assigned(fActionProgress) then
     ActionProgress(self, quoi, min, max);
end;

procedure TPatchScript.DoProgress(Sender: TObject; Actuel: Integer; Maximum:
    Integer);
begin
  DoActionProgress(_Message, Actuel, Maximum);
end;

procedure TPatchScript.DoScript(s: string);
begin
  try
     s := trim(s);
     SQL.SQL.Text := S;
     sql.ParamCheck := false;
     Sql.ExecQuery;
     Commit;
  except
     RollBack;
     if Copy(uppercase(S), 1, length('CREATE PROCEDURE')) = 'CREATE PROCEDURE' then
     begin
        delete(s, 1, 6);
        S := 'ALTER' + S;
        Sql.SQL.Text := S;
        Sql.ExecQuery;
        commit;
     end;
  //      else
  //         raise;
  end;
end;

procedure TPatchScript.Patch;
var
  LeGuID: string;
  Tc: Tconnexion;
  Tc_R: TstringList;
  i_fic: Integer;
  Tc_Fic: TstringList;
  idver: Integer;
  s: string;
  internet: TInternet;
  CRC: string;
  Crc32: TCrc32;
  repertoire: string;
  Fich: string;
  NomVer: string;
  Nomrecup: string;
begin
  DoActionProgress('Patch de l''application', 0, 1);
  LeGuID := GuID;
  if trim(LeGuID) <> '' then
  begin
     Tc := Tconnexion.create;
     Tc_R := tc.Select('Select * from version where version = "' + VersionEnCours + '"');
     if tc.recordCount(Tc_R) <> 0 then
     begin
        internet := Tinternet.create(fOwner);
        internet.OnProgress := DoProgress;
        idver := Strtoint(tc.UneValeur(tc_R, 'id'));
        NomVer := tc.UneValeur(tc_R, 'nomversion');
        tc.FreeResult(tc_R);
        tc_r := tc.select('select * from clients where clt_GUID="' + GUID + '"');
        Tc_Fic := tc.select('Select * from fichiers Where id_ver = ' + Inttostr(idver));
        ForceDirectories(FDirGinkoia +  'A_MAJ\');
        Crc32 := TCrc32.create;
        for i_fic := 0 to tc.recordCount(Tc_Fic) - 1 do
        begin
           DoActionProgress('vérification de ' + tc.UneValeur(Tc_Fic, 'fichier', i_fic), i_fic + 1, tc.recordCount(Tc_Fic));
           S := FDirGinkoia + tc.UneValeur(Tc_Fic, 'fichier', i_fic);
           CRC := IntToStr(crc32.FileCRC32(S));
           if CRC <> tc.UneValeur(Tc_Fic, 'crc', i_fic) then
           begin
              if FileExists(FDirGinkoia + 'A_MAJ\' + tc.UneValeur(Tc_Fic, 'fichier', i_fic)) then
                 CRC := IntToStr(crc32.FileCRC32(FDirGinkoia + 'A_MAJ\' + tc.UneValeur(Tc_Fic, 'fichier', i_fic)));
           end;
           if CRC <> tc.UneValeur(Tc_Fic, 'crc', i_fic) then
           begin
              _Message := 'récupération de ' + tc.UneValeur(Tc_Fic, 'fichier', i_fic);
              Fich := FDirGinkoia + 'A_MAJ\' + tc.UneValeur(Tc_Fic, 'fichier', i_fic);
              repertoire := IncludeTrailingBackslash(extractfilepath(Fich));
              ForceDirectories(repertoire);
              Nomrecup := internet.traitechaine(FLame {'http://lame2.no-ip.com/maj/'} + NomVer + '/' + tc.UneValeur(Tc_Fic, 'fichier', i_fic));
              internet.Download(Nomrecup, repertoire);
              CRC := IntToStr(crc32.FileCRC32(Fich));
              if CRC = tc.UneValeur(Tc_Fic, 'crc', i_fic) then
              begin
                 tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                    'values (' + tc.UneValeur(tc_r, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                    '3, "' + tc.UneValeur(Tc_Fic, 'fichier', i_fic) + '","OK","","")');
                 repertoire := IncludeTrailingBackslash(extractfilepath(FDirGinkoia + tc.UneValeur(Tc_Fic, 'fichier', i_fic)));
                 ForceDirectories(repertoire);
                 if CopyFile(Pchar(fich), Pchar(FDirGinkoia + tc.UneValeur(Tc_Fic, 'fichier', i_fic)), false) then
                    DeleteFile(fich);
              end
              else
              begin
                 deletefile(Fich);
              end;
           end;
        end;
        Crc32.free;
        tc.FreeResult(Tc_Fic);
        internet.free;
     end
     else
     begin
        application.MessageBox('Pas la bonne version ', ' Erreur', MB_OK);
     end;
     tc.FreeResult(Tc_R);
  end
  else
  begin
     application.MessageBox('Pas de GUID pour la base', ' Erreur', MB_OK);
  end;
end;

procedure TPatchScript.Script;
var
  VEnCours: string;
  LaBase: string;
  LeGuID: string;
  tc: Tconnexion;
  Tc_R: TstringList;
  Tc_C: TstringList;
  idver: Integer;
  Patch: Integer;
  NomVer: string;
  i: Integer;
  Internet: TInternet;
  fichier: string;
  tsl: tstringlist;
  s, s1: string;
begin
  DoActionProgress('Mise à jour de la base', 0, 1);
  LaBase := BaseEnCours;
  VEnCours := VersionEnCours;
  LeGuID := GuID;
  if trim(LeGuID) <> '' then
  begin
     DoActionProgress('Selection sur yellis', 0, 1);
     Tc := Tconnexion.create;
     Tc_C := tc.select('select * from clients where clt_GUID="' + GUID + '"');
     if tc.recordCount(Tc_C) <> 0 then
     begin
    // vérification de la version du client
        Tc_R := tc.Select('Select * from version where version = "' + VEnCours + '"');
        if tc.recordCount(Tc_R) = 0 then
        begin
           idver := 0;
           Patch := 0;
           NomVer := '';
           application.MessageBox('Version inconnu sur le site de référence', ' Erreur', MB_OK);
        end
        else
        begin
           idver := Strtoint(tc.UneValeur(tc_R, 'id'));
           Patch := Strtoint(tc.UneValeur(tc_R, 'Patch'));
           NomVer := tc.UneValeur(tc_R, 'nomversion');
        end;
        tc.FreeResult(tc_r);
        if idver <> 0 then
        begin
           if tc.UneValeurEntiere(tc_C, 'version') <> idver then
           begin
              DoActionProgress('Update version sur yellis', 0, 1);
              // le client n'est pas dans la version de yellis, MAJ du site yellis
              tc.ordre('UPDATE clients set version=' + inttostr(idver) + ', patch=0 where id=' + tc.UneValeur(tc_c, 'id'));
              tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                 'values (' + tc.UneValeur(tc_c, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                 '2, "Maj de la version par le client","","","")');
           end;
           Internet := TInternet.create(fOwner);

           tsl := tstringlist.create;
           if Patch > tc.UneValeurEntiere(tc_C, 'patch') then
           begin
              ForceDirectories(FDirGinkoia + 'A_Patch\');
              for i := tc.UneValeurEntiere(tc_C, 'patch') + 1 to Patch do
              begin
                 DoActionProgress('Passage du script ' + Inttostr(i), i - tc.UneValeurEntiere(tc_C, 'patch'), Patch - tc.UneValeurEntiere(tc_C, 'patch'));
                 fichier := internet.traitechaine(FLame {'http://lame2.no-ip.com/maj/} + 'patch/' + NomVer + '/script' + Inttostr(i) + '.SQL');
                 tsl.text := Internet.DownloadStr(fichier);
                 tsl.SaveToFile(FDirGinkoia + 'A_Patch\script' + Inttostr(i) + '.SQL');
                 S := tsl.Text;
                 while s <> '' do
                 begin
                    if pos('<---->', S) > 0 then
                    begin
                       S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
                       Delete(S, 1, pos('<---->', S) + 5);
                    end
                    else
                    begin
                       S1 := trim(S);
                       S := '';
                    end;
                    if s1 <> '' then
                       DoScript(S1);
                 end;
                 DoActionProgress('Validation du script ' + Inttostr(i), i - tc.UneValeurEntiere(tc_C, 'patch'), Patch - tc.UneValeurEntiere(tc_C, 'patch'));
                 tc.ordre('update clients set patch=' + Inttostr(i) + ' where id=' + tc.UneValeur(tc_c, 'id'));
                 tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                    'values (' + tc.UneValeur(tc_c, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                    '4, "script' + Inttostr(i) + '.SQL","' + FDirBase + 'ginkoia.ib","","")');
                 tc.ordre('update histo set fait=1 where action=5 and id_cli=' + tc.UneValeur(tc_c, 'id'));
              end;
           end;
           if tc.UneValeurEntiere(tc_C, 'spe_patch') > tc.UneValeurEntiere(tc_C, 'spe_fait') then
           begin
              ForceDirectories(FDirGinkoia + 'A_Patch\');
              for i := tc.UneValeurEntiere(tc_C, 'spe_fait') + 1 to tc.UneValeurEntiere(tc_C, 'spe_patch') do
              begin
                 DoActionProgress('Passage du spécifique', i - tc.UneValeurEntiere(tc_C, 'spe_fait'), tc.UneValeurEntiere(tc_C, 'spe_patch') - tc.UneValeurEntiere(tc_C, 'spe_fait'));
                 fichier := internet.traitechaine(FLame {'http://lame2.no-ip.com/maj/} + 'patch/' + GUID + '/script' + Inttostr(i) + '.SQL');
                 tsl.text := Internet.DownloadStr(fichier);
                 tsl.SaveToFile(FDirGinkoia + 'A_Patch\Spe' + Inttostr(i) + '.SQL');
                 S := tsl.Text;
                 while s <> '' do
                 begin
                    if pos('<---->', S) > 0 then
                    begin
                       S1 := trim(Copy(S, 1, pos('<---->', S) - 1));
                       Delete(S, 1, pos('<---->', S) + 5);
                    end
                    else
                    begin
                       S1 := trim(S);
                       S := '';
                    end;
                    if s1 <> '' then
                       DoScript(S1);
                 end;
                 tc.ordre('update clients set spe_fait=' + Inttostr(i) + ' where id=' + tc.UneValeur(tc_c, 'id'));
                 tc.ordre('Insert into histo (id_cli, ladate, action, actionstr, str1, str2, str3) ' +
                    'values (' + tc.UneValeur(tc_c, 'id') + ', "' + tc.DateTime(Now) + '", ' +
                    '7, "script' + Inttostr(i) + '.SQL","' + FDirBase + 'Ginkoia.IB","","")');
                 tc.ordre('update histo set fait=1 where action=8 and id_cli=' + tc.UneValeur(tc_c, 'id'));
              end;
           end;
           tsl.free;
           Internet.free;
        end;
     end
     else
     begin
        application.MessageBox('Client inconnu sur le site de référence', ' Erreur', MB_OK);
     end;
     tc.FreeResult(Tc_C);
     tc.free;
  end
  else
  begin
     application.MessageBox('Pas de GUID pour la base', ' Erreur', MB_OK);
  end;
  DoActionProgress('Fin MAJ BASE', 0, 1);
end;

end.

