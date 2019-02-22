" " -- gorename
" command! -nargs=? -complete=customlist,go#rename#Complete GoRename call go#rename#Rename(<bang>0, <f-args>)
"
"
" " -- guru
" command! -nargs=* -complete=customlist,go#package#Complete VimGoGuruScope call go#guru#Scope(<f-args>)
" command! -range=% VimGoImplements call go#guru#Implements(<count>)
" command! -range=% VimGoPointsTo call go#guru#PointsTo(<count>)
" command! -range=% VimGoWhicherrs call go#guru#Whicherrs(<count>)
" command! -range=% VimGoCallees call go#guru#Callees(<count>)
" command! -range=% VimGoDescribe call go#guru#Describe(<count>)
" command! -range=% VimGoCallers call go#guru#Callers(<count>)
" command! -range=% VimGoCallstack call go#guru#Callstack(<count>)
" command! -range=% VimGoFreevars call go#guru#Freevars(<count>)
" command! -range=% VimGoChannelPeers call go#guru#ChannelPeers(<count>)
" command! -range=% VimGoReferrers call go#guru#Referrers(<count>)
"
"
" command! -range=0 VimGoSameIds call go#guru#SameIds(1)
" command! -range=0 VimGoSameIdsClear call go#guru#ClearSameIds()
" command! -range=0 VimGoSameIdsToggle call go#guru#ToggleSameIds()
" command! -range=0 VimGoSameIdsAutoToggle call go#guru#AutoToogleSameIds()
"
"
" " -- tags
" command! -nargs=* -range VimGoAddTags call go#tags#Add(<line1>, <line2>, <count>, <f-args>)
" command! -nargs=* -range VimGoRemoveTags call go#tags#Remove(<line1>, <line2>, <count>, <f-args>)
"
"
" " -- mod
" command! -nargs=0 -range VimGoModFmt call go#mod#Format()
"
"
" " -- tool
" command! -nargs=* -complete=customlist,go#tool#ValidFiles VimGoFiles echo go#tool#Files(<f-args>)
" command! -nargs=0 VimGoDeps echo go#tool#Deps()
" command! -nargs=0 VimGoInfo call go#tool#Info(1)
" command! -nargs=0 VimGoAutoTypeInfoToggle call go#complete#ToggleAutoTypeInfo()
"
"
" " -- cmd
" command! -nargs=* -bang VimGoBuild call go#cmd#Build(<bang>0,<f-args>)
" command! -nargs=? -bang VimGoBuildTags call go#cmd#BuildTags(<bang>0, <f-args>)
" command! -nargs=* -bang VimGoGenerate call go#cmd#Generate(<bang>0,<f-args>)
" command! -nargs=* -bang -complete=file VimGoRun call go#cmd#Run(<bang>0,<f-args>)
" command! -nargs=* -bang VimGoInstall call go#cmd#Install(<bang>0, <f-args>)
"
"
" " -- test
" command! -nargs=* -bang VimGoTest call go#test#Test(<bang>0, 0, <f-args>)
" command! -nargs=* -bang VimGoTestFunc call go#test#Func(<bang>0, <f-args>)
" command! -nargs=* -bang VimGoTestCompile call go#test#Test(<bang>0, 1, <f-args>)
"
"
" " -- cover
" command! -nargs=* -bang VimGoCoverage call go#coverage#Buffer(<bang>0, <f-args>)
" command! -nargs=* -bang VimGoCoverageClear call go#coverage#Clear()
" command! -nargs=* -bang VimGoCoverageToggle call go#coverage#BufferToggle(<bang>0, <f-args>)
" command! -nargs=* -bang VimGoCoverageBrowser call go#coverage#Browser(<bang>0, <f-args>)
"
"
" " -- play
" command! -nargs=0 -range=% VimGoPlay call go#play#Share(<count>, <line1>, <line2>)
"
"
" " -- def
" command! -nargs=* -range VimGoDef :call go#def#Jump('')
" command! -nargs=? VimGoDefPop :call go#def#StackPop(<f-args>)
" command! -nargs=? VimGoDefStack :call go#def#Stack(<f-args>)
" command! -nargs=? VimGoDefStackClear :call go#def#StackClear(<f-args>)
"
"
" " -- doc
" command! -nargs=* -range -complete=customlist,go#package#Complete VimGoDoc call go#doc#Open('new', 'split', <f-args>)
" command! -nargs=* -range -complete=customlist,go#package#Complete VimGoDocBrowser call go#doc#OpenBrowser(<f-args>)
"
"
" " -- fmt
" command! -nargs=0 VimGoFmt call go#fmt#Format(-1)
" command! -nargs=0 VimGoFmtAutoSaveToggle call go#fmt#ToggleFmtAutoSave()
" command! -nargs=0 VimGoImports call go#fmt#Format(1)
"
"
" " -- asmfmt
" command! -nargs=0 VimGoAsmFmtAutoSaveToggle call go#asmfmt#ToggleAsmFmtAutoSave()
"
"
" " -- import
" command! -nargs=? -complete=customlist,go#package#Complete VimGoDrop call go#import#SwitchImport(0, '', <f-args>, '')
" command! -nargs=1 -bang -complete=customlist,go#package#Complete VimGoImport call go#import#SwitchImport(1, '', <f-args>, '<bang>')
" command! -nargs=* -bang -complete=customlist,go#package#Complete VimGoImportAs call go#import#SwitchImport(1, <f-args>, '<bang>')
"
"
" " -- linters
" command! -nargs=* VimGoMetaLinter call go#lint#Gometa(0, <f-args>)
" command! -nargs=0 VimGoMetaLinterAutoSaveToggle call go#lint#ToggleMetaLinterAutoSave()
" command! -nargs=* VimGoLint call go#lint#Golint(<f-args>)
" command! -nargs=* -bang VimGoVet call go#lint#Vet(<bang>0, <f-args>)
" command! -nargs=* -complete=customlist,go#package#Complete VimGoErrCheck call go#lint#Errcheck(<f-args>)
"
"
" " -- alternate
" command! -bang VimGoAlternate call go#alternate#Switch(<bang>0, '')
"
"
" " -- decls
" command! -nargs=? -complete=file VimGoDecls call go#decls#Decls(0, <q-args>)
" command! -nargs=? -complete=dir VimGoDeclsDir call go#decls#Decls(1, <q-args>)
"
"
" " -- impl
" command! -nargs=* -complete=customlist,go#impl#Complete VimGoImpl call go#impl#Impl(<f-args>)
"
"
" " -- template
" command! -nargs=0 VimGoTemplateAutoCreateToggle call go#template#ToggleAutoCreate()
"
"
" " -- keyify
" command! -nargs=0 VimGoKeyify call go#keyify#Keyify()
"
"
" " -- fillstruct
" command! -nargs=0 VimGoFillStruct call go#fillstruct#FillStruct()
"
"
" " -- debug
" if !exists(':GoDebugStart')
"   command! -nargs=* -complete=customlist,go#package#Complete VimGoDebugStart call go#debug#Start(0, <f-args>)
"   command! -nargs=* -complete=customlist,go#package#Complete VimGoDebugTest  call go#debug#Start(1, <f-args>)
"   command! -nargs=? VimGoDebugBreakpoint call go#debug#Breakpoint(<f-args>)
" endif
"
"
" " -- issue
" command! -nargs=0 VimGoReportGitHubIssue call go#issue#New()
"
"
" " -- iferr
" command! -nargs=0 VimGoIfErr call go#iferr#Generate()


" vim: sw=2 ts=2 et
