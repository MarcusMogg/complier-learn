target("libjson")
    set_kind("static")
    add_files("json.g4")
    add_rules("antlr4", {
        outdir = "$(scriptdir)/json/gen",
    })
    add_packages("antlr4", {public = true})

target("json")
    set_kind("binary")
    add_files("main.cc")
    add_deps("libjson")