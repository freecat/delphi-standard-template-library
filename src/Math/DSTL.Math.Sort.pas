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
unit DSTL.Math.Sort;

interface

uses
  Windows, SysUtils, DSTL.Types, Generics.Defaults, Generics.Collections;

type
  TSorter<T> = class
  protected
    comparer: IComparer<T>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure QSort(var data: array of T; l, r: integer);
  end;

implementation

constructor TSorter<T>.Create;
begin
  comparer := TComparer<T>.default;
end;

destructor TSorter<T>.Destroy;
begin
end;

procedure TSorter<T>.QSort(var data: array of T; l, r: integer);
var
  i, j: integer;
  x, y: T;
begin
  i := l;
  j := r;
  x := data[(l + r) div 2];
  while i <= j do
  begin
    while comparer.Compare(x, data[i]) > 0 do
      inc(i);
    while comparer.Compare(x, data[j]) < 0 do
      dec(j);
    if i <= j then
    begin
      y := data[i];
      data[i] := data[j];
      data[j] := y;
      inc(i);
      dec(j);
    end;
  end;
  if l < j then
    QSort(data, l, j);
  if i < r then
    QSort(data, i, r);
end;

end.
