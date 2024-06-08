require("jhivens.remap")
require("jhivens.set")
require("jhivens.lazy")

vim.filetype.add({
	pattern = {
		[".*%.blade%.php"] = "blade",
	},
})
