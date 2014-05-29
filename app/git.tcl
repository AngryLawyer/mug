source [file join [file dirname [info script]] "cache.tcl"]

namespace eval ::mug::git {
    namespace export is_git_url get_repo_name get_repo_url get_repo_tag install find_fetch_url

    proc is_git_url {url} {
        set VALID_PREFIXES {
            {git:}
            {git\+http:}
            {git\+https:}
            {git\+rsync:}
            {git\+ftp:}
            {git\+ssh:}
            {git@[A-Za-z0-9_.+-]+:}
        }

        set prefix "[lindex [split $url ":"] 0]:"

        foreach {valid_prefix} $VALID_PREFIXES {
            if {[regexp $valid_prefix $prefix] == 1} {
                return 1
            }
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
        set path "mug_packages/$repo_name"
        exec git --git-dir=./$path/.git pull

        set branch_name [exec git symbolic-ref -q --short HEAD]

        if {$repo_tag != {}} {
            if {$repo_tag != $branch_name} {
                exec git --git-dir=./$path/.git checkout $repo_tag
            }
        } else {
            if {$branch_name != "master"} {
                exec git --git-dir=./$path/.git checkout master
            }
        }
    }
    
    proc install_repo {repo_name repo_url cache_directory repo_tag} {
        # We're doing a fresh install of a repo
        ::mug::cache::clean_cache $cache_directory
        ::mug::cache::ensure_cache $cache_directory
        exec git clone -q $repo_url $cache_directory
        # Switch branches etc
        if {$repo_tag != {}} {
            exec git --git-dir=$cache_directory/.git checkout $repo_tag
        }
        # Copy copy copy
        file copy $cache_directory ./mug_packages/$repo_name
        # Remove copied git directory
        file delete -force ./mug_packages/$repo_name/.git 
        ::mug::cache::clean_cache $cache_directory
    }

    proc find_fetch_url {remote_strings} {
        # Given the results of git remote -v, find
        # the url we're getting updates from
        set records [split $remote_strings "\n"]
        foreach record $records {
            if {[lindex $record 2] == "(fetch)" && [lindex $record 0] == "origin"} {
                return [lindex $record 1]
            }
        }
        return {}
    }

    proc local_repo_exists {repo_name} {
        # Check if we've got a local repo already
        set path "mug_packages/$repo_name"
        if {[file exists $path]} {
            if {[file isdirectory $path]} {
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

        set cache_directory [::mug::cache::cache_directory_path $repo_name $repo_tag]

        if {[local_repo_exists $repo_name]} {
            return -code error "Not yet implemented"
        } else {
            install_repo $repo_name $repo_url $cache_directory $repo_tag
        }

        if {$repo_tag != {}} {
            return "$repo_name@$repo_tag mug_packages/$repo_name"
        } else {
            return "$repo_name mug_packages/$repo_name"
        }
    }
}
