local au_group = vim.api.nvim_create_augroup('anekos-python-envs', { clear = true })

local events = require('python-envs.events')

vim.api.nvim_create_autocmd({ 'VimEnter' }, {
  pattern = '*',
  callback = function()
    events.init(vim.env.PWD)
  end,
  group = au_group,
})

vim.api.nvim_create_autocmd({ 'DirChanged' }, {
  pattern = '*',
  callback = function(ev)
    events.init(ev.file)
  end,
  group = au_group,
})

vim.api.nvim_create_autocmd({ 'DirChangedPre' }, {
  pattern = '*',
  callback = function()
    events.cleanup()
  end,
  group = au_group,
})

vim.api.nvim_create_user_command('PythonPath', function(args)
  events.init(args.args)
end, {
  nargs = 1,
  complete = 'dir',
})
