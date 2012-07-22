program find_end;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm,
  DSTL.STL.Iterator;

var
  v1, v2, v3: TVector<integer>;
  it: TIterator<integer>;
begin
  try
    v1 := TVector<integer>.Create([1,2,3,4,5,1,2,3,4,5]);
    v2 := TVector<integer>.Create([1,2,3]);
    it := TIterAlgorithms<integer>.find_end(v1.start, v1.finish, v2.start, v2.finish);
    writeln('v2 last found at position ', it - v1.start);
    v3 := TVector<integer>.Create([4, 5, 1]);
    it := TIterAlgorithms<integer>.find_end(v1.start, v1.finish, v3.start, v3.finish);
    writeln('v3 last found at position ', it - v1.start);
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

