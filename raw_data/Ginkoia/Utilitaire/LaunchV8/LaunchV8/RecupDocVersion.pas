unit RecupDocVersion;

interface

uses Classes, SysUtils, IBQuery, IBDatabase, IBODataset, uLog, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdIOHandler,
  IdIOHandlerStream, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, Windows;

type
  TThreadRecupDocDeVersion = class(TThread)
    private
      FIBDatabase: TIBDatabase;
      FFilePath: String;

      procedure RecupDocDeVersion;

    protected
      procedure Execute;   override;

    public
      constructor Create(CreateSuspended: Boolean);
      procedure Init(aIBDatabase: TIBDatabase; const sFilePath: String);
  end;

  procedure RecupDocDeVersion(aIBDatabase: TIBDatabase; const sFilePath: String);

var
  ThreadRecupDocDeVersion: TThreadRecupDocDeVersion;
  nNbTentatives: Integer;

implementation

uses LaunchV7_Frm;

procedure RecupDocDeVersion(aIBDatabase: TIBDatabase; const sFilePath: String);
begin
  // Si transfert pas déjà en cours.
  if(not Assigned(ThreadRecupDocDeVersion)) or (ThreadRecupDocDeVersion.Terminated) then
  begin
    // Si moins de 5 échecs.
    if nNbTentatives < 5 then
    begin
      ThreadRecupDocDeVersion := TThreadRecupDocDeVersion.Create(True);
      ThreadRecupDocDeVersion.Init(aIBDatabase, sFilePath);
      ThreadRecupDocDeVersion.Start;
    end;
  end;
end;

{ TThreadRecupDocDeVersion }

constructor TThreadRecupDocDeVersion.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
  FIBDatabase := nil;
  FFilePath := '';
end;

procedure TThreadRecupDocDeVersion.Init(aIBDatabase: TIBDatabase; const sFilePath: String);
begin
  FIBDatabase := aIBDatabase;
  FFilePath := sFilePath;
end;

procedure TThreadRecupDocDeVersion.Execute;
begin
  if(Assigned(FIBDatabase)) and (FFilePath <> '') then
    RecupDocDeVersion;
end;

procedure TThreadRecupDocDeVersion.RecupDocDeVersion;
{$REGION 'RecupDocDeVersion'}
  function GetRepertoireTemp: String;
  var
    Valeur: Array[0..Max_Path] of Char;
  begin
    GetTempPath(Length(Valeur), @Valeur);
    Result := valeur;
  end;
{$ENDREGION}
var
  sURLSource, sVersion, sFichierTemp: String;
  IB_RecupURL: TIBQuery;
  FluxFichier: TFileStream;
  IdHTTP: TIdHTTP;
  IdIOHandlerStream: TIdSSLIOHandlerSocketOpenSSL;  // TIdIOHandlerStream;
begin
  IB_RecupURL := TIBQuery.Create(nil);
  try
    IB_RecupURL.Database := FIBDatabase;
    IB_RecupURL.SQL.Add('select prm_string from genparam join K on K_id = prm_id and K_enabled = 1');
    IB_RecupURL.SQL.Add('where prm_code = 130 and prm_type = 3 and prm_magid = 0');
    IB_RecupURL.Open;
    if not IB_RecupURL.EOF then
    begin
      sURLSource := IB_RecupURL.Fields[0].AsString;

      IB_RecupURL.Close;
      IB_RecupURL.SQL.Clear;
      IB_RecupURL.SQL.Add('select VER_VERSION from GENVERSION');
      IB_RecupURL.SQL.Add('where VER_DATE = (select max(VER_DATE) from GENVERSION)');
      IB_RecupURL.Open;
      if not IB_RecupURL.EOF then
      begin
        sVersion := IB_RecupURL.Fields[0].AsString;
        sURLSource := StringReplace(sURLSource, '{%VER%}', 'v' + sVersion, [rfReplaceAll]);
        sFichierTemp := GetRepertoireTemp + 'Revision.pdf';
        Log.Log('RecupDocDeVersion', 'Log', 'Téléchargement du document de version [' + sURLSource + '] ...', logNotice, True, -1, ltLocal);

        // Téléchargement du fichier.
        IdIOHandlerStream := TIdSSLIOHandlerSocketOpenSSL.Create;
        IdHTTP := TIdHTTP.Create;
        try
          IdHTTP.IOHandler := IdIOHandlerStream;
          IdIOHandlerStream.ConnectTimeout := 5000;
          IdIOHandlerStream.ReadTimeout := 5000;

          FluxFichier := TFileStream.Create(sFichierTemp, fmCreate);
          try
            try
              IdHTTP.Get(sURLSource, FluxFichier);
            except
              on E: Exception do
              begin
                Inc(nNbTentatives);
                Log.Log('RecupDocDeVersion', 'Log', 'Échec du téléchargement du fichier [' + sURLSource + ']: ' + E.ClassName + ' - ' + E.Message, logError, True, -1, ltLocal);
                if nNbTentatives > 5 then
                  Log.Log('RecupDocDeVersion', 'Log', '>> 5 tentatives maximum.', logError, True, -1, ltLocal);
                Exit;
              end;
            end;
          finally
            FluxFichier.Free;
          end;

          // Si téléchargement réussi.
          if IdHTTP.ResponseCode = 200 then
          begin
            if CopyFile(PChar(sFichierTemp), PChar(FFilePath + 'BPL\revision.pdf'), False) then
            begin
              Log.Log('RecupDocDeVersion', 'Log', 'Téléchargement du document de version [' + sURLSource + '] terminé.', logInfo, True, -1, ltLocal);
              Synchronize(Frm_LaunchV7.SetLastDateRecup);
            end
            else
              Log.Log('RecupDocDeVersion', 'Log', 'Échec copie fichier :  ' + SysErrorMessage(GetLastError), logWarning, True, -1, ltLocal);
          end
          else
            Log.Log('RecupDocDeVersion', 'Log', 'Échec téléchargement fichier :  ' + IntToStr(IdHTTP.ResponseCode) + ' - ' + IdHTTP.ResponseText, logWarning, True, -1, ltLocal);
        finally
          IdHTTP.Free;
          IdIOHandlerStream.Free;
        end;
      end
      else
        Log.Log('RecupDocDeVersion', 'Log', 'Échec recherche version.', logWarning, True, -1, ltLocal);
    end;
    //else
      //Log.Log('RecupDocDeVersion', 'Log', 'Pas de paramètre.', logWarning, True, -1, ltLocal);

    IB_RecupURL.Close;
  finally
    IB_RecupURL.Free;
  end;
end;

initialization
  ThreadRecupDocDeVersion := nil;
  nNbTentatives := 0;
finalization
//  if Assigned(ThreadRecupDocDeVersion) and (not ThreadRecupDocDeVersion.Terminated) then
//    ThreadRecupDocDeVersion.Terminate;
end.

