require 'showoff'
require 'commandline_parser'

CommandlineParser.rule(:prompt) { str('$') | str('#') | str('>>') }
run ShowOff
