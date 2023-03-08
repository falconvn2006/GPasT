program MenghitungIP;
uses crt;

const
  MaksMahasiswa = 50;
  MaksMataKuliah = 10;

type
  DataMahasiswa = Record
    NIM         : integer;
    TampungNilai: integer;
    Nilai,BobotNilai : array[1..MaksMataKuliah] of integer;
    Nama        : string;
    IndeksNilai : array[1..MaksMataKuliah] of char;
    SKS : integer;
    NamaMatkul,KodeMatkul  : string;
    IP          : real;
  end; //endrecord
  DataMhs = array[1..MaksMahasiswa] of DataMahasiswa;

var
  DatMhs : DataMhs;
  Menu,Menu1,Menu2 : char;
  N,M,Semester  : Integer; {N : Banyaknya Mahasiswa, M : Banyaknya Matkul}
  Kelas : String;
  k,i,JumlahSKS : integer;


procedure MenuPilihanUtama (var Menu : char);
{I.S. : user memasukkan nommor menu}
{F.S. : menghasilkan nomor menu}
begin
  Textcolor(white);
  gotoxy(47,10); write('===========================');
  gotoxy(47,11); write('|      Menu Pilihan       |');
  gotoxy(47,12); write('===========================');
  gotoxy(47,13); write('|     1. Isi Data         |');
  gotoxy(47,14); write('|     2. Tampil Data      |');
  gotoxy(47,15); write('|     3. Cari Data        |');
  gotoxy(47,16); write('|     0. Keluar           |');
  gotoxy(47,17); write('===========================');
  gotoxy(47,18); write('| Pilihan Anda ?          |');
  gotoxy(47,19); write('===========================');
  gotoxy(64,18); read(Menu);
  readln;
end;

procedure MenuPilihan1 (var Menu1 : char);
{I.S. : user memasukkan nommor menu}
{F.S. : menghasilkan nomor menu}
begin
  Textcolor(white);
  gotoxy(45,10); write('================================');
  gotoxy(45,11); write('|        Menu Pilihan 1        |');
  gotoxy(45,12); write('================================');
  gotoxy(45,13); write('| 1. Isi Data Mahasiswa        |');
  gotoxy(45,14); write('| 2. Isi Data Mata Kuliah      |');
  gotoxy(45,15); write('| 3. Isi Data Nilai Per Matkul |');
  gotoxy(45,16); write('| 0. Kembali ke Menu Utama     |');
  gotoxy(45,17); write('================================');
  gotoxy(45,18); write('| Pilihan Anda ?               |');
  gotoxy(45,19); write('================================');
  gotoxy(62,18); read(Menu1);
  readln;
end;

procedure MenuPilihan2 (var Menu2 : char);
{I.S. : user memasukkan nommor menu}
{F.S. : menghasilkan nomor menu}
begin
  Textcolor(white);
  gotoxy(38,10); write('================================================');
  gotoxy(38,11); write('|                Menu Pilihan 2                |');
  gotoxy(38,12); write('================================================');
  gotoxy(38,13); write('| 1. Daftar Nilai Mahasiswa Terurut NIM Asc.   |');
  gotoxy(38,14); write('| 2. Daftar Nilai Mahasiswa Terurut Nilai Dsc. |');
  gotoxy(38,15); write('| 3. Daftar IP Mahasiswa Terurut IP Dsc.       |');
  gotoxy(38,16); write('| 0. Kembali ke Menu Utama                     |');
  gotoxy(38,17); write('================================================');
  gotoxy(38,18); write('| Pilihan Anda ?                               |');
  gotoxy(38,19); write('================================================');
  gotoxy(55,18); read(Menu2);
  readln;
end;

