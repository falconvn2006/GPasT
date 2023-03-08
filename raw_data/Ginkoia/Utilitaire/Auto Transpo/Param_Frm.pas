UNIT Param_Frm;

INTERFACE

USES Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    iniFiles,
    Buttons, ExtCtrls, Dialogs;

TYPE
    TFrm_Param = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Label1: TLabel;
        Ed_BaseVide: TEdit;
        SpeedButton1: TSpeedButton;
        Od4: TOpenDialog;
        Label2: TLabel;
        Ed_Backup: TEdit;
        SpeedButton2: TSpeedButton;
        Label3: TLabel;
        Ed_PlaceHusky: TEdit;
        SpeedButton3: TSpeedButton;
        Od: TOpenDialog;
        Label4: TLabel;
        Ed_IPHUSKY: TEdit;
        SpeedButton4: TSpeedButton;
        Label5: TLabel;
        Ed_Parametrage: TEdit;
        SpeedButton5: TSpeedButton;
    Label6: TLabel;
    Ed_EAI: TEdit;
    SpeedButton6: TSpeedButton;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
        PROCEDURE OKBtnClick(Sender: TObject);
        PROCEDURE SpeedButton3Click(Sender: TObject);
        PROCEDURE SpeedButton5Click(Sender: TObject);
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
    END;

VAR
    Frm_Param: TFrm_Param;

IMPLEMENTATION

{$R *.DFM}

PROCEDURE TFrm_Param.SpeedButton1Click(Sender: TObject);
VAR
    S: STRING;
BEGIN
    IF od4.execute THEN
    BEGIN
        S := IncludeTrailingBackslash(extractfilepath(od4.FileName));
        IF TSpeedButton(sender).tag = 1 THEN
            Ed_BaseVide.text := S;
        IF TSpeedButton(sender).tag = 2 THEN
            Ed_Backup.text := S;
        //IF TSpeedButton(sender).tag = 3 THEN
            //Ed_IPHUSKY.text := S;
        IF TSpeedButton(sender).tag = 4 THEN
            Ed_EAI.text := S;
    END;
END;

PROCEDURE TFrm_Param.FormCreate(Sender: TObject);
VAR
    ini: TIniFile;
BEGIN
    ini := tinifile.create(changefileext(application.exename, '.ini'));
    Ed_BaseVide.text := ini.readstring('PARAM', 'CHEMINVIDE', 'C:\BASEVIDE\');
    Ed_Backup.text := ini.readstring('PARAM', 'CHEMINBACKUP', 'C:\BACKUP\');
    Ed_PlaceHusky.text := ini.readstring('PARAM', 'PLACEIMPORT', 'C:\Ginkoia\Import_Husky.exe');
    //Ed_IPHUSKY.text := ini.readstring('PARAM', 'IP_HUSKY', 'C:\IP_HUSKY\');
    Ed_Parametrage.text := ini.readstring('PARAM', 'PARAMETRAGE', 'C:\Ginkoia\ParametrageGinkoia.exe');
    Ed_EAI.text := ini.readstring('PARAM', 'EAI', 'C:\Ginkoia\EAI\');
    ini.free;
END;

PROCEDURE TFrm_Param.OKBtnClick(Sender: TObject);
VAR
    ini: TIniFile;
BEGIN
    ini := tinifile.create(changefileext(application.exename, '.ini'));
    ini.Writestring('PARAM', 'CHEMINVIDE', Ed_BaseVide.text);
    ini.Writestring('PARAM', 'CHEMINBACKUP', Ed_Backup.text);
    ini.Writestring('PARAM', 'PLACEIMPORT', Ed_PlaceHusky.text);
    //ini.Writestring('PARAM', 'IP_HUSKY', Ed_IPHUSKY.text);
    ini.WriteString('PARAM', 'PARAMETRAGE', Ed_Parametrage.text);
    ini.WriteString('PARAM', 'EAI', Ed_EAI.text);
    ini.free;
END;

PROCEDURE TFrm_Param.SpeedButton3Click(Sender: TObject);
BEGIN
    IF od.execute THEN
    BEGIN
        Ed_PlaceHusky.text := Od.FileName;
    END;
END;

PROCEDURE TFrm_Param.SpeedButton5Click(Sender: TObject);
BEGIN
    IF od.execute THEN
    BEGIN
        Ed_Parametrage.text := Od.FileName;
    END;
END;

END.

