import pypeg2


class MDText:
    grammar = some(word)

class header:
    grammar = "sec ", date, endl, maybe_some(tag)

class date:
    grammar = 
