import os
import sys

from deoplete.base.filter import Base
from deoplete.util import error, globruntime


class Filter(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'matcher_fruzzy'
        self.description = 'fruzzy matcher'

        self.is_debug_enabled = True
        self.fruzzy = None

    def filter(self, context):
        if (not context['candidates'] or not context['input']
                or self.fruzzy is False):
            return context['candidates']

        if self.fruzzy is None:
            errmsg = self._init_fruzzy(context)
            if errmsg:
                error(self.vim, 'matcher_fruzzy: %s' % errmsg)
                return []

        qry = context['complete_str']
        if context['ignorecase']:
            qry = qry.lower()
        candidates = context['candidates']
        key = None
        ispath = candidates and 'action__path' in candidates[0]
        buf = context['bufnr']
        buf = int(buf) if isinstance(buf, str) else buf
        sort_on_empty_query = self.vim.vars.get("fruzzy#sortonempty", 1)
        results = self.get_fruzzy_result(qry, candidates,
                                               1000,
                                               key=key,
                                               ispath=ispath,
                                               buf=buf,
                                               sortonempty=sort_on_empty_query)
        return [w[0] for w in results]

    def _init_fruzzy(self, context):
        ext = '.pyd' if context['is_windows'] else '.so'
        fname = 'rplugin/python3/fruzzy_mod' + ext
        found = globruntime(self.vim.options['runtimepath'], fname)
        errmsg = None
        if found:
            sys.path.insert(0, os.path.dirname(found[0]))
            try:
                import fruzzy_mod
            except ImportError as exc:
                import traceback
                errmsg = 'Could not import fruzzy: %s\n%s' % (
                    exc, traceback.format_exc())
            else:
                self.fruzzy = fruzzy_mod.scoreMatchesStr
            finally:
                sys.path.pop(0)
        else:
            errmsg = (
                '%s was not found in runtimepath. '
                'You must install/build fruzzy with Python 3 support.' % (
                    fname))
        if errmsg:
            self.fruzzy = False
        return errmsg

    def get_fruzzy_result(self, q, c, limit, key=None, ispath=True, buf=0, sortonempty=True):
        relname = ""
        if sortonempty and ispath and buf > 0 and q == "":
            fname = self.vim.buffers[buf].name
            relname = relpath(self.vim, fname)

        arr = self.fruzzy(q, [d['word'] for d in c], relname, limit, ispath)
        results = []
        for i in arr:
            idx, score = i
            results.append((c[idx], score))
        return results

    # def get_fruzzy_result(self, candidates, pattern):
    #     return self.fruzzy((d['word'] for d in candidates), pattern, limit=1000, ispath=False)[0]
