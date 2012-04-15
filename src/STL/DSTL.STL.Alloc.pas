unit DSTL.STL.Alloc;

interface

type
  IAllocator<T> = interface(IInterface)
    function allocate(size: integer): pointer;
    procedure deallocate(p: pointer); overload;
    procedure deallocate(p: pointer; size: integer); overload;
  end;

  TAllocator<T> = class(TInterfacedObject, IAllocator<T>)
    function allocate(size: integer): pointer;
    procedure deallocate(p: pointer); overload;
    procedure deallocate(p: pointer; size: integer); overload;
  end;

implementation

function TAllocator<T>.allocate(size: integer): pointer;
begin
  GetMem(Result, size);
end;

procedure TAllocator<T>.deallocate(p: pointer);
begin
  FreeMem(p);
end;

procedure TAllocator<T>.deallocate(p: pointer; size: integer);
begin
  FreeMem(p, size);
end;

end.
