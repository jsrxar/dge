################################################################################
## Descripción : Activa y agrega funcionalidades a salida del PHP Generator
################################################################################
param(
[string]$dir
)
[system.text.encoding]::GetEncoding('iso-8859-1')
$diract =  $dir + "\activador"

foreach ($arch in get-content "$diract\activador.txt") {
	Write-Host Procesando $arch

	if (Test-Path $arch) {
		$archtmp = $dir + "\" + $arch + ".borrar"

		if ($arch.Equals("factura.php")) {
			get-content $arch | 
				%{$_ -replace 'SetUseImagesForActions\(false\)', 'SetUseImagesForActions(true)'} |
				%{$_ -replace 'SetHighlightRowAtHover\(false\)', 'SetHighlightRowAtHover(true)'} |
				%{$_ -replace 'SetExportToExcelAvailable\(false\)', 'SetExportToExcelAvailable(true)'} |
				%{$_ -replace 'SetExportToWordAvailable\(false\)', 'SetExportToWordAvailable(true)'} |
				%{$_ -replace 'SetExportToXmlAvailable\(false\)', 'SetExportToXmlAvailable(true)'} |
				%{$_ -replace 'SetExportToCsvAvailable\(false\)', 'SetExportToCsvAvailable(true)'} |
				%{$_ -replace 'SetExportToPdfAvailable\(false\)', 'SetExportToPdfAvailable(true)'} |
				%{$_ -replace 'SetPrinterFriendlyAvailable\(false\)', 'SetPrinterFriendlyAvailable(true)'} |
				%{$_ -replace 'SetSimpleSearchAvailable\(false\)', 'SetSimpleSearchAvailable(true)'} |
				%{$_ -replace 'SetAdvancedSearchAvailable\(false\)', 'SetAdvancedSearchAvailable(true)'} |
				%{$_ -replace 'SetFilterRowAvailable\(false\)', 'SetFilterRowAvailable(true)'} |
				%{$_ -replace 'SetVisualEffectsEnabled\(false\)', 'SetVisualEffectsEnabled(true)'} |
				%{$_ -replace 'SetShowTopPageNavigator\(false\)', 'SetShowTopPageNavigator(true)'} |
				%{$_ -replace 'SetShowBottomPageNavigator\(false\)', 'SetShowBottomPageNavigator(true)'} |
				%{$_ -replace 'SetAllowDeleteSelected\(false\)', 'SetAllowDeleteSelected(true)'} |
				%{$_ -replace 'AddBand\(', 'AddBandToBegin('} |
				%{$_ -replace 'SetRowsPerPage\(.*\)', 'SetRowsPerPage(100)'} | Out-File -Encoding "UTF8" $archtmp
		} else {
			get-content $arch | 
				%{$_ -replace 'SetUseImagesForActions\(false\)', 'SetUseImagesForActions(true)'} |
				%{$_ -replace 'SetHighlightRowAtHover\(false\)', 'SetHighlightRowAtHover(true)'} |
				%{$_ -replace 'SetExportToExcelAvailable\(false\)', 'SetExportToExcelAvailable(true)'} |
				%{$_ -replace 'SetExportToWordAvailable\(false\)', 'SetExportToWordAvailable(true)'} |
				%{$_ -replace 'SetExportToXmlAvailable\(false\)', 'SetExportToXmlAvailable(true)'} |
				%{$_ -replace 'SetExportToCsvAvailable\(false\)', 'SetExportToCsvAvailable(true)'} |
				%{$_ -replace 'SetExportToPdfAvailable\(false\)', 'SetExportToPdfAvailable(true)'} |
				%{$_ -replace 'SetPrinterFriendlyAvailable\(false\)', 'SetPrinterFriendlyAvailable(true)'} |
				%{$_ -replace 'SetSimpleSearchAvailable\(false\)', 'SetSimpleSearchAvailable(true)'} |
				%{$_ -replace 'SetAdvancedSearchAvailable\(false\)', 'SetAdvancedSearchAvailable(true)'} |
				%{$_ -replace 'SetFilterRowAvailable\(false\)', 'SetFilterRowAvailable(true)'} |
				%{$_ -replace 'SetVisualEffectsEnabled\(false\)', 'SetVisualEffectsEnabled(true)'} |
				%{$_ -replace 'SetShowTopPageNavigator\(false\)', 'SetShowTopPageNavigator(true)'} |
				%{$_ -replace 'SetShowBottomPageNavigator\(false\)', 'SetShowBottomPageNavigator(true)'} |
				%{$_ -replace 'SetAllowDeleteSelected\(true\)', 'SetAllowDeleteSelected(false)'} |
				%{$_ -replace 'AddBand\(', 'AddBandToBegin('} |
				%{$_ -replace 'SetRowsPerPage\(.*\)', 'SetRowsPerPage(100)'} | Out-File -Encoding "UTF8" $archtmp
		}

		# Convierte la salida de nuevo a ISO-8859-1
		Start-Process -FilePath "$diract\iconv.exe" `
		              -ArgumentList "-f UTF-8 -t ISO-8859-1 -c $archtmp" `
		              -RedirectStandardOutput "$arch" `
		              -RedirectStandardError "iconv_error.txt" `
		              -Wait
		Remove-Item $archtmp

	} else {
		Write-Host -> El archivo no existe
	}
}

Write-Host Cambiando archivo de estilos CSS
$oricss = $diract + "\main.css"
$descss = $dir + "\components\css"
Copy-Item $oricss -Destination $descss -Force

Write-Host Proceso finalizado
