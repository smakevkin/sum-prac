unit validate;
interface
uses perem,rasp;
procedure read_file(ini:text;var _goods: TGoodsList;var k:integer;var _not_goods:TStringArray;var l:integer);
implementation

function valid(a:string;countGoods:integer): boolean;
begin
  if Length(a)>=52 then
    if a[7]='|' then
      if a[28]='|' then
        if a[35]='|' then
          if a[47]='|' then
            if a[52]='|' then valid:=true 
            else Writeln('В строке ',countGoods,' в поле Количество неверная длина символов, должно быть 6 символов')
          else Writeln('В строке ',countGoods,' в поле Дата неверная длина символов, должно быть 11 символов') 
         else Writeln('В строке ',countGoods,' в поле Код Поставщика неверная длина символов, должно быть 6 символов') 
       else Writeln('В строке ',countGoods,' в поле Наименование неверная длина символов, должно быть 20 символов') 
     else Writeln('В строке ',countGoods,' в поле Штрихкод неверная длина символов, должно быть 6 символов')
  else Writeln('В строке ',countGoods,' не хватает символов для обработки.');
end;

function check_barcode(a:string;countGoods:integer): boolean;
var i:integer;
stri:integer;
eror:integer;
fCheck,sCheck:boolean;
begin
  for i:=1 to Length(a) do if a[i] not in num then fCheck:=true;
  Val(a,stri,eror);
  if (stri<100000) or (stri>999999) then sCheck:=true;
  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Штрихкод ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только натуральные цифры от 0-9.');
  if (sCheck=true) and (fCheck=false) then Writeln('В строке ', countGoods, ' в поле Штрихкод ошибка "формат строки", поле надо изменить. В поле должно находитсья число от 100000 до 999999');
  
  if (fCheck or sCheck) = false then check_barcode:=true else check_barcode:=false;
end;

function check_product(a:string;countGoods:integer): boolean;
var i:integer;
fCheck,sCheck:boolean;
begin
  if a[1] not in rusupper then sCheck:=true;
  for i:=2 to Length(a) do begin
    if a[i]<>LowerCase(a[i]) then scheck:=true;
    if a[i] not in ruslower then fCheck:=true;
  end;

  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Наименование продукта ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только русские буквы.');
  if (sCheck=true) and (fCheck=false) then Writeln('В строке ', countGoods, ' в поле Наименование продукта ошибка "формат строки", поле надо изменить. В поле должно находиться русские слова, первое слово начинается с заглавной буквы, все остальные символы должны быть строчными');
  if (fCheck or sCheck) = false then check_product:=true else check_product:=false;
end;

function check_ProviderCode(a:string;countGoods:integer): boolean;
var i:integer;
stri:integer;
eror:integer;
fCheck,sCheck:boolean;
begin
  for i:=1 to Length(a) do if a[i] not in num then fCheck:=true;
  Val(a,stri,eror);
  if (stri<100000) or (stri>999999) then sCheck:=true;
  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Код поставщика ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только натуральные цифры от 0-9.');
  if (sCheck=true) and (fCheck=false) then Writeln('В строке ', countGoods, ' в поле Код Поставщика ошибка "формат строки", поле надо изменить. В поле должно находиться число от 100000 до 999999');
  
  if (fCheck or sCheck) = false then check_ProviderCode:=true else check_ProviderCode:=false;
end;

