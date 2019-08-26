import typing

from deoplete.base.filter import Base
from deoplete.util import Nvim, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter_passthrough'
        self.description = 'passthrough sorter'

    def filter(self, context: UserContext) -> Candidates:
        return context['candidates']
