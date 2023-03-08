unit uThreadDB;

interface

Uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Phys.IBDef, FireDAC.Stan.Def,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Phys, FireDAC.Stan.Intf,
  FireDAC.Phys.IB, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Pool, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, Vcl.StdCtrls, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, Vcl.ComCtrls, FireDAC.Phys.FBDef, FireDAC.Phys.FB, ShellAPi,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, System.Win.Registry,
  Vcl.ExtCtrls, Math, UWMI, System.IniFiles, System.DateUtils;

Type
  TStatusMessageCall = Procedure (const info:String) of object;
  TThreadImport = class(TThread)
  private
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FEASY_BIN_DIR  : string;
    FTABLENAME     : string;
    FFileNameCSV   : TFileName;
    FFileNameDONE  : TFileName;
    FNbError       : integer;
   { Déclarations privées }
    FDone : boolean;
  protected
    procedure Etape_DBImport();
    procedure Etape_Rename();
  public
    procedure Execute; override;
    constructor Create(aTABLENAME:string; const aType:string;
      const AEvent: TNotifyEvent = nil); reintroduce;
    property NbError : integer read FNbError;
  end;

  // un seul thread pour désactiver les index
  TThreadDesactiveIndex = class(TThread)
  private
  { Déclarations privées }
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FIBFile        : string;
    FNbError       : integer;
    FDone : boolean;
  protected
    procedure StatusCallBack();
    procedure DesactiveINDEX(aIDXNAME:string);
    procedure Execute; override;
  public
    constructor Create(aIBFile:TFileName;
      aStatusCallBack : TStatusMessageCall;
      aEvent:TNotifyEvent=nil); reintroduce;
    property NbError : integer read FNbError;
  end;

  TThreadActiveIndex = class(TThread)
  private
  { Déclarations privées }
    FStatusProc    : TStatusMessageCall;
    FStatus        : string;
    FNbError       : integer;
  protected
    { -- }
  public
    procedure Execute; override;
    constructor Create(aTABLENAME:string; const AEvent: TNotifyEvent = nil); reintroduce;
    property NbError : integer read FNbError;
  end;

implementation

Uses uProcess,UDataMod;

{ ---------------------------- TThreadImport ------------------------------------- }

constructor TThreadImport.Create(aTABLENAME:string; const aType:string; Const AEvent: TNotifyEvent = nil);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  FTABLENAME      := UpperCase(aTableName);
  FFileNameCSV    := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+  aType +'\' + aTableName + '.csv';
  FFileNameDone   := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+  aType +'\' + aTableName + '.done';
  OnTerminate     := AEvent;
end;

procedure TThreadImport.Etape_Rename();
var chaine:string;
    merror:string;
    a:cardinal;
begin
     try
        try
          If not(RenameFile(FFileNameCSV, FFileNameDone))
            then
              begin
                raise Exception.Create('Erreur au renommage');
              end;
          // FStatus:=Format('Renommage de la base %s en %s : [OK]',[ExtractFileName(FGINKOIA_IB),ExtractFileName(FSAV)]);
          // Synchronize(StatusCallBack);
        Except On E:Exception do
          begin
            inc(FnbError);
            raise;
          end;
        end;
     finally
        // Synchronize(StatusCallBack);
     end;
end;


procedure TThreadImport.Etape_DBImport();
var vParams:string;
    vCall:string;
    merror  : string;
    a       : cardinal;
begin
    // dbimport %s --force --format=CSV --table %s
    try
      vParams := Format('%s --force --format=CSV --table %s',[FFileNameCSV,FTABLENAME]);
      vCall   := Format('%s\bin\dbimport.bat',[FEASY_BIN_DIR]);
      a:=ExecAndWaitProcess(merror,vCall,vParams);
    finally

    end;
end;

procedure TThreadImport.Execute;
begin
  try
    try
      // GetInfos();
      if FileExists(FFileNameCSV)
        then
          begin
            Etape_DBImport();
            Etape_Rename();
          end
      else
        begin
          // Fichier pas là !
        end;
    Except
      //
    end;
  finally
  end;
end;

constructor TThreadActiveIndex.Create(aTABLENAME:string; Const AEvent: TNotifyEvent = nil);
begin
  inherited Create(true);
  FreeOnTerminate := true;
  OnTerminate := AEvent;
end;


procedure TThreadActiveIndex.Execute;
begin
  try
    try
      // GetInfos();


    Except
      //
    end;
  finally
  end;
end;

constructor TThreadDesactiveIndex.Create(aIBFile:TFileName;
    aStatusCallBack : TStatusMessageCall;
    aEvent:TNotifyEvent=nil);
begin
  inherited Create(true);
  FIBFile         := aIBFILE;
  FStatusProc     := aStatusCallBack;
  FreeOnTerminate := true;
  OnTerminate := AEvent;
end;

procedure TThreadDesactiveIndex.Execute;
begin
  try
    try
      FStatus:='Désactivation des INDEX';
      Synchronize(StatusCallBack);
      DesactiveINDEX('K_2');
      DesactiveINDEX('K_3');
    Except
      //
    end;
  finally

  end;
end;

procedure TThreadDesactiveIndex.StatusCallBack();
begin
   if Assigned(FStatusProc) then  FStatusProc(FStatus);
end;


procedure TThreadDesactiveIndex.DesactiveINDEX(aIDXNAME:string);
var vCnx:TFDConnection;
    vQuery:TFDQuery;
begin
    vCnx   := DataMod.getNewConnexion('SYSDBA@'+FIBFile);
    vQuery := DataMod.getNewQuery(vCnx,nil);
    try
      try
        vQuery.Close;
        vQuery.SQL.Clear;
        vQuery.SQL.Add(Format('ALTER INDEX %s INACTIVE;',[UpperCase(aIDXNAME)]));
        vQuery.OptionsIntf.UpdateOptions.ReadOnly := False;
        vQuery.ExecSQL;
        vQuery.Close;
      Except

      end;
    finally
      vQuery.DisposeOf;
      vCnx.DisposeOf;
    end;
end;
end.
