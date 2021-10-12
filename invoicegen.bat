:: This works using the Invoice_for_PDF.rpt, but not invoice_for_RM.rpt yet due to subreport linked parameters


set arg1=%1

"F:\PaulShields\CrystalReportsNinja-master\deployment\CrystalReportsNinja.exe" -F "F:\Montana Reports\Invoice_for_RM.rpt" -O "F:\PaulShields\Invoices\%arg1%.pdf" -E pdf -a "HeaderRef:%arg1%" -a "IsCopy:False" -a "QR_path:F:\PaulShields\jpgs\%arg1%.bmp"