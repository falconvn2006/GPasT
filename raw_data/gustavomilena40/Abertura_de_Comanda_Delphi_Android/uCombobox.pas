unit uCombobox;

// unit tirada de um vídeo do YT
// https://www.youtube.com/watch?v=FYR_n7HGgJA

interface

uses FMX.Layouts, FMX.Objects, FMX.Types, FMX.Forms, FMX.Graphics, FMX.Ani,
  FMX.StdCtrls, SysUtils, System.Types;

type
  TExecutaClickWin = procedure(Sender: TObject) of Object;
  TExecutaClickMobile = procedure(Sender: TObject; const Point: TPointF)
    of Object;

  TCustomCombo = class
  private
    rectFundo, rectItem: TRectangle;
    vert: TVertScrollBox;
    Ani: TFloatAnimation;
    btnBack: TSpeedButton;
    lblTitulo, lblSubTitulo, lblItem: TLabel;
    FTitleMenuText, FSubTitleMenuText, FCodItem, FDescrItem: string;
    FTitleFontSize, FItemFontSize, FSubTitleFontSize, FSubItemFontSize: integer;
    FBackgroundColor, FTitleFontColor, FSubTitleFontColor, FItemFontColor,
      FItemBackgroundColor: Cardinal;
    FVisible: Boolean;
    fOrigem: String;
{$IFDEF MSWINDOWS}
    ACallBack: TExecutaClickWin;
{$ELSE}
    ACallBack: TExecutaClickMobile;
{$ENDIF}
  public
    constructor Create(Frm: TForm);
    procedure ShowMenu(pOrigem : string);
    procedure ClickCancel(Sender: TObject);
    procedure HideMenu();
    procedure FinishFade(Sender: TObject);
    procedure ProcessFade(Sender: TObject);
    procedure AddItem(codItem: string; TextItem: string);

{$IFDEF MSWINDOWS}
    procedure ItemClick(Sender: TObject);
{$ELSE}
    procedure ItemClick(Sender: TObject; const Point: TPointF);
{$ENDIF}
  published
    property TitleMenuText: string read FTitleMenuText write FTitleMenuText;
    property TitleFontSize: integer read FTitleFontSize write FTitleFontSize;
    property TitleFontColor: Cardinal read FTitleFontColor
      write FTitleFontColor;

    property SubTitleMenuText: string read FSubTitleMenuText
      write FSubTitleMenuText;
    property SubTitleFontSize: integer read FSubTitleFontSize
      write FSubTitleFontSize;
    property SubTitleFontColor: Cardinal read FSubTitleFontColor
      write FSubTitleFontColor;

    property ItemFontSize: integer read FItemFontSize write FItemFontSize;
    property ItemFontColor: Cardinal read FItemFontColor write FItemFontColor;
    property ItemBackgroundColor: Cardinal read FItemBackgroundColor
      write FItemBackgroundColor;

    property BackgroundColor: Cardinal read FBackgroundColor
      write FBackgroundColor;
    property Visible: Boolean read FVisible write FVisible;
    property codItem: String read FCodItem write FCodItem;
    property DescrItem: String read FDescrItem write FDescrItem;
    property Origem: String read fOrigem write fOrigem;
{$IFDEF MSWINDOWS}
    property OnClick: TExecutaClickWin read ACallBack write ACallBack;
{$ELSE}
    property OnClick: TExecutaClickMobile read ACallBack write ACallBack;
{$ENDIF}
  end;

implementation

