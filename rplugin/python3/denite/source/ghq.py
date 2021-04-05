import subprocess
import os

from denite.base.source import Base
from denite.util import Nvim, UserContext, Candidates


class Source(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = "ghqq"
        self.kind = "directory"

        self.env = os.environ.copy()

    def gather_candidates(self, context: UserContext) -> Candidates:
        cmd = ["ghq", "list", "--full-path"]
        self.env["GIT_CONFIG"] = os.path.expanduser("~/.config/ghq/.gitconfig")

        return [{"word": path, "action__path": path} for path in subprocess.run(cmd,
                                  check=True,
                                  universal_newlines=True,
                                  stdout=subprocess.PIPE,
                                  env=self.env).stdout.split()]
