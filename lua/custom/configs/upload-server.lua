local Menu = require "nui.menu"
local buf_utils = require "custom.utils.buf"

local M = {}

-- upload server config
-- example:
-- local upload_configs = {
--   {
--      name = "your project root name"
--      target_root_dir = "project root name on remote server"
--      servers = {
--        {name = "alias name", host = "1.1.1."}
--      }
--   }
-- }

local configs = {
  {
    name = "nvim",
    target_root_dir = "~/.config/nvim/",
    servers = {
      { name = "arch1", host = "1.1.1.1" },
      { name = "arch2", host = "2.2.2.2" },
    },
  },
}

local function get_config()
  local root_name = buf_utils.get_root_name()
  for _, one_config in ipairs(configs) do
    if one_config.name == root_name then
      return one_config
    end
  end

  local msg = string.format("Not find name='%s', pls add configuration for '%s' firstly!", root_name, root_name)
  vim.notify(msg, vim.log.levels.ERROR)
  return nil
end

local function show_menu(lines, on_submit, on_close)
  Menu({
    position = "50%",
    size = {
      width = 25,
      height = 5,
    },
    border = {
      style = "single",
      text = {
        top = "Choose Your Server:",
        top_align = "center",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
  }, {
    lines = lines,
    max_width = 20,
    keymap = {
      focus_next = { "j", "<Down>", "<Tab>" },
      focus_prev = { "k", "<Up>", "<S-Tab>" },
      close = { "<Esc>", "<C-c>" },
      submit = { "<CR>", "<Space>" },
    },
    on_submit = on_submit,
    on_close = on_close,
  }):mount()
end

local function encode_line(idx, server)
  return string.format("%s. %s -> %s", idx, server.name, server.host)
end

local function decode_line(line)
  local chunks = vim.fn.split(line, " ")
  return {
    idx = string.gsub(chunks[1], "[.]", ""),
    name = chunks[2],
    host = chunks[4],
  }
end

local function run_upload(target)
  -- TODO imcomplete upload action
  print(target.idx, target.name, target.host)
end

function M.upload_server()
  local config = get_config()
  if config == nil then
    return
  end

  local lines = {}
  for idx, server in ipairs(config.servers) do
    table.insert(lines, Menu.item(encode_line(idx, server)))
  end

  show_menu(lines, function(item)
    run_upload(decode_line(item.text))
  end, function()
    vim.notify "Cancel upload"
  end)
end

M.upload_server()

return M
