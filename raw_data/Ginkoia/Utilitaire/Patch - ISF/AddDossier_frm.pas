unit AddDossier_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, ExtCtrls, ClassDossier, RzGroupBar, uThreadProc,
  StdCtrls;

type
  TFrm_AddDossier = class(TForm)
    Pan_BasPage: TPanel;
    Pan_Resultat: TPanel;
    lv_dossiers: TListView;
    Nbt_LancerRecherche: TSpeedButton;
    Nbt_AjouterDossier: TSpeedButton;
    Nbt_Check: TSpeedButton;
    RzGroupBar1: TRzGroupBar;
    Grp_Centrales: TRzGroup;
    Grp_Versions: TRzGroup;
    Grp_Modules: TRzGroup;
    lv_modules: TListView;
    lv_versions: TListView;
    Lv_Centrales: TListView;
    Pan_Centrales: TPanel;
    Pan_Modules: TPanel;
    Pan_Versions: TPanel;
    Chk_ActiveVT: TCheckBox;
    procedure Nbt_AjouterDossierClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Nbt_LancerRechercheClick(Sender: TObject);
    procedure Nbt_CheckClick(Sender: TObject);
    procedure lv_dossiersDblClick(Sender: TObject);
    procedure Lv_CentralesDblClick(Sender: TObject);
    procedure lv_versionsDblClick(Sender: TObject);
    procedure lv_modulesDblClick(Sender: TObject);
    procedure Lv_CentralesItemChecked(Sender: TObject; Item: TListItem);
    procedure lv_versionsItemChecked(Sender: TObject; Item: TListItem);
    procedure lv_modulesItemChecked(Sender: TObject; Item: TListItem);
    procedure FormShow(Sender: TObject);
    procedure lv_versionsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lv_dossiersColumnClick(Sender: TObject; Column: TListColumn);
    procedure lv_dossiersCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lv_dossiersKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Chk_ActiveVTClick(Sender: TObject);
  private
    { Déclarations privées }
    Dossiers : TDossiers;
    DatabaseOpen : boolean;
    sortColumn : integer;
    procedure LancerRecherche;
    procedure LoadCentrales;
    procedure LoadVersions;
    procedure LoadModules;
    function getCentrales : string;
    function getVersions : string;
    function getModules : string;
    procedure lv_DblClick(lv: TListView);
    procedure lv_ItemChecked(lv: TListView; GroupBar: TRzGroup);
    procedure doLancerRecherche;
    procedure doLoadCentrales;
    procedure doLoadVersions;
    procedure doLoadModules;
    procedure FinalisationLoad(visible, onSearch : boolean);
    procedure Trier_lv_version;
    procedure Msg(sMsg : string);
    function FindListViewItem(lv: TListView; const S: string;
      column: Integer): TListItem;
  public
    { Déclarations publiques }
  end;

var
  Frm_AddDossier: TFrm_AddDossier;

function ExecuteChercheDossiers : TDossiers ;

implementation

uses uguid;

{$R *.dfm}

function ExecuteChercheDossiers : TDossiers ;
var
  AddDossier : TFrm_AddDossier ;
begin
  Result := nil ;
  try
    Application.createform(TFrm_AddDossier, AddDossier);
    AddDossier.Pan_BasPage.Color := clWebLightBlue;
    AddDossier.Pan_Resultat.Color := clWebLightBlue;
    AddDossier.Pan_Centrales.Color := clWebLightBlue;
    AddDossier.Pan_Modules.Color := clWebLightBlue;
    AddDossier.Pan_Versions.Color := clWebLightBlue;
    if AddDossier.ShowModal = mrOk then
    begin
      Result := AddDossier.Dossiers;
    end ;
  except
    Result := nil ;
  end;
end;

procedure TFrm_AddDossier.doLoadCentrales;
var
  aListCentrale : TListCentrales;
  ListItem : TListItem;
