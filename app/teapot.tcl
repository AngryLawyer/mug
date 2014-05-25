namespace eval ::mug::teapot {

    # Args are defined like {name comparator source version}
    # Get a URL really simply
    proc get_page {url} {
        set token [::http::geturl $url]
        set data [::http::data $token]
        ::http::cleanup $token          
        return $data
    }

    # From a Teapot URL, extract the meaningful data
    proc extract_teapot_string {teapot_string} {
        set start [string first {[[TPM[[} $teapot_string]
        set end [string first {]]MPT]]} $teapot_string]
        return [string range $teapot_string [expr {$start + 7}] [expr {$end - 1}]]
    }

    proc get_teapot_info {url} {
        set data [get_page $url]
        return [extract_teapot_string $data]
    }

    proc find_teapot_package {teapot_url package_name {version "any"} {platform "tcl"}} {
        # Find the package in our packages list
        set packages [get_teapot_info $teapot_url/package/list]

        set named_packages [filter {package_tuple {
            upvar 2 package_name package_name version version platform platform
            if {[lindex $package_tuple 1] == $package_name &&
                [match_version [lindex $package_tuple 2] $version] &&
                [match_platform [lindex $package_tuple 3] $platform]} {
                return 1
            }
        }} $packages]

        return [pick_newest $named_packages]
    }


}
