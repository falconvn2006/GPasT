unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdUDPBase, IdUDPServer,
  IdSocketHandle,ComCtrls,StrUtils, ExtCtrls, IdIPWatch, Buttons,LGetAdapterInfo; //请务必增加IdSocketHandle，StrUtils

type
  TForm1 = class(TForm)
    IdUDPServer1: TIdUDPServer;
    Label5: TLabel;
    Label8: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    CheckBox1: TCheckBox;
    Label9: TLabel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Edit8: TEdit;
    ComboBox2: TComboBox;
    Button4: TButton;
    CheckBox2: TCheckBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ListView1: TListView;
    Button7: TButton;
    Button5: TButton;
    Button9: TButton;
    Button6: TButton;
    Button10: TButton;
    IdIPWatch1: TIdIPWatch;
    GroupBox2: TGroupBox;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Label13: TLabel;
    Memo1: TMemo;
    Button3: TButton;
    CheckBox3: TCheckBox;
    GroupBox3: TGroupBox;
    StaticText1: TStaticText;
    ListView2: TListView;
    Label2: TLabel;
    Edit1: TEdit;
    GroupBox4: TGroupBox;
    Button1: TButton;
    Edit2: TEdit;
    Label3: TLabel;
    Button2: TButton;
    ComboBox1: TComboBox;
    Label4: TLabel;
    GroupBox5: TGroupBox;
    Edit7: TEdit;
    Label14: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Edit9: TEdit;
    GroupBox6: TGroupBox;
    Button8: TButton;
    Button11: TButton;
    ListView3: TListView;
    Label15: TLabel;
    Edit10: TEdit;
    Button15: TButton;
    Label16: TLabel;
    Button17: TButton;
    Button18: TButton;
    Button16: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    GroupBox7: TGroupBox;
    Button22: TButton;
    CheckBox4: TCheckBox;
    Edit11: TEdit;
    Label17: TLabel;
    Edit12: TEdit;
    Button23: TButton;
    Button24: TButton;
    ComboBox3: TComboBox;
    Timer1: TTimer;
    GroupBox8: TGroupBox;
    Label18: TLabel;
    Edit13: TEdit;
    Button25: TButton;
    Label6: TLabel;
    Button26: TButton;
    ComboBox4: TComboBox;
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure FormShow(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7Exit(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    expensestr:string;

  end;

var
  Form1: TForm1;

implementation

uses Unit3, Unit2;

{$R *.dfm}

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

procedure TForm1.Button9Click(Sender: TObject);
var

  strls1:string;
  i:Integer;

begin
  Form3:=TForm3.Create(nil);
  Form3.ShowModal;
  if(Form3.ModalResult=mrOk) then
  begin
    //下传
    //启始机号2字节，结束机号2字节，目标电脑IP地址,
    strls1 := '005,'; //表示修改读卡器参数

    //子网掩码
    strls1 := strls1 + Form3.strsubnetmask1 + '.' + Form3.strsubnetmask2 + '.' + Form3.strsubnetmask3 + '.' + Form3.strsubnetmask4 + ',';

    //网关地址
    strls1 := strls1 + Form3.strgateip1 + '.' + Form3.strgateip2 + '.' + Form3.strgateip3 + '.' + Form3.strgateip4 + ',';

    //网关MAC
    strls1 := strls1 + Form3.strgatemac1 + '-' + Form3.strgatemac2 + '-' + Form3.strgatemac3 + '-' + Form3.strgatemac4 + '-' + Form3.strgatemac5 + '-' + Form3.strgatemac6+ ',';

    //对方地址
    strls1 := strls1 + Form3.strremoteip1 + '.' + Form3.strremoteip2 + '.' + Form3.strremoteip3 + '.' + Form3.strremoteip4 + ',';

    //远程电脑MAC
    strls1 := strls1 + Form3.strremotemac1 + '-' + Form3.strremotemac2 + '-' + Form3.strremotemac3 + '-' + Form3.strremotemac4 + '-' + Form3.strremotemac5 + '-' + Form3.strremotemac6+ ',';
    //MAC自动搜标志
    i := 0;
    if(Form3.isautogetremotemac1) then
    begin
      i := i + 1;
    end;

    if(Form3.isautogetgatemac1) then
    begin
      i := i + 2;
    end;
    strls1 := strls1 + IntToStr(i) + ',';

    //端口号
    strls1 := strls1 + Form3.strmyport + ',';

    //机器序列号
    strls1 := strls1 + '005-005::005-005';

    IdUDPServer1.Binding.SendTo('255.255.255.255',39192,strls1[1],Length(strls1)); //广播式发送

    ShowMessage('提示：已发送更改目标电脑IP地址信息至读卡器，请稍候搜寻所有读卡器以刷新最新参数！');
  end;

  Form3.Free;
end;


procedure TForm1.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  i:Integer;
  len:Integer;
  strls:string;
  strls1:string;
  serid:Cardinal;
  divmac:string;
  infstr:string;

  AStrings: TStringList;

  listls:TListItem;
  mytime:TDateTime;
  ismytimeok:Boolean;

  LongDateFormatbak:string;
  LongTimeFormatbak:string;
  DateSeparatorbak:Char;
  TimeSeparatorbak:Char;

  myipandportbuf:array[1..6] of Byte;

begin



  AData.Position:= 0;
  len:=AData.Size;
  if(len>269) then
  begin
    len := 269;
  end;


  if(len>0) then
  begin
    SetLength(strls,len);
    AData.Read(strls[1],len);


    //解析出字符串
    AStrings := TStringList.Create;
    ExtractStrings([','],[],Pchar(strls),AStrings);

    if AStrings.Count > 0 then
    begin
      if(AStrings.Strings[0] = '100') then
      begin//搜寻设备时回应
        if AStrings.Count >= 10  then
        begin
          //100,00009,192.168.1.218,255.255.255.0,192.168.1.1,192.168.1.3,39169，1234567890
          if(ListView1.Items.Count > 0) then
          begin
            for i := 0 to ListView1.Items.Count - 1 do
            begin
              strls := ListView1.Items[i].SubItems.Strings[7];
              if AStrings.Strings[9] = strls then
              begin //机器序列号是唯一的，如果已经存在先册掉
                ListView1.Items.Delete(i);
                Break;

              end;
            end;
          end;

          listls:=ListView1.Items.Add;


           //本机IP地址
          listls.Caption:=AStrings.Strings[1];

          //子网掩码
          listls.SubItems.Add(AStrings.Strings[2]);

          //网关
          listls.SubItems.Add(AStrings.Strings[3]);

          //网关MAC地址
          listls.SubItems.Add(AStrings.Strings[4]);

          //远程电脑IP地址
          listls.SubItems.Add(AStrings.Strings[5]);

         //远程电脑MAC地址
          listls.SubItems.Add(AStrings.Strings[6]);

          //MAC自动搜标志
          listls.SubItems.Add(AStrings.Strings[7]);

          //端口号
          listls.SubItems.Add(AStrings.Strings[8]);

          //机器序列号
          listls.SubItems.Add(AStrings.Strings[9]);
          divmac:='16-88-' ;
          infstr:=AStrings.Strings[9];
          serid:=StrToInt64(infstr);
          infstr:= IntToHex(serid,8);
          for i:=1 to 4 do
          begin
              divmac:=divmac+copy(infstr,(8-i*2+1),2);
              if i<>4 then
              begin
                  divmac:=divmac+'-';
              end;
          end;


          //接收时间
          listls.SubItems.Add('搜寻回应时间' + FormatDateTime('hh:nn:ss',Now));

          listls.SubItems.Add(divmac);

          if AStrings.Count > 10 then listls.SubItems.Add(AStrings.Strings[10]);

        end
        else
        begin
          //100,00009,192.168.1.218,255.255.255.0,192.168.1.1,192.168.1.3,39169，1234567890
          if(ListView1.Items.Count > 0) then
          begin
            for i := 0 to ListView1.Items.Count - 1 do
            begin
              strls := ListView1.Items[i].SubItems.Strings[7];
              if AStrings.Strings[9] = strls then
              begin //机器序列号是唯一的，如果已经存在先册掉
                ListView1.Items.Delete(i);
                Break;

              end;
            end;
          end;

          listls:=ListView1.Items.Add;


           //本机IP地址
          listls.Caption:=AStrings.Strings[1];

          //子网掩码
          listls.SubItems.Add(AStrings.Strings[2]);

          //网关
          listls.SubItems.Add(AStrings.Strings[3]);

          //网关MAC地址
          listls.SubItems.Add('');

          //远程电脑IP地址
          listls.SubItems.Add(AStrings.Strings[4]);

         //远程电脑MAC地址
          listls.SubItems.Add('');

          //MAC自动搜标志
          listls.SubItems.Add('');

          //端口号
          listls.SubItems.Add(AStrings.Strings[5]);

          //机器序列号
          listls.SubItems.Add(AStrings.Strings[6]);

          //接收时间
          listls.SubItems.Add('搜寻回应时间' + FormatDateTime('hh:nn:ss',Now));

        end;
      end  
      else if(AStrings.Strings[0] = '101') then
      begin//读卡器开机信息
        //101，00009,192.168.1.1，192.168.1.3，00002，2012-04-20 11:12:13
        if AStrings.Count >= 5  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号

          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,开机时间):'+ strls;



        end;

      end
      else if(AStrings.Strings[0] = '102') then
      begin//刷卡信息
        //102,00003,192.168.1.228,255.255.255.255,00000,3373293092
        Label6.Caption := IntToStr(StrToInt64(Label6.Caption) + 1);
        if AStrings.Count >= 6  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号

          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,卡号):'+ strls;

          

          //发送显示"此卡尚未开户"
          strls1 :='006,'+ AStrings.Strings[4] +',' + AStrings.Strings[5]+',{张三丰}\n余额1159此卡尚未开户\,余额信息不存在,10,4,3'; //4为长鸣一声

          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          ShowMessage(strls1);



        end;

      end
      else if(AStrings.Strings[0] = '103') then
      begin//输入消费额再刷卡
        //103，00009,192.168.1.1，192.168.1.3，00002，8888888888，5.50, 2012-04-20 11:12:13
        if AStrings.Count >= 8  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,卡号,消费额,时间):'+ strls;


          //strls1 :='006,' + AStrings.Strings[4] +',' + AStrings.Strings[5]+ ',此卡尚未开户\,余额信息{不}存在\n\n,10,1,15'; //4为长鸣一声


          strls1 :='008,' + AStrings.Strings[4] +',' + AStrings.Strings[5]+','+AStrings.Strings[6]+','+'王小明 {￥}1{2}.56元'+',10,2,1';//0x38
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

        end;
      end
      else if(AStrings.Strings[0] = '104') then
      begin//计次消费
        //103，00009,192.168.1.1，192.168.1.3，00002，8888888888，2012-04-20 11:12:13
        if AStrings.Count >= 7  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,卡号,消费额,时间):'+ strls;

          //strls1 :='006,' + AStrings.Strings[5]+',此卡尚未开户\,余额信息不存在,10,4,1'; //4为长鸣一声

          strls1 :='008,' + AStrings.Strings[4] +',' + AStrings.Strings[5]+','+'1,王小明 {扣一次}\n\n\n\n\n'+',10,2,1';//0x38
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

        end;
      end
      else if(AStrings.Strings[0] = '105') then
      begin//记帐记录
        //105，00009,192.168.1.1，192.168.1.3，00002，8888888888，5.50,2012-04-20 11:12:13,1,12345678,18
        if AStrings.Count >= 11  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          Memo1.Text := strls;

          listls:=ListView2.Items.Add;

          //读卡器IP地址
          listls.Caption:=AStrings.Strings[2];

          //机号
          listls.SubItems.Add(AStrings.Strings[4]);

          //卡号
          listls.SubItems.Add(AStrings.Strings[5]);

          //消费额
          listls.SubItems.Add(AStrings.Strings[6]);

          //消费时间
          listls.SubItems.Add(AStrings.Strings[7]);

          //状态
          listls.SubItems.Add(AStrings.Strings[8]);

          //总记录数
          listls.SubItems.Add(AStrings.Strings[10]);

          LongDateFormatbak := LongDateFormat;
          LongTimeFormatbak := LongTimeFormat;
          DateSeparatorbak := DateSeparator;
          TimeSeparatorbak := TimeSeparator;

          ismytimeok := True;
          try
            LongDateFormat := 'yyyy-MM-dd';
            LongTimeFormat := 'hh:mm:ss';
            DateSeparator := '-';
            TimeSeparator := ':';
            mytime:= StrToDateTime(AStrings.Strings[7]);
          except
            ismytimeok := False;
          end;

          LongDateFormat := LongDateFormatbak;
          LongTimeFormat := LongTimeFormatbak;
          DateSeparator := DateSeparatorbak;
          TimeSeparator := TimeSeparatorbak;

          if ismytimeok then
          begin
            //记帐信息已成功收到，发送清除记帐指令，清除设备上的这条记录，让其继续发送下一次记帐记录                                     //地址
            strls1 :='011,' + AStrings.Strings[4] +','  + AStrings.Strings[5]+','+AStrings.Strings[6]+','+AStrings.Strings[7]+','+AStrings.Strings[9];
            IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));
          end
          else
          begin//记录时间乱码，可以发命令过去清掉
                                              //地址
            strls1 :='011,' + AStrings.Strings[4] +','  + AStrings.Strings[5]+','+AStrings.Strings[6]+',9999-99-99 99:99:99,'+AStrings.Strings[9];
            IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          end;


        end;
      end
      else if(AStrings.Strings[0] = '106') then
      begin//键盘输入
        if AStrings.Count >= 6  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,键盘输入信息):'+ strls;


          strls1 :='009,' + Edit1.Text + ',' ;//1,20,0,1';  //0x2b
          strls1 := strls1 + Edit8.Text;
          strls1 := strls1 + ',20,';


          if(CheckBox2.Checked) then
          begin//可以同时发出声响
            strls1 := strls1 +IntToStr(ComboBox2.ItemIndex + 1) + ',' + IntToStr(ComboBox1.ItemIndex);//IntToStr(ComboBox1.ItemIndex);

          end
          else
          begin
            strls1 := strls1 + '0,0';
          end;

          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));



        end;
      end
      else if(AStrings.Strings[0] = '108') then
      begin//取餐信息
        if AStrings.Count >= 7  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));



          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,卡号,时间):'+ strls;

          //strls1 :='006,' + AStrings.Strings[4] +',' + AStrings.Strings[5]+ ',此卡尚未开户\,余额信息不存在,10,1,15'; //4为长鸣一声



          strls1 :='013,' + Edit1.Text + ',' ;//013表示取订餐成功
          strls1 := strls1 + '姓名：王小明\n卡号：1234567890\n{餐}名：白切鸡饭\n￥8.00 1份\n';
          strls1 := strls1 + ',20,';


          if(CheckBox2.Checked) then
          begin//可以同时发出声响
            strls1 := strls1 + '1,16';
          end
          else
          begin
            strls1 := strls1 + '0,0';
          end;


          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

        end;
      end
      else if(AStrings.Strings[0] = '109') then
      begin//响应电脑发送的显示信息
        if AStrings.Count >= 6  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));



          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,电脑指令):'+ strls;


          {
          strls1 :='013,' + Edit1.Text + ',' ;//013表示取订餐成功
          strls1 := strls1 + '姓名：王小明\n卡号：1234567890\n餐名：白切鸡饭\n￥8.00 1份';
          strls1 := strls1 + ',20,';


          if(CheckBox2.Checked) then
          begin//可以同时发出声响
            strls1 := strls1 + '1,16';
          end
          else
          begin
            strls1 := strls1 + '0,0';
          end;
          }


        end;
      end
      else if(AStrings.Strings[0] = '114') then
      begin//远程寻价
        if AStrings.Count >= 9  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));
          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,卡序列号,自定义卡号，卡上余额,时间):'+ strls;

          if RadioButton1.Checked then
          begin
            strls1 :='014,'+AStrings.Strings[4]+','+expensestr;

          end
          else
          begin
            strls1 :='006,' + AStrings.Strings[4] +',' + AStrings.Strings[5]+ ','+Edit9.Text+',10,1,15'; //4为长鸣一声

          end;

          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

        end;
      end

      else  if((AStrings.Strings[0] = '115') or (AStrings.Strings[0] = '116') or (AStrings.Strings[0] = '117') or (AStrings.Strings[0] = '118') or (AStrings.Strings[0] = '119') or (AStrings.Strings[0] = '120') or (AStrings.Strings[0] = '121')or (AStrings.Strings[0] = '130')) then
      begin
        if AStrings.Count >= 6  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));
          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,):'+ strls;
        end;
      end
      else if(AStrings.Strings[0] = '124') then
      begin//输入消费额再刷卡
        //103，00009,192.168.1.1，192.168.1.3，00002，8888888888，5.50, 2012-04-20 11:12:13
        if AStrings.Count >= 15  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));
          //                                                                                   6      7     8       9         10        11     12     13      14
          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,记录格式标识,卡号,流水号,交易额,交易后余额,交易时间,交易模式,餐次,是否跨日,未上传记录总数):'+ strls;

          listls:=ListView2.Items.Add;

          //读卡器IP地址
          listls.Caption:=AStrings.Strings[2];

          //机号
          listls.SubItems.Add(AStrings.Strings[4]);

          //卡号
          listls.SubItems.Add(AStrings.Strings[6]);

          //消费额
          listls.SubItems.Add(AStrings.Strings[8]);

          //消费时间
          listls.SubItems.Add(AStrings.Strings[10]);

          //状态
          listls.SubItems.Add(AStrings.Strings[11]);

          //总记录数
          listls.SubItems.Add(AStrings.Strings[14]);


          //卡充值流水号
          listls.SubItems.Add(AStrings.Strings[7]);

          //卡交易后余额
          listls.SubItems.Add(AStrings.Strings[9]);

          //餐次
          listls.SubItems.Add(AStrings.Strings[12]);

          //是否跨日
          listls.SubItems.Add(AStrings.Strings[13]);


          //向设备反馈接收成功信息，设备收到后将会清楚该记录，必须确定在保存记录成功后才能发此指令
          //024,            65535,                                           003,                      983039,                     65535,                       167772.15,                   167772.15,           2017-04-20 01:52:32,            003,                         003,                         003
          strls1 :='024,' + AStrings.Strings[4] + ',' + AStrings.Strings[5] + ',' + AStrings.Strings[6] + ',' + AStrings.Strings[7] + ',' + AStrings.Strings[8] + ',' + AStrings.Strings[9] + ',' + AStrings.Strings[10] + ',' + AStrings.Strings[11] + ',' + AStrings.Strings[12] + ',' + AStrings.Strings[13] + ',024-024::024-024'; //4为长鸣一声
          //strls1 := '024,65535,024-024::024-024,3,983039,00000,0.09,4.39,2017-11-22 00:49:02,0,3,1';

          //
          IdUDPServer1.Binding.SendTo(abinding.PeerIP,abinding.PeerPort,strls1[1],Length(strls1));

        end;
      end
      else if(AStrings.Strings[0] = '125') then
      begin//红外扫描枪扫码信息，直接搜到什么发什么
        //102,00003,192.168.1.228,255.255.255.255,00000,3373293092
        if AStrings.Count >= 7  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号

          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));

          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,读卡器机号,红外扫描枪格式标识,红外扫描枪信息):'+ strls;


        end;

      end
      else if(AStrings.Strings[0] = '140') then
      begin//远程寻价
        if AStrings.Count >= 5  then
        begin
          //先回应，以免读卡器重发3次
          strls1 :='001,' + AStrings.Strings[1];//AStrings.Strings[1]为读卡器UDP包序列号
          IdUDPServer1.Binding.SendTo(AStrings.Strings[2],39192,strls1[1],Length(strls1));
          Memo1.Text := '(命令,数据包序列,读卡器IP,接受数据的电脑的IP,状态,):'+ strls;

        end;
      end

    end;
    AStrings.Free;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

  Label10.Caption := IdIPWatch1.LocalIP;
  ListView1.Items.Clear;

  IdUDPServer1.DefaultPort:=39192;
  IdUDPServer1.BroadcastEnabled:=True;



  try
    IdUDPServer1.Active := True;
  except
    on EIdCouldNotBindSocket do
    begin

      showmessage('读卡器专用UDP协议端口[39192]已被其他程序占用，无法打开，程序将自行退出，请检查后重新打开软件！');
      Close();

    end;


  end;

  expensestr := Edit7.Text;

  ComboBox3.ItemIndex := 1;





