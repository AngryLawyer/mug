namespace eval ::mug::git {
    namespace export is_git_url

    proc is_git_url {url} {
        set VALID_PREFIXES {
            "git:"
            "git+http:"
            "git+https:"
            "git+rsync:"
            "git+ftp:"
            "git+ssh:"
        }

        set prefix "[lindex [split $url ":"] 0]:"
        if {[lsearch $VALID_PREFIXES $prefix] > -1} {
            return 1
        }
        return 0
    }
}
