UNIT Unit1;
{cet exemple montre dans le détail l'utilisation de FindFirs et Find*Next
Ces fonctions permettent d'explorer les dossiers et leurs fichiers}

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Db,
  dxmdaset,
  ADODB,
  IBDatabase,
  IBCustomDataSet,
  IBQuery,
  LMDCustomComponent,
  LMDIniCtrl, AdvGlowButton, RzPanel, AlgolDialogForms, IniCfg_Frm, UVersion;

TYPE
  TForm1 = CLASS(TAlgolDialogForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Label3: TLabel;
    ado: TADOConnection;
    liste: TdxMemData;
    listechaine: TStringField;
    TD: TADOTable;
    TDdos_id: TAutoIncField;
    TDdos_nom: TStringField;
    TDdos_centrale: TStringField;
    TDdos_code: TStringField;
    TDdos_magnom: TStringField;
    TDdos_ville: TStringField;
    TDdos_chemin: TStringField;
    IB: TIBDatabase;
    QM: TIBQuery;
    tt: TIBTransaction;
    del: TADOCommand;
    Timer1: TTimer;
    INI: TLMDIniCtrl;
    QV: TIBQuery;
    TDdos_version: TStringField;
    Q_tw: TIBQuery;
    Q_S2K: TIBQuery;
    Q_IS: TIBQuery;
    TDdos_resatw: TWordField;
    TDdos_resais: TWordField;
    TDdos_resas2k: TWordField;
    q_sms: TIBQuery;
    TDdos_sms: TStringField;
    TDdos_poste: TWordField;
    TDdos_dermvt: TDateTimeField;
    Q_poste: TIBQuery;
    q_tck: TIBQuery;
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    nbt_Lancement: TAdvGlowButton;
    Nbt_Parametrage: TAdvGlowButton;
    Pan_Top: TRzPanel;
    Label4: TLabel;
    Ens: TEdit;
    CheckBox8: TCheckBox;
    TDdos_lstbase: TWordField;
    Q_WebConfig: TIBQuery;
    Q_Module: TIBQuery;
    PROCEDURE Button1Click(Sender: TObject);
    PROCEDURE FormCreate(Sender: TObject);
    PROCEDURE Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_ParametrageClick(Sender: TObject);
  PRIVATE
    { Déclarations privées }
  PUBLIC
    procedure ConnexionAdo;
    { Déclarations publiques }
  END;

VAR
  Form1: TForm1;
  CanGenerateCSV, CanPutHeaders: Boolean;
  Attempt: Integer;

CONST
  Attributs: integer = 0;
  cFilename: TFileName = 'ListeDesBases.csv';
  cMaxAttempt: Cardinal = 3;

PROCEDURE ScruteDossier(Dossier: STRING; filtre: STRING; attributs: integer; recursif: boolean);
PROCEDURE ScruteFichier(Dossier: STRING; filtre: STRING; attributs: integer);
PROCEDURE insertbase;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TForm1.Button1Click(Sender: TObject);
VAR
  nbre: STRING;
  I: Integer;
  j: Integer;
  k: Integer;
  sDossier : String;
BEGIN
  if not ado.Connected then
  begin
    ShowMessage('Pas de connexion à la base de données SQL Serveur');
    Exit;
  end;

  del.CommandText := 'delete from dossiers where dos_lstbase = ' + IntToStr(IniCfg.NumSoft);
  del.Execute;

  CanPutHeaders := True;
  if FileExists( cFilename ) then begin
    Attempt := 1;
    CanGenerateCSV := not FileExists( cFilename );
    while( ( Attempt <= cMaxAttempt ) and FileExists( cFilename ) ) do begin
      CanGenerateCSV := DeleteFile( cFilename );
      Inc( Attempt );
      Sleep( Attempt * 5000 );
    end;
  end
  else
    CanGenerateCSV := True;

  for i := 0 to IniCfg.LstCentrales.Count -1 do
  begin
    Memo1.Clear;
    Memo2.Clear;
    ens.text := IniCfg.LstCentrales[i];
    Application.ProcessMessages;
    for j := 0 to IniCfg.LstLames.Count -1 do
      for k := 0 to IniCfg.LstFiles.Count -1 do
      begin
        sDossier := Format('\\%s\%s\%s',[IniCfg.LstLames[j],IniCfg.SearchDir,IniCfg.LstCentrales[i]]);
        ScruteDossier(sDossier, IniCfg.LstFiles[k], attributs, CheckBox8.Checked);
        Insertbase;
        liste.close;
        liste.open;
      end;
  end;
  Application.Terminate;


//  nbre := INI.readString('CENTRALES', 'Nbre', '');
//  //showmessage (nbre);
//  FOR I := 1 TO strtoint(nbre) DO
//  BEGIN
//    ens.text := INI.readString('CENTRALES', 'C' + inttostr(i), '');
//    Memo1.Clear;
//    Memo2.Clear;
//
//    FOR j := 1 TO 9 DO
//    BEGIN
//      IF INI.readString('LAMES', 'LAME' + inttostr(j), '') = '1' THEN
//      BEGIN
//        ScruteDossier('\\gsa-lame' + inttostr(j) + '\EAI\' + ens.text, 'GINKOIA.GDB', attributs, CheckBox8.Checked);
//        ScruteDossier('\\gsa-lame' + inttostr(j) + '\EAI\' + ens.text, 'GINKOIA.IB', attributs, CheckBox8.Checked);
//        insertbase;
//        liste.close;
//        liste.open;
//      END
//    END;
//    application.terminate;
//
//  END;
END;

PROCEDURE ScruteFichier(Dossier: STRING; filtre: STRING; Attributs: integer);
VAR
  FichierTrouve: STRING;
  Resultat: Integer;
  SearchRec: TSearchRec;
BEGIN
  IF Dossier[length(Dossier)] = '\' THEN Dossier := copy(Dossier, 1, length(Dossier) - 1);
  Resultat := FindFirst(Dossier + '\' + filtre, Attributs, SearchRec);
  WHILE Resultat = 0 DO
  BEGIN
    Application.ProcessMessages; // rend la main à windows pour qu'il traite les autres applications (évite que l'application garde trop longtemps la main
    IF ((SearchRec.Attr AND faDirectory) <= 0) THEN // On a trouvé un Fichier (et non un dossier)
    BEGIN
      FichierTrouve := Dossier + '\' + SearchRec.Name;
      Form1.Memo1.Lines.Add(FichierTrouve); // j'ajoute le Dossier trouvé dans le Memo2
      Form1.liste.append;
      Form1.listechaine.asstring := uppercase(FichierTrouve);
      Form1.liste.post;
    END;
    Resultat := FindNext(SearchRec);
  END;
  FindClose(SearchRec); // libération de la mémoire
END;

PROCEDURE ScruteDossier(Dossier: STRING; filtre: STRING; attributs: integer; recursif: boolean);
VAR
  DossierTrouve: STRING;
  Resultat: Integer;
  SearchRec: TSearchRec;
BEGIN
  IF Dossier[length(Dossier)] = '\' THEN Dossier := copy(Dossier, 1, length(Dossier) - 1); // s'il y a un '\' à la fin, je le retire

  ScruteFichier(Dossier, filtre, attributs); //pour trouver les fichiers du dossier
  IF recursif THEN // si on veut aller voir les sous dossiers
  BEGIN
    Resultat := FindFirst(Dossier + '\' + '*.*', FaDirectory, SearchRec); //permet de trouver le premier sous dossier de Dossier
    WHILE Resultat = 0 DO // SearchRec contient tous les renseignements concernant le dossier trouvé
    BEGIN
      IF (SearchRec.Name <> '.') AND (SearchRec.Name <> '..')
        AND ((SearchRec.Attr AND faDirectory) > 0) THEN // C'est comme cela que je teste si on a trouvé un Dossier et non un fichier
      BEGIN
        DossierTrouve := Dossier + '\' + SearchRec.Name; // pour avoir le nom du dossier avec le chemin complet
        // attention, souvent un memo est trop petit pour contenir tous les fichiers d'un disque dur !
        // si vous avez Delphi3 choisisez un TRichEdit vous serez moins limité
        IF recursif THEN ScruteDossier(DossierTrouve, filtre, attributs, recursif); // je relance la recherche mais cette fois à partir du dossier trouvé
        Application.ProcessMessages; // rend la main à windows pour qu'il traite les autres applications (évite que l'application garde trop longtemps la main
      END;
      Resultat := FindNext(SearchRec); // permet de trouver les sous dosssiers suivants
    END;
  END; //fin de if récursif
  FindClose(SearchRec); // libération de la mémoire
END;

PROCEDURE insertbase;
VAR
  ch: STRING;
  i: integer;
  dossier: STRING;
  car: STRING;
   lame: STRING;
  lg: integer;

  FileStream: TFileStream;
  StringList_Line, StringList_Lines: TStringList;
BEGIN
  if CanGenerateCSV then begin
    if FileExists( cFilename ) then begin
      FileStream := TFileStream.Create( cFilename, fmOpenWrite or fmShareDenyWrite );
      FileStream.Seek( 0, TSeekOrigin.soEnd );
    end
    else
      FileStream := TFileStream.Create( cFilename, fmCreate or fmShareDenyWrite );

    StringList_Lines := TStringList.Create;

    StringList_Line := TStringList.Create;
    StringList_Line.StrictDelimiter := True;
    StringList_Line.Delimiter := ';';

    if CanPutHeaders then begin
      {$REGION 'Génération de l''entête'}
      for i := 0 to Pred( Form1.TD.Fields.Count ) do
        StringList_Line.Add( Trim( Form1.TD.Fields[ i ].FieldName ) );
      StringList_Line.Add( 'mag_id' );
      StringList_Line.Add( 'bas_sender' );
      StringList_Line.Add( 'ass_nom' );
      StringList_Line.Add( 'ass_code' );
      StringList_Line.Add( 'ass_amaj' );
      StringList_Line.Add( 'asf_ftphost' );
      StringList_Line.Add( 'asf_ftpuser' );
      StringList_Line.Add( 'asf_ftppwd' );
      StringList_Line.Add( 'asf_ftpport' );
      StringList_Line.Add( 'asf_dossierftp' );
      StringList_Line.Add( 'asf_dosend' );
      StringList_Line.Add( 'mdl_BONS_ACHAT' );
      StringList_Line.Add( 'mdl_LOCATION' );
      StringList_Lines.Add( StringList_Line.DelimitedText );
      {$ENDREGION}
      CanPutHeaders := False;
    end;
  end;
  try

    lg := length(form1.ens.text); //Libelle enseigne
    form1.td.open;
    form1.liste.first;

    WHILE NOT form1.liste.eof DO
    BEGIN

      ch := form1.listechaine.asstring;
      i := pos(form1.ens.text, ch);

      i := i + lg + 1;
      dossier := '';
      car := copy(ch, i, 1);
      WHILE car <> '\' DO
      BEGIN
        dossier := dossier + car;
        i := i + 1;
        car := copy(ch, i, 1);
      END;

      delete(ch, 1, 2);
     // lame := copy(ch, 1, 9);
      lame := copy(ch, 1, Pos('\',ch) - 1);
      delete(ch, 1, Length(lame) + 1);

      case IniCfg.TypeServeur of
        0: begin // lame
          ch := lame + ':D:' + ch;
        end;
        1: begin // OCEALIS
          lame := lame + ':';
          i := Pos('\',ch);
          Insert(':', ch, i);

          ch := lame + ch;
        end;
      end;

      Form1.Memo2.Lines.Add(dossier);

      //Ouverture base ginkoia...

      form1.ib.databasename := ch;
      TRY
        form1.ib.open;
        //lecture table version
        form1.qv.open;
        //Lecture table magasin
        form1.qm.open;
        form1.qm.first;
        WHILE NOT form1.qm.eof DO
        BEGIN
          //form1.q_is.close;
          //form1.q_is.parambyname('magid').asinteger:=form1.qm.fieldbyname('mag_id').asinteger;
          //form1.Q_IS.Open;

          //form1.q_s2k.close;
          //form1.q_s2k.parambyname('magid').asinteger:=form1.qm.fieldbyname('mag_id').asinteger;
          //form1.Q_s2k.Open;

          //form1.q_tw.close;
          //form1.q_tw.parambyname('magid').asinteger:=form1.qm.fieldbyname('mag_id').asinteger;
          //form1.Q_tw.Open;

          //form1.q_sms.close;
          //form1.q_sms.parambyname('magid').asinteger:=form1.qm.fieldbyname('mag_id').asinteger;
          //form1.q_sms.Open;


          form1.q_tck.close;
          form1.q_tck.parambyname('magid').asinteger:=form1.qm.fieldbyname('mag_id').asinteger;
          form1.q_tck.Open;


          form1.q_poste.close;
          form1.q_poste.parambyname('magid').asinteger:=form1.qm.fieldbyname('mag_id').asinteger;
          form1.q_poste.Open;

          form1.td.append;
          form1.TDdos_centrale.asstring := copy(form1.ens.text, 1, 2);
          form1.TDdos_nom.asstring := dossier;
          form1.TDdos_chemin.asstring := ch;
          form1.TDdos_code.asstring := form1.qm.fieldbyname('MAG_CODEADH').asstring;
          form1.TDdos_magnom.asstring := form1.qm.fieldbyname('MAG_ENSEIGNE').asstring;
          form1.TDdos_ville.asstring := form1.qm.fieldbyname('VIL_NOM').asstring;
          form1.TDdos_version.asstring:= form1.qv.fieldbyname('ver_version').asstring;
          //form1.TDdos_resais.asinteger:=form1.q_is.fieldbyname('nb').asinteger;
          //form1.TDdos_resatw.asinteger:=form1.q_tw.fieldbyname('nb').asinteger;
          //form1.TDdos_resas2k.asinteger:=form1.q_s2k.fieldbyname('nb').asinteger;
          form1.TDdos_resais.asinteger:=0;
          form1.TDdos_resatw.asinteger:=0;
          form1.TDdos_resas2k.asinteger:=0;
          form1.TDdos_lstbase.AsInteger := IniCfg.NumSoft;
          //form1.tddos_smsasstring:=form1.qm.fieldbyname('VIL_NOM').asstring;

          //form1.TDdos_sms.asstring:=form1.q_sms.fieldbyname('idm_presta').asstring;
          //form1.TDdos_sms.asstring:=form1.q_sms.fieldbyname('prm_string').asstring;
          //FORM1.TDdos_sms.AsString:='';
          form1.tddos_dermvt.asdatetime:=form1.q_tck.fieldbyname('dt').asdatetime;

//          form1.TDmag_id.AsInteger := Form1.QM.FieldByName( 'MAG_ID' ).AsInteger;
//          form1.TDbas_sender.AsString := Form1.QM.FieldByName( 'BAS_SENDER' ).AsString;

          form1.td.post;

          {$REGION 'Génération des datas'}
          StringList_Line.Clear;
          for i := 0 to Pred( Form1.TD.Fields.Count ) do
            StringList_Line.Add( Trim( Form1.TD.Fields[ i ].AsString ) );
          StringList_Line.Add( Trim( Form1.QM.FieldByName('MAG_ID').AsString ) );
          StringList_Line.Add( Trim( Form1.QM.FieldByName('BAS_SENDER').AsString ) );

          Form1.Q_WebConfig.Open;
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'ass_nom' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'ass_code' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'ass_amaj' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'asf_ftphost' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'asf_ftpuser' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'asf_ftppwd' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'asf_ftpport' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'asf_dossierftp' ).AsString ) );
          StringList_Line.Add( Trim( Form1.Q_WebConfig.FieldByName( 'asf_dosend' ).AsString ) );
          Form1.Q_WebConfig.Close;

          Form1.Q_Module.ParamByName( 'MAGID' ).AsInteger := Form1.QM.FieldByName( 'MAG_ID' ).AsInteger;
          Form1.Q_Module.Open;
          if Form1.Q_Module.RecordCount > 0 then
            StringList_Line.Add( Trim( Form1.Q_Module.FieldByName( 'mdl_BONS_ACHAT' ).AsString ) )
          else
            StringList_Line.Add( '' );

          if Form1.Q_Module.RecordCount > 0 then
            StringList_Line.Add( Trim( Form1.Q_Module.FieldByName( 'mdl_LOCATION' ).AsString ) )
          else
            StringList_Line.Add( '' );
          Form1.Q_Module.Close;

          StringList_Lines.Add( StringList_Line.DelimitedText );
          {$ENDREGION}

          form1.qm.next;
        END;
      EXCEPT
        form1.td.append;
        form1.TDdos_centrale.asstring := copy(form1.ens.text, 1, 2);
        form1.TDdos_nom.asstring := dossier;
        form1.TDdos_chemin.asstring := ch;
        form1.TDdos_code.asstring := 'NON TRAITE';
        form1.TDdos_magnom.asstring := 'NON TRAITE';
        form1.TDdos_ville.asstring := 'NON TRAITE';
        form1.TDdos_lstbase.AsInteger := IniCfg.NumSoft;
        form1.td.post;

      END;
      form1.qm.close;
      form1.ib.close;
      form1.liste.next;
    END;
  finally
    if CanGenerateCSV then begin
      StringList_Lines.SaveToStream( FileStream );
      FileStream.Free;
      StringList_Lines.Free;
      StringList_Line.Free;
    end
  end
END;

procedure TForm1.ConnexionAdo;
begin
  ado.Connected := False;
  ado.ConnectionString := IniCfg.MsSqlConnectionString;
  Try
    ado.Connected := True;
  Except on E:Exception do
    ShowMessage('Erreur de connexion à la base de données: ' + E.Message);
  End;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Inicfg.FreeList;
end;

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
  Caption := Caption + ' - Version : ' + GetNumVersionSoft;

  form1.liste.open;

  // chargement du fichier Ini
  IniCfg.LoadIni;
  IniCfg.AdoConnection := ado;

  if IniCfg.NumSoft = 0 then
    Nbt_Parametrage.Click
  else
    // connexion au serveur
    ConnexionAdo;
END;

procedure TForm1.Nbt_ParametrageClick(Sender: TObject);
begin

  Timer1.Enabled := False;
  if IniCfg.ShowCfgInterface = mrOk then
    ConnexionAdo;
  Timer1.Enabled := True;
end;

PROCEDURE TForm1.Timer1Timer(Sender: TObject);
BEGIN
  timer1.enabled := false;
  Button1Click(NIL);
END;

END.

