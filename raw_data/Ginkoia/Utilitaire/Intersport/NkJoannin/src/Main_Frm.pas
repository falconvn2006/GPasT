unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  IB_Components;

type
  TFrm_Main = class(TForm)
    Lab_DataBase: TLabel;
    edt_DataBase: TEdit;
    Nbt_DataBase: TSpeedButton;
    Lab_Login: TLabel;
    edt_Login: TEdit;
    Lab_Password: TLabel;
    edt_Password: TEdit;
    Lab_NkFile: TLabel;
    edt_NkFile: TEdit;
    Nbt_NkFile: TSpeedButton;
    Btn_Traitement: TButton;
    Btn_Quitter: TButton;
    Lab_UniverNom: TLabel;
    edt_UniverNom: TEdit;
    Lab_ActiviteNom: TLabel;
    Pan_Sep1: TPanel;
    cbx_ActiviteNom: TComboBox;
    Pan_Sep2: TPanel;
    Pan_Sep3: TPanel;
    Lab_Log: TLabel;
    cbx_Log: TComboBox;
    pgb_Progress: TProgressBar;
    Chk_Obligatoire: TCheckBox;
    Chk_ParDefaut: TCheckBox;
    Btn_AssignationArticle: TButton;
    Btn_VerificationNomk: TButton;

    procedure FormCreate(Sender: TObject);

    procedure edt_DataBaseChange(Sender: TObject);
    procedure Nbt_DataBaseClick(Sender: TObject);
    procedure edt_LoginChange(Sender: TObject);
    procedure edt_PasswordChange(Sender: TObject);
    procedure edt_NkFileChange(Sender: TObject);
    procedure Nbt_NkFileClick(Sender: TObject);
    procedure Btn_TraitementClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
    procedure Btn_AssignationArticleClick(Sender: TObject);
    procedure Btn_VerificationNomkClick(Sender: TObject);
  private
    { Déclarations privées }
    function VerifConnexion() : boolean;
    procedure FillCombo();

    function GetSQLValeur(Trans : TIB_Transaction; requete : string; out Count : integer) : integer;
    function FindSSFamilleFromUnivers(Trans : TIB_Transaction; idssf : integer; UniName : string; out Count : integer) : integer;

    function IntegrationNomenclature() : boolean;
    function AssignationArticle() : boolean;
    function VerificationNomenclature() : boolean;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  uGestionBDD,
  GestionLog,
  IBODataset,
  Generics.Collections,
  TypInfo,
  Math;

{$R *.dfm}

const
  idx_first_fedas = 9;

{ TFrm_Main }

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  tmp : TErrorLevel;
begin
  cbx_Log.Items.Clear();
  for tmp := Low(TErrorLevel) to High(TErrorLevel) do
    cbx_Log.Items.Add(Copy(GetEnumName(TypeInfo(TErrorLevel), ord(tmp)), 4, 1024));
  cbx_Log.ItemIndex := Ord(el_Warning);
end;

procedure TFrm_Main.edt_DataBaseChange(Sender: TObject);
begin
  if VerifConnexion() then
  begin
    FillCombo();
    Btn_Traitement.Enabled := FileExists(edt_NkFile.Text);
    Btn_AssignationArticle.Enabled := True;
    Btn_VerificationNomk.Enabled := True;
  end
  else
  begin
    Btn_Traitement.Enabled := false;
    Btn_AssignationArticle.Enabled := false;
    Btn_VerificationNomk.Enabled := false;
  end;
end;

procedure TFrm_Main.Nbt_DataBaseClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier Interbase (*.ib)|*.ib';
    Open.InitialDir := ExtractFilePath(edt_Database.Text);
    Open.FileName := ExtractFileName(edt_Database.Text);
    if Open.Execute() then
      edt_Database.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure TFrm_Main.edt_LoginChange(Sender: TObject);
begin
  if VerifConnexion() then
  begin
    FillCombo();
    Btn_Traitement.Enabled := FileExists(edt_NkFile.Text);
    Btn_AssignationArticle.Enabled := True;
    Btn_VerificationNomk.Enabled := True;
  end
  else
  begin
    Btn_Traitement.Enabled := false;
    Btn_AssignationArticle.Enabled := false;
    Btn_VerificationNomk.Enabled := false;
  end;
end;

procedure TFrm_Main.edt_PasswordChange(Sender: TObject);
begin
  if VerifConnexion() then
  begin
    FillCombo();
    Btn_Traitement.Enabled := FileExists(edt_NkFile.Text);
    Btn_AssignationArticle.Enabled := True;
    Btn_VerificationNomk.Enabled := True;
  end
  else
  begin
    Btn_Traitement.Enabled := false;
    Btn_AssignationArticle.Enabled := false;
    Btn_VerificationNomk.Enabled := false;
  end;
