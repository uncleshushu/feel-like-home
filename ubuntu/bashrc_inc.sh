# aliases

# colorful `cat`
function ccat() {
    local style="monokai"
    if [ $# -eq 0 ]; then
        pygmentize -P style=$style -P tabsize=4 -f terminal256 -g
    else
        for NAME in "$@"; do
            pygmentize -P style=$style -P tabsize=4 -f terminal256 -g "$NAME"
        done
    fi
}

# environment variables
export PIPENV_PYPI_MIRROR="https://mirrors.ustc.edu.cn/pypi/web/simple"
