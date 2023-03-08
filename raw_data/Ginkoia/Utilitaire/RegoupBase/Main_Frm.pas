unit Main_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrm_Main = class(TForm)
    Pan_Haut: TPanel;
    Pan_Base1: TPanel;
    Pan_Base2: TPanel;
    Pan_Traite: TPanel;
    Nbt_RecupBase: TBitBtn;
    Nbt_Close: TBitBtn;
    Lab_Version: TLabel;
    OD_Base: TOpenDialog;
    Lab_Base1: TLabel;
    Lab_OkConn1: TLabel;
    Edt_Base1: TEdit;
    Nbt_Conn1: TBitBtn;
    Nbt_Ouvre1: TBitBtn;
    Lab_Base2: TLabel;
    Lab_OkConn2: TLabel;
    Edt_Base2: TEdit;
    Nbt_Conn2: TBitBtn;
    Nbt_Ouvre2: TBitBtn;
    Nbt_CompareMark: TBitBtn;
    Lab_Nom1: TLabel;
    Edt_Nom1: TEdit;
    Lab_Nom2: TLabel;
    Edt_Nom2: TEdit;
    Panel1: TPanel;
    Nbt_Taille: TBitBtn;
    Gbx_Restric: TGroupBox;
    Chk_Restric: TCheckBox;
    Lab_Stock: TLabel;
    Lab_Date: TLabel;
    Dt_Analyse: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure Nbt_Ouvre1Click(Sender: TObject);
    procedure Nbt_Conn1Click(Sender: TObject);
    procedure Nbt_Conn2Click(Sender: TObject);
    procedure Nbt_Ouvre2Click(Sender: TObject);
    procedure Nbt_RecupBaseClick(Sender: TObject);
    procedure Nbt_CompareMarkClick(Sender: TObject);
    procedure Nbt_TailleClick(Sender: TObject);
    procedure Chk_RestricClick(Sender: TObject);
  private
    { Déclarations privées }
    NomBase1: string;
    NomBase2: string;
    procedure DoConnexion1(OkMess: boolean);
    procedure DoConnexion2(OkMess: boolean);
    procedure DoPanelTraiteOk;
    procedure SauveConfig;
  public
    { Déclarations publiques }
  end;

var
  Frm_Main: TFrm_Main;

implementation

uses
  IniFiles, Main_Dm, ComparMarq_Frm, AnalyseArticle_Frm, Progression_Frm;

{$R *.dfm}   

