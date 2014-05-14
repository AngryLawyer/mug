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
        # From a Git URL, extract a tag or commit, if any
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

    proc check_clean_repo {} {
        # Has a given repo got any local changes that would be lost?
        set result [exec git status --porcelain]
        if {$result == {}} {
            return 1
        } else {
            return 0
        }
    }

    proc update_repo {repo_name repo_tag} {
    }

    proc validate_local_repo {repo_name repo_url} {
        # a local repo
    }

    proc local_repo_exists {repo_name} {
        # Check if we've got a local repo already
        set path "mug_packages/$repo_name"
        if {[file exists $path]} {
            if {[file isdirectory $path]} {
                set result [exec git --git-dir=./$path/.git remote -v]
                puts $result
                return 1
            } else {
                return -code error "Non-directory found in $path"
            }
        }
        return 0
    }

    proc install {url} {
        if {![check_git_exists]} {
            return -code error "I can't find git!"
        }

        set repo_name [get_repo_name $url]
        set repo_tag [get_repo_tag $url]
        set repo_url [get_repo_url $url]

        if {[local_repo_exists $repo_name]} {
        }

    }
}