end;

procedure TForm1.Button7Click(Sender: TObject);
var
  str:string;

begin
    str :='000';


    IdUDPServer1.Binding.SendTo('255.255.255.255',39192,str[1],3); //广播式发送
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  listls:TListItem;
  strls:string;
  strls1:string;
  AStrings: TStringList;
  i:Integer;

begin
  if ListView1.SelCount>0 then
  begin
    Form2:=TForm2.Create(nil);

    listls:=ListView1.Selected;

    AStrings := TStringList.Create;
    //消费机IP地址
    strls:=listls.Caption;
    ExtractStrings(['.'],[],Pchar(strls),AStrings);

    if AStrings.Count >= 4 then
    begin
      Form2.strmyip1:=AStrings.Strings[0];
      Form2.strmyip2:=AStrings.Strings[1];
      Form2.strmyip3:=AStrings.Strings[2];
      Form2.strmyip4:=AStrings.Strings[3];
    end;

    //子网掩码
    strls:=listls.SubItems.Strings[0];
    AStrings.Clear;
    ExtractStrings(['.'],[],Pchar(strls),AStrings);

    if AStrings.Count >= 4 then
    begin
      Form2.strsubnetmask1:=AStrings.Strings[0];
      Form2.strsubnetmask2:=AStrings.Strings[1];
      Form2.strsubnetmask3:=AStrings.Strings[2];
      Form2.strsubnetmask4:=AStrings.Strings[3];
    end;

    //网关
    strls:=listls.SubItems.Strings[1];
    AStrings.Clear;
    ExtractStrings(['.'],[],Pchar(strls),AStrings);

    if AStrings.Count >= 4 then
    begin
      Form2.strgateip1:=AStrings.Strings[0];
      Form2.strgateip2:=AStrings.Strings[1];
      Form2.strgateip3:=AStrings.Strings[2];
      Form2.strgateip4:=AStrings.Strings[3];
    end;

    //网关MAC
    strls:=listls.SubItems.Strings[2];
    AStrings.Clear;
    ExtractStrings(['-'],[],Pchar(strls),AStrings);

    if AStrings.Count >= 6 then
    begin
      Form2.strgatemac1:=AStrings.Strings[0];
      Form2.strgatemac2:=AStrings.Strings[1];
      Form2.strgatemac3:=AStrings.Strings[2];
      Form2.strgatemac4:=AStrings.Strings[3];
      Form2.strgatemac5:=AStrings.Strings[4];
      Form2.strgatemac6:=AStrings.Strings[5];

    end;

    //远程电脑
    strls:=listls.SubItems.Strings[3];
    AStrings.Clear;
    ExtractStrings(['.'],[],Pchar(strls),AStrings);

    if AStrings.Count >= 4 then
    begin
      Form2.strremoteip1:=AStrings.Strings[0];
      Form2.strremoteip2:=AStrings.Strings[1];
      Form2.strremoteip3:=AStrings.Strings[2];
      Form2.strremoteip4:=AStrings.Strings[3];
    end;

    //远程电脑MAC
    strls:=listls.SubItems.Strings[4];
    AStrings.Clear;
    ExtractStrings(['-'],[],Pchar(strls),AStrings);

    if AStrings.Count >= 6 then
    begin
      Form2.strremotemac1:=AStrings.Strings[0];
      Form2.strremotemac2:=AStrings.Strings[1];
      Form2.strremotemac3:=AStrings.Strings[2];
      Form2.strremotemac4:=AStrings.Strings[3];
      Form2.strremotemac5:=AStrings.Strings[4];
      Form2.strremotemac6:=AStrings.Strings[5];
    end;

    AStrings.Free;

    //MAC自动搜寻
    i := StrToInt(listls.SubItems.Strings[5]);
    Form2.isautogetgatemac1 := False;
    Form2.isautogetremotemac1 := False;
    if(i = 1) then
    begin
      Form2.isautogetremotemac1 := True;
      
    end
    else if(i = 2) then
    begin
      Form2.isautogetgatemac1 := True;
    end
    else if(i = 3) then
    begin
      Form2.isautogetgatemac1 := True;
      Form2.isautogetremotemac1 := True;
    end;


    //端口号
    Form2.strmyport:=listls.SubItems.Strings[6];

    //设备硬件号
    Form2.strmydevno:=listls.SubItems.Strings[7];

    Form2.ShowModal;
    if(Form2.ModalResult=mrOk) then
    begin

      strls1 := '004,'; //表示修改读卡器参数

      //IP地址
      strls1 := strls1 + Form2.strmyip1 + '.' + Form2.strmyip2 + '.' + Form2.strmyip3 + '.' + Form2.strmyip4 + ',';

      //子网掩码
      strls1 := strls1 + Form2.strsubnetmask1 + '.' + Form2.strsubnetmask2 + '.' + Form2.strsubnetmask3 + '.' + Form2.strsubnetmask4 + ',';

      //网关地址
      strls1 := strls1 + Form2.strgateip1 + '.' + Form2.strgateip2 + '.' + Form2.strgateip3 + '.' + Form2.strgateip4 + ',';

      //网关MAC
      strls1 := strls1 + Form2.strgatemac1 + '-' + Form2.strgatemac2 + '-' + Form2.strgatemac3 + '-' + Form2.strgatemac4 + '-' + Form2.strgatemac5 + '-' + Form2.strgatemac6+ ',';

      //远程电脑IP地址
      strls1 := strls1 + Form2.strremoteip1 + '.' + Form2.strremoteip2 + '.' + Form2.strremoteip3 + '.' + Form2.strremoteip4 + ',';

      //远程电脑MAC
      strls1 := strls1 + Form2.strremotemac1 + '-' + Form2.strremotemac2 + '-' + Form2.strremotemac3 + '-' + Form2.strremotemac4 + '-' + Form2.strremotemac5 + '-' + Form2.strremotemac6+ ',';
      //MAC自动搜标志
      i := 0;
      if(Form2.isautogetremotemac1) then
      begin
        i := i + 1;
      end;

      if(Form2.isautogetgatemac1) then
      begin
        i := i + 2;
      end;
      strls1 := strls1 + IntToStr(i) + ',';

      //端口号
      strls1 := strls1 + Form2.strmyport + ',';

      //机器序列号
      strls1 := strls1 + Form2.strmydevno;

      IdUDPServer1.Binding.SendTo('255.255.255.255',39192,strls1[1],Length(strls1)); //广播式发送

    end;

    Form2.Free;


  end
  else
  begin
    ShowMessage('请先选择需要更改的行');
  end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
  if ListView1.SelCount>0 then
  begin
    if(Application.MessageBox('是否删除有记录?', '警告', MB_YESNO +MB_ICONINFORMATION) = IDYES) then
    begin
      ListView1.DeleteSelected;

    end;

  end
  else
  begin
    ShowMessage('请先选择需要删除的行');
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  ListView1.Items.Clear;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  strls:string;
  strls1:string;
  i:Integer;
  pedit:TEdit;

