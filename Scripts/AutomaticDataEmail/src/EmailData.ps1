#Constants
$Date = Get-Date -UFormat "%d.%m.%Y"
$CurrentTimestamp = get-date -Format "dd.MM.yyy_HH.mm"
$ScriptHome = "$home\AutomaticDataEmail\"
$Logfile = "$($ScriptHome)Logs\EmailData_$($CurrentTimestamp).log"
$CurrentDay = Get-Date -UFormat "%A"
$BackupDirectory = "$($ScriptHome)DataBackup\$($CurrentDay)\"
$File = "$($BackupDirectory)Data_$($Date).zip"

WriteLog "$($BackupDirectory)"
WriteLog "$($CurrentDay)"
WriteLog "$($File)"

#Log Function
Function WriteLog
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

WriteLog "Scripting execution started: $(get-date)"
WriteLog "Creating AutomaticDataEmail and related folders under $home"

if ( -Not (Test-path "$home\AutomaticDataEmail\Logs\")) { mkdir "$home\AutomaticDataEmail\Logs\" }
if ( -Not (Test-path "$home\AutomaticDataEmail\DataBackup\")) { mkdir "$home\AutomaticDataEmail\DataBackup\" }
if ( -Not (Test-path "$home\AutomaticDataEmail\Bin\")) { mkdir "$home\AutomaticDataEmail\Bin\" }


$EmailTo = "aatman.kothari94@gmail.com"
$EmailFrom = "kotharimillstore@gmail.com"

$Subject = "Kothari Mill Stores Data - $Date"
$Body = "This is an auto-generated mail with data file compressed and attached. `n Kindly check the log file at $($Logfile) for details."
$SMTPServer = "smtp.gmail.com"
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)

Remove-Item -Path $File
WriteLog "Compressing and attaching file: $($BackupDirectory)Data_$($Date).zip"
# Uncomment the line below to use compression in powershell v5
#Compress-Archive -Path $BackupDirectory -DestinationPath $BackupDirectory\Data_$($Date).zip

# Using 7zip compression as Powershell v2 doesn't support compression like v5.
# 7zip has to be installed and PATH needs to be set
&7z a -tzip $BackupDirectory"Data_$($Date).zip" $BackupDirectory

WriteLog "Compress successful."

$Attachment = New-object System.Net.Mail.Attachment($File)
$SMTPMessage.Attachments.Add($Attachment)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.Timeout = 400000
$SMTPClient.EnableSsl = $True
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("kotharimillstore@gmail.com", "yugtzebvtbivxqqg");
$SMTPClient.Send($SMTPMessage)
WriteLog "Email sent to $($EmailTo)" 
WriteLog "Scripting execution finished: $(get-date)"