program test;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.STL.Iterator,
  DSTL.Algorithm.Algorithm,
  DSTL.STL.List,
  DSTL.Exception;

var
  listStr: TList<String>;
  listInt: TList<integer>;

procedure writeStr(str: String);
begin
  writeln(str);
end;

procedure writeInt(int: integer);
begin
  write(int, ' ');
end;

procedure printStr;
var
  ia: TIterAlgorithms<String>;
begin
  if listStr.empty then exit;
  ia.for_each(listStr.start, listStr.finish, @writeStr);
  writeln;
end;

procedure printInt;
var
  ia: TIterAlgorithms<Integer>;
begin
  if listInt.empty then exit;
  ia.for_each(listInt.start, listInt.finish, @writeInt);
  writeln;
end;

begin
  listStr := TList<String>.Create;
  listStr.add(['Hello', 'world']);
  printStr;
  writeln('Remove ''Hello''');
  listStr.remove(['Hello']);
  printStr;
  writeln('Clear');
  listStr.clear;
  printStr;
  writeln('Sort test');
  listInt := TList<integer>.create;
  listInt.add([2,3,1,2,5,2,5,6,200,10]);
  writeln('Before sorting');
  printInt;
  listInt.sort;
  writeln('After sorting');
  printInt;
  readln;
end.
 