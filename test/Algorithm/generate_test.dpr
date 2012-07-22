program generate_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

function gen: integer;
begin
  exit(random(30000));
end;

var
  v: TVector<integer>;
  i: integer;

begin
  try
    randomize;
    v := TVector<integer>.Create(8, 0);
    TIterAlgorithms<integer>.generate(v.start, v.finish, gen);
    for i := 0 to v.size - 1 do
      write(v[i], ' ');
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

