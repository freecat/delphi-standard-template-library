program find_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.Algorithm,
  DSTL.STL.Iterator,
  DSTL.STL.Vector;

var
  vec: TVector<integer>;
  it: TIterator<integer>;
  i: integer;

begin
  vec := TVector<integer>.Create;
  for i := 1 to 4 do vec.push_back(i * 10);
  it := TIterAlgorithms<integer>.find(vec.start, vec.finish, 30);
  inc(it);
  writeln('The element following 30 is ', integer(it));
  readln;
end.
