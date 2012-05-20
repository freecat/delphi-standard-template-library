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
  DSTL.Types, DSTL.STL.Iterator, DSTL.STL.Vector, DSTL.Exception, DSTL.STL.Alloc,
  DSTL.STL.DequeMap, DSTL.Algorithm;

const
  defaultBufSize = 32;

type
  TDeque<T> = class(TSequence<T>)
  protected
    allocator: IAllocator<T>;

    buf_size: TSizeType;
    map: TDequeMapNode<T>;

    procedure iadvance(var Iterator: TIterator<T>); override;
    procedure iadvance_by(var Iterator: TIterator<T>;n: integer);
    procedure iretreat(var Iterator: TIterator<T>); override;
    procedure iretreat_by(var Iterator: TIterator<T>;n: integer);
    function iget(const Iterator: TIterator<T>): T; override;
    procedure iput(const Iterator: TIterator<T>; const obj: T); override;
    function iequals(const iter1, iter2: TIterator<T>): boolean; override;
    function idistance(const iter1, iter2: TIterator<T>): integer;  override;
    function get_item(idx: integer): T;
    procedure set_item(idx: integer; const value: T);
    function get_buf_size: TSizeType;
    procedure set_buf_size(const value: TSizeType);
    procedure set_node(var it: TIterator<T>; node: TDequeMapNode<T>);
    procedure create_map;
    procedure push_front_aux(const obj: T);
    procedure push_back_aux(const obj: T);
    function pop_back_aux: T;
    function pop_front_aux: T;
    function reserve_elements_at_front(n: integer): TIterator<T>;
    function reserve_elements_at_back(n: integer): TIterator<T>;
    function insert_aux(Iterator: TIterator<T>; const obj: T): TIterator<T>;  overload;
    procedure insert_aux(position: TIterator<T>; first, last: TIterator<T>; n: integer); overload;
    procedure fill_insert(position: TIterator<T>; n: integer; const obj: T);
    procedure insert_aux(position: TIterator<T>; n: integer; const obj: T); overload;
  public
    start, finish: TIterator<T>;

    constructor Create;  overload;
    constructor Create(alloc: IAllocator<T>); overload;
    constructor Create(n: integer; value: T); overload;
    constructor Create(first, last: TIterator<T>); overload;
    constructor Create(x: TVector<T>); overload;
    destructor Destroy; override;
    procedure assign(first, last: TIterator<T>); overload;
    procedure assign(n: integer; u: T); overload;
    procedure add(const obj: T); override;
    procedure remove(const obj: T); override;
    procedure clear; override;
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
    function pop_front: T; override;
    procedure push_front(const obj: T);override;
    function pop_back: T; override;
    procedure push_back(const obj: T); override;
    function insert(Iterator: TIterator<T>; const obj: T): TIterator<T>; overload;
    procedure insert(position: TIterator<T>; n: integer; const obj: T); overload;
    procedure insert(position: TIterator<T>; first, last: TIterator<T>); overload;
    function erase(it: TIterator<T>): TIterator<T>; overload;
    function erase(_start, _finish: TIterator<T>): TIterator<T>; overload;
    procedure swap(var dqe: TDeque<T>);

    property items[idx: integer]: T read get_item write set_item; default;
    function get_allocator: IAllocator<T>;
    property buffer_size: TSizeType read get_buf_size write set_buf_size;
  end;

implementation

{ ******************************************************************************
  *                                                                            *
  *                                TDeque                                     *
  *                                                                            *
  ****************************************************************************** }
constructor TDeque<T>.Create;
begin
  allocator := TAllocator<T>.Create;
  buf_size := defaultBufSize;
  create_map;
  start.handle := Self;
  finish.handle := Self;
end;

constructor TDeque<T>.Create(alloc: IAllocator<T>);
begin
  allocator := alloc;
  buf_size := defaultBufSize;
  create_map;
  start.handle := Self;
  finish.handle := Self;
end;

