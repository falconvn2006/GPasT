unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  IB_Components;

type
  TNkType = ( {nktJoannin,} nktSport2000 );
  TFedasPart=( fpProduit, fpDomaine, fpGroupe, fpSousGroupe );
  TFedasParts=set of TFedasPart;

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
    Lab_ActiviteNom: TLabel;
    Pan_Sep1: TPanel;
    edt_ActiviteNom: TComboBox;
    Pan_Sep2: TPanel;
    Pan_Sep3: TPanel;
    Lab_Log: TLabel;
    cbx_Log: TComboBox;
    pgb_Progress: TProgressBar;
    Chk_Obligatoire: TCheckBox;
    Chk_ParDefaut: TCheckBox;
    Btn_AssignationArticle: TButton;
    Btn_VerificationNomk: TButton;
    edt_UniverNom: TComboBox;
    edt_NkType: TComboBox;

    procedure FormCreate(Sender: TObject);
    procedure Nbt_DataBaseClick(Sender: TObject);
    procedure Nbt_NkFileClick(Sender: TObject);
    procedure Btn_TraitementClick(Sender: TObject);
    procedure Btn_QuitterClick(Sender: TObject);
    procedure Btn_AssignationArticleClick(Sender: TObject);
    procedure Btn_VerificationNomkClick(Sender: TObject);
    procedure FieldsChange(Sender: TObject);
  private type
    TFlagValue = ( fvDefault = 0, fvSucceed = 1, fvFailed = 2, fvPending = 4, fvUnknown = 8 );  
  private
    { Déclarations privées }
    AutoClose, AutoStart: Boolean;
    SauvUnivers: String;
    function VerifConnexion() : boolean;
    procedure FillUniversActivites();

    function GetSQLValeur(Trans : TIB_Transaction; requete : string; out Count : integer) : integer;
    function FindSSFamilleFromUnivers(Trans : TIB_Transaction; idssf : integer; UniName : string; out Count : integer) : integer;

    function IntegrationNomenclature() : boolean;
    function AssignationArticle() : boolean;
    function VerificationNomenclature() : boolean;
    function RechercheAncienneFEDAS: Boolean;
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
  Math,
  StrUtils, UVersion;

{$R *.dfm}

const
  idx_first_fedas = 9;

{ TFrm_Main }

procedure TFrm_Main.FormCreate(Sender: TObject);
var
  ErrLvl : TErrorLevel;
  prm : String;
  int : Integer;
  NkType: TNkType;
begin
  // Interface
  cbx_Log.Items.Clear();
  for ErrLvl := Low(TErrorLevel) to High(TErrorLevel) do
    cbx_Log.Items.Add(Copy(GetEnumName(TypeInfo(TErrorLevel), ord(ErrLvl)), 4, 1024));
  cbx_Log.ItemIndex := Ord(el_Warning);

  edt_UniverNom.DoubleBuffered := True;
  edt_ActiviteNom.DoubleBuffered := True;

  edt_NkType.Items.Clear();
  for NkType := Low( TNkType ) to High( TNkType ) do
    edt_NkType.Items.Add( Copy( GetEnumName( TypeInfo( TNkType ), Ord( NkType )), 4, 1024 ));
  edt_NkType.ItemIndex := Ord( nktSport2000 );

  if ( edt_NkType.Items.Count = 1 ) and ( Low( TNkType ) = nktSport2000 ) then
  begin
    edt_NkType.Style := csSimple;
    edt_NkType.Enabled := False;
    Chk_Obligatoire.Enabled := False;
    Chk_ParDefaut.Enabled := False;
    edt_ActiviteNom.Enabled := False;
    edt_UniverNom.Enabled := False;
    Lab_ActiviteNom.Enabled := False;
    Lab_UniverNom.Enabled := False;
    edt_UniverNom.Text := '';
    Chk_Obligatoire.Checked := True;
    Chk_ParDefaut.Checked := True;
  end;


  // Gestion des parametres
  if FindCmdLineSwitch( 'b', prm ) and FileExists( prm ) then
    edt_DataBase.Text := prm;
  if FindCmdLineSwitch( 'l', prm ) then
    edt_Login.Text := prm;
  if FindCmdLineSwitch( 'p', prm ) then
    edt_Password.Text := prm;
  if FindCmdLineSwitch( 'f', prm ) and FileExists( prm ) then
    edt_NkFile.Text := prm;
  (*if FindCmdLineSwitch( 't', prm )  then
  begin
    for NkType := Low( TNkType ) to High( TNkType ) do
      if SameText( prm, Copy( GetEnumName( TypeInfo( TNkType ), Ord( NkType )), 4, 1024 )) then
      begin
        edt_NkType.ItemIndex := Ord( NkType );
        Break;
      end;
    if ( edt_NkType.ItemIndex <> Ord( nktSport2000 )) and FindCmdLineSwitch( 'u', prm ) then
    begin
      SauvUnivers := prm;
      edt_UniverNom.Text := prm;
    end
  end
  else*)
    if FindCmdLineSwitch( 'u', prm ) then
    begin
      SauvUnivers := prm;
      edt_UniverNom.Text := prm;
    end;

  if FindCmdLineSwitch( 'o', prm ) and ( prm = '' ) then
    Chk_Obligatoire.Checked := True;
  if FindCmdLineSwitch( 'd', prm ) and ( prm = '' ) then
    Chk_ParDefaut.Checked := True;

  if FindCmdLineSwitch( 's', prm ) then
    // Si s(ilent) trouvé, on ne cherche pas le v(erbose)
    cbx_Log.ItemIndex := Ord( el_Silent )
  else
    // Sinon on cherche le verbose
    if FindCmdLineSwitch( 'v', prm ) then
    begin
      cbx_Log.ItemIndex := Ord( el_Verbose );
      for ErrLvl := Low( TErrorLevel ) to High( TErrorLevel ) do
        if SameText( prm, Copy( GetEnumName( TypeInfo( TErrorLevel ), Ord( ErrLvl )), 4, 1024 )) then
        begin
          cbx_Log.ItemIndex := Ord( ErrLvl );
          Break;
        end;
    end;
