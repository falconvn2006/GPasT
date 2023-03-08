unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  //Dialogs, StdCtrls, ExtCtrls, IdBaseComponent, IdComponent, IdIPWatch,StrUtils;
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdIPWatch,StrUtils,WinSock,nb30;

const
  MAX_ADAPTER_NAME_LENGTH        = 256;
  MAX_ADAPTER_DESCRIPTION_LENGTH = 128;
  MAX_ADAPTER_ADDRESS_LENGTH     = 8;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    IdIPWatch1: TIdIPWatch;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label26: TLabel;
    EditIp9: TEdit;
    EditIp10: TEdit;
    EditIp11: TEdit;
    EditIp12: TEdit;
    Button4: TButton;
    EditMac1: TEdit;
    EditMac2: TEdit;
    EditMac3: TEdit;
    EditMac4: TEdit;
    Button5: TButton;
    EditMac5: TEdit;
    EditMac6: TEdit;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Button7: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    EditIp14: TEdit;
    EditIp15: TEdit;
    EditIp16: TEdit;
    EditMac7: TEdit;
    EditMac8: TEdit;
    EditMac9: TEdit;
    EditMac10: TEdit;
    Button6: TButton;
    EditMac11: TEdit;
    EditMac12: TEdit;
    EditIp13: TEdit;
    Button8: TButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Label5: TLabel;
    Edit14: TEdit;
    EditIp5: TEdit;
    EditIp6: TEdit;
    EditIp7: TEdit;
    EditIp8: TEdit;
    Label3: TLabel;
  procedure Button1Click(Sender: TObject);
  procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }

  public

    //子网掩码
    strsubnetmask1:string;
    strsubnetmask2:string;
    strsubnetmask3:string;
    strsubnetmask4:string;

    //网关地址
    strgateip1:string;
    strgateip2:string;
    strgateip3:string;
    strgateip4:string;

    //网关MAC
    isautogetgatemac1:Boolean;
    strgatemac1:string;
    strgatemac2:string;
    strgatemac3:string;
    strgatemac4:string;
    strgatemac5:string;
    strgatemac6:string;

    //远程电脑地址
    strremoteip1:string;
    strremoteip2:string;
    strremoteip3:string;
    strremoteip4:string;

    //远程电脑MAC
    isautogetremotemac1:Boolean;
    strremotemac1:string;
    strremotemac2:string;
    strremotemac3:string;
    strremotemac4:string;
    strremotemac5:string;
    strremotemac6:string;

    //自动搜MAC的标志
    strautomac:string;

    //端口
    strmyport:string;


    { Public declarations }
  end;

  TIPAddressString = Array[0..4*4-1] of Char;
  PIPAddrString = ^TIPAddrString;
    TIPAddrString = Record
    Next      : PIPAddrString;
    IPAddress : TIPAddressString;
    IPMask    : TIPAddressString;
    Context   : Integer;
  End;

  PIPAdapterInfo = ^TIPAdapterInfo;

  TIPAdapterInfo = Record { IP_ADAPTER_INFO }
      Next                : PIPAdapterInfo;
      ComboIndex          : Integer;
      AdapterName         : Array[0..MAX_ADAPTER_NAME_LENGTH+3] of Char;
      Description         : Array[0..MAX_ADAPTER_DESCRIPTION_LENGTH+3] of Char;
      AddressLength       : Integer;
      Address             : Array[1..MAX_ADAPTER_ADDRESS_LENGTH] of Byte;
      Index               : Integer;
      _Type               : Integer;
      DHCPEnabled         : Integer;
      CurrentIPAddress    : PIPAddrString;
      IPAddressList       : TIPAddrString;
      GatewayList         : TIPAddrString;
      DHCPServer          : TIPAddrString;
      HaveWINS            : Bool;
      PrimaryWINSServer   : TIPAddrString;
      SecondaryWINSServer : TIPAddrString;
      LeaseObtained       : Integer;
      LeaseExpires        : Integer;
  End;

var
  Form3: TForm3;

implementation

//获取MAC函数
Function sendarp(ipaddr:ulong; temp:dword; ulmacaddr:pointer; ulmacaddrleng:pointer) : DWord; StdCall; External 'Iphlpapi.dll' Name 'SendARP';

Function GetAdaptersInfo(AI : PIPAdapterInfo; Var BufLen : Integer) : Integer; StdCall; External 'iphlpapi.dll' Name 'GetAdaptersInfo';



function isrightint(textls:string):boolean;stdcall;
begin
       try
          if(strtoint(textls) =0) then
          begin
          end;
          result := True;

       except
          result := False;
          exit;
       end;


end;

function isrighthex(textls:string):boolean;stdcall;
begin
       try
          if(strtoint('$' + textls) =0) then
          begin
          end;
          result := True;

       except
          result := False;
          exit;
       end;


end;

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  i:Integer;
  strls:string;
  pedit:TEdit;

