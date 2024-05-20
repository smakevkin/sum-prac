unit perem;
interface
const
  M = 100;
  num = ['0','1','2','3','4','5','6','7','8','9'];
  mon31 = ['Янв','Мар','Май','Июл','Авг','Окт','Дек'];
  mon30 = ['Апр','Июн','Сен','Ноя'];
  ruslower = ['а','б','в','г','д','е','ё','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','ъ','ы','ь','э','ю','я',' '];
  rusupper = ['А','Б','В','Г','Д','Е','Ё','Ж','З','И','Й','К','Л','М','Н','О','П','Р','С','Т','У','Ф','Х','Ц','Ч','Ш','Щ','Ъ','Ы','Ь','Э','Ю','Я'];
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
    _goods: TGoodsList;
  _not_goods: TStringArray; 
  implementation
  begin end.