begin

   for i := 3 to 6 do
   begin
      pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

    if not CheckBox1.Checked then
      begin
        strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
      end
    else
    begin
      strls := '255.255.255.255';
    end;

    if CheckBox3.Checked then
    begin //有文字需要显示

      strls1 :='009,' + Edit1.Text + ',' ;//1,20,0,1';  //0x2b
      strls1 := strls1 + Edit8.Text;
      strls1 := strls1 + ',20,';


      if(CheckBox2.Checked) then
      begin//可以同时发出声响
        strls1 := strls1 +IntToStr(ComboBox2.ItemIndex + 1) + ',' + IntToStr(ComboBox1.ItemIndex);//IntToStr(ComboBox1.ItemIndex);

      end
      else
      begin
        strls1 := strls1 + '0,0';
      end;

      IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));
    end
    else
    begin
      strls1 :='010,'  + Edit1.Text + ',';//1,20,0,1';  //0x2b

      if(CheckBox2.Checked) then
      begin//可以同时发出声响
        strls1 := strls1 +IntToStr(ComboBox2.ItemIndex + 1) + ',' + IntToStr(ComboBox1.ItemIndex + 2);
        IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));
      end;
    end;

end;

procedure TForm1.Button12Click(Sender: TObject);
var
    mydatetime:TDateTime;
