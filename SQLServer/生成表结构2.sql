SELECT     'create table [' + so.name + '] (' + o.list + ')'
           + CASE
               WHEN tc.CONSTRAINT_NAME IS NULL THEN ''
             ELSE
               'ALTER TABLE ' + so.name + ' ADD CONSTRAINT ' + tc.CONSTRAINT_NAME + ' PRIMARY KEY ' + ' ('
               + LEFT(j.list, LEN(j.list) - 1) + ')'
             END
FROM       sysobjects so
CROSS APPLY( SELECT   '  [' + COLUMN_NAME + '] ' + DATA_TYPE
                      + CASE DATA_TYPE
                          WHEN 'sql_variant' THEN ''
                          WHEN 'text' THEN ''
                          WHEN 'decimal' THEN
                            '(' + CAST(NUMERIC_PRECISION_RADIX AS VARCHAR) + ', ' + CAST(NUMERIC_SCALE AS VARCHAR) + ')'
                        ELSE COALESCE('(' + CASE
                                              WHEN CHARACTER_MAXIMUM_LENGTH = -1 THEN 'MAX'
                                            ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR)
                                            END + ')', '')
                        END + ' '
                      + CASE
                          WHEN EXISTS ( SELECT id
                                        FROM   syscolumns
                                        WHERE  OBJECT_NAME(id) = so.name
                                          AND  name = COLUMN_NAME
                                          AND  COLUMNPROPERTY(id, name, 'IsIdentity') = 1 ) THEN
                            'IDENTITY(' + CAST(IDENT_SEED(so.name) AS VARCHAR) + ','
                            + CAST(IDENT_INCR(so.name) AS VARCHAR) + ')'
                        ELSE ''
                        END + ' ' + ( CASE
                                        WHEN IS_NULLABLE = 'No' THEN 'NOT '
                                      ELSE ''
                                      END ) + 'NULL '
                      + CASE
                          WHEN INFORMATION_SCHEMA.COLUMNS.COLUMN_DEFAULT IS NOT NULL THEN
                            'DEFAULT ' + INFORMATION_SCHEMA.COLUMNS.COLUMN_DEFAULT
                        ELSE ''
                        END + ', '
             FROM     INFORMATION_SCHEMA.COLUMNS
             WHERE    TABLE_NAME = so.name
             ORDER BY ORDINAL_POSITION
             FOR XML PATH('')) o(list)
LEFT JOIN  INFORMATION_SCHEMA.TABLE_CONSTRAINTS tc ON tc.TABLE_NAME = so.name
                                                  AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
CROSS APPLY( SELECT   '[' + COLUMN_NAME + '], '
             FROM     INFORMATION_SCHEMA.KEY_COLUMN_USAGE kcu
             WHERE    kcu.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
             ORDER BY ORDINAL_POSITION
             FOR XML PATH('')) j(list)
WHERE      xtype = 'U'
  AND      name NOT IN ('dtproperties');