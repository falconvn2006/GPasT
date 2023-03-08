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
    LFichier: TLabel;
    Nbt_FichierToc: TBitBtn;
    LArtIdeal: TLabel;
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
    FicArtIdeal: string;
    procedure TraiteInfoArtIdeal;
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
    LPos := Pos(';', Result);
    if LPos>0 then
      Result := Copy(Result, LPos+1, Length(Result))
    else
      Result :=  '';
  end;
  LPos := Pos(';', Result);
  if (LPos>0) then
    Result := Copy(Result, 1, LPos-1);

  // unquoted
//  if Result<>'' then
//  begin
//    if Result[1]='"' then
//      Result := Copy(Result, 2, Length(Result));
//  end;
//  if Result<>'' then
//  begin
//    if Result[Length(Result)]='"' then
//      Result := Copy(Result, 1, Length(Result)-1);
//  end;
//  Result := StringReplace(Result, '""', '"', [rfReplaceAll, rfIgnoreCase]);
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

procedure TFrm_Main.TraiteInfoArtIdeal;
begin
  if FileExists(FicArtIdeal) then
  begin
    LFichier.Visible := true;
    LArtIdeal.Caption := FicArtIdeal;
  end
  else
  begin
    LFichier.Visible := false;
    LArtIdeal.Caption := '';
  end;
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
  FicArtIdeal := '';
  EReperId.Text := '';
  TraiteInfoArtIdeal;
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
  QueTst: TIBOQuery;
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
  iArtID: integer;
  iTgfID: integer;
  iCouID: integer;
  iStiID: integer;
  vQte: integer;
  bOk: boolean;

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

  // fichier ArtIdeal
  if not(FileExists(FicArtIdeal)) then
  begin
    MessageDlg('Fichier ArtIdeal manquant', mterror, [mbok], 0);
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
  QueTst := TIBOQuery.Create(Self);
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    // initialisation
    Dm_Main.LoadListeArticleID;        // article
    Dm_Main.LoadListeGrTailleLigID;    // taille
    Dm_Main.LoadListeCouleurID;        // couleur

    // prepa requete NEwK
    QueNewK.IB_Connection := Dm_Main.Database;
    QueNewK.IB_Transaction := Dm_Main.Transaction;
    QueNewK.SQL.Add('select ID from PR_NEWK(:TABLE)');

    // liste des mag<-->code adhérent
    Dm_Main.Cds_Magasin.Close;
    Dm_Main.Cds_Magasin.Open;
    Dm_Main.Cds_Magasin.EmptyDataSet;

    // query de test
    QueTst.IB_Connection := Dm_Main.Database;
    QueTst.IB_Transaction := Dm_Main.Transaction;
    QueTst.SQL.Clear;
    QueTst.SQL.Add('select STI_ID from ARTIDEAL');
    QueTst.SQL.Add('where STI_ARTID=:STI_ARTID and STI_MAGID=:STI_MAGID '+
                   'and STI_TGFID=:STI_TGFID and STI_COUID=:STI_COUID');

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

    nb := 0;
    Delai := GetTickCount;
    sInfo := 'ARTIDEAL 0';
    Lab_EnCours.Caption := sInfo;
    Application.ProcessMessages;
    TpListe.Clear;
    TpListe.LoadFromFile(FicArtIdeal);
    QueDiv.SQL.Clear;
    QueDiv.SQL.Add('insert into ARTIDEAL (STI_ID, STI_ARTID, STI_MAGID, STI_TGFID, STI_COUID, STI_QTE) '+
                   'values (:STI_ID, :STI_ARTID, :STI_MAGID, :STI_TGFID, :STI_COUID, :STI_QTE)');
    for i := 2 to TPListe.Count do
    begin
      sLigne := TPListe[i-1];
      sInfo := 'ARTIDEAL '+inttostr(i-1);
      if not(Dm_Main.Transaction.InTransaction) then
        Dm_Main.Transaction.StartTransaction;
      try

        iArtID := Dm_Main.GetArtID(GetValueLigne(sLigne, 1));
        iMagId := 0;
        sMagAdh := GetValueLigne(sLigne, 2);
        if Dm_Main.Cds_Magasin.Locate('MAG_CODEADH', sMagAdh, []) then
          iMagId := Dm_Main.Cds_Magasin.FieldByName('MAG_ID').AsInteger;
        iTgfID := Dm_Main.GetTgfID(GetValueLigne(sLigne, 3));
        iCouID := Dm_Main.GetCouID(GetValueLigne(sLigne, 4));
        vQte   := Round(ConvertStrToFloat(GetValueLigne(sLigne, 5)));
        bOk := true;
        if iArtID<=0 then
        begin
          LstErreur.Add('ARTID non trouvé: '+GetValueLigne(sLigne, 1));
          bOk := false;
        end;
        if iMagId<=0 then
        begin
          LstErreur.Add('Code magasin non trouvé: '+sMagAdh);
          bOk := false;
        end;
        if iTgfID<=0 then
        begin
          LstErreur.Add('TGFID non trouvé: '+GetValueLigne(sLigne, 3));
          bOk := false;
        end;
        if iCouID<=0 then
        begin
          LstErreur.Add('COUID non trouvé: '+GetValueLigne(sLigne, 4));
          bOk := false;
        end;
        // test existance
        if bOk then
        begin
          QueTst.ParamByName('STI_ARTID').AsInteger := iArtId;
          QueTst.ParamByName('STI_TGFID').AsInteger := iTgfID;
          QueTst.ParamByName('STI_MAGID').AsInteger := iMagID;
          QueTst.ParamByName('STI_COUID').AsInteger := iCouID;
          QueTst.Open;
          if QueTst.RecordCount>0 then
          begin
            bOk := false;
            LstErreur.Add('Triplette ARTID, TGFID et COUID déjà existant ('+
                              inttostr(iArtId)+','+
                              inttostr(iTgfID)+','+
                              inttostr(iCouID)+')');
          end;
          QueTst.Close;

        end;

        if bOk then
        begin
          iStiID := GetNewKid('ARTIDEAL');
          QueDiv.ParamByName('STI_ID').AsInteger := iStiId;
          QueDiv.ParamByName('STI_ARTID').AsInteger := iArtID;
          QueDiv.ParamByName('STI_MAGID').AsInteger := iMagId;
          QueDiv.ParamByName('STI_TGFID').AsInteger := iTgfID;
          QueDiv.ParamByName('STI_COUID').AsInteger := iCouID;
          QueDiv.ParamByName('STI_QTE').AsInteger := vQte;
          QueDiv.ExecSQL;
          QueDiv.Close;
        end;
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
      LstErreur.SaveToFile(ReperBase+'Erreur ArtIdeal '+formatdatetime('yyyy-mm-dd hhnnss', now)+'.txt');
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
  sFile: string;
begin
  sFile := '';
  odTemp := TOpenDialog.Create(Self);
  try
    odTemp.Filter := 'Fichier TOC|*.csv';
    odTemp.Title := 'Fichiers TOC';
    odTemp.Options := [ofReadOnly,ofPathMustExist,ofFileMustExist,ofNoReadOnlyReturn,ofEnableSizing];
    if odTemp.Execute then
      sFile := odTemp.FileName;
  finally
    odTemp.Free;
  end;
  if sFile='' then
    exit;
  FicArtIdeal := sFile;
  TraiteInfoArtIdeal;
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
