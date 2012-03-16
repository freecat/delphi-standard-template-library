program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, DSTL.STL.TSet;

var
  s: TSet<String>;

begin
  try
    s := TSet<String>.Create;
    s.add('Hello');
    if s.includes('Hello') then writeln('s includes `Hello''')
    else writeln('s doesn''t include `hello''');
    if s.includes('world') then writeln('s includes `world''')
    else writeln('s doesn''t include `world''');
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
