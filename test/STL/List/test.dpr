program test;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.STL.Iterator,
  DSTL.Algorithm,
  DSTL.STL.List;

procedure writeint(int: integer);
begin
  write(int, ' ');
end;

procedure printlist(l: TList<integer>);
var
  ia: TIterAlgorithms<Integer>;
begin
  if l.empty then exit;
  ia.for_each(l.start, l.finish, @writeint);
  writeln;
end;

procedure writereal(r: real);
begin
  write(r, ' ');
end;

procedure printrlist(l: TList<real>);
var
  ia: TIterAlgorithms<real>;
begin
  ia := TIterAlgorithms<Real>.Create;
  if l.empty then exit;
  ia.for_each(l.start, l.finish, @writereal);
  writeln;
end;

procedure assign_test;
var
  first, second: TList<integer>;
begin
  writeln('assign test');

  first := TList<integer>.Create;
  second := TList<integer>.Create;

  first.assign(7,100);                      // 7 ints with value 100
  second.assign(first.start, first.finish); // a copy of first

  write('first: ');
  printlist(first);
  write('second: ');
  printlist(second);
  writeln;
end;

procedure insert_test;
var
  mylist: TList<integer>;
  it: TIterator<integer>;
  i: integer;
begin
  mylist := TList<integer>.Create;

  writeln('insert test');
  for i := 1 to 5 do
    mylist.push_back(i);

  writeln('before inserting');
  printlist(mylist);

  it := mylist.start;
  inc(it);

  mylist.insert(it,10);                        // 1 10 2 3 4 5

  mylist.insert (it,2,20);                      // 1 10 20 20 2 3 4 5

  writeln('after inserting');
  printlist(mylist);
  writeln;
end;

procedure erase_test;
var
  mylist: TList<integer>;
  it1, it2: TIterator<integer>;
  i: integer;
begin
  mylist := TList<integer>.Create;

  writeln('erase test');
  for i := 1 to 9 do
    mylist.push_back(i * 10);

  writeln('before erasing');
  printlist(mylist);

  it1 := mylist.start;
  it2 := mylist.start;
  for i := 1 to 6 do inc(it2);
  inc(it1);

  it1 := mylist.erase(it1);   // 10 30 40 50 60 70 80 90
                              //    ^           ^

  it2 := mylist.erase(it2);   // 10 30 40 50 60 80 90
                              //    ^           ^

  inc(it1);
  dec(it2);

  mylist.erase (it1,it2);     // 10 30 60 80 90
                              //        ^

  writeln('after erasing');
  printlist(mylist);
  writeln;
end;

procedure swap_test;
var
  first, second: TList<integer>;
begin
  writeln('swap test');

  first := TList<integer>.Create(3, 100);
  second := TList<integer>.Create(5, 200);

  writeln('before swaping');
  write('first: ');
  printlist(first);
  write('second: ');
  printlist(second);

  first.swap(second);

  writeln('before swaping');
  write('first: ');
  printlist(first);
  write('second: ');
  printlist(second);
  writeln;
end;

procedure splice_test;
var
  mylist1, mylist2: TList<integer>;
  it, it1, it2: TIterator<integer>;
  i: integer;
begin
  mylist1 := TList<integer>.Create;
  mylist2 := TList<integer>.Create;

  writeln('splice test');
  for i := 1 to 4 do
    mylist1.push_back(i);
  for i := 1 to 3 do
    mylist2.push_back(i * 10);

  writeln('before splicing');
  printlist(mylist1);

  it := mylist1.start;
  inc(it);                        // points to 2

  mylist1.splice(it, mylist2); // mylist1: 1 10 20 30 2 3 4
                                // mylist2 (empty)
                                // "it" still points to 2 (the 5th element)

  it1 := mylist2.start;
  mylist2.splice(it1, mylist1, it);
                                // mylist1: 1 10 20 30 3 4
                                // mylist2: 2
                                // "it" is now invalid.
  it := mylist1.start;
  for i := 1 to 3 do
    inc(it);                // "it" points now to 30

  it1 := mylist1.start;
  it2 := mylist1.finish;
  mylist1.splice(it1, mylist1, it, it2);
                               // mylist1: 30 3 4 1 10 20

  writeln('after splicing');
  printlist(mylist1);
  writeln;
end;

procedure remove_test;
var
  mylist: TList<integer>;
begin
  writeln('remove test');
  mylist := TList<integer>.Create;

  mylist.push_back(17);
  mylist.push_back(89);
  mylist.push_back(7);
  mylist.push_back(14);
  writeln('before removing');
  printlist(mylist);

  mylist.remove(89);

  writeln('after removing');
  printlist(mylist);

  writeln;
end;

procedure remove_if_test;
  function single_digit(p: integer): boolean;
  begin
    Result := p < 10;
  end;

  function is_odd(p: integer): boolean;
  begin
    Result := (p mod 2) = 1;
  end;
var
  mylist: TList<integer>;
begin
  writeln('remove_if test');
  mylist := TList<integer>.Create;

  mylist.push_back(15);
  mylist.push_back(36);
  mylist.push_back(7);
  mylist.push_back(17);
  mylist.push_back(20);
  mylist.push_back(39);
  mylist.push_back(4);
  mylist.push_back(1);
  writeln('before removing');
  printlist(mylist);                // 15 36 7 17 20 39 4 1

  mylist.remove_if(@single_digit);  // 15 36 17 20 39
  mylist.remove_if(@is_odd);        // 36 20

  writeln('after removing');
  printlist(mylist);

  writeln;
end;

procedure unique_test;
  function same_integral_part(p1, p2: real): boolean;
  begin
    Result := trunc(p1) = trunc(p2);
  end;

  function is_near(p1, p2: real): boolean;
  begin
    Result := abs(p1 - p2) < 5;
  end;
var
  mylist: TList<real>;
begin
  writeln('unique test');
  mylist := TList<real>.Create;

  mylist.push_back(12.15);
  mylist.push_back(2.72);
  mylist.push_back(73.0);
  mylist.push_back(12.77);
  mylist.push_back(3.14);
  mylist.push_back(12.77);
  mylist.push_back(73.35);
  mylist.push_back(72.25);
  mylist.push_back(15.3);
  mylist.push_back(72.25);
  writeln('before unique');
  printrlist(mylist);                // 15 36 7 17 20 39 4 1

  mylist.sort;
  mylist.unique;
  mylist.unique(@same_integral_part);
  mylist.unique(@is_near);

  writeln('after unique');
  printrlist(mylist);

  writeln;
end;

procedure reverse_test;
var
  mylist: TList<integer>;
  it: TIterator<integer>;
  i: integer;
begin
  mylist := TList<integer>.Create;

  writeln('reverse test');
  for i := 1 to 10 do
    mylist.push_back(i);

  writeln('before reversing');
  printlist(mylist);

  mylist.reverse();

  writeln('after reversing');
  printlist(mylist);
  writeln;
end;

begin
  assign_test;
  insert_test;
  erase_test;
  swap_test;
  splice_test;
  remove_test;
  remove_if_test;
  //unique_test;
  reverse_test;
  readln;
end.
 