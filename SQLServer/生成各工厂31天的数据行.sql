--生成各工厂31天的数据行
with
temp_area as
(
  select N'企业1' Enterprise, N'工厂1' Plant
  union
  select N'企业2' Enterprise, N'工厂2' Plant
  union
  select N'企业3' Enterprise, N'工厂3' Plant
),
PIVOT_Table as
(
  select Enterprise, Plant, 1 [1], 1 [2], 1 [3], 1 [4], 1 [5], 1 [6], 1 [7], 1 [8], 1 [9], 1 [10], 1 [11], 1 [12],
         1 [13], 1 [14], 1 [15], 1 [16], 1 [17], 1 [18], 1 [19], 1 [20], 1 [21], 1 [22], 1 [23], 1 [24], 1 [25],
         1 [26], 1 [27], 1 [28], 1 [29], 1 [30], 1 [31]
  from   temp_area
),
temp_days as
(
  select *
  from   PIVOT_Table unpivot([RowCount] for sday in([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31])) as t
)
select * from temp_days;