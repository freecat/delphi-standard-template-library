program count_if_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

function is_odd(i: integer): boolean;
begin
  exit((i mod 2) = 1);
end;

var
  v: TVector<integer>;
begin
  try
    v := TVector<integer>.Create([1,2,3,4,5,6,7,8,9]);
    writeln('v contains ', TIterAlgorithms<integer>.count_if(v.start, v.finish, is_odd), ' odd values.');
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

