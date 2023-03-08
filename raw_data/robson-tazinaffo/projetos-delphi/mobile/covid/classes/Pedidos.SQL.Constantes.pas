unit Pedidos.SQL.Constantes;

interface

const
  //Clientes
  C_SQL_CLIENTES =
    'SELECT                        ' +
    '  PES_ID,                     ' +
    '  PES_RAZAOSOCIAL,            ' +
    '  PES_FANTASIA,               ' +
    '  PES_ATIVOINATIVO,           ' +
    '  PES_CPFCNPJ,                ' +
    '  PES_RGINSCR,                ' +
    '  PES_FISICAJURIDICA,         ' +
    '  PES_DTNASCIMENTO,           ' +
    '  PES_DTCADASTRO,             ' +
    '  PES_SITE,                   ' +
    '  PES_USUARIO_CAD,            ' +
    '  PES_TELEFONE,               ' +
    '  PES_CELULAR,                ' +
    '  PES_EMAIL,                  ' +
    '  PES_COND_PAGTO_PADRAO,      ' +
    '  PES_LIMITE_CREDITO,         ' +
    '  PES_DTALTERACAO             ' +
    'FROM                          ' +
    '  MOB001                      ';

  //Endereços
  C_SQL_ENDERECOS =
    'SELECT                                      ' +
    '  ENDERECO.END_ID,                          ' +
    '  ENDERECO.END_ID_CIDADE,                   ' +
    '  ENDERECO.END_ID_PESSOA,                   ' +
    '  ENDERECO.END_TIPO,                        ' +
    '  ENDERECO.END_NUMERO,                      ' +
    '  ENDERECO.END_ENDERECO,                    ' +
    '  ENDERECO.END_COMPLEMENTO,                 ' +
    '  ENDERECO.END_BAIRRO,                      ' +
    '  ENDERECO.END_CEP,                         ' +
    '  ENDERECO.END_ESTADO,                      ' +
    '  CIDADE.CID_NOME                           ' +
    'FROM                                        ' +
    '  MOB001 PESSOA                             ' +
    '  INNER JOIN MOB005 ENDERECO                ' +
    '  ON ENDERECO.END_ID_PESSOA = PESSOA.PES_ID ' +
    '  INNER JOIN MOB006 CIDADE                  ' +
    '  ON ENDERECO.END_ID_CIDADE = CIDADE.CID_ID ' +
    'WHERE                                       ' +
    '  PESSOA.PES_ID = :pID_PESSOA               ';

  //Contatos
  C_SQL_CONTATOS =
    'SELECT                                        ' +
    '  *                                           ' +
    'FROM                                          ' +
    '  MOB002 CONTATO                              ' +
    '  INNER JOIN MOB001 PESSOA                    ' +
    '  ON CONTATO.CNT_ID_PESSOA = PESSOA.PES_ID    ' +
    'WHERE                                         ' +
    '  CONTATO.CNT_ID_PESSOA = :pID_PESSOA         ';

  //Títulos
  C_SQL_TITULOS =
    'SELECT                                    ' +
    '  *                                       ' +
    'FROM                                      ' +
    '  MOB012 TITULO                           ' +
    '  INNER JOIN MOB001 PESSOA                ' +
    '  ON TITULO.TIT_ID_PESSOA = PESSOA.PES_ID ' +
    'WHERE                                     ' +
    '  TITULO.TIT_ID_PESSOA = :pID_PESSOA      ';

  //Situação Financeira
  C_SQL_SITUACAO_FINANCEIRA =
    'SELECT                                             ' +
    '  *                                                ' +
    'FROM                                               ' +
    '  MOB003 SIT_FINANCEIRA                            ' +
    '  INNER JOIN MOB001 PESSOA                         ' +
    '  ON SIT_FINANCEIRA.SIF_ID_PESSOA = PESSOA.PES_ID  ' +
    'WHERE                                              ' +
    '  SIT_FINANCEIRA.SIF_ID_PESSOA = :pID_PESSOA       ';



implementation

end.
