import re
import typing

from deoplete.source.base import Base
from deoplete.util import debug, error_vim, Nvim, UserContext, Candidates


class Source(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = "LanguageClientInternal"
        self.description = "Language Sever Protocol Client source"
        self.mark = "[LCI]"
        self.min_pattern_length = 1
        self.input_pattern = r"(\.|::|->)\w*$"
        self.matchers = ["matcher_fuzzy"]
        self.sorters = []
        self.filetypes = self.vim.eval(
            "get(g:, 'LanguageClient_serverCommands', {})"
        ).keys()
        self.is_debug_enabled = False
        self.is_bytepos = True
        self.is_volatile = True
        self.is_async = True
        self.rank = 1000
        self.events = (
            []
        )  # , "BufReadPost", "InsertEnter", "BufWritePost", "InsertLeave"

    def reset_var(self) -> None:
        self.vim.vars["LanguageClient_omniCompleteResults"] = []

    def on_event(self, context: UserContext) -> None:
        self.debug("context[event]: {}".format(context["event"]))

        # disable for now
        if context["event"] == "BufReadPost":
            ft = self.get_buf_option("filetype")
            if ft == "go":
                self.input_pattern = r"(\.|::|->)\w*(?:[^\W\d]\w*)?"

    def get_complete_position(self, context: UserContext) -> int:
        return self.vim.call("LanguageClient#get_complete_start", context["input"])

    def request_omni_completion(self, context: UserContext) -> None:
        character = context["complete_position"] + len(context["complete_str"])
        self.vim.funcs.LanguageClient_omniComplete(
            {"character": character, "complete_position": context["complete_position"]}
        )

    def async_completion(self, context: UserContext) -> Candidates:
        candidates = self.vim.eval("g:LanguageClient_omniCompleteResults")
        if candidates:
            return candidates[0].get("result", [])

        self.request_omni_completion(context)

        return []

    def gather_candidates(self, context: UserContext) -> Candidates:
        if context["is_async"]:
            result = self.vim.eval("g:LanguageClient_omniCompleteResults")
            if result:
                context["is_async"] = False
                candidates = result[0].get("result", [])

                for candidate in candidates:
                    if "func" in candidate["menu"]:
                        candidate["abbr"] += "()"

                return candidates

        context["is_async"] = True
        self.reset_var()

        character = context["complete_position"] + len(context["complete_str"])
        self.vim.funcs.LanguageClient_omniComplete(
            {
                "character": character,
                "complete_position": context["complete_position"],
            }
        )

        return []

    # def gather_candidates(self, context: UserContext) -> Candidates:
    #     self.reset_var()
    #
    #     while True:
    #         try:
    #             candidates = self.async_completion(context)
    #             if candidates:
    #                 return candidates
    #
    #                 for candidate in candidates:
    #                     if candidate["kind"] != "Module":
    #                         candidate["kind"] = candidate["menu"]
    #                     if candidate.get("info"):
    #                         candidate["menu"] = "{}".format(candidate["info"])
    #
    #                 # for echodoc.vim
    #                 if candidate.get('user_data'):
    #                     if candidate['kind'] == 'Function' or candidate['kind'] == 'Method':
    #                         user_data = json.loads(candidate['user_data'])
    #                         user_data['signature'] = candidate['info']
    #                         candidate['user_data'] = user_data
    #                 return candidates
    #         except:
    #             return False
    #
    #     return []


"""gather_candidates
:help complete-items

Each list item can either be a string or a Dictionary.  When it is a string it
is used as the completion.  When it is a Dictionary it can contain these
items:
        word		the text that will be inserted, mandatory
        abbr		abbreviation of "word"; when not empty it is used in
                        the menu instead of "word"
        menu		extra text for the popup menu, displayed after "word"
                        or "abbr"
        info		more information about the item, can be displayed in a
                        preview window
        kind		single letter indicating the type of completion
        icase		when non-zero case is to be ignored when comparing
                        items to be equal; when omitted zero is used, thus
                        items that only differ in case are added
        equal		when non-zero, always treat this item to be equal when
                        comparing. Which means, "equal=1" disables filtering
                        of this item.
        dup		when non-zero this match will be added even when an
                        item with the same word is already present.
        empty		when non-zero this match will be added even when it is
                        an empty string
        user_data 	custom data which is associated with the item and
                        available in |v:completed_item|

All of these except "icase", "equal", "dup" and "empty" must be a string.  If
an item does not meet these requirements then an error message is given and
further items in the list are not used.  You can mix string and Dictionary
items in the returned list.

The "menu" item is used in the popup menu and may be truncated, thus it should
be relatively short.  The "info" item can be longer, it will  be displayed in
the preview window when "preview" appears in 'completeopt'.  The "info" item
will also remain displayed after the popup menu has been removed.  This is
useful for function arguments.  Use a single space for "info" to remove
existing text in the preview window.  The size of the preview window is three
lines, but 'previewheight' is used when it has a value of 1 or 2.

The "kind" item uses a single letter to indicate the kind of completion.  This
may be used to show the completion differently (different color or icon).
Currently these types can be used:
        v	variable
        f	function or method
        m	member of a struct or class
        t	typedef
        d	#define or macro

When searching for matches takes some time call |complete_add()| to add each
match to the total list.  These matches should then not appear in the returned
list!  Call |complete_check()| now and then to allow the user to press a key
while still searching for matches.  Stop searching when it returns non-zero.

[
  {
    "word": "Fatalf",
    "menu": "[LC] func(format string, args ...interface{})",
    "user_data": {
      "lspitem": {
        "label": "Fatalf",
        "kind": 2,
        "detail": "func(format string, args ...interface{})",
        "documentation": "Fatalf is equivalent to Logf followed by FailNow.",
        "sortText": "00001",
        "filterText": "Fata",
        "insertTextFormat": 1,
        "textEdit": {
          "range": {
            "start": {
              "line": 355,
              "character": 7
            },
            "end": {
              "line": 355,
              "character": 11
            }
          },
          "newText": "Fatalf"
        },
        "command": {
          "title": "",
          "command": "editor.action.triggerParameterHints"
        }
      }
    },
    "info": "Fatalf is equivalent to Logf followed by FailNow.",
    "kind": "Method",
    "abbr": "Fatalf"
  }
]

'info': 'Channel information about a channel.',
'menu': 'struct{...}',
'user_data': '{
  "lspitem":{  ## needs json.loads, it's not dict
    "label":"Channel",
    "kind":22,
    "detail":"struct{...}",
    "documentation":"Channel information about a channel.",
    "sortText":"00003",
    "filterText":"c",
    "insertTextFormat":1,
    "textEdit":{"range":{"start":{"line":201,"character":2},"end":{"line":201,"character":3}},"newText":"Channel"}
  }
}',
'kind': 'Struct',
'word': 'Channel',
'is_snippet': False,
'abbr': 'Channel',
'dup': 1,
'icase': 1,
"""
