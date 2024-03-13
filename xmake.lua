set_languages("c++23")

add_repositories("my-repo 3rd")
add_requires("antlr4")

rule("antlr4")
    set_extensions(".g4")
    add_deps("c++")
    after_load(function (target) 
        target:set("policy", "build.across_targets_in_parallel", false)
    end)
    before_buildcmd_file(function (target, batchcmds, sourcefile, opt)
        -- https://xmake.io/#/zh-cn/manual/extension_modules?id=detectfind_program
        -- antlr has no --version/--help
        import("lib.detect.find_program")
        local antlr_checker = function (program) os.run("%s", program) end
        local antlr = assert(find_program("antlr",{check=antlr_checker}) 
                                or find_program("antlr4",{check=antlr_checker}), 
                             "antlr not found!")
        
        local basename = path.basename(sourcefile)
        local basedir = path.directory(sourcefile)
        -- 优先使用前缀，方便ignore
        local gen_dir = path.join(basedir, "gen_" .. basename)
        local gen_opt = {
            outdir = target:extraconf("rules", "antlr4", "outdir") or gen_dir,
            namespace = target:extraconf("rules", "antlr4", "namespace") or basename,
            visitor = target:extraconf("rules", "antlr4", "visitor") or true,
            listener = target:extraconf("rules", "antlr4", "listener") or true,
        }
        print(target:extraconf("rules", "antlr4", "outdir"))
        -- 有点挫，不能用文件夹，必须指定文件名
        local gen_array = {
            "Lexer.cpp", 
            "Parser.cpp",
        }

        if gen_opt.listener then 
            table.join2(gen_array,{
                "BaseListener.cpp",
                "Listener.cpp",
            })
        end
        if gen_opt.visitor then 
            table.join2(gen_array,{
                "BaseVisitor.cpp",
                "Visitor.cpp",
            })
        end
        
        batchcmds:show_progress(opt.progress, "${color.build.object}antlr4 %s", sourcefile)
        batchcmds:vrunv(antlr, {
                "-Dlanguage=Cpp", 
                "-package", gen_opt.namespace, 
                "-o", gen_opt.outdir,
                "-Xexact-output-dir", 
                gen_opt.visitor and "-visitor" or "-no-visitor",
                gen_opt.listener and "-listener" or "-no-listener",
                sourcefile,
            })
        batchcmds:add_depfiles(sourcefile)

        for i = 1, #gen_array do
            -- get c/c++ source file for yacc
            local sourcefile_cx = path.join(gen_dir, basename .. gen_array[i])

            -- add objectfile
            local objectfile = target:objectfile(sourcefile_cx)
            table.insert(target:objectfiles(), objectfile)

            -- add commands
            batchcmds:compile(sourcefile_cx, objectfile)

            -- add deps
            batchcmds:set_depmtime(os.mtime(objectfile))
            batchcmds:add_depfiles(sourcefile_cx)
            batchcmds:set_depcache(target:dependfile(objectfile))
        end
    end)
rule_end()

add_plugindirs(path.join(os.projectdir(), "plugins"))

includes("*/xmake.lua")