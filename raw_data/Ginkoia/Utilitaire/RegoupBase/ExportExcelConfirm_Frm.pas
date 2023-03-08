unit ExportExcelConfirm_Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLabel, LMDCustomButton, LMDButton, ExtCtrls;

type
  TFrm_ExportExcelConfirm = class(TForm)
    Lab_Titre: TRzLabel;
    Lab_Nom: TRzLabel;
    Chk_OuvrirExcel: TCheckBox;
    Bevel1: TBevel;
    Nbt_Ok: TLMDButton;
    Nbt_Cancel: TLMDButton;
  private
    { Déclarations privées }
    procedure WMSysCommand(var Msg: TWMSyscommand); message WM_SYSCOMMAND;
  public
    { Déclarations publiques }
    procedure SetInit(AFilename: string);
  end;

var
  Frm_ExportExcelConfirm: TFrm_ExportExcelConfirm;

implementation

{$R *.dfm}

procedure TFrm_ExportExcelConfirm.SetInit(AFilename: string);
begin
  Lab_Nom.Caption := AFilename;
end;

procedure TFrm_ExportExcelConfirm.WMSysCommand(var Msg: TWMSyscommand);
begin
  // intercepte le clic sur le bouton minimise
  if ((msg.CmdType and $FFF0) = SC_MINIMIZE) then begin  
    Msg.Result:=1;
    Application.Minimize;
    exit;
  end;
  inherited;
end;

end.
