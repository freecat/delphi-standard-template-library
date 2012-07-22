program find_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm,
  DSTL.STL.Iterator;

var
  v: TVector<integer>;
  it: TIterator<integer>;
begin
  try
    v := TVector<integer>.Create([10,20,30,40]);
    it := TIterAlgorithms<integer>.find(v.start, v.start + 4, 30);
    inc(it);
    writeln('The element following 30 is ', integer(it));
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

