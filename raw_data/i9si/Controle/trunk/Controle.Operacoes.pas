unit Controle.Operacoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUIForm, uniBitBtn, uniSpeedButton, uniLabel, uniButton,
  uniGUIBaseClasses, uniPanel, Data.Win.ADODB, Datasnap.Provider, Data.DB,
  Datasnap.DBClient, uniImageList;

type
  TControleOperacoes = class(TUniForm)
    UniPanel1: TUniPanel;
    BotaoSalvar: TUniButton;
    BotaoDescartar: TUniButton;
    UniPanel21: TUniPanel;
    UniPanelCaption: TUniPanel;
    UniLabelCaption: TUniLabel;
    UniSpeedCaptionClose: TUniSpeedButton;
    UniImageList1: TUniImageList;
    UniImageList2: TUniImageList;
    DscCadastro: TDataSource;
    CdsCadastro: TClientDataSet;
    DspCadastro: TDataSetProvider;
    QryCadastro: TADOQuery;
    UniImageCaptionMaximizar: TUniSpeedButton;
    UniImageCaptionClose: TUniImageList;
    UniPanel3: TUniPanel;
    UniPanel4: TUniPanel;
    UniPanel2: TUniPanel;
    procedure UniSpeedCaptionCloseClick(Sender: TObject);
    procedure UniFormCreate(Sender: TObject);
    procedure UniFormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ControleOperacoes: TControleOperacoes;

implementation

{$R *.dfm}

uses
  Controle.Main.Module, uniGUIApplication, uniDBEdit, Vcl.StdCtrls, uniEdit;

function ControleOperacoes: TControleOperacoes;
begin
  Result := TControleOperacoes(ControleMainModule.GetFormInstance(TControleOperacoes));
end;

procedure TControleOperacoes.UniFormCreate(Sender: TObject);
begin
  self.BorderStyle := bsNone;
end;

procedure TControleOperacoes.UniFormShow(Sender: TObject);
var
  I: Integer;
begin
  UniLabelCaption.Text := Self.Caption;

  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TUniDBEdit then
    begin
      if TUniDBEdit(Components[I]).Tag = 0 then
        TUniDBEdit(Components[I]).CharCase := ecUpperCase
      else if TUniDBEdit(Components[I]).Tag = 1 then
        TUniDBEdit(Components[I]).CharCase := ecLowerCase
      else if TUniDBEdit(Components[I]).Tag = 2 then
        TUniDBEdit(Components[I]).CharCase := ecNormal;
    end;

    if Components[I] is TUniEdit then
    begin
      if TUniEdit(Components[I]).Tag = 0 then
        TUniEdit(Components[I]).CharCase := ecUpperCase
      else if TUniEdit(Components[I]).Tag = 1 then
        TUniEdit(Components[I]).CharCase := ecLowerCase;// Usado para email por exemplo
    end;
  end;
end;

procedure TControleOperacoes.UniSpeedCaptionCloseClick(Sender: TObject);
begin
  Close;
end;

end.
