unit goods;
interface

uses errors;
uses tabular;
uses consts;
uses providers;

type good = record
  code: integer;
  name: string;
  provider_code: integer;
  arrival_date: consts.Date;
  amount: integer;
  cost: real;
end;

list_goods = record
  list: array[1..possible_records] of good;
  count: integer;
end;

function makeGoodObjectFromString(s: string): good;
function validateGoodString(s: string): string;
function validateGoodObject(g: good; gl: list_goods; pl: list_prov): string;

implementation

function makeGoodObjectFromString(s: string): good;
var err: integer;
var _d, _m, _y: integer;
begin
  val(get_next(s,6), Result.code, err);
  Result.name := get_next(s,20);
  val(get_next(s,6), Result.provider_code, err);

  val(get_next(s,2), _d, err);
  _m := months.IndexOf(get_next(s,3)) + 1;
  val(get_next(s,4), _y, err);
  Result.arrival_date := Date.create(_d,_m,_y);

  val(get_next(s,4), Result.amount, err);
  val(get_next(s,12), Result.cost, err);
end;

function validateGoodString(s: string): string;
var err_string: string;
var t_s: string;
var t_i: integer;
var t_r: real;
var t_flag: boolean;
var t_err: integer;
var t_date: record
  day: integer;
  month: integer;
  year: integer;
end;
var tab_lengths: array of integer = (6, 20, 6, 2, 3, 4, 4, 12);
begin
  err_string := validate(s, tab_lengths);
  
  // Проверка на соблюдение заданного формата данных.
  if err_string = '' then begin
    // -------- КОД ТОВАРА --------
    t_s := get_next(s, tab_lengths[0]);
    
    // Проверка на начало кода НЕ с нуля
    if t_s[1] = '0' then append_err(err_string, 'КОД ТОВАРА: Код товара не может начинаться с 0.');
    
    // Проверка на длину кода и отсутствие лишних символов в коде
    val(t_s, t_i, t_err);
    if (t_err <> 0) or (t_i > 999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'КОД ТОВАРА: Код товара должен состоять ТОЛЬКО максимум из 6 цифр, не должно быть букв и других символов вроде "+", "-" и т.п.');
    
    // -------- НАИМЕНОВАНИЕ ТОВАРА --------
    t_s := get_next(s, tab_lengths[1]);
    
    // Проверка на начало имени НЕ на _
    if t_s[1] = '_' then append_err(err_string, 'НАИМЕНОВАНИЕ ТОВАРА: Наименование товара не может начинаться с нижнего подчеркивания.');
    
    // Проверка на оканчивание имени НЕ на пробел или _
    if t_s[t_s.Length] = '_' then append_err(err_string, 'НАИМЕНОВАНИЕ ТОВАРА: Наименование товара не может оканчиваться на нижнее подчёркивание.');
    
    // Проверка на отсутствие невалидных символов
    t_flag := false;
    for t_i := 1 to t_s.Length do begin
      if t_s[t_i] not in ['A'..'Z', 'А'..'Я', 'a'..'z', 'а'..'я', '0'..'9', '_'] then t_flag := true;
    end;
    if t_flag then append_err(err_string, 'НАИМЕНОВАНИЕ ТОВАРА: Обнаружены неприемлимые символы. Разрешены только русский и английский алфавит, цифры и нижнее подчёркивание.');
    
    // -------- КОД ПОСТАВЩИКА ТОВАРА --------
    t_s := get_next(s, tab_lengths[2]);
    
    // Проверка на начало кода НЕ с нуля
    if t_s[1] = '0' then append_err(err_string, 'КОД ПОСТАВЩИКА: Код поставщика не может начинаться с 0.');
    
    // Проверка на длину кода и отсутствие лишних символов в коде
    val(t_s, t_i, t_err);
    if (t_err <> 0) or (t_i > 999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'КОД ПОСТАВЩИКА: Код поставщика должен состоять ТОЛЬКО максимум из 6 цифр, не должно быть букв и других символов вроде "+", "-" и т.п.');
    
    // -------- ДАТА (ДЕНЬ) --------
    t_s := get_next(s, tab_lengths[3]);
    t_flag := true; // Флаг правильности даты
    val(t_s, t_date.day, t_err);
    
    // Проверка на отсутствие лишних символов
    if (t_err <> 0) then begin
      append_err(err_string, 'ДАТА (ДЕНЬ): День должен состоять только из цифр (одной, если число меньше 10, иначе двух).');
      t_flag := false;
    end;

    // Проверка на длину строки (чтобы день задавался одной цифрой только если день меньше 10)
    if (t_s.Length <> 2) and (t_date.day >= 10) then begin 
      append_err(err_string, 'ДАТА (ДЕНЬ): День должен состоять из одной цифры только если число меньше 10.');
      t_flag := false;
    end
    else begin
      // Проверка на то, чтобы день не был больше 31 или меньше 1
      if (t_date.day > 31) then append_err(err_string, 'ДАТА (ДЕНЬ): День не может быть больше 31.');
      if (t_date.day < 1) then append_err(err_string, 'ДАТА (ДЕНЬ): День не может быть меньше 1.');
    end;

    // -------- ДАТА (МЕСЯЦ) --------
    t_s := get_next(s, tab_lengths[4]);
    
    // Проверка, что задан верный месяц
    if not months.Contains(t_s) then begin 
      append_err(err_string, 'ДАТА (МЕСЯЦ): Месяц должен быть задан заглавными буквами по первым трём буквам его русского названия (например, "ЯНВ" для января).');
      t_flag := false;
    end
    else begin
      t_date.month := months.IndexOf(t_s);
      if t_flag then begin
        // Проверка, является ли последний день чётного месяца 30-м
        if (t_date.month in ([4, 6, 9, 11])) and (t_date.day > 30) then append_err(err_string, 'ДАТА (МЕСЯЦ): Апрель, июнь, сентябрь и ноябрь имеют всего 30 дней.');
        // Проверка, является ли месяц февралём и день меньшим, чем 30
        if (t_date.month = 2) and (t_date.day > 29) then append_err(err_string, 'ДАТА (МЕСЯЦ): В феврале не может быть больше 29 дней.');
      end;
    end;
    
    // -------- ДАТА (ГОД) --------
    t_s := get_next(s,tab_lengths[5]);
    
    // Проверка, что нет лишних символов
    val(t_s, t_date.year, t_err);
    if (t_err <> 0) or (t_date.year < 2000) or (t_date.year > 2099) then begin
      append_err(err_string, 'ДАТА (ГОД): Год должен состоять из четырёх цифр и означать год 21 века (20xx) или 2000-й год.');
      t_flag := false;
    end
    else begin
      if t_flag then begin
        // Проверка на високосные года
        if (t_date.month = 2) and (t_date.day = 29) and ((t_date.year mod 4 <> 0) or ((t_date.year mod 100 = 0) and (t_date.year mod 400 <> 0))) then append_err(err_string, 'ДАТА (ГОД): 29 февраля может быть только в високосные года.');
      end;
    end;

    // -------- КОЛИЧЕСТВО ТОВАРА --------
    t_s := get_next(s, tab_lengths[6]);

    if t_s[1] = '0' then append_err(err_string, 'КОЛИЧЕСТВО ТОВАРА: Количество товара не может начинаться с 0.');

    // Проверка на отсутствие + и - в начале и в целом знаков
    val(t_s, t_i, t_err);
    if (t_s[1] = '+') or (t_s[1] = '-') or (t_err <> 0) then append_err(err_string, 'КОЛИЧЕСТВО ТОВАРА: Количество товара не должно иметь символы, отличные от цифр.');

    // // Проверка на длину числа
    // if (t_i > 9999) then append_err(err_string, 'КОЛИЧЕСТВО ТОВАРА: Количество товара не может быть больше 9999 за раз.');
    
    // -------- СТОИМОСТЬ ТОВАРА --------
    t_s := get_next(s, tab_lengths[7]);
    
    // Проверка на начало стоимости на 0
    if (t_s[1] = '0') then append_err(err_string, 'СТОИМОСТЬ ТОВАРА: Стоимость товара не может начинаться с 0.');
    
    // Проверка на отсутствие + и - в начале и в целом лишних знаков
    val(t_s, t_r, t_err);
    if (t_s[1] = '+') or (t_s[1] = '-') or (t_err <> 0) then append_err(err_string, 'СТОИМОСТЬ ТОВАРА: Стоимость товара не должна включать в себя символы, отличные от цифр и точки. Она должна являться вещественным числом максимум из 10 символов (7 цифр перед точкой, сама точка и две обязательных цифры после точки).');
    
    // Проверка на наличие точки и конкретно двух цифр после неё
    t_i := pos('.', t_s);
    if (t_i = 0) or (t_s.Length - t_i <> 2) then append_err(err_string, 'СТОИМОСТЬ ТОВАРА: В стоимости товара обязательно должно присутствовать две цифры после точки, даже если дробное значение равно нулю (тогда стоимость должна иметь ".00" в конце).');
    
  end;
  Result := err_string;
