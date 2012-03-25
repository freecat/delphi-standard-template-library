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
unit DSTL.STL.Vector;

interface

uses
  Windows, DSTL.Types, DSTL.STL.Iterator, DSTL.Exception;

type
  TSequence<T> = class(TContainer<T>)
    procedure add(const obj: T); override;
    procedure remove(const obj: T); override;
    procedure clear; override;
    function start: TIterator<T>; virtual;
    function finish: TIterator<T>; virtual;
    function front: T; virtual;
    function back: T; virtual;
    function max_size: Integer; virtual;
    function size: Integer; virtual;
    function empty: boolean; virtual;
    function at(const idx: Integer): T; virtual;
    function pop_back: T; virtual;
    procedure push_back(const obj: T); virtual;
  end;

  TVector<T> = class(TSequence<T>)
  protected
    fItems: ^arrObject<T>;
    len, cap: Integer;

    procedure iadvance(var Iterator: TIterator<T>); override;
    procedure iretreat(var Iterator: TIterator<T>); override;
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
    function capacity: Integer;
    function max_size: Integer; override;
    procedure reserve(const n: Integer);
    procedure resize(const n: Integer); overload;
    procedure resize(const n: Integer; const x: T); overload;
    function size: Integer; override;
    function empty: boolean; override;
    function at(const idx: Integer): T; override;
    function pop_back: T; override;
    procedure push_back(const obj: T); override;
    function insert(Iterator: TIterator<T>; const obj: T): TIterator<T>; overload;
    procedure insert(Iterator: TIterator<T>; n: integer; const obj: T); overload;
    procedure insert(Iterator: TIterator<T>; first, last: TIterator<T>); overload;
    function erase(it: TIterator<T>): TIterator<T>; overload;
    function erase(_start, _finish: TIterator<T>): TIterator<T>; overload;
    procedure swap(var vec: TVector<T>);
    property items[idx: integer]: T read get_item write set_item; default;
  end;

implementation

{ ******************************************************************************
  *                                                                            *
  *                                TSequence                                   *
  *                                                                            *
  ****************************************************************************** }
procedure TSequence<T>.add(const obj: T);
begin
end;

procedure TSequence<T>.remove(const obj: T);
begin
end;

procedure TSequence<T>.clear;
begin
end;

function TSequence<T>.start: TIterator<T>;
begin
end;

function TSequence<T>.finish: TIterator<T>;
begin
end;

function TSequence<T>.front: T;
begin
end;

function TSequence<T>.back: T;
begin
end;

function TSequence<T>.max_size: Integer;
begin
  result := 0;
end;

function TSequence<T>.size: Integer;
begin
  result := 0;
end;

function TSequence<T>.empty: boolean;
begin
  result := false;
end;

function TSequence<T>.at(const idx: Integer): T;
begin
end;

function TSequence<T>.pop_back: T;
begin
end;

procedure TSequence<T>.push_back(const obj: T);
begin
end;
(*
procedure TSequence<T>.insert(Iterator: TIterator<T>; const obj: T);
begin
end;

function TSequence<T>.erase(it: TIterator<T>): TIterator<T>;
begin

end;

function TSequence<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
begin

end;
*)

{ ******************************************************************************
  *                                                                            *
  *                                TVector                                     *
  *                                                                            *
  ****************************************************************************** }
constructor TVector<T>.Create;
begin
  getMem(fItems, defaultArrSize * sizeOf(T));
  len := 0;
  cap := defaultArrSize;
end;

destructor TVector<T>.Destroy;
begin
  FreeMem(fItems, cap);
end;

procedure TVector<T>.iadvance(var Iterator: TIterator<T>);
begin
  if Iterator.position + 1 <= size then
    inc(Iterator.position);
end;

procedure TVector<T>.iretreat(var Iterator: TIterator<T>);
begin
  if Iterator.position - 1 >= 0 then
    dec(Iterator.position);
end;

function TVector<T>.iget(const Iterator: TIterator<T>): T;
begin
  result := fItems[Iterator.position];
end;

