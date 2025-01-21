fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author '@devangelo25 on discord - https://rb.gy/673fz0'
description 'Hunting Animal'
version '1.0.0'

shared_scripts {
    "configs/main.lua",
    "configs/debug.lua", 
    "configs/framework.lua",
    "configs/lang.lua",
    '@ox_lib/init.lua',
}

client_scripts {
"client/**/*.lua",
"bridge/cl.lua",
}

server_scripts {
    "bridge/sv.lua",
    "server/**/*.lua",
}
