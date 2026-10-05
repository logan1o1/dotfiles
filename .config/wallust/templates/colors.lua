return {
    background = "0xff{{ background | strip }}",
    foreground = "0xff{{ foreground | strip }}",
    cursor = "0xff{{ cursor | strip }}",
    primary = "0xff{{ color1 | lighten(0.30) | strip }}",
    secondary = "0xff{{ color2 | lighten(0.25) | strip }}",
    shadow = "0xff{{ color0 | strip }}",
{% for i in range(colors | length - 2) -%}
    color{{ i }} = "0xff{{ colors[i] | strip }}",
{% endfor -%}
}
