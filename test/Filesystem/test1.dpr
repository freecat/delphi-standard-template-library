program test1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.Filesystem.Filesystem;

var
  f: textFile;
begin
  create_file('D:\test.txt');
  writeln('''D:\test.txt'' created.');
  assignFile(f, 'D:\test.txt');
  rewrite(f);
  writeln(f, 'This is a test');
  closeFile(f);
  copy('D:\test.txt', 'D:\test1.txt');
  writeln('Copy ''D:\test.txt'' -> ''D:\test1.txt''');
  if file_exists('D:\test.txt') then writeln('File ''D:\test.txt'' exists');
  if not is_empty('D:\test.txt') then writeln('File ''D:\test.txt'' is not empty');
  writeln('size of ''D:\test.txt'' = ', file_size('D:\test.txt'));
  remove('D:\test.txt');
  writeln('''D:\test.txt'' removed');
  remove('D:\test1.txt');
  writeln('''D:\test1.txt'' removed');
  readln;
end.
