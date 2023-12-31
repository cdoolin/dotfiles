function Color(color)
	color = color or "everforest"
	vim.cmd.colorscheme(color)

	--	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

function ColorMode()
	local current_background = vim.go.background

	if current_background == 'dark' then
		vim.go.background = 'light'
	else
		vim.go.background = 'dark'
	end
end

vim.api.nvim_create_user_command("ColorMode", ColorMode, { desc = "Toggle background color mode" })

Color()
