program letpract;


// TODO!!!: выходной файлик по условию

uses consts; // модуль констант, общих для всей программы
uses providers, goods, sells; // модули работы с отдельными входными файлами
uses sort; // модуль сортировки
//uses output; // модуль вывода отчёта

const providers_in_filename = 'providers.txt';
const goods_in_filename = 'goods.txt';
const sells_in_filename = 'sells.txt';

var err_string, line: string;
var file_record_count, sheetYear, sheetQuarter: integer;
var f_prov, f_goods, f_sells, f_out: text;
var l_prov: list_prov; l_goods: list_goods; l_sells: list_sells;
var prov: provider; good: good; sell: sell;
begin
  assign(f_prov, providers_in_filename);
  assign(f_goods, goods_in_filename);
  assign(f_sells, sells_in_filename);
  reset(f_prov); 
  reset(f_goods);
  reset(f_sells);
  
  file_record_count := 0;
  l_prov.Count := 0;
  while (not eof(f_prov)) and (l_prov.Count <= possible_records) do begin
    err_string := '';
    readln(f_prov, line);
    file_record_count := file_record_count + 1;
    err_string := err_string + validateProviderString(line);
    if err_string <> '' then begin
      writeln('Ошибки в ' + providers_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
    end else begin
      prov := makeProviderObjectFromString(line);
      err_string := validateProviderObject(prov, l_prov);
      if err_string <> '' then begin
        writeln('Ошибки в ' + providers_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
      end else begin
        l_prov.Count := l_prov.Count + 1;
        l_prov.List[l_prov.Count] := prov;
        writeln(l_prov.List[l_prov.Count]);
      end;
    end;
  end;
  if not eof(f_prov) and (l_prov.Count > possible_records) then writeln('Слишком много записей о провайдерах. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
  close(f_prov);
  
  if l_prov.Count = 0 then writeln('В файле ' + providers_in_filename + ' не найдено ни одной валидной записи о провайдерах!')
  else begin
    file_record_count := 0;
    l_goods.Count := 0;
    while (not eof(f_goods)) and (l_goods.Count <= possible_records) do begin
      err_string := '';
      readln(f_goods, line);
      file_record_count := file_record_count + 1;
      err_string := err_string + validateGoodString(line);
      if err_string <> '' then begin
        writeln('Ошибки в ' + goods_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
      end else begin
        good := makeGoodObjectFromString(line);
        err_string := validateGoodObject(good, l_goods, l_prov);
        if err_string <> '' then begin
          writeln('Ошибки в ' + goods_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
        end else begin
          l_goods.Count := l_goods.Count + 1;
          l_goods.List[l_goods.Count] := good;
          writeln(l_goods.List[l_goods.Count]);
        end;
      end;
    end;
    if not eof(f_goods) and (l_goods.Count > possible_records) then writeln('Слишком много записей о товарах. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
    close(f_goods);
    
    if l_goods.Count = 0 then Writeln('В файле ' + goods_in_filename + ' не найдено ни одной валидной записи о товарах!')
    else begin
      quickSort(l_goods, 1, l_goods.Count); // ПЕРВЫМ ДЕЛОМ ОТСОРТИРОВАТЬ ТОВАРЫ (ВАЖНО!)
      
      file_record_count := 0;
      l_sells.Count := 0;
      while (not eof(f_sells)) and (l_sells.Count <= possible_records) do begin
        err_string := '';
        readln(f_sells, line);
        file_record_count := file_record_count + 1;
        err_string := err_string + validateSellString(line);
        if err_string <> '' then begin
          writeln('Ошибки в ' + sells_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
        end else begin
          sell := makeSellObjectFromString(line);
          err_string := validateSellObject(sell, l_goods, l_sells);
          if err_string <> '' then begin
            writeln('Ошибки в ' + sells_in_filename + ' на ' + file_record_count.ToString() + ' строке:' + err_string);
          end else begin
            l_sells.Count := l_sells.Count + 1;
            l_sells.List[l_sells.Count] := sell;
            writeln(l_sells.List[l_sells.Count]);
          end;
        end;
      end;
      if not eof(f_sells) and (l_sells.Count > possible_records) then writeln('Слишком много записей о продажах. Зарегистрировано максимальное доступное количество (' + possible_records.ToString() + ').');
      close(f_sells);
      
      quickSort(l_sells, 1, l_sells.Count);
      
      sheetYear := 0;
      while sheetYear < 2000 or sheetYear > 2099 do begin
        write('Введите год для создания отчёта (2000-2099): ');
        readln(sheetYear);
      end;

      sheetQuarter := 0;
      while sheetQuarter not in [1, 2, 3, 4] do begin
        write('Введите квартал для создания отчёта (1-4): ');
        readln(sheetQuarter);
      end;
      
      assign(f_out, 'sheet_' + sheetYear.ToString() + '-' + sheetQuarter.ToString() + '.txt');
      rewrite(f_out);
      
      printSheet(l_prov, l_goods, l_sells, sheetYear, sheetQuarter, f_out);
      
      close(f_out);

      writeln('Успешно!');
    end;
  end;
end.