unit ImportUtilisateur_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, MainImport_DM, DB, dxmdaset,
  IBQuery, IB_Components, IBODataset;

type
  Tfrm_ImportUtilisateur = class(TForm)
    Nbt_ExportCSV: TBitBtn;
    Lab_InfoExport: TLabel;
    DatabaseExport: TIB_Connection;
    OD_OpenDataExport: TOpenDialog;
    SV_Export: TSaveDialog;
    Nbt_FichierCSVUtil: TBitBtn;
    Nbt_FichierCSVGroupe: TBitBtn;
    Nbt_FichierCSVRelUserGroupe: TBitBtn;
    Lab_User: TLabel;
    Lab_Group: TLabel;
    Lab_RelUserGroup: TLabel;
    OD_FichierCSV: TOpenDialog;
    Nbt_ExecuteUser: TBitBtn;
    MemD_User: TdxMemData;
    MemD_Group: TdxMemData;
    MemD_RelUserGroup: TdxMemData;
    MemD_UserUSR_ID: TIntegerField;
    MemD_UserUSR_USERNAME: TStringField;
    MemD_UserUSR_FULLNAME: TStringField;
    MemD_UserUSR_PASSWORD: TStringField;
    MemD_UserUSR_EMAIL: TStringField;
    MemD_UserUSR_TEL: TStringField;
    MemD_UserUSR_FAX: TStringField;
    MemD_UserUSR_GSM: TStringField;
    MemD_UserNew_USRID: TIntegerField;
    MemD_GroupGRP_ID: TIntegerField;
    MemD_GroupGRP_GROUPNAME: TStringField;
    MemD_GroupGRP_DESCRIPTION: TStringField;
    MemD_GroupGRP_AFFICHAGE: TIntegerField;
    MemD_GroupNew_GRPID: TIntegerField;
    MemD_RelUserGroupGRM_ID: TIntegerField;
    MemD_RelUserGroupGRM_GROUPNAME: TStringField;
    MemD_RelUserGroupGRM_USERNAME: TStringField;
    MemD_RelUserGroupGRM_USRID: TIntegerField;
    MemD_RelUserGroupGRM_GRPID: TIntegerField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Chk_TmpTbUsr: TCheckBox;
    procedure Nbt_ExportCSVClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Nbt_FichierCSVUtilClick(Sender: TObject);
    procedure Nbt_FichierCSVGroupeClick(Sender: TObject);
    procedure Nbt_FichierCSVRelUserGroupeClick(Sender: TObject);
    procedure Nbt_ExecuteUserClick(Sender: TObject);
  private
    FEditDir: TEdit;
    FProgress: TProgressBar;
    FicAImportUser: string;
    FicAImportGroup: string;
    FicAImportRelUserGroup: string;
    { Déclarations privées }
  public
    { Déclarations publiques }
    property FileDirEdit : TEdit read FEditDir write FEditDir;
    property ProgressBar : TProgressBar read FProgress write FProgress;

  end;

var
  frm_ImportUtilisateur: Tfrm_ImportUtilisateur;

implementation

uses
  uImport_Gene;

{$R *.dfm} 

const
  FicExportUser: string = 'Utilisateur.csv';
  FicExportGroupe: string = 'Groupe.csv';
  FicExportRelUserGroup: string = 'RelationUserGroup.csv';

procedure Tfrm_ImportUtilisateur.FormCreate(Sender: TObject);
begin
  FicAImportUser := '';
  FicAImportGroup := '';
  FicAImportRelUserGroup := '';
  Lab_User.Caption := '';
  Lab_Group.Caption := '';
  Lab_RelUserGroup.Caption := '';
end;

procedure Tfrm_ImportUtilisateur.Nbt_ExecuteUserClick(Sender: TObject);
var
  iUsrID: integer;
  iGrpID: integer;
  iGrmID: integer;
  iAff: integer;
  bOk: boolean;  // tout s'est bien passé
