#!/usr/bin/env rbx
require './example'

DeepThought.method_table.lookup(:ultimate_answer?).method.literals[1] = "55"
p DeepThought.new.ultimate_answer? 55
