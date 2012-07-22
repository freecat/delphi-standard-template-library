program count_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

var
  v: TVector<integer>;
begin
  try
    v := TVector<integer>.Create([10,20,30,30,20,10,10,20]);
    writeln('20 appears ', TIterAlgorithms<integer>.count(v.start, v.finish, 20), ' times.');
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
