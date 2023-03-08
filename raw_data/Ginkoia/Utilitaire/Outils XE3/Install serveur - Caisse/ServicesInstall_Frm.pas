unit ServicesInstall_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.ShellAPI,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.IniFiles, Vcl.ComCtrls, uToolsXE;

const
  SECTION_OBLIGATOIRE = 'obligatoire';
  SECTION_OPTIONNEL = 'optionnel';


type
  TTypeInstall = (InstallTypeServeur, InstallTypePortable, InstallTypeCaisseSec);

  RService = record
    section: string;
    name: string;
    path: string;
    default_checked: boolean;
    enabled: Boolean;
    TheCheckBox: TCheckBox;
  end;

  TFrmServicesInstall = class(TForm)
    pnl_bottom: TPanel;
    BtnOk: TButton;
    LblTitle: TLabel;
    LblObligatoire: TLabel;
    LblOptionnel: TLabel;
    LblCentrale: TLabel;
    PnlObligatoire: TPanel;
    PnlOptionnel: TPanel;
    PnlCentrale: TPanel;
    GdPnlObligatoire: TGridPanel;
    GdPnlOptionnel: TGridPanel;
    GdPnlCentrale: TGridPanel;
    ProgressServices: TProgressBar;
    procedure BtnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
    ArrayService: array of RService;
    procedure LoadServicesFromIni(aIniName: string);
    procedure ShowCheckBoxes;
  public
    { Déclarations publiques }
    TypeInstall: TTypeInstall;
    PathGinkoia: string;
    ListModules: TstringList;
  end;

var
  Frm_ServicesInstall: TFrmServicesInstall;

implementation

{$R *.dfm}

procedure TFrmServicesInstall.BtnOkClick(Sender: TObject);
var
  i, Nb_Checked: Integer;
  serviceName: String;
begin
  BtnOk.Enabled := False;
  Nb_Checked := 0;

  // Installation des services
  // on parcourt les checkboxes et on récupère le rang des cochées
  for i := 0 to Length(ArrayService) - 1 do
  begin
    if ArrayService[i].TheCheckBox.Checked then
      Inc(Nb_Checked);
  end;

  ProgressServices.Visible := True;
  ProgressServices.Max := Nb_Checked;
  ProgressServices.Position := 0;

  for i := 0 to Length(ArrayService) - 1 do
  begin
    serviceName := '';

    // la case est cochée, on installe le service
    if ArrayService[i].TheCheckBox.Checked then
    begin
      ShellExecute(0, 'open', PWideChar(ArrayService[i].path), '/install /silent', Nil, SW_HIDE);
      // après installation d'un service on tente de le redémarrer
      //ServiceStart('', );

      Sleep(3000);

      ProgressServices.Position := ProgressServices.Position + 1;
      Application.ProcessMessages;

      // on tente de démarrer le service après son installation
      serviceName := GetServicesNameByPath(ArrayService[i].path);
      if serviceName <> '' then
        ServiceStart('', serviceName);
    end;
  end;

  ModalResult := mrOk;
end;

procedure TFrmServicesInstall.FormDestroy(Sender: TObject);
begin
  if Assigned(ListModules) then
    ListModules.Free;
end;

procedure TFrmServicesInstall.FormShow(Sender: TObject);
var
  iniName: string;
