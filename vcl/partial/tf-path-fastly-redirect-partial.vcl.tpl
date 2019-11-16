if (req.url ~ "(?i)^${source}/?$") {
    error ${error-code} "${destination}";
}