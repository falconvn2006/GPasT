unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AlgolDialogForms, GinkoiaStyle_Dm, AdvGlowButton, ExtCtrls, RzPanel,
  GinPanel, Midaslib, StdCtrls, RzLabel, AdvCombo, Grids, DBGrids, DB, DBClient,
  Mask, DBCtrls, IBODataset, Buttons, uVersion;

type
  TFrm_Main = class(TForm)
    RzPanel1: TRzPanel;
    GinPanel1: TGinPanel;
    RzPanel2: TRzPanel;
    GinPanel2: TGinPanel;
    RzPanel3: TRzPanel;
    Lst_Reper: TListBox;
    RzPanel6: TRzPanel;
    DBGrid1: TDBGrid;
    RzPanel7: TRzPanel;
    Bt_AjoutProc: TAdvGlowButton;
    Bt_SupprProc: TAdvGlowButton;
    Bt_OrdreUp: TAdvGlowButton;
    Bt_OrdreDown: TAdvGlowButton;
    RzLabel2: TRzLabel;
    Ds_Proc: TDataSource;
    OD_Proc: TOpenDialog;
    OD_Base: TOpenDialog;
    GinPanel4: TGinPanel;
    Bt_AjoutParam: TAdvGlowButton;
    Bt_ModifParam: TAdvGlowButton;
    Bt_SupprParam: TAdvGlowButton;
    RzPanel8: TRzPanel;
    DBGrid2: TDBGrid;
    Pan_Select: TGinPanel;
    RzLabel1: TRzLabel;
    Cmb_Ch: TAdvComboBox;
    Bt_AjoutNom: TAdvGlowButton;
    Bt_ModifNom: TAdvGlowButton;
    Bt_SupprNom: TAdvGlowButton;
    Ds_Param: TDataSource;
    DataSource1: TDataSource;
    Bt_AjoutReper: TAdvGlowButton;
    Bt_SupprReper: TAdvGlowButton;
    od: TGinPanel;
    Label2: TLabel;
    Label3: TLabel;
    btn_BasePath: TAdvGlowButton;
    Ed_NomBase: TEdit;
    Ed_CheminExport: TEdit;
    Bt_CheminExport: TAdvGlowButton;
    Chk_Guillemet: TCheckBox;
    Chk_PointVirgule: TCheckBox;
    Bt_CreeProc: TAdvGlowButton;
    Bt_Export: TAdvGlowButton;
    Bt_Drop: TAdvGlowButton;
    Chk_OkEntete: TCheckBox;
    GinPanel3: TGinPanel;
    Lab_FicExport: TLabel;
    Label1: TLabel;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    DBCheckBox3: TDBCheckBox;
    DBTxt_FicExport: TDBEdit;
    Bt_ModifDetail: TAdvGlowButton;
    Bt_CreeLaProc: TAdvGlowButton;
    Bt_ExportLaProc: TAdvGlowButton;
    Bt_DropLaProc: TAdvGlowButton;
    DBCheckBox4: TDBCheckBox;
    bt_ParamEntree: TAdvGlowButton;
    Bt_ParamSortie: TAdvGlowButton;
    DBCheckBox5: TDBCheckBox;
    Bt_Rafraichir: TAdvGlowButton;
    Pan_Bottom: TRzPanel;
    btn_Quitter: TAdvGlowButton;
    procedure btn_QuitterClick(Sender: TObject);
    procedure AlgolDialogFormCreate(Sender: TObject);
    procedure Cmb_ChChange(Sender: TObject);
    procedure Bt_AjoutNomClick(Sender: TObject);
    procedure Bt_ModifNomClick(Sender: TObject);
    procedure Bt_AjoutProcClick(Sender: TObject);
    procedure Bt_SupprProcClick(Sender: TObject);
    procedure Bt_OrdreDownClick(Sender: TObject);
    procedure Bt_OrdreUpClick(Sender: TObject);
    procedure Ds_ProcDataChange(Sender: TObject; Field: TField);
    procedure Bt_AjoutReperClick(Sender: TObject);
    procedure Bt_SupprReperClick(Sender: TObject);
    procedure Bt_ModifDetailClick(Sender: TObject);
    procedure Bt_CheminExportClick(Sender: TObject);
    procedure btn_BasePathClick(Sender: TObject);
    procedure Chk_GuillemetClick(Sender: TObject);
    procedure Chk_PointVirguleClick(Sender: TObject);
    procedure Bt_CreeProcClick(Sender: TObject);
    procedure Bt_ExportClick(Sender: TObject);
    procedure Bt_DropClick(Sender: TObject);
    procedure Bt_SupprNomClick(Sender: TObject);
    procedure Bt_CreeLaProcClick(Sender: TObject);
    procedure Bt_DropLaProcClick(Sender: TObject);
    procedure Bt_ExportLaProcClick(Sender: TObject);
    procedure Bt_AjoutParamClick(Sender: TObject);
    procedure Bt_ModifParamClick(Sender: TObject);
    procedure Bt_SupprParamClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Bt_RafraichirClick(Sender: TObject);
    procedure bt_ParamEntreeClick(Sender: TObject);
    procedure Bt_ParamSortieClick(Sender: TObject);
    procedure Chk_OkEnteteClick(Sender: TObject);
  private
    { Déclarations privées }
    ChoixReper: string;
    ChoixNomExport: string;          // dernier nom d'export choisi

    // test le fichier si on le trouve une seule fois
    function RetrouveNbFichier(AFileName: string): integer;

    // retrouve le fichier complet
    function RetrouveExpandFichier(AFileName: string): string;

    // cree une seule procedure
    function CreerLaProcedure: boolean;
    // drop une seule procedure
    function DropLaProcedure: boolean;
    // exportation un seule fichier
    function ExportLaProcedure: boolean;

    // passe tous les fichiers script
    function CreerLesProcedures: boolean;
    // Drop les procedure (si coché)
    function DropLesProcedures: boolean;
    // exportation
    function Exportation: boolean;

    // ajouter un répertoire
    procedure AjouterUnRepertoire(AReper: string);

    // recupère le prochain N° des noms d'export
    function GetNextNumExport: integer;
    // recupère la liste des noms d'export
    procedure DoListeExport(AListe: TStrings);
    // recupère l'IDStr du nom de l'export (ex: EXPORT1)
    function GetSectionNomExport(ANom: string): string;
    // recupère la liste des répertoire pour un nom d'export
    procedure GetRepertoire(ASection: string; AListe: TStrings);
    // recupère la liste des sections des nom des paramètre
    procedure GetLstParam(ASection: string; AListe: TStrings);
    // récupère le détail d'un paramètre
    procedure GetDetailParam(ASection: string; var ANum: integer; var ANom: string; var ATipe: integer;
                            Var ValString: string; var ValInteger, ValFloat, ValDateTime: Variant);
    // recupère la liste des fichiers de proc stockées pour un nom d'export
    procedure GetLstProc(ASection: string; AListe: TStrings);
    // recupere le detail d'une proc
    procedure GetDetailProc(ASection: string; var AOrdre: integer; var AFicProc, AFicCsv: string;
        var AOkGrantGinkoia, AOkGrantRepl, AOkDropAfterExport, AvIn, AvOut: integer; var ARecupParam, AStkActif: boolean);
    // recupère le num de paramètre associé aux entrées de la proc stockée
    function GetNumParamFromStkProc(ASection: string; AIdent: string): integer;
    // charge parametre d'entrée d'une proc stockée
    procedure ChargeParamInFromStkProc(ASection: string; ANbre: integer);
    // sauvegarde parametre d'entrée d'une proc stockée
    procedure SauveParamInFromStkProc(ASection: string; Var ivIn, ivInFait: integer);
    // enregistre tous les paramètres trouvé
    procedure SetParamInFromStkProc(AParams: string);
    // charge parametre de sortie d'une proc stockée
    procedure ChargeParamOutFromStkProc(ASection: string);
    // sauvegarde parametre de sortie d'une proc stockée
    procedure SauveParamOutFromStkProc(ASection: string; Var ivOut: integer);

    // charge tout l'export sélectionné
    procedure LoadNomExport;

    // efface l'export
    procedure EraseExport;

    // sauve l'export
    procedure SauveNomExport;

    // etat des boutons
    procedure DoBoutonNomExport;
    procedure DoBoutonRepertoire;
    procedure DoBoutonParam;
    procedure DoBoutonListeProc;
    procedure DoBoutonListeProcOrder;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  IniFiles, Main_Dm, AjoutModifNomExport_Frm, ValeurDefaut_Frm, {$WARN UNIT_PLATFORM OFF} FileCtrl {$WARN UNIT_PLATFORM ON},
  ModifDetail_Frm, Progress_Frm, AjoutModifParam_Frm, ParamEntree_Frm,
  ParamSortie_Frm, SaisiParam_Frm;

{$R *.dfm}

procedure WriteStreamString(AStream: TStream; ALigne: string);
var
  sLigne: AnsiString;
begin
  sLigne := AnsiString(ALigne + #13#10);
  AStream.Write(sLigne[1],Length(sLigne));
end;

// test le fichier si on le trouve une seule fois
function TFrm_Main.RetrouveNbFichier(AFileName: string): integer;
var
  i: integer;
  sFile: string;
begin
  Result := 0;
  for i := 1 to Dm_Main.ListeNomReper.Count do
  begin
    sFile := Dm_Main.ListeNomReper[i-1];
    if (sFile<>'') and (sFile[Length(sFile)]<>'\') then
      sFile := sFile+'\';

    sFile := sFile+AFileName;

    if FileExists(sFile) then
      inc(Result);
  end;
end;

// retrouve le fichier complet
function TFrm_Main.RetrouveExpandFichier(AFileName: string): string;
var
  i: integer;
  sFile: string;
begin
  Result := '';
  i := 1;
  while (Result='') and (i<=Dm_Main.ListeNomReper.Count) do
  begin
    sFile := Dm_Main.ListeNomReper[i-1];
    if (sFile<>'') and (sFile[Length(sFile)]<>'\') then
      sFile := sFile+'\';

    sFile := sFile+AFileName;

    if FileExists(sFile) then
      Result := sFile;

    inc(i);
  end;
end;

// cree une seule procedure
function TFrm_Main.CreerLaProcedure: boolean;
var
  nb: integer;
  sTmp: string;
  sFicProc: string;
  sFile: string;
  sFirstLigne: string;
  sProcName: string;
  TmpListe: TStringList;
begin
  result := false;
  Frm_Progress.DoEtat('Test du fichier');
  Nb := RetrouveNbFichier(Dm_Main.cds_Proc.FieldByName('FicProc').AsString);
  if (Nb=0) then
    raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                           ' non trouvé dans la liste des répertoires');
  if (Nb>1) then
    raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                           ' trouvé plusieurs fois dans la liste des répertoires');

  TmpListe := TStringList.Create;
  try
    try
      sFicProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
      Frm_Progress.DoEtat(sFicProc);
      sFile := RetrouveExpandFichier(sFicProc);
      TmpListe.Clear;
      TmpListe.LoadFromFile(sFile);

      if TmpListe.Count>0 then
      begin
        sFirstLigne := UpperCase(TmpListe[0]);
        //Retrouve le nom de la procedure stockée
        sProcName := '';
        if Pos('CREATE', sFirstLigne)=1 then
        begin
          sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
          if Pos('PROCEDURE', sFirstLigne)=1 then
          begin
            sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
            if Pos(' ', sFirstLigne)>0 then
              sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
            if Pos('(', sFirstLigne)>0 then
              sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
            if Pos(';', sFirstLigne)>0 then
              sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
            sProcName := sFirstLigne;
          end;
        end;
        // test existance procedure stocké et change eventuellement en alter
        if (sProcName<>'') and Dm_Main.IsProcedureExists(sProcName) then
        begin
          sFirstLigne := UpperCase(TmpListe[0]);
          sFirstLigne := 'ALTER '+Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
          TmpListe.Insert(0, sFirstLigne);
          TmpListe.Delete(1);
        end;

        // passe le script (normalement une proc stockée)
        Dm_Main.PassageScript(TmpListe.Text);

        // passe les grant si nécessaire
        if (sProcName<>'') and (Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger=1) then
          Dm_Main.GrantProcedure(sProcName, true);

        if (sProcName<>'') and (Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger=1) then
          Dm_Main.GrantProcedure(sProcName, false);

      end;
      Result := true;
    except
      on E: Exception do
      begin
        sTmp := 'Pb avec le fichier: '+sFicProc;
        if sProcName<>'' then
          sTmp := sTmp+' ; Proc Stk: '+sProcName;

        E.Message := sTmp+' : '+E.Message;
        raise;
      end;
    end;
  finally
    FreeAndNil(TmpListe);
  end;
end;

// passe tous les fichiers script
function TFrm_Main.CreerLesProcedures: boolean;
var
  Book: TBookMark;
  Nb: integer;
  sTmp: string;
  sFicProc: string;
  sFile: string;
  sFirstLigne: string;
  sProcName: string;
  TmpListe: TStringList;
begin
  Result := false;

  sProcName := '';
  sFicProc := '';
  Book := Dm_Main.cds_Proc.GetBookmark;
  Dm_Main.cds_Proc.DisableControls;
  TmpListe := TStringList.Create;
  try
    Frm_Progress.DoEtat('Test des fichiers');
    // test les fichiers
    Dm_Main.cds_Proc.First;
    while not(Dm_Main.cds_Proc.Eof) do
    begin
      if Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean then
      begin
        // nombre de fois où le fichier est trouvé dans la liste des répertoires
        // doit être = à 1
        Nb := RetrouveNbFichier(Dm_Main.cds_Proc.FieldByName('FicProc').AsString);
        if (Nb=0) then
          raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                                 ' non trouvé dans la liste des répertoires');
        if (Nb>1) then
          raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                                 ' trouvé plusieurs fois dans la liste des répertoires');
      end;

      Dm_Main.cds_Proc.Next;
    end;

    try
      // passe les script
      Dm_Main.cds_Proc.First;
      while not(Dm_Main.cds_Proc.Eof) do
      begin
        if Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean then
        begin
          sFicProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
          Frm_Progress.DoEtat(sFicProc);
          sFile := RetrouveExpandFichier(sFicProc);
          TmpListe.Clear;
          TmpListe.LoadFromFile(sFile);

          if TmpListe.Count>0 then
          begin
            sFirstLigne := UpperCase(TmpListe[0]);
            //Retrouve le nom de la procedure stockée
            sProcName := '';
            if Pos('CREATE', sFirstLigne)=1 then
            begin
              sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
              if Pos('PROCEDURE', sFirstLigne)=1 then
              begin
                sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
                if Pos(' ', sFirstLigne)>0 then
                  sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
                if Pos('(', sFirstLigne)>0 then
                  sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
                if Pos(';', sFirstLigne)>0 then
                  sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
                sProcName := sFirstLigne;
              end;
            end;
            // test existance procedure stocké et change eventuellement en alter
            if (sProcName<>'') and Dm_Main.IsProcedureExists(sProcName) then
            begin
              sFirstLigne := UpperCase(TmpListe[0]);
              sFirstLigne := 'ALTER '+Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
              TmpListe.Insert(0, sFirstLigne);
              TmpListe.Delete(1);
            end;

            // passe le script (normalement une proc stockée)
            Dm_Main.PassageScript(TmpListe.Text);

            // passe les grant si nécessaire
            if (sProcName<>'') and (Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger=1) then
              Dm_Main.GrantProcedure(sProcName, true);

            if (sProcName<>'') and (Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger=1) then
              Dm_Main.GrantProcedure(sProcName, false);

          end;
        end;

        Dm_Main.cds_Proc.Next;
      end;

      Result := true;
    except
      on E: Exception do
      begin
        sTmp := 'Pb avec le fichier: '+sFicProc;
        if sProcName<>'' then
          sTmp := sTmp+' ; Proc Stk: '+sProcName;

        E.Message := sTmp+' : '+E.Message;
        raise;
      end;
    end;

  finally
    Dm_Main.cds_Proc.GotoBookmark(Book);
    Dm_Main.cds_Proc.FreeBookmark(Book);
    Dm_Main.cds_Proc.EnableControls;
    FreeAndNil(TmpListe);
  end;
