program sort_test;

{$APPTYPE CONSOLE}

uses
  SysUtils, DSTL.STL.Vector, DSTL.Algorithm;

var
  v: TVector<integer>;
  i: integer;
begin
  randomize;
  v := TVector<integer>.Create;
  for i := 1 to 6000 do v.push_back(random(2147483647));
  TIterAlgorithms<integer>.sort(v.start, v.finish);

  for i := 0 to v.size - 1 do
  begin
    write(v[i],' ');
    if i mod 6 = 0  then  writeln;
  end;
  writeln;
  readln;
end.
