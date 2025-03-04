   
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <!-- Nombre de usuario (abre modal) -->
            <a class="navbar-brand" href="#" data-bs-toggle="modal" data-bs-target="#accountModal">
                <?php echo htmlspecialchars($_SESSION['name'] ?? 'Usuario'); ?>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
                    data-bs-target="#navbarContent" aria-controls="navbarContent" 
                    aria-expanded="false" aria-label="Alternar navegación">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center">
                    <!-- Inicio -->
                    <li class="nav-item">
                        <a class="nav-link" href="main.php">
                            Inicio
                        </a>
                    </li>
                    <!-- Instalación de apliaciones -->
                    <li class="nav-item">
                        <a class="nav-link" href="install.php">
                            Instalación
                        </a>
                    </li>
                    <!-- Gestionar cuenta -->
                    <?php
                    if( basename($_SERVER['PHP_SELF']) == 'main.php' ) {
                    echo '<li class="nav-item"><a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#accountModal">Cuenta</a></li>';
                    }
                    ?>

                    <!-- Cerrar sesión con icono -->
                    <li class="nav-item">
                        <form action="backEnd/mngSession.php" method="post" class="d-flex align-items-center">
                            <input type="hidden" name="op" value="sc">
                            <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token'] ?? ''; ?>">
                            <button type="submit" class="nav-link p-0" style="margin-left:1rem;">
                                <!-- Icono para cerrar sesión -->
                                <img src="img/logoutIcon.png" alt="Cerrar sesión" style="width:24px; height:24px;">
                            </button>
                        </form>
                    </li>
                </ul>
            </div>
        </div>
    </nav>