begin
  uguid.Form1.QrySelectMaintenance.Close;
  uguid.Form1.QrySelectMaintenance.SQL.Text:= 'select * from GROUPE where grou_id <> 0 order by grou_nom';
  uguid.Form1.QrySelectMaintenance.Open;
  Lv_Centrales.Items.Clear;
  uguid.Form1.QrySelectMaintenance.First;
  while not uguid.Form1.QrySelectMaintenance.eof do
  begin
    aListCentrale := TListCentrales.Create;
    aListCentrale.Nom := uguid.Form1.QrySelectMaintenance.FieldByName('GROU_NOM').AsString;
    aListCentrale.Id := uguid.Form1.QrySelectMaintenance.FieldByName('GROU_ID').AsInteger;
    ListItem := Lv_Centrales.Items.Add;
    ListItem.SubItems.add(aListCentrale.Nom);
    ListItem.SubItems.add(inttostr(aListCentrale.Id));
    uguid.Form1.QrySelectMaintenance.Next;
  end;
end;

procedure TFrm_AddDossier.doLoadModules;
var
  aListModules : TListModules;
  ListItem : TListItem;
begin
  uguid.Form1.QrySelectMaintenance.Close;
  uguid.Form1.QrySelectMaintenance.SQL.Text:= 'select * from Modules where modu_id <> 0 order by modu_nom';
  uguid.Form1.QrySelectMaintenance.Open;
  lv_modules.Items.Clear;
  uguid.Form1.QrySelectMaintenance.First;
  while not uguid.Form1.QrySelectMaintenance.eof do
  begin
    aListModules := TListModules.Create;
    aListModules.Nom := uguid.Form1.QrySelectMaintenance.FieldByName('MODU_NOM').AsString;
    aListModules.Id := uguid.Form1.QrySelectMaintenance.FieldByName('MODU_ID').AsInteger;
    ListItem := lv_modules.Items.Add;
    ListItem.SubItems.add(aListModules.Nom);
    ListItem.SubItems.add(inttostr(aListModules.Id));
    uguid.Form1.QrySelectMaintenance.Next;
  end;
end;

procedure TFrm_AddDossier.doLoadVersions;
var
  aListVersions : TListVersions;
  ListItem : TListItem;
begin
  try
    uguid.Form1.QrySelectMaintenance.Close;
    if Chk_ActiveVT.Checked
      then uguid.Form1.QrySelectMaintenance.SQL.Text:= 'select * from Version where vers_id <> 0 order by vers_id'
      else uguid.Form1.QrySelectMaintenance.SQL.Text:= 'select * from Version where vers_id <> 0 and VERS_NOMVERSION not like ''%VT%'' order by vers_id';
    uguid.Form1.QrySelectMaintenance.Open;
    lv_versions.Items.Clear;
    uguid.Form1.QrySelectMaintenance.First;
    while not uguid.Form1.QrySelectMaintenance.eof do
    begin


      aListVersions := TListVersions.Create;
      aListVersions.Nom := uguid.Form1.QrySelectMaintenance.FieldByName('VERS_NOMVERSION').AsString;
      aListVersions.Id := uguid.Form1.QrySelectMaintenance.FieldByName('VERS_ID').AsInteger;
      ListItem := lv_versions.Items.Add;
      ListItem.SubItems.add(aListVersions.Nom);
      ListItem.SubItems.add(inttostr(aListVersions.Id));

      uguid.Form1.QrySelectMaintenance.Next;
    end;
  except
  end;
  Trier_lv_version;
end;

procedure TFrm_AddDossier.FinalisationLoad(visible, onSearch : boolean);
begin
  if onSearch then
    lv_dossiers.Visible := visible
  else
  begin
    lv_modules.Visible := visible;
    Lv_Centrales.Visible := visible;
    lv_versions.Visible := visible;
  end;
  Nbt_Check.Visible := visible;
  Nbt_AjouterDossier.Visible := visible;
  Nbt_LancerRecherche.Visible := visible;
end;

procedure TFrm_AddDossier.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not DatabaseOpen then
    uguid.Form1.DB_MAINTENANCE.close;
end;

procedure TFrm_AddDossier.FormShow(Sender: TObject);
begin
  Dossiers := TDossiers.Create();
  DatabaseOpen := uguid.Form1.DB_MAINTENANCE.Connected;
  if not DatabaseOpen then
  begin
    uguid.Form1.DB_MAINTENANCE.DatabaseName:= uguid.Form1.DatabaseNameMaintenance;
    uguid.Form1.DB_MAINTENANCE.Open;
  end;

  FinalisationLoad(false, false);
  loadCentrales;
end;

function TFrm_AddDossier.getCentrales: string;
var
  i : integer;
  li : TListItem;
  sTmp : string;