function ApplicationVersion: String;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
  Version: string;
  d: TDateTime;
  AgeExe: string;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize <> 0 then   // Les info de version sont inclues
  begin
    // On alloue de la mémoire pour un pointeur sur les info de version
    GetMem(VerInfo, VerInfoSize);
    // On récupère ces informations :
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    // On traite les informations ainsi récupérées
    with VerValue^ do
    begin
      Version := IntTostr(dwFileVersionMS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Version := Version + '.' + IntTostr(dwFileVersionLS shr 16);
      Version := Version + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;
    // On libère la place précédemment allouée
    FreeMem(VerInfo, VerInfoSize);
  end
  else
    Version:='0.0.0.0 ';

  d:=  FileDateToDateTime(FileAge(ParamStr(0)));
  AgeExe := ' du '+FormatDateTime('dd/mm/yyyy',d);
  result := Version+AgeExe;
end;

procedure TFrm_Main.DoPanelTraiteOk;
begin
  Pan_Traite.Visible := Dm_Main.GinBase1.Connected and Dm_Main.GinBase2.Connected;
end;

procedure TFrm_Main.SauveConfig;
var
  FicIni: TInifile;
begin
  if not(Dm_Main.GinBase1.Connected) or not(Dm_Main.GinBase2.Connected) then
    exit;

  FicIni := TIniFile.Create(ReperBase+'RegroupBase.ini');
  try
    FicIni.WriteString('Base1','Chemin',Edt_Base1.Text);
    FicIni.WriteString('Base1','Nom',Edt_Nom1.Text);
    FicIni.WriteString('Base2','Chemin',Edt_Base2.Text); 
    FicIni.WriteString('Base2','Nom',Edt_Nom2.Text);
  finally
    FreeAndNil(FicIni);
  end;
end;

procedure TFrm_Main.Chk_RestricClick(Sender: TObject);
begin
  Lab_Stock.Enabled := Chk_Restric.Checked;
  Lab_Date.Enabled := Chk_Restric.Checked;
  Dt_Analyse.Enabled := Chk_Restric.Checked;
end;

procedure TFrm_Main.DoConnexion1(OkMess: boolean);
var
  vVer: string;
begin
  Lab_OkConn1.Caption := 'Non connecté';
  Lab_OkConn1.Font.Color := clMaroon;  
  try
    Dm_Main.GinBase1.Connected := false;
    if (Edt_Base1.Text='') or not(FileExists(Edt_Base1.Text)) then
    begin
      if OkMess then
        MessageDlg('Base N° 1 non trouvé !',mterror,[mbok],0);
      exit;
    end;

    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Dm_Main.GinBase1.Database := Edt_Base1.Text;
      Dm_Main.GinBase1.Connected := true;
      vVer := '';
      with Dm_Main.Que_B1_Div, SQL do
      begin
        Active := false;
        Clear;
        Add('select * from genversion order by ver_date');
        Active:=true;
        Last;
        vVer := fieldbyname('VER_VERSION').AsString;
        Active := false;
      end;

      Lab_OkConn1.Caption := 'Connecté Ver '+vVer;
      Lab_OkConn1.Font.Color := clGreen;
      NomBase1 := ExtractFilePath(Edt_Base1.Text);
      if (NomBase1<>'') and (NomBase1[Length(NomBase1)]='\') then
        NomBase1 := Copy(NomBase1, 1, Length(NomBase1)-1);
      while pos('\',NomBase1)>0 do
        NomBase1 := Copy(NomBase1, pos('\',NomBase1)+1, Length(NomBase1));

      if Edt_Nom1.Text='' then
        Edt_Nom1.Text := NomBase1;
    except
      on E:Exception do
      begin
        if OkMess then
          MessageDlg('Base N° 1: '+E.Message, mterror,[mbok],0);
      end;
    end;
  finally
    DoPanelTraiteOk;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.DoConnexion2(OkMess: boolean);
var
  vVer: string;
begin
  Lab_OkConn2.Caption := 'Non connecté';
  Lab_OkConn2.Font.Color := clMaroon;
  try
    Dm_Main.GinBase2.Connected := false;
    if (Edt_Base2.Text='') or not(FileExists(Edt_Base2.Text)) then
    begin
      if OkMess then
        MessageDlg('Base N° 2 non trouvé !',mterror,[mbok],0);
      exit;
    end;

    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
    try
      Dm_Main.GinBase2.Database := Edt_Base2.Text;
      Dm_Main.GinBase2.Connected := true;
      vVer := '';
      with Dm_Main.Que_B2_Div, SQL do
      begin
        Active := false;
        Clear;
        Add('select * from genversion order by ver_date');
        Active:=true;
        Last;
        vVer := fieldbyname('VER_VERSION').AsString;
        Active := false;
      end;

      Lab_OkConn2.Caption := 'Connecté Ver '+vVer;
      Lab_OkConn2.Font.Color := clGreen;
      NomBase2 := ExtractFilePath(Edt_Base2.Text);
      if (NomBase2<>'') and (NomBase2[Length(NomBase2)]='\') then
        NomBase2 := Copy(NomBase2, 1, Length(NomBase2)-1);
      while pos('\',NomBase2)>0 do
        NomBase2 := Copy(NomBase2, pos('\',NomBase2)+1, Length(NomBase2));  

      if Edt_Nom2.Text='' then
        Edt_Nom2.Text := NomBase2;
    except
      on E:Exception do
      begin
        if OkMess then
          MessageDlg('Base N° 2: '+E.Message, mterror,[mbok],0);
      end;
    end;
  finally
    DoPanelTraiteOk;
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrm_Main.FormCreate(Sender: TObject);
begin
  Lab_Version.Caption := 'Ver. '+ApplicationVersion;
  Edt_Base1.Text := '';
  Edt_Nom1.Text := '';
  Edt_Base2.Text := '';
  Edt_Nom2.Text := ''; 
  DoConnexion1(false);
  DoConnexion2(false);
  Dt_Analyse.Date:=Trunc(Date)-90;  // 3 mois
  Chk_RestricClick(Chk_Restric);
end;

procedure TFrm_Main.Nbt_CompareMarkClick(Sender: TObject);
var
  lstMarqueBase1: TStringList;
  lstMarqueBase2: TStringList;
  lstMarqueResultat: TStringList;
  sNom: string;
  i: integer;
  iEtat: integer;
begin
  if (Trim(Edt_Nom1.Text)='') then
    Edt_Nom1.Text := NomBase1;
  if (Trim(Edt_Nom2.Text)='') then
    Edt_Nom2.Text := NomBase2;
  SauveConfig;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages; 
  lstMarqueBase1 := TStringList.Create;
  lstMarqueBase2 := TStringList.Create;
  lstMarqueResultat := TStringList.Create;
  try
    // vide la table Mem des marque
    Dm_Main.MemD_Marque.Active := false;
    Dm_Main.MemD_Marque.Active := true;
    Dm_Main.MemD_Marque.SortedField := '';

    // ajoute toutes les marques dans la première liste de la base 1
    with Dm_Main.Que_B1_Div, SQL do
    begin
      Close;
      Clear;
      //Add('SELECT MRK_NOM from ARTMARQUE');
      //Add(' join k on (K_ID=MRK_ID and K_ENABLED=1)');
      //Add('where MRK_ID<>0');

      Add('select distinct mrk_nom from artmarque');
      Add('join k on k_id=mrk_id and k_enabled=1');
      Add('join artarticle');
      Add('      join artreference on arf_artid=art_id and arf_archiver=0');
      Add(' on art_mrkid=mrk_id');
      Add('  where mrk_id<>0');


      Open;
      First;
      while not(Eof) do
      begin
        lstMarqueBase1.Add(fieldbyname('MRK_NOM').AsString);
        Next;
      end;
      Close;
    end;
    lstMarqueBase1.Sort;
    
    // ajoute toutes les marques dans la 2ème liste de la base 1
    with Dm_Main.Que_B2_Div, SQL do
    begin 
      Close;
      Clear;
      Add('SELECT MRK_NOM from ARTMARQUE');
      Add(' join k on (K_ID=MRK_ID and K_ENABLED=1)');
      Add('where MRK_ID<>0');
      Open;
      First;
      while not(Eof) do
      begin
        lstMarqueBase2.Add(fieldbyname('MRK_NOM').AsString);
        Next;
      end;
      Close;
    end;
    lstMarqueBase2.Sort;

    // valeur de iEtat:
    //       0 = present dans les 2 base
    //       1 = present uniquement dans Base1
    //       2 = present uniquement dans Base2

    // compare liste1 avec liste2
    for i:=1 to lstMarqueBase1.Count do
    begin
      sNom := lstMarqueBase1[i-1];
      if lstMarqueBase2.IndexOf(sNom)>=0 then
        iEtat := 0
      else
        iEtat := 1;
      lstMarqueResultat.Add(sNom+'|'+inttostr(iEtat));
    end;     

    // compare liste2 avec liste1 (uniquement si pas present ; pour iEtat=2)
    for i:=1 to lstMarqueBase2.Count do
    begin
      sNom := lstMarqueBase2[i-1];
      if lstMarqueBase1.IndexOf(sNom)<0 then
        lstMarqueResultat.Add(sNom+'|2');
    end;


    // insert dans la table mem des marques
    for i:=1 to lstMarqueResultat.Count do
    begin
      sNom := lstMarqueResultat[i-1];
      iEtat := StrToIntDef(copy(sNom,Pos('|',sNom)+1,Length(sNom)),-1);
      sNom:=Copy(sNom,1,Pos('|',sNom)-1);
      case iEtat of
        0:
        begin
          with Dm_Main.MemD_Marque do
          begin
            Append;
            fieldbyname('NomMarque').AsString := snom;
            fieldbyname('MarqueBase1').AsString := snom;
            fieldbyname('MarqueBase2').AsString := snom;
            Post;
          end;
        end; //1
        1:
        begin
          with Dm_Main.MemD_Marque do
          begin
            Append;
            fieldbyname('NomMarque').AsString := snom;
            fieldbyname('MarqueBase1').AsString := snom;
            fieldbyname('MarqueBase2').AsString := '';
            Post;
          end;
        end; //2
        2:
        begin 
          with Dm_Main.MemD_Marque do
          begin
            Append;
            fieldbyname('NomMarque').AsString := snom;
            fieldbyname('MarqueBase1').AsString := '';
            fieldbyname('MarqueBase2').AsString := snom;
            Post;
          end;
        end; //3
      end;

    end;

    Dm_Main.MemD_Marque.SortedField := 'NomMarque';

  finally                       
    Application.ProcessMessages;
    Screen.Cursor := crDefault;
  end;

  Frm_ComparMarq := TFrm_ComparMarq.Create(Self);
  try
    Frm_ComparMarq.SetInit(Edt_Nom1.Text,Edt_Nom2.Text);
    Frm_ComparMarq.ShowModal;
  finally
    FreeAndNil(Frm_ComparMarq);
  end;

end;

procedure TFrm_Main.Nbt_Conn1Click(Sender: TObject);
begin  
  Edt_Nom1.Text := '';
  DoConnexion1(true);
  SauveConfig;
end;

procedure TFrm_Main.Nbt_Conn2Click(Sender: TObject);
begin          
  Edt_Nom2.Text := '';
  DoConnexion2(true);
  SauveConfig;
end;

procedure TFrm_Main.Nbt_Ouvre1Click(Sender: TObject);
begin
  if OD_Base.Execute then
  begin
    Edt_Nom1.Text := '';
    Edt_Base1.Text := OD_Base.FileName;
    Nbt_Conn1Click(Nbt_Conn1);
    SauveConfig;
  end;
end;

procedure TFrm_Main.Nbt_Ouvre2Click(Sender: TObject);
begin 
  if OD_Base.Execute then
  begin          
    Edt_Nom2.Text := '';
    Edt_Base2.Text := OD_Base.FileName;
    Nbt_Conn2Click(Nbt_Conn2);  
    SauveConfig;
  end;
end;

procedure TFrm_Main.Nbt_RecupBaseClick(Sender: TObject);
var
  FicIni: TIniFile;
begin
  if not(fileExists(ReperBase+'RegroupBase.ini')) then
  begin
    MessageDlg('Aucune config. n''a été encore effectué !',mterror,[mbok],0);
    exit;
  end;

  FicIni := TIniFile.Create(ReperBase+'RegroupBase.ini');
  try
    Edt_Base1.Text := FicIni.ReadString('Base1','Chemin','');
    Edt_Nom1.Text := FicIni.ReadString('Base1','Nom','');
    Edt_Base2.Text := FicIni.ReadString('Base2','Chemin','');  
    Edt_Nom2.Text := FicIni.ReadString('Base2','Nom','');
  finally
    FreeAndNil(FicIni);
  end;
  
  DoConnexion1(true);
  DoConnexion2(true);

end;

function Ajoute64Blanc(AStr: string): string;
begin
  Result := AStr;
  while Length(Result)<64 do
    Result := Result+' ';
end;

function Maxi(AVal1, AVal2: integer): integer;
begin
  if AVal1>AVal2 then
    Result := AVal1
  else
    Result := AVal2;
end;

procedure TFrm_Main.Nbt_TailleClick(Sender: TObject);
var
  lstTaille1: TStringList;  // liste temporaire des tailles de la base 1
  lstTaille2: TStringList;  // liste temporaire des tailles de la base 2
  lstCoul1: TStringList;    // liste temporaire des couleurs de la base 1
  lstCoul2: TStringList;    // liste temporaire des couleurs de la base 2
  i: integer;
  FouId: integer;
  PxAch: Double;
  PxVte: Double;
  Nbre: integer;
  iNbSansRef: integer;
  bOkArt: boolean;
  bOkAjoutArt: boolean;  // test si on doit ajouter l'article (restriction par stock et date de création)
  sRefArt: string;
  iStk: integer;  // stock tous mag de l'article
  dArtCre: TDateTime; //date de création de l'article (utilisation de la table K)
begin 
  if (Trim(Edt_Nom1.Text)='') then
    Edt_Nom1.Text := NomBase1;
  if (Trim(Edt_Nom2.Text)='') then
    Edt_Nom2.Text := NomBase2;
  SauveConfig;

  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  VeuillezPatienter('Analyse des articles',0);
  AffichePatienter;
  Application.ProcessMessages;
  iNbSansRef := 1;
  lstTaille1 := TStringList.Create;
  lstTaille2 := TStringList.Create;
  lstCoul1 := TStringList.Create;
  lstCoul2 := TStringList.Create;
  try
    // liste des articles de la base 1 non pseudo, non archivés
    with Dm_Main.Que_B1_Div, SQL do
    begin
      Close;
      Clear;
      Add('select ART_ID,ART_SSFID,MRK_NOM,ART_REFMRK,ART_NOM,GTF_NOM,CAT_NOM,GRE_NOM,k.k_inserted from ARTARTICLE');
      Add(' join k k on (k_id=art_id and k_enabled=1)');
      Add(' join ARTREFERENCE on (arf_artid=art_id and arf_virtuel<>1 and arf_archiver<>1)');
      Add(' join ARTMARQUE on (MRK_ID=art_mrkid)');
      Add('  join PLXGTF on (gtf_id=art_gtfid)');
      Add(' join NKLCATEGORIE on (CAT_ID=ARF_CATID)');
      Add(' join ARTGENRE on (GRE_ID=ART_GREID)');
      Add(' where art_id<>0');
      Open;
      SetMaxProgress(RecordCount);
    end;

    // vide les table
    Dm_Main.MemD_ArtNouv.Close;
    Dm_Main.MemD_ArtNouv.Open;
    Dm_Main.MemD_ArtNouv.SortedField:='';
    Dm_Main.MemD_ArtNewDet.Close;
    Dm_Main.MemD_ArtNewDet.Open;
    Dm_Main.MemD_ArtNewDet.SortedField:='';
    Dm_Main.MemD_ArtAModif.Close;
    Dm_Main.MemD_ArtAModif.Open;
    Dm_Main.MemD_ArtAModif.SortedField:='';
    Dm_Main.MemD_MarqDiff.Close;
    Dm_Main.MemD_MarqDiff.Open;
    Dm_Main.MemD_MarqDiff.SortedField:='';

    // préparation requete dans base N° 2 pour rechercher marque et reference
    with Dm_Main.Que_B2_Div, SQL do
    begin
      Close;
      Clear;
      Add('select ARF_CHRONO, ART_ID,MRK_NOM,ART_REFMRK,ART_NOM,GTF_NOM from ARTARTICLE');
      Add(' join k on (k_id=art_id and k_enabled=1)');
      Add(' join ARTREFERENCE on (arf_artid=art_id and arf_virtuel<>1 and arf_archiver<>1)');
      Add(' join ARTMARQUE on (MRK_ID=art_mrkid)');
      Add(' join PLXGTF on (gtf_id=art_gtfid)');
      //Add('where art_id<>0 and (MRK_NOM=:MRKNOM) and (ART_REFMRK=:ARTREFMRK)');
      Add('where art_id<>0 and (ART_REFMRK=:ARTREFMRK)');
    end;

    Dm_Main.Que_B1_Div.First;
    while not(Dm_Main.Que_B1_Div.Eof) do
    begin
    
      // date de création
      dArtCre := Dm_Main.Que_B1_Div.FieldByName('k_inserted').AsDateTime;

      // stock tous mag
      with Dm_Main.Que_B1_Stock do
      begin
        Close;
        ParamByName('ARTID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
        Open;
        iStk := fieldbyname('QTE').AsInteger;
        Close;
      end;

      // restriction d'analyse
      bOkAjoutArt := true;
      if Chk_Restric.Checked then
      begin
        if iStk<=0 then
          bOkAjoutArt := (Trunc(dArtCre)>Trunc(Dt_Analyse.DateTime));
      end;

      bOkArt := false;
      if Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString<>'' then
      begin
        // recherche si article de la base 1 correspond à un article de la base 2
        Dm_Main.Que_B2_Div.Close;
        // Dm_Main.Que_B2_Div.ParamByName('MRKNOM').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
        Dm_Main.Que_B2_Div.ParamByName('ARTREFMRK').AsString := Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
        Dm_Main.Que_B2_Div.Open;
        Dm_Main.Que_B2_Div.First;
        bOkArt := not(Dm_Main.Que_B2_Div.Eof);
      end;

      if bOkArt then
      begin        //les articles correspondent

        // ref identique et marque différent
        if Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString<>Dm_Main.Que_B2_Div.fieldbyname('MRK_NOM').AsString then
        begin
          // remplie la liste avec les tailles travaillées de l'article de la base2
          lstTaille1.Clear;
          lstTaille2.Clear;
          Dm_Main.Que_B2_Taille.Close;
          Dm_Main.Que_B2_Taille.ParamByName('ART_ID').AsInteger := Dm_Main.Que_B2_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B2_Taille.Open;
          Dm_Main.Que_B2_Taille.First;
          while not(Dm_Main.Que_B2_Taille.Eof) do
          begin
            lstTaille2.Add(Dm_Main.Que_B2_Taille.fieldbyname('TGF_NOM').AsString);
            Dm_Main.Que_B2_Taille.Next;
          end;
          Dm_Main.Que_B2_Taille.Close;

          // recherche les tailles non presentes dans la base 2
          Dm_Main.Que_B1_Taille.Close;
          Dm_Main.Que_B1_Taille.ParamByName('ART_ID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B1_Taille.Open;
          Dm_Main.Que_B1_Taille.First;
          while not(Dm_Main.Que_B1_Taille.Eof) do
          begin
            if lstTaille2.IndexOf(Dm_Main.Que_B1_Taille.fieldbyname('TGF_NOM').AsString)<0 then
              lstTaille1.Add(Dm_Main.Que_B1_Taille.fieldbyname('TGF_NOM').AsString);
            Dm_Main.Que_B1_Taille.Next;
          end;
          Dm_Main.Que_B2_Taille.Close;
                            
          // remplie la liste avec les couleurs de l'article de la base2
          lstCoul1.Clear;
          lstCoul2.Clear;
          Dm_Main.Que_B2_Couleur.Close;
          Dm_Main.Que_B2_Couleur.ParamByName('ARTID').AsInteger := Dm_Main.Que_B2_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B2_Couleur.Open;
          Dm_Main.Que_B2_Couleur.First;
          while not(Dm_Main.Que_B2_Couleur.Eof) do
          begin
            lstCoul2.Add(Dm_Main.Que_B2_Couleur.fieldbyname('COUNOM').AsString);
            Dm_Main.Que_B2_Couleur.Next;
          end;
          Dm_Main.Que_B2_Couleur.Close;
                            
          // recherche les couleurs non presentes dans la base 2
          Dm_Main.Que_B1_Couleur.Close;
          Dm_Main.Que_B1_Couleur.ParamByName('ARTID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B1_Couleur.Open;
          Dm_Main.Que_B1_Couleur.First;
          while not(Dm_Main.Que_B1_Couleur.Eof) do
          begin
            if lstCoul2.IndexOf(Dm_Main.Que_B1_Couleur.fieldbyname('COUNOM').AsString)<0 then
              lstCoul1.Add(Dm_Main.Que_B1_Couleur.fieldbyname('COUNOM').AsString);
            Dm_Main.Que_B1_Couleur.Next;
          end;
          Dm_Main.Que_B1_Couleur.Close;

          with Dm_Main.MemD_MarqDiff do
          begin
            // Chrono
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Chrono dans la base '+Edt_Nom2.Text+' : ';
            fieldbyname('Info').AsString := Dm_Main.Que_B2_Div.fieldbyname('ARF_CHRONO').AsString;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;

            // marque 1
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Marque dans la base '+Edt_Nom1.Text+' : ';
            fieldbyname('Info').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;       

            // marque 2
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Marque dans la base '+Edt_Nom2.Text+' : ';
            fieldbyname('Info').AsString := Dm_Main.Que_B2_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;

            // Nom article
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Nom de l''article dans la base '+Edt_Nom2.Text+' : ';
            fieldbyname('Info').AsString := Dm_Main.Que_B2_Div.fieldbyname('ART_NOM').AsString;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;

            // taille à compléter
            if lstTaille1.Count>0 then
            begin
              for i:=1 to lstTaille1.Count do
              begin
                Append;
                fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
                fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
                fieldbyname('TypeInfo').AsString := '2 - Taille à compléter';
                fieldbyname('Libelle').AsString := '';
                fieldbyname('Info').AsString := lstTaille1[i-1];
                fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                                Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                                Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
                Post;
              end;

            end;

            // couleur à compléter
            if lstCoul1.Count>0 then
            begin
              for i:=1 to lstCoul1.Count do
              begin
                Append;
                fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
                fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
                fieldbyname('TypeInfo').AsString := '3 - Couleur à compléter';
                fieldbyname('Libelle').AsString := '';
                fieldbyname('Info').AsString := lstCoul1[i-1];
                fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                                Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                                Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
                Post;
              end;

            end;

          end;
        end
        else   // ref et marque identique
        begin   
          // remplie la liste avec les tailles travaillées de l'article de la base2
          lstTaille1.Clear;
          lstTaille2.Clear;
          Dm_Main.Que_B2_Taille.Close;
          Dm_Main.Que_B2_Taille.ParamByName('ART_ID').AsInteger := Dm_Main.Que_B2_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B2_Taille.Open;
          Dm_Main.Que_B2_Taille.First;
          while not(Dm_Main.Que_B2_Taille.Eof) do
          begin
            lstTaille2.Add(Dm_Main.Que_B2_Taille.fieldbyname('TGF_NOM').AsString);
            Dm_Main.Que_B2_Taille.Next;
          end;
          Dm_Main.Que_B2_Taille.Close;

          // recherche les tailles non presentes dans la base 2
          Dm_Main.Que_B1_Taille.Close;
          Dm_Main.Que_B1_Taille.ParamByName('ART_ID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B1_Taille.Open;
          Dm_Main.Que_B1_Taille.First;
          while not(Dm_Main.Que_B1_Taille.Eof) do
          begin
            if lstTaille2.IndexOf(Dm_Main.Que_B1_Taille.fieldbyname('TGF_NOM').AsString)<0 then
              lstTaille1.Add(Dm_Main.Que_B1_Taille.fieldbyname('TGF_NOM').AsString);
            Dm_Main.Que_B1_Taille.Next;
          end;
          Dm_Main.Que_B2_Taille.Close;
                            
          // remplie la liste avec les couleurs de l'article de la base2
          lstCoul1.Clear;
          lstCoul2.Clear;
          Dm_Main.Que_B2_Couleur.Close;
          Dm_Main.Que_B2_Couleur.ParamByName('ARTID').AsInteger := Dm_Main.Que_B2_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B2_Couleur.Open;
          Dm_Main.Que_B2_Couleur.First;
          while not(Dm_Main.Que_B2_Couleur.Eof) do
          begin
            lstCoul2.Add(Dm_Main.Que_B2_Couleur.fieldbyname('COUNOM').AsString);
            Dm_Main.Que_B2_Couleur.Next;
          end;
          Dm_Main.Que_B2_Couleur.Close;
                            
          // recherche les couleurs non presentes dans la base 2
          Dm_Main.Que_B1_Couleur.Close;
          Dm_Main.Que_B1_Couleur.ParamByName('ARTID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
          Dm_Main.Que_B1_Couleur.Open;
          Dm_Main.Que_B1_Couleur.First;
          while not(Dm_Main.Que_B1_Couleur.Eof) do
          begin
            if lstCoul2.IndexOf(Dm_Main.Que_B1_Couleur.fieldbyname('COUNOM').AsString)<0 then
              lstCoul1.Add(Dm_Main.Que_B1_Couleur.fieldbyname('COUNOM').AsString);
            Dm_Main.Que_B1_Couleur.Next;
          end;
          Dm_Main.Que_B1_Couleur.Close;

          if (lstCoul1.Count<>0) and (lstTaille1.Count<>0) then  // couleur et/ou taille à compléter
          begin
            with Dm_Main.MemD_ArtAModif do
            begin
              // Chrono
              Append;
              fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
              fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
              fieldbyname('TypeInfo').AsString := '1 - Détail';
              fieldbyname('Libelle').AsString := 'Chrono dans la base '+Edt_Nom2.Text+' : ';
              fieldbyname('Info').AsString := Dm_Main.Que_B2_Div.fieldbyname('ARF_CHRONO').AsString;
              fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                              Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                              Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
              Post;

              // Nom article
              Append;
              fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
              fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
              fieldbyname('TypeInfo').AsString := '1 - Détail';
              fieldbyname('Libelle').AsString := 'Nom de l''article dans la base '+Edt_Nom2.Text+' : ';
              fieldbyname('Info').AsString := Dm_Main.Que_B2_Div.fieldbyname('ART_NOM').AsString;
              fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                              Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                              Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
              Post;

              // taille à compléter
              if lstTaille1.Count>0 then
              begin
                for i:=1 to lstTaille1.Count do
                begin
                  Append;
                  fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
                  fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
                  fieldbyname('TypeInfo').AsString := '2 - Taille à compléter';
                  fieldbyname('Libelle').AsString := '';
                  fieldbyname('Info').AsString := lstTaille1[i-1];
                  fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                                  Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                                  Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
                  Post;
                end;

              end;

              // couleur à compléter
              if lstCoul1.Count>0 then
              begin
                for i:=1 to lstCoul1.Count do
                begin
                  Append;
                  fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
                  fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
                  fieldbyname('TypeInfo').AsString := '3 - Couleur à compléter';
                  fieldbyname('Libelle').AsString := '';
                  fieldbyname('Info').AsString := lstCoul1[i-1];
                  fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                                  Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                                  Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
                  Post;
                end;

              end;

            end;
          end;   //if (lstCoul1.Count<>0) and (lstTaille1.Count<>0) then
        end;  // else if
      end
      else
      begin
        // ajoute un nouvel article si pas de restriction

        if bOkAjoutArt then
        begin
          with Dm_Main.Que_B1_Div2, SQL do
          begin
            // Fournisseur prin
            Close;
            Clear;
            Add('SELECT CLG_FOUID FROM TARCLGFOURN');
            Add('    JOIN K ON (K_ID=CLG_ID AND K_ENABLED=1)');
            Add('    JOIN ARTFOURN ON (FOU_ID=CLG_FOUID)');
            Add('    WHERE');
            Add('    CLG_ARTID='+inttostr(Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger)+' AND');
            Add('    CLG_TGFID=0 and CLG_PRINCIPAL=1');
            Add('    GROUP BY');
            Add('    CLG_FOUID,');
            Add('    CLG_PRINCIPAL,');
            Add('    FOU_NOM,');
            Add('    FOU_IDREF');
            Open;
            FouID := fieldbyname('CLG_FOUID').AsInteger;
            Close;

            // extraction des tarifs
            Close;
            Clear;
            Add('SELECT * FROM RV_TARCLGFOURN('+inttostr(Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger)+','+
                         inttostr(FouID)+', 0)');
            Add('where clg_tgfid=0'); 
            Add('ORDER BY TGF_ORDREAFF');
            Open;
            PxAch := fieldbyname('CLG_PXNEGO').AsFloat;
            PxVte := fieldbyname('PVTE').AsFloat;
            Close;

          end;
        
          with Dm_Main.Que_NK do
          begin
            Close;
            ParamByName('ARTSSFID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_SSFID').AsInteger;
            Open;
          end;

          sRefArt := Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
          if sRefArt='' then
          begin
            sRefArt:='<Sans Réf. N° '+inttostr(iNbSansRef)+'>';
            inc(iNbSansRef);
          end;

          // ajoute un nouvel article
          with Dm_Main.MemD_ArtNouv do
          begin
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := sRefArt;
            fieldbyname('Libelle').AsString := Dm_Main.Que_B1_Div.fieldbyname('ART_NOM').AsString;
            fieldbyname('Info').AsString := Dm_Main.Que_B1_Div.fieldbyname('GTF_NOM').AsString;
            fieldbyname('PxAch').AsFloat := PxAch;
            fieldbyname('PxVen').AsFloat := PxVte;
            fieldbyname('Rayon').AsString := Dm_Main.Que_NK.fieldbyname('RAY_NOM').AsString;
            fieldbyname('Famille').AsString := Dm_Main.Que_NK.fieldbyname('FAM_NOM').AsString;
            fieldbyname('SFamille').AsString := Dm_Main.Que_NK.fieldbyname('SSF_NOM').AsString;

            fieldbyname('Secteur').AsString := Dm_Main.Que_NK.fieldbyname('SEC_NOM').AsString;
            fieldbyname('categ').AsString := Dm_Main.Que_NK.fieldbyname('CTF_NOM').AsString;
            fieldbyname('SCateg').AsString := Dm_Main.Que_B1_Div.fieldbyname('CAT_NOM').AsString;
            fieldbyname('Genre').AsString := Dm_Main.Que_B1_Div.fieldbyname('GRE_NOM').AsString;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Dm_Main.Que_B1_Div.fieldbyname('ART_NOM').AsString;
            fieldbyname('Stock').AsInteger := iStk;
            fieldbyname('DatCre').AsDateTime := dArtCre;
            Post;
          end;


          // ajoute un nouvel article détaillée
          with Dm_Main.MemD_ArtNewDet do
          begin
            // liste des tailles travaillées
            lstTaille1.Clear;
            Dm_Main.Que_B1_Taille.Close;
            Dm_Main.Que_B1_Taille.ParamByName('ART_ID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
            Dm_Main.Que_B1_Taille.Open;
            Dm_Main.Que_B1_Taille.First;
            while not(Dm_Main.Que_B1_Taille.Eof) do
            begin
              lstTaille1.Add(Dm_Main.Que_B1_Taille.fieldbyname('TGF_NOM').AsString);
              Dm_Main.Que_B1_Taille.Next;
            end;
            Dm_Main.Que_B1_Taille.Close;
                                      
            // liste des Couleurs
            lstCoul1.Clear;
            Dm_Main.Que_B1_Couleur.Close;
            Dm_Main.Que_B1_Couleur.ParamByName('ARTID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
            Dm_Main.Que_B1_Couleur.Open;
            Dm_Main.Que_B1_Couleur.First;
            while not(Dm_Main.Que_B1_Couleur.Eof) do
            begin
              lstCoul1.Add(Dm_Main.Que_B1_Couleur.fieldbyname('COUNOM').AsString);
              Dm_Main.Que_B1_Couleur.Next;
            end;
            Dm_Main.Que_B1_Couleur.Close;


            Nbre := Maxi(lstTaille1.Count, lstCoul1.Count);
            if Nbre<1 then
              Nbre := 1;
            for i:= 1 to Nbre do
            begin 
              Append;
              fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
              fieldbyname('Ref').AsString := sRefArt;
              if i=1 then
              begin
                fieldbyname('Libelle').AsString := Dm_Main.Que_B1_Div.fieldbyname('ART_NOM').AsString;
                fieldbyname('Info').AsString := Dm_Main.Que_B1_Div.fieldbyname('GTF_NOM').AsString;
                fieldbyname('PxAch').AsFloat := PxAch;
                fieldbyname('PxVen').AsFloat := PxVte;
                fieldbyname('Rayon').AsString := Dm_Main.Que_NK.fieldbyname('RAY_NOM').AsString;
                fieldbyname('Famille').AsString := Dm_Main.Que_NK.fieldbyname('FAM_NOM').AsString;
                fieldbyname('SFamille').AsString := Dm_Main.Que_NK.fieldbyname('SSF_NOM').AsString;
              
                fieldbyname('Secteur').AsString := Dm_Main.Que_NK.fieldbyname('SEC_NOM').AsString;
                fieldbyname('categ').AsString := Dm_Main.Que_NK.fieldbyname('CTF_NOM').AsString;
                fieldbyname('SCateg').AsString := Dm_Main.Que_B1_Div.fieldbyname('CAT_NOM').AsString;
                fieldbyname('Genre').AsString := Dm_Main.Que_B1_Div.fieldbyname('GRE_NOM').AsString;  
                fieldbyname('Stock').AsInteger := iStk;
                fieldbyname('DatCre').AsDateTime := dArtCre;
              end;
              if i<=lstTaille1.Count then
                fieldbyname('TailleTrav').AsString := lstTaille1[i-1];
              if i<=lstCoul1.Count then
                fieldbyname('Couleur').AsString := lstCoul1[i-1];
              fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                              Ajoute64Blanc(fieldbyname('Ref').AsString);
              Post;
            end;
        
           (*  // Nom article
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := Dm_Main.Que_B1_Div.fieldbyname('ART_NOM').AsString;
            fieldbyname('Info').AsString := Dm_Main.Que_B1_Div.fieldbyname('GTF_NOM').AsString;
            fieldbyname('PxAch').AsFloat := PxAch;
            fieldbyname('PxVen').AsFloat := PxVte;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;  *)

          (* // Nom article
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Nom de l''article : ';
            fieldbyname('Info').AsString := Dm_Main.Que_B1_Div.fieldbyname('ART_NOM').AsString;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;

            // Grille de tailles  
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Grille de taille : ';
            fieldbyname('Info').AsString :=  Dm_Main.Que_B1_Div.fieldbyname('GTF_NOM').AsString;
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);

            // px Achat
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Px Achat : ';
            fieldbyname('Info').AsString := FormatFloat('#,##0.00',PxAch);
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;    

            // px Vente
            Append;
            fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
            fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
            fieldbyname('TypeInfo').AsString := '1 - Détail';
            fieldbyname('Libelle').AsString := 'Px Vente : ';
            fieldbyname('Info').AsString := FormatFloat('#,##0.00',PxVte);
            fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                            Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                            Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
            Post;   *)

          (*  // liste des tailles travaillées
            Dm_Main.Que_B1_Taille.Close;
            Dm_Main.Que_B1_Taille.ParamByName('ART_ID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
            Dm_Main.Que_B1_Taille.Open;
            Dm_Main.Que_B1_Taille.First;
            while not(Dm_Main.Que_B1_Taille.Eof) do
            begin
              Append;
              fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
              fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
              fieldbyname('TypeInfo').AsString := '2 - Tailles travaillées';
              fieldbyname('Libelle').AsString := '';
              fieldbyname('Info').AsString := Dm_Main.Que_B1_Taille.fieldbyname('TGF_NOM').AsString;
              fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                              Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                              Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
              Post;
              Dm_Main.Que_B1_Taille.Next;
            end;
            Dm_Main.Que_B1_Taille.Close;

            // liste des Couleurs
            Dm_Main.Que_B1_Couleur.Close;
            Dm_Main.Que_B1_Couleur.ParamByName('ARTID').AsInteger := Dm_Main.Que_B1_Div.fieldbyname('ART_ID').AsInteger;
            Dm_Main.Que_B1_Couleur.Open;
            Dm_Main.Que_B1_Couleur.First;
            while not(Dm_Main.Que_B1_Couleur.Eof) do
            begin     
              Append;
              fieldbyname('Marque').AsString := Dm_Main.Que_B1_Div.fieldbyname('MRK_NOM').AsString;
              fieldbyname('Ref').AsString := 'Réf. : '+Dm_Main.Que_B1_Div.fieldbyname('ART_REFMRK').AsString;
              fieldbyname('TypeInfo').AsString := '3 - Couleurs';
              fieldbyname('Libelle').AsString := '';
              fieldbyname('Info').AsString := Dm_Main.Que_B1_Couleur.fieldbyname('COUNOM').AsString;
              fieldbyname('OrdreListe').AsString := Ajoute64Blanc(fieldbyname('Marque').AsString)+
                                              Ajoute64Blanc(fieldbyname('Ref').AsString)+
                                              Ajoute64Blanc(fieldbyname('TypeInfo').AsString);
              Post;
              Dm_Main.Que_B1_Couleur.Next;
            end;
            Dm_Main.Que_B1_Couleur.Close;   *)

          end;
        end;  // ajoute un article
      end;

      AvanceProgress;
      Dm_Main.Que_B1_Div.Next;
    end;  // while not(Dm_Main.Que_B1_Div.Eof)..

    Dm_Main.Que_B2_Div.Close;

    Dm_Main.MemD_ArtNouv.SortedField:='OrdreListe';  
    Dm_Main.MemD_ArtNouv.First;

    Dm_Main.MemD_ArtNewDet.SortedField:='OrdreListe';
    Dm_Main.MemD_ArtNewDet.First;

    Dm_Main.MemD_ArtAModif.SortedField:='OrdreListe';
    Dm_Main.MemD_ArtAModif.First;
    

    Dm_Main.MemD_MarqDiff.SortedField:='OrdreListe';
    Dm_Main.MemD_MarqDiff.First;

  finally  
    FreeAndNil(lstTaille1);
    FreeAndNil(lstTaille2);
    FreeAndNil(lstCoul1);
    FreeAndNil(lstCoul2);
    Dm_Main.Que_B1_Div.Close;
    Dm_Main.Que_B2_Div.Close;
    Dm_Main.Que_NK.Close;
    FermerPatienter;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
  end;


                                                         
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  Frm_AnalyseArticle := TFrm_AnalyseArticle.Create(Self); 
  Screen.Cursor := crDefault;
  Application.ProcessMessages;
  try                             
    Frm_AnalyseArticle.SetInit(Edt_Nom1.Text,Edt_Nom2.Text);
    Frm_AnalyseArticle.ShowModal; 
    Application.ProcessMessages;
  finally
    freeAndNil(Frm_AnalyseArticle);
  end;
end;

end.
