local M = {}

--- @class vim.lsp.protocol.constants
--- @nodoc
M.constants = {
  DiagnosticSeverity = {
    -- Reports an error.
    Error = 1,
    -- Reports a warning.
    Warning = 2,
    -- Reports an information.
    Information = 3,
    -- Reports a hint.
    Hint = 4,
  },

  DiagnosticTag = {
    -- Unused or unnecessary code
    Unnecessary = 1,
    -- Deprecated or obsolete code
    Deprecated = 2,
  },

  MessageType = {
    -- An error message.
    Error = 1,
    -- A warning message.
    Warning = 2,
    -- An information message.
    Info = 3,
    -- A log message.
    Log = 4,
    -- A debug message.
    Debug = 5,
  },

  -- The file event type.
  FileChangeType = {
    -- The file got created.
    Created = 1,
    -- The file got changed.
    Changed = 2,
    -- The file got deleted.
    Deleted = 3,
  },

  -- The kind of a completion entry.
  CompletionItemKind = {
    Text = 1,
    Method = 2,
    Function = 3,
    Constructor = 4,
    Field = 5,
    Variable = 6,
    Class = 7,
    Interface = 8,
    Module = 9,
    Property = 10,
    Unit = 11,
    Value = 12,
    Enum = 13,
    Keyword = 14,
    Snippet = 15,
    Color = 16,
    File = 17,
    Reference = 18,
    Folder = 19,
    EnumMember = 20,
    Constant = 21,
    Struct = 22,
    Event = 23,
    Operator = 24,
    TypeParameter = 25,
  },

  -- How a completion was triggered
  CompletionTriggerKind = {
    -- Completion was triggered by typing an identifier (24x7 code
    -- complete), manual invocation (e.g Ctrl+Space) or via API.
    Invoked = 1,
    -- Completion was triggered by a trigger character specified by
    -- the `triggerCharacters` properties of the `CompletionRegistrationOptions`.
    TriggerCharacter = 2,
    -- Completion was re-triggered as the current completion list is incomplete.
    TriggerForIncompleteCompletions = 3,
  },

  -- Completion item tags are extra annotations that tweak the rendering of a
  -- completion item
  CompletionTag = {
    -- Render a completion as obsolete, usually using a strike-out.
    Deprecated = 1,
  },

  -- A document highlight kind.
  DocumentHighlightKind = {
    -- A textual occurrence.
    Text = 1,
    -- Read-access of a symbol, like reading a variable.
    Read = 2,
    -- Write-access of a symbol, like writing to a variable.
    Write = 3,
  },

  -- A symbol kind.
  SymbolKind = {
    File = 1,
    Module = 2,
    Namespace = 3,
    Package = 4,
    Class = 5,
    Method = 6,
    Property = 7,
    Field = 8,
    Constructor = 9,
    Enum = 10,
    Interface = 11,
    Function = 12,
    Variable = 13,
    Constant = 14,
    String = 15,
    Number = 16,
    Boolean = 17,
    Array = 18,
    Object = 19,
    Key = 20,
    Null = 21,
    EnumMember = 22,
    Struct = 23,
    Event = 24,
    Operator = 25,
    TypeParameter = 26,
  },

  -- Extra annotations that tweak the rendering of a symbol.
  SymbolTag = {
    Deprecated = 1,
  },

  -- Represents reasons why a text document is saved.
  TextDocumentSaveReason = {
    -- Manually triggered, e.g. by the user pressing save, by starting debugging,
    -- or by an API call.
    Manual = 1,
    -- Automatic after a delay.
    AfterDelay = 2,
    -- When the editor lost focus.
    FocusOut = 3,
  },

  ErrorCodes = {
    -- Defined by JSON RPC
    ParseError = -32700,
    InvalidRequest = -32600,
    MethodNotFound = -32601,
    InvalidParams = -32602,
    InternalError = -32603,
    ServerNotInitialized = -32002,
    UnknownErrorCode = -32001,
    -- Defined by the protocol.
    RequestCancelled = -32800,
    ContentModified = -32801,
    ServerCancelled = -32802,
    RequestFailed = -32803,
  },

  -- Describes the content type that a client supports in various
  -- result literals like `Hover`, `ParameterInfo` or `CompletionItem`.
  --
  -- Please note that `MarkupKinds` must not start with a `$`. This kinds
  -- are reserved for internal usage.
  MarkupKind = {
    -- Plain text is supported as a content format
    PlainText = 'plaintext',
    -- Markdown is supported as a content format
    Markdown = 'markdown',
  },

  ResourceOperationKind = {
    -- Supports creating new files and folders.
    Create = 'create',
    -- Supports renaming existing files and folders.
    Rename = 'rename',
    -- Supports deleting existing files and folders.
    Delete = 'delete',
  },

  FailureHandlingKind = {
    -- Applying the workspace change is simply aborted if one of the changes provided
    -- fails. All operations executed before the failing operation stay executed.
    Abort = 'abort',
    -- All operations are executed transactionally. That means they either all
    -- succeed or no changes at all are applied to the workspace.
    Transactional = 'transactional',
    -- If the workspace edit contains only textual file changes they are executed transactionally.
    -- If resource changes (create, rename or delete file) are part of the change the failure
    -- handling strategy is abort.
    TextOnlyTransactional = 'textOnlyTransactional',
    -- The client tries to undo the operations already executed. But there is no
    -- guarantee that this succeeds.
    Undo = 'undo',
  },

  -- Known error codes for an `InitializeError`;
  InitializeError = {
    -- If the protocol version provided by the client can't be handled by the server.
    -- @deprecated This initialize error got replaced by client capabilities. There is
    -- no version handshake in version 3.0x
    unknownProtocolVersion = 1,
  },

  -- Defines how the host (editor) should sync document changes to the language server.
  TextDocumentSyncKind = {
    -- Documents should not be synced at all.
    None = 0,
    -- Documents are synced by always sending the full content
    -- of the document.
    Full = 1,
    -- Documents are synced by sending the full content on open.
    -- After that only incremental updates to the document are
    -- send.
    Incremental = 2,
  },

  WatchKind = {
    -- Interested in create events.
    Create = 1,
    -- Interested in change events
    Change = 2,
    -- Interested in delete events
    Delete = 4,
  },

  -- Defines whether the insert text in a completion item should be interpreted as
  -- plain text or a snippet.
  InsertTextFormat = {
    -- The primary text to be inserted is treated as a plain string.
    PlainText = 1,
    -- The primary text to be inserted is treated as a snippet.
    --
    -- A snippet can define tab stops and placeholders with `$1`, `$2`
    -- and `${3:foo};`. `$0` defines the final tab stop, it defaults to
    -- the end of the snippet. Placeholders with equal identifiers are linked,
    -- that is typing in one will update others too.
    Snippet = 2,
  },

  -- A set of predefined code action kinds
  CodeActionKind = {
    -- Empty kind.
    Empty = '',
    -- Base kind for quickfix actions
    QuickFix = 'quickfix',
    -- Base kind for refactoring actions
    Refactor = 'refactor',
    -- Base kind for refactoring extraction actions
    --
    -- Example extract actions:
    --
    -- - Extract method
    -- - Extract function
    -- - Extract variable
    -- - Extract interface from class
    -- - ...
    RefactorExtract = 'refactor.extract',
    -- Base kind for refactoring inline actions
    --
    -- Example inline actions:
    --
    -- - Inline function
    -- - Inline variable
    -- - Inline constant
    -- - ...
    RefactorInline = 'refactor.inline',
    -- Base kind for refactoring rewrite actions
    --
    -- Example rewrite actions:
    --
    -- - Convert JavaScript function to class
    -- - Add or remove parameter
    -- - Encapsulate field
    -- - Make method static
    -- - Move method to base class
    -- - ...
    RefactorRewrite = 'refactor.rewrite',
    -- Base kind for source actions
    --
    -- Source code actions apply to the entire file.
    Source = 'source',
    -- Base kind for an organize imports source action
    SourceOrganizeImports = 'source.organizeImports',
  },
  -- The reason why code actions were requested.
  CodeActionTriggerKind = {
    -- Code actions were explicitly requested by the user or by an extension.
    Invoked = 1,
    -- Code actions were requested automatically.
    --
    -- This typically happens when current selection in a file changes, but can
    -- also be triggered when file content changes.
    Automatic = 2,
  },
  InlineCompletionTriggerKind = {
    -- Completion was triggered explicitly by a user gesture.
    -- Return multiple completion items to enable cycling through them.
    Invoked = 1,
    -- Completion was triggered automatically while editing.
    -- It is sufficient to return a single completion item in this case.
    Automatic = 2,
  },
}

return M
