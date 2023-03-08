unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, IB_Components, StdCtrls, ExtCtrls, ImgList, Midaslib;

type

  TMainForm = class(TForm)
    EDT_MONITOR: TButtonedEdit;
    ImageList1: TImageList;
    Label1: TLabel;
    EDT_MAINTENANCE: TButtonedEdit;
    Label2: TLabel;
    BTN_IMPORT: TButton;
    MEMO_LOG: TMemo;
    Label3: TLabel;
    BTN_LOG: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure EDT_MONITORRightButtonClick(Sender: TObject);
    procedure EDT_MAINTENANCERightButtonClick(Sender: TObject);
    procedure BTN_LOGClick(Sender: TObject);
    procedure BTN_IMPORTClick(Sender: TObject);
  private

  public
     procedure SetIBConnexion(Base : TIB_Connection; Chemin : string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses DM_MONITOR, DM_MAINTENANCE, DM_GINKOIA;

procedure TMainForm.EDT_MONITORRightButtonClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
      begin
      EDT_MONITOR.Text := OpenDialog1.FileName;
      SetIBConnexion(DMMonitor.IBCNX_MONITOR, OpenDialog1.FileName);
      end;
end;

procedure TMainForm.EDT_MAINTENANCERightButtonClick(Sender: TObject);
begin
   if OpenDialog1.Execute then
      begin
      EDT_MAINTENANCE.Text := OpenDialog1.FileName;
      SetIBConnexion(DMMaintenance.IBCNX_MAINTENANCE, OpenDialog1.FileName);
      end;
end;

procedure TMainForm.BTN_IMPORTClick(Sender: TObject);
begin
   if EDT_MONITOR.Text = '' then
      raise Exception.Create('Veuillez choisir la base Monitor');
   if EDT_MAINTENANCE.Text = '' then
      raise Exception.Create('Veuillez choisir la base Maintenance');
   if DMMaintenance.BaseVide then
      DMMaintenance.LancerImport
   else
      raise Exception.Create('La base contient déjà des données : impossible de lancer l''import initial');
end;

procedure TMainForm.BTN_LOGClick(Sender: TObject);
begin
   if SaveDialog1.Execute then
      MEMO_LOG.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TMainForm.SetIBConnexion(Base : TIB_Connection; Chemin : string);
var chn : String;
begin
   with Base do
        begin
        Connected := False;

//TODO : tester la modif du chemin
        if System.Copy(Chemin, 1, 2) = '\\' then
           begin
           System.Delete(Chemin, 1, 2);
           chn := System.Copy(Chemin, 1, System.Pos('\', Chemin)-1);
           chn := chn + ':D:'+ System.Copy(Chemin, System.Pos('\', Chemin), Length(Chemin));
           Params.Values[ 'PATH' ] := chn;
           end
        else
           Params.Values[ 'PATH' ] := Chemin;
        try
        Connected := True;
        finally
        end;
        end;
end;


end.