constructor TCustomCombo.Create(Frm: TForm);
begin
  FTitleMenuText := 'Escolha o Tipo de Entrada';
  FTitleFontSize := 18;
  FTitleFontColor := $FF1F2035;

  FSubTitleMenuText := '';
  FSubTitleFontSize := 15;
  FSubTitleFontColor := $FF9E9EB4;

  FItemFontSize := 15;
  FItemFontColor := $FF1F2035;
  // FItemBackgroundColor := $FFFFFFFF;

  FBackgroundColor := $FFFFFFFF;

  // Cria rect de fundo...
  rectFundo := TRectangle.Create(Frm);
  with rectFundo do
  begin
    Align := TAlignLayout.center;
    Height := Frm.Height / 1.5;
    width := Frm.width / 1.5;
{$IFDEF android}
    width := Frm.width / 2.6;
{$ENDIF}
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := FBackgroundColor;
    // Fill.Color := $FFFFFFFF;
    BringToFront;
    HitTest := false;
    Margins.Right := (Frm.width + 100) * -1;
    Visible := false;
    Stroke.Kind := TBrushKind.None;
    Padding.Left := 20;
    Padding.Right := 20;
    Tag := 0;
    Opacity := 1;
  end;
  Frm.AddObject(rectFundo);

  // Cria animacao de entrada do fundo...
  Ani := TFloatAnimation.Create(rectFundo);
  with Ani do
  begin
    PropertyName := 'Margins.Right';
    StartValue := (Frm.width + 100) * -1;
    StopValue := 0;
    Inverse := false;
    Duration := 0.3;
    OnFinish := FinishFade;
    OnProcess := ProcessFade;
  end;
  rectFundo.AddObject(Ani);

  // Label com titulo da tela...
  lblTitulo := TLabel.Create(rectFundo);
  with lblTitulo do
  begin
    Text := FTitleMenuText;
    Align := TAlignLayout.MostTop;
    Height := 50;
    VertTextAlign := TTextAlign.center;
    TextAlign := TTextAlign.center;
    StyledSettings := StyledSettings - [TStyledSetting.Size,
      TStyledSetting.FontColor];
    Font.Size := FTitleFontSize;
    FontColor := FTitleFontColor;
    // AutoSize := true;
    Margins.Top := 0;
    Margins.Bottom := 0;
  end;
  rectFundo.AddObject(lblTitulo);

  // Label com subtitulo da tela...
  lblSubTitulo := TLabel.Create(rectFundo);
  with lblSubTitulo do
  begin
    Text := FSubTitleMenuText;
    Align := TAlignLayout.MostTop;
    Height := 20;
    VertTextAlign := TTextAlign.center;
    TextAlign := TTextAlign.center;
    StyledSettings := StyledSettings - [TStyledSetting.Size,
      TStyledSetting.FontColor];
    Font.Size := FSubTitleFontSize;
    FontColor := FSubTitleFontColor;
    // AutoSize := true;
    Margins.Top := 0;
    Margins.Bottom := 0;
  end;
  rectFundo.AddObject(lblSubTitulo);

  // Layout que vai conter o botao cancelar...
  vert := TVertScrollBox.Create(rectFundo);
  with vert do
  begin
    Align := TAlignLayout.Client;
    ShowScrollBars := false;
    Margins.Top := 20;
    Margins.Bottom := 20;
    Visible := true;
  end;
  rectFundo.AddObject(vert);

  // Botao voltar...
  btnBack := TSpeedButton.Create(rectFundo);
  with btnBack do
  begin
    width := 48;
    Height := 48;
    Position.X := 13;
    Position.Y := 5;
    BringToFront;
    StyleLookup := 'backtoolbutton';
    Text := '';
    OnClick := ClickCancel;
  end;
  rectFundo.AddObject(btnBack);

  {
    // Fundo do cancelar...
    rectCancelar := TRectangle.Create(rectMenu);
    with rectCancelar do
    begin
    Align := TAlignLayout.Bottom;
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := FMenuColor;
    Opacity := 1;
    BringToFront;
    Visible := true;
    HitTest := true;
    XRadius := 10;
    YRadius := 10;
    Margins.Bottom := -60;
    Height := 50;
    Parent := rectMenu;
    Stroke.Kind := TBrushKind.None;
    end;
    rectMenu.AddObject(rectCancelar);


    // Label cancelar
    lblCanc := TLabel.Create(rectCancelar);
    with lblCanc do
    begin
    Text := FCancelMenuText;
    Align := TAlignLayout.Client;
    VertTextAlign := TTextAlign.Center;
    TextAlign := TTextAlign.Center;
    StyledSettings := StyledSettings - [TStyledSetting.Size, TStyledSetting.FontColor];
    Font.Size := FCancelFontSize;
    FontColor := FCancelFontColor;
    HitTest := true;
    OnClick := ClickBackground;
    end;
    rectCancelar.AddObject(lblCanc);
  }
