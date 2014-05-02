/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.2"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1


/* Substitute the variable and function names.  */
#define yyparse         cavparse
#define yylex           cavlex
#define yyerror         caverror
#define yydebug         cavdebug
#define yynerrs         cavnerrs

#define yylval          cavlval
#define yychar          cavchar

/* Copy the first part of user declarations.  */
#line 11 "CAV.y" /* yacc.c:339  */

#include "alphaPoly.h"
#include<cstdio>
#include<cstdlib>
#include<iostream>
#include<sstream>
#include<map>
#include<list>
#include<set>
#include<vector>
#include<string>
#include<cstring>
#include<fstream>
#include<cassert>
#include<algorithm>
#include<ctime>
using namespace std;

/*************Definition of Flex&Bison**********/
extern int cavlineno;
extern FILE *cavin;
extern FILE *cavout;
int caverror(const char *s);
extern int cavlex();

double diffms(0.0);
static clock_t end;
static clock_t begin;
/**********************************************/
/**********************************************/
typedef struct monomial_
{
	set<unsigned int> monList;
	AlphaPoly* coef;
} monomial;
static monomial tempmon;

static list<monomial> glopoly;
static list<monomial> specpoly;

static vector< list<monomial> > ideal;

static unsigned long int lastExp;

static map<string, unsigned int> VID;   // mapping:  variable -> ID
static map<unsigned int,string> DIV;   // mapping:  ID --> variable  
static unsigned int ind=2;				//ID index. "0" is not supposed to occur in any monomial.

static map<string, unsigned int>::iterator mapit;

static string minpolyString = "";
static string tmpMinpoly = "";

static void HandleMiter(string out1, string out2);

static void HandleMinpoly(string& str, char* var, unsigned long int exp);

static void HandlePoly(list<monomial>& tempoly);

static int CompareSet(set<unsigned int> &set1,set<unsigned int> &set2);

/*sorting monomials when inserting into polynomial*/
static void insertmon(monomial & tempmon, bool delCoef);
/*merge sort of two sorted polys*/
void mergesort(list<monomial>& specpoly,list<monomial>& tempoly);
/*insertion order, insert tempmon into poly*/
static void insertmon2poly(list<monomial>& poly, monomial & mon);
/* copies monList and coef in "from" over to "to". "from" remains unchanged.*/
static void copyMonomial(monomial* to, monomial& from);
/* multiplies "original" by "mult" and stores in "original". "mult remains unchanged */
static void multiplyMonomial(monomial* original, monomial& mult);


/***  kernel function***/
/*multivariate polynomial reduction*/
static void reduce(list<monomial> & specpoly,vector< list<monomial> > &ideal );
static void HandleVar(char * var);

static void clear();

/**********aux functions*******/
static void printmap();
static void printmonomial(monomial & toprint);
static void printpoly(list<monomial> &toprint);
static void printideal(vector< list<monomial> > &toprint);

static int digione; //the corresponding index of number 1.


#line 164 "parser.cpp" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* In a future release of Bison, this section will be replaced
   by #include "parser.hpp".  */
#ifndef YY_CAV_PARSER_HPP_INCLUDED
# define YY_CAV_PARSER_HPP_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int cavdebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    VARIABLE = 258,
    EXP = 259
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 103 "CAV.y" /* yacc.c:355  */

  char* id;
  unsigned long int exp;
  bool parentheses;

#line 215 "parser.cpp" /* yacc.c:355  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE cavlval;

int cavparse (void);

#endif /* !YY_CAV_PARSER_HPP_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 230 "parser.cpp" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  6
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   32

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  12
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  14
/* YYNRULES -- Number of rules.  */
#define YYNRULES  23
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  42

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   259

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
      11,    10,     6,     5,     9,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     8,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     7,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint8 yyrline[] =
{
       0,   125,   125,   126,   129,   132,   133,   136,   139,   140,
     143,   150,   151,   154,   155,   159,   160,   161,   164,   167,
     168,   172,   176,   179
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "VARIABLE", "EXP", "'+'", "'*'", "'^'",
  "';'", "','", "')'", "'('", "$accept", "statements", "statement",
  "vardelc", "minpoly", "minvar", "specPoly", "polys", "poly", "gmonomial",
  "group", "groupStart", "var", "exponent", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,    43,    42,    94,    59,    44,
      41,    40
};
# endif

