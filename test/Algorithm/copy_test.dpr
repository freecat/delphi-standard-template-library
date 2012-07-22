program copy_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

var
  i: integer;
  v1, v2: TVector<integer>;
begin
  try
    v1 := TVector<integer>.Create([10,20,30,40,50,60,70,80]);
    v2 := TVector<integer>.Create;
    v2.resize(v1.size);
    TIterAlgorithms<integer>.copy(v1.start, v1.finish, v2.start);
    for i := 0 to v2.size - 1 do
      write(v2[i],' ');
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
