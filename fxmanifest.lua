fx_version 'cerulean'
game 'gta5'

lua54 "yes"
author "onecodes"
version "1.0.5"
description 'Simple /pcheck [id] with /pcheckban [id] with supported fiveguard anticheat ban'


server_scripts {
    'server.lua'
}

client_scripts {
    'client.lua',
}

ui_page "html/ui.html"
files {
    "html/ui.html",
    "html/ui.css",
    "html/ui.js",
    "html/*.mp3"
}

shared_script '@ox_lib/init.lua'

