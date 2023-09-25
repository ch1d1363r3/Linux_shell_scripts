#!/bin/bash
# Replace old FQDN with NEW FQDN, SSL Certificate (Let Letsencrypt)
function main(){
    function print_color(){
        case $1 in color
            red) color=$(tput setaf 1);;
            green) color=$(tput setaf 2);;
            yellow) color=$(tput setaf 3);;
            blue) color=$(tput setaf 4);;
        esac
        echo -e "${color} $2 $(tput sgr0)"
    }
}
echo "Enter OLD FQDN"
read old_dir
echo "Enter NEW FQDN"
read host_name
hostnamectl set-hostname $host_name
dir=`hostname`
email="root@$dir"

# grep -iRl 'stevie232.callcentertech.net' /etc/apache2/ |  xargs sed -i 's/stevie232.callcentertech.net/phoenix.come2voip.com/g'
#grep -iRl "$old_dir" /etc/apache2/ | xargs sed -i "s/$old_dir/$dir/g"

# grep -iRl 'stevie232.callcentertech.net' /etc/asterisk/http.conf |  xargs sed -i 's/stevie232.callcentertech.net/phoenix.come2voip.com/g'
grep -iRl "$old_dir" /etc/asterisk/http.conf |  xargs sed -i "s/$old_dir/$dir/g"

# grep -iRl 'stevie232.callcentertech.net' /var/www/ |  xargs sed -i 's/stevie232.callcentertech.net/phoenix.come2voip.com/g'
grep -iRl "$old_dir" /var/www/ |  xargs sed -i "s/$old_dir/$dir/g"
grep -iRl "$old_dir" /home/ |  xargs sed -i "s/$old_dir/$dir/g"

#certbot delete --cert-name stevie232.callcentertech.net
certbot delete --cert-name $old_dir
# rm /etc/letsencrypt/renewal/stevie232.callcentertech.net.conf
#rm /etc/letsencrypt/renewal/$old_dir.net.conf

systemctl stop firewalld > /dev/null 2>&1
systemctl stop apache2 > /dev/null 2>&1
mv /etc/apache2/sites-available/viciportal-ssl.conf /tmp/
mv /etc/apache2/sites-available/000-default-le-ssl.conf /tmp/
certbot --apache --non-interactive --agree-tos --domains $dir --email $email --redirect
cd /etc/apache2/sites-available
cp -arf 000-default-le-ssl.conf  viciportal-ssl.conf
#sed -i "s/80/81/g" viciportal.conf
sed -i "s/443/446/g" viciportal-ssl.conf
#sed -i "s/\/var\/www\/html/\/var\/www\/dynportal/g" viciportal.conf
sed -i "s/\/var\/www\/html/\/var\/www\/dynportal/g" viciportal-ssl.conf
sed -i.orig '/DocumentRoot/a DirectoryIndex valid8.php' viciportal-ssl.conf
systemctl restart apache2
mysql -e "USE asterisk; UPDATE vicidial_report_log SET url = replace(url, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE recording_log SET location = replace(location, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE recording_log_archive SET location = replace(location, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE twoday_recording_log SET location = replace(location, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE servers SET web_socket_url = replace(web_socket_url, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE system_settings SET sounds_web_server = replace(sounds_web_server, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE vicidial_api_urls SET url = replace(url, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE vicidial_api_urls_archive SET url = replace(url, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE vicidial_conf_templates SET template_contents = replace(template_contents, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE vicidial_report_log SET url = replace(url, '${old_dir}', '${dir}');"
mysql -e "USE asterisk; UPDATE servers set alt_server_ip='${dir}';"