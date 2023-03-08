unit uZVTProtocolUtils;

interface

type

  TBMPGetFormatedValueEvent = procedure(AValueCode: string; var AFormatedValue: string);

  procedure getFormatedZVTError(AValue: string; var AFormatedValue: string);
  procedure getFormatLLVarBMP(AValue: string; var AFormatedValue: string);

  function ZVTErrorMessage(ACode: string): string;
  function ZVTStatusMessage(AStatus: string): string;

implementation

uses
  SysUtils;

procedure getFormatedZVTError(AValue: string; var AFormatedValue: string);
begin
  AFormatedValue := ZVTErrorMessage(AValue);
end;

procedure getFormatLLVarBMP(AValue: string; var AFormatedValue: string);
begin
  // LLVAR format "F0 F8 49 99 99 99 99 99 99 96
  // F0 F8 défini la taille (08 bytes)
  AFormatedValue := Copy(AValue, 7, length(AValue));
  AFormatedValue.Replace(' ', '', [rfReplaceAll]);
end;

function ZVTErrorMessage(ACode: string): string;
begin
  // ACode est une valeur hexadecimal
  Result := ACode + ' (No known def)';

  if ACode = '00' then Result := 'No error';

  // 01-63 codes erreurs du "netword-operator system" / "authorisation-system"
  if (StrToInt('$' + ACode) >= 1) and (StrToInt('$' + ACode) <= 99) then
    Result := Format('ErrorCodes from netword-operator system / authorisation system (%s)', [ACode]);

  if ACode = '64' then Result := 'Card not readable (LRC-/parity-error)';
  if ACode = '65' then Result := 'Card-data not present (neither track-data nor chip found)';
  if ACode = '66' then Result := 'Processing-error (also for problems with card-reader mechanism)';
  if ACode = '67' then Result := 'Function not permitted for ec and Maestro-cards';
  if ACode = '68' then Result := 'Function not permitted for credit- and tank-cards';
  if ACode = '6A' then Result := 'Turnover-fill full';
  if ACode = '6B' then Result := 'Function deactivated (PT not registered)';
  if ACode = '6C' then Result := 'Abort via-time out or abort-key';
  if ACode = '6E' then Result := 'Card in blocked-list (response to command 06 E4)';
  if ACode = '6F' then Result := 'Wrong currency';
  if ACode = '71' then Result := 'Credit not sufficient (chip-card)';
  if ACode = '72' then Result := 'Chip error';
  if ACode = '73' then Result := 'Card-data incorrect (e.g. country-key check, checksum-error)';
  if ACode = '77' then Result := 'End-of-day batch not possible';
  if ACode = '78' then Result := 'Card expired';
  if ACode = '79' then Result := 'Card not yet valid';
  if ACode = '7A' then Result := 'Card unknown';
  if ACode = '7B' then Result := 'Fallback to magnetic stripe for girocard not possible';
  if ACode = '7C' then Result := 'Fallback to magnetic stripe not possible (used for non girocard cards)';
  if ACode = '7D' then Result := 'Communication error (communication modules does not answer or is not present)';
  if ACode = '83' then Result := 'Function not possible';
  if ACode = '85' then Result := 'Key missing';
  if ACode = '89' then Result := 'PIN-oad defective';
  if ACode = '9A' then Result := 'Protocol error';
  if ACode = '9B' then Result := 'Error from dial-up / communication fault';
  if ACode = '9C' then Result := 'Please wait';
  if ACode = 'A0' then Result := 'receiver not ready';
  if ACode = 'A1' then Result := 'Remote station does not respond';
  if ACode = 'A3' then Result := 'No connection';
  if ACode = 'A4' then Result := 'Submission of Geldkarte not possible';
  if ACode = 'B1' then Result := 'Memory full';
  if ACode = 'B2' then Result := 'Merchant-journal full';
  if ACode = 'B4' then Result := 'Already reversed';
  if ACode = 'B5' then Result := 'Reversal not possible';
  if ACode = 'B7' then Result := 'Pre-authorisation incorrect (amount too high) or amount wrong';
  if ACode = 'B8' then Result := 'Error pre-authorisation';
  if ACode = 'BF' then Result := 'Voltage supply to low (external power supply)';
  if ACode = 'C0' then Result := 'Card locking mechanism defective';
  if ACode = 'C1' then Result := 'Merchant-card locked';
  if ACode = 'C2' then Result := 'Diagnosis requred';
  if ACode = 'C3' then Result := 'Maximum amount exceeded';
  if ACode = 'C4' then Result := 'Card-profile invalid. New card-profiles must be loaded';
  if ACode = 'C5' then Result := 'Payment method not supported';
  if ACode = 'C6' then Result := 'Currency not applicable';
  if ACode = 'C8' then Result := 'Amount zu small';
  if ACode = 'C9' then Result := 'Max. transaction-amount zu small';
  if ACode = 'CB' then Result := 'Function only allowed in EURO';
  if ACode = 'CC' then Result := 'Printer not ready';
  if ACode = 'CD' then Result := 'CashBack not possible';
  if ACode = 'D2' then Result := 'Function not permitted for service-card/bank-customer-cards';
  if ACode = 'DC' then Result := 'Card inserted';
  if ACode = 'DD' then Result := 'Error during card-eject (for motor-insertion reader)';
  if ACode = 'DE' then Result := 'Error during card-insertion (for motor-insertion reader)';
  if ACode = 'E0' then Result := 'Remote-maintenance activated';
  if ACode = 'E2' then Result := 'Card-reader does not answer / card-reader defective';
  if ACode = 'E3' then Result := 'Shutter closed';
  if ACode = 'E4' then Result := 'Terminal activation required';
  if ACode = 'E7' then Result := 'min. one goods-group not found';
  if ACode = 'E8' then Result := 'No goods-groups-table loaded';
  if ACode = 'E9' then Result := 'Restriction-code not permitted';
  if ACode = 'EA' then Result := 'Card-code not permitted (e.g. card not activated via Diagnosis)';
  if ACode = 'EB' then Result := 'Function not executable (PIN-algorithm unknow)';
  if ACode = 'EC' then Result := 'PIN-processing not possible';
  if ACode = 'ED' then Result := 'PIN-pas defective';
  if ACode = 'F0' then Result := 'Open end-of-day batch present';
  if ACode = 'F1' then Result := 'ec-cash/Maestro offline error';
  if ACode = 'F5' then Result := 'OPT-error';
  if ACode = 'F6' then Result := 'OPT-data not available (=OPT personalisation required)';
  if ACode = 'FA' then Result := 'Error transmitting offline-transactions (clearing error)';
  if ACode = 'FB' then Result := 'Turnover data-set defective';
  if ACode = 'FC' then Result := 'Necessary device not present or defective';
  if ACode = 'FD' then Result := 'Baudrate not supported';
  if ACode = 'FE' then Result := 'Register unknow';
  if ACode = 'FF' then Result := 'System error';
