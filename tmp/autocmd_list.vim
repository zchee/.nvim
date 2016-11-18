augroup AutoCmd
  autocmd!

  " Read
  autocmd BufNewFile * echomsg 'autocmd: BufNewFile'
  autocmd BufReadPre * echomsg 'autocmd: BufReadPre'
  autocmd BufRead * echomsg 'autocmd: BufRead'
  autocmd BufReadPost * echomsg 'autocmd: BufReadPost'
  autocmd BufReadCmd * echomsg 'autocmd: BufReadCmd'
  autocmd FileReadPre * echomsg 'autocmd: FileReadPre'
  autocmd FileReadPost * echomsg 'autocmd: FileReadPost'
  autocmd FileReadCmd * echomsg 'autocmd: FileReadCmd'
  autocmd FilterReadPre * echomsg 'autocmd: FilterReadPre'
  autocmd FilterReadPost * echomsg 'FilterReadPost'
  autocmd StdinReadPre * echomsg 'autocmd: StdinReadPre'
  autocmd StdinReadPost * echomsg 'autocmd: StdinReadPost'

  " Write
  autocmd BufWrite * echomsg 'autocmd: BufWrite'
  autocmd BufWritePre * echomsg 'autocmd: BufWritePre'
  autocmd BufWritePost * echomsg 'autocmd: BufWritePost'
  autocmd BufWriteCmd * echomsg 'autocmd: BufWriteCmd'
  autocmd FileWritePre * echomsg 'autocmd: FileWritePre'
  autocmd FileWritePost * echomsg 'autocmd: FileWritePost'
  autocmd FileWriteCmd * echomsg 'autocmd: FileWriteCmd'
  autocmd FileAppendPre * echomsg 'autocmd: FileAppendPre'
  autocmd FileAppendPost * echomsg 'autocmd: FileAppendPost'
  autocmd FileAppendCmd * echomsg 'autocmd: FileAppendCmd'
  autocmd FilterWritePre * echomsg 'autocmd: FilterWritePre'
  autocmd FilterWritePost * echomsg 'autocmd: FilterWritePost'

  " Buffe
  autocmd BufAdd * echomsg 'autocmd: BufAdd'
  autocmd BufCreate * echomsg 'autocmd: BufCreate'
  autocmd BufDelete * echomsg 'autocmd: BufDelete'
  autocmd BufWipeout * echomsg 'autocmd: BufWipeout'
  autocmd BufFilePre * echomsg 'autocmd: BufFilePre'
  autocmd BufFilePost * echomsg 'autocmd: BufFilePost'
  autocmd BufEnter * echomsg 'autocmd: BufEnter'
  autocmd BufLeave * echomsg 'autocmd: BufLeave'
  autocmd BufWinEnter * echomsg 'autocmd: BufWinEnter'
  autocmd BufWinLeave * echomsg 'autocmd: BufWinLeave'
  autocmd BufUnload * echomsg 'autocmd: BufUnload'
  autocmd BufHidden * echomsg 'autocmd: BufHidden'
  autocmd BufNew * echomsg 'autocmd: BufNew'
  autocmd SwapExists * echomsg 'autocmd: SwapExists'

  " Optio
  autocmd FileType * echomsg 'autocmd: FileType'
  autocmd Syntax * echomsg 'autocmd: Syntax'
  autocmd EncodingChanged * echomsg 'autocmd: EncodingChanged'
  autocmd TermChanged * echomsg 'autocmd: TermChanged'
  autocmd OptionSet * echomsg 'autocmd: OptionSet'

  " Start End
  autocmd VimEnter * echomsg 'autocmd: VimEnter'
  autocmd GUIEnter * echomsg 'autocmd: GUIEnter'
  autocmd GUIFailed * echomsg 'autocmd: GUIFailed'
  autocmd TermResponse * echomsg 'autocmd: TermResponse'
  autocmd QuitPre * echomsg 'autocmd: QuitPre'
  autocmd VimLeavePre * echomsg 'autocmd: VimLeavePre'
  autocmd VimLeave * echomsg 'autocmd: VimLeave'

  " Other
  autocmd FileChangedShell * echomsg 'autocmd: FileChangedShell'
  autocmd FileChangedShellPost * echomsg 'autocmd: FileChangedShellPost'
  autocmd FileChangedRO * echomsg 'autocmd: FileChangedRO'
  autocmd ShellCmdPost * echomsg 'autocmd: ShellCmdPost'
  autocmd ShellFilterPost * echomsg 'autocmd: ShellFilterPost'
  autocmd CmdUndefined * echomsg 'autocmd: CmdUndefined'
  " autocmd FuncUndefined * echomsg 'autocmd: FuncUndefined'
  autocmd SpellFileMissing * echomsg 'autocmd: SpellFileMissing'
  " autocmd SourcePre * echomsg 'autocmd: SourcePre'
  " autocmd SourceCmd * echomsg 'autocmd: SourceCmd'
  autocmd VimResized * echomsg 'autocmd: VimResized'
  autocmd FocusGained * echomsg 'autocmd: FocusGained'
  autocmd FocusLost * echomsg 'autocmd: FocusLost'
  autocmd CursorHold * echomsg 'autocmd: CursorHold'
  autocmd CursorHoldI * echomsg 'autocmd: CursorHoldI'
  autocmd CursorMoved * echomsg 'autocmd: CursorMoved'
  autocmd CursorMovedI * echomsg 'autocmd: CursorMovedI'

  autocmd WinEnter * echomsg 'autocmd: WinEnter'
  autocmd WinLeave * echomsg 'autocmd: WinLeave'
  autocmd TabEnter * echomsg 'autocmd: TabEnter'
  autocmd TabLeave * echomsg 'autocmd: TabLeave'
  autocmd CmdwinEnter * echomsg 'autocmd: CmdwinEnter'
  autocmd CmdwinLeave * echomsg 'autocmd: CmdwinLeave'

  autocmd InsertEnter * echomsg 'autocmd: InsertEnter'
  autocmd InsertChange * echomsg 'autocmd: InsertChange'
  autocmd InsertLeave * echomsg 'autocmd: InsertLeave'
  autocmd InsertCharPre * echomsg 'autocmd: InsertCharPre'

  autocmd TextChanged * echomsg 'autocmd: TextChanged'
  autocmd TextChangedI * echomsg 'autocmd: TextChangedI'

  autocmd ColorScheme * echomsg 'autocmd: ColorScheme'

  autocmd RemoteReply * echomsg 'autocmd: RemoteReply'

  autocmd QuickFixCmdPre * echomsg 'autocmd: QuickFixCmdPre'
  autocmd QuickFixCmdPost * echomsg 'autocmd: QuickFixCmdPost'

  autocmd SessionLoadPost * echomsg 'autocmd: SessionLoadPost'

  autocmd MenuPopup * echomsg 'autocmd: MenuPopup'
  autocmd CompleteDone * echomsg 'autocmd: CompleteDone'

augroup END
