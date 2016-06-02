package "apache2" do
 action :install
end

service "apache2" do
 action [:enable, :start]
end
  site_name= node['lamp-stack']['site']['name']
  document_root = "/var/www/html/#{site_name}"

  directory document_root do
    mode "0755"
    recursive true
  end

  template "/etc/apache2/sites-available/#{site_name}.conf" do
    source "virtualhosts.erb"
    mode "0644"
    variables(
      :document_root => document_root,
      :port => node["lamp-stack"]["site"]["port"],
      :serveradmin => node["lamp-stack"]["site"]["serveradmin"],
      :servername => node["lamp-stack"]["site"]["servername"]
     )
    notifies :restart, "service[apache2]"
  end
 
  execute "enable-sites" do
    command "a2ensite #{site_name}"
    action :nothing
  end

  template "/etc/apache2/sites-available/#{site_name}.conf" do
    notifies :run, "execute[enable-sites]"
  end
 
  directory "/var/www/html/#{site_name}/public_html" do
    action :create
  end

  directory "/var/www/html/#{site_name}/logs" do
    action :create
  end
  #remove default file
 
  file '/etc/apache2/sites-available/000-default.conf' do
    action :delete
  end 

  # Write the home page.
  file "/var/www/html/#{site_name}/public_html/index.html" do
    content '<html><head><title>Ness Devops</title></head><body><H1>Welcome to NESS!!!! </H1></body></html>'
    mode '0644'
    owner 'www-data'
    group 'www-data'
  end
