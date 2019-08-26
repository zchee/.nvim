import re
from deoplete.base.filter import Base


class Filter(Base):
    def __init__(self, vim):
        super().__init__(vim)

        self.name = "converter_auto_paren_lsp"
        self.description = "auto add parentheses converter for lsp"

    def filter(self, context):
        p = re.compile(r"\(.*\)")
        for candidate in [
            x for x in context["candidates"] if ("kind" in x and p.search(x["kind"]))
        ]:
            candidate["word"] += "("

        return context["candidates"]
