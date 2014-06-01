namespace eval ::mug::install {
    namespace export install install_directory

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

    # We've got a repo directory - is it the same as the current?
    proc is_current_repo {repo_name repo_tag repo_url} {
        set repo_details [::mug::utils::get_installed_package_details "mug_packages/$repo_name"]
        if {$repo_details != "$repo_name-$repo_tag-$repo_url\n"} {
            return 0
        }
        return 1
    }

    proc ensure_mug_packages_directory {} {
        set path [install_directory]
        if {[file exists $path]} {
            if {[file isdirectory $path] == 0} {
                return -code error "Non-directory found in $path"
            }
        } else {
            file mkdir $path
        }
    }

    proc install_item {item} {
        if {[::mug::git::is_git_url $item] == 1} {
            ::mug::git::install $item
        } else {
            ::mug::teapot::install $item
        }
    }

    proc install_directory {} {
        return "mug_packages"
    }

    proc clean_repo {repo_name repo_tag repo_url} {
        if {[local_repo_exists $repo_name]} {
            if {[is_current_repo $repo_name $repo_tag $repo_url] != 1} {
                # Remove the repo already there
                file delete -force ./mug_packages/$repo_name
            }
        } 
    }

    proc install {items} {
        # Do we have any items?
        if {[llength $items] > 0} {
            ensure_mug_packages_directory
            foreach item $items {
                puts [install_item $item]
            }
        } else {
            # Otherwise install from a file
            if {[file exists "mug-requirements.txt"]} {
                set items [split [::mug::utils::slurp_file "mug-requirements.txt"] "\n"]
                foreach item $items {
                    set item [string trim $item]
                    if {$item != {}} {
                        puts [install_item $item]
                    }
                }
            } else {
                #We have nothing to install
            }
        }
    }
}
