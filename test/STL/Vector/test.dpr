program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector;

var
  v: TVector<integer>;

begin
  try
    v := TVector<Integer>.Create;
    v.assign(10, 123);
    writeln(v.items[0]);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
