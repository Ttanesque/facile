/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_HOME_HPORCHET_DOCUMENTS_S_BUILD_FACILE_Y_H_INCLUDED
# define YY_YY_HOME_HPORCHET_DOCUMENTS_S_BUILD_FACILE_Y_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_IF = 258,
    TOK_THEN = 259,
    TOK_ELSE = 260,
    TOK_ELSE_IF = 261,
    TOK_END = 262,
    TOK_ENDIF = 263,
    TOK_WHILE = 264,
    TOK_END_WHILE = 265,
    TOK_DO = 266,
    TOK_CONTINUE = 267,
    TOK_BREAK = 268,
    TOK_SEMI_COLON = 269,
    TOK_AFFECTATION = 270,
    TOK_PRINT = 271,
    TOK_READ = 272,
    TOK_IDENTIFIER = 273,
    TOK_NUMBER = 274,
    TOK_BRACK_OP = 275,
    TOK_BRACK_CL = 276,
    TOK_OPE_ADD = 277,
    TOK_OPE_SUB = 279,
    TOK_OPE_DIV = 281,
    TOK_OPE_MUL = 283,
    TOK_TRUE = 285,
    TOK_FALSE = 286,
    TOK_AND = 287,
    TOK_OR = 289,
    TOK_NOT = 291,
    TOK_SUP = 293,
    TOK_INF = 295,
    TOK_EQUALS = 297,
    TOK_SUPEQUAL = 299,
    TOK_INFEQUAL = 301,
    TOK_COMMENT = 303
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 29 "facile.y" /* yacc.c:1909  */

    gulong number;
    gchar *string;
    GNode * node;

#line 97 "/home/hporchet/Documents/s/build/facile.y.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_HOME_HPORCHET_DOCUMENTS_S_BUILD_FACILE_Y_H_INCLUDED  */
