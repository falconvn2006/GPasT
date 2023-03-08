{*******************************************************************************
  作者: dmzn@163.com 2023-03-02
  描述: 数据模块
*******************************************************************************}
unit UDataModule;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, Vcl.ImgList, Vcl.Controls,
  cxImageList, cxGraphics;

type
  TFDM = class(TDataModule)
    ImgSmall: TcxImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDM: TFDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
