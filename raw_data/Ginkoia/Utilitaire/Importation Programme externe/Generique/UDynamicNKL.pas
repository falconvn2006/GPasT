unit UDynamicNKL;

interface

uses
  StdCtrls, Controls;

type
  TDynamicNKL = class
  strict private
    Fname : string;
    Fparent : TWinControl;
    Findex : Integer;

    FactID : Integer;
    FuniID : Integer;
    FssfID : Integer;

    FaxeLabel : TLabel;
    FssfEdit : TEdit;
    FssfLabel : TLabel;

    function getSsfCodeFinal() : string;
  public
    constructor Create(aParent : TWinControl; aName : string; aIndex, aActID, aUniID : Integer; aSsfCodeFinal : string); overload;
    destructor Destroy(); override;

    procedure SetLabel(aNom : string; aSsfID : Integer; aInRed : Boolean = False);
    procedure SetEnabled(aValue : Boolean);

    property UniID : Integer read FuniID;
    property ActID : Integer read FactID;
    property SsfID : Integer read FssfID;
    property SsfCodeFinal : string read getSsfCodeFinal;
    property Enabled : Boolean write SetEnabled;
    property Name : string read Fname; 
  end;

implementation

uses
    SysUtils, Messages, Forms, Graphics;


{ TDynamicNKL }

constructor TDynamicNKL.Create(aParent: TWinControl; aName: string; aIndex, aActID, aUniID : Integer; aSsfCodeFinal : string);
begin
  inherited Create();
  Fparent := aParent;
  Fname := aName;
  Findex := aIndex;

  FuniID := aUniID;
  FactID := aActID;

  FaxeLabel := TLabel.Create(nil);
  FaxeLabel.Font.Size := 7;
  FaxeLabel.Font.Color := clNavy;
  FaxeLabel.Parent := Fparent;
  FaxeLabel.Left := 21;
  FaxeLabel.Top := 9 + ((Findex) * 30) - TScrollBox(aParent).vertscrollbar.position;
  FaxeLabel.Caption := UpperCase(Fname);

  FssfEdit := TEdit.Create(nil);
  FssfEdit.Parent := Fparent;
  FssfEdit.Left := 228;
  FssfEdit.Width := 94;
  FssfEdit.Top := 3 + ((Findex) * 30) - TScrollBox(aParent).vertscrollbar.position;
  FssfEdit.Text := aSsfCodeFinal;

  FssfLabel := TLabel.Create(nil);
  FssfLabel.Font.Size := 7;
  FssfLabel.Font.Color := clNavy;
  FssfLabel.Parent := Fparent;
  FssfLabel.Left := 328;
  FssfLabel.Top := 9 + ((Findex) * 30) - TScrollBox(aParent).vertscrollbar.position;
  FssfLabel.Caption := '';
end;

destructor TDynamicNKL.Destroy;
begin
  FaxeLabel.Parent := nil;
  FreeAndNil(FaxeLabel);

  FssfEdit.Parent := nil;
  FreeAndNil(FssfEdit);

  FssfLabel.Parent := nil;
  FreeAndNil(FssfLabel);
  inherited Destroy();
end;


function TDynamicNKL.getSsfCodeFinal: string;
begin
  Result := FssfEdit.Text;
end;

procedure TDynamicNKL.SetLabel(aNom: string; aSsfID : Integer; aInRed: Boolean);
begin
  FssfLabel.Caption := aNom;

  if aInRed then
  begin
    FssfLabel.Font.Color := clMaroon;
    FssfLabel.Font.Style := [fsBold];
    FssfID := -1;
  end
  else
  begin
    FssfLabel.Font.Color := clNavy;
    FssfLabel.Font.Style := [];
    FssfID := aSsfID;
  end;
end;

procedure TDynamicNKL.SetEnabled(aValue: Boolean);
begin
  FssfEdit.Enabled := aValue;
end;

end.
