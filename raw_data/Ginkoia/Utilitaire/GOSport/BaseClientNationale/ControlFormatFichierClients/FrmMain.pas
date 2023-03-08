unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ImgList, ComCtrls,
  iniFiles, Buttons;

type
  TFormBaseNationale = class(TForm)
    Pgc_FileControl: TPageControl;
    Tab_Logs: TTabSheet;
    Tab_Params: TTabSheet;
    MemoLogs: TMemo;
    Btn_Runcontrol: TButton;
    EditDefaultTypeName: TEdit;
    EditDefaultTypeValue: TEdit;
    ComboBoxFilePathAndName: TComboBox;
    ComboBoxParamDefaultDirectory: TComboBox;
    Btn_ParamSave: TButton;
    SpdBtnImportClear: TSpeedButton;
    FileOpenDialogDefaultPath: TFileOpenDialog;
    Lab_DefaultDirectory: TLabel;
    Lab_FileTypeName: TLabel;
    Lab_FileTypeValue: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ComboBoxFilePathAndNameDropDown(Sender: TObject);
    procedure ComboBoxParamDefaultDirectoryDropDown(Sender: TObject);
    procedure Btn_ParamSaveClick(Sender: TObject);
    procedure Btn_RuncontrolClick(Sender: TObject);
    procedure SpdBtnImportClearClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure LoadIniParams;
    { Déclarations publiques }
    function ControleFormatFichierCLI(var aSLFile, aSLLog : TStringList; aSeparateur : String) : Integer;
  end;

var
  FormBaseNationale: TFormBaseNationale;

implementation

{$R *.dfm}

procedure TFormBaseNationale.LoadIniParams;
var
  vIniFile : TIniFile;
  aString: String;
begin
  aString := ExtractFilePath(Application.ExeName) + 'ControlFormatFichierClients.ini';
  vIniFile:= TIniFile.Create(aString);
  ComboBoxParamDefaultDirectory.Text := vIniFile.ReadString('PARAMS','DEFAULT_DIRECTORY','C:\JacquesB\Imports\SFTP');
  EditDefaultTypeName.Text := vIniFile.ReadString('PARAMS','DEFAULT_FILE_TYPE_NAME',' ');
  FileOpenDialogDefaultPath.FileTypes[0].DisplayName := EditDefaultTypeName.Text;
  EditDefaultTypeValue.Text := vIniFile.ReadString('PARAMS','DEFAULT_FILE_TYPE_VALUE','*.CLI7');
  FileOpenDialogDefaultPath.FileTypes[0].FileMask := EditDefaultTypeValue.Text;
  ComboBoxFilePathAndName.Text := vIniFile.ReadString('PARAMS','MEMO_LAST_FILE_PATH_AND_NAME','');
  vIniFile.Free;

end;

procedure TFormBaseNationale.SpdBtnImportClearClick(Sender: TObject);
begin
  MemoLogs.Clear;
end;

procedure TFormBaseNationale.Btn_ParamSaveClick(Sender: TObject);
var
  vIniFile : TIniFile;
begin
  vIniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ControlFormatFichierClients.ini');
  vIniFile.WriteString('PARAMS','DEFAULT_DIRECTORY',ComboBoxParamDefaultDirectory.Text);
  vIniFile.WriteString('PARAMS','DEFAULT_FILE_TYPE_NAME',EditDefaultTypeName.Text);
  FileOpenDialogDefaultPath.FileTypes[0].DisplayName := EditDefaultTypeName.Text;
  vIniFile.WriteString('PARAMS','DEFAULT_FILE_TYPE_VALUE',EditDefaultTypeValue.Text);
  FileOpenDialogDefaultPath.FileTypes[0].FileMask := EditDefaultTypeValue.Text;
  if ComboBoxFilePathAndName.Text <> '' then
    vIniFile.WriteString('PARAMS','MEMO_LAST_FILE_PATH_AND_NAME',ComboBoxFilePathAndName.Text);
  vIniFile.Free;
end;

procedure TFormBaseNationale.Btn_RuncontrolClick(Sender: TObject);
var
  vIniFile : TIniFile;
  vSLFile : TStringList;
  vSLLog  : TStringList;
  I,J : Integer;
  vT2, vT1 : TDateTime;
  aString : String;