function check_Date_Day(a:string;month:string;year:integer;countGoods:integer): boolean;
var i:integer;
{1-недопустимые символы 2-формат строки 3-неправильная дата из-за месяца}
fCheck,sCheck,tCheck,fevCheck:boolean;
day,err:integer;
begin
  Val(a,day,err);
  for i:=1 to Length(a) do if (a[i] not in ['0','1','2','3','4','5','6','7','8','9',' ']) then fCheck:=true;
  if a[2]=' ' then sCheck:=true;
  if ((month = 'Фев') and ((year mod 4) = 0) and (day>29)) or ((month = 'Фев') and ((year mod 4) <> 0) and (day>28))then begin 
    tCheck:=true;
    fevCheck:=true;
  end;
  if ((month in mon31) and (day>31)) or ((month in mon30) and (day>30)) then tCheck:=true;
  if day<=0 then tCheck:=true;
  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Дата.День ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только натуральные цифры от 0-9.');
  if (sCheck=true) and (fCheck=false) then Writeln('В строке ', countGoods, ' в поле Дата.День ошибка "формат строки", поле надо изменить. Строка должна содержать две цифры, если день<10, слева должен быть пробел');
  if (tCheck=true) and (fevCheck=true)then Writeln('В строке ', countGoods, ' в поле Дата.День ошибка "Неправильная дата", надо изменить День. В високосном году, в феврале максимум 29 дней. Не в високосном максимум 28 дней');
  if (tCheck=true) and (fevCheck=false)then Writeln('В строке ', countGoods, ' в поле Дата.День ошибка "Неправильная дата", надо изменить День. День должен быть от 1 до 31');
  if (fCheck or sCheck or tCheck) = false then check_Date_day:=true else check_Date_day:=false;
end;

function check_Date_Month(a:string;countGoods:integer):boolean;
var i:integer;
fCheck,sCheck:boolean;
begin
  if a[1] not in rusupper then sCheck:=true;
  for i:=2 to Length(a) do begin
    if a[i]<>LowerCase(a[i]) then scheck:=true;
    if a[i] not in ruslower then fCheck:=true;
  end;
  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Дата.Месяц ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только русские буквы.');
  if (sCheck=true) and (fCheck=false) then Writeln('В строке ', countGoods, ' в поле Дата.Месяц ошибка "формат строки", поле надо изменить. В поле должно находиться русские слова, первое слово начинается с заглавной буквы, все остальные символы должны быть строчными');
  if (fCheck or sCheck) = false then check_Date_Month:=true else check_Date_Month:=false;
end;

function check_Date_Year(a:string;countGoods:integer):boolean;
var i:integer;
fCheck,sCheck:boolean;
stri:integer;
eror:integer;
begin
  for i:=1 to Length(a) do if a[i] not in num then fCheck:=true;
  Val(a,stri,eror);
  if (stri<2015) or (stri>2024) then sCheck:=true;
  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Дата.Год ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только натуральные цифры от 0-9.');
  if (sCheck=true) and (fCheck=false)then Writeln('В строке ', countGoods, ' в поле Дата.Год ошибка "формат строки", поле надо изменить. В поле должно находитсья число от 2015 до 2024');
  
  if (fCheck or sCheck) = false then check_Date_Year:=true else check_Date_Year:=false;
end;

function check_Amount(a:string;countGoods:integer): boolean;
var i:integer;
stri:integer;
eror:integer;
fCheck,sCheck:boolean;
begin
  for i:=1 to Length(a) do if a[i] not in num then fCheck:=true;
  Val(a,stri,eror);
  if (stri<1) or (stri>9999) then sCheck:=true;
  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Количество ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только натуральные цифры от 0-9.');
  if (sCheck=true) and (fcheck=false) then Writeln('В строке ', countGoods, ' в поле Количество ошибка "формат строки", поле надо изменить. В поле должно находитсья число от 1 до 9999, если числу не хватает 4 символов от слева должны быть соответствующие нули');
  
  if (fCheck or sCheck) = false then check_Amount:=true else check_Amount:=false;
end;

