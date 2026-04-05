document.body.insertAdjacentHTML("afterbegin", "\
<div class=\"menu\">\
    <svg width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" class=\"menu-title\">\
        <path d=\"M3 18h18v-2H3zm0-5h18v-2H3zm0-7v2h18V6z\"></path>\
    </svg>\
    <ul class=\"menu-items\">\
        <li><a href=\"./index.html\">Main Page</a></li>\
        <li><a href=\"./faq.html\">Frequently Asked Questions</a></li>\
        <li><a href=\"./troubleshooting.html\">Troubleshooting</a></li>\
        <li><a href=\"./settings_global.html\">Global Settings</a></li>\
        <li><a href=\"./settings_local.html\">Local Settings</a></li>\
        <li><a href=\"./sram_tables.html\">SRAM Tables</a></li>\
        <li><a href=\"./midway_instruction.html\">Multiple Midways</a></li>\
        <li>\
            <div class=\"submenu-title\">\
                Sprite Status Bar\
                <ul class=\"submenu-items\">\
                    <li><a href=\"./settings_global.html#sprite-status-bar\">Global Settings</a></li>\
                    <li><a href=\"./settings_local.html#ssb_config_item_box\">Per-Level Settings</a></li>\
                </ul>\
            </div>\
        </li>\
        <li>\
            <div class=\"submenu-title\">\
                Advanced Usage\
                <ul class=\"submenu-items\">\
                    <li><a href=\"./prompt_tilemap.html\">Prompt Tilemap Settings</a></li>\
                    <li><a href=\"./extra.html\">Extra Routines</a></li>\
                    <li><a href=\"./ram_map.html\">Retry RAM Map</a></li>\
                    <li><a href=\"./api.html\">Retry API Routines</a></li>\
                </ul>\
            </div>\
        </li>\
        <li><a href=\"./files.html\">Resources</a></li>\
        <li><a href=\"./hijack_map.html\">Hijack Map</a></li>\
    </ul>\
</div>\
");
