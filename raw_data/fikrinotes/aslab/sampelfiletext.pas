 uses crt;

 var
        f : text;
        s : string;

 begin
 assign(f, 'fikrifiletext.txt');
 {$I-}
 append(f);
 {$I+}
 if IOResult<>0 then
        begin
        rewrite(f)
        end;
 writeln(f,'fikri');
 writeln(f,'mulyana');
 close(f);

 end.