end;

procedure TFrm_Main.edt_NkFileChange(Sender: TObject);
begin
  Btn_Traitement.Enabled := FileExists(edt_NkFile.Text) and VerifConnexion();
end;

procedure TFrm_Main.Nbt_NkFileClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier CSV (*.csv)|*.csv';
    Open.InitialDir := ExtractFilePath(edt_NkFile.Text);
    Open.FileName := ExtractFileName(edt_NkFile.Text);
    if Open.Execute() then
      edt_NkFile.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure TFrm_Main.Btn_TraitementClick(Sender: TObject);
begin
  try
    Self.Enabled := false;
    Screen.Cursor := crHourGlass;

    Log_Init(TErrorLevel(cbx_Log.ItemIndex), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log'));

    if IntegrationNomenclature() then
      MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0)
    else
      MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0)

  finally
    Screen.Cursor := crDefault;
    Self.Enabled := true;
  end;
end;

procedure TFrm_Main.Btn_AssignationArticleClick(Sender: TObject);
begin
  try
    Self.Enabled := false;
    Screen.Cursor := crHourGlass;

    Log_Init(TErrorLevel(cbx_Log.ItemIndex), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log'));

    if AssignationArticle() then
      MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0)
    else
      MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0)

  finally
    Screen.Cursor := crDefault;
    Self.Enabled := true;
  end;
end;

procedure TFrm_Main.Btn_VerificationNomkClick(Sender: TObject);
begin
  try
    Self.Enabled := false;
    Screen.Cursor := crHourGlass;

    Log_Init(TErrorLevel(cbx_Log.ItemIndex), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log'));

    if VerificationNomenclature() then
      MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0)
    else
      MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0)

  finally
    Screen.Cursor := crDefault;
    Self.Enabled := true;
  end;
end;

procedure TFrm_Main.Btn_QuitterClick(Sender: TObject);
begin
  Close();
end;

// Utilitaire graphique

function TFrm_Main.VerifConnexion() : boolean;
var
  Query : TIBOQuery;
begin
  Result := false;
  if FileExists(edt_DataBase.Text) then
  begin
    try
      try
        Query := GetNewQuery(GetNewTransaction(GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text)));
        Result := true;
      finally
        Query.IB_Transaction.Rollback();
        Query.IB_Transaction.Close();
        Query.IB_Transaction.Free();
        Query.IB_Connection.Free();
        FreeAndNil(Query);
      end;
    except
      on e : Exception do
      begin
        // Nothing;
      end;
    end;
  end;
end;

procedure TFrm_Main.FillCombo();
var
  Query : TIBOQuery;
