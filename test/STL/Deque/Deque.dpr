program Deque;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  DSTL.STL.Deque,
  DSTL.STL.Iterator;

procedure printdeq(deq: TDeque<integer>);
var
  i: integer;
begin
  for i := 0 to deq.size - 1 do
    write(deq.items[i], ' ');
  writeln;
end;

procedure assign_test;
var
  first, second: TDeque<Integer>;
  it1, it2: TIterator<integer>;
begin
  writeln('assign test');
  first := TDeque<Integer>.Create;
  second := TDeque<Integer>.Create;

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
  mydeque, anotherdeq: TDeque<integer>;
  it: TIterator<integer>;
begin
  writeln('insert test');
  mydeque := TDeque<integer>.Create(3, 100);
  it := mydeque.start;
  it := mydeque.insert(it, 200);
  mydeque.insert(it, 2, 300);
  it := mydeque.start;
  inc(it); inc(it);
  anotherdeq := TDeque<integer>.Create(2, 400);
  mydeque.insert(it, anotherdeq.start, anotherdeq.finish);
  printdeq(mydeque);    (* 300 300 400 400 200 100 100 100 *)
  writeln;
end;

procedure erase_test;
var
  i: integer;
  mydeque: TDeque<integer>;
begin
  writeln('erase test');
  mydeque := TDeque<integer>.Create;
  for i := 1 to 10 do
    mydeque.push_back(i);

  mydeque.erase(mydeque.start + 5);
  mydeque.erase(mydeque.start, mydeque.start + 3);

  printdeq(mydeque); (* 4 5 7 8 9 10 *)
  writeln;
end;

procedure swap_test;
var
  i: integer;
  first, second: TDeque<integer>;
begin
  writeln('swap test');
  first := TDeque<integer>.Create(3, 100);
  second := TDeque<integer>.Create(5, 200);
  first.swap(second);
  write('first contains: '); printdeq(first);
  write('second contains: '); printdeq(second);
  writeln;
end;

begin
  assign_test;
  insert_test;
  erase_test;
  swap_test;
  readln;
end.
