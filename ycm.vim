" YCM:
let g:ycm_auto_trigger = 0
let g:ycm_min_num_of_chars_for_completion = 1000
let g:ycm_filetype_blacklist = {
      \ 'tagbar' : 1,
      \ 'pandoc' : 1,
      \ 'quickrun' : 1,
      \ 'markdown' : 1,
      \}
let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_extra_conf_globlist = ['./*','../*']
let g:ycm_filepath_completion_use_working_dir = 1
let g:ycm_global_ycm_extra_conf = $HOME . '/.nvim/.ycm_extra_conf.py'
let g:ycm_goto_buffer_command = 'same-buffer' " ['same-buffer', 'horizontal-split', 'vertical-split', 'new-tab', 'new-or-existing-tab']
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_server_python_interpreter = $PYENV_ROOT.'/versions/3.6-dev/bin/python3'
let g:ycm_seed_identifiers_with_syntax = 1
