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
