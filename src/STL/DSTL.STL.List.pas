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
unit DSTL.STL.List;

interface

uses

  SysUtils, DSTL.Types, DSTL.STL.ListNode, DSTL.STL.Iterator, DSTL.STL.Vector,
  Generics.Defaults, Generics.Collections;

type
{$REGION 'TList<T>'}
  TList<T> = class(TSequence<T>)
  protected
    head, tail: TListNode<T>;

    procedure iadvance(var Iterator: TIterator<T>); override;
    procedure iretreat(var Iterator: TIterator<T>); override;
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
    function max_size: integer; override;
    procedure resize(const n: integer); overload;
    procedure resize(const n: integer; const x: T); overload;
    function size: integer; override;
    function empty: boolean; override;
    function at(const idx: integer): T; override;
    function get(const idx: integer): TIterator<T>;
    function pop_back: T; override;
    function pop_front: T;
    procedure push_back(const obj: T); override;
    procedure push_front(const obj: T);
    procedure cut(_start, _finish: TIterator<T>);
    procedure insert(Iterator: TIterator<T>; const obj: T);
    function _erase(it: TIterator<T>): TIterator<T>;
    function erase(_start, _finish: TIterator<T>): TIterator<T>;
    procedure merge(l: TList<T>);
    procedure reverse;
    procedure _sort(comparator: IComparer<T>; l, r: integer);
    procedure sort; overload;
    procedure sort(comparator: IComparer<T>); overload;
    procedure swap(l: TList<T>);
    procedure unique;
  end;

{$ENDREGION}

implementation

{$REGION 'TList<T>'}

constructor TList<T>.Create;
begin
  head := nil;
  tail := nil;
end;

destructor TList<T>.Destroy;
begin
end;

procedure TList<T>.iadvance(var Iterator: TIterator<T>);
begin
  if Iterator.node.next = nil then
    exit;
  Iterator.node := Iterator.node.next;
  Iterator.handle := self;
end;

procedure TList<T>.iretreat(var Iterator: TIterator<T>);
begin
  if Iterator.node.prev = nil then
    exit;
  Iterator.node := Iterator.node.prev;
  Iterator.handle := self;
end;

function TList<T>.iget(const Iterator: TIterator<T>): T;
begin
  result := Iterator.node.obj;
end;

function TList<T>.iequals(const iter1, iter2: TIterator<T>): boolean;
begin
  result := iter1.node = iter2.node;
end;

procedure TList<T>.add(const obj: T);
begin
  push_back(obj);
end;

procedure TList<T>.remove(const obj: T);
var
  tmp: TIterator<T>;
  comparer: IEqualityComparer<T>;
begin
  comparer := TEqualityComparer<T>.default;
  tmp := start;
  repeat
    if comparer.Equals(tmp.node.obj, obj) then
    begin
      if tmp.node = head then
      begin
        head := head.next;
        head.prev := nil;
      end
      else if tmp.node = tail then
      begin
        tail := tail.prev;
        tail.next := nil;
      end
      else
      begin
        tmp.node.prev.next := tmp.node.next;
        tmp.node.next.prev := tmp.node.prev;
      end;
    end;
    iadvance(tmp);
  until (tmp.node = nil) or empty;
end;

procedure TList<T>.clear;
begin
  head := nil;
end;

function TList<T>.start: TIterator<T>;
begin
  result.node := head;
  result.handle := self;
end;

function TList<T>.finish: TIterator<T>;
begin
  result.node := tail;
  result.handle := self;
end;

function TList<T>.front: T;
begin
  if empty then
    exit;
  result := head.obj;
end;

function TList<T>.back: T;
begin
  if empty then
    exit;
  result := tail.obj;
end;

function TList<T>.max_size: integer;
begin
  { TODO: max_size code here }
end;

procedure TList<T>.resize(const n: integer);
begin
  { TODO: resize code here }
end;

procedure TList<T>.resize(const n: integer; const x: T);
begin
  { TODO: resize code here }
