unit DSTL.STL.Alloc;

interface
uses
  Windows, DSTL.Types, DSTL.Exception;

type
  IAllocator<T> = interface(IInterface)
    function allocate(size: integer): pointer;
    procedure deallocate(p: pointer); overload;
    procedure deallocate(p: pointer; size: integer); overload;
    procedure reallocate(p: pointer; size: TSizeType);
  end;

  TAllocator<T> = class(TInterfacedObject, IAllocator<T>)
    function allocate(size: integer): pointer;
    procedure deallocate(p: pointer); overload;
    procedure deallocate(p: pointer; size: integer); overload;
    procedure reallocate(p: pointer; size: TSizeType);
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

procedure TAllocator<T>.reallocate(p: pointer; size: TSizeType);
begin
  try
    ReallocMem(p, size);
  except
    dstl_raise_exception(E_OUT_OF_MEMORY);
  end;
end;

end.
