unit SelectRescueC_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.StrUtils, System.AnsiStrings, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  //Début Uses Perso
  uFunctions,
  uParams,
  uRessourcestr,
  uSevenZip,
  // uLogfile, anciens logs
  uLog,
  uLameFileparser,
  uDownloadfromlame,
  uPatchScript,
  uInstallbase,
  uBasetest,
  registry,
  ShlObj,
  Informations,
  IniFiles,
  system.IOUtils,
  //Fin Uses Perso
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

Const
  LOCALFILE = 0;
  URL = 1; // id de l'image dans imagelist
  STOP = 2;
  FROMLAME = 3;
  WM_LOADLISTFROMLAME = WM_USER + 101;

type
  TFrm_SelectRescueC = class(TForm)
    pnl_bas: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    pnl_SelectOrigine: TPanel;
    edtLocalfile: TButtonedEdit;
    lbl1: TLabel;
    lblMagasin: TLabel;
    cbbMagasin: TComboBox;
    lblPosteSecours: TLabel;
    cbbPosteSecours: TComboBox;
    Openfile: TFileOpenDialog;
    OpenFileXP: TOpenDialog;
    IdHTTP1: TIdHTTP;
    btnDownload: TButton;
    lbl_NomServeurPrin: TLabel;
    edt_ServeurPrin: TEdit;
    lbl_DirServSecours: TLabel;
    edt_DirServPrin: TEdit;
    lbl_DiskG: TLabel;
    cbbLetter: TComboBox;
    procedure btnCancelClick(Sender: TObject);
    procedure edtLocalfileRightButtonClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbbMagasinChange(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure cbbLetterChange(Sender: TObject);
    procedure edt_ServeurPrinChange(Sender: TObject);
  private
    { Déclarations privées }
    Install: Tinstall;

    ptrAddshop  : TAddshop;
    ptrAddPoste : TAddposte;
    NomDuPoste, NomDuPosteDeSecours : string;

    function DecoupeNameServeurPrin(sServeurPrin : string) : String;
  public
    { Déclarations publiques }
    GetcbListeServeur, cbLettre, sDirGinkoia, sMagL, sPosteL, sDirTestL : string;
    IsBaseTestL : Boolean;

    function InstallCaisseSecours : Boolean;
    procedure GetInfoInstal(GetcbListeServeurs, cbLettres, sDirGinkoias, sMag, sPoste, sDirTest : string; IsBaseTest : Boolean);
    procedure CreateIni;
  end;

var
  Frm_SelectRescueC: TFrm_SelectRescueC;

implementation

Uses Main_Dm;

{$R *.dfm}

procedure TFrm_SelectRescueC.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrm_SelectRescueC.btnDownloadClick(Sender: TObject);
var
  i                : integer;
  sNameServeurPrin : string;
begin
  //
  Try
    application.ProcessMessages;
    // création de l'objet Tinstall (uInstallbase)
    Install := Tinstall.Create(edtLocalfile.Text); // create pour caisse
    Install.Connexion := edtLocalfile.Text;
    Install.OpenServeur;
    if Install.Database.Error = '' then  //Si connexion ok
    begin
      ShowMessage('Connexion à la base de données réussie');
      Install.AddShop := ptrAddShop;
      Install.AddPoste := ptrAddPoste;
      Install.GetShop;



      //Selection automatique du magasin
      cbbMagasin.ItemIndex := 0;
      i := cbbMagasin.Items.Count;

      for I := 0 to i do
      begin
        if sMagL = cbbMagasin.Items[i] then
        cbbMagasin.ItemIndex  := i;
        cbbMagasinChange(Sender);
      end;

      //Selection du letterdir automatiquement
      i := 0;
      i := cbbLetter.Items.Count;

      for I := 0 to i do
      begin
        if cbLettre[1] = cbbLetter.Items[i] then
          cbbLetter.ItemIndex := i;
      end;

      //Getting the main shop
      sNameServeurPrin     := Install.GetServPrin(sDirGinkoia, sMagL);
      if sNameServeurPrin <> '' then
      begin
        sNameServeurPrin     := DecoupeNameServeurPrin(sNameServeurPrin);
        edt_ServeurPrin.Text := sNameServeurPrin;
      end else
      begin
        ShowMessage('Aucun magasin principal n''est configuré dans la base'+#13#10+'Veuillez entrer manuellement le nom du serveur principal');
        edt_ServeurPrin.SetFocus;
      end;

      edt_DirServPrin.Text := sNameServeurPrin + ':' + cbbLetter.Text + ':\GINKOIA\DATA\Ginkoia.IB';

      //SELECT AUTO
      i := 0;
      i := cbbPosteSecours.Items.Count;

      for I := 0 to i do
      begin
        if sPosteL+'_SEC' = cbbPosteSecours.Items[i] then
        begin
          cbbPosteSecours.ItemIndex := i;
        end;
      end;

    end;
  Finally

  End;
end;

procedure TFrm_SelectRescueC.btnOkClick(Sender: TObject);
begin
  if InstallCaisseSecours then
    ModalResult := mrOk;
end;

procedure TFrm_SelectRescueC.cbbLetterChange(Sender: TObject);
begin
  edt_DirServPrin.Text := edt_ServeurPrin.Text + ':' + cbbLetter.Text + ':\GINKOIA\DATA\Ginkoia.IB';
end;

procedure TFrm_SelectRescueC.cbbMagasinChange(Sender: TObject);
begin
  //
  cbbPosteSecours.Clear;
  Install.GetPoste(cbbMagasin.Text);
end;

procedure TFrm_SelectRescueC.CreateIni;
var
  TsElementIni : TStringList;
  sBase        : string;
  sDir         : string;
  sServerName  : string;
  MaxVal       : Integer;
  IniGin       : TIniFile;
  ValueL       : TStringList;
begin
  //Creating Ini file 'Emergency Checkout'
  try
    //Ini Ginkoia
    IniGin := TIniFile.Create(cbLettre + 'ginkoia\GINKOIA.INI');
    ValueL := TStringList.Create;
    IniGin.ReadSection('DATABASE', ValueL);
    MaxVal := ValueL.Count;

    IniGin.WriteString('DATABASE', 'PATH0', edt_DirServPrin.Text);
    IniGin.WriteString('DATABASE', 'PATH'+IntToStr(MaxVal), sDirGinkoia);
    IniGin.WriteString('NOMMAGS', 'MAG0', sMagL);
    IniGin.WriteString('NOMMAGS', 'MAG'+IntToStr(MaxVal), cbbMagasin.Text);
    IniGin.WriteString('NOMPOSTE', 'POSTE0', sPosteL);
    IniGin.WriteString('NOMPOSTE', 'POSTE'+IntToStr(MaxVal), cbbPosteSecours.Text);
    IniGin.WriteString('NOMBASES', 'ITEM0', sMagL);
    IniGin.WriteString('NOMBASES', 'ITEM'+IntToStr(MaxVal), 'SECOURS ' + cbbMagasin.Text);

    //Ini Caisse
    IniGin.Free;
    MaxVal := 0;
    ValueL.Clear;

    IniGin := TIniFile.Create(cbLettre + 'ginkoia\Caisseginkoia.INI');
    IniGin.ReadSection('DATABASE', ValueL);
    MaxVal := ValueL.Count;

    IniGin.WriteString('DATABASE', 'PATH0', edt_DirServPrin.Text);
    IniGin.WriteString('DATABASE', 'PATH'+IntToStr(MaxVal), sDirGinkoia);
    IniGin.WriteString('NOMMAGS', 'MAG0', sMagL);
    IniGin.WriteString('NOMMAGS', 'MAG'+IntToStr(MaxVal), cbbMagasin.Text);
    IniGin.WriteString('NOMPOSTE', 'POSTE0', sPosteL);
    IniGin.WriteString('NOMPOSTE', 'POSTE'+IntToStr(MaxVal), cbbPosteSecours.Text);
    IniGin.WriteString('NOMBASES', 'ITEM0', sMagL);
    IniGin.WriteString('NOMBASES', 'ITEM'+IntToStr(MaxVal), 'SECOURS ' + cbbMagasin.Text);
  finally
    TsElementIni.Free;
    IniGin.Free;
  end;
end;

function TFrm_SelectRescueC.DecoupeNameServeurPrin(
  sServeurPrin: string): String;
var
  i : Integer;
begin
  //
  Result := '';

  if sServeurPrin[1] = '\' then
    sServeurPrin := Copy(sServeurPrin, 3, System.Length(sServeurPrin));
  i := Pos('\',sServeurPrin);
  sServeurPrin := Copy(sServeurPrin, 0, i-1);

  Result := sServeurPrin;
end;

procedure TFrm_SelectRescueC.edtLocalfileRightButtonClick(Sender: TObject);
var
  sFilename: string;
  fs: string;
begin
  if IsVistaOrHigher then
  begin
    Openfile.DefaultFolder := 'C:\Ginkoia';
    if Openfile.Execute then
    begin
      sFilename := Openfile.FileName;
    end;
  end else
  begin
    // xp
    OpenFileXP.InitialDir := 'c:\';
    if OpenFileXP.Execute then
      sFilename := OpenFileXP.FileName;
  end;

  if sFilename <> '' then
  begin
    edtLocalfile.Text := sFilename;
    btnDownload.Enabled := True;
  end;


end;


procedure TFrm_SelectRescueC.edt_ServeurPrinChange(Sender: TObject);
begin
  edt_DirServPrin.Text := edt_ServeurPrin.Text + ':' + cbbLetter.Text + ':\GINKOIA\DATA\Ginkoia.IB';
end;

procedure TFrm_SelectRescueC.FormCreate(Sender: TObject);
var
  a : Char;
begin
  ptrAddPoste := procedure(Poste : string; aPosID: Integer)
  begin
    //cbbPosteSecours.items.Add(Poste);
    cbbPosteSecours.Items.AddObject(Poste, TObject(aPosID));
    if Nomduposte = Poste then
    begin
      cbbPosteSecours.Itemindex := cbbPosteSecours.items.count-1;
    end;
  end;

  ptrAddShop := procedure(Magasin : string; MagID: integer)
  begin
    //cbbMagasin.Items.Add(Magasin);
    cbbMagasin.Items.AddObject(Magasin, TObject(MagID));
    if Magasin = Install.MagasinSurServeur then
    begin
      cbbMagasin.ItemIndex := cbbMagasin.Items.Count-1;
    end;
  end;

  //**** Les lettres des disques ****//
  cbbLetter.Clear;
  for a := 'A' to 'Z' do
    cbbLetter.Items.Add(a);
end;

procedure TFrm_SelectRescueC.GetInfoInstal(GetcbListeServeurs, cbLettres, sDirGinkoias, sMag, sPoste, sDirTest : string; IsBaseTest : Boolean);
begin
  //Get Info
  GetcbListeServeur := GetcbListeServeurs;
  cbLettre          := cbLettres;
  sDirGinkoia       := sDirGinkoias;
  sMagL             := sMag;
  sPosteL           := sPoste;
  sDirTestL         := sDirTest;
  IsBaseTestL       := IsBaseTest;

  if sDirGinkoia <> '' then
  begin
    edtLocalfile.Text := sDirGinkoia;
  end;

end;

function TFrm_SelectRescueC.InstallCaisseSecours : Boolean;
var
  sFile : string;
  I: Integer;
  tmp : TStringList;
  Res, Res_Icon : TResourceStream;
  sRep,sBat, sIcon:string;
begin
  //
  Result := False;

  CreateIni;

  tmp := TStringList.Create;
  try
    try
      if Tfile.Exists(sFile) = false then
      begin
        sRep := ExtractFilePath(Application.ExeName);
        sBat := 'MODEL.BAT';
        sIcon:= 'Icon_CaisseSecours.ICO';

        if sRep[length(sRep)]<>'\' then
          sRep:=sRep+'\';

        Res_Icon  := TResourceStream.Create(HInstance,'Icon_CaisseSecours', RT_RCDATA);

        try
//          Res_Icon.SaveToFile(sRep + sIcon);
          Res_Icon.SaveToFile(sDirGinkoia[1]+':\GINKOIA\'+ sIcon);
        finally
          Res_Icon.Free;
        end;
      end
      else
      begin
        tmp.LoadFromFile(sFile);
      end;

  finally
//      Install.Machine.CreateShortcut( 'Caisse de secours',
//                                      sDirGinkoia[1] + ':\ginkoia\CAISSEGINKOIA.exe',
//                                      'Caisse',
//                                      sDirGinkoia[1]+':\GINKOIA\', sRep + sIcon);

      Install.Machine.CreateShortcut( 'Caisse de secours',
                                      sDirGinkoia[1] + ':\ginkoia\CAISSEGINKOIA.exe',
                                      'Caisse',
                                      sDirGinkoia[1]+':\GINKOIA\', sDirGinkoia[1]+':\GINKOIA\' + sIcon);
      Result := True;
      tmp.Free;
  end;
  except on E:Exception do
    begin
      Result := False;
      ShowMessage('Erreur lors de la création du fichier batch : ' + E.Message);
//      TlogFile.Addline('Erreur lors de la création du fichier batch : ' + E.Message);
      //log.Log('Erreur lors de la création du fichier batch : ' + E.Message, logError);
      Log.Log('SelectRescueC_Frm','InstallCaisseSecours', 'Erreur lors de la création du fichier batch : ' + E.Message, logError, True, 0, ltBoth);
    end;
  end;
end;

end.
