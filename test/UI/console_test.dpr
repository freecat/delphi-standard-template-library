program console_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.UI.Console,
  Windows;

begin
  TextColor(FOREGROUND_RED);
  writeln('This is red');
  TextColor(FOREGROUND_GREEN);
  writeln('This is green');
  TextColor(FOREGROUND_BLUE);
  writeln('This is blue');
  TextColor(FOREGROUND_INTENSITY);
  writeln('This is normal');
  readln;
end.
