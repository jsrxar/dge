#!/bin/ksh

for arch in `cat activador.txt`;do
	echo "Procesando ${arch}"

	if [ -a ${arch} ]; then
		sed 's/SetUseImagesForActions(false)/SetUseImagesForActions(true)/g' ${arch} | \
			sed 's/SetHighlightRowAtHover(false)/SetHighlightRowAtHover(true)/g' | \
			sed 's/SetExportToExcelAvailable(false)/SetExportToExcelAvailable(true)/g' | \
			sed 's/SetExportToWordAvailable(false)/SetExportToWordAvailable(true)/g' | \
			sed 's/SetExportToXmlAvailable(false)/SetExportToXmlAvailable(true)/g' | \
			sed 's/SetExportToCsvAvailable(false)/SetExportToCsvAvailable(true)/g' | \
			sed 's/SetExportToPdfAvailable(false)/SetExportToPdfAvailable(true)/g' | \
			sed 's/SetPrinterFriendlyAvailable(false)/SetPrinterFriendlyAvailable(true)/g' | \
			sed 's/SetSimpleSearchAvailable(false)/SetSimpleSearchAvailable(true)/g' | \
			sed 's/SetAdvancedSearchAvailable(false)/SetAdvancedSearchAvailable(true)/g' | \
			sed 's/SetFilterRowAvailable(false)/SetFilterRowAvailable(true)/g' | \
			sed 's/SetVisualEffectsEnabled(false)/SetVisualEffectsEnabled(true)/g' | \
			sed 's/SetShowTopPageNavigator(false)/SetShowTopPageNavigator(true)/g' | \
			sed 's/SetShowBottomPageNavigator(false)/SetShowBottomPageNavigator(true)/g' | \
			sed 's/SetAllowDeleteSelected(false)/SetAllowDeleteSelected(true)/g' | \
			sed 's/AddBand(/AddBandToBegin(/g' | \
			sed 's/SetRowsPerPage(.*)/SetRowsPerPage(100)/g' > ${arch}.new
			
		if [[ ${arch} == ver_* ]]; then
			echo "-> No se completa el archivo ${arch}"
			mv ${arch}.new ${arch}
		else
			grep "?>" ${arch} >/dev/null 2>&1
			if [ $? -ne 0 ]; then
				cat ${arch}.new general.php ${arch%%.*}.cm? >${arch} 2>/dev/null
				rm ${arch}.new
			else
				echo "-> archivo ya completado"
				mv ${arch}.new ${arch}
			fi
		fi
	fi
done

echo "Proceso finalizado"

exit

