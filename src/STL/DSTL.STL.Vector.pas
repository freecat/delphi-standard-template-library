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
  DSTL.Types, DSTL.STL.Iterator;

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
    procedure insert(Iterator: TIterator<T>; const obj: T); virtual;
    function _erase(it: TIterator<T>): TIterator<T>; virtual;
    function erase(_start, _finish: TIterator<T>): TIterator<T>; virtual;
  end;

  TVector<T> = class(TSequence<T>)
  protected
    items: ^arrObject<T>;
    len, cap: Integer;

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
    procedure insert(Iterator: TIterator<T>; const obj: T); override;
    function _erase(it: TIterator<T>): TIterator<T>; override;
    function erase(_start, _finish: TIterator<T>): TIterator<T>; override;
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

procedure TSequence<T>.insert(Iterator: TIterator<T>; const obj: T);
begin
end;

function TSequence<T>._erase(it: TIterator<T>): TIterator<T>;
begin

end;

function TSequence<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
begin

end;

{ ******************************************************************************
  *                                                                            *
  *                                TVector                                     *
  *                                                                            *
  ****************************************************************************** }
constructor TVector<T>.Create;
begin
  getMem(items, defaultArrSize * sizeOf(T));
  len := 0;
  cap := defaultArrSize;
end;

destructor TVector<T>.Destroy;
begin
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
  result := items[Iterator.position];
end;

function TVector<T>.iequals(const iter1, iter2: TIterator<T>): boolean;
begin
  result := iter1.position = iter2.position;
end;

procedure TVector<T>.add(const obj: T);
begin
  items[len] := obj;
  inc(len);
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
  result := items[0];
end;

function TVector<T>.back: T;
begin
  if empty then
    exit;
  result := items[len - 1];
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
  result := items[idx];
end;

function TVector<T>.pop_back: T;
begin
  result := items[len - 1];
  dec(len);
end;

procedure TVector<T>.push_back(const obj: T);
begin
  items[len] := obj;
  inc(len);
end;

procedure TVector<T>.insert(Iterator: TIterator<T>; const obj: T);
var
  idx: Integer;
  i: Integer;
begin
  idx := Iterator.position;
  for i := size - 1 downto idx do
    items[i + 1] := items[i];
  items[idx] := obj;
  inc(len);
end;

function TVector<T>._erase(it: TIterator<T>): TIterator<T>;
var
  idx: Integer;
  i: Integer;
begin
  idx := it.position;
  for i := idx to size - 1 do
    items[i] := items[i + 1];
  dec(len);
end;

function TVector<T>.erase(_start, _finish: TIterator<T>): TIterator<T>;
begin
  // TODO: erase code here
end;

end.
