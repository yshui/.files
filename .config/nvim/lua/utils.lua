return {
    -- Check is cursor is behind a whitespace
    is_whitespace = function()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
    end
}
