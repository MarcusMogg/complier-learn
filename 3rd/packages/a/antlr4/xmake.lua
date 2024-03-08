package("antlr4")

    set_homepage("https://www.antlr.org/")
    set_description("ANTLR (ANother Tool for Language Recognition) is a powerful parser generator for reading, processing, executing, or translating structured text or binary files.")

    add_urls("https://github.com/antlr/antlr4/archive/refs/tags/$(version).tar.gz",
             "https://github.com/antlr/antlr4.git")
    add_versions("4.13.1", "da20d487524d7f0a8b13f73a8dc326de7fc2e5775f5a49693c0a4e59c6b1410c")

    add_deps("cmake")
    -- well, gencode path is hardcode
    add_includedirs("include/antlr4-runtime")

    on_install("macosx", "linux", "windows", "mingw", "cross", function (package)

        local configs = {"-DCMAKE_CXX_STANDARD=17"}
        table.insert(configs, "-DWITH_DEMO=False")
        table.insert(configs, "-DCMAKE_BUILD_TYPE=" .. (package:debug() and "Debug" or "Release"))
        if package:config("shared") then 
            table.insert(configs, "-DANTLR_BUILD_SHARED=On")
        else 
            table.insert(configs, "-DANTLR_BUILD_STATIC=On")
        end
        os.cd(path.join(os.curdir(), "runtime","Cpp"))
        import("package.tools.cmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
           #include "antlr4-runtime.h"
           class ExprParser : public antlr4::Parser {};
        ]]}, {configs = {languages = "cxx17"}}))
    end)