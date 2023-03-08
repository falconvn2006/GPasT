unit UCompareXMLThread;

interface

uses
  System.Classes,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  UBaseThread,
  uCreateProcess,
  UVerificationBase;

type
  TCompareXMLThread = class(TBaseIBThread)
  protected
    FXMLFile : string;

    procedure Execute(); override;
  public
    constructor Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; XMLFile : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean = false); reintroduce;
    destructor Destroy(); override;
    function GetErrorLibelle(ret : integer) : string; override;
  end;

implementation

uses
  Winapi.ActiveX,
  System.SysUtils,
  uGestionBDD;

{ TCompareXMLThread }

procedure TCompareXMLThread.Execute();
// code de retour :
// 0 - reussite
// 1 - Chargement de la structure KO
// 2 - Exception
// 3 - Autre erreur
var
  Verif : TDataBaseVerif;
begin
  ReturnValue := 3;
  ProgressStyle(pbstMarquee);

  Verif := nil;

  try
    CoInitialize(nil);

    try
      try
        Verif := TDataBaseVerif.Create();
        if Verif.FillFromDatabase(FServeur, FDataBase, CST_BASE_LOGIN, CST_BASE_PASSWORD, FPort) then
        begin
          Verif.SaveToXml(FXMLFile);
          ReturnValue := 0
        end
        else
          ReturnValue := 1;
      finally
        FreeAndNil(Verif);
      end;
    except
      on e : Exception do
      begin
        DoLog('!! Exception : ' + e.ClassName + ' - ' + e.Message);
        ReturnValue := 2;
      end;
    end;
  finally
    CoUninitialize();
  end;
end;

constructor TCompareXMLThread.Create(OnTerminateThread : TNotifyEvent; StdStream : TStdStream; FileLog, Serveur, DataBase : string; Port : integer; XMLFile : string; Progress : TProgressBar; StepLbl : TLabel; CreateSuspended : Boolean);
begin
  Inherited Create(OnTerminateThread, StdStream, FileLog, Serveur, DataBase, Port, Progress, StepLbl, CreateSuspended);
  FXMLFile := XMLFile;
end;

destructor TCompareXMLThread.Destroy();
begin
  Inherited Destroy();
end;

function TCompareXMLThread.GetErrorLibelle(ret : integer) : string;
begin
  case ret of
    0 : Result := 'Traitement effectué correctement.';
    1 : Result := 'Erreur lors de la création du fichier.';
    2 : Result := 'Exception lors du traitement.';
    else Result := 'Autre erreur lors du traitement : ' + IntToStr(ret);
  end;
end;

end.