end;

function ZVTStatusMessage(AStatus: string): string;
begin
  Result := AStatus + ' (No known def)';

  if AStatus = '00' then Result := '';
  if AStatus = '01' then Result := 'Please observe display on the PIN pad';
  if AStatus = '02' then Result := '';
  if AStatus = '03' then Result := 'Transaction impossible';    //'Transaction not possible';
  if AStatus = '04' then Result := '';
  if AStatus = '05' then Result := '';
  if AStatus = '06' then Result := '';
  if AStatus = '07' then Result := 'Carte non admise';          //'Card not admitted';
  if AStatus = '08' then Result := 'Carte inconnue';            //'Card unknown';
  if AStatus = '09' then Result := 'Carte expirée';             //'Card expired';
  if AStatus = '0A' then Result := 'Inserer carte';             //'Insert Card';
  if AStatus = '0B' then Result := 'Retirer Carte';             //'Remove card';
  if AStatus = '0C' then Result := 'Carte non lisible';         //'Card not legible';
  if AStatus = '0D' then Result := 'Transaction annulée';       //'Transaction cancelled';
  if AStatus = '0E' then Result := 'Transaction en cours, Patientez svp ...'; //'Processing transaction, Please wait...';
  if AStatus = '0F' then Result := '';
  if AStatus = '10' then Result := 'Carte invalide';            //'Invalid card';
  if AStatus = '11' then Result := '';
  if AStatus = '12' then Result := 'Erreur système';            //'System error';
  if AStatus = '13' then Result := 'Paiement impossible';        //'Payment not possible';
  if AStatus = '14' then Result := '';
  if AStatus = '15' then Result := 'Code PIN incorrect';        //'Incorrect PIN';
  if AStatus = '16' then Result := '';
  if AStatus = '17' then Result := 'Patientez svp ...';         //'Please wait...';
  if AStatus = '18' then Result := 'PIN try limit exceeded';
  if AStatus = '19' then Result := 'Wrong card data';
  if AStatus = '1A' then Result := '';
  if AStatus = '1B' then Result := '';
  if AStatus = '1C' then Result := '';
  if AStatus = '1D' then Result := 'Authorisation impossible';  //'Authorisation not possible';
  if AStatus = '26' then Result := '';
  if AStatus = '27' then Result := '';
  if AStatus = '28' then Result := '';
  if AStatus = '29' then Result := '';
  if AStatus = '2A' then Result := '';
  if AStatus = '2B' then Result := '';
  if AStatus = '2C' then Result := '';
  if AStatus = '41' then Result := '';
  if AStatus = '42' then Result := '';
  if AStatus = '43' then Result := 'Transaction impossible - Retirer la carte svp'; //'Transaction not possible - please remove card';
  if AStatus = '44' then Result := '';
  if AStatus = '45' then Result := '';
  if AStatus = '46' then Result := '';
  if AStatus = '47' then Result := 'Carte non admise - Retirer la carte svp'; //'Card not admitted - please remove card';
  if AStatus = '48' then Result := 'Carte inconnue - Retirer la carte svp'; //'Unknown card - please remove card';
  if AStatus = '49' then Result := 'Carte expirée - Retirer la carte svp'; //'Card expired - please remove card';
  if AStatus = '4A' then Result := '';
  if AStatus = '4B' then Result := 'Retirer la carte svp';        //'Please remove card';
  if AStatus = '4C' then Result := 'Lecture de carte impossible - Retirer la carte svp'; //'Cannot read card - please remove card';
  if AStatus = '4D' then Result := 'Transation annulée - Retirer la carte svp'; //'Transaction cancelled - please remove card';
  if AStatus = '4E' then Result := '';
  if AStatus = '4F' then Result := '';
  if AStatus = '50' then Result := 'Carte invalide - Retirer la carte svp'; //'Invalid card - please remove card';
  if AStatus = '51' then Result := '';
  if AStatus = '52' then Result := 'Erreur système - Retirer la carte svp'; //'System error - please remove card';
  if AStatus = '53' then Result := 'Paiement impossible - Retirer la carte svp'; //'Payment not possible - please remove card';
  if AStatus = '54' then Result := '';
  if AStatus = '55' then Result := 'Code PIN incorrect - Retirer la carte svp'; //'Wrong PIN - please remove card';
  if AStatus = '56' then Result := '';
  if AStatus = '57' then Result := '';
  if AStatus = '58' then Result := 'Wrong PIN entered too often - please remove card';
  if AStatus = '59' then Result := 'Wrong card data - please remove card';
  if AStatus = '5A' then Result := '';
  if AStatus = '5B' then Result := '';
  if AStatus = '5C' then Result := '';
  if AStatus = '5D' then Result := 'Authorisation impossible - Retirer la carte svp'; //'Authorisation not possible - please remove card';
  if AStatus = '66' then Result := '';
  if AStatus = '67' then Result := '';
  if AStatus = 'C7' then Result := '';
  if AStatus = 'C8' then Result := '';
  if AStatus = 'C9' then Result := '';
  if AStatus = 'CA' then Result := '';
  if AStatus = 'CB' then Result := '';
  if AStatus = 'CC' then Result := '';
  if AStatus = 'D2' then Result := 'Establishing remote data transfer connection';
  if AStatus = 'D3' then Result := 'Remote data transfer connection established';
  if AStatus = 'E0' then Result := '';
  if AStatus = 'E1' then Result := '';
  if AStatus = 'F1' then Result := '';
  if AStatus = 'F2' then Result := '';
  if AStatus = 'F3' then Result := '';
  if AStatus = 'FF' then Result := '';
  // additional message
  if AStatus = 'A0' then Result := 'Paiement effectué';     //'Payment processed';
  if AStatus = 'A1' then Result := 'Paiement effectué. Retirer la carte svp'; //'Payment processed - please remove card';
  if AStatus = 'A2' then Result := 'Cancellation processed';
  if AStatus = 'A3' then Result := 'Cancellation processed - please remove card';
  if AStatus = 'A4' then Result := 'Cancellation not possible';
  if AStatus = 'A5' then Result := 'Cancellation not possible - please remove card';
  if AStatus = 'A6' then Result := 'Please verify customer signature (for iDRM)';
end;

end.
