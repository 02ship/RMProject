set arg1=%1
powershell -Command "& C:\RoyalMail\SumatraPDF\SumatraPDF.exe -print-settings 'fit,bin=3,paper=A4' -print-to-default %arg1%"