begin
  if FileExists(ComboBoxFilePathAndName.Text) then
  begin
    vIniFile:= TIniFile.Create(ExtractFilePath(Application.ExeName) + 'ControlFormatFichierClients.ini');
    vIniFile.WriteString('PARAMS','MEMO_LAST_FILE_PATH_AND_NAME',ComboBoxFilePathAndName.Text);
    vIniFile.Free;
    vSLFile := TStringList.Create();
    vSLLog := TStringList.Create();
    try
      vT1 := Now;
      vSLFile.DefaultEncoding:= TEncoding.UTF8;
      vSLFile.LoadFromFile(ComboBoxFilePathAndName.Text);
      J := ControleFormatFichierCLI(vSLFile, vSLLog,'|');
      if J > 0 then
      begin
        vT2 := Now;
        MemoLogs.Lines.Add('Fichier ' + ComboBoxFilePathAndName.Text + ' --> Nombre d''erreurs = ' + IntToStr(J));
        MemoLogs.Lines.Add('Heure de démarrage du traitement : ' +  FormatDateTime('dd/mm/yyyy a hh:nn:ss',vT1));
        aString := FormatDateTime('hh:nn:ss:zzz', vT2 - vT1);
        MemoLogs.Lines.Add('Temps de traitement : ' + copy(aString,1,2) + 'h' + copy(aString,4,2) + 'm' + copy(aString,7,2) + '.' + copy(aString,10,3) + ' s');
        MemoLogs.Lines.Add('');
        for I := 0 to vSLLog.Count-1 do
        begin
          MemoLogs.Lines.Add(vSLLog.Strings[I])
        end;
        MemoLogs.Lines.Add('--------------------------------------------------');
      end else
      begin
        MemoLogs.Lines.Add('Le Fichier ' + ComboBoxFilePathAndName.Text + ' n''a pas d''erreur');
        MemoLogs.Lines.Add('--------------------------------------------------');
      end;
    finally
      FreeAndNil(vSLFile);
      FreeAndNil(vSLLog);

    end;
  end
  else MessageDlg('Fichier inexistant',mtError,[mbOk],0);

end;

procedure TFormBaseNationale.ComboBoxFilePathAndNameDropDown(Sender: TObject);
begin
  FileOpenDialogDefaultPath.Options := [];
  if FileOpenDialogDefaultPath.Execute then
  begin
    ComboBoxFilePathAndName.Text := FileOpenDialogDefaultPath.FileName;
    Abort;
  end;
end;

procedure TFormBaseNationale.ComboBoxParamDefaultDirectoryDropDown(
  Sender: TObject);
begin
  FileOpenDialogDefaultPath.Options := [fdoPickFolders];
  if FileOpenDialogDefaultPath.Execute then
  begin
    ComboBoxParamDefaultDirectory.Text := FileOpenDialogDefaultPath.FileName;
  end;
end;


procedure TFormBaseNationale.FormActivate(Sender: TObject);
begin
  LoadIniParams;
end;

function TFormBaseNationale.ControleFormatFichierCLI(var aSLFile, aSLLog : TStringList; aSeparateur : String) : Integer;
const
	cCLI_NUMCARTE1 = 1;
	cCLI_NUMCARTE2 = 2;
	cCLI_DTVAL = 3;
	cCLI_CODECLUB = 4;
	cCLI_CIV = 5;
	cCLI_NOM = 6;
	cCLI_PRENOM = 7;
	cCLI_ADR1 = 8;
	cCLI_ADR2 = 9;
	cCLI_ADR3 = 10;
	cCLI_ADR4 = 11;
	cCLI_CP = 12;
	cCLI_VILLE = 13;
	cCLI_CODEPAYS = 14;
	cCLI_TEL1 = 15;
	cCLI_TEL2 = 16;
	cCLI_DTNAISS = 17;
	cCLI_CODEPROF = 18;
	cCLI_AUTRESP = 19;
	cCLI_BLACKLIST = 20;
	cCLI_EMAIL = 21;
	cCLI_DTCREATION = 22;
  cCLI_IDETO = 23;
	cCLI_TOPSAL = 24;
	cCLI_CODERFM = 25;
	cCLI_OPTIN = 26;
	cCLI_OPTINPART = 27;
	cCLI_MAGORIG = 28;
	cCLI_TOPNPAI = 29;
	cCLI_TOPVIB = 30;
	cCLI_REMRENOUV = 31;
	cCLI_DTSUP = 32;
	cCLI_DTRENOUV = 33;
	cCLI_TYPEINFO = 34;

var
  vSLLine, vValeur, aString : String;
  i,j,k,Indice, NbErreurs : Integer;
  IsOk, IsLineOK : Boolean;

function IsNotNumerique(pValeur : String) : Boolean;
var
  i : Integer;
begin
  result := False;
  if pValeur <> '' then
  begin
    for i := 1 to length(pValeur) do
    begin
      if (copy(pValeur,i,1) < '0') or (copy(pValeur,i,1) > '9') then result := True;
    end;
  end;
end;

function IsNotDate(pValeur : String) : Boolean;
var
  i : Integer;
  vDate : TDate;
begin
  result := False;
  if pValeur <> '' then
  begin
    if (length(pValeur) > 10) or (Pos('/',pValeur) = 0) then
    begin
      result := True;
    end
    else begin
      try
        StrToDate(pValeur);
      except
        result := True;
      end;
    end;
  end;
end;

