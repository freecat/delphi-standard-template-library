program for_each_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

procedure myfunc(i: integer);
begin
  write(i, ' ');
end;

var
  v: TVector<integer>;

begin
  try
    v := TVector<integer>.Create([10, 20, 30]);
    write('v contains: ');
    TIterAlgorithms<integer>.for_each(v.start, v.finish, myfunc);
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

