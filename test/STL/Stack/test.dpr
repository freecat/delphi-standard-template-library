program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Stack;

var
  s: TStack<Integer>;

begin
  try
    s := TStack<Integer>.Create;
    s.push(1);
    s.push(10);
    writeln(s.top);
    s.pop;
    writeln(s.top);
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
