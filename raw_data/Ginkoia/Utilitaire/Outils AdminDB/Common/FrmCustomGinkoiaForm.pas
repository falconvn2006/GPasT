unit FrmCustomGinkoiaForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrmCustomGinkoia, cxPropertiesStore;

type
  TCustomGinkoiaFormFrm = class(TCustomGinkoiaFrm)
    cxPropertiesStore: TcxPropertiesStore;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
  end;

var
  CustomGinkoiaFormFrm: TCustomGinkoiaFormFrm;

implementation

{$R *.dfm}

procedure TCustomGinkoiaFormFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if cxPropertiesStore.Active then
    cxPropertiesStore.StoreTo(False);
end;

procedure TCustomGinkoiaFormFrm.FormCreate(Sender: TObject);
begin
  inherited;
  cxPropertiesStore.StorageName:= 'Software\' + ChangeFileExt(ExtractFileName(Application.ExeName), '') + '\Storage\' + Self.Name;
  if cxPropertiesStore.Active then
    cxPropertiesStore.RestoreFrom;
end;

procedure TCustomGinkoiaFormFrm.FormDestroy(Sender: TObject);
begin
  inherited;
  if cxPropertiesStore.Active then
    cxPropertiesStore.StoreTo(False);
  cxPropertiesStore.Active:= False;
end;

end.
