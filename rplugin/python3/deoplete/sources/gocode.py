from .base import Base

import deoplete.util

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'gocode'
        self.mark = '[go]'
        self.filetypes = ['go']
        self.rank = 100
        # self.min_pattern_length = 1
        # self.is_bytepos = True

    def get_complete_position(self, context):
        return self.vim.call('gocomplete#Complete(0, 0)', context['input'])
        # return self.vim.call('gocomplete#Complete(1, 0)', context['complete_str'])
        # return self.vim.call('gocomplete#Complete(1, 0)', 1, 0)
        # return self.vim.call('go#complete#Complete')

    def gather_candidates(self, context):
        return self.vim.call('gocomplete#Complete(0, 0)', context['input'])
        # return self.vim.call('gocomplete#Complete(1, 0)', context['complete_str'])
        # return self.vim.call('go#complete#Complete')
        # return self.vim.call('gocomplete#Complete', 0, '')
        # return self.vim.call('gocomplete#Complete(0, 0)', context['input'])
        # return self.vim.call('gocomplete#Complete(0, 0)')


