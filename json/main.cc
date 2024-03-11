#include <ANTLRInputStream.h>
#include <CommonTokenStream.h>

#include <any>
#include <map>
#include <string>

#include "gen/jsonParser.h"

auto main() -> int {
  antlr4::ANTLRInputStream stream(std::cin);
  json::jsonLexer lex(&stream);
  antlr4::CommonTokenStream tokens(&lex);
  json::jsonParser parser(&tokens);

  auto* prog = parser.prog();

  std::cout << prog->toStringTree(&parser) << "\n";

  return 0;
}