constructor TDeque<T>.Create(n: integer; value: T);
begin
  allocator := TAllocator<T>.Create;
  buf_size := defaultBufSize;
  assign(n, value);
  start.handle := Self;
  finish.handle := Self;
end;

constructor TDeque<T>.Create(first, last: TIterator<T>);
begin
  allocator := TAllocator<T>.Create;
  buf_size := defaultBufSize;
  assign(first, last);
  start.handle := Self;
  finish.handle := Self;
end;

constructor TDeque<T>.Create(x: TVector<T>);
begin
  allocator := TAllocator<T>.Create;
  buf_size := defaultBufSize;
  assign(x.start, x.finish);
  start.handle := Self;
  finish.handle := Self;
end;

destructor TDeque<T>.Destroy;
begin
end;

procedure TDeque<T>.iadvance(var Iterator: TIterator<T>);
begin
  inc(Iterator.cur);
  if Iterator.cur = Iterator.last then
  begin
    set_node(Iterator, Iterator.bnode.next);
    Iterator.cur := Iterator.first;
  end;
end;

procedure TDeque<T>.iadvance_by(var Iterator: TIterator<T>;n: integer);
var
  i: integer;
begin
  for i := 1 to n do
    iadvance(Iterator);
end;

procedure TDeque<T>.iretreat(var Iterator: TIterator<T>);
begin
  if Iterator.cur = Iterator.first then
  begin
    set_node(Iterator, Iterator.bnode.prev);
    Iterator.cur := Iterator.last;
  end;
  dec(Iterator.cur);
end;

procedure TDeque<T>.iretreat_by(var Iterator: TIterator<T>;n: integer);
var
  i: integer;
begin
  for i := 1 to n do
    iretreat(Iterator);
end;

function TDeque<T>.iget(const Iterator: TIterator<T>): T;
begin
  result := Iterator.bnode.buf[Iterator.cur];
end;

procedure TDeque<T>.iput(const Iterator: TIterator<T>; const obj: T);
begin
  Iterator.bnode.buf[Iterator.cur] := obj;
end;

function TDeque<T>.iequals(const iter1, iter2: TIterator<T>): boolean;
begin
  result := (iter1.bnode = iter2.bnode) and (iter1.cur = iter2.cur);
end;

function TDeque<T>.idistance(const iter1, iter2: TIterator<T>): integer;
var
  dist: integer;
  iter: TIterator<T>;
begin
  dist := 0;
  iter := iter1;
  while iter <> iter2 do
  begin
    iadvance(iter);
    inc(dist);
  end;
  Result := dist;
end;

function TDeque<T>.get_item(idx: integer): T;
var
  it: TIterator<T>;
begin
  if (idx >= size) or (idx < 0) then dstl_raise_exception(E_OUT_OF_BOUND);
  it := start;
  while idx > 0 do
  begin
    iadvance(it);
    dec(idx);
  end;
  Result := it.bnode.buf[it.cur];
end;

procedure TDeque<T>.set_item(idx: integer; const value: T);
var
  it: TIterator<T>;
begin
  it := start;
  while idx > 0 do
  begin
    iadvance(it);
    dec(idx);
  end;
  it.bnode.buf[it.cur] := value;
end;

function TDeque<T>.get_buf_size: TSizeType;
begin
  Result := Self.buf_size;
end;

procedure TDeque<T>.set_buf_size(const value: TSizeType);
begin
  Self.buf_size := value;
end;

procedure TDeque<T>.set_node(var it: TIterator<T>; node: TDequeMapNode<T>);
begin
  it.bnode := node;
  it.first := 0;
  it.last := buf_size div sizeOf(T) + 1;
end;

procedure TDeque<T>.create_map;
var
  node: TDequeMapNode<T>;
begin
  node := TDequeMapNode<T>.Create;
  node.buf := allocator.allocate(buf_size * sizeOf(T));
  set_node(start, node);
  set_node(finish, node);
  start.cur := start.first;
  finish.cur := start.first;
