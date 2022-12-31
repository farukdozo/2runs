del /F /Q game
copy /b love.exe+%1 "%~n1.exe"
mkdir game
copy dlls game
move "%~n1.exe" "game/%~n1.exe"

echo Set objArgs = WScript.Arguments > _zipIt.vbs
echo FullPath = objArgs(2) >> _zipIt.vbs
echo InputFolder = FullPath + "\" + objArgs(0) >> _zipIt.vbs
echo ZipFile =  FullPath + "\" + objArgs(1) >> _zipIt.vbs
echo CreateObject("Scripting.FileSystemObject").CreateTextFile(ZipFile, True).Write "PK" ^& Chr(5) ^& Chr(6) ^& String(18, vbNullChar) >> _zipIt.vbs
echo Set objShell = CreateObject("Shell.Application") >> _zipIt.vbs
echo Set source = objShell.NameSpace(InputFolder).Items >> _zipIt.vbs
echo objShell.NameSpace(ZipFile).CopyHere(source) >> _zipIt.vbs
echo wScript.Sleep 2000 >> _zipIt.vbs
cls
echo Creating zip...
CScript  _zipIt.vbs  game  %~n1.zip %cd%

del _zipIt.vbs
del /s /q game
rmdir /s /q game

echo Done!