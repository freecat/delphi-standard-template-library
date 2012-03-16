unit DSTL.Utils.Range;

interface

uses
  DSTL.STL.Iterator;

type
  TRange<T> = record
    start, finish: TIterator<T>;
  end;

  TRange<T1, T2> = record
    start, finish: TIterator<T1, T2>;
  end;

implementation

end.
