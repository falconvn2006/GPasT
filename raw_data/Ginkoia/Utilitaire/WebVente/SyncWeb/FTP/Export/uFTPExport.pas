unit uFTPExport;

interface

uses
  DB, SysUtils, DateUtils, Classes, Forms, uFTPFiles, uGestionBDD;

Type
  TFTPExportVteLTC = class(TCustomFTPSendFile)
  protected
    procedure LoadQueryParams(AQuery: TMyQuery); override;

    function getQuery: string; override;
    function getInitQuery: string; override;
  public
  end;

implementation

uses
  uCustomFTPManager, uCommon_Dm, uFTPUtils, uLog, uMonitoring;

{ TFTPExportVteLTC }


Const
  cListFields = '  R_CODE_FICHIER AS CODE_FICHIER,' + #13#10 +
                '  R_MAG_CODEADH AS CODE_BOUTIQUE,' + #13#10 +
                '  R_TKE_SEQUENCE AS IDTICKET,' + #13#10 +
                '  R_TKE_DATE AS DATETICKET,' + #13#10 +
                '  R_CBI_CB AS CB,' + #13#10 +
                '  R_TKL_QTE AS QTE,' + #13#10 +
                '  R_TKL_PXBRUT AS PXBRUT,' + #13#10 +
                '  R_TKL_PXNET AS PXNET,' + #13#10 +
                '  R_DESCRIPTION AS DESCRIPTION ' + #13#10;


function TFTPExportVteLTC.getInitQuery: string;
begin
  Result := 'SELECT' + #13#10 + cListFields +
            'FROM PR_EXP_VTE_LTC(:PDATEDEB, :PDATEFIN, :PCODEFICHIER, :PCODEMARQUE)';
end;

function TFTPExportVteLTC.getQuery: string;
begin
  Result := 'SELECT' + #13#10 +cListFields +
            'FROM PR_EXP_VTE_LTC(:PDATEDEB, :PDATEFIN, :PCODEFICHIER, :PCODEMARQUE)';
end;

procedure TFTPExportVteLTC.LoadQueryParams(AQuery: TMyQuery);
var
  vQry: TMyQuery;
  vField: TField;
  vAWE_DATEEXPORT, vDT_Fin: TDateTime;
  vCODEFICHIER, Buffer: String;
  vCODEMARQUE: integer;
  vH, vM, vS, vMS: Word;
  vSL: TStringList;
  vIsReplayTheExport: Boolean;
begin
  inherited LoadQueryParams(AQuery);
  vCODEFICHIER:= '';
  vCODEMARQUE:= 0;
  vIsReplayTheExport:= False;

  vQry:= GetNewQuery;
  vSL:= TStringList.Create;
  try
    Buffer:= ChangeFileExt(Application.ExeName, '.rte');

    if FileExists(Buffer) then
      begin
        vSL.LoadFromFile(Buffer);
        vIsReplayTheExport:= vSL.Count <> 0;
      end;

    if vIsReplayTheExport then
      begin
        { Option en cas de problème lorsqu'il y a un ou des exports qui manquent.
          Cela permet de réexécuter des exports à partir d'un fichier dans lequel
          se trouve une ou plusieurs dates sous forme de liste avec le
          format jj/mm/yyyy. Aucun séparateur de fin de ligne n'est nécessaire.

          ATTENTION : A utiliser QUE en mode manuel. En mode Auto, le fichier
                      devra être vide ou supprimer. }


          vAWE_DATEEXPORT:= StrToDate(vSL.Strings[0]) + EncodeTime(0, 0, 1, 0);

          vDT_Fin:= IncDay(vAWE_DATEEXPORT);

        vSL.Delete(0);
        vSL.SaveToFile(Buffer);
      end
    else
      begin
        // Récupération de la date de début
        vQry.SQL.Text:= 'SELECT AWE_DATEEXPORT ' +
                        'FROM ARTEXPORTWEB JOIN K ON K.K_ID = ARTEXPORTWEB.AWE_ID AND K.K_ENABLED = 1 ' +
                        'WHERE AWE_ASSID = ' + IntToStr(ASSID) + ' AND AWE_ACTIF > 0 ' +
                        'ORDER BY AWE_DATEEXPORT DESC ' +
                        'ROWS 1';

        vQry.Open;
        vField:= vQry.Fields[0];

        { Le client souhaite faire un export quotidien à 2h du matin de toutes
         les ventes depuis la dernière date d'export. Si aucune date de dernier
         export, on prend toutes les ventes de la veille jusqu'à "Now".
        }

        if not vField.IsNull then
          vAWE_DATEEXPORT:= vField.AsDateTime
        else
          vAWE_DATEEXPORT:= Yesterday; //EncodeDate(2018, 5, 18);

        vDT_Fin:= Now;
      end;

    // Récupération des paramètres CODECEGID, CODEMARQUE
    vQry.SQL.Text:= 'SELECT PRM_CODE, PRM_INTEGER, PRM_STRING ' +
                    'FROM GENPARAM ' +
                    'WHERE PRM_TYPE = 88 AND PRM_CODE IN (10, 15) ' +
                    'ORDER BY PRM_CODE';
    vQry.Open;

    if vQry.Locate('PRM_CODE', 10, []) then
      vCODEFICHIER:= vQry.FieldByName('PRM_STRING').AsString;

    if vQry.Locate('PRM_CODE', 15, []) then
      vCODEMARQUE:= vQry.FieldByName('PRM_INTEGER').AsInteger;

    // ------------------------ Log ----------------------------
    AddLog('Plage de récupération - ' + DateTimeToStr(vAWE_DATEEXPORT) + ' à ' + DateTimeToStr(vDT_Fin), ftpllInfo);
    AddLog('Code fichier : ' + vCODEFICHIER, ftpllInfo);
    AddLog('Code marque : ' + IntToStr(vCODEMARQUE), ftpllInfo);

    OnAddMonitoring(Self, 'Plage de récupération - ' + DateTimeToStr(vAWE_DATEEXPORT) + ' à ' + DateTimeToStr(vDT_Fin), logNotice, mdltExport, FMonitoringAppType, FMagId, False, -1);
    OnAddMonitoring(Self, 'Code fichier : ' + vCODEFICHIER, logNotice, mdltExport, FMonitoringAppType, FMagId, False, -1);
    OnAddMonitoring(Self, 'Code marque : ' + IntToStr(vCODEMARQUE), logNotice, mdltExport, FMonitoringAppType, FMagId, False, -1);
    //----------------------------------------------------------

    AQuery.Params.ParamByName('PDATEDEB').AsDateTime := vAWE_DATEEXPORT;
    AQuery.Params.ParamByName('PDATEFIN').AsDateTime := vDT_Fin;
    AQuery.Params.ParamByName('PCODEFICHIER').AsString := vCODEFICHIER;
    AQuery.Params.ParamByName('PCODEMARQUE').AsInteger := vCODEMARQUE;

  finally
    FreeAndNil(vQry);
    FreeAndNil(vSL);
  end;
end;

initialization

  TCustomFTPManager.RegisterKnownFile('EXP_LTC', ftSend, '', '', TFTPExportVteLTC);

end.
