program lexicographical_compare_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm;

function comp(a, b: char): integer;
begin
  a := lowcase(a);
  b := lowcase(b);
  if a > b then exit(1) else if a < b then exit(-1) else exit(0);
end;

var
  v1, v2: TVector<char>;

begin
  try
    v1 := TVector<char>.Create(['A', 'p', 'p', 'l', 'e']);
    v2 := TVector<char>.Create(['a', 'p', 'a', 'r', 't', 'm', 'e', 'n', 't']);
    write('Using default comparison: ');
    if TIterAlgorithms<char>.lexicographical_compare(v1.start, v1.finish, v2.start, v2.finish) then
      writeln('Apple is less than apartment')
    else if TIterAlgorithms<char>.lexicographical_compare(v2.start, v2.finish, v1.start, v1.finish) then
      writeln('Apple is greater than apartment')
    else writeln('Apple and apartment are equivalent');

    write('Using comp as comparison: ');
    if TIterAlgorithms<char>.lexicographical_compare(v1.start, v1.finish, v2.start, v2.finish, comp) then
      writeln('Apple is less than apartment')
    else if TIterAlgorithms<char>.lexicographical_compare(v2.start, v2.finish, v1.start, v1.finish, comp) then
      writeln('Apple is greater than apartment')
    else writeln('Apple and apartment are equivalent');
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
