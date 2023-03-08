unit Params_Frm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  FireDAC.Phys.IBDef, FireDAC.Stan.Def,
  FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase, FireDAC.Phys, FireDAC.Stan.Intf,
  FireDAC.Phys.IB, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Pool, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.Phys.FBDef, FireDAC.Phys.FB, ShellAPi,
  FireDAC.Comp.ScriptCommands, FireDAC.Stan.Util, FireDAC.Comp.Script, Upost,
  Vcl.Buttons, UWMI;

type
  TFrm_Params = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    teNODEID: TEdit;
    teBASIDENT: TEdit;
    Label4: TLabel;
    tePLAGE: TEdit;
    Label5: TLabel;
    teGENERALID: TEdit;
    Label6: TLabel;
    teIBFILE: TEdit;
    Label7: TLabel;
    teSENDER: TEdit;
    Label8: TLabel;
    teGUID: TEdit;
    Button1: TButton;
    Label9: TLabel;
    teYELLISVERSION: TEdit;
    Label10: TLabel;
    teVERSION: TEdit;
    PageControl1: TPageControl;
    tsDB: TTabSheet;
    TabSheet2: TTabSheet;
    Label11: TLabel;
    BFERMER: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    teEASYSERVICE: TEdit;
    Label12: TLabel;
    teEASYPATH: TEdit;
    Label13: TLabel;
    teEASYFileProperties: TEdit;
    Label14: TLabel;
    teRegsitrationURL: TEdit;
    Label15: TLabel;
    teBACKRES: TEdit;
    Bevel1: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BFERMERClick(Sender: TObject);
  private
    FIBFile : TFileName;
    SE_EASY : TEASYInfos;
    procedure SetIBFile(aValue:TFileName);
    procedure GetDBInfos();
    { Déclarations privées }
  public
    property IBFile : TFileName read FIBFile write SetIBFile;
    { Déclarations publiques }
  end;

var
  Frm_Params: TFrm_Params;

implementation

{$R *.dfm}

USes uDataMod;


procedure TFrm_Params.SetIBFile(aValue:TFileName);
begin
    FIBFile := aValue;
    teIBFILE.Text := FIBFile;
    GetDBInfos();
end;

procedure TFrm_Params.BFERMERClick(Sender: TObject);
begin
   //---------------- Détection des changements --
//   If ((rbBackRest0.Checked) and (OldLAU_BACK<>0)) or
//      ((rbBackRest1.Checked) and (OldLAU_BACK<>1)) or
//      (OldLAU_BACKTIME<>timBACKREST.DateTime)
//      then MessageDlg('qsdqsd',  mtInformation, [mbOK], 0);
   //----------------------------------------------
end;

procedure TFrm_Params.BitBtn1Click(Sender: TObject);
begin
    ShellExecute(Handle,'Open',PWideChar(Format('http://localhost:%d/app',[SE_EASY.http])),nil,nil,SW_SHOWNORMAL);
end;

procedure TFrm_Params.BitBtn2Click(Sender: TObject);
begin
    ShellExecute(Handle,'Open',PWideChar(SE_EASY.Directory + '\bin\symcc.bat'),nil,nil,SW_HIDE);
end;

procedure TFrm_Params.Button1Click(Sender: TObject);
begin
//   YellisConnexion.Base := '';
    teYELLISVERSION.Text := YellisConnexion.GetVersion(teGUID.Text);
end;

procedure TFrm_Params.FormCreate(Sender: TObject);
begin
    SE_EASY := WMI_GetServicesEASY();
    //
    teEASYSERVICE.Text := SE_EASY.ServiceName;
    teEASYPATH.Text    := SE_EASY.Directory;

    teEASYFileProperties.Text := SE_EASY.PropertiesFile;
    teRegsitrationURL.Text    := SE_EASY.registration_url;
end;

