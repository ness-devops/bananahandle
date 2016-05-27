package "apache2" do
 action :install
end

service "apache2" do
 action [:enable, :start]
end

  document_root = "/var/www/html/ness-devops.com"

  directory document_root do
    mode "0755"
    recursive true
  end

  template "/etc/apache2/sites-available/ness-devops.com.conf" do
    source "virtualhosts.erb"
    mode "0644"
    variables(
      :document_root => document_root,
      :port => node["lamp-stack"]["sites"]["ness-devops.com"]["port"],
      :serveradmin => node["lamp-stack"]["sites"]["ness-devops.com"]["serveradmin"],
      :servername => node["lamp-stack"]["sites"]["ness-devops.com"]["servername"]
     )
    notifies :restart, "service[apache2]"
  end
 
  execute "enable-sites" do
    command "a2ensite ness-devops.com"
    action :nothing
  end

  template "/etc/apache2/sites-available/ness-devops.com.conf" do
    notifies :run, "execute[enable-sites]"
  end
 
  directory "/var/www/html/ness-devops.com/public_html" do
    action :create
  end

  directory "/var/www/html/ness-devops.com/logs" do
    action :create
  end
  
  # Write the home page.
  file "/var/www/html/ness-devops.com/public_html/index.html" do
    content '<html>This is a placeholder</html>'
    mode '0644'
    owner 'www-data'
    group 'www-data'
  end
