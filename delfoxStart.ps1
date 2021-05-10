[CmdletBinding()]
param ([string]$CFGFile)

#Enable next line only for Debugging!
# $CFGFile = "mysettings.xml"
#------------------------------------

$ConfigFile = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigFileFullPath = $ConfigFile+"\DELFOXConfigs\"+$CFGFile
$LogFileDir=$ConfigFile
$LogTime= Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
#Specify static variables above this line.

CLS
Write-Host DELFOX [DELete Files Older than X Days]
Write-Host         Version: 1.2a Rel Date :20210421
Write-Host
Write-Host This Script deletes Files older than X Days
Write-Host [c]MICRODYN AG Switzerland/all rights reserved
Write-Host www.microdyn.ch -- Feedback : info@microdyn.ch
Write-Host ______________________________________________
Write-Host 

# Import settings from config file to array
[xml]$Configuration = Get-Content "$ConfigFileFullPath" -ErrorVariable E000 -ErrorAction SilentlyContinue

if ($E000.count -eq 0)
    {
    # SET Variables from Configfile
    $DataDirectory = [Object[]]::new(9)
    $RetentionDays = [Object[]]::new(9)
    $LastWrite= [Object[]]::new(9)
    $ProjectName=$Configuration.Settings.General.ProjectName
    $NumberofRetentionJobs=$Configuration.Settings.General.NumberofRetentionJobs
    $DelaySeconds=$Configuration.Settings.General.DelaySeconds
    $DataDirectory[0]=$Configuration.Settings.Job1.DataDirectory1
    $RetentionDays[0]=$Configuration.Settings.Job1.RetentionDays1
    $DataDirectory[1]=$Configuration.Settings.Job2.DataDirectory2
    $RetentionDays[1]=$Configuration.Settings.Job2.RetentionDays2
    $DataDirectory[2]=$Configuration.Settings.Job3.DataDirectory3
    $RetentionDays[2]=$Configuration.Settings.Job3.RetentionDays3
    $DataDirectory[3]=$Configuration.Settings.Job4.DataDirectory4
    $RetentionDays[3]=$Configuration.Settings.Job4.RetentionDays4
    $DataDirectory[4]=$Configuration.Settings.Job5.DataDirectory5
    $RetentionDays[4]=$Configuration.Settings.Job5.RetentionDays5
    $DataDirectory[5]=$Configuration.Settings.Job6.DataDirectory6
    $RetentionDays[5]=$Configuration.Settings.Job6.RetentionDays6
    $DataDirectory[6]=$Configuration.Settings.Job7.DataDirectory7
    $RetentionDays[6]=$Configuration.Settings.Job7.RetentionDays7
    $DataDirectory[7]=$Configuration.Settings.Job8.DataDirectory8
    $RetentionDays[7]=$Configuration.Settings.Job8.RetentionDays8
    $DataDirectory[8]=$Configuration.Settings.Job9.DataDirectory9
    $RetentionDays[8]=$Configuration.Settings.Job9.RetentionDays9

    #CALCULATED VARIABLES BLOCK
    $LogFile         = $LogFileDir+"\DELFOXlogs\DELFOXLOG "+$LogTime+".log"
    $Now             = Get-Date
    $LastWrite[0]    =$Now.addDays(-$RetentionDays[0])
    $LastWrite[1]    =$Now.addDays(-$RetentionDays[1])
    $LastWrite[2]    =$Now.addDays(-$RetentionDays[2])
    $LastWrite[3]    =$Now.addDays(-$RetentionDays[3])
    $LastWrite[4]    =$Now.addDays(-$RetentionDays[4])
    $LastWrite[5]    =$Now.addDays(-$RetentionDays[5])
    $LastWrite[6]    =$Now.addDays(-$RetentionDays[6])
    $LastWrite[7]    =$Now.addDays(-$RetentionDays[7])
    $LastWrite[8]    =$Now.addDays(-$RetentionDays[8])

    #PRINT INFORMATION OVERVIEW
    Write-Host DELFOX SETTINGS:
    Write-Host ..Configuration-File............. : $ConfigFileFullPath
    Write-Host ..Log-File Name.................. : $LogFile
    Write-Host ..Date........................... : $Now
    Write-Host
    Write-Host CFGFile.Settings.General
    Write-Host ..DelaySeconds................... : $DelaySeconds
    Write-Host ..ProjectName.................... : $ProjectName
    Write-Host ..NumberofRetentionJobs.......... : $NumberofRetentionJobs
    Write-Host

    for ($jobnum=0; $jobnum -lt $NumberofRetentionJobs ; $jobnum++)
        {
        $job=$jobnum + 1
        Write-Host CFGFile.Settings.Job $job
        Write-Host ..DataDirectory.................. : $DataDirectory[$jobnum]
        Write-Host ..RetentionDays.................. : $RetentionDays[$jobnum]
        Write-Host ..=.LastWrite.................... : $LastWrite[$jobnum]
        Write-Host
        }
    
    Write-Host
    Write-Host The Process starts after a delay. Press CTRL-C to Abort!
    Write-Host

    #LOG_start
    new-item -ItemType Directory -path $LogFileDir -erroraction SilentlyContinue
    new-item -ItemType Directory -path $LogFileDir/delfoxlogs -erroraction SilentlyContinue
    $LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss"
    $Logtime + " MSG001: JOB STARTED :  "+$ProjectName |Out-File $Logfile -Append -Force

    #DelayBeforeStart
    Write-Host "_________"
    Write-Host "DELFOXMSG: 001 New Job Started / Delay: " $DelaySeconds 
    Start-Sleep -s $DelaySeconds
  
    for ($jobnum=0; $jobnum -lt $NumberofRetentionJobs ; $jobnum++)
        {
  
        #Logfile append (Jobnumber)
        "" | Out-File $Logfile -Append -Force
        $Logtime + " MSG100: SUBTASK " + $jobnum + "   :  Cleanup of archive Files in Folder " + $DataDirectory[$jobnum] + " started" | Out-File $Logfile -Append -Force
        $Files = Get-Childitem $DataDirectory[$jobnum] -ErrorAction SilentlyContinue | Where {$_.LastWriteTime -le $LastWrite[$jobnum]}

        if($?) 
            {
            foreach ($File in $Files) 
                {
                if ($Files.count -igt 0) 
                    {
                    if ($File -ne $NULL)
                        {
                        write-host "Deleting File $File" -ForegroundColor "Yellow"
                        Remove-Item $File.FullName -recurse | out-null
               
                        #Logfile append (Deleting File)
                        $Logtime + " MSG800   ..         :  File deleted: " + $File | Out-File $Logfile -Append -Force
                        }
                    else
                        {
                        Write-Host "No more files to purge!" -foregroundcolor "Green"
                        #Logfile append (no more files)
                        $Logtime + " MSG899: ..no more files to purge" + $File | Out-File $Logfile -Append -Force
                        }
                    }
                else
                    {
                    #Logfile append
                    $Logtime + " MSG900:  ..No files with criteria to purge in this folder " + $DataDirectory[$jobnum] + " (nothing here to delete)" | Out-File $Logfile -Append -Force
                    }
                }
                #Logfile append
                $Logtime + " MSG801: ..          :  " + $Files.count + " Files older than " + $LastWrite[$jobnum] + " deleted" | Out-File $Logfile -Append -Force
            }
        else
            {
            #Logfile append Error
            $Logtime + " MSG901:  ..ERROR:   :  Folder " + $DataDirectory[$jobnum] + " not existing or not accessible" | Out-File $Logfile -Append -Force
            }
        }
        #LOG_end
        Write-Host _________
        Write-Host DELFOXMSG: 999 Finished Job
        $LogTime = Get-Date -Format "MM-dd-yyyy_hh-mm-ss" 
        "" | Out-File $Logfile -Append -Force
        $Logtime + " MSG999: JOB FINISHED: " + $ProjectName | Out-File $Logfile -Append -Force
    }
else
    {
    Write-Host _______
    Write-Host ERR001:
    Write-Host Please configure a valid Settings.XML File as Param Name for this Script.
    Write-Host You can do this by using the param: -CFGFile [mysettings.xml]
    Write-Host Config Files must be placed in folder .\DELFOXConfigs
    Start-Sleep -Milliseconds 3000
    }