end;

function TDeque<T>.reserve_elements_at_front(n: integer): TIterator<T>;
var
  tmp: T;
  old_start: TIterator<T>;
begin
  old_start := start;
  tmp := front;
  while n > 0 do
  begin
    push_front(tmp);
    dec(n);
  end;
  Result := start;
  start := old_start;
end;

function TDeque<T>.reserve_elements_at_back(n: integer): TIterator<T>;
var
  tmp: T;
  old_finish: TIterator<T>;
begin
  old_finish := finish;
  tmp := back;
  while n > 0 do
  begin
    push_back(tmp);
    dec(n);
  end;
  Result := finish;
  finish := old_finish;
end;

procedure TDeque<T>.assign(first, last: TIterator<T>);
var
  iter: TIterator<T>;
begin
  (* clean up *)
  if not empty then clear;
  if start.bnode <> nil then
  begin
    allocator.deallocate(start.bnode.buf);
    start.bnode.Destroy;
  end;

  create_map;

  iter := first;
  while iter <> last do
  begin
    Self.push_back(iter);
    iter.handle.iadvance(iter);
  end;
end;

procedure TDeque<T>.assign(n: integer; u: T);
var
  i: integer;
begin
  (* clean up *)
  if not empty then clear;
  if start.bnode <> nil then
  begin
    allocator.deallocate(start.bnode.buf);
    start.bnode.Destroy;
  end;

  create_map;

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
var
  node: TDequeMapNode<T>;
begin
  node := start.bnode.next;
  if node <> nil then begin
    (* destroy all nodes between (start.bnode, finish.bnode) *)
    while (node <> finish.bnode) do
    begin
      allocator.deallocate(node.buf, buf_size * sizeOf(T));
      node := node.next;
      node.prev.Destroy;
    end;
  end;

  if start.bnode <> finish.bnode then allocator.deallocate(finish.bnode.buf,
                                                      buf_size * sizeOf(T));
  finish := start;
end;

function TDeque<T>.front: T;
begin
  if empty then
    exit;
  result := iget(start);
end;

function TDeque<T>.back: T;
begin
  if empty then
    exit;
  result := finish.bnode.buf[finish.cur - 1];
end;

function TDeque<T>.capacity: integer;
begin
  result := MaxInt;
end;

function TDeque<T>.max_size: integer;
begin
  result := TSizeType(-1);
end;

procedure TDeque<T>.reserve(const n: integer);
begin
end;

procedure TDeque<T>.resize(const n: integer);
begin
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
end;

function TDeque<T>.size: integer;
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
  result := i;
end;

function TDeque<T>.empty: boolean;
begin
  result := (start.bnode = finish.bnode) and (start.cur = finish.cur);
end;

function TDeque<T>.at(const idx: integer): T;
begin
  if idx > size then dstl_raise_exception(E_OUT_OF_BOUND);
  result := items[idx];
end;

function TDeque<T>.pop_front: T;
begin
  if start.cur = start.last - 1 then
  begin
    Result := start.bnode.buf[start.cur];
    inc(start.cur);
  end
  else Result := pop_front_aux;
end;

function TDeque<T>.pop_front_aux: T;
begin
  Result := start.bnode.buf[start.cur];
  set_node(start, start.bnode.next);
  allocator.deallocate(start.bnode.prev.buf, buf_size * sizeOf(T));
  start.bnode.prev.Destroy;
  start.cur := start.first;
end;

procedure TDeque<T>.push_front(const obj: T);
begin
  if start.cur <> start.first then
  (* we have enough space *)
  begin
    start.bnode.buf[start.cur - 1] := obj;
    start.cur := start.cur - 1;
  end
  else
    push_front_aux(obj);
end;