procedure TFrm_Params.GetDBInfos();
var vQuery:TFDQuery;
    i:integer;
    vBASID  : integer;
    vBASNOM : string;
    vBASPLAGE  : string;
    vBASSENDER : string;
    vBASGUID   : string;
    vDebut,vFin : integer;

begin
     if IBFILE='' then exit;

     vQuery:=TFDQuery.Create(nil);
     try
       try
         DataMod.FDcon.Params.Database := IBFILE;
         vQuery.Connection  := DataMod.FDcon;
         vQuery.Transaction := DataMod.FDtrans;
         vQuery.Transaction.Options.ReadOnly:=true;
         vQuery.Close;

         // Recup du BAS_ID (on en a besoin pour GENHISTOEVT)
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT BAS_ID, BAS_IDENT, BAS_NOM, BAS_PLAGE, BAS_SENDER, BAS_GUID FROM GENPARAMBASE        ');
         vQuery.SQL.Add(' JOIN GENBASES ON BAS_IDENT=PAR_STRING ');
         vQuery.SQL.Add(' JOIN K ON K_ID=BAS_ID AND K_ENABLED=1 ');
         vQuery.SQL.Add('WHERE PAR_NOM=''IDGENERATEUR''         ');
         vQuery.Open();
         If (vQuery.RecordCount=1) then
           begin
              vBASID          := vQuery.FieldByName('BAS_ID').Asinteger;
              teBASIDENT.Text := vQuery.FieldByName('BAS_IDENT').Asstring;
              teSENDER.Text   := vQuery.FieldByName('BAS_SENDER').Asstring;
              teGUID.Text     := vQuery.FieldByName('BAS_GUID').Asstring;
              tePLAGE.Text    := vQuery.FieldByName('BAS_PLAGE').Asstring;
           end;

         vQuery.Close;

         // Recup du BAS_ID (on en a besoin pour GENHISTOEVT)
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT * FROM GENVERSION        ');
         vQuery.SQL.Add('ORDER BY VER_DATE DESC ROWS 1   ');
         vQuery.Open();
         If (vQuery.RecordCount=1) then
           begin
              teVERSION.Text  := vQuery.FieldByName('VER_VERSION').Asstring
           end;

         teYELLISVERSION.Text := YellisConnexion.GetVersion(teGUID.Text);

         vQuery.Close;
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT NODE_ID FROM SYM_NODE_IDENTITY ');
         vQuery.Open();
         If (vQuery.RecordCount=1) then
           begin
              teNODEID.Text := vQuery.FieldByName('NODE_ID').Asstring;
           end;

         // Ou est GENERAL_ID
         vQuery.Close;
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT GEN_ID(GENERAL_ID,0) FROM RDB$DATABASE ');
         vQuery.Open();
         If (vQuery.RecordCount=1) then
           begin
              teGENERALID.Text := vQuery.Fields[0].asstring;
//              AnalysePlage(vBASPLAGE,vQuery.Fields[0].asinteger);
           end;

         // Recup de l'Horaire du Backup (attention ce n'est pas LAU_HEURE1 mais LAU_BACKTIME
         vQuery.Close;
         vQuery.SQL.Clear();
         vQuery.SQL.Add('SELECT * FROM GenLaunch ');
         vQuery.SQL.Add('Join k on (K_ID = LAU_ID and K_Enabled=1) ');
         vQuery.SQL.Add('  WHERE LAU_BASID=:BASID');
         vQuery.ParamByName('BASID').AsInteger := vBASID;
         vQuery.Open();
         If (vQuery.RecordCount=1) then
           begin
                teBACKRES.Text := '23:00';
                If (vQuery.FieldByName('LAU_BACK').Asinteger=1)
                  then teBACKRES.Text := FormatDateTime('HH:mm',vQuery.FieldByName('LAU_BACKTIME').AsDateTime);
           end;
       except
         On E:EIBNativeException Do
          begin
            // do raise;
            // FShutdown :=true;

          end;
       end;
     Finally
       vQuery.Free;
       DataMod.FDcon.Connected := false;
     end;
end;

end.