begin
    mydatetime := Now;

    Edit19.Text := FormatDateTime('YY',mydatetime);
    Edit20.Text := FormatDateTime('MM',mydatetime);
    Edit21.Text := FormatDateTime('DD',mydatetime);
    Edit23.Text := FormatDateTime('hh',mydatetime);
    Edit24.Text := FormatDateTime('nn',mydatetime);
    Edit25.Text := FormatDateTime('ss',mydatetime);

end;

procedure TForm1.Button13Click(Sender: TObject);
var
  strls:string;
  i:Integer;
  pedit:TEdit;
  strls1:string;

begin
  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
  begin
    strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
  end
  else
  begin
    strls := '255.255.255.255';
  end;

  strls1 :='002,' + Edit1.Text ;


  IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));


end;

procedure TForm1.Button14Click(Sender: TObject);
var
  strls:string;
  strls1:string;

  i:Integer;
  pedit:TEdit;

begin
   for i := 3 to 6 do
   begin
      pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

    strls1 :='003,' + Edit1.Text + ',20' +  Edit19.Text + '-' + Edit20.Text + '-' + Edit21.Text + ' ' + Edit23.Text + ':' + Edit24.Text + ':' + Edit25.Text;

    if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
    else
    begin
      strls := '255.255.255.255';
    end;

    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Memo1.Text := '';  
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  strls:string;
  strls1:string;

