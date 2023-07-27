-- from :h setting-tabline
vim.cmd([[
    function! MyTabLine()
        let s = ''
        for i in range(tabpagenr('$'))
            " select the highlighting
            if i + 1 == tabpagenr()
                let s ..= '%#TabLineSel#'
            else
                let s ..= '%#TabLine#'
            endif

            " set the tab page number (for mouse clicks)
            let s ..= '%' .. (i + 1) .. 'T'

            " the label is made by MyTabLabel()
            let s ..= ' %{MyTabLabel(' .. (i + 1) .. ')} '
        endfor

        " after the last tab fill with TabLineFill and reset tab page nr
        let s ..= '%#TabLineFill#%T'

        " right-align the label to close the current tab page
        if tabpagenr('$') > 1
            let s ..= '%=%#TabLine#%999Xclose'
        endif

        return s
    endfunction

    function! MyTabLabel(n)
        let tab_label = gettabvar(a:n, 'label', '')
        if tab_label != ''
            return tab_label
        endif

        let buflist = tabpagebuflist(a:n)
        let winnr = tabpagewinnr(a:n)
        return bufname(buflist[winnr - 1])
    endfunction
]])

vim.opt.tabline='%!MyTabLine()'
