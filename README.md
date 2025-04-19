# Export Data from an IS-Pro Database to CSV Files

Download the `ispro-ora-export.sql` file.

By default, it will be downloaded to the `C:\Users\username\Downloads` folder.

In the `ispro-ora-export.sql` file, change the output folder path to the desired one.

For example:

``` notepad
DEFINE outfolder = 'C:\Users\username\Downloads\csv\'
```

Start Oracle SQL*Plus.

Enter your credentials.

In the command prompt, run the `ispro-ora-export.sql` file:

```sqlplus
SQL> @"C:\Users\username\Downloads\ispro-ora-export.sql";
```

As a result, you will get a set of CSV files in the `C:\Users\username\Downloads\csv` directory.
