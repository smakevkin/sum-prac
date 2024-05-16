unit perem;
interface
const
  M = 100;
type
  TDate = record
    day: integer;
    month: string[3];
    year: integer;
  end;

  TGoods = record
    barcode: integer;
    product: string[20];
    ProviderCode: integer;
    date: TDate;
    amount: integer;
    price: real;
  end;

  TGoodsList = array[1..M] of TGoods;
  TStringArray = array[1..M] of string;
  var k, l: integer;
  implementation
  begin
    
  end.