return {
    <* for name, value in colors *>
    {{name}} = "0xff{{value.default.hex_stripped}}",
    <* endfor *>
}

-- return {
--         active_border = "rgba({{base16.base08.default.hex_stripped}}ff)",
--         inactive_border = "rgba({{colors.surface_dim.default.hex_stripped}}aa)",
--         shadow_color = "rgba({{colors.shadow.default.hex_stripped}}ee)",
-- }
