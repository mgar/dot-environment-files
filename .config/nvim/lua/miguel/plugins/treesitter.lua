-- nvim-treesitter `main` branch (the rewrite). Unlike the legacy `master`
-- branch, features are NOT configured via a single `setup({...})` call and the
-- plugin cannot be lazy-loaded. Highlighting/indent are enabled per-buffer via
-- a FileType autocmd, and parsers are installed with `install()`.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- main does not support lazy-loading
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter").setup()

    -- Parsers we want available. install() is async and a no-op for parsers
    -- that are already present, so it's safe to call on every startup.
    local ensure_installed = {
      "bash",
      "c",
      "css",
      "dockerfile",
      "gitignore",
      "go",
      "graphql",
      "groovy",
      "hcl",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "prisma",
      "python",
      "query",
      "svelte",
      "terraform",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    }
    require("nvim-treesitter").install(ensure_installed)

    -- autotag (HTML/JSX) is configured standalone on the main branch
    require("nvim-ts-autotag").setup()

    -- Enable treesitter highlighting + indentation per buffer. On main these
    -- are opt-in: highlighting comes from Neovim core (vim.treesitter.start),
    -- indentation from this plugin (experimental). Folds are handled by ufo.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if not lang or not vim.treesitter.language.add(lang) then
          return
        end
        pcall(vim.treesitter.start, ev.buf, lang)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
