<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  // 1. Recoger todos los campos del formulario
  $formData = $_POST;

  // 2. Filtrar y guardar solo los valores que nos interesan
  $options = []; // Aquí guardaremos las opciones seleccionadas y sus valores
  foreach ($formData as $key => $value) {
    // Si el campo es una opción (lamp, wordpress, nextcloud, moodle)
    if (in_array($key, ['lamp', 'wordpress', 'nextcloud', 'moodle'])) {
      $options[$key] = true; // Marcamos la opción como seleccionada
    } elseif (strpos($key, '_') !== false) {
      // Si el campo es dinámico (ej: lamp_domain, wordpress_db_user, etc.)
      list($option, $field) = explode('_', $key, 2);
      if (in_array($option, ['lamp', 'wordpress', 'nextcloud', 'moodle'])) {
        $options[$option][$field] = $value; // Guardamos el valor dinámico
      }
    }
  }

  // 3. Leer el archivo YAML
  $yamlFile = 'ansible/vars/varsMain.yml';
  $yamlContent = file_get_contents($yamlFile);

  // 4. Actualizar los valores en el YAML
  foreach ($options as $option => $values) {
    if ($values === true) {
      // Si es una opción seleccionada (lamp, wordpress, etc.)
      $yamlContent = preg_replace("/option:\s*\[(.*)\]/", "option: ['$option']", $yamlContent);
    } elseif (is_array($values)) {
      // Si es un campo dinámico (lamp_domain, wordpress_db_user, etc.)
      foreach ($values as $field => $value) {
        $yamlContent = preg_replace("/{$option}_{$field}:\s*\"(.*)\"/", "{$option}_{$field}: \"{$value}\"", $yamlContent);
      }
    }
  }

  // 5. Guardar el archivo YAML actualizado
  file_put_contents($yamlFile, $yamlContent);

  // 6. Ejecutar el playbook de Ansible (opcional)
  #$command = 'ansible-playbook ansible/main.yml -u www-data --skip-tags "mysql-root, prerequisites"';
  #$output = shell_exec($command);

  // 7. Mostrar la salida del comando (opcional)
  #echo "<pre>Ansible Output:\n$output</pre>";
}
?>