begin
  sTmp := '';
  result := '';
  try
    for i := 0 to Lv_Centrales.Items.Count - 1 do
    begin
      li := Lv_Centrales.Items[i];
      if li.Checked then
      begin
        if sTmp <> '' then
          sTmp := sTmp + ', ';
        sTmp := sTmp + li.SubItems[1];
      end;
    end;
  finally
    if sTmp <> '' then
      result := sTmp;
  end;
end;

function TFrm_AddDossier.getModules: string;
var
  i : integer;
  li : TListItem;
  sTmp : string;
begin
  sTmp := '';
  result := '';
  try
    for i := 0 to lv_modules.Items.Count - 1 do
    begin
      li := lv_modules.Items[i];
      if li.Checked then
      begin
        if sTmp <> '' then
          sTmp := sTmp + ', ';
        sTmp := sTmp + li.SubItems[1];
      end;
    end;
  finally
    if sTmp <> '' then
      result := sTmp;
  end;
end;

function TFrm_AddDossier.getVersions: string;
var
  i : integer;
  li : TListItem;
  sTmp : string;
begin
  sTmp := '';
  result := '';
  try
    for i := 0 to lv_versions.Items.Count - 1 do
    begin
      li := lv_versions.Items[i];
      if li.Checked then
      begin
        if sTmp <> '' then
          sTmp := sTmp + ', ';
        sTmp := sTmp + li.SubItems[1];
      end;
    end;
  finally
    if sTmp <> '' then
      result := sTmp;
  end;
end;

procedure TFrm_AddDossier.Chk_ActiveVTClick(Sender: TObject);
begin
  doLoadVersions;
end;

procedure TFrm_AddDossier.doLancerRecherche;
var
  ListItem : TListItem;
  CriModules, CriCentrales, CriVersions : String;
  Where : string;
begin
  uguid.Form1.QrySelectMaintenance.Close;
  uguid.Form1.QrySelectMaintenance.SQL.clear;
  uguid.Form1.QrySelectMaintenance.SQL.add('select distinct doss_database, grou_id, grou_Nom, vers_version, serv_nom, doss_chemin ');
  uguid.Form1.QrySelectMaintenance.SQL.add('from DOSSIER ');
  uguid.Form1.QrySelectMaintenance.SQL.add('join Groupe on doss_grouid = grou_id ');
  uguid.Form1.QrySelectMaintenance.SQL.add('join serveur on doss_servid = serv_id ');
  uguid.Form1.QrySelectMaintenance.SQL.add('join magasins on maga_dossid = doss_id ');
  uguid.Form1.QrySelectMaintenance.SQL.add('join emetteur on emet_dossid = doss_id ');
  uguid.Form1.QrySelectMaintenance.SQL.add('join version on emet_versid = vers_id ');
  uguid.Form1.QrySelectMaintenance.SQL.add('join MODULES_MAGASINS on maga_id = mmag_magaid ');
  CriModules := getModules;
  CriCentrales := getCentrales;
  CriVersions := getVersions;
  if (CriModules <> '') or (CriCentrales <> '') or (CriVersions <> '') then
  begin
    uguid.Form1.QrySelectMaintenance.SQL.add(' where ');
    Where := '';
    if (CriModules <> '') then
    begin
      Where := ' mmag_moduid in (' + CriModules + ') ';
    end;
    if (CriCentrales <> '') then
    begin
      if Where <> '' then
        Where := Where + ' and ';
      Where := Where + ' grou_id in (' + CriCentrales + ') ';
    end;
    if (CriVersions <> '') then
    begin
      if Where <> '' then
        Where := Where + ' and ';
      Where := Where + ' vers_id in (' + CriVersions + ') ';
    end;
  end;
  if Where <> '' then
    uguid.Form1.QrySelectMaintenance.SQL.add(Where);
  //uguid.Form1.QrySelectMaintenance.SQL.SaveToFile('c:\t.txt');
  uguid.Form1.QrySelectMaintenance.Open;
  lv_dossiers.Items.Clear;
  uguid.Form1.QrySelectMaintenance.First;
  while not uguid.Form1.QrySelectMaintenance.eof do
  begin
    ListItem := lv_dossiers.Items.Add;
    ListItem.SubItems.add(uguid.Form1.QrySelectMaintenance.FieldByName('DOSS_DATABASE').AsString);
    ListItem.SubItems.add(uguid.Form1.QrySelectMaintenance.FieldByName('GROU_NOM').asString);
    ListItem.SubItems.add(uguid.Form1.QrySelectMaintenance.FieldByName('VERS_VERSION').AsString);
    ListItem.SubItems.add(uguid.Form1.QrySelectMaintenance.FieldByName('SERV_NOM').AsString);
    ListItem.SubItems.add(uguid.Form1.QrySelectMaintenance.FieldByName('DOSS_CHEMIN').AsString);
    ListItem.SubItems.add(uguid.Form1.QrySelectMaintenance.FieldByName('GROU_ID').AsString);
    uguid.Form1.QrySelectMaintenance.Next;
  end;
