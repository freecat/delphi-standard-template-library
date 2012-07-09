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
unit DSTL.STL.Queues;

interface

uses
  DSTL.STL.Vector, DSTL.STL.Deque, DSTL.STL.Heap;

type
  TQueue<T> = class
  protected
    queue: TSequence<T>;
  public
    constructor Create; overload;
    constructor Create(container: TSequence<T>); overload;
    function empty: boolean;
    function size: integer;
    function front: T;
    function back: T;
    procedure push(x: T);
    procedure pop;
  end;

  TPriorityQueue<T> = class
  protected
    queue: TSequence<T>;
  public
    constructor Create;  overload;
    constructor Create(container: TSequence<T>); overload;
    function empty: boolean;
    function size: integer;
    function front: T;
    function back: T;
    function top: T;
    procedure push(x: T);
    procedure pop;
  end;

implementation

constructor TQueue<T>.Create;
begin
  queue := TDeque<T>.Create;
end;

constructor TQueue<T>.Create(container: TSequence<T>);
begin
  queue := container.Create;
end;

function Tqueue<T>.empty: boolean;
begin
  Result := queue.empty;
end;

function TQueue<T>.size: integer;
begin
  Result := queue.size;
end;

function TQueue<T>.front: T;
begin
  Result := queue.front;
end;

function TQueue<T>.back: T;
begin
  Result := queue.back;
end;

procedure TQueue<T>.push(x: T);
begin
  queue.push_back(x);
end;

procedure TQueue<T>.pop;
begin
  queue.pop_front;
end;

constructor TPriorityQueue<T>.Create;
begin
  queue := TDeque<T>.Create;
end;

constructor TPriorityQueue<T>.Create(container: TSequence<T>);
begin
  queue := container.Create;
end;

function TPriorityQueue<T>.empty: boolean;
begin
  Result := queue.empty;
end;

function TPriorityQueue<T>.size: integer;
begin
  Result := queue.size;
end;

function TPriorityQueue<T>.front: T;
begin
  Result := queue.front;
end;

function TPriorityQueue<T>.back: T;
begin
  Result := queue.back;
end;

function TPriorityQueue<T>.top: T;
begin
  Result := queue.front;
end;

procedure TPriorityQueue<T>.push(x: T);
begin
  queue.push_back(x);
  THeapAlgorithms<T>.push_heap(queue.start, queue.finish);
end;

procedure TPriorityQueue<T>.pop;
begin
  THeapAlgorithms<T>.pop_heap(queue.start, queue.finish);
  queue.pop_back;
end;

end.