end;

procedure TCustomCombo.ClickCancel(Sender: TObject);
begin
  FCodItem := '';
  FDescrItem := '';
  HideMenu;
end;

{$IFDEF MSWINDOWS}

procedure TCustomCombo.ItemClick(Sender: TObject);
begin
  FCodItem := TLabel(Sender).TagString;
  FDescrItem := TLabel(Sender).Text;
  ACallBack(Sender);
end;
{$ELSE}

procedure TCustomCombo.ItemClick(Sender: TObject; const Point: TPointF);
begin
  FCodItem := TLabel(Sender).TagString;
  FDescrItem := TLabel(Sender).Text;
  ACallBack(Sender, Point);
end;
{$ENDIF}

procedure TCustomCombo.ShowMenu(pOrigem: string);
begin
  fOrigem:=pOrigem;
  // Volta scroll para o inicio...
  vert.ViewportPosition := TPointF.Zero;

  // Acerta o fundo opaco...
  rectFundo.Visible := true;
  FVisible := true;
  rectFundo.Fill.Color := FBackgroundColor;

  Ani.Inverse := false;
  Ani.Start;

  // Acerta titulo do menu...
  if Trim(FTitleMenuText) = '' then
    lblTitulo.Height := 0
  else
  begin
    lblTitulo.Height := 50;
    lblTitulo.Margins.Top := 50;
    lblTitulo.Margins.Bottom := 10;
  end;

  lblTitulo.Font.Size := FTitleFontSize;
  lblTitulo.Text := FTitleMenuText;

  // Acerta subtitulo do menu...
  if Trim(FSubTitleMenuText) = '' then
    lblSubTitulo.Height := 0
  else
  begin
    lblSubTitulo.Height := 20;

    if lblTitulo.Height > 0 then
      lblSubTitulo.Margins.Top := 10
    else
      lblSubTitulo.Margins.Top := 50;

    lblSubTitulo.Margins.Bottom := 10;
  end;

  lblSubTitulo.Font.Size := FSubTitleFontSize;
  lblSubTitulo.Text := FSubTitleMenuText;

end;

procedure TCustomCombo.AddItem(codItem: string; TextItem: string);
begin

  // Fundo do item...
  rectItem := TRectangle.Create(vert);
  with rectItem do
  begin
    Align := TAlignLayout.MostTop;
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := FItemBackgroundColor;
    HitTest := true;
    XRadius := 6;
    YRadius := 6;
    Margins.Bottom := 10;
    Height := 60;
    Stroke.Kind := TBrushKind.None;
  end;
  vert.AddObject(rectItem);

  lblItem := TLabel.Create(rectItem);
  with lblItem do
  begin
    Text := TextItem;
    Align := TAlignLayout.Client;
    VertTextAlign := TTextAlign.center;
    TextAlign := TTextAlign.Leading;
    StyledSettings := StyledSettings - [TStyledSetting.Size,
      TStyledSetting.FontColor];
    Font.Size := FItemFontSize;
    FontColor := FItemFontColor;
    HitTest := true;
    Margins.Left := 10;
    Margins.Right := 10;
    TagString := codItem;

{$IFDEF MSWINDOWS}
    OnClick := ItemClick;
{$ELSE}
    OnTap := ItemClick;
{$ENDIF}
  end;
  rectItem.AddObject(lblItem);

  vert.Repaint;
end;

procedure TCustomCombo.FinishFade(Sender: TObject);
begin
  rectFundo.Visible := FVisible;
end;

procedure TCustomCombo.ProcessFade(Sender: TObject);
begin
  rectFundo.Margins.Left := rectFundo.Margins.Right * -1;
end;

procedure TCustomCombo.HideMenu();
begin
  FVisible := false;

  Ani.Delay := 0;
  Ani.Inverse := true;
  Ani.Start;
end;

end.
