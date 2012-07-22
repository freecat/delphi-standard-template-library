program sort_test;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.STL.Iterator,
  DSTL.Algorithm,
  DSTL.STL.List,
  DSTL.Exception;

var
  l: TList<integer>;
  ia: TIterAlgorithms<Integer>;
  i: integer;

procedure print(int: integer);
begin
  write(int, ' ');
end;

begin
  writeln('Sort test');
  l := TList<integer>.create;
  randomize;
  for i := 1 to 1000 do l.push_back(random(30000));
  writeln('Before sorting:');
  ia.for_each(l.start, l.finish, @print);
  l.sort;
  writeln;
  writeln('After sorting:');
  ia.for_each(l.start, l.finish, @print);
  writeln;
  readln;
end.
