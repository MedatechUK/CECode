# Example: Loading Large Volumes of Data in Priority ERP

This script demonstrates how to process large datasets in Priority ERP by breaking them into manageable batches. It starts from a given line number (stored in `:LN`) and processes records up to the next occurrence of a record with `RECORDTYPE = '1'`, which acts as a batch delimiter. This approach is useful for handling large data imports or migrations without overwhelming system resources.

## How It Works

1. Starting Point: The script begins at a specified line number (e.g., `:LN = 11687`).
2. Batch Identification: It finds the next record with `RECORDTYPE = '1'` to define the end of the current batch.
3. Processing: The batch is isolated, processed via an external interface (e.g., `ZLIA_MIG_PLOTEXTS`), and results are updated.
4. Logging: Progress and results are appended to a text file.
5. Iteration: The script moves to the next batch and repeats until all data is processed, but only if all records in the current batch are successfully loaded.

## Sample Script

```sql
/* Initialize variables and file */
:C = :LN = 11687 ;  /* Starting line number */
SELECT '' FROM DUMMY FORMAT '../../GENERALLOAD.txt' ;  /* Create output file */
SELECT SQL.TMPFILE INTO :GEN FROM DUMMY ;  /* Generate temp file handle */
LINK GENERALLOAD TO :GEN ;  /* Link data table to temp file */
ERRMSG 99 WHERE :RETVAL = 0 ;  /* Stop if linking fails */
/* */
/* Find the first batch starting point */
SELECT MIN(LINE) INTO :LN
FROM GENERALLOAD ORIG
WHERE RECORDTYPE = '1'
AND   LINE > :LN ;
/* */
/* Main processing loop */
LABEL 10 ;
SELECT MIN(LINE) INTO :C  /* Find next RECORDTYPE '1' as batch end */
FROM GENERALLOAD ORIG
WHERE RECORDTYPE = '1'
AND   LINE > :LN ;
/* */
/* Isolate and process the batch */
DELETE FROM GENERALLOAD ;
INSERT INTO GENERALLOAD
SELECT * FROM GENERALLOAD ORIG
WHERE LINE BETWEEN :LN AND :C - 1 ;
EXECUTE INTERFACE 'ZLIA_MIG_PLOTEXTS', SQL.TMPFILE, '-L', :GEN ;  /* Process batch */
/* */
/* Update results using a cursor */
DECLARE GL CURSOR FOR SELECT LINE, LOADED, KEY1, KEY2 FROM GENERALLOAD ;
OPEN GL ;
GOTO 101 WHERE :RETVAL <= 0 ;
LABEL 100 ;
:LINE = 0 ; :KEY1 = :KEY2 = '' ; :LOADED = '\0' ;
FETCH GL INTO :LINE, :LOADED, :KEY1, :KEY2 ;
GOTO 99 WHERE :RETVAL = 0 ;
UPDATE GENERALLOAD ORIG
SET LOADED = :LOADED, KEY1 = :KEY1, KEY2 = :KEY2
WHERE LINE = :LINE ;
LOOP 100 ;
LABEL 99 ;
CLOSE GL ;
LABEL 101 ;
/* */
/* Log progress */
SELECT :LN AS FROMLINE, :C - 1 AS TOLINE FROM DUMMY FORMAT ADDTO '../../GENERALLOAD.txt' ;
SELECT * FROM GENERALLOAD FORMAT ADDTO '../../GENERALLOAD.txt' ;
/* */
/* Move to next batch or exit */
GOTO 999 WHERE EXISTS(  /* Stop if any record isn't loaded successfully */
    SELECT * FROM GENERALLOAD
    WHERE 0=0
    AND   LINE > 0
    AND   LOADED <> 'Y'
);
SELECT :C INTO :LN FROM DUMMY ;
LOOP 10 WHERE EXISTS (
    SELECT 'x' FROM GENERALLOAD ORIG
    WHERE RECORDTYPE = '1'
    AND   LINE >= :LN
);
/* */
/* Cleanup */
LABEL 999 ;
UNLINK GENERALLOAD ;
```

## Key Features
Incremental Loading: Starts at :LN (e.g., 11687) and processes up to the next RECORDTYPE = '1' (stored in :C), avoiding memory overload.
Batch Control: Uses MIN(LINE) to locate batch boundaries dynamically.
External Processing: Calls ZLIA_MIG_PLOTEXTS to handle the heavy lifting (e.g., data transformation or loading).
Progress Tracking: Updates fields like LOADED (e.g., 'Y' for success) and logs each batch to a file.
Looping with Safety: Repeats only if all records in the current batch have LOADED = 'Y' and there’s a RECORDTYPE = '1' at or beyond :LN; otherwise, it exits to LABEL 999.

## Usage Notes
Customization: Replace :LN = 11687 with your desired starting line and adjust ZLIA_MIG_PLOTEXTS to your interface.
Table: GENERALLOAD is the working table; ORIG refers to the source data.
Output: Results are appended to ../../GENERALLOAD.txt for monitoring.
Error Handling: The script will quit after a bad loading (e.g., if EXECUTE INTERFACE fails or any record has LOADED <> 'Y'), thanks to the GOTO 999 check. You can then review the log in ../../GENERALLOAD.txt, fix the data, and restart from the last :LN.

## Why It’s Effective
By processing data in batches marked by RECORDTYPE = '1', this method ensures scalability. The GOTO 999 WHERE EXISTS(...) statement prevents the script from proceeding if any record fails to load (i.e., LOADED <> 'Y'), and the LINE >= :LN condition ensures all batch boundaries are correctly processed, making it reliable for large datasets like importing millions of records into Priority ERP.
