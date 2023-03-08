unit UUsers;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UMasterData, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, SMDBGrid,
  RzPanel, RzDBNav, Vcl.ExtCtrls, RzButton;

type
  TfrmUsers = class(TfrmMasterData)
    SMDBGridHeader: TSMDBGrid;
    FDQueryDetail: TFDQuery;
    DsDetail: TDataSource;
    FDQuery1IDUSER: TWideStringField;
    FDQuery1USERNAME: TWideStringField;
    FDQuery1PASSWORD: TWideStringField;
    RzBtnAccess: TRzBitBtn;
    FDStoredProc1: TFDStoredProc;
    FDQueryDetailIDUSER: TWideStringField;
    FDQueryDetailFORMNAME: TWideStringField;
    FDQueryDetailFORMDESCRIPTION: TWideStringField;
    FDQueryDetailMARK: TBooleanField;
    procedure RzBtnAccessClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FDQuery1AfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmUsers: TfrmUsers;

implementation
 Uses UDM;
{$R *.dfm}

procedure TfrmUsers.FDQuery1AfterScroll(DataSet: TDataSet);
begin
  inherited;
   with FDQueryDetail do
   begin
     sql.Clear;
     sql.Add('SELECT * FROM USERSFORM WHERE IDUSER =:USERID');
     Params[0].AsString := FDQuery1IDUSER.AsString;
     Active := True;
   end;
end;

procedure TfrmUsers.FormCreate(Sender: TObject);
begin
  inherited;
  with FDQuery1 do
  begin
    sql.Clear;
    sql.Add('SELECT * FROM USERS');
    Active:= True;
  end;

  with FDQueryDetail do
  begin
    sql.Clear;
    sql.Add('SELECT * FROM USERSFORM');
    Active:= True;
  end;
end;


procedure TfrmUsers.RzBtnAccessClick(Sender: TObject);
begin
  inherited;
  with FDStoredProc1 do
        begin
            Close;
            Prepare;
            StoredProcName := 'POS.dbo.InsertFormToUsers';
            ParamByName('@userid').AsString := FDQuery1IDUSER.AsString;
            ExecProc;
            //SLEEP(20);

        end;

        FDQueryDetail.Refresh;

end;

end.