end;

procedure TFrm_AddDossier.LancerRecherche;
begin
  TThreadProc.RunInThread(
    procedure
    begin
      doLancerRecherche;
    end
  ).whenFinish(
    procedure
    begin
      FinalisationLoad(true, true);
    end
  ).Run ;
end;

procedure TFrm_AddDossier.LoadCentrales;
begin
  TThreadProc.RunInThread(
    procedure
    begin
      doLoadCentrales;
    end
  ).whenFinish(
    procedure
    begin
      loadVersions;
    end
  ).Run ;
end;

procedure TFrm_AddDossier.LoadModules;
begin
  TThreadProc.RunInThread(
    procedure
    begin
      doLoadModules;
    end
  ).whenFinish(
    procedure
    begin
      FinalisationLoad(true, false);
    end
  ).Run ;
end;

procedure TFrm_AddDossier.LoadVersions;
begin
  TThreadProc.RunInThread(
    procedure
    begin
      doloadVersions;
    end
  ).whenFinish(
    procedure
    begin
      loadmodules;
    end
  ).Run ;
end;

procedure TFrm_AddDossier.Lv_CentralesDblClick(Sender: TObject);
begin
  lv_DblClick(Lv_Centrales);
end;

procedure TFrm_AddDossier.Lv_CentralesItemChecked(Sender: TObject;
  Item: TListItem);
begin
  lv_ItemChecked(Lv_Centrales,Grp_Centrales);
end;

procedure TFrm_AddDossier.lv_dossiersColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  if sortColumn = Column.Index
    then sortColumn := -Column.Index
    else sortColumn := Column.Index;
  lv_dossiers.AlphaSort;
end;

procedure TFrm_AddDossier.lv_dossiersCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if abs(sortColumn) <> 0 then
    if sortColumn >= 0
      then Compare := CompareText(Item2.SubItems[abs(sortColumn)-1],Item1.SubItems[abs(sortColumn)-1])
      else Compare := CompareText(Item1.SubItems[abs(sortColumn)-1],Item2.SubItems[abs(sortColumn)-1]);
end;

procedure TFrm_AddDossier.lv_dossiersDblClick(Sender: TObject);
begin
  lv_DblClick(lv_dossiers);
end;

procedure TFrm_AddDossier.lv_dossiersKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i : integer;
  li, li2 : TListItem;
begin
  if (Key = Ord('A')) and (ssCtrl in Shift) then
  begin
    for i := 0 to lv_dossiers.Items.Count - 1 do
    begin
      li := lv_dossiers.Items[i];
      li.Selected := true;
    end;
  end
  else
  begin
    if (Key in [Ord('A')..Ord('Z'),Ord('a')..Ord('z')]) then
    begin
      li2 := FindListViewItem(lv_dossiers, Char(Key), 1);
      if li2 <> nil then
      begin
        for i := 0 to lv_dossiers.Items.Count - 1 do
        begin
          li := lv_dossiers.Items[i];
          li.Selected := false;
        end;
        lv_dossiers.Selected := li2;
        li2.MakeVisible(True);
        lv_dossiers.SetFocus;
      end;
    end;
  end;
  if Key = VK_F5 then
    Nbt_LancerRechercheClick(self);
end;

function TFrm_AddDossier.FindListViewItem(lv: TListView; const S: string; column: Integer): TListItem;
var
  i: Integer;
  found: Boolean;
  Search : String;
begin
  Assert(Assigned(lv));
  Assert((lv.viewstyle = vsReport) or (column = 0));
  Assert(S <> '');
  found := false;
  for i := 0 to lv.Items.Count - 1 do
  begin
    Result := lv.Items[i];
    Search := Copy(Result.SubItems[column - 1],0,1);
    found := Search = S;
