program test;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.Crypto.MD5;

begin
  try
    writeln(MD5Print(MD5String('This is a test')));
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
