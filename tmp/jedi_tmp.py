# import deoplete.util
#
# from .base import Base
#
# class Source(Base):
#     def __init__(self, vim):
#         Base.__init__(self, vim)
#
#         self.name = 'jedi'
#         self.mark = '[jedi]'
#         self.filetypes = ['python']
#         self.rank = 10000
#         self.min_pattern_length = 0
#         self.is_bytepos = True
#
#     def get_complete_position(self, context):
#         return self.vim.call('jedi#completions', 1, 0)
#
#     def gather_candidates(self, context, **kwargs):
#         return self.vim.call('jedi#completions', 0, 0)
#
#     def completions(self, findstart, base):
#         row, column = vim.current.window.cursor
#         # Clear call signatures in the buffer so they aren't seen by the completer.
#         # Call signatures in the command line can stay.
#         if vim_eval("g:jedi#show_call_signatures") == '1':
#             clear_call_signatures()
#         if vim.eval('a:findstart') == '1':
#             count = 0
#             for char in reversed(vim.current.line[:column]):
#                 if not re.match('[\w\d]', char):
#                     break
#                 count += 1
#             vim.command('return %i' % (column - count))
#         else:
#             base = vim.eval('a:base')
#             source = ''
#             for i, line in enumerate(vim.current.buffer):
#                 # enter this path again, otherwise source would be incomplete
#                 if i == row - 1:
#                     source += line[:column] + base + line[column:]
#                 else:
#                     source += line
#                 source += '\n'
#             # here again hacks, because jedi has a different interface than vim
#             column += len(base)
#             try:
#                 script = get_script(source=source, column=column)
#                 completions = script.completions()
#                 signatures = script.call_signatures()
#
#                 out = []
#                 for c in completions:
#                     d = dict(word=PythonToVimStr(c.name[:len(base)] + c.complete),
#                              abbr=PythonToVimStr(c.name),
#                              # stuff directly behind the completion
#                              menu=PythonToVimStr(c.description),
#                              info=PythonToVimStr(c.docstring()),  # docstr
#                              icase=1,  # case insensitive
#                              dup=1  # allow duplicates (maybe later remove this)
#                              )
#                     out.append(d)
#
#                 strout = str(out)
#             except Exception:
#                 # print to stdout, will be in :messages
#                 print(traceback.format_exc())
#                 strout = ''
#                 completions = []
#                 signatures = []
#
#             show_call_signatures(signatures)
#             vim.command('return ' + strout)
#
