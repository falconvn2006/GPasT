Program HirePurchaseInterest(input,output);
{*This program calculates the annual rate of interest charged on a hire purchase debt... Written by Clinton Ogada v1. 20/02/2023*}
var
  downpayment, payment, totalDebt, interest, annualRate: real;
  numPayments: integer;
begin
  write('Enter the downpayment: ');
  readln(downpayment);
  write('Enter the number of payments per year: ');
  readln(numPayments);
  write('Enter the amount paid in each installment: ');
  readln(payment);
  totalDebt := payment * numPayments;
  interest := totalDebt - downpayment;
  annualRate := 100 * (interest / downpayment) / numPayments;
  writeln('The annual rate of interest charged is ', annualRate:0:2, '%');
  readln;
end.
