/* 
Global replace Vendor for Supplier 
*/
update [system].[dbo].[T$EXEC]
set TITLE = REPLACE(TITLE, 'Vendor' , 'Supplier')
WHERE TITLE LIKE '%Vendor%'
AND LEN(REPLACE(TITLE, 'Vendor' , 'Supplier')) < 33

update [system].[dbo].[T$EXEC]
set TITLE = REPLACE(TITLE, 'Vendor' , 'Suppl.')
WHERE TITLE LIKE '%Vendor%'
AND LEN(REPLACE(TITLE, 'Vendor' , 'Supplier')) >= 33

update [system].[dbo].[COLUMNS]
set TITLE = REPLACE(TITLE, 'Vendor' , 'Supplier')
WHERE TITLE LIKE '%Vendor%'
AND LEN(REPLACE(TITLE, 'Vendor' , 'Supplier')) < 21

update [system].[dbo].[COLUMNS]
set TITLE = REPLACE(TITLE, 'Vendor' , 'Suppl.')
WHERE TITLE LIKE '%Vendor%'
AND LEN(REPLACE(TITLE, 'Vendor' , 'Supplier')) >= 21

update [system].[dbo].[EXTMSG]
set MESSAGE = REPLACE(MESSAGE, 'Vendor' , 'Supplier')
WHERE MESSAGE LIKE '%Vendor%'
AND LEN(REPLACE(MESSAGE, 'Vendor' , 'Supplier')) < 57

update [system].[dbo].[EXTMSG]
set MESSAGE = REPLACE(MESSAGE, 'Vendor' , 'Suppl.')
WHERE MESSAGE LIKE '%Vendor%'
AND LEN(REPLACE(MESSAGE, 'Vendor' , 'Supplier')) >= 57

update [system].[dbo].[LANGEXEC]
set TITLE = REPLACE(TITLE, 'Vendor' , 'Supplier')
WHERE TITLE LIKE '%Vendor%'
AND LEN(REPLACE(TITLE, 'Vendor' , 'Supplier')) < 65

update [system].[dbo].[LANGEXEC]
set TITLE = REPLACE(TITLE, 'Vendor' , 'Suppl.')
WHERE TITLE LIKE '%Vendor%'
AND LEN(REPLACE(TITLE, 'Vendor' , 'Supplier')) >= 65
