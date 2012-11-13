program reverse_test;

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
    TIterAlgorithms<integer>.reverse(v.start, v.finish);
                                                  //  9 8 7 6 5 4 3 2 1

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
