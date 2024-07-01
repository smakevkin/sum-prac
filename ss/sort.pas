unit sort;
interface

uses goods, sells;
uses consts;

type goodForSell = record
  code: integer;
  name: string;
  amount: integer;
  cost: real;
  sellDay: integer;
end;
type list_gfs = record
  list: array[1..possible_records*31] of goodForSell;
  count: integer;
end;

procedure bubbleSort(var lg: list_goods);
procedure bubbleSort(var ls: list_sells);
procedure bubbleSort(var lgfs: list_gfs);
function stringCompare(s1, s2: string): integer;
function dateCompare(d1, d2: date): integer;
//procedure filterByYear(var lp: list_prod; var lo: list_ord; year: integer);

implementation

procedure bubbleSort(var lg: list_goods);
var i, j: integer;
begin
  for i := 1 to lg.count-1 do begin
    for j := i+1 to lg.count do begin
      if 
        (stringCompare(lg.list[i].name, lg.list[j].name) = 1) or
        (dateCompare(lg.list[i].arrival_date, lg.list[j].arrival_date) = 1)
      then (lg.list[i], lg.list[j]) := (lg.list[j], lg.list[i]);
    end;
  end;
end;

procedure bubbleSort(var ls: list_sells);
var i, j: integer;
begin
  for i := 1 to ls.count-1 do begin
    for j := i+1 to ls.count do begin
      if 
        (dateCompare(ls.list[i].date, ls.list[j].date) = 1)
      then (ls.list[i], ls.list[j]) := (ls.list[j], ls.list[i]);
    end;
  end;
end;

procedure bubbleSort(var lgfs: list_gfs);
var i, j: integer;
begin
  for i := 1 to lgfs.count-1 do begin
    for j := i+1 to lgfs.count do begin
      if 
        (stringCompare(lgfs.list[i].name, lgfs.list[j].name) = 1) or
        (lgfs.list[i].sellDay > lgfs.list[j].sellDay)
      then (lgfs.list[i], lgfs.list[j]) := (lgfs.list[j], lgfs.list[i]);
    end;
  end;
end;

function stringCompare(s1, s2: string): integer;
// Если s1 < s2 - -1
// Если s1 = s2 - 0
// Если s1 > s2 - 1
var c1, c2: char;
var i: integer;
begin
  result := 0;
  if (s1 = '') and (s2 = '') then result := 0
  else if (s1.Length < s2.Length) then result := -1
  else if (s1.Length > s2.Length) then result := 1
  else begin
    i := 1;
    c1 := s1[i];
    c2 := s2[i];
    while (i <= s1.Length) and (result = 0) do begin
      if c1 < c2 then result := -1
      else if c1 > c2 then result := 1;
      i := i + 1;
      if i <= s1.Length then begin
        c1 := s1[i];
        c2 := s2[i];
      end;
    end;
  end;
end;

function dateCompare(d1, d2: date): integer;
// Если d1 < d2 - -1
// Если d1 = d2 - 0
// Если d1 > d2 - 1
var i: int64;
begin
  result := 0;
  i := (d1.getYear() - d2.getYear()) * 31622400 + (d1.getMonth() - d2.getMonth()) * 2592000 + (d1.getDay() - d2.getDay()) * 86400; // че-то типа сравнения даты по UNIX таймстампу
  if i < 0 then result := -1
  else if i > 0 then result := 1;
end;

end.
