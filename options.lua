-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
  vim.opt.linespace = 0
  vim.o.guifont = "D2CodingLigature Nerd Font:h11"
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5
  vim.g.neovide_paddint_top = 0
  vim.g.neovide_paddint_bottom = 0
  vim.g.neovide_paddint_left = 0
  vim.g.neovide_paddint_right = 0
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  vim.g.neovide_flaoting_corner = 0.2
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 0.8
end
