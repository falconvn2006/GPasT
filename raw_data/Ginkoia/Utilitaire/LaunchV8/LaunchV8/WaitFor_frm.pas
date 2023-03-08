unit WaitFor_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvGlowButton, ExtCtrls, RzPanel, GinPanel;

type
  Tfrm_WaitFor = class(TForm)
    GinPanel1: TGinPanel;
    Btn_APropos: TAdvGlowButton;
    Lab_WaitServeur: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Btn_AProposClick(Sender: TObject);
  private
    { Déclarations privées }
    FBtnState : Boolean ;
    FCanClose : Boolean ;
    FOnAbort  : TNotifyEvent ;
  public
    { Déclarations publiques }
    property BtnState : Boolean read FBtnState;
    property onAbort : TNotifyEvent read fOnAbort write fOnAbort ;
  end;

var
  frm_WaitFor: Tfrm_WaitFor;

implementation

{$R *.dfm}

procedure Tfrm_WaitFor.Btn_AProposClick(Sender: TObject);
begin
    FCanClose := True;
    FBtnState := True;

    if Assigned(fOnAbort) then
    begin
        try
            fOnAbort(Self) ;
        except
        end;
    end;
end;

procedure Tfrm_WaitFor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCanClose;
end;

procedure Tfrm_WaitFor.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FBtnState := False;
end;

end.
