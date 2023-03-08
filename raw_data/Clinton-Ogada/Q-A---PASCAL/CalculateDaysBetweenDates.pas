Program CalculateDaysBetweenDates(input,output);
{*This program calculates the number of days between two given dates*}
{*written by Clinton Ogada v1*}
uses
  sysutils;
var
  date1, date2: TDateTime;
  daysBetween: integer;
begin
  // Prompt the user for the first date
  write('Enter the first date (in the format "yyyy-mm-dd"): ');
  readln(date1);
  // Prompt the user for the second date
  write('Enter the second date (in the format "yyyy-mm-dd"): ');
  readln(date2);
  // Calculate the number of days between the two dates
  daysBetween := trunc(abs(date2 - date1));
  // Output the result
  writeln('The number of days between ', DateToStr(date1), ' and ', DateToStr(date2), ' is: ', daysBetween);
end.
