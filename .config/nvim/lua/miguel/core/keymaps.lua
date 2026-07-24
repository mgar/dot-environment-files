-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- resize splits with <leader> + arrow keys (Left/Right adjust width, Up/Down
-- height). Not Ctrl+arrow — macOS binds those to Mission Control (switch Spaces),
-- so they never reach nvim.
keymap.set("n", "<leader><Left>", "<cmd>vertical resize -4<CR>", { desc = "Shrink split width" })
keymap.set("n", "<leader><Right>", "<cmd>vertical resize +4<CR>", { desc = "Grow split width" })
keymap.set("n", "<leader><Up>", "<cmd>resize +2<CR>", { desc = "Grow split height" })
keymap.set("n", "<leader><Down>", "<cmd>resize -2<CR>", { desc = "Shrink split height" })

-- Seamless navigation OUT of the Claude terminal into nvim windows.
-- vim-tmux-navigator installs GLOBAL terminal mappings (only when $TMUX is set)
-- that use `<C-w>:...<cr>` — that command-line trick doesn't work inside
-- Claude's full-screen TUI, so the command name leaks as literal text. It also
-- loads after core/keymaps, so any global mapping we set here gets overwritten.
-- Fix: set BUFFER-LOCAL terminal mappings on the Claude terminal via autocmd.
-- Buffer-local mappings always take precedence over the plugin's global ones,
-- regardless of load order, and a Lua callback can't leak keys to the terminal.
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("miguel_claude_nav", { clear = true }),
	callback = function(args)
		local name = vim.api.nvim_buf_get_name(args.buf)
		if not (name:match("claude") or vim.bo[args.buf].filetype == "snacks_terminal") then
			return
		end
		local o = { buffer = args.buf, silent = true }
		vim.keymap.set("t", "<C-h>", function() vim.cmd("TmuxNavigateLeft") end, o)
		vim.keymap.set("t", "<C-j>", function() vim.cmd("TmuxNavigateDown") end, o)
		vim.keymap.set("t", "<C-k>", function() vim.cmd("TmuxNavigateUp") end, o)
		vim.keymap.set("t", "<C-l>", function() vim.cmd("TmuxNavigateRight") end, o)
	end,
})

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- run the current file based on its filetype, in a terminal split
local run_cmds = {
	python = "python3",
	javascript = "node",
	typescript = "npx tsx", -- requires `tsx` (npx will offer to install it)
	sh = "bash",
	bash = "bash",
	lua = "lua",
}

keymap.set("n", "<leader>R", function()
	local runner = run_cmds[vim.bo.filetype]
	if not runner then
		vim.notify("No runner configured for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
		return
	end
	vim.cmd("write")
	local file = vim.fn.shellescape(vim.fn.expand("%:p"))
	vim.cmd("botright 15split | terminal " .. runner .. " " .. file)
	vim.cmd("startinsert")
end, { desc = "Run current file" })

-- inspect completion/LSP state for the current buffer (debugging helper)
keymap.set("n", "<leader>ci", function()
	local clients = vim.tbl_map(function(c)
		return c.name
	end, vim.lsp.get_clients({ bufnr = 0 }))
	local lsp = #clients > 0 and table.concat(clients, ", ") or "none"
	local blink_ok = pcall(require, "blink.cmp")
	vim.notify(
		("LSP: %s\nblink.cmp loaded: %s\nfiletype: %s"):format(lsp, tostring(blink_ok), vim.bo.filetype),
		vim.log.levels.INFO,
		{ title = "Completion status" }
	)
end, { desc = "Completion/LSP status" })
