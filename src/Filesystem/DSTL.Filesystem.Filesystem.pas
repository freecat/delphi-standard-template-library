{ *******************************************************************************
  *                                                                             *
  *          Delphi Standard Template Library                                   *
  *                                                                             *
  *          (C)Copyright Jimx 2011                                             *
  *                                                                             *
  *          http://delphi-standard-template-library.googlecode.com             *
  *                                                                             *
  *******************************************************************************
  *  This file is part of Delphi Standard Template Library.                     *
  *                                                                             *
  *  Delphi Standard Template Library is free software:                         *
  *  you can redistribute it and/or modify                                      *
  *  it under the terms of the GNU General Public License as published by       *
  *  the Free Software Foundation, either version 3 of the License, or          *
  *  (at your option) any later version.                                        *
  *                                                                             *
  *  Delphi Standard Template Library is distributed                            *
  *  in the hope that it will be useful,                                        *
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of             *
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
  *  GNU General Public License for more details.                               *
  *                                                                             *
  *  You should have received a copy of the GNU General Public License          *
  *  along with Delphi Standard Template Library.                               *
  *  If not, see <http://www.gnu.org/licenses/>.                                *
  ******************************************************************************* }
unit DSTL.Filesystem.Filesystem;

interface

uses Windows, SysUtils, Classes, DSTL.Exception,
  Generics.Collections, Generics.Defaults;

type
{$REGION 'TFileOperations'}
  TFileOperations = class
    procedure Copy(src, dst: string);
    procedure CreateFile(path: string);
    procedure CreateDirectory(path: string);
    function CurrentPath: string;
    function FileExists(path: string): boolean;
    function FileSize(path: string): longint;
    function IsEmpty(path: string): boolean;
    procedure Remove(path: string);
    procedure Rename(path, newname: string);
  end;

{$ENDREGION}
{$REGION 'TDriveInfo'}

  TDriveType = (dtNoRootDirectory, dtRemovable, dtFixed, dtNetwork, dtCDRom,
    dtRam, dtUnknown);

  TDriveInfo = class
  protected
    fDriveName: string;
    fRootDir: string;
    fDriveType: TDriveType;
    fAvailableFreeSpace: Int64;
    fTotalSize: Int64;
    fTotalFreeSpace: Int64;
    fVolumeName: array [0 .. MAX_PATH] of Char;
    fFileSystemName: array [0 .. MAX_PATH] of Char;
    fSerialNumber: DWORD;
    fMaximumComponentLength: DWORD;
    fFileSystemFlags: DWORD;
    function GetAvailableFreeSpace: Int64;
    function GetDriveFormat: string;
    function GetDriveType: TDriveType;
    function GetDriveTypeString: string;
    function GetTotalFreeSpace: Int64;
    function GetTotalSize: Int64;
    function GetVolumeLabel: string;
    procedure SetVolumeLabel(const Value: string);
  private
    procedure update;
  public
    constructor Create(driveName: string);
    destructor Destory;
    function GetDrive: TArray<TDriveInfo>;
    property AvailableFreeSpace: Int64 read GetAvailableFreeSpace;
    property DriveFormat: string read GetDriveFormat;
    property DriveType: TDriveType read GetDriveType;
    property DriveTypeString: string read GetDriveTypeString;
    property Name: string read fDriveName;
    property RootDirectory: string read fRootDir;
    property TotalFreeSpace: Int64 read GetTotalFreeSpace;
    property TotalSize: Int64 read GetTotalSize;
    property VolumeLabel: string read GetVolumeLabel write SetVolumeLabel;
  end;

const
  SysDriveType = [DRIVE_NO_ROOT_DIR, DRIVE_REMOVABLE, DRIVE_FIXED, DRIVE_REMOTE,
    DRIVE_CDROM, DRIVE_RAMDISK];

  DriveTypeStrings: array [TDriveType] of string = ('No Root Directory',
    'Removable', 'Fixed', 'Network', 'CDROM', 'RAMDisk', 'Unknown');
{$ENDREGION}

implementation

{$REGION 'TFileOperations'}

procedure TFileOperations.Copy(src, dst: string);
var
  s, d: TFileStream;
begin
  s := TFileStream.Create(src, FMOPENREAD);
  d := TFileStream.Create(dst, FMOPENWRITE or FMCREATE);
  d.CopyFrom(s, s.Size);
  d.Free;
  s.Free;
end;

procedure TFileOperations.CreateFile(path: string);
var
  f: textFile;
begin
  assignFile(f, path);
  rewrite(f);
  closeFile(f);
end;

procedure TFileOperations.CreateDirectory(path: string);
begin
  mkdir(path);
