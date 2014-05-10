namespace eval ::mug::install {
    namespace export install

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
        puts $item
    }
}
