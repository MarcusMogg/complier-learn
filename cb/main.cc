#include <ANTLRInputStream.h>
#include <CommonTokenStream.h>

#include "gen_cb/cbLexer.h"
#include "gen_cb/cbParser.h"

auto main() -> int {
  antlr4::ANTLRInputStream stream(std::cin);
  cb::cbLexer lex(&stream);
  antlr4::CommonTokenStream tokens(&lex);
  cb::cbParser parser(&tokens);

  auto* prog = parser.prog();

  std::cout << prog->toStringTree(&parser) << "\n";

  return 0;
}