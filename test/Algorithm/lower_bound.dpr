program lower_bound;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm,
  DSTL.STL.Iterator;

var
  v: TVector<integer>;
  up, low: TIterator<integer>;
begin
  try
    v := TVector<integer>.Create([10,20,30,30,20,10,10,20]);

    TIterAlgorithms<integer>.sort(v.start, v.finish);                   // 10 10 10 20 20 20 30 30

    low := TIterAlgorithms<integer>.lower_bound(v.start, v.finish, 20); //          ^
    //up := TIterAlgorithms<integer>.upper_bound(v.start, v.finish, 20);   //                   ^

    writeln('lower_bound at position ', low - v.start);
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
