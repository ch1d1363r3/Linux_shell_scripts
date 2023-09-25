#!/bin/bash
function main(){
        function print_color(){
                        case $1 in
                        green) color=$(tput setaf 2) ;;
                        red) color=$(tput setaf 1) ;;
                        blue) color=$(tput setaf 4);;
                        yellow) color=$(tput setaf 3);;
                        esac
                        echo -e "${color} $2 $(tput sgr0)"
        }
        function get_distro(){
                        DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(ubuntu|centos)' | uniq )
                        echo $DISTRO
        }
        function ubuntu_installer(){
                print_color "yellow" "... Now Updating repo list and packages"
                #sudo apt update -y
                print_color "green" " Update now complete !!!"
                print_color "yellow" "... Downloading and Installing LAMP stack Packages ..."
                sudo apt install -y $1
                print_color "green" " LAMP stack Packages Download and Installation complete !!!"
                print_color "yellow" "Now Setting up firewall to allow services"
                sudo ufw allow in "Apache"
                sudo ufw allow in $port_no
                sudo ufw reload
                print_color "green" " Firewall Setup now complete ... "
                print_color "green" " _____________________________________________________________________"
                print_color "green" " _____________________________________________________________________"
                print_color "blue" " Now setting up Database ..."
                print_color "yellow" "Starting Mysql Server.."
                sudo service mysql start
                sudo systemctl enable mysql
                cat > db_conf.sql <<-EOF
                CREATE DATABASE $db_name;
                CREATE USER '$sql_user'@'localhost' IDENTIFIED BY '$passwd';
                GRANT ALL PRIVILEGES ON $db_name.* TO '$sql_user'@'localhost';
                FLUSH PRIVILEGES;
EOF
                sudo mysql < db_conf.sql
                print_color "blue" " Now Loading Database ..."
                sudo cat > $db_loader <<-EOF
                USE $db_name;
                CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
                INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF
                sudo mysql < $db_loader
                print_color "yellow" " _____________________________________________________________________"
                print_color "yellow" " _____________________________________________________________________"
                print_color "green" " Database setup and configuration is now COMPLETE !!! "
                print_color "yellow" " _____________________________________________________________________"
                print_color "yellow" " _____________________________________________________________________\n"
                print_color "green" " _____________________________________________________________________"
                print_color "green" " _____________________________________________________________________"
                print_color "blue" " Now setting up Webserver ..."
                sudo sed -i "s/index.html/index.php/g" /etc/apache2/apache2.conf
                # Start apache2 service
                print_color "yellow" "Now starting apache2 service.."
                sudo mkdir /var/www/sites/$domain
                sudo chown -R $USER:$USER /var/www/sites/$domain
                print_color "green" "Installing Git..."
                sudo apt install -y git
                sudo git clone $git_path  /var/www/sites/$domain
                sudo sed -i "s/ecomuser/$sql_user/g" /var/www/sites/$domain/index.php
                sudo sed -i "s/ecomdb/$db_name/g" /var/www/sites/$domain/index.php
                sudo sed -i "s/ecompassword/$passwd/g" /var/www/sites/$domain/index.php
                sudo sed -i 's/172.20.1.101/localhost/g' /var/www/sites/$domain/index.php
                sudo cat > $domain.conf  <<-EOF
                <VirtualHost *:$port_no>
                        ServerName $domain
                        ServerAlias $domain
                        ServerAdmin webmaster@localhost
                        DocumentRoot /var/www/sites/$domain
                        ErrorLog /var/log/apache2/$domain/error.log
                        CustomLog /var/log/apache2/$domain/access.log combined
                </VirtualHost>
EOF
                sudo mkdir /etc/apache2/sites-available
                sudo mkdir /etc/apache2/sites-enabled
                sudo mkdir /var/log/apache2/$domain
                sudo mv $domain.conf /etc/apache2/sites-available/
                sudo chown root /etc/apache2/sites-available/$domain.conf
                sudo chmod 550 /etc/apache2/sites-available/$domain.conf
                sudo a2ensite $domain
                sudo a2dissite 000-default
                sudo systemctl reload apache2
                print_color "yellow" " _____________________________________________________________________"
                print_color "yellow" " _____________________________________________________________________"
                print_color "green" " Webserver setup and configuration is now COMPLETE !!! "
                print_color "yellow" " _____________________________________________________________________"
                print_color "yellow" " _____________________________________________________________________\n"
        }
        function centos_installer(){
                echo "---------------- Setup Database Server ------------------"
                # Install and configure firewalld
                print_color "green" "Installing FirewallD.. "
                sudo yum install -y firewalld
                print_color "green" "Installing FirewallD.. "
                sudo service firewalld start
                sudo systemctl enable firewalld
                print_color "green" "Installing MariaDB Server.."
                sudo yum install -y mariadb-server
                print_color "green" "Starting MariaDB Server.."
                sudo service mariadb start
                sudo systemctl enable mariadb
                print_color "green" "Configuring FirewallD rules for database.."
                sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
                sudo firewall-cmd --reload
                print_color "green" "Setting up database.."
                cat > db_conf.sql <<-EOF
                CREATE DATABASE $db_name;
                CREATE USER '$sql_user'@'localhost' IDENTIFIED BY '$passwd';
                GRANT ALL PRIVILEGES ON $db_name.* TO '$sql_user'@'localhost';
                FLUSH PRIVILEGES;
EOF
                sudo mysql < db_conf.sql
                print_color "blue" " Now Loading Database ..."
                sudo cat > $db_loader <<-EOF
                USE $db_name;
                CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
                INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
EOF
                sudo mysql < $db_loader
                print_color "green" "---------------- Setup Database Server - Finished ------------------"
                print_color "green" "---------------- Setup Web Server ------------------"
                print_color "green" "Installing Web Server Packages .."
                sudo yum install -y httpd php php-mysqlnd
                print_color "green" "Configuring FirewallD rules.."
                sudo firewall-cmd --permanent --zone=public --add-port=$port_no/tcp
                sudo firewall-cmd --reload
                sudo sed -i 's/index.html/index.php/g' /etc/httpd/conf/httpd.conf
                print_color "green" "Start httpd service.."
                sudo service httpd start
                sudo systemctl enable httpd
                print_color "green" "Install GIT.."
                sudo yum install -y git
                sudo mkdir -p /var/www/sites/$domain
                sudo chown -R $USER:wheel /var/www/sites/$domain
                sudo chmod -R 755 /var/www/
                sudo git clone $git_path /var/www/sites/$domain
                sudo sed -i "s/ecomuser/$sql_user/g" /var/www/sites/$domain/index.php
                sudo sed -i "s/ecomdb/$db_name/g" /var/www/sites/$domain/index.php
                sudo sed -i "s/ecompassword/$passwd/g" /var/www/sites/$domain/index.php
                sudo sed -i 's/172.20.1.101/localhost/g' /var/www/sites/$domain/index.php
                print_color "green" "Updating index.php.."
                sudo sed -i 's/172.20.1.101/localhost/g' /var/www/sites/$domain/index.php
                sudo cat > $domain.conf  <<-EOF
                <VirtualHost *:$port_no>
                        ServerName $domain
                        ServerAlias $domain
                        ServerAdmin webmaster@localhost
                        DocumentRoot /var/www/sites/$domain
                        ErrorLog /var/log/httpd/$domain/error.log
                        CustomLog /var/log/httpd/$domain/access.log combined
                </VirtualHost>
EOF
                sudo mkdir /etc/httpd/sites-available
                sudo mkdir /etc/httpd/sites-enabled
                sudo mkdir /var/log/httpd/$domain
                sudo mv $domain.conf /etc/httpd/sites-available/
                sudo restorecon -vF /etc/httpd/sites-available/$domain.conf
                sudo chown root /etc/httpd/sites-available/$domain.conf
                sudo chmod 550 /etc/httpd/sites-available/$domain.conf
                sudo ln -s /etc/httpd/sites-available/$domain.conf /etc/httpd/sites-enabled/$domain.conf
                sudo sed -i "s/index.html/index.php/g" /etc/httpd/conf/httpd.conf
                sudo semanage port -a -t http_port_t -p tcp $port_no
                sudo systemctl restart httpd
                print_color "green" "---------------- Setup Web Server - Finished ------------------"
        }
        print_color "yellow" " _____________________________________________________________________"
        print_color "green" " _____________________________________________________________________"
        print_color "blue" " Welcome To The Great LAMP Stack Deployment tool Powered by Tchidi "
        print_color "green" " _____________________________________________________________________"
        print_color "yellow" " _____________________________________________________________________"
        print_color "blue" " Kindly provide the following information correctly for configuration of LAMP Stack"
        print_color "yellow" " _____________________________________________________________________"
        print_color "yellow" " _____________________________________________________________________"
        echo -e "1. Enter your preferred domain name \n"
        read domain
        echo -e "2. Enter your the preferred name for your Database \n"
        read db_name
        echo -e "3. Enter User password for Database \n"
        IFS= read -s  passwd
        echo -e "4. Enter the absolute path to your Git repo for your php file"
        read git_path
        echo -e "5. Enter Port Number to Serve Web content"
        read port_no
        echo -e "6. Enter the absolute path to your script for loading Database"
        read db_load_path
        sql_user=$(echo $USER)
        db_loader=$(echo $db_load_path/"db_loader.sql")
        print_color "blue" "....Detecting Distro..."
        distro=$(get_distro)
        print_color "green" "---- $distro Detected ----"
        ubuntu_pkg=$(echo "apache2 mysql-server php libapache2-mod-php php-mysql")
        #rhel_pkg=$(echo "firewalld mariadb-server httpd php php-mysql")
        if [[ "${distro}" = "centos" ]]; then
                centos_installer
                elif  [[ "${distro}" = "ubuntu" ]]; then
                        ubuntu_installer "$ubuntu_pkg"
                else
                echo "This Machine is Neither Ubuntu nor Centos"

        fi
}
main