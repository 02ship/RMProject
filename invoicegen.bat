:: The following command generates a PDF invoice using a modified (.00) header reference
:: This works using the Invoice_for_PDF.rpt, but not invoice.rpt. I have no idea why.
:: Next task afterwards will be integrating this with the image conversion script in order to automate invoice generation

set arg1=%1

"F:\PaulShields\CrystalReportsNinja-master\deployment\CrystalReportsNinja.exe" -F "C:\montana\ReportDocuments\Invoice_for_PDF.rpt" -O "F:\PaulShields\Invoices\%arg1%.pdf" -E pdf -a "HeaderRef:%arg1%" -a "IsCopy:False"