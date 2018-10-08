SELECT NULL mykey,
       c.name,
       t.name AS [Table],
       c.name AS [Column],
       c.collation_name AS [Collation],
       TYPE_NAME(c.system_type_id) AS [TypeName],
       c.max_length AS [TypeLength]
FROM sys.columns c
    RIGHT JOIN sys.tables t
        ON c.object_id = t.object_id
WHERE c.collation_name IS NOT NULL
  AND t.name=N'ToolWorkOrderDetail'