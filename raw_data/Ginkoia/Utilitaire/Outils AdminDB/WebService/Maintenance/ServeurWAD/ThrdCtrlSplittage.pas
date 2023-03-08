unit ThrdCtrlSplittage;

interface

uses
  Classes, SysUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.IBDef, FireDAC.Phys.IBBase,
  FireDAC.Phys.IB, FireDAC.Comp.Client, FireDAC.Comp.DataSet, dmdMaintenance;

type
  TThrdCtrlSplittage = class(TThread)
  private
    vSLExcept: TStringList;
    vQrySplit: TFDQuery;
    vSLTraceur: TStringList;
    procedure CentralControl;
  public
    constructor Create(CreateSuspended:boolean);
    destructor Destroy; override;
  protected
    procedure Execute; override;
  end;

implementation

uses uCommon, uCtrlMaintenance,  uMdlMaintenance, uVar;

{ TThrdCtrlSplittage }

procedure TThrdCtrlSplittage.CentralControl;
var
  vEMETTEUR: TEmetteur;
begin
  //écrivez ici ce que doit faire votre thread à un instant T donné
  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur.Append('CentralControl : ' + GetNowToStr);
  end;
  try
    vQrySplit.Close;
    vQrySplit.Open;
    vQrySplit.First;

    if vQrySplit.Eof then
      Suspend;

    vEMETTEUR:= GMaintenanceCtrl.EmetteurByID[vQrySplit.FieldByName('SPLI_EMETID').AsInteger];
    if vEMETTEUR <> nil then
      begin
          if VEmetteur.ADossier.DOSS_EASY=1 then
            begin
              vSLTraceur.Append('CentralControl : Dossier EASY');
              GMaintenanceCtrl.SplitEASY(vEMETTEUR, vQrySplit.FieldByName('SPLI_NOSPLIT').AsInteger);
            end
          else
            begin
              GMaintenanceCtrl.RunRecupBase(vEMETTEUR, vQrySplit.FieldByName('SPLI_NOSPLIT').AsInteger);
            end;
      end
    else
    begin
      if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
      begin
        vSLTraceur.Append('CentralControl : vEmetteur = Nil. EMET_ID = ' + vQrySplit.FieldByName('SPLI_EMETID').AsString);
      end;
    end;
  except
    on E: Exception do
      begin
        vSLExcept.Append('TThrdCtrlSplittage.CentralControl : ' + E.Message);
        GWSConfig.SaveFile(GWSConfig.ServiceFileName + GWSConfig.GetTime + '_TThrdCtrlSplittage_CentralControl.Except', vSLExcept, GWSConfig.LogException);
        Suspend;
      end;
  end;
end;

constructor TThrdCtrlSplittage.Create(CreateSuspended: boolean);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate:=false;
  Priority:=tpNormal;
  vSLExcept:= TStringList.Create;
  vQrySplit:= dmMaintenance.GetNewQry;
  vQrySplit.SQL.Text:= 'SELECT SPLI_NOSPLIT, SPLI_EMETID FROM SPLITTAGE_LOG WHERE SPLI_STARTED = 0 ORDER BY SPLI_ORDRE';
  vSLTraceur:= TStringList.Create;
  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur.Append('Create : ' + GetNowToStr);
  end;
end;

destructor TThrdCtrlSplittage.Destroy;
begin
  FreeAndNil(vSLExcept);
  FreeAndNil(vQrySplit);
  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur.Append('Destroy : ' + GetNowToStr);
    GWSConfig.SaveFile(GWSConfig.ServiceFileName + 'TThrdCtrlSplittage' + GWSConfig.GetTime + '.Traceur', vSLTraceur, GWSConfig.Traceur);
  end;
  FreeAndNil(vSLTraceur);
  inherited;
end;

procedure TThrdCtrlSplittage.Execute;
begin
  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur.Append('Début execute : ' + GetNowToStr);
  end;

  repeat
    Sleep(500); //en millisecondes
    //Synchronize(CentralControl);
    CentralControl;
  until Terminated;

  if GWSConfig.Options.Values['MODEDEBUG'] = '1' then
  begin
    vSLTraceur.Append('Fin execute : ' + GetNowToStr);
  end;
end;

end.
