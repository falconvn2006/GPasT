unit Constante_CBR;

interface

uses Classes, Contnrs, IniFiles, SysUtils, Forms;

type

  // les provenances en MAJUSCULE viennent de CONSOMONITOR et en minuscule de YELLIS
  TTypeTableProvenance = (tpAucun, tpClients, tpEmetteur, tpFichiers, tpHisto, tpPlageMAJ, tpSpecifique,
                          tpVersion, tpSRV, tpGRP, tpDossier, tpHDB, tpRAISON);

  TTypeMaTable = class(TObject)
    Libelle        : String;
    ATraiter       : Boolean;
    MAJAuto        : Boolean;
    Last_Id        : Integer;
    Last_IdSVG     : Integer;
    TableOrigine   : String;
    TypeProvenance : TTypeTableProvenance;
  end;

var
  vgObjlTable : TObjectList;

  vgIniFile     : TIniFile;
  vgFichierIni  : string = '';
  vgRepertoire  : string = '';

const
  E1 : String = ' ';
  E2 : String = '  ';
  E3 : String = '   ';
  E4 : String = '    ';
  E5 : String = '     ';

implementation


end.