begin
  if (FicAImportUser='') or not(FileExists(FicAImportUser)) then
  begin
    MessageDlg('Fichier CSV Utilisateur manquant ou introuvable !', mterror, [mbok], 0);
    exit;
  end;
  if (FicAImportGroup='') or not(FileExists(FicAImportGroup)) then
  begin
    MessageDlg('Fichier CSV Groupe manquant ou introuvable !', mterror, [mbok], 0);
    exit;
  end;
  if (FicAImportRelUserGroup='') or not(FileExists(FicAImportRelUserGroup)) then
  begin
    MessageDlg('Fichier CSV Relation Utilisateur<-->Groupe manquant ou introuvable !', mterror, [mbok], 0);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  ProgressBar.Position := 0;
  bOk := false;
  try
    // charge le fichier utilisateur
    MemD_User.Close;
    MemD_User.Open;
    MemD_User.DelimiterChar := ';';
    MemD_User.LoadFromTextFile(FicAImportUser);

    // charge le fichier groupe
    MemD_Group.Close;
    MemD_Group.Open;
    MemD_Group.DelimiterChar := ';';
    MemD_Group.LoadFromTextFile(FicAImportGroup);

    // charge le relation user-->groupe
    MemD_RelUserGroup.Close;
    MemD_RelUserGroup.Open;
    MemD_RelUserGroup.DelimiterChar := ';';
    MemD_RelUserGroup.LoadFromTextFile(FicAImportRelUserGroup);

    // ouverture base à importer
    with Form1 do
    begin
      Base.Close;
      Base.DatabaseName := ed_base.text;
      Base.Open;
      DM_MainImport.Database := Base;

      // FTH 17/10/2011 Gestion de la table temporaire pour l'atelier / fidélité & co
      tran_ecr.StartTransaction;
      if Chk_TmpTbUsr.Checked then
      begin
        Try
          SQL.Close;
          SQL.SQL.Text := 'CREATE TABLE TMPIMPGENE_USR(' +
                          'OLD_USRID ALGOL_INTEGER,' +
                          'NEW_USRID ALGOL_INTEGER);';
          SQL.ExecQuery;
        Except on E:Exception do
        End;
      end; // if
      tran_ecr.Commit;
    end;

    // Debut de transaction
    Form1.Tran_ecr.StartTransaction;

    try

      // fichier user
      ProgressBar.Position := 0;
      if MemD_User.RecordCount>0 then
        ProgressBar.Max := MemD_User.RecordCount;
      MemD_User.First;
      while not(MemD_User.Eof) do
      begin
        ProgressBar.Position := ProgressBar.Position+1;
        Application.ProcessMessages;
        // recherche si l'utilisateur n'existe pas déjà
        iUsrID := 0;
        with TIBQuery.Create(Self) do
        begin
          Database := DM_MainImport.Database;
          try
            SQL.Clear;
            SQL.Add('select USR_ID from uilusers');
            SQL.Add('where USR_USERNAME=:USERNAME');
            ParamByName('USERNAME').AsString := MemD_User.FieldByName('USR_USERNAME').AsString;
            Open;
            if not(Eof) then
              iUsrID := fieldbyname('USR_ID').AsInteger;
          finally
            Close;
            Free;
          end;
        end;

        // création user si nécessaire
        if iUsrID=0 then
        begin
          iUsrID := DM_MainImport.GetNewKID('UILUSERS');
          with TIBQuery.Create(Self) do
          begin
            Database := DM_MainImport.Database;
            try
              SQL.Clear;
              SQL.Add('insert into uilusers(USR_ID, USR_USERNAME, USR_FULLNAME, '+
                      'USR_PASSWORD, USR_ENABLED, USR_TEL, USR_FAX, USR_GSM, USR_EMAIL) values');
              SQL.Add('(:USRID, :USRUSERNAME, :USRFULLNAME, '+
                      ':USRPASSWORD, :USRENABLED, :USRTEL, :USRFAX, :USRGSM, :USREMAIL)');
              ParamByName('USRID').AsInteger     := iUsrID;
              ParamByName('USRUSERNAME').AsString := MemD_User.fieldbyname('USR_USERNAME').AsString;
              ParamByName('USRFULLNAME').AsString := MemD_User.fieldbyname('USR_FULLNAME').AsString;
              ParamByName('USRPASSWORD').AsString := MemD_User.fieldbyname('USR_PASSWORD').AsString;
              ParamByName('USRENABLED').AsInteger := 1;
              ParamByName('USRTEL').AsString      := MemD_User.fieldbyname('USR_TEL').AsString;
              ParamByName('USRFAX').AsString      := MemD_User.fieldbyname('USR_FAX').AsString;
              ParamByName('USRGSM').AsString      := MemD_User.fieldbyname('USR_GSM').AsString;
              ParamByName('USREMAIL').AsString     := MemD_User.fieldbyname('USR_EMAIL').AsString;
              ExecSQL;
            finally
              Close;
              Free;
            end;
          end;
        end;

        // Intégration dans la table temporaire
        if Chk_TmpTbUsr.Checked then
        begin
          with TIBQuery.Create(Self) do
          begin
            Database := DM_MainImport.Database;
            try
              Close;
              SQL.Clear;
              SQL.Add('Select count(*) as Resultat from TMPIMPGENE_USR');
              SQL.Add('Where OLD_USRID = :PUSRID');
              ParamCheck := True;
              ParamByName('PUSRID').AsInteger := MemD_User.FieldByName('USR_ID').AsInteger;
              Open;
              if FieldbyName('Resultat').AsInteger = 0 then
              begin
                Close;
                SQL.Clear;
                SQL.Add('Insert into TMPIMPGENE_USR(OLD_USRID, NEW_USRID)');
                SQL.Add('Values(:POLD, :PNEW)');
                ParamCheck := True;
                ParamByName('POLD').AsInteger := MemD_User.FieldByName('USR_ID').AsInteger;
                ParamByName('PNEW').AsInteger := iUsrID;
                ExecSQL;
              end;
            finally
              Close;
              Free;
            end;
          end;
        end;


        // garde en mémoire l'Id user pour après avec la relation user <--> groupe
        MemD_User.Edit;
        MemD_User.fieldbyname('New_USRID').AsInteger := iUsrID;
        MemD_User.Post;
        MemD_User.Next;
      end;    // fichier user

      // fichier groupe
      ProgressBar.Position := 0;
      if MemD_Group.RecordCount>0 then
        ProgressBar.Max := MemD_Group.RecordCount;
      MemD_Group.First;
      while not(MemD_Group.Eof) do
      begin
        ProgressBar.Position := ProgressBar.Position+1;
        Application.ProcessMessages;
        // recherche si le groupe n'existe pas déjà
        iGrpID := 0;
        with TIBQuery.Create(Self) do
        begin
          Database := DM_MainImport.Database;
          try
            SQL.Clear;
            SQL.Add('select GRP_ID from uilgroups');
            SQL.Add('where GRP_GROUPNAME=:GROUPNAME');
            ParamByName('GROUPNAME').AsString := MemD_Group.FieldByName('GRP_GROUPNAME').AsString;
            Open;
            if not(Eof) then
              iGrpID := fieldbyname('GRP_ID').AsInteger;
          finally
            Close;
            Free;
          end;
        end;

        // création group si nécessaire
        if iGrpID=0 then
        begin
          iGrpID := DM_MainImport.GetNewKID('UILGROUPS');
          with TIBQuery.Create(Self) do
          begin
            Database := DM_MainImport.Database;
            try
              // affichage
              iAff := 0;
              SQL.Clear;
              SQL.Add('select Max(GRP_AFFICHAGE) as AFF from UILGROUPS');
              Open;
              if not(Eof) then
                iAff := fieldbyname('AFF').AsInteger;
              Inc(iAff);
              Close;

              SQL.Clear;
              SQL.Add('insert into UILGROUPS(GRP_ID, GRP_GROUPNAME, GRP_DESCRIPTION, GRP_AFFICHAGE) values');
              SQL.Add('(:GRPID, :GRPGROUPNAME, :GRPDESCRIPTION, :GRPAFFICHAGE)');
              ParamByName('GRPID').AsInteger         := iGrpID;
              ParamByName('GRPGROUPNAME').AsString   := MemD_Group.FieldByName('GRP_GROUPNAME').AsString;
              ParamByName('GRPDESCRIPTION').AsString := MemD_Group.FieldByName('GRP_DESCRIPTION').AsString;
              ParamByName('GRPAFFICHAGE').AsInteger  := iAff;
              ExecSQL;
            finally
              Close;
              Free;
            end;
          end;
        end;

        // garde en mémoire l'Id hgroup pour après avec la relation user <--> groupe
        MemD_Group.Edit;
        MemD_Group.fieldbyname('New_GRPID').AsInteger := iGrpID;
        MemD_Group.Post;
        MemD_Group.Next;
      end;    // fichier groupe

      // fichier relation User <-->groupe  
      ProgressBar.Position := 0;
      if MemD_RelUserGroup.RecordCount>0 then
        ProgressBar.Max := MemD_RelUserGroup.RecordCount;
      MemD_RelUserGroup.First;
      while not(MemD_RelUserGroup.Eof) do
      begin
        ProgressBar.Position := ProgressBar.Position+1;
        Application.ProcessMessages;
        // recherche si le groupe n'existe pas déjà
        iGrmID := 0;
        with TIBQuery.Create(Self) do
        begin
          Database := DM_MainImport.Database;
          try
            SQL.Clear;
            SQL.Add('select GRM_ID from UILGROUPMEMBERSHIP');
            SQL.Add('where GRM_USERNAME=:GRMUSERNAME and GRM_GROUPNAME=:GROUPNAME');
            ParamByName('GRMUSERNAME').AsString := MemD_RelUserGroup.FieldByName('GRM_USERNAME').AsString;
            ParamByName('GROUPNAME').AsString := MemD_RelUserGroup.FieldByName('GRM_GROUPNAME').AsString;
            Open;
            if not(Eof) then
              iGrmID := fieldbyname('GRM_ID').AsInteger;
          finally
            Close;
            Free;
          end;
        end;

        // création si nécéssaire
        if iGrmID=0 then
        begin
          // retrouve le nouveau Id User
          iUsrID := 0;
          if MemD_User.Locate('USR_ID', MemD_RelUserGroup.FieldByName('GRM_USRID').AsInteger, []) then
            iUsrID := MemD_User.FieldByName('New_USRID').AsInteger;
          // retrouve le nouveau Id Group
          iGrpID := 0;
          if MemD_Group.Locate('GRP_ID', MemD_RelUserGroup.FieldByName('GRM_GRPID').AsInteger, []) then
            iGrpID := MemD_Group.FieldByName('New_GRPID').AsInteger;

          // création
          if (iUsrID>0) and (iGrpID>0) then
          begin
            iGrmID := DM_MainImport.GetNewKID('UILGROUPMEMBERSHIP');
            with TIBQuery.Create(Self) do
            begin
              Database := DM_MainImport.Database;
              try
                SQL.Clear;
                SQL.Add('insert into UILGROUPMEMBERSHIP(GRM_ID, GRM_USERNAME, GRM_GROUPNAME, '+
                        'GRM_USRID, GRM_GRPID) values');
                SQL.Add('(:GRMID, :GRMUSERNAME, :GRMGROUPNAME, :GRMUSRID, :GRMGRPID)');
                ParamByName('GRMID').AsInteger      := iGrmID;
                ParamByName('GRMUSERNAME').AsString  := MemD_RelUserGroup.FieldByName('GRM_USERNAME').AsString;
                ParamByName('GRMGROUPNAME').AsString := MemD_RelUserGroup.FieldByName('GRM_GROUPNAME').AsString;
                ParamByName('GRMUSRID').AsInteger    := iUsrID;
                ParamByName('GRMGRPID').AsInteger    := iGrpID;
                ExecSQL;
              finally 
                Close;
                Free;
              end;
            end;
          end;
        end;

        MemD_RelUserGroup.Next;
      end;    // fichier relation User <-->groupe

      // validation des données
      Form1.Tran_ecr.Commit;

      // tout s'est bien passé
      bOk := true;
    except
      on E: Exception do
      begin
        // annulation des données
        Form1.Tran_ecr.Rollback;
        MessageDlg(E.Message, mterror,[mbok],0);
      end;
    end;

  finally
    MemD_User.Close;
    MemD_Group.Close;
    MemD_RelUserGroup.Close;
    ProgressBar.Position := 0;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  if bOk then
    MessageDlg('Importation effectuée avec succès !', mtinformation, [mbok], 0);

