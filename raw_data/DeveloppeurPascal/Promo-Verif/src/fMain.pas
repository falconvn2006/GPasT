unit fMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.ExtCtrls, FMX.Layouts, FMX.ListBox,
  FMX.EditBox, FMX.NumberBox, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, System.JSON, FMX.DzHTMLText,
  Olf.FMX.TextImageFrame;

type
  TfrmMain = class(TForm)
    TabControl1: TTabControl;
    tabListe: TTabItem;
    tabCalcul: TTabItem;
    tabInfos: TTabItem;
    vsbCalculs: TVertScrollBox;
    VertScrollBox2: TVertScrollBox;
    txtCopyright: TDzHTMLText;
    logo: TRectangle;
    Layout1: TLayout;
    VertScrollBox3: TVertScrollBox;
    lblNb: TLabel;
    edtNb: TNumberBox;
    lblPoids: TLabel;
    edtPoids: TNumberBox;
    lblUnite: TLabel;
    edtUnite: TComboBox;
    lblPrix: TLabel;
    edtPrix: TNumberBox;
    lblCashback: TLabel;
    edtCashback: TNumberBox;
    btnCalcul: TButton;
    tiPromo: TOlfFMXTextImageFrame;
    tiVerif: TOlfFMXTextImageFrame;
    Layout2: TLayout;
    Layout3: TLayout;
    procedure FormCreate(Sender: TObject);
    procedure btnCalculClick(Sender: TObject);
    procedure edtNbEnter(Sender: TObject);
    procedure vsbCalculsResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure txtCopyrightLinkClick(Sender: TObject; Link: TDHBaseLink;
      var Handled: Boolean);
  private
    { Déclarations privées }
    histo: TJSONObject;
    histo_filename: string;
    procedure initialiseEcranListe;
    procedure initialiseEcranCalcul;
    procedure afficheResultatCalcul(nb: integer; poids: double; unite: string;
      prix, remise: double);
    procedure histo_charger;
    procedure histo_sauver;
    procedure histo_ajouter(nb: integer; poids: double; unite: string;
      prix, remise: double);
  public
    { Déclarations publiques }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses System.Math, System.IOUtils, uDm, u_urlOpen,
  udmPromoVerifTypoAdobeStock_212889779;

procedure TfrmMain.afficheResultatCalcul(nb: integer; poids: double;
  unite: string; prix, remise: double);
var
  rectangle: TRectangle;
  i: integer;
  decalage: single;
  lbl: TLabel;
  prixaukilo: double;
