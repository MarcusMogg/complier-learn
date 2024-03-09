add_repositories("my-repo 3rd")

add_requires("antlr4")

rule("antlr4")
    set_extensions(".g4")
    add_deps("c++")
    before_buildcmd_file(function (target, batchcmds, sourcefile, opt)

        local basename = path.basename(sourcefile)
        local basedir = path.directory(sourcefile)
        -- 优先使用前缀，方便ignore
        local gen_dir = path.join(basedir, "gen_" .. basename)
        opt = table.join(opt, {
            outdir = gen_dir,
            namespace = basename,
        })
        
        -- 有点挫，不难用文件夹，必须指定文件名
        local gen_array = {
            "Lexer.cpp", 
            "Parser.cpp", 
            "BaseListener.cpp",
            "Listener.cpp",
            "BaseVisitor.cpp",
            "Visitor.cpp",
        }
        
        batchcmds:show_progress(opt.progress, "${color.build.object}antlr4 %s", sourcefile)
        batchcmds:execv("antlr4", {
                "-Dlanguage=Cpp", 
                "-package", opt.namespace, 
                "-o", opt.outdir,
                "-Xexact-output-dir", 
                "-visitor",
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
            batchcmds:set_depcache(target:dependfile(objectfile))
        end
    end)

add_plugindirs(path.join(os.projectdir(), "plugins"))

includes("test")