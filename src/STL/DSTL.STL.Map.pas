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
unit DSTL.STL.Map;

interface

uses
  DSTL.STL.Iterator, DSTL.STL.RBTree, DSTL.Utils.Pair, Generics.Defaults;

type
  TMap<K, V> = class(TContainer<K, V>)
  protected
    tree: TRedBlackTree<K, V>;

    procedure iadvance(var Iterator: TIterator<K, V>);  override;
    function iget(const Iterator: TIterator<K, V>): TPair<K, V>; override;
    function iat_end(const Iterator: TIterator<K, V>): boolean; override;
    function iequals(const iter1, iter2: TIterator<K, V>): Boolean;  override;
    procedure iput(const Iterator: TIterator<K, V>; const obj: TPair<K, V>); override;
    function iremove(const Iterator: TIterator<K, V>): TIterator<K, V>; override;
    procedure iretreat(var Iterator: TIterator<K, V>);  override;
    function iget_at(const Iterator: TIterator<K, V>; offset: Integer)
      : TPair<K, V>;
    procedure iput_at(const Iterator: TIterator<K, V>; offset: Integer;
      const obj: TPair<K, V>);
    procedure clear;
  public
    constructor Create;
    destructor Destroy;   override;
    procedure add(const obj: TPair<K, V>);
    function finish: TIterator<K, V>;
    function max_size: Integer;
    function start: TIterator<K, V>;
    function size: Integer;
    function count(const key: K): Integer;
    function get_at(const key: K): TPair<K, V>;
    function locate(const key: K): TIterator<K, V>;
    function lower_bound(const key: K): TIterator<K, V>;
    function upper_bound(const key: K): TIterator<K, V>;
    procedure put_at(const key: K; value: V);
    procedure remove(const key: K);
    procedure remove_at(Iterator: TIterator<K, V>);
    procedure remove_in(_start, _finish: TIterator<K, V>);
    function start_key: TIterator<K, V>;
  end;

implementation

constructor TMap<K, V>.Create;
begin
  tree := TRedBlackTree<K, V>.Create(Self, true, TComparer<K>.Default);
end;

destructor TMap<K, V>.Destroy;
begin
	tree.free;
	inherited;
end;

procedure TMap<K, V>.iadvance(var Iterator: TIterator<K, V>);
begin
  with Iterator do
  begin
    tree.RBincrement(node);
  end;
end;

function TMap<K, V>.iget(const Iterator: TIterator<K, V>): TPair<K, V>;
begin
  Result := Iterator.node.Pair;
end;

function TMap<K, V>.iat_end(const Iterator: TIterator<K, V>): boolean;
begin
  Result := Iterator.node = tree.EndNode;
end;

function TMap<K, V>.iequals(const iter1, iter2: TIterator<K, V>): Boolean;
begin
  result := iter1.node = iter2.node;
end;

procedure TMap<K, V>.iput(const Iterator: TIterator<K, V>; const obj: TPair<K, V>);
begin
  Iterator.node.Pair := obj;
end;

function TMap<K, V>.iremove(const Iterator: TIterator<K, V>): TIterator<K, V>;
begin
  result := Iterator;
  iadvance(result);
  remove_at(Iterator);
end;

procedure TMap<K, V>.iretreat(var Iterator: TIterator<K, V>);
begin
  with Iterator do
  begin
    tree.RBdecrement(Iterator.node);
  end;
end;

function TMap<K, V>.iget_at(const Iterator: TIterator<K, V>; offset: Integer)
  : TPair<K, V>;
var
  iter: TIterator<K, V>;
  i: integer;
begin
  iter := Iterator;
  if offset > 0 then
    for i := 1 to offset do iadvance(iter)
  else
    for i := 1 to -offset do iretreat(iter);
  result := iget(iter);
end;

procedure TMap<K, V>.iput_at(const Iterator: TIterator<K, V>; offset: Integer;
  const obj: TPair<K, V>);
var
  iter: TIterator<K, V>;
  i: integer;
begin
  iter := Iterator;
  if offset > 0 then
    for i := 1 to offset do iadvance(iter)
  else
    for i := 1 to -offset do iretreat(iter);
  iput(iter, obj);
end;

procedure TMap<K, V>.clear;
begin
  tree.erase(true);
end;

procedure TMap<K, V>.add(const obj: TPair<K, V>);
begin
  tree.insert(obj);
end;

function TMap<K, V>.max_size : Integer;
begin
	result := MaxInt;
end;

function TMap<K, V>.start : TIterator<K, V>;
begin
	result := tree.start;
end;

function TMap<K, V>.finish : TIterator<K, V>;
begin
	result := tree.finish;
end;

function TMap<K, V>.size : Integer;
begin
	result := tree.size;
end;

function TMap<K, V>.count(const key: K) : Integer;
begin
	result := tree.count(key);
end;

function TMap<K, V>.get_at(const key : K) : TPair<K, V>;
var iter : TIterator<K, V>;
begin
	iter := tree.find(key);
	result := iget(iter);
end;

function TMap<K, V>.locate(const key : K) : TIterator<K, V>;
begin
	result := tree.find(key);
end;

function TMap<K, V>.lower_bound(const key : K) : TIterator<K, V>;
begin
	result := tree.lower_bound(key);
end;

function TMap<K, V>.upper_bound(const key : K) : TIterator<K, V>;
begin
	result := tree.upper_bound(key);
end;

procedure TMap<K, V>.put_at(const key: K; value: V);
var pair : TPair<K, V>;
begin
  pair.first := key;
  pair.second := value;
	tree.insert(pair);
end;

procedure TMap<K, V>.remove(const key : K);
begin
	tree.eraseKey(key);
end;

procedure TMap<K, V>.remove_at(iterator : TIterator<K, V>);
begin
	tree.eraseAt(iterator);
end;

procedure TMap<K, V>.remove_in(_start, _finish : TIterator<K, V>);
begin
	tree.eraseIn(_start, _finish);
end;

function TMap<K, V>.start_key : TIterator<K, V>;
begin
	result := start;
end;


end.
