program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Vector,
  DSTL.STL.Iterator;

var
  v: TVector<integer>;

procedure printvec(vec: TVector<integer>);
var
  i: integer;
begin
  for i := 0 to vec.size - 1 do
    write(vec.items[i], ' ');
  writeln;
end;

procedure assign_test;
var
  first, second: TVector<Integer>;
  it1, it2: TIterator<integer>;
begin
  writeln('assign test');
  first := TVector<Integer>.Create;
  second := TVector<Integer>.Create;

  first.assign(7, 100);

  it1 := first.start;
  inc(it1);
  it2 := first.finish;
  dec(it2);
  second.assign(it1, it2);

  writeln('Size of first: ', first.size);
  writeln('Size of second: ', second.size);
  writeln;
end;

procedure insert_test;
var
  myvector, anothervec: TVector<integer>;
  it: TIterator<integer>;
begin
  writeln('insert test');
  myvector := TVector<integer>.Create(3, 100);
  it := myvector.start;
  it := myvector.insert(it, 200);
  myvector.insert(it, 2, 300);
  it := myvector.start;
  inc(it); inc(it);
  anothervec := TVector<integer>.Create(2, 400);
  myvector.insert(it, anothervec.start, anothervec.finish);
  printvec(myvector);
end;

procedure erase_test;
begin

end;

begin
  assign_test;
  insert_test;
  readln;
end.
