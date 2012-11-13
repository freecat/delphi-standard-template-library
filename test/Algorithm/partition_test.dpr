program partition_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.STL.Iterator,
  DSTL.Algorithm;

var
  v: TVector<integer>;
  bound, it: TIterator<integer>;

function is_odd(i: integer): boolean;
begin
  exit((i mod 2) = 1);
end;

begin
  try
    v := TVector<integer>.Create([1,2,3,4,5,6,7,8,9]);
    bound := TIterAlgorithms<integer>.partition(v.start, v.finish, is_odd);
    it := v.start;
    write('odd numbers: ');
    while it <> bound do
    begin
      write(integer(it), ' ');
      inc(it);
    end;
    writeln;
    write('even numbers: ');
    while it <> v.finish do
    begin
      write(integer(it), ' ');
      inc(it);
    end;
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
