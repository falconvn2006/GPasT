Program DataCards(input,output);
{*This program inputs data cards and output a list of surnames, each followed by initials*}
var
  input: text;
  line, surname, initials, name: string;
  i: integer;
begin
  // Open the input file
  assign(input, 'data_cards.txt');
  reset(input);

  // Loop through each line of the input file
  while not eof(input) do begin
    readln(input, line);
    // Extract the surname and initialize the initials string
    surname := copy(line, 1, pos(' ', line) - 1);
    initials := '';
    // Loop through each name after the surname
    i := pos(' ', line) + 1;
    while i <= length(line) do begin
      name := copy(line, i, pos(' ', line, i) - i);
      // Add the first letter of the name to the initials string
      initials := initials + name[1] + ' ';
      i := pos(' ', line, i) + 1;
    end;
    // Output the surname followed by initials
    writeln(surname, ' ', initials);
  end;
  // Close the input file
  close(input);
end.
