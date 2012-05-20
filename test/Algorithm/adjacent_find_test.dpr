program adjacent_find_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.Algorithm,
  DSTL.STL.Vector,
  DSTL.STL.Iterator;

var
  vec: TVector<integer>;
  it: TIterator<integer>;
  i: integer;

function myfunc(p1, p2: integer): boolean;
begin
  Result := p1 = p2;
end;

begin
  vec := TVector<integer>.Create;
  vec.push_back(10);
  vec.push_back(20);
  vec.push_back(30);
  vec.push_back(30);
  vec.push_back(20);
  vec.push_back(10);
  vec.push_back(10);
  vec.push_back(20);

  it := TIterAlgorithms<integer>.adjacent_find(vec.start, vec.finish);
  writeln('the first consecutive repeated elements are: ', integer(it));

  inc(it);
  it := TIterAlgorithms<integer>.adjacent_find(it, vec.finish, myfunc);
  writeln('the second consecutive repeated elements are: ', integer(it));

  readln;
end.
