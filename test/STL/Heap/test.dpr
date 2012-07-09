program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
  DSTL.STL.Iterator,
  DSTL.STL.Vector,
  DSTL.STL.Heap;

procedure print_vec(v: TVector<integer>);
var
  i: integer;
begin
  for i := 0 to v.size - 1 do write(v[i]:3);
  writeln;
end;

procedure make_heap_test;
var
  v: TVector<integer>;
  i: integer;
  io: TIterOperations<integer>;
begin
  v := TVector<integer>.Create;
  v.push_back(10);
  v.push_back(20);
  v.push_back(30);
  v.push_back(5);
  v.push_back(15);

  THeapAlgorithms<integer>.make_heap(v.start,v.finish);
  writeln('initial max heap   : ', v.front);

  THeapAlgorithms<integer>.pop_heap (v.start,v.finish);
  v.pop_back;
  writeln('max heap after pop : ', v.front);

  v.push_back(99); THeapAlgorithms<integer>.push_heap (v.start,v.finish);
  writeln('max heap after push: ', v.front);

  THeapAlgorithms<integer>.sort_heap(v.start, v.finish);

  writeln('final sorted range :');
  print_vec(v);

  writeln;
end;

begin
  try
    make_heap_test;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
