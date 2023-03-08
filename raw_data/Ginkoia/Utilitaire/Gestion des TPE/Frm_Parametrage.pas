unit Frm_Parametrage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UCommun, ShellAPI, ExtCtrls;


type
  TParametrage_Frm = class(TForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ENumPort: TEdit;
    CVitesse: TComboBox;
    CBits: TComboBox;
    CParite: TComboBox;
    CArret: TComboBox;
    Nbt_Ok: TBitBtn;
    Nbt_Cancel: TBitBtn;
    Cport: TComboBox;
    cb_autodetect: TCheckBox;
    edtSearchTPENAME: TEdit;
    BDeviceManager: TBitBtn;
    Label1: TLabel;
    cb_log: TCheckBox;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    Bevel2: TBevel;
    procedure ENumPortKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Nbt_OkClick(Sender: TObject);
    procedure CportChange(Sender: TObject);
    procedure BDeviceManagerClick(Sender: TObject);
    procedure cb_autodetectClick(Sender: TObject);
    procedure cb_TestPresenceSimpleClick(Sender: TObject);
    procedure cb_logClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure WMDeviceChange(var M:TMessage); message WM_DEVICECHANGE;
    procedure Auto_Detection;
    procedure ParamEcran;
  public
    { Déclarations publiques }
  end;

var
  Parametrage_Frm: TParametrage_Frm;

implementation

uses
  uCsteTPE, uResTPE;

{$R *.dfm}

procedure TParametrage_Frm.BDeviceManagerClick(Sender: TObject);
begin
     ShellExecute(Handle,'Open','mmc',PChar(' devmgmt.msc'),Nil,SW_SHOWDEFAULT);
end;

procedure TParametrage_Frm.BitBtn1Click(Sender: TObject);
begin
     CVitesse.ItemIndex:=3;
     cBits.ItemIndex:=2;
     cParite.ItemIndex:=0;
     cArret.ItemIndex:=0;
end;

procedure TParametrage_Frm.cb_autodetectClick(Sender: TObject);
begin
     ParamEcran;
end;

procedure TParametrage_Frm.cb_logClick(Sender: TObject);
begin
     ParamEcran;
end;

procedure TParametrage_Frm.cb_TestPresenceSimpleClick(Sender: TObject);
begin
    ParamEcran;
end;

procedure TParametrage_Frm.ParamEcran;
begin
     edtSearchTPENAME.Visible := cb_autodetect.checked;
end;


procedure TParametrage_Frm.CportChange(Sender: TObject);
var sTmp:string;
    iPos1:integer;
    iPos2:integer;
begin
  sTmp:=CPort.Items[CPort.ItemIndex];
  iPos1:=AnsiPos('(COM',sTmp);
  iPos2:=AnsiPos(')',sTmp);
  If iPos1>0
    then
        begin
             sTmp:=Copy(sTmp,iPos1+4,iPos2-iPos1-4);
             ENumPort.Text:=sTmp;
        End;
end;

procedure TParametrage_Frm.WMDeviceChange(var M:TMessage);
const
  DBT_DEVNODES_CHANGED = $0007;      // Changement sur les USB
begin
  inherited;
  case M.wParam of
    DBT_DEVNODES_CHANGED:
        begin
             // EnregistreTrace('Event PnP : $0007 : Détection USB');
             // Auto_Detection;
        end;
  end;
end;

procedure TParametrage_Frm.Auto_Detection;
var s1:TStringList;
    i:integer;
    TPE_port:string;
    bfind:Boolean;
begin
    TPE_port:=Auto_Detect_TPE(edtSearchTPENAME.Text);
    CPort.Items.BeginUpdate;
    s1:=Get_Serial_Ports;
      try
         CPort.Items.Assign(s1);
      finally
         s1.Free;
      end;
  For i:=0 to CPort.Items.Count-1 do
      begin
          If Pos(Format('(COM%d)',[iNumPort]),CPort.Items[i])>=1 then
             begin
                 CPort.ItemIndex:=i;
             end;
      end;
  //-------
  If (cb_autodetect.Checked)
      then
          begin
               bfind:=false;
               for i := 0 to s1.Count-1 do
                   begin
                        if AnsiPos(Format('(%s)',[TPE_port]),s1.Strings[i])>1 then
                            begin
                                 // théoriquement c'est le bon n° de port
                                 iNumPort := StrToIntDef(Copy(TPE_port,4,length(TPE_port)),0);
                                 bfind:=True;
                            end;
                   end;
               ENumPort.Text:=inttostr(iNumPort);
          end;
    CPort.Items.EndUpdate;
end;

procedure TParametrage_Frm.ENumPortKeyPress(Sender: TObject; var Key: Char);
begin
  if (Ord(Key)>=32) and not(CharInSet(Key, ['0'..'9'])) then
    Key:=chr(7);
end;

procedure TParametrage_Frm.FormCreate(Sender: TObject);
var i:Integer;
    s1:TStringList;
begin
  if (iNumPort<=0) or (iNumPort>99) then
    iNumPort:=1;
  cb_log.Checked:=bOkTrace;
  ENumPort.Text:=inttostr(iNumPort);
  cb_autodetect.Checked:=bautoDetect;
  edtSearchTPENAME.Text:=sSearchTPEName;
//  cb_TestPresenceSimple.Checked:=bTestPresenceSimple;

  Auto_Detection;
//  s1:=Get_Serial_Ports;
//  try
//     CPort.Items.Assign(s1);
//  finally
//     s1.Free;
//  end;




//  For i:=0 to CPort.Items.Count-1 do
//      begin
//          If Pos(Format('(COM%d)',[iNumPort]),CPort.Items[i])>=1 then
//             begin
//                 CPort.ItemIndex:=i;
//             end;
//      end;
  //-------------------------------------------

  case iVitesse of
    vBaudRate110    : CVitesse.ItemIndex := 0;
    vBaudRate300    : CVitesse.ItemIndex := 1;
    vBaudRate600    : CVitesse.ItemIndex := 2;
    vBaudRate1200   : CVitesse.ItemIndex := 3;
    vBaudRate2400   : CVitesse.ItemIndex := 4;
    vBaudRate4800   : CVitesse.ItemIndex := 5;
    vBaudRate9600   : CVitesse.ItemIndex := 6;
    vBaudRate14400  : CVitesse.ItemIndex := 7;
    vBaudRate19200  : CVitesse.ItemIndex := 8;
    vBaudRate38400  : CVitesse.ItemIndex := 9;
    vBaudRate56000  : CVitesse.ItemIndex := 10;
    vBaudRate57600  : CVitesse.ItemIndex := 11;
    vBaudRate115200 : CVitesse.ItemIndex := 12;
    vBaudRate128000 : CVitesse.ItemIndex := 13;
    vBaudRate256000 : CVitesse.ItemIndex := 14;
  else
    CVitesse.ItemIndex := 3;
  end;
     
  case iBits of
    vBits5: CBits.ItemIndex := 0;
    vBits6: CBits.ItemIndex := 1;
    vBits7: CBits.ItemIndex := 2;
    vBits8: CBits.ItemIndex := 3;
  else
    CBits.ItemIndex := 1;
  end;

  case iParite of
    vParitePaire   : CParite.ItemIndex := 0;
    vPariteImpaire : CParite.ItemIndex := 1;
    vPariteAucune  : CParite.ItemIndex := 2;
    vPariteMarque  : CParite.ItemIndex := 3;
    vPariteEspace  : CParite.ItemIndex := 4;
  else
    CParite.ItemIndex:=0
  end;

  case iArret of
    vArretOneStop  : CArret.ItemIndex := 0;
    vArretOne5Stop : CArret.ItemIndex := 1;
    vArretTwoStop  : CArret.ItemIndex := 2;
  else
    CArret.ItemIndex:=0;
  end;
  ParamEcran;
end;

procedure TParametrage_Frm.Nbt_OkClick(Sender: TObject);
var
  TstNumPort: integer;
{  sTmp:string;
  iPos1:integer;
  iPos2:integer;
}
begin
     if (cb_autodetect.Checked) and (edtSearchTPENAME.Text='') then
      begin
            MessageDlg(ERR_ChaineVide, mterror, [mbok], 0);
            ModalResult := mrnone;
            edtSearchTPENAME.SetFocus;
            exit;
      end;
{  sTmp:=CPort.Items[CPort.ItemIndex];
  iPos1:=AnsiPos('(COM',sTmp);
  iPos2:=AnsiPos(')',sTmp);
  If iPos1>0
    then
        begin
             sTmp:=Copy(sTmp,iPos1+4,iPos2-iPos1);
             MessageDlg(sTmp, mtWarning, [mbOK], 0);
        End;
  }
  TstNumPort:=StrToIntDef(ENumPort.Text,0);
  if (TstNumPort<=0) or (TstNumPort>99) then
  begin
    MessageDlg(ERR_NumeroPortInvalide, mterror, [mbok], 0);
    ModalResult := mrnone;
    ENumPort.SetFocus;
    ENumPort.SelectAll;
    exit;
  end;
  iNumPort := TstNumPort;
//  bTestPresenceSimple := cb_TestPresenceSimple.Checked;
  bautoDetect:=cb_autodetect.Checked;
  sSearchTPEName:=edtSearchTPENAME.Text;
  bOkTrace:=cb_log.Checked;

  case CVitesse.ItemIndex of
    0:  iVitesse := vBaudRate110;
    1:  iVitesse := vBaudRate300;
    2:  iVitesse := vBaudRate600;
    3:  iVitesse := vBaudRate1200;
    4:  iVitesse := vBaudRate2400;
    5:  iVitesse := vBaudRate4800;
    6:  iVitesse := vBaudRate9600;
    7:  iVitesse := vBaudRate14400;
    8:  iVitesse := vBaudRate19200;
    9:  iVitesse := vBaudRate38400;
    10: iVitesse := vBaudRate56000;
    11: iVitesse := vBaudRate57600;
    12: iVitesse := vBaudRate115200;
    13: iVitesse := vBaudRate128000;
    14: iVitesse := vBaudRate256000;
  else
    iVitesse := vBaudRate9600;
  end;

  case CBits.ItemIndex of
    0: iBits := vBits5;
    1: iBits := vBits6;
    2: iBits := vBits7;
    3: iBits := vBits8;
  else
     iBits := vBits8;
  end;

  case CParite.ItemIndex of
    0: iParite := vParitePaire;
    1: iParite := vPariteImpaire;
    2: iParite := vPariteAucune;
    3: iParite := vPariteMarque;
    4: iParite := vPariteEspace;
  else
    iParite := vParitePaire;
  end;

  case CArret.ItemIndex of
    0: iArret := vArretOneStop;
    1: iArret := vArretOne5Stop;
    2: iArret := vArretTwoStop;
  else
    iArret := vArretOneStop;
  end;
end;

end.
