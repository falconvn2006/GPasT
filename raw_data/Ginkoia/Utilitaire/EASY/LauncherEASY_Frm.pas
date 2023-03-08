unit LauncherEASY_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Winapi.ShellAPI,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Comp.UI,FireDAC.Stan.Def,
  FireDAC.Phys.IBDef, FireDAC.Phys, FireDAC.Phys.IBBase, FireDAC.Phys.IB;

const sEASY = 'EASY';

type
  TFrm_LauncherEasy = class(TForm)
    BitBtn1: TBitBtn;
    mLog: TMemo;
    Label1: TLabel;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FIBFile     : string;
    FBase0      : string;
    FGinkoiaDir : string;
    procedure InitInfos();
    { Déclarations privées }
  public
    property IBFile     : string read FIBFile;
    property Base0      : string read FBase0;
    property GinkoiaDir : string read FGinkoiaDir;
    { Déclarations publiques }
  end;

var
  Frm_LauncherEasy: TFrm_LauncherEasy;

implementation

{$R *.dfm}

Uses UWMI,SymmetricDS.Commun,ServiceControler,UCommun, UIBUtilsThread;


procedure TFrm_LauncherEasy.FormCreate(Sender: TObject);
begin
    InitInfos();
end;

procedure TFrm_LauncherEasy.InitInfos();
var i:integer;
begin
    BitBtn1.Enabled:=false;
    WMI_GetServicesSYMDS;
    GetDatabases;
    FBase0 := UpperCase(Readbase0);
    FIBFile := UpperCase(VGIB[0].DatabaseFile);
    FGinkoiaDir := ExtractFilePath(ExcludeTrailingPathDelimiter(ExtractFilePath(FBase0)));
    for i:=0 to Length(VGSYMDS)-1 do
       begin
        if VGSYMDS[i].ServiceName=sEASY
          then
              begin
                // il faut une correspondance entre readbase0 et le fichier properties
                // Readbase0;
                Label1.Caption := 'Etat du service de réplication '+ sEASY+ ' : ' + VGSYMDS[i].Status;
                If IBFile<>Base0
                    then
                      begin
                        Label1.Caption :=
                          Format('Erreur la Base0 n''est pas la même base que dans le fichier %s',[VGIB[0].PropertiesFile]);
                      end
                  else BitBtn1.Enabled:=true;
              end;
       end;
end;



procedure TFrm_LauncherEasy.BitBtn1Click(Sender: TObject);
var aSEASY:TInfoSurService;
    vBackRes : string;
    vthread : TBaseBackRestThread;
begin
    BitBtn1.Enabled:=false;
    If (ServiceGetStatus('',sEasy)=4)
      then
        begin
            ArreterService('EASY');
            // 3s
            Sleep(3000);
        end;

  // Si Service EASY Arreté
  If (ServiceGetStatus('',sEasy)=1)
      then
        begin
            {vBackRes    := FGinkoiaDir+'BackRest.Exe';
            IF FileExists(vBackRes) THEN
              BEGIN
                  ShellExecute(0, 'OPEN', PChar(vBackRes),' auto', '', SW_SHOWNORMAL);
              END;
            }
            vthread := TBaseBackRestThread.Create('localhost', FBase0, 3050);
            try
              while WaitForSingleObject(vthread.Handle, 100) = WAIT_TIMEOUT do
                begin
                   Application.ProcessMessages();
                end;
              ExitCode := vthread.ReturnValue;
            finally
              FreeAndNil(vthread);
            end;
        end;
end;

end.
