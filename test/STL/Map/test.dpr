program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, DSTL.STL.Maps, DSTL.Utils.Pair, DSTL.STL.Iterator, DSTL.Exception;

procedure printmap(m: TMap<char, integer>);
var
  it: TIterator<char, integer>;
begin
  it := m.start;
  while it <> m.finish do
  begin
    writeln(TPair<char, integer>(it).first, ' => ', TPair<char, integer>(it).second);
    inc(it);
  end;
end;

procedure insert_test;
var
  mymap, anothermap: TMap<char, integer>;
  it: TIterator<char, integer>;
  ret: TPair<TIterator<char, integer>, boolean>;
begin
  mymap := TMap<char, integer>.Create;
  anothermap := TMap<char, integer>.Create;
  writeln('insert test');

  // first insert function version (single parameter):
  mymap.insert (TPair<char,integer>.Create('a',100) );
  mymap.insert (TPair<char,integer>.Create('z',200) );
  ret := mymap.insert (TPair<char,integer>.Create('z',500) );
  if ret.second = false then
  begin
    writeln('element ''z'' already existed');
    writeln('with a value of ', TPair<char,integer>(ret.first).second);
  end;

  // second insert function version (with hint position):
  it := mymap.start;
  //mymap.insert (it, TPair<char,integer>.Create('b',300));  // max efficiency inserting
  //mymap.insert (it, TPair<char,integer>.Create('c',400));  // no max efficiency inserting

  // third insert function version (range insertion):
  //anothermap.insert(mymap.start, mymap.find('c'));

  writeln('mymap contains: ');
  printmap(mymap);
  writeln('anothermap contains: ');
  printmap(anothermap);
end;

begin
  insert_test;
  readln;
end.
