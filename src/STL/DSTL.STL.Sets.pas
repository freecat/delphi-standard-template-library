unit DSTL.STL.Sets;

interface
uses
  DSTL.STL.Iterator, DSTL.STL.RBTree, DSTL.Utils.Pair, Generics.Defaults;

type
  TSet<T> = class(TContainer<T, T>)
  protected
    tree: TRedBlackTree<T, T>;

    procedure iadvance(var Iterator: TIterator<T, T>);  override;
    function iat_end(const Iterator: TIterator<T, T>): boolean; override;
    function iequals(const iter1, iter2: TIterator<T, T>): Boolean;  override;
    function iremove(const Iterator: TIterator<T, T>): TIterator<T, T>; override;
    procedure iretreat(var Iterator: TIterator<T, T>);  override;
    procedure clear;
  public
    constructor Create;
    destructor Destroy;   override;
    function start: TIterator<T, T>;
    function finish: TIterator<T, T>;
    procedure add(const obj: T);
    procedure remove(const obj : T);
    function includes(const obj: T): boolean;
  end;

implementation

constructor TSet<T>.Create;
begin
  tree := TRedBlackTree<T, T>.Create(Self, true, TComparer<T>.Default);
end;

destructor TSet<T>.Destroy;
begin
	tree.free;
	inherited;
end;

procedure TSet<T>.iadvance(var Iterator: TIterator<T, T>);
begin
  with Iterator do
  begin
    tree.RBincrement(node);
  end;
end;

function TSet<T>.iat_end(const Iterator: TIterator<T, T>): boolean;
begin
  Result := Iterator.node = tree.EndNode;
end;

function TSet<T>.iequals(const iter1, iter2: TIterator<T, T>): Boolean;
begin
  result := iter1.node = iter2.node;
end;

function TSet<T>.iremove(const Iterator: TIterator<T, T>): TIterator<T, T>;
begin
  result := Iterator;
  iadvance(result);
  tree.eraseAt(Iterator);
end;

procedure TSet<T>.iretreat(var Iterator: TIterator<T, T>);
begin
  with Iterator do
  begin
    tree.RBdecrement(Iterator.node);
  end;
end;

procedure TSet<T>.clear;
begin
  tree.erase(true);
end;

function TSet<T>.start : TIterator<T, T>;
begin
	result := tree.start;
end;

function TSet<T>.finish : TIterator<T, T>;
begin
	result := tree.finish;
end;

procedure TSet<T>.add(const obj: T);
begin
  tree.insert(TPair<T, T>.Create(obj, T(nil)));
end;

procedure TSet<T>.remove(const obj : T);
begin
	tree.eraseKey(obj);
end;

function TSet<T>.includes(const obj: T): boolean;
var
  iter: TIterator<T, T>;
  io: TIterOperations<T, T>;
begin
  iter := tree.find(obj);
	result := not io.equals(iter, finish);
end;

end.
