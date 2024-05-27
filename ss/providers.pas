unit providers;
interface

uses errors;
uses space_many;
uses consts;

type provider = record
  code: integer;
  name: string;
  phone: int64;
end;
list_prov = record
  List: array[1..possible_records] of provider;
  Count: integer;
end;

function makeProviderObjectFromString(s: string): provider;
function validateProviderString(s: string): string; // Валидация ФОРМАТА данных
function validateProviderObject(p: provider; pl: list_prov): string; // Валидация ОБЪЕКТА

implementation

function makeProviderObjectFromString(s: string): provider;
var i, err: integer;
begin
  val(get_next(s), Result.code, err);
  Result.name := get_next(s);
  val(get_next(s), Result.phone, err);
end;

function validateProviderString(s: string): string;
var err_string: string;
var t_s: string;
var t_i: integer;
var t_l: int64;
var t_err: integer;
begin
  err_string := validate(s, 3);
  
  // Проверка на соблюдение заданного формата данных.
  if err_string = '' then begin
    // -------- КОД ЗАКАЗА --------
    t_s := get_next(s);
    
    // Проверка на начало кода заказа (не должно быть нуля в начале)
    if t_s[1] = '0' then append_err(err_string, 'КОД ЗАКАЗА: Код заказа не может начинаться с 0.');
    
    // Проверка на отсутствие лишних символов в коде заказа
    val(t_s, t_i, t_err);
    if (t_err <> 0) or (t_i > 99999999) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'КОД ЗАКАЗА: Код заказа должен состоять ТОЛЬКО максимум из 8 цифр, не должно быть букв и других символов.');
    
    // -------- НАИМЕНОВАНИЕ ЗАКАЗЧИКА --------
    t_s := get_next(s);
    
    // Проверка на длину наименования заказчика (не больше 32)
    if t_s.Length > 32 then append_err(err_string, 'НАИМЕНОВАНИЕ ЗАКАЗЧИКА: Длина наименования заказчика не может быть больше 32 символов.');
    
    // Проверка на начало имени НЕ на _
    if t_s[1] = '_' then append_err(err_string, 'НАИМЕНОВАНИЕ ЗАКАЗЧИКА: Наименование заказчика не может начинаться с нижнего подчеркивания.');
    
    // Проверка на оканчивание имени НЕ на _
    if t_s[t_s.Length] = '_' then append_err(err_string, 'НАИМЕНОВАНИЕ ЗАКАЗЧИКА: Наименование заказчика не может оканчиваться на нижнее подчёркивание.');
    
    // -------- НОМЕР ТЕЛЕФОНА --------
    // Пример: 78009921385
    t_s := get_next(s);
    val(t_s, t_l, t_err);
    
    // Проверка на длину номера телефона и на отсутствие лишних символов.
    if (t_s.Length <> 11) or (t_err <> 0) or (t_s[1] = '+') or (t_s[1] = '-') then append_err(err_string, 'НОМЕР ТЕЛЕФОНА: Номер телефона должен быть записан, используя только 11 цифр.');
    
    // Проверка на начало номера на 7
    if (t_s[1] <> '7') then append_err(err_string, 'НОМЕР ТЕЛЕФОНА: Номер должен начинаться с 7 (код России).');
  end;

  Result := err_string;
end;

function validateProviderObject(p: provider; pl: list_prov): string;
var i, j: integer;
var flag: boolean;
var err_string: string;
begin
  err_string := '';
  
  // -------- КОД ПОСТАВЩИКА --------
  for i := 1 to pl.Count do begin
    if pl.List[i].code = p.code then append_err(err_string, 'КОД ПОСТАВЩИКА: Произошёл конфликт в виде совпадения кода поставщика с кодом другого уже зарегистрированного поставщика.');
    if (pl.List[i].phone = p.phone) and (pl.List[i].name <> p.name) then append_err(err_string, 'НОМЕР ТЕЛЕФОНА: Один и тот же номер телефона не может принадлежать разным поставщикам.');
  end;
  Result := err_string;
end;

end.