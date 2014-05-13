#FIXME: Abstract this away
source [file join [file dirname [info script]] "git.tcl"]

namespace eval ::mug::install {
    namespace export install install_directory

    proc install {items} {
        # Do we have any items?
        if {[llength $items] > 0} {
            foreach item $items {
                install_item $item
            }
        } else {
            # Otherwise install from a file
        }
    }

    proc install_item {item} {
        if {[::mug::git::is_git_url $item] == 1} {
            ::mug::git::install $item
        } else {
            puts "$item is not a Git repo"
        }
    }

    proc install_directory {} {
        return "mug_packages"
    }
}