end;

function TFileOperations.CurrentPath: string;
begin
  result := getCurrentDir;
end;

function TFileOperations.FileExists(path: string): boolean;
begin
  result := FileExists(path);
end;

function TFileOperations.FileSize(path: string): longint;
var
  f: textFile;
begin
  assignFile(f, path);
  reset(f);
  result := System.FileSize(f);
end;

function TFileOperations.IsEmpty(path: string): boolean;
var
  f: textFile;
begin
  assignFile(f, path);
  reset(f);
  result := System.FileSize(f) = 0;
end;

procedure TFileOperations.Remove(path: string);
var
  f: textFile;
begin
  try
    assignFile(f, path);
    erase(f);
  except
  end;
end;

procedure TFileOperations.Rename(path, newname: string);
var
  f: textFile;
begin
  try
    assignFile(f, path);
    System.Rename(f, newname);
  except
  end;
end;

{$ENDREGION}
{$REGION 'TDriveInfo'}

constructor TDriveInfo.Create(driveName: string);
begin
  driveName := UpperCase(driveName);
  if not((length(driveName) in [1 .. 3]) or charInSet(driveName[1],
    ['A' .. 'Z'])) then
    raise_exception(E_INVALID_ARG, [driveName]);
  case length(driveName) of
    1:
      begin
        fRootDir := driveName + driveDelim + pathDelim;
      end;
    2:
      begin
        if driveName[2] <> driveDelim then
          raise_exception(E_INVALID_ARG, [driveName]);
        fRootDir := driveName + driveDelim;
      end;
    3:
      begin
        if driveName[2] <> driveDelim then
          raise_exception(E_INVALID_ARG, [driveName]);
        if driveName[3] <> pathDelim then
          raise_exception(E_INVALID_ARG, [driveName]);
        fRootDir := driveName;
      end;
  end;
  fDriveName := driveName;
end;

destructor TDriveInfo.Destory;
begin

end;

function TDriveInfo.GetDrive: TArray<TDriveInfo>;
var
  driveSym: Char;
  driveName: array [0 .. 25] of string;
  DriveType: integer;
  len: integer;
  i: integer;
begin
  len := 0;
  for driveSym := 'A' to 'Z' do
  begin
    DriveType := Windows.GetDriveType(Pchar(driveSym + driveDelim + pathDelim));
    if not(DriveType in SysDriveType) then
      continue;
    inc(len);
    driveName[len - 1] := driveSym + driveDelim + pathDelim;
  end;
  setLength(result, len);
  for i := 0 to len - 1 do
    result[i] := TDriveInfo.Create(driveName[i]);
end;

procedure TDriveInfo.update;
begin
  SysUtils.GetDiskFreeSpaceEx(Pchar(fRootDir), fAvailableFreeSpace, fTotalSize,
    @fTotalFreeSpace);
  Windows.GetVolumeInformation(Pchar(fRootDir), fVolumeName,
    length(fVolumeName), @fSerialNumber, fMaximumComponentLength,
    fFileSystemFlags, fFileSystemName, length(fFileSystemName));
end;

function TDriveInfo.GetAvailableFreeSpace: Int64;
begin
  update;
  result := fAvailableFreeSpace;
end;

function TDriveInfo.GetDriveFormat: string;
begin
  update;
  result := fFileSystemName;
end;

function TDriveInfo.GetDriveType: TDriveType;
var
  Value: Cardinal;
begin
  Value := Windows.GetDriveType(Pchar(fRootDir));
  case Value of
    DRIVE_NO_ROOT_DIR:
      result := dtNoRootDirectory;
    DRIVE_REMOVABLE:
      result := dtRemovable;
    DRIVE_FIXED:
      result := dtFixed;
    DRIVE_REMOTE:
      result := dtNetwork;
    DRIVE_CDROM:
      result := dtCDRom;
    DRIVE_RAMDISK:
      result := dtRam;
  else
    result := dtUnknown; // DRIVE_UNKNOWN
  end;
end;

function TDriveInfo.GetDriveTypeString: string;
begin
  result := DriveTypeStrings[Self.DriveType];
end;

function TDriveInfo.GetTotalFreeSpace: Int64;
begin
  update;
  result := fTotalFreeSpace;
end;

function TDriveInfo.GetTotalSize: Int64;
begin
  update;
  result := fTotalSize;
end;

function TDriveInfo.GetVolumeLabel: string;
begin
  update;
  result := fVolumeName;
end;

procedure TDriveInfo.SetVolumeLabel(const Value: string);
begin
  Windows.SetVolumeLabel(Pchar(fRootDir), Pchar(Value));
end;

{$ENDREGION}

end.
