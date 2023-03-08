unit Controle.Consulta.VideoTutoriais;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIFrame, Controle.Consulta,  frxClass, frxDBSet,
  frxExportBaseDialog, frxExportPDF, uniGridExporters, uniBasicGrid,
   Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniCheckBox, uniLabel,
  uniPanel, uniDBGrid, uniBitBtn,  uniButton;

type
  TControleConsultaVideoTutoriais = class(TControleConsulta)
    QryConsultaID: TFloatField;
    QryConsultaTITULO: TWideStringField;
    QryConsultaDESCRICAO: TWideStringField;
    CdsConsultaID: TFloatField;
    CdsConsultaTITULO: TWideStringField;
    CdsConsultaDESCRICAO: TWideStringField;
    QryConsultaLINK_URL: TWideStringField;
    CdsConsultaLINK_URL: TWideStringField;
    procedure UniFrameCreate(Sender: TObject);
    procedure BotaoAbrirClick(Sender: TObject);
    procedure CdsConsultaLINK_URLGetText(Sender: TField; var Text: string;
      DisplayText: Boolean);
    procedure GrdResultadoCellClick(Column: TUniDBGridColumn);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  Controle.Main.Module;

{$R *.dfm}



procedure TControleConsultaVideoTutoriais.BotaoAbrirClick(Sender: TObject);
var
  url_video : string;
begin
//  inherited;
  url_video := CdsConsulta.FieldByName('link_url').AsString;
  UniSession.AddJS('window.open('+'"'+ url_video + '"'+')');

end;

procedure TControleConsultaVideoTutoriais.CdsConsultaLINK_URLGetText(
  Sender: TField; var Text: string; DisplayText: Boolean);
begin
  inherited;
  Text := '<img src=./files/icones/play-circle.png height=22 align="center" />'
end;

procedure TControleConsultaVideoTutoriais.GrdResultadoCellClick(
  Column: TUniDBGridColumn);
begin
 //inherited;
 if Column.FieldName = 'LINK_URL' then
 begin
  BotaoAbrir.Click;
 end;
end;

procedure TControleConsultaVideoTutoriais.UniFrameCreate(Sender: TObject);
var
  vSchema : string;
begin
//  inherited;
  if Copy(ControleMainModule.FSchema,1,7) = 'CLINICA' then
   vSchema := 'CLINICA'
  else if Copy(ControleMainModule.FSchema,1,8) = 'CONTROLE' then
   vSchema := 'CONTROLE';

  CdsConsulta.Close;
  CdsConsulta.Params.ParamByName('nome_schema').AsString := vSchema;
  CdsConsulta.Open;

end;

end.
