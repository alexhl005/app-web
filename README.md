# 🌐 app-web

## 📖 Description
This project is a web application designed to provide various functionalities. It is built using PHP and includes several features that enhance user experience.

## 📂 Project Structure
- **Root Files:**
  - `do.php`
  - `index.php`
  - `install.php`
  - `isntall.sh`
  - `main.php`
  - `README.md`

- **ansible/**: Configuration files for various services.
  - `main.conf.j2`
  - `main.yml`
  - `mainNG.conf.j2`
  - **ftp/**: FTP configuration files.
    - `vsftpd.conf.j2`
    - `vsftpd.yml`
  - **lamp/**: LAMP stack configuration files.
    - `lamp.conf.j2`
    - `lamp.yml`
    - `lampNG.conf.j2`
  - **moodle/**: Configuration files for Moodle.
  - **nextcloud/**: Configuration files for Nextcloud.
    - `ncApache.conf.j2`
    - `ncNginx.conf.j2`
    - `nextcloud.yml`
  - **vars/**: Variable files.
    - `varsMain.yml`
  - **wordpress/**: Configuration files for WordPress.
    - `wordpress.yml`
    - `wpApache.conf.j2`
    - `wpConfig.php.j2`
    - `wpNginx.conf.j2`

- **backEnd/**: Backend PHP files.
  - `appHeader.php`
  - `commons.php`
  - `mngSession.php`

- **css/**: CSS files.
  - `bootstrap.min.css`

- **img/**: Image assets.
  - `fondo.png`
  - `lamp.png`
  - `logo.png`
  - `logoutIcon.png`
  - `moodle.png`
  - `nc.png`
  - `wp.png`

- **js/**: JavaScript files.
  - `bootstrap.bundle.min.js`
  - `jquery-3.6.0.min.js`

- **sql/**: SQL files.
  - `loansdb.mwb`
  - `loansdb.mwb.bak`

- **view/**: View files for different languages.
  - `messages_en.php`
  - `messages_es.php`
  - `nav.php`

## 🚀 Usage
1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/app-web.git
   ```
2. **Navigate to the project directory**:
   ```bash
   cd app-web
   ```
3. **Run the application**:
   - For local development, you can use a local server like XAMPP or MAMP.
   - Place the project files in the server's root directory and access it via your browser.

## 📜 License
This project is licensed under the terms that it can be modified but not commercialized.

## 👥 Authors
- Alejandro Herrera Luque
- Rafael Bello Martinez
