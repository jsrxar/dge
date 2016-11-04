################################################################################
## Descripción : Activa y agrega funcionalidades a salida del PHP Generator
################################################################################
param(
	[string]$dir
)
Write-Host Procesando el directorio $dir

[system.text.encoding]::GetEncoding('iso-8859-1')
$diract = $dir + "\activador"

foreach ($arch in get-content "$diract\activador.txt") {
	$archori = $dir + "\" + $arch
	Write-Host Procesando $arch

	if (Test-Path $archori) {
		if(@( Get-Content $archori | Where-Object { $_.Contains("SetExportToExcelAvailable(true)") } ).Count -eq 0) {
			$archtmp = $archori + ".borrar"

			if ($arch.Equals("factura.php")) {
				get-content $archori | 
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
				get-content $archori | 
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
						  -RedirectStandardOutput "$archori" `
						  -RedirectStandardError "iconv_error.txt" `
						  -Wait
			Remove-Item $archtmp
		} else {
			Write-Host -> Ya activado
		}
	} else {
		Write-Host -> El archivo no existe
	}
}

Write-Host Cambiando archivo de estilos CSS y conexión DB
$origen = $diract + "\main.css"
$destino = $dir + "\components\css"
Copy-Item $origen -Destination $destino -Force
$origen = $diract + "\pgsql_engine.php"
$destino = $dir + "\database_engine"
Copy-Item $origen -Destination $destino -Force

Write-Host Agregando funciones nuevas
$phpaux = $diract + "\general.php"
$phpfunc = $dir + "\phpgen_settings.php"
if(@( Get-Content $phpfunc | Where-Object { $_.Contains("/* Funciones Generales PHP */") } ).Count -eq 0) {
	Add-Content -path $phpfunc -value (Get-Content $phpaux)
}

Write-Host Proceso finalizado
