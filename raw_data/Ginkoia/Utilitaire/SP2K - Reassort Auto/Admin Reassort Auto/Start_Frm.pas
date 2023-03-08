unit Start_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, uDefs, IniFiles, StrUtils, IniCfg_frm;

type
  TFrm_Start = class(TForm)
    Pan_fond: TRzPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
//    procedure LoadIni;
  end;

var
  Frm_Start: TFrm_Start;

implementation

{$R *.dfm}

procedure TFrm_Start.FormCreate(Sender: TObject);
begin
  // Chargement de la configuration
  try
    IniCfg.LoadIni;
  Except on E:Exception do
    raise Exception.Create('LoadIni -> ' + E.Message);
  end;
end;

//procedure TFrm_Start.LoadIni;
//begin
//  With TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
//  try
//    //Mode
//    IniStruct.IsDevMode := (ReadInteger('DEBUG','MODE',0) = 1);
//
//    if IniStruct.IsDevMode then
//    begin
//      // Dev
//      IniStruct.LoginDev    := ReadString('DEBUG','LOGIN','');
//      IniStruct.PasswordDev := CPASSWORD;
//      IniStruct.ServerDev   := ReadString('DEBUG','SERVER','');
//      IniStruct.CatalogDev  := ReadString('DEBUG','CATALOG','');
//    end
//    else
//    begin
//      // Prd
//      IniStruct.LoginPrd    := ReadString('DATABASE','LOGIN','');
//      IniStruct.PasswordPrd := CPASSWORD;
//      IniStruct.ServerPrd   := ReadString('DATABASE','SERVER','');
//      IniStruct.CatalogPrd  := ReadString('DATABASE','CATALOG','');
//    end;
//  finally
//    Free;
//  end;
//end;

end.