begin
  // chargement du fichier Ini en fonction du Type d'installation
  case TypeInstall of
    InstallTypeServeur:
      iniName := 'Deploy_Serveur.ini';
    InstallTypePortable:
      iniName := 'Deploy_Portable.ini';
    InstallTypeCaisseSec:
      iniName := 'Deploy_Caisse-Sec.ini';
  end;

  // si les fichiers Ini ne sont pas dans la version on skip l'installation des services
  if not FileExists(PathGinkoia + 'SERVICES\' + iniName) then
    PostMessage(Self.Handle, wm_close, 0, 0);

  // on charge le fichier INI dans un tableau de Record
  LoadServicesFromIni(iniName);

  // on affiche les checkboxs dans les zones correspondantes
  ShowCheckBoxes();
end;

procedure TFrmServicesInstall.ShowCheckBoxes();
var
  i, iObligatoire, iOptionnel, iCentrale, iCurrent: Integer;
  aCheckBox: TCheckBox;
  aRowItem: TRowItem;
  aColumnItem: TColumnItem;
  CurrentGrid: TGridPanel;
begin
  // GridPanel Obligatoire
  GdPnlObligatoire.RowCollection.BeginUpdate;
  GdPnlObligatoire.ColumnCollection.BeginUpdate;
  GdPnlObligatoire.RowCollection.Clear;
  GdPnlObligatoire.ColumnCollection.Clear;
  // GridPanel Optionnel
  GdPnlOptionnel.RowCollection.BeginUpdate;
  GdPnlOptionnel.ColumnCollection.BeginUpdate;
  GdPnlOptionnel.RowCollection.Clear;
  GdPnlOptionnel.ColumnCollection.Clear;
  // GridPanel Centrale
  GdPnlCentrale.RowCollection.BeginUpdate;
  GdPnlCentrale.ColumnCollection.BeginUpdate;
  GdPnlCentrale.RowCollection.Clear;
  GdPnlCentrale.ColumnCollection.Clear;

  iObligatoire := 0;
  iOptionnel := 0;
  iCentrale := 0;

  for i := 0 to Length(ArrayService) - 1 do
  begin

    if LowerCase(ArrayService[i].section) = SECTION_OBLIGATOIRE then
    begin
      iCurrent := iObligatoire;
      CurrentGrid := GdPnlObligatoire;
      Inc(iObligatoire);
    end
    else if LowerCase(ArrayService[i].section) = SECTION_OPTIONNEL then
    begin
      iCurrent := iOptionnel;
      CurrentGrid := GdPnlOptionnel;
      Inc(iOptionnel);
    end
    else
    begin
      iCurrent := iCentrale;
      CurrentGrid := GdPnlCentrale;
      Inc(iCentrale);
    end;


    // tous les 4 enregistrement on ajoute une ligne + la première (i = 0)
    //if (i mod 4 = 0) then
    if (iCurrent mod 4 = 0) then
    begin
      //aRowItem := GdPnlObligatoire.RowCollection.Add;
      aRowItem := CurrentGrid.RowCollection.Add;
      aRowItem.SizeStyle := ssAbsolute;
      aRowItem.Value := 30;
    end;

    // on ajoute quatre colonnes au maximum
    //if GdPnlObligatoire.ColumnCollection.Count < 4 then
    if CurrentGrid.ColumnCollection.Count < 4 then
    begin
      //aColumnItem := GdPnlObligatoire.ColumnCollection.Add;
      aColumnItem := CurrentGrid.ColumnCollection.Add;
      aColumnItem.SizeStyle := ssAbsolute;
      aColumnItem.Value := 140;
    end;

    aCheckBox := TCheckBox.Create(self);
    //aCheckBox.Parent := GdPnlObligatoire;
    aCheckBox.Parent := CurrentGrid;
    aCheckBox.Visible := true;
    aCheckBox.Align := alClient;
    aCheckBox.AlignWithMargins := True;
    aCheckBox.Caption := ArrayService[i].name;
    aCheckBox.Name := 'CheckService_' + IntToStr(i);
    aCheckBox.Checked := ArrayService[i].default_checked;
    aCheckBox.Enabled := ArrayService[i].enabled;

    ArrayService[i].TheCheckBox := aCheckBox;
  end;

  GdPnlObligatoire.RowCollection.EndUpdate;
  GdPnlObligatoire.ColumnCollection.EndUpdate;
  GdPnlOptionnel.RowCollection.EndUpdate;
  GdPnlOptionnel.ColumnCollection.EndUpdate;
  GdPnlCentrale.RowCollection.EndUpdate;
  GdPnlCentrale.ColumnCollection.EndUpdate;

  // on masque les GridPanels qui n'ont aucun service
  if GdPnlObligatoire.ColumnCollection.Count = 0 then
  begin
    PnlObligatoire.Hide;
    LblObligatoire.Hide;
  end;
  if GdPnlOptionnel.ColumnCollection.Count = 0 then
  begin
    PnlOptionnel.Hide;
    LblOptionnel.Hide;
  end;
  if GdPnlCentrale.ColumnCollection.Count = 0 then
  begin
    PnlCentrale.Hide;
    LblCentrale.Hide;
  end;

end;

procedure TFrmServicesInstall.LoadServicesFromIni(aIniName: string);
var
  iniFile: TIniFile;
  Sections, Keys: TStringList;
  cptSections, cptKeys, aLength: integer;
  nomSection, nomKey, valueKey: string;
  bAddToArray: Boolean;
  i: Integer;
begin
  iniFile := TIniFile.Create(PathGinkoia + 'SERVICES\' + aIniName);
  Sections := TStringList.Create;

  try
    iniFile.ReadSections(Sections);

    for cptSections := 0 to Sections.Count - 1 do
    begin
      bAddToArray := False;
      nomSection := Sections[cptSections];

      // si on est dans un partie autre que optionnel ou obligatoire, on regarde si le module correspondant existes
      if (LowerCase(nomSection) <> SECTION_OBLIGATOIRE) and (LowerCase(nomSection) <> SECTION_OPTIONNEL) then
      begin
        for i := 0 to ListModules.Count - 1 do
        begin
          if LowerCase(ListModules[i]) = LowerCase(nomSection) then
          begin
            bAddToArray := True;
            Break;
          end;
        end;
      end
      else
        bAddToArray := True;

      if bAddToArray then
      begin
        Keys := TStringList.Create;
        try
        // Lecture des valeurs de la Section Sections[Compteur]
          iniFile.ReadSectionValues(Sections[cptSections], Keys);

          for cptKeys := 0 to Keys.Count - 1 do
          begin
          // nom du service à installer
            nomKey := Keys.Names[cptKeys];
            valueKey := iniFile.ReadString(nomSection, nomKey, '');

            SetLength(ArrayService, Length(ArrayService) + 1);
            aLength := Length(ArrayService) - 1;

            ArrayService[aLength].section := nomSection;
            ArrayService[aLength].name := nomKey;
            ArrayService[aLength].path := PathGinkoia + valueKey;
            ArrayService[aLength].default_checked := (LowerCase(nomSection) <> SECTION_OPTIONNEL);
            ArrayService[aLength].enabled := (LowerCase(nomSection) <> SECTION_OBLIGATOIRE);
          end;
        finally
          Keys.Free;
        end;
      end;
    end;

  finally
    iniFile.Free;
    Sections.Free
  end;
end;

end.