end;

// drop une seule procedure
function TFrm_Main.DropLaProcedure: boolean;
var
  nb: integer;
  sTmp: string;
  sFicProc: string;
  sFile: string;
  sFirstLigne: string;
  sProcName: string;
  TmpListe: TStringList;
begin
  result := false;
  Frm_Progress.DoEtat('Test du fichier');
  Nb := RetrouveNbFichier(Dm_Main.cds_Proc.FieldByName('FicProc').AsString);
  if (Nb=0) then
    raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                           ' non trouvé dans la liste des répertoires');
  if (Nb>1) then
    raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                           ' trouvé plusieurs fois dans la liste des répertoires');

  TmpListe := TStringList.Create;
  try
    try
      sFicProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
      Frm_Progress.DoEtat(sFicProc);
      sFile := RetrouveExpandFichier(sFicProc);
      TmpListe.Clear;
      TmpListe.LoadFromFile(sFile);

      if TmpListe.Count>0 then
      begin
        sFirstLigne := UpperCase(TmpListe[0]);
        //Retrouve le nom de la procedure stockée
        sProcName := '';
        if Pos('CREATE', sFirstLigne)=1 then
        begin
          sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
          if Pos('PROCEDURE', sFirstLigne)=1 then
          begin
            sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
            if Pos(' ', sFirstLigne)>0 then
              sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
            if Pos('(', sFirstLigne)>0 then
              sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
            if Pos(';', sFirstLigne)>0 then
              sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
            sProcName := sFirstLigne;
          end;
        end;

        // test existance procedure stocké et change eventuellement en alter
        if (sProcName<>'') and (Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger=1)
             and Dm_Main.IsProcedureExists(sProcName) then
        begin
          // passe le script (normalement une proc stockée)
          Dm_Main.PassageScript('DROP PROCEDURE '+sProcName);
        end;

      end;
      Result := true;
    except
      on E: Exception do
      begin
        sTmp := 'Pb avec le fichier: '+sFicProc;
        if sProcName<>'' then
          sTmp := sTmp+' ; Proc Stk: '+sProcName;

        E.Message := sTmp+' : '+E.Message;
        raise;
      end;
    end;
  finally
    FreeAndNil(TmpListe);
  end;
end;

// Drop les procedure (si coché)
function TFrm_Main.DropLesProcedures: boolean;
var
  Book: TBookMark;
  Nb: integer;
  sTmp: string;
  sFicProc: string;
  sFile: string;
  sFirstLigne: string;
  sProcName: string;
  TmpListe: TStringList;
