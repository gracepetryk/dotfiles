local git_blame = require('gitblame')

function blame_text()
    blame = git_blame.get_current_blame_text()
    cutoff = 100 

    if (string.len(blame) > cutoff + 3) then  -- add 3 for elipsis
        blame = string.sub(blame, 1, cutoff) .. '...'
    end

    return blame
end
    

require('lualine').setup({
    sections = {
        lualine_b = {
            'branch',
            'diff',
            'diagnostics',
            {
                blame_text,
                cond = git_blame.is_blame_text_available
            }
        },
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 1
            }
        }
    }
})
