# delfox
DELFOX is a Powershell Script that deletes files older than x days in up to 9 predifined folders.

It works with a controller XML File that has to be placed in the subfolder delfoxconfigs
Delfox will be started with 1 param:
delfoxstart.ps1 -CFGFile controlfile.xml

In the controller File you can configure up to 9 folders where files are purged older than the defined days per folder. 
The controller File looks like this:
    ...
    <Job1>
        <DataDirectory2>c:\temp\2</DataDirectory2>
        <RetentionDays2>90</RetentionDays2>
    </Job1>
    ...

