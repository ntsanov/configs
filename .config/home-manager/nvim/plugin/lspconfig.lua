local lsp, api, keymap = vim.lsp, vim.api, vim.keymap
local lspconfig = require("lspconfig")
local util = require "lspconfig/util"


--Enable (broadcasting) snippet capability for completion
local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.jsonls.setup { capabilities = capabilities }
lspconfig.eslint.setup({
  on_attach = function(client, bufnr)
    api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})
-- lspconfig.tsserver.setup { capabilities = capabilities }
lspconfig.cssls.setup { capabilities = capabilities }
lspconfig.html.setup { capabilities = capabilities }
lspconfig.bashls.setup{}
lspconfig.dockerls.setup{}
lspconfig.marksman.setup{}
lspconfig.ansiblels.setup{}
lspconfig.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if not vim.loop.fs_stat(path..'/.luarc.json') and not vim.loop.fs_stat(path..'/.luarc.jsonc') then
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT'
          },
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            }
            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
            -- library = vim.api.nvim_get_runtime_file("", true)
          }
        }
      })

      client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
    end
    return true
  end
}
lspconfig.sqlls.setup{}
lspconfig.yamlls.setup{}
lspconfig.openscad_lsp.setup{}
lspconfig.pyright.setup{}
lspconfig.vuels.setup{}
lspconfig.gopls.setup {
  cmd = {"gopls"},
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keymap.set('n', '<space>e', vim.diagnostic.open_float)
keymap.set('n', '[d', vim.diagnostic.goto_prev)
keymap.set('n', ']d', vim.diagnostic.goto_next)
keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    keymap.set('n', 'gD', lsp.buf.declaration, opts)
    keymap.set('n', 'gd', lsp.buf.definition, opts)
    keymap.set('n', 'K', lsp.buf.hover, opts)
    keymap.set('n', 'gi', lsp.buf.implementation, opts)
    keymap.set('n', '<C-k>', lsp.buf.signature_help, opts)
    keymap.set('n', '<space>wa', lsp.buf.add_workspace_folder, opts)
    keymap.set('n', '<space>wr', lsp.buf.remove_workspace_folder, opts)
    keymap.set('n', '<space>wl', function()
      print(vim.inspect(lsp.buf.list_workspace_folders()))
    end, opts)
    keymap.set('n', '<space>D', lsp.buf.type_definition, opts)
    keymap.set('n', '<space>rn', lsp.buf.rename, opts)
    keymap.set({ 'n', 'v' }, '<space>ca', lsp.buf.code_action, opts)
    keymap.set('n', 'gr', lsp.buf.references, opts)
    keymap.set('n', '<space>f', function()
      lsp.buf.format { async = true }
    end, opts)
  end,
})
