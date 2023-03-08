unit Main_Frm;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, Grids, DBGrids, DB, IBODataset,
  IB_Components, IB_Access;

type
  TFrm_Main = class(TForm)
    Pan_Haut: TPanel;
    Label1: TLabel;
    EDataBase: TEdit;
    Nbt_OpenConn: TSpeedButton;
    Nbt_Quit: TBitBtn;
    Nbt_Conn: TSpeedButton;
    Lab_Version: TLabel;
    Pan_Boulot: TPanel;
    Label4: TLabel;
    EReperID: TEdit;
    Nbt_SelRep: TSpeedButton;
    Lab_EnCours: TLabel;
    PgBar: TProgressBar;
    LRepertoire: TLabel;
    Nbt_FichierToc: TBitBtn;
    LOctete: TLabel;
    LOcMag: TLabel;
    LOcLignes: TLabel;
    LOcDetail: TLabel;
    Nbt_Exec: TBitBtn;
    procedure Nbt_QuitClick(Sender: TObject);
    procedure Nbt_OpenConnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Nbt_ConnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Nbt_SelRepClick(Sender: TObject);
    procedure Nbt_FichierTocClick(Sender: TObject);
    procedure Nbt_ExecClick(Sender: TObject);
  private
    { Déclarations privées }
    DelaiAffiche: DWord;
    ReperToc: string;
    FicOcTete: string;
    FicOcMag: string;
    FicOcLignes: string;
    FicOcDetail: string;
    procedure TraiteInfoToc;
    procedure OpenDatabase;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  Main_Dm, uVersion, FileCtrl;

{$R *.dfm}

function GetValueLigne(ALigne: string; Position: integer): string;
var
  i: integer;
  LPos: integer;
begin
  Result := ALigne;
  for i := 1 to Position-1 do
  begin
    LPos := Pos('";"', Result);
    if LPos>0 then
      Result := Copy(Result, LPos+2, Length(Result))
    else
      Result :=  '';
  end;
  LPos := Pos('";"', Result);
  if (LPos>0) then
    Result := Copy(Result, 1, LPos);

  // unquoted
  if Result<>'' then
  begin
    if Result[1]='"' then
      Result := Copy(Result, 2, Length(Result));
  end;
  if Result<>'' then
  begin
    if Result[Length(Result)]='"' then
      Result := Copy(Result, 1, Length(Result)-1);
  end;
  Result := StringReplace(Result, '""', '"', [rfReplaceAll, rfIgnoreCase]);
end;

function ConvertStrToFloat(AStr: string; const ADefault: Double = 0.0): Double;
var
  sTmp: string;
begin
  Result := ADefault;
  sTmp := Trim(AStr);
  if sTmp='' then
    exit;

  if Pos(',', sTmp)>0 then
    sTmp[Pos(',', sTmp)] := FormatSettings.DecimalSeparator;
  if Pos('.', sTmp)>0 then
    sTmp[Pos('.', sTmp)] := FormatSettings.DecimalSeparator;

  Result := StrToFloatDef(sTmp, ADefault);
end;

