program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, DSTL.STL.Map, DSTL.Utils.Pair;

var
  m: TMap<String, Real>;

begin
  try
    m := TMap<String, Real>.Create;
    m.add(TPair<String, Real>.Create('pi', pi));
    writeln(m.get_at('pi').second);
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
