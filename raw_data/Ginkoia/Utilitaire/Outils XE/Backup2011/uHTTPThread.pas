unit uHTTPThread;

interface

  uses Classes, uCommon, uCommonThread,Windows , ComCtrls, sysUtils, Forms, idHttp, IdComponent, urlmon;


type THTTPThread = class(TCMNThread)
  private
  public
    procedure Execute;override;
  published
end;

implementation

{ TTCPThread }

procedure THTTPThread.Execute;
var
  Http : TIdHTTP;
  FileStream : TFileStream;
begin
  Http := TIdHTTP.Create;
  FileStream := TFileStream.Create(DestinationFile,fmCreate);
  try
    Try
      case Self.ActionMode of
        maCopy : begin
          // Création du/des répertoire/s de destination s'il n'existe pas
          DoDir(ExtractFilePath(DestinationFile));
          // traitement de la copie
          With Http do
          begin
            Http.OnWorkBegin := HttpOnWorkBegin;
            Http.OnWork      := HttpOnWork;
            Http.Put(SourceFile,FileStream);
          end;
        end;
        maZip: ZipFile;
       // maDel: DeleteFile(SourceFile);
      end;
    Except on E:Exception do
      Logs.Add('TCPThread -> ' + E.Message);
    End;
  finally
    Http.Free;
    FileStream.Free;
  end;
  IsTerminated := True;
end;

end.
