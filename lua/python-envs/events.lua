local M = {}

local current_venv_dir = nil

local make_bin_dir = function (venv_dir)
  return venv_dir .. '/bin'
end


function M.cleanup()
  if current_venv_dir == nil then
    return
  end

  local bin_dir = make_bin_dir(current_venv_dir)

  local entries = {}
  for _, path in ipairs(vim.split(vim.env.PATH, ':')) do
    if path ~= bin_dir then
      table.insert(entries, path)
    end
  end

  vim.env.PATH = vim.fn.join(entries, ':')
end


function M.add(venv_dir)
  local entries = vim.split(vim.env.PATH, ':')
  table.insert(entries, 1, make_bin_dir(venv_dir))

  vim.env.PATH = vim.fn.join(entries, ':')
  vim.env.VIRTUAL_ENV = venv_dir

  current_venv_dir = venv_dir

  vim.notify('venv → ' .. current_venv_dir)
end


function M.init(cwd)
  for _, dot in ipairs { '.venv', '.env' } do
    local venv_dir = cwd .. '/' .. dot
    if vim.fn.isdirectory(make_bin_dir(venv_dir)) == 1 then
      M.cleanup()
      M.add(venv_dir)
      return
    end
  end
end

return M
