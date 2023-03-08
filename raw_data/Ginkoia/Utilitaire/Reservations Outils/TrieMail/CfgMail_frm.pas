unit CfgMail_frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TMode = (tmInsert, tmEdit);

  Tfrm_CfgMail = class(TForm)
    Pan_Bottom: TPanel;
    Nbt_Cancel: TBitBtn;
    Nbt_Post: TBitBtn;
    Pan_client: TPanel;
    Lab_Boite: TLabel;
    Lab_Host: TLabel;
    Lab_User: TLabel;
    Lab_Password: TLabel;
    edt_Boite: TEdit;
    edt_Host: TEdit;
    edt_User: TEdit;
    edt_Password: TEdit;
    Rgr_Type: TRadioGroup;
    Rgr_Suppression: TRadioGroup;
    Memo_MagAExclure: TMemo;
    Lab_MagAExclure: TLabel;
    Lab_MagAExclureDesc: TLabel;
    procedure Nbt_PostClick(Sender: TObject);
  private
    FMode: TMode;
    function GetBoite: String;
    procedure SetBoite(const Value: String);
    function GetHost: String;
    procedure SetHost(const Value: String);
    function GetUser: String;
    procedure SetUser(const Value: String);
    function GetPwd: String;
    procedure SetPwd(const Value: String);
    function GetType: Integer;
    procedure SetType(const Value: Integer);
    function GetDel: Integer;
    procedure SetDel(const Value: Integer);
    function GetMagsAExclure: String;
    procedure SetMagsAExclure(const Value: String);
    { Déclarations privées }
  public
    { Déclarations publiques }
  published
    Property Mode : TMode read FMode write FMode;

    Property Boite : String read GetBoite write SetBoite;
    property Host : String read GetHost write SetHost;
    property User : String read GetUser write SetUser;
    property Pwd  : String read GetPwd  write SetPwd;
    property TypeMail : Integer read GetType write SetType;
    property DelMail : Integer read GetDel write SetDel;
    property MagsAExclure : String read GetMagsAExclure write SetMagsAExclure;
  end;

var
  frm_CfgMail: Tfrm_CfgMail;

implementation

{$R *.dfm}

{ Tfrm_CfgMail }

function Tfrm_CfgMail.GetBoite: String;
begin
  Result := edt_Boite.Text;
end;

function Tfrm_CfgMail.GetDel: Integer;
begin
  Result := Rgr_Suppression.ItemIndex;
end;

function Tfrm_CfgMail.GetHost: String;
begin
  Result := edt_Host.Text;
end;

function Tfrm_CfgMail.GetMagsAExclure: String;
begin
  Result := Memo_MagAExclure.Text;
end;

function Tfrm_CfgMail.GetPwd: String;
begin
  Result := edt_Password.Text;
end;

function Tfrm_CfgMail.GetType: Integer;
begin
  Result := Rgr_Type.ItemIndex;
end;

function Tfrm_CfgMail.GetUser: String;
begin
  Result := edt_User.Text;
end;

procedure Tfrm_CfgMail.Nbt_PostClick(Sender: TObject);
begin
  if trim(edt_Boite.Text) = '' then
  begin
    ShowMessage('Veuillez saisir un nom de boite mail');
    Exit;
  end;

  if trim(edt_Host.Text) = '' then
  begin
    ShowMessage('Veuillez saisir un host');
    Exit;
  end;

  if trim(edt_User.Text) = '' then
  begin
    ShowMessage('Veuillez saisir un user');
    Exit;
  end;

  if trim(edt_Password.Text) = '' then
  begin
    ShowMessage('Veuillez saisir un mot de passe');
    Exit;
  end;

  if (Rgr_Type.ItemIndex = -1) then
  begin
    ShowMessage('Veuillez sélectionner un type');
    Exit;
  end;

  ModalResult := mrOk;
end;

procedure Tfrm_CfgMail.SetBoite(const Value: String);
begin
  edt_Boite.Text := Value;
end;

procedure Tfrm_CfgMail.SetDel(const Value: Integer);
begin
  Rgr_Suppression.ItemIndex := Value;
end;

procedure Tfrm_CfgMail.SetHost(const Value: String);
begin
  edt_Host.Text := Value;
end;

procedure Tfrm_CfgMail.SetMagsAExclure(const Value: String);
begin
  Memo_MagAExclure.Text := Value;
end;

procedure Tfrm_CfgMail.SetPwd(const Value: String);
begin
  edt_Password.Text := Value;
end;

procedure Tfrm_CfgMail.SetType(const Value: Integer);
begin
  Rgr_Type.ItemIndex := Value;
end;

procedure Tfrm_CfgMail.SetUser(const Value: String);
begin
  edt_User.Text := Value;
end;

end.
