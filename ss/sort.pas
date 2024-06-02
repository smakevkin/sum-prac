unit sort;
interface

uses goods, sells;
uses consts;

procedure quickSort(var lg: list_goods; low: integer; high: integer);
procedure quickSort(var ls: list_sells; low: integer; high: integer);
function stringCompare(s1, s2: string): integer;
function dateCompare(d1, d2: date): integer;
//procedure filterByYear(var lp: list_prod; var lo: list_ord; year: integer);

implementation

procedure quickSort(var lg: list_goods; low: integer; high: integer);
var i, j: integer;
var pivot: good;
var iRes, jRes: integer;
begin
  if low < high then begin
    pivot := lg.List[(low + high) div 2];
    i := low;
    j := high;
    repeat
      iRes := stringCompare(lg.List[i].name, pivot.name);
      jRes := stringCompare(lg.List[j].name, pivot.name);
      while 
        (iRes = -1) or 
        (
          (iRes = 0) and 
          (
            (lg.List[i].arrival_date.year <= pivot.arrival_date.year) and 
            (lg.List[i].arrival_date.month <= pivot.arrival_date.month) and 
            (lg.List[i].arrival_date.day <= pivot.arrival_date.day)
          )
        ) or 
        (
          (iRes = 0) and 
          (lg.List[i].code <= pivot.code)
        ) 
      do begin
        i := i + 1;
        iRes := stringCompare(lg.List[i].name, pivot.name);
      end;
      while 
        (jRes = 1) or 
        (
          (jRes = 0) and 
          (
            (lg.List[j].arrival_date.year > pivot.arrival_date.year) and 
            (lg.List[j].arrival_date.month > pivot.arrival_date.month) and 
            (lg.List[j].arrival_date.day > pivot.arrival_date.day)
          )
        ) or 
        (
          (jRes = 0) and 
          (lg.List[j].code > pivot.code)
        ) 
        do begin
        j := j - 1;
        jRes := stringCompare(lg.List[j].name, pivot.name);
      end;
      if i <= j then begin
        (lg.List[i], lg.List[j]) := (lg.List[j], lg.List[i]);
        i := i + 1;
        j := j - 1;
      end;
    until i > j;
    
    if low < j then quickSort(lg, low, j);
    if i < high then quickSort(lg, i, high); 
  end;
end;

procedure quickSort(var ls: list_sells; low: integer; high: integer);
var i, j: integer;
var pivot: sell;
var iRes, jRes: integer;
begin
  if low < high then begin
    pivot := ls.List[(low + high) div 2];
    i := low;
    j := high;
    repeat
      iRes := dateCompare(ls.List[i].date, pivot.date);
      jRes := dateCompare(ls.List[j].date, pivot.date);
      while (iRes = -1) do begin
        i := i + 1;
        iRes := dateCompare(ls.List[i].date, pivot.date);
      end;
      while (jRes = 1) do begin
        j := j - 1;
        jRes := dateCompare(ls.List[j].date, pivot.date);
      end;
      if i <= j then begin
        (ls.List[i], ls.List[j]) := (ls.List[j], ls.List[i]);
        i := i + 1;
        j := j - 1;
      end;
    until i > j;
    
    if low < j then quickSort(ls, low, j);
    if i < high then quickSort(ls, i, high); 
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
  i := (d1.year - d2.year) * 31622400 + (d1.month - d2.month) * 2592000 + (d1.day - d2.day) * 86400; // че-то типа сравнения даты по UNIX таймстампу
  if i < 0 then result := -1
  else if i > 0 then result := 1;
end;

end.
