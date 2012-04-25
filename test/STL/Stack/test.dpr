program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Stack;

var
  s: TStack<Integer>;
  i: integer;

begin
  try
    s := TStack<integer>.Create;
    for i := 1 to 5 do
    begin
      s.push(i);
    end;
    writeln(s.size);
    while not s.empty do
    begin
      writeln(s.top);
      s.pop;
    end;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
