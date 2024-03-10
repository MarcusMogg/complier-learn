#include <ANTLRInputStream.h>
#include <CommonTokenStream.h>

#include <any>
#include <map>
#include <string>

#include "gen_Expr/ExprLexer.h"
#include "gen_Expr/ExprParser.h"
#include "gen_Expr/ExprVisitor.h"

class EvalVisitor final : public Expr::ExprVisitor {
 public:
  std::any visitProg(Expr::ExprParser::ProgContext* ctx) override { return visitChildren(ctx); }

  std::any visitExpression(Expr::ExprParser::ExpressionContext* ctx) override {
    const auto value = std::any_cast<int>(visit(ctx->expr()));
    std::cout << value << "\n";
    return 0;
  }

  std::any visitBlank(Expr::ExprParser::BlankContext* ctx) override { return visitChildren(ctx); }

  std::any visitParens(Expr::ExprParser::ParensContext* ctx) override { return visit(ctx->expr()); }

  std::any visitAddsub(Expr::ExprParser::AddsubContext* ctx) override {
    const auto left = std::any_cast<int>(visit(ctx->expr(0)));
    const auto right = std::any_cast<int>(visit(ctx->expr(1)));
    if (ctx->op->getText() == "+") {
      return left + right;
    }
    return left - right;
  }

  std::any visitId(Expr::ExprParser::IdContext* ctx) override {
    const auto id = ctx->ID()->getText();
    return mem_[id];
  }

  std::any visitInt(Expr::ExprParser::IntContext* ctx) override {
    return std::stoi(ctx->INT()->getText());
  }

  std::any visitMuldiv(Expr::ExprParser::MuldivContext* ctx) override {
    const auto left = std::any_cast<int>(visit(ctx->expr(0)));
    const auto right = std::any_cast<int>(visit(ctx->expr(1)));
    if (ctx->op->getText() == "*") {
      return left * right;
    }
    return left / right;
  }

  std::any visitAssign(Expr::ExprParser::AssignContext* ctx) override {
    const auto id = ctx->ID()->getText();
    const auto value = std::any_cast<int>(visit(ctx->expr()));
    mem_[id] = value;
    return value;
  }

 private:
  std::map<std::string, int> mem_;
};

auto main() -> int {
  antlr4::ANTLRInputStream stream(std::cin);
  Expr::ExprLexer lex(&stream);
  antlr4::CommonTokenStream tokens(&lex);
  Expr::ExprParser parser(&tokens);

  auto* prog = parser.prog();

  EvalVisitor eval;
  eval.visit(prog);

  // std::cout << prog->toStringTree(&parser) << "\n";

  return 0;
}