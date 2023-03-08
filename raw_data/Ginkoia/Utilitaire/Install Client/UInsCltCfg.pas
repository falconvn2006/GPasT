//$Log:
// 2    Utilitaires1.1         26/09/2006 11:02:53    pascal          rendu des
//      modifs
// 1    Utilitaires1.0         27/04/2005 15:53:36    pascal          
//$
//$NoKeywords$
//
UNIT UInsCltCfg;

INTERFACE

USES
    inifiles,
    Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
    Buttons, ExtCtrls, Dialogs;

TYPE
    TDial_Config = CLASS(TForm)
        OKBtn: TButton;
        CancelBtn: TButton;
        Bevel1: TBevel;
        Edit1: TEdit;
        Label1: TLabel;
        OD: TOpenDialog;
        SpeedButton1: TSpeedButton;
        Edit2: TEdit;
        Label2: TLabel;
        PROCEDURE SpeedButton1Click(Sender: TObject);
        PROCEDURE OKBtnClick(Sender: TObject);
        PROCEDURE FormCreate(Sender: TObject);
    PRIVATE
    { Private declarations }
    PUBLIC
    { Public declarations }
    END;

{
VAR
    Dial_Config: TDial_Config;
}
IMPLEMENTATION

{$R *.DFM}

PROCEDURE TDial_Config.SpeedButton1Click(Sender: TObject);
BEGIN
    IF od.execute THEN
        edit1.text := od.filename;
END;

PROCEDURE TDial_Config.OKBtnClick(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    ini := Tinifile.create(changefileext(application.exename, '.ini'));
    ini.writestring('GENERAL', 'BASE', edit1.text);
    ini.writestring('GENERAL', 'REP', IncludeTrailingBackslash(edit2.text));
    ini.free;
END;

PROCEDURE TDial_Config.FormCreate(Sender: TObject);
VAR
    ini: tinifile;
BEGIN
    ini := Tinifile.create(changefileext(application.exename, '.ini'));
    edit1.text := ini.Readstring('GENERAL', 'BASE', '');
    edit2.text := ini.Readstring('GENERAL', 'REP', '');
    ini.free;
END;

END.

