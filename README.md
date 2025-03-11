# 🚀 Project Overview

This project automates the deployment of a web application using **Ansible**, ensuring a streamlined and repeatable process. It includes a **Bash script** for installation and a well-organized directory structure for managing application resources. The goal is to simplify server configuration, database setup, and application deployment.

---

## 📂 Installation Script (`install.sh`)

The `install.sh` script automates the deployment process by performing the following tasks:

1. **Install Ansible**: Installs Ansible on the system if not already present.
2. **Clone Repository**: Clones or updates the GitHub repository containing the project files.
3. **Copy Project Files**: Copies the contents of the `project` directory to `/var/www/html` for web server access.
4. **Run Ansible Playbook**: Executes an Ansible playbook to configure the server environment.
5. **Database Setup**: Creates a MariaDB database and user, and imports SQL files to initialize the database.

### 🔑 Key Functions in `install.sh`

- **`ask_domain_name`**: Prompts the user to input the domain name for the application.
- **`update_vars_file`**: Updates the Ansible variables file (`vars.yml`) with the provided domain name.
- **`check_root`**: Ensures the script is executed with **root privileges**.
- **`check_os`**: Verifies that the operating system is **Ubuntu** or **Debian** for compatibility.
- **`install_dependencies`**: Installs necessary dependencies, including Ansible and MariaDB.
- **`clone_repository`**: Clones or updates the GitHub repository to the local system.
- **`copy_project_files`**: Copies the project files to the web server directory (`/var/www/html`).
- **`run_ansible_playbook`**: Executes the Ansible playbook to configure the server.
- **`create_database`**: Creates the `loansdb` database and configures a user with appropriate privileges.
- **`import_databases`**: Imports SQL files from the `sql/` directory to populate the database.

---

## 📂 Project Directory Analysis

The `project` directory contains various subdirectories and files that are part of the web application. Below is a detailed analysis of its structure and the purpose of each file and directory.

### Directory Structure

```
project/
├── 📁 ansible/          # Contains Ansible playbooks and configuration files
│   ├── 📄 playbook.yml  # Main playbook for server configuration
│   └── 📄 vars.yml      # Variables file for Ansible
├── 📁 backEnd/          # Backend PHP scripts for application logic
│   ├── 📄 appHeader.php # Header information for the application
│   ├── 📄 commons.php   # Common functions used across the backend scripts
│   ├── 📄 doBackup.php  # Script for performing backup operations
│   ├── 📄 download.php  # Script for handling file downloads
│   └── 📄 mngSession.php # Manages user sessions
├── 📁 backup/           # Backup files for the application
│   └── 📄 wpBCK_20250304_121959.zip # A backup file, possibly of a WordPress installation
├── 📄 backup.php        # PHP script for backup functionality
├── 📁 config/           # Configuration files for the application
│   └── 📄 config.php    # Holds database connection settings and other configurations
├── 📁 css/              # CSS files for styling the web application
│   └── 📄 bootstrap.min.css # Minified Bootstrap CSS for responsive design
├── 📄 do.php            # PHP script for specific operations
├── 📄 download.php      # PHP script for downloading files
├── 📄 export.php        # PHP script for exporting data
├── 📁 img/              # Images used in the application
│   ├── 📄 logo.png      # Application logo
│   └── 📄 icon.png      # Application icon
├── 📄 import.php        # PHP script for importing data
├── 📄 index.php         # Main entry point of the web application
├── 📄 install.php       # PHP script for installation tasks
├── 📁 js/               # JavaScript files for client-side functionality
│   ├── 📄 bootstrap.bundle.min.js # Minified Bootstrap JavaScript for responsive components
│   └── 📄 jquery-3.6.0.min.js # Minified jQuery library
├── 📄 main.php          # Main PHP script for application logic
├── 📄 restore.php       # PHP script for restoring data
├── 📁 sql/              # SQL files for database setup
│   └── 📄 loansdb.sql   # SQL script for creating and populating the `loansdb` database
└── 📁 view/             # View files for rendering HTML
    ├── 📄 messages_en.php # Language file for English messages
    ├── 📄 messages_es.php # Language file for Spanish messages
    └── 📄 nav.php       # Navigation bar for the application
```

---

## 🛠️ How to Use

1. **Clone the Repository**:
   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

2. **Run the Installation Script**:
   ```bash
   sudo bash install.sh
   ```

3. **Follow the Prompts**:
   - Provide the domain name when prompted.
   - The script will handle the rest, including dependency installation, file copying, and database setup.

4. **Access the Application**:
   - Once the script completes, access the application via the provided domain name or server IP address.

---

## 🧩 Key Features

- **Automated Deployment**: Simplifies the deployment process using Ansible.
- **Database Integration**: Automatically sets up a MariaDB database and imports SQL files.
- **Modular Structure**: Organized directory structure for easy maintenance and scalability.
- **Cross-Platform Compatibility**: Designed to work on Ubuntu and Debian systems.

---

## 🚨 Prerequisites

- **Operating System**: Ubuntu or Debian.
- **Root Access**: The script requires root privileges to install dependencies and configure the server.
- **Internet Connection**: Required to download dependencies and clone the repository.

---

## 📝 Conclusion

This project provides a **comprehensive and automated solution** for deploying a web application. By leveraging Ansible and a well-structured directory, it ensures a smooth and repeatable deployment process. Whether you're setting up a development environment or deploying to production, this project simplifies the process and reduces the risk of errors.

---

## 🙏 Credits

- **Ansible**: For server automation.
- **MariaDB**: For database management.
- **Bash Scripting**: For automating the installation process.

---

## 📜 License

This project is licensed under the **Non-Commercial MIT License**. 

### Key Points of the License:
- **Non-Commercial Use Only**: The software and its associated files may not be used for commercial purposes.
- **Attribution**: You must give appropriate credit, provide a link to the license, and indicate if changes were made.
- **No Warranty**: The software is provided "as is," without warranty of any kind.

For full details, see the [LICENSE](LICENSE) file.

---

Happy deploying! 🎉
