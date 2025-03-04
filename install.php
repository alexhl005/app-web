<?php include("backEnd/appHeader.php"); ?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instalación de aplicaciones</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/jquery-3.6.0.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <style>
        .hidden { display: none; }
        .logo-option { cursor: pointer; border: 2px solid transparent; padding: 10px; width: 100px; }
        .logo-option.selected { border-color: #007bff; }
        .logo-container { text-align: center; }
        .logo-label { display: block; margin-top: 5px; font-weight: bold; }
        
        /* Animación de entrada */
        .fade-in {
            opacity: 0;
            transform: scale(0);
            transition: opacity 1.5s ease-in, transform 1.5s ease-in;
        }
        .show {
            opacity: 1 !important;
            transform: scale(1) !important;
        }

        /* Ajuste para vista en desktop */
        @media (min-width: 1024px) {
            .container { max-width: 1024px; }
            .row.text-center { max-width: 768px; margin: auto; }
        }

        /* Fondo translúcido del modal */
        .modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background-color: rgba(0, 0, 0, 0.1) !important; /* Más translúcido */
            backdrop-filter: blur(4px); /* Efecto difuminado */
            z-index: 1050;
        }

        /* Centrar modal verticalmente */
        .modal-dialog {
            display: flex;
            align-items: center;
            min-height: 100vh;
        }
    </style>
</head>
<body class="">
    <!-- Navbar responsiva -->
    <?php include("view/nav.php"); ?>

    <div class="container mt-5">
        <h2 class="text-center">Configuración del servidor</h2>
        <form id="installForm" action="do.php" method="POST" class="needs-validation" novalidate>
            <div class="row text-center my-4 justify-content-center">
                <div class="col-6 col-md-3 logo-container">
                    <img src="img/lamp.png" class="img-fluid logo-option" data-option="lamp">
                    <span class="logo-label">LAMP</span>
                </div>
                <div class="col-6 col-md-3 logo-container">
                    <img src="img/wp.png" class="img-fluid logo-option" data-option="wordpress">
                    <span class="logo-label">WordPress</span>
                </div>
                <div class="col-6 col-md-3 logo-container">
                    <img src="img/nc.png" class="img-fluid logo-option" data-option="nextcloud">
                    <span class="logo-label">NextCloud</span>
                </div>
                <div class="col-6 col-md-3 logo-container">
                    <img src="img/moodle.png" class="img-fluid logo-option" data-option="moodle">
                    <span class="logo-label">Moodle</span>
                </div>
            </div>

            <!-- Campos comunes -->
            <div id="common-fields" class="hidden">
                <h4>Datos FTP y MySQL</h4>
                <div class="mb-3">
                    <label for="ftp_user" class="form-label">Usuario FTP</label>
                    <input type="text" id="ftp_user" name="ftp_user" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="ftp_pass" class="form-label">Contraseña FTP</label>
                    <input type="password" id="ftp_pass" name="ftp_pass" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label for="mysql_root" class="form-label">Contraseña MySQL root</label>
                    <input type="password" id="mysql_root" name="mysql_root" class="form-control" required>
                </div>
            </div>

            <!-- Campos específicos por opción -->
            <div id="dynamic-fields"></div>
            
            <div class="text-center mt-5">
                <button type="submit" class="btn btn-primary w-25">Instalar</button>
            </div>
        </form>
    </div>

    <!-- Modal de Confirmación -->
    <div class="modal fade" id="confirmationModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar instalación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <p><strong>Por favor, verifica los datos antes de continuar:</strong></p>
                    <ul id="confirmationList"></ul>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" id="confirmInstall" class="btn btn-primary">Confirmar</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            setTimeout(() => $('body').addClass('show'), 100);

            $('.logo-option').click(function() {
                $(this).toggleClass('selected');
                let selectedOptions = $('.logo-option.selected');

                $('#common-fields').toggle(selectedOptions.length > 0);
                updateDynamicFields();
            });

            function updateDynamicFields() {
                $('#dynamic-fields').html('');
                $('.logo-option.selected').each(function() {
                    let option = $(this).data('option');
                    let html = `<div class='mt-3'>
                        <h4>${option.toUpperCase()}</h4>
                        <div class='mb-3'>
                            <label class='form-label'>Dominio</label>
                            <input type='text' name='${option}_domain' class='form-control domain-field' required>
                        </div>
                        <div class='mb-3'>
                            <label class='form-label'>Usuario BD</label>
                            <input type='text' name='${option}_db_user' class='form-control' required>
                        </div>
                        <div class='mb-3'>
                            <label class='form-label'>Contraseña BD</label>
                            <input type='password' name='${option}_db_pass' class='form-control' required>
                        </div>
                    </div>`;
                    $('#dynamic-fields').append(html);
                });
            }

            $('#installForm').submit(function(event) {
                event.preventDefault();

                let domains = [];
                let valid = true;
                $('.domain-field').each(function() {
                    let domain = $(this).val().trim();
                    if (!/^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(domain) || domains.includes(domain)) {
                        valid = false;
                        alert('Dominios inválidos o repetidos.');
                        return false;
                    }
                    domains.push(domain);
                });

                if (valid && this.checkValidity()) {
                    let confirmationList = $("#confirmationList").empty();
                    $(this).serializeArray().forEach(item => confirmationList.append(`<li><strong>${item.name}:</strong> ${item.value}</li>`));

                    $('#confirmationModal').modal('show');
                }
            });

            $('#confirmInstall').click(() => $('#installForm').off('submit').submit());
        });
    </script>
</body>
</html>