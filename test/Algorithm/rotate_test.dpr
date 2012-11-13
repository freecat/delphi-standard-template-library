program rotate_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

var
  v: TVector<integer>;
  i: integer;
begin
  try
    v := TVector<integer>.Create;
    for i := 1 to 9 do v.push_back(i);
    TIterAlgorithms<integer>.rotate(v.start, v.start + 3, v.finish);
                                                  // 4 5 6 7 8 9 1 2 3

    // print out content:
    write('myvector contains: ');
    for i := 0 to v.size - 1 do write(v[i], ' ');
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
