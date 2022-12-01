local function find_root_git(path)
    local job = require'plenary.job'
    local root, code = job:new({
        command = 'git',
        args = {'rev-parse', '--show-toplevel'},
        cwd = vim.fs.dirname(path),
        enable_recording = true
    }):sync()
    if code ~= 0 then
        return nil
    end
    return root[1]
end

local function find_root_cargo(path)
    local job = require'plenary.job'
    local metadata, code = job:new({
        command = 'cargo',
        args = {'metadata', '--no-deps', '--format-version', '1'},
        cwd = vim.fs.dirname(path),
        enable_recording = true
    }):sync()
    if code ~= 0 then
        return nil
    end
    metadata = vim.json.decode(metadata[1])
    return metadata.workspace_root
end

local M = {}
function M.find_root(buffer)
    local path = vim.api.nvim_buf_get_name(buffer)
    local root = find_root_cargo(path)
    if root ~= nil then
        return root
    end
    root = find_root_git(path)
    if root ~= nil then
        return root
    end
    return vim.fs.dirname(path)
end

return M
