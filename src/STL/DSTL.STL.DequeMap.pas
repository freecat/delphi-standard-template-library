unit DSTL.STL.DequeMap;

interface
uses
  DSTL.Types;

type
  TDequeBuffer<T> = array [0 .. MaxInt div sizeof(TBaseObject) - 1] of T;
  TDequeMapNode<T> = class
    buf: ^TDequeBuffer<T>;
    prev, next: TDequeMapNode<T>;
  end;

implementation

end.
