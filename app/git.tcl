namespace eval ::mug::git {
    namespace export is_git_url get_repo_name get_repo_url get_repo_tag install

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
        set last_slash [string last "/" $url]
        set git_extension [string first ".git" $url $last_slash]
        if {$last_slash != -1 && $git_extension != -1} {
            return [string range $url [expr $last_slash + 1] [expr $git_extension - 1]]
        } else {
            return {}
        }
    }

    proc get_repo_url {url} {
        set git_prefix [string first "git+" $url]
        if {$git_prefix == 0} {
            set start_pos 4
        } else {
            set start_pos 0
        }

        set hash_pos [string last # $url]
        if {$hash_pos != -1} {
            set end_pos [expr $hash_pos - 1]
        } else {
            set end_pos end
        }
        return [string range $url $start_pos $end_pos]
    }

    proc get_repo_tag {url} {
        set hash_pos [string last # $url]
        if {$hash_pos == -1} {
            return {}
        }
        return [string range $url [expr $hash_pos + 1] end]
    }

    proc check_git_exists {} {
        #TODO: This needs to be platform independent
        set result [exec which git]
        if {$result != {}} {
            return 1
        } else {
            return 0
        }
    }

    proc install {url} {
        if {![check_git_exists]} {
            puts "I can't find git!"
            return
        }
    }
}