begin
   //IP地址
   for i := 5 to 16 do
   begin
      pedit := TEdit(FindComponent('EditIp' + IntToStr(i)));
      strls := pedit.Text;
      if Trim(strls) = '' then
      begin
       ShowMessage('输入不能为空');
       pedit.Text:='';
       pedit.SetFocus;
       Exit;
      end;

       if not isrightint(strls) then
       begin
         ShowMessage('输入必须为数字');
         pedit.SelectAll;
         pedit.SetFocus;
         Exit;

       end;

       if StrToInt(strls)>255 then
       begin
         ShowMessage('输入不能大于255');
         pedit.SelectAll;
         pedit.SetFocus;
         Exit;

       end;

   end;

   //MAC地址
   if RadioButton6.Checked  then
   begin
     for i := 1 to 6 do
     begin
        pedit := TEdit(FindComponent('EditMac' + IntToStr(i)));
        strls := pedit.Text;
        if Trim(strls) = '' then
        begin
         ShowMessage('输入不能为空');
         pedit.Text:='';
         pedit.SetFocus;
         Exit;
        end;

         if not isrighthex(strls) then
         begin
           ShowMessage('输入必须为十六进制字母或数字');
           pedit.SelectAll;
           pedit.SetFocus;
           Exit;

         end;

     end;
   end;

   if RadioButton4.Checked  then
   begin
     for i := 7 to 12 do
     begin
        pedit := TEdit(FindComponent('EditMac' + IntToStr(i)));
        strls := pedit.Text;
        if Trim(strls) = '' then
        begin
         ShowMessage('输入不能为空');
         pedit.Text:='';
         pedit.SetFocus;
         Exit;
        end;

         if not isrighthex(strls) then
         begin
           ShowMessage('输入必须为十六进制字母或数字');
           pedit.SelectAll;
           pedit.SetFocus;
           Exit;

         end;

     end;
   end;

   strsubnetmask1 := EditIp5.Text;
   strsubnetmask2 := EditIp6.Text;
   strsubnetmask3 := EditIp7.Text;
   strsubnetmask4 := EditIp8.Text;

   strremoteip1 := EditIp9.Text;
   strremoteip2 := EditIp10.Text;
   strremoteip3 := EditIp11.Text;
   strremoteip4 := EditIp12.Text;

   strgateip1 := EditIp13.Text;
   strgateip2 := EditIp14.Text;
   strgateip3 := EditIp15.Text;
   strgateip4 := EditIp16.Text;

   if RadioButton6.Checked  then
   begin
    isautogetremotemac1 := False;
    strremotemac1:=Trim(EditMac1.Text);
    strremotemac2:=Trim(EditMac2.Text);
    strremotemac3:=Trim(EditMac3.Text);
    strremotemac4:=Trim(EditMac4.Text);
    strremotemac5:=Trim(EditMac5.Text);
    strremotemac6:=Trim(EditMac6.Text);
   end
   else
   begin
    isautogetremotemac1 := True;
    strremotemac1:='ff';
    strremotemac2:='ff';
    strremotemac3:='ff';
    strremotemac4:='ff';
    strremotemac5:='ff';
    strremotemac6:='ff';
   end;

   if RadioButton4.Checked  then
   begin
    isautogetgatemac1 := False;
    strgatemac1:=Trim(EditMac7.Text);
    strgatemac2:=Trim(EditMac8.Text);
    strgatemac3:=Trim(EditMac9.Text);
    strgatemac4:=Trim(EditMac10.Text);
    strgatemac5:=Trim(EditMac11.Text);
    strgatemac6:=Trim(EditMac12.Text);
   end
   else
   begin
    isautogetgatemac1 := True;
    strgatemac1:='ff';
    strgatemac2:='ff';
    strgatemac3:='ff';
    strgatemac4:='ff';
    strgatemac5:='ff';
    strgatemac6:='ff';
   end;

   if(RadioButton5.Checked) then
   begin
      isautogetremotemac1 := True;
   end
   else
   begin
      isautogetremotemac1 := False;
   end;

   if(RadioButton3.Checked) then
   begin
      isautogetgatemac1 := True;
   end
   else
   begin
      isautogetgatemac1 := False;
   end;

   strmyport := Edit14.Text;

   ModalResult:=mrOk;
end;

procedure TForm3.Button4Click(Sender: TObject);
var
  strls:string;
  i:Integer;

begin
  strls:=IdIPWatch1.LocalIP;
  i := Pos('.',strls);
  EditIp9.Text := LeftStr(strls,i-1);
  strls := RightStr(strls,Length(strls)-i);
  i := Pos('.',strls);
  EditIp10.Text := LeftStr(strls,i-1);

  strls := RightStr(strls,Length(strls)-i);
  i := Pos('.',strls);
  EditIp11.Text := LeftStr(strls,i-1);

  EditIp12.Text := RightStr(strls,Length(strls)-i);

end;