procedure TDeque<T>.push_front_aux(const obj: T);
begin
  (* create and allocate new node *)
  start.bnode.prev := TDequeMapNode<T>.Create;
  start.bnode.prev.next := start.bnode;
  start.bnode.prev.buf := allocator.allocate(buf_size * sizeOf(T));
  try
    (* set new node *)
    set_node(start, start.bnode.prev);
    start.cur := start.last - 1;
    start.bnode.buf[start.cur] := obj;
  except
    (* rollback *)
    set_node(start, start.bnode.next);
    start.cur := start.first;
    allocator.deallocate(start.bnode.prev.buf, buf_size * sizeOf(T));
    dstl_raise_exception(E_ALLOCATE);
  end;
end;

function TDeque<T>.pop_back: T;
begin
  if finish.cur <> finish.first then
  begin
    dec(finish.cur);
    Result := finish.bnode.buf[finish.cur];
  end
  else Result := pop_back_aux;
end;

function TDeque<T>.pop_back_aux: T;
begin
  set_node(finish, finish.bnode.prev);
  allocator.deallocate(finish.bnode.next.buf, buf_size * sizeOf(T));
  finish.bnode.next.Destroy;
  finish.bnode.next := nil;
  finish.cur := finish.last - 1;
  Result := finish.bnode.buf[finish.cur];
end;

procedure TDeque<T>.push_back(const obj: T);
begin
  if finish.cur <> finish.last - 1 then
  (* we have enough space *)
  begin
    finish.bnode.buf[finish.cur] := obj;
    inc(finish.cur);
  end
  else
    push_back_aux(obj);
end;

procedure TDeque<T>.push_back_aux(const obj: T);
begin
  (* create new node *)
  finish.bnode.next := TDequeMapNode<T>.Create;
  finish.bnode.next.prev := finish.bnode;
  (* set value *)
  finish.bnode.buf[finish.cur] := obj;
  (* set new node *)
  set_node(finish, finish.bnode.next);
  try
    (* allocate memory for the new node *)
    finish.bnode.buf := allocator.allocate(buf_size * sizeOf(T));
  except
    dstl_raise_exception(E_ALLOCATE);
  end;
  (* reset finish.cur *)
  finish.cur := finish.first;
end;

function TDeque<T>.insert(Iterator: TIterator<T>; const obj: T): TIterator<T>;
begin
  (* insert to the head *)
  if iequals(start, Iterator) then
  begin
    push_front(obj);
    Result := start;
  end
  (* insert to the tail *)
  else if iequals(finish, Iterator) then
  begin
    push_back(obj);
    Result := finish;
    iretreat(Result);
  end
  else Result := insert_aux(Iterator, obj);
end;

function TDeque<T>.insert_aux(Iterator: TIterator<T>; const obj: T): TIterator<T>;
var
  index: integer;
  front1, front2, pos1, back1, back2: TIterator<T>;
begin
  index := idistance(start, Iterator);
  if (index < size div 2) then
  begin
    push_front(front);
    front1 := start; iadvance(front1);
    front2 := front1; iadvance(front2);
    pos1 := Iterator; iadvance(pos1);
    TIterAlgorithms<T>.copy(front2, pos1, front1);
  end
  else begin
    push_back(back);
    back1 := finish; iretreat(back1);
    back2 := back1; iretreat(back2);
    TIterAlgorithms<T>.copy_backward(Iterator, back2, back1);
  end;
  iput(Iterator, obj);
  Result := Iterator;
end;

procedure TDeque<T>.insert(position: TIterator<T>; n: integer; const obj: T);
begin
  fill_insert(position, n, obj);
end;

procedure TDeque<T>.fill_insert(position: TIterator<T>; n: integer; const obj: T);
var
  new_start, new_finish: TIterator<T>;
begin
  if position.cur = start.cur then
  begin
    new_start := reserve_elements_at_front(n);
    try
      TIterAlgorithms<T>.fill(new_start, start, obj);
      start := new_start;
    except
    end;
  end
  else if position.cur = finish.cur then
  begin
    new_finish := reserve_elements_at_back(n);
    try
      TIterAlgorithms<T>.fill(finish, new_finish, obj);
      finish := finish;
    except
    end;
  end
  else
    insert_aux(position, n, obj);
