unit DSTL.STL.DequeMap;

interface
uses
  DSTL.Types;

const
  MAX_BUFFER_SIZE = 32767;

type
  TDequeBuffer<T> = array [0 .. MAX_BUFFER_SIZE div sizeof(TBaseObject) - 1] of T;
  TDequeMapNode<T> = class
    buf: ^TDequeBuffer<T>;
    prev, next: TDequeMapNode<T>;
  end;

implementation

end.
