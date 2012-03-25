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
  Windows, Generics.Defaults,
  DSTL.Types, DSTL.STL.Iterator, DSTL.STL.Vector, DSTL.Exception;

type
  TDeque<T> = class(TSequence<T>)
  protected
    fItems: ^arrObject<T>;
    len, cap: integer;

    procedure iadvance(var Iterator: TIterator<T>); override;
    function iget(const Iterator: TIterator<T>): T; override;
    function iequals(const iter1, iter2: TIterator<T>): boolean; override;
    function get_item(idx: integer): T;
    procedure set_item(idx: integer; const value: T);
    procedure reallocate(sz: integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure assign(first, last: TIterator<T>); overload;
    procedure assign(n: integer; u: T); overload;
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
    procedure push_front(const obj: T);
    function pop_back: T; override;
    procedure push_back(const obj: T); override;
    function insert(Iterator: TIterator<T>; const obj: T): TIterator<T>; overload;
    procedure insert(Iterator: TIterator<T>; n: integer; const obj: T); overload;
    procedure insert(Iterator: TIterator<T>; first, last: TIterator<T>); overload;
    function erase(it: TIterator<T>): TIterator<T>; overload;
    function erase(_start, _finish: TIterator<T>): TIterator<T>; overload;
    procedure swap(var dqe: TDeque<T>);
    procedure _sort(comparator: IComparer<T>; l, r: integer);
    procedure sort; overload;
    procedure sort(comparator: IComparer<T>); overload;

    property items[idx: integer]: T read get_item write set_item; default;
  end;

implementation

{ ******************************************************************************
  *                                                                            *
  *                                TDeque                                     *
  *                                                                            *
  ****************************************************************************** }
constructor TDeque<T>.Create;
begin
  getMem(fItems, defaultArrSize * sizeOf(T));
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
  result := fItems[Iterator.position];
end;

function TDeque<T>.iequals(const iter1, iter2: TIterator<T>): boolean;
begin
  result := iter1.position = iter2.position;
end;

function TDeque<T>.get_item(idx: integer): T;
begin
  if idx > len then raise_exception(E_OUT_OF_RANGE);
  Result := fItems[idx];
end;

procedure TDeque<T>.set_item(idx: integer; const value: T);
begin
  if idx > len then raise_exception(E_OUT_OF_RANGE);
  fItems[idx] := value;
end;

procedure TDeque<T>.reallocate(sz: integer);
var
  oldcap: integer;
  olditems: pointer;
begin
  if cap < sz then oldcap := cap else oldcap := sz;
  olditems := fItems;
  GetMem(fItems, sz);
  CopyMemory(fItems, olditems, oldcap);
  FreeMem(olditems, oldcap);
  cap := sz;
end;

procedure TDeque<T>.assign(first, last: TIterator<T>);
var
  iter: TIterator<T>;
begin
  freeMem(fItems);
  getMem(fItems, defaultArrSize * sizeOf(T));
  len := 0;
  cap := defaultArrSize;

  iter := first;
  Self.push_back(iter);
  while iter <> last do
  begin
    iter.handle.iadvance(iter);
    Self.push_back(iter);
  end;
end;

procedure TDeque<T>.assign(n: integer; u: T);
var
  i: integer;
begin
  freeMem(fItems);
  getMem(fItems, defaultArrSize * sizeOf(T));
  len := 0;
  cap := defaultArrSize;

  Self.len := 0;
  for i := 0 to n - 1 do
    Self.push_back(u);
end;

procedure TDeque<T>.add(const obj: T);
begin
  push_back(obj);
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
  result := fItems[0];
end;

function TDeque<T>.back: T;
begin
  if empty then
    exit;
  result := fItems[len - 1];
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
  result := fItems[idx];
end;

function TDeque<T>.pop_front: T;
var
  i: integer;
begin
  result := fItems[0];
  for i := 0 to len - 2 do
  begin
    fItems[i] := fItems[i + 1];
  end;
  dec(len);
end;

procedure TDeque<T>.push_front(const obj: T);
var
  i: integer;
begin
  for i := len downto 1 do
  begin
    fItems[i] := fItems[i - 1];
  end;
  inc(len);
  fItems[0] := obj;
end;

function TDeque<T>.pop_back: T;
begin
  result := fItems[len - 1];
  dec(len);
end;

procedure TDeque<T>.push_back(const obj: T);
begin
  if len = cap then reallocate((cap + 1) * sizeof(T));
  fItems[len] := obj;
  inc(len);
end;

function TDeque<T>.insert(Iterator: TIterator<T>; const obj: T): TIterator<T>;
var
  idx: Integer;
  i: Integer;
begin
  if cap = len then reallocate((cap + 1) * sizeof(T));

  idx := Iterator.position;
  for i := size - 1 downto idx do
    fItems[i + 1] := fItems[i];
  fItems[idx] := obj;
  inc(len);

  result.position := idx;
  Result.handle := self;
end;

procedure TDeque<T>.insert(Iterator: TIterator<T>; n: integer; const obj: T);
var
  idx: Integer;
  i: Integer;
begin
  if len + n > cap then reallocate(len + n);

  idx := Iterator.position;
  for i := size - 1 downto idx do
    fItems[i + n] := fItems[i];
  for i := idx to idx + n do
    fItems[i] := obj;
  inc(len, n);
end;

procedure TDeque<T>.insert(Iterator: TIterator<T>; first, last: TIterator<T>);
var
  dist: integer;
  iter: TIterator<T>;
  idx, i: integer;
begin
  dist := 0;
  iter := first;
  while iter <> last do
  begin
    iter.handle.iadvance(iter);
    inc(dist);
  end;
  inc(dist);

  if len + dist > cap then reallocate(len + dist);

  idx := Iterator.position;
  for i := size - 1 downto idx do
    fItems[i + dist] := fItems[i];
  iter := first;
  for i := idx to idx + dist do
  begin
    fItems[i] := iter;
    iter.handle.iadvance(iter);
  end;
  inc(len, dist);
end;

function TDeque<T>.erase(it: TIterator<T>): TIterator<T>;
var
  idx: Integer;
  i: Integer;
begin
  idx := it.position;
  for i := idx to size - 1 do
    fItems[i] := fItems[i + 1];
  dec(len);
end;

function TDeque<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
var
  idx: Integer;
  dist, cnt: integer;
  i: Integer;
begin
  idx := start.position;
  dist := _finish.position - _start.position + 1;
  cnt := len - _finish.position;
  for i := idx to idx + cnt do
    fItems[i] := fItems[i + dist];
  dec(len, dist);
end;

procedure TDeque<T>._sort(comparator: IComparer<T>; l, r: integer);
var
  tmp: T;
  i, j: integer;
  x: T;
begin
  i := l;
  j := r;
  x := fItems[(i + j) shr 1];
  repeat
    while (comparator.Compare(at(i), x) < 0) do inc(i);
    while (comparator.Compare(x, at(j)) < 0) do dec(j);
    if i <= j then
    begin
      tmp := fItems[i];
      fItems[i] := fItems[j];
      fItems[j] := tmp;
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

procedure TDeque<T>.swap(var dqe: TDeque<T>);
var
  cnt, slen, sdqe, scap: integer;
  i: integer;
  tmp: T;
begin
  if Self.len > dqe.len then
  begin
    cnt := Self.len;
    slen := dqe.len;
    scap := dqe.cap;
    sdqe := 0;
  end
  else begin
    cnt := dqe.len;
    slen := Self.len;
    scap := Self.cap;
    sdqe := 1;
  end;
  if (Self.len > dqe.len) then dqe.resize(Self.len)
  else  if (Self.len < dqe.len) then Self.resize(dqe.len);
  if (Self.len > Self.cap) then Self.reallocate(Self.len);
  if (dqe.len > dqe.cap) then dqe.reallocate(dqe.len);

  for i := 0 to cnt - 1 do
  begin
    tmp := Self.fItems[i];
    Self.fItems[i] := dqe.fItems[i];
    dqe.fItems[i] := tmp;
  end;

  if sdqe = 0 then
  begin
    Self.resize(slen);
    Self.reallocate(scap);
  end
  else begin
    dqe.resize(slen);
    dqe.reallocate(scap);
  end;
end;

end.
