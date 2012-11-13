program next_permutation;

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
    v := TVector<integer>.Create([1,2,3]);
    repeat
      writeln(v[0], ' ', v[1], ' ', v[2]);
    until (not TIterAlgorithms<integer>.next_permutation(v.start, v.finish));
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
