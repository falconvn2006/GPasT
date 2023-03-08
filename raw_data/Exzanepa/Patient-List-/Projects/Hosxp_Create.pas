unit Hosxp_Create;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, DM_hosxp,
  Data.DB, Vcl.Grids, Vcl.DBGrids ;

type
  Thosxp_add = class(TForm)
    Hosxp_create: TPanel;
    firstname: TLabel;
    surname: TLabel;
    gender: TLabel;
    age: TLabel;
    phonenumber: TLabel;
    address: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    surname_create: TEdit;
    gender_create: TEdit;
    age_create: TEdit;
    phone_create: TEdit;
    address_create: TEdit;
    notice_create: TEdit;
    create: TButton;
    DBGrid1: TDBGrid;
    firstname_create: TEdit;
    cd4_create: TEdit;
    let_create: TEdit;
    catagories_create: TEdit;
    stage_create: TEdit;
    procedure createClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  hosxp_add: Thosxp_add;

implementation

{$R *.dfm}

procedure Thosxp_add.createClick(Sender: TObject);
var sfirstname : string;

begin
  with dm_database do ;
  begin
    sfirstname := firstname_create.Text;
    if dm_database.dm_table.Locate('firstname',sfirstname,[]) then
    begin
      showmessage('ID already exists');
      exit;
    end;

    dm_database.dm_table.Insert;
    dm_database.dm_table['firstname'] :=sfirstname;
    dm_database.dm_table['lastname'] :=surname_create.Text;
    dm_database.dm_table['gender'] :=gender_create.Text;
    dm_database.dm_table['age'] :=age_create.Text;
    dm_database.dm_table['notice'] := notice_create.Text;
    dm_database.dm_table['catagories'] :=catagories_create.Text;
    dm_database.dm_table['stage'] :=stage_create.Text;
    dm_database.dm_table['CD4'] :=cd4_create.Text;
    dm_database.dm_table['LET'] :=let_create.Text;
    dm_database.dm_table['phone number'] := phone_create.Text;
    dm_database.dm_table['address'] := address_create.Text;

    dm_database.dm_table.Post;




  end;
end;

end.
