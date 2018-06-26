if object_id('tempdb..#tempTable') is not null Begin
    truncate table #tempTable
    drop table #tempTable
End