program test2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.Algorithm.Algorithm;

var
  minMax: TMinMax<integer>;
begin
  try
    writeln(minMax.min([3, 2, 4, 6, 3, 2, 3, 1, 4]));
    writeln(minMax.max([3, 2, 4, 6, 3, 2, 3, 1, 4]));
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
