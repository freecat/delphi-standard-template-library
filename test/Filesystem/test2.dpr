program test2;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  DSTL.Filesystem.Filesystem;

var
  di: TDriveInfo;
begin
  di := TDriveInfo.Create('C:\');
  writeln('Info of drive C:');
  writeln('Drive type: ', di.DriveTypeString);
  writeln('Drive format: ', di.DriveFormat);
  writeln('Drive name: ', di.Name);
  writeln('Drive size: ', di.TotalSize div 1024 div 1024 div 1024 ,' GB');
  writeln('Drive free space: ', di.TotalFreeSpace div 1024 div 1024 div 1024 ,' GB');
  readln;
end.
