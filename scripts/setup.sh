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

config_file="/etc/fail2ban/jail.conf"
temp_file="temp.conf"
while IFS= read -r line; do
  if [[ $line =~ ^logpath[[:space:]]*=[[:space:]]*(.*) ]]; then
    log_path="${BASH_REMATCH[1]}"
    if [[ -d $log_path ]]; then
      echo "$line"
      echo "enabled = true"
    else
      echo "$line"
      echo "enabled = false"
    fi
  else
    echo "$line"
  fi
done < "$config_file" > "$temp_file"
mv "$temp_file" "$config_file"

systemctl daemon-reload
/etc/init.d/fail2ban start
