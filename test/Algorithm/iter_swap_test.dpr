program iter_swap_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

var
  v1, v2: TVector<integer>;
  i: integer;
begin
  try
    v1 := TVector<integer>.Create([10,20,30,40,50]); //   myints:  10  20  30  40  50
    v2 := TVector<integer>.Create(4, 99);            // myvector:  99  99  99  99

    TIterAlgorithms<integer>.iter_swap(v1.start, v2.start);      //   myints: [99] 20  30  40  50
                                                                  // myvector: [10] 99  99  99

    TIterAlgorithms<integer>.iter_swap(v1.start + 3,v2.start+2);  //   myints:  99  20  30 [99]
                                                                  // myvector:  10  99 [40] 99

    for i := 0 to v2.size - 1 do write(v2[i]:3);
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
