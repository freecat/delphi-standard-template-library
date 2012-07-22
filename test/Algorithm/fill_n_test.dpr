program fill_n_test;

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
    v.resize(8, 10);
    TIterAlgorithms<integer>.fill_n(v.start, 4, 20);
    TIterAlgorithms<integer>.fill_n(v.start + 3, 3, 33);
    for i := 0 to v.size - 1 do
      write(v[i], ' ');
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

