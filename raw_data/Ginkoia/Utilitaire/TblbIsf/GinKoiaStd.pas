unit GinKoiaStd;

interface

uses
  SysUtils,
  Classes,
  LMDCustomComponent,
  LMDIniCtrl,
  LmdSBtn,
  RzDbBnEd,
  lmdcont,
  dxBar,
  LMDCustomSpeedButton,
  Buttons,
  LMDSpeedButton,
  Graphics,
  MidasLib,
  dxDBGridHP;

type
  TStdGinKoia = class(TDataModule)
    IniCtrl: TLMDIniCtrl;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure AffecteHintEtBmp(aControl: TObject);
    procedure InfoMess(aTitre, aMsg: string);
    function OuiNon(aTitre, aMsg: string; aDefault: boolean): boolean;
    function UserCanModify(aType: string): boolean;
    function UserVisuMags: boolean;

    procedure SaveOrLoadDBGGrilleConfiguration(Param1 : boolean; Param2 : TdxDBGridHP; Param3 : boolean);
  end;

var
  StdGinKoia: TStdGinKoia;

implementation
uses
  Forms,
  dialogs, controls;
{$R *.DFM}

procedure TStdGinKoia.DataModuleCreate(Sender: TObject);
begin
  IniCtrl.IniFile := ChangeFileExt(Application.ExeName, '.ini');
end;

procedure TStdGinKoia.InfoMess(aTitre, aMsg: string);
begin;
  MessageDlg (aTitre + ': ' + aMsg, mtInformation, [mbOK], 0);
end;

procedure TStdGinKoia.AffecteHintEtBmp(aControl: TObject);
begin;
end;

function TStdGinKoia.UserVisuMags: boolean;
begin;
  result := true;
end;

function TStdGinKoia.UserCanModify(aType: string): boolean;
begin;
  result := true;
end;

function TStdGinKoia.OuiNon(aTitre, aMsg: string; aDefault: boolean): boolean;
begin;
  result := MessageDlg (aTitre + ': ' + aMsg, mtInformation, [mbYes, mbNo], 0) = mrYes;
end;

procedure TStdGinKoia.SaveOrLoadDBGGrilleConfiguration(Param1 : boolean; Param2 : TdxDBGridHP; Param3 : boolean);
begin
  // rin !
end;

end.
