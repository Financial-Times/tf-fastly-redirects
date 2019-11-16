if (req.url.path ~ "(?i)^${source}/?$") {
    error ${error-code} "${destination}";
}