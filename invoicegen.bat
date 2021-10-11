:: The following command generates a PDF invoice using a modified (.00) header reference
:: This works using the Invoice_for_PDF.rpt, but not invoice.rpt. I have no idea why.
:: Next task afterwards will be integrating this with the image conversion script in order to automate invoice generation

"F:\PaulShields\CrystalReportsNinja-master\deployment\CrystalReportsNinja.exe" -F "C:\montana\ReportDocuments\Invoice_for_PDF.rpt" -O "F:\PaulShields\PDFs\testinvoice.pdf" -E pdf -a "HeaderRef:41138662.00" -a "IsCopy:False"