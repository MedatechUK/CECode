# PrioritySQL Storage Repartitioning Instructions


**Machine**: CE-AZ-UK-S-PRIO (PrioritySQL)  
**Date**: March 15, 2025  
**Objective**: Expand F: and G: disks to 4 TB each, repartition them by removing existing partitions, create 1 GB base partitions with mount points (`Priority` at 1.5 TB, `Dev` at 1 TB, `Test` at 1.5 TB), and copy files back to these mount points without modifying SQL database locations. Add a 4 TB attachments disk (I:) for temporary storage.

---

## Final Structure

- **Disk 4 (4 TB, F: expanded from 1 TB):**  
  - **F:** 1 GB base partition, labeled `SQLVMDATA1`.  
    - **F:\Priority**: 1.5 TB mount point (hosts Priority data files, e.g., `F:\Priority\PriorityDB.mdf`).  
    - **F:\Dev**: 1 TB mount point (hosts Dev data files, e.g., `F:\Dev\DevDB.mdf`).  
    - **F:\Test**: 1.5 TB mount point (hosts Test data files, e.g., `F:\Test\TestDB.mdf`).  
- **Disk 5 (4 TB, G: expanded from 1 TB):**  
  - **G:** 1 GB base partition, labeled `SQLVMLOG`.  
    - **G:\Priority**: 1.5 TB mount point (hosts Priority log files, e.g., `G:\Priority\PriorityDB.ldf`).  
    - **G:\Dev**: 1 TB mount point (hosts Dev log files, e.g., `G:\Dev\DevDB.ldf`).  
    - **G:\Test**: 1.5 TB mount point (hosts Test log files, e.g., `G:\Test\TestDB.ldf`).  
- **Disk 6 (4 TB, new I:)**  
  - **I:** 4 TB single partition, labeled `ATTACHMENTS`.

---

## Instructions

### Step 1: Add a Temporary 4 TB Disk as I:

1. **In Azure Portal**:  
   - Navigate to VM (`CE-AZ-UK-S-PRIO`) > **Disks** > **Create and attach a new disk**.  
   - Settings:  
     - Name: `ATTACHMENTS`  
     - Size: 4096 GB (P40 Premium SSD)  
     - Type: Premium SSD  
   - Save and wait for the disk to attach.

2. **Initialize the Disk on the VM**:  
   ```cmd
   diskpart
   DISKPART> list disk  (note the new 4 TB disk, e.g., Disk 6)
   DISKPART> select disk 6
   DISKPART> convert gpt
   DISKPART> create partition primary
   DISKPART> format fs=ntfs label="ATTACHMENTS" quick
   DISKPART> assign letter=I
   DISKPART> exit
   ```

---

### Step 2: Copy and Verify Files from F: and G: to I:

1. **Stop SQL Server Instances**:  
   ```cmd
   net stop "MSSQL$PRIORITY"
   net stop "MSSQL$DEV"
   net stop "MSSQL$TEST"
   ```

2. **Run Copy and Verify Batch Script**:  
   - Save the following as `CopyAndVerify.bat` and run it in an elevated Command Prompt:  
   ```cmd
   @echo off
   setlocal enabledelayedexpansion

   echo Copying files from F: drive...
   robocopy "f:\pridata" i:\From F Drive\pridata" /E /XO /V /R:5 /W:5
   robocopy "f:\pridev" "i:\From F Drive\pridev" /E /XO /V /R:5 /W:5
   robocopy "f:\pritest" "i:\From F Drive\pritest" /E /XO /V /R:5 /W:5

   echo Copying files from G: drive...
   robocopy "g:\pridata" "i:\From G Drive\pridata" /E /XO /V /R:5 /W:5
   robocopy "g:\pridev" "i:\From G Drive\pridev" /E /XO /V /R:5 /W:5
   robocopy "g:\pritest" "i:\From G Drive\pritest" /E /XO /V /R:5 /W:5

   echo Verifying files from F: drive...
   for /R "f:\Priority" %%f in (*.*) do (
      set "destfile=i:\From F Drive\Priority\%%~pnxf"
      set "destfile=!destfile:f:\Priority\=!"
      if exist "!destfile!" (
         fc /B "%%f" "!destfile!" >> comparison_log.txt 2>&1
      )
   )
   for /R "f:\Dev" %%f in (*.*) do (
      set "destfile=i:\From F Drive\Dev\%%~pnxf"
      set "destfile=!destfile:f:\Dev\=!"
      if exist "!destfile!" (
         fc /B "%%f" "!destfile!" >> comparison_log.txt 2>&1
      )
   )
   for /R "f:\Test" %%f in (*.*) do (
      set "destfile=i:\From F Drive\Test\%%~pnxf"
      set "destfile=!destfile:f:\Test\=!"
      if exist "!destfile!" (
         fc /B "%%f" "!destfile!" >> comparison_log.txt 2>&1
      )
   )

   echo Verifying files from G: drive...
   for /R "g:\Priority" %%f in (*.*) do (
      set "destfile=i:\From G Drive\Priority\%%~pnxf"
      set "destfile=!destfile:g:\Priority\=!"
      if exist "!destfile!" (
         fc /B "%%f" "!destfile!" >> comparison_log.txt 2>&1
      )
   )
   for /R "g:\Dev" %%f in (*.*) do (
      set "destfile=i:\From G Drive\Dev\%%~pnxf"
      set "destfile=!destfile:g:\Dev\=!"
      if exist "!destfile!" (
         fc /B "%%f" "!destfile!" >> comparison_log.txt 2>&1
      )
   )
   for /R "g:\Test" %%f in (*.*) do (
      set "destfile=i:\From G Drive\Test\%%~pnxf"
      set "destfile=!destfile:g:\Test\=!"
      if exist "!destfile!" (
         fc /B "%%f" "!destfile!" >> comparison_log.txt 2>&1
      )
   )

   echo Verification complete. Check comparison_log.txt for details.
   pause
   ```  
   - **Notes**:  
     - `robocopy` ensures reliable copying with retries (`/R:5 /W:5`) and verbose logging (`/V`).  
     - `fc /B` performs binary comparison, logging results to `comparison_log.txt`.  
     - Folder names are `Priority`, `Dev`, `Test` to match mount points.

