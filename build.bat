@ECHO OFF

REM // Ensure the script runs in the correct directory
cd /d "%~dp0"

REM // Delete some intermediate assembler output just in case
IF EXIST S1S3.gen (
    del S1S3.gen
    IF ERRORLEVEL 1 goto LABLERROR1
)
IF EXIST S1S3.p (
    del S1S3.p
    IF ERRORLEVEL 1 goto LABLERROR2
)
IF EXIST S1S3.h (
    del S1S3.h
    IF ERRORLEVEL 1 goto LABLERROR3
)
IF EXIST S1S3.log (
    del S1S3.log
    IF ERRORLEVEL 1 goto LABLERROR4
)

REM // Run the assembler
set AS_MSGPATH=Tools\AS\Windows
set USEANSI=n
set ASCMD=@%AS_MSGPATH%\asflags

REM // Allow the user to choose to print error messages out by supplying the -pe parameter
"%AS_MSGPATH%\asw.exe" Engine\Includes.asm
IF ERRORLEVEL 1 (
    echo Assembler failed to execute.
    goto LABLERROR5
)
IF NOT EXIST S1S3.p (
    echo Assembler did not produce S1S3.p
    goto LABLERROR5
)

REM // Convert the assembled file to binary
"%AS_MSGPATH%\p2bin.exe" -p=FF S1S3.p S1S3.gen S1S3.h
IF ERRORLEVEL 1 (
    echo Failed to convert S1S3.p to S1S3.gen
    pause & exit /b 1
)

REM // Delete temporary files with error checking
IF EXIST S1S3.p (
    del S1S3.p
    IF ERRORLEVEL 1 (
        echo Failed to delete S1S3.p during final cleanup.
        pause & exit /b 1
    )
)
IF EXIST S1S3.h (
    del S1S3.h
    IF ERRORLEVEL 1 (
        echo Failed to delete S1S3.h during final cleanup.
        pause & exit /b 1
    )
)

REM // Check if the output file was created
IF NOT EXIST S1S3.gen (
    echo Failed to generate S1S3.gen
    pause & exit /b 1
)

REM // Generate debug information
"%AS_MSGPATH%\convsym.exe" S1S3.lst S1S3.gen -input as_lst -range 0 FFFFFF -exclude -filter \"z[A-Z].+\" -a
IF ERRORLEVEL 1 (
    echo Failed to generate debug information for S1S3.gen
    pause & exit /b 1
)
"%AS_MSGPATH%\convsym.exe" S1S3.lst "Engine\_RAM.lst" -in as_lst -out asm -range FF0000 FFFFFF
IF ERRORLEVEL 1 (
    echo Failed to generate RAM listing for _RAM.lst
    pause & exit /b 1
)

REM // Make ROM padding (commented out as in the original)
REM // "%AS_MSGPATH%\rompad.exe" S1S3.gen 255 0

REM // Fix the ROM header (checksum)
"%AS_MSGPATH%\fixheader.exe" S1S3.gen
IF ERRORLEVEL 1 (
    echo Failed to fix the ROM header for S1S3.gen
    pause & exit /b 1
)

REM // Copy rom to CD folder
IF EXIST S1S3.gen (
    copy S1S3.gen _CD
    IF ERRORLEVEL 1 (
        echo Failed to copy S1S3.gen
        pause & exit /b 1
    )
)

REM // Successful completion: exit and close the console
exit 0

:LABLERROR1
echo Failed to build because write access to S1S3.gen was denied.
pause & exit /b 1

:LABLERROR2
echo Failed to build because write access to S1S3.p was denied.
pause & exit /b 1

:LABLERROR3
echo Failed to build because write access to S1S3.h was denied.
pause & exit /b 1

:LABLERROR4
echo Failed to build because write access to S1S3.log was denied.
pause & exit /b 1

:LABLERROR5
IF EXIST S1S3.log (
    type S1S3.log
) ELSE (
    echo S1S3.log not found, check if assembler ran correctly.
)
REM // Display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *      There were build errors. See S1S3.log for more details.      *
echo *                                                                    *
echo **********************************************************************
echo.
pause & exit /b 1
