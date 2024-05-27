unit sells;
interface

uses errors;
uses space_one;
uses consts;
uses goods;

type sell = record
  date: date; // Дата продажи
  goods_list: array[1..max_goods] of record
    code: integer;
    amount: integer;
    cost: integer;
  end;
end;
list_sells = record
  list: array[1..possible_records] of sell;
  count: integer;
end;

function makeSellObjectFromString(s: string): sell;
function validateSellString(s: string): string;
function validateSellObject(s: sell; gl: list_goods; sl: list_sells): string;

implementation

function makeSellObjectFromString(s: string): sell;
var i, err: integer;
begin
  val(get_next(s), Result.date.day, err);
  Result.date.month := months.IndexOf(get_next(s)) + 1;
  val(get_next(s), Result.date.year, err);
  
  i := 1;
  while (i <= max_goods) and (s <> '') do begin
    val(get_next(s), Result.goods_list[i].code, err);
    val(get_next(s), Result.goods_list[i].amount, err);
    val(get_next(s), Result.goods_list[i].cost, err);
    i := i + 1;
  end;
end;

function validateSellString(s: string): string;
var err_string, t_err_string: string;
var t_s: string;
var t_i, i: integer;
var t_r: real;
var t_err: integer;
var t_flag: boolean;
var t_switch: integer;
var t_date: record
  day: integer;
  month: integer;
  year: integer;