3. **Check Verification**:  
   - Open `comparison_log.txt` and look for "No differences encountered" for each file. Any discrepancies indicate a copy issue.

---

### Step 3: Repartition F: and G: Disks

1. **Remove Existing Partitions on F:**:  
   ```cmd
   diskpart
   DISKPART> list disk  (identify Disk 4, e.g., 4 TB)
   DISKPART> select disk 4
   DISKPART> clean  (removes all partitions)
   DISKPART> convert gpt
   DISKPART> create partition primary size=1000
   DISKPART> format fs=ntfs label="SQLVMDATA1" quick
   DISKPART> assign letter=F
   DISKPART> create partition primary size=1536000  (1.5 TB)
   DISKPART> format fs=ntfs label="Priority_Data" quick
   DISKPART> assign mount=F:\Priority
   DISKPART> create partition primary size=1024000  (1 TB)
   DISKPART> format fs=ntfs label="Dev_Data" quick
   DISKPART> assign mount=F:\Dev
   DISKPART> create partition primary size=1536000  (1.5 TB)
   DISKPART> format fs=ntfs label="Test_Data" quick
   DISKPART> assign mount=F:\Test
   DISKPART> exit
   ```

2. **Remove Existing Partitions on G:**:  
   ```cmd
   diskpart
   DISKPART> list disk  (identify Disk 5, e.g., 4 TB)
   DISKPART> select disk 5
   DISKPART> clean  (removes all partitions)
   DISKPART> convert gpt
   DISKPART> create partition primary size=1000
   DISKPART> format fs=ntfs label="SQLVMLOG" quick
   DISKPART> assign letter=G
   DISKPART> create partition primary size=1536000  (1.5 TB)
   DISKPART> format fs=ntfs label="Priority_Logs" quick
   DISKPART> assign mount=G:\Priority
   DISKPART> create partition primary size=1024000  (1 TB)
   DISKPART> format fs=ntfs label="Dev_Logs" quick
   DISKPART> assign mount=G:\Dev
   DISKPART> create partition primary size=1536000  (1.5 TB)
   DISKPART> format fs=ntfs label="Test_Logs" quick
   DISKPART> assign mount=G:\Test
   DISKPART> exit
   ```

3. **Verify**:  
   ```cmd
   dir F:\
   dir G:\
   diskpart
   DISKPART> list volume  (F: as SQLVMDATA1, G: as SQLVMLOG)
   DISKPART> exit
   ```

---

### Step 4: Copy Files Back to F: and G:

1. **Copy Files**:  
   ```cmd
   xcopy "I:\From F Drive\*.*" F:\ /E /H /C /I /Y
   xcopy "I:\From G Drive\*.*" G:\ /E /H /C /I /Y
   ```  
   - **Key Point**: Files are copied from `I:\From F Drive` to F: and `I:\From G Drive` to G:, preserving the original folder structure (`Priority`, `Dev`, `Test`) now as mount points.

2. **Verify**:  
   ```cmd
   dir F:\Priority
   dir F:\Dev
   dir F:\Test
   dir G:\Priority
   dir G:\Dev
   dir G:\Test
   ```

---

### Step 5: Restart SQL Server Instances

1. **Start Instances**:  
   ```cmd
   net start "MSSQL$PRIORITY"
   net start "MSSQL$DEV"
   net start "MSSQL$TEST"
   ```  
   - **No SQL Updates Needed**: File paths (e.g., `F:\Priority\PriorityDB.mdf`) are identical, so SQL Server requires no reconfiguration.

---

## Notes

- **Partition Sizes**:  
  - 1 GB base = 1000 MB.  
  - 1.5 TB = 1,536,000 MB (Priority, Test).  
  - 1 TB = 1,024,000 MB (Dev).  
  - Total: 1 GB + 1.5 TB + 1 TB + 1.5 TB ≈ 4 TB (4096 GB).  
- **Folder Names**: Mount points (`F:\Priority`, `G:\Priority`, etc.) match the original folder names. The batch script uses these names; adjust if your originals differ.  
- **Temporary Disk I:**: Detach the I: disk after verification if no longer required.

---