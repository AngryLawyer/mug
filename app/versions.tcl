namespace eval ::mug::versions {
    namespace export match_version parse_version_pattern pick_newest

    proc parse_version_pattern {pattern} {
        if {$pattern == "any"} {
            return $pattern
        }

        set strlen [string length $pattern]

        if {[string first "==" $pattern] == 0 || [string first ">=" $pattern] == 0 || [string first "<=" $pattern] == 0} { 
            return "[string range $pattern 0 1] [string trim [string range $pattern 2 $strlen]]"
        } elseif {[string first ">" $pattern] == 0 || [string first "<" $pattern] == 0 || [string first "~" $pattern] == 0} {
            return "[string range $pattern 0 0] [string trim [string range $pattern 1 $strlen]]"
        } else {
            error "Invalid pattern $pattern"
        }
    }

    proc pick_newest {packages} {
        #FIXME: Make it do something
        return [lindex $packages 0]
    }

    proc match_version {available target} {

        if {$target == "any"} {
            return 1
        }

        set operator [lindex $target 0]
        set version [lindex $target 1]

        if {$operator == "=="} {
            return [expr {$version == $available}]
        } 

        set exploded_version [split $version "."]
        set exploded_available [split $available "."]

        # Approx equal - find something that matches the substring on the left
        if {$operator == "~"} {
            foreach version_part $exploded_version available_part $exploded_available {
                if {$version_part == {}} {
                    return 1
                }
                if {$version_part != $available_part} {
                    return 0
                }
            }
            return 1
        }

        if {$operator == ">="} {
            foreach version_part $exploded_version available_part $exploded_available {
                if {$version_part == {}} {
                    return 1
                } elseif {$available_part < $version_part} {
                    return 0
                } elseif {$available_part > $version_part} {
                    return 1
                }
            }
            return 1
        }

        if {$operator == ">"} {
            foreach version_part $exploded_version available_part $exploded_available {
                if {$version_part == {}} {
                    return 1
                } elseif {$available_part < $version_part} {
                    return 0
                } elseif {$available_part > $version_part} {
                    return 1
                }
            }
            return 0
        }

        if {$operator == "<="} {
            foreach version_part $exploded_version available_part $exploded_available {
                if {$version_part == {}} {
                    return 0
                } elseif {$available_part > $version_part} {
                    return 0
                } elseif {$available_part < $version_part} {
                    return 1
                }
            }
            return 1
        }

        if {$operator == "<"} {
            foreach version_part $exploded_version available_part $exploded_available {
                if {$version_part == {}} {
                    return 0
                } elseif {$available_part > $version_part} {
                    return 0
                } elseif {$available_part < $version_part} {
                    return 1
                }
            }
            return 0
        }

    }

}