end;

procedure TDeque<T>.insert_aux(position: TIterator<T>; n: integer; const obj: T);
var
  elemsbef, elemsaft, leng: integer;
  new_start, old_start, start_n, tmp, mid2: TIterator<T>;
  new_finish, old_finish, finish_n: TIterator<T>;
begin
  elemsbef := idistance(start, position);
  leng := size;

  if elemsbef < leng div 2 then
  begin
    new_start := reserve_elements_at_front(n);
    old_start := start;
    try
      if elemsbef >= n then
      begin
        start_n := start;
        iadvance_by(start_n, n);
        TIterAlgorithms<T>.copy(start, start_n, new_start);
        start := new_start;
        TIterAlgorithms<T>.copy(start_n, position, old_start);
        tmp := position;
        iretreat_by(tmp, n);
        TIterAlgorithms<T>.fill(tmp, position, obj);
      end
      else begin
        mid2 := TIterAlgorithms<T>.copy(start, position, new_start);
        TIterAlgorithms<T>.fill(mid2, start, obj);
        start := new_start;
        TIterAlgorithms<T>.fill(old_start, position, obj);
      end
    except
    end;
  end
  else begin
    new_finish := reserve_elements_at_back(n);
    old_finish := finish;
    elemsaft := leng - elemsbef;
    try
      if elemsaft > n then
      begin
        finish_n := finish;
        iretreat_by(finish_n, n);
        TIterAlgorithms<T>.copy(finish_n, finish, finish);
        finish := new_finish;
        TIterAlgorithms<T>.copy_backward(position, finish_n, old_finish);
        tmp := position;
        iadvance_by(tmp, n);
        TIterAlgorithms<T>.fill(position, tmp, obj);
      end
      else begin
        tmp := position;
        iadvance_by(tmp, n);
        TIterAlgorithms<T>.fill(finish, tmp, obj);
        TIterAlgorithms<T>.copy(position, finish, tmp);
        finish := new_finish;
        TIterAlgorithms<T>.fill(position, old_finish, obj);
      end;
    except
    end;
  end;
end;

procedure TDeque<T>.insert(position: TIterator<T>; first, last: TIterator<T>);
var
  n: integer;
  new_start, new_finish: TIterator<T>;
begin
  n := first.handle.idistance(first, last);

  (* insert to head *)
  if  position.cur = start.cur then
  begin
    new_start := reserve_elements_at_front(n);
    TIterAlgorithms<T>.copy(first, last, new_start);
    start := new_start;
  end
  (* insert to tail *)
  else if position.cur = finish.cur then
  begin
    new_finish := reserve_elements_at_back(n);
    TIterAlgorithms<T>.copy(first, last, finish);
    finish := new_finish;
  end
  else insert_aux(position, first, last, n);
end;

procedure TDeque<T>.insert_aux(position: TIterator<T>; first, last: TIterator<T>; n: integer);
var
  elemsbef, elemsaft: integer;
  leng, tmp: integer;
  old_start, new_start, start_n, mid, mid2: TIterator<T>;
  old_finish, new_finish, finish_n: TIterator<T>;