end;

function TList<T>.size: integer;
var
  i: integer;
  iter: TIterator<T>;
begin
  i := 0;
  iter := start;
  while iter <> finish do
  begin
    iadvance(iter);
    inc(i);
  end;
  inc(i);
  result := i;
end;

function TList<T>.empty: boolean;
begin
  result := head = nil;
end;

function TList<T>.at(const idx: integer): T;
var
  tmp: TIterator<T>;
  i: integer;
begin
  tmp := start;
  i := idx;
  if i >= size then
    exit;
  while true do
  begin
    dec(i);
    if i < 0 then
      break;
    if tmp.node = nil then
      break;
    iadvance(tmp);
  end;
  if tmp.node <> nil then
    result := tmp.node.obj;
end;

function TList<T>.get(const idx: integer): TIterator<T>;
var
  tmp: TIterator<T>;
  i: integer;
begin
  tmp := start;
  i := idx;
  if idx >= size then
    exit;
  while true do
  begin
    dec(i);
    if i < 0 then
      break;
    iadvance(tmp);
  end;
  result := tmp;
end;

function TList<T>.pop_back: T;
begin
  result := tail.obj;
  tail := tail.prev;
  tail.next := nil;
end;

function TList<T>.pop_front: T;
begin
  result := head.obj;
  head := head.next;
  head.prev := nil;
end;

procedure TList<T>.push_back(const obj: T);
var
  tmp: TListNode<T>;
begin
  if empty then
  begin
    head := TListNode<T>.Create;
    tail := TListNode<T>.Create;
    head.obj := obj;
    tail := head;
  end
  else
  begin
    tmp := TListNode<T>.Create;
    tmp.obj := obj;
    tmp.prev := tail;
    tail.next := tmp;
    tail := tmp;
  end;
end;

procedure TList<T>.push_front(const obj: T);
var
  tmp: TListNode<T>;
begin
  if empty then
  begin
    head := TListNode<T>.Create;
    tail := TListNode<T>.Create;
    head.obj := obj;
    tail := head;
  end
  else
  begin
    tmp := TListNode<T>.Create;
    tmp.obj := obj;
    tmp.next := head;
    head.prev := tmp;
    head := tmp;
  end;
end;

procedure TList<T>.cut(_start, _finish: TIterator<T>);
begin
  _start.node.next := _finish.node.next;
  _finish.node.prev := _start.node.prev;
end;

procedure TList<T>.insert(Iterator: TIterator<T>; const obj: T);
begin
end;

function TList<T>._erase(it: TIterator<T>): TIterator<T>;
begin

end;

function TList<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
begin

end;

procedure TList<T>.merge(l: TList<T>);
begin
  tail.next := l.start.node;
  l.start.node.prev := tail;
end;

procedure TList<T>.reverse;
begin

end;

procedure TList<T>._sort(comparator: IComparer<T>; l, r: integer);
var
  i, j: integer;
  tmp: TIterator<T>;
  s, x: T;
begin
  i := l;
  j := r;
  x := get((i + j) shr 1);
  repeat
    while (comparator.Compare(at(i), x) < 0) do inc(i);
    while (comparator.Compare(x, at(j)) < 0) do dec(j);
    if i <= j then
    begin
      s := at(i);
      tmp := get(i);
      tmp.node.obj := at(j);
      tmp := get(j);
      tmp.node.obj := s;
      inc(i);
      dec(j);
    end;
  until i>j;
  if l < j then _sort(comparator, l,j);
  if i < r then _sort(comparator, i,r);
end;

procedure TList<T>.sort;
begin
  _sort(TComparer<T>.default, 0, size - 1);
end;

procedure TList<T>.sort(comparator: IComparer<T>);
begin
  _sort(comparator, 0, size - 1);
end;

procedure TList<T>.swap(l: TList<T>);
begin

end;

procedure TList<T>.unique;
begin

end;

{$ENDREGION}

end.
