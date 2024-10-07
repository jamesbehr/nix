local file = io.open(vim.fn.expand("~/.config/nvim/niks.json"), "r")
if not file then
    return nil
end

local content = file:read("*all")
file:close()

return vim.json.decode(content)
