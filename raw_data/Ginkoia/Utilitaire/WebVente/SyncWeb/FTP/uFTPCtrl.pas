unit uFTPCtrl;

interface

Type
  TFTPCtrl = Class(TObject)
  private
    FNameSite: String;
    FIsBusy: Boolean;
    procedure Reset;
  public
    constructor Create;

    procedure Start(Const ANameSite: String);
    procedure Finish(Const ANameSite: String);

    property NameSite: String read FNameSite;
    property IsBusy: Boolean read FIsBusy;
  End;

implementation

{ TFTPCtrl }

constructor TFTPCtrl.Create;
begin
  Reset;
end;

procedure TFTPCtrl.Finish(const ANameSite: String);
begin
  if FNameSite = ANameSite then
    Reset;
end;

procedure TFTPCtrl.Reset;
begin
  FIsBusy:= False;
  FNameSite:= '';
end;

procedure TFTPCtrl.Start(const ANameSite: String);
begin
  FIsBusy:= True;
  FNameSite:= ANameSite;
end;

end.