begin
  aSLLog.Clear;
  NbErreurs := 0;
  if aSLFile.Count > 0 then
  begin
    if pos(aSeparateur,aSLFile.Strings[0]) > 0 then
    begin
      for i:= 0 to aSLFile.Count -1 do
      begin
        IsLineOK := True;
        vSLLine := aSLFile.Strings[i];
        aString := vSLLine;
        Indice := 1;
        while Indice < 35 do
        begin
          k := pos(aSeparateur,aString);
          if k = 0 then
          begin
            vValeur := trim(aString);
            aString := '';
          end else
          begin
            vValeur := trim(copy(aString,1,k-1));
            aString := copy(aString,k+length(aSeparateur),length(aString)-k-length(aSeparateur)+1);
          end;
          IsOk := True;
          case Indice of
            cCLI_NUMCARTE1  : if length(vValeur) > 15 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Ancien code carte -> CLI_NUMCARTE longeur > 15 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_NUMCARTE2  : if length(vValeur) > 13 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Nouveau code carte -> CLI_NUMCARTE longeur > 13 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_DTVAL      : if IsNotDate(vValeur) then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Date de validité -> CLI_DTVAL date incorrecte (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_CODECLUB   : if length(vValeur) > 12 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code club -> CLI_CODECLUB longeur > 12 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_CIV        : if length(vValeur) > 4 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Civilite -> CLI_CIV longeur > 4 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_NOM        : if length(vValeur) > 50 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Nom -> CLI_NOM longeur > 50 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_PRENOM     : if length(vValeur) > 30 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Prenom -> CLI_PRENOM longeur > 30 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_ADR1       : if length(vValeur) > 50 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Adresse ligne 1 -> CLI_ADR1 longeur > 50 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_ADR2       : if length(vValeur) > 50 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Adresse ligne 2 -> CLI_ADR2 longeur > 50 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_ADR3       : if length(vValeur) > 50 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Adresse ligne 3 -> CLI_ADR3 longeur > 50 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_ADR4       : if length(vValeur) > 50 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Adresse ligne 4 -> CLI_ADR4 longeur > 50 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_CP         : if length(vValeur) > 15 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code postal -> CLI_CP longeur > 15 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_VILLE      : if length(vValeur) > 50 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Ville -> CLI_VILLE longeur > 50 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_CODEPAYS   : if length(vValeur) > 2 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code pays -> CLI_CODEPAYS longeur > 2 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_TEL1       : if length(vValeur) > 20 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Telephone 1 -> CLI_TEL1 longeur > 20 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_TEL2       : if length(vValeur) > 20 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Telephone 2 -> CLI_TEL2 longeur > 20 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_DTNAISS    : if IsNotDate(vValeur) then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Date de naissance -> CLI_DTNAISS date incorrect (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_CODEPROF   : if length(vValeur) > 4 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code profession -> CLI_CODEPROF longeur > 4 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_AUTRESP    : if length(vValeur) > 20 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Autre sport -> CLI_AUTRESP longeur > 20 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_BLACKLIST  : if length(vValeur) > 1 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Client en liste noire -> CLI_BLACKLIST longeur > 1 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_EMAIL      : if length(vValeur) > 100 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Email -> CLI_EMAIL longeur > 100 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_DTCREATION : if IsNotDate(vValeur) then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Date Création -> CLI_DTCREATION date incorrecte (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_IDETO      : if length(vValeur) > 15 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code Pivot -> CLI_IDETO longeur > 15 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_TOPSAL     : if length(vValeur) > 1 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Top Salarie -> CLI_TOPSAL longeur > 1 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_CODERFM    : if length(vValeur) > 2 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code RFM -> CLI_CODERFM longeur > 2 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_OPTIN      : if length(vValeur) > 1 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Top OPTIN -> CLI_OPTIN trop long (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_OPTINPART  : if length(vValeur) > 1 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Top OPTIN partenaire -> CLI_OPTINPART longeur > 1 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_MAGORIG    : if length(vValeur) > 4 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code magasin origine -> CLI_MAGORIG longeur > 4 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_TOPNPAI    : if length(vValeur) > 1 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Top NPAI -> CLI_TOPNPAI longeur > 1 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_TOPVIB     : if length(vValeur) > 1 then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Top VIB -> CLI_TOPVIB longeur > 1 (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_REMRENOUV  : if IsNotNumerique(vValeur) then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Remise sur renouvellement -> CLI_REMRENOUV non numerique (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_DTSUP      : if IsNotDate(vValeur) then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Date_suppression -> CLI_DTSUP date incorrecte (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_DTRENOUV   : if IsNotDate(vValeur) then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Date_Renouvellement -> CLI_DTRENOUV date incorrecte (' + vValeur + ')');
                                IsOk := False;
                              end;
            cCLI_TYPEINFO   : if (vValeur <> 'C') and (vValeur <> 'M') and (vValeur <> 'S') then
                              begin
                                aSLLog.Append('Ligne' + IntToStr(i+1) + ' : Code Type Infos -> Attendu (C,M,S) incorrect (' + vValeur + ')');
                                IsOk := False;
                              end;
          end;
          if IsOK = False then
          begin
            IsLineOK := False;
          end;
          Indice := Indice + 1;
        end;
        if IsLineOK = False then
        begin
          aSLLog.Append(vSLLine);
          Inc(NbErreurs);
        end;
      end;
    end else
    begin
      aSLLog.Append('Pas de séparateur "' + aSeparateur + '" sur la première ligne');
      Inc(NbErreurs );
    end;
  end else
  begin
    aSLLog.Append('Le fichier est vide (vérifier encodage UTF8)!');
    Inc(NbErreurs );
  end;
  Result := NbErreurs;
end;



end.