#define YYPACT_NINF -27

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-27)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
       2,   -27,     3,   -27,    11,     7,   -27,   -27,     2,     2,
     -27,   -27,    -1,     8,     7,     7,     1,     2,     2,    15,
      19,    10,    20,     5,     7,     7,     7,     1,     1,     2,
       2,     2,   -27,    13,    19,    10,     7,     7,     7,   -27,
       1,    19
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       0,    21,     0,     2,     0,     5,     1,     3,     0,     0,
      23,    22,     0,     7,     8,     6,     0,     0,     0,     0,
      10,    13,     0,     0,    15,     9,    19,     0,     0,     0,
       0,     0,    18,     0,    11,    14,    17,    16,    20,     4,
       0,    12
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -27,   -27,    23,   -27,   -27,   -27,   -27,   -27,   -26,     4,
     -27,   -27,     0,   -27
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     2,     3,     4,    12,    13,    19,    33,    20,    21,
      22,    23,    24,    11
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
       5,    34,     5,     6,     1,     1,     1,    16,    14,    15,
      31,    10,    18,    17,    41,    32,    29,    25,    26,     8,
       9,    39,    40,    27,    28,     7,    30,     0,     0,    36,
      37,    38,    35
};

static const yytype_int8 yycheck[] =
{
       0,    27,     2,     0,     3,     3,     3,     8,     8,     9,
       5,     4,    11,     5,    40,    10,     6,    17,    18,     8,
       9,     8,     9,     8,     5,     2,     6,    -1,    -1,    29,
      30,    31,    28
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,     3,    13,    14,    15,    24,     0,    14,     8,     9,
       4,    25,    16,    17,    24,    24,     8,     5,    11,    18,
      20,    21,    22,    23,    24,    24,    24,     8,     5,     6,
       6,     5,    10,    19,    20,    21,    24,    24,    24,     8,
       9,    20
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    12,    13,    13,    14,    15,    15,    16,    17,    17,
      18,    19,    19,    20,    20,    21,    21,    21,    22,    23,
      23,    24,    24,    25
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     2,     8,     1,     3,     1,     1,     3,
       1,     1,     3,     1,     3,     1,     3,     3,     2,     2,
       3,     1,     2,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 125 "CAV.y" /* yacc.c:1646  */
    {reduce(specpoly,ideal);clear();}
#line 1324 "parser.cpp" /* yacc.c:1646  */
    break;

  case 3:
#line 126 "CAV.y" /* yacc.c:1646  */
    {reduce(specpoly,ideal);clear();}
#line 1330 "parser.cpp" /* yacc.c:1646  */
    break;

  case 5:
#line 132 "CAV.y" /* yacc.c:1646  */
    {VID[(yyvsp[0].id)]=ind;DIV[ind]=(yyvsp[0].id);if(strcmp((yyvsp[0].id),"1")==0) digione=ind;++ind;  free((yyvsp[0].id));}
#line 1336 "parser.cpp" /* yacc.c:1646  */
    break;

  case 6:
#line 133 "CAV.y" /* yacc.c:1646  */
    {VID[(yyvsp[0].id)]=ind;DIV[ind]=(yyvsp[0].id);if(strcmp((yyvsp[0].id),"1")==0) digione=ind;++ind;  free((yyvsp[0].id));}
#line 1342 "parser.cpp" /* yacc.c:1646  */
    break;

  case 7:
#line 136 "CAV.y" /* yacc.c:1646  */
    {AlphaPoly::setMinpoly(minpolyString); tempmon.coef = new AlphaPoly((long unsigned int)0);}
#line 1348 "parser.cpp" /* yacc.c:1646  */
    break;

  case 8:
#line 139 "CAV.y" /* yacc.c:1646  */
    {HandleMinpoly(minpolyString,(yyvsp[0].id),lastExp); free((yyvsp[0].id));}
#line 1354 "parser.cpp" /* yacc.c:1646  */
    break;

  case 9:
#line 140 "CAV.y" /* yacc.c:1646  */
    {minpolyString += "+"; HandleMinpoly(minpolyString,(yyvsp[0].id),lastExp); free((yyvsp[0].id));}
#line 1360 "parser.cpp" /* yacc.c:1646  */
    break;

  case 10:
#line 143 "CAV.y" /* yacc.c:1646  */
    {specpoly=glopoly;glopoly.clear();}
#line 1366 "parser.cpp" /* yacc.c:1646  */
    break;

  case 11:
#line 150 "CAV.y" /* yacc.c:1646  */
    {HandlePoly(glopoly);glopoly.clear();}
#line 1372 "parser.cpp" /* yacc.c:1646  */
    break;

  case 12:
#line 151 "CAV.y" /* yacc.c:1646  */
    {HandlePoly(glopoly);glopoly.clear();}
#line 1378 "parser.cpp" /* yacc.c:1646  */
    break;

  case 13:
#line 154 "CAV.y" /* yacc.c:1646  */
    {insertmon(tempmon, true);tempmon.monList.clear();tempmon.coef = new AlphaPoly((unsigned long int)0);}
#line 1384 "parser.cpp" /* yacc.c:1646  */
    break;

  case 14:
#line 155 "CAV.y" /* yacc.c:1646  */
    {insertmon(tempmon, true);tempmon.monList.clear();tempmon.coef = new AlphaPoly((unsigned long int)0);}
#line 1390 "parser.cpp" /* yacc.c:1646  */
    break;

  case 15:
#line 159 "CAV.y" /* yacc.c:1646  */
    {HandleVar((yyvsp[0].id));free((yyvsp[0].id));}
#line 1396 "parser.cpp" /* yacc.c:1646  */
    break;

  case 16:
#line 160 "CAV.y" /* yacc.c:1646  */
    {HandleVar((yyvsp[0].id));free((yyvsp[0].id));}
#line 1402 "parser.cpp" /* yacc.c:1646  */
    break;

  case 17:
#line 161 "CAV.y" /* yacc.c:1646  */
    {HandleVar((yyvsp[0].id));free((yyvsp[0].id));}
#line 1408 "parser.cpp" /* yacc.c:1646  */
    break;

  case 18:
#line 164 "CAV.y" /* yacc.c:1646  */
    {AlphaPoly tmp = AlphaPoly(tmpMinpoly); tempmon.coef->mult(&tmp); }
#line 1414 "parser.cpp" /* yacc.c:1646  */
    break;

  case 19:
#line 167 "CAV.y" /* yacc.c:1646  */
    { tmpMinpoly=""; HandleMinpoly(tmpMinpoly, (yyvsp[0].id), lastExp); free((yyvsp[0].id));}
#line 1420 "parser.cpp" /* yacc.c:1646  */
    break;

  case 20:
#line 168 "CAV.y" /* yacc.c:1646  */
    { tmpMinpoly+="+";HandleMinpoly(tmpMinpoly,(yyvsp[0].id),lastExp); free((yyvsp[0].id));}
#line 1426 "parser.cpp" /* yacc.c:1646  */
    break;

  case 21:
#line 173 "CAV.y" /* yacc.c:1646  */
    {
		(yyval.id) =strdup((yyvsp[0].id)); lastExp=1;
	}
#line 1434 "parser.cpp" /* yacc.c:1646  */
    break;

  case 22:
#line 176 "CAV.y" /* yacc.c:1646  */
    {(yyval.id) =strdup((yyvsp[-1].id)); lastExp=(yyvsp[0].exp);}
#line 1440 "parser.cpp" /* yacc.c:1646  */
    break;

  case 23:
#line 179 "CAV.y" /* yacc.c:1646  */
    {;}
#line 1446 "parser.cpp" /* yacc.c:1646  */
    break;


#line 1450 "parser.cpp" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 183 "CAV.y" /* yacc.c:1906  */


int caverror(const char *s)
{
cout<<"ERROR:line "<<cavlineno<<": "<<s<<"\n";
return 1;
}

void cavmain(char *filename)
{
	cavin=fopen(filename,"r");
	if(!cavin)
	{
		cout<<"Fail to locate file: "<<filename<<endl;
		return;
	}
	cavparse();
	fclose(cavin);
	//printideal(ideal);
	//cout<<"Total verification time is: "<<diffms<<" ms."<<endl;
	//cout<<"specpoly:"<<endl;
	//printpoly(specpoly);
	//cout<<"ideal:"<<endl;
	//printideal(ideal);
	
	//cout<<"reduction:"<<endl;
	
	
	//reduce(specpoly,ideal);
	
}

void HandleVar(char * var)
{
	if( strcmp(var,"X") == 0 )
	{
		AlphaPoly tmp(lastExp);
		tempmon.coef->mult(&tmp);
		return;
	}

	if( strcmp(var,"1") == 0 )
	{
		// tempmon.coef already contains one
		return;
	}

	if(VID.find(var)!=VID.end()) 
		tempmon.monList.insert(VID[var]);
	else
	{
		cout<<var<<" undefined\n";
		exit(1);
	}
}


void HandleMinpoly(string& str, char* var, unsigned long int exp)
{
	stringstream ss;
	if( exp == 0 )
	{
		cout<<"Invalid minpoly exponent 0"<<endl;
		exit(1);
	}

	if( strcmp(var,"X") == 0 )
	{
		str += "X";
		if(exp!=1)
		{
			ss<<exp;
			str+="^"+ss.str();
		}
	}
	else 
	{
		if( strcmp(var,"1") == 0 )
		{
			str += "1";
		}
		else
		{
			cout<<"Invalid minpoly variable "<<var<<endl;
			exit(1);
		}
	}
}


// Ideal does not have to be in ring order
// But the program will parse a bit faster if it is
void HandlePoly(list<monomial>& tempoly)
{
	//cout<<"Adding: ";
	//printpoly(tempoly);
	int ret;
	vector<list<monomial> >::iterator it;
	if( ideal.size() == 0 )
	{
		ideal.push_back(tempoly);
		return;
	}

	it = ideal.end();
	do
	{
		it--;
		ret = CompareSet(it->front().monList,tempoly.front().monList);
		//cout<<"ret"<<endl;
		if( ret < 0 )
		{
			if( it+1 == ideal.end() )
				ideal.push_back(tempoly);
			else
				ideal.insert(it+1,tempoly);
			return;
		}
		//cout<<"After if1"<<endl;
		if( ret == 0 )
		{
			/*cout<<"WARNING:"<<endl;
			printpoly(*it);
			printpoly(tempoly);
			cout<<"Contain the same monomials!"<<endl;*/
			if( it+1 == ideal.end() )
				ideal.push_back(tempoly);
			else
				ideal.insert(it+1,tempoly);
			return;
		}
		//cout<<"After if2"<<endl;
	}
	while(it != ideal.begin());
	//cout<<"Outside"<<endl;
	ideal.insert(it,tempoly);
}

void HandleMiter(string out1,  string out2)
{
	// tempmon will already have a valid coef of exp 0 by this point

	tempmon.monList.insert(VID[out1]);
	specpoly.push_back(tempmon);
	tempmon.monList.clear();
	tempmon.monList.insert(VID[out2]);
	tempmon.coef = new AlphaPoly((long unsigned int)0);
	specpoly.push_back(tempmon);
	tempmon.monList.clear();
	tempmon.coef = new AlphaPoly((long unsigned int)0);
}

//1 if set1> set2, example: <5,2,3> > <2,3,4>
//0 if set1=set2
//-1 if set1<set2
int CompareSet(set<unsigned int> &set1,set<unsigned int> &set2)
{
	set<unsigned int>::iterator it1;
	set<unsigned int>::iterator it2;
	
	for(it1=set1.begin(),it2=set2.begin();((it1!=set1.end()) && (it2!=set2.end()));++it1,++it2)
	if((*it1)>(*it2)) return 1;
	else if((*it1)<(*it2)) return -1;
	
	if(set1.size()>set2.size())
	return -1;
	else if(set1.size()<set2.size())
	return 1;
	else return 0;
}


/*sorting monomials when inserting into polynomial*/
// delCoef == true deletes tempmon.coef if not used by glopoly
void insertmon(monomial & tempmon, bool delCoef)
{
	if(tempmon.monList.size() == 0)
	{
		glopoly.push_back(tempmon);
		return;
	}
	set<unsigned int>::iterator monit=tempmon.monList.end();
		--monit;
//	if ( (*monit==digione) && (tempmon.monList.size()>1) )//handle the case: a*b*1
//		tempmon.monList.erase(monit);
	if(glopoly.size()==0 )
	{
		glopoly.push_back(tempmon);
	}
	else
	{
		//sorting first
		list<monomial>::iterator it; //about 5 times faster than reverse iterator.
		it=glopoly.end();
		int temp;
		--it;
	//cout<<"it=";printmonomial(*it);cout<<endl;
		while(it!=glopoly.begin())
		{
			temp=CompareSet(tempmon.monList,it->monList);//cout<<"compare result is: "<<temp<<endl;
			if( temp==1)//temp > it
			{
				glopoly.insert(++it,tempmon);
		//		cout<<"insert: ";printmonomial(tempmon);//cout<<" into: ";printpoly(glopoly);
				return;
			}
			else if(temp==-1)
			--it;
			else if (temp==0) //same, add or delete
			{
				it->coef->add(tempmon.coef);
				if( it->coef->isZero() )
				{
					delete it->coef;
					glopoly.erase(it);
				}
				if( delCoef )
					delete tempmon.coef;
		//		cout<<"insert: ";printmonomial(tempmon);cout<<" into: ";printpoly(glopoly);
				return;
			}
			
		}
	
		temp=CompareSet(tempmon.monList,it->monList);//cout<<"compare result is: "<<temp<<endl;
		if( temp==1)//temp > it
		{
			glopoly.insert(++it,tempmon);
		}
		else if(temp==-1)
			glopoly.push_front(tempmon);
		else if (temp==0) //same, add or delete
		{
			it->coef->add(tempmon.coef);
			if( it->coef->isZero() )
			{
				delete it->coef;
				glopoly.erase(it);
			}
			if( delCoef )
				delete tempmon.coef;
		}
	}
	//cout<<"insert: ";printmonomial(tempmon);cout<<" into: ";printpoly(glopoly);
}



/* copies monList and coef in "from" over to "to". "from" remains unchanged */
static void copyMonomial(monomial* to, monomial& from)
{
	to->monList = from.monList;
	to->coef = new AlphaPoly(from.coef);
}



/* multiplies "original" by "mult" and stores in "original". "mult remains unchanged 
 * Time critical function. Make sure it is optimized
 */
static void multiplyMonomial(monomial* original, monomial& mult)
{
	pair<set<unsigned int>::iterator, bool> ret;
	set<unsigned int>::iterator it;
	for( it = mult.monList.begin(); it != mult.monList.end(); it++ )
	{
		ret = original->monList.insert(*it);
		if( !(ret.second) ) // element already existed 
		{
			cout<<"Warning: Exponents not yet handled. Possible overlap detected for ";
			printmonomial(*original);
			cout<<" and ";
			printmonomial(mult);
			cout<<endl;
		}
	}

	if( !mult.coef->isOne() )
		original->coef->mult(mult.coef);
}



/* If div divides spec, creates result newmon (including new allocated AlphaPoly) and returns true
 * Otherwise returns false (no AlphaPoly allocated for newmon in this case)
 * Time critical function. Make sure it is optimized
 */
static bool tryMonDiv(monomial* newmon, monomial& spec, monomial& div )
{
	set<unsigned int>::iterator it1;
	set<unsigned int>::iterator it2;

	newmon->monList.clear();
	if( div.monList.size() > spec.monList.size() )
		return false;

	/*cout<<"Spec is ";
	printmonomial(spec);
	cout<<" and div is ";
	printmonomial(div);
	cout<<endl;*/
	
	for(it1=spec.monList.begin(),it2=div.monList.begin(); it1!=spec.monList.end() && it2!=div.monList.end(); it1++ )
	{
		if((*it1)>(*it2))
			return false;

		if((*it1)<(*it2))
			newmon->monList.insert(*it1);
		else
			it2++;
	}

	if( it2 != div.monList.end() )
		return false;

	while( it1!=spec.monList.end() )
	{
		newmon->monList.insert(*it1);
		it1++;
	}

	// If got here, monomials are divisible
    // Create AlphaPoly coefficient of spec/div = spec*inverse(div)
	if( div.coef->isOne() )
	{
		newmon->coef = new AlphaPoly(spec.coef);
	}
	else
	{
		if( div.coef->equals(spec.coef) )
		{
			newmon->coef = new AlphaPoly((unsigned long int) 0);
		}
		else
		{
			newmon->coef = div.coef->getInverse(); // Make sure this function is optimized!
			newmon->coef->mult(spec.coef);
		}
	}

	/*cout<<"Divided: ";
	printmonomial(*newmon);
	cout<<endl;*/

	return true;
}



/*
Purpose: r = specpoly / ideal 
specpoly is a given polynomial (or called specification polynomial)
ideal is a set of polynomials containing f1,f2,f3,...fn
------------------------------------------------------------
Basic procedure is:
1: get the leading monomials of specpoly, example: f=ab+ac+bc+d; lms(f)=ab+ac, not just "ab"!!! Differnt from traditional method.
2: get the leading monomial of f_i, because the property of circuit, leading monomial of f_i can only be single variable 
3: if the 1st variable of lms(f)== lm(f_i), then it implies divisiable. 
	Example: specpoly=ab+ac+bc+d, f1=a+c+d*e, 
			lms(specpoly)=ab+ac; lm(f1)=a; 1st var of lms(specpoy) is a==lm(f1), so dividable.
4: update specpoly: specpoly=specpoly-lms(specpoly)+(f_i-lm(f_i))*lms(specpoly)/lm(f_i)
5: go step 1 until all f_i are handled.
------------------------------------------------------------
The critical and most time-consuming step is Step 4, of which, there are 2 critical sub-steps:
1: (f_i-lm(f_i))*	lms(specpoly)/lm(f_i) 
2: addition between "specpoly-lms(specpoly)" and "(f_i-lm(f_i))*lms(specpoly)/lm(f1)"
The above step 1 takes about 90% running time and Step 2 only takes 10%.
So basically the problem now is how to efficiently compute polynomial multiplication?
Some attributes of these polynomials:
1) the two polynomials are sorted
2) In most time, one polynomial can be much longer the other one.
*/
//dd

double diffms1(0.0);
clock_t mbegin,mend;

double diffms2(0.0);
clock_t abegin,aend;

double diffms3(0.0);
clock_t fbegin,fend;

double diffms4(0.0);
clock_t t1begin,t1end;

double diffms5(0.0);
void reduce(list<monomial> & specpoly,vector< list<monomial> > &ideal )
{
  //mbegin = clock();

	int start = 0;
	monomial newMon;

	//tryMonDiv(&newMon, specpoly.front(), ideal[start].front());
	while(start<ideal.size() && specpoly.size() > 0 )
	{
		// If can be divided
		if( tryMonDiv(&newMon, specpoly.front(), ideal[start].front()) )
		{
		#ifdef DEBUG
			printpoly(specpoly);
			cout<<"IS DIVIDED BY"<<endl;
			printpoly(ideal[start]);
                #endif
			//cout<<"monom result ";
			//printmonomial(newMon);
			//cout<<endl;
		
			delete specpoly.front().coef;
			specpoly.pop_front();
			list<monomial>::iterator it;
			it = ideal[start].begin();
			it++; //skip lm(f). i.e now f-lm(f)
			// Multiply every monomial in (f-lm(f)) by newmon
			// Then, add it to the current specPoly
			for( it; it != ideal[start].end(); it++ )
			{
				monomial tmpMon;
			 	copyMonomial(&tmpMon, *it);
				multiplyMonomial(&tmpMon, newMon);
				insertmon2poly(specpoly,tmpMon);
			}
		#ifdef DEBUG
			cout<<"RESULT"<<endl;
			printpoly(specpoly);
			cout<<endl;
		#endif

			delete newMon.coef;
		}
		else
		{
		  /*#ifdef DEBUG
			printpoly(ideal[start]);
			cout<<"DOES NOT DIVIDE"<<endl;
			printpoly(specpoly);
			cout<<endl;
		  #endif*/
			start++;
		}
	}
	//printideal(ideal);

	//mend = std::clock();

	cout<<"FINAL RESULT: ";
	printpoly(specpoly);
	//cout<<"Reduce took "<<(mend-mbegin)/ (double)(CLOCKS_PER_SEC / 1000) << " ms"<<endl; 
}


/*insertion order, insert tempmon into poly
 * when inserting, from end to begin
 * tempmon no longer owns its coef after insert
 * */
void insertmon2poly(list<monomial>& tempoly, monomial & tempmon)
{
		//fbegin=clock();
		//sorting first

		// Lack of this constitutes a bug in Jinpeng's code!
		if( tempoly.size() == 0 )
		{
			tempoly.push_back(tempmon);
			return;
		}

		list<monomial>::iterator it; //about 5 times faster than reverse iterator.
		it=tempoly.end();
		int temp;
		--it;

		while(it!=tempoly.begin())
		{
			temp=CompareSet(tempmon.monList,it->monList);
			if( temp==1)//temp > it
			{
				tempoly.insert(++it,tempmon);
				//fend=clock();
				//diffms3+=((fend-fbegin)*1000);
				
				return;
			}
			else if(temp==-1)
			--it;
			else if (temp==0) //same, add then maybe delete
			{
				it->coef->add(tempmon.coef);
				if( it->coef->isZero() )
				{
					delete it->coef;
					tempoly.erase(it);
				}
				delete tempmon.coef;
				
				//fend=clock();
				//diffms3+=((fend-fbegin)*1000);
				
				return;
			}
			
		}
		temp=CompareSet(tempmon.monList,it->monList);
		if( temp==1)//temp > it
		{
			tempoly.insert(++it,tempmon);
		}
		else if(temp==-1)
			tempoly.push_front(tempmon);
		else if (temp==0) //same, delete
		{
			it->coef->add(tempmon.coef);
			if( it->coef->isZero() )
			{
				delete it->coef;
				tempoly.erase(it);
			}
			delete tempmon.coef;
		}
		//fend=clock();
		//diffms3+=((fend-fbegin)*1000);	
		
}

/*merge sort of two sorted polys*/
void mergesort(list<monomial>& specpoly, list<monomial>& tempoly)
{
		/*
		 * addition between "specpoly-lms(specpoly)" and "(f_i-lm(f_i))*lms(specpoly)/lm(f1)"
		 * "specpoly-lms(specpoly)" is stored in specpoly which has been sorted
		 * "(f_i-lm(f_i))*lms(specpoly)/lm(f1)" is stored in tempoly which has been sorted
		 * Implemented as a merge sort
		 */
		
		list<monomial>::iterator tempit;
		list<monomial>::iterator specit;
		list<monomial>::iterator pre_specit;
		int res;
		
		tempit=tempoly.begin();
		specit=specpoly.begin();
			
		while( (tempit!=tempoly.end()) || (specit!=specpoly.end()) )
		{/*since specpoly is usually much longer than tempoly, we choose a different version of merge sort. different from CLRS book.*/
			if( (tempit!=tempoly.end()) && (specit!=specpoly.end()) )
			{	
				res=CompareSet(tempit->monList, specit->monList);
				if( res==1)//temp > spec
				{
					//newspecpoly.push_back(*specit);
					//cout<<"temp>spec: ";printpoly(newspecpoly);
					++specit;
				}
				else if(res==-1) //temp < spec
				{
					specpoly.insert(specit,*tempit);
					//newspecpoly.push_back(*tempit);
					//cout<<"temp<spec: ";printpoly(newspecpoly);
					++tempit;
				}
				else if (res==0) //temp =spec, add or delete
				{
						//cout<<"temp=spec: ";printpoly(newspecpoly);
						specit->coef->add(tempit->coef);
						++tempit;
						if( specit->coef->isZero() )
						{
							pre_specit=specit;
							++specit;
						
							specpoly.erase(pre_specit);
						}
						//if( (tempit==tempoly.end()) && (specit==specpoly.end()))
						//{
							//specpoly.clear();
							//specpoly.insert(specpoly.end(),newspecpoly.begin(),newspecpoly.end());
						//	break;
						//}
					}
				}
				else if(tempit==tempoly.end())//most possible case
				{
					//specpoly.erase(specpoly.begin(),specit);
					//specpoly.insert(specit,newspecpoly.begin(),newspecpoly.end());
					break;
				}
				else if(specit==specpoly.end())//less possible
				{
					//specpoly.clear();
					//specpoly.insert(specpoly.end(),tempit,tempoly.end());
					specpoly.splice(specpoly.end(),tempoly,tempit,tempoly.end());
					//specpoly.insert(specpoly.end(),tempit,tempoly.end());
					break;
				}
				
			}
					
}

/*clear global variables*/
void clear()
{	//begin=clock();
	tempmon.monList.clear();
	glopoly.clear();
	specpoly.clear();
	ideal.clear();
	VID.clear();
	ind=2;		
//	end=clock();
	//double diffms2=((end-begin)*1000)/CLOCKS_PER_SEC;	
//	cout<<"clear takes "<<diffms2<<" ms"<<endl;
}
/********************************************/

void printmonomial(monomial & toprint)
{
	if(toprint.monList.size()==0)
	{
		cout<<toprint.coef->toString()<<endl;
		return;
	}

	if( !toprint.coef->isOne() )
		cout<<"("<<toprint.coef->toString()<<")*";

	set<unsigned int>::iterator it;
	set<unsigned int>::iterator endit;

	endit=--toprint.monList.end();
	for(it=toprint.monList.begin();it!=endit;++it)
	{
		cout<<DIV[*it]<<"*";
	}

	cout<<DIV[*it];
	
}

void printpoly(list<monomial> &toprint)
{
	if(toprint.size()==0)
	{
		cout<<"0"<<endl;
		return;
	}
	list<monomial>::iterator it;
	list<monomial>::iterator endit;
	endit=--toprint.end();
	for(it=toprint.begin();it!=endit;++it)
	{
		printmonomial(*it);
		cout<<"+";
	}
	printmonomial(*it);
	cout<<endl;
}

void printideal(vector< list<monomial> > &toprint)
{
	if(toprint.size()==0)
	{
		cout<<"0"<<endl;
		return;
	}	
	vector< list<monomial> >::iterator it;
	for(it=toprint.begin();it!=toprint.end();++it)
	{
		printpoly(*it);
		cout<<endl;
	}
}

void printmap()
{
	map<string, unsigned int>::iterator it;
	for(it=VID.begin();it!=VID.end();++it)
	cout<<it->first<<"-->"<<it->second<<endl;
}

