UNIT NetEven_Utils;

INTERFACE

USES
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls, InvokeRegistry, Rio, SOAPHTTPClient, Ucommon;

TYPE
  TFrm_NetEvenUtils = CLASS(TForm)
    Btn_: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Btn_soapit: TButton;
    Btn_Copy: TButton;
    Btn_UpperCase: TButton;
    HTTPRIO1: THTTPRIO;
    Btn_Send: TButton;
    PROCEDURE Btn_Click(Sender: TObject);
    PROCEDURE Btn_2Click(Sender: TObject);
    procedure Btn_CopyClick(Sender: TObject);
    procedure Btn_UpperCaseClick(Sender: TObject);
    procedure Btn_SendClick(Sender: TObject);
  PRIVATE
    { DÈclarations privÈes }
  PUBLIC
    { DÈclarations publiques }
  END;

VAR
  Frm_NetEvenUtils: TFrm_NetEvenUtils;

IMPLEMENTATION
{$R *.dfm}

USES NetEvenWS,
  XSBuiltIns,
  XMLCursor,
  StdXML_TLB,
  soapOperation;

PROCEDURE TFrm_NetEvenUtils.Btn_2Click(Sender: TObject);
BEGIN
//  soapit;
END;

PROCEDURE TFrm_NetEvenUtils.Btn_Click(Sender: TObject);
VAR
  aCdes: GetOrdersResponse;

  sService: TGestionNetEven;

//  array
//  tmpDT: TXSDateTime;

BEGIN
  sService := CreerNWSServer('http://ws.neteven.com/NWS', 'laurent@ekosport.fr', '2fsarl73', 'c:\');

  TRY
//    if sService.ServerIsHere then ShowMessage('Present');


//    ShowMessage(sService.TestConnection);

  aCDes := sService.GetCommandes(Now, Now - 15);
  

 //  Length(aCdes.GetOrdersResult);
   
//   ShowMessage(answer);




  FINALLY

    aCdes.Free;
  END;

  CloseNWSServer(sService);
END;

procedure TFrm_NetEvenUtils.Btn_CopyClick(Sender: TObject);
begin
  Edit2.Text := Copy(Edit1.Text, 1 , 2);
end;

procedure TFrm_NetEvenUtils.Btn_SendClick(Sender: TObject);
VAR
  sService: TGestionNetEven;

  Answer : string;
//  array
//  tmpDT: TXSDateTime;


BEGIN
  ForceDirectories('C:\Ginkoia\FluxWeb\TestNetEven');

  sService := CreerNWSServer('http://ws.neteven.com/NWS', 'laurent@ekosport.fr', '2fsarl73', 'C:\Ginkoia\FluxWeb\TestNetEven\');

  TRY
//    if sService.ServerIsHere then ShowMessage('Present');


//    ShowMessage(sService.TestConnection);

  Answer := sService.PostCommandes(448011, 1, EncodeDate(2009,11,27) + EncodeTime(14,23,23,0), 0, '');
// 2009-11-27T14:23:23Z  

 //  Length(aCdes.GetOrdersResult);
   
   ShowMessage(answer);




  FINALLY

  END;

  CloseNWSServer(sService);
end;

procedure TFrm_NetEvenUtils.Btn_UpperCaseClick(Sender: TObject);
begin
  Edit1.Text := 'MÈtropole È‡Í)';
//  Edit2.Text := EnleveAccentsCaseOfDoubles(Edit1.Text);
end;

END.

