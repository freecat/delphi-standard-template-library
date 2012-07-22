program binary_search_test;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

function myfunction(i, j: integer): integer;
begin
  if i < j then exit(-1) else if i = j then exit(0) else if i > j then exit(1);
end;

var
  v: TVector<integer>; i: integer;

begin
  v := TVector<integer>.Create([1,2,3,4,5,4,3,2,1]);

  // using default comparison:
  TIterAlgorithms<integer>.sort(v.start, v.finish);

  write('looking for a 3... ');
  if (TIterAlgorithms<integer>.binary_search (v.start, v.finish, 3)) then
    writeln('found!')
  else writeln('not found.');

  // using myfunction as comp:
  TIterAlgorithms<integer>.sort(v.start, v.finish, myfunction);

  write('looking for a 6... ');
  if (TIterAlgorithms<integer>.binary_search (v.start, v.finish, 6)) then
    writeln('found!')
  else writeln('not found.');
  readln;
end.