procedure TFrm_Main.TraiteInfoToc;
begin
  if (ReperToc<>'') and (ReperToc[Length(ReperToc)]<>'\') then
    ReperToc := ReperToc+'\';

  if ReperToc<>'' then
    LRepertoire.Caption := 'Répertoire: '+ReperToc
  else
    LRepertoire.Caption := '';

  FicOcTete := 'Octete.csv';
  if FileExists(ReperToc+FicOcTete) then
    LOcTete.Caption := 'Octete.csv....Ok'
  else
    LOcTete.Caption := 'Octete.csv....Non';

  FicOcMag := 'OcMag.csv';
  if FileExists(ReperToc+FicOcMag) then
    LOcMag.Caption := 'OcMag.csv....Ok'
  else
    LOcMag.Caption := 'OcMag.csv....Non';

  FicOcLignes := 'OcLignes.csv';
  if FileExists(ReperToc+FicOcLignes) then
    LOcLignes.Caption := 'OcLignes.csv....Ok'
  else
    LOcLignes.Caption := 'OcLignes.csv....Non';

  FicOcDetail := 'OcDetail.csv';
  if FileExists(ReperToc+FicOcDetail) then
    LOcDetail.Caption := 'OcDetail.csv....Ok'
  else
    LOcDetail.Caption := 'OcDetail.csv....Non';

end;

procedure TFrm_Main.OpenDatabase;
var
  sFile: string;
begin
  Lab_Version.Visible := false;
  sFile := EDataBase.Text;
  if (sFile='') or not(FileExists(sFile)) then
  begin
    MessageDlg('Fichier manquant ou introuvable !', mterror, [mbok], 0);
    exit;
  end;
  try
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Dm_Main.DoConnexion(sFile);
      Lab_Version.Caption := 'Ver. '+Dm_Main.GetVersion;
      Lab_Version.Visible := true;
    finally
      Application.ProcessMessages;
      Screen.Cursor := crDefault;
    end;
  except
    on E:Exception do
      MessageDlg(E.Message, mterror, [mbok], 0);
  end;
  Pan_Boulot.Visible := Dm_Main.Database.Connected;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Dm_Main := TDm_Main.Create(Self);
  ReperBase := ExtractFilePath(ParamStr(0));
  if ReperBase[Length(ReperBase)]<>'\' then
    ReperBase := ReperBase+'\';

  DelaiAffiche := 200;
  Lab_Version.Visible := false;
  EDataBase.Text := '';
  Caption := Caption +' - Ver '+Version;
  Application.Title := Application.Title +' - Ver '+Version;
  ReperToc := '';
  EReperId.Text := '';
  TraiteInfoToc;
end;

procedure TFrm_Main.FormDestroy(Sender: TObject);
begin
  Dm_Main.Free;
end;

procedure TFrm_Main.Nbt_ConnClick(Sender: TObject);
begin
  OpenDatabase;
end;

procedure TFrm_Main.Nbt_ExecClick(Sender: TObject);
var
  QueDiv: TIBOQuery;
  QueNewK: TIBOQuery;
  LstErreur: TStringList;
  Delai: DWord;
  sInfo: String;
  sMagAdh: string;
  iMagId: integer;
  Nb: integer;
  TpListe: TStringList;
  i: integer;
  sLigne: string;
  iOldOctId: integer;
  iNewOctId: integer;
  iOldOcmId: integer;
  iNewOcmId: integer;
  iOldOclId: integer;
  iNewOclId: integer;
  iOldOcdId: integer;
  iNewOcdId: integer;
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;

  function GetNewKid(ATable: string): integer;
  begin
    QueNewK.ParamByName('TABLE').AsString := ATable;
    QueNewK.ExecSQL;
    Result := QueNewK.FieldByName('ID').AsInteger;
    QueNewK.Close;
  end;

begin
  Dm_Main.ReperSavID := EReperID.Text;
  if (Dm_Main.ReperSavID<>'') and (Dm_Main.ReperSavID[Length(Dm_Main.ReperSavID)]<>'\') then
    Dm_Main.ReperSavID := Dm_Main.ReperSavID+'\';

  if not(SysUtils.DirectoryExists(Dm_Main.ReperSavID)) then
  begin
    MessageDlg('Répertoire manquant ou invalide !', mterror, [mbok], 0);
    exit;
  end;
  // article
  if not(FileExists(Dm_Main.ReperSavID+ArticleID)) then
  begin
    MessageDlg('Fichier "ArticleID.ID" manquant', mterror, [mbok], 0);
    exit;
  end;
  // Taille
  if not(FileExists(Dm_Main.ReperSavID+GrTailleLigID)) then
  begin
    MessageDlg('Fichier "GrTailleLigID.ID" manquant', mterror, [mbok], 0);
    exit;
  end;
  // couleur
  if not(FileExists(Dm_Main.ReperSavID+CouleurID)) then
  begin
    MessageDlg('Fichier "CouleurID.ID" manquant', mterror, [mbok], 0);
    exit;
  end;

  // Octete
  if not(FileExists(ReperToc+FicOcTete)) then
  begin
    MessageDlg('Fichier "Octete.csv" manquant', mterror, [mbok], 0);
    exit;
  end;

  // OcMag
  if not(FileExists(ReperToc+FicOcMag)) then
  begin
    MessageDlg('Fichier "OcMag.csv" manquant', mterror, [mbok], 0);
    exit;
  end;

  // OcLignes
  if not(FileExists(ReperToc+FicOcLignes)) then
  begin
    MessageDlg('Fichier "OcLignes.csv" manquant', mterror, [mbok], 0);
    exit;
  end;

  // OcDetail
  if not(FileExists(ReperToc+FicOcDetail)) then
  begin
    MessageDlg('Fichier "OcDetail.csv" manquant', mterror, [mbok], 0);
    exit;
  end;

  QueNewK := TIBOQuery.Create(Self);
  LstErreur := TStringList.Create;
  TpListe := TStringList.Create;
  Lab_EnCours.Caption := 'Initialisation';
  Lab_EnCours.Visible := true;
  PgBar.Position := 0;
  PgBar.Visible := true;
  QueDiv := TIBOQuery.Create(Self);
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    // initialisation
    Dm_Main.LoadListeArticleID;        // article
    Dm_Main.LoadListeGrTailleLigID;    // taille
    Dm_Main.LoadListeCouleurID;        // couleur

    Dm_Main.Cds_OcTete.Close;
    Dm_Main.Cds_OcTete.Open;
    Dm_Main.Cds_OcTete.EmptyDataSet;

    Dm_Main.Cds_OctMag.Close;
    Dm_Main.Cds_OctMag.Open;
    Dm_Main.Cds_OctMag.EmptyDataSet;

    Dm_Main.Cds_OcLignes.Close;
    Dm_Main.Cds_OcLignes.Open;
    Dm_Main.Cds_OcLignes.EmptyDataSet;

    Dm_Main.Cds_OcDetail.Close;
    Dm_Main.Cds_OcDetail.Open;
    Dm_Main.Cds_OcDetail.EmptyDataSet;

    // prepa requete NEwK
    QueNewK.IB_Connection := Dm_Main.Database;
    QueNewK.IB_Transaction := Dm_Main.Transaction;
    QueNewK.SQL.Add('select ID from PR_NEWK(:TABLE)');

    // liste des mag<-->code adhérent
    Dm_Main.Cds_Magasin.Close;
    Dm_Main.Cds_Magasin.Open;
    Dm_Main.Cds_Magasin.EmptyDataSet;

    QueDiv.IB_Connection := Dm_Main.Database;
    QueDiv.IB_Transaction := Dm_Main.Transaction;
    QueDiv.SQL.Clear;
    QueDiv.SQL.Add('select MAG_ID, MAG_CODEADH from GENMAGASIN');
    QueDiv.SQL.Add('  join K on K_ID=MAG_ID and K_ENABLED=1');
    QueDiv.SQL.Add(' where MAG_ID<>0');
    QueDiv.Open;
    while not(QueDiv.Eof) do
    begin
      Dm_Main.Cds_Magasin.Append;
      Dm_Main.Cds_Magasin.FieldByName('MAG_ID').AsInteger := QueDiv.FieldByName('MAG_ID').AsInteger;
      Dm_Main.Cds_Magasin.FieldByName('MAG_CODEADH').AsString := QueDiv.FieldByName('MAG_CODEADH').AsString;
      Dm_Main.Cds_Magasin.Post;
      QueDiv.Next;
    end;
    QueDiv.Close;

    // OCTETE
    nb := 0;
    Delai := GetTickCount;
    sInfo := 'OCTETE 0';
    Lab_EnCours.Caption := sInfo;
    Application.ProcessMessages;
    TpListe.Clear;
    TpListe.LoadFromFile(ReperToc+FicOcTete);
    QueDiv.SQL.Clear;
    QueDiv.SQL.Add('insert into OCTETE (OCT_ID, OCT_NOM, OCT_COMMENT, OCT_DEBUT, '+
                                       'OCT_FIN, OCT_TYPID, OCT_WEB, OCT_CENTRALE, OCT_CODE)'+
                                       'values '+
                                       '(:OCT_ID, :OCT_NOM, :OCT_COMMENT, :OCT_DEBUT, :OCT_FIN, '+
                                       ':OCT_TYPID, :OCT_WEB, :OCT_CENTRALE, :OCT_CODE)');
    for i := 2 to TPListe.Count do
    begin
      sLigne := TPListe[i-1];
      sInfo := 'OCTETE '+inttostr(i-1);
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      try
        iOldOctId := StrToInt(GetValueLigne(sLigne, 1));
        iNewOctId := GetNewKid('OCTETE');

        QueDiv.ParamByName('OCT_ID').AsInteger   := iNewOctId;
        QueDiv.ParamByName('OCT_NOM').Value      := GetValueLigne(sLigne, 2);
        QueDiv.ParamByName('OCT_COMMENT').Value  := GetValueLigne(sLigne, 3);
        QueDiv.ParamByName('OCT_DEBUT').Value    := GetValueLigne(sLigne, 4);
        QueDiv.ParamByName('OCT_FIN').Value      := GetValueLigne(sLigne, 5);
        QueDiv.ParamByName('OCT_TYPID').Value    := GetValueLigne(sLigne, 6);
        QueDiv.ParamByName('OCT_WEB').Value      := GetValueLigne(sLigne, 7);
        QueDiv.ParamByName('OCT_CENTRALE').Value := GetValueLigne(sLigne, 8);
        QueDiv.ParamByName('OCT_CODE').Value     := GetValueLigne(sLigne, 9);
        QueDiv.ExecSQL;
        QueDiv.Close;

        Dm_Main.Cds_OcTete.Append;
        Dm_Main.Cds_OcTete.FieldByName('Old_OCTID').AsInteger := iOldOctId;
        Dm_Main.Cds_OcTete.FieldByName('New_OCTID').AsInteger := iNewOctId;
        Dm_Main.Cds_OcTete.Post;

        Dm_Main.Transaction.Commit;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;

      except
        on E:Exception do
        begin
          if (Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.Rollback;
          raise;
        end;
      end;
    end;

    // OCMAG
    nb := 0;
    Delai := GetTickCount;
    sInfo := 'OCMAG 0';
    Lab_EnCours.Caption := sInfo;
    Application.ProcessMessages;
    TpListe.Clear;
    TpListe.LoadFromFile(ReperToc+FicOcMag);
    QueDiv.SQL.Clear;
    QueDiv.SQL.Add('insert into OCMAG (OCM_ID, OCM_OCTID, OCM_MAGID, OCM_CLTID, OCM_CLTPRO) '+
                                      'values '+
                                      '(:OCM_ID, :OCM_OCTID, :OCM_MAGID, :OCM_CLTID, :OCM_CLTPRO)');
    for i := 2 to TPListe.Count do
    begin
      sLigne := TPListe[i-1];
      sInfo := 'OCMAG '+inttostr(i-1);
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      try
        iOldOctId := StrToInt(GetValueLigne(sLigne, 2));
        Dm_Main.Cds_OcTete.Locate('Old_OCTID', iOldOctId, []);
        iNewOctId := Dm_Main.Cds_OcTete.FieldByName('New_OCTID').AsInteger;

        iOldOcmId := StrToInt(GetValueLigne(sLigne, 1));
        iNewOcmId := GetNewKid('OCMAG');

        sMagAdh := GetValueLigne(sLigne, 3);
        Dm_Main.Cds_Magasin.Locate('MAG_CODEADH', sMagAdh, []);
        iMagId := Dm_Main.Cds_Magasin.FieldByName('MAG_ID').AsInteger;

        QueDiv.ParamByName('OCM_ID').AsInteger := iNewOcmId;
        QueDiv.ParamByName('OCM_OCTID').AsInteger := iNewOctId;
        QueDiv.ParamByName('OCM_MAGID').AsInteger:= iMagId;
        QueDiv.ParamByName('OCM_CLTID').AsInteger:= 0 ;     // to do  : gerer l'Id client s'il y en a
        QueDiv.ParamByName('OCM_CLTPRO').AsInteger:= 0 ;    // to do
        QueDiv.ExecSQL;
        QueDiv.Close;

        Dm_Main.Cds_OctMag.Append;
        Dm_Main.Cds_OctMag.FieldByName('Old_OCMID').AsInteger := iOldOcmId;
        Dm_Main.Cds_OctMag.FieldByName('New_OCMID').AsInteger := iNewOcmId;
        Dm_Main.Cds_OctMag.Post;

        Dm_Main.Transaction.Commit;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;

      except
        on E:Exception do
        begin
          if (Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.Rollback;
          raise;
        end;
      end;
    end;

    // OCLIGNES
    nb := 0;
    Delai := GetTickCount;
    sInfo := 'OCLIGNES 0';
    Lab_EnCours.Caption := sInfo;
    Application.ProcessMessages;
    TpListe.Clear;
    TpListe.LoadFromFile(ReperToc+FicOcLignes);
    QueDiv.SQL.Clear;
    QueDiv.SQL.Add('insert into OCLIGNES (OCL_ID, OCL_ARTID, OCL_PXVTE, OCL_OCTID, OCL_LOTID) '+
                                         'values '+
                                         '(:OCL_ID, :OCL_ARTID, :OCL_PXVTE, :OCL_OCTID, :OCL_LOTID)');

    for i := 2 to TPListe.Count do
    begin
      sLigne := TPListe[i-1];
      sInfo := 'OCLIGNES '+inttostr(i-1);
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      try
        iOldOclId := StrToInt(GetValueLigne(sLigne, 1));
        iNewOclId := GetNewKid('OCLIGNES');

        iOldOctId := StrToInt(GetValueLigne(sLigne, 4));
        Dm_Main.Cds_OcTete.Locate('Old_OCTID', iOldOctId, []);
        iNewOctId := Dm_Main.Cds_OcTete.FieldByName('New_OCTID').AsInteger;

        iArtID := Dm_Main.GetArtID(GetValueLigne(sLigne, 2));

        if iArtID<=0 then
          LstErreur.Add('OCLIGNES - Article non trouvé - ArtId = '+GetValueLigne(sLigne, 2));

        QueDiv.ParamByName('OCL_ID').AsInteger    := iNewOclId;
        QueDiv.ParamByName('OCL_ARTID').AsInteger := iArtId;
        QueDiv.ParamByName('OCL_PXVTE').AsFloat   := ConvertStrToFloat(GetValueLigne(sLigne, 3));
        QueDiv.ParamByName('OCL_OCTID').AsInteger := iNewOctId;
        QueDiv.ParamByName('OCL_LOTID').AsInteger := 0;    // to do
        QueDiv.ExecSQL;
        QueDiv.Close;

        Dm_Main.Cds_OcLignes.Append;
        Dm_Main.Cds_OcLignes.FieldByName('Old_OCLID').AsInteger := iOldOclId;
        Dm_Main.Cds_OcLignes.FieldByName('New_OCLID').AsInteger := iNewOclId;
        Dm_Main.Cds_OcLignes.Post;

        Dm_Main.Transaction.Commit;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;

      except
        on E:Exception do
        begin
          if (Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.Rollback;
          raise;
        end;
      end;
    end;

    // OCDETAIL
    nb := 0;
    Delai := GetTickCount;
    sInfo := 'OCDETAIL 0';
    Lab_EnCours.Caption := sInfo;
    Application.ProcessMessages;
    TpListe.Clear;
    TpListe.LoadFromFile(ReperToc+FicOcDetail);
    QueDiv.SQL.Clear;
    QueDiv.SQL.Add('insert into OCDETAIL (OCD_ID, OCD_OCLID, OCD_ARTID, OCD_TGFID, OCD_COUID, OCD_PRIX, '+
                                         'OCD_ACTIVE, OCD_CENTRALE) '+
                                         'values '+
                                         '(:OCD_ID, :OCD_OCLID, :OCD_ARTID, :OCD_TGFID, :OCD_COUID, '+
                                         ':OCD_PRIX, :OCD_ACTIVE, :OCD_CENTRALE)');

    for i := 2 to TPListe.Count do
    begin
      sLigne := TPListe[i-1];
      sInfo := 'OCDETAIL '+inttostr(i-1);
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      try
        iOldOcdId := StrToInt(GetValueLigne(sLigne, 1));
        iNewOcdId := GetNewKid('OCDETAIL');

        iOldOclId := StrToInt(GetValueLigne(sLigne, 2));
        Dm_Main.Cds_OcLignes.Locate('Old_OCLID', iOldOctId, []);
        iNewOclId := Dm_Main.Cds_OcLignes.FieldByName('New_OCLID').AsInteger;

        iArtID := Dm_Main.GetArtID(GetValueLigne(sLigne, 3));
        iTgfID := Dm_Main.GetTgfID(GetValueLigne(sLigne, 4));
        iCouID := Dm_Main.GetCouID(GetValueLigne(sLigne, 5));
        if iArtID<=0 then
          LstErreur.Add('OCDETAIL - Article non trouvé - ArtId = '+GetValueLigne(sLigne, 3));
        if iTgfID<=0 then
          LstErreur.Add('OCDETAIL - Taille non trouvé - TgfId = '+GetValueLigne(sLigne, 4));
        if iCouID<=0 then
          LstErreur.Add('OCDETAIL - Couleur non trouvé - CouId = '+GetValueLigne(sLigne, 5));

        QueDiv.ParamByName('OCD_ID').AsInteger       := iNewOcdId;
        QueDiv.ParamByName('OCD_OCLID').AsInteger    := iNewOclId;
        QueDiv.ParamByName('OCD_ARTID').AsInteger    := iArtID;
        QueDiv.ParamByName('OCD_TGFID').AsInteger    := iTgfID;
        QueDiv.ParamByName('OCD_COUID').AsInteger    := iCouID;
        QueDiv.ParamByName('OCD_PRIX').AsFloat       := ConvertStrToFloat(GetValueLigne(sLigne, 6));
        QueDiv.ParamByName('OCD_ACTIVE').AsInteger   := StrtoInt(GetValueLigne(sLigne, 7));
        QueDiv.ParamByName('OCD_CENTRALE').AsInteger := StrtoInt(GetValueLigne(sLigne, 8));
        QueDiv.ExecSQL;
        QueDiv.Close;

        Dm_Main.Cds_OcDetail.Append;
        Dm_Main.Cds_OcDetail.FieldByName('Old_OCDID').AsInteger := iOldOclId;
        Dm_Main.Cds_OcDetail.FieldByName('New_OCDID').AsInteger := iNewOclId;
        Dm_Main.Cds_OcDetail.Post;

        Dm_Main.Transaction.Commit;

        if (GetTickCount-Delai)>=DelaiAffiche then
        begin
          Lab_EnCours.Caption := sInfo;
          Delai := GetTickCount;
          Application.ProcessMessages;
        end;

      except
        on E:Exception do
        begin
          if (Dm_Main.Transaction.InTransaction) then
            Dm_Main.Transaction.Rollback;
          raise;
        end;
      end;
    end;

    MessageDlg('Transfert terminé', mtinformation, [mbok], 0);
  finally
    if LstErreur.Count>0 then
    begin
      LstErreur.SaveToFile(ReperBase+'Erreur Toc '+formatdatetime('yyyy-mm-dd hhnnss', now)+'.txt');
    end;
    QueNewK.Close;
    FreeAndNil(QueNewK);
    QueDiv.Close;
    FreeAndNil(QueDiv);
    FreeAndNil(LstErreur);
    FreeAndNil(TpListe);
    Dm_Main.ListeIDGrTailleLig.Clear;
    Dm_Main.ListeIDArticle.Clear;
    Dm_Main.ListeIDCouleur.Clear;
    Lab_EnCours.Visible := false;
    PgBar.Visible := false;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.Nbt_FichierTocClick(Sender: TObject);
var
  odTemp: TOpenDialog;
  sDir: string;
begin
  sDir := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier TOC|*.csv';
    odTemp.Title := 'Fichiers TOC';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      sDir := ExtractFilePath(odTemp.FileName);
  finally
    odTemp.Free;
  end;
  if sDir='' then
    exit;
  ReperToc := sDir;
  TraiteInfoToc;
end;

procedure TFrm_Main.Nbt_OpenConnClick(Sender: TObject);
var
  odTemp : TOpenDialog;
  sFile: string;
begin
  sFile := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'InterBase|*.ib';
    odTemp.Title := 'Choix de la base de données';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      sFile := odTemp.FileName;
  finally
    odTemp.Free;
  end;
  if sFile='' then
    exit;

  EDataBase.Text := sFile;
  OpenDatabase;
end;

procedure TFrm_Main.Nbt_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.Nbt_SelRepClick(Sender: TObject);
var
  sTemp: string;
begin
  sTemp := EReperID.Text;
  if (sTemp<>'') and (sTemp[Length(sTemp)]<>'\') then
    sTemp := sTemp+'\';
  if not(SysUtils.DirectoryExists(sTemp)) then
    sTemp := '';
  if SelectDirectory('Choix du répertoire', '', sTemp) then
  begin
    if (sTemp<>'') and (sTemp[Length(sTemp)]<>'\') then
      sTemp := sTemp+'\';
    EReperID.Text := sTemp;
  end;
end;

end.
