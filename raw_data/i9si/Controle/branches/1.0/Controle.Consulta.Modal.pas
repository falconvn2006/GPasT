unit Controle.Consulta.Modal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, Data.DB, Data.Win.ADODB, Datasnap.Provider,
  Datasnap.DBClient, uniGUIBaseClasses, uniImageList, uniPanel, uniBasicGrid,
  uniDBGrid, uniButton, uniLabel, uniBitBtn, uniSpeedButton;

type
  TControleConsultaModal = class(TUniForm)
    UniPanel1: TUniPanel;
    UniPanel2: TUniPanel;
    UniDBGrid1: TUniDBGrid;
    UniPanel3: TUniPanel;
    UniHiddenPanel1: TUniHiddenPanel;
    UniPanel4: TUniPanel;
    UniImageList1: TUniImageList;
    CdsConsulta: TClientDataSet;
    DspConsulta: TDataSetProvider;
    QryConsulta: TADOQuery;
    DscConsulta: TDataSource;
    UniPanelBottom: TUniPanel;
    UniLabelCorpright: TUniLabel;
    UniPanel21: TUniPanel;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    BotaoConfirma: TUniButton;
    BotaoNovo: TUniButton;
    UniImageCaptionClose: TUniImageList;
    procedure UniDBGrid1ColumnFilter(Sender: TUniDBGrid;
      const Column: TUniDBGridColumn; const Value: Variant);
    procedure UniDBGrid1TitleClick(Column: TUniDBGridColumn);
    procedure UniFormCreate(Sender: TObject);
    procedure BotaoConfirmaClick(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
  private
    { Private declarations }
    function SortCustomClientDataSet(DataSet: TCustomClientDataSet;
      const FieldName: String): Boolean;
  public
    { Public declarations }
  end;

implementation

uses
  uniGUIApplication, Controle.Main.Module, TypInfo;

{$R *.dfm}

procedure TControleConsultaModal.BotaoConfirmaClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;


procedure TControleConsultaModal.UniDBGrid1ColumnFilter(Sender: TUniDBGrid;
  const Column: TUniDBGridColumn; const Value: Variant);
var
  V : Variant;
  I : Integer;
begin
  if CdsConsulta.Active then
  begin
    for I := 0 to Sender.Columns.Count - 1  do
      if Sender.Columns[I].Filtering.Enabled then
      begin
        V := Sender.Columns[I].Filtering.VarValue;
        CdsConsulta.Params.ParamByName(Sender.Columns[I].FieldName).Value := '%'+V+'%';
      end;
    CdsConsulta.Refresh;
  end;
end;

procedure TControleConsultaModal.UniDBGrid1TitleClick(Column: TUniDBGridColumn);
begin
  SortCustomClientDataSet(CdsConsulta, Column.FieldName);
end;

procedure TControleConsultaModal.UniFormCreate(Sender: TObject);
Var
  Dia, Mes, Ano : Word;
begin
  self.BorderStyle := bsNone;

  CdsConsulta.Open;

  // Colocando a data no bottom
  DecodeDate(Now, Ano, Mes, Dia);
  UniLabelCorpright.Caption := 'Copyright © ' + InttoStr(Ano) + ' I9si Sistemas. Todos os direitos reservados.';
end;

procedure TControleConsultaModal.UniFormShow(Sender: TObject);
begin
  UniLabelCaption.Text := Self.Caption;
end;

procedure TControleConsultaModal.UniSpeedCaptionCloseClick(Sender: TObject);
begin
  Close;
end;

function TControleConsultaModal.SortCustomClientDataSet(DataSet: TCustomClientDataSet;
  const FieldName: String): Boolean;
var
  i: Integer;
  IndexDefs: TIndexDefs;
  IndexName: String;
  IndexOptions: TIndexOptions;
  Field: TField;
begin
  Result := False;
  Field := DataSet.Fields.FindField(FieldName);
  //If invalid field name, exit.
  if Field = nil then Exit;
  //if invalid field type, exit.
  if (Field is TObjectField) or (Field is TBlobField) or
    (Field is TAggregateField) or (Field is TVariantField)
     or (Field is TBinaryField) then Exit;
  //Get IndexDefs and IndexName using RTTI
  if IsPublishedProp(DataSet, 'IndexDefs') then
    IndexDefs := GetObjectProp(DataSet, 'IndexDefs') as TIndexDefs
  else
    Exit;
  if IsPublishedProp(DataSet, 'IndexName') then
    IndexName := GetStrProp(DataSet, 'IndexName')
  else
    Exit;
  //Ensure IndexDefs is up-to-date
  IndexDefs.Update;
  //If an ascending index is already in use,
  //switch to a descending index
  if IndexName = FieldName + '__IdxA'
  then
    begin
      IndexName := FieldName + '__IdxD';
      IndexOptions := [ixDescending];
    end
  else
    begin
      IndexName := FieldName + '__IdxA';
      IndexOptions := [];
    end;
  //Look for existing index
  for i := 0 to Pred(IndexDefs.Count) do
  begin
    if IndexDefs[i].Name = IndexName then
      begin
        Result := True;
        Break
      end;  //if
  end; // for
  //If existing index not found, create one
  if not Result then
      begin
        DataSet.AddIndex(IndexName, FieldName, IndexOptions);
        Result := True;
      end; // if not
  //Set the index
  SetStrProp(DataSet, 'IndexName', IndexName);
end;

end.