//    if column = 0 then
//      found := AnsiCompareText(Result.Caption, S) = 0
//    else if column > 0 then
//      found := AnsiCompareText(Copy(Result.SubItems[column - 1],0,1), S) = 0
//    else
//      found := False;
    if found then
      Exit;
  end;
  // No hit if we get here
  Result := nil;
end;

procedure TFrm_AddDossier.lv_modulesDblClick(Sender: TObject);
begin
  lv_DblClick(lv_modules);
end;

procedure TFrm_AddDossier.lv_DblClick(lv : TListView);
var
  i : integer;
  li : TListItem;
begin
  for i := 0 to lv.Items.Count - 1 do
  begin
    li := lv.Items[i];
    if li.Selected then
      li.Checked := not li.Checked;
  end
end;

procedure TFrm_AddDossier.lv_ItemChecked(lv : TListView; GroupBar : TRzGroup);
var
  i, NbCheck, NbItem : integer;
  li : TListItem;
  Name : String;
begin
  NbItem := lv.Items.Count;
  for i := 0 to NbItem - 1 do
  begin
    li := lv.Items[i];
    if li.Checked then
      inc(NbCheck);
  end;
  Name := GroupBar.Name;
  Name := StringReplace(Name,'Grp_','',[rfReplaceAll, rfIgnoreCase]);
  if NbCheck = 0 then
    GroupBar.Caption := Name + ' (Pas de sélection)'
  else
  begin
    if NbItem = NbCheck
      then GroupBar.Caption := Name + ' (Pas de filtres)'
      else GroupBar.Caption := Name + '(' + inttostr(NbCheck) + ' sélections)';
  end;
end;

procedure TFrm_AddDossier.lv_modulesItemChecked(Sender: TObject;
  Item: TListItem);
begin
  lv_ItemChecked(lv_modules,Grp_Modules);
end;

procedure TFrm_AddDossier.lv_versionsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  s1, s2 : string;
begin
  // on ajoute un 0 devant les versions qui ont un "." en 2ème caractères, pour que le tri fonctionne .....
  s1 := Item1.SubItems[0];
  s2 := Item2.SubItems[0];
  if s1[2] = '.' then s1 := '0' + s1;
  if s2[2] = '.' then s2 := '0' + s2;
  Compare := CompareStr(s2, s1);
end;

procedure TFrm_AddDossier.lv_versionsDblClick(Sender: TObject);
var
  i : integer;
  li : TListItem;
begin
  for i := 0 to lv_versions.Items.Count - 1 do
  begin
    li := lv_versions.Items[i];
    if li.Selected then
      li.Checked := not li.Checked;
  end
end;

procedure TFrm_AddDossier.lv_versionsItemChecked(Sender: TObject;
  Item: TListItem);
begin
  lv_ItemChecked(lv_versions, Grp_Versions);
end;

procedure TFrm_AddDossier.Msg(sMsg: string);
begin
//  showmessage(sMsg);
end;

procedure TFrm_AddDossier.Nbt_AjouterDossierClick(Sender: TObject);
var
  i : integer;
  li : TListItem;
  aDossier : TDossier;
begin
  try
    for i := 0 to lv_dossiers.Items.Count - 1 do
    begin
      li := lv_dossiers.Items[i];
      if li.Checked then
      begin
        aDossier := TDossier.create;
        aDossier.Nom := li.SubItems[0];
        aDossier.NomCentrale := li.SubItems[1];
        aDossier.Version := li.SubItems[2];
        aDossier.Serveur := li.SubItems[3];
        aDossier.Base := li.SubItems[4];
        aDossier.Centrale := TCentrale(strtointdef(li.SubItems[5],0));
        Dossiers.Add(aDossier);
      end;
    end;
    ModalResult := mrOk;
  except

  end;
end;

procedure TFrm_AddDossier.Nbt_CheckClick(Sender: TObject);
var
  i : integer;
  li : TListItem;
begin
  for i := 0 to lv_dossiers.Items.Count - 1 do
  begin
    li := lv_dossiers.Items[i];
    if li.Selected then
      li.Checked := not li.Checked;
  end;
end;

procedure TFrm_AddDossier.Nbt_LancerRechercheClick(Sender: TObject);
begin
  FinalisationLoad(false , true);
  LancerRecherche;
end;

procedure TFrm_AddDossier.Trier_lv_version;
begin
  (lv_versions as TCustomListView).AlphaSort;
end;

end.
