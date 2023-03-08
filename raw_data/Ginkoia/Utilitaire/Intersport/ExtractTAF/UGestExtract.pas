unit UGestExtract;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.IniFiles, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdFTP,
  UThreadExtract;

type
  TGestExtract = class
  private
    FConnection : TFDConnection;
    FThread : TThreadExtract;
    FIni : TIniFile;
    FFTP : TIdFtp;
    FPathFtp : string;
    FCodeMag : string;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

implementation

{ TGestExtract }

constructor TGestExtract.Create;
begin
  FIni := TIniFile.Create(ChangeFileExt(ParamStr(0),'ini'));
  FConnection.ConnectionString := 'DriverID=IB;Database='+FIni.ReadString('BASE','Fichier','C:\Ginkoia\Data\Ginkoia.IB')+';User_Name=SYSDBA;Password=masterkey;'
                                    +'InstanceName=gds_db';

  FFTP := TIdFTP.Create(nil);
  FFTP.Host := FIni.ReadString('FTP','Host','');
  FFTP.Port := FIni.ReadInteger('FTP','Port',21);
  FFTP.Username := FIni.ReadString('FTP','Username','');
  FFTP.Password := FIni.ReadString('FTP','Password','');
  FPathFtp := FIni.ReadString('FTP','Path','');

  FCodeMag := FIni.ReadString('Magasin','CodeMag','');

  FIni.Free;
end;

destructor TGestExtract.Destroy;
begin
  FFTP.Free;

  FConnection.Free;
  inherited;
end;

end.
