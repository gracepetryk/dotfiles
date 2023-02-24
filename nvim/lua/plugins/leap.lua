local leap = require('leap')

leap.add_default_mappings()
leap.opts.safe_labels = {} -- workaround until https://github.com/ggandor/flit.nvim/issues/3 is fixed
