target("libcsv")
    set_kind("static")
    add_files("csv.g4")
    add_rules("antlr4")
    add_packages("antlr4", {public = true})


target("csv")
    set_kind("binary")
    add_files("main.cc")
    add_deps("libcsv")
    on_test(function (target,opt) 
        return import("utils.test_no_error",{rootdir = os.projectdir()})(target,opt)
    end)
    add_tests("test1",{
        rundir = os.projectdir(), 
        runargs = "csv/test1.csv",
    })
    add_tests("test2",{
        rundir = os.projectdir(), 
        runargs = "csv/test2.csv",
    })
    add_tests("test3",{
        rundir = os.projectdir(), 
        runargs = "csv/test3.csv",
    })