//  if FindCmdLineSwitch( 'a', prm ) and TryStrToInt( prm, int ) then
//    Switches.Activite := int; // ACT_ID

  AutoClose := ( FindCmdLineSwitch( 'auto', prm ) and ( prm = '' ))
            or ( FindCmdLineSwitch( 'c', prm ) and ( prm = '' ));
  AutoStart := ( FindCmdLineSwitch( 'auto', prm ) and ( prm = '' ))
            or ( FindCmdLineSwitch( 'r', prm ) and ( prm = '' ));

  FieldsChange( edt_NkType );

  if AutoStart then
    Btn_Traitement.Click;

  Caption := 'Intégration de nomenclature ' + GetNumVersionSoft;
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

procedure TFrm_Main.Nbt_NkFileClick(Sender: TObject);
var
  Open : TOpenDialog;
begin
  try
    Open := TOpenDialog.Create(Self);
    Open.Filter := 'Fichier CSV (*.csv)|*.csv';
    Open.InitialDir := ExtractFilePath( ParamStr(0) );
    Open.FileName := ExtractFileName(edt_NkFile.Text);
    if Open.Execute() then
      edt_NkFile.Text := Open.FileName;
  finally
    FreeAndNil(Open);
  end;
end;

procedure TFrm_Main.Btn_TraitementClick(Sender: TObject);
var
  MsgDlgBtn: TMsgDlgBtn;
