fish_add_path (go env GOPATH)

function godoc
	pkgsite . "$(go env GOROOT)/src"
end

funcsave godoc

