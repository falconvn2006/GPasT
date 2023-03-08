unit uDm;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList;

type
  Tdm = class(TDataModule)
    Images: TImageList;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