begin
  try
    try
      ExitCode := ERROR_CANNOT_MAKE; // CodeRetour par défaut
      Log_Init(TErrorLevel(cbx_Log.ItemIndex), IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'Log'));

      Self.Enabled := false;
      Screen.Cursor := crHourGlass;

      {DONE -oJO : Recherche de l'ancienne FEDAS (2016-04-21)}
      if not AutoClose then
      begin
        MsgDlgBtn := mbIgnore;
        repeat
          if not RechercheAncienneFEDAS then
          begin
            Log_Write('RechercheAncienneFEDAS', el_Warning);
            MsgDlgBtn := TMsgDlgBtn(Succ(MessageDlg('L''identification de l''ancienne FEDAS a échoué...'#13'Voulez-vous tout de même poursuivre l''intégration de la nouvelle FEDAS ?', mtWarning, mbAbortRetryIgnore, 0, mbRetry)));
            case MsgDlgBtn of
              mbAbort: 
                begin
                  Log_Write('-> Traitement annulé', el_Warning);
                  ExitCode := ERROR_CANCELLED;
                  Exit;
                end;
              mbRetry: 
                begin
                  Log_Write('-> Rechercher à nouveau l''ancienne FEDAS', el_Warning);
                end;
              mbIgnore: 
                begin
                  Log_Write('-> Ignorer et poursuivre le traitement', el_Warning);
                end;
            end;
          end;
        until MsgDlgBtn = mbIgnore;
      end;

      if IntegrationNomenclature() then
      begin
        ExitCode := ERROR_SUCCESS;
        if not AutoClose then
          MessageDlg('Traitement terminé correctement.', mtInformation, [mbOK], 0);
      end
      else
      begin
        if not AutoClose then
          MessageDlg('Erreur lors du traitement', mtError, [mbOK], 0);
      end;
    except
      on E: Exception do
        Log_Write( 'Traitement annulé (' + E.Message +')' );
    end;
  finally
    Screen.Cursor := crDefault;
    Self.Enabled := true;
    if AutoClose then
      Application.Terminate;
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
  ExitCode := ERROR_CANCELLED;
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

procedure TFrm_Main.FieldsChange(Sender: TObject);
begin
  if VerifConnexion() then
  begin
    if ( Sender = edt_UniverNom ) then
      SauvUnivers := edt_UniverNom.Text;
    if ( Sender = edt_NkType ) or ( Sender = edt_DataBase ) then
      FillUniversActivites();
    Btn_Traitement.Enabled         := FileExists(edt_NkFile.Text)
                                  and ( edt_NkType.ItemIndex > -1 )
                                  and ( Trim( edt_UniverNom.Text ) <> '' );
    Btn_AssignationArticle.Enabled := True;
    Btn_VerificationNomk.Enabled   := True;

    Chk_Obligatoire.Enabled :=  edt_NkType.ItemIndex <> Ord( nktSport2000 );
    Chk_ParDefaut.Enabled :=  edt_NkType.ItemIndex <> Ord( nktSport2000 );
  end
  else
  begin
    Btn_Traitement.Enabled := false;
    Btn_AssignationArticle.Enabled := false;
    Btn_VerificationNomk.Enabled := false;
  end;
end;

procedure TFrm_Main.FillUniversActivites;
var
  Query : TIBOQuery;
begin
  edt_ActiviteNom.Items.Clear();
  if FileExists(edt_DataBase.Text) then
  begin
    try
      try
        Query := GetNewQuery(GetNewTransaction(GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text)));
        edt_ActiviteNom.Enabled := False;
        edt_UniverNom.Enabled   := False;
        case edt_NkType.ItemIndex of
          {$REGION 'nktJoannin (deprecated->disabled)'}(*
          Ord( nktJoannin ): begin
            Query.SQL.Text := 'select act_id, act_nom from nklactivite join k on k_id = act_id and k_enabled = 1 where act_id != 0 order by act_nom;';
            Query.Open();
            while not Query.Eof do
            begin
              edt_ActiviteNom.Items.AddObject(Query.FieldByName('act_nom').AsString, Pointer(Query.FieldByName('act_id').AsInteger));
              Query.Next();
            end;
            edt_UniverNom.Style   := csSimple;
            edt_UniverNom.Text    := SauvUnivers;
            edt_UniverNom.Repaint;
            edt_ActiviteNom.Enabled := Query.RecordCount > 0;
            edt_UniverNom.Enabled := True;
          end;
          *){$ENDREGION}
          Ord( nktSport2000 ): begin
            Query.SQL.Text := 'select act_id,act_nom,uni_id,uni_nom from nklactivite, nklunivers join k on k_id=act_id and k_enabled=0 join k on k_id=uni_id and k_enabled=0 where act_id!=0 and uni_id!=0 and lower(act_nom)=lower(''sport2000'') and lower(uni_nom)=lower(''fedas'')';
            Query.Open();
            edt_ActiviteNom.Items.Clear;
            edt_ActiviteNom.Items.AddObject(Query.FieldByName('act_nom').AsString, Pointer(Query.FieldByName('act_id').AsInteger));
            if edt_ActiviteNom.Items.Count = 1 then
              edt_ActiviteNom.Style := csSimple
            else
              edt_ActiviteNom.Style := csDropDownList;

            edt_UniverNom.Items.Clear;
            edt_UniverNom.Items.AddObject(Query.FieldByName('uni_nom').AsString, Pointer(Query.FieldByName('uni_id').AsInteger));
            edt_UniverNom.ItemIndex := edt_UniverNom.Items.Count -1;
            if edt_UniverNom.Items.Count = 1 then
              edt_UniverNom.Style := csSimple
            else
              edt_UniverNom.Style := csDropDownList;
          end;
        end;
        edt_ActiviteNom.ItemIndex := edt_ActiviteNom.Items.Count -1;
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
        edt_ActiviteNom.Items.Clear();
        MessageDlg('Erreur : ' + e.ClassName + ' - ' + e.Message, mtError, [mbOK], 0)
      end;
    end;
  end;
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

function TFrm_Main.RechercheAncienneFEDAS: Boolean;
var
  Query: TIBOQuery;
  function RechercheParLeNom: Boolean;
  begin
    Log_Write('  RechercheParLeNom');  
    Result := False; // default
    try
      Query.SQL.Text :=
        'select nklsecteur.sec_id ' +
        'from nklsecteur ' +
        'join k ksec on ksec.k_id = nklsecteur.sec_id and ksec.k_enabled = 1 ' +
        'where nklsecteur.sec_nom = ' + QuotedStr('FEDAS');
      try
        Query.Open;
        Result := not Query.IsEmpty;
        Log_WriteFmt('  -> %d', [Ord(Result)]);
      finally         
        Query.Close;
      end;
    except
      on E: Exception do
      begin
        Log_WriteFmt('  -> %s', [E.Message]);
        raise;
      end;
    end;
  end;
begin
  Log_Write('RechercheAncienneFEDAS');
  Result := False; // default
  try
    Query := GetNewQuery(GetNewTransaction(GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text)));
    try
      {DONE -oJO : Recherche de l'ancienne FEDAS : Rollback (2016-04-28)}
      Result := RechercheParLeNom;
      Log_WriteFmt('-> %d', [Ord(Result)]);
    finally
      Query.IB_Transaction.Rollback();
      Query.IB_Transaction.Close();
      Query.IB_Transaction.Free();
      Query.IB_Connection.Free();
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      Log_WriteFmt('-> %s', [E.Message]);
      raise;
    end;
  end;
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

  procedure SplitLineJoannin(Text : string; var Infos : TStringList; Sep : char = ';');
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

  procedure SplitLineSport2000(Text: String; var Infos : TStringList; Sep : char = ';');
  var
    sLine: TStringList;
    i: Integer;
  begin
    Log_Write('SplitLine("' + Text + '")', el_Verbose);

    sLine := TStringList.Create();
    try
      Infos.Clear;
      sLine.StrictDelimiter := True;
      sLine.Delimiter := Sep;
      sLine.DelimitedText := Text;
      for i := 0 to sLine.Count -1 do
        Infos.Add( sLine[i] );
    finally
      sLine.Free;
    end;

    Log_Write('         -> Fin', el_Verbose);
  end;

  function GetFedasCodePart(const AFedasCode: String; const AFedasParts: TFedasParts):String; overload;
  begin
    Result := '';
    if fpProduit in AFedasParts then
      Result := Result + Copy( AFedasCode, 1, 1 ); //_xxxxx
    if fpDomaine in AFedasParts then
      Result := Result + Copy( AFedasCode, 2, 2 ); //x__xxx
    if fpGroupe in AFedasParts then
      Result := Result + Copy( AFedasCode, 4, 2 ); //xxx__x
    if fpSousGroupe in AFedasParts then
      Result := Result + Copy( AFedasCode, 6, 1 ); //xxxxx_
  end;

  function GetFedasCodePart(const AFedasCode: String; const AFedasPart: TFedasPart): String; overload;
  begin
    Result := GetFedasCodePart( AFedasCode, [AFedasPart] )
  end;

  {$REGION 'function CreateEnreg(Trans : TIB_Transaction; Table, Champs, Valeurs : string; const k_enabled : boolean = true) : integer;'}
  {
  function CreateEnreg(Trans : TIB_Transaction; Table, Champs, Valeurs : string; const k_enabled : boolean = true) : integer;
  var
    Query : TIBOQuery;
  begin
    Result := -1;
    Log_Write('CreateEnreg("' + Table + '", "' + Champs + '", "' + Valeurs + '", "' + BoolToStr(k_enabled,true) + '")', el_Verbose);
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

      // k_enabled false
      if not k_enabled then
      begin
        Query.SQL.Text := 'execute procedure pr_updatek(' + IntToStr(Result) + ',1);';
        Query.ExecSQL();
      end;

    finally
      FreeAndNil(Query);
    end;
    Log_Write('           -> ' + IntToStr(Result), el_Verbose);
  end;
  }
  {$ENDREGION}

  function CreateEnreg(Trans : TIB_Transaction; Table, Champs, Valeurs : string; const k_enabled : boolean = true) : integer;
  var
    Query : TIBOQuery;
    KTBID : Integer;
  begin
    Result := -1;
    Log_Write('CreateEnreg("' + Table + '", "' + Champs + '", "' + Valeurs + '", "' + BoolToStr(k_enabled,true) + '")', el_Verbose);
    try
      Query := GetNewQuery(Trans);
      // Récupération d'un nouvel ID
      Query.SQL.Text := 'select ktb_id, gen_id(general_id,1) as id from ktb where ktb_name=upper(' + QuotedStr( Table ) + ');';
      Query.Open();
      if not Query.Eof then
      begin
        Result := Query.FieldByName('id').AsInteger;
        KTBID  := Query.FieldByName('ktb_id').AsInteger;
      end
      else
        raise Exception.Create('Erreur à la création du K !');
      Query.Close();
      // Alimentation de la table K
      Query.SQL.Text := Format( 'insert into k (k_id,krh_id,ktb_id,k_version,k_enabled,kse_owner_id,kse_insert_id,k_inserted,kse_delete_id,k_deleted,kse_update_id,k_updated,kse_lock_id,kma_lock_id) '
                              + 'values ( %d, %d, %d, %d, %d, -1, -1, current_timestamp, 0, ''1899-12-30'', 0, current_timestamp, %d, %d )'
                              , [ Result, Result, KTBID, Result, Integer( k_enabled ), Result, Result ]);
      Query.ExecSQL();
      // Alimentation de la table <Table>
      Query.SQL.Text := Format( 'insert into %s (%s) values (%d, %s);', [ Table, Champs, Result, Valeurs ]);
      Query.ExecSQL();
    finally
      FreeAndNil(Query);
    end;
    Log_Write('           -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistActivite(Trans : TIB_Transaction; idact : integer; libelle : string) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistActivite("' + IntToStr(idact) + '", "' + libelle + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select act_id '
                                + 'from nklactivite join k on k_id = act_id and k_enabled = 1 '
                                + 'where uni_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                 -> ' + IntToStr(Result), el_Verbose);
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
                               + '2, '                        // uni_centrale
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

  function VerifExistSecteur(Trans : TIB_Transaction; iduni : integer; code, libelle : string; const k_enabled : boolean = True) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistSecteur("' + IntToStr(iduni) + '", "' + code + '", "' + libelle + '", "' + BoolToStr(k_enabled,true) + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select sec_id '
                                + 'from nklsecteur join k on k_id = sec_id and k_enabled = ' + IntToStr(Integer(k_enabled)) + ' '
                                + 'where sec_uniid = ' + IntToStr(iduni) + ' and sec_code = ' + QuotedStr(code) + ' and sec_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateSecteur(Trans : TIB_Transaction; iduni : integer; code, libelle : string; var ordre : integer; const k_enabled : boolean = true) : integer;
  begin
    Log_Write('CreateSecteur("' + IntToStr(iduni) + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '", "' + BoolToStr(k_enabled,True) + '")', el_Verbose);
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
                               + '2'                       // sec_centrale
                               , k_enabled
                         );
    Log_Write('             -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistRayon(Trans : TIB_Transaction; idsec : integer; code, libelle : string; const k_enabled : boolean = True) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistRayon("' + IntToStr(idsec) + '", "' + code + '", "' + libelle + '", "' + BoolToStr(k_enabled,true) + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select ray_id '
                                + 'from nklrayon join k on k_id = ray_id and k_enabled = ' + IntToStr(Integer(k_enabled)) + ' '
                                + 'where ray_secid = ' + IntToStr(idsec) + ' and ray_code = ' + QuotedStr(code) + ' and ray_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('               -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateRayon(Trans : TIB_Transaction; iduni, idsec : integer; basecode, code, libelle : string; var ordre : integer; const k_enabled : boolean = True) : integer;
  begin
    Log_Write('CreateRayon("' + IntToStr(iduni) + '", "' + IntToStr(idsec) + '", "' + basecode + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '", "' + BoolToStr(k_enabled,True) + '")', el_Verbose);
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
                               + '2'                               // ray_centrale
                               , k_enabled
                         );
    Log_Write('           -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistFamille(Trans : TIB_Transaction; idray : integer; code, libelle : string; const k_enabled : boolean = True) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistFamille("' + IntToStr(idray) + '", "' + code + '", "' + libelle + '", "' + BoolToStr(k_enabled,true) + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select fam_id '
                                + 'from nklfamille join k on k_id = fam_id and k_enabled = ' + IntToStr(Integer(k_enabled)) + ' '
                                + 'where fam_rayid = ' + IntToStr(idray) + ' and fam_code = ' + QuotedStr(code) + ' and fam_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                 -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateFamille(Trans : TIB_Transaction; idray : integer; basecode, code, libelle : string; var ordre : integer; ctfid: integer = 0; const k_enabled : boolean = True) : integer;
  begin
    Log_Write('CreateFamille("' + IntToStr(idray) + '", "' + basecode + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '", "' + BoolToStr(k_enabled,True) + '")', el_Verbose);
    Inc(ordre, 10);
    Result := CreateEnreg(Trans, 'nklfamille'
                               , 'fam_id, fam_rayid, fam_idref, fam_nom, fam_ordreaff, fam_visible, fam_ctfid, fam_code, fam_codeniv, fam_centrale'
                               , IntToStr(idray) + ', '            // fam_rayid
                               + '0, '                             // fam_idref
                               + QuotedStr(libelle) + ', '         // fam_nom
                               + IntToStr(ordre) + ', '            // fam_ordreaff
                               + '1, '                             // fam_visible
                               + IntToStr( ctfid ) + ', '          // fam_ctfid
                               + QuotedStr(code) + ', '            // fam_code
                               + QuotedStr(basecode + code) + ', ' // fam_codeniv
                               + '2'                               // fam_centrale
                               , k_enabled
                         );
    Log_Write('             -> ' + IntToStr(Result), el_Verbose);
  end;

  function VerifExistSSFamille(Trans : TIB_Transaction; idfam : integer; code, libelle : string; const k_enabled : boolean = True) : integer;
  var
    Count : integer;
  begin
    Log_Write('VerifExistSSFamille("' + IntToStr(idfam) + '", "' + code + '", "' + libelle + '", "' + BoolToStr(k_enabled,true) + '")', el_Verbose);
    Result := GetSQLValeur(Trans, 'select ssf_id '
                                + 'from nklssfamille join k on k_id = ssf_id and k_enabled = ' + IntToStr(Integer(k_enabled)) + ' '
                                + 'where ssf_famid = ' + IntToStr(idfam) + ' and ssf_code = ' + QuotedStr(code) + ' and ssf_nom = ' + QuotedStr(libelle) + ';', Count);
    Log_Write('                   -> ' + IntToStr(Result), el_Verbose);
  end;

  function CreateSSFamille(Trans : TIB_Transaction; idfam, idtva, idtct : integer; basecode, code, libelle : string; var ordre : integer; const k_enabled : boolean = True) : integer;
  begin
    Log_Write('CreateSSFamille("' + IntToStr(idfam) + '", "' + IntToStr(idtva) + '", "' + IntToStr(idtct) + '", "' + basecode + '", "' + code + '", "' + libelle + '", "' + IntToStr(ordre) + '", "' + BoolToStr(k_enabled,True) + '")', el_Verbose);
    Inc(ordre, 10);
    Result := CreateEnreg(Trans, 'nklssfamille'
                               , 'ssf_id, ssf_famid, ssf_idref, ssf_nom, ssf_ordreaff, ssf_visible, ssf_catid, ssf_tvaid, ssf_tctid, ssf_code, ssf_codeniv, ssf_codefinal, ssf_centrale'
                               , IntToStr(idfam) + ', '            // ssf_famid
                               + basecode + code + ', '            // ssf_idref
                               + QuotedStr(libelle) + ', '         // ssf_nom
                               + IntToStr(ordre) + ', '            // ssf_ordreaff
                               + '1, '                             // ssf_visible
                               + '0, '                             // ssf_catid
                               + IntToStr(idtva) + ', '            // ssf_tvaid
                               + IntToStr(idtct) + ', '            // ssf_tctid
                               + QuotedStr(code) + ', '            // ssf_code
                               + QuotedStr(basecode + code) + ', ' // ssf_codeniv
                               + QuotedStr(basecode + code) + ', ' // ssf_codefinal
                               + '2'                               // ssf_centrale
                               , k_enabled
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
 
  function CheckFlag(Trans: TIB_Transaction; prmid: integer): TFlagValue;
  var
    Count : integer;
    FlagValue: Integer;
  begin
    Log_WriteFmt( 'CheckFlag("%d")', [ prmid ], el_Verbose );
    FlagValue := GetSQLValeur( Trans, Format( 'select cast( PRM_FLOAT as integer ) from GENPARAM where PRM_ID = %d', [ prmid ] ), Count );
    if FlagValue in [ 0, 1, 2, 4 ] then
      Result := TFlagValue( FlagValue )
    else
      Result := fvUnknown;
    Log_WriteFmt( '         -> %d', [ Ord( Result ) ], el_Verbose );
  end;
  
  procedure UpdateFlag(Connection: TIB_Connection; prmid: Integer; 
    const FlagValue: TFlagValue );
  var
    Transaction: TIB_Transaction;
    Query : TIBOQuery;
    Count: Integer;
  begin
    try
      Transaction := GetNewTransaction( Connection, False );
      Log_WriteFmt( 'UpdateFlag("%d","%d")', [ prmid, Ord( FlagValue ) ], el_Verbose );
      try
        Query := GetNewQuery( Transaction );
        Query.SQL.Text := Format( 'update GENPARAM set PRM_FLOAT = %d where PRM_ID = %d;', [ Ord( FlagValue ), prmid ] );
        Query.ExecSQL();      
        Query.SQL.Text := Format( 'execute procedure PR_UPDATEK( %d, 0 );', [ prmid ] );
        Query.ExecSQL();
      finally
        FreeAndNil(Query);
      end;
      Log_Write('           -> fin', el_Verbose);
      Transaction.Commit;
    except
      on E: Exception do begin
        Transaction.Rollback;
      end;    
    end;
  end;

var
  Connexion : TIB_Connection;
  Transaction : TIB_Transaction;

  seccode, raycode, famcode, ssfcode,
  secname, rayname, famname, ssfname, catname,
  fedascode : string;

  PrmId,
  TvaId, TctId,
  ActId, UniId,
  SecId, RayId, FamId, SsfId, CatId,
  secordre, rayordre, famordre, ssfordre,
  FedasSSFId, UniComSSFId : integer;

  Lignes, Infos : TStringList;
  i, Count, nblienfedas, nblienunicom : integer;
begin
  Result := false;
  Log_Write( '==================================================', el_Info);
  Log_Write('Démarrage de l''integration', el_Info);
  try
    Connexion := GetNewConnexion(edt_DataBase.Text, edt_Login.Text, edt_Password.Text);
    Transaction := GetNewTransaction(Connexion, false);
    try
      Transaction.StartTransaction();

      // Paramétrage
      Log_Write('Lecture des paramètres utiles', el_Etape);

      PrmId := GetSQLValeur(Transaction, 'select prm_id '
                                       + 'from genparam '
                                       + 'where prm_type = 3 and prm_code = 71', Count);
      ActId := Integer(Pointer(edt_ActiviteNom.Items.Objects[edt_ActiviteNom.ItemIndex]));
      TvaId := GetSQLValeur(Transaction, 'select tva_id '
                                       + 'from arttva join k on k_id = tva_id and k_enabled = 1 '
                                       + 'where tva_taux = (select dos_float '
                                       + 'from gendossier join k on k_id = dos_id and k_enabled = 1 '
                                       + 'where dos_nom = ''TVA'') '
                                       + 'order by tva_id;', Count);
      TctId := GetSQLValeur(Transaction, 'select tct_id '
                                       + 'from arttypecomptable join k on k_id = tct_id and k_enabled = 1 '
                                       + 'where tct_nom = ' + QuotedStr('PRODUIT') + 'or tct_nom = ' + QuotedStr('PRODUITS') + ';', Count);

      if (PrmId < 0) then
        raise Exception.Create('Base non conforme (flag non présent?)');
        
      case CheckFlag( Transaction, PrmId ) of
        fvDefault       : if not AutoStart then
                            MessageDlg('Première tentative d''intégration de la nomenclature.', mtInformation, [mbOK], 0);
        fvSucceed       : begin
                            if not AutoStart then
                              MessageDlg('Traitement déjà effectué. Fin', mtInformation, [mbOK], 0);
                            Exit;
                          end;
        fvFailed        : if not AutoStart then
                            MessageDlg('La derniere tentative d''intégration de la nomenclature avait échoué, nouvelle tentative...', mtError, [mbOK], 0);
        fvPending       : if AutoStart
                          or (( not AutoStart ) and ( MessageDlg('La base n''est pas prête actuellement. Interrompre le traitement ?', mtWarning, mbYesNo, 0 ) = mrYes )) then
                            exit;
        else {=fvUnknown} if AutoStart
                          or (( not AutoStart ) and ( MessageDlg('La base est dans un état incertain. Interrompre le traitement ?', mtWarning, mbYesNo, 0 ) = mrYes )) then
                            exit;
      end;
        
      UpdateFlag( Connexion, prmid, fvPending );
      
      if (ActId < 0) then
        raise Exception.Create('Activité sélectionnée non trouvé');
      if (TvaId < 0) then
        TvaId := 0;
      if (TctId < 0) then
        TctId := 0;

      // selection/creation de l'univers !
      Log_Write('Gestion de l''univers', el_Etape);
      if edt_NkType.ItemIndex = Ord( nktSport2000 ) then
        UniId := Integer(Pointer(edt_UniverNom.Items.Objects[edt_UniverNom.ItemIndex]))
      else
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

        for i := 1 to Lignes.Count -1 do
        begin
          Log_Write('gestion de la ligne ' + IntToStr(i +1), el_Etape);


          case edt_NkType.ItemIndex of
            {$REGION 'Parsing du fichier CSV pour Joannin (deprecated->disabled)'}(*
            Ord( nktJoannin ): begin
              SplitLineJoannin(Lignes[i], Infos);

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
                SecId := VerifExistSecteur(Transaction, UniId, seccode, secname);
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

            end; // Joannin
            *){$ENDREGION}
            {$REGION 'Parsing du fichier CSV pour Sport2000'}
            Ord( nktSport2000 ): begin
              SplitLineSport2000(Lignes[i], Infos);

              pgb_Progress.Stepit();
              Application.ProcessMessages();

              if Infos.Count = 7 then
              begin
                // recup des infos
                secname := Infos[0];
                raycode := Infos[1];
                rayname := Infos[2];
                famcode := Infos[3];
                famname := Infos[4];
                ssfcode := Infos[5];
                ssfname := Infos[6];

                // gestion de la section
                Log_Write('Gestion de la section "' + secname + '"', el_Debug);
                SecId := VerifExistSecteur(Transaction, UniId, GetFedasCodePart(ssfcode,fpProduit), secname, False);
                if SecId < 0 then
                begin
                  SecId := CreateSecteur(Transaction, UniId, GetFedasCodePart(ssfcode,fpProduit), secname, secordre, False);
                  rayordre := 0;
                end
                else
                begin
                  rayordre := GetSQLValeur(Transaction, 'select max(ray_ordreaff) from nklrayon where ray_secid = ' + intToStr(SecId) + ';', Count);
                end;

                // gestion du rayon
                Log_Write('Gestion du rayon "' + raycode + ' - ' + rayname + '"', el_Debug);
                RayId := VerifExistRayon(Transaction, SecId, raycode, rayname, False);
                if RayId < 0 then
                begin
                  RayId := CreateRayon(Transaction, UniId, SecID, GetFedasCodePart(ssfcode,fpProduit), GetFedasCodePart(ssfcode,fpDomaine), rayname, rayordre, False);
                  famordre := 0;
                end
                else
                begin
                  famordre := GetSQLValeur(Transaction, 'select max(fam_ordreaff) from nklfamille where fam_rayid = ' + intToStr(RayId) + ';', Count);
                end;

                // gestion de la famille
                Log_Write('Gestion de la famille "' + famcode + ' - ' + famname + '"', el_Debug);
                FamId := VerifExistFamille(Transaction, RayId,  GetFedasCodePart(ssfcode,fpGroupe), famname, False);
                if FamId < 0 then
                begin                                                                 //seccode + raycode
                  FamId := CreateFamille(Transaction, RayId, GetFedasCodePart(ssfcode,[fpProduit,fpDomaine]), GetFedasCodePart(ssfcode,fpGroupe), famname, famordre, CatId, False);
                  ssfordre := 0;
                end
                else
                begin
                  ssfordre := GetSQLValeur(Transaction, 'select max(ssf_ordreaff) from nklssfamille where ssf_famid = ' + intToStr(FamId) + ';', Count);
                end;

                // gestion de la sous-famille
                Log_Write('Gestion de la sous-famille "' + ssfcode + ' - ' + ssfname + '"', el_Debug);
                SsfId := VerifExistSSFamille(Transaction, FamId, GetFedasCodePart(ssfcode,fpSousGroupe), ssfname, False);
                if SsfId < 0 then
                begin
                  SsfId := CreateSSFamille(Transaction, FamId, TvaId, TctId, GetFedasCodePart(ssfcode,[fpProduit,fpDomaine,fpGroupe]), GetFedasCodePart(ssfcode,fpSousGroupe), ssfname, ssfordre, False);
                end
                else
                begin
                end;
              end
              else
                Log_Write('Nombre de colonne insufisant a la ligne ' + IntToStr(i +1), el_Warning);
            end; // Sport2000
            {$ENDREGION}
          end;
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
      UpdateFlag( Connexion, prmid, fvSucceed );
      Result := true;
    except
      on e : Exception do
      begin
        Transaction.Rollback();
        UpdateFlag( Connexion, prmid, fvFailed );
        Log_Write('Exception : ' + e.ClassName + ' - ' + e.Message, el_Erreur);
        if not AutoClose then
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
