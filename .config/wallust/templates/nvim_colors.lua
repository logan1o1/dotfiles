return {
    background = "{{background}}",
    foreground = "{{foreground}}",
    cursor = "{{cursor}}",
    {% for i in range(colors | length - 3) -%}
          color{{ i }} = "{{ colors[i] }}",
     {% endfor -%}
}