begin
  cbx_ActiviteNom.Items.Clear();
  if FileExists(edt_DataBase.Text) then
  begin
    try
      try
        Query := GetNewQuery(GetNewTransaction(GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text)));
        Query.SQL.Text := 'select act_id, act_nom from nklactivite join k on k_id = act_id and k_enabled = 1 where act_id != 0 order by act_nom;';
        Query.Open();
        while not Query.Eof do
        begin
          cbx_ActiviteNom.Items.AddObject(Query.FieldByName('act_nom').AsString, Pointer(Query.FieldByName('act_id').AsInteger));
          Query.Next();
        end;
      finally
        Query.IB_Transaction.Rollback();
        Query.IB_Transaction.Close();
        Query.IB_Transaction.Free();
        Query.IB_Connection.Free();
        FreeAndNil(Query);
      end;
    except
      on e : Exception do
      begin
        cbx_ActiviteNom.Items.Clear();
        MessageDlg('Erreur : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0)
      end;
    end;
  end;
  cbx_ActiviteNom.ItemIndex := cbx_ActiviteNom.Items.Count -1;
end;

// Utilitaire non graphique

function TFrm_Main.GetSQLValeur(Trans : TIB_Transaction; requete : string; out Count : integer) : integer;
var
  Query : TIBOQuery;
begin
  Result := -1;
  Count := 0;
  Log_Write('GetSQLValeur("' + requete + '")', el_Verbose);
  try
    Query := GetNewQuery(Trans);
    Query.SQL.Text := requete;
    Query.Open();
    if not Query.Eof then
    begin
      Result := Query.Fields[0].AsInteger;
      Count := Query.RecordCount;
    end;
  finally
    FreeAndNil(Query);
  end;
  Log_Write('            -> ' + IntToStr(Result), el_Verbose);
end;

function TFrm_Main.FindSSFamilleFromUnivers(Trans : TIB_Transaction; idssf : integer; UniName : string; out count : integer) : integer;
begin
  Log_Write('FindSSFamilleUniversCommerciaux("' + IntToStr(idssf) + '")', el_Verbose);
  Result := GetSQLValeur(Trans, 'select ssf_id '
                              + 'from nklaxeaxe join k on k_id = axx_id and k_enabled = 1 '
                              + 'join nklssfamille join k on k_id = ssf_id and k_enabled = 1 on (ssf_id = axx_ssfid1 or ssf_id = axx_ssfid2) '
                              + 'join nklfamille on fam_id = ssf_famid '
                              + 'join nklrayon on ray_id = fam_rayid '
                              + 'join nklsecteur on sec_id = ray_secid '
                              + 'join nklunivers on uni_id = sec_uniid '
                              + 'where (axx_ssfid1 = ' + IntToStr(idssf) + ' or axx_ssfid2 = ' + IntToStr(idssf) + ') '
                              + 'and ssf_id != ' + IntToStr(idssf) + ' and upper(uni_nom) = ' + QuotedStr(UpperCase(UniName)) + ';', Count);
  Log_Write('                               -> ' + IntToStr(Result), el_Verbose);
end;

// Traitements

function TFrm_Main.IntegrationNomenclature() : boolean;

  procedure SplitLine(Text : string; var Infos : TStringList; Sep : char = ';');
  var
    possep, idx : integer;
    tmp : string;
  begin
    Log_Write('SplitLine("' + Text + '")', el_Verbose);
    idx := 0;
    while Length(Text) > 0 do
    begin
      possep := pos(sep, Text);
      if possep > 0 then
      begin
        tmp := Copy(Text, 1, Possep -1);
        Text := Copy(Text, possep +1, Length(Text));
      end
      else
      begin
        tmp := Text;
        Text := '';
      end;
      if Infos.Count <= idx then
        Infos.Add('');
      if not (Trim(tmp) = '') then
      begin
        Infos[idx] := tmp;
        // au premier nouveau text, on netoye la suite
        while Infos.Count > (idx +1) do
          Infos.Delete(idx +1);
      end;
      Inc(idx);
    end;
    while Infos.Count > idx do
      Infos.Delete(idx);
    while (Infos.Count >= idx_first_fedas) and (Trim(Infos[Infos.Count -1]) = '') do
      Infos.Delete(Infos.Count -1);
    Log_Write('         -> Fin', el_Verbose);
  end;


  function CreateEnreg(Trans : TIB_Transaction; Table, Champs, Valeurs : string) : integer;
  var
    Query : TIBOQuery;
  begin
    Result := -1;
    Log_Write('CreateEnreg("' + Table + '", "' + Champs + '", "' + Valeurs + '")', el_Verbose);
    try
      // nouveau K
      Query := GetNewQuery(Trans);
      Query.SQL.Text := 'select id from pr_newk(' + QuotedStr(Table) + ');';
      Query.Open();
      if not Query.Eof then
        Result := Query.FieldByName('id').AsInteger
      else
        Raise Exception.Create('Erreur a la creation du K !');
      Query.Close();
      // insertion des nos données
      Query.SQL.Text := 'insert into ' + Table + ' '
                      + '(' + Champs + ') '
                      + 'values (' + IntToStr(Result) + ', ' + Valeurs + ');';
      Query.ExecSQL();
    finally
      FreeAndNil(Query);
    end;
    Log_Write('           -> ' + IntToStr(Result), el_Verbose);
  end;


  function VerifExistUnivers(Trans : TIB_Transaction; idact : integer; libelle : string) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistUnivers("' + IntToStr(idact) + '", "' + libelle + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select uni_id '
                                + 'from nklunivers join k on k_id = uni_id and k_enabled = 1 '
                                + 'where uni_actid = ' + IntToStr(idact) + ' and uni_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                 -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateUnivers(Trans : TIB_Transaction; idact : integer; libelle : string) : integer;

    function GetObligatoire() : string;
    begin
      if Chk_Obligatoire.Checked then
        Result := '1'
      else
        Result := '0';
    end;

  begin
    Log_Write('CreateUnivers("' + IntToStr(idact) + '", "' + libelle + '")', el_Verbose);
    Result := CreateEnreg(Trans, 'nklunivers'
                               , 'uni_id, uni_idref, uni_nom, uni_niveau, uni_origine, uni_code, uni_centrale, uni_obligatoire, uni_actid, uni_libn1, uni_libn2, uni_libn3, uni_libn4, uni_look, uni_relation'
                               , '0, '                        // uni_idref
                               + QuotedStr(libelle) + ', '    // uni_nom
                               + '4, '                        // uni_niveau
                               + '1, '                        // uni_origine
                               + QuotedStr('') + ', '         // uni_code
                               + '0, '                        // uni_centrale
                               + GetObligatoire() + ', '      // uni_obligatoire
                               + IntToStr(idact) + ', '       // uni_actid
                               + QuotedStr('NIVEAU 1') + ', ' // uni_libn1
                               + QuotedStr('NIVEAU 2') + ', ' // uni_libn2
                               + QuotedStr('NIVEAU 3') + ', ' // uni_libn3
                               + QuotedStr('NIVEAU 4') + ', ' // uni_libn4
                               + '0, '                        // uni_look
                               + '1'                          // uni_relation
                         );
    Log_Write('             -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistSeteur(Trans : TIB_Transaction; iduni : integer; code, libelle : string) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistSeteur("' + IntToStr(iduni) + '", "' + code + '", "' + libelle + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select sec_id '
                                + 'from nklsecteur join k on k_id = sec_id and k_enabled = 1 '
                                + 'where sec_uniid = ' + IntToStr(iduni) + ' and sec_code = ' + QuotedStr(code) + ' and sec_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateSecteur(Trans : TIB_Transaction; iduni : integer; code, libelle : string; var ordre : integer) : integer;
  begin
    Log_Write('CreateSecteur("' + IntToStr(iduni) + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '")', el_Verbose);
    Inc(ordre, 10);
    Result := CreateEnreg(Trans, 'nklsecteur'
                               , 'sec_id, sec_idref, sec_nom, sec_uniid, sec_type, sec_ordreaff, sec_code, sec_codeniv, sec_visible, sec_centrale'
                               , '0, '                     // sec_idref
                               + QuotedStr(libelle) + ', ' // sec_nom
                               + IntToStr(iduni) + ', '    // sec_uniid
                               + '1, '                     // sec_type
                               + IntToStr(ordre) + ', '    // sec_ordreaff
                               + QuotedStr(code) + ', '    // sec_code
                               + QuotedStr(code) + ', '    // sec_codeniv
                               + '1, '                     // sec_visible
                               + '0'                       // sec_centrale
                         );
    Log_Write('             -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistRayon(Trans : TIB_Transaction; idsec : integer; code, libelle : string) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistRayon("' + IntToStr(idsec) + '", "' + code + '", "' + libelle + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select ray_id '
                                + 'from nklrayon join k on k_id = ray_id and k_enabled = 1 '
                                + 'where ray_secid = ' + IntToStr(idsec) + ' and ray_code = ' + QuotedStr(code) + ' and ray_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('               -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateRayon(Trans : TIB_Transaction; iduni, idsec : integer; basecode, code, libelle : string; var ordre : integer) : integer;
  begin
    Log_Write('CreateRayon("' + IntToStr(iduni) + '", "' + IntToStr(idsec) + '", "' + basecode + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '")', el_Verbose);
    Inc(ordre, 10);
    Result := CreateEnreg(Trans, 'nklrayon'
                               , 'ray_id, ray_uniid, ray_idref, ray_nom, ray_ordreaff, ray_visible, ray_secid, ray_code, ray_codeniv, ray_centrale'
                               , IntToStr(iduni) + ', '            // ray_uniid
                               + '0, '                             // ray_idref
                               + QuotedStr(libelle) + ', '         // ray_nom
                               + IntToStr(ordre) + ', '            // ray_ordreaff
                               + '1, '                             // ray_visible
                               + IntToStr(idsec) + ', '            // ray_secid
                               + QuotedStr(code) + ', '            // ray_code
                               + QuotedStr(basecode + code) + ', ' // ray_codeniv
                               + '0'                               // ray_centrale
                         );
    Log_Write('           -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistFamille(Trans : TIB_Transaction; idray : integer; code, libelle : string) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistFamille("' + IntToStr(idray) + '", "' + code + '", "' + libelle + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select fam_id '
                                + 'from nklfamille join k on k_id = fam_id and k_enabled = 1 '
                                + 'where fam_rayid = ' + IntToStr(idray) + ' and fam_code = ' + QuotedStr(code) + ' and fam_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                 -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateFamille(Trans : TIB_Transaction; idray : integer; basecode, code, libelle : string; var ordre : integer) : integer;
  begin
    Log_Write('CreateFamille("' + IntToStr(idray) + '", "' + basecode + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '")', el_Verbose);
    Inc(ordre, 10);
    Result := CreateEnreg(Trans, 'nklfamille'
                               , 'fam_id, fam_rayid, fam_idref, fam_nom, fam_ordreaff, fam_visible, fam_ctfid, fam_code, fam_codeniv, fam_centrale'
                               , IntToStr(idray) + ', '            // fam_rayid
                               + '0, '                             // fam_idref
                               + QuotedStr(libelle) + ', '         // fam_nom
                               + IntToStr(ordre) + ', '            // fam_ordreaff
                               + '1, '                             // fam_visible
                               + '0, '                             // fam_ctfid
                               + QuotedStr(code) + ', '            // fam_code
                               + QuotedStr(basecode + code) + ', ' // fam_codeniv
                               + '0'                               // fam_centrale
                         );
    Log_Write('             -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistSSFamille(Trans : TIB_Transaction; idfam : integer; code, libelle : string) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistSSFamille("' + IntToStr(idfam) + '", "' + code + '", "' + libelle + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select ssf_id '
                                + 'from nklssfamille join k on k_id = ssf_id and k_enabled = 1 '
                                + 'where ssf_famid = ' + IntToStr(idfam) + ' and ssf_code = ' + QuotedStr(code) + ' and ssf_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                   -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateSSFamille(Trans : TIB_Transaction; idfam, idtva, idtct : integer; basecode, code, libelle : string; var ordre : integer) : integer;
  begin
    Log_Write('CreateSSFamille("' + IntToStr(idfam) + '", "' + IntToStr(idtva) + '", "' + IntToStr(idtct) + '", "' + basecode + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '")', el_Verbose);
    Inc(ordre, 10);
    Result := CreateEnreg(Trans, 'nklssfamille'
                               , 'ssf_id, ssf_famid, ssf_idref, ssf_nom, ssf_ordreaff, ssf_visible, ssf_catid, ssf_tvaid, ssf_tctid, ssf_code, ssf_codeniv, ssf_codefinal, ssf_centrale, ssf_tgtcode'
                               , IntToStr(idfam) + ', '            // ssf_famid
                               + '0, '                             // ssf_idref
                               + QuotedStr(libelle) + ', '         // ssf_nom
                               + IntToStr(ordre) + ', '            // ssf_ordreaff
                               + '1, '                             // ssf_visible
                               + '0, '                             // ssf_catid
                               + IntToStr(idtva) + ', '            // ssf_tvaid
                               + IntToStr(idtct) + ', '            // ssf_tctid
                               + QuotedStr(code) + ', '            // ssf_code
                               + QuotedStr(basecode + code) + ', ' // ssf_codeniv
                               + QuotedStr(basecode + code) + ', ' // ssf_codefinal
                               + '0, '                             // ssf_centrale
                               + QuotedStr('')                     // ssf_tgtcode
                         );
    Log_Write('               -> ' + IntToStr(Result), el_Verbose);
  end;


  function FindSSFamilleFedas(Trans : TIB_Transaction; code : string) : integer;
  var
    Count : integer;
  begin
    Log_Write('FindSSFamilleFedas("' + code + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select ssf_id '
                                + 'from nklssfamille join k on k_id = ssf_id and k_enabled = 1 '
                                + 'join nklfamille on fam_id = ssf_famid '
                                + 'join nklrayon on ray_id = fam_rayid '
                                + 'join nklsecteur on sec_id = ray_secid '
                                + 'join nklunivers on uni_id = sec_uniid '
                                + 'where ssf_codefinal = ' + QuotedStr(code) + ' and upper(uni_nom) = ' + QuotedStr('FEDAS') + ';', COunt);
    Log_Write('                  -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistRelation(Trans : TIB_Transaction; ssfidnew, ssfidlien : integer) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistRelation("' + IntToStr(ssfidnew) + '", "' + IntToStr(ssfidlien) + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select axx_id '
                                + 'from nklaxeaxe join k on k_id = axx_id and k_enabled = 1 '
                                + 'where (axx_ssfid1 = ' + IntToStr(ssfidnew) + ' and axx_ssfid2 = ' + IntToStr(ssfidlien) + ') '
                                + '   or (axx_ssfid1 = ' + IntToStr(ssfidlien) + ' and axx_ssfid2 = ' + IntToStr(ssfidnew) + ');', Count);
    Log_Write('                  -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateRelation(Trans : TIB_Transaction; ssfidnew, ssfidlien : integer) : integer;
  begin
    Log_Write('CreateRelation("' + IntToStr(ssfidnew) + '", "' + IntToStr(ssfidlien) + '")', el_Verbose);
    Result := CreateEnreg(Trans, 'nklaxeaxe'
                               , 'axx_id, axx_ssfid1, axx_ssfid2, axx_centrale'
                               , IntToStr(ssfidnew) + ', '   // axx_ssfid1
                               + IntToStr(ssfidlien) + ', ' // axxssfid2
                               + '0'                         // axx_centrale
                         );
    Log_Write('              -> ' + IntToStr(Result), el_Verbose);
  end;


  procedure UpdateActivité(Trans : TIB_Transaction; actid, newuniid : integer);
  var
    Query : TIBOQuery;
  begin
    Log_Write('UpdateActivité("' + IntToStr(newuniid) + '", "' + IntToStr(actid) + '")', el_Verbose);
    try
      // nouveau K
      Query := GetNewQuery(Trans);
      Query.SQL.Text := 'update nklactivite set act_uniid = ' + IntToStr(newuniid) + ' where act_id = ' + IntToStr(actid) + ';';
      Query.ExecSQL();
      Query.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(actid) + ', 0);';
      Query.ExecSQL();
    finally
      FreeAndNil(Query);
    end;
    Log_Write('             -> fin', el_Verbose);
  end;

var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;

  seccode, raycode, famcode, ssfcode,
  secname, rayname, famname, ssfname,
  fedascode : string;

  TvaId, TctId,
  ActId, UniId,
  SecId, RayId, FamId, SsfId,
  secordre, rayordre, famordre, ssfordre,
  FedasSSFId, UniComSSFId : integer;

  Lignes, Infos : TStringList;
  i, Count, nblienfedas, nblienunicom : integer;
begin
  Result := false;
  Log_Write('', el_Info);
  Log_Write('==================================================', el_Info);
  Log_Write('Démarage de l''integration', el_Info);
  try
    Connexion := GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text);
    Transaction := GetNewTransaction(Connexion, false);
    try
      Transaction.StartTransaction();

      // Paramétrage
      Log_Write('Lecture des paramètres utils', el_Etape);
      ActId := Integer(Pointer(cbx_ActiviteNom.Items.Objects[cbx_ActiviteNom.ItemIndex]));
      TvaId := GetSQLValeur(Transaction, 'select tva_id '
                                       + 'from arttva join k on k_id = tva_id and k_enabled = 1 '
                                       + 'where tva_taux = (select dos_float '
                                       + '                  from gendossier join k on k_id = dos_id and k_enabled = 1 '
                                       + '                  where dos_nom = ''TVA'') '
                                       + 'order by tva_id;', Count);
      TctId := GetSQLValeur(Transaction, 'select tct_id '
                                       + 'from arttypecomptable join k on k_id = tct_id and k_enabled = 1 '
                                       + 'where tct_nom = ' + QuotedStr('PRODUIT') + ';', Count);

      if (ActId < 0) then
        raise Exception.Create('Activité sélectionnée non trouver');
      if (TvaId < 0) then
        raise Exception.Create('Ligne de TVA normal non trouver');
      if (TctId < 0) then
        raise Exception.Create('Ligne de type comptable "PRODUIT" non trouver');

      // selection/creation de l'univers !
      Log_Write('Gestion de l''univers', el_Etape);
      UniId := VerifExistUnivers(Transaction, ActId, edt_UniverNom.Text);
      if UniId < 0 then
      begin
        UniId := CreateUnivers(Transaction, ActId, edt_UniverNom.Text);
        secordre := 0;
      end
      else
      begin
        secordre := GetSQLValeur(Transaction, 'select max(sec_ordreaff) from nklsecteur where sec_uniid = ' + intToStr(UniId) + ';', Count);
      end;

      try
        Log_Write('Lecture du fichier', el_Etape);
        Lignes := TStringList.Create();
        Infos := TStringList.Create();
        Lignes.LoadFromFile(edt_NkFile.Text);

        pgb_Progress.Position := 0;
        pgb_Progress.Max := Lignes.Count -2;
        pgb_Progress.Step := 1;

        for i := 2 to Lignes.Count -1 do
        begin
          Log_Write('gestion de la ligne ' + IntToStr(i +1), el_Etape);
          SplitLine(Lignes[i], Infos);
          pgb_Progress.Stepit();
          Application.ProcessMessages();

          if Infos.Count > 7 then
          begin
            // recup des infos
            seccode := Infos[0];
            secname := Infos[1];
            raycode := Infos[2];
            rayname := Infos[3];
            famcode := Infos[4];
            famname := Infos[5];
            ssfcode := Infos[6];
            ssfname := Infos[7];

            // gestion de niveau non renseigné !
            if Trim(raycode) = '' then
            begin
              raycode := seccode;
              Log_Write('Code de rayon non renseigné, reprise du code de section ligne ' + IntToStr(i +1), el_Warning);
            end;
            if Trim(rayname) = '' then
            begin
              rayname := secname;
              Log_Write('Nom de rayon non renseigné, reprise du nom de section ligne ' + IntToStr(i +1), el_Warning);
            end;
            if Trim(famcode) = '' then
            begin
              Famcode := raycode;
              Log_Write('Code de famille non renseigné, reprise du code de rayon ligne ' + IntToStr(i +1), el_Warning);
            end;
            if Trim(famname) = '' then
            begin
              famname := rayname;
              Log_Write('Nom de famille non renseigné, reprise du nom de rayon ligne ' + IntToStr(i +1), el_Warning);
            end;
            if Trim(ssfcode) = '' then
            begin
              ssfcode := famcode;
              Log_Write('Code de sous-famille non renseigné, reprise du code de famille ligne ' + IntToStr(i +1), el_Warning);
            end;
            if Trim(ssfname) = '' then
            begin
              ssfname := famname;
              Log_Write('Nom de sous-famille non renseigné, reprise du nom de famille ligne ' + IntToStr(i +1), el_Warning);
            end;

            // gestion de la section
            Log_Write('Gestion de la section "' + seccode + ' - ' + secname + '"', el_Debug);
            SecId := VerifExistSeteur(Transaction, UniId, seccode, secname);
            if SecId < 0 then
            begin
              SecId := CreateSecteur(Transaction, UniId, seccode, secname, secordre);
              rayordre := 0;
            end
            else
            begin
              rayordre := GetSQLValeur(Transaction, 'select max(ray_ordreaff) from nklrayon where ray_secid = ' + intToStr(SecId) + ';', Count);
            end;

            // gestion du rayon
            Log_Write('Gestion du rayon "' + raycode + ' - ' + rayname + '"', el_Debug);
            RayId := VerifExistRayon(Transaction, SecId, raycode, rayname);
            if RayId < 0 then
            begin
              RayId := CreateRayon(Transaction, UniId, SecID, seccode, raycode, rayname, rayordre);
              famordre := 0;
            end
            else
            begin
              famordre := GetSQLValeur(Transaction, 'select max(fam_ordreaff) from nklfamille where fam_rayid = ' + intToStr(RayId) + ';', Count);
            end;

            // gestion de la famille
            Log_Write('Gestion de la famille "' + famcode + ' - ' + famname + '"', el_Debug);
            FamId := VerifExistFamille(Transaction, RayId, famcode, famname);
            if FamId < 0 then
            begin
              FamId := CreateFamille(Transaction, RayId, seccode + raycode, famcode, famname, famordre);
              ssfordre := 0;
            end
            else
            begin
              ssfordre := GetSQLValeur(Transaction, 'select max(ssf_ordreaff) from nklssfamille where ssf_famid = ' + intToStr(FamId) + ';', Count);
            end;

            // gestion de la sous-famille
            Log_Write('Gestion de la sous-famille "' + ssfcode + ' - ' + ssfname + '"', el_Debug);
            SsfId := VerifExistSSFamille(Transaction, FamId, ssfcode, ssfname);
            if SsfId < 0 then
            begin
              SsfId := CreateSSFamille(Transaction, FamId, TvaId, TctId, seccode + raycode + famcode, ssfcode, ssfname, ssfordre);
            end
            else
            begin
            end;

            // gestion de la relation entre axes !
            nblienfedas := 0;
            nblienunicom := 0;
            while Infos.Count > idx_first_fedas do
            begin
              fedascode := Trim(Infos[idx_first_fedas]);
              Infos.Delete(idx_first_fedas);
              if not (fedascode = '') then
              begin
                Log_Write('Recherche de la FEDAS code "' + fedascode + '"', el_Debug);
                FedasSSFId := FindSSFamilleFedas(Transaction, fedascode);
                if (FedasSSFId > 0) then
                begin
                  if FindSSFamilleFromUnivers(Transaction, FedasSSFId, edt_UniverNom.Text, Count) < 0 then
                  begin
                    if VerifExistRelation(Transaction, SsfId, FedasSSFId) < 0 then
                      CreateRelation(Transaction, SsfId, FedasSSFId);
                    Inc(nblienfedas);

                    Log_Write('Recherche de l''univers commercial lié', el_Debug);
                    UniComSSFId := FindSSFamilleFromUnivers(Transaction, FedasSSFId, 'UNIVERS COMMERCIAUX', Count);
                    if (UniComSSFId > 0) and (Count = 1)then
                    begin
                      if VerifExistRelation(Transaction, SsfId, UniComSSFId) < 0 then
                        CreateRelation(Transaction, SsfId, UniComSSFId);
                      Inc(nblienunicom);
                    end
                    else if (Count > 1) then
                      Log_Write('Plusieur sous-famille dans l''UNIVERS COMMERCIAUX pour l''id fedas "' + IntToStr(FedasSSFId) + '"', el_Debug)
                    else
                      Log_Write('Pas de sous-famille dans l''UNIVERS COMMERCIAUX pour l''id fedas "' + IntToStr(FedasSSFId) + '"', el_Debug)
                  end
                  else
                    Log_Write('Sous-famille FEADS ' + fedascode + ' déjà lié a un sous-famille ' + edt_UniverNom.Text + ' ligne ' + IntToStr(i +1), el_Warning)
                end
                else
                  Log_Write('Pas de sous-famille dans la FEDAS pour le code "' + fedascode + '"', el_Debug)
              end;
            end;

            if nblienfedas = 0 then
              Log_Write('Pas de liaison FEDAS valide pour la sous-famille code "' + seccode + ' ' + raycode + ' ' + famcode + ' ' + ssfcode + '" ligne ' + IntToStr(i +1), el_Warning)
            else if nblienunicom = 0 then
              Log_Write('Pas de liaison UNIVERS COMMERCIAUX valide pour la sous-famille code "' + seccode + ' ' + raycode + ' ' + famcode + ' ' + ssfcode + '" ligne ' + IntToStr(i +1), el_Warning)
          end
          else
            Log_Write('Nombre de colonne insufisant a la ligne ' + IntToStr(i +1), el_Warning);
        end;
      finally
        FreeAndNil(Infos);
        FreeAndNil(Lignes);
      end;

      Log_Write('Fin du fichier', el_Etape);

      // verification liaison

      // mise en place de l'univer comme univer par defaut
      if Chk_ParDefaut.Checked then
      begin
        Log_Write('Activation de l''univers comme par défaut', el_Etape);
        UpdateActivité(Transaction, ActId, UniId);
      end;

      Transaction.Commit();
      Result := true;
    except
      on e : Exception do
      begin
        Transaction.Rollback();
        Log_Write('Exception : ' + e.ClassName + ' - ' + e.Message, el_Erreur);
        MessageDlg('Exception lors du traitement : ' + #13 + e.ClassName + ' - ' + e.Message + #13 + 'Rollback sur le traitement !', mtError, [mbOK], 0);
      end;
    end;
  finally
    FreeAndNil(Transaction);
    FreeAndNil(Connexion);
  end;
end;

function TFrm_Main.AssignationArticle() : boolean;
var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
begin
  Result := false;
  Log_Write('', el_Info);
  Log_Write('==================================================', el_Info);
  Log_Write('Démarage de l''assignation', el_Info);
  try
    Connexion := GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text);
    Transaction := GetNewTransaction(Connexion, false);
    try
      Transaction.StartTransaction();


      // TODO -obpy : traitement


      Transaction.Commit();
      Result := true;
    except
      on e : Exception do
      begin
        Transaction.Rollback();
        Log_Write('Exception : ' + e.ClassName + ' - ' + e.Message, el_Erreur);
        MessageDlg('Exception lors du traitement : ' + #13 + e.ClassName + ' - ' + e.Message + #13 + 'Rollback sur le traitement !', mtError, [mbOK], 0);
      end;
    end;
  finally
    FreeAndNil(Transaction);
    FreeAndNil(Connexion);
  end;
end;

function TFrm_Main.VerificationNomenclature() : boolean;
var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;
  Query : TIBOQuery;
  tmpSSFId, Count : integer;
  Error : boolean;
begin
  Result := false;
  Error := false;
  Log_Write('', el_Info);
  Log_Write('==================================================', el_Info);
  Log_Write('Démarage de la verification', el_Info);
  try
    Connexion := GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text);
    Transaction := GetNewTransaction(Connexion, false);
    try
      Transaction.StartTransaction();

      Query := GetNewQuery(Transaction);
      Query.SQL.Text := 'select ssf_id, ssf_codefinal '
                      + 'from nklssfamille join k on k_id = ssf_id and k_enabled = 1 '
                      + 'join nklfamille on fam_id = ssf_famid '
                      + 'join nklrayon on ray_id = fam_rayid '
                      + 'join nklsecteur on sec_id = ray_secid '
                      + 'join nklunivers on uni_id = sec_uniid '
                      + 'where upper(uni_nom) = ' + QuotedStr(UpperCase('FEDAS')) + ';';
      Query.Open();

      pgb_Progress.Position := 0;
      pgb_Progress.Max := Query.RecordCount;
      pgb_Progress.Step := 1;

      while not Query.Eof do
      begin
        pgb_Progress.Stepit();
        Application.ProcessMessages();

        tmpSSFId := FindSSFamilleFromUnivers(Transaction, Query.FieldByName('ssf_id').AsInteger, edt_UniverNom.Text, Count);
        if Count > 1 then
        begin
          Error := true;
          Log_Write('Plusieur lien (' + IntToStr(Count) + ') depuis la FEDAS code ' + Query.FieldByName('ssf_codefinal').AsString + ' vers l''univers ' + edt_UniverNom.Text, el_Warning);
        end
        else if Count = 0 then
        begin
          Error := true;
          Log_Write('Pas de lien depuis la FEDAS code ' + Query.FieldByName('ssf_codefinal').AsString + ' vers l''univers ' + edt_UniverNom.Text, el_Warning);
        end;
        Query.Next();
      end;

      Transaction.Commit();
      Result := true;
    except
      on e : Exception do
      begin
        Transaction.Rollback();
        Log_Write('Exception : ' + e.ClassName + ' - ' + e.Message, el_Erreur);
        MessageDlg('Exception lors du traitement : ' + #13 + e.ClassName + ' - ' + e.Message + #13 + 'Rollback sur le traitement !', mtError, [mbOK], 0);
      end;
    end;
  finally
    FreeAndNil(Transaction);
    FreeAndNil(Connexion);
  end;
end;

end.