procedure MenuPilihan3 (var Menu1 : char);
{I.S. : user memasukkan nommor menu}
{F.S. : menghasilkan nomor menu}
begin
  Textcolor(white);
  gotoxy(42,10); write('=======================================');
  gotoxy(42,11); write('|           Menu Pilihan 3            |');
  gotoxy(42,12); write('=======================================');
  gotoxy(42,13); write('| 1. Cari Data Mahasiswa              |');
  gotoxy(42,14); write('| 2. Cari Data Mata Kuliah            |');
  gotoxy(42,15); write('| 3. Cari Kartu Hasil Studi Mahasiswa |');
  gotoxy(42,16); write('| 0. Kembali ke Menu Utama            |');
  gotoxy(42,17); write('=======================================');
  gotoxy(42,18); write('| Pilihan Anda ?                      |');
  gotoxy(42,19); write('=======================================');
  gotoxy(59,18); read(Menu1);
  readln;
end;

procedure IsiDataNomor1(var Kelas : string; var N,M,Semester : integer; var DatMhs: DataMhs);
{I.S. : User memasukkan kelas, N(Jumlah Mahasiswa), M(Jumlah Matakuliah),
        Semester dan record data mahasiswa(1:N)}
{F.S. : Menghasilkan Kelas, N(Jumlah Mahasiswa), M(Jumlah Matakuliah,
        semester dan record data mahasiswa(1:N)}
var
 i : integer;
Begin
  textcolor(white);
  gotoxy(40,10); write('=======================================');
  gotoxy(40,11); write('|              Isi Data               |');
  gotoxy(40,12); write('=======================================');
  gotoxy(40,13); write('| Kelas                 |             |');
  gotoxy(40,14); write('---------------------------------------');
  gotoxy(40,15); write('| Semester              |             |');
  gotoxy(40,16); write('---------------------------------------');
  gotoxy(40,17); write('| Banyaknya Mahasiswa   |             |');
  gotoxy(40,18); write('---------------------------------------');
  gotoxy(40,19); write('| Banyaknya Mata Kuliah |             |');
  gotoxy(40,20); write('=======================================');
  gotoxy(66,13); read(Kelas);
  gotoxy(66,15); read(Semester);
  gotoxy(66,17); readln(N);
  while(N < 1 ) or (N > MaksMahasiswa) do
  begin
    textcolor(red);
    gotoxy(30,21); write('Banyaknya Mahasiswa Harus Antara 1 - ',MaksMahasiswa,', Ulangi Tekan Enter!');
    readln;
    gotoxy(30,21); clreol;
    gotoxy(66,17); write('    ');
    textcolor(white);
    gotoxy(66,17); readln(N);
  end;

  gotoxy(66,19); readln(M);
  while(M < 1 ) or (M > MaksMataKuliah) do
  begin
    textcolor(red);
    gotoxy(30,21); write('Banyaknya Mata Kuliah Harus Antara 1 - ',MaksMataKuliah,', Ulangi Tekan Enter!');
    readln;
    gotoxy(30,21); clreol;
    gotoxy(66,19); write('    ');
    textcolor(white);
    gotoxy(66,19); readln(M);
  end;

  clrscr;
  gotoxy(39,4); write('              Daftar Mahasiswa              ');
  gotoxy(39,6); write('Kelas/Semester : ',Kelas,'/',Semester);
  gotoxy(39,7); write('============================================');
  gotoxy(39,8); write('| No |   NIM    |      Nama Mahasiswa      |');
  gotoxy(39,9); write('============================================');
  for i := 1 to N do
  begin
    gotoxy(39,i+9); write('| ',i,'  |');gotoxy(55,i+9); write('|');
    gotoxy(82,i+9); write('|');
    gotoxy(46,i+9); readln(DatMhs[i].NIM);
    gotoxy(57,i+9); readln(DatMhs[i].Nama);
  end;
  gotoxy(39,i+10); write('============================================');
  textcolor(yellow);
  gotoxy(39,i+11); write('Tekan Enter Untuk Kembali Ke Menu Pilihan');
  textcolor(white);
  readln;
end;

procedure IsiDataNomor2(var DatMhs : DataMhs);
{I.S. : User memasukkan record data mata kuliah}
{F.S. : menghasilkan record data mata kuliah}
var
  j : integer;
Begin
  gotoxy(33,4); write('               Daftar Mata Kuliah                 ');
  gotoxy(33,6); write('Kelas/Semester : ',Kelas,'/',Semester);
  gotoxy(33,7); write('==================================================');
  gotoxy(33,8); write('| No | Kode Mata Kuliah | Nama Mata Kuliah | SKS |');
  gotoxy(33,9); write('==================================================');
  for j := 1 to M do
  begin
    gotoxy(33,j+9); write('| ',j);
    gotoxy(38,j+9); write('| '); gotoxy(57,j+9); write('|');
    gotoxy(76,j+9); write('|'); gotoxy(82,j+9); write('|');
    gotoxy(44,j+9); readln(DatMhs[j].KodeMatkul);
    gotoxy(59,j+9); readln(DatMhs[j].NamaMatkul);
    gotoxy(78,j+9); readln(DatMhs[j].SKS);
  end;
  gotoxy(33,j+10); write('==================================================');
  textcolor(yellow);
  gotoxy(33,j+11); write('Tekan Enter Untuk Kembali Ke Menu Pilihan');
  textcolor(white);
  readln;
end;

function Indeks(Nilai:integer):Char;
{I.S. : Nilai Sudah Terdefinisi}
{F.S. : Menghasilkan fungsi hitung indeks}
begin
  case (Nilai) of
   80..100 : indeks := 'A';
   70..79  : indeks := 'B';
   60..69  : indeks := 'C';
   50..59  : indeks := 'D';
   0..49   : indeks := 'E';
  end;
end;

function Bobot(Indeks:char):integer;
{I.S. : }
{F.S. : }
begin
  case (Indeks) of
    'A' : bobot := 4;
    'B' : bobot := 3;
    'C' : bobot := 2;
    'D' : bobot := 1;
    'E' : bobot := 0;
  end;
end;

procedure HitungIP(var DatMhs:DataMhs; var JumlahSKS:integer);
{I.S. : }
{F.S. : }
var
 j : integer;
 TampungNilai :integer;
begin
  for i := 1 to N do
  begin
  JumlahSKS:=0;
  tampungnilai :=0;
   for j := 1 to M do
    begin
      DatMhs[i].BobotNilai[j] := Bobot(DatMhs[i].IndeksNilai[j]);
      TampungNilai := TampungNilai + DatMhs[i].BobotNilai[j] * DatMHS[j].SKS;
      JumlahSKS:= JumlahSKS + DatMhs[j].SKS;
    end;//endfor
  DatMhs[i].TampungNilai := TampungNilai;
  DatMhs[i].IP := DatMhs[i].TampungNilai / JumlahSKS;

  end;

end;

procedure IsiDataNomor3(var DatMhs:DataMhs);
{I.S. : user memasukkan nilai mahasiswa untuk setiap mata kuliah}
{F.S. : menghasilkan indeks nilai mahasiswa dari tiap mata kuliah}
var
 i,j : integer;
Begin
  gotoxy(30,4); write('                    Daftar Nilai Mahasiswa                   ');
  for j := 1 to M do
  begin
    gotoxy(30,J*10-10+6); write('Kelas/Semester : ',Kelas,'/',Semester);
    gotoxy(30,J*10-10+7); write('Mata Kuliah    : ',DatMhs[j].NamaMatkul);
    gotoxy(30,J*10-10+8); write('=============================================================');
    gotoxy(30,J*10-10+9); write('| No |   NIM    |      Nama Mahasiswa      | Nilai | Indeks |');
    gotoxy(30,J*10-10+10);write('=============================================================');
    for i := 1 to N do
    begin
      gotoxy(30,J*10-10+i+10); write('| ',i,'  |');gotoxy(46,J*10-10+i+10); write('|');
      gotoxy(73,J*10-10+i+10); write('|'); gotoxy(81,J*10-10+i+10); write('|');
      gotoxy(90,J*10-10+i+10); write('|');
      gotoxy(37,J*10-10+i+10); write(DatMhs[i].NIM);
      gotoxy(48,J*10-10+i+10); write(DatMhs[i].Nama);
      gotoxy(76,J*10-10+i+10); readln(DatMhs[i].Nilai[j]);
        while (DatMhs[i].Nilai[j]<0) or (DatMhs[i].Nilai[j]>100) do
        begin
          textcolor(red);
          gotoxy(30,J*10-10+i+10+1); write('Nilai Harus Diantara 0 - 100, Ulangi Tekan Enter!');
          readln;
          gotoxy(30,J*10-10+i+10+1); clreol;
          gotoxy(76,J*10-10+i+10); write('   ');
          textcolor(white);
          gotoxy(76,J*10-10+i+10); readln(DatMhs[i].Nilai[j]);
        end;
        DatMhs[i].IndeksNilai[j] := Indeks(DatMhs[i].Nilai[j]);
        gotoxy(85,J*10-10+i+10); write(DatMhs[i].IndeksNilai[j]);
      end;

    gotoxy(30,J*10-10+i+11); write('=============================================================');
  end;
  textcolor(yellow);
  gotoxy(30,j*10-10+i+12); write('Tekan Enter Untuk Kembali Ke Menu Pilihan');
  textcolor(white);
  readln;
end;

procedure IsiTampil1(var k : integer; var DatMhs:DataMhs);
{I.S. :}
{F.S. :}
var
  j,i : integer;
  ketemu : boolean;
  CariMatkul : string;
  temp : DataMahasiswa;
Begin
  gotoxy(30,2); write('Mata Kuliah Yang Dicari : '); readln(CariMatkul);
  ketemu:= false;
  k:= 1;
  while(not ketemu) and (k <= M) do
  begin
    if(DatMhs[k].NamaMatkul = CariMatkul)
    then
      ketemu := true
    else
      k := k + 1;
  end;

  if(ketemu)then
  begin
   for i := 1 to (N-1) do
    for j := N downto (i+1) do
    begin
      if(DatMhs[j].NIM < DatMhs[j-1].NIM)
      then
      begin
        Temp := DatMhs[j];
        DatMhs[j] := DatMhs[j-1];
        DatMhs[j-1] := Temp;
      end; //endif
    end; //endfor
  end;
end;

procedure IsiTampilData1( var DatMhs:DataMhs; k:integer);
{I.S. : }
{F.S. : }
var
 i : integer;
begin
 gotoxy(30,4); write('     Daftar Nilai Mahasiswa Terurut NIM Secara Ascending     ');
 gotoxy(30,6); write('Kelas/Semester : ',Kelas,'/',Semester);
 gotoxy(30,7); write('Mata Kuliah    : ',DatMhs[k].NamaMatkul);
 gotoxy(30,8); write('=============================================================');
 gotoxy(30,9); write('| No |   NIM    |      Nama Mahasiswa      | Nilai | Indeks |');
 gotoxy(30,10);write('=============================================================');
 for i := 1 to N do
 begin
   gotoxy(30,i+10); write('| ',i,'  |');gotoxy(46,i+10); write('|');
   gotoxy(73,i+10); write('|'); gotoxy(81,i+10); write('|');
   gotoxy(90,i+10); write('|');
   gotoxy(37,i+10); write(DatMhs[i].NIM);
   gotoxy(48,i+10); write(DatMhs[i].Nama);
   gotoxy(76,i+10); write(DatMhs[i].Nilai[k]);
   gotoxy(85,i+10); write(DatMhs[i].IndeksNilai[k]);
 end;
 gotoxy(30,i+11);write('=============================================================');
 textcolor(yellow);
 gotoxy(30,i+12); write('Tekan Enter Untuk Kembali Ke Menu Pilihan');
 textcolor(white);
 readln;
end;

procedure IsiTampilData2(DatMhs:DataMhs; var k:integer);
{I.S. : }
{F.S. : }
var
 i : integer;
begin
 gotoxy(30,4); write('    Daftar Nilai Mahasiswa Terurut Nilai Secara Descending   ');
 gotoxy(30,6); write('Kelas/Semester : ',Kelas,'/',Semester);
 gotoxy(30,7); write('Mata Kuliah    : ',DatMhs[k].NamaMatkul);
 gotoxy(30,8); write('=============================================================');
 gotoxy(30,9); write('| No |   NIM    |      Nama Mahasiswa      | Nilai | Indeks |');
 gotoxy(30,10);write('=============================================================');
 for i := 1 to N do
 begin
   gotoxy(30,i+10); write('| ',i,'  |');gotoxy(46,i+10); write('|');
   gotoxy(73,i+10); write('|'); gotoxy(81,i+10); write('|');
   gotoxy(90,i+10); write('|');
   gotoxy(37,i+10); write(DatMhs[i].NIM);
   gotoxy(48,i+10); write(DatMhs[i].Nama);
   gotoxy(76,i+10); write(DatMhs[i].Nilai[k]);
   gotoxy(85,i+10); write(DatMhs[i].IndeksNilai[k]);
 end;
 gotoxy(30,i+11);write('=============================================================');
 textcolor(yellow);
 gotoxy(30,i+12); write('Tekan Enter Untuk Kembali Ke Menu Pilihan');
 textcolor(white);
 readln;
end;

procedure IsiTampil2(var DatMhs:DataMhs; var K:integer);
{I.S. :}
{F.S. :}
var
  j,i : integer;
  ketemu : boolean;
  CariMatkul : string;
  temp : DataMahasiswa;
Begin
  gotoxy(30,2); write('Mata Kuliah Yang Dicari : '); readln(CariMatkul);
  ketemu:= false;
  k:= 1;
  while(not ketemu) and (k <= M) do
  begin
    if(DatMhs[k].NamaMatkul = CariMatkul)
    then
      ketemu := true
    else
      k := k + 1;
  end;

  if(ketemu)then
  begin
   for i := 1 to (N-1) do
    for j := 1 to (N-1) do
    begin
      if(DatMhs[j].Nilai[k] < DatMhs[j+1].Nilai[k])
      then
      begin
        Temp := DatMhs[j];
        DatMhs[j] := DatMhs[j+1];
        DatMhs[j+1] := Temp
      end; //endif
    end; //endfor
  end;
end;

procedure IsiTampil3(var DatMhs:DataMhs);
{I.S. :}
{F.S. :}
var
  j,i : integer;
  temp : DataMahasiswa;
Begin
  for i := 1 to (N-1) do
    for j := i to (N-1) do
    begin
      if(DatMhs[j].IP < DatMhs[j+1].IP)
      then
      begin
        Temp := DatMhs[j];
        DatMhs[j] := DatMhs[j+1];
        DatMhs[j+1] := Temp
      end; //endif
    end; //endfor
end;

procedure IsiTampilData3(DatMhs:DataMhs);
{I.S. :}
{F.S. :}
var
 i : integer;
Begin
    gotoxy(30,4); write('       Daftar Indeks Prestasi (IP)  Mahasiswa        ');
    gotoxy(30,6); write('Kelas/Semester : ',Kelas,'/',Semester);
    gotoxy(30,8); write('=====================================================');
    gotoxy(30,9); write('| No |   NIM    |      Nama Mahasiswa      |   IP   |');
    gotoxy(30,10);write('=====================================================');
  for i := 1 to N do
  begin
   gotoxy(30,i+10); write('| ',i,'  |');gotoxy(46,i+10); write('|');
   gotoxy(73,i+10); write('|'); gotoxy(82,i+10); write('|');
   gotoxy(37,i+10); write(DatMhs[i].NIM);
   gotoxy(48,i+10); write(DatMhs[i].Nama);
   gotoxy(76,i+10); write(DatMhs[i].IP:0:2);
   gotoxy(30,i+11); write(JumlahSKS);

  end;
  gotoxy(30,i+11); write('=====================================================');
  readln;
end;

procedure MenuCariDataMahasiswa(var Menu2:char);
{I.S. :}
{F.S. :}
begin
  Textcolor(white);
  gotoxy(42,10); write('=======================================');
  gotoxy(42,11); write('|       Menu Cari Data Mahasiswa      |');
  gotoxy(42,12); write('=======================================');
  gotoxy(42,13); write('| 1. Cari NIM Mahasiswa               |');
  gotoxy(42,14); write('| 2. Cari Nama Mahasiswa              |');
  gotoxy(42,15); write('| 3. Cari Nilai Mahasiswa             |');
  gotoxy(42,16); write('| 0. Kembali ke Menu Utama            |');
  gotoxy(42,17); write('=======================================');
  gotoxy(42,18); write('| Pilihan Anda ?                      |');
  gotoxy(42,19); write('=======================================');
  gotoxy(59,18); read(Menu2);
  readln;
end;

procedure CariDataMhs1(DatMhs:DataMhs);
{I.S. : }
{F.S. : }
var
  ketemu : boolean;
  CariNim : Integer;
Begin
  gotoxy(30,3); write('NIM Yang di Cari : '); readln(CariNim);
  ketemu:= false;
  k:= 1;
  while(not ketemu) and (k <= N) do
  begin
    if(DatMhs[k].Nim = CariNim)
    then
      ketemu := true
    else
      k := k + 1;
  end;

  if(ketemu)then
  begin
  gotoxy(30,4); write('================================================================');
  gotoxy(30,5); write('|   NIM   |     Nama Mahasiswa     |  Kelas  | Semester |  IP  |');
  gotoxy(30,6); write('----------------------------------------------------------------');
  gotoxy(30,7); write('|         |                        |         |          |      |');
  gotoxy(30,8); write('================================================================');
  gotoxy(32,7); write(CariNim); gotoxy(42,7); write(DatMhs[k].Nama);
  gotoxy(68,7); write(Kelas); gotoxy (80,7); write(Semester);
  gotoxy(88,7); write(DatMhs[k].IP:0:2);
  textcolor(yellow);
  gotoxy(30,9); write('Tekan Enter Untuk Kembali ke Menu Cari Data Mahasiswa');
  textcolor(white);
  end
  else
  begin
  textcolor(red);
  gotoxy(30,4); write('NIM ',CariNim,' Tidak Ada');
  textcolor(yellow);
  gotoxy(30,5); write('Tekan Enter Untuk Kembali ke Menu Cari Data Mahasiswa');
  textcolor(white);
  end;
  readln;
end;

procedure CariDataMhs2(DatMhs:DataMhs);
{I.S. : }
{F.S. : }
var
  ketemu : boolean;
  CariNama : String;
Begin
  gotoxy(30,3); write('Nama Yang di Cari : '); readln(CariNama);
  ketemu:= false;
  k:= 1;
  while(not ketemu) and (k <= N) do
  begin
    if(DatMhs[k].Nama = CariNama)
    then
      ketemu := true
    else
      k := k + 1;
  end;

  if(ketemu)then
  begin
  gotoxy(30,4); write('================================================================');
  gotoxy(30,5); write('|   NIM   |     Nama Mahasiswa     |  Kelas  | Semester |  IP  |');
  gotoxy(30,6); write('----------------------------------------------------------------');
  gotoxy(30,7); write('|         |                        |         |          |      |');
  gotoxy(30,8); write('================================================================');
  gotoxy(32,7); write(DatMhs[k].Nim); gotoxy(42,7); write(CariNama);
  gotoxy(68,7); write(Kelas); gotoxy (80,7); write(Semester);
  gotoxy(88,7); write(DatMhs[k].IP:0:2);
  textcolor(yellow);
  gotoxy(30,9); write('Tekan Enter Untuk Kembali ke Menu Cari Data Mahasiswa');
  textcolor(white);
  end
  else
  begin
  textcolor(red);
  gotoxy(30,4); write('Nama ',CariNama,' Tidak Ada');
  textcolor(yellow);
  gotoxy(30,5); write('Tekan Enter Untuk Kembali ke Menu Cari Data Mahasiswa');
  textcolor(white);
  end;
  readln;
end;

procedure CariDataMhs3(DatMhs:DataMhs);
{I.S. :}
{F.S. :}
var
  i : integer;
  ketemu : boolean;
  CariMatkul : string;
  MaxNilai,MinNilai : integer;

Begin
  gotoxy(30,2); write('Mata Kuliah Yang Dicari     : '); readln(CariMatkul);
  gotoxy(30,3); write('Nilai Mahasiswa Yang Dicari :  Antara '); readln(MinNilai);
  gotoxy(70,3); write(' Sampai '); readln(MaxNilai);

  ketemu:= false;
  k:= 1;
  while(not ketemu) and (k <= N) do
  begin
    if(DatMhs[k].NamaMatkul = CariMatkul)
    then
      ketemu := true
    else
      k := k + 1;
  end;

  if(ketemu) then
  begin
  gotoxy(30,5); write('   Daftar Nilai Mahasiswa Antara ',MinNilai,' Sampai ',MaxNilai);
  gotoxy(30,6); write('                    Mata Kuliah ',CariMatkul);
  gotoxy(30,8); write('=============================================================');
  gotoxy(30,9); write('| No |   NIM    |      Nama Mahasiswa      | Nilai | Indeks |');
  gotoxy(30,10);write('=============================================================');
  for i := 1 to N do
  begin
    if(DatMhs[i].Nilai[K] >= MinNilai) and (DatMhs[i].Nilai[k] <= MaxNilai) then
    begin
    gotoxy(30,i+10); write('|'); gotoxy(35,i+10); write('|');
    gotoxy(46,i+10); write('|'); gotoxy(73,i+10); write('|');
    gotoxy(81,i+10); write('|'); gotoxy(90,i+10); write('|');
    gotoxy(32,i+10); write(i); gotoxy(37,i+10); write(DatMhs[i].NIM);
    gotoxy(48,i+10); write(DatMhs[i].Nama);
    gotoxy(76,i+10); write(DatMhs[i].Nilai[k]);
    gotoxy(85,i+10); write(DatMhs[i].IndeksNilai[k]);
    end;
  end;
  gotoxy(30,i+11); write('=============================================================');
  readln;
end;
end;


Procedure CariDataMatkul(DatMhs:DataMhs; var K: integer);
{I.S. :}
{F.S. :}
var
  ketemu : boolean;
  CariKodeMatkul : string;
Begin
  gotoxy(30,2); write('Kode Mata Kuliah Yang Dicari : '); readln(CariKodeMatkul);
  ketemu:= false;
  k:= 1;
  while(not ketemu) and (k <= M) do
  begin
    if(CariKodeMatkul = DatMhs[k].KodeMatkul)
    then
      ketemu := true
    else
      k := k + 1;
  end;

  if(ketemu)then
  begin
    gotoxy(30,3); write('==============================================================');
    gotoxy(30,4); write('| Kode Mata Kuliah |         Nama Mata Kuliah          | SKS |');
    gotoxy(30,5); write('--------------------------------------------------------------');
    gotoxy(30,6); write('|                  |                                   |     |');
    gotoxy(30,7); write('==============================================================');
    gotoxy(33,6); write(CariKodeMatkul);
    gotoxy(52,6); write(DatMhs[k].NamaMatkul);
    gotoxy(88,6); write(DatMhs[k].SKS);
    textcolor(yellow);
    gotoxy(30,8); write('Tekan Enter Untuk Kembali Ke Menu Cari Data');
    textcolor(white);
  end
  else
  begin
  gotoxy(30,4); write('Kode Mata Kuliah ',CariKodeMatkul,' Tidak Ada');
  textcolor(yellow);
  gotoxy(30,5); write('Tekan Enter Untuk Kembali Ke Menu Cari Data');
  textcolor(white);
  end;
  readln;
end;

procedure CariHasilStudi(DatMhs:DataMhs);
{I.S. : }
{F.S. : }
var
  i : integer;
  ketemu : boolean;
  CariNim : Integer;
Begin
  gotoxy(45,2); write('Kartu Hasil Studi Mahasiswa');
  gotoxy(15,3); write('NIM : '); readln(CariNim);
  ketemu:= false;
  k:= 1;
  while(not ketemu) and (k <= N) do
  begin
    if(DatMhs[k].Nim = CariNim)
    then
      ketemu := true
    else
      k := k + 1;
  end;

  If(ketemu)then
  begin
    gotoxy(15,4); write('Nama : ',DatMhs[k].Nama);
    gotoxy(15,5); write('Kelas/Semester : ',Kelas,'/',Semester,K);
    gotoxy(15,6); write('===============================================================================');
    gotoxy(15,7); write('|    Kode     |        Nama Mata Kuliah        | SKS | Indeks |  SKS x Bobot  |');
    gotoxy(15,8); write('| Mata Kuliah |                                |     | Nilai  |  Indeks Nilai |');
    gotoxy(15,9); write('-------------------------------------------------------------------------------');
    for i := 1 to M do
    begin
      gotoxy(15,i+9); write('|'); gotoxy(29,i+9); write('|'); gotoxy(62,i+9); write('|');
      gotoxy(68,i+9); write('|'); gotoxy(77,i+9); write('|'); gotoxy(93,i+9); write('|');
      gotoxy(17,i+9); write(DatMhs[i].KodeMatkul);
      gotoxy(31,i+9); write(DatMhs[i].NamaMatkul);
      gotoxy(65,i+9); write(DatMhs[i].SKS);
      gotoxy(70,i+9); write(DatMhs[i].IndeksNilai[k]);
      gotoxy(79,i+9); write(DatMhs[i].Sks * DatMhs[i].BobotNilai[k]);
    end;
    gotoxy(15,i+10); write('===============================================================================');
    gotoxy(15,i+11); write('Indeks Prestasi : ');
    textcolor(red);
    gotoxy(33,i+11); write(DatMhs[k].IP:0:2);
    textcolor(yellow);
    gotoxy(15,i+12); write('Tekan Enter Untuk Kembali Ke Menu');
    textcolor(white);
    readln;
  end;
end;

begin
   repeat
    clrscr;
    MenuPilihanUtama(Menu);
    case (Menu) of
     '1' : begin
             repeat
             clrscr;
             MenuPilihan1(Menu1);
             case (Menu1) of
               '1' : begin
                     clrscr;
                     IsiDataNomor1(Kelas,N,M,Semester,DatMhs);
                     end;

               '2' : begin
                     clrscr;
                     IsiDataNomor2(DatMhs);
                     end;

               '3' : begin
                     clrscr;
                     IsiDataNomor3(DatMhs);
                     end;

              end;
              until(Menu1='0');
           end;

     '2' : begin
             repeat
             clrscr;
             MenuPilihan2(Menu1);
             HitungIP(DatMhs,JumlahSKS);
             case (menu1) of
             '1' : begin
                     clrscr;
                     IsiTampil1(K,DatMhs);
                     IsiTampilData1(DatMhs,K);
                     end;

             '2' : begin
                     clrscr;
                     IsiTampil2(DatMhs,K);
                     IsiTampilData2(DatMhs,K);
                   end;

             '3' : begin
                     clrscr;
                     IsiTampil3(DatMhs);
                     IsiTampilData3(DatMhs);
                   end;
             end;
             until(Menu1='0');
           end;

     '3' : begin
             repeat
             clrscr;
             HitungIP(DatMhs,JumlahSKS);
             MenuPilihan3(Menu1);
             case (Menu1) of
             '1' : begin
                   repeat
                   clrscr;
                   MenuCariDataMahasiswa(menu2);
                   case (menu2) of
                   '1' : begin
                         clrscr;
                         CariDataMhs1(DatMhs);
                         end;

                   '2' : begin
                         clrscr;
                         CariDataMhs2(DatMhs);
                         end;

                   '3' : begin
                         clrscr;
                         CariDataMhs3(DatMhs);
                         end;
                   end;
                   until(menu2='0');



                   end;

             '2' : begin
                   clrscr;
                   CariDataMatkul(DatMhs,K);
                   end;

             '3' : begin
                   clrscr;
                   CariHasilStudi(DatMhs);
                   end;
             end;
             until(Menu1='0');
           end;
     end;
   until (Menu = '0');
end.

