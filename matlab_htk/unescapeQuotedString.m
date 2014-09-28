function s = unescapeQuotedString(s)
    s = strrep(s, '\''', ''''); % \' -> '
    s = strrep(s, '\"', '"');   % \" -> "
    s = strrep(s, '\\', '\');   % \\ -> \
end

