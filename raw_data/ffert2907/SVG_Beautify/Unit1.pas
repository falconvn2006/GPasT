unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, FMX.ListBox,
  FMX.Edit, FMX.Layouts, FMX.TabControl, ShellAPI,
  Math, Generics.Collections, uStringComparison,
  //FMX.TMSBaseControl, FMX.TMSScrollControl, FMX.TMSRichEditorBase,
  //FMX.TMSRichEditor,
  FMX.Memo.Types, FMX.Colors;

const
  K_SVGCMD = 'aAlLcCzZmMhHvVqQsS, ';

type

  TForm1 = class(TForm)
    M_SVG: TMemo;
    Path1: TPath;
    SB_ShowDesign: TSpeedButton;
    SB_ShowSelection: TSpeedButton;
    M_BackUp: TMemo;
    SB_FixSize: TSpeedButton;
    CB_NbChars: TComboBox;
    SB_DelphiConstant: TSpeedButton;
    E_Search: TEdit;
    Layout1: TLayout;
    Layout2: TLayout;
    Splitter1: TSplitter;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    SB_SplitShape: TSpeedButton;
    Splitter2: TSplitter;
    E_Scale: TEdit;
    Label1: TLabel;
    SB_ScalingSelection: TSpeedButton;
    Label2: TLabel;
    SB_UnDelphi: TSpeedButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TI_SVG: TTabItem;
    TabItem3: TTabItem;
    Image1: TImage;
    SB_OpenImage: TSpeedButton;
    OD: TOpenDialog;
    M_Target: TMemo;
    M_Source: TMemo;
    SpeedButton1: TSpeedButton;
    SB_Convert: TSpeedButton;
    LB_Sites: TListBox;
    SB_Comparer: TSpeedButton;
    M_Comparer: TMemo;
    SB_checkDiff: TSpeedButton;
    SP_OpenSVG: TSpeedButton;
    SB_AddCircle: TSpeedButton;
    E_Circle: TEdit;
    P_Delphi: TPanel;
    SB_RoundValues: TSpeedButton;
    P_Html: TPanel;
    SPB_HtmlCode: TSpeedButton;
    SB_Beautify: TSpeedButton;
    L_Size: TLabel;
    ColorPanel1: TColorPanel;
    CB_Stroke: TCheckBox;
    E_ColorInt: TEdit;
    E_ColorHex: TEdit;
    SB_Copy: TSpeedButton;
    procedure SB_BeautifyClick(Sender: TObject);
    procedure SB_ShowDesignClick(Sender: TObject);
    procedure SB_ShowSelectionClick(Sender: TObject);
    procedure SB_FixSizeClick(Sender: TObject);
    procedure SB_DelphiConstantClick(Sender: TObject);
    procedure E_SearchKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure SB_SplitShapeClick(Sender: TObject);
    procedure SB_ScalingSelectionClick(Sender: TObject);
    procedure M_SVGMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure SB_UnDelphiClick(Sender: TObject);
    procedure SB_OpenImageClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SB_ConvertClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LB_SitesDblClick(Sender: TObject);
    procedure SB_ComparerClick(Sender: TObject);
    procedure SB_checkDiffClick(Sender: TObject);
    procedure SP_OpenSVGClick(Sender: TObject);
    procedure SB_AddCircleClick(Sender: TObject);
    procedure SB_RoundValuesClick(Sender: TObject);
    procedure SPB_HtmlCodeClick(Sender: TObject);
    procedure M_SVGChange(Sender: TObject);
    procedure CB_StrokeChange(Sender: TObject);
    procedure ColorPanel1Change(Sender: TObject);
    procedure E_ColorHexChange(Sender: TObject);
    procedure SB_CopyClick(Sender: TObject);
  private
    function beautify(s: string): string;
    function CorrigeErreur(aStr: string): string;
    function GetXYFromSTR(var aStr: string): TPointF;
    function ToSVGValue(aVal: single): string;
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}


function TForm1.beautify(s : string) : string;
var
  i : integer;
  vPointFlag : boolean;