procedure TForm3.Button7Click(Sender: TObject);
begin
  EditIp9.Text := '255';
  EditIp10.Text := '255';
  EditIp11.Text := '255';
  EditIp12.Text := '255';

  EditMac1.Text := 'FF';
  EditMac2.Text := 'FF';
  EditMac3.Text := 'FF';
  EditMac4.Text := 'FF';
  EditMac5.Text := 'FF';
  EditMac6.Text := 'FF';
end;
procedure TForm3.Button5Click(Sender: TObject);
  var

  ADAPTER : TADAPTERSTATUS; //取网卡状态
  LANAENUM : TLANAENUM; // Netbios lana
  cRC : Char; //返回值
  NCB:TNCB; //NetBios控制块

begin
  Try
  (*===========获取 IP和主机名称  START ==============*)
  //初始化WS2_32.DLL


    NCB.ncb_command:=Chr(NCBENUM);


    NCB.ncb_buffer := @LANAENUM;
    NCB.ncb_length := SizeOf(LANAENUM);
    cRC := NetBios(@NCB);


    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBRESET);
    NCB.ncb_lana_num := LANAENUM.lana[0];
    cRC := NetBios(@NCB);


    ZeroMemory(@NCB, SizeOf(NCB));
    NCB.ncb_command := Chr(NCBASTAT);
    NCB.ncb_lana_num := LANAENUM.lana[0];
    StrPCopy(NCB.ncb_callname, '*');
    NCB.ncb_buffer := @ADAPTER;
    NCB.ncb_length := SizeOf(ADAPTER);
    cRC := NetBios(@NCB);

    Editmac1.Text := InttoHex(Integer(ADAPTER.adapter_address[0]),2);
    Editmac2.Text := InttoHex(Integer(ADAPTER.adapter_address[1]),2);
    Editmac3.Text := InttoHex(Integer(ADAPTER.adapter_address[2]),2);
    Editmac4.Text := InttoHex(Integer(ADAPTER.adapter_address[3]),2);
    Editmac5.Text := InttoHex(Integer(ADAPTER.adapter_address[4]),2);
    Editmac6.Text := InttoHex(Integer(ADAPTER.adapter_address[5]),2);

  Finally
  End;




end;

procedure TForm3.Button6Click(Sender: TObject);
var
  Aip: ulong;
  Amac: array[0..5] of byte;
  Amaclength: ulong;
  Ai: dword;
  i:Integer;
  strls:string;
  pedit:TEdit;
begin

  for i := 13 to 16 do
  begin
    pedit := TEdit(FindComponent('EditIp' + IntToStr(i)));
    strls := pedit.Text;
    if Trim(strls) = '' then
    begin
     ShowMessage('网关IP地址输入不能为空');
     pedit.Text:='';
     pedit.SetFocus;
     Exit;
    end;

    if not isrightint(strls) then
    begin
     ShowMessage('网关IP地址输入必须为数字');
     pedit.SelectAll;
     pedit.SetFocus;
     Exit;

    end;

    if StrToInt(strls)>255 then
    begin
     ShowMessage('网关IP地址输入不能大于255');
     pedit.SelectAll;
     pedit.SetFocus;
     Exit;

    end;

  end;

  Aip := inet_addr(PAnsiChar(AnsiString(EditIp13.Text + '.' + EditIp14.Text + '.' + EditIp15.Text + '.' + EditIp16.Text)));
  Amaclength := length(Amac);
  Ai := sendarp(Aip,0,@Amac,@Amaclength);
  if Ai = NO_ERROR then
  begin
    Editmac7.Text := IntToHex(Amac[0],2);
    Editmac8.Text := IntToHex(Amac[1],2);
    Editmac9.Text := IntToHex(Amac[2],2);
    Editmac10.Text := IntToHex(Amac[3],2);
    Editmac11.Text := IntToHex(Amac[4],2);
    Editmac12.Text := IntToHex(Amac[5],2);

  end
  else
  begin
      ShowMessage('该主机不在线！');
  end;
end;

procedure TForm3.Button8Click(Sender: TObject);
var
  AI,Work : PIPAdapterInfo;
  Size    : Integer;
  Res     : Integer;
  i     : Integer;
  strls:string;
  j     :Integer;

begin


  Size := 5120;
  GetMem(AI,Size);
  work:=AI;
  Res := GetAdaptersInfo(AI,Size);
  If (Res = ERROR_SUCCESS) Then Begin
    //网卡地址：
    //('Adapter address: '+MACToStr(@Work^.Address,Work^.AddressLength));

    j := 1;
    repeat
    //本机IP地址：
      //'IP addresses: '+GetAddrString(@Work^.IPAddressList));
      //网关地址：
      strls:=work^.GatewayList.IPAddress;
      ShowMessage('电脑查找到的第' + IntToStr(j) + '个网关IP：' + strls);

      work:=work^.Next ;
      j := j + 1;

    until (work=nil);
  End;
end;

end.
