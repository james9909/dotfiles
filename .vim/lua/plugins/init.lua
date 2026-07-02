return {
  -- Completion / LSP -----------------------------------------------------
  { "neoclide/coc.nvim", branch = "release" },

  -- Colorscheme (load first so early highlight tweaks can read its palette)
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_background = "medium"
    end,
    config = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("gruvbox-material") -- Gruvbox runs 'syntax reset' anyway
    end,
  },

  -- Statusline
  {
    "bling/vim-airline",
    init = function()
      vim.g.airline_powerline_fonts = 1
      vim.g["airline#extensions#hunks#enabled"] = 1
      vim.g["airline#extensions#hunks#hunk_symbols"] = { "+", "Δ", "-" }
      vim.g["airline#extensions#hunks#non_zero_only"] = 1
      vim.g["airline#extensions#virtualenv#enabled"] = 1
    end,
  },

  -- Undo tree
  {
    "simnalamburt/vim-mundo",
    cmd = "MundoToggle",
    init = function()
      vim.g.mundo_width = 30
      vim.g.mundo_preview_height = 15
      vim.g.mundo_preview_bottom = 1
    end,
  },

  -- Fuzzy finding
  {
    "junegunn/fzf.vim",
    dependencies = {
      { "junegunn/fzf", build = "./install --all" },
    },
    init = function()
      if vim.fn.executable("rg") == 1 then
        vim.env.FZF_DEFAULT_COMMAND = "rg --files --no-ignore-vcs --hidden "
          .. "--ignore-file ~/.gitignore_global -g '!{node_modules,.git,.cache}' --follow"
      end
      vim.g.fzf_preview_window = { "right:50%", "ctrl-/" }
      vim.g.fzf_buffers_jump = 1
    end,
  },

  -- Git signs in the gutter
  {
    "mhinz/vim-signify",
    init = function()
      vim.g.signify_vcs_list = { "git" }
      vim.g.signify_realtime = 0
      vim.g.signify_cursorhold_insert = 0
      vim.g.signify_sign_add = "+"
      vim.g.signify_sign_change = "Δ"
      vim.g.signify_sign_delete = "-"
      vim.g.signify_sign_delete_first_line = "^"
      vim.g.signify_sign_changedelete = "Δ-"
    end,
  },

  -- Auto-close / pairs
  {
    "jiangmiao/auto-pairs",
    init = function()
      vim.g.AutoPairsMultilineClose = 0
      -- delimitMate is no longer installed, but keep its settings for parity.
      vim.g.delimitMate_expand_inside_quotes = 1
      vim.g.delimitMate_expand_cr = 1
      vim.g.delimitMate_nesting_quotes = { '"', "`", '"' }
    end,
  },

  {
    "Valloric/MatchTagAlways",
    ft = "html",
    init = function()
      vim.g.mta_use_match_paren_group = 1
    end,
  },

  {
    "Yggdroot/indentLine",
    init = function()
      vim.g.indentLine_char = "¦"
      vim.g.indentLine_color_term = 239
    end,
  },

  "alvan/vim-closetag",
  "gioele/vim-autoswap",
  "Konfekt/FastFold",
  "machakann/vim-sandwich",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-sleuth",

  {
    "luochen1990/rainbow",
    init = function()
      vim.g.rainbow_active = 1
      vim.g.rainbow_conf = {
        ctermfgs = { "white", "lightgreen", "lightblue", "lightmagenta" },
        parentheses = {
          "start=/(/ end=/)/",
          "start=/\\[/ end=/\\]/",
          "start=/{/ end=/}/",
        },
      }
    end,
  },

  -- Copilot
  {
    "github/copilot.vim",
    init = function()
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_no_tab_map = 1
    end,
  },

  -- Linting
  {
    "w0rp/ale",
    init = function()
      vim.g.ale_lint_on_text_changed = "insert" -- Run ale only in insert mode
      vim.g.ale_lint_on_insert_leave = 1 -- Run ale when exiting insert mode
      vim.g.ale_type_map = { flake8 = { ES = "WS", E = "W" } } -- Style errors -> warnings
      vim.g.ale_python_flake8_args = "--ignore=E302,E305,E501"
      vim.g.ale_lint_delay = 500 -- Lint after 500 milliseconds
      vim.g.ale_linters = { go = { "revive" }, rust = {}, python = {} }
    end,
  },

  -- Treesitter (pinned to the frozen 'master' branch until we support 'main')
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup({
          ensure_installed = {
            "rust", "javascript", "go", "bash", "toml", "yaml", "html", "typescript",
          },
          highlight = { enable = true },
        })
      end
    end,
  },

  -- Markdown
  {
    "plasticboy/vim-markdown",
    init = function()
      vim.g.vim_markdown_conceal = 0
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },

  -- Language-specific --------------------------------------------------
  {
    "fatih/vim-go",
    ft = "go",
    init = function()
      vim.g.go_fmt_fail_silently = 1
      vim.g.go_code_completion_enabled = 0
      vim.g.go_fmt_autosave = 0
      vim.g.go_imports_autosave = 0
      vim.g.go_fmt_command = "goimports"
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_gopls_enabled = "false"
      vim.g.go_doc_keywordprg_enabled = 0
    end,
  },

  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1 -- Run :RustFmt when saving a buffer
    end,
  },

  {
    "HerringtonDarkholme/yats.vim",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  },

  {
    "MaxMEllon/vim-jsx-pretty",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    init = function()
      vim.g.jsx_ext_required = 0 -- Allow JSX syntax highlighting in .js files
    end,
  },

  { "hynek/vim-python-pep8-indent", ft = "python" },
  { "stephpy/vim-yaml", ft = "yaml" },
  { "alx741/vim-hindent", ft = "haskell" },
  { "neovimhaskell/haskell-vim", ft = "haskell" },
}