end;

procedure Tfrm_ImportUtilisateur.Nbt_ExportCSVClick(Sender: TObject);
var
  sDataBase: string;
  sReperDest: string;
  LstTmp: TStringList;
begin
  // base de données à exporter
  sDataBase := '';
  if OD_OpenDataExport.Execute then
    sDataBase := OD_OpenDataExport.FileName;
  if sDataBase='' then
    exit;

  // repertoire de destination des fichiers
  sReperDest := '';
  if SV_Export.Execute then
    sReperDest := ExtractFilePath(SV_Export.FileName);
  if sReperDest='' then
    exit;
  if sReperDest[Length(sReperDest)]<>'\' then
    sReperDest := sReperDest+'\';

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  ProgressBar.Position := 0;
  LstTmp := TStringList.Create;
  try
    // ouverture base de données
    DatabaseExport.Close;
    DatabaseExport.DatabaseName := sDataBase;
    DatabaseExport.Open;

    with TIBOQuery.Create(Self) do
    begin
      IB_Connection := DatabaseExport;
      try

        // utilisateur
        ProgressBar.Position := 0;
        LstTmp.Clear;
        LstTmp.Add('USR_ID;USR_USERNAME;USR_FULLNAME;USR_PASSWORD;USR_TEL;USR_FAX;USR_GSM;USR_EMAIL');
        SQL.Clear;
        SQL.Add('select * from uilusers');
        SQL.Add('join k on k_id=usr_id and k_enabled=1');
        SQL.Add('where USR_ID<>0 AND USR_MAGASIN=0 AND');
        SQL.Add('USR_ENABLED=1');
        Open;
        if RecordCount>0 then
          ProgressBar.Max := RecordCount;
        First;
        while not(Eof) do
        begin  
          ProgressBar.Position := ProgressBar.Position+1;
          Application.ProcessMessages;
          LstTmp.Add(fieldbyname('USR_ID').AsString+';'+
                     fieldbyname('USR_USERNAME').AsString+';'+
                     fieldbyname('USR_FULLNAME').AsString+';'+
                     fieldbyname('USR_PASSWORD').AsString+';'+
                     fieldbyname('USR_TEL').AsString+';'+
                     fieldbyname('USR_FAX').AsString+';'+
                     fieldbyname('USR_GSM').AsString+';'+
                     fieldbyname('USR_EMAIL').AsString);
          Next;
        end;
        Close;
        LstTmp.SaveToFile(sReperDest+FicExportUser);

        // groupe
        ProgressBar.Position := 0;
        LstTmp.Clear;
        LstTmp.Add('GRP_ID;GRP_GROUPNAME;GRP_DESCRIPTION;GRP_AFFICHAGE');
        SQL.Clear;
        SQL.Add('select * from uilgroups');
        SQL.Add('join k on k_id=grp_id and k_enabled=1');
        SQL.Add('where grp_id<>0');
        SQL.Add('order by grp_affichage');
        Open;
        if RecordCount>0 then
          ProgressBar.Max := RecordCount;
        First;
        while not(Eof) do
        begin                    
          ProgressBar.Position := ProgressBar.Position+1;
          Application.ProcessMessages;
          LstTmp.Add(fieldbyname('GRP_ID').AsString+';'+
                     fieldbyname('GRP_GROUPNAME').AsString+';'+
                     fieldbyname('GRP_DESCRIPTION').AsString+';'+
                     fieldbyname('GRP_AFFICHAGE').AsString);
          Next;
        end;
        Close;
        LstTmp.SaveToFile(sReperDest+FicExportGroupe);

        // relation user-->groupe
        ProgressBar.Position := 0;
        LstTmp.Clear;
        LstTmp.Add('GRM_ID;GRM_USERNAME;GRM_GROUPNAME;GRM_USRID;GRM_GRPID');
        SQL.Clear;
        SQL.Add('select a.* from UILGROUPMEMBERSHIP a');
        SQL.Add('join k on k_id=grm_id and k_enabled=1');
        SQL.Add('join uilusers join k on k_id=usr_id and k_enabled=1');
        SQL.Add('  on usr_id=grm_usrid');
        SQL.Add('join UILGROUPS join k on k_id=grp_id and k_enabled=1');
        SQL.Add('  on grp_id=grm_grpid');
        SQL.Add('where grm_id<>0 AND USR_MAGASIN=0 AND');
        SQL.Add('USR_ENABLED=1;');
        Open;
        if RecordCount>0 then
          ProgressBar.Max := RecordCount;
        First;
        while not(Eof) do
        begin             
          ProgressBar.Position := ProgressBar.Position+1;
          Application.ProcessMessages;
          if UpperCase(fieldbyname('GRM_USERNAME').AsString)<>'ALGOL' then
          begin
            LstTmp.Add(fieldbyname('GRM_ID').AsString+';'+
                       fieldbyname('GRM_USERNAME').AsString+';'+
                       fieldbyname('GRM_GROUPNAME').AsString+';'+
                       fieldbyname('GRM_USRID').AsString+';'+
                       fieldbyname('GRM_GRPID').AsString);
          end;
          Next;
        end;
        Close;
        LstTmp.SaveToFile(sReperDest+FicExportRelUserGroup);

      finally
        Close;
        Free;
      end;
    end;
  finally             
    ProgressBar.Position := 0;
    FreeAndNil(LstTmp);
    DatabaseExport.Close;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
  MessageDlg('Export terminé !', mtinformation, [mbok], 0);

