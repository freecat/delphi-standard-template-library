program find_first_of_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.Algorithm,
  DSTL.STL.Iterator;

function comp_case_insensitive(a, b: char): boolean;
begin
  exit(upcase(a) = upcase(b));
end;

var
  v1, v2: TVector<char>;
  it: TIterator<char>;
begin
  try
    v1 := TVector<char>.Create(['a','b','c','A','B','C']);
    v2 := TVector<char>.Create(['A', 'B', 'C']);
    it := TIterAlgorithms<char>.find_first_of(v1.start, v1.finish, v2.start, v2.finish);
    if (it <> v1.finish) then writeln('first match is ', char(it));
    it := TIterAlgorithms<char>.find_first_of(v1.start, v1.finish, v2.start, v2.finish, comp_case_insensitive);
    if (it <> v1.finish) then writeln('first match is ', char(it));
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