function check_Price(a:string;countGoods:integer): boolean;
var i:integer;
stri:real;
eror:integer;
fCheck,sCheck,tCheck:boolean;
dot:integer;
begin
  for i:=1 to Length(a) do if ((a[i] not in num) and (a[i]<>'.')) then fCheck:=true;
  Val(a,stri,eror);
  for i:=1 to Length(a) do begin
    if dot=0 then if a[i]='.' then dot:=i
    else if (a[dot+1] not in num) and (a[dot+2] not in num) then tCheck:=True;
  end;
  if Length(a)>(dot+3) then if a[dot+3] in num then tCheck:=true;
  if (stri<1) or (stri>99999.99) then sCheck:=true;
  if (fCheck=true) then Writeln('В строке ', countGoods, ' в поле Цена ошибка "недопустимые символы", из поля надо убрать недопустимые символы. В поле должны находиться только натуральные цифры от 0-9,либо символ "." .');
  if (sCheck=true) then Writeln('В строке ', countGoods, ' в поле Цена ошибка "формат строки", поле надо изменить. В поле должно находитсья число от 1.00.');
  if (tCheck=true) then Writeln('В строке ', countGoods, ' в поле Цена ошибка "неправильная цена", поле надо изменить. В поле должно находитсья вещественно число с максимум 2 цифрами после точки. Если цена-целое число, должно быть быть дописаны два нуля, после точки.');
  
  if (fCheck or sCheck or tCheck) = false then check_Price:=true else check_Price:=false;
end;

procedure check(s: string; var countGoods:integer;var k:integer;var l:integer;var _goods: TGoodsList;var _not_goods:TStringArray);
var{проверка правильности формата таблицы и после все остальные проверки}
  lolxd1, lolxd2, lolxd3, lolxd4, lolxd5, lolxd6: integer;
  chBar,chName,chProvider,chDateDay,chDateMon,chDateYear,chAmount,chPrice:boolean;
  checks: TGoods;
  tempPrice:string;
  i:integer;
begin
  if valid(s,countGoods)=true then begin //если валидация(проверка разделителей) прошла успешно, можно проверять дальше
      Val(Copy(s, 1, 6), checks.barcode, lolxd1);
      checks.product := s[8:28];
      Val(Copy(s, 29, 6), checks.ProviderCode, lolxd2);
      Val(Copy(s, 36, 2), checks.date.day, lolxd3);
      checks.date.month := s[39:42];
      Val(Copy(s, 43, 4), checks.date.year, lolxd4);
      Val(Copy(s, 48, 4), checks.amount, lolxd5);
      for i:=53 to Length(s) do begin
        tempPrice:=tempPrice+s[i]
      end;
      Val(tempPrice, checks.price, lolxd6);
      
      //требуется для корректного проведения всех тестов
      chBar:=check_barcode(Copy(s, 1, 6),countGoods);
      chName:=check_product(checks.product,countGoods);
      chProvider:=check_ProviderCode(Copy(s, 29, 6),countGoods);
      chDateDay:=check_Date_Day(Copy(s,36,2),checks.date.month,checks.date.year,countGoods);
      chDateMon:=check_Date_Month(checks.date.month,countGoods);
      chDateYear:=check_Date_Year(Copy(s, 43, 4),countGoods);
      chAmount:=check_Amount(Copy(s, 48, 4),countGoods);
      chPrice:=check_Price(tempPrice,countGoods);
      
      if (lolxd1 = 0) and (lolxd2 = 0) and (lolxd3 = 0) and (lolxd4 = 0) and (lolxd5 = 0) and (lolxd6 = 0) and
         chBar and
         chName and
         chProvider and
         chDateDay and chDateMon and chDateYear and
         chAmount and
         chPrice then begin
          inc(k);
          setGoods(_goods, k, checks);
          writeln('Строка ', countGoods,' успешно провалидирована.');
         end
      else begin
          inc(l);
          _not_goods[l] := s;
        end;
    end else begin
          inc(l);
          _not_goods[l] := s;
    end;
end;

procedure read_file(ini:text;var _goods: TGoodsList;var k:integer;var _not_goods:TStringArray;var l:integer);
var countGoods:integer;
  s: string;
    i:integer;
  restriction:boolean;

begin
  while (not eof(ini)) and (restriction<>True)  do
  begin
    Inc(i);
    if i<=M then begin
      Inc(countGoods);
      readln(ini, s);
      check(s, countGoods,k,l,_goods,_not_goods);
      writeln();
    end
    else restriction:=True;
  end;
  if restriction=True then
  begin
      Writeln('Начиная с строки ',countGoods,' обработка проводится не будет. Обрабатывается максимум 100 строк.');
  end;
end;
begin end.