unit rasp;
interface
uses perem;
procedure setGoods(var arr: TGoodsList; k: integer; checks: TGoods);
procedure SortGoodsAscending(var arr: TGoodsList; count: integer);
implementation
procedure setGoods(var arr: TGoodsList; k: integer; checks: TGoods);
begin
  arr[k] := checks;
end;

procedure SortGoodsAscending(var arr: TGoodsList; count: integer);
var
  i, j: integer;
  temp: TGoods;
begin
  for i := 1 to count - 1 do
    for j := 1 to count - i do
      if arr[j].amount < arr[j + 1].amount then
      begin
        temp := arr[j];
        arr[j] := arr[j + 1];
        arr[j + 1] := temp;
      end;
end;
begin end.