end;
begin
  err_string := validate(s, max_goods * 3 + 3);
  
  // Проверка на соблюдение заданного формата данных.
  if err_string = '' then begin
    // -------- ДАТА (ДЕНЬ) --------
    t_s := get_next(s);
    t_flag := true; // Флаг правильности даты
    val(t_s, t_date.day, t_err);
    
    // Проверка на длину строки и на отсутствие лишних символов
    if (t_s.Length <> 2) or (t_err <> 0) then begin 
      append_err(err_string, 'ДАТА (ДЕНЬ): День должен состоять из двух цифр (если число меньше 10, то следует добавить 0 в начало).');
      t_flag := false;
    end
    else begin
      // Проверка на то, чтобы день не был больше 31 или меньше 1
      if (t_date.day > 31) then append_err(err_string, 'ДАТА (ДЕНЬ): День не может быть больше 31.');
      if (t_date.day < 1) then append_err(err_string, 'ДАТА (ДЕНЬ): День не может быть меньше 1.');
    end;
    
    // -------- ДАТА (МЕСЯЦ) --------
    t_s := get_next(s);
    
    // Проверка, что задан верный месяц
    if not months.Contains(t_s) then begin 
      append_err(err_string, 'ДАТА (МЕСЯЦ): Месяц должен состоять из трёх латинских букв по началу их названия (например, "JAN" для января (January)).');
      t_flag := false;
    end
    else begin
      t_date.month := months.IndexOf(t_s);
      if t_flag then begin
        // Проверка, является ли последний день чётного месяца 30-м
        if (t_date.month in ([4, 6, 9, 11])) and (t_date.month <> 2) and (t_date.day > 30) then append_err(err_string, 'ДАТА (МЕСЯЦ): Апрель, июнь, сентябрь и ноябрь имеют всего 30 дней.');
        // Проверка, является ли месяц февралём и день меньшим, чем 30
        if (t_date.month = 2) and (t_date.day > 29) then append_err(err_string, 'ДАТА (МЕСЯЦ): В феврале не может быть больше 29 дней.');
      end;
    end;
    
    // -------- ДАТА (ГОД) --------
    t_s := get_next(s);
    
    // Проверка, что нет лишних символов
    val(t_s, t_date.year, t_err);
    if (t_err <> 0) or (t_date.year < 2000) or (t_date.year > 2099) then begin
      append_err(err_string, 'ДАТА (ГОД): Год должен состоять из четырёх цифр и означать год 21 века (20xx) или 2000-й год.');
      t_flag := false;
    end
    else begin
      if t_flag then begin
        // Проверка на високосные года
        if (t_date.month = 2) and (t_date.day = 29) and ((t_date.year mod 4 <> 0) or ((t_date.year mod 100 = 0) and (t_date.year mod 400 <> 0))) then append_err(err_string, 'ДАТА: 29 февраля может быть только в високосные года.');
      end;
    end;

    // -------- СПИСОК ТОВАРОВ --------
    i := 0;
    t_switch := 0; // переключатель поля товара
    while (s <> '') do begin
      t_s := get_next(s);
      
      if t_switch = 0 then begin
        i := i + 1;
        t_err_string := '';
        
        // Проверка на начало кода НЕ с нуля
        if t_s[1] = '0' then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Код товара не может начинаться с 0.');
        
        // Проверка на отсутствие лишних символов в коде товара
        val(t_s, t_i, t_err);
        if (t_err <> 0) or (t_i > 999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Код товара должен состоять ТОЛЬКО максимум из 8 цифр, не должно быть букв и других символов.');
        
        if t_err_string <> '' then err_string := err_string + t_err_string;
        t_switch := 1;
      end
      else if t_switch = 1 then begin
        t_err_string := '';
        
        // Проверка на начало кол-ва НЕ с нуля
        if t_s[1] = '0' then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Кол-во товара не может начинаться с 0.');
        
        // Проверка на отсутствие лишних символов в кол-ве товара
        val(t_s, t_i, t_err);
        if (t_err <> 0) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Кол-во товара должен состоять ТОЛЬКО из цифр, не должно быть букв и других символов.');
        
        if t_err_string <> '' then err_string := err_string + t_err_string;
        t_switch := 2;
      end
      else if t_switch = 2 then begin
        t_err_string := '';
        
        // Проверка на начало кол-ва НЕ с нуля
        if t_s[1] = '0' then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Стоимость товара не может начинаться с 0.');
        
        // Проверка на отсутствие лишних символов в кол-ве товара
        val(t_s, t_r, t_err);
        if (t_err <> 0) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(t_err_string, 'ТОВАР №' + i.ToString() + ': Стоимость товара должен состоять ТОЛЬКО из цифр, не должно быть букв и других символов.');
        
        // Проверка на наличие точки и конкретно двух цифр после неё
        t_i := pos('.', t_s);
        if (t_i = 0) or (t_s.Length - t_i <> 2) then append_err(err_string, 'ТОВАР №' + i.ToString() + ': В стоимости товара обязательно должно присутствовать две цифры после точки, даже если дробное значение равно нулю (тогда стоимость должна иметь ".00" в конце).');
        
        if t_err_string <> '' then err_string := err_string + t_err_string;
        t_switch := 0;
      end;
    end;
  end;
  Result := err_string;
end;

function validateSellObject(s: sell; gl: list_goods; sl: list_sells): string;
var i, j: integer;
var flag: boolean;
var err_string: string;
begin
  // TODO: сравнение по дате поступления-продажи
  err_string := '';

  // -------- ДАТА ПРОДАЖИ --------
  for i := 1 to sl.Count do begin
    if (s.date.day = sl.List[i].date.day) and (s.date.month = sl.List[i].date.month) and (s.date.year = sl.List[i].date.year) then append_err(err_string, 'ДАТА: В эту дату уже произошла продажа. Объедините информацию о данных продажах.');
  end;

  // -------- СПИСОК ТОВАРОВ --------
  i := 1;
  j := 0;
  while (i <= max_goods) and (s.goods_list[i].code <> 0) do begin
    // TODO: по условию возможно описание одинаковых товаров от разных поставщиков, причем еще и в разных кол-вах. нужно сделать проверку правильно, учитывая это
    if j <> 0 then
      if s.goods_list[i].code < j then append_err(err_string, 'СПИСОК ТОВАРОВ: Список не отсортирован по кодам товаров.');
    
    // Проверка на наличие всех кодов товаров
    flag := false;
    j := 1;
    while not flag and (j <= gl.Count) do begin
      if gl.List[j].code = s.goods_list[i].code then flag := true // для кода дальше подходит получение самого первого, т.к. в сортировке реализована сортировка по дате в том числе. по сути берем самого раннего.
      else j := j + 1;
    end;
    if not flag then append_err(err_string, 'ТОВАР №' + i.ToString() + ': Код товара не соответствует ни одному из зарегистрированных товаров.')
    else if (gl.List[j].arrival_date.year > s.date.year) or (gl.List[j].arrival_date.month > s.date.month) or (gl.List[j].arrival_date.day > s.date.day) then append_err(err_string, 'ТОВАР №' + i.ToString() + ': Дата поступления товара установлена на более позднюю, чем дата его продажи.');
    j := s.goods_list[i].code; // здесь j выступит в роли временного хранилища для кода
    i := i + 1;
  end;
  Result := err_string;
end;

end.