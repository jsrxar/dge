#!/bin/ksh

mv -f public.stg_pagos_1.php ./BK 2>/dev/null

cd BK
for arch in *;do
	echo "Procesando ${arch}"
	sed 's/SetUseImagesForActions(false)/SetUseImagesForActions(true)/g' ${arch} | \
		sed 's/SetHighlightRowAtHover(false)/SetHighlightRowAtHover(true)/g' | \
		sed 's/SetShowPageList(false)/SetShowPageList(true)/g' | \
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
		sed 's/SetRowsPerPage(.*)/SetRowsPerPage(100)/g' > ../${arch}
done

echo "Proceso finalizado"

exit
