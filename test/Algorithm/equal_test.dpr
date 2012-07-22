program equal_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

var
  v1, v2: TVector<integer>;
begin
  try
    v1 := TVector<integer>.Create([20, 40, 60, 80]);
    v2 := TVector<integer>.Create(v1);
    if TIterAlgorithms<integer>.equal(v1.start, v1.finish, v2.start) then
      writeln('The contents of both sequences are equal.')
    else
      writeln('The contents of both sequences differ.');

    v2[3] := 81;
    if TIterAlgorithms<integer>.equal(v1.start, v1.finish, v2.start) then
      writeln('The contents of both sequences are equal.')
    else
      writeln('The contents of both sequences differ.');
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