begin

     if not CheckBox1.Checked then
      begin
        strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
      end
    else
    begin
      strls := '255.255.255.255';
    end;


    strls1 :='012,'  + Edit1.Text + ',' + Edit2.Text ;//1,20,0,1';  //0x2b

    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  str:string;

begin

  //str := '006,00000,3213582007,{张三丰\n余}额1159此卡尚未开户\,{余额信}息不存在,10,4,3';
  str := '024,65535,024-024::024-024,3,983039,00000,0.02,2.80,2017-11-24 22:13:20,0,3,0';
  IdUDPServer1.Binding.SendTo('192.168.1.228',39192,str[1],Length(str));
end;

procedure TForm1.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['0'..'9','.',#8] then
  begin


  end
  else
  begin
    Key := #0;
  end;

end;

procedure TForm1.Edit7Exit(Sender: TObject);

begin
  if Trim(Edit7.Text) = '' then
  begin
    ShowMessage('金额输入不能为空！');
    Edit7.SetFocus;
    Exit;

  end;
  try

    expensestr := Formatfloat('0.00',StrToFloat(Trim(Edit7.Text)));

    Edit7.Text := expensestr;

  except

  end;




end;

procedure TForm1.Button11Click(Sender: TObject);
var
  cardhao:Int64;
  cardhaols:Int64;

begin

  cardhao := StrToInt64(Edit10.Text);
  if ListView3.items.Count > 0 then
  begin
    cardhaols := StrToInt64(ListView3.items[ListView3.items.Count-1].Caption);

    if(cardhao > cardhaols) then
    begin


    end
    else
    begin
       ShowMessage('输入卡号必须大于前面的卡号!');
       Edit10.SelectAll;
       Edit10.SetFocus;
       Exit;

    end;

  end;

  if cardhao = 0 then
  begin
    ShowMessage('请输入大于0的卡号!');
    Exit;
  end
  else if(cardhao > 4294967295) then
  begin
    ShowMessage('请输入小于等于4294967295的卡号!');
    Exit;

  end;

  (ListView3.items.Add).Caption := Edit10.Text;

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  ListView3.Items.Clear;
end;

procedure TForm1.Button15Click(Sender: TObject);
var
  i:Integer;
  j:Integer;
  mycount:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin

  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;

  mycount := ListView3.items.Count;
  i := 0;

  strls1 := '015,' + Edit1.Text;

  while i< mycount do
  begin
    if (mycount - i) >= 8 then//一次最大只能传8个卡号
    begin
      strls1 := strls1 + ',' + ListView3.items[i].Caption + ',' + ListView3.items[i+1].Caption + ',' + ListView3.items[i+2].Caption + ',' + ListView3.items[i+3].Caption + ',' + ListView3.items[i+4].Caption + ',' + ListView3.items[i+5].Caption + ',' + ListView3.items[i+6].Caption + ',' + ListView3.items[i+7].Caption;

    end
    else
    begin
      for j := i to (mycount - 1) do
      begin
        strls1 := strls1 + ',' + ListView3.items[j].Caption;



      end;



    end;

    i := i + 8;

    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

  end;

end;

procedure TForm1.Button17Click(Sender: TObject);
var
  i:Integer;
  j:Integer;
  mycount:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin

  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;

  mycount := ListView3.items.Count;
  i := 0;

  strls1 := '016,' + Edit1.Text;

  while i< mycount do
  begin
    if (mycount - i) >= 8 then//一次最大只能传8个卡号
    begin
      strls1 := strls1 + ',' + ListView3.items[i].Caption + ',' + ListView3.items[i+1].Caption + ',' + ListView3.items[i+2].Caption + ',' + ListView3.items[i+3].Caption + ',' + ListView3.items[i+4].Caption + ',' + ListView3.items[i+5].Caption + ',' + ListView3.items[i+6].Caption + ',' + ListView3.items[i+7].Caption;

    end
    else
    begin
      for j := i to (mycount - 1) do
      begin
        strls1 := strls1 + ',' + ListView3.items[j].Caption;



      end;



    end;

    i := i + 8;

    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

  end;

end;

procedure TForm1.Button18Click(Sender: TObject);
var
  i:Integer;
  j:Integer;
  mycount:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin
  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;

  mycount := ListView3.items.Count;
  i := 0;

  strls1 := '017,' + Edit1.Text;

  while i< mycount do
  begin
    if (mycount - i) >= 8 then//一次最大只能传8个卡号
    begin
      strls1 := strls1 + ',' + ListView3.items[i].Caption + ',' + ListView3.items[i+1].Caption + ',' + ListView3.items[i+2].Caption + ',' + ListView3.items[i+3].Caption + ',' + ListView3.items[i+4].Caption + ',' + ListView3.items[i+5].Caption + ',' + ListView3.items[i+6].Caption + ',' + ListView3.items[i+7].Caption;

    end
    else
    begin
      for j := i to (mycount - 1) do
      begin
        strls1 := strls1 + ',' + ListView3.items[j].Caption;



      end;



    end;

    i := i + 8;

    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

  end;

end;

procedure TForm1.Button16Click(Sender: TObject);
var
  i:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin

  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;


  strls1 := '018,' + Edit1.Text + ',018-018::018-018';   //018,00000,

  IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

end;

procedure TForm1.Button19Click(Sender: TObject);
var
  i:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin

  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;


  strls1 := '019,' + Edit1.Text + ',019-019::019-019';   //018,00000,

  IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

end;

procedure TForm1.Button21Click(Sender: TObject);
var
  i:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin

  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;


  strls1 := '020,' + Edit1.Text + ',' + Edit10.Text;   //018,00000,

  IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

end;

procedure TForm1.Button20Click(Sender: TObject);
var
  i:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin

  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;


  strls1 := '021,' + Edit1.Text;   //018,00000,

  IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

end;

procedure TForm1.Button22Click(Sender: TObject);
var
  i:Integer;
  strls:string;
  strls1:string;
  pedit:TEdit;

begin

  for i := 3 to 6 do
  begin
    pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

  if not CheckBox1.Checked then
    begin
      strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
    end
  else
  begin
    strls := '255.255.255.255';
  end;

  strls1 := '022,' + Edit1.Text +',';

  if (CheckBox4.Checked) then
  begin//屏蔽密码输入
    strls1 := strls1 + '1,' + Edit11.Text + ',10,2,0' ;
  end
  else
  begin
    strls1 := strls1 + '0,' + Edit11.Text + ',10,2,0' ;

  end;

  IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));
