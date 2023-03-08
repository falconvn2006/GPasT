unit Unite_Def;

interface
  Uses Sysutils,Registry, Windows, IniFiles,Forms;

  type
  TModeRun = (mrServer, mrClient);

  type
  TInfoBase = record
    public
      NomBase : String;
      CodeTiers : string;
      Magasin : String;
      Infos : record
        Adresse ,
        CodePostal,
        Ville ,
        Telephone : String;
      end;
      procedure SaveIni;
      procedure LoadIni;
  end;

  Var
    sPathProg, sPatchLog, sPatchPathXE, sPathTemp : String;
    InfoBase      : TInfoBase;
    InstallMode   : TModeRun;

implementation
procedure TInfoBase.SaveIni;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    WriteString('INFOBASE','NomBase',NomBase);
    WriteString('INFOBASE','CodeTiers',CodeTiers);
    WriteString('INFOBASE','Magasin',Magasin);
    WriteString('INFOBASE','Adresse',Infos.Adresse);
    WriteString('INFOBASE','CodePostal',Infos.CodePostal);
    WriteString('INFOBASE','Ville',Infos.Ville);
    WriteString('INFOBASE','Telephone',Infos.Telephone);
  finally
    Free;
  end;
end;

procedure TInfoBase.LoadIni;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    NomBase          := ReadString('INFOBASE','NomBase','');
    CodeTiers        := ReadString('INFOBASE','CodeTiers','');
    Magasin          := ReadString('INFOBASE','Magasin','');
    Infos.Adresse    := ReadString('INFOBASE','Adresse','');
    Infos.CodePostal := ReadString('INFOBASE','CodePostal','');
    Infos.Ville      := ReadString('INFOBASE','Ville','');
    Infos.Telephone  := ReadString('INFOBASE','Telephone','');
  finally
    Free;
  end;
end;

end.
