source src/agate.tcl

set app [::agate::application]
agate::get app "^/$" { {request} {
    puts "Welcome to my server!"
}}
agate::get app {^([A-Za-z0-9]+)/$} { {request name} {
    puts "Hi $name"
}}

# Standard call
set fake [dict create path / method GET]

agate::run app $fake

set fake [dict create path tony/ method GET]

agate::run app $fake

set fake [dict create path tony/lollerskates/ method GET]

agate::run app $fake
