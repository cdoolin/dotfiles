get_gcc_location = function()
	local gcc_location = vim.fn.system("which arm-none-eabi-gcc")
	gcc_location = string.gsub(gcc_location, "\n", "")
	return gcc_location
end

function ArmClangd()
	vim.cmd("LspStop")

	require("lspconfig").clangd.setup({
		cmd = {
			"/home/callum/.local/share/nvim/mason/bin/clangd",
			-- "--query-driver=/home/callum/stm32cubeide/plugins/com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.11.3.rel1.linux64_1.1.1.202309131626/tools/bin/arm-none-eabi-gcc",
			"--query-driver=" .. get_gcc_location(),
		},
	})

	vim.cmd("LspStart")
end

vim.api.nvim_create_user_command("ArmClangd", ArmClangd, { desc = "Configure clangd for stm32 arm gcc" })
