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
unit DSTL.STL.Deque;

interface

uses
  Generics.Collections, Generics.Defaults,
  DSTL.Types, DSTL.STL.Iterator, DSTL.STL.Vector;

type
  TDeque<T> = class(TSequence<T>)
  protected
    items: ^arrObject<T>;
    len, cap: integer;

    procedure iadvance(var Iterator: TIterator<T>); override;
    function iget(const Iterator: TIterator<T>): T; override;
    function iequals(const iter1, iter2: TIterator<T>): boolean; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure add(const obj: T); override;
    procedure remove(const obj: T); override;
    procedure clear; override;
    function start: TIterator<T>; override;
    function finish: TIterator<T>; override;
    function front: T; override;
    function back: T; override;
    function capacity: integer;
    function max_size: integer; override;
    procedure reserve(const n: integer);
    procedure resize(const n: integer); overload;
    procedure resize(const n: integer; const x: T); overload;
    function size: integer; override;
    function empty: boolean; override;
    function at(const idx: integer): T; override;
    function pop_front: T;
    procedure _push_front(const obj: T);
    procedure push_front(const objs: array of T);
    function pop_back: T; override;
    procedure push_back(const obj: T); override;
    procedure insert(Iterator: TIterator<T>; const obj: T); override;
    function _erase(it: TIterator<T>): TIterator<T>; override;
    function erase(_start, _finish: TIterator<T>): TIterator<T>; override;
    procedure _sort(comparator: IComparer<T>; l, r: integer);
    procedure sort; overload;
    procedure sort(comparator: IComparer<T>); overload;
  end;

implementation

{ ******************************************************************************
  *                                                                            *
  *                                TDeque                                     *
  *                                                                            *
  ****************************************************************************** }
constructor TDeque<T>.Create;
begin
  getMem(items, defaultArrSize * sizeOf(T));
  len := 0;
  cap := defaultArrSize;
end;

destructor TDeque<T>.Destroy;
begin
end;

procedure TDeque<T>.iadvance(var Iterator: TIterator<T>);
begin
  if Iterator.position + 1 <= size then
    inc(Iterator.position);
end;

function TDeque<T>.iget(const Iterator: TIterator<T>): T;
begin
  result := items[Iterator.position];
end;

function TDeque<T>.iequals(const iter1, iter2: TIterator<T>): boolean;
begin
  result := iter1.position = iter2.position;
end;

procedure TDeque<T>.add(const obj: T);
begin
  items[len] := obj;
  inc(len);
end;

procedure TDeque<T>.remove(const obj: T);
begin
end;

procedure TDeque<T>.clear;
begin
  len := 0;
end;

function TDeque<T>.start: TIterator<T>;
begin
  result.position := 0;
  result.handle := self;
end;

function TDeque<T>.finish: TIterator<T>;
begin
  result.position := len;
  result.handle := self;
end;

function TDeque<T>.front: T;
begin
  if empty then
    exit;
  result := items[0];
end;

function TDeque<T>.back: T;
begin
  if empty then
    exit;
  result := items[len - 1];
end;

function TDeque<T>.capacity: integer;
begin
  result := cap;
end;

function TDeque<T>.max_size: integer;
begin
  result := cap;
end;

procedure TDeque<T>.reserve(const n: integer);
begin
  if cap < n then
    cap := n;
end;

procedure TDeque<T>.resize(const n: integer);
begin
  len := n;
end;

procedure TDeque<T>.resize(const n: integer; const x: T);
var
  m: integer;
begin
  if size < n then
  begin
    m := n - size;
    while m > 0 do
    begin
      dec(m);
      push_back(x);
    end;
  end;
  len := n;
end;

function TDeque<T>.size: integer;
begin
  result := len;
end;

function TDeque<T>.empty: boolean;
begin
  result := len = 0;
end;

function TDeque<T>.at(const idx: integer): T;
begin
  if idx > size then
    exit;
  result := items[idx];
end;

function TDeque<T>.pop_front: T;
var
  i: integer;
begin
  result := items[0];
  for i := 0 to len - 2 do
  begin
    items[i] := items[i + 1];
  end;
  dec(len);
end;

procedure TDeque<T>._push_front(const obj: T);
var
  i: integer;
begin
  for i := len downto 1 do
  begin
    items[i] := items[i - 1];
  end;
  inc(len);
  items[0] := obj;
end;

procedure TDeque<T>.push_front(const objs: array of T);
var
  i: integer;
begin
  for i := low(objs) to high(objs) do
  begin
    _push_front(objs[i]);
  end;
end;

function TDeque<T>.pop_back: T;
begin
  result := items[len - 1];
  dec(len);
end;

procedure TDeque<T>.push_back(const obj: T);
begin
  items[len] := obj;
  inc(len);
end;

procedure TDeque<T>.insert(Iterator: TIterator<T>; const obj: T);
var
  idx: integer;
  i: integer;
begin
  idx := Iterator.position;
  for i := size - 1 downto idx do
    items[i + 1] := items[i];
  items[idx] := obj;
  inc(len);
end;

function TDeque<T>._erase(it: TIterator<T>): TIterator<T>;
var
  idx: integer;
  i: integer;
begin
  idx := it.position;
  for i := idx to size - 1 do
    items[i] := items[i + 1];
  dec(len);
end;

function TDeque<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
begin
  // TODO: erase code here
end;

procedure TDeque<T>._sort(comparator: IComparer<T>; l, r: integer);
var
  tmp: T;
  i, j: integer;
  x: T;
begin
  i := l;
  j := r;
  x := items[(i + j) shr 1];
  repeat
    while (comparator.Compare(at(i), x) < 0) do inc(i);
    while (comparator.Compare(x, at(j)) < 0) do dec(j);
    if i <= j then
    begin
      tmp := items[i];
      items[i] := items[j];
      items[j] := tmp;
      inc(i);
      dec(j);
    end;
  until i>j;
  if l < j then _sort(comparator, l, j);
  if i < r then _sort(comparator, i, r);
end;

procedure TDeque<T>.sort;
begin
  _sort(TComparer<T>.default, 0, size - 1);
end;

procedure TDeque<T>.sort(comparator: IComparer<T>);
begin
  _sort(comparator, 0, size - 1);
end;

end.
