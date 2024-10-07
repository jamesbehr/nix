local config = require('lspconfig')
local keymap = require('keymap')
local niks = require('niks')

keymap.nnoremap('[d', vim.diagnostic.goto_prev, {silent=true})
keymap.nnoremap(']d', vim.diagnostic.goto_next, {silent=true})
keymap.nnoremap('<leader>d', vim.diagnostic.open_float, {silent=true})

local organize_imports = function (client, timeout_ms)
    if not client.server_capabilities.codeActionProvider then
        return
    end

    local params = vim.lsp.util.make_range_params(nil, "utf-16")
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

local on_attach = function (client, bufnr)
    local nmap = keymap.bind("n", {noremap=true, silent=true, buffer=bufnr})

    nmap("gD", vim.lsp.buf.declaration)
    nmap("gd", vim.lsp.buf.definition)
    nmap("K", vim.lsp.buf.hover)
    nmap("gi", vim.lsp.buf.implementation)
    nmap("<C-k>", vim.lsp.buf.signature_help)
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder)
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder)
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)
    nmap("<leader>D", vim.lsp.buf.type_definition)
    nmap("<leader>rn", vim.lsp.buf.rename)
    nmap("<leader>ca", vim.lsp.buf.code_action)
    nmap("gr", vim.lsp.buf.references)

    vim.api.nvim_create_autocmd({"BufWritePre"}, {
        buffer = bufnr,
        callback = function ()
            organize_imports(client, 1001)
            vim.lsp.buf.format({async=false})
        end,
    })
end

if niks["dev"]["ruby"]["enable"] then
    config["solargraph"].setup({
        on_attach = on_attach,
    })
end

if niks["dev"]["go"]["enable"] then
    config["gopls"].setup({
        on_attach = on_attach,
    })
end

if niks["dev"]["terraform"]["enable"] then
    config["terraformls"].setup({
        on_attach = on_attach,
    })
end

if niks["dev"]["nix"]["enable"] then
    config["nil_ls"].setup({
        on_attach = on_attach,
    })
end

if niks["dev"]["haskell"]["enable"] then
    config["hls"].setup({
        on_attach = on_attach,
    })
end

if niks["dev"]["node"]["enable"] then
    config["ts_ls"].setup({
        on_attach = on_attach,
    })
end

if niks["dev"]["rust"]["enable"] then
    config["rust_analyzer"].setup({
        on_attach = on_attach,
    })
end

if niks["dev"]["scala"]["enable"] then
    local metals_config = require("metals").bare_config()

    metals_config.settings = {
        useGlobalExecutable = true
    }

    metals_config.on_attach = on_attach

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
end
