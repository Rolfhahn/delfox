# delfox
DELFOX is a Powershell Script that deletes files older than x days in up to 9 predefined folders.

It works with a control.xml File that has to be placed in the subfolder "delfoxconfigs".
Control-File can be configure with up to 9 folders where files are purged older than the defined days per folder. 
Part's of the control File look like this:
    ...
    <Job1>
        <DataDirectory2>c:\temp\2</DataDirectory2>
        <RetentionDays2>90</RetentionDays2>
    </Job1>
    ...

Delfox can be started with 1 param:
   delfoxstart.ps1 -CFGFile control.xml
