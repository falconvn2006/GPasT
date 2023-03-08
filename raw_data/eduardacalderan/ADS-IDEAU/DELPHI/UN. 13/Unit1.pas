unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TExercicio1 = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Exercicio1: TExercicio1;

implementation

{$R *.dfm}

uses Unit2;

procedure TExercicio1.Button1Click(Sender: TObject);
begin
  DataModuleExercicio1.ClientDataSet1.Append;
end;

procedure TExercicio1.Button2Click(Sender: TObject);
begin
    DataModuleExercicio1.ClientDataSet1.ApplyUpdates(0);
end;

procedure TExercicio1.Button3Click(Sender: TObject);
begin
  if DataModuleExercicio1.ClientDataSet1.State in dsEditModes then
    DataModuleExercicio1.ClientDataSet1.Cancel;
end;

procedure TExercicio1.Button4Click(Sender: TObject);
begin
  if not (DataModuleExercicio1.ClientDataSet1.State in dsEditModes) then
    DataModuleExercicio1.ClientDataSet1.Delete;
end;

procedure TExercicio1.Button5Click(Sender: TObject);
begin
  DataModuleExercicio1.ClientDataSet1.First;
end;

procedure TExercicio1.Button6Click(Sender: TObject);
begin
  DataModuleExercicio1.ClientDataSet1.Prior;
end;

procedure TExercicio1.Button7Click(Sender: TObject);
begin
  DataModuleExercicio1.ClientDataSet1.Next;
end;

procedure TExercicio1.Button8Click(Sender: TObject);
begin
  DataModuleExercicio1.ClientDataSet1.Last;
end;

procedure TExercicio1.FormCreate(Sender: TObject);
begin
  DataModuleExercicio1.ClientDataSet1.Close;
  DataModuleExercicio1.ClientDataSet1.Open;
end;

end.
