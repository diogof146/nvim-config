-- Smear Cursor plugin

return {
  
  "sphamba/smear-cursor.nvim",

  opts = {

    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,

    -- Smear cursor when moving within line or to neighbor lines.
    smear_between_neighbor_lines = true,

    -- Draw the smear in buffer space instead of screen space when scrolling
    scroll_buffer_space = true,

    -- Set to `true` if your font supports legacy computing symbols
    legacy_computing_symbols_support = true,

    -- Smear cursor in insert mode.
    smear_insert_mode = true,

    -- Smear color
    cursor_color = '#22898c',

    -- Physics parameters
    stiffness = 1,
    trailing_stiffness = 0.4,
    stiffness_insert_mode = 0.7,
    trailing_stiffness_insert_mode = 0.7,
    damping = 0.6,
    damping_insert_mode = 0.8,
    distance_stop_animating = 0.1,
  },
}
