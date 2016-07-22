################################################################################
## Descripción : Activa y agrega funcionalidades a salida del PHP Generator
################################################################################
[system.text.encoding]::GetEncoding('iso-8859-1')

foreach ($arch in get-content activador.txt) {
	Write-Host Procesando $arch

	if (Test-Path $arch) {
		$archtmp = $arch + ".new"
		$archbase = ([io.fileinfo]$arch).basename + ".cm?"

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

		if ($arch.StartsWith("ver_")) {
			Write-Host -> No se completa el archivo $arch
		} else {
			if(@( Get-Content $archtmp | Where-Object { $_.Contains("?>") } ).Count -eq 0) {
				Add-Content $archtmp "include 'general.php'; ?>`n"
				Get-Content $archbase -ErrorAction SilentlyContinue | Add-Content $archtmp
			} else {
				Write-Host -> El archivo ya fue completado
			}
		}
		<#
		$bytes = [System.IO.File]::ReadAllBytes('C:\Temp\RoboCopyLog.txt')
		$len = $bytes.Length
		#Remove the Unicode BOM, and convert to ASCII
		$text = [System.Text.Encoding]::ASCII.GetString($bytes,2,$len -2)
		$text

		iconv -f UTF-8 -t ISO-8859-1 in.txt > out.txt
		$encoding = [Text.Encoding]::GetEncoding('iso-8859-1')
		$arch88591 = New-Object IO.StreamWriter ($archtmp, $false, $encoding)
		$xml.Save($arch88591)
		$arch88591.Close()
		$arch88591.Dispose()
		#>
		Remove-Item $arch
		Rename-Item $archtmp $arch -Force
	} else {
		Write-Host -> El archivo no existe
	}
}

Write-Host Proceso finalizado