end;

procedure TForm1.Button23Click(Sender: TObject);
var
  strls:string;
  strls1:string;
  i:Integer;
  pedit:TEdit;
begin
   for i := 3 to 6 do
   begin
      pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

    if not CheckBox1.Checked then
      begin
        strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
      end
    else
    begin
      strls := '255.255.255.255';
    end;

    strls1 :='030,' + Edit1.Text + ',030-030::030-030,' ;//030,机号, 030-030::030-030,

    strls1 := strls1 + IntToStr(ComboBox3.ItemIndex)+ ',1,' + Edit12.Text; //继电器编号,开，时长

    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));





end;

procedure TForm1.Button24Click(Sender: TObject);
var
  strls:string;
  strls1:string;
  i:Integer;
  pedit:TEdit;
begin
   for i := 3 to 6 do
   begin
      pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

    if not CheckBox1.Checked then
      begin
        strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
      end
    else
    begin
      strls := '255.255.255.255';
    end;

    strls1 :='030,' + Edit1.Text + ',030-030::030-030,' ;//030,机号, 030-030::030-030,

    strls1 := strls1 + IntToStr(ComboBox3.ItemIndex)+ ',0,' + Edit12.Text; //继电器编号,开，时长

    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  str:string;
  sendbuf:array[0..60000] of Byte;
  i:Integer;



