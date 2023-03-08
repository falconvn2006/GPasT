Program TriangleCheck(input,output);
{*This program reads three integers and determines whether they could represent the lengths of the sides a triangle and a right-angled triangle respectively*}
{*Written by Clinton Ogada*}
var
  a, b, c: integer;
begin
  // Prompt the user to enter the three integers
  writeln('Enter three integers a, b, and c where a > b > c: ');
  readln(a, b, c);
  // Check if the sides could represent a triangle
  if (a < b + c) and (b < a + c) and (c < a + b) then
  begin
    writeln('The three sides could represent a triangle.');
    // Check if the triangle is a right-angled triangle
    if (a * a = b * b + c * c) or (b * b = a * a + c * c) or (c * c = a * a + b * b) then
      writeln('The triangle is a right-angled triangle.')
    else
      writeln('The triangle is not a right-angled triangle.');
  end
  else
    writeln('The three sides could not represent a triangle.');
end.