begin
  rectangle := TRectangle.Create(self);
  try
    rectangle.Parent := vsbCalculs;
    // rectangle.XRadius := 20;
    // rectangle.YRadius := 10;
    rectangle.Margins.Top := 5;
    rectangle.Margins.right := 5;
    rectangle.Margins.bottom := 5;
    rectangle.Margins.left := 5;
    // rectangle.Padding.Top := rectangle.YRadius;
    // rectangle.Padding.right := rectangle.XRadius;
    // rectangle.Padding.bottom := rectangle.YRadius;
    // rectangle.Padding.left := rectangle.XRadius;
    rectangle.Padding.Top := 5;
    rectangle.Padding.right := 5;
    rectangle.Padding.bottom := 5;
    rectangle.Padding.left := 5;
    rectangle.position.X := rectangle.Margins.left + vsbCalculs.Padding.left;
    rectangle.position.Y := rectangle.Margins.Top + vsbCalculs.Padding.Top;
    rectangle.Width := vsbCalculs.clientWidth - rectangle.Margins.left -
      vsbCalculs.Padding.left - rectangle.Margins.right -
      vsbCalculs.Padding.right;
    rectangle.Height := rectangle.Padding.Top + rectangle.Padding.bottom;
    // rectangle.Anchors := [TAnchorKind.akLeft, TAnchorKind.akRight];
    decalage := rectangle.Padding.Top;
    lbl := TLabel.Create(self);
    try
      lbl.Parent := rectangle;
      lbl.position.X := rectangle.Padding.left;
      lbl.Width := rectangle.Width - rectangle.Padding.left -
        rectangle.Padding.right;
      lbl.position.Y := decalage;
      decalage := lbl.position.Y + lbl.Margins.Top + lbl.Height +
        lbl.Margins.bottom;
      rectangle.Height := rectangle.Height + lbl.Margins.Top + lbl.Height +
        lbl.Margins.bottom;
      // lbl.Anchors := [TAnchorKind.akLeft, TAnchorKind.akRight];
      lbl.Text := nb.ToString + ' x ' + poids.ToString(tfloatformat.ffFixed, 10,
        2) + unite + ' => ' + prix.ToString(tfloatformat.ffCurrency, 10, 2);
      if (unite = 'g') or (unite = 'cl') then
        prixaukilo := (1000 * prix) / (poids * nb)
      else if (unite = 'kg') or (unite = 'l') then
        prixaukilo := prix / (poids * nb)
      else
        raise exception.Create('Unité ''' + unite + ''' non prise en charge.');
    except
      freeandnil(lbl);
    end;
    if (remise > 0) then
    begin
      lbl := TLabel.Create(self);
      try
        lbl.Parent := rectangle;
        lbl.position.X := rectangle.Padding.left;
        lbl.Width := rectangle.Width - rectangle.Padding.left -
          rectangle.Padding.right;
        lbl.position.Y := decalage;
        decalage := lbl.position.Y + lbl.Margins.Top + lbl.Height +
          lbl.Margins.bottom;
        rectangle.Height := rectangle.Height + lbl.Margins.Top + lbl.Height +
          lbl.Margins.bottom;
        // lbl.Anchors := [TAnchorKind.akLeft, TAnchorKind.akRight];
        lbl.Text := 'Remboursement prochain achat : ' +
          remise.ToString(tfloatformat.ffCurrency, 10, 2);
        prixaukilo := prixaukilo - remise;
      except
        freeandnil(lbl);
      end;
    end;
    lbl := TLabel.Create(self);
    try
      lbl.Parent := rectangle;
      lbl.position.X := rectangle.Padding.left;
      lbl.Width := rectangle.Width - rectangle.Padding.left -
        rectangle.Padding.right;
      lbl.position.Y := decalage;
      decalage := lbl.position.Y + lbl.Margins.Top + lbl.Height +
        lbl.Margins.bottom;
      rectangle.Height := rectangle.Height + lbl.Margins.Top + lbl.Height +
        lbl.Margins.bottom;
      // lbl.Anchors := [TAnchorKind.akLeft, TAnchorKind.akRight];
      if (unite = 'kg') or (unite = 'g') then
        lbl.Text := 'Prix au kilo : ' + prixaukilo.ToString
          (tfloatformat.ffCurrency, 10, 2)
      else if (unite = 'l') or (unite = 'cl') then
        lbl.Text := 'Prix au litre : ' + prixaukilo.ToString
          (tfloatformat.ffCurrency, 10, 2)
      else
        raise exception.Create('Unité ''' + unite + ''' non prise en charge.');
    except
      freeandnil(lbl);
    end;
    if (vsbCalculs.Content.ChildrenCount > 0) then
    begin
      decalage := rectangle.Margins.Top + rectangle.Height +
        rectangle.Margins.bottom;
      rectangle.position.Y := rectangle.position.Y - decalage;
      for i := 0 to vsbCalculs.Content.ChildrenCount - 1 do
      begin
        if (vsbCalculs.Content.Children[i] is TRectangle) then
          (vsbCalculs.Content.Children[i] as TRectangle).position.Y :=
            (vsbCalculs.Content.Children[i] as TRectangle).position.Y +
            decalage;
      end;
    end;
  except
    freeandnil(rectangle);
  end;
end;

procedure TfrmMain.btnCalculClick(Sender: TObject);
begin
  if (edtNb.Value < 1) then
  begin
    edtNb.SetFocus;
    raise exception.Create('Combien ?');
  end;
  if (edtPoids.Value < 1) then
  begin
    edtPoids.SetFocus;
    raise exception.Create('Quel poids ?');
  end;
  if (edtPrix.Value < 1) then
  begin
    edtPrix.SetFocus;
    raise exception.Create('Quel prix ?');
  end;
  afficheResultatCalcul(ceil(edtNb.Value), edtPoids.Value,
    edtUnite.Items[edtUnite.ItemIndex], edtPrix.Value, edtCashback.Value);
  histo_ajouter(ceil(edtNb.Value), edtPoids.Value,
    edtUnite.Items[edtUnite.ItemIndex], edtPrix.Value, edtCashback.Value);
  initialiseEcranCalcul;
  TabControl1.ActiveTab := tabListe;
end;

procedure TfrmMain.edtNbEnter(Sender: TObject);
begin
  if (Sender is TNumberBox) then
    (Sender as TNumberBox).SelectAll;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // initialisation générale
  TabControl1.ActiveTab := tabCalcul;
  histo_filename := tpath.Combine(tpath.GetDocumentsPath, 'PromoVerif.dat');
  histo_charger;
  // initialisation onglet liste
  initialiseEcranListe;
  // initialisation onglet calcul
  initialiseEcranCalcul;
  // initialisation onglet infos
  txtCopyright.Text :=
    'Calculez le prix au kilo ou au litre des produits qui vous intéressent.<br>'
    + 'Comparez le prix réel entre les offres par lot, en promo, en cadeau ou à l''unité.<br>'
    + '<br>' +
    'Infos et contacts sur <a>https://promoverif.olfsoftware.fr</a><br>' +
    '<br>' + 'Développement réalisé sous Delphi 11.3 Alexandria.<br>' +
    'Merci à Digao Dalpiaz pour le composant DzHTMLText permettant l''affichage de ce texte avec mise en forme.<br>'
    + 'Certains éléments graphiques sont sous licence Adobe Stock.<br>' + '<br>'
    + '(c) Patrick Prémartin / Olf Software 2017-2023<br>';

  tiPromo.Font := dmPromoVerifTypoAdobeStock_212889779.ImageList;
  tiVerif.Font := dmPromoVerifTypoAdobeStock_212889779.ImageList;
  tiPromo.Text := 'PROMO';
  tiVerif.Text := 'VERIF';
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if assigned(histo) then
    freeandnil(histo);
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if ((Key = vkHardwareBack) or (Key = vkEscape)) then
  begin
    if (TabControl1.ActiveTab = tabCalcul) then
      TabControl1.ActiveTab := tabListe
    else if (TabControl1.ActiveTab = tabInfos) then
      TabControl1.ActiveTab := tabListe
    else
      close;
    Key := 0;
    KeyChar := #0;
  end;
end;

procedure TfrmMain.histo_ajouter(nb: integer; poids: double; unite: string;
  prix, remise: double);
var
  elem: TJSONObject;
  lst: TJSONArray;
begin
  if (not assigned(histo)) then
    histo := TJSONObject.Create;
  lst := histo.GetValue('liste') as TJSONArray;
  if (not assigned(lst)) then
  begin
    lst := TJSONArray.Create;
    histo.AddPair('liste', lst);
  end;
  while (lst.Count > 50) do
    lst.Remove(0);
  elem := TJSONObject.Create;
  try
    elem.AddPair('nb', TJSONNumber.Create(nb));
    elem.AddPair('pds', TJSONNumber.Create(poids));
    elem.AddPair('unit', unite);
    elem.AddPair('prx', TJSONNumber.Create(prix));
    elem.AddPair('rem', TJSONNumber.Create(remise));
    lst.AddElement(elem);
  except
    freeandnil(elem);
  end;
  histo_sauver;
end;

procedure TfrmMain.histo_charger;
begin
  if tfile.Exists(histo_filename) then
    try
      histo := TJSONObject.ParseJSONValue(tfile.ReadAllBytes(histo_filename), 0)
        as TJSONObject;
    except
      histo := TJSONObject.Create;
    end;
end;

procedure TfrmMain.histo_sauver;
begin
  tfile.WriteAllText(histo_filename, histo.ToJSON, tencoding.UTF8);
end;

procedure TfrmMain.initialiseEcranCalcul;
begin
  edtNb.Value := 1;
  edtPoids.Value := 0;
  edtUnite.ItemIndex := edtUnite.Items.IndexOf('g');
  // grammes par défaut
  edtPrix.Value := 0;
  edtCashback.Value := 0;
end;

procedure TfrmMain.initialiseEcranListe;
var
  elem: TJSONObject;
  lst: TJSONArray;
  i: integer;
  nb: integer;
  poids, prix, remise: double;
  unite: string;
begin
  try
    lst := histo.GetValue('liste') as TJSONArray;
  except
    lst := TJSONArray.Create;
  end;
  if (lst.Count > 0) then
    for i := 0 to lst.Count - 1 do
    begin
      elem := lst.Items[i] as TJSONObject;
      try
        nb := (elem.GetValue('nb') as TJSONNumber).AsInt64;
      except
        nb := 0;
      end;
      try
        poids := (elem.GetValue('pds') as TJSONNumber).AsDouble;
      except
        poids := 0;
      end;
      try
        unite := elem.GetValue('unit').Value;
      except
        unite := 'g';
      end;
      try
        prix := (elem.GetValue('prx') as TJSONNumber).AsDouble;
      except
        prix := 0;
      end;
      try
        remise := (elem.GetValue('rem') as TJSONNumber).AsDouble;
      except
        remise := 0;
      end;
      afficheResultatCalcul(nb, poids, unite, prix, remise);
    end;
end;

procedure TfrmMain.txtCopyrightLinkClick(Sender: TObject; Link: TDHBaseLink;
  var Handled: Boolean);
begin
  url_Open_In_Browser(Link.LinkRef.Text);
  Handled := true;
end;

procedure TfrmMain.vsbCalculsResize(Sender: TObject);
var
  i: integer;
  r: TRectangle;
begin
  if (vsbCalculs.Content.ChildrenCount > 0) then
    for i := 0 to vsbCalculs.Content.ChildrenCount - 1 do
      if (vsbCalculs.Content.Children[i] is TRectangle) then
      begin
        r := vsbCalculs.Content.Children[i] as TRectangle;
        r.Width := vsbCalculs.clientWidth - r.Margins.left -
          vsbCalculs.Padding.left - r.Margins.right - vsbCalculs.Padding.right;
      end;
end;

end.