begin
    str :='000';
    for i := 0 to 60000  do
    begin
         sendbuf[i] := Random(255);

    end;

    IdUDPServer1.Binding.SendTo('255.255.255.255',39192,sendbuf,30000); //广播式发送
end;




procedure TForm1.Button25Click(Sender: TObject);
  var
  strls:string;
  strls1:string;
  i:Integer;
  pedit:TEdit;

begin

   for i := 3 to 6 do
   begin
      pedit := TEdit(FindComponent('Edit' + IntToStr(i)));
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

    if not CheckBox1.Checked then
      begin
        strls := Edit3.Text + '.' + Edit4.Text + '.' + Edit5.Text + '.' + Edit6.Text;
      end
    else
    begin
      strls := '255.255.255.255';
    end;


    strls1 :='040,' + Edit1.Text + ',' ;
    strls1 := strls1 + Edit13.Text;
    IdUDPServer1.Binding.SendTo(strls,39192,strls1[1],Length(strls1));



end;


procedure TForm1.Button26Click(Sender: TObject);
begin
  ListView2.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  aa:TList;
  i :Integer;

begin
  try
    begin
      aa :=GetAdapterInfo;
      for i := 0 to aa.Count - 1 do
      begin
               ComboBox4.Items.Add(TAdapterInfo(aa.Items[i]).IPAddress);
      end;
      ComboBox4.ItemIndex:= aa.Count - 1;
    end;
    except
     begin
        showmessage('本计算机网卡异常，消费机专用UDP协议端口[39192]已被其他程序占用，无法与设备正常连接，请检查后重启软件！');
        Close ;
     end;
    end;

end;

procedure TForm1.ComboBox4Change(Sender: TObject);
begin
  try
    begin
      IdUDPServer1.Active :=False ;
      IdUDPServer1.BroadcastEnabled:=False;
      IdUDPServer1.Bindings.Clear;
      IdUDPServer1.Bindings.Add;
      IdUDPServer1.Bindings[0].IP := ComboBox4.Text ; //本地IP
      IdUDPServer1.Bindings[0].Port := 39192; //本地IP
      IdUDPServer1.BroadcastEnabled:=true;
      IdUDPServer1.Active := true; //激活IdUDPServer 控件
     end;
   except

  end;
end;

end.


