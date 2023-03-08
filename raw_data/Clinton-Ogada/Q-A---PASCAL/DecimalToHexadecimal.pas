Program DecimalToHexadecimal(input,output);
{*This program will convert an input number from decimal to hexadecimal(base10)*}
var
  decimalNum, quotient, remainder: integer;
  hexNum: string;
begin
  // Prompt the user for the decimal number to convert
  write('Enter a decimal number: ');
  readln(decimalNum);
  // Convert the decimal number to hexadecimal
  hexNum := '';
  quotient := decimalNum;
  repeat
    remainder := quotient mod 16;
    case remainder of
      0..9: hexNum := chr(remainder + ord('0')) + hexNum;
      10..15: hexNum := chr(remainder - 10 + ord('A')) + hexNum;
    end;
    quotient := quotient div 16;
  until quotient = 0;
  // Output the hexadecimal number
  writeln('The hexadecimal representation of ', decimalNum, ' is ', hexNum);
end.