end;

function validateGoodObject(g: good; gl: list_goods; pl: list_prov): string;
var i: integer;
var t_flag: boolean;
var err_string: string;
begin
  err_string := '';

  // УНИКАЛЬНОСТЬ
  for i := 1 to gl.Count do begin
    if gl.List[i].code = g.code then append_err(err_string, 'КОД ТОВАРА: Произошёл конфликт в виде повтора кода товара с кодом другого уже зарегистрированного товара.');
  end;
  
  // считаем, что если товар с одинаковым именем поставляется разными поставщиками, то это два разных товара => разные коды товара, следовательно они повторяться не должны
  for i := 1 to gl.Count do begin
    if (gl.list[i].name = g.name) and (gl.list[i].provider_code = g.provider_code) then append_err(err_string, 'НАИМЕНОВАНИЕ ТОВАРА и КОД ПОСТАВЩИКА: Произошёл конфликт в виде повтора данных о товаре, включая и наименование, и код поставщика, с данными другого уже зарегистрированного товара.');
  end;
  
  // СУЩЕСТВОВАНИЕ ПОСТАВЩИКА ПО КОДУ
  if err_string = '' then begin
    t_flag := false;
    for i := 1 to pl.Count do begin
      if pl.List[i].code = g.provider_code then t_flag := true;
    end;
    if not t_flag then append_err(err_string, 'КОД ПОСТАВЩИКА: Указанный в товаре код поставщика не найден среди зарегистрированных поставщиков.');
  end;
  
  Result := err_string;
end;

end.