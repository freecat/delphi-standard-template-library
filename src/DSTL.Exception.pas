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
unit DSTL.Exception;

interface

uses SysUtils;

const
  errornr = 3;
  E_OUT_OF_RANGE = $1;
  E_INVALID_ARG = $2;
  E_FILE_NOT_FOUND = $3;

  exception_msg: array [1 .. errornr] of string = ('Out of range.',
    'Invalid argument: %s.', 'File ''%s'' not found.');

procedure raise_exception(errno: integer); overload;
procedure raise_exception(errno: integer; args: array of const); overload;

implementation

procedure raise_exception(errno: integer);
begin
  raise Exception.Create(exception_msg[errno]);
end;

procedure raise_exception(errno: integer; args: array of const);
var
  i: integer;
  str: string;
  idx: integer;
begin
  i := 0;
  str := '';
  idx := 0;
  while i <= length(exception_msg[errno]) do
  begin
    inc(i);
    if not(exception_msg[errno, i] = '%') then
      str := str + exception_msg[errno, i]
    else
      inc(i);
    case exception_msg[errno, i] of
      's':
        begin
          if idx > high(args) then
            break;
          str := str + String(args[idx].VString);
          inc(idx);
        end;
    end;
  end;
  raise Exception.Create(str);
end;

end.
