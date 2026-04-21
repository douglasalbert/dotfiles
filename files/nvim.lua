-- airline
vim.g.airline_powerline_fonts = 1
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.airline_theme = 'term'

-- Use terminal colors and transparent background (inherits ghostty theme)
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })

--
-- Options
--

vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.number = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.startofline = false
vim.opt.cursorcolumn = false
vim.opt.cursorline = false

vim.opt.encoding = 'utf-8'
vim.opt.fileformats = { 'unix', 'dos', 'mac' }

vim.opt.wildmode = { 'longest', 'list', 'full' }
vim.opt.wildmenu = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.confirm = true

vim.opt.mouse = 'a'

vim.opt.timeout = false
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 200

--
-- Formatting
--

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 79
vim.opt.formatoptions = 'qrn1j'
vim.opt.colorcolumn = '79'
vim.opt.relativenumber = true

vim.opt.listchars = { tab = '>.', trail = '.', extends = '#', nbsp = '.' }
vim.opt.list = true

vim.opt.autoindent = true
vim.opt.complete:remove('i')
vim.opt.showmatch = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.opt.switchbuf = { 'usetab', 'newtab' }
vim.opt.completeopt = { 'longest', 'menuone' }
vim.opt.tags = './tags,tags;'

--
-- Autocmds
--

vim.api.nvim_create_augroup('vimrcEx', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = 'vimrcEx',
  pattern = 'text',
  callback = function() vim.opt_local.textwidth = 72 end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = 'vimrcEx',
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line('$') then
      vim.cmd("normal! g`\"")
    end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = 'vimrcEx',
  pattern = 'gitcommit',
  callback = function() vim.fn.setpos('.', { 0, 1, 1, 0 }) end,
})

--
-- Keymaps
--

vim.g.mapleader = ','

vim.keymap.set('n', '<leader>W', ':%s/\\s\\+$//<CR>:let @/=""<CR>')
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', '<C-L>', ':nohl<CR><C-L>')

vim.keymap.set('n', '<Right>', '<C-w>l')
vim.keymap.set('n', '<Left>', '<C-w>h')
vim.keymap.set('n', '<Up>', '<C-w>k')
vim.keymap.set('n', '<Down>', '<C-w>j')

vim.keymap.set('n', 'th', ':tabprev<CR>')
vim.keymap.set('n', 'tl', ':tabnext<CR>')
vim.keymap.set('n', 'tt', ':tabedit<Space>', { silent = false })
vim.keymap.set('n', 'tn', ':tabnext<Space>', { silent = false })
vim.keymap.set('n', 'tm', ':tabm<Space>', { silent = false })
vim.keymap.set('n', 'td', ':tabclose<CR>')
