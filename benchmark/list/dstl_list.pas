program list_pushback;
{$APPTYPE CONSOLE}
uses
  DSTL.STL.List, DSTL.Utils.Stopwatch;

var
  sw: TStopWatch;

procedure pushback_test;
var
  l: TList<integer>;
  i: integer;
begin
  l := TList<integer>.Create;
  sw.start;
  for i := 1 to 1000000 do
  begin
    l.push_back(i);
  end;
  sw.stop;
  writeln('pushing 1000000 elements into a list takes: ', sw.elapsedMSec:0:2, 'ms');
end;

procedure sort_test;
var
  l: TList<integer>;
  i: integer;
begin
  l := TList<integer>.Create;
  for i := 1 to 1000 do
  begin
    l.push_back(random(30000));
  end;
  sw.start;
  l.sort;
  sw.stop;
  writeln('pushing 1000000 elements into a list takes: ', sw.elapsedMSec:0:2, 'ms');
end;

begin
  sw := TStopWatch.Create;
  pushback_test;
  sort_test;
end.