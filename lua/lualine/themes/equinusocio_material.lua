local colors = {
  color0  = "#000000",
  color1  = "#c3e88d",
  color2  = "#eeffff",
  color3  = "#545454",
  color4  = "#2f2f2f",
  color5  = "#89ddff",
  color8  = "#ff5370",
  color11 = "#ffcb6b",
}

local equinusocio_material = {
  normal = {
    a = {
      fg = colors.color0,
      bg = colors.color1,
      gui = "bold",
    },
    b = {
      fg = colors.color2,
      bg = colors.color3,
    },
    c = {
      fg = colors.color2,
      bg = colors.color4,
    },
  },
  insert = {
    a = {
      fg = colors.color4,
      bg = colors.color5,
      gui = "bold",
    },
    b = {
      fg = colors.color2,
      bg = colors.color3,
    },
  },
  inactive = {
    a = {
      fg = colors.color2,
      bg = colors.color3,
      gui = "bold",
    },
    b = {
      fg = colors.color2,
      bg = colors.color3,
    },
    c = {
      fg = colors.color2,
      bg = colors.color4,
    },
  },
  replace = {
    a = {
      fg = colors.color0,
      bg = colors.color8,
      gui = "bold",
    },
    b = {
      fg = colors.color2,
      bg = colors.color3,
    },
  },
  visual = {
    a = {
      fg = colors.color0,
      bg = colors.color11,
      gui = "bold",
    },
    b = {
      fg = colors.color2,
      bg = colors.color3,
    },
  },
}

return equinusocio_material
