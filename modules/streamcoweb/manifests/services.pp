class streamcoweb::services {
	# Install all required packages
	$packagelist.each | String $package |{
		package {"Install $package" :
			name	=> $package,
			ensure	=> installed,
		}
	}
	
	# Add index.html
	file {'/usr/share/nginx/html/index.php':
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		content	=> template('streamcoweb/index.erb'),
	}
	
	# Add php-fpm.d/www.conf
	file {'/etc/php-fpm.d/www.conf':
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		source	=> "puppet:///modules/streamcoweb/www.conf",
	}
	file {'/etc/ssl/certs':
		ensure	=> 'directory',
		owner	=> 'root',
		mode	=> '0755',
	}
	file {"nginx-selfsigned.crt" :
		path	=> '/etc/ssl/certs/nginx-selfsigned.crt',
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/streamcoweb/nginx-selfsigned.crt'
	}
	file {"dhparam.pem" :
		path	=> '/etc/ssl/certs/dhparam.pem',
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/streamcoweb/dhparam.pem'
	}
#	$certslist = [ 'nginx-selfsigned.crt', 'dparam.pem']
#	$certslist.each|String $certname| {
#		file {"$certname" :
#			path	=> "/etc/ssl/certs/$certname",
#			ensure	=> file,
#			owner	=> 'root',
#			mode	=> '0644',
#			source	=> "puppet:///modules/streamcoweb/$certname",
#		}
#	}
	file {'/etc/ssl/private':
		ensure	=> 'directory',
		owner	=> 'root',
		mode	=> '0755',
	}-> 
	file {"nginx-selfsigned.key" :
		path	=> '/etc/ssl/private/nginx-selfsigned.key',
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		source	=> 'puppet:///modules/streamcoweb/nginx-selfsigned.key'
	}

	# Add 404.html
	file {'/usr/share/nginx/html/404.html':
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		source	=> "puppet:///modules/streamcoweb/404.html",
	}
	file {'/etc/nginx/nginx.conf':
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		content	=> template('streamcoweb/nginx_conf.erb'),
	}
	file {'/etc/nginx/conf.d/ssl.conf':
		ensure	=> file,
		owner	=> 'root',
		mode	=> '0644',
		content	=> template('streamcoweb/ssl_conf.erb'),
	}
		
	service {nginx:
		name => 'nginx',
		ensure	=> running,
		enable	=> true,
		subscribe => File["/etc/nginx/nginx.conf"]
	}
	service {php-fpm:
		name	=> php-fpm,
		ensure	=> running,
		enable	=> true,
		subscribe => File['/etc/php-fpm.d/www.conf'],
	}

	# Start required services
#	$servicelist.each | String $servicename |{
#		service {"Start $servicename" :
#			name	=> $servicename,
#			ensure	=> running,
#		}
#	}
}
