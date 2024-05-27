unit consts;
interface

type date = record
  day: integer;
  month: integer;
  year: integer;
end;

const possible_records = 100;
const max_goods = 100;
const months: array of string = (
  'ЯНВ', 'ФЕВ', 'МАР', 'АПР', 'МАЙ', 'ИЮН', 'ИЮЛ', 'АВГ', 'СЕН', 'ОКТ', 'НОЯ', 'ДЕК'
);
const months_for_display: array of string = (
  'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
);

implementation

end.