vim.opt.formatoptions = 'cqjlr2'

local python_query = vim.treesitter.query.get('python', 'highlights')

if python_query == nil then
    return
end

local constant_builtin_index

for i, capture in pairs(python_query.captures) do
    if capture == 'constant.builtin' then
        constant_builtin_index = i
        break
    end
end

if constant_builtin_index == nil then
    return
end

for _, pattern in pairs(python_query.info.patterns) do
    local pattern = pattern[1] ---@diagnostic disable-line: redefined-local
    local directive = pattern[1]
    local capture_index = pattern[2]

    if capture_index ~= constant_builtin_index or directive ~= "any-of?" then
        goto continue
    end


    if pattern.string_set ~= nil then
        pattern.string_set.license = nil
    end

    for i, symbol in pairs(pattern) do
        if symbol == 'license' then
            pattern[i] = nil
        end
    end

    ::continue::
end
