-- import nvim-autopairs safely
local setup, lastplace = pcall(require, "nvim-lastplace")
if not setup then
    return
end

lastplace.setup()
