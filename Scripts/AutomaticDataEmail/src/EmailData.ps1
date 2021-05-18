#Constants
$Date = Get-Date -UFormat "%d.%m.%Y"
$RunTime = get-date -Format "dddd dd.MM.yyyy HH:mm:ss K"
$CurrentTimestamp = get-date -Format "dd.MM.yyy_HH.mm"
$ScriptHome = "$home\AutomaticDataEmail\"
$Logfile = "$($ScriptHome)Logs\EmailData_$($CurrentTimestamp).log"
$CurrentDay = Get-Date -UFormat "%A"
$BackupDirectory = "$($ScriptHome)DataBackup\$($CurrentDay)\"
$FileLastWriteTime = get-itempropertyvalue $BackupDirectory*.001 -name LastWriteTime
$TallyDataFiles = (Get-ChildItem $BackupDirectory -Filter *.001 -Recurse).Name | Sort length -Descending
$ZipFiles = Get-ChildItem $BackupDirectory -name *.zip
$File = "$($BackupDirectory)Data_$($Date).zip"

#Log Function
Function WriteLog
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

WriteLog "$($BackupDirectory)"
WriteLog "$($CurrentDay)"
WriteLog "$($TallyDataFiles)"


WriteLog "Scripting execution started: $($RunTime)"
WriteLog "Creating AutomaticDataEmail and related folders under $home"

if ( -Not (Test-path "$home\AutomaticDataEmail\Logs\")) { mkdir "$home\AutomaticDataEmail\Logs\" }
if ( -Not (Test-path "$home\AutomaticDataEmail\DataBackup\")) { mkdir "$home\AutomaticDataEmail\DataBackup\" }
if ( -Not (Test-path "$home\AutomaticDataEmail\Bin\")) { mkdir "$home\AutomaticDataEmail\Bin\" }


$EmailFrom = "kotharimillstore@gmail.com"
$EmailTo = "aatman.kothari94@gmail.com"
$EmailCC = "kotharimillstores@rediffmail.com"
#sdwarika4@gmail.com
$Subject = "Kothari Mill Stores Data - $Date"
$Body = "This is an auto-generated mail with data file compressed and attached.`n`n The data file $($TallyDataFiles) was last modified at $($FileLastWriteTime). `n`n Kindly check the log file at $($Logfile) for details."
$SMTPServer = "smtp.gmail.com"
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$SMTPMessage.cc.Add($EmailCC)

WriteLog "$($ZipFiles)"
Remove-Item -Path $BackupDirectory  -include *.zip -recurse
WriteLog "File properties $($FileLastWriteTime)"

# Using 7zip compression as Powershell v2 doesn't support compression like v5.
# 7zip has to be installed and PATH needs to be set
# To exlude all the .zip inside the folder use = -r -x!*.zip
# Zips only the files with extention .001 (tally standard)
if (test-path "$($BackupDirectory)*.001")
{
	# Uncomment the line below to use compression in powershell v5
	Compress-Archive -Path $BackupDirectory*.001 -DestinationPath $BackupDirectory\Data_$($Date).zip
	# &7z a -tzip $BackupDirectory"Data_$($Date).zip" $BackupDirectory*.001
	WriteLog "Compressing and attaching file: $($BackupDirectory)Data_$($Date).zip"	
	WriteLog "Compress successful."
}
else
{
	WriteLog "No file with extendion *.001 found at $($BackupDirectory)"
}

$Attachment = New-object System.Net.Mail.Attachment($File)
$SMTPMessage.Attachments.Add($Attachment)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.Timeout = 400000
$SMTPClient.EnableSsl = $True
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("kotharimillstore@gmail.com", "yugtzebvtbivxqqg");
$SMTPClient.Send($SMTPMessage)
WriteLog "Email sent to $($EmailTo)" 
WriteLog "Scripting execution finished: $($RunTime)"