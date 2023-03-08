Program BankAccount(input,output);
{*This program is meant to process deposits and withdrawals for a bank account*}
var
  balance, amount: real;
  transaction: char;
begin
  // Input the initial balance
  write('Enter initial balance: ');
  readln(balance);

  // Output the statement heading
  writeln('DEPOSIT    WITHDRAWAL    CREDIT    DEBIT');

  // Process deposits and withdrawals
  repeat
    // Input the transaction code and amount
    write('Enter transaction code (D for deposit, W for withdrawal): ');
    readln(transaction);
    write('Enter amount: ');
    readln(amount);
    // Process the transaction
    case transaction of
      'D', 'd': begin
                  balance := balance + amount;
                  if balance < 0 then
                    writeln('  ', amount:10:2)
                  else
                    writeln(amount:10:2);
                end;
      'W', 'w': begin
                  balance := balance - amount;
                  if balance < 0 then
                    writeln('  ', amount:10:2)
                  else
                    writeln('  ', amount:10:2);
                end;
      else
        writeln('Invalid transaction code');
    end;
  until (transaction <> 'D') and (transaction <> 'd') and (transaction <> 'W') and (transaction <> 'w');

  // Output the final balance
  writeln('Final balance: ', balance:0:2);
end.
