Write-Output "Disabiling ngen scheduled task"
Get-ScheduledTask '.NET Framework NGEN v4.0.30319','.NET Framework NGEN v4.0.30319 64'
$ngen | Disable-ScheduledTask

Write-Output "Running ngen.exe"
. c:\Windows\microsoft.net\framework\v4.0.30319\ngen.exe update /force /queue > NUL
. c:\Windows\microsoft.net\framework64\v4.0.30319\ngen.exe update /force /queue > NUL
. c:\Windows\microsoft.net\framework\v4.0.30319\ngen.exe executequeueditems > NUL
. c:\Windows\microsoft.net\framework64\v4.0.30319\ngen.exe executequeueditems > NUL