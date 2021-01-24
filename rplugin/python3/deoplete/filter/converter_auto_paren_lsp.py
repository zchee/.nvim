import re

from deoplete.base.filter import Base
from deoplete.util import Nvim, UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = "converter_auto_paren_lsp"
        self.description = "auto add parentheses converter for lsp"

    def filter(self, context: UserContext) -> Candidates:
        # p = re.compile("\(.*\)")
        # for candidate in [
        #     x for x in context["candidates"] if ("menu" in x and p.search(x["menu"]))
        # ]:
        #     candidate["word"] += "("

        for candidate in [
            x
            for x in context["candidates"]
            if ("kind" in x and x["kind"] == "Function")
        ]:
            candidate["word"] += "("

        for candidate in [
            x for x in context["candidates"] if ("menu" in x and "func" in x["menu"])
        ]:
            candidate["word"] += "("

        return context["candidates"]


"""
{
  "changedtick": 524,
  "event": "TextChangedI",
  "filetype": "go",
  "filetypes": [
    "go"
  ],
  "input": "\t\tcase *spansql.",
  "max_abbr_width": 80,
  "max_kind_width": 40,
  "max_menu_width": 50,
  "next_input": "",
  "position": [
    0,  # bufnum
    28, # lnum
    17, # col
    0   # off
  ],
  "same_filetypes": [],
  "time": [
    13740,
    -1469993891
  ],
  "bufnr": 1,
  "bufname": "main.go",
  "bufpath": "/Users/zchee/go/src/github.com/kouzoh/merpay-creditdesign-kit/test/main.go",
  "camelcase": true,
  "complete_str": "",
  "cwd": "/Users/zchee/go/src/github.com/kouzoh/merpay-creditdesign-kit/test",
  "encoding": "utf-8",
  "ignorecase": 0,
  "is_windows": 0,
  "smartcase": 1,
  "keyword_pattern": "[a-zA-Z_][\\w@0-9_À-ÿ]*",
  "sources": [],
  "rpc": "deoplete_auto_completion_begin",
  "char_position": 16,
  "complete_position": 16,
  "is_async": true,
  "is_refresh": false,
  "max_info_width": 200,
  "vars": "<pynvim.api.common.RemoteMap object at 0x10c912700>",
  "candidates": []
}

# placeholders
{
    'word': 'rParam',
    'menu': '[LCI] interface{...}',
    'user_data': '{
        "lspitem":{
            "label":"spansql.LiteralOrParam",
            "kind":8,"detail":"interface{...}",
            "preselect":true,
            "sortText":"00000",
            "filterText":"spansql.LiteralOrParam",
            "insertTextFormat":1,
            "textEdit":{
                "range":{
                    "start":{
                        "line":26,
                        "character":8,
                    },
                    "end":{
                        "line":26,
                        "character":15,
                    },
                },
            "newText":"spansql.LiteralOrParam",
            },
        },
    }',
    'info': '',
    'kind': 'Interface',
    'abbr': 'spansql.LiteralOrParam',
}

# Not placeholders
{
    'word': 'AlterTable',
    'menu': '[LCI] struct{...}',
    'user_data': '{
        "lspitem":{
            "label":"AlterTable",
            "kind":22,
            "detail":"struct{...}",
            "preselect":true,
            "sortText":"00000",
            "filterText":"AlterTable",
            "insertTextFormat":1,
            "textEdit":{
                "range":{
                    "start":{
                        "line":27,
                        "character":16,
                    },
                    "end":{
                        "line":27,
                        "character":16,
                    },
                },
            "newText":"AlterTable",
            },
        },
    }',
    'info': '',
    'kind': 'Struct',
    'abbr': 'AlterTable',
}
"""


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
