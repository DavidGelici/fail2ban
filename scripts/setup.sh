#!/bin/bash
useremail=$1

curl -sSfL "https://github.com/DavidGelici/fail2ban/raw/master/settings/jail.conf" -o /etc/fail2ban/jail.conf 2>&1
curl -sSfL "https://github.com/DavidGelici/fail2ban/raw/master/settings/paths-jelastic.conf" -o /etc/fail2ban/paths-jelastic.conf 2>&1
curl -sSfL "https://github.com/DavidGelici/fail2ban/raw/master/settings/apache-myadmin.conf" -o /etc/fail2ban/filter.d/apache-myadmin.conf 2>&1
curl -sSfL "https://github.com/DavidGelici/fail2ban/raw/master/settings/glassfish3-admin.conf" -o /etc/fail2ban/filter.d/glassfish3-admin.conf 2>&1
curl -sSfL "https://github.com/DavidGelici/fail2ban/raw/master/settings/mongodb-iptables.conf" -o /etc/fail2ban/filter.d/mongodb-iptables.conf 2>&1
curl -sSfL "https://github.com/DavidGelici/fail2ban/raw/master/settings/postgresql-iptables.conf" -o /etc/fail2ban/filter.d/postgresql-iptables.conf 2>&1
curl -sSfL "https://github.com/DavidGelici/fail2ban/raw/master/settings/postgresql.conf" -o /etc/fail2ban/filter.d/postgresql.conf 2>&1
sed -i "s~destemail = root@localhost~destemail = $useremail~g" /etc/fail2ban/jail.conf

for logfile in $(grep 'logpath =' /etc/fail2ban/jail.conf | tr ' ' :); do 
  file=$(echo $logfile | cut -d ":" -f 3);
  mkdir -p $(echo $file | grep -Eo '.*\/')
  touch $file
done;

# CNT=0
# for logfile in $(grep -n 'logpath =' /etc/fail2ban/jail.conf | tr ' ' :); do 
#   path=$(echo $logfile | cut -d ":" -f 4);
#   if [ ! -f "$path" ]; then
#     sed -i "$(($(echo $logfile | cut -d ":" -f 1)+$CNT)) i enabled = false" /etc/fail2ban/jail.conf;
#     (( CNT++ ));
#   fi
# done;

systemctl daemon-reload
/etc/init.d/fail2ban start