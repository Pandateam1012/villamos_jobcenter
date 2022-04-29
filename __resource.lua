fx_version 'adamant'

game 'gta5'

description 'jobcenter by 6osvillamos#9280'

version '1.0'

ui_page('html/index.html') 

files {
	'html/index.html',
  	'html/index.js',
  	'html/style.css',
    'html/img/*.png',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
	'config.lua',
	'client.lua'
}

dependencies {
	'es_extended'
}