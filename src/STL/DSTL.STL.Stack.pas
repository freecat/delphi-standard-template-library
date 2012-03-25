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
unit DSTL.STL.Stack;

interface

uses
  DSTL.STL.Deque;

type
  TStack<T> = class
  protected
    Stack: TDeque<T>;
  public
    constructor Create;
    function empty: boolean;
    function size: integer;
    function top: T;
    procedure push(x: T);
    procedure pop;
  end;

implementation

constructor TStack<T>.Create;
begin
  Stack := TDeque<T>.Create;
end;

function TStack<T>.empty: boolean;
begin
  Result := Stack.empty;
end;

function TStack<T>.size: integer;
begin
  Result := Stack.size;
end;

function TStack<T>.top: T;
begin
  Result := Stack.back;
end;

procedure TStack<T>.push(x: T);
begin
  Stack.push_back(x);
end;

procedure TStack<T>.pop;
begin
  Stack.pop_back;
end;

end.