program find_if_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.STL.Iterator,
  DSTL.Algorithm;

function is_odd(i: integer): boolean;
begin
  exit((i mod 2) = 1);
end;

var
  v: TVector<integer>;
  it: TIterator<integer>;
begin
  try
    v := TVector<integer>.Create([10, 25, 40, 55]);
    it := TIterAlgorithms<integer>.find_if(v.start, v.finish, is_odd);
    writeln('The first odd value is ', integer(it));
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
