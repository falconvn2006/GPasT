unit form_configuracoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, DBCtrls, DB, IBCustomDataSet, IBQuery,
  RxLookup, Mask, wwdbedit, Wwdotdot, Wwdbcomb, wwcheckbox, Sockets, cxStyles,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, cxCustomData,
  cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, ExtCtrls,
  cxGridLevel, cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, wwdbdatetimepicker, wwdblook,
  untDados;

type
  TfrmConfiguracoes = class(TForm)
    Panel_btns_cad: TPanel;
    btn_sair: TSpeedButton;
    pnlTitulo: TPanel;
    Panel2: TPanel;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    Panel3: TPanel;
    DBMemo1: TDBMemo;
    Notebook1: TNotebook;
    dseConfig: TIBDataSet;
    dtsConfig: TDataSource;
    cxGrid1DBTableView1CONFIG_CAPTION: TcxGridDBColumn;
    Panel4: TPanel;
    DBText1: TDBText;
    wwDBEdit1: TwwDBEdit;
    wwDBEdit2: TwwDBEdit;
    DBMemo2: TDBMemo;
    DBRadioGroup1: TDBRadioGroup;
    wwDBDateTimePicker1: TwwDBDateTimePicker;
    wwDBDateTimePicker2: TwwDBDateTimePicker;
    wwDBEdit3: TwwDBEdit;
    qryLookup: TIBQuery;
    lkpConfig: TRxDBLookupCombo;
    dtsLookup: TDataSource;
    ColorDialogClassificacao: TColorDialog;
    Panel1: TPanel;
    SpeedButtonAlterarCor: TSpeedButton;
    ShapeCor: TShape;
    dseConfigFORM_NAME: TIBStringField;
    dseConfigCONFIG_NAME: TIBStringField;
    dseConfigCONFIG_CAPTION: TIBStringField;
    dseConfigDESCRICAO: TIBStringField;
    dseConfigTIPOCONFIG: TIntegerField;
    dseConfigVALOR_INTEIRO: TIntegerField;
    dseConfigVALOR_STRING: TIBStringField;
    dseConfigVALOR_MEMO: TMemoField;
    dseConfigVALOR_LOGICO: TIntegerField;
    dseConfigVALOR_DATA: TDateField;
    dseConfigVALOR_HORA: TTimeField;
    dseConfigSQL_LOOKUP: TMemoField;
    dseConfigDISPLAY_LOOKUP: TIBStringField;
    dseConfigKEYVALUE_LOOKUP: TIBStringField;
    dseConfigSEQUENCIAFECHAMENTOTURNO: TIntegerField;
    dseConfigVALORREAL: TFMTBCDField;
    procedure btn_sairClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dseConfigAfterScroll(DataSet: TDataSet);
    procedure dseConfigBeforeOpen(DataSet: TDataSet);
    procedure dseConfigAfterPost(DataSet: TDataSet);
    procedure SpeedButtonAlterarCorClick(Sender: TObject);
  private
    { Private declarations }
  public
    FormChamado : Tform;
    { Public declarations }
  end;

var
  frmConfiguracoes: TfrmConfiguracoes;


implementation

{$R *.dfm}

procedure TfrmConfiguracoes.btn_sairClick(Sender: TObject);
begin
  if dseConfig.State = dsedit then
    dseConfig.Post;
  close;
end;

procedure TfrmConfiguracoes.dseConfigAfterPost(DataSet: TDataSet);
begin
  dseConfig.Transaction.CommitRetaining;
end;

procedure TfrmConfiguracoes.dseConfigAfterScroll(DataSet: TDataSet);
begin
  case dseConfigTIPOCONFIG.AsInteger of
    1 : Notebook1.ActivePage := 'configTexto';
    2 : Notebook1.ActivePage := 'configInteiro';
    3 : Notebook1.ActivePage := 'configMemo';
    4 : Notebook1.ActivePage := 'configReal';
    5 : Notebook1.ActivePage := 'configData';
    6 : Notebook1.ActivePage := 'configHora';
    7 : Notebook1.ActivePage := 'configLogico';
    8 : begin
          Notebook1.ActivePage := 'configLookup';
          qryLookup.Close;
          qryLookup.SQL.Text := dseConfigSQL_LOOKUP.AsString;
          qryLookup.Open;
          lkpConfig.LookupField   := dseConfigKEYVALUE_LOOKUP.Text;
          lkpConfig.LookupDisplay := dseConfigDISPLAY_LOOKUP.Text;
        end;
    9 : begin
          Notebook1.ActivePage := 'configCor';
          ShapeCor.Brush.Color := dseConfigVALOR_INTEIRO.AsInteger;
          ShapeCor.Repaint;
        end;
  end;
end;

procedure TfrmConfiguracoes.dseConfigBeforeOpen(DataSet: TDataSet);
begin
  dseConfig.ParamByName('F_NAME').AsString := FormChamado.Name;
end;

procedure TfrmConfiguracoes.FormShow(Sender: TObject);
begin
  TOP := 122;
  LEFT := 0;
  if length(FormChamado.Caption) > 17 then
    pnlTitulo.Caption := copy(FormChamado.Caption,17,length(FormChamado.Caption))
  else
    pnlTitulo.Caption := FormChamado.Caption;
  dseConfig.Close;
  dseConfig.Open;
end;

procedure TfrmConfiguracoes.SpeedButtonAlterarCorClick(Sender: TObject);
begin
    if ColorDialogClassificacao.Execute then
    begin
      if not (dseConfig.State in [dsInsert, dsEdit]) then
        dseConfig.Edit;

      ShapeCor.Brush.Color              := ColorDialogClassificacao.Color;
      dseConfigVALOR_INTEIRO.AsInteger  := ColorDialogClassificacao.Color;

      dseConfig.Post;
    end;
end;

end.
