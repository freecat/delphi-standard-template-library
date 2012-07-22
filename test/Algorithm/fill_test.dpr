program fill_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

var
  v: TVector<integer>;
  i: integer;
begin
  try
    v := TVector<integer>.Create();
    v.resize(8, 0);
    TIterAlgorithms<integer>.fill(v.start, v.start + 4, 5);
    TIterAlgorithms<integer>.fill(v.start + 3, v.finish - 2, 8);
    for i := 0 to v.size - 1 do
      write(v[i], ' ');
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

