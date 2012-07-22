program includes_test;

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
    v1 := TVector<integer>.Create([5,10,15,20,25,30,35,40,45,50]);
    v2 := TVector<integer>.Create([40,30,20,10]);
    TIterAlgorithms<integer>.sort(v1.start, v1.finish);
    TIterAlgorithms<integer>.sort(v2.start, v2.finish);
    if TIterAlgorithms<integer>.includes(v1.start, v1.finish, v2.start, v2.finish) then
      writeln('v1 includes v2!');
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

