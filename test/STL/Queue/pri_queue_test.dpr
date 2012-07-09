program pri_queue_test;

{$APPTYPE CONSOLE}

uses
  SysUtils, DSTL.STL.Queues;

var
  mypq: TPriorityQueue<integer>;
begin
  try
    mypq := TPriorityQueue<integer>.Create;
    mypq.push(30);
    mypq.push(100);
    mypq.push(25);
    mypq.push(40);

    writeln('Popping out elements...');
    while ( not mypq.empty) do
    begin
      write(' ', mypq.top);
      mypq.pop;
    end;
    writeln;
    readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
