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
  DSTL.STL.Deque;

type
  TQueue<T> = class
  protected
    Queue: TDeque<T>;
  public
    constructor Create;
    function empty: boolean;
    function size: integer;
    function front: T;
    function back: T;
    procedure push(x: T);
    procedure pop;
  end;

  TPriorityQueue<T> = class
  protected
    Queue: TDeque<T>;
  public
    constructor Create;
    function empty: boolean;
    function size: integer;
    function front: T;
    function back: T;
    procedure push(x: T);
    procedure pop;
  end;

implementation

constructor TQueue<T>.Create;
begin
  Queue := TDeque<T>.Create;
end;

function TQueue<T>.empty: boolean;
begin
  Result := Queue.empty;
end;

function TQueue<T>.size: integer;
begin
  Result := Queue.size;
end;

function TQueue<T>.front: T;
begin
  Result := Queue.front;
end;

function TQueue<T>.back: T;
begin
  Result := Queue.back;
end;

procedure TQueue<T>.push(x: T);
begin
  Queue.push_back(x);
end;

procedure TQueue<T>.pop;
begin
  Queue.pop_front;
end;

constructor TPriorityQueue<T>.Create;
begin
  Queue := TDeque<T>.Create;
end;

function TPriorityQueue<T>.empty: boolean;
begin
  Result := Queue.empty;
end;

function TPriorityQueue<T>.size: integer;
begin
  Result := Queue.size;
end;

function TPriorityQueue<T>.front: T;
begin
  Result := Queue.front;
end;

function TPriorityQueue<T>.back: T;
begin
  Result := Queue.back;
end;

procedure TPriorityQueue<T>.push(x: T);
begin
  Queue.push_back(x);
  Queue.sort;
end;

procedure TPriorityQueue<T>.pop;
begin
  Queue.pop_front;
end;

end.
