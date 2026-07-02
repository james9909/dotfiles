local M = {}

-- Preserve cursor position and last search while executing a command
function M.preserve(command)
  local last_search = vim.fn.getreg("/")
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  vim.cmd(command)
  vim.fn.setreg("/", last_search)
  vim.fn.cursor(line, col)
end

-- Follow symlinks so we edit the real file
-- https://www.reddit.com/r/vim/comments/yhsn6/is_it_possible_to_work_around_the_symlink_bug/c5w91qw
function M.follow_symlink()
  local orig_file = vim.fn.fnameescape(vim.fn.expand("<afile>:p"))
  if vim.fn.getftype(orig_file) == "link" then
    local target = vim.fn.fnamemodify(vim.fn.resolve(orig_file), ":p")
    vim.cmd("silent! edit " .. vim.fn.fnameescape(target))
  end
end

-- Initialize the airline statusline sections
function M.airline_init()
  local create = vim.fn["airline#section#create"]
  local create_left = vim.fn["airline#section#create_left"]
  vim.g.airline_section_a = create({ "mode", " ", "paste" })
  vim.g.airline_section_b = create({ "branch", " ", "hunks" })
  vim.g.airline_section_c = create_left({ "file", "readonly" })
end

-- Enter insert mode with the appropriate indent on an empty line
function M.smart_insert_mode_enter()
  if #vim.fn.getline(".") == 0 then
    return "cc"
  else
    return "i"
  end
end

-- NERDTree-like file browsing with netrw
-- http://stackoverflow.com/a/5636941
function M.toggle_vexplorer()
  if vim.t.expl_buf_num ~= nil then
    local expl_win_num = vim.fn.bufwinnr(vim.t.expl_buf_num)
    if expl_win_num ~= -1 then
      local cur_win_nr = vim.fn.winnr()
      vim.cmd(expl_win_num .. "wincmd w")
      vim.cmd("close")
      vim.cmd(cur_win_nr .. "wincmd w")
    end
    vim.t.expl_buf_num = nil
  else
    vim.cmd("1wincmd w")
    vim.cmd("Vexplore")
    vim.t.expl_buf_num = vim.fn.bufnr("%")
    vim.cmd("vertical resize 30")
  end
end

-- coc.nvim: show documentation in a preview window
function M.show_documentation()
  if vim.fn.CocAction("hasProvider", "hover") then
    vim.fn.CocActionAsync("doHover")
  else
    vim.fn.feedkeys("K", "in")
  end
end

-- Echo the highlight group under the cursor (old <F3> mapping)
function M.show_highlight_group()
  local id = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
  local id_lo = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 0)
  vim.api.nvim_echo({ {
    "hi<" .. vim.fn.synIDattr(id, "name") ..
    "> trans<" .. vim.fn.synIDattr(id_lo, "name") ..
    "> lo<" .. vim.fn.synIDattr(vim.fn.synIDtrans(id), "name") .. ">",
  } }, false, {})
end

-- coc.nvim: used by the <Tab> completion expr mapping (must be global for v:lua)
function _G.check_back_space()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

return M
