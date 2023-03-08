unit IFC_CFGParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvGlowButton, StdCtrls, RzLabel, ExtCtrls, RzPanel, Buttons, IFC_Type;

type
  Tfrm_CFGParams = class(TForm)
    Pan_Btn: TRzPanel;
    Pan_Edition: TRzPanel;
    Lab_Ou: TRzLabel;
    Nbt_Cancel: TRzLabel;
    Nbt_Post: TAdvGlowButton;
    Gbx_Base: TGroupBox;
    Lab_Base: TLabel;
    edt_Base: TEdit;
    Nbt_FileDir: TBitBtn;
    OD_FileIB: TOpenDialog;
    Gbx_Vide: TGroupBox;
    procedure Nbt_FileDirClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Nbt_PostClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Nbt_CancelClick(Sender: TObject);
  private
    { Déclarations privées }
    function CheckData : Boolean;
  public
    { Déclarations publiques }
  end;

var
  frm_CFGParams: Tfrm_CFGParams;

implementation

{$R *.dfm}

function Tfrm_CFGParams.CheckData: Boolean;
begin
  Result := False;
  if edt_Base.Text = '' then
  begin
    ShowMessage('Veuillez sélectionner une base de donneées');
    edt_Base.SetFocus;
    Exit;
  end;

  Result := True;
end;

procedure Tfrm_CFGParams.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  IniCfg.LoadIni;
end;

procedure Tfrm_CFGParams.FormCreate(Sender: TObject);
begin
  IniCfg.LoadIni;
  edt_Base.Text := IniCfg.Database;
end;

procedure Tfrm_CFGParams.Nbt_CancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tfrm_CFGParams.Nbt_FileDirClick(Sender: TObject);
begin
  if OD_FileIB.Execute then
  begin
    edt_Base.Text := OD_FileIB.FileName;
    IniCfg.Database := OD_FileIB.FileName;
  end;
end;

procedure Tfrm_CFGParams.Nbt_PostClick(Sender: TObject);
begin
  if CheckData then
  begin
    IniCfg.SaveIni;
    ModalResult := mrOk;
  end;
end;

end.
