WITH cte_org AS (
	select T$EXEC 
	from T$EXEC
	where ENAME like 'DOCUMENTS_p'            
    UNION ALL
    SELECT 
        T$EXEC 
	from T$EXEC e
        INNER JOIN FORMLINKS o 
            ON o.SONFORM = e. T$EXEC
	where e.ENAME like 'ZCLA_%'
)
SELECT 'TAKESINGLEENT', T$EXEC.ENAME, TYPE FROM cte_org join T$EXEC on cte_org.T$EXEC = T$EXEC.T$EXEC
where ENAME  like 'ZCLA_%'
