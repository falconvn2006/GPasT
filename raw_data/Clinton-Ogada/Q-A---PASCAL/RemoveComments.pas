Program RemoveComments(input,output);
{*This program inputs another Pascal program and outputs the program with comments removed*}
var
  input, output: text;
  line, newLine: string;
  i, openBrace, closeBrace: integer;
  inString, inComment: boolean;
begin
  // Open the input and output files
  assign(input, 'input.pas');
  reset(input);
  assign(output, 'output.pas');
  rewrite(output);
  // Loop through each line of the input file
  while not eof(input) do begin
    readln(input, line);
    // Initialize the newLine string
    newLine := '';
    // Loop through each character in the line
    for i := 1 to length(line) do begin
      if not inString and not inComment then begin
        // Check for the start of a comment
        if line[i] = '{' then begin
          openBrace := i;
          inComment := true;
        end else if (i < length(line)) and (line[i] = '(') and (line[i+1] = '*') then begin
          openBrace := i;
          inComment := true;
          i := i + 1;
        // Copy the character to the newLine string
        end else if line[i] <> '"' then begin
          newLine := newLine + line[i];
        end else begin
          inString := true;
          newLine := newLine + line[i];
        end;
      // Check for the end of a string
      end else if inString then begin
        newLine := newLine + line[i];
        if line[i] = '"' then inString := false;
      // Check for the end of a comment
      end else if inComment then begin
        if line[i] = '}' then begin
          closeBrace := i;
          inComment := false;
          newLine := newLine + ' ';
        end;
      end;
    end;
    // Copy any remaining characters to the newLine string
    if not inComment then begin
      newLine := newLine + copy(line, openBrace + 1, length(line) - openBrace);
    end;
    // Output the newLine string to the output file
    writeln(output, newLine);
  end;
  // Close the input and output files
  close(input);
  close(output);
end.
