unit uPedidos.Constantes;

interface

const
//  C_COR_PADRAO = $FF049A04;
//  C_COR_PADRAO = $FD7F6664;
    C_COR_PADRAO = $FFA1A390;

    C_COR_PRIMARY = $FFA1A390;
    C_COR_PRIMARY_LIGHT = $FFD2D4C0;
    C_COR_PRIMARY_DARK = $FF727463;

    C_COR_SECUNDARY = $FF806765; // MARROM





    ICO_VOICE_ON  = 'M12,2A3,3 0 0,1 15,5V11A3,3 0 0,1 12,14A3,3 0 0,1 9,11V5A3,3 0 0,1 12,2M19,11C19,14.53 16.39,17.44 13,17.93V21H11V17.93C7.61,17.44 5,14.53 5,11H7A5,5 0 0,0 12,16A5,5 0 0,0 17,11H19Z';
    ICO_VOICE_OFF = 'M19,11C19,12.19 18.66,13.3 18.1,14.28L16.87,13.05C17.14,12.43 17.3,11.74 17.3,11H19M15,11.16L9,5.18V5A3,3 0 0,1 12,2A3,3 0 0,1 15,5V11L15,11.16M4.27,3L21,19.73L19.73,21L15.54,16.81C14.77' +
                  ',17.27 13.91,17.58 13,17.72V21H11V17.72C7.72,17.23 5,14.41 5,11H6.7C6.7,14 9.24,16.1 12,16.1C12.81,16.1 13.6,15.91 14.31,15.58L12.65,13.92L12,14A3,3 0 0,1 9,11V10.28L3,4.27L4.27,3Z';

    // Mascaras Valor
//    C_Mascara_Decimal_2 = '###,###,##0.00';
    C_Mascara_Decimal_2 = '#,##0.00';
    C_Mascara_Real_2    = 'R$ ###,###,##0.00';
    C_Mascara_Decimal_4 = '###,###,##0.0000';
    C_Mascara_Real_4    = 'R$ ###,###,##0.0000';
    C_Mascara_Comissao  = '##0.00';
    C_Mascara_Qtde      = '##0';

    // Mascara Data
    C_Data_Simples = 'DD/MM/YYYY';
    C_Data_SQLite  = 'yyyy-MM-dd';

    // Tabelas do Sistema
    C_PESSOA      = 'MOB001';
    C_CONTATO     = 'MOB002';
    C_ENDERECO    = 'MOB005';
    C_AGENDA      = 'MOB007';
    C_PEDIDO      = 'MOB009';
    C_ITEM_PEDIDO = 'MOB010';


    {Expressões Regulares}
    C_EXP_CPF_CNPJ   = '([0-9]{2}[\.]?[0-9]{3}[\.]?[0-9]{3}'     +
                     '[\/]?[0-9]{4}[-]?[0-9]{2})|([0-9]{3}'    +
                     '[\.]?[0-9]{3}[\.]?[0-9]{3}[-]?[0-9]{2})' ;

    C_EXP_EMAIL      = '^((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*' +
                     '|"((?=[\x01-\x7f])[^"\\]|\\[\x01-\x7f])*"\' +
                     'x20*)*(?<angle><))?((?!\.)(?>\.?[a-zA-Z\d!' +
                     '#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])' +
                     '[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\' +
                     '-]+(?<!-)\.)+[a-zA-Z]{2,}|\[(((?(?<!\[)\.)' +
                     '(25[0-5]|2[0-4]\d|[01]?\d?\d)){4}|[a-zA-Z\' +
                     'd\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|' +
                     '\\[\x01-\x7f])+)\])(?(angle)>)$';

    C_EXP_FIXO_CEL   = '/^\([0-9]{2}\) [0-9]?[0-9]{4}-[0-9]{4}$/';
    //'/^(?:(?:\+|00)?(55)\s?)?(?:\(?([1-9][0-9])\)?\s?)?(?:((?:9\d|[2-9])\d{3})\-?(\d{4}))$/';

    C_EXP_RG         = '';

    C_EXP_SITE       = '^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\.' +
                     '_~:?#[\]@@!\$&''\ (\)\*\+,;=.]+$';

    C_EXP_INSCRICAO  = '';

    C_EXP_IP        = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b';

    C_EXP_CEP       = '\d{2}.\d{3}-\d{3}'; // Com ponto
//    C_EXP_CEP       = '\d{5}-\d{3}'; // Sem ponto

//    C_EXP_URL       = '^((http)|(https)|(ftp)):\/\/([\- \w]+\.)+\w{2,3}(\/ [%\-\w]+(\.\w{2,})?)*$';
				  
//    C_URL_PADRAO      = 'http://homologacao.vittia.com.br:8084/rest-secure.php';
    C_URL_PADRAO      = 'https://homologacao.vittia.com.br/rest-secure.php';

implementation

end.
