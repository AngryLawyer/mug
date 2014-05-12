namespace eval ::mug::git {
    namespace export is_git_url get_repo_name get_repo_url get_repo_tag

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

    proc get_repo_name {url} {
    }

    proc get_repo_url {url} {
    }

    proc get_repo_tag {url} {
        set hash_pos [string last # $url]
        if {$hash_pos == -1} {
            return {}
        }
        return [string range $url [expr $hash_pos + 1] end]
    }
}
