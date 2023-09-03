CallStatusbar:
    jsr StatusbarCode_main
    lda $1493|!addr
    ora $9D
    jml $008E1F|!bank

namespace StatusbarCode
incsrc "!StatusbarCodeFile"
namespace off
