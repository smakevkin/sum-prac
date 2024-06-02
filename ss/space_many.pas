﻿unit space_many;
interface

uses errors;

function get_next(var s: string): string;
function validate(s: string; max_elements_count: integer): string;

implementation

function get_next(var s: string): string;
var i: integer;
begin
  if s = '' then Result := ''
  else begin
    i := 1;
    while (i <= s.Length) and (s[i] <> ' ') do i := i + 1;
    Result := copy(s, 1, i-1);
    while (i <= s.Length) and (s[i] = ' ') do i := i + 1;
    s := copy(s, i, s.Length - i + 1);
  end;
end;

function validate(s: string; max_elements_count: integer): string;
var i, count: integer;
var space_flag: boolean;
var err_string: string;
begin
  err_string := '';
  
  if s.Length = 0 then append_err(err_string, 'ФОРМАТ ДАННЫХ: Обнаружена пустая строка.')
  else begin
    if s[1] = ' ' then append_err(err_string, 'ФОРМАТ ДАННЫХ: Строка не должна начинаться с пробела.');
    if s[s.Length] = ' ' then append_err(err_string, 'ФОРМАТ ДАННЫХ: Строка не должна оканчиваться на пробел.');
    
    count := 1;
    for i := 1 to s.Length do begin
      if (s[i] = ' ') and not space_flag then begin
        space_flag := true;
        count := count + 1;
      end
      else if (s[i] <> ' ') then space_flag := false;
    end;
    if (count > max_elements_count) then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком много данных. Строка должна иметь ровно 3 поля: код поставщика, наименование и номер телефона.')
    else if (count < 3) then append_err(err_string, 'ФОРМАТ ДАННЫХ: Слишком мало данных. Строка должна иметь ровно 3 поля: код поставщика, наименование и номер телефона.')
    //else if (count mod 2 = 1) then append_err(err_string, 'ФОРМАТ ДАННЫХ: Неверное количество данных. Товары имеют по два поля: код и кол-во. У последнего товара указан только код.');
  end;
  
  Result := err_string;
end;

end.