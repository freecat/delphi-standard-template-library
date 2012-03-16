unit DSTL.Utils.Pair;

interface

type
  TPair<T1, T2> = record
    first: T1;
    second: T2;

    constructor Create(first: T1; second: T2);
  end;

implementation

constructor TPair<T1, T2>.Create(first: T1; second: T2);
begin
  Self.first := first;
  Self.second := second;
end;

end.
