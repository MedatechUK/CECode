# PrioritySQL Storage Repartitioning Instructions

**Machine**: CE-AZ-UK-S-PRIO (PrioritySQL)  
**Date**: February 24, 2025  
**Objective**: Add a 4 TB attachments disk (I:), replace F: and G: with 4 TB disks, create 1 GB base partitions with mount points named identically to the original folders (`Priority`, `Dev`, `Test`), and copy files back to these mount points without modifying SQL database locations.

---

## Final Structure

- **Disk 4 (4 TB, replaces old F:)**  
  - **F:** 1 GB base partition, labeled `SQLVMDATA1`.  
    - **F:\Priority**: ~1.33 TB mount point (hosts Priority data files, e.g., `F:\Priority\PriorityDB.mdf`).  
    - **F:\Dev**: ~1.33 TB mount point (hosts Dev data files, e.g., `F:\Dev\DevDB.mdf`).  
    - **F:\Test**: ~1.33 TB mount point (hosts Test data files, e.g., `F:\Test\TestDB.mdf`).  
- **Disk 5 (4 TB, replaces old G:)**  
  - **G:** 1 GB base partition, labeled `SQLVMLOG`.  
    - **G:\Priority**: ~1.33 TB mount point (hosts Priority log files, e.g., `G:\Priority\PriorityDB.ldf`).  
    - **G:\Dev**: ~1.33 TB mount point (hosts Dev log files, e.g., `G:\Dev\DevDB.ldf`).  
    - **G:\Test**: ~1.33 TB mount point (hosts Test log files, e.g., `G:\Test\TestDB.ldf`).  
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

### Step 2: Copy Database Files to I:

1. **Stop SQL Server Instances**:  
   ```cmd
   net stop "MSSQL$PRIORITY"
   net stop "MSSQL$DEV"
   net stop "MSSQL$TEST"
   ```

2. **Copy Files to I:**:  
   ```cmd
   xcopy F:\*.* I:\ /E /H /C /I /Y
   xcopy G:\*.* I:\ /E /H /C /I /Y
   ```  
   - **Flags Explained**:  
     - `/E`: Copies all subdirectories, including empty ones.  
     - `/H`: Copies hidden and system files.  
     - `/C`: Continues on errors.  
     - `/I`: Assumes destination is a directory.  
     - `/Y`: Overwrites without prompting.

3. **Verify**:  
   ```cmd
   dir I:\Priority
   dir I:\Dev
   dir I:\Test
   ```

---

### Step 3: Replace and Repartition F: and G:

1. **In Azure Portal**:  
   - **Detach Old Disks**:  
     - VM > **Disks** > **Edit** > Detach `SQLVMDATA1` (F:) and `SQLVMLOG` (G:).  
     - Save.  
   - **Attach New 4 TB Disks**:  
     - Add two new disks:  
       - Disk 4: Name `SQL_DATA_4TB`, 4096 GB (P40), LUN 4.  
       - Disk 5: Name `SQL_LOG_4TB`, 4096 GB (P40), LUN 5.  
     - Save.

2. **Initialize and Partition Disk 4 (F:)**:  
   ```cmd
   diskpart
   DISKPART> list disk  (confirm Disk 4 is 4 TB)
   DISKPART> select disk 4
   DISKPART> convert gpt
   DISKPART> create partition primary size=1000
   DISKPART> format fs=ntfs label="SQLVMDATA1" quick
   DISKPART> assign letter=F
   DISKPART> create partition primary size=1365000
   DISKPART> format fs=ntfs label="Priority_Data" quick
   DISKPART> assign mount=F:\Priority
   DISKPART> create partition primary size=1365000
   DISKPART> format fs=ntfs label="Dev_Data" quick
   DISKPART> assign mount=F:\Dev
   DISKPART> create partition primary size=1365000
   DISKPART> format fs=ntfs label="Test_Data" quick
   DISKPART> assign mount=F:\Test
   DISKPART> exit
   ```

3. **Initialize and Partition Disk 5 (G:)**:  
   ```cmd
   diskpart
   DISKPART> list disk  (confirm Disk 5 is 4 TB)
   DISKPART> select disk 5
   DISKPART> convert gpt
   DISKPART> create partition primary size=1000
   DISKPART> format fs=ntfs label="SQLVMLOG" quick
   DISKPART> assign letter=G
   DISKPART> create partition primary size=1365000
   DISKPART> format fs=ntfs label="Priority_Logs" quick
   DISKPART> assign mount=G:\Priority
   DISKPART> create partition primary size=1365000
   DISKPART> format fs=ntfs label="Dev_Logs" quick
   DISKPART> assign mount=G:\Dev
   DISKPART> create partition primary size=1365000
   DISKPART> format fs=ntfs label="Test_Logs" quick
   DISKPART> assign mount=G:\Test
   DISKPART> exit
   ```

4. **Verify**:  
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
   xcopy I:\*.* F:\ /E /H /C /I /Y
   xcopy I:\*.* G:\ /E /H /C /I /Y
   ```  
   - **Key Point**: The mount points (`F:\Priority`, `G:\Priority`, etc.) retain the original folder names, so file paths remain unchanged.

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

- **Folder Names**: Mount points (`F:\Priority`, `G:\Priority`, etc.) must match the original folder names to avoid SQL database location changes.  
- **Partition Sizes**: Adjust `size=` values in `diskpart` if different allocations are needed.  

---
