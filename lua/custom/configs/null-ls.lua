local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local b = null_ls.builtins

local sources = {

  b.diagnostics.eslint,
  b.formatting.prettier,
  b.formatting.goimports_reviser,
  b.formatting.gofumpt,
  b.formatting.golines,
  b.formatting.stylua,
}
null_ls.setup {
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
  debug = true,
  sources = sources,
}
