unit IniCfg_ClassSurcharge;

interface

Uses StdCtrls, Spin, Classes, Graphics, Forms, TypInfo;

type
  TControlState = (csNormal, csError, csObligatoire);

  TEdit = class(StdCtrls.TEdit)
  private
    FIsState: TControlState;
    FIsConfiguration: TControlState;
    function GetFontColor: TColor;
    procedure SetFontColor(const Value: TColor);
  published
    public
      constructor Create(AOwner : TComponent);override;
    published
      property IsConfiguration : TControlState read FIsConfiguration write FIsConfiguration;
      property IsState : TControlState read FIsState write FIsState;
      property FontColor : TColor read GetFontColor write SetFontColor;
  end;

  TSpinEdit = class(Spin.TSpinEdit)
  private
    FIsState: TControlState;
    FIsConfiguration: TControlState;
    function GetFontColor: TColor;
    procedure SetFontColor(const Value: TColor);
  published
    public
      constructor Create(AOwner : TComponent);override;
    published
      property IsConfiguration : TControlState read FIsConfiguration write FIsConfiguration;
      property IsState : TControlState read FIsState write FIsState;
      property FontColor : TColor read GetFontColor write SetFontColor;
  end;

  TMemo = class(StdCtrls.TMemo)
  private
    FIsState: TControlState;
    FIsConfiguration: TControlState;
    function GetFontColor: TColor;
    procedure SetFontColor(const Value: TColor);
  published
    public
      constructor Create(AOwner : TComponent);override;
    published
      property IsConfiguration : TControlState read FIsConfiguration write FIsConfiguration;
      property IsState : TControlState read FIsState write FIsState;
      property FontColor : TColor read GetFontColor write SetFontColor;
      // Normalement Text est dans la partie public mais avec les GetProp on a besoin qu'il soit dans le published
      property Text;
  end;


  procedure InitComposantState(AForm : TForm; AColor, AFontColor : TColor);
  function SetComposantStateError(AForm : TForm; AColor, AFontColor : TColor; var AComponentToFocus : TComponent) : Boolean;

implementation

procedure InitComposantState(AForm : TForm;AColor, AFontColor : TColor);
var
  i : integer;
begin
  With AForm do
  for i := 0 to ComponentCount -1 do
  begin
    if GetPropInfo(Components[i].ClassInfo,'IsConfiguration') <> nil then
    begin
      if TControlState(GetPropValue(TObject(Components[i]),'IsConfiguration',false)) = csobligatoire then
        if  GetPropInfo(Components[i].ClassInfo, 'IsState') <> nil then
        begin
          SetPropValue(TObject(Components[i]),'IsState',csNormal);
          SetPropValue(TObject(Components[i]),'Color',AColor);
          SetPropValue(TObject(Components[i]),'FontColor',AFontColor);
        end;
    end;
  end;
end;

function SetComposantStateError(AForm : TForm; AColor, AFontColor : TColor; var AComponentToFocus : TComponent) : Boolean;
var
  i : integer;
  OnError : Boolean;
begin
  Result := False;
  AComponentToFocus := nil;
  With AForm do
    for i := 0 to ComponentCount -1 do
    begin
      // Vérification si le composant est obligatoire
      if GetPropInfo(Components[i].ClassInfo,'IsConfiguration') <> nil then
        if TControlState(GetPropValue(TObject(Components[i]),'IsConfiguration',false)) = csobligatoire then
        begin
          // Vérification que la zone de saisie n'est pas vide
          if GetPropInfo(Components[i].ClassInfo,'Text') <> nil then
            if GetPropValue(TObject(Components[i]),'Text',false) = '' then
            begin
              Result := True;
              if GetPropInfo(Components[i].ClassInfo, 'IsState') <> nil then
                 SetPropValue(TObject(Components[i]),'IsState',csError);
            end;
        end;

      // changement de couleur si l'état du composant est en erreur
      if GetPropInfo(Components[i].ClassInfo, 'IsState') <> nil then
        case TControlState(GetPropValue(TObject(Components[i]),'IsState',False)) of
          csError: begin
            if AComponentToFocus = nil then
              AComponentToFocus := Components[i];

           SetPropValue(TObject(Components[i]),'Color',AColor);
           SetPropValue(TObject(Components[i]),'FontColor',AFontColor);
           Result := True;
          end;
        end;

    end;
end;
{ TEdit }

constructor TEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsConfiguration := csNormal;
  FIsState := csNormal;
end;

function TEdit.GetFontColor: TColor;
begin
  Result := Self.Font.Color;
end;

procedure TEdit.SetFontColor(const Value: TColor);
begin
  Self.Font.Color := Value;
end;

{ TSpinEdit }

constructor TSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  IsConfiguration := csNormal;
  FIsState := csNormal;
end;

function TSpinEdit.GetFontColor: TColor;
begin
  Result := Self.Font.Color;
end;

procedure TSpinEdit.SetFontColor(const Value: TColor);
begin
  Self.Font.Color := Value;
end;

{ TMemo }

constructor TMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  IsConfiguration := csNormal;
  FIsState := csNormal;
end;

function TMemo.GetFontColor: TColor;
begin
  Result := Self.Font.Color;
end;

procedure TMemo.SetFontColor(const Value: TColor);
begin
  Self.Font.Color := Value;
end;

end.