begin
  elemsbef := idistance(start, position);
  leng := size;
  if elemsbef < leng div 2 then
  begin
    new_start := reserve_elements_at_front(n);
    old_start := start;
    try
      if elemsbef >= n then
      begin
        start_n := start;
        iadvance_by(start_n, n);
        TIterAlgorithms<T>.copy(start, start_n, new_start);
        start := new_start;
        TIterAlgorithms<T>.copy(start_n, position, old_start);
        iretreat_by(position, n);
        TIterAlgorithms<T>.copy(first, last, position);
      end
      else begin
        mid := first;
        tmp := n - elemsbef;
        while tmp > 0 do
        begin
          mid.handle.iadvance(mid);
          dec(tmp);
        end;
        mid2 := TIterAlgorithms<T>.copy(start, position, new_start);
        TIterAlgorithms<T>.copy(first, mid, mid2);
        start := new_start;
        TIterAlgorithms<T>.copy(mid, last, old_start);
      end;
    except
    end;  (* try *)
  end
  else begin
    new_finish := reserve_elements_at_back(n);
    old_finish := finish;
    elemsaft := leng - elemsbef;

    try
      if elemsaft > n then
      begin
        finish_n := finish;
        iretreat_by(finish_n, n);
        TIterAlgorithms<T>.copy(finish_n, finish, finish);
        finish := new_finish;
        TIterAlgorithms<T>.copy_backward(position, finish_n, old_finish);
        TIterAlgorithms<T>.copy(first, last, position);
      end
      else begin
        mid := first;
        tmp := elemsaft;
        while tmp > 0 do
        begin
          mid.handle.iadvance(mid);
          dec(tmp);
        end;
        mid2 := TIterAlgorithms<T>.copy(mid, last, finish);
        TIterAlgorithms<T>.copy(position, finish, mid2);
        finish := new_finish;
        TIterAlgorithms<T>.copy(first, mid, position);
      end;
    except
    end;
  end;
end;

function TDeque<T>.erase(it: TIterator<T>): TIterator<T>;
var
  next: TIterator<T>;
  index: integer;
begin
  next := it;
  iadvance(next);
  index := idistance(start, it);

  (* move elements *)
  if (index < size div 2) then
  begin
    TIterAlgorithms<T>.copy_backward(start, it, next);
    pop_front;
  end
  else
  begin
    TIterAlgorithms<T>.copy(next, finish, it);
    pop_back;
  end;

  Result := start;
  while index > 0 do
  begin
    iadvance(Result);
    dec(index);
  end;
end;

function TDeque<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
var
  n: integer;
  elems_before: integer;
  new_start, new_finish: TIterator<T>;
  cur: TDequeMapNode<T>;
begin
  (* if _start == start and _finish == finish just clear *)
  if (iequals(start, _start)) and (iequals(_finish, finish)) then
  begin
    clear;
    Result := finish;
  end
  else begin
    n := idistance(_start, _finish);
    elems_before := idistance(start, _start);

    if elems_before < (size - n) div 2 then
    begin
      (* move elements *)
      TIterAlgorithms<T>.copy_backward(start, _start, _finish);
      new_start := start;
      iadvance_by(new_start, n);
      cur := start.bnode;
      (* free buffer *)
      while cur <> new_start.bnode do
      begin
        allocator.deallocate(cur.buf, buf_size * sizeOf(T));
        cur := cur.next;
      end;
      (* set new start *)
      start := new_start;
    end
    else begin
      (* move elements *)
      TIterAlgorithms<T>.copy(_finish, finish, _start);
      new_finish := finish;
      iretreat_by(new_finish, n);
      (* free buffer *)
      cur := new_finish.bnode;
      cur := cur.next;
      allocator.deallocate(cur.buf, buf_size * sizeOf(T));
      while cur <> finish.bnode do
      begin
        cur := cur.next;
        allocator.deallocate(cur.buf, buf_size * sizeOf(T));
      end;
      finish := new_finish;
    end;
    Result := start;
    iadvance_by(Result, elems_before);
  end;
end;

procedure TDeque<T>.swap(var dqe: TDeque<T>);
begin
  (* swap allocator, buf_size, map, start and finish *)
  _TSwap<IAllocator<T>>.swap(Self.allocator, dqe.allocator);
  _TSwap<integer>.swap(Self.buf_size, dqe.buf_size);
  _TSwap<TDequeMapNode<T>>.swap(Self.map, dqe.map);
  _TSwap<TIterator<T>>.swap(Self.start, dqe.start);
  _TSwap<TIterator<T>>.swap(Self.finish, dqe.finish);
end;

function TDeque<T>.get_allocator: IAllocator<T>;
begin
  Result := Self.allocator;
end;

end.
