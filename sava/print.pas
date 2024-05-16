unit print;
interface
uses perem;
procedure PrintGoodsArray(var outF: Text; arr: TGoodsList; count: integer);
procedure PrintErrorArray(var errorF: Text; var errors: TStringArray; count: integer);
implementation
procedure PrintGoodsArray(var outF: Text; arr: TGoodsList; count: integer);
var
  i: integer;
  pricestr, tempo: string;
begin
  for i := 1 to count do
  begin
    Str(arr[i].price:0:2, pricestr);
    if arr[i].date.day > 9 then
      tempo := Concat(IntToStr(arr[i].barcode), '|', arr[i].product, '|', IntToStr(arr[i].ProviderCode), '|',
                      IntToStr(arr[i].date.day), ' ', arr[i].date.month, ' ', IntToStr(arr[i].date.year), '|',
                      IntToStr(arr[i].amount), '|', pricestr)
    else
      tempo := Concat(IntToStr(arr[i].barcode), '|', arr[i].product, '|', IntToStr(arr[i].ProviderCode), '| ',
                      IntToStr(arr[i].date.day), ' ', arr[i].date.month, ' ', IntToStr(arr[i].date.year), '|',
                      IntToStr(arr[i].amount), '|', pricestr);
    writeln(outF, tempo);
  end;
end;

procedure PrintErrorArray(var errorF: Text; var errors: TStringArray; count: integer);
var
  i: integer;
begin
  for i := 1 to count do
    writeln(errorF, errors[i]);
end;
begin
  
end.