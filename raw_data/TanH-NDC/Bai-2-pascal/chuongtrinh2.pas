program bai2;
uses crt;
var t:string;
Begin
     clrscr;
     writeln('Nhap vao xau t'); readln(t);
     writeln(t[1]=' ') do delete(t,1,1);
     while (t[length(t)]=' ') do delete(t,length(t),1);
     while (pos(' ',t) > 0) do delete(t,pos(' ',t),1);
     writeln('Xau sau khi chuan hoa: ',t);
     readln();
end.
     
