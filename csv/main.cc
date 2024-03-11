#include <ANTLRFileStream.h>
#include <ANTLRInputStream.h>
#include <BaseErrorListener.h>
#include <CommonTokenStream.h>

#include <string>

#include "gen_csv/csvLexer.h"
#include "gen_csv/csvParser.h"

auto main(int argc, char* argv[]) -> int {
  antlr4::ANTLRFileStream stream;
  stream.loadFromFile(argv[1]);
  csv::csvLexer lex(&stream);
  antlr4::CommonTokenStream tokens(&lex);
  csv::csvParser parser(&tokens);

  auto* file = parser.file();

  std::cout << file->toStringTree(&parser) << "\n";

  return 0;
}