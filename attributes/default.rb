case node["platform_family"]
when "debian"
#  default["packages"] = %w(
 #          libssl-dev
 #          libyaml-dev
 #          libreadline-dev
 #          openssl
 #          curl
 #          git-core
 #          zlib1g-dev
 #          bison
 #          libxml2-dev
 #          libxslt1-dev
 #          libcurl4-openssl-dev
 #          nodejs
 #          libsqlite3-dev
 #          sqlite3
 #          git
	#   apache2)
   default["apache_service"] = "apache2"
when "rhel"
end
#
default['project_install_directory'] = '/home/deploy/apps/'
