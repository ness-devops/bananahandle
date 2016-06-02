mysqlpass = Chef::EncryptedDataBagItem.load("mysql", "rtpass")

mysql_service 'ness' do
  port '3306'
  version '5.5'
  initial_root_password mysqlpass['password']
  action [:create, :start]
end

# This is used repeatedly, so we'll store it in a variable
mysql_connection_info = {
  host:     'localhost',
  username: 'root',
  password: mysqlpass['password']
}

# Ensure a database exists with the name of our app
mysql_database node['lamp-stack']['site']['name'] do
  connection mysql_connection_info
  action     :create
end

# Ensure a database user exists with the name of our app
mysql_database_user node['lamp-stack']['site']['name'] do
  connection mysql_connection_info
  password   node['lamp-stack']['site']['db_password']
  action     :create
end

# Let this database user access this database
mysql_database_user node['lamp-stack']['site']['name'] do
  mysql_connection_info
  password      node['lamp-stack']['site']['db_password']
  database_name node['lamp-stack']['site']['name']
  host          'localhost'
  action        :grant
end