function TVector<T>.iequals(const iter1, iter2: TIterator<T>): boolean;
begin
  result := iter1.position = iter2.position;
end;

function TVector<T>.get_item(idx: integer): T;
begin
  if idx > len then raise_exception(E_OUT_OF_RANGE);
  Result := fItems[idx];
end;

procedure TVector<T>.set_item(idx: integer; const value: T);
begin
  if idx > len then raise_exception(E_OUT_OF_RANGE);
  fItems[idx] := value;
end;

procedure TVector<T>.reallocate(sz: integer);
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

procedure TVector<T>.assign(first, last: TIterator<T>);
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

procedure TVector<T>.assign(n: integer; u: T);
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

procedure TVector<T>.add(const obj: T);
begin
  push_back(obj);
end;

procedure TVector<T>.remove(const obj: T);
begin
end;

procedure TVector<T>.clear;
begin
  len := 0;
end;

function TVector<T>.start: TIterator<T>;
begin
  result.position := 0;
  result.handle := self;
end;

function TVector<T>.finish: TIterator<T>;
begin
  result.position := len;
  result.handle := self;
end;

function TVector<T>.front: T;
begin
  if empty then
    exit;
  result := fItems[0];
end;

function TVector<T>.back: T;
begin
  if empty then
    exit;
  result := fItems[len - 1];
end;

function TVector<T>.capacity: Integer;
begin
  result := cap;
end;

function TVector<T>.max_size: Integer;
begin
  result := cap;
end;

procedure TVector<T>.reserve(const n: Integer);
begin
  if cap < n then
    cap := n;
end;

procedure TVector<T>.resize(const n: Integer);
begin
  len := n;
end;

procedure TVector<T>.resize(const n: Integer; const x: T);
var
  m: Integer;
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

function TVector<T>.size: Integer;
begin
  result := len;
end;

function TVector<T>.empty: boolean;
begin
  result := len = 0;
end;

function TVector<T>.at(const idx: Integer): T;
begin
  if idx > size then
    exit;
  result := fItems[idx];
end;

function TVector<T>.pop_back: T;
begin
  result := fItems[len - 1];
  dec(len);
end;

procedure TVector<T>.push_back(const obj: T);
begin
  if len = cap then reallocate((cap + 1) * sizeof(T));
  fItems[len] := obj;
  inc(len);
end;

function TVector<T>.insert(Iterator: TIterator<T>; const obj: T): TIterator<T>;
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

procedure TVector<T>.insert(Iterator: TIterator<T>; n: integer; const obj: T);
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

procedure TVector<T>.insert(Iterator: TIterator<T>; first, last: TIterator<T>);
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

function TVector<T>.erase(it: TIterator<T>): TIterator<T>;
var
  idx: Integer;
  i: Integer;
begin
  idx := it.position;
  for i := idx to size - 1 do
    fItems[i] := fItems[i + 1];
  dec(len);
end;

function TVector<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
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

procedure TVector<T>.swap(var vec: TVector<T>);
var
  cnt, slen, svec, scap: integer;
  i: integer;
  tmp: T;
begin
  if Self.len > vec.len then
  begin
    cnt := Self.len;
    slen := vec.len;
    scap := vec.cap;
    svec := 0;
  end
  else begin
    cnt := vec.len;
    slen := Self.len;
    scap := Self.cap;
    svec := 1;
  end;
  if (Self.len > vec.len) then vec.resize(Self.len)
  else  if (Self.len < vec.len) then Self.resize(vec.len);
  if (Self.len > Self.cap) then Self.reallocate(Self.len);
  if (vec.len > vec.cap) then vec.reallocate(vec.len);

  for i := 0 to cnt - 1 do
  begin
    tmp := Self.fItems[i];
    Self.fItems[i] := vec.fItems[i];
    vec.fItems[i] := tmp;
  end;

  if svec = 0 then
  begin
    Self.resize(slen);
    Self.reallocate(scap);
  end
  else begin
    vec.resize(slen);
    vec.reallocate(scap);
  end;
end;

end.
