 function _G.checkEden()
	vim.api.nvim_command('silent !cd %:h; git;')
	if(vim.v.shell_error == 0) then
		--change formatter into eden.
	 useEdenFormatter()
	else 
		-- use the default value.
		-- vim.api.nvim_buf_set_keymap(0, 'n','<Leader>f','<Cmd>CocCommand prettier.formatFile<CR>',{noremap=false})
		print('not in eden')
	end
end

local function useEdenFormatter()
	print('use eden formatter')
end

