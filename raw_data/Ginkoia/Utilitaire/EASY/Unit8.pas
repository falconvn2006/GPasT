unit Unit8;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,ClientClassesUnit1,ClientModuleUnit1,Gin.Com.classEasyLame,
  Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrm_DSCLIENT = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Memo1: TMemo;
    Panel1: TPanel;
    Button2: TButton;
    gridInstance: TDBGrid;
    FDMemTB: TFDMemTable;
    FDMemTBID: TIntegerField;
    FDMemTBServiceName: TStringField;
    FDMemTBPathName: TStringField;
    FDMemTBConfigFile: TStringField;
    FDMemTBNBBASES: TIntegerField;
    FDMemTBSIZE: TLargeintField;
    FDMemTBEtat: TStringField;
    FDMemTBDirectory: TStringField;
    FDMemTBPorts: TStringField;
    FDMemTBsSize: TStringField;
    dsInstances: TDataSource;
    Button3: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    FDMemTable2: TFDMemTable;
    FDMemTable2ID: TIntegerField;
    StringField1: TStringField;
    FDMemTable2EngineName: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    FDMemTable2SIZE: TLargeintField;
    FDMemTable2sSize: TStringField;
    FDMemTable2TRG: TIntegerField;
    FDMemTable2RTB: TIntegerField;
    FDMemTable2Version: TStringField;
    DataSource2: TDataSource;
    Splitter1: TSplitter;
    DBGrid3: TDBGrid;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Frm_DSCLIENT: TFrm_DSCLIENT;

implementation

{$R *.dfm}

procedure TFrm_DSCLIENT.Button1Click(Sender: TObject);
var aEasyFiles:TEasyFiles;
    i:Integer;
begin
  Memo1.Lines.Clear;
  aEasyFiles := ClientModule1.SM_EasyServiceClient.GetFiles(Edit1.Text);
  for I := 0 to aEasyFiles.Count-1 do
    begin
        Memo1.Lines.Add(aEasyFiles[i].Name);
    end;
end;

procedure TFrm_DSCLIENT.Button2Click(Sender: TObject);
begin
  ClientModule1.SM_EasyServiceClient.CreateNewEasyInstance();
end;

procedure TFrm_DSCLIENT.Button3Click(Sender: TObject);
var vEasys:TEasyServices;
    I: Integer;
    vEasyDossiers:TEasyDossiers;
begin
    vEasys := ClientModule1.SM_EasyServiceClient.GetEasyServices();
    vEasyDossiers := nil;
    FDMemTB.Close;
    FDMemTB.Open;
    for i:=0 to vEasys.Count-1 do
        begin
          FDMemTB.append;
          if vEasys[i].ServiceName='EASY01'
            then
              begin
                  vEasyDossiers := ClientModule1.SM_EasyServiceClient.GetEasyDossiers(vEasys[i].ServiceName)
              end;
          FDMemTB.FieldByName('ID').asinteger         := i;
          FDMemTB.FieldByName('ServiceName').asstring := vEasys[i].ServiceName;
          FDMemTB.FieldByName('PathName').asstring    := VEasys[i].ServicePath;
          FDMemTB.FieldByName('ConfigFile').asstring  := VEasys[i].ConfigFile;
          FDMemTB.FieldByName('Directory').asstring   := VEasys[i].Directory;
          FDMemTB.FieldByName('Etat').asstring        := VEasys[i].Status;
          FDMemTB.FieldByName('NBBASES').AsInteger    := VEasys[i].NbBases;
          FDMemTB.FieldByName('SIZE').AsLargeInt      := VEasys[i].Size;
          FDMemTB.FieldByName('Ports').asstring       := Format('%d,%d,%d,%d',[
              VEasys[i].http,VEasys[i].https,VEasys[i].jmxhttp,VEasys[i].jmxagent]);
          FDMemTB.post;
        end;
     FDMemTable2.Close;
     if Assigned(vEasyDossiers) then
       begin
           FDMemTable2.Open;
           for i:=0 to vEasyDossiers.count-1 do
            begin
              FDMemTable2.append;
              FDMemTable2.FieldByName('ID').asinteger := i;
              FDMemTable2.FieldByName('EngineName').asstring  := vEasyDossiers[i].EngineName;
              FDMemTable2.FieldByName('IBFile').asstring := vEasyDossiers[i].IBFile;
              FDMemTable2.FieldByName('ServiceName').asstring := vEasyDossiers[i].ServiceName;
              FDMemTable2.FieldByName('PropertiesFile').asstring := vEasyDossiers[i].PropertiesFile;
              FDMemTable2.FieldByName('SIZE').asLargeInt  := vEasyDossiers[i].Size;
              FDMemTable2.FieldByName('TRG').Asinteger    := vEasyDossiers[i].TRG;
              FDMemTable2.FieldByName('RTB').Asinteger    := vEasyDossiers[i].RTB;
              FDMemTable2.FieldByName('Version').AsString := vEasyDossiers[i].Version;
              FDMemTable2.post;
            end;
       end;
end;

procedure TFrm_DSCLIENT.Button4Click(Sender: TObject);
begin
    // vEasys := ClientModule1.SM_EasyServiceClient.GetEasyServices();



end;

end.