begin
  //
  i := 0;
  vPointFlag := false;
  s := StringReplace(s, '-', ' -', [rfReplaceAll]);
  s := StringReplace(s, '  ', ' ', [rfReplaceAll]);

  while i < length(s) do
  begin
    if i < length(s)-1 then
    begin
      if (s[1 + i] = '.') and (vPointFlag) then
      begin
        if s[i] = '-' then
          s := s.Insert(i, '0')
        else
          s := s.Insert(i, ' 0');
        vPointFlag := false;
      end;

      if pos(s[1+i], K_SVGCMD) > 0 then // 'MmSsLlHhVvCcZz, '
      begin
        if (s[1 + i] <> ' ') then
        begin
          s := s.Insert(i, #$D#$A);
          i := i + 2;
        end;
        vPointFlag := false;
      end;

      if s[i] = '.' then
        vPointFlag := true;
    end;

    inc(i);
  end;
  result := s
end;


procedure TForm1.E_ColorHexChange(Sender: TObject);
begin
  //
  ColorPanel1.Tag := 1;
  ColorPanel1.Color := StrToInt('$' + E_ColorHex.Text);
  E_ColorInt.Text := StrToInt('$' + E_ColorHex.Text).ToString;
  ColorPanel1.Tag := 0;
end;

procedure TForm1.E_SearchKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    M_SVG.Lines.Text := StringReplace(M_SVG.Lines.Text, E_Search.Text, #$A#$D + E_Search.Text, [rfReplaceAll]);
    //M_SVG.SelStart := pos(E_Search.Text, M_SVG.Lines.Text);
    //M_SVG.SelLength := Length(E_Search.Text);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LB_Sites.ItemIndex := 0;
end;

procedure TForm1.LB_SitesDblClick(Sender: TObject);
begin
  SB_ConvertClick(SB_Convert);
end;

procedure TForm1.M_SVGChange(Sender: TObject);
begin
  L_Size.Text := Inttostr(length(M_SVG.Lines.Text)) + 'Octets';
end;

procedure TForm1.M_SVGMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  SB_ScalingSelection.TagString := M_SVG.SelText;
end;

Function DrawBezierOvalQuarter(aCenterX, aCenterY, aSizeX, aSizeY : double ; aStartPoint : boolean) : string;
var
  vSVG : string;
  vCoef : double;
begin
  // expliqué ici : https://spencermortensen.com/articles/bezier-circle/
  // et ici : https://stackoverflow.com/questions/1734745/how-to-create-circle-with-b%C3%A9zier-curves
  // position départ : m3 4
  // premier curve : c -.83 0 -1.5 -.67 -1.5 -1.5
  // autre point : S16.67 9 17.5 9
  // autres points : s1.5 0.67 1.5 1.5 -.67 1.5 -1.5 1.5z

  vCoef := 0.551915024494;
  if aStartPoint then
  begin
    vSVG := ' M' ;
  end
  else
  begin
    vSVG := ' S' ;

  end;

  vSVG := vSVG + ' ' + FloatToStr(aCenterX - aSizeX) + ' ' + FloatToStr(aCenterY - (0)) + ' ';

  if aStartPoint then
  begin
    vSVG := vSVG + ' C';
  end;

  vSVG := vSVG + FloatToStr(acenterX - (aSizeX)) + ' ';
  vSVG := vSVG + FloatToStr(acenterY - (vCoef * aSizeY)) + ' ';
  vSVG := vSVG + FloatToStr(acenterX - (vCoef * aSizeX)) + ' ';
  vSVG := vSVG + FloatToStr(acenterY - (aSizeY)) + ' ';
  vSVG := vSVG + FloatToStr(acenterX - (0)) + ' ';
  vSVG := vSVG + FloatToStr(acenterY - (aSizeY)) + ' ';

  result := vSVG;
end;

procedure TForm1.SB_AddCircleClick(Sender: TObject);
var
  s : string;
  vSVG : string;
  vCoef : double;
  vCenterX : double;
  vCenterY : double;
  vSizeX : double;
  vSizeY : double;
begin
  // expliqué ici : https://spencermortensen.com/articles/bezier-circle/
  // et ici : https://stackoverflow.com/questions/1734745/how-to-create-circle-with-b%C3%A9zier-curves

  vCoef := 0.551915024494;
  vSVG := 'M';

  s := E_Circle.Text;
  if s[length(s)] <> ';' then
    E_Circle.Text := E_Circle.Text + ';';

  vCenterX := strtoFloat(copy(s, 0, pos(';', s) -1));
  s := copy(s, 1 + pos(';', s), length(s));
  vCenterY := strtoFloat(copy(s, 0, pos(';', s) -1));
  s := copy(s, 1 + pos(';', s), length(s));
  vSizeX := strtoFloat(copy(s, 0, pos(';', s) -1));
  s := copy(s, 1 + pos(';', s), length(s));
  vSizeY := strtoFloatDef(copy(s, 0, pos(';', s) -1), vSizeX);

  vSVG := DrawBezierOvalQuarter(vCenterX, vCenterY, -vSizeX, vSizeY , true);
  vSVG := vSVG + DrawBezierOvalQuarter(vCenterX, vCenterY, vSizeX, vSizeY, true);
  vSVG := vSVG + DrawBezierOvalQuarter(vCenterX, vCenterY, vSizeX, -vSizeY, true);
  vSVG := vSVG + DrawBezierOvalQuarter(vCenterX, vCenterY, -vSizeX, -vSizeY, true);
  vSVG := vSVG + ' M' + FloatToStr(vCenterX - vSizeX) + ' ' + FloatToStr(vCenterY - (0)) + 'z ';

  M_SVG.lines.Add(StringReplace(vSVG, ',', '.', [rfReplaceAll]));

//function drawBezierOvalQuarter(centerX, centerY, sizeX, sizeY) {
//    ctx.beginPath();
//    ctx.moveTo(
//    	centerX - (sizeX),
//        centerY - (0)
//    );
//    ctx.bezierCurveTo(
//    	centerX - (sizeX),
//        centerY - (0.552 * sizeY),
//        centerX - (0.552 * sizeX),
//        centerY - (sizeY),
//        centerX - (0),
//        centerY - (sizeY)
//    );
//	ctx.stroke();
//}
//
//function drawBezierOval(centerX, centerY, sizeX, sizeY) {
//    drawBezierOvalQuarter(centerX, centerY, -sizeX, sizeY);
//    drawBezierOvalQuarter(centerX, centerY, sizeX, sizeY);
//    drawBezierOvalQuarter(centerX, centerY, sizeX, -sizeY);
//    drawBezierOvalQuarter(centerX, centerY, -sizeX, -sizeY);
//}
//
//function drawBezierCircle(centerX, centerY, size) {
//    drawBezierOval(centerX, centerY, size, size)
//}
//
//drawBezierCircle(200, 200, 64)
end;

procedure TForm1.CB_StrokeChange(Sender: TObject);
begin
  if CB_Stroke.IsChecked then
    Path1.Stroke.Kind := TBrushKind.Solid
  else
    Path1.Stroke.Kind := TBrushKind.None;
end;

procedure TForm1.ColorPanel1Change(Sender: TObject);
begin
  Path1.Fill.Color := ColorPanel1.Color;
  if  ColorPanel1.Tag = 0 then
  begin
    E_ColorHex.Text := integer(ColorPanel1.Color).ToHexString(8);
    E_ColorInt.Text := IntToStr(ColorPanel1.Color);
  end;

end;

function TForm1.CorrigeErreur(aStr : string) : string;
var
  vStr : String;
  i : integer;
  vPoint : boolean;
begin
  // permet de gérer les valeurs à plusieurs . comme
  // par exemple c.22.36.86.93 devient : c 0.22 0.36 0.86 0.93
  for i := 0 to aStr.length do
  begin
    if aStr[i] = '.' then
    begin
      if vPoint then
        vStr := vStr + ' 0';
      vPoint := true;
    end
    else if pos(aStr[i], K_SVGCMD) > 0 then
    begin
      vPoint := false;
    end;
    vStr := vStr + aStr[i]
  end;

  result := vStr;

end;

function TForm1.GetXYFromSTR(var aStr : string) : TPointF;
var
  done : boolean;
  doneX : boolean;
  i : integer;
  v : string;
  pt : TPointF;
  LocalFormat: TFormatSettings;
begin
  pt := TPointF.Create(0,0);
  done := false;
  doneX := false;
  i := 1;
  v := '';
  aStr := trim(aStr);
  LocalFormat := TFormatSettings.Create;

  while not(done) do
  begin
    if pos(aStr[i], '0123456789') > 0 then
      v := v + aStr[i]
    else if aStr[i] = '.' then
      v := v + LocalFormat.DecimalSeparator
    else if v <> '' then
    begin
      if not(doneX) then
      begin
        pt.X := strtofloat(v); //RoundTo(strtofloat(v), -2);
        v := '';
        doneX := true
      end
      else
      begin
        pt.Y := strtofloat(v); //RoundTo(strtofloat(v), -2);
        v := '';
        aStr := copy(aStr, i, length(aStr));
        done := true;
      end;
    end;
    inc(i);
  end;
  result := pt;
end;

function TForm1.ToSVGValue(aVal : single) : string;
var
  LocalFormat: TFormatSettings;
begin
  LocalFormat := TFormatSettings.Create;
  result := StringReplace(floattostr(RoundTo(aVal, -2)),  LocalFormat.DecimalSeparator, '.', []);
end;

procedure TForm1.SB_BeautifyClick(Sender: TObject);
var
  i : integer;
  s : string;
  sc : string;
  st : string;
  x, y, r1, r2 : single;
  Pt1 : TPointF;
  Pt2 : TPointF;
  c : word;
  ch : char;
begin
  // beautify code
  M_SVG.Lines.Text := stringReplace(M_SVG.Lines.Text, 'fill="none"','', [rfReplaceAll,rfIgnoreCase]);

  if (M_SVG.Lines.Text = '') and (M_BackUp.Lines.Text <> '') then
    M_SVG.Lines.Text := M_BackUp.Lines.Text;

  M_SVG.Lines.Text := StringReplace( M_SVG.Lines.Text, '<', #$D#$A + '<', [rfReplaceAll]);
  M_BackUp.Lines.Text  := M_SVG.Lines.Text;

  i := 0;
  while i < M_SVG.Lines.Count do
  begin
    s := M_SVG.Lines[i];
    if (pos('<svg', s) = 1) and (pos('<path', s) = 0) then
      s := '';
    if (pos('</svg', s) = 1) and (pos('<path', s) = 0) then
      s := '';
     if (pos('</g>', s) = 1) and (pos('<path', s) = 0) then
      s := '';
     if (pos('<rect ', s) = 1) and (pos('<path', s) = 0) then
      s := '';
    if (pos('<?xml', s) = 1) and (pos('<path', s) = 0) then
      s := '';
    if (pos('<!DOCTYPE', s) = 1) and (pos('<path', s) = 0) then
      s := '';
    if (pos('<g', s) = 1) and (pos('<path', s) = 0) then
      s := '';
    if (pos('fill=none', s) = 1) and (pos('<path', s) = 0) then
      s := '';

    if (pos('<circle ', s) = 1) and (pos('<path', s) = 0) then
    begin
      sc := trim(stringReplace(copy(s, 8, pos('>', s) -1), '/>', '', [rfReplaceAll]));
      s := copy(s, 1 + pos('>', s), length(s));
      if pos('cx=', sc) > 0 then
      begin
        st := (copy(sc, 3 + pos('cx=', sc), length(sc)));
        st := trim(stringreplace(st, '"', '', [rfReplaceAll]));
        st := copy(st, 0, pos(' ', st) - 1);
        x := strtofloat(st);
      end;
      if pos('cy=', sc) > 0 then
      begin
        st := (copy(sc, 3 + pos('cy=', sc), length(sc)));
        st := trim(stringreplace(st, '"', '', [rfReplaceAll]));
        st := copy(st, 0, pos(' ', st) - 1);
        y := strtofloat(st);
      end;
      if pos('r=', sc) > 0 then
      begin
        st := (copy(sc, 2 + pos('r=', sc), length(sc)));
        st := trim(stringreplace(st, '"', '', [rfReplaceAll]));
        // st := copy(st, 0, pos(' ', st) - 1);
        r1 := strtofloat(st);
      end;
      E_Circle.Text := floattostr(x) + ';' + floattostr(y) + ';' + floattostr(r1) + ';';
      SB_AddCircleClick(Sender);
    end;

    if (pos('<polygon ', s) = 1) and (pos('<path', s) = 0) then
    begin
      s := stringreplace(copy(s, 8 + pos('points=', s), length(s)), '"', '', [rfReplaceAll]);
      st := 'M' + copy(s, 0, pos(' ', s));
      Pt1 := GetXYFromSTR(s);
      while s <> '' do
      begin
        Pt2 := GetXYFromSTR(s);
        if s <> '' then
          st := st + ' l' + ToSVGValue(RoundTo(Pt2.X-Pt1.X, -2)) + ',' + ToSVGValue(RoundTo(Pt2.Y-Pt1.Y, -2));
        Pt1 := Pt2;
      end;
      st := st + 'z';
      M_SVG.Lines.Add(st);
    end;



    if s <> '' then
    begin
      if pos('<path ', s) > 0 then
      begin
        s := trim(copy(s, 3 + pos(' d=', s), length(s)));
//        s := stringReplace(s, '<path','', [rfReplaceAll,rfIgnoreCase]);
//        s := stringReplace(s, 'd=','', [rfReplaceAll,rfIgnoreCase]);
        s := stringReplace(s, '/>','', [rfReplaceAll]);
        //s := copy(s, 0, 1 + pos('"', copy(s, 2, length(s))));
        s := stringReplace(s, '"','', [rfReplaceAll]);

        M_SVG.Lines[i] := Beautify(s);
      end;


      inc(i);
    end
    else
      M_SVG.Lines.Delete(i);
  end;
  M_SVG.Lines.Text := stringReplace(M_SVG.Lines.Text, '"','', [rfReplaceAll]);
  M_SVG.Lines.Text := CorrigeErreur( stringReplace(M_SVG.Lines.Text, '/>','', [rfReplaceAll]));

  try
    Path1.Data.Data := StringReplace(M_SVG.Lines.text, #$D#$A, ' ', [rfReplaceAll]);
  except
    //    raise Exception.Create('Message d''erreur');
    on E : Exception do
    begin
      E_Search.Text := StringReplace(StringReplace(E.Message, '''', '', [rfReplaceAll]), ' nest pas une valeur en virgule flottante correcte','', []);
      E_Search.SetFocus;
      c := word(13);
      ch := chr(13);
      E_SearchKeyDown(E_Search, c, ch, []);
    end;
  end;

end;

procedure TForm1.SB_checkDiffClick(Sender: TObject);
var
  i : integer;
  s : string;
  Up1 : integer;
  Up2 : integer;
begin
  s := M_Comparer.Lines.Text;
  Up1 := -1;
  Up2 := -1;
  i := M_comparer.SelStart + M_comparer.SelLength;
  while i < s.Length do
  begin
    if (s[i] = '°') then   // and (Up2 = -1) then
    begin
      if Up1 > -1 then
      begin
         M_comparer.SelLength := i - Up1 - 1;
         exit;
      end
      else
      begin
        Up1 := i;
        M_comparer.SelStart := i;
        M_comparer.SelLength  := 1;
      end;
    end
    else if (s[i] = '¤') then // and (Up1 = -1) then
    begin
      if Up2 > -1 then
      begin
        M_comparer.SelLength := i - Up2 - 1;
        exit;
      end
      else
      begin
        Up2 := i;
        M_comparer.SelStart := i;
        M_comparer.SelLength := 1;
      end;
    end;
    inc(i);
  end;

end;

procedure TForm1.SB_DelphiConstantClick(Sender: TObject);
var
  i : integer;
begin
  if (pos('<', M_SVG.Lines.text) > 0) or (pos('>', M_SVG.Lines.text) > 0) then
  begin
    SB_BeautifyClick(SB_Beautify);
  end;

  SB_FixSizeClick(Sender);

  i := 0;
  while i < (M_SVG.Lines.Count) do
  begin
    if i = 0 then
      M_SVG.Lines[i] := 'SVG_DESIGN = ''' + M_SVG.Lines[i] + '''' + '+'
    else if i = M_SVG.Lines.Count - 1 then
      M_SVG.Lines[i] := '    ''' + M_SVG.Lines[i] + '''' + ';'
    else
      M_SVG.Lines[i] := '    ''' + M_SVG.Lines[i] + '''' + '+';
    inc(i);
  end;
end;

procedure TForm1.SB_FixSizeClick(Sender: TObject);
var
  i : integer;
  vLast : integer;
  s : string;
  vSplit : boolean;
  vSize : integer;
begin
  // mettre les données sur une taille fixe pour aller à la ligne
  i := 0;
  vSize := StrToInt(CB_NbChars.Items[CB_NbChars.ItemIndex]);
  vSplit := false;
  vLast := 0;
  s := StringReplace(M_SVG.Lines.Text, #$D#$A, ' ', [rfReplaceAll]);
  while i < length(s) do
  begin
    if vSplit then
    begin
      if pos(s[i], K_SVGCMD) > 0 then  // 'MmSsLlHhVvCcZz ') > 0 then
      begin
        s := s.Insert(i, ' ' + #$D#$A + ' ');
        i := i + 4;
        vSplit := false;
        vLast := i;
      end;
    end;

    inc(i);
    if i - vLast > vSize then
      vSplit := true;
  end;

  M_SVG.Lines.Text := StringReplace(s, '  ', ' ', [rfReplaceAll]);
end;

procedure TForm1.SB_OpenImageClick(Sender: TObject);
begin
  //
  if OD.Execute then
  begin
    Image1.Bitmap.LoadFromFile(OD.FileName);
  end;
end;

procedure TForm1.SB_RoundValuesClick(Sender: TObject);
var
  s : string;
  i : integer;
  vSelection : integer;
begin
  s := M_SVG.Lines.Text;

  i := 0;
  vSelection := -1;
  while i < length(s) do
  begin
    if vSelection > 0 then
    begin
      if pos(s[i], '0123456789') = 0 then
      begin
        // on est sorti des chiffres, on supprime le texte
        if i - vSelection > 2 then
        begin
          s := copy(s, 0, 2 + vSelection) + copy(s, i, length(s));
          i := 2 + vSelection;
          vSelection := -1;
        end;
      end;
    end
    else if s[i] = '.' then
    begin
      vSelection := i;
    end;

    inc(i);
  end;
  M_SVG.Lines.Text := s;
end;

procedure TForm1.SB_ScalingSelectionClick(Sender: TObject);
var
i : integer;
  s : string;
  aValue : string;
  aVal : single;
  aStartVal : integer;
  aEndVal : integer;
  vScaled : string;
  vCoef : single;
begin
  vCoef := strtofloat(E_Scale.Text);
  s := SB_ScalingSelection.TagString; //M_SVG.SelText;
  aValue := '';
  i := 1;
  while i <= length(s) do
  begin
    if pos(s[i], '.0123456789') > 0 then
    begin
      if s[i] = '.' then
        aValue := aValue + ','
      else
        aValue := aValue + s[i];

    end
    else
    begin
      if aValue <> '' then
      begin
        aVal := strtofloat(aValue) * vCoef;
        vScaled := vScaled + stringReplace(FloatToStrF(aVal, ffFixed, 15, 2), ',', '.', []);
      end;
      vScaled := vScaled + s[i];
      aValue := '';
    end;
    inc(i);
  end;

  M_SVG.Lines.Text := stringreplace(M_SVG.Lines.Text, s, vScaled, []);

//  M_SVG.SelText := vScaled;
end;

procedure TForm1.SB_ShowDesignClick(Sender: TObject);
begin
  Path1.Data.Data := StringReplace(M_SVG.Lines.text, #$D#$A, ' ', [rfReplaceAll]);
end;

procedure TForm1.SB_ShowSelectionClick(Sender: TObject);
var
  s : string;
begin
  //
  s := trim(StringReplace(M_SVG.SelText, #$D#$A, ' ', [rfReplaceAll]));
  if pos(s[length(s)], 'zZ') = 0  then
    s := s + 'z';
  Path1.Data.Data := s;
end;

procedure TForm1.SB_SplitShapeClick(Sender: TObject);
begin
  M_SVG.Lines.Text := StringReplace(M_SVG.Lines.Text, 'z', 'z' + #$A#$D, [rfReplaceAll, RfIgnoreCase]);
end;

procedure TForm1.SB_UnDelphiClick(Sender: TObject);
var
  s : string;
  i : integer;
begin
  s := M_SVG.Lines.Text;
  if pos('=', s) > 0 then
    s := copy(s, 1 + pos('=', s), length(s));
  s := stringReplace(s, '''', '', [rfReplaceAll]);
  s := stringReplace(s, '+', '', [rfReplaceAll]);
  s := stringReplace(s, ';', '', [rfReplaceAll]);
  M_SVG.Lines.Text := s;
  i := 0;
  while i < M_SVG.Lines.Count do
  begin
    M_SVG.Lines[i] := trim(M_SVG.Lines[i]);
    inc(i);
  end;

end;

procedure TForm1.SPB_HtmlCodeClick(Sender: TObject);
var
  s : string;
  vWidth : string;
  vHeight : string;
begin
  // créer un code html
  if pos('<svg ', M_SVG.Lines.Text) < 1 then
  begin

    vWidth := inttostr(trunc(ifThen( Path1.Data.GetBounds.Width = trunc(Path1.Data.GetBounds.Width), Path1.Data.GetBounds.Width, 1 + Path1.Data.GetBounds.Width)));
    vHeight := inttostr(trunc(ifThen( Path1.Data.GetBounds.Height = trunc(Path1.Data.GetBounds.Height), Path1.Data.GetBounds.Height,  1 + Path1.Data.GetBounds.Height)));

    s := M_SVG.Lines.Text;
    s := '<svg xmlns="http://www.w3.org/2000/svg" width="' + vWidth +
      '" height="' + vHeight + '" viewBox="0 0 ' + vWidth +' ' + vHeight + '">' + #$A#$D +
      '<path d="M0 0h' + vWidth +'v' + vHeight + 'H0z" fill="none"/>' + #$A#$D +
      '<path d="' + s + '"/>'+#$A#$D+
      '</svg>';

    M_SVG.Lines.Text := s;
  end;

end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  s : string;
begin
  Image1.Bitmap.Rotate(180);
  s := OD.FileName;
  s := copy(s,0, length(s) -4) + '_R180' + copy(s,length(s) -4, 5);
  Image1.Bitmap.SaveToFile(s);
end;

procedure TForm1.SP_OpenSVGClick(Sender: TObject);
begin
  if OD.Execute then
  begin
    M_SVG.Lines.LoadFromFile(OD.FileName);
  end;
end;

procedure TForm1.SB_ComparerClick(Sender: TObject);
var
  Differences: TList<TDiff>;
  Diff: TDiff;
begin
//  //Yes, I know...this method could be refactored ;-)
  Differences := TStringComparer.Compare(M_Source.Lines.Text, M_Target.Lines.Text);
  try
    M_Comparer.lines.Clear;
    for Diff in Differences do
    begin
      M_Comparer.SelStart := M_Comparer.Text.Length;
      if Diff.CharStatus = '+' then
      begin
        //M_Comparer.SelectionColor := clBlue;
        M_Comparer.lines.Text := M_Comparer.lines.Text + '¤' + Diff.Character + '¤';
        //RE_Compare.SelectedText := Diff.Character;
      end
      else if Diff.CharStatus = '-' then
      begin
        M_Comparer.lines.Text := M_Comparer.lines.Text + '°' + Diff.Character + '°';
//        M_Comparer.InsertText(RE_Compare.Text.Length, '°' + Diff.Character + '°');
//        M_Comparer.SelLength := 2;
//        M_Comparer.SelectionColor := clRed;
//        RE_Compare.PlainText := RE_Compare.PlainText + Diff.Character;
        //RE_Compare.SelectedText := Diff.Character;
      end
      else
      begin
        M_Comparer.lines.Text := M_Comparer.lines.Text + Diff.Character;
//        M_Comparer.SelectionColor := clBlack;
//        M_Comparer.InsertText(RE_Compare.Text.Length, Diff.Character);
//        RE_Compare.PlainText := RE_Compare.PlainText + Diff.Character;
        //RE_Compare.SelectedText := Diff.Character;
      end;
    end;

     M_Comparer.lines.Text := StringReplace(M_Comparer.lines.Text, '°°', '', [rfReplaceAll]);
     M_Comparer.lines.Text := StringReplace(M_Comparer.lines.Text, '¤¤', '', [rfReplaceAll]);

  finally
    Differences.Free;
  end;




end;

procedure TForm1.SB_ConvertClick(Sender: TObject);
var
  s : string;
begin
  s := LB_Sites.Items[LB_Sites.ItemIndex];
  s := StringReplace(s, '{{Rotation}}', '', [rfReplaceAll]);
  ShellExecute(0, 'open', PWideChar(s), nil, nil, 0);
end;

procedure TForm1.SB_CopyClick(Sender: TObject);
var
  Stream : TMemoryStream;

begin
  //
  Form1.Canvas.Bitmap.SaveToFile('test.jpg');
//  Stream := TMemoryStream.Create;
//  Path1.Canvas.Bitmap.SaveToStream(Stream);
//  Stream.SaveToFile('Test.png');
//  Stream.Free;
end;

end.
