program sort_test;

{$APPTYPE CONSOLE}

uses
  SysUtils, DSTL.STL.Vector, DSTL.Algorithm, DSTL.Utils.StopWatch;

var
  v: TVector<integer>;
  i: integer;
  sw: TStopWatch;
begin
  randomize;
  v := TVector<integer>.Create;
  for i := 1 to 5000 do v.push_back(random(2147483647));

  sw := TStopWatch.Create;
  sw.start;
  TIterAlgorithms<integer>.sort(v.start, v.finish);
  sw.stop;

  for i := 0 to v.size - 1 do
  begin
    write(v[i],' ');
    if i mod 6 = 0  then  writeln;
  end;
  writeln;
  writeln('In ', sw.elapsedSec:0:5, ' second(s).');
  readln;
end.
