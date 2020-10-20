p '  Aqui escribo bi  en'.gsub(/ {2,}/).map { |_,arr| Regexp.last_match.begin(0) }

# open("/usr/share/dict/words", "r:iso-8859-1") { |f|
#   f.chunk { |line| line.upcase.ord }.each { |ch, lines| p [ch.chr, lines.length] }
# }

open("/usr/share/dict/words", "r:iso-8859-1") { |f| 
f.chunk { |line| line.upcase.ord }.each { |ch, lines| p [ch.chr, lines.length] } }