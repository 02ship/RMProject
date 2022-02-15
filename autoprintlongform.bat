set arg1=%1
powershell -Command "& C:\Users\till2\AppData\Local\SumatraPDF\SumatraPDF.exe -print-settings 'fit,bin=3,paper=A4' -print-to-default %arg1%"