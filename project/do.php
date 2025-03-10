<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 1. Recoger todos los campos del formulario
    $formData = $_POST;
    error_log("Datos recibidos por POST: " . print_r($formData, true)); // Debug

    // 2. Filtrar y guardar solo los valores que nos interesan
    $options = [];
    foreach ($formData as $key => $value) {
        // Si el campo es una opción (lamp, wp, nc, md)
        if (in_array($key, ['lamp', 'wp', 'nc', 'md'])) {
            $options[$key] = true; // Marcamos la opción como seleccionada
        } elseif (strpos($key, 'Domain') !== false || strpos($key, 'DBU') !== false || strpos($key, 'DBP') !== false) {
            // Si el campo es dinámico (ej: lampDomain, wpDBU, mdDBP, etc.)
            $option = substr($key, 0, 2); // Extraer la opción (lamp, wp, nc, md)
            $field = substr($key, 2); // Extraer el campo (Domain, DBU, DBP)
            if (in_array($option, ['la', 'wp', 'nc', 'md'])) { // Verificar la opción
                $options[$option][$field] = $value; // Guardar el valor dinámico
            }
        } else {
            // Campos comunes como ftpUser, ftpPass, mysql_root
            $options[$key] = $value;
        }
    }

    // 3. Leer el archivo YAML
    $yamlFile = 'ansible/vars/varsMain.yml';
    $yamlContent = file_get_contents($yamlFile);

    // 4. Actualizar los valores en el YAML
    foreach ($options as $option => $values) {
        if ($values === true) {
            // Si es una opción seleccionada (lamp, wp, etc.)
            $yamlContent = preg_replace("/option:\s*\[(.*)\]/", "option: ['$option']", $yamlContent);
        } elseif (is_array($values)) {
            // Si es un campo dinámico (lampDomain, wpDBU, etc.)
            foreach ($values as $field => $value) {
                $yamlContent = preg_replace("/{$option}{$field}:\s*\"(.*)\"/", "{$option}{$field}: \"{$value}\"", $yamlContent);
            }
        } else {
            // Campos comunes como ftpUser, ftpPass, mysql_root
            $yamlContent = preg_replace("/{$option}:\s*\"(.*)\"/", "{$option}: \"{$values}\"", $yamlContent);
        }
    }

    // 5. Guardar el archivo YAML actualizado
    file_put_contents($yamlFile, $yamlContent);
    error_log("YAML content updated successfully."); // Debug

    // Ejecutar ansible
    $command = "sudo ansible-playbook -u www-data ansible/main.yml --skip-tags 'prerequisites' 2>&1";

    // 7. Respuesta al cliente
    echo json_encode(["status" => "success", "message" => "Datos procesados correctamente."]);
} else {
    echo json_encode(["status" => "error", "message" => "Método no permitido."]);
}
?>