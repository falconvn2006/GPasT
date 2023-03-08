unit Test;

// Interface
interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  Setup = class
  public
    // Sample Methods
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Simple single Test
    [Test]
    procedure SetupIsOK;
  end;


//Implementation
implementation

procedure Setup.Setup;
begin
end;

procedure Setup.TearDown;
begin
end;

procedure Setup.SetupIsOK;
begin
  Assert.Pass();
end;

initialization
  TDUnitX.RegisterTestFixture(Setup);

end.
