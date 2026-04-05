function is_whitespace(ch) {
    return /\s/.test(ch);
}

function remove_whitespace(str) {
    return str.replace(/\s/g, "");
}

function generate() {
    let line1 = document.getElementById("line1").value;
    let line2 = document.getElementById("line2").value;
    let out = document.getElementById("out");
    let err = document.getElementById("err");

    out.innerHTML = "";
    err.innerHTML = "";

    if (line1.length === 0) {
        err.innerHTML = "Error: first line cannot be empty!";
        return;
    }

    var chars1 = new Set(remove_whitespace(line1));
    var chars2 = [...new Set(remove_whitespace(line2)).difference(chars1)];
    chars1 = [...chars1];
    var chars = chars1.concat(chars2);

    var tiles1 = "    !prompt_tiles_line1 = <";
    tiles1 += chars1.length;
    tiles1 += " values>\n";
    
    var tiles2;
    if (chars2.length === 0) {
        tiles2 = "    ;!prompt_tiles_line2 =\n";
    } else {
        tiles2 = "    !prompt_tiles_line2 = <";
        tiles2 += chars2.length;
        tiles2 += " values>";
    }


    var idx = 3; // Start after cursor
    
    var gfx_index1 = "    !prompt_gfx_index_line1  = ";
    for (var i = 0; i < chars1.length; i++) {
        gfx_index1 += idx++;
        if (i < chars1.length - 1) gfx_index1 += ",";
    }

    var gfx_index2;
    if (chars2.length === 0) {
        gfx_index2 = "    ;!prompt_gfx_index_line2 =";
    } else {
        gfx_index2 = "    !prompt_gfx_index_line2  = ";
        for (var i = 0; i < chars2.length; i++) {
            gfx_index2 += idx++;
            if (i < chars2.length - 1) gfx_index2 += ",";
        }
    }

    var tile_index1 = "    !prompt_tile_index_line1 = ";
    for (var i = 0; i < line1.length; i++) {
        if (is_whitespace(line1[i]))
            tile_index1 += "-1";
        else
            tile_index1 += chars.indexOf(line1[i]);
        if (i < line1.length - 1) tile_index1 += ",";
    }

    var tile_index2;
    if (line2.length === 0 || remove_whitespace(line2).length === 0) {
        tile_index2 = "    ;!prompt_tile_index_line2 =";
    } else {
        tile_index2 = "    !prompt_tile_index_line2 = ";
        for (var i = 0; i < line2.length; i++) {
            if (is_whitespace(line2[i]))
                tile_index2 += "-1";
            else
                tile_index2 += chars.indexOf(line2[i]);
            if (i < line2.length - 1) tile_index2 += ",";
        }
    }

    var max_len = gfx_index1.length;
    if (gfx_index2.length > max_len) max_len = gfx_index2.length;
    gfx_index1 += " ".repeat(max_len - gfx_index1.length + 1);
    gfx_index1 += "; ";
    gfx_index1 += line1;
    gfx_index1 += "\n";
    gfx_index2 += " ".repeat(max_len - gfx_index2.length + 1);
    gfx_index2 += "; ";
    gfx_index2 += line2;
    gfx_index2 += "\n";

    max_len = tile_index1.length;
    if (tile_index2.length > max_len) max_len = tile_index2.length;
    tile_index1 += " ".repeat(max_len - tile_index1.length + 1);
    tile_index1 += "; ";
    tile_index1 += line1;
    tile_index1 += "\n";
    tile_index2 += " ".repeat(max_len - tile_index2.length + 1);
    tile_index2 += "; ";
    tile_index2 += line2;
    tile_index2 += "\n";

    out.innerHTML = "<pre>    !prompt_tile_cursor = <1 value>\n" + tiles1 + tiles2 + "</pre>"
                    + "<pre>    !prompt_gfx_index_cursor = 0\n" + gfx_index1 + gfx_index2 + "</pre>"
                    + "<pre>" + tile_index1 + tile_index2 + "</pre>";

    chars = "\u25B6  ".concat(chars.join("")).replaceAll(" ", "\u2B1C");
    var table = "";
    
    for (var i = 0; i < 16*8; i++) {
        if (i % 16 === 0)  table += "<tr>";
        table += "<td>";
        if (i < chars.length) table += chars[i];
        table += "</td>";
        if (i % 16 === 15) table += "</tr>";
    }

    var out_table = document.getElementById("out-table");
    if (out_table === null) {
        out_label = document.createElement("p");
        out_label.innerHTML = "GFX Layout:<br/>";
        document.getElementById("out-wrap").appendChild(out_label);
        out_table = document.createElement("table");
        out_table.id = "out-table";
        out_table.classList.add("out-table");
        document.getElementById("out-wrap").appendChild(out_table);
    }
    out_table.innerHTML = table;
    window.scrollTo(0, document.body.scrollHeight);
}
