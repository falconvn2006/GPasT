Program DecimalToRoman(Input,output);
{*This program will input a number in decimal form and output the corresponding Roman numeral*}
var
  decimalNum, remainder, i: integer;
  romanNum: string;
const
  decimals: array[1..13] of integer = (1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1);
  romans: array[1..13] of string = ('M', 'CM', 'D', 'CD', 'C', 'XC', 'L', 'XL', 'X', 'IX', 'V', 'IV', 'I');
begin
  // Prompt the user for the decimal number to convert
  write('Enter a decimal number: ');
  readln(decimalNum);
  // Convert the decimal number to a Roman numeral
  romanNum := '';
  i := 1;
  while decimalNum > 0 do
  begin
    remainder := decimalNum div decimals[i];
    decimalNum := decimalNum mod decimals[i];
    for j := 1 to remainder do
      romanNum := romanNum + romans[i];
    Inc(i);
  end;
  // Output the Roman numeral
  writeln('The Roman numeral representation of ', decimalNum, ' is ', romanNum);
end.
