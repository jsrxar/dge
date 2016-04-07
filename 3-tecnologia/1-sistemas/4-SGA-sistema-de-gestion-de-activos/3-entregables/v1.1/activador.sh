#!/bin/ksh

mv -f accion.php ./BK 2>/dev/null
mv -f tarea_plan.php ./BK 2>/dev/null
mv -f espacio.php ./BK 2>/dev/null
mv -f bien.php ./BK 2>/dev/null
mv -f metodologia.php ./BK 2>/dev/null
mv -f tipo_accion.php ./BK 2>/dev/null
mv -f tipo_espacio.php ./BK 2>/dev/null
mv -f tipo_bien.php ./BK 2>/dev/null
mv -f periodicidad.php ./BK 2>/dev/null
mv -f planta.php ./BK 2>/dev/null
mv -f origen.php ./BK 2>/dev/null

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
cd ..

echo "Completando archivos"
for arch_cmp in `ls -1 *.cm?`;do
	arch_php=${arch_cmp%%.*}.php
	grep "?>" $arch_php >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		cat $arch_cmp >> $arch_php
	else
		echo "archivo $arch_php ya completado"
	fi
done

echo "Proceso finalizado"

exit

