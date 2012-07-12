program sort_test;

{$APPTYPE CONSOLE}

uses
  SysUtils, DSTL.STL.Vector, DSTL.Algorithm;

var
  v: TVector<integer>;
  i: integer;
begin
  v := TVector<integer>.Create([32,71,12,45,26,80,53,33]);
  TIterAlgorithms<integer>.sort(v.start, v.finish);

  for i := 0 to v.size - 1 do  write(v[i]:3);
  writeln;
  readln;
end.
