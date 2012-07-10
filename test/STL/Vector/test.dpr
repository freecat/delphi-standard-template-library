program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  DSTL.STL.Vector,
  DSTL.STL.Iterator;

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
  printvec(myvector);    (* 300 300 400 400 200 100 100 100 *)
  writeln;
end;

procedure erase_test;
var
  i: integer;
  myvector: TVector<integer>;
begin
  writeln('erase test');
  myvector := TVector<integer>.Create;
  for i := 1 to 10 do
    myvector.push_back(i);

  myvector.erase(myvector.start + 5);
  myvector.erase(myvector.start, myvector.start + 3);

  printvec(myvector); (* 4 5 7 8 9 10 *)
  writeln;
end;

procedure swap_test;
var
  i: integer;
  first, second: TVector<integer>;
begin
  writeln('swap test');
  first := TVector<integer>.Create(5, 100);
  second := TVector<integer>.Create(3, 200);
  first.swap(second);
  write('first contains: '); printvec(first);
  write('second contains: '); printvec(second);
  writeln;
end;

begin
  assign_test;
  insert_test;
  erase_test;
  swap_test;
  readln;
end.
