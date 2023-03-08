unit UIni;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShlObj, Winapi.ActiveX,
  System.SysUtils, System.Variants, System.Classes, System.Types,
  System.IOutils, System.Win.registry, System.StrUtils, System.Win.ComObj,
  Vcl.Forms,
  //Uses Perso
  uFunctions,
  uRessourcestr,
  Inifiles,
  //Fin Uses
  Data.DB, FireDAC.Comp.Client;  // supprimer dialog

Type

  TUIni = class
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    IniParam : TIniFile;
    Constructor Create (aPath : String);
  published
    { Déclarations published }
  end;

implementation

{ TUIni }

constructor TUIni.Create(aPath: String);
begin
  //Création ou ouverture du fichier .Ini

end;

end.
