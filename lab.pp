$packagelist = [
	'epel-release',
	'nginx',
	'php',
	'php-mysql',
	'php-fpm',
	]

$certificates = {
	'nginx-selfsigned.key' => '/etc/pki/nginx/private/server.key',
	'nginx-selfsigned.crt' => '/etc/pki/nginx/server.crt',
}
