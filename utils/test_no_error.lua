import("private.action.run.runenvs")
import("core.base.option")

function main (target, opt)
    opt = opt or {}

    -- early out: results were computed during build
    if opt.build_should_fail or opt.build_should_pass then
        if opt.errors then
            vprint(opt.errors)
        end
        return opt.passed
    end

    -- get run environments
    local envs = opt.runenvs
    if not envs then
        local addenvs, setenvs = runenvs.make(target)
        envs = runenvs.join(addenvs, setenvs)
    end

    -- run test
    local rundir = opt.rundir or target:rundir()
    local targetfile = path.absolute(target:targetfile())
    local runargs = table.wrap(opt.runargs or target:get("runargs"))
    local outfile = os.tmpfile()
    local errfile = os.tmpfile()
    local run_timeout = opt.run_timeout
    local ok, syserrors = os.execv(targetfile, runargs, {try = true, timeout = run_timeout,
        curdir = rundir, envs = envs, stdout = outfile, stderr = errfile})
    local outdata = os.isfile(outfile) and io.readfile(outfile) or ""
    local errdata = os.isfile(errfile) and io.readfile(errfile) or ""
    os.tryrm(outfile)
    os.tryrm(errfile)
    if outdata and #outdata > 0 then
        vprint(outdata)
    end
    if errdata and #errdata > 0 then
        if (option.get("verbose") or option.get("diagnosis")) then
            cprint("${color.failure}%s${clear}", errdata)
        end
        return false
    end
    if opt.trim_output then
        outdata = outdata:trim()
    end


    local errors
    if ok ~= 0 then
        if not errors or #errors == 0 then
            if ok ~= nil then
                if syserrors then
                    errors = string.format("run %s failed, exit code: %d, exit error: %s", opt.name, ok, syserrors)
                else
                    errors = string.format("run %s failed, exit code: %d", opt.name, ok)
                end
            else
                errors = string.format("run %s failed, exit error: %s", opt.name, syserrors and syserrors or "unknown reason")
            end
        end
        if errors and #errors > 0 and (option.get("verbose") or option.get("diagnosis")) then
            cprint(errors)
        end
        return false
    end
    return true
end