begin
  Result := false;

  sProcName := '';
  sFicProc := '';
  Book := Dm_Main.cds_Proc.GetBookmark;
  Dm_Main.cds_Proc.DisableControls;
  TmpListe := TStringList.Create;
  try
    Frm_Progress.DoEtat('Test des fichiers');
    // test les fichiers
    Dm_Main.cds_Proc.First;
    while not(Dm_Main.cds_Proc.Eof) do
    begin
      // nombre de fois où le fichier est trouvé dans la liste des répertoires
      // doit être = à 1
      Nb := RetrouveNbFichier(Dm_Main.cds_Proc.FieldByName('FicProc').AsString);
      if (Nb=0) then
        raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                               ' non trouvé dans la liste des répertoires');
      if (Nb>1) then
        raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                               ' trouvé plusieurs fois dans la liste des répertoires');

      Dm_Main.cds_Proc.Next;
    end;

    try
      // passe les script
      Dm_Main.cds_Proc.Last;
      while not(Dm_Main.cds_Proc.Bof) do
      begin
        sFicProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
        Frm_Progress.DoEtat(sFicProc);
        sFile := RetrouveExpandFichier(sFicProc);
        TmpListe.Clear;
        TmpListe.LoadFromFile(sFile);

        if TmpListe.Count>0 then
        begin
          sFirstLigne := UpperCase(TmpListe[0]);
          //Retrouve le nom de la procedure stockée
          sProcName := '';
          if Pos('CREATE', sFirstLigne)=1 then
          begin
            sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
            if Pos('PROCEDURE', sFirstLigne)=1 then
            begin
              sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
              if Pos(' ', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
              if Pos('(', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
              if Pos(';', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
              sProcName := sFirstLigne;
            end;
          end;
          // test existance procedure stocké et change eventuellement en alter
          if (sProcName<>'') and (Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger=1)
               and Dm_Main.IsProcedureExists(sProcName) then
          begin
            // passe le script (normalement une proc stockée)
            Dm_Main.PassageScript('DROP PROCEDURE '+sProcName);
          end;

        end;

        Dm_Main.cds_Proc.Prior;
      end;

      Result := true;
    except
      on E: Exception do
      begin
        sTmp := 'Pb avec le fichier: '+sFicProc;
        if sProcName<>'' then
          sTmp := sTmp+' ; Proc Stk: '+sProcName;

        E.Message := sTmp+' : '+E.Message;
        raise;
      end;
    end;

  finally
    Dm_Main.cds_Proc.GotoBookmark(Book);
    Dm_Main.cds_Proc.FreeBookmark(Book);
    Dm_Main.cds_Proc.EnableControls;
    FreeAndNil(TmpListe);
  end;
end;

// exportation un seule fichier
function TFrm_Main.ExportLaProcedure: boolean;
var
  NomSection: string;
  sProcSection: string;
  NomSectionDetailProc: string;
  Nb: integer;
  sRep: string;
  sTmp: string;
  sFicProc: string;
  sFicCsv: string;
  sFile: string;
  sFirstLigne: string;
  sProcName: string;
  TmpListe: TStringList;
  QryTmp: TIBOQuery;
  sLigne: string;
  sChamp: string;
  i: integer;
  Cnt: integer;
  PrCen: integer;
  LParam: integer;
  sChampParam: string;
  sLstParam: string;
  StreamDst: TFileStream;
begin
  result := false;

  NomSection := GetSectionNomExport(ChoixNomExport);

  StreamDst := Nil;
  sRep := Ed_CheminExport.Text;
  TmpListe := TStringList.Create;
  try
    try
      sFicProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
      sProcSection := Copy(sFicProc, 1, Length(sFicProc)-Length(ExtractFileExt(sFicProc)));

      // paramètre d'endrée
      NomSectionDetailProc := Nomsection+'_'+sProcSection+'_IN';
      // charge les paramètres d'entrée
      ChargeParamInFromStkProc(NomSectionDetailProc, Dm_Main.cds_Proc.FieldByName('vIn').AsInteger);

      sFicCsv := Dm_Main.cds_Proc.FieldByName('FicCsv').AsString;
      Dm_Main.cds_EntreeIn.First;
      while not Dm_Main.cds_EntreeIn.Eof do
      begin
        if AnsiPos('%' + Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString + '%', sFicCsv) <> 0 then
        begin
          LParam := Dm_Main.cds_EntreeIn.FieldByName('NumParam').AsInteger;
          sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;

          if Dm_Main.cds_Param.Locate('Num', LParam, []) then
          begin
            Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
              1:
              begin
                if Dm_Main.cds_Param.FieldByName('ValString').Value <> Null then
                  sTmp := Dm_Main.cds_Param.FieldByName('ValString').Value
                else
                  sTmp := '';
              end;
            end;
          end;
          sFicCsv := StringReplace(sFicCsv, '%' + Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString + '%', sTmp,[rfReplaceAll, rfIgnoreCase]);
          Dm_Main.cds_EntreeIn.Last;
        end;
        Dm_Main.cds_EntreeIn.Next;
      end;
      Frm_Progress.DoEtat(sFicCsv);
      sProcName := '';
      if sFicCsv<>'' then
      begin
        sFile := RetrouveExpandFichier(sFicProc);
        TmpListe.Clear;
        TmpListe.LoadFromFile(sFile);

        if TmpListe.Count>0 then
        begin
          sFirstLigne := UpperCase(TmpListe[0]);
          //Retrouve le nom de la procedure stockée
          if Pos('CREATE', sFirstLigne)=1 then
          begin
            sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
            if Pos('PROCEDURE', sFirstLigne)=1 then
            begin
              sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
              if Pos(' ', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
              if Pos('(', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
              if Pos(';', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
              sProcName := sFirstLigne;
            end;
          end;
        end;

        //export
        if FileExists(sRep+sFicCsv) then
          DeleteFile(sRep+sFicCsv);

        StreamDst := TFileStream.Create(sRep+sFicCsv, fmCreate);
        try
          if sProcName<>'' then
          begin
            QryTmp := TIBOQuery.Create(Self);
            try
              QryTmp.IB_Connection := Dm_Main.DataBase;
              QryTmp.IB_Transaction := Dm_Main.Transaction;
              QryTmp.ParamCheck := false;
              QryTmp.SQL.Clear;
              QryTmp.SQL.Add('select * from '+sProcName);
              // paramètres
              sLstParam := '';
              Dm_Main.cds_EntreeIn.First;
              while not(Dm_Main.cds_EntreeIn.Eof) do
              begin
                sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;
                if (sLstParam<>'') then
                  sLstParam := sLstParam+', ';
                sLstParam := sLstParam +':'+sChampParam;
                Dm_Main.cds_EntreeIn.Next;
              end;
              if sLstParam<>'' then
                QryTmp.SQL.Add('('+sLstParam+')');
              QryTmp.ParamCheck := true;
              //affectation des paramètres
              Dm_Main.cds_EntreeIn.First;
              while not(Dm_Main.cds_EntreeIn.Eof) do
              begin
                LParam := Dm_Main.cds_EntreeIn.FieldByName('NumParam').AsInteger;
                sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;

                if Dm_Main.cds_Param.Locate('Num', LParam, []) then
                begin
                  Dm_Main.cds_Param.Edit;
                  Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
                    1: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValString').Value;
                    2: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValInteger').Value;
                    3: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValFloat').Value;
                    4: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValDateTime').Value;
                  end;
                  Dm_Main.cds_Param.Post;
                end;
                Dm_Main.cds_EntreeIn.Next;
              end;

              QryTmp.Open;

              // Calcul progression
              Nb := QryTmp.RecordCount;
              PrCen :=  Round((Nb/100)*5);
              if (PrCen<=0) then
                PrCen := 1;
              Cnt := 0;
              Frm_Progress.SetInitBar(Nb);

              // ligne d'entete
              if Chk_OkEntete.Checked then
              begin
                sLigne := '';
                for i := 1 to QryTmp.Fields.Count do
                begin
                  sChamp := StringReplace(QryTmp.Fields[i-1].FieldName, ';', '-', [rfReplaceAll, rfIgnoreCase]);
                  sChamp := StringReplace(sChamp, #13#10, '\n', [rfReplaceAll, rfIgnoreCase]);
                  sChamp := StringReplace(sChamp, #10, '\l', [rfReplaceAll, rfIgnoreCase]);
                  if Chk_Guillemet.Checked then
                    sChamp := '"'+sChamp+'"';
                  if sLigne<>'' then
                    sLigne := sLigne+';';

                  sLigne := sLigne+sChamp;
                end;
                if Chk_PointVirgule.Checked then
                  sLigne := sLigne+';';
                // TmpListe.Add(sLigne);
                WriteStreamString(StreamDst, sLigne);
              end;

              // export
              QryTmp.First;
              while not(QryTmp.Eof) do
              begin

                if ((cnt mod PrCen)=0) then
                begin
                  Frm_Progress.DoProgress(cnt);
                  Application.ProcessMessages;
                end;

                sLigne := '';
                for i := 1 to QryTmp.Fields.Count do
                begin
                  sChamp := QryTmp.Fields[i-1].AsString;
                  sChamp := StringReplace(sChamp, ';', '-', [rfReplaceAll, rfIgnoreCase]);
                  sChamp := StringReplace(sChamp, #13#10, '\n', [rfReplaceAll, rfIgnoreCase]);
                  sChamp := StringReplace(sChamp, #10, '\l', [rfReplaceAll, rfIgnoreCase]);
                  if Chk_Guillemet.Checked then
                    sChamp := '"'+sChamp+'"';
                  if sLigne<>'' then
                    sLigne := sLigne+';';

                  sLigne := sLigne+sChamp;
                end;
                if Chk_PointVirgule.Checked then
                  sLigne := sLigne+';';
                // TmpListe.Add(sLigne);
                WriteStreamString(StreamDst, sLigne);

                inc(cnt);

                QryTmp.Next;
              end;

              // TmpListe.SaveToFile(sRep+sFicCsv);

            finally
              Frm_Progress.SetEndBar;
              QryTmp.Close;
              FreeAndNil(QryTmp);
            end;
          end;
        finally
          StreamDst.Free;
          StreamDst := nil;
        end;
      end       // if sFicCsv<>'' then
      else if Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean then
      begin
        sFile := RetrouveExpandFichier(sFicProc);
        TmpListe.Clear;
        TmpListe.LoadFromFile(sFile);

        if TmpListe.Count>0 then
        begin
          sFirstLigne := UpperCase(TmpListe[0]);
          //Retrouve le nom de la procedure stockée
          if Pos('CREATE', sFirstLigne)=1 then
          begin
            sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
            if Pos('PROCEDURE', sFirstLigne)=1 then
            begin
              sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
              if Pos(' ', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
              if Pos('(', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
              if Pos(';', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
              sProcName := sFirstLigne;
            end;
          end;
        end;

        //export
        TmpListe.Clear;
        if sProcName<>'' then
        begin
          QryTmp := TIBOQuery.Create(Self);
          try
            QryTmp.IB_Connection := Dm_Main.DataBase;
            QryTmp.IB_Transaction := Dm_Main.Transaction;
            QryTmp.ParamCheck := false;
            QryTmp.SQL.Clear;

            // paramètre de sortie
            NomSectionDetailProc := Nomsection+'_'+sProcSection+'_OUT';
            // charge les paramètres d'entrée
            ChargeParamOutFromStkProc(NomSectionDetailProc);

            // exporte les resultat
            Dm_Main.cds_SortieOut.First;
            if not(Dm_Main.cds_SortieOut.Eof) then
              QryTmp.SQL.Add('select * from '+sProcName)
            else
              QryTmp.SQL.Add('execute procedure '+sProcName);
            // paramètres
            sLstParam := '';
            Dm_Main.cds_EntreeIn.First;
            while not(Dm_Main.cds_EntreeIn.Eof) do
            begin
              sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;
              if (sLstParam<>'') then
                sLstParam := sLstParam+', ';
              sLstParam := sLstParam +':'+sChampParam;
              Dm_Main.cds_EntreeIn.Next;
            end;
            if sLstParam<>'' then
              QryTmp.SQL.Add('('+sLstParam+')');
            QryTmp.ParamCheck := true;
            // affectation des paramètres
            Dm_Main.cds_EntreeIn.First;
            while not(Dm_Main.cds_EntreeIn.Eof) do
            begin
              LParam := Dm_Main.cds_EntreeIn.FieldByName('NumParam').AsInteger;
              sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;

              if Dm_Main.cds_Param.Locate('Num', LParam, []) then
              begin
                Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
                  1: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValString').Value;
                  2: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValInteger').Value;
                  3: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValFloat').Value;
                  4: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValDateTime').Value;
                end;
              end;
              Dm_Main.cds_EntreeIn.Next;
            end;

            Dm_Main.Transaction.StartTransaction;
            QryTmp.ExecSQL;
            Dm_Main.Transaction.Commit;

            // paramètre de sortie
            NomSectionDetailProc := Nomsection+'_'+sProcSection+'_OUT';
            // charge les paramètres d'entrée
            ChargeParamOutFromStkProc(NomSectionDetailProc);

            // exporte les resultat
            Dm_Main.cds_SortieOut.First;
            while not(Dm_Main.cds_SortieOut.Eof) do
            begin
              LParam := Dm_Main.cds_SortieOut.FieldByName('NumParam').AsInteger;
              sChampParam := Dm_Main.cds_SortieOut.FieldByName('NomChamp').AsString;
              if Dm_Main.cds_Param.Locate('Num', LParam, []) then
              begin
                Dm_Main.cds_Param.Edit;
                Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
                  1: Dm_Main.cds_Param.FieldByName('ValString').Value := QryTmp.FieldByName(sChampParam).Value;
                  2: Dm_Main.cds_Param.FieldByName('ValInteger').Value := QryTmp.FieldByName(sChampParam).Value;
                  3: Dm_Main.cds_Param.FieldByName('ValFloat').Value := QryTmp.FieldByName(sChampParam).Value;
                  4: Dm_Main.cds_Param.FieldByName('ValDateTime').Value := QryTmp.FieldByName(sChampParam).Value;
                end;
                Dm_Main.cds_Param.Post;
              end;

              Dm_Main.cds_SortieOut.Next;
            end;

          finally
            Frm_Progress.SetEndBar;
            QryTmp.Close;
            FreeAndNil(QryTmp);
          end;
        end;
      end;  // if RecupParam

      result := true;

    except
      on E: Exception do
      begin
        if (Dm_Main.Transaction.InTransaction) then
          Dm_Main.Transaction.Rollback;
        sTmp := 'Pb avec le fichier: '+sFicProc;
        if sProcName<>'' then
          sTmp := sTmp+' ; Proc Csv: '+sFicCsv;

        E.Message := sTmp+' : '+E.Message;
        raise;
      end;
    end;

  finally
    if (StreamDst<>nil) then
      FreeAndNil(StreamDst);
    FreeAndNil(TmpListe);
  end;
end;

// exportation
function TFrm_Main.Exportation: boolean;
var
  NomSection: string;
  sProcSection: string;
  NomSectionDetailProc: string;
  Book: TBookMark;
  Nb: integer;
  sRep: string;
  sTmp: string;
  sFicProc: string;
  sFicCsv: string;
  sFile: string;
  sFirstLigne: string;
  sProcName: string;
  TmpListe: TStringList;
  QryTmp: TIBOQuery;
  sLigne: string;
  sChamp: string;
  i: integer;
  Cnt: integer;
  PrCen: integer;
  LParam: integer;
  sChampParam: string;
  sLstParam: string;

  tTot: TDateTime;
  tProc: TDateTime;
  tpListeDelai: TStringList;
  StreamDst: TFileStream;
begin
  result := false;

  NomSection := GetSectionNomExport(ChoixNomExport);

  sRep := Ed_CheminExport.Text;
  Book := Dm_Main.cds_Proc.GetBookmark;
  Dm_Main.cds_Proc.DisableControls;
  TmpListe := TStringList.Create;
  StreamDst := nil;
  tpListeDelai := TStringList.Create;
  tTot := Now;
  try
    try
      // passe les script
      Dm_Main.cds_Proc.First;
      while not(Dm_Main.cds_Proc.Eof) do
      begin
        if Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean then
        begin
          sFicProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
          sProcSection := Copy(sFicProc, 1, Length(sFicProc)-Length(ExtractFileExt(sFicProc)));

          // paramètre d'endrée
          NomSectionDetailProc := Nomsection+'_'+sProcSection+'_IN';
          // charge les paramètres d'entrée
          ChargeParamInFromStkProc(NomSectionDetailProc, Dm_Main.cds_Proc.FieldByName('vIn').AsInteger);

          sFicCsv := Dm_Main.cds_Proc.FieldByName('FicCsv').AsString;
          Dm_Main.cds_EntreeIn.First;
          while not Dm_Main.cds_EntreeIn.Eof do
          begin
            if AnsiPos('%' + Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString + '%', sFicCsv) <> 0 then
            begin
              LParam := Dm_Main.cds_EntreeIn.FieldByName('NumParam').AsInteger;
              sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;

              if Dm_Main.cds_Param.Locate('Num', LParam, []) then
              begin
                Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
                  1:
                  begin
                    if Dm_Main.cds_Param.FieldByName('ValString').Value <> Null then
                      sTmp := Dm_Main.cds_Param.FieldByName('ValString').Value
                    else
                      sTmp := '';
                  end;
                end;
              end;
              sFicCsv := StringReplace(sFicCsv, '%' + Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString + '%', sTmp,[rfReplaceAll, rfIgnoreCase]);
              Dm_Main.cds_EntreeIn.Last;
            end;
            Dm_Main.cds_EntreeIn.Next;
          end;

          Frm_Progress.DoEtat(sFicCsv);
          sProcName := '';
          if sFicCsv<>'' then
          begin
            sFile := RetrouveExpandFichier(sFicProc);
            TmpListe.Clear;
            TmpListe.LoadFromFile(sFile);

            if TmpListe.Count>0 then
            begin
              sFirstLigne := UpperCase(TmpListe[0]);
              //Retrouve le nom de la procedure stockée
              if Pos('CREATE', sFirstLigne)=1 then
              begin
                sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
                if Pos('PROCEDURE', sFirstLigne)=1 then
                begin
                  sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
                  if Pos(' ', sFirstLigne)>0 then
                    sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
                  if Pos('(', sFirstLigne)>0 then
                    sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
                  if Pos(';', sFirstLigne)>0 then
                    sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
                  sProcName := sFirstLigne;
                end;
              end;
            end;

            //export
            if FileExists(sRep+sFicCsv) then
              DeleteFile(sRep+sFicCsv);

            StreamDst := TFileStream.Create(sRep+sFicCsv, fmCreate);
            try
              TmpListe.Clear;
              if sProcName<>'' then
              begin
                tProc := Now;
                QryTmp := TIBOQuery.Create(Self);
                try
                  QryTmp.IB_Connection := Dm_Main.DataBase;
                  QryTmp.IB_Transaction := Dm_Main.Transaction;
                  QryTmp.ParamCheck := false;
                  QryTmp.SQL.Clear;
                  QryTmp.SQL.Add('select * from '+sProcName);
                  // paramètres
                  sLstParam := '';
                  Dm_Main.cds_EntreeIn.First;
                  while not(Dm_Main.cds_EntreeIn.Eof) do
                  begin
                    sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;
                    if (sLstParam<>'') then
                      sLstParam := sLstParam+', ';
                    sLstParam := sLstParam +':'+sChampParam;
                    Dm_Main.cds_EntreeIn.Next;
                  end;
                  if sLstParam<>'' then
                    QryTmp.SQL.Add('('+sLstParam+')');
                  QryTmp.ParamCheck := true;
                  //affectation des paramètres
                  Dm_Main.cds_EntreeIn.First;
                  while not(Dm_Main.cds_EntreeIn.Eof) do
                  begin
                    LParam := Dm_Main.cds_EntreeIn.FieldByName('NumParam').AsInteger;
                    sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;

                    if Dm_Main.cds_Param.Locate('Num', LParam, []) then
                    begin
                      Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
                        1: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValString').Value;
                        2: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValInteger').Value;
                        3: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValFloat').Value;
                        4: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValDateTime').Value;
                      end;
                    end;
                    Dm_Main.cds_EntreeIn.Next;
                  end;

                  QryTmp.Open;

                  // Calcul progression
                  Nb := QryTmp.RecordCount;
                  PrCen :=  Round((Nb/100)*5);
                  if (PrCen<=0) then
                    PrCen := 1;
                  Cnt := 0;
                  Frm_Progress.SetInitBar(Nb);

                  // ligne d'entete
                  if Chk_OkEntete.Checked then
                  begin
                    sLigne := '';
                    for i := 1 to QryTmp.Fields.Count do
                    begin
                      sChamp := StringReplace(QryTmp.Fields[i-1].FieldName, ';', '-', [rfReplaceAll]);
                      sChamp := StringReplace(sChamp, #13#10, '\n', [rfReplaceAll, rfIgnoreCase]);
                      sChamp := StringReplace(sChamp, #10, '\l', [rfReplaceAll, rfIgnoreCase]);
                      if Chk_Guillemet.Checked then
                        sChamp := '"'+sChamp+'"';
                      if sLigne<>'' then
                        sLigne := sLigne+';';

                      sLigne := sLigne+sChamp;
                    end;
                    if Chk_PointVirgule.Checked then
                      sLigne := sLigne+';';
                    // TmpListe.Add(sLigne);
                    WriteStreamString(StreamDst, sLigne);
                  end;

                  // export
                  QryTmp.First;
                  while not(QryTmp.Eof) do
                  begin

                    if ((cnt mod PrCen)=0) then
                    begin
                      Frm_Progress.DoProgress(cnt);
                      Application.ProcessMessages;
                    end;

                    sLigne := '';
                    for i := 1 to QryTmp.Fields.Count do
                    begin
                      sChamp := QryTmp.Fields[i-1].AsString;
                      sChamp := StringReplace(sChamp, ';', '-', [rfReplaceAll, rfIgnoreCase]);
                      sChamp := StringReplace(sChamp, #13#10, '\n', [rfReplaceAll, rfIgnoreCase]);
                      sChamp := StringReplace(sChamp, #10, '\l', [rfReplaceAll, rfIgnoreCase]);
                      if Chk_Guillemet.Checked then
                        sChamp := '"'+sChamp+'"';
                      if sLigne<>'' then
                        sLigne := sLigne+';';

                      sLigne := sLigne+sChamp;
                    end;
                    if Chk_PointVirgule.Checked then
                      sLigne := sLigne+';';

                    // TmpListe.Add(sLigne);
                    WriteStreamString(StreamDst, sLigne);

                    inc(cnt);

                    QryTmp.Next;
                  end;

                  // TmpListe.SaveToFile(sRep+sFicCsv);

                finally
                  Frm_Progress.SetEndBar;
                  QryTmp.Close;
                  FreeAndNil(QryTmp);
                end;
                tpListeDelai.Add('  '+sProcName+': '+formatdatetime('hh:nn:ss:zzz', now-tProc));
              end;
            finally
              StreamDst.Free;
              StreamDst := nil;
            end;

          end // if sFicCsv<>'' then
          else if Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean then
          begin
            sFile := RetrouveExpandFichier(sFicProc);
            TmpListe.Clear;
            TmpListe.LoadFromFile(sFile);

            if TmpListe.Count>0 then
            begin
              sFirstLigne := UpperCase(TmpListe[0]);
              //Retrouve le nom de la procedure stockée
              if Pos('CREATE', sFirstLigne)=1 then
              begin
                sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
                if Pos('PROCEDURE', sFirstLigne)=1 then
                begin
                  sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
                  if Pos(' ', sFirstLigne)>0 then
                    sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
                  if Pos('(', sFirstLigne)>0 then
                    sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
                  if Pos(';', sFirstLigne)>0 then
                    sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
                  sProcName := sFirstLigne;
                end;
              end;
            end;

            //export
            TmpListe.Clear;
            if sProcName<>'' then
            begin
              tProc := now;
              QryTmp := TIBOQuery.Create(Self);
              try
                QryTmp.IB_Connection := Dm_Main.DataBase;
                QryTmp.IB_Transaction := Dm_Main.Transaction;
                QryTmp.ParamCheck := false;
                QryTmp.SQL.Clear;
                // paramètre de sortie
                NomSectionDetailProc := Nomsection+'_'+sProcSection+'_OUT';
                // charge les paramètres d'entrée
                ChargeParamOutFromStkProc(NomSectionDetailProc);

                // exporte les resultat
                Dm_Main.cds_SortieOut.First;
                if not(Dm_Main.cds_SortieOut.Eof) then
                  QryTmp.SQL.Add('select * from '+sProcName)
                else
                  QryTmp.SQL.Add('execute procedure '+sProcName);
                // paramètres
                sLstParam := '';
                Dm_Main.cds_EntreeIn.First;
                while not(Dm_Main.cds_EntreeIn.Eof) do
                begin
                  sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;
                  if (sLstParam<>'') then
                    sLstParam := sLstParam+', ';
                  sLstParam := sLstParam +':'+sChampParam;
                  Dm_Main.cds_EntreeIn.Next;
                end;
                if sLstParam<>'' then
                  QryTmp.SQL.Add('('+sLstParam+')');
                QryTmp.ParamCheck := true;
                // affectation des paramètres
                Dm_Main.cds_EntreeIn.First;
                while not(Dm_Main.cds_EntreeIn.Eof) do
                begin
                  LParam := Dm_Main.cds_EntreeIn.FieldByName('NumParam').AsInteger;
                  sChampParam := Dm_Main.cds_EntreeIn.FieldByName('NomParam').AsString;

                  if Dm_Main.cds_Param.Locate('Num', LParam, []) then
                  begin
                    Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
                      1: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValString').Value;
                      2: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValInteger').Value;
                      3: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValFloat').Value;
                      4: QryTmp.ParamByName(AnsiString(sChampParam)).Value := Dm_Main.cds_Param.FieldByName('ValDateTime').Value;
                    end;
                  end;
                  Dm_Main.cds_EntreeIn.Next;
                end;

                Dm_Main.Transaction.StartTransaction;
                QryTmp.ExecSQL;
                Dm_Main.Transaction.Commit;

                // paramètre de sortie
                NomSectionDetailProc := Nomsection+'_'+sProcSection+'_OUT';
                // charge les paramètres d'entrée
                ChargeParamOutFromStkProc(NomSectionDetailProc);

                // exporte les resultat
                Dm_Main.cds_SortieOut.First;
                while not(Dm_Main.cds_SortieOut.Eof) do
                begin
                  LParam := Dm_Main.cds_SortieOut.FieldByName('NumParam').AsInteger;
                  sChampParam := Dm_Main.cds_SortieOut.FieldByName('NomChamp').AsString;
                  if Dm_Main.cds_Param.Locate('Num', LParam, []) then
                  begin
                    Dm_Main.cds_Param.Edit;
                    Case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
                      1: Dm_Main.cds_Param.FieldByName('ValString').Value := QryTmp.FieldByName(sChampParam).Value;
                      2: Dm_Main.cds_Param.FieldByName('ValInteger').Value := QryTmp.FieldByName(sChampParam).Value;
                      3: Dm_Main.cds_Param.FieldByName('ValFloat').Value := QryTmp.FieldByName(sChampParam).Value;
                      4: Dm_Main.cds_Param.FieldByName('ValDateTime').Value := QryTmp.FieldByName(sChampParam).Value;
                    end;
                    Dm_Main.cds_Param.Post;
                  end;

                  Dm_Main.cds_SortieOut.Next;
                end;

              finally
                Frm_Progress.SetEndBar;
                QryTmp.Close;
                FreeAndNil(QryTmp);
              end;
              tpListeDelai.Add('  '+sProcName+': '+formatdatetime('hh:nn:ss:zzz', now-tProc));
            end;
          end;  // if RecupParam

        end; //  if actif

        Dm_Main.cds_Proc.Next;
      end;

      result := true;

      tpListeDelai.Add('');
      tpListeDelai.Add('');
      tpListeDelai.Add('Temps total: '+formatdatetime('hh:nn:ss:zzz', now-tTot));

    except
      on E: Exception do
      begin
        if (Dm_Main.Transaction.InTransaction) then
          Dm_Main.Transaction.Rollback;
        sTmp := 'Pb avec le fichier: '+sFicProc;
        if sProcName<>'' then
          sTmp := sTmp+' ; Proc Csv: '+sFicCsv;

        E.Message := sTmp+' : '+E.Message;
        raise;
      end;
    end;

  finally
    try
      tpListeDelai.SaveToFile(Dm_Main.ReperBase+'Delai_Export_'+FormatDateTime('yyyy-mm-dd hhnnss', now)+'.txt');
    except
    end;
    FreeAndNil(tpListeDelai);
    Dm_Main.cds_Proc.GotoBookmark(Book);
    Dm_Main.cds_Proc.FreeBookmark(Book);
    Dm_Main.cds_Proc.EnableControls;
    FreeAndNil(TmpListe);
    if StreamDst<>nil then
      freeAndNil(StreamDst);
  end;
end;

procedure TFrm_Main.Bt_ParamSortieClick(Sender: TObject);
var
  NomSection: string;
  sProcSection: string;
  NomSectionDetailProc: string;
  vOut: integer;
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  NomSection := GetSectionNomExport(ChoixNomExport);
  if NomSection='' then
    exit;

  sProcSection := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
  sProcSection := Copy(sProcSection, 1, Length(sProcSection)-Length(ExtractFileExt(sProcSection)));
  NomSectionDetailProc := Nomsection+'_'+sProcSection+'_OUT';

  // charge les paramètres de sorties
  ChargeParamOutFromStkProc(NomSectionDetailProc);

  Frm_ParamSortie := TFrm_ParamSortie.Create(Self);
  try
    if Frm_ParamSortie.ShowModal=mrok then
    begin
      Application.ProcessMessages;
      SauveParamOutFromStkProc(NomSectionDetailProc, vOut);
      Dm_Main.cds_Proc.Edit;
      Dm_Main.cds_Proc.FieldByName('vOut').AsInteger := vOut;
      Dm_Main.cds_Proc.Post;
      SauveNomExport;
    end;
  finally
    FreeAndNil(Frm_ParamSortie);
  end;

end;

procedure TFrm_Main.Bt_RafraichirClick(Sender: TObject);
var
  sProcName: string;
  sFicProc: string;
  sParam: string;
  NbPar: integer;
  sProcSection: string;
  Book: TBookMark;
  TmpListe: TStringList;
  Nb: integer;
  i: integer;
  sFile: string;
  sTmp: string;
  sFirstLigne: string;
  NomSection: string;
  NomSectionDetailProc: string;
  vIn, vInFait: integer;
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  NomSection := GetSectionNomExport(ChoixNomExport);
  if NomSection='' then
    exit;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  sProcName := '';
  sFicProc := '';
  Book := Dm_Main.cds_Proc.GetBookmark;
  Dm_Main.cds_Proc.DisableControls;
  TmpListe := TStringList.Create;
  try
    try
      // test les fichiers
      Dm_Main.cds_Proc.First;
      while not(Dm_Main.cds_Proc.Eof) do
      begin
        // nombre de fois où le fichier est trouvé dans la liste des répertoires
        // doit être = à 1
        Nb := RetrouveNbFichier(Dm_Main.cds_Proc.FieldByName('FicProc').AsString);
        if (Nb=0) then
          raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                                 ' non trouvé dans la liste des répertoires');
        if (Nb>1) then
          raise Exception.Create('Fichier '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString+
                                 ' trouvé plusieurs fois dans la liste des répertoires');

        Dm_Main.cds_Proc.Next;
      end;

      // recherche les proc stockée
      Dm_Main.cds_Proc.First;
      while not(Dm_Main.cds_Proc.Eof) do
      begin
        sFicProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
        sFile := RetrouveExpandFichier(sFicProc);
        TmpListe.Clear;
        TmpListe.LoadFromFile(sFile);

        sProcSection := sFicProc;
        sProcSection := Copy(sFicProc, 1, Length(sFicProc)-Length(ExtractFileExt(sFicProc)));
        NomSectionDetailProc := Nomsection+'_'+sProcSection+'_IN';

        if TmpListe.Count>0 then
        begin
          // charge les paramètres d'entrée
          ChargeParamInFromStkProc(NomSectionDetailProc, Dm_Main.cds_Proc.FieldByName('vIn').AsInteger);

          sFirstLigne := UpperCase(TmpListe[0]);
          //Retrouve le nom de la procedure stockée
          sProcName := '';
          if Pos('CREATE', sFirstLigne)=1 then
          begin
            sFirstLigne := Trim(Copy(sFirstLigne, 7, Length(sFirstLigne)));
            if Pos('PROCEDURE', sFirstLigne)=1 then
            begin
              sFirstLigne := Trim(Copy(sFirstLigne, 10, Length(sFirstLigne)));
              if Pos(' ', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(' ',sFirstLigne)-1));
              if Pos('(', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos('(',sFirstLigne)-1));
              if Pos(';', sFirstLigne)>0 then
                sFirstLigne := Trim(Copy(sFirstLigne, 1, Pos(';',sFirstLigne)-1));
              sProcName := sFirstLigne;
            end;
          end;
          if sProcName<>'' then
          begin
            // lignes des paramètres entrants
            sParam := UpperCase(TmpListe.Text);
            sParam := Trim(Copy(sParam, Pos(sProcName, sParam)+Length(sProcName), Length(sParam)));
            if Pos('RETURNS', sParam)>0 then
              sParam := Copy(sParam, 1, Pos('RETURNS', sParam)-1);
            if Pos('BEGIN', sParam)>0 then
            begin
              sParam := Copy(sParam, 1, Pos('BEGIN', sParam)-1);
              sParam := StringReplace(sParam, #13#10, ' ', [rfReplaceAll, rfIgnoreCase]);
              while Pos('DECLARE VARIABLE', sParam)>0 do
                sParam := Copy(sParam, 1, Pos('DECLARE VARIABLE', sParam)-1);
              sParam := Trim(sParam);
              if Copy(sParam, Length(sParam)-2, 2)='AS' then
                sParam := Copy(sParam, 1, Length(sParam)-2);
            end;

          //  if Pos('AS', sParam)>0 then
         //     sParam := Copy(sParam, 1, Pos('AS', sParam)-1);
         //   sParam := StringReplace(sParam, #13#10, '', [rfReplaceAll, rfIgnoreCase]);
            sParam := Trim(sParam);
            if (Pos('(', sParam)>0) and (Pos(')', sParam)>0) then
            begin
              sParam := Copy(sParam, Pos('(', sParam)+1, Length(sParam));
              NbPar := 1;
              i := 1;
              while (NbPar>0) and (i<=Length(sParam)) do
              begin
                if (sParam[i]='(') then
                  Inc(NbPar);
                if (sParam[i]=')') then
                begin
                  Dec(NbPar);
                  if NbPar=0 then
                    sParam := Copy(sParam, 1, i-1);
                end;
                inc(i);
              end;
              sParam := Trim(sParam);
              sParam := StringReplace(sParam, #13#10, '', [rfReplaceAll, rfIgnoreCase]);
              sParam := StringReplace(sParam, #10, '', [rfReplaceAll, rfIgnoreCase]);
              SetParamInFromStkProc(sParam);
            end
            else
              SetParamInFromStkProc('');
          end
          else
            SetParamInFromStkProc('');

          // sauve les paramètre d'entrée
          SauveParamInFromStkProc(NomSectionDetailProc, vIn, vInFait);
          Dm_Main.cds_Proc.Edit;
          Dm_Main.cds_Proc.FieldByName('vIn').AsInteger := vIn;
          Dm_Main.cds_Proc.FieldByName('vInFait').AsInteger := vInFait;
          Dm_Main.cds_Proc.Post;

        end;


        Dm_Main.cds_Proc.Next;
      end;

    except
      on E: Exception do
      begin
        sTmp := 'Pb avec le fichier: '+sFicProc;
        if sProcName<>'' then
          sTmp := sTmp+' ; Proc Stk: '+sProcName;

        E.Message := sTmp+' : '+E.Message;
        raise;
      end;
    end;

  finally
    Dm_Main.cds_Proc.GotoBookmark(Book);
    Dm_Main.cds_Proc.FreeBookmark(Book);
    Dm_Main.cds_Proc.EnableControls;
    FreeAndNil(TmpListe);
    SauveNomExport;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

end;

procedure TFrm_Main.AjouterUnRepertoire(AReper: string);
var
  sTmp: string;
  LPos: integer;
  i: integer;
begin
  if AReper='' then
    exit;

  sTmp := AReper;
  if (sTmp[Length(sTmp)]<>'\') then
    sTmp := sTmp+'\';
  LPos := -1;
  i := 1;
  while (Lpos=-1) and (i<=Dm_Main.ListeNomReper.Count) do
  begin
    if UpperCase(sTmp)=UpperCase(Dm_Main.ListeNomReper[i-1]) then
      LPos := i-1;
    inc(i);
  end;
  if LPos>=0 then
    exit;

  Dm_Main.ListeNomReper.Add(sTmp);
  Dm_Main.ListeNomReper.Sort;
  Lst_Reper.Clear;
  Lst_Reper.Items.AddStrings(Dm_Main.ListeNomReper);
  Lst_Reper.ItemIndex := Lst_Reper.Items.IndexOf(sTmp);
end;

// recupère l'IDStr du nom de l'export (ex: EXPORT1)
function TFrm_Main.GetSectionNomExport(ANom: string): string;
var
  FicIni: TIniFile;
  LstExport: TStringList;
  i: integer;
  sTmp: string;
  sTmp2: string;
begin
  Result := '';
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    LstExport := TStringList.Create;
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      if FicIni.SectionExists('ListeNomExport') then
      begin
        FicIni.ReadSection('ListeNomExport', LstExport);
        i := 1;
        while (Result='') and (i<=LstExport.Count) do
        begin
          sTmp := UpperCase(LstExport[i-1]);
          if Pos('EXPORT', sTmp)=1 then
          begin
            sTmp2 := FicIni.ReadString('ListeNomExport', sTmp, '');
            if UpperCase(sTmp2)=UpperCase(ANom) then
              Result := sTmp;
          end;
          inc(i);
        end;
      end;
    finally
      FreeAndNil(FicIni);
      FreeAndNil(LstExport);
    end;
  end;
end;

// recupère la liste des répertoires pour un nom d'export
procedure TFrm_Main.GetRepertoire(ASection: string; AListe: TStrings);
var
  FicIni: TIniFile;
  LstExport: TStringList;
  i: integer;
  sTmp: string;
  sTmp2: string;
begin
  AListe.Clear;
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    LstExport := TStringList.Create;
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      if FicIni.SectionExists(ASection) then
      begin
        FicIni.ReadSection(ASection, LstExport);
        for i:=1 to LstExport.Count do
        begin
          sTmp := UpperCase(LstExport[i-1]);
          if Pos('REPER', sTmp)=1 then
          begin
            sTmp2 := FicIni.ReadString(ASection, sTmp, '');
            AListe.Add(sTmp2);
          end;
        end;
      end;
    finally
      FreeAndNil(FicIni);
      FreeAndNil(LstExport);
    end;
  end;
end;

// recupère la liste des sections des nom des paramètre
procedure TFrm_Main.GetLstParam(ASection: string; AListe: TStrings);
var
  FicIni: TIniFile;
  LstExport: TStringList;
  i: integer;
  sTmp: string;
  sTmp2: string;
begin
  AListe.Clear;
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    LstExport := TStringList.Create;
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      if FicIni.SectionExists(ASection) then
      begin
        FicIni.ReadSection(ASection, LstExport);
        for i:=1 to LstExport.Count do
        begin
          sTmp := UpperCase(LstExport[i-1]);
          if Pos('PARAM', sTmp)=1 then
          begin
            sTmp2 := FicIni.ReadString(ASection, sTmp, '');
            AListe.Add(sTmp2);
          end;
        end;
      end;
    finally
      FreeAndNil(FicIni);
      FreeAndNil(LstExport);
    end;
  end;
end;

// récupère le détail d'un paramètre
procedure TFrm_Main.GetDetailParam(ASection: string; var ANum: integer;
    var ANom: string; var ATipe: integer; Var ValString: string;
    var ValInteger, ValFloat, ValDateTime: Variant);
var
  FicIni: TIniFile;
  bIsNull: boolean;
begin
  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    ANum  := FicIni.ReadInteger(ASection, 'Numero', 0);
    ANom  := FicIni.ReadString(ASection, 'Nom', '');
    ATipe := FicIni.ReadInteger(ASection, 'Tipe', 1);
    ValString  := FicIni.ReadString(ASection, 'ValString', '');
    bIsNull := FicIni.ReadBool(ASection, 'IntegerIsNull', true);
    if not(bIsNull) then
      ValInteger := FicIni.ReadInteger(ASection, 'ValInteger', 0)
    else
      ValInteger := null;
    bIsNull := FicIni.ReadBool(ASection, 'FloatIsNull', true);
    if not(bIsNull) then
      ValFloat := FicIni.ReadFloat(ASection, 'ValFloat', 0.0)
    else
      ValFloat := null;
    bIsNull := FicIni.ReadBool(ASection, 'DateTimeIsNull', true);
    if not(bIsNull) then
      ValDateTime := FicIni.ReadDateTime(ASection, 'ValDateTime', 0)
    else
      ValDateTime := null;
  finally
    FreeAndNil(FicIni);
  end;
end;

// recupère la liste des fichiers de proc stockées pour un nom d'export
procedure TFrm_Main.GetLstProc(ASection: string; AListe: TStrings);
var
  FicIni: TIniFile;
  LstExport: TStringList;
  i: integer;
  sTmp: string;
  sTmp2: string;
begin
  AListe.Clear;
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    LstExport := TStringList.Create;
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      if FicIni.SectionExists(ASection) then
      begin
        FicIni.ReadSection(ASection, LstExport);
        for i:=1 to LstExport.Count do
        begin
          sTmp := UpperCase(LstExport[i-1]);
          if Pos('PROC', sTmp)=1 then
          begin
            sTmp2 := FicIni.ReadString(ASection, sTmp, '');
            AListe.Add(sTmp2);
          end;
        end;
      end;
    finally
      FreeAndNil(FicIni);
      FreeAndNil(LstExport);
    end;
  end;
end;

// recupere le detail d'une proc
procedure TFrm_Main.GetDetailProc(ASection: string; var AOrdre: integer; var AFicProc, AFicCsv: string;
    var AOkGrantGinkoia, AOkGrantRepl, AOkDropAfterExport, AvIn, AvOut: integer; var ARecupParam, AStkActif: boolean);
var
  FicIni: TIniFile;
begin
  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    AOrdre             := FicIni.ReadInteger(ASection, 'Ordre', 0);
    AFicProc           := FicIni.ReadString(ASection, 'FichierProc', '');
    AFicCsv            := FicIni.ReadString(ASection, 'FichierCsv', '');
    AOkGrantGinkoia    := FicIni.ReadInteger(ASection, 'GrantGinkoia', 0);
    AOkGrantRepl       := FicIni.ReadInteger(ASection, 'GrantRepl', 0);
    AOkDropAfterExport := FicIni.ReadInteger(ASection, 'DropAfterExport', 0);
    AvIn               := FicIni.ReadInteger(ASection, 'ParamIn', 0);
    AvOut              := FicIni.ReadInteger(ASection, 'ParamOut', 0);
    ARecupParam        := FicIni.ReadBool(ASection, 'RecupParam', false);
    AStkActif          := FicIni.ReadBool(ASection, 'Actif', true);
  finally
    FreeAndNil(FicIni);
  end;
end;

// recupère le num de paramètre associé aux entrées de la proc stockée
function TFrm_Main.GetNumParamFromStkProc(ASection: string; AIdent: string): integer;
var
  FicIni: TIniFile;
begin
  Result := 0;
  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    Result := FicIni.ReadInteger(ASection, AIdent, Result);
  finally
    FreeAndNil(FicIni);
  end;
end;

// charge parametre d'entrée d'une proc stockée
procedure TFrm_Main.ChargeParamInFromStkProc(ASection: string; ANbre: integer);
var
  i: integer;
  FicIni: TIniFile;
  sNom: string;
  iNumParam: integer;
begin
  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    with Dm_Main do
    begin
      cds_EntreeIn.EmptyDataSet;
      for i:= 1 to ANbre do
      begin
        sNom := FicIni.ReadString(ASection, 'Nom'+inttostr(i), '');
        iNumParam := FicIni.ReadInteger(ASection, 'NumParam'+inttostr(i), 0);
        cds_EntreeIn.Append;
        cds_EntreeIn.FieldByName('NomParam').AsString := sNom;
        cds_EntreeIn.FieldByName('NumParam').AsInteger := iNumParam;
        cds_EntreeIn.Post;
      end;
    end;
  finally
    FreeAndNil(FicIni);
  end;
end;

// sauvegarde parametre d'entrée d'une proc stockée
procedure TFrm_Main.SauveParamInFromStkProc(ASection: string; Var ivIn, ivInFait: integer);
var
  i: integer;
  FicIni: TIniFile;
begin
  ivIn := 0;
  ivInFait := 0;
  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    FicIni.EraseSection(ASection);

    with Dm_Main do
    begin
      i := 1;
      cds_EntreeIn.First;
      while not(cds_EntreeIn.Eof) do
      begin
        FicIni.WriteString(ASection, 'Nom'+inttostr(i), cds_EntreeIn.FieldByName('NomParam').AsString);
        FicIni.WriteInteger(ASection, 'NumParam'+inttostr(i), cds_EntreeIn.FieldByName('NumParam').AsInteger);
        if cds_EntreeIn.FieldByName('NumParam').AsInteger>0 then
          Inc(ivInFait);
        inc(i);
        inc(ivIn);
        cds_EntreeIn.Next;
      end;
    end;

  finally
    FreeAndNil(FicIni);
  end;
end;

// enregistre tous les paramètres trouvé
procedure TFrm_Main.SetParamInFromStkProc(AParams: string);
var
  LstParam: TStringList;
  LstSuppr: TStringList;
  i: integer;
  sLigne: string;
  sTmp: string;
begin
  with Dm_Main do
  begin
    sLigne := Trim(UpperCase(AParams));
    LstParam := TStringList.Create;
    LstSuppr := TStringList.Create;
    try
      // chaque paramètre est séparé par des virgules
      while Pos(',', sLigne)>0 do
      begin
        sTmp := Trim(Copy(sLigne, 1, Pos(',', sLigne)-1));
        sLigne := Copy(sLigne, Pos(',', sLigne)+1, Length(sLigne));
        // retrait de la déclaration
        if Pos(' ', sTmp)>0 then
          sTmp := Copy(sTmp, 1, Pos(' ', sTmp)-1);
        LstParam.Add(sTmp);
      end;
      sLigne := Trim(sLigne);
      if sLigne<>'' then
      begin
        // retrait de la déclaration
        if Pos(' ', sLigne)>0 then
          sLigne := Copy(sLigne, 1, Pos(' ', sLigne)-1);
        LstParam.Add(sLigne);
      end;

      // ajoute les paramètres d'entrées s'il n'existe pas
      for i := 1 to LstParam.Count do
      begin
        if not(cds_EntreeIn.Locate('NomParam', LstParam[i-1], [])) then
        begin
          cds_EntreeIn.Append;
          cds_EntreeIn.FieldByName('NomParam').AsString := LstParam[i-1];
          cds_EntreeIn.FieldByName('NumParam').AsInteger := 0;
          cds_EntreeIn.Post;
        end;
      end;
      // supprime les paramètres qui n'existe pas
      cds_EntreeIn.first;
      while not(cds_EntreeIn.Eof) do
      begin
        if LstParam.IndexOf(cds_EntreeIn.FieldByName('NomParam').AsString)<0 then
          LstSuppr.Add(cds_EntreeIn.FieldByName('NomParam').AsString);
        cds_EntreeIn.Next;
      end;
      for i := 1 to LstSuppr.Count do
      begin
        if (cds_EntreeIn.Locate('NomParam', LstSuppr[i-1], [])) then
          cds_EntreeIn.Delete;
      end;
    finally
      FreeAndNil(LstParam);
      FreeAndNil(LstSuppr);
    end;
  end;
end;

// charge parametre de sortie d'une proc stockée
procedure TFrm_Main.ChargeParamOutFromStkProc(ASection: string);
var
  i: integer;
  FicIni: TIniFile;
  sNom: string;
  iNumParam: integer;
  iNbre: integer;
begin
  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    with Dm_Main do
    begin
      cds_SortieOut.EmptyDataSet;
      iNbre := FicIni.ReadInteger(ASection, 'Nombre', 0);
      for i:= 1 to iNbre do
      begin
        sNom := FicIni.ReadString(ASection, 'NomChamp'+inttostr(i), '');
        iNumParam := FicIni.ReadInteger(ASection, 'NumParam'+inttostr(i), 0);
        cds_SortieOut.Append;
        cds_SortieOut.FieldByName('NomChamp').AsString := sNom;
        cds_SortieOut.FieldByName('NumParam').AsInteger := iNumParam;
        cds_SortieOut.Post;
      end;
    end;
  finally
    FreeAndNil(FicIni);
  end;
end;

    // sauvegarde parametre de sortie d'une proc stockée
procedure TFrm_Main.SauveParamOutFromStkProc(ASection: string; Var ivOut: integer);
var
  i: integer;
  FicIni: TIniFile;
begin
  ivOut := 0;
  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    FicIni.EraseSection(ASection);

    with Dm_Main do
    begin
      ivOut := cds_SortieOut.RecordCount;
      FicIni.WriteInteger(ASection, 'Nombre', ivOut);

      i := 1;
      cds_SortieOut.First;
      while not(cds_SortieOut.Eof) do
      begin
        FicIni.WriteString(ASection, 'NomChamp'+inttostr(i), cds_SortieOut.FieldByName('NomChamp').AsString);
        FicIni.WriteInteger(ASection, 'NumParam'+inttostr(i), cds_SortieOut.FieldByName('NumParam').AsInteger);
        inc(i);
        cds_SortieOut.Next;
      end;
    end;

  finally
    FreeAndNil(FicIni);
  end;
end;

// charge tout l'export sélectionné
procedure TFrm_Main.LoadNomExport;
var
  NomSection: string;
  NomSectionGeneral: string;
  NomSectionParametre: string;
  NomSectionDetailParametre: string;
  NomSectionReper: string;
  NomSectionFicProc: string;
  NomSectionDetailProc: string;
  LstParam: TStringList;
  LstProc: TStringList;
  i,j: integer;

  iNumParam: integer;
  sNomParam: string;
  iTipeParam: integer;

  iOrdre: integer;
  sFicProc: string;
  sFicCsv: string;
  iOkGrantGinkoia: integer;
  iOkGrantRepl: integer;
  iOkDropAfterExport: integer;
  ivIn, ivOut: integer;
  ivInFait: integer;
  bStkActif: boolean;
  bRecupParam: boolean;
  FicIni: TIniFile;
  ValString: string;
  ValInteger, ValFloat, ValDateTime: Variant;
begin
  Lst_Reper.Clear;
  Dm_Main.ListeNomReper.Clear;
  Dm_Main.cds_Proc.EmptyDataSet;
  Dm_Main.cds_Param.EmptyDataSet;
  Ed_NomBase.Text := '';
  Ed_CheminExport.Text := '';
  Chk_OkEntete.Checked := false;
  Chk_Guillemet.Checked := false;
  Chk_PointVirgule.Checked := true;
  if ChoixNomExport='' then
    exit;

  NomSection := GetSectionNomExport(ChoixNomExport);
  if NomSection='' then
    exit;

  // paramètres internes
  NomSectionGeneral := NomSection+'_General';
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      Ed_NomBase.Text := FicIni.ReadString(NomSectionGeneral, 'NomBase', '');
      Ed_CheminExport.Text := FicIni.ReadString(NomSectionGeneral, 'CheminExport', '');
      Chk_OkEntete.Checked := FicIni.ReadBool(NomSectionGeneral, 'OkEntete', false);
      Chk_Guillemet.Checked := FicIni.ReadBool(NomSectionGeneral, 'Guillemet', false);
      Chk_PointVirgule.Checked := FicIni.ReadBool(NomSectionGeneral, 'PointVirgule', true);
    finally
      FreeAndNil(FicIni);
    end;
  end;

  // liste des répertoires
  NomSectionReper := NomSection+'_Repertoire';
  GetRepertoire(NomSectionReper, Dm_Main.ListeNomReper);
  Dm_Main.ListeNomReper.Sort;
  Lst_Reper.Items.AddStrings(Dm_Main.ListeNomReper);
  if (Lst_Reper.Items.Count>0) then
    Lst_Reper.ItemIndex := 0;

  // recupère la liste des sections des nom des paramètre
  NomSectionParametre := NomSection+'_Parametre';
  LstParam := TStringList.Create;
  try
    GetLstParam(NomSectionParametre, LstParam);
    for i:=1 to LstParam.Count do
    begin
      NomSectionDetailParametre := NomSection+'_'+LstParam[i-1];
      GetDetailParam(NomSectionDetailParametre, iNumParam, sNomParam, iTipeParam,
          ValString, ValInteger, ValFloat, ValDateTime);
      Dm_Main.cds_Param.Append;
      Dm_Main.cds_Param.FieldByName('Num').AsInteger   := iNumParam;
      Dm_Main.cds_Param.FieldByName('Nom').AsString    := sNomParam;
      Dm_Main.cds_Param.FieldByName('Tipe').AsInteger  := iTipeParam;
      Dm_Main.cds_Param.FieldByName('Saisi').AsInteger := 0;
      case iTipeParam of
        1: Dm_Main.cds_Param.FieldByName('ValString').AsString := ValString;
        2: Dm_Main.cds_Param.FieldByName('ValInteger').Value := ValInteger;
        3: Dm_Main.cds_Param.FieldByName('ValFloat').Value := ValFloat;
        4: Dm_Main.cds_Param.FieldByName('ValDateTime').Value := ValDateTime;
      end;
      Dm_Main.cds_Param.Post;
    end;
  finally
    FreeAndNil(LstProc);
  end;

  Dm_Main.cds_Param.IndexFieldNames := '';
  Dm_Main.cds_Param.IndexFieldNames := 'Num';

  // liste des fichiers procedures stockées
  NomSectionFicProc := NomSection+'_FicProc';
  LstProc := TStringList.Create;
  try
    GetLstProc(NomSectionFicProc, LstProc);
    for i := 1 to LstProc.Count do
    begin
      NomSectionDetailProc := NomSection+'_'+LstProc[i-1];
      GetDetailProc(NomSectionDetailProc, iOrdre, sFicProc, sFicCsv, iOkGrantGinkoia,
             iOkGrantRepl, iOkDropAfterExport, ivIn, ivOut, bRecupParam, bStkActif);

      ivInFait := 0;
      for j := 1 to ivIn do
      begin
        if GetNumParamFromStkProc(NomSectionDetailProc+'_IN', 'NumParam'+inttostr(j))>0 then
          Inc(ivInFait);
      end;

      Dm_Main.cds_Proc.Append;
      Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := iOrdre;
      Dm_Main.cds_Proc.FieldByName('FicProc').AsString := sFicProc;
      Dm_Main.cds_Proc.FieldByName('FicCsv').AsString := sFicCsv;
      Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger := iOkGrantGinkoia;
      Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger := iOkGrantRepl;
      Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger := iOkDropAfterExport;
      Dm_Main.cds_Proc.FieldByName('vIn').AsInteger := ivIn;
      Dm_Main.cds_Proc.FieldByName('vOut').AsInteger := ivOut;
      Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean := bRecupParam;
      Dm_Main.cds_Proc.FieldByName('vInFait').AsInteger := ivInFait;
      Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean := bStkActif;

      Dm_Main.cds_Proc.Post;
    end;
  finally
    FreeAndNil(LstProc);
  end;

  Dm_Main.cds_Proc.IndexFieldNames := '';
  Dm_Main.cds_Proc.IndexFieldNames := 'Ordre';
  Dm_Main.cds_Proc.First;
end;

procedure TFrm_Main.EraseExport;
var
  FicIni: TIniFile;
  NomSection: string;
  NomSectionGeneral: string;
  NomSectionReper: string;
  NomSectionParametre: string;
  NomSectionDetailParametre: string;
  LstParam: TStringList;
  NomSectionFicProc: string;
  NomSectionDetailProc: string;
  LstProc: TStringList;
  i: integer;
begin
  NomSection := GetSectionNomExport(ChoixNomExport);
  if NomSection='' then
    exit;

  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    FicIni.DeleteKey('ListeNomExport', NomSection);

    // paramètres internes
    NomSectionGeneral := NomSection+'_General';
    FicIni.EraseSection(NomSectionGeneral);

    // liste des répertoires
    NomSectionReper := NomSection+'_Repertoire';
    FicIni.EraseSection(NomSectionReper);

    // recupère la liste des sections des nom des paramètre
    // efface d'abord
    NomSectionParametre := NomSection+'_Parametre';
    LstParam := TStringList.Create;
    try
      GetLstParam(NomSectionParametre, LstParam);
      for i:=1 to LstParam.Count do
      begin
        NomSectionDetailParametre := NomSection+'_'+LstParam[i-1];
        FicIni.EraseSection(NomSectionDetailParametre);
      end;
      FicIni.EraseSection(NomSectionParametre);
    finally
      FreeAndNil(LstParam);
    end;

    // liste des fichiers procedures stockées
    // efface d'abord
    NomSectionFicProc := NomSection+'_FicProc';
    LstProc := TStringList.Create;
    try
      GetLstProc(NomSectionFicProc, LstProc);
      for i:=1 to LstProc.Count do
      begin
        NomSectionDetailProc := NomSection+'_'+LstProc[i-1];
        FicIni.EraseSection(NomSectionDetailProc);
        FicIni.EraseSection(NomSectionDetailProc+'_IN');
        FicIni.EraseSection(NomSectionDetailProc+'_OUT');

      end;
      FicIni.EraseSection(NomSectionFicProc);
    finally
      FreeAndNil(LstProc);
    end;

  finally
    FreeAndNil(ficIni);
  end;

end;

procedure TFrm_Main.SauveNomExport;
var
  FicIni: TIniFile;
  NomSection: string;
  NomSectionGeneral: string;
  NomSectionReper: string;
  NomSectionParametre: string;
  NomSectionDetailParametre: string;
  LstParam: TStringList;
  sParam: string;
  NomSectionFicProc: string;
  NomSectionDetailProc: string;
  LstProc: TStringList;
  i: integer;
  Book: TBookMark;
  sProc: string;
begin
  NomSection := GetSectionNomExport(ChoixNomExport);
  if NomSection='' then
    exit;

  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    // paramètres internes
    NomSectionGeneral := NomSection+'_General';
    FicIni.WriteString(NomSectionGeneral, 'NomBase', Ed_NomBase.Text);
    FicIni.WriteString(NomSectionGeneral, 'CheminExport', Ed_CheminExport.Text);
    FicIni.WriteBool(NomSectionGeneral, 'OkEntete', Chk_OkEntete.Checked);
    FicIni.WriteBool(NomSectionGeneral, 'Guillemet', Chk_Guillemet.Checked);
    FicIni.WriteBool(NomSectionGeneral, 'PointVirgule', Chk_PointVirgule.Checked);

    // liste des répertoires
    NomSectionReper := NomSection+'_Repertoire';
    FicIni.EraseSection(NomSectionReper);
    for i := 1 to Dm_Main.ListeNomReper.Count do
      FicIni.WriteString(NomSectionReper, 'REPER'+inttostr(i), Dm_Main.ListeNomReper[i-1]);

    // recupère la liste des sections des nom des paramètre
    // efface d'abord
    NomSectionParametre := NomSection+'_Parametre';
    LstParam := TStringList.Create;
    try
      GetLstParam(NomSectionParametre, LstParam);
      for i:=1 to LstParam.Count do
      begin
        NomSectionDetailParametre := NomSection+'_'+LstParam[i-1];
        FicIni.EraseSection(NomSectionDetailParametre);
      end;
      FicIni.EraseSection(NomSectionParametre);
    finally
      FreeAndNil(LstParam);
    end;

    // remet les valeur des paramètre
    if Dm_Main.cds_Param.RecordCount>0 then
    begin
      Book := Dm_Main.cds_Param.GetBookmark;
      Dm_Main.cds_Param.DisableControls;
      try
        i := 1;
        Dm_Main.cds_Param.First;
        while not(Dm_Main.cds_Param.Eof) do
        begin
          sParam := '';
          if i<10 then
            sParam := '0';
          sParam := sParam+inttostr(i);
          sParam := 'Param_'+sParam;

          // enregistrement de la liste
          NomSectionDetailParametre := Nomsection+'_'+sParam;
          FicIni.WriteString(NomSectionParametre, 'PARAM'+inttostr(i), sParam);

          // enregistrement du détail
          FicIni.WriteInteger(NomSectionDetailParametre, 'Numero', Dm_Main.cds_Param.FieldByName('Num').AsInteger);
          FicIni.WriteString(NomSectionDetailParametre, 'Nom', Dm_Main.cds_Param.FieldByName('Nom').AsString);
          FicIni.WriteInteger(NomSectionDetailParametre, 'Tipe', Dm_Main.cds_Param.FieldByName('Tipe').AsInteger);
          case Dm_Main.cds_Param.FieldByName('Tipe').AsInteger of
            1: FicIni.WriteString(NomSectionDetailParametre, 'ValString', Dm_Main.cds_Param.FieldByName('ValString').AsString);
            2:
            begin
              if Dm_Main.cds_Param.FieldByName('ValInteger').IsNull then
                FicIni.WriteBool(NomSectionDetailParametre, 'IntegerIsNull', true)
              else
                FicIni.WriteBool(NomSectionDetailParametre, 'IntegerIsNull', false);
              FicIni.WriteInteger(NomSectionDetailParametre, 'ValInteger', Dm_Main.cds_Param.FieldByName('ValInteger').AsInteger);
            end;
            3:
            begin
              if Dm_Main.cds_Param.FieldByName('ValFloat').IsNull then
                FicIni.WriteBool(NomSectionDetailParametre, 'FloatIsNull', true)
              else
                FicIni.WriteBool(NomSectionDetailParametre, 'FloatIsNull', false);
              FicIni.WriteFloat(NomSectionDetailParametre, 'ValFloat', Dm_Main.cds_Param.FieldByName('ValFloat').AsFloat);
            end;
            4:
            begin
              if Dm_Main.cds_Param.FieldByName('ValDateTime').IsNull then
                FicIni.WriteBool(NomSectionDetailParametre, 'DateTimeIsNull', true)
              else
                FicIni.WriteBool(NomSectionDetailParametre, 'DateTimeIsNull', false);
              FicIni.WriteDateTime(NomSectionDetailParametre, 'ValDateTime', Dm_Main.cds_Param.FieldByName('ValDateTime').AsDateTime);
            end;
          end;
          inc(i);
          Dm_Main.cds_Param.Next;
        end;
      finally
        Dm_Main.cds_Param.GotoBookmark(Book);
        Dm_Main.cds_Param.FreeBookmark(Book);
        Dm_Main.cds_Param.EnableControls;
      end;
    end;

    // liste des fichiers procedures stockées
    // efface d'abord
    NomSectionFicProc := NomSection+'_FicProc';
    LstProc := TStringList.Create;
    try
      GetLstProc(NomSectionFicProc, LstProc);
      for i:=1 to LstProc.Count do
      begin
        NomSectionDetailProc := NomSection+'_'+LstProc[i-1];
        FicIni.EraseSection(NomSectionDetailProc);
      end;
      FicIni.EraseSection(NomSectionFicProc);
    finally
      FreeAndNil(LstProc);
    end;

    // remet les valeur procedures stockées
    if Dm_Main.cds_Proc.RecordCount>0 then
    begin
      Book := Dm_Main.cds_Proc.GetBookmark;
      Dm_Main.cds_Proc.DisableControls;
      try
        i := 1;
        Dm_Main.cds_Proc.First;
        while not(Dm_Main.cds_Proc.Eof) do
        begin
          sProc := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
          sProc := Copy(sProc, 1, Length(sProc)-Length(ExtractFileExt(sProc)));
          // enregistrement de la liste
          NomSectionDetailProc := Nomsection+'_'+sProc;
          FicIni.WriteString(NomSectionFicProc, 'PROC'+inttostr(i), sProc);

          // enregistrement du détail
          FicIni.WriteInteger(NomSectionDetailProc, 'Ordre', Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger);
          FicIni.WriteString(NomSectionDetailProc, 'FichierProc', Dm_Main.cds_Proc.FieldByName('FicProc').AsString);
          FicIni.WriteString(NomSectionDetailProc, 'FichierCsv', Dm_Main.cds_Proc.FieldByName('FicCsv').AsString);
          FicIni.WriteInteger(NomSectionDetailProc, 'GrantGinkoia', Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger);
          FicIni.WriteInteger(NomSectionDetailProc, 'GrantRepl', Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger);
          FicIni.WriteInteger(NomSectionDetailProc, 'DropAfterExport', Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger);
          FicIni.WriteInteger(NomSectionDetailProc, 'ParamIn', Dm_Main.cds_Proc.FieldByName('vIn').AsInteger);
          FicIni.WriteInteger(NomSectionDetailProc, 'ParamOut', Dm_Main.cds_Proc.FieldByName('vOut').AsInteger);
          FicIni.WriteBool(NomSectionDetailProc, 'RecupParam', Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean);
          FicIni.WriteBool(NomSectionDetailProc, 'Actif', Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean);
          inc(i);
          Dm_Main.cds_Proc.Next;
        end;
      finally
        Dm_Main.cds_Proc.GotoBookmark(Book);
        Dm_Main.cds_Proc.FreeBookmark(Book);
        Dm_Main.cds_Proc.EnableControls;
      end;
    end;

  finally
    FreeAndNil(ficIni);
  end;

end;

// recupère le prochain N° des noms d'export
function TFrm_Main.GetNextNumExport: integer;
var
  FicIni: TIniFile;
  LstExport: TStringList;
  i: integer;
  v: integer;
  sTmp: string;
begin
  Result := 0;
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    LstExport := TStringList.Create;
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      if FicIni.SectionExists('ListeNomExport') then
      begin
        FicIni.ReadSection('ListeNomExport', LstExport);
        for i:=1 to LstExport.Count do
        begin
          sTmp := UpperCase(LstExport[i-1]);
          if Pos('EXPORT', sTmp)=1 then
          begin
            sTmp := Copy(sTmp, 7, Length(sTmp));
            v := StrToIntDef(sTmp, 0);
            if v>Result then
              Result := v;
          end;
        end;
      end;
    finally
      FreeAndNil(FicIni);
      FreeAndNil(LstExport);
    end;
  end;
  Inc(Result);
end;

// recupère la liste des noms d'export
procedure TFrm_Main.DoListeExport(AListe: TStrings);
var
  FicIni: TIniFile;
  LstExport: TStringList;
  i: integer;
  sTmp: string;
  sTmp2: string;
begin
  AListe.Clear;
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    LstExport := TStringList.Create;
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      if FicIni.SectionExists('ListeNomExport') then
      begin
        FicIni.ReadSection('ListeNomExport', LstExport);
        for i:=1 to LstExport.Count do
        begin
          sTmp := UpperCase(LstExport[i-1]);
          if Pos('EXPORT', sTmp)=1 then
          begin
            sTmp2 := FicIni.ReadString('ListeNomExport', sTmp, '');
            AListe.Add(sTmp2);
          end;
        end;
      end;
    finally
      FreeAndNil(FicIni);
      FreeAndNil(LstExport);
    end;
  end;
end;

procedure TFrm_Main.Ds_ProcDataChange(Sender: TObject; Field: TField);
begin
  with Dm_Main do
  begin
    DBTxt_FicExport.Enabled := (cds_Proc.Active) and (cds_Proc.RecordCount>0)
          and not(cds_Proc.FieldByName('RecupParam').AsBoolean);
  end;
  Lab_FicExport.Enabled := DBTxt_FicExport.Enabled;

  DoBoutonListeProcOrder;
end;

// etat des boutons
procedure TFrm_Main.DoBoutonNomExport;
begin
  Bt_ModifNom.Enabled := (cmb_ch.ItemIndex>=0);
  Bt_SupprNom.Enabled := (cmb_ch.ItemIndex>=0);
end;

procedure TFrm_Main.DoBoutonRepertoire;
begin
  Bt_AjoutReper.Enabled := (cmb_ch.ItemIndex>=0);
  Bt_SupprReper.Enabled := (cmb_ch.ItemIndex>=0) and (Lst_Reper.ItemIndex>=0);

  btn_BasePath.Enabled := (cmb_ch.ItemIndex>=0);
  Bt_CheminExport.Enabled := (cmb_ch.ItemIndex>=0);
  Chk_OkEntete.Enabled := (cmb_ch.ItemIndex>=0);
  Chk_Guillemet.Enabled := (cmb_ch.ItemIndex>=0);
  Chk_PointVirgule.Enabled := (cmb_ch.ItemIndex>=0);

  Bt_CreeProc.Enabled := (cmb_ch.ItemIndex>=0);
  Bt_Export.Enabled := (cmb_ch.ItemIndex>=0);
  Bt_Drop.Enabled := (cmb_ch.ItemIndex>=0);
end;

procedure TFrm_Main.DoBoutonParam;
begin
  Bt_AjoutParam.Enabled := (cmb_ch.ItemIndex>=0);
  Bt_ModifParam.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Param.RecordCount>0);
  Bt_SupprParam.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Param.RecordCount>0);
end;

procedure TFrm_Main.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  savBrush: TColor;
  savFont: TColor;
  ChBrush: TColor;
  ChFont: TColor;
begin
  with TDBGrid(Sender).Canvas do
  begin
    savBrush := Brush.Color;
    savFont := Font.Color;

    // paramètre d'entrées
    if (Column.FieldName = 'vIn') and (TDBGrid(Sender).DataSource.DataSet.Active) then
    begin
      if TDBGrid(Sender).DataSource.DataSet.FieldByName('vIn').AsInteger=TDBGrid(Sender).DataSource.DataSet.FieldByName('vInFait').AsInteger then
      begin
        // vert
        if (gdSelected in State) or (gdFocused in State) then
        begin
          ChBrush := rgb(0, 153, 0);
          ChFont := ClWhite;
        end
        else
        begin
          ChBrush := rgb(153, 255, 153);
          ChFont := clBlack;
        end;
      end
      else
      begin
        // rouge
        if (gdSelected in State) or (gdFocused in State) then
        begin
          ChBrush := rgb(153, 0, 0);
          ChFont := ClWhite;
        end
        else
        begin
          ChBrush := rgb(255, 153, 153);
          ChFont := clBlack;
        end;
      end;
    end
    // actif
    else if (Column.FieldName = 'Actif') and (TDBGrid(Sender).DataSource.DataSet.Active) then
    begin
      if TDBGrid(Sender).DataSource.DataSet.FieldByName('Actif').AsBoolean then
      begin
        // vert
        if (gdSelected in State) or (gdFocused in State) then
        begin
          ChBrush := rgb(0, 153, 0);
          ChFont := ClWhite;
        end
        else
        begin
          ChBrush := rgb(153, 255, 153);
          ChFont := clBlack;
        end;
      end
      else
      begin
        // rouge
        if (gdSelected in State) or (gdFocused in State) then
        begin
          ChBrush := rgb(153, 0, 0);
          ChFont := ClWhite;
        end
        else
        begin
          ChBrush := rgb(255, 153, 153);
          ChFont := clBlack;
        end;
      end;
    end
    else
    begin
      if (gdSelected in State) or (gdFocused in State) then
      begin
        ChBrush := clHighlight;
        ChFont := clHighlightText;
      end
      else
      begin
        ChBrush := Column.Color;
        ChFont := Column.Font.Color;
      end;
    end;

    Brush.Color := chBrush;
    Font.Color := ChFont;
    TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    Brush.Color := savBrush;
    Font.Color := savFont;

  end;

end;

procedure TFrm_Main.DoBoutonListeProc;
begin
  Bt_AjoutProc.Enabled := (cmb_ch.ItemIndex>=0);
  Bt_ModifDetail.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0);
  bt_ParamEntree.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0);
  Bt_SupprProc.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0);
  Bt_CreeLaProc.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0);
  Bt_ExportLaProc.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0);
  Bt_DropLaProc.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0);
  Bt_Rafraichir.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0);
  DoBoutonListeProcOrder;
end;

procedure TFrm_Main.DoBoutonListeProcOrder;
begin
  Bt_OrdreDown.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0) and not(Dm_Main.cds_Proc.Eof);
  Bt_OrdreUp.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0) and not(Dm_Main.cds_Proc.Bof);
  Bt_ParamSortie.Enabled := (cmb_ch.ItemIndex>=0) and (Dm_Main.cds_Proc.RecordCount>0)
    and (Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean);
end;

procedure TFrm_Main.AlgolDialogFormCreate(Sender: TObject);
var
  FicIni: TIniFile;
begin
  Left := Screen.WorkAreaLeft + Round((Width/2)-(Screen.WorkAreaWidth/2));
  Top  := Screen.WorkAreaTop  + Round((Height/2)-(Screen.WorkAreaHeight/2));

  Caption := Caption +' - Ver ' + GetNumVersionSoft;

  ChoixReper := Dm_Main.ReperBase;
  Ed_NomBase.Text := '';
  Ed_CheminExport.Text := '';

  // dernier nom d'export choisi
  ChoixNomExport := '';
  if FileExists(Dm_Main.ReperBase+'ExpertExport.ini') then
  begin
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      ChoixNomExport := FicIni.ReadString('General', 'LastNomExport', '');
    finally
      FreeAndNil(FicIni);
    end;
  end;

  // chargement de la liste d'export
  DoListeExport(Dm_Main.ListeNomExport);
  Dm_Main.ListeNomExport.Sort;
  Cmb_Ch.Items.AddStrings(Dm_Main.ListeNomExport);
  if ChoixNomExport<>'' then
    Cmb_Ch.ItemIndex := Cmb_Ch.Items.IndexOf(ChoixNomExport);

  // chargement du dernier nom effectué
  LoadNomExport;
  DoBoutonNomExport;
  DoBoutonRepertoire;
  DoBoutonParam;
  DoBoutonListeProc;
end;

procedure TFrm_Main.btn_BasePathClick(Sender: TObject);
begin
  if od_Base.Execute then
  begin
    Application.ProcessMessages;
    Ed_NomBase.Text := od_base.FileName;
    SauveNomExport;
  end;
end;

procedure TFrm_Main.btn_QuitterClick(Sender: TObject);
begin
  Close;
end;

procedure TFrm_Main.Bt_AjoutNomClick(Sender: TObject);
var
  FicIni: TIniFile;
  NoExport: integer;
begin
  Frm_AjoutModifNomExport := TFrm_AjoutModifNomExport.Create(Self);
  try
    if Frm_AjoutModifNomExport.ShowModal=mrok then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        ChoixNomExport := Frm_AjoutModifNomExport.sReponseNom;
        Cmb_Ch.Clear;
        Cmb_Ch.Items.AddStrings(Dm_Main.ListeNomExport);
        Cmb_Ch.ItemIndex := Cmb_Ch.Items.IndexOf(ChoixNomExport);
        NoExport := GetNextNumExport;
        FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
        try
          FicIni.WriteString('General', 'LastNomExport', ChoixNomExport);
          FicIni.WriteString('ListeNomExport', 'EXPORT'+inttostr(NoExport), ChoixNomExport);
        finally
          FreeAndNil(FicIni);
        end;
        LoadNomExport;
        DoBoutonNomExport;
        DoBoutonRepertoire;
        DoBoutonParam;
        DoBoutonListeProc;
      finally
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    FreeAndNil(Frm_AjoutModifNomExport);
  end;
end;

procedure TFrm_Main.Bt_AjoutParamClick(Sender: TObject);
begin
  if (ChoixNomExport='') then
    exit;

  Frm_AjoutModifParam := TFrm_AjoutModifParam.Create(Self);
  try
    Frm_AjoutModifParam.SetAjout;
    if Frm_AjoutModifParam.ShowModal = mrok then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        Dm_Main.cds_Param.IndexFieldNames := '';
        Dm_Main.cds_Param.IndexFieldNames := 'Num';
        SauveNomExport;
        DoBoutonParam;
      finally
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    FreeAndNil(Frm_AjoutModifParam);
  end;

end;

procedure TFrm_Main.Bt_AjoutProcClick(Sender: TObject);
var
  i: integer;
  Book: TBookMark;
  Liste: TStringList;
  iGrantGinkoia: integer;
  iGrantRepl: integer;
  iDropProc: integer;
  sRep: string;
  sFile: string;
  iOrdre: integer;
  savOrdre: integer;
begin
  if (ChoixNomExport='') then
    exit;

  Frm_ValeurDefaut := TFrm_ValeurDefaut.Create(Self);
  Liste := TStringList.Create;
  try
    with Frm_ValeurDefaut.Cmb_Ordre.Items do
    begin
      Clear;
      Add('En premier');
      Add('A la fin');
      if Dm_Main.cds_Proc.RecordCount>0 then
      begin
        Book := Dm_Main.cds_Proc.GetBookmark;
        Dm_Main.cds_Proc.DisableControls;
        try
          Dm_Main.cds_Proc.First;
          while not(Dm_Main.cds_Proc.Eof) do
          begin
            Add('Après '+Dm_Main.cds_Proc.FieldByName('FicProc').AsString);
            Dm_Main.cds_Proc.Next;
          end;
        finally
          Dm_Main.cds_Proc.GotoBookmark(Book);
          Dm_Main.cds_Proc.FreeBookmark(Book);
          Dm_Main.cds_Proc.EnableControls;
        end;
      end;
    end;
    Frm_ValeurDefaut.Cmb_Ordre.ItemIndex := 1;

    if OD_Proc.Execute and (Frm_ValeurDefaut.ShowModal=mrok) then
    begin
      if Frm_ValeurDefaut.Chk_GrantGinkoia.Checked then
        iGrantGinkoia := 1
      else
        iGrantGinkoia := 0;
      if Frm_ValeurDefaut.Chk_GrantRepl.Checked then
        iGrantRepl := 1
      else
        iGrantRepl := 0;
      if Frm_ValeurDefaut.Chk_OkDrop.Checked then
        iDropProc := 1
      else
        iDropProc := 0;
      Liste.AddStrings(OD_Proc.Files);

      Dm_Main.cds_Proc.DisableControls;
      try
        if Frm_ValeurDefaut.Cmb_Ordre.ItemIndex=0 then
        begin
          // premier
          Dm_Main.cds_Proc.Last;
          while not(Dm_Main.cds_Proc.Bof) do
          begin
            Dm_Main.cds_Proc.Edit;
            Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger+Liste.Count;
            Dm_Main.cds_Proc.Post;
            Dm_Main.cds_Proc.Prior;
          end;
          iOrdre := 1;
        end
        else if Frm_ValeurDefaut.Cmb_Ordre.ItemIndex = 1 then
        begin
          // dernier
          Dm_Main.cds_Proc.Last;
          iOrdre := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger+1;
        end
        else
        begin
          Dm_Main.cds_Proc.First;
          if Frm_ValeurDefaut.Cmb_Ordre.ItemIndex>2 then
            Dm_Main.cds_Proc.MoveBy(Frm_ValeurDefaut.Cmb_Ordre.ItemIndex-2);
          savOrdre := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger;
          Dm_Main.cds_Proc.Last;
          while not(Dm_Main.cds_Proc.Bof) and (Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger>savOrdre) do
          begin
            if (Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger>savOrdre) then
            begin
              Dm_Main.cds_Proc.Edit;
              Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger+Liste.Count;
              Dm_Main.cds_Proc.Post;
            end;
            Dm_Main.cds_Proc.Prior;
          end;
          iOrdre := savOrdre+1;
        end;

        for i := 1 to Liste.Count do
        begin
          // répertoire
          sRep := ExtractFilePath(Liste[i-1]);
          AjouterUnRepertoire(sRep);

          // fichier
          sFile := ExtractfileName(Liste[i-1]);

          if not(Dm_Main.cds_Proc.Locate('FicProc', sFile, [loCaseInsensitive])) then
          begin
            Dm_Main.cds_Proc.Append;
            Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := iOrdre;
            Dm_Main.cds_Proc.FieldByName('FicProc').AsString := sFile;
            Dm_Main.cds_Proc.FieldByName('FicCsv').AsString := '';
            Dm_Main.cds_Proc.FieldByName('OkGrantGinkoia').AsInteger := iGrantGinkoia;
            Dm_Main.cds_Proc.FieldByName('OkGrantRepl').AsInteger := iGrantRepl;
            Dm_Main.cds_Proc.FieldByName('OkDropAfterExport').AsInteger := iDropProc;
            Dm_Main.cds_Proc.FieldByName('vIn').AsInteger := 0;
            Dm_Main.cds_Proc.FieldByName('vOut').AsInteger := 0;
            Dm_Main.cds_Proc.FieldByName('vInFait').AsInteger := 0;
            Dm_Main.cds_Proc.FieldByName('RecupParam').AsBoolean := false;
            Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean := true;
            Dm_Main.cds_Proc.Post;
            Inc(iOrdre);
          end;
        end;

        SauveNomExport;
        DoBoutonRepertoire;
        DoBoutonParam;
        DoBoutonListeProc;

        Bt_RafraichirClick(Bt_Rafraichir);

      finally
        Dm_Main.cds_Proc.IndexFieldNames := '';
        Dm_Main.cds_Proc.IndexFieldNames := 'Ordre';
        Dm_Main.cds_Proc.EnableControls;
      end;
    end;
  finally
    FreeandNil(Frm_ValeurDefaut);
    FreeandNil(Liste);
  end;
end;

procedure TFrm_Main.Bt_AjoutReperClick(Sender: TObject);
var
  sRep: string;
begin
  if (ChoixNomExport='') then
    exit;

  sRep := ChoixReper;
  if sRep[Length(sRep)]<>'\' then
    sRep := sRep+'\';
  if Length(sRep)>3 then
    sRep := Copy(sRep, 1, Length(sRep)-1);

  if SelectDirectory('Ajouter un répertoire de recherche', '', sRep) then
  begin
    ChoixReper := sRep;
    AjouterUnRepertoire(sRep);

    SauveNomExport;
    DoBoutonRepertoire;
  end;
end;

procedure TFrm_Main.Bt_CheminExportClick(Sender: TObject);
var
  sRep: string;
begin
  if (ChoixNomExport='') then
    exit;

  sRep := Ed_CheminExport.Text;
  if (sRep='') or not(SysUtils.DirectoryExists(sRep)) then
    sRep := ChoixReper;

  if sRep[Length(sRep)]<>'\' then
    sRep := sRep+'\';
  if Length(sRep)>3 then
    sRep := Copy(sRep, 1, Length(sRep)-1);

  if SelectDirectory('Ajouter un répertoire de recherche', '', sRep) then
  begin
    if sRep[Length(sRep)]<>'\' then
      sRep := sRep+'\';
    Ed_CheminExport.Text := sRep;

    SauveNomExport;
  end;
end;

procedure TFrm_Main.Bt_CreeLaProcClick(Sender: TObject);
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  if (Ed_NomBase.Text='') or not(FileExists(Ed_NomBase.Text)) then
  begin
    MessageDlg('Nom base indéfini ou introuvable !', mterror, [mbok],0);
    exit;
  end;

  if not(Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean) then
  begin
    if MessageDlg('Procedure stockée non actif'+#13#10#13#10+'Poursuivre ?',
             mterror, [mbyes, mbno], 0)<>mryes then
      exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Enabled := false;
  Frm_Progress := TFrm_Progress.Create(Self);
  try
    Frm_Progress.DoEtat('Connexion à la base', '');
    Frm_Progress.Show;
    Application.ProcessMessages;
    // connexion
    Dm_Main.DoConnexion(Ed_NomBase.Text);

    // création procedure
    Frm_Progress.DoEtat('Création procédure', '');
    if CreerLaProcedure then
      MessageDlg('Procedure crée avec succès !', mtinformation, [mbok], 0);

  finally
    Enabled := true;
    Dm_Main.DataBase.Disconnect;
    FreeAndNil(Frm_Progress);
    Application.ProcessMessages;
    Screen.Cursor := crdefault;
  end;
end;

procedure TFrm_Main.Bt_CreeProcClick(Sender: TObject);
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  if (Ed_NomBase.Text='') or not(FileExists(Ed_NomBase.Text)) then
  begin
    MessageDlg('Nom base indéfini ou introuvable !', mterror, [mbok],0);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Enabled := false;
  Frm_Progress := TFrm_Progress.Create(Self);
  try
    Frm_Progress.DoEtat('Connexion à la base', '');
    Frm_Progress.Show;
    Application.ProcessMessages;
    // connexion
    Dm_Main.DoConnexion(Ed_NomBase.Text);

    // création procedure
    Frm_Progress.DoEtat('Création procédure', '');
    if CreerLesProcedures then
      MessageDlg('Procedures crées avec succès !', mtinformation, [mbok], 0);

  finally
    Enabled := true;
    Dm_Main.DataBase.Disconnect;
    FreeAndNil(Frm_Progress);
    Application.ProcessMessages;
    Screen.Cursor := crdefault;
  end;
end;

procedure TFrm_Main.Bt_DropClick(Sender: TObject);
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  if (Ed_NomBase.Text='') or not(FileExists(Ed_NomBase.Text)) then
  begin
    MessageDlg('Nom base indéfini ou introuvable !', mterror, [mbok],0);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Enabled := false;
  Frm_Progress := TFrm_Progress.Create(Self);
  try
    Frm_Progress.DoEtat('Connexion à la base', '');
    Frm_Progress.Show;
    Application.ProcessMessages;
    // connexion
    Dm_Main.DoConnexion(Ed_NomBase.Text);

    // Drop procedure
    Frm_Progress.DoEtat('Drop procédure', '');
    if DropLesProcedures then
      MessageDlg('Procedures droppées avec succès !', mtinformation, [mbok], 0);

  finally
    Enabled := true;
    Dm_Main.DataBase.Disconnect;
    FreeAndNil(Frm_Progress);
    Application.ProcessMessages;
    Screen.Cursor := crdefault;
  end;
end;

procedure TFrm_Main.Bt_DropLaProcClick(Sender: TObject);
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  if (Ed_NomBase.Text='') or not(FileExists(Ed_NomBase.Text)) then
  begin
    MessageDlg('Nom base indéfini ou introuvable !', mterror, [mbok],0);
    exit;
  end;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Enabled := false;
  Frm_Progress := TFrm_Progress.Create(Self);
  try
    Frm_Progress.DoEtat('Connexion à la base', '');
    Frm_Progress.Show;
    Application.ProcessMessages;
    // connexion
    Dm_Main.DoConnexion(Ed_NomBase.Text);

    // Drop procedure
    Frm_Progress.DoEtat('Drop procédure', '');
    if DropLaProcedure then
      MessageDlg('Procedure droppée avec succès !', mtinformation, [mbok], 0);

  finally
    Enabled := true;
    Dm_Main.DataBase.Disconnect;
    FreeAndNil(Frm_Progress);
    Application.ProcessMessages;
    Screen.Cursor := crdefault;
  end;
end;

procedure TFrm_Main.Bt_ExportClick(Sender: TObject);
var
  NomSection: string;
  sProcSection: string;
  NomSectionDetailProc: string;
  bOk: boolean;
  BookParam: TBookMark;
  BookProc: TBookMark;
  LParam: integer;
  bNeedSaisi: boolean;
  bPoursuivre: boolean;
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  if (Ed_NomBase.Text='') or not(FileExists(Ed_NomBase.Text)) then
  begin
    MessageDlg('Nom base indéfini ou introuvable !', mterror, [mbok],0);
    exit;
  end;

  if (Ed_CheminExport.Text='') or not(SysUtils.DirectoryExists(Ed_CheminExport.Text)) then
  begin
    MessageDlg('Chemin d''exportation: indéfini ou introuvable !', mterror, [mbok],0);
    exit;
  end;

  // saisi des paramètres
  NomSection := GetSectionNomExport(ChoixNomExport);
  bPoursuivre := true;
  bNeedSaisi := false;
  with Dm_Main do
  begin
    if (cds_Param.RecordCount>0) then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      BookParam := cds_Param.GetBookmark;
      cds_Param.DisableControls;
      BookProc := cds_Proc.GetBookmark;
      cds_Proc.DisableControls;
      try
        // vidage
        cds_Param.First;
        while not(cds_Param.Eof) do
        begin
          cds_Param.Edit;
          cds_Param.FieldByName('Saisi').AsInteger := 0;
          cds_Param.FieldByName('FicProc').AsString := '';
          cds_Param.Post;
          cds_Param.Next;
        end;

        // pour chaque proc, regarder les paramètres
        cds_Proc.First;
        while not(cds_Proc.Eof) do
        begin
          if cds_Proc.FieldByName('Actif').AsBoolean then
          begin
            sProcSection := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
            sProcSection := Copy(sProcSection, 1, Length(sProcSection)-Length(ExtractFileExt(sProcSection)));
            // paramètre d'endrée
            NomSectionDetailProc := Nomsection+'_'+sProcSection+'_IN';
            // charge les paramètres d'entrée
            ChargeParamInFromStkProc(NomSectionDetailProc, Dm_Main.cds_Proc.FieldByName('vIn').AsInteger);

            cds_EntreeIn.First;
            while not(cds_EntreeIn.Eof) do
            begin
              LParam := cds_EntreeIn.FieldByName('NumParam').AsInteger;
              if cds_Param.Locate('Num', LParam, []) then
              begin
                if cds_Param.FieldByName('Saisi').AsInteger=0 then
                begin
                  bNeedSaisi := true;
                  cds_Param.Edit;
                  cds_Param.FieldByName('Saisi').AsInteger := 1;
                  cds_Param.Post;
                end;
              end;
              cds_EntreeIn.Next;
            end;

            // paramètre de sortie
            NomSectionDetailProc := Nomsection+'_'+sProcSection+'_OUT';
            // charge les paramètres d'entrée
            ChargeParamOutFromStkProc(NomSectionDetailProc);

            cds_SortieOut.First;
            while not(cds_SortieOut.Eof) do
            begin
              LParam := cds_SortieOut.FieldByName('NumParam').AsInteger;
              if cds_Param.Locate('Num', LParam, []) then
              begin
                if cds_Param.FieldByName('Saisi').AsInteger=0 then
                begin
                  bNeedSaisi := true;
                  cds_Param.Edit;
                  cds_Param.FieldByName('Saisi').AsInteger := 2;   // pas besoin de saisi, present pour indication
                  cds_Param.FieldByName('FicProc').AsString := 'Mis à jour par: '+sProcSection;
                  cds_Param.Post;
                end;
              end;
              cds_SortieOut.Next;
            end;
          end;

          cds_Proc.Next;
        end;

        if bNeedSaisi then
        begin
          bPoursuivre := false;
          Frm_SaisiParam := TFrm_SaisiParam.Create(Self);
          try
            if Frm_SaisiParam.ShowModal=mrok then
            begin
              bPoursuivre := true;
            end;
          finally
            FreeAndNil(Frm_SaisiParam);
          end;
        end;

      finally
        cds_Param.GotoBookmark(BookParam);
        cds_Param.FreeBookmark(BookParam);
        cds_Param.EnableControls;
        cds_Proc.GotoBookmark(BookProc);
        cds_Proc.FreeBookmark(BookProc);
        cds_Proc.EnableControls;
        Application.ProcessMessages;
        Screen.Cursor := crdefault;
      end;
    end;
  end;
  if not(bPoursuivre) then
    exit;

  SauveNomExport;

  // exportation
  bOk := true;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  BookParam := Dm_Main.cds_Param.GetBookmark;
  Dm_Main.cds_Param.DisableControls;
  Enabled := false;
  Frm_Progress := TFrm_Progress.Create(Self);
  try
    Frm_Progress.DoEtat('Connexion à la base', '');
    Frm_Progress.Show;
    Application.ProcessMessages;
    // connexion
    Dm_Main.DoConnexion(Ed_NomBase.Text);

    // création procedure
    Frm_Progress.DoEtat('Création procédure', '');
    if not(CreerLesProcedures) then
      exit;

    // exportation
    Frm_Progress.DoEtat('Exportation', '');
    if Exportation then
      bOk := true;

    // Drop procedure
    Frm_Progress.DoEtat('Drop procédure', '');
    if not(DropLesProcedures) or not(bOk) then
      exit;

    // tout s'est bien passé
    bOk := true;

  finally
    Enabled := true;
    Dm_Main.DataBase.Disconnect;
    FreeAndNil(Frm_Progress);
    Dm_Main.cds_Param.GotoBookmark(BookParam);
    Dm_Main.cds_Param.FreeBookmark(BookParam);
    Dm_Main.cds_Param.EnableControls;
    Application.ProcessMessages;
    Screen.Cursor := crdefault;
  end;

  SauveNomExport;

  if bOk then
    MessageDlg('Export réalisé avec succès !', mtinformation, [mbok],0);
end;

procedure TFrm_Main.Bt_ExportLaProcClick(Sender: TObject);
var
  NomSection: string;
  sProcSection: string;
  NomSectionDetailProc: string;
  bOk: boolean;
  BookParam: TBookMark;
  LParam: integer;
  bNeedSaisi: boolean;
  bPoursuivre: boolean;
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  if (Ed_NomBase.Text='') or not(FileExists(Ed_NomBase.Text)) then
  begin
    MessageDlg('Nom base indéfini ou introuvable !', mterror, [mbok],0);
    exit;
  end;

  if not(Dm_Main.cds_Proc.FieldByName('Actif').AsBoolean) then
  begin
    if MessageDlg('Procedure stockée non actif'+#13#10#13#10+'Poursuivre ?',
             mterror, [mbyes, mbno], 0)<>mryes then
      exit;
  end;
  // saisi des paramètres
  NomSection := GetSectionNomExport(ChoixNomExport);
  bPoursuivre := true;
  bNeedSaisi := false;
  with Dm_Main do
  begin
    if (cds_Param.RecordCount>0) then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      BookParam := cds_Param.GetBookmark;
      cds_Param.DisableControls;
      try
        // vidage
        cds_Param.First;
        while not(cds_Param.Eof) do
        begin
          cds_Param.Edit;
          cds_Param.FieldByName('Saisi').AsInteger := 0;
          cds_Param.FieldByName('FicProc').AsString := '';
          cds_Param.Post;
          cds_Param.Next;
        end;

        // regarder les paramètres pour la proc
        if cds_Proc.FieldByName('Actif').AsBoolean then
        begin
          sProcSection := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
          sProcSection := Copy(sProcSection, 1, Length(sProcSection)-Length(ExtractFileExt(sProcSection)));
          // paramètre d'endrée
          NomSectionDetailProc := Nomsection+'_'+sProcSection+'_IN';
          // charge les paramètres d'entrée
          ChargeParamInFromStkProc(NomSectionDetailProc, Dm_Main.cds_Proc.FieldByName('vIn').AsInteger);

          cds_EntreeIn.First;
          while not(cds_EntreeIn.Eof) do
          begin
            LParam := cds_EntreeIn.FieldByName('NumParam').AsInteger;
            if cds_Param.Locate('Num', LParam, []) then
            begin
              if cds_Param.FieldByName('Saisi').AsInteger=0 then
              begin
                bNeedSaisi := true;
                cds_Param.Edit;
                cds_Param.FieldByName('Saisi').AsInteger := 1;
                cds_Param.Post;
              end;
            end;
            cds_EntreeIn.Next;
          end;

          // paramètre de sortie
          NomSectionDetailProc := Nomsection+'_'+sProcSection+'_OUT';
          // charge les paramètres d'entrée
          ChargeParamOutFromStkProc(NomSectionDetailProc);

          cds_SortieOut.First;
          while not(cds_SortieOut.Eof) do
          begin
            LParam := cds_SortieOut.FieldByName('NumParam').AsInteger;
            if cds_Param.Locate('Num', LParam, []) then
            begin
              if cds_Param.FieldByName('Saisi').AsInteger=0 then
              begin
                bNeedSaisi := true;
                cds_Param.Edit;
                cds_Param.FieldByName('Saisi').AsInteger := 2;   // pas besoin de saisi, present pour indication
                cds_Param.FieldByName('FicProc').AsString := 'Mis à jour par: '+sProcSection;
                cds_Param.Post;
              end;
            end;
            cds_SortieOut.Next;
          end;
        end;

        if bNeedSaisi then
        begin
          bPoursuivre := false;
          Frm_SaisiParam := TFrm_SaisiParam.Create(Self);
          try
            if Frm_SaisiParam.ShowModal=mrok then
            begin
              bPoursuivre := true;
            end;
          finally
            FreeAndNil(Frm_SaisiParam);
          end;
        end;

      finally
        cds_Param.GotoBookmark(BookParam);
        cds_Param.FreeBookmark(BookParam);
        cds_Param.EnableControls;
        Application.ProcessMessages;
        Screen.Cursor := crdefault;
      end;
    end;
  end;
  if not(bPoursuivre) then
    exit;

  SauveNomExport;

  bOk := false;
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Enabled := false;
  Frm_Progress := TFrm_Progress.Create(Self);
  try
    Frm_Progress.DoEtat('Connexion à la base', '');
    Frm_Progress.Show;
    Application.ProcessMessages;
    // connexion
    Dm_Main.DoConnexion(Ed_NomBase.Text);

    // création procedure
    Frm_Progress.DoEtat('Création procédure', '');
    if CreerLaProcedure then
      bOk := true;

    // export
    if ExportLaProcedure then
      bOk := true;

    // Drop procedure
    Frm_Progress.DoEtat('Drop procédure', '');
    if not(DropLaProcedure) or not(bOk) then
      exit;

    bOk := true;

  finally
    Enabled := true;
    Dm_Main.DataBase.Disconnect;
    FreeAndNil(Frm_Progress);
    Application.ProcessMessages;
    Screen.Cursor := crdefault;
  end;

  SauveNomExport;

  if bOk then
    MessageDlg('Export réalisé avec succès !', mtinformation, [mbok],0);
end;

procedure TFrm_Main.Bt_ModifDetailClick(Sender: TObject);
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  Frm_ModifDetail := TFrm_ModifDetail.Create(Self);
  try
    if Frm_ModifDetail.ShowModal=mrok then
      SauveNomExport;
  finally
    FreeAndNil(Frm_ModifDetail);
  end;

end;

procedure TFrm_Main.Bt_ModifNomClick(Sender: TObject);
var
  FicIni: TIniFile;
  sSection: string;
begin
  if ChoixNomExport='' then
    exit;

  Frm_AjoutModifNomExport := TFrm_AjoutModifNomExport.Create(Self);
  try
    Frm_AjoutModifNomExport.SetModif(ChoixNomExport);
    if Frm_AjoutModifNomExport.ShowModal=mrok then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        sSection := GetSectionNomExport(ChoixNomExport);
        EraseExport;
        ChoixNomExport := Frm_AjoutModifNomExport.sReponseNom;
        Cmb_Ch.Clear;
        Cmb_Ch.Items.AddStrings(Dm_Main.ListeNomExport);
        Cmb_Ch.ItemIndex := Cmb_Ch.Items.IndexOf(ChoixNomExport);
        FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
        try
          FicIni.WriteString('General', 'LastNomExport', ChoixNomExport);
          FicIni.WriteString('ListeNomExport', sSection, ChoixNomExport);
        finally
          FreeAndNil(FicIni);
        end;
        SauveNomExport;
        LoadNomExport;
        DoBoutonNomExport;
        DoBoutonRepertoire;
        DoBoutonParam;
        DoBoutonListeProc;
      finally
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    FreeAndNil(Frm_AjoutModifNomExport);
  end;
end;

procedure TFrm_Main.Bt_ModifParamClick(Sender: TObject);
begin
  if (ChoixNomExport='') or (Dm_Main.cds_Param.RecordCount=0) then
    exit;

  Frm_AjoutModifParam := TFrm_AjoutModifParam.Create(Self);
  try
    Frm_AjoutModifParam.SetModif;
    if Frm_AjoutModifParam.ShowModal = mrok then
    begin
      Screen.Cursor := crHourGlass;
      Application.ProcessMessages;
      try
        Dm_Main.cds_Param.IndexFieldNames := '';
        Dm_Main.cds_Param.IndexFieldNames := 'Num';
        SauveNomExport;
        DoBoutonParam;
      finally
        Application.ProcessMessages;
        Screen.Cursor := crDefault;
      end;
    end;
  finally
    FreeAndNil(Frm_AjoutModifParam);
  end;
end;

procedure TFrm_Main.Bt_OrdreDownClick(Sender: TObject);
var
  LPos1, LPos2: integer;
begin
  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  LPos1 := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger;
  Dm_Main.cds_Proc.Next;
  if not(Dm_Main.cds_Proc.Eof) then
  begin
    LPos2 := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger;
    Dm_Main.cds_Proc.Edit;
    Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := -1;
    Dm_Main.cds_Proc.Post;
    Dm_Main.cds_Proc.Locate('Ordre', LPos1, []);
    Dm_Main.cds_Proc.Edit;
    Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := LPos2;
    Dm_Main.cds_Proc.Post;
    Dm_Main.cds_Proc.Locate('Ordre', -1, []);
    Dm_Main.cds_Proc.Edit;
    Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := LPos1;
    Dm_Main.cds_Proc.Post;

    Dm_Main.cds_Proc.IndexFieldNames := '';
    Dm_Main.cds_Proc.IndexFieldNames := 'Ordre';

    Dm_Main.cds_Proc.Locate('Ordre', LPos2, []);

    SauveNomExport;
  end;

  DoBoutonListeProcOrder;
end;

procedure TFrm_Main.Bt_OrdreUpClick(Sender: TObject);
var
  LPos1, LPos2: integer;
begin
  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  LPos1 := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger;
  Dm_Main.cds_Proc.Prior;
  if not(Dm_Main.cds_Proc.Bof) then
  begin
    LPos2 := Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger;
    Dm_Main.cds_Proc.Edit;
    Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := -1;
    Dm_Main.cds_Proc.Post;
    Dm_Main.cds_Proc.Locate('Ordre', LPos1, []);
    Dm_Main.cds_Proc.Edit;
    Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := LPos2;
    Dm_Main.cds_Proc.Post;
    Dm_Main.cds_Proc.Locate('Ordre', -1, []);
    Dm_Main.cds_Proc.Edit;
    Dm_Main.cds_Proc.FieldByName('Ordre').AsInteger := LPos1;
    Dm_Main.cds_Proc.Post;

    Dm_Main.cds_Proc.IndexFieldNames := '';
    Dm_Main.cds_Proc.IndexFieldNames := 'Ordre';
    Dm_Main.cds_Proc.Locate('Ordre', LPos2, []);

    SauveNomExport;
  end;

  DoBoutonListeProcOrder;
end;

procedure TFrm_Main.bt_ParamEntreeClick(Sender: TObject);
var
  NomSection: string;
  sProcSection: string;
  NomSectionDetailProc: string;
  vIn, vInFait: integer;
begin
  if ChoixNomExport='' then
    exit;

  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  NomSection := GetSectionNomExport(ChoixNomExport);
  if NomSection='' then
    exit;

  if Dm_Main.cds_Proc.FieldByName('vIn').AsInteger=0 then
  begin
    MessageDlg('Aucun paramètre d''entrée'+#13#10+
               'Si vous êtes sûr d''en avoir, cliquer sur rafraîchir.',
               mterror, [mbok], 0);
    exit;
  end;

  sProcSection := Dm_Main.cds_Proc.FieldByName('FicProc').AsString;
  sProcSection := Copy(sProcSection, 1, Length(sProcSection)-Length(ExtractFileExt(sProcSection)));
  NomSectionDetailProc := Nomsection+'_'+sProcSection+'_IN';

  // charge les paramètres d'entrée
  ChargeParamInFromStkProc(NomSectionDetailProc, Dm_Main.cds_Proc.FieldByName('vIn').AsInteger);

  Frm_ParamEntree := TFrm_ParamEntree.Create(Self);
  try
    if Frm_ParamEntree.ShowModal=mrok then
    begin
      Application.ProcessMessages;
      SauveParamInFromStkProc(NomSectionDetailProc, vIn, vInFait);
      Dm_Main.cds_Proc.Edit;
      Dm_Main.cds_Proc.FieldByName('vIn').AsInteger := vIn;
      Dm_Main.cds_Proc.FieldByName('vInFait').AsInteger := vInFait;
      Dm_Main.cds_Proc.Post;
      SauveNomExport;
    end;
  finally
    FreeAndNil(Frm_ParamEntree);
  end;

end;

procedure TFrm_Main.Bt_SupprNomClick(Sender: TObject);
var
  lret: integer;
  FicIni: TIniFile;
begin
  if ChoixNomExport='' then
    exit;

  if MessageDlg('Supprimer ?', mtconfirmation, [mbyes, mbno],0)<>mryes then
    exit;

  lret := Dm_Main.ListeNomExport.IndexOf(ChoixNomExport);
  if lret<0 then
    exit;

  Dm_Main.ListeNomExport.Delete(lret);
  EraseExport;
  if lret>=Dm_Main.ListeNomExport.Count then
    lret := lret-1;
  if lret<0 then
    ChoixNomExport := ''
  else
    ChoixNomExport := Dm_Main.ListeNomExport[lret];

  FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
  try
    FicIni.WriteString('General', 'LastNomExport', ChoixNomExport);
  finally
    FreeAndNil(FicIni);
  end;

  // chargement de la liste d'export
  Dm_Main.ListeNomExport.Clear;
  Cmb_Ch.Items.Clear;
  DoListeExport(Dm_Main.ListeNomExport);
  Dm_Main.ListeNomExport.Sort;
  Cmb_Ch.Items.AddStrings(Dm_Main.ListeNomExport);
  if ChoixNomExport<>'' then
    Cmb_Ch.ItemIndex := Cmb_Ch.Items.IndexOf(ChoixNomExport);

  // chargement du dernier nom effectué
  LoadNomExport;
  DoBoutonNomExport;
  DoBoutonRepertoire;
  DoBoutonParam;
  DoBoutonListeProc;

end;

procedure TFrm_Main.Bt_SupprParamClick(Sender: TObject);
begin
  if (ChoixNomExport='') or (Dm_Main.cds_Param.RecordCount=0) then
    exit;

  if MessageDlg('Supprimer ?', mtconfirmation, [mbyes, mbno],0)<>mryes then
    exit;

  Dm_Main.cds_Param.Delete;
  SauveNomExport;
  DoBoutonParam;

end;

procedure TFrm_Main.Bt_SupprProcClick(Sender: TObject);
begin
  if Dm_Main.cds_Proc.RecordCount=0 then
    exit;

  if MessageDlg('Supprimer ?', mtconfirmation, [mbyes, mbno],0)<>mryes then
    exit;

  Dm_Main.cds_Proc.Delete;
  SauveNomExport;
  DoBoutonRepertoire;
  DoBoutonListeProc;
end;

procedure TFrm_Main.Bt_SupprReperClick(Sender: TObject);
var
  lret: integer;
  lpos: integer;
  sTmp: string;
begin
  if Dm_Main.ListeNomReper.Count=0 then
    exit;

  lret := Lst_Reper.ItemIndex;
  if lret<0 then
    exit;

  sTmp := Lst_Reper.Items[lret];
  lret := lret-1;
  lpos := Dm_Main.ListeNomReper.IndexOf(sTmp);
  if (lpos>=0) then
  begin
    Dm_Main.ListeNomReper.Delete(lpos);
    Lst_Reper.Clear;
    Lst_Reper.Items.AddStrings(Dm_Main.ListeNomReper);
    Lst_Reper.ItemIndex := lret;

    SauveNomExport;
    DoBoutonRepertoire;
  end;
end;

procedure TFrm_Main.Chk_GuillemetClick(Sender: TObject);
begin
  if Chk_Guillemet.Focused then
    SauveNomExport;
end;

procedure TFrm_Main.Chk_OkEnteteClick(Sender: TObject);
begin
  if Chk_OkEntete.Focused then
    SauveNomExport;
end;

procedure TFrm_Main.Chk_PointVirguleClick(Sender: TObject);
begin
  if Chk_PointVirgule.Focused then
    SauveNomExport;
end;

procedure TFrm_Main.Cmb_ChChange(Sender: TObject);
var
  lret: integer;
  sTmp: string;
  FicIni: TIniFile;
begin
  lret:= cmb_ch.ItemIndex;
  if lret<0 then
    sTmp := ''
  else
    sTmp := cmb_ch.Items[lret];

  if sTmp<>ChoixNomExport then
  begin
    ChoixNomExport := sTmp;
    FicIni := TIniFile.Create(Dm_Main.ReperBase+'ExpertExport.ini');
    try
      FicIni.WriteString('General', 'LastNomExport', ChoixNomExport);
    finally
      FreeAndNil(FicIni);
    end;
    LoadNomExport;
    DoBoutonNomExport;
    DoBoutonRepertoire;
    DoBoutonParam;
    DoBoutonListeProc;
  end;
end;

end.
