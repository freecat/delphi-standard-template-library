unit DSTL.UI.Console;

interface

uses Windows;

procedure TextColor(color: word);

implementation

procedure TextColor(color: word);
var
  ConsoleHWND: HWND;
begin
  ConsoleHWND := GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(ConsoleHWND, color);
end;

end.
