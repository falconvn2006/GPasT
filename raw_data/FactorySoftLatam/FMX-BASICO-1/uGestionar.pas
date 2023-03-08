unit uGestionar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  System.Bindings.Outputs, Data.Bind.EngExt, Fmx.Bind.DBEngExt, FMX.Grid.Style,
  Data.Bind.Controls, FMX.Layouts, Fmx.Bind.Navigator, FMX.ScrollBox, FMX.Grid,
  FMX.Controls.Presentation, FMX.StdCtrls, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, Fmx.Bind.Grid, Fmx.Bind.Editors, FMX.Edit, FMX.ComboEdit,
  FMX.ListBox;

type
  TfGestionar = class(TForm)
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    Panel1: TPanel;
    Panel3: TPanel;
    GridBindSourceDB1: TGrid;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Panel2: TPanel;
    NavigatorBindSourceDB1: TBindNavigator;
    Panel4: TPanel;
    Editusu_cnombre: TEdit;
    Labelusu_cnombre: TLabel;
    LinkControlToFieldusu_cnombre: TLinkControlToField;
    Editusu_nid: TEdit;
    Labelusu_nid: TLabel;
    LinkControlToFieldusu_nid: TLinkControlToField;
    Editusu_cnum_celular: TEdit;
    Labelusu_cnum_celular: TLabel;
    LinkControlToFieldusu_cnum_celular: TLinkControlToField;
    ComboBoxusu_ccargo: TComboBox;
    Labelusu_ccargo: TLabel;
    Editusu_cnum_tele_fijo: TEdit;
    Labelusu_cnum_tele_fijo: TLabel;
    LinkControlToFieldusu_cnum_tele_fijo: TLinkControlToField;
    Editusu_cnum_extension: TEdit;
    Labelusu_cnum_extension: TLabel;
    LinkControlToFieldusu_cnum_extension: TLinkControlToField;
    ComboBoxusu_cestado: TComboBox;
    Labelusu_cestado: TLabel;
    ComboBoxusu_nperfil: TComboBox;
    Labelusu_nperfil: TLabel;
    BindSourceDB2: TBindSourceDB;
    BindSourceDB3: TBindSourceDB;
    BindSourceDB4: TBindSourceDB;
    LinkFillControlToField3: TLinkFillControlToField;
    LinkFillControlToField1: TLinkFillControlToField;
    LinkFillControlToField2: TLinkFillControlToField;
    Editusu_cusuario: TEdit;
    Labelusu_cusuario: TLabel;
    LinkControlToFieldusu_cusuario: TLinkControlToField;
    Editusu_cpassword: TEdit;
    Labelusu_cpassword: TLabel;
    LinkControlToFieldusu_cpassword: TLinkControlToField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fGestionar: TfGestionar;

implementation

{$R *.fmx}

uses dmData;

procedure TfGestionar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  BindSourceDB1.DataSource.DataSet.Close;
end;

procedure TfGestionar.FormCreate(Sender: TObject);
begin
  BindSourceDB1.DataSource.DataSet.Close;
  BindSourceDB1.DataSource.DataSet.Open;
end;

end.
