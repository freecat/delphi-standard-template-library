program test;

{$APPTYPE CONSOLE}

uses
  SysUtils, DSTL.Algorithm.StringAlgorithm;

begin
  writeln(to_upper('hello, world'));
  writeln(to_lower('HELLO, WORLD'));
  readln;
end.
 