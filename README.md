# delfox
DELFOX is a Powershell Script that deletes files older than x days in up to 9 predefined folders and its subfolders.

It works with a control.xml File that has to be placed in the subfolder "delfoxconfigs".
Control-File can be configure with up to 9 folders where files and files in sub-folders are purged older than the defined days per rootfolder. 

Delfox logs all purge jobs for folders and all deleted files in its subfolder "delfoxlogs". 

Delfox can be started with 1 param:
   delfoxstart.ps1 -CFGFile control.xml
