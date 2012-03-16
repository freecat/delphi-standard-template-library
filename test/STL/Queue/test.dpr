program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Queue;

var
  q: TQueue<Integer>;
begin
  try
    q := TQueue<Integer>.Create;
    q.push(1);
    q.push(10);
    writeln(q.front);
    q.pop;
    writeln(q.front);
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