end;

procedure Tfrm_ImportUtilisateur.Nbt_FichierCSVGroupeClick(Sender: TObject);
var
  sReper: string;
begin
  if OD_FichierCSV.Execute then
  begin         
    FicAImportGroup := OD_FichierCSV.FileName;
    Lab_Group.Caption := FicAImportGroup;
    sReper := ExtractFilePath(FicAImportGroup);
    if sReper[Length(sReper)]<>'\' then
      sReper := sReper+'\';

    if (FicAImportUser='') and FileExists(sReper+FicExportUser) then
    begin
      FicAImportUser := sReper+FicExportUser;
      Lab_User.Caption := FicAImportUser;
    end;

    if (FicAImportRelUserGroup='') and FileExists(sReper+FicExportRelUserGroup) then
    begin
      FicAImportRelUserGroup := sReper+FicExportRelUserGroup;
      Lab_RelUserGroup.Caption := FicAImportRelUserGroup;
    end;
  end;
end;

procedure Tfrm_ImportUtilisateur.Nbt_FichierCSVRelUserGroupeClick(Sender: TObject);
var
  sReper: string;
begin
  if OD_FichierCSV.Execute then
  begin  
    FicAImportRelUserGroup := OD_FichierCSV.FileName;
    Lab_RelUserGroup.Caption := FicAImportRelUserGroup;
    sReper := ExtractFilePath(FicAImportRelUserGroup);
    if sReper[Length(sReper)]<>'\' then
      sReper := sReper+'\';

    if (FicAImportUser='') and FileExists(sReper+FicExportUser) then
    begin
      FicAImportUser := sReper+FicExportUser;
      Lab_User.Caption := FicAImportUser;
    end;

    if (FicAImportGroup='') and FileExists(sReper+FicExportGroupe) then
    begin
      FicAImportGroup := sReper+FicExportGroupe;
      Lab_Group.Caption := FicAImportGroup;
    end;
  end;
end;

procedure Tfrm_ImportUtilisateur.Nbt_FichierCSVUtilClick(Sender: TObject);
var
  sReper: string;
begin
  if OD_FichierCSV.Execute then
  begin
    FicAImportUser := OD_FichierCSV.FileName;
    Lab_User.Caption := FicAImportUser;
    sReper := ExtractFilePath(FicAImportUser);
    if sReper[Length(sReper)]<>'\' then
      sReper := sReper+'\';

    if (FicAImportGroup='') and FileExists(sReper+FicExportGroupe) then
    begin
      FicAImportGroup := sReper+FicExportGroupe;
      Lab_Group.Caption := FicAImportGroup;
    end;

    if (FicAImportRelUserGroup='') and FileExists(sReper+FicExportRelUserGroup) then
    begin
      FicAImportRelUserGroup := sReper+FicExportRelUserGroup;
      Lab_RelUserGroup.Caption := FicAImportRelUserGroup;
    end;
  end;
end;

end.
