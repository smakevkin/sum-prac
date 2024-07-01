unit output;
interface

uses consts;
uses sort;
uses providers, goods, sells;

procedure printSheet(lp: list_prov; lg: list_goods; ls: list_sells; year: integer; quarter: integer; f: text);
function makeOutputString(sellDay: integer; goodName: string; provName: string; cost: real; amount: integer; sum: real): string;

implementation

procedure printSheet(lp: list_prov; lg: list_goods; ls: list_sells; year: integer; quarter: integer; f: text);
var sellCounter, i, j, k, l: integer;
    totalMonthAmount, totalAmount: integer;
    totalMonthSum, totalSum: real;
    p: provider;
    g: good;
    s: sell;
    res: string;
    gfsList: list_gfs;
    gfs: goodForSell;
    
begin
  writeln(f, 'Отчёт о продажах товаров розничным магазином "OKEY" за ' + quarter.ToString() + ' квартал ' + year.ToString() + ' года.');
  
  // Дата (День) - 2 символа
  // Наименование товара - 20 символов
  // Наименование поставщика - 20 символов
  // Цена - 12 символов
  // Количество - 6 символов
  // Сумма - 18 символов
  // Между каждым полем еще по 4 пробела
  // Это минимальные длины. Вообще даём больше места в основном из-за заголовков.
  writeln(f, '------------------------------------------------------------------------------------------------------------');
  writeln(f, 'Дата       Наименование            Наименование            Цена,           Количество    Сумма,            ');
  writeln(f, 'продажи    товара                  поставщика              руб.                          руб.              ');
  writeln(f, '------------------------------------------------------------------------------------------------------------');
  
  totalAmount := 0;
  totalSum := 0;
  for i := quarter * 3 - 2 to quarter * 3 do begin
    totalMonthAmount := 0;
    totalMonthSum := 0;
    sellCounter := 1;
    // Собираем информацию по продажам за месяц
    while sellCounter <= ls.count do begin
      s := ls.list[sellCounter];
      if s.date.getMonth() = i then begin
        for j := 1 to s.goods_list.count do begin      
          for k := 1 to lg.count do begin
            if lg.list[k].code = s.goods_list.list[j].code then begin
              l := 1;
              while (gfsList.list[l].code <> lg.list[k].code) and (gfsList.list[l].sellDay <> s.date.getDay()) and (l <= gfsList.count) do begin
                l := l + 1;
              end;
              if l > gfsList.count then begin
                gfs.amount := s.goods_list.list[j].amount;
                gfs.cost := s.goods_list.list[j].cost;
                gfs.code := lg.list[k].code;
                gfs.name := lg.list[k].name;
                gfs.sellDay := s.date.getDay();
                gfsList.list[l] := gfs;
                gfsList.count := gfsList.count + 1;
              end else gfsList.list[l-1].amount := gfsList.list[l-1].amount + s.goods_list.list[j].amount;
            end;
          end;
        end;
      end;
      sellCounter := sellCounter + 1;
    end;
    
    if gfsList.count <> 0 then writeln(f, 'Месяц ' + months_for_display[i]);
    
    // Сортируем наш массив с продажами за месяц
    bubbleSort(gfsList);
    
    // Выводим на экран потоварно
    j := 1;
    while j < gfsList.count do begin
      k := 1;
      while k < lg.count do begin
        if gfsList.list[j].code = lg.list[k].code then begin
          l := 1;
          while l < lp.Count do begin
            if lg.list[k].provider_code = lp.List[l].code then begin
              totalMonthAmount := totalMonthAmount + gfsList.list[j].amount;
              totalAmount := totalAmount + gfsList.list[j].amount;
              totalMonthSum := totalMonthSum + gfsList.list[j].cost * gfsList.list[j].amount;
              totalSum := totalSum + gfsList.list[j].cost * gfsList.list[j].amount;
              writeln(f, makeOutputString( gfsList.list[j].sellDay, lg.list[k].name, lp.list[l].name, gfsList.list[j].cost, gfsList.list[j].amount, gfsList.list[j].cost * gfsList.list[j].amount ));
            end;
            l := l + 1;
          end;
        end;
        k := k + 1;
      end;
      j := j + 1;
    end;
    
    // Выводим "Итого за месяц"
    if gfsList.count <> 0 then writeln(f, makeOutputString( 0, '', '', 0, totalMonthAmount, totalMonthSum));
  end;
  writeln(f, '..............................................................................................................');
  writeln(f, makeOutputString(-1, '', '', 0, totalAmount, totalSum));
end;

function makeOutputString(sellDay: integer; goodName: string; provName: string; cost: real; amount: integer; sum: real): string;
var i: integer;
    l: integer;
    res: string;
begin
  if sellDay = 0 then result := 'Итого за месяц:'
  else if sellDay = -1 then result := 'Итого:'
  else if sellDay < 10 then result := '0' + sellDay.ToString()
  else result := sellDay.ToString();
  for i := 1 to 5 do result := result + ' '; // нужны пять пробелов из-за заголовков
  result := result + '    '; // те самые 4 пробела между полями
  result := result + goodName;
  if sellDay = 0 then for i := 1 to 7 do result := result + ' ' // выравнивание "итого за месяц" с основными строками
  else if sellDay = -1 then for i := 1 to 16 do result := result + ' ' // выравнивание "итого" с основными строками
  else for i := 1 to 20 - goodName.Length do result := result + ' ';
  result := result + '    ';
  result := result + provName;
  for i := 1 to 20 - provName.Length do result := result + ' ';
  result := result + '    ';
  if sellDay > 0 then begin
    result := result + cost.ToString();
    l := cost.ToString().Length;
    if frac(cost).ToString().Length = 0 then begin result := result + '.00'; l := l + 3; end
    else if frac(cost).ToString().Length = 1 then begin result := result + '9'; l := l + 1; end;
    for i := 1 to 12 - l do result := result + ' ';
  end
  else result := result + '            ';
  result := result + '    ';
  result := result + amount.ToString();
  for i := 1 to 10 - amount.ToString().Length do result := result + ' '; // нужны 4 пробела из-за заголовка
  result := result + '    ';
  result := result + sum.ToString();
  l := sum.ToString().Length;
  if frac(sum).ToString().Length = 0 then begin result := result + '.00'; l := l + 3; end
  else if frac(sum).ToString().Length = 1 then begin result := result + '9'; l := l + 1; end;
  for i := 1 to 18 - l do result := result + ' ';
end;


end.