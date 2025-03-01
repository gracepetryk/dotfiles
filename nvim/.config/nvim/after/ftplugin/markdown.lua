local rtp = vim.opt.rtp:get()
local path = vim.fn.expand('%')
local path_root = path:gsub('/doc/[^/]*%.md$', '')

if type(rtp) == "table" and vim.tbl_contains(rtp, path_root) then
    vim.cmd.wincmd('L')
    vim.cmd('vert resize 90')
end
