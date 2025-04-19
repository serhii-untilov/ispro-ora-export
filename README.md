# Export Data from an IS-Pro Database to CSV Files

Download the [`ispro-ora-export.sql`](https://github.com/serhii-untilov/ispro-ora-export/blob/master/ispro-ora-export.sql) file.

By default, it will be downloaded to the `C:\Users\<username>\Downloads` folder.

In the `ispro-ora-export.sql` file, change the output folder path to the desired one.

For example:

``` notepad
DEFINE outfolder = 'C:\Users\<username>\Downloads\csv\'
```

Start Oracle SQL*Plus and pass in it username, password, db name and script.

Example:

``` powershell
D:\app\<username>\product\11.2.0\dbhome_4\BIN\sqlplus.exe <oracle-username>/<oracle-password>@<DBNAME> @C:\Users\<username>\Downloads\ispro-ora-export.sql
```

See `sql-plus.cmd`.

or

Start SQL*Plus

``` powershell
sqlplus.exe
```

Enter your credentials.

In the command prompt, run the `ispro-ora-export.sql` file:

``` sqlplus
SQL> @"C:\Users\<username>\Downloads\ispro-ora-export.sql";
```

As a result, you will get a set of CSV files in the `C:\Users\<username>\Downloads\csv` directory.
