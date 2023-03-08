unit MSS_ClassSurcharge;

interface

// UNITE permettant d'ajouter des fonctionnalités aux composants existant
// Elle doit toujours être placé à la fin des uses de la partie interface
// (surtout après les unités qu'elle surcharge)
// Afin que les surcharges soient prises en compte.


uses StdCtrls, Spin, SysUtils, ExtCtrls;

type
  TEdit = Class(StdCtrls.TEdit)
    Private
      FOldValue : String;
      procedure FSetOldValue(AValue : String);
      function FGetOldValue : String;
    published
      function IsDifferent : Boolean;
      property OldValue : String read FGetOldValue write FSetOldValue;
  End;

  TSpinEdit = Class(Spin.TSpinEdit)
    private
      FOldValue : Integer;
    Private
      procedure FSetOldvalue(AValue : Integer);
      function FGetOldValue : Integer;
    published
      function IsDifferent : Boolean;

      property OldValue : Integer read FGetOldValue write FSetOldValue;

  End;

  TRadioGroup = Class(ExtCtrls.TRadioGroup)
    private
      FOldValue : Integer;
     Procedure FSetOldValue (AValue : Integer);
     function FGetOldValue : Integer;
    published
      function IsDifferent : Boolean;

      property OldValue : Integer read FGetOldValue Write FSetOldValue;
  End;

implementation


{TRadioGroup}

function TRadioGroup.FGetOldValue: Integer;
begin
  Result := FOldValue;
end;

procedure TRadioGroup.FSetOldValue(AValue: Integer);
begin
  Self.ItemIndex := AValue;
  FOldValue := AValue;
end;

function TRadioGroup.IsDifferent: Boolean;
begin
  Result := Self.ItemIndex <> FOldValue;
end;

{ TEdit }

function TEdit.FGetOldValue: String;
begin
  Result := FOldValue;
end;

procedure TEdit.FSetOldValue(AValue: String);
begin
  FOldValue := AValue;
  Text := AValue;
end;

function TEdit.IsDifferent: Boolean;
begin
  Result := trim(Self.Text) <> trim(FOldValue);
end;

{ TSpinEdit }

function TSpinEdit.FGetOldValue: Integer;
begin
  Result := FOldValue;
end;

procedure TSpinEdit.FSetOldvalue(AValue: Integer);
begin
  Self.Value := AValue;
  FOldValue := AValue;
end;

function TSpinEdit.IsDifferent: Boolean;
begin
  Result := Self.Value <> FOldValue;
end;

end.
