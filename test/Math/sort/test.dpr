program test;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.Math.Sort, DSTL.Types, DSTL.Exception;

var
  a: array [0..10] of integer;
  sorter: TSorter<integer>;
  i: integer;
begin
  sorter := TSorter<integer>.Create;
  randomize;
  writeln('Before sorting');
  for i := 0 to 10 do
  begin
    a[i] := random(30000);
    write(a[i], ' ');
  end;
  sorter.QSort(a, 0, 10);
  writeln;
  writeln('After sorting');
  for i := 0 to 10 do
  begin
    write(a[i], ' ');
  end;